#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include <exec/exec.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <graphics/gfx.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>

#include <PowerUP/PPCLib/Interface.h>
#include <PowerUP/PPCLib/tasks.h>
#include <PowerUP/PPCLib/ppc.h>
#include <PowerUP/PPCLib/object.h>
#include <PowerUP/clib/ppc_protos.h>
#include <PowerUP/pragmas/ppc_pragmas.h>

struct symbol_node {
  struct symbol_node *left;
  struct symbol_node *right;
  ULONG addr;
  ULONG size;
  char *name;
  ULONG count;
};

struct StartupData
{
  void *M68kPort;  /* the PowerPC task can send messages to this port */
  BPTR std_in;     /* standard input handle */
  BPTR std_out;    /* standard output handle */
  BPTR std_err;    /* standard error handle */
  LONG ReturnCode; /* here we will find the return code from the PPC task */
  ULONG Flags;     /* additional flags (currently unused) */
};

#define STARTUPF_ELFLOADSEG	0x1
#define MSGID_EXIT 0x44584954

struct Library *PPCLibBase = NULL;
static void *object = NULL;
static struct Hook scan_symbol_hook, exception_hook;
static struct symbol_node *symbol_root = NULL;
static struct Task *m68ktask;
static void *M68kPort = NULL;
static void *startup_msg = NULL;
static struct StartupData *startup_data = NULL;
static BOOL task_is_finished = FALSE;
static ULONG pc = 0;

static char *StateString[] = {
  "Invalid",
  "Added  ",
  "Run    ",
  "Ready  ",
  "Wait   ",
  "-------",
  "Removed"
};

/**********************************************************************/
void fatal (char *error, ...)
{
  va_list argptr;

  fprintf (stderr, "Fatal error: ");
  va_start (argptr,error);
  vfprintf (stderr, error, argptr);
  va_end (argptr);
  fprintf (stderr, "\n");

  exit (20);
}

/****************************************************************************/
static struct symbol_node *insert_info (struct symbol_node **p,
                                        struct PPCObjectInfo *info)
{
  if (*p == NULL) {
    if ((*p = (struct symbol_node *)malloc (sizeof(struct symbol_node))) == NULL)
      fatal ("Out of memory!\n");
    (*p)->left = NULL;
    (*p)->right = NULL;
    (*p)->addr = info->Address;
    (*p)->size = info->Size;
    if (((*p)->name = (char *)malloc(strlen(info->Name) + 1)) == NULL)
      fatal ("Out of memory!\n");
    strcpy ((*p)->name, info->Name);
    (*p)->count = 0;
    return (*p);
  } else {
    if (info->Address < (*p)->addr)
      return (insert_info (&(*p)->left, info));
    else if (info->Address > (*p)->addr)
      return (insert_info (&(*p)->right, info));
    else {
//      printf ("%s and %s are coincident at %08x, sizes %d and %d\n",
//              (*p)->name, info->Name, (*p)->addr, (*p)->size, info->Size);
      if ((*p)->size < info->Size)
        (*p)->size = info->Size;
      return (*p);
    }
  }
}

/****************************************************************************/
static void fill_gaps (struct symbol_node *p)
{
  static struct symbol_node *prev_node = NULL;
  static struct PPCObjectInfo info;
  static char name[1024];

  if (p != NULL) {
    fill_gaps (p->left);
    if (prev_node != NULL) {
      if (prev_node->addr + prev_node->size < p->addr) {
        sprintf (name, "between %s and %s", prev_node->name, p->name);
        info.Name = name;
        info.Address = prev_node->addr + prev_node->size;
        info.Size = p->addr - info.Address;
        insert_info (&symbol_root, &info);
      } else if (prev_node->addr + prev_node->size > p->addr) {
        printf ("%s and %s overlap\n", prev_node->name, p->name);
        prev_node->size = p->addr - prev_node->addr;
      }
    }
    prev_node = p;
    fill_gaps (p->right);
  }
}

/****************************************************************************/
static struct symbol_node *lookup_info (struct symbol_node *p, ULONG addr)
{
  if (p == NULL)
    return NULL;
  else if (addr >= p->addr && addr < p->addr + p->size)
    return p;
  else if (addr < p->addr)
    return (lookup_info (p->left, addr));
  else
    return (lookup_info (p->right, addr));
}

/****************************************************************************/
static void print_tree (struct symbol_node *p)
{
  if (p != NULL) {
    print_tree (p->left);
    if (p->count > 0)
      printf ("0x%08lx\t0x%08lx\t%d\t%s\n", p->addr, p->size, p->count, p->name);
    print_tree (p->right);
  }
}

/****************************************************************************/
static void free_tree (struct symbol_node *p)
{
  if (p != NULL) {
    free_tree (p->left);
    free_tree (p->right);
    if (p->name != NULL)
      free (p->name);
    free ((char *)p);
  }
}

