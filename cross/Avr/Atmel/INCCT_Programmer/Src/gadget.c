/***************************************************************************/
/* INCCT GUI V1.00                                                         */
/* A quickly put together GUI for the Atmel in circuit programmer.         */
/* 1999 LJS                                                                */
/***************************************************************************/

#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <devices/parallel.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/alib_protos.h>

#include <stdio.h>

#include "globdefs.h"

#define MYGAD_STRING1   (1)
#define MYGAD_FILENAME  (2)
#define MYGAD_BUTTON    (3)
#define MYGAD_PROGRAM   (4)
#define MYGAD_LOCK      (5)
#define MYGAD_READF     (6)
#define MYGAD_EEPROM    (7)
#define MAXGADS 8           /*number of gadgets + 1*/

void errorMessage(STRPTR error, int Err);
VOID handleGadgetEvent(struct Window *win, struct Gadget *gad, UWORD code,
    struct Gadget *my_gads[]);
VOID handleVanillaKey(struct Window *win, UWORD code,
    struct Gadget *my_gads[]);
int createAllGadgets(struct Gadget **glistptr, void *vi,
    UWORD topborder, struct Gadget *my_gads[]);
VOID process_window_events(struct Window *mywin, struct Gadget *my_gads[]);
VOID gadtoolsWindow(VOID);
void StartProgram(BYTE X);
void StartRead(void);
void FreeParallel(void);
int SaveParallel(void);

extern char FileName[];
char Lock=0;

char Vers[]="$VER:INCCT AVR Programmer "VERSION;

struct EasyStruct myES = {
    sizeof(struct EasyStruct),
    0,
    "Error",
    "%s %ld",
    "OK"
};

struct TextAttr Topaz80 = { "topaz.font", 8, 0, 0, };

struct Library      *IntuitionBase;
struct Library      *GfxBase;
struct Library      *GadToolsBase;
struct MsgPort      *ParallelMP=NULL; 
struct IOExtPar     *ParallelIO=NULL; 

struct Screen   *mysc;      /* The screen we are on */

int main(int argc, char *argv[])
{

  FileName[0]=0;
    
if (NULL == (IntuitionBase = OpenLibrary("intuition.library", 37)))
{ 
  printf("Can't open intuition.library V37 !!!!\n");
   /*What else can we do?*/
}
else
{
  if(!create_timer())
    errorMessage( "Can't open timer.device",0);
  else
  {
    if(!SaveParallel())
      errorMessage("Can't open parallel.device",0);    
    else
    {
      if (NULL == (GfxBase = OpenLibrary("graphics.library", 37)))
        errorMessage( "Requires V37 graphics.library",0);
      else
      {
        if (NULL == (GadToolsBase = OpenLibrary("gadtools.library", 37)))
          errorMessage( "Requires V37 gadtools.library",0);
        else
        {
          if(argc>1)
          {
            Program_It(argc,argv);
          }
          else
          {
            gadtoolsWindow();
          }
          CloseLibrary(GadToolsBase);
        }
        CloseLibrary(GfxBase);
      }
      CloseDevice((struct IORequest *)ParallelIO);
      FreeParallel();
    }
    delete_timer();
  }
  CloseLibrary(IntuitionBase);
}
  return 1;
}


void errorMessage(STRPTR error, int Err)
{
  if (error)
  {
    EasyRequest(NULL, &myES, NULL, error, Err);
  }
}

VOID handleGadgetEvent(struct Window *win, struct Gadget *gad, UWORD code,
    struct Gadget *my_gads[])
{
  switch (gad->GadgetID)
  {
    case MYGAD_FILENAME:
        strcpy(FileName,  ((struct StringInfo *)gad->SpecialInfo)->Buffer);
        break;

    case MYGAD_BUTTON: if (FileRequest())
                       {
                        GT_SetGadgetAttrs(my_gads[MYGAD_FILENAME], win, NULL,
                            GTST_String,   FileName,
                            TAG_END);
                       }
                      break;

    case MYGAD_PROGRAM:
         StartProgram(1);
         break;

    case MYGAD_READF:
          StartRead();
          break;

    case MYGAD_EEPROM:
         StartProgram(2);
         break;

    case MYGAD_LOCK:
         {
           Lock^=1;
         }
         break;
  }
}


