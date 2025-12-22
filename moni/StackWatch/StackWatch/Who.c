/* ROOM TO GROW:   Attempt to see what processes are waiting for?  (node->
   pr_Task.tc_SigWait?)  Workbench version paginate?  Always paginate?
   Display the mort field?  It's just the ID plus sizeof(struct Task), which
   is 92 decimal or 5c hex.
 */

/*
 * WHO
 * by George Musser Jr.
 * 16 November 1986
 *
 * 21 January 1987 - added task id, CLI process numbers
 *
 * Lists tasks on the Ready and Wait queues.
 *
 */


/* ============================================================================
   Modified by Paul Kienitz 10/88 for prettier sorted output, Cli command name,
   other additional useful data, and single Disable/Enable snapshot.  Manxed
   for smallness (should still be Lattice compatible), no more large arrays on
   stack.  It crashed sometimes before. Also workbench runnable with
   "WINDOW=CON:0/nn/640/nnn/Press any key to exit" tooltype in the icon, but
   it's not really a workbench program.
   -- 12/88 added Cli script file name, improved "for" display, added crude
   unit number detection for some driver tasks, flag for Cli interactiveness.
   -- 2/9/89 discovered that trackdisk.device plugs the task MsgPort pointer
   directly into the io_Unit field, instead of in the first field of the struct
   Unit (or struct TDU_PublicUnit?) that's supposed to be pointed to by that.
   Reduced Disabled time with tap array.  Decided that trying to find unit
   numbers for any device other than trackdisk is too dangerous, as well as
   unlikely to accomplish anything, since you have no way of knowing what
   some chumps will put in the io_Unit field.
   -- 4/13/89 removed limit of at most 99 tasks displayed, made sorting by
   name use cli command name instead of task name when present, fixed failure
   to handle out-of-memory condition.
   -- 4/14/89 made it create standard 640×200 window under Workbench without
   consulting any tooltypes -- this makes it start faster.
 */


#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/ports.h>
#include <exec/devices.h>
#include <exec/execbase.h>
#include <devices/trackdisk.h>
#include <libraries/dosextens.h>
#include <libraries/filehandler.h>
#ifdef AZTEC_C
#include <functions.h>
#endif

#define Maxks    999   /* Maximum handleable number of tasks */
#define NAME_LEN  40   /* Number of characters in task names */
#define CLIp      40   /* Length to truncate Cli command strings to */
#define dimwit    30   /* how many devices we can recognize */

#define min(a,b) (a > b ? b : a)
#define bip(T, B) ((T *) (B << 2))
#define gbip(B) bip(void, B)

extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;

extern int Enable_Abort;

char *strncpy();
void *malloc();

/* lame excess incomplete Unix compatible Manx 3.4a bullshit */
char *hex6(), *hex8();
/* even lamer English weenie-ism */
void Beast();

typedef struct Task *task;
typedef struct Process *process;
typedef struct MsgPort *port;

typedef struct {
   task id;			/* struct Task address */
   task stout;			/* standard output handler process */
   port mort;			/* message port address (for processes) */
   short pri, clinum, nype;	/* priority, Cli number, strange node type */
   BOOL dosproc, foreskin;	/* it's a process, it's an interactive Cli */
   char name[NAME_LEN],		/* task name */
      command[CLIp],		/* Cli command string (truncated) */
      xeq[CLIp];		/* Execute source file name (truncated) */
} vitals;
typedef vitals *vitalp;

typedef struct {
   char dame[31];		/* name of device (e.g. DF1) */
   char drivel[31];		/* name of device driver (e.g trackdisk.device) */
   task hand;			/* id of dos handler process */
} dist;
typedef dist *dip;


task     tap[Maxks];		/* all the task pointers from the lists */
vitalp   tasx;			/* all the data on those tasks */



