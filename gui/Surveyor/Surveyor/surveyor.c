/*  char *Cr="Surveyor 1.0  13 April 1988 by Dirk Reisig\n";  */

/*  Surveyor displays the pointer position relative to the screens
 *  upperleftmost and to a free postionable point and it shows the
 *  color the pointer is on. It does it on all intuition screens
 *  that are frontmost. (and somtimes trashing them).
 *  
 *  This program may be freely distributed.
 */

#include "exec/types.h"
#include "intuition/intuition.h"
#include "intuition/intuitionbase.h"
#include "graphics/rastport.h"

#define HWEXTRA		8		
#define VWEXTRA		4		
#define MOUSESPEED	4		
#define IB		IntuitionBase	

/* I tried a higher value (8) for the mouse speed. It resulted in a
 * very strange behavior. The pointer was attracted by the
 * lower right corner. A interference problem?
 */

typedef struct mousepointerdescriptor{
  USHORT *Pointer;
  int Height, Width, XOffset, YOffset;
} MousePtr;

extern void PutWindowAway(), ChangePrefs(), ChangePointer();
extern char *RAdCi_d(); 
extern struct Window *OpenWindow();
extern short EmptyData[], CrossData[];
extern struct IntuiMessage *GetMsg();

struct IB *IB;
struct Window *W;
MousePtr Empty={ EmptyData, 0, 0, 0, 0 };
MousePtr Cross={ CrossData,15,15,-8,-7 };

char  TxAbs[]="A          ";
char  TxRel[]="R          ";
char  TxCol[]="Color      ";
char TxWTtl[]="Q    X    Y";

struct IntuiText  ITAbs={ 1,0,JAM2,HWEXTRA/2,0,0,TxAbs,     0 };
struct IntuiText  ITRel={ 1,0,JAM2,HWEXTRA/2,0,0,TxRel,&ITAbs };
struct IntuiText  ITCol={ 1,0,JAM2,HWEXTRA/2,0,0,TxCol,&ITRel };
struct IntuiText ITWTtl={ 1,0,JAM2,0,0,0,TxWTtl,0 };

struct Gadget GClose={ 
  0,0,0,0,10,GADGHCOMP,TOGGLESELECT,BOOLGADGET,0,0,0,0,0,0,0
};

struct NewWindow NW={
  0,0,0,0,-1,-1,
  MOUSEBUTTONS,
  WINDOWDRAG | NOCAREREFRESH | RMBTRAP ,
  0,0,TxWTtl,0,0,0,0,0,0,0
};


_main()
{
  register short NowX, NowY, DynaCol, StatX, StatY, DynaX, DynaY;
  short StatCol, MouseButton;
  short PrintX=-1, PrintY=-1, PrintCol=-1, PrintStat=-1;
  short Cycle=0, DisplayDots=0, WP=0;
  register struct Screen *FS=0;
  register struct IntuiMessage *Mesg; /* No register as promised */
  
  if (!(IB=(struct IB *)OpenLibrary("intuition.library",0))) return(0);
  while (1){
    if (FS!=IB->FirstScreen){
      Forbid();
      FS=IB->FirstScreen;
      if (!GetNewWindow(FS)) break;
      Permit();
      StatX=0;  StatY=0;
      DisplayDots=0;
      ChangePrefs(0);
    }
    if (IB->FirstScreen->LayerInfo.top_layer!=W->WLayer){
      Forbid();   /* Our window is not firstmost */
      if (FS==IB->FirstScreen)  WindowToFront(W);
      Permit();
    }
    NowX=FS->MouseX;  NowY=FS->MouseY;
    MouseButton=0;    
    if (Mesg=GetMsg(W->UserPort)){   
      if (Mesg->Class==MOUSEBUTTONS) MouseButton=Mesg->Code;
      ReplyMsg(Mesg);
    }
    if (MouseButton==MENUDOWN){  /* From spritepointer to dot? */
      DynaCol=GetDotColor(NowX,NowY);
      StatCol=GetDotColor(StatX,StatY);
      DynaX=NowX;  DynaY=NowY;
      ChangePrefs(1);  
      DisplayDots=1;   
    }
    if (DisplayDots){
      if (MouseButton==SELECTDOWN){ /* Replace relative point? */
        SetDotColor(StatX,StatY,StatCol);
        StatX=NowX;  StatY=NowY;
        StatCol=DynaCol;
        PrintStat=1;
      }
      if ((NowX!=DynaX)||(NowY!=DynaY)){  /* Pointer moved? */
        SetDotColor(DynaX,DynaY,DynaCol);
        DynaX=NowX;  DynaY=NowY;
        DynaCol=GetDotColor(DynaX,DynaY);
      }
      /* (++Cycle)%=(1<<FS->BitMap.Depth); should be, but is inherent */
      ++Cycle;
      SetDotColor(DynaX,DynaY,Cycle);
      SetDotColor(StatX,StatY,Cycle);
      if (MouseButton==MENUUP){          /* Back to spritepointer? */
        SetDotColor(DynaX,DynaY,DynaCol);
        SetDotColor(StatX,StatY,StatCol);
        ChangePrefs(0);
        DisplayDots=0;
      }
    } else{ /* !DisplayDots */
      DynaCol=GetDotColor(NowX,NowY); /* Did color change under pointer? */
      if ((W->Flags&WINDOWACTIVE)&&!WP){
        ChangePointer(&Cross);
        WP=1;
      } else WP=0;
      if (GClose.Flags&SELECTED) break;
    } /* DisplayDots */
    if ((NowX!=PrintX)||(NowY!=PrintY)||(DynaCol!=PrintCol)||PrintStat){
      PrintX=NowX;  PrintY=NowY;  PrintCol=DynaCol;  PrintStat=0;
      strcpy(&TxCol[7],RAdCi_d(4,DynaCol));
      strcpy(&TxRel[2],RAdCi_d(4,NowX-StatX));
      strcpy(&TxRel[6],RAdCi_d(5,NowY-StatY));
      strcpy(&TxAbs[2],RAdCi_d(4,NowX));
      strcpy(&TxAbs[6],RAdCi_d(5,NowY));
      Forbid();
      if (FS==IB->FirstScreen)  PrintIText(W->RPort,&ITCol,0,0);
      Permit();
    }
    /*  Most of the time, this program blocks intuition. So give the
     *  system some more time by delaying this loop. That even increases
     *  this programs performance. Isn't that peculiar?
     */
    Delay(1);
  }
  ChangePrefs(0);
  if (W)  PutWindowAway(W);
  CloseLibrary(IB);
  return(0);
}