VOID handleVanillaKey(struct Window *win, UWORD code, struct Gadget *my_gads[])
{

  switch (code)
  {
    case 's':
    case 'S':
        ActivateGadget(my_gads[MYGAD_FILENAME], win, NULL);
        break;

    case 'w':
    case 'W':
         StartProgram(2);
         break;

    case 'c':
    case 'C':
         if (FileRequest())
         {
           GT_SetGadgetAttrs(my_gads[MYGAD_FILENAME], win, NULL,
                             GTST_String,   FileName,
                            TAG_END);
         }
        break;
    case 'l':
    case 'L':
        Lock^=1;
        if(Lock)
        {
          GT_SetGadgetAttrs(my_gads[MYGAD_LOCK],win,NULL,GTCB_Checked,TRUE,TAG_END);
        }
        else
        {
          GT_SetGadgetAttrs(my_gads[MYGAD_LOCK],win,NULL,GTCB_Checked,FALSE,TAG_END);
        }
        break;
    case 'p':
    case 'P':
        StartProgram(1);
        break;
  
    case 'r':
    case 'R':
        StartRead();
        break;
  }
}


int createAllGadgets(struct Gadget **glistptr, void *vi,
    UWORD topborder, struct Gadget *my_gads[])
{
struct NewGadget ng;
struct Gadget *gad;

gad = CreateContext(glistptr);

ng.ng_LeftEdge   = 100;
ng.ng_TopEdge    = 10+topborder;
ng.ng_Width      = 200;
ng.ng_Height     = 12;
ng.ng_TextAttr   = &Topaz80;
/* ng.ng_TextAttr   = mysc->Font; */
ng.ng_VisualInfo = vi;
ng.ng_GadgetText = "";
ng.ng_Flags      = NG_HIGHLABEL;
ng.ng_GadgetID   = MYGAD_STRING1;
my_gads[MYGAD_STRING1] = gad = CreateGadget(TEXT_KIND, gad, &ng,
                    GTTX_Text,   "ATMEL In Circuit Programmer.",
                    GTTX_Border, FALSE,
                    TAG_END);
if(gad == NULL) return 1;

ng.ng_TopEdge   += 15;
ng.ng_Width      = 200;
ng.ng_GadgetText = "_S Record:";
ng.ng_GadgetID   = MYGAD_FILENAME;
my_gads[MYGAD_FILENAME] = gad = CreateGadget(STRING_KIND, gad, &ng,
                    GTST_String,   FileName,
                    GTST_MaxChars, 256,
                    GT_Underscore, '_',
                    TAG_END);
if(gad == NULL) return 2;

ng.ng_TopEdge   += 20;
ng.ng_LeftEdge   = 20;
ng.ng_Width      = 100;
ng.ng_Height     = 12;
ng.ng_GadgetText = "Select _code";
ng.ng_GadgetID   = MYGAD_BUTTON;
ng.ng_Flags      = 0;
my_gads[MYGAD_BUTTON] = gad = CreateGadget(BUTTON_KIND, gad, &ng,
                    GT_Underscore, '_',
                    TAG_END);
if(gad == NULL) return 3;

ng.ng_LeftEdge  += 120;
ng.ng_Width      = 100;
ng.ng_Height     = 12;
ng.ng_GadgetText = "_Program";
ng.ng_GadgetID   = MYGAD_PROGRAM;
my_gads[MYGAD_PROGRAM] = gad = CreateGadget(BUTTON_KIND, gad, &ng,
                    GT_Underscore, '_',
                    TAG_END);
if(gad == NULL) return 4;

ng.ng_LeftEdge  += 170;
ng.ng_Height     = 12;
ng.ng_GadgetText = "_Lock";
ng.ng_GadgetID   = MYGAD_LOCK;
my_gads[MYGAD_LOCK] = gad = CreateGadget(CHECKBOX_KIND, gad, &ng,GT_Underscore, '_',
                    TAG_END);
if(gad == NULL) return 5;

ng.ng_LeftEdge  -= 170;
ng.ng_TopEdge   += 20;
ng.ng_GadgetText = "_Read Flash";
ng.ng_GadgetID   = MYGAD_READF;
my_gads[MYGAD_READF] = gad = CreateGadget(BUTTON_KIND, gad, &ng,
                    GT_Underscore, '_',
                    TAG_END);
if(gad == NULL) return 6;

ng.ng_LeftEdge  -= 120;
ng.ng_GadgetText = "_Write EEPROM";
ng.ng_GadgetID   = MYGAD_EEPROM;
my_gads[MYGAD_EEPROM] = gad = CreateGadget(BUTTON_KIND, gad, &ng,
                    GT_Underscore, '_',
                    TAG_END);
if(gad == NULL) return 7;

return 0;
}

