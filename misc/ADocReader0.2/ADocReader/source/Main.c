/*******************************************************************/
/*                                                                 */
/* ADocReader V0.2 (April 22 1996)                                 */
/*                                                                 */
/* Description:                                                    */
/*   This is an AutoDoc Reader that uses MUI 3.3                   */
/*                                                                 */
/* Legal:                                                          */
/*   This program is PUBLIC DOMAIN, you may use it and modify it   */
/*   and publish it if you give a reference to me, the             */
/*                                                                 */
/* Author:                                                         */
/*   Gilles MASSON                                                 */
/*   12 bis boulevard de MONTREAL                                  */
/*   06200 NICE / FRANCE                                           */
/*   masson@alto.unice.fr / masson@ogpsrv.unice.fr                 */
/*                                                                 */
/* Based on 'Martins Reader' from:                                 */
/*   Dirk Holtwick                                                 */
/*   Karlstr 59                                                    */
/*   47119 Duisburg /GERMANY                                       */
/*   dirco@uni-duisburg.de                                         */
/*                                                                 */
/*******************************************************************/
/* Compiled with GCC */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <dos/dos.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/io.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <libraries/gadtools.h>
#include <libraries/asl.h>
#include <libraries/mui.h>
#include <devices/clipboard.h>
#include <workbench/workbench.h>
#include <intuition/intuition.h>
#include <intuition/classusr.h>

#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/gadtools.h>
#include <proto/asl.h>

#include <clib/muimaster_protos.h>

#include "Main.h"
#include "mui_obj.h"

#include "DXListClass.h"

#include "cb.h"

#include "xref_gen.h"
#include "xref_make.h"
#include "xref_read.h"


#include <proto/muimaster.h>


static VOID fail(APTR APP_Main,char *str);
static VOID init(VOID);
void PrintError(char *str,...);
void PrintInfo(char *str,...);
static void AppInfo(void);
static void HelpInfo(void);
static void UnLoadxref(void);
static void Makexref(void);
static void Loadxref(void);
static void FindXRef(void);
static void PR_TextChange(void);
static void PR_TextSet(void);
static void DisplayLI_Text(void);
static void DisplayXRef(void);
static void DisplayHist(void);
static void addhist(struct XRefNode *xrefnode);
static void restarthistory(void);
static void HistFound(void);
static void FreeIndex(void);
static void DisplayCap(void);
static void addindex(char *name, char **text_array);
static void XRefFound(void);
static void CapFound(void);
static void LoadText(char *name, LONG len, long pos);
static void DirFound(void);
static void ChangeDir(char *file_name);
static void PrintSelect(void);
static void CopyClip(void);
static void ConfigWinOpen(void);
static void WinXRefSearchOpen(void);
static void WFindWinOpen(void);
static BOOL IsPartOfCase(char *findin,char *tofind,int tofindlen);
static BOOL IsPartOfNoCase(char *findin,char *tofind,int tofindlen);
static void WFindString(int incvalue,int firstlast);
static void WFindStringFirst(void);
static void WFindStringPrec(void);
static void WFindStringNext(void);
static void WFindStringLast(void);
static void WFindStringIncr(void);
static void XRefSearchStr(void);
static void XRefSearchStrIncr(void);
static void DirGoUp(void);
static void DirGoDown(void);
static void DirGoPageUp(void);
static void DirGoPageDown(void);
static void DirGoUp2(void);
static void DirGoDown2(void);
static void DirGoPageUp2(void);
static void DirGoPageDown2(void);
static void CapGoUp(void);
static void CapGoDown(void);
static void CapGoPageUp(void);
static void CapGoPageDown(void);
static void TextGoUp(void);
static void TextGoDown(void);
static void TextGoPageUp(void);
static void TextGoPageDown(void);
static void StartState(void);
int main(int argc,char *argv[]);
static void SearchXRef(void);
static int WriteClip(char *string);
static void WinErrorsClose(void);
static void WinInfosClose(void);
static void FreeCurrentDrawerList(void);
static void LoadCurrentDrawerList(void);

/* MUI STUFF */

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#define TOC "TABLE OF CONTENTS"

#ifndef SAVEDS
#define SAVEDS
#endif

struct Library *MUIMasterBase;

/*LONG __stack = 30000;*/

static const struct Hook SearchXRefHook    = { { NULL,NULL },(VOID *)SearchXRef, NULL,NULL };

/* INDEX STRUCTURE */
struct IndexData
{
  struct IndexData *succ;
  char  name[80];
  char  **text_array;
} *IndexBase = NULL, *IndexLast = NULL;

/* MUI OBJECTS */


#define DATA_STRING_MAX 160

char FindWord[DATA_STRING_MAX];
char DisplayString[DATA_STRING_MAX];
char DisplayString2[DATA_STRING_MAX];

char *StartFileName = NULL;
char *StartDirName = NULL;
char NothingName[] = "Nothing.";

struct XRefNode XRefStart = {  NULL,  0,  0, "" };

char DirPatternToken[20];

APTR  APP_Main,
      WIN_Main,
      LV_Dir,
      LV_Hist,
      LV_Cap,
      LI_Text,
      PR_Text,
      MN_Strip,
      STR_DefaultDrawer,
      STR_CurrentDrawer,
      LI_CurrentDrawer,
      WIN_WFind,
      STR_WFind,
      WIN_XRefSearch,
      STR_XRefSearch,
      CK_XS_Case,
      CK_XS_Incr,
      CK_XS_PartOf,
      LV_XRefSearch,
      CK_WF_Case,
      CK_WF_Incr,
      BT_WF_First,
      BT_WF_Prec,
      BT_WF_Next,
      BT_WF_Last,
      CY_FindType,
      WIN_Config,
      STR_ADocDrawer1,
      STR_ADocDrawer2,
      STR_ADocDrawer3,
      STR_ADocDrawer4,
      STR_IncDrawer1,
      STR_IncDrawer2,
      STR_IncDrawer3,
      STR_IncDrawer4,
      STR_XRefFile,
      STR_ADocFile,
      STR_DirListFile,
      BT_UnLoadxref,
      BT_Loadxref,
      BT_Makexref,
      WIN_Infos,
      TXT_Infos,
      WIN_Errors,
      TXT_Errors;

/* TEXT BUFFER */
char *MainText = NULL;
char **MainTextArray = NULL;
char MainWinTitle[121];
BOOL DirHasChange;
long FindCurrentLine;
long FindCurrentPos;
BOOL FindindXRef = FALSE;
long find_cap, find_entry, find_posentry;

char *DirListText = NULL;
char **DirListTextArray = NULL;

long  LI_Text_x_offset = 0;

char *CY_FindTypeStr[] =
{
   "Current Entry",
   "Current File",
   NULL
};


/* THE ONLY MENU CONSTANT */
enum{Dummy, MEN_INFO, MEN_HELP, MEN_SELALL, MEN_COPY, MEN_FIND, MEN_XREF, MEN_PRINTSEL, MEN_CONFIG};