main(argc) int argc;
{
   short reds, weights;         /* how many ready, how many waiting */
   dip devz[dimwit];            /* data on devices */
   short numbed;                /* how many devices in devz */
   process me;
   void PrintList(), DigestList();
   int rank();
   short EatList(), EatDevices();

   Forbid();
   numbed = EatDevices(devz);
   Disable();  /* Here we mustn't let the list get reordered */
   reds = EatList (&SysBase->TaskReady, tap, Maxks);
   weights = EatList (&SysBase->TaskWait, tap + reds, Maxks - reds);
   /* running tasks have dibs on array slots; waiting tasks have to sit in the
      back of the bus */
   Enable();
   /* That was probably longer than 250 microseconds, but I've disabled for
      several seconds at a time with no harm, even during disk activity */
   /* Here it's okay if they're reordered, just make sure none of them exit */
   if (!(tasx = malloc((reds + weights) * sizeof(vitals)))) {
      Permit();
      printf("\nGaaah!  Insufficient memory!\n");
      exit(10);
   }
   DigestList(tap, reds, tasx);
   DigestList(tap + reds, weights, tasx + reds);
   Permit();

   qsort(tasx + reds, weights, sizeof(vitals), rank);
   PrintList(tasx + reds, weights, "Waiting", -reds, devz, numbed);
   qsort(tasx, reds, sizeof(vitals), rank);
   PrintList(tasx, reds, "Ready to run", weights, devz, numbed);

   me = (process) FindTask(0L);
   printf("Running: this WHO process ");
   if (me->pr_TaskNum) printf("(CLI %ld) ", me->pr_TaskNum);
   printf("is id %s, priority %d.",
          hex6(me), (int) me->pr_Task.tc_Node.ln_Pri);
   if (!argc) {
       printf("   ");
       set_raw();
       getchar();     /* wait for keystroke if workbench */
   }
   else putchar('\n');
}



short EatDevices(devz) dip devz[dimwit];
{  short numbed = 0;
   struct FileSysStartupMsg *fart;
   struct DeviceNode *devlist = bip(struct DeviceNode, bip(struct DosInfo,
				     ((struct RootNode *) DOSBase->dl_Root)
				   ->rn_Info)->di_DevInfo);
   for ( ; devlist ; devlist = gbip(devlist->dn_Next)) {
      if (!devlist->dn_Type) {
         if (!(devz[numbed] = malloc(sizeof(dist)))) return (numbed - 1);
         Beast(devlist->dn_Name, devz[numbed]->dame, 30);
	 if (devlist->dn_Task)
	    devz[numbed]->hand = devlist->dn_Task->mp_SigTask;
	 else
	    devz[numbed]->hand = NULL;
	 if (devz[numbed]->hand && (fart = gbip(devlist->dn_Startup)))
	    Beast(fart->fssm_Device, devz[numbed]->drivel, 30);
	 else
	    devz[numbed]->drivel[0] = '\0';
	 if (++numbed >= dimwit) break;
      }
   }
   return (numbed);
}



short EatList(header, tap, limit)
struct List *header; task tap[]; short limit;
{
   struct Node *node;
   short i;

   if (limit < 0) limit = 0;
   for (node = header->lh_Head, i = 0;
	      node->ln_Succ && i < limit;
	      node = node->ln_Succ, i++)
      tap[i] = (task) node;
   return (i);
}



void DigestList(tap, count, ray) task tap[]; short count; vitalp ray;
{
   short i;
   struct Node *node;
   process pode;
   struct FileHandle *ss;
   port sss;
   struct CommandLineInterface *kwy;
   BPTR mandy;
   vitalp this;

   for (i = 0; i < count; i++) {
      node = (struct Node *) tap[i];
      this = ray + i;
      this->nype = node->ln_Type;
      strncpy (this->name, node->ln_Name, NAME_LEN);
      this->id = (task) node;
      this->pri = node->ln_Pri;
      if (this->dosproc = node->ln_Type == NT_PROCESS) {
         pode = (process) node;
	 this->mort = &pode->pr_MsgPort;
         if (this->clinum = (short) (pode->pr_TaskNum)) {
	    kwy = gbip(pode->pr_CLI);
	    mandy = kwy->cli_CommandName;
	    /* The only thing in the universe that's stupider than a BPTR is a
	       BSTR.  Why should a *string* pointer to be longword aligned??? */
            Beast(mandy, this->command, CLIp);
	    this->foreskin = kwy->cli_Interactive;
	    mandy = kwy->cli_CommandFile;
	    if (mandy) Beast(mandy, this->xeq, CLIp);
	    else this->xeq[0] = '\0';
	 }
	 ss = bip(struct FileHandle, pode->pr_COS);
	 sss = ((long) ss ? ss->fh_Type : (port) NULL);
	 this->stout = ((long) sss ? sss->mp_SigTask : (task) NULL);
      } else {
         this->clinum = 0;
	 this->stout = NULL;
	 this->mort = NULL;
      }
   }
}



void Beast(from, to, limit) BPTR from; char *to; short limit;
{
   int j;
   char *fro = gbip(from);
   j = min(fro[0], limit);
   strncpy(to, fro + 1, j);
   to[j] = '\0';
}