VOID process_window_events(struct Window *mywin, struct Gadget *my_gads[])
{
  struct IntuiMessage *imsg;
  ULONG imsgClass;
  UWORD imsgCode;
  struct Gadget *gad;
  BOOL terminated = FALSE;

  while (!terminated)
  {
    Wait (1 << mywin->UserPort->mp_SigBit);

    while ( (!terminated) && (imsg = GT_GetIMsg(mywin->UserPort)) )
    {
      gad = (struct Gadget *)imsg->IAddress;

      imsgClass = imsg->Class;
      imsgCode = imsg->Code;

      GT_ReplyIMsg(imsg);

      switch (imsgClass)
      {
        case IDCMP_GADGETDOWN:
       /* case IDCMP_MOUSEMOVE:*/
        case IDCMP_GADGETUP:
                 handleGadgetEvent(mywin, gad, imsgCode, my_gads);
                        break;
        case IDCMP_VANILLAKEY:
                handleVanillaKey(mywin, imsgCode, my_gads);
                break;
        case IDCMP_CLOSEWINDOW:
                terminated = TRUE;
                break;
        case IDCMP_REFRESHWINDOW:
                GT_BeginRefresh(mywin);
                GT_EndRefresh(mywin, TRUE);
                break;
      }
    }
  }
}

VOID gadtoolsWindow(VOID)
{
struct Window   *mywin;
struct Gadget   *glist, *my_gads[MAXGADS];
void            *vi;
UWORD           topborder;
int Err;

  if (NULL == (mysc = LockPubScreen(NULL)))
  {
    errorMessage( "Couldn't lock default public screen",0);
  }
  else
  {
    if (NULL == (vi = GetVisualInfo(mysc, TAG_END)))
    {
      errorMessage( "GetVisualInfo() failed",0);
    }
    else
    {
      topborder = mysc->WBorTop + (mysc->Font->ta_YSize + 1);

      if (Err = createAllGadgets(&glist, vi, topborder, my_gads))
      {
        errorMessage( "createAllGadgets() failed", Err);
      }
      else
      {
        mywin = OpenWindowTags(NULL,
                     WA_Title,     "INCCT "VERSION" ©2000 LJS",
                     WA_Gadgets,   glist,      WA_AutoAdjust,    TRUE,
                     WA_Width,       400,      WA_MinWidth,        50,
                     WA_InnerHeight, 80,      WA_MinHeight,       50,
                     WA_DragBar,    TRUE,      WA_DepthGadget,   TRUE,
                     WA_Activate,   TRUE,      WA_CloseGadget,   TRUE,
                     WA_SizeGadget, FALSE,      WA_SimpleRefresh, TRUE,
                     WA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW |
                         IDCMP_VANILLAKEY | SLIDERIDCMP | STRINGIDCMP |
                         BUTTONIDCMP,
                     WA_PubScreen, mysc,
                     TAG_END);
        if(mywin == NULL)
        { 
          errorMessage( "OpenWindow() failed",0);
        }
        else
        {
          GT_RefreshWindow(mywin, NULL);

          process_window_events(mywin, my_gads);
          CloseWindow(mywin);
        }
      }
      FreeGadgets(glist);
      FreeVisualInfo(vi);
    }
    UnlockPubScreen(NULL, mysc);
  }
}

void StartProgram(BYTE X)
{
  char *Args[3];
  BYTE Aargc=2;
  switch(X)
  {
    case 1:
      if(Lock)
      {
        Args[2]="-l";
        Aargc=3;
      }
      break;

    case 2:
      Args[2]="-ee";
      Aargc=3;
      break;
 
    default:
      break;
  }

  Args[0]="";
  Args[1]=FileName;
  Program_It(Aargc,Args);
}

void StartRead(void)
{
  char *Args[3];
  Args[0]="";
  Args[1]=FileName;
  Args[2]="-r";
  Program_It(3,Args);
}

int SaveParallel(void)
{
  if (ParallelMP=CreatePort(0,0) )
  {
    if (ParallelIO=(struct IOExtPar *)
        CreateExtIO(ParallelMP,sizeof(struct IOExtPar)) )
    {
      if (OpenDevice(PARALLELNAME,0L,(struct IORequest *)ParallelIO,0) )
      {
        return 0;
      }
      else
      {
        return 1;
      }
    }
  }
}

void FreeParallel(void)
{
  if(ParallelIO) DeleteExtIO((struct IORequest*)ParallelIO);
  if(ParallelMP) DeletePort(ParallelMP);
}