/* SIMPLE MENU STRUCTURE */
struct NewMenu Menu[] = {
  { NM_TITLE, "Project",     0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Info",        "I",0,0,    (APTR)MEN_INFO      },
  { NM_ITEM , "Help",        "H",0,0,    (APTR)MEN_HELP      },
  { NM_ITEM , NM_BARLABEL,   0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Print Select","P",0,0,    (APTR)MEN_PRINTSEL  },
  { NM_ITEM , NM_BARLABEL,   0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Config",      "?",0,0,    (APTR)MEN_CONFIG    },
  { NM_ITEM , NM_BARLABEL,   0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Quit",        "Q",0,0,    (APTR)MUIV_Application_ReturnID_Quit },

  { NM_TITLE, "Tools",       0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Copy",        "C",0,0,    (APTR)MEN_COPY      },
  { NM_ITEM , NM_BARLABEL,   0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Select All",  "A",0,0,    (APTR)MEN_SELALL    },
  { NM_ITEM , NM_BARLABEL,   0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Return First",0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Go Backward", 0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Go Forward",  0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Go Last",     0  ,0,0,    (APTR)0             },

  { NM_TITLE, "Search",      0  ,0,0,    (APTR)0             },
  { NM_ITEM , "Find Word",   "F",0,0,    (APTR)MEN_FIND      },
  { NM_ITEM , "Search XRef", "S",0,0,    (APTR)MEN_XREF      },

  { NM_END  , NULL,          0  ,0,0,    (APTR)0             },
};


/* MUI ERROR? */
static VOID fail(APTR APP_Main,char *str)
{
  if (APP_Main)
    MUI_DisposeObject(APP_Main);

  FreeCurrentDrawerList();

  if (MainTextArray)
  {  free(MainTextArray); MainTextArray = NULL; }
  if (MainText)
  {  free(MainText); MainText = NULL; }

  FreeIndex();

  FreeXRefs();

  DeleteDXListClass();

  if (MUIMasterBase)
    CloseLibrary(MUIMasterBase);
  if (str)
  {
    puts(str);
    exit(20);
  }
  exit(0);
}

/* STANDARD INIT FUNCTION FOR MUI */
static VOID init(VOID)
{
  if (!(MUIMasterBase = (struct Library *) OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN-1)))
    fail(NULL,"Failed to open "MUIMASTER_NAME".");
  if (!CreateDXListClass())
    fail(NULL,"Could not create DXList custom class.");
}

static BOOL ERROR_WIN_OPEN = FALSE;
static BOOL INFO_WIN_OPEN = FALSE;

void PrintError(char *str,...)
{
  static char txt_error[500];
  vsprintf(txt_error,str,(char *) ((& str) + 1));
  set(TXT_Errors,MUIA_Text_Contents,txt_error);
  if (!ERROR_WIN_OPEN)
  {
    ERROR_WIN_OPEN = TRUE;
    set(WIN_Errors, MUIA_Window_Open,TRUE);
  }
}

static void WinErrorsClose(void)
{
  set(WIN_Errors, MUIA_Window_Open,FALSE);
  ERROR_WIN_OPEN = FALSE;
}

void PrintInfo(char *str,...)
{
  static char txt_info[500];
  vsprintf(txt_info,str,(char *) ((& str) + 1));
  set(TXT_Infos,MUIA_Text_Contents,txt_info);
  if (!INFO_WIN_OPEN)
  {
    INFO_WIN_OPEN = TRUE;
    set(WIN_Infos, MUIA_Window_Open,TRUE);
  }
}

static void WinInfosClose(void)
{
  set(WIN_Infos, MUIA_Window_Open,FALSE);
  INFO_WIN_OPEN = FALSE;
}

/* OPENS INFO WINDOW */
static void AppInfo(void)
{
  MUI_RequestA(APP_Main,WIN_Main,0,"Info","*\033b_O\033bK",
    "\033c\n\033bADocReader "ADRVER"\n\033n\033iWritten by Gilles MASSON, 1996.\n\n\033n"
    "Based on Dirk Holtwick's MartinsReader 1.2.\n\n"
    "This program is FREEWARE\nand you may use it\nwithout paying any fee.\n",0);
}

/* OPENS HELP INFO WINDOW */
static void HelpInfo(void)
{
  MUI_RequestA(APP_Main,WIN_Main,0,"Help Info","*\033b_O\033bK",
    "\033c\n\033bADocReader "ADRVER"\n\033n\n"
    "Dir list       Up: '7'  Down: '1'  Read: '4'   \n"
    "               PageUp/PageDown: same with shift\n"
    "               Auto read: 'alt 7' and 'alt 1'  \n\n"
    "Function list  Up: '8'  Down: '2'              \n"
    "               PageUp/PageDown: same with shift\n\n"
    "Text           Up: '9'  Down: '3'              \n"
    "               PageUp: '5'  PageDown: '6'      \n\n"
    "Copy current Text line to clipboard 0: 'F4' or menu\n\n"
    "All can be found with cursors and alt/shift\n"
    "\n",0);
}

static void UnLoadxref(void)
{
  FreeXRefs();
}

static void Makexref(void)
{
  UnLoadxref();
  {
    char *xfn, *adf, *dlf, *incd1, *incd2, *incd3, *incd4, *adocd1, *adocd2, *adocd3, *adocd4;
    get(STR_XRefFile, MUIA_String_Contents, &xfn);
    get(STR_ADocFile, MUIA_String_Contents, &adf);
    get(STR_DirListFile, MUIA_String_Contents, &dlf);
    get(STR_ADocDrawer1, MUIA_String_Contents, &adocd1);
    get(STR_ADocDrawer2, MUIA_String_Contents, &adocd2);
    get(STR_ADocDrawer3, MUIA_String_Contents, &adocd3);
    get(STR_ADocDrawer4, MUIA_String_Contents, &adocd4);
    get(STR_IncDrawer1,  MUIA_String_Contents, &incd1);
    get(STR_IncDrawer2,  MUIA_String_Contents, &incd2);
    get(STR_IncDrawer3,  MUIA_String_Contents, &incd3);
    get(STR_IncDrawer4,  MUIA_String_Contents, &incd4);
    if (xfn && *xfn)
    {
      PrintInfo("Making XREF file %s ... \n",xfn);
      set(APP_Main,MUIA_Application_Sleep,TRUE );
      xref_make(xfn,adf,dlf,incd1,incd2,incd3,incd4,adocd1,adocd2,adocd3,adocd4);
      set(APP_Main,MUIA_Application_Sleep,FALSE);
    }
    else
      PrintError("can't find XREF file name ! \n");
  }
  FreeCurrentDrawerList();
}

static void Loadxref(void)
{
  UnLoadxref();
  {
    char *xfn;
    get(STR_XRefFile, MUIA_String_Contents, &xfn);
    if (xfn && *xfn)
    {
/*PrintInfo("Reading XREF file %s ... \n",xfn);*/
      set(APP_Main,MUIA_Application_Sleep,TRUE );
      ReadXRef(xfn);
      set(APP_Main,MUIA_Application_Sleep,FALSE);
    }
    else
      PrintError("can't find XREF file name ! \n");
  }
  if (!XRefArray)
    ConfigWinOpen();
}

static void FindXRef(void)
{
  if (FindindXRef)
  {
    PrintError("Allready finding other... \n");
    return;
  }
  if (!XRefArray)
    Loadxref();
  if (XRefArray)
  {
    char *word = NULL;
    get(LI_Text,MUIA_DXList_DClick,&word);
    if (word)
    {
      strncpy(FindWord,word,DATA_STRING_MAX);
      FindWord[DATA_STRING_MAX-1] = '\0';
      DoMethod(WIN_Main,MUIM_CallHook,&SearchXRefHook,MUIV_TriggerValue);
    }
    else
      PrintError("can't find word to search ! \n");
  }
  else
    PrintError("Can't search xref link, datas not loaded ! \n");
}

static void PR_TextChange(void)
{
  get(PR_Text,MUIA_Prop_First, &LI_Text_x_offset);
  set(LI_Text,MUIA_DXList_XOffset, LI_Text_x_offset);
}

static void PR_TextSet(void)
{
  long visible,width,first,num;
  get(LI_Text,MUIA_DXList_XVisible,&visible);

  get(LI_Text,MUIA_List_First,&first);
  get(LI_Text,MUIA_List_Visible,&num);
  width = 0;
  if ((first >= 0))
  {
    char *entry;
    long twidth,pos;
    while (num > 0)
    {
      num--;
      DoMethod(LI_Text,MUIM_List_GetEntry,first+num,&entry);
      if (entry)
      {
        twidth = 0;
        pos = 0;
        while (entry[pos] != '\0')
        {
          if (entry[pos] == '\t')
            twidth += 4;
          else
            twidth += 1;
          pos++;
        }
        if (twidth > width)
          width = twidth;
      }
    }
  }
  if (visible < 1)
    visible = 1;
  if (visible > width)
  {
    width = visible;
    LI_Text_x_offset = 0;
    set(PR_Text,MUIA_Prop_First, LI_Text_x_offset);
  }
  else if (LI_Text_x_offset > (width - visible))
  {
    LI_Text_x_offset = width - visible;
    set(PR_Text,MUIA_Prop_First, LI_Text_x_offset);
  }
  SetAttrs(PR_Text,MUIA_NoNotify,TRUE,
                        MUIA_Prop_First, LI_Text_x_offset,
                        MUIA_Prop_Visible, visible,
                        MUIA_Prop_Entries, width,
                        TAG_DONE);
}



/* DISPLAY ROUTINE FOR TEXTLIST */
/* void DisplayLI_Text(register __a2 char **array, register __a1 struct IndexData *act) */
static void DisplayLI_Text(void)
{
  register char **a2 __asm("a2");               char **array = a2;
  register char *a1 __asm("a1");     char *str = a1;

  if (str)
  {
    long len1,len2;
    len1 = 0;
    len2 = 0;
    while ((str[len1] != '\0') && (len2 < DATA_STRING_MAX - 5))
    {
      if (str[len1] == '\t')
      {
        DisplayString[len2++]  = ' ';
        DisplayString[len2++]  = ' ';
        DisplayString[len2++]  = ' ';
        DisplayString[len2++]  = ' ';
      }
      else if (str[len1] == '\f')
        DisplayString[len2++]  = ' ';
      else
        DisplayString[len2++]  = str[len1];
      len1++;
    }
    DisplayString[len2]  = '\0';
    if (LI_Text_x_offset < len2)
      *array  = &DisplayString[LI_Text_x_offset];
    else
      *array  = &DisplayString[len2];
  }
  else
    *array  = (void *) "???";
}


/* DISPLAY ROUTINE FOR XRef list */
/* void DisplayXRef(register __a2 char **array, register __a1 struct IndexData *act) */
static void DisplayXRef(void)
{
  register char **a2 __asm("a2");               char **array = a2;
  register struct XRefNode *a1 __asm("a1");     struct XRefNode *act = a1;

  if (act && act->File && act->Type)
  {
    int namelen, filelen;
    namelen = strlen(act->Name);
    if (namelen < 14)
      namelen = 14;
    GetShortFileName(act->File,DisplayString2,80);
    filelen = strlen(DisplayString2);
    if (filelen < 14)
      filelen = 14;
    sprintf(DisplayString,"%s %-*s %-*s",TypeName(act->Type),namelen,act->Name,filelen,DisplayString2);
    *array  = (void *) DisplayString;
  }
  else
    *array  = (void *) "<BAD XREF>";
}

/* DISPLAY ROUTINE FOR HISTORY */
/* void DisplayHist(register __a2 char **array, register __a1 struct IndexData *act) */
static void DisplayHist(void)
{
  register char **a2 __asm("a2");               char **array = a2;
  register struct XRefNode *a1 __asm("a1");      struct XRefNode *act = a1;

  if (act && act->File && act->Type)
  {
    int namelen, filelen;
    namelen = strlen(act->Name);
    if (namelen < 12)
      namelen = 12;
    GetShortFileName(act->File,DisplayString2,80);
    filelen = strlen(DisplayString2);
    if (filelen < 14)
      filelen = 14;
    sprintf(DisplayString,"%s %-*s %-*s",TypeName(act->Type),namelen,act->Name,filelen,DisplayString2);
    *array  = (void *) DisplayString;
  }
  else
    *array  = (void *) "<START>";
}

/* ADD ITEM TO HISTORY */
static void addhist(struct XRefNode *xrefnode)
{
  long    num;
  struct XRefNode *current;

  get(LV_Hist, MUIA_List_Active, &num);
  if (num != MUIV_List_Active_Off)
  {
    num = 0;
    while (1)
    {
      DoMethod (LV_Hist, MUIM_List_GetEntry, num, &current);
      if (!current)
        break;
      if (current == xrefnode)
      {
        set(LV_Hist,MUIA_List_Active, num);
        break;
      }
      num++;
    }
    if (!current)
    {
      get(LV_Hist, MUIA_List_Active, &num);
      if (num != MUIV_List_Active_Off)
      {
        DoMethod(LV_Hist, MUIM_List_InsertSingle, xrefnode, num+1);
        get(LV_Hist,MUIA_List_InsertPosition, &num);
        set(LV_Hist,MUIA_List_Active, num);
      }
      else
      {
        DoMethod(LV_Hist, MUIM_List_InsertSingle, xrefnode, MUIV_List_Insert_Bottom);
        get(LV_Hist,MUIA_List_InsertPosition, &num);
        set(LV_Hist,MUIA_List_Active, num);
      }
    }
  }
  else
  {
    DoMethod(LV_Hist, MUIM_List_InsertSingle, xrefnode, MUIV_List_Insert_Bottom);
    get(LV_Hist,MUIA_List_InsertPosition, &num);
    set(LV_Hist,MUIA_List_Active, num);
  }
}

/* ADD ITEM TO HISTORY */
static void restarthistory(void)
{
  DoMethod(LV_Hist,MUIM_List_Clear);
  addhist(&XRefStart);
}

/* DOUBLECLICK IN HISTORY */
static void HistFound(void)
{
  long    num;
  struct XRefNode *xrefnode;

  set(APP_Main, MUIA_Application_Sleep, TRUE);
  get(LV_Hist, MUIA_List_Active, &num);
  if (num != MUIV_List_Active_Off)
  {
    DoMethod (LV_Hist, MUIM_List_GetEntry, num, &xrefnode);

    if (xrefnode && xrefnode->File)
    {
      char realname[200];
      long    size = 50000,locksave;
      struct  FileInfoBlock  *fileinfo;
      long num;

      GetFileName(xrefnode->File,realname,200);
      if (fileinfo=malloc(sizeof(struct FileInfoBlock)))
      {
        if (locksave=Lock(realname,ACCESS_READ))
        {
          if(Examine(locksave,fileinfo)) size=fileinfo->fib_Size;
          UnLock(locksave);

          if (xrefnode->Type == TYPE_ADENTRY)
          {
            LoadText(realname,size,xrefnode->Line);
          }
          else if ((xrefnode->Type == TYPE_DEFINE) ||
              (xrefnode->Type == TYPE_TYPEDEF) ||
              (xrefnode->Type == TYPE_TYPEDEFSTRUCT) ||
              (xrefnode->Type == TYPE_STRUCT))
          {
            LoadText(realname,size,xrefnode->Line);
          }
          else
          {
            LoadText(realname,size,-1);
          }
        }
        free(fileinfo);
      }
    }
    else
      StartState();
    nnset(LV_Hist, MUIA_List_Active, num);
  }
  set(APP_Main, MUIA_Application_Sleep, FALSE);
}


/* FREE INDEX LIST */
static void FreeIndex(void)
{
  struct IndexData *a,*b;

  if (IndexBase)
  {
    a = IndexBase;
    while (a)
    {
      b = a->succ;
      free(a);
      a = b;
    }
    IndexBase = NULL;
    IndexLast = NULL;
  }
}

/* DISPLAY ROUTINE FOR CHAPTERS */
/* void DisplayCap(register __a2 char **array, register __a1 struct IndexData *act) */
static void DisplayCap(void)
{
  register char **a2 __asm("a2");               char **array = a2;
  register struct IndexData *a1 __asm("a1");    struct IndexData *act = a1;

  *array  = (void *)act->name;
}

/* ADD ITEM TO CHAPTER INDEX */
static void addindex(char *name, char **text_array)
{
  struct  IndexData  *act;

  if (act = malloc(sizeof(struct IndexData)))
  {
    if (IndexBase)
      IndexLast->succ = act;
    else
      IndexBase = act;
    IndexLast = act;
    act->succ = NULL;
    strcpy((char *)(act->name), name);
    act->text_array = text_array;
    DoMethod(LV_Cap, MUIM_List_InsertSingle, act, MUIV_List_Insert_Bottom);
  }
  else
    puts("Index mem");
}

static void XRefFound(void)
{
  struct XRefNode *act;
  DoMethod(LV_XRefSearch, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &act);
  if (act)
    addhist(act);
}


/* DOUBLECLICK IN CHAPTER */
static void CapFound(void)
{
  if (MainText)
  {
    long    num;
    struct  IndexData  *id;

    nnset(LV_Hist, MUIA_List_Active, MUIV_List_Active_Off);
    set(APP_Main, MUIA_Application_Sleep, TRUE);
    get(LV_Cap, MUIA_List_Active, &num);
    if (num != MUIV_List_Active_Off)
    {
      DoMethod(LV_Cap, MUIM_List_GetEntry, num, &id);
      set(LI_Text, MUIA_List_Quiet, TRUE);
      DoMethod(LI_Text,MUIM_List_Clear);
      if (id->text_array)
        DoMethod(LI_Text,MUIM_List_Insert,id->text_array,-1,MUIV_List_Insert_Bottom);
      else
        DoMethod(LI_Text,MUIM_List_InsertSingle,NothingName,MUIV_List_Insert_Bottom);
      set(LI_Text, MUIA_List_Quiet, FALSE);
    }
    set(APP_Main, MUIA_Application_Sleep, FALSE);
  }
}

/* LOAD WHOLE TEXT INTO BUFFER */
static void LoadText(char *name, LONG len, long pos)
{
  struct  IndexData  *id;
  char    *t,*s;
  FILE    *f;
  BOOL    changed;
  static  char CurrentName[200] = "";
  char *adf = NULL;

  if (name == NULL)
  {
    long    size,locksave;
    struct  FileInfoBlock  *fileinfo;  /* must be long aligned !!! */

    get(STR_ADocFile, MUIA_String_Contents, &adf);

    size = 0;
    if (adf && (adf[0]!='\0') && (locksave=Lock(adf,ACCESS_READ)))
    {
      if (fileinfo=malloc(sizeof(struct FileInfoBlock)))
      {
        if (Examine(locksave,fileinfo))
          size = fileinfo->fib_Size;
        free(fileinfo);
      }
      UnLock(locksave);
    }
    if (size > 0)
    {
      name = adf;
      len = size;
      pos = -1;
    }
    else
    {
      PrintError("Couldn't get size of file %s !\n",adf);
      adf = NULL;
    }
    if (!adf || (adf[0]=='\0'))
    {
      find_cap = 0; find_entry = 0; find_posentry = 0;
      CurrentName[0] = '\0';
      DoMethod(LI_Text,MUIM_List_Clear);
      if (MainTextArray)
      {  free(MainTextArray); MainTextArray = NULL; }
      if(MainText)
      {  free(MainText); MainText = NULL; }
      DoMethod(LV_Cap, MUIM_List_Clear);
      FreeIndex();
      DoMethod(LI_Text,MUIM_List_Clear);
      nnset(PR_Text,MUIA_Prop_First, 0);
      PR_TextChange();
      DoMethod(LI_Text,MUIM_List_InsertSingle,NothingName,MUIV_List_Insert_Bottom);
      addindex(NothingName,NULL);
      return;
    }
  }

  /* LOAD */
  /*PrintInfo("load text: %s  (old %s) \n",name,CurrentName);*/

  if (!strcmp(CurrentName,name))
    changed = FALSE;
  else
  {
    changed = TRUE;
    find_cap = 0; find_entry = 0; find_posentry = 0;

    if (!adf)
      ChangeDir(name);

    strncpy(CurrentName,name,199);
    CurrentName[199] = '\0';

    DoMethod(LI_Text,MUIM_List_Clear);
    nnset(PR_Text,MUIA_Prop_First, 0);
    PR_TextChange();

    if (MainTextArray)
    {  free(MainTextArray); MainTextArray = NULL; }
    if(MainText)
    {  free(MainText); MainText = NULL; }
    if (MainText = malloc(len+10))
    {
      if (f = fopen(name,"r"))
      {
        fread(MainText,len,1,f);
        MainText[len] = 0;
        fclose(f);
      }
      else
        puts("File error");
    }
    else
      puts("No more mem");
  }

  /* IS AUTODOC? */
  if (!strncmp(MainText,TOC,strlen(TOC)))
  {
    if (changed)
    {
      s = FilePart(name);
      strncpy(MainWinTitle,s,120); MainWinTitle[120] = '\0';
      set(WIN_Main, MUIA_Window_Title, MainWinTitle);

      /* ANALYSE */
      DoMethod(LV_Cap, MUIM_List_Clear);
      FreeIndex();
      set(LV_Cap, MUIA_List_Quiet, TRUE);

      {
        char strname[200];
        long strn;
        char *str = MainText;
        long max = 2;

        while (*str != '\0')
        {
          if (*str == '\n')
            max++;
          if (*str == '\f')
            max += 2;
          str++;
        }
        if ((MainTextArray = malloc((max + 2) * sizeof(char *))))
        {
          long num = 0;
          str = MainText;
          MainTextArray[num] = str;
          addindex("[FIRST PAGE]",&(MainTextArray[num]));
          while (*str != '\0')
          {
            if (*str == '\f')
            {
              if (num <= max)
              {
                num++;
                MainTextArray[num] = NULL;
              }
              *str = '\0';
              str++;
              if (*str == '\n')
              {
                *str = '\0';
                str++;
              }
              if (*str != '\0')
              {
                num++;
                MainTextArray[num] = str;
                strn = 0;
                while(*str && (*str != '\n') && (*str != ' ') && (*str != '\t') && (strn < 119))
                  strname[strn++] = *str++;
                if (strn > 0)
                {
                  strname[strn] = '\0';
                  addindex(strname,&(MainTextArray[num]));
                }
              }
            }
            if (*str == '\n')
            {
              *str = '\0';
              str++;
              if (num <= max)
              {
                num++;
                MainTextArray[num] = str;
              }
            }
            else
              str++;
          }
          num++;
          MainTextArray[num] = NULL;
        }
        else
          PrintError("LoadText: malloc textarray failled ! \n");
      }
      set(LV_Cap, MUIA_List_Quiet, FALSE);
    }
    /* SHOW */
    if (pos > 0)
      set(LV_Cap, MUIA_List_Active, pos);
    else
      set(LV_Cap, MUIA_List_Active, 0);
  }
  else
  {       /*  MUI_RequestA(APP_Main,WIN_Main,0,"Info","*\033b_O\033bK",
           *    "\nDoesn't seem to be\na real AutoDoc file!\n",0);
           */
    if (changed)
    {
      if (adf)
      {
        strncpy(MainWinTitle,"ADocReader "ADRVER", 1996",120); MainWinTitle[120] = '\0';
        set(WIN_Main, MUIA_Window_Title, MainWinTitle);
      }
      else
      {
        s = FilePart(name);
        strncpy(MainWinTitle,s,120); MainWinTitle[120] = '\0';
        set(WIN_Main, MUIA_Window_Title, MainWinTitle);
      }

      {
        char *str = MainText;
        long max = 2;

        while (*str != '\0')
        {
          if ((*str == '\n') || (*str == '\f'))
            max++;
          str++;
        }
        if ((MainTextArray = malloc((max + 2) * sizeof(char *))))
        {
          long num = 0;
          str = MainText;
          MainTextArray[num] = str;

          while (*str != '\0')
          {
            if ((*str == '\n') || (*str == '\f'))
            {
              *str = '\0';
              str++;
              if (num <= max)
              {
                num++;
                MainTextArray[num] = str;
              }
            }
            else
              str++;
          }
          num++;
          MainTextArray[num] = NULL;

          DoMethod(LI_Text,MUIM_List_Clear,TRUE);
          set(LI_Text, MUIA_List_Quiet, TRUE);
          DoMethod(LI_Text,MUIM_List_Insert,MainTextArray,-1,MUIV_List_Insert_Bottom);
          set(LI_Text, MUIA_List_Quiet, FALSE);
        }
        else
          PrintError("LoadText: malloc textarray failed ! \n");
      }

      set(LV_Cap, MUIA_List_Quiet, TRUE);
      DoMethod(LV_Cap, MUIM_List_Clear);
      FreeIndex();
      addindex("Not AutoDoc.",MainTextArray);
      set(LV_Cap, MUIA_List_Quiet, FALSE);
    }
    /* SHOW */
    if (MainTextArray && (pos >= 0))
    {
      long num;
      set(LI_Text, MUIA_List_Quiet, TRUE);
      get(LI_Text, MUIA_List_Visible, &num);
      if (num > 0)
        DoMethod(LI_Text,MUIM_List_Jump, pos - 1 + num);
      if (pos > 0)
        DoMethod(LI_Text,MUIM_List_Jump, pos - 1);
      if (pos >= 0)
        set(LI_Text, MUIA_List_Active, pos);
      set(LI_Text, MUIA_List_Quiet, FALSE);
    }
  }
}

/* DOUBLECLICK ON A FILE */
static void DirFound(void)
{
  long    num,len;
  struct  FileInfoBlock  *act;
  char    *dir;

  nnset(LV_Hist, MUIA_List_Active, MUIV_List_Active_Off);
  set(APP_Main, MUIA_Application_Sleep, TRUE);
  get(LV_Dir, MUIA_List_Active, &num);
  if (num != MUIV_List_Active_Off)
  {
    DoMethod (LV_Dir, MUIM_List_GetEntry, num, &act);
    if (act != NULL)
    {
      char name[200];
      get(LV_Dir,MUIA_Dirlist_Directory,&dir);
      strncpy(name,dir,199);
      name[199] = '\0';
      AddPart(name,act->fib_FileName,199);
      len = act->fib_Size;

      LoadText(name,len,-1);
    }
  }
  set(APP_Main, MUIA_Application_Sleep, FALSE);
  DirHasChange = FALSE;
}

static void ChangeDir(char *file_name)
{
  long num;
  BOOL reactive = FALSE;
  struct  FileInfoBlock  *act;
  char *dir, *fdir;
  char file_dir[200];
  int pos;
  set(APP_Main, MUIA_Application_Sleep, TRUE);
  pos = strlen(file_name);
  while (pos > 0)
  {
    if ((file_name[pos] == '.') || (file_name[pos] == '/') || (file_name[pos] == ':'))
      break;
    pos--;
  }
  if (file_name[pos] == '.')
  {
    strcpy(file_dir,"#?");
    strcat(file_dir,&file_name[pos]);
    ParsePatternNoCase(file_dir,DirPatternToken,20);
  }
  else
    ParsePatternNoCase("#?",DirPatternToken,20);

  get(LV_Dir,MUIA_Dirlist_Directory,&dir);
  strncpy(file_dir,file_name,199);
  file_dir[199] = '\0';
  fdir = PathPart(file_dir);
  if (fdir)
    *fdir = '\0';
  if (!dir || strcmp(file_dir,dir))
  {
    set(LV_Dir, MUIA_List_Quiet, TRUE);
    set(LV_Dir, MUIA_Dirlist_Directory, file_dir);
    nnset(STR_CurrentDrawer, MUIA_String_Contents, file_dir);
    set(LV_Dir, MUIA_Dirlist_AcceptPattern, DirPatternToken);
    set(LV_Dir, MUIA_List_Quiet, FALSE);
    reactive = TRUE;
  }
  fdir = FilePart(file_name);
  get(LV_Dir, MUIA_List_Active, &num);
  if (num != MUIV_List_Active_Off)
  {
    DoMethod(LV_Dir, MUIM_List_GetEntry, num, &act);
    if (strcmp(fdir,act->fib_FileName))
      reactive = TRUE;
  }
  else
    reactive = TRUE;

  if (reactive)
  {
    long num = 0;
    nnset(LV_Dir, MUIA_List_Active, MUIV_List_Active_Off);
    while (1)
    {
      DoMethod(LV_Dir,MUIM_List_GetEntry,num,&act);
      if (act)
      {
        if (!strcmp(fdir,act->fib_FileName))
        {
          nnset(LV_Dir, MUIA_List_Active, num);
          break;
        }
      }
      else
        break;
      num++;
    }
  }
  set(APP_Main, MUIA_Application_Sleep, FALSE);
}


/* PRINT ACTUAL PAGE */
static void PrintSelect(void)
{
  if (MainText)
  {
    char  *prttext;
    FILE  *prt;
/*
    get(LI_Text, MUIA_Floattext_Text, &prttext);
    if(prt=fopen("prt:","w"))
    {
      fputs(prttext,prt);
      fclose(prt);
    }
    else
      puts("Couldn't open printer.");
*/
  }
}


/* COPY ACTUAL LINE */
static void CopyClip(void)
{
  if (MainText)
  {
    unsigned char *string,*string2;
    long TextSize;
    LONG id;
    long pos;
    set(APP_Main, MUIA_Application_Sleep, TRUE);
    TextSize = 0;
    id = MUIV_List_NextSelected_Start;
    for (;;)
    {
      DoMethod(LI_Text,MUIM_List_NextSelected,&id);
      if (id == MUIV_List_NextSelected_End)
        break;
      DoMethod(LI_Text,MUIM_List_GetEntry,id,&string2);
      if (string2 != NULL)
      {
        while (*string2 != '\0')
        {
          if (*string2 == '\t')
            TextSize += 4;
          else
            TextSize += 1;
          string2++;
        }
        TextSize += 1;
      }
    }
    TextSize += 2;

    string = (unsigned char *) malloc(TextSize + 1);
    if (string != NULL)
    {
      string[TextSize] = '\0';
      id = MUIV_List_NextSelected_Start;
      pos = 0;
      for (;;)
      {
        DoMethod(LI_Text,MUIM_List_NextSelected,&id);
        if (id == MUIV_List_NextSelected_End)
          break;
        DoMethod(LI_Text,MUIM_List_GetEntry,id,&string2);
        if (string2 != NULL)
        {
          if (pos >= TextSize)
            break;
          while (*string2 != '\0')
          {
            if ((*string2 == 0xA0) || (*string2 == '\f'))
            {
              if (pos < TextSize) string[pos++] = ' ';
            }
            else if (*string2 == '\t')
            {
              if (pos < TextSize) string[pos++] = ' ';
              if (pos < TextSize) string[pos++] = ' ';
              if (pos < TextSize) string[pos++] = ' ';
              if (pos < TextSize) string[pos++] = ' ';
            }
            else
              if (pos < TextSize) string[pos++] = *string2;
            string2++;
          }
          if (pos < TextSize) string[pos++] = '\n';
          string[pos] = '\0';
        }
      }
      WriteClip(string);
      free(string);
    }
    set(APP_Main, MUIA_Application_Sleep, FALSE);
  }
}

/* Open/Active CONF window*/
static void ConfigWinOpen(void)
{
  set(WIN_Config, MUIA_Window_Open,TRUE);
  set(WIN_Config, MUIA_Window_ActiveObject, STR_DefaultDrawer);
  set(WIN_Config, MUIA_Window_DefaultObject, STR_DefaultDrawer);
}

/* Open/Active SEARCH XRef window*/
static void WinXRefSearchOpen(void)
{
  set(WIN_XRefSearch,MUIA_Window_Open,TRUE);
  set(WIN_XRefSearch, MUIA_Window_ActiveObject, STR_XRefSearch);
  set(WIN_XRefSearch, MUIA_Window_DefaultObject, STR_XRefSearch);
}

/* Open/Active FIND Word window*/
static void WFindWinOpen(void)
{
  if (MainText)
  {
    set(WIN_WFind,MUIA_Window_Open,TRUE);
    set(WIN_WFind, MUIA_Window_ActiveObject, STR_WFind);
    set(WIN_WFind, MUIA_Window_DefaultObject, STR_WFind);
    FindCurrentLine = 0;
    FindCurrentPos = 0;
  }
}

static BOOL IsPartOfCase(char *findin,char *tofind,int tofindlen)
{
  int pos = strlen(findin) - tofindlen;
  while (pos >= 0)
  {
    if (!strncmp(&findin[pos],tofind,tofindlen))
      return (TRUE);
    pos--;
  }
  return (FALSE);
}

static BOOL IsPartOfNoCase(char *findin,char *tofind,int tofindlen)
{
  int pos = strlen(findin) - tofindlen;
  while (pos >= 0)
  {
    if (!strnicmp(&findin[pos],tofind,tofindlen))
      return (TRUE);
    pos--;
  }
  return (FALSE);
}


static void WFindString(int incvalue,int firstlast)
{
/*  find_cap, find_entry, find_posentry  */
  if (MainText)
  {
    long num;
    char *chaine;
    get(STR_WFind, MUIA_String_Contents, &chaine);
    WFindWinOpen();
    get(LV_Dir, MUIA_List_Active, &num);
    if (firstlast || (num == MUIV_List_Active_Off))
    {
      if (incvalue > 0)
      {
        incvalue = 1;
        find_entry = 0;
        find_posentry = 0;
      }
      else
      {
        incvalue = -1;
        find_entry = 1000;
        find_posentry = 1000;
      }
    }

  }
}

static void WFindStringFirst(void)
{
  WFindString( 1,1);
}

static void WFindStringPrec(void)
{
  WFindString(-1,0);
}

static void WFindStringNext(void)
{
  WFindString( 1,0);
}

static void WFindStringLast(void)
{
  WFindString(-1,1);
}

static void WFindStringIncr(void)
{
  LONG incr;
  get(CK_WF_Incr,MUIA_Selected,&incr);
  if (incr)
    WFindString(1,0);
}


static void XRefSearchStr(void)
{
  long searchcase,searchpartof;
  int wordlen;
  char *chaine;
  get(STR_XRefSearch, MUIA_String_Contents, &chaine);
  get(CK_XS_Case,MUIA_Selected,&searchcase);
  get(CK_XS_PartOf,MUIA_Selected,&searchpartof);

  wordlen = strlen(chaine);
  if (wordlen > 0)
  {
    FindindXRef = TRUE;
    if (!XRefArray)
      Loadxref();
    if (XRefArray)
    {
      long curnum;
      char realname[200];
      long num;

      set(APP_Main,MUIA_Application_Sleep,TRUE );
      if (searchpartof)
      {
        set(LV_XRefSearch, MUIA_List_Quiet, TRUE);
        DoMethod(LV_XRefSearch, MUIM_List_Clear);
        curnum = 0;
        while (curnum <= XRefArrayLast)
        {
          if ((searchcase && IsPartOfCase(XRefArray[curnum]->Name,chaine,wordlen)) ||
              (!searchcase && IsPartOfNoCase(XRefArray[curnum]->Name,chaine,wordlen)))
            DoMethod(LV_XRefSearch, MUIM_List_InsertSingle, XRefArray[curnum], MUIV_List_Insert_Bottom);
          curnum++;
        }
        set(LV_XRefSearch, MUIA_List_Quiet, FALSE);
      }
      else
      {
        curnum = SearchStartOfNameNoCase(chaine,&num);
        set(LV_XRefSearch, MUIA_List_Quiet, TRUE);
        DoMethod(LV_XRefSearch, MUIM_List_Clear);
        while ((curnum <= XRefArrayLast) && (num > 0))
        {
          if (!searchcase || !strncmp(XRefArray[curnum]->Name,chaine,wordlen))
            DoMethod(LV_XRefSearch, MUIM_List_InsertSingle, XRefArray[curnum], MUIV_List_Insert_Bottom);
          curnum++;
          num--;
        }
        set(LV_XRefSearch, MUIA_List_Quiet, FALSE);
      }
      set(APP_Main,MUIA_Application_Sleep,FALSE );
      WinXRefSearchOpen();
    }
  }
  FindindXRef = FALSE;
}

static void XRefSearchStrIncr(void)
{
  LONG incr;
  get(CK_XS_Incr,MUIA_Selected,&incr);
  if (incr)
    XRefSearchStr();
}

/* DIR ACTIVE UP */
static void DirGoUp(void)
{
  if (1)
  {
    nnset(LV_Dir,MUIA_List_Active,MUIV_List_Active_Up);
    DirHasChange = TRUE;
  }
}

/* DIR ACTIVE DOWN */
static void DirGoDown(void)
{
  if (1)
  {
    nnset(LV_Dir,MUIA_List_Active,MUIV_List_Active_Down);
    DirHasChange = TRUE;
  }
}

/* DIR ACTIVE PAGE UP */
static void DirGoPageUp(void)
{
  if (1)
  {
    nnset(LV_Dir,MUIA_List_Active,MUIV_List_Active_PageUp);
    DirHasChange = TRUE;
  }
}

/* DIR ACTIVE PAGE DOWN */
static void DirGoPageDown(void)
{
  if (1)
  {
    nnset(LV_Dir,MUIA_List_Active,MUIV_List_Active_PageDown);
    DirHasChange = TRUE;
  }
}

/* DIR ACTIVE UP */
static void DirGoUp2(void)
{
  if (1)
  {
    nnset(LV_Dir,MUIA_List_Active,MUIV_List_Active_Up);
    DirFound();
  }
}

/* DIR ACTIVE DOWN */
static void DirGoDown2(void)
{
  if (1)
  {
    nnset(LV_Dir,MUIA_List_Active,MUIV_List_Active_Down);
    DirFound();
  }
}

/* DIR ACTIVE PAGE UP */
static void DirGoPageUp2(void)
{
  if (1)
  {
    nnset(LV_Dir,MUIA_List_Active,MUIV_List_Active_PageUp);
    DirFound();
  }
}

/* DIR ACTIVE PAGE DOWN */
static void DirGoPageDown2(void)
{
  if (1)
  {
    nnset(LV_Dir,MUIA_List_Active,MUIV_List_Active_PageDown);
    DirFound();
  }
}

/* CAP ACTIVE UP */
static void CapGoUp(void)
{
  if (DirHasChange)
    DirFound();
  if (MainText)
  {
    nnset(LV_Cap,MUIA_List_Active,MUIV_List_Active_Up);
    CapFound();
  }
  else
    DirGoUp2();
}

/* CAP ACTIVE DOWN */
static void CapGoDown(void)
{
  if (DirHasChange)
    DirFound();
  if (MainText)
  {
    nnset(LV_Cap,MUIA_List_Active,MUIV_List_Active_Down);
    CapFound();
  }
  else
    DirGoUp2();
}

/* CAP ACTIVE PAGE UP */
static void CapGoPageUp(void)
{
  if (DirHasChange)
    DirFound();
  if (MainText)
  {
    nnset(LV_Cap,MUIA_List_Active,MUIV_List_Active_PageUp);
    CapFound();
  }
  else
    DirGoUp2();
}

/* CAP ACTIVE PAGE DOWN */
static void CapGoPageDown(void)
{
  if (DirHasChange)
    DirFound();
  if (MainText)
  {
    nnset(LV_Cap,MUIA_List_Active,MUIV_List_Active_PageDown);
    CapFound();
  }
  else
    DirGoUp2();
}

/* TEXT ACTIVE UP */
static void TextGoUp(void)
{
  if (DirHasChange)
    DirFound();
  if (MainText)
  {
    set(LI_Text,MUIA_List_Active,MUIV_List_Active_Up);
  }
  else
    CapGoUp();
}

/* TEXT ACTIVE DOWN */
static void TextGoDown(void)
{
  if (DirHasChange)
    DirFound();
  if (MainText)
  {
    set(LI_Text,MUIA_List_Active,MUIV_List_Active_Down);
  }
  else
    CapGoUp();
}

/* TEXT ACTIVE PAGE UP */
static void TextGoPageUp(void)
{
  if (DirHasChange)
    DirFound();
  if (MainText)
  {
    set(LI_Text,MUIA_List_Active,MUIV_List_Active_PageUp);
  }
  else
    CapGoUp();
}

/* TEXT ACTIVE PAGE DOWN */
static void TextGoPageDown(void)
{
  if (DirHasChange)
    DirFound();
  if (MainText)
  {
    set(LI_Text,MUIA_List_Active,MUIV_List_Active_PageDown);
  }
  else
    CapGoUp();
}


static void StartState(void)
{

  if (StartFileName)
  {
    long    size,locksave;
    struct  FileInfoBlock  *fileinfo;
    size = 0;
    if (locksave=Lock(StartFileName,ACCESS_READ))
    {
      if (fileinfo=malloc(sizeof(struct FileInfoBlock)))
      {
        if (Examine(locksave,fileinfo))
          size = fileinfo->fib_Size;
        free(fileinfo);
      }
      UnLock(locksave);
    }
    ParsePatternNoCase("#?",DirPatternToken,20);
    set(LV_Dir, MUIA_Dirlist_AcceptPattern, DirPatternToken);
    nnset(LV_Dir, MUIA_List_Active, MUIV_List_Active_Off);
    if (size > 0)
      LoadText(StartFileName,size,-1);
    else
      StartFileName = NULL;
  }
  else if (StartDirName)
  {
    nnset(STR_CurrentDrawer, MUIA_String_Contents, StartDirName);
    set(LV_Dir, MUIA_Dirlist_Directory, StartDirName);
    ParsePatternNoCase("#?",DirPatternToken,20);
    set(LV_Dir, MUIA_Dirlist_AcceptPattern, DirPatternToken);
    nnset(LV_Dir, MUIA_List_Active, MUIV_List_Active_Off);
    LoadText(NULL, 0, 0);
  }
  if (!StartFileName && !StartDirName)
  {
    char  *s;
    get(STR_DefaultDrawer, MUIA_String_Contents, &s);
    nnset(STR_CurrentDrawer, MUIA_String_Contents, s);
    set(LV_Dir, MUIA_Dirlist_Directory, s);
    ParsePatternNoCase("#?.doc",DirPatternToken,20);
    set(LV_Dir, MUIA_Dirlist_AcceptPattern, DirPatternToken);
    nnset(LV_Dir, MUIA_List_Active, MUIV_List_Active_Off);
    LoadText(NULL, 0, 0);
  }
  set(WIN_Main, MUIA_Window_ActiveObject, LI_Text);
  set(WIN_Main, MUIA_Window_DefaultObject, LI_Text);
}

static void FreeCurrentDrawerList(void)
{
  if (DirListText)
  { free(DirListText);        DirListText = NULL; }
  if (DirListText)
  { free(DirListTextArray);   DirListTextArray = NULL; }
}

static void LoadCurrentDrawerList(void)
{
  if (!DirListText || !DirListTextArray)
  {
    long    size,locksave;
    struct  FileInfoBlock  *fileinfo;  /* must be long aligned !!! */
    char *dlf;

    DoMethod(LI_CurrentDrawer,MUIM_List_Clear,TRUE);
    FreeCurrentDrawerList();

    get(STR_DirListFile, MUIA_String_Contents, &dlf);

    size = 0;
    if (dlf && (dlf[0]!='\0') && (locksave=Lock(dlf,ACCESS_READ)))
    {
      if (fileinfo=malloc(sizeof(struct FileInfoBlock)))
      {
        if (Examine(locksave,fileinfo))
          size = fileinfo->fib_Size;
        free(fileinfo);
      }
      UnLock(locksave);
    }
    if (size > 0)
    {
      FILE *f;
      if (DirListText = malloc(size+10))
      {
        char *str = MainText;
        long max = 2;
        if (f = fopen(dlf,"r"))
        {
          fread(DirListText,size,1,f);
          DirListText[size] = 0;
          fclose(f);

          str = DirListText;
          max = 2;

          while (*str != '\0')
          {
            if ((*str == '\n') || (*str == '\f'))
              max++;
            str++;
          }
          if ((DirListTextArray = malloc((max + 2) * sizeof(char *))))
          {
            long num = 0;
            str = DirListText;
            DirListTextArray[num] = str;

            while (*str != '\0')
            {
              if ((*str == '\n') || (*str == '\f'))
              {
                *str = '\0';
                str++;
                if ((str[0] != '\n') && (str[0] != '\f') && (num <= max))
                {
                  num++;
                  DirListTextArray[num] = str;
                }
              }
              else
                str++;
            }
            num++;
            DirListTextArray[num] = NULL;

            set(LI_CurrentDrawer, MUIA_List_Quiet, TRUE);
            DoMethod(LI_CurrentDrawer,MUIM_List_Insert,DirListTextArray,-1,MUIV_List_Insert_Bottom);
            set(LI_CurrentDrawer, MUIA_List_Quiet, FALSE);
            return;
          }
          else
            PrintError("DirListText: malloc dirlisttextarray failed ! \n");
        }
        else
          puts("File error");
      }
      else
        puts("No more mem");
      FreeCurrentDrawerList();
    }
  }
}

/* SAVEDS ASM LONG StrObjFunc(REG(a2) Object *pop,REG(a1) Object *str) */
static LONG StrObjFunc(void)
{
  char *x,*s,d[200];
  int i;

  LoadCurrentDrawerList();

  get(STR_CurrentDrawer,MUIA_String_Contents,&s);
  if (s && *s)
  {
    s = stpcpy(d,s);
    if ((s[-1] != ':') && (s[-1] != '/'))
    {
      s[0] = '/';
      s[1] = '\0';
    }

    for (i=0;;i++)
    {
      DoMethod(LI_CurrentDrawer,MUIM_List_GetEntry,i,&x);
      if (!x)
      {
        set(LI_CurrentDrawer,MUIA_List_Active,MUIV_List_Active_Off);
        break;
      }
      else if (!stricmp(x,d))
      {
        set(LI_CurrentDrawer,MUIA_List_Active,i);
        break;
      }
    }
  }
  return(TRUE);
}

/* SAVEDS ASM VOID ObjStrFunc(REG(a2) Object *pop,REG(a1) Object *str) */
static void ObjStrFunc(void)
{
  char *x;
  DoMethod(LI_CurrentDrawer,MUIM_List_GetEntry,MUIV_List_GetEntry_Active,&x);
  nnset(STR_CurrentDrawer,MUIA_String_Contents,x);
  nnset(LV_Dir, MUIA_List_Active, MUIV_List_Active_Off);
  nnset(LV_Hist, MUIA_List_Active, MUIV_List_Active_Off);
  ChangeDir(x);
  LoadText(NULL, 0, 0);
}

/* SAVEDS ASM VOID WindowFunc(REG(a2) Object *pop,REG(a1) Object *win) */
static void WindowFunc(void)
{
  register Object *a1 __asm("a1");  Object *win = a1;
  set(win, MUIA_Window_DefaultObject, LI_CurrentDrawer);
}

static void ChgeCurrentDrawer(void)
{
  char *s,d[200];
  get(STR_CurrentDrawer,MUIA_String_Contents,&s);
  if (s && *s)
  {
    s = stpcpy(d,s);
    if ((s[-1] != ':') && (s[-1] != '/'))
    {
      s[0] = '/';
      s[1] = '\0';
    }
    nnset(LV_Dir, MUIA_List_Active, MUIV_List_Active_Off);
    nnset(LV_Hist, MUIA_List_Active, MUIV_List_Active_Off);
    ChangeDir(d);
    LoadText(NULL, 0, 0);
  }
  else
    StartState();
}

/* MAIN PROGRAM */
int main(int argc,char *argv[])
{
  int     numarg;

  /* HOOKS */
  static const struct Hook XRefFoundHook  =         { { NULL,NULL },(VOID *)XRefFound, NULL,NULL };
  static const struct Hook DisplayXRefHook  =       { { NULL,NULL },(VOID *)DisplayXRef, NULL,NULL };
  static const struct Hook PR_TextChangeHook =      { { NULL,NULL },(VOID *)PR_TextChange, NULL,NULL };
  static const struct Hook PR_TextSetHook  =        { { NULL,NULL },(VOID *)PR_TextSet, NULL,NULL };
  static const struct Hook DisplayLI_TextHook  =    { { NULL,NULL },(VOID *)DisplayLI_Text, NULL,NULL };
  static const struct Hook FindXRefHook  =          { { NULL,NULL },(VOID *)FindXRef, NULL,NULL };
  static const struct Hook DirFoundHook  =          { { NULL,NULL },(VOID *)DirFound, NULL,NULL };
  static const struct Hook DisplayHistHook  =       { { NULL,NULL },(VOID *)DisplayHist, NULL,NULL };
  static const struct Hook DisplayCapHook  =        { { NULL,NULL },(VOID *)DisplayCap, NULL,NULL };
  static const struct Hook HistFoundHook  =         { { NULL,NULL },(VOID *)HistFound, NULL,NULL };
  static const struct Hook CapFoundHook  =          { { NULL,NULL },(VOID *)CapFound, NULL,NULL };
  static const struct Hook AppInfoHook    =         { { NULL,NULL },(VOID *)AppInfo, NULL,NULL };
  static const struct Hook HelpInfoHook    =        { { NULL,NULL },(VOID *)HelpInfo, NULL,NULL };
  static const struct Hook CopyClipHook    =        { { NULL,NULL },(VOID *)CopyClip, NULL,NULL };
  static const struct Hook PrintSelectHook    =     { { NULL,NULL },(VOID *)PrintSelect, NULL,NULL };
  static const struct Hook StartStateHook =         { { NULL,NULL },(VOID *)StartState, NULL,NULL };
  static const struct Hook DirGoUpHook    =         { { NULL,NULL },(VOID *)DirGoUp, NULL,NULL };
  static const struct Hook DirGoDownHook    =       { { NULL,NULL },(VOID *)DirGoDown, NULL,NULL };
  static const struct Hook DirGoPageUpHook    =     { { NULL,NULL },(VOID *)DirGoPageUp, NULL,NULL };
  static const struct Hook DirGoPageDownHook    =   { { NULL,NULL },(VOID *)DirGoPageDown, NULL,NULL };
  static const struct Hook DirGoUp2Hook   =         { { NULL,NULL },(VOID *)DirGoUp2, NULL,NULL };
  static const struct Hook DirGoDown2Hook   =       { { NULL,NULL },(VOID *)DirGoDown2, NULL,NULL };
  static const struct Hook DirGoPageUp2Hook   =     { { NULL,NULL },(VOID *)DirGoPageUp2, NULL,NULL };
  static const struct Hook DirGoPageDown2Hook   =   { { NULL,NULL },(VOID *)DirGoPageDown2, NULL,NULL };
  static const struct Hook CapGoUpHook    =         { { NULL,NULL },(VOID *)CapGoUp, NULL,NULL };
  static const struct Hook CapGoDownHook    =       { { NULL,NULL },(VOID *)CapGoDown, NULL,NULL };
  static const struct Hook CapGoPageUpHook    =     { { NULL,NULL },(VOID *)CapGoPageUp, NULL,NULL };
  static const struct Hook CapGoPageDownHook    =   { { NULL,NULL },(VOID *)CapGoPageDown, NULL,NULL };
  static const struct Hook TextGoUpHook    =        { { NULL,NULL },(VOID *)TextGoUp, NULL,NULL };
  static const struct Hook TextGoDownHook    =      { { NULL,NULL },(VOID *)TextGoDown, NULL,NULL };
  static const struct Hook TextGoPageUpHook    =    { { NULL,NULL },(VOID *)TextGoPageUp, NULL,NULL };
  static const struct Hook TextGoPageDownHook    =  { { NULL,NULL },(VOID *)TextGoPageDown, NULL,NULL };
  static const struct Hook WinInfosCloseHook    =   { { NULL,NULL },(VOID *)WinInfosClose, NULL,NULL };
  static const struct Hook WinErrorsCloseHook    =  { { NULL,NULL },(VOID *)WinErrorsClose, NULL,NULL };
  static const struct Hook WFindWinOpenHook    =    { { NULL,NULL },(VOID *)WFindWinOpen, NULL,NULL };
  static const struct Hook WFindStringIncrHook =    { { NULL,NULL },(VOID *)WFindStringIncr, NULL,NULL };
  static const struct Hook WFindStringFirstHook =   { { NULL,NULL },(VOID *)WFindStringFirst, NULL,NULL };
  static const struct Hook WFindStringPrecHook =    { { NULL,NULL },(VOID *)WFindStringPrec, NULL,NULL };
  static const struct Hook WFindStringNextHook =    { { NULL,NULL },(VOID *)WFindStringNext, NULL,NULL };
  static const struct Hook WFindStringLastHook =    { { NULL,NULL },(VOID *)WFindStringLast, NULL,NULL };
  static const struct Hook XRefSearchStrIncrHook =  { { NULL,NULL },(VOID *)XRefSearchStrIncr, NULL,NULL };
  static const struct Hook XRefSearchStrHook =      { { NULL,NULL },(VOID *)XRefSearchStr, NULL,NULL };
  static const struct Hook ConfigWinOpenHook    =   { { NULL,NULL },(VOID *)ConfigWinOpen, NULL,NULL };
  static const struct Hook WinXRefSearchOpenHook =  { { NULL,NULL },(VOID *)WinXRefSearchOpen, NULL,NULL };
  static const struct Hook UnLoadxrefHook =         { { NULL,NULL },(VOID *)UnLoadxref, NULL,NULL };
  static const struct Hook LoadxrefHook =           { { NULL,NULL },(VOID *)Loadxref, NULL,NULL };
  static const struct Hook MakexrefHook =           { { NULL,NULL },(VOID *)Makexref, NULL,NULL };
  static const struct Hook StrObjHook =             { { NULL,NULL },(VOID *)StrObjFunc,NULL,NULL };
  static const struct Hook ObjStrHook =             { { NULL,NULL },(VOID *)ObjStrFunc,NULL,NULL };
  static const struct Hook WindowHook =             { { NULL,NULL },(VOID *)WindowFunc,NULL,NULL };
  static const struct Hook ChgeCurrentDrawerHook =  { { NULL,NULL },(VOID *)ChgeCurrentDrawer,NULL,NULL };

  if ((argc >= 2) && (argv[1][0] == '?'))
  {
    puts("adocreader [ALL]  or   adocreader file.doc   or   adocreader [ALL] DIR dirpath\nUse ALL if you don't want only .doc files in dir list\n");
    exit(0);
  }

  init();

  numarg = 0;
  if ((argc >= 2) && !strncmp(argv[1],"ALL",3))
  {
    ParsePatternNoCase("#?",DirPatternToken,20);
    numarg = 1;
  }
  else
    ParsePatternNoCase("#?.doc",DirPatternToken,20);

  /* MUI (3.2) APPLICATION */
  APP_Main = ApplicationObject,
    MUIA_Application_Title      , "ADocReader",
    MUIA_Application_Version    , "$VER: ADocReader "ADRVER" ["__DATE__"]",
    MUIA_Application_Copyright  , "Written by Gilles MASSON, 1996",
    MUIA_Application_Author     , "Gilles MASSON",
    MUIA_Application_Description, "Autodoc Reader based on Dirk Holtwick's MartinsReader1.2",
    MUIA_Application_Base       , "ADOCREADER",

    SubWindow, WIN_Main = WindowObject,
      MUIA_Window_Title, "ADocReader "ADRVER", 1996",
      MUIA_Window_ID   , MAKE_ID('D','W','I','N'),
      MUIA_Window_Menustrip, MN_Strip = MUI_MakeObject(MUIO_MenustripNM,Menu,0),

      WindowContents, VGroup,
        Child, VGroup,
          MUIA_Group_VertSpacing, 1,
          Child, LI_Text = ListviewObject,
            MUIA_VertWeight, 250,
            MUIA_Font,MUIV_Font_Fixed,
            MUIA_Listview_List, NewObject(DXListClass->mcc_Class,NULL,
              MUIA_Background, MUII_TextBack,
              MUIA_Frame, MUIV_Frame_InputList,
              MUIA_List_DisplayHook, &DisplayLI_TextHook,
              TAG_DONE),
            MUIA_Listview_MultiSelect, MUIV_Listview_MultiSelect_Default,
          End,
          Child, PR_Text = PropObject,
            PropFrame,
            MUIA_Prop_Entries, 100,
            MUIA_Prop_First, 0,
            MUIA_Prop_Horiz, TRUE,
            MUIA_Prop_Visible, 80,
            MUIA_FixHeight, 8,
          End,
        End,
        Child, BalanceObject,
          MUIA_ExportID, 2,
        End,
        Child, HGroup,
          MUIA_Weight, 30,
          Child, HGroup,
            Child, LV_Hist = ListviewObject,
              MUIA_Listview_List, ListObject,
                MUIA_Frame, MUIV_Frame_InputList,
                MUIA_List_DisplayHook, &DisplayHistHook,
                MUIA_List_AutoVisible, TRUE,
              End,
            End,
            Child, BalanceObject,
              MUIA_ExportID, 3,
            End,
            Child, VGroup,
              MUIA_Weight, 60,
              MUIA_Group_VertSpacing, 1,
              Child, STR_CurrentDrawer = PopobjectObject,
                MUIA_Font, MUIV_Font_Tiny,
                MUIA_Popstring_String, KeyString(0,60,'n'),
                MUIA_Popstring_Button, PopButton(MUII_PopUp),
                MUIA_Popobject_StrObjHook, &StrObjHook,
                MUIA_Popobject_ObjStrHook, &ObjStrHook,
                MUIA_Popobject_WindowHook, &WindowHook,
                MUIA_Popobject_Object, LI_CurrentDrawer = ListviewObject,
                  MUIA_Listview_List, ListObject,
                    InputListFrame,
                    /*MUIA_List_SourceArray, PopNames,*/
                  End,
                End,
              End,

              Child, LV_Dir = ListviewObject,
                MUIA_Listview_List, DirlistObject,
                  MUIA_Frame, MUIV_Frame_InputList,
                  MUIA_Dirlist_AcceptPattern, DirPatternToken,
                  MUIA_Dirlist_FilesOnly, TRUE,
                  MUIA_List_AutoVisible, TRUE,
                End,
              End,
            End,
          End,
          Child, BalanceObject,
            MUIA_ExportID, 4,
          End,
          Child, LV_Cap = ListviewObject,
            MUIA_Weight, 60,
            MUIA_Listview_List, ListObject,
              MUIA_Frame, MUIV_Frame_InputList,
              MUIA_List_DisplayHook, &DisplayCapHook,
              MUIA_List_AutoVisible, TRUE,
            End,
          End,
        End,
      End,
    End,

    SubWindow, WIN_XRefSearch = WindowObject,
      MUIA_Window_Title, "Search XRef",
      MUIA_Window_ID   , MAKE_ID('S','W','I','N'),

      WindowContents, VGroup,
        Child, HGroup,
          GroupFrame,
          Child, ColGroup(12),
            Child, CK_XS_Case = CheckMark(FALSE), Child, Label1("_Case Sensit." ),
            Child, HSpace(0),
            Child, MUI_MakeObject(MUIO_VBar,2),
            Child, HSpace(0),
            Child, CK_XS_Incr = CheckMark(FALSE), Child, Label1("_Incr. Search" ),
            Child, HSpace(0),
            Child, MUI_MakeObject(MUIO_VBar,2),
            Child, HSpace(0),
            Child, CK_XS_PartOf = CheckMark(FALSE), Child, Label1("_Part of" ),
          End,
        End,
        Child, STR_XRefSearch = StringObject,
          StringFrame,
        End,
        Child, LV_XRefSearch = ListviewObject,
          MUIA_Listview_List, ListObject,
            MUIA_Frame, MUIV_Frame_InputList,
            MUIA_List_DisplayHook, &DisplayXRefHook,
            MUIA_List_AutoVisible, TRUE,
          End,
        End,
      End,
    End,

    SubWindow, WIN_WFind = WindowObject,
      MUIA_Window_Title, "Find word",
      MUIA_Window_ID   , MAKE_ID('F','W','I','N'),

      WindowContents, VGroup,
        Child, VGroup,
          GroupFrame,
          Child, CY_FindType = Cycle(CY_FindTypeStr),
          Child, HGroup,
            Child, ColGroup(7),
              Child, CK_WF_Case = CheckMark(FALSE), Child, Label1("_Case Sensit." ),
              Child, HSpace(0),
              Child, MUI_MakeObject(MUIO_VBar,2),
              Child, HSpace(0),
              Child, CK_WF_Incr = CheckMark(TRUE), Child, Label1("_Incr. Search" ),
            End,
          End,
        End,
        Child, HGroup,
          MUIA_Group_SameWidth, TRUE,
          Child, BT_WF_First = SimpleButton("_First"),
          Child, BT_WF_Prec  = SimpleButton("_Back"),
          Child, BT_WF_Next  = SimpleButton("_Next"),
          Child, BT_WF_Last  = SimpleButton("_Last"),
        End,
        Child, STR_WFind = StringObject,
          StringFrame,
        End,
      End,
    End,

    SubWindow, WIN_Config = WindowObject,
      MUIA_Window_Title, "ADocReader Config",
      MUIA_Window_ID   , MAKE_ID('C','W','I','N'),
      WindowContents, VGroup,
        Child, ListviewObject,
          MUIA_Listview_Input, FALSE,
          MUIA_Listview_List, FloattextObject,
            MUIA_Frame, MUIV_Frame_ReadList,
            MUIA_Floattext_TabSize, 2,
            MUIA_Floattext_Text,
              "\tThe XRef file is use to load all names and their positions in Autodoc and Include files.\n"
              "\tAutodoc drawers are the drawers containing autodoc files used to make the xref file.\n"
              "\tInclude drawers are the drawers containing include files used to make the xref file.\n",
          End,
        End,
        Child, VGroup,
          GroupFrameT("Default Starting Drawer"),
          PopStringDrawer(STR_DefaultDrawer,1),
        End,
        Child, HGroup,
          Child, VGroup,
            GroupFrameT("Autodocs Dirs"),
            PopStringDrawer(STR_ADocDrawer1,10),
            PopStringDrawer(STR_ADocDrawer2,11),
            PopStringDrawer(STR_ADocDrawer3,12),
            PopStringDrawer(STR_ADocDrawer4,13),
          End,
          Child, VGroup,
            GroupFrameT("Includes Dirs"),
            PopStringDrawer(STR_IncDrawer1,14),
            PopStringDrawer(STR_IncDrawer2,15),
            PopStringDrawer(STR_IncDrawer3,16),
            PopStringDrawer(STR_IncDrawer4,17),
          End,
        End,
        Child, VGroup,
          GroupFrameT("XRefs File"),
          PopStringFile(STR_XRefFile,18),
          Child, HGroup,
            MUIA_Group_SameWidth, TRUE,
            Child, BT_UnLoadxref = SimpleButton("_UnLoad XRef"),
            Child, BT_Loadxref = SimpleButton("_Load XRef"),
            Child, BT_Makexref = SimpleButton("_Make Xref"),
          End,
        End,
        Child, HGroup,
          Child, VGroup,
            GroupFrameT("AutoDoc Entries File"),
            PopStringFile(STR_ADocFile,19),
          End,
          Child, VGroup,
            GroupFrameT("Dir List File"),
            PopStringFile(STR_DirListFile,20),
          End,
        End,
      End,
    End,

    SubWindow, WIN_Infos = WindowObject,
      MUIA_Window_Title, "ADocReader Infos",
      MUIA_Window_ID   , MAKE_ID('1','W','I','N'),

      WindowContents, VGroup,
        Child, VGroup, GroupFrameT("Infos"),
          Child, TXT_Infos = TextObject,
            MUIA_Text_Contents, "nothing.",
            MUIA_Text_PreParse, "\33c",
            MUIA_Text_SetVMax, FALSE,
          End,
        End,
      End,
    End,

    SubWindow, WIN_Errors = WindowObject,
      MUIA_Window_Title, "ADocReader Errors",
      MUIA_Window_ID   , MAKE_ID('2','W','I','N'),

      WindowContents, VGroup,
        Child, VGroup, GroupFrameT("Errors"),
          Child, TXT_Errors = TextObject,
            MUIA_Text_Contents, "nothing.",
            MUIA_Text_PreParse, "\33c",
            MUIA_Text_SetVMax, FALSE,
          End,
        End,
      End,
    End,

  End;

  if(!APP_Main) fail(APP_Main,"Failed to create Application.");

  DoMethod(BT_UnLoadxref ,MUIM_Notify,MUIA_Pressed,FALSE,
    BT_UnLoadxref ,2, MUIM_CallHook, &UnLoadxrefHook);
  DoMethod(BT_Loadxref ,MUIM_Notify,MUIA_Pressed,FALSE,
    BT_Loadxref ,2, MUIM_CallHook, &LoadxrefHook);
  DoMethod(BT_Makexref ,MUIM_Notify,MUIA_Pressed,FALSE,
    BT_Makexref ,2, MUIM_CallHook, &MakexrefHook);

  DoMethod((Object *)
    DoMethod(MN_Strip,MUIM_FindUData,MEN_XREF),MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,
    WIN_XRefSearch, 2, MUIM_CallHook, &WinXRefSearchOpenHook);
  DoMethod(WIN_XRefSearch,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    WIN_XRefSearch  ,3,MUIM_Set,MUIA_Window_Open,FALSE);

  DoMethod((Object *)
    DoMethod(MN_Strip,MUIM_FindUData,MEN_FIND),MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,
    WIN_WFind, 2, MUIM_CallHook, &WFindWinOpenHook);
  DoMethod(WIN_WFind,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    WIN_WFind  ,3,MUIM_Set,MUIA_Window_Open,FALSE);

  DoMethod(CK_XS_Incr,MUIM_Notify,MUIA_Selected, MUIV_EveryTime,
    WIN_XRefSearch, 3,MUIM_Set, MUIA_Window_ActiveObject, STR_XRefSearch);
  DoMethod(CK_XS_Case,MUIM_Notify,MUIA_Selected, MUIV_EveryTime,
    STR_XRefSearch, 2, MUIM_CallHook, &XRefSearchStrHook);
  DoMethod(CK_XS_PartOf,MUIM_Notify,MUIA_Selected, MUIV_EveryTime,
    STR_XRefSearch, 2, MUIM_CallHook, &XRefSearchStrHook);
  DoMethod(STR_XRefSearch,MUIM_Notify,MUIA_String_Contents, MUIV_EveryTime,
    STR_XRefSearch, 2, MUIM_CallHook, &XRefSearchStrIncrHook);
  DoMethod(STR_XRefSearch,MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
    STR_XRefSearch, 2, MUIM_CallHook, &XRefSearchStrHook);

  DoMethod(BT_WF_First,MUIM_Notify,MUIA_Pressed,FALSE,
    STR_WFind ,2, MUIM_CallHook, &WFindStringFirstHook);
  DoMethod(BT_WF_Prec,MUIM_Notify,MUIA_Pressed,FALSE,
    STR_WFind ,2, MUIM_CallHook, &WFindStringPrecHook);
  DoMethod(BT_WF_Next,MUIM_Notify,MUIA_Pressed,FALSE,
    STR_WFind ,2, MUIM_CallHook, &WFindStringNextHook);
  DoMethod(BT_WF_Last,MUIM_Notify,MUIA_Pressed,FALSE,
    STR_WFind ,2, MUIM_CallHook, &WFindStringLastHook);
  DoMethod(STR_WFind,MUIM_Notify,MUIA_String_Contents, MUIV_EveryTime,
    STR_WFind, 2, MUIM_CallHook, &WFindStringIncrHook);
  DoMethod(STR_WFind,MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
    STR_WFind, 2, MUIM_CallHook, &WFindStringNextHook);

  DoMethod((Object *)
    DoMethod(MN_Strip,MUIM_FindUData,MEN_CONFIG),MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,
    WIN_Config, 2, MUIM_CallHook, &ConfigWinOpenHook);
  DoMethod(WIN_Config,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    WIN_Config, 3,MUIM_Set,MUIA_Window_Open,FALSE);

  DoMethod(WIN_Infos,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    WIN_Infos, 2, MUIM_CallHook, &WinInfosCloseHook);

  DoMethod(WIN_Errors,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    WIN_Errors, 2, MUIM_CallHook, &WinErrorsCloseHook);

  DoMethod(LI_Text, MUIM_Notify,MUIA_DXList_AfterDraw,MUIV_EveryTime,
    LI_Text, 2, MUIM_CallHook, &PR_TextSetHook);
  DoMethod(PR_Text, MUIM_Notify, MUIA_Prop_First,MUIV_EveryTime,
    PR_Text, 2, MUIM_CallHook, &PR_TextChangeHook);

  DoMethod(LI_Text, MUIM_Notify,MUIA_DXList_DClick,MUIV_EveryTime,
    LI_Text, 2, MUIM_CallHook, &FindXRefHook);

  DoMethod(LV_Hist, MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,
    LV_Hist, 2, MUIM_CallHook, &HistFoundHook);

  DoMethod(LV_XRefSearch, MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
    LV_XRefSearch, 2, MUIM_CallHook, &XRefFoundHook);

  DoMethod(WIN_Main,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
    APP_Main,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
  DoMethod(LV_Dir, MUIM_Notify, MUIA_List_Active,MUIV_EveryTime,
    LV_Dir, 2, MUIM_CallHook, &DirFoundHook);
  DoMethod(LV_Cap, MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,
    LV_Cap, 2, MUIM_CallHook, &CapFoundHook);
  DoMethod((Object *)
    DoMethod(MN_Strip,MUIM_FindUData,MEN_INFO),MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,
    WIN_Main,3,MUIM_CallHook,&AppInfoHook,MUIV_TriggerValue);
  DoMethod((Object *)
    DoMethod(MN_Strip,MUIM_FindUData,MEN_HELP),MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,
    WIN_Main,3,MUIM_CallHook,&HelpInfoHook,MUIV_TriggerValue);
  DoMethod((Object *)
    DoMethod(MN_Strip,MUIM_FindUData,MEN_COPY),MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,
    WIN_Main,3,MUIM_CallHook,&CopyClipHook,MUIV_TriggerValue);
  DoMethod((Object *)
    DoMethod(MN_Strip,MUIM_FindUData,MEN_SELALL),MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,
    LI_Text,4,MUIM_List_Select,MUIV_List_Select_All,MUIV_List_Select_On,NULL);
  DoMethod((Object *)
    DoMethod(MN_Strip,MUIM_FindUData,MEN_PRINTSEL),MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,
    WIN_Main,3,MUIM_CallHook,&PrintSelectHook,MUIV_TriggerValue);
  DoMethod(STR_DefaultDrawer,MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
    LV_Dir, 2, MUIM_CallHook, &StartStateHook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt left",
    WIN_Main, 2, MUIM_CallHook, &DirGoUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt right",
    WIN_Main, 2, MUIM_CallHook, &DirGoDownHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt shift left",
    WIN_Main, 2, MUIM_CallHook, &DirGoPageUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt shift right",
    WIN_Main, 2, MUIM_CallHook, &DirGoPageDownHook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat numpad 7",
    WIN_Main, 2, MUIM_CallHook, &DirGoUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat numpad 1",
    WIN_Main, 2, MUIM_CallHook, &DirGoDownHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat shift numpad 7",
    WIN_Main, 2, MUIM_CallHook, &DirGoPageUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat shift numpad 1",
    WIN_Main, 2, MUIM_CallHook, &DirGoPageDownHook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "numpad 4",
    WIN_Main, 2, MUIM_CallHook, &DirFoundHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "shift numpad 4",
    WIN_Main, 2, MUIM_CallHook, &DirFoundHook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt numpad 7",
    WIN_Main, 2, MUIM_CallHook, &DirGoUp2Hook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt numpad 1",
    WIN_Main, 2, MUIM_CallHook, &DirGoDown2Hook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt shift numpad 7",
    WIN_Main, 2, MUIM_CallHook, &DirGoPageUp2Hook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt shift numpad 1",
    WIN_Main, 2, MUIM_CallHook, &DirGoPageDown2Hook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt up",
    WIN_Main, 2, MUIM_CallHook, &CapGoUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt down",
    WIN_Main, 2, MUIM_CallHook, &CapGoDownHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt shift up",
    WIN_Main, 2, MUIM_CallHook, &CapGoPageUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "alt shift down",
    WIN_Main, 2, MUIM_CallHook, &CapGoPageDownHook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat numpad 8",
    WIN_Main, 2, MUIM_CallHook, &CapGoUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat numpad  2",
    WIN_Main, 2, MUIM_CallHook, &CapGoDownHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat shift numpad 8",
    WIN_Main, 2, MUIM_CallHook, &CapGoPageUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat shift numpad 2",
    WIN_Main, 2, MUIM_CallHook, &CapGoPageDownHook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat numpad 9",
    WIN_Main, 2, MUIM_CallHook, &TextGoUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat numpad 3",
    WIN_Main, 2, MUIM_CallHook, &TextGoDownHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat numpad 5",
    WIN_Main, 2, MUIM_CallHook, &TextGoPageUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat numpad 6",
    WIN_Main, 2, MUIM_CallHook, &TextGoPageDownHook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat shift numpad 9",
    WIN_Main, 2, MUIM_CallHook, &TextGoPageUpHook);
  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "-repeat shift numpad 3",
    WIN_Main, 2, MUIM_CallHook, &TextGoPageDownHook);

  DoMethod(WIN_Main,MUIM_Notify, MUIA_Window_InputEvent, "f4",
    WIN_Main,3,MUIM_CallHook,&CopyClipHook,MUIV_TriggerValue);

  DoMethod(LI_CurrentDrawer,MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,
    STR_CurrentDrawer,2,MUIM_Popstring_Close,TRUE);
  DoMethod(STR_CurrentDrawer,MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
    LV_Dir, 2, MUIM_CallHook, &ChgeCurrentDrawerHook);

  DoMethod(WIN_Main,MUIM_Window_SetCycleChain,
            LI_Text,PR_Text,LV_Hist,LV_Dir,LV_Cap,STR_CurrentDrawer,NULL);

  DoMethod(WIN_XRefSearch,MUIM_Window_SetCycleChain,
            CK_XS_Case,CK_XS_Incr,CK_XS_PartOf,STR_XRefSearch,LV_XRefSearch,NULL);

  DoMethod(WIN_WFind,MUIM_Window_SetCycleChain,
            CY_FindType,CK_WF_Case,CK_WF_Incr,BT_WF_First,BT_WF_Prec,
            BT_WF_Next,BT_WF_Last,STR_WFind,NULL);

  DoMethod(WIN_Config,MUIM_Window_SetCycleChain,
            STR_DefaultDrawer,STR_ADocDrawer1,STR_ADocDrawer2,STR_ADocDrawer3,STR_ADocDrawer4,
            STR_IncDrawer1,STR_IncDrawer2,STR_IncDrawer3,STR_IncDrawer4,STR_XRefFile,
            BT_UnLoadxref,BT_Loadxref,BT_Makexref,STR_ADocFile,STR_DirListFile,NULL);

  MainText = NULL;
  DoMethod(APP_Main,MUIM_Application_Load,MUIV_Application_Load_ENVARC);

  if (argc == 2+numarg)
    StartFileName = argv[1+numarg];
  else if ((argc == 3+numarg) && !strncmp(argv[1+numarg],"DIR",3))    /* 'DIR' option */
    StartDirName = argv[2+numarg];

  StartState();

  restarthistory();

  set(WIN_Main,MUIA_Window_Open,TRUE);
  set(WIN_Main, MUIA_Window_ActiveObject, LI_Text);
  set(WIN_Main, MUIA_Window_DefaultObject, LI_Text);

  {
    ULONG sigs = 0;

    while (DoMethod(APP_Main,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit){
      if (sigs){
        sigs = Wait(sigs | SIGBREAKF_CTRL_C);
        if (sigs & SIGBREAKF_CTRL_C) break;
      }
    }
  }

  DoMethod(APP_Main,MUIM_Application_Save,MUIV_Application_Save_ENVARC);
  set(WIN_Main,MUIA_Window_Open,FALSE);
  fail(APP_Main,NULL);
}




static void SearchXRef(void)
{
  if (XRefArray)
  {
    long   curnum, num;
    char realname[200];

    FindindXRef = TRUE;
    set(APP_Main,MUIA_Application_Sleep,TRUE );
    curnum = SearchNameCase(FindWord,&num);
    set(APP_Main,MUIA_Application_Sleep,FALSE );

    if (num != 1)
    {
      WinXRefSearchOpen();
      set(LV_XRefSearch, MUIA_List_Quiet, TRUE);
      nnset(STR_XRefSearch, MUIA_String_Contents, FindWord);
      DoMethod(LV_XRefSearch, MUIM_List_Clear);
      while ((curnum <= XRefArrayLast) && (num > 0))
      {
        DoMethod(LV_XRefSearch, MUIM_List_InsertSingle, XRefArray[curnum], MUIV_List_Insert_Bottom);
        curnum++;
        num--;
      }
      set(LV_XRefSearch, MUIA_List_Quiet, FALSE);
    }
    else
    {
      addhist(XRefArray[curnum]);
    }
  }
  FindindXRef = FALSE;
}


/*
 * Write a string to the clipboard
 */
static int WriteClip(char *string)
{
  struct IOClipReq *ior;
  if (string == NULL)
  {
    puts("No string argument given");
    return(0L);
  }
  /* Open clipboard.device unit 0 */
  if (ior = CBOpen(0L))
  {
    if (!(CBWriteFTXT(ior,string)))
    {
      PrintError("Error writing to clipboard: io_Error = %ld\n",ior->io_Error);
    }
    CBClose(ior);
  }
  else
  {
    puts("Error opening clipboard.device");
  }
  return(0);
}