/****************************************************************************/
BOOL __asm __saveds ExceptionHookFunc (register __a0 struct Hook *exception_hook,
                                       register __a2 void *task,
                                       register __a1 struct ExceptionMsg *msg)
{
  if (msg->Type & EXCEPTION_MSG) {
    if (msg->Type == EXCEPTION_FINISHTASK)
      task_is_finished = TRUE;
    else if (msg->Type == EXCEPTION_STOPTASK) {
      pc = msg->SRR0;
      Signal (m68ktask, SIGBREAKF_CTRL_F);
    }
    return TRUE;
  }
  return FALSE;
}

/**********************************************************************/
static void __asm __saveds ScanHookFunc (register __a0 struct Hook *exception_hook,
                                         register __a2 void *elf_struct,
                                         register __a1 struct PPCObjectInfo *info)
{
  if (info->Address != 0 && info->Size != 0 && strlen(info->Name) != 0)
    insert_info (&symbol_root, info);
//  printf ("0x%08lx\t0x%08lx\t%s\n", info->Address, info->Size,
//          info->Name);
}

/**********************************************************************/
void _STD_cleanup (void)
{
  if (startup_data != NULL) {
    PPCFreeVec (startup_data);
    startup_data = NULL;
  }
  if (startup_msg != NULL) {
    PPCDeleteMessage (startup_msg);
    startup_msg = NULL;
  }
  if (M68kPort != NULL) {
    PPCDeletePort (M68kPort);
    M68kPort = NULL;
  }
  free_tree (symbol_root);
  if (object != NULL) {
    PPCUnLoadObject (object);
    object = NULL;
  }
  if (PPCLibBase != NULL) {
    CloseLibrary (PPCLibBase);
    PPCLibBase = NULL;
  }
}