GetNewWindow(FS)
register struct Screen *FS;
{
  static short  VFact=0, HFact=0;
  register short TxLen_d;

  if (W){
    NW.LeftEdge=W->LeftEdge<<HFact; /* scale from */
    NW.TopEdge=W->TopEdge<<VFact;
    PutWindowAway(W);
  } 
  ITAbs.TopEdge=1*FS->Font->ta_YSize+((VWEXTRA*3)/4);  /* set text pos's */
  ITRel.TopEdge=2*FS->Font->ta_YSize+((VWEXTRA*3)/4);
  ITCol.TopEdge=3*FS->Font->ta_YSize+((VWEXTRA*3)/4);
  ITWTtl.ITextFont=FS->Font;
  TxLen_d=IntuiTextLength(&ITWTtl);
  GClose.Width=TxLen_d/11+(HWEXTRA/2);
  NW.LeftEdge>>=HFact=(FS->ViewPort.Modes&HIRES)?0:1;  /* scale to */
  NW.TopEdge>>= VFact=(FS->ViewPort.Modes&LACE)?0:1;
  NW.Width=TxLen_d+HWEXTRA;
  NW.Height=4*FS->Font->ta_YSize+VWEXTRA;
  NW.Screen=FS;
  NW.Type=FS->Flags&SCREENTYPE;
  while ((NW.LeftEdge+NW.Width)>FS->Width) --NW.LeftEdge;  /* inside screen? */
  while ((NW.TopEdge+NW.Height)>FS->Height) --NW.TopEdge;
  if (W=(struct Window *)OpenWindow(&NW))  AddGadget(W,&GClose,0);  
  return(W);
}


/*
 *  We donot want to close a window on a non existing screen, do we?
 */

void PutWindowAway(window)
register struct Window *window;
{
extern struct IntuitionBase *IntuitionBase;
  register struct Screen *S;

  for (S=IntuitionBase->FirstScreen;S;S=S->NextScreen){
    if (S==window->WScreen){
      CloseWindow(window);
      break;
    }
  }
}


/*
 *  Here we change the pointer speed. And the pointer.
 */

void ChangePrefs(yn)
short yn;
{
  static short ItsSpeed;
  struct Preferences Prefs;
  Forbid();
  if (yn){
    ChangePointer(&Empty);
    GetPrefs(&Prefs,sizeof(struct Preferences));
    ItsSpeed=Prefs.PointerTicks;
    Prefs.PointerTicks=MOUSESPEED;
    SetPrefs(&Prefs,sizeof(struct Preferences),FALSE);
  } else{
    ChangePointer(&Cross);
    GetPrefs(&Prefs,sizeof(struct Preferences));
    if (Prefs.PointerTicks==MOUSESPEED){
      Prefs.PointerTicks=ItsSpeed;
      SetPrefs(&Prefs,sizeof(struct Preferences),FALSE);
    } else  ItsSpeed=Prefs.PointerTicks;
  }
  Permit();
}    


/*
 * Some simple formatting routine ( return ("%<size>d",number)
 */
char *RAdCi_d(size,number)
{
  static char buffer[32];
  register  short i;
  for (i=0;i<32;++i) buffer[i]=' ';
  return(&buffer[15-size+stci_d(&buffer[15],number)]);
}


void MemCleanup(){}  /* This really cleans up a lot! */

/*
 *  Some trivial function, but saving code. It is possible to pass a
 *  structure. Why not use it once? It shurely will produce a warning!
 */
void ChangePointer(Ptr)
MousePtr *Ptr;
{
  SetPointer(W,*Ptr);
}