/*
 * PrintList()
 *
 * Prints the names, pointers, priorities, and types of items in a list.
 *
 */

void PrintList(list, count, label, stench, devz, numbed)
vitalp list; char *label; dip devz[]; short count, stench, numbed;
{
   short j, k, lo, hi;
   char *lab;
   task mycon = bip(struct FileHandle, (BPTR) Output())->fh_Type->mp_SigTask;
   vitalp this;
   struct IOExtTD quest;
   task trask[4];

   setmem(&quest, sizeof(struct IOExtTD), 0);
   for (j = 0; j < 4; j++)
      if (!OpenDevice(TD_NAME, (long) j, &quest, 0L)) {
	 trask[j] = ((port) quest.iotd_Req.io_Unit)->mp_SigTask;
	 CloseDevice(&quest);
      } else trask[j] = NULL;
   if (!count) printf("%s:  none.\n", label);
   else printf ("%s:\n", label);
   for (j = 0; j < count; j++) {
      this = list + j;
      if (this->dosproc)
         if (this->clinum)
	    printf("CLI %d%c%c ", this->clinum,
	           (this->foreskin ? '>' : ' '),
		   (this->clinum < 10 ? ' ' : '\0'));
	 else printf("Process ");
      else printf(" task   ");
      printf ("ID %s, pri%4d, ", hex6(this->id), this->pri);
      if (this->clinum)
         if (this->command[0]) {
	    printf("cmd. \"%s\"", this->command);
	    if (this->xeq[0]) printf(" script \"%s\"", this->xeq);
	 } else
	    printf("(no command)");
      else
	 printf("name \"%s\"", this->name);
      lab = "for";
      for (k = 0; k < numbed; k++)
         if (this->id == devz[k]->hand) {
	    printf(" %s %s:", lab, devz[k]->dame);
	    lab = "&";
	 }
      if (this->id == mycon) {
         printf(" %s this output", lab);
	 lab = "&";
      }
      for (k = 0; k < 4; k++)
	 if (this->id == trask[k])
            printf(" unit %d", k);
      lo = 0; hi = count;	/* look in both parts of the array */
      if (stench < 0) lo = stench; else hi += stench;
      for (k = lo; k < hi; k++)
         if (list[k].stout == this->id) {
	    if (list[k].clinum) printf(" %s CLI %d", lab, list[k].clinum);
	    else printf(" %s ID %s", lab, hex6(list[k].id));
	    lab = "&";
	 }
      if (this->nype != NT_TASK & this->nype != NT_PROCESS)
	 printf(" NODE TYPE %d", this->nype);   /* example:  PerfMon */
      putchar('\n');
   }
}



int rank(a, b) vitalp a, b;		/* called by qsort */
{
   int tp = a->dosproc - b->dosproc;
   int pr = b->pri - a->pri;
   char *na = a->name, *nb = b->name;
   char ca, cb;
   if (tp) return (tp);
   if (pr) return (pr);
   if (a->clinum) na = a->command;
   if (b->clinum) nb = b->command;
   for (ca = toupper(*na), cb = toupper(*nb); ca && ca == cb;
              ca = toupper(*++na), cb = toupper(*++nb)) ;
   return (ca - cb);
}



char *hex8(l) unsigned long l;  /* convert long to UPPERCASE hexadecimal */
{
   static char result[9];
   int hid, nyb;
   for (hid = 0; hid <= 7; hid++) {
      nyb = (l >> (4*hid)) & 15L;
      result[7 - hid] = (nyb >= 10 ? (char) nyb + 'A' - 10 : (char) nyb + '0');
   }
   for (hid = 0; hid <= 7; hid++)
      if (result[hid] == '0') result[hid] = ' ';
      else break;
   result[8] = '\0';
   return (result);
}



char *hex6(l) unsigned long l;  /* for 24 bit addresses */
{  return (hex8(l) + 2); }



#ifdef AZTEC_C

extern int _argc;
void _cli_parse()
{  _argc = 1; }		/* don't bother to parse arguments */

void _wb_parse(me) struct Process *me;  /* don't bother with ToolType */
{
   BPTR wind = Open("CON:0/0/640/200/ Who - press any key to clear ",
		    MODE_OLDFILE);
   if (!wind) exit(10);
   me->pr_ConsoleTask = (adr) bip(struct FileHandle, wind)->fh_Type;
   me->pr_CIS = wind;
   me->pr_COS = Open("*", MODE_OLDFILE);
}

#endif