/**********************************************************************/
int main (int argc, char *argv[])
{
  struct TagItem tags[22];
  struct PPCObjectInfo info;
  struct symbol_node *node;
  BOOL ctrl_c_check;
  int count, out_of_range_count, state_count[7], other_state_count, i;
  ULONG Result, sig, state;
  void *ppctask;
  char *name;
  static char args[1024];

  if (argc < 2) {
    printf ("Usage: ProfilePPC <elf-prog> <args>...\n");
    exit (10);
  }

  m68ktask = FindTask (NULL);

  if ((PPCLibBase = OpenLibrary ("ppc.library", 0)) == NULL)
    fatal ("Can't open ppc.library");

  if ((object = PPCLoadObject (argv[1])) == NULL)
    fatal ("Can't load ELF object %s", argv[1]);

  scan_symbol_hook.h_Entry = (ULONG (*)(void)) ScanHookFunc;
  scan_symbol_hook.h_SubEntry = (ULONG (*)(void)) NULL;
  scan_symbol_hook.h_Data = (APTR) PPCLibBase;

  tags[0].ti_Tag = PPCELFINFOTAG_SCANSYMBOLHOOK;
  tags[0].ti_Data = (ULONG) &scan_symbol_hook;
  tags[1].ti_Tag = TAG_END;
  Result = PPCGetObjectAttrs (NULL /*object*/, &info, tags);
  printf ("PPCGetObjectAttrs Result = %d\n", Result);

  fill_gaps (symbol_root);

  info.Address = NULL;
  info.Name = "_ixbaseobj";
  tags[0].ti_Tag = TAG_END;
  if (PPCGetObjectAttrs (object, &info, tags))
    ctrl_c_check = FALSE;
  else
    ctrl_c_check = TRUE;

  tags[0].ti_Tag = TAG_END;
  if ((M68kPort = PPCCreatePort (tags)) == NULL)
    fatal ("PPCCreatePortTags() failed");

  if ((startup_msg = PPCCreateMessage (M68kPort, sizeof(struct StartupData)))
                                                                        == NULL)
    fatal ("PPCCreateMessage() failed");

  if ((startup_data = (struct StartupData *)PPCAllocVec (
                        sizeof(struct StartupData), MEMF_CLEAR | MEMF_PUBLIC))
                                                                        == NULL)
    fatal ("PPCAllocVec() failed");

  args[0] = '\0';
  for (i = 1; i < argc; i++) {
    strcat (args, " ");
    strcat (args, argv[i]);
  }
  startup_data->M68kPort = M68kPort;
  startup_data->std_in = Input ();
  startup_data->std_out = Output ();
  startup_data->std_err = ((struct Process *)m68ktask)->pr_CES;
  startup_data->Flags = STARTUPF_ELFLOADSEG;

  exception_hook.h_Entry = (ULONG (*)(void))ExceptionHookFunc;
  exception_hook.h_SubEntry = (ULONG (*)(void))NULL;
  exception_hook.h_Data = (APTR)PPCLibBase;

  tags[0].ti_Tag = PPCTASKTAG_WAITFINISH;
  tags[0].ti_Data = FALSE;
  tags[1].ti_Tag = PPCTASKTAG_INPUTHANDLE;
  tags[1].ti_Data = (ULONG) Input ();
  tags[2].ti_Tag = PPCTASKTAG_OUTPUTHANDLE;
  tags[2].ti_Data = (ULONG) Output ();
  tags[3].ti_Tag = NP_CloseInput;
  tags[3].ti_Data = FALSE;
  tags[4].ti_Tag = NP_CloseOutput;
  tags[4].ti_Data = FALSE;
  tags[5].ti_Tag = NP_Cli;
  tags[5].ti_Data = TRUE;
  tags[6].ti_Tag = PPCTASKTAG_BREAKSIGNAL;
  tags[6].ti_Data = ctrl_c_check;
  tags[7].ti_Tag = PPCTASKTAG_ARG1;
  tags[7].ti_Data = (ULONG)args;
  tags[8].ti_Tag = NP_Name;
  tags[8].ti_Data = (ULONG)argv[1],
  tags[9].ti_Tag = NP_CommandName;
  tags[9].ti_Data = (ULONG)argv[1],
  tags[10].ti_Tag = PPCTASKTAG_STACKSIZE;
  tags[10].ti_Data = 500000;
  tags[11].ti_Tag = NP_StackSize;
  tags[11].ti_Data = 4096;
  tags[12].ti_Tag = PPCTASKTAG_STARTUP_MSG;
  tags[12].ti_Data =(ULONG)startup_msg;
  tags[13].ti_Tag = PPCTASKTAG_STARTUP_MSGDATA;
  tags[13].ti_Data =(ULONG)startup_data;
  tags[14].ti_Tag = PPCTASKTAG_STARTUP_MSGLENGTH;
  tags[14].ti_Data = sizeof(struct StartupData);
  tags[15].ti_Tag = PPCTASKTAG_STARTUP_MSGID;
  tags[15].ti_Data = MSGID_EXIT;
  tags[16].ti_Tag = PPCTASKTAG_EXCEPTIONHOOK;
  tags[16].ti_Data = (ULONG)&exception_hook;
  tags[17].ti_Tag = TAG_END;

  ppctask = PPCCreateTask (object, &tags[0]);
  printf ("PPCCreateTask ppctask = %d\n", ppctask);

//  Delay (50);

  count = 0;
  out_of_range_count = 0;
  other_state_count = 0;
  for (state = TS_INVALID; state <= TS_REMOVED; state++)
    state_count[state] = 0;
  while (PPCGetMessage (M68kPort) == NULL && !task_is_finished) {
    state = PPCGetTaskAttrsTags (ppctask, PPCTASKINFOTAG_STATE, &state, TAG_END);
    switch (state) {
      case TS_INVALID:
        break;
      case TS_ADDED:
        break;
      case TS_RUN:
        tags[0].ti_Tag = TAG_END;
        if (PPCStopTask (ppctask, &tags[0])) {  /* causes an exception */
          /* wait for CTRL_F signal from exception handler */
          sig = Wait (SIGBREAKF_CTRL_F | SIGBREAKF_CTRL_C);
          if (sig & SIGBREAKF_CTRL_C)
            break;
          tags[0].ti_Tag = PPCTASKSTARTTAG_RUN;
          tags[0].ti_Data = TRUE;
          tags[1].ti_Tag = TAG_END;
          PPCStartTask (ppctask, &tags[0]);
        }
        break;
      case TS_READY:
        break;
      case TS_WAIT:
        PPCGetTaskAttrsTags (ppctask, PPCTASKINFOTAG_LR, &pc,
                                      PPCTASKINFOTAG_VALUEPTR, &pc, TAG_END);
        break;
      case TS_EXCEPT:
        break;
      case TS_REMOVED:
        break;
      default:
        break;
    }
    count++;
    if (state <= TS_REMOVED)
      state_count[state]++;
    else
      other_state_count++;
    if ((node = lookup_info (symbol_root, pc)) != NULL) {
      node->count++;
      name = node->name;
    } else {
      out_of_range_count++;
      name = "out of range";
    }
//      printf ("pc = %08x, %s\n", pc, name);
//    }
    Delay (20);  /* or WaitTOF() */
  }

  printf ("\nAddress\t\tSize\t\tCount\tName\n");
  print_tree (symbol_root);

  for (state = TS_INVALID; state <= TS_REMOVED; state++)
    printf ("%s state count = %d\n", StateString[state], state_count[state]);
  printf ("other state count   = %d\n", other_state_count);
  printf ("out of range count  = %d\n", out_of_range_count);
  printf ("total count         = %d\n", count);

  return 0;
}

/**********************************************************************/
