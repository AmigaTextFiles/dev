/* Fenster-Verwaltung */
#include "multiwindows.h"

extern struct ExecBase         *SysBase;
extern struct MultiWindowsBase *MultiWindowsBase;

BOOL         UnIconifyWindow();
void         DrawFrame();
void         UpdateFrames();
extern UWORD INewX(),INewY(),INewWidth(),INewHeight();

/* ---- Neues Fenster öffnen */
BOOL CreateWindow(windowID,titleID,x,y,w,h,flags,screenID,special)
 UBYTE             windowID;
 ULONG             titleID;
 UWORD             x,y,w,h;
 UWORD             flags;
 UBYTE             screenID;
 struct CWSpecial *special;
{
 BOOL                     locked;
 UWORD                    nx,ny;
 struct MultiWindowsUser *mw;
 struct ExtNewWindow     *nw;
 struct Screen           *scr;
 struct ScreenEntry      *se;
 struct WindowEntry      *we;
 struct DimensionInfo     di;

 /* ---- ID-Angaben prüfen und PubScreen sperren ------------------- */
 USER;

 if(windowID>MAXWINDOWS)
  { ErrorL(1000,"CreateWindow():\nInvalid WindowID!");
    return(FALSE); }
 if(mw->WindowList[windowID]!=NULL)
  { ErrorL(1003,"CreateWindow():\nWindowID already used!");
    return(FALSE); }
 if( (screenID==SCREENID_WORKBENCH) ||
     ((screenID<=MAXSCREENS)&&(mw->ScreenList[screenID]==NULL)) )
  {
   scr=LockPubScreen(NULL);
   if(scr==NULL)
    { ErrorL(1004,"CreateWindow():\nUnable to lock public screen!");
      return(FALSE); }
   locked=TRUE;
   se=NULL;
  }
 else
  {
   if(screenID>MAXSCREENS)
    { ErrorL(1001,"CreateWindow():\nInvalid ScreenID!");
      return(FALSE); }
   se=mw->ScreenList[screenID];
   if(se==NULL)
    { ErrorL(1002,"CreateWindow():\nNo screen with this ScreenID available!");
      return(FALSE); }
   scr=se->Screen;
   locked=FALSE;
  }

 /* ---- WindowEntry erstellen ------------------------------------- */
 we=ALLOC1(sizeof(struct WindowEntry));
 if(we==NULL)
   { if(locked) UnlockPubScreen(NULL,scr);
     NoMemory();
     return(FALSE); }

 /* ---- AspectX/Y-Berechnung -------------------------------------- */
 GetDisplayInfoData(NULL,&di,sizeof(struct DimensionInfo),DTAG_DIMS,GetVPModeID(&scr->ViewPort));
 nx=di.Nominal.MaxX+1;
 ny=di.Nominal.MaxY+1;
 we->AspectX=((FLOAT)nx/4.0) / ((FLOAT)ny/3.0);
 we->AspectY=((FLOAT)ny/3.0) / ((FLOAT)nx/4.0);

 /* ---- NewWindow-Struktur initialisieren ------------------------- */
 nw=&we->NewWindow;
 nw->LeftEdge=x;
 nw->TopEdge=y;
 nw->Width=w;
 nw->Height=h;
 nw->Title=FindID(mw->Catalog,titleID);
 nw->Screen=scr;
 nw->Flags=REPORTMOUSE|ACTIVATE|WFLG_NW_EXTENDED;
 if(flags & CW_INACTIVATE) nw->Flags &= (0xffff-ACTIVATE);
 if(flags & CW_DRAG) nw->Flags |= WINDOWDRAG;
 if(flags & CW_DEPTH) nw->Flags |= WINDOWDEPTH;
 if(flags & CW_SIZE) nw->Flags |= WINDOWSIZING;
 if(flags & CW_CLOSE) nw->Flags |= WINDOWCLOSE;
 if(flags & CW_BORDERLESS) nw->Flags |= BORDERLESS;
 nw->IDCMPFlags=MXIDCMP|SCROLLERIDCMP|STRINGIDCMP|INTEGERIDCMP|SLIDERIDCMP|STRINGIDCMP|LISTVIEWIDCMP|BUTTONIDCMP|CYCLEIDCMP;
 nw->IDCMPFlags|=INACTIVEWINDOW|ACTIVEWINDOW|CLOSEWINDOW|NEWSIZE|GADGETUP|GADGETDOWN|MENUPICK|RAWKEY|VANILLAKEY|REFRESHWINDOW|MOUSEMOVE|NEWPREFS;
 if(mw->HasMenuHelp) nw->IDCMPFlags |= MENUVERIFY;
 nw->DetailPen=0;
 nw->BlockPen=1;
 nw->MinWidth=nw->Width;
 nw->MinHeight=nw->Height;
 nw->MaxWidth=scr->Width;
 nw->MaxHeight=scr->Height;
 nw->Type=CUSTOMSCREEN;
 nw->CheckMark=NULL;
 nw->FirstGadget=NULL;
 nw->BitMap=NULL;

 /* ---- ExtNewWindow initialisieren ------------------------------- */
 nw->Extension=&we->TagList;
 we->WindowID=windowID;
 we->TagList[2].ti_Tag=WA_AutoAdjust;
 we->TagList[2].ti_Data=TRUE;
 we->TagList[1].ti_Tag=WA_InnerWidth;
 we->TagList[1].ti_Data=(UWORD)((FLOAT)w*mw->FactorX);
 we->TagList[0].ti_Tag=WA_InnerHeight;
 we->TagList[0].ti_Data=(UWORD)((FLOAT)h*mw->FactorY);
 we->TagList[3].ti_Tag=TAG_DONE;

 /* ---- Fenster öffnen -------------------------------------------- */
 we->Window=OpenWindow(nw);
 if(we->Window==NULL)
  {
   { if(locked) UnlockPubScreen(NULL,scr);
     FREE1(we);
     ErrorL(1005,"CreateWindow():\nUnable to open window!");
     return(FALSE); }
  }

 /* ---- TagList um 3 Einträge erhöhen (für Iconify) --------------- */
 nw->Extension=&we->TagList[3];  /* InnerWidth/Height, AutoAdjust  */
                                 /* sollen bei UnIconify wegfallen */

 /* ---- WindowEntry-Struktur initialisieren ----------------------- */
 NewList(&we->GadgetList);
 NewList(&we->FrameList);
 we->WindowFlags=flags;
 we->OWidth=w;
 we->OHeight=h;
 we->Iconify=FALSE;
 we->UserPort=we->Window->UserPort;
 we->RastPort=we->Window->RPort;
 we->ViewPort=ViewPortAddress(we->Window);
 we->DrawInfo=GetScreenDrawInfo(scr);
 we->VisualInfo=GetVisualInfoA(scr,NULL);
 we->ScreenEntry=se;
 we->TextFont=mw->TextFont;

 we->Width=we->Window->Width;
 we->Height=we->Window->Height;
 we->FactorX=(FLOAT)we->Width/(FLOAT)w;
 we->FactorY= (FLOAT)we->Height/(FLOAT)h;
 we->Layer=we->Window->WLayer;
 we->LayerInfo=&scr->LayerInfo;
 we->ColorMap=scr->ViewPort.ColorMap;
 we->BitMap=scr->RastPort.BitMap;
 we->Screen=scr;
 we->Window->UserData=we;
 we->WindowNode.ln_Name=nw->Title;

 if(locked) we->PubScreenLock=TRUE; else we->PubScreenLock=FALSE;
 if((we->DrawInfo==NULL)||(we->VisualInfo==NULL))
  {
    { CloseWindow(we->Window);
      if(we->VisualInfo) FreeVisualInfo(we->VisualInfo);
      if(we->DrawInfo) FreeScreenDrawInfo(we->DrawInfo);
      if(locked) UnlockPubScreen(NULL,scr);
      FREE1(we);
      NoMemory();
      return(FALSE); }
  }

 SetFont(we->RastPort,mw->TextFont);
 SetAPen(we->RastPort,we->DrawInfo->dri_Pens[TEXTPEN]);
 WindowLimits(we->Window,we->Width,we->Height,scr->Width,scr->Height);
 CalcInnerSize(we);

 we->TextSpacing=we->RastPort->TxSpacing;

 if(flags & CW_INITGFX)
  {
   CreateTmpRas(we);
   CreateAreaInfo(we,200);
  }

 /* ---- Window in WindowList einhängen ---------------------------- */
 Forbid();
 mw->WindowList[windowID]=we;
 if(!(flags & CW_INACTIVATE))
  {
   mw->ActiveWindowID=windowID;
   mw->ActiveWindow=we;
  }
 if(se!=NULL)
   AddHead(&se->WindowList,we);
 Permit();
 return(TRUE);
}

/* ---- WindowEntry für ID ermitteln */
struct WindowEntry *FindWindowEntry(windowID)
 UBYTE windowID;
{
 struct MultiWindowsUser  *mw;
 struct WindowEntry       *we;

 USER;
 if(windowID>MAXWINDOWS)
  { ErrorL(1006,"FindWindowEntry():\nInvalid WindowID!");
    return(NULL); }

 we=mw->WindowList[windowID];
 if(we==NULL)
  { ErrorL(1007,"FindWindowEntry():\nNo window with this WindowID available!");
    return(NULL); }
 return(we);
}

/* ---- Prüfen, ob WindowID gültig ist */
BOOL CheckWindowID(windowID)
 UBYTE windowID;
{
 struct MultiWindowsUser  *mw;

 USER;
 if(windowID<=MAXWINDOWS)
  { if(mw->WindowList[windowID]!=NULL) return(TRUE); }
 return(FALSE);
}

/* ---- Fenster schließen */
void DeleteWindow(windowID)
 UBYTE windowID;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct Node             *node;
 struct MWGadget         *gad;
 struct Gadget           *g;
 struct ListviewData     *ld;
 struct IconData         *iconData;
 struct ImageData        *imageData;
 int                      i;

 USER;
 if((CheckWindowID(windowID))==FALSE) return;
 we=FindWindowEntry(windowID);
 if(we)
  {
   GadHelpClose(we);
   /* ---- Fenster aus WindowList entfernen --------------------- */
   Forbid();
   mw->WindowList[windowID]=NULL;
   if(mw->ActiveWindow==we->Window)
    {
     mw->ActiveWindow=NULL;
     mw->ActiveWindowID=-1;
    }
   if(we->ScreenEntry) Remove(we);
   Permit();

   if(we->Iconify)
    {
     /* ---- Fenster ist ikonifiziert --------------------------- */
     if(we->AppIcon) DeleteAppObject(we->AppIcon);
     if(we->AppMenuItem) DeleteAppObject(we->AppMenuItem);
    }
   else
    {
     /* ---- Fenster ist geöffnet ------------------------------- */
     if(we->Window)
      {
       ClearMenuStrip(we->Window);
       ClearPointer(we->Window);
       CloseWindow(we->Window);
       SetPointerColors();
       DisposeMenu(we);
      }
    }

    /* ---- Strukturen freigeben -------------------------------- */
    if(we->PubScreenLock) UnlockPubScreen(NULL,we->Screen);
    FreeVisualInfo(we->VisualInfo);
    FreeScreenDrawInfo(we->Screen,we->DrawInfo);
    if(we->SysWPAddress) UnLoadWallpaper(we->SysWPAddress);
    if(we->SysPOAddress) UnLoadPointer(we->SysPOAddress);

    we->RastPort=NULL; /* Wichtig für DeleteTmpRas()/DeleteAreaInfo() !!! */
    if(we->TmpRasCount>0)
     {
      we->TmpRasCount=1;
      DeleteTmpRas(we);
     }
    DeleteAreaInfo(we);

    if(we->WindowFont)
     {
      Forbid();
      we->WindowFont->tf_Accessors--;
      Permit();
     }

    /* ---- Schalter entfernen ---------------------------------- */
    for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
     {
      gad=node;
      switch(gad->Type)
       {
        case MWGAD_GADTOOLS:
          if(gad->Gadget)
            FreeGList(gad->Gadget,gad->GadgetCount);
          if(gad->Kind==LISTVIEW_KIND)
           {
            ld=gad->ExtData;
            FreeMemory(&ld->Remember);
           }
         break;
        case MWGAD_SPECIAL:
          switch(gad->Kind)
           {
            case ICON_KIND:
              iconData=gad->ExtData;
              if(iconData->Icon) FreeDiskObject(iconData->Icon);
             break;
            case IMAGE_KIND:
              imageData=gad->ExtData;
              if(imageData->Image) DisposeObject(imageData->Image);
              if(imageData->Gadget) DisposeObject(imageData->Gadget);
             break;
           }
         break;
       }
      FreeMemory(&gad->Remember);
     }

   /* ---- Remember und WindowEntry freigeben ------------------- */
   if(we->Remember.FirstRemember) FreeMemory(&we->Remember);
   FREE1(we);
  }
}

/* ---- Fenster aktivieren (INTERN, ohne GadHelpClose) */
BYTE ActWin(windowID)
 UBYTE windowID;
{
 BYTE                     oldID;
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;

 USER;
 if(windowID!=-1)
  {
   we=FindWindowEntry(windowID);
   if(we)
    {
     if(we->Iconify) UnIconifyWindow(windowID);

     Forbid();
     oldID=mw->ActiveWindowID;
     mw->ActiveWindow=we;
     mw->ActiveWindowID=windowID;
     Permit();
    }
  }
 else
  {
   oldID=mw->ActiveWindowID;
   mw->ActiveWindow=NULL;
   mw->ActiveWindowID=-1;
  }
 return(oldID);
}

/* ---- Fenster ikonifizieren */
BOOL IconifyWindow(windowID,flags)
 UBYTE windowID;
 UWORD flags;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct NewWindow        *nw;
 struct Window           *win;
 struct RastPort         *rp;

 USER;
 we=FindWindowEntry(windowID);
 if((we)&&(!(we->Iconify)))
  {
   GadHelpClose(we);

   if(flags & IF_APPICON)
    {
     we->AppIcon=CreateAppObject(-1L,AOT_ICON,"AppIcon",OT_WINDOWENTRY,we);
     if(we->AppIcon==NULL)
       return(FALSE);
    }

   if(flags & IF_APPMENU)
    {
     we->AppMenuItem=CreateAppObject(-1L,AOT_MENUITEM,"AppMenuItem",OT_WINDOWENTRY,we);
     if(we->AppMenuItem==NULL)
      {
       if(we->AppIcon) DeleteAppObject(we->AppIcon);
       we->AppIcon=NULL;
       return(FALSE);
      }
    }

   nw=&we->NewWindow;
   win=we->Window;
   rp=we->Window->RPort;

   nw->Title=win->Title;
   nw->LeftEdge=win->LeftEdge;
   nw->TopEdge=win->TopEdge;
   nw->Width=win->Width;
   nw->Height=win->Height;
   nw->Flags=win->Flags;
   nw->IDCMPFlags=win->IDCMPFlags;
   nw->MinWidth=win->MinWidth;
   nw->MinHeight=win->MinHeight;
   nw->MaxWidth=win->MaxWidth;
   nw->MaxHeight=win->MaxHeight;
   nw->DetailPen=win->DetailPen;
   nw->BlockPen=win->BlockPen;
   nw->Type=CUSTOMSCREEN;
   nw->Screen=win->WScreen;
   nw->CheckMark=NULL;
   nw->FirstGadget=NULL;
   nw->BitMap=NULL;
   CopyMemQuick(rp,&we->IRastPort,sizeof(struct RastPort));

   we->Window=NULL;
   we->RastPort=NULL;
   we->UserPort=NULL;
   we->ViewPort=NULL;
   we->Screen=NULL;
   we->LayerInfo=NULL;
   we->ColorMap=NULL;
   we->BitMap=NULL;
   we->Layer=NULL;
   we->Iconify=TRUE;

   SetPointerColors();
   ClearPointer(win);
   ClearMenuStrip(win);
   CloseWindow(win);

   if(we->VisualInfo) FreeVisualInfo(we->VisualInfo);
   if(we->DrawInfo) FreeScreenDrawInfo(we->DrawInfo);
   we->VisualInfo=NULL;
   we->DrawInfo=NULL;

   return(TRUE);
  }
 return(FALSE);
}

/* ---- Fenster entikonifizieren */
BOOL UnIconifyWindow(windowID)
 UBYTE windowID;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct RastPort         *oldRP,*newRP;
 struct Node             *node;
 struct MWGadget         *gad;

 USER;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Iconify))
  {
   if(we->ScreenEntry!=NULL)
     we->NewWindow.Screen=we->ScreenEntry->Screen;
   we->Window=OpenWindow(&we->NewWindow);
   if(we->Window)
    {
     we->Screen=we->Window->WScreen;
     we->DrawInfo=GetScreenDrawInfo(we->Screen);
     we->VisualInfo=GetVisualInfoA(we->Screen,NULL);
     if((we->DrawInfo==NULL)||(we->VisualInfo==NULL))
      {
       CloseWindow(we->Window);
       return(FALSE);
      }

     we->Window->UserData=we;
     we->Iconify=FALSE;
     we->UserPort=we->Window->UserPort;

     /* --- RastPort-Kopie: von AreaPtrn bis RP_User --- */
     newRP=we->Window->RPort;
     oldRP=&we->IRastPort;
     we->RastPort=newRP;
     CopyMemQuick((ULONG)oldRP+8L,(ULONG)newRP+8L,62);
     SetFont(we->RastPort,we->TextFont);

     /* --- Zeiger wiederherstellen -------------------- */
     we->ViewPort=ViewPortAddress(we->Window);
     we->Layer=we->Window->WLayer;
     we->RastPort->TmpRas=we->TmpRas;
     we->RastPort->AreaInfo=we->AreaInfo;
     we->ColorMap=we->Screen->ViewPort.ColorMap;
     we->Layer=we->Window->WLayer;
     we->LayerInfo=&we->Screen->LayerInfo;
     we->BitMap=we->Screen->RastPort.BitMap;

     we->Width=we->Window->Width;
     we->Height=we->Window->Height;
     we->FactorX=(FLOAT)we->Width/(FLOAT)we->OWidth;
     we->FactorY=(FLOAT)we->Height/(FLOAT)we->OHeight;

     /* --- Pointer, Wallpaper, Menüs wiederherstellen - */
     if(we->FirstMenu) SetMenuStrip(we->Window,we->FirstMenu);
     if(we->Wallpaper) UseWallpaper(we,we->Wallpaper);
     if(we->Pointer) UsePointer(we,we->Pointer);
     SetPointerColors();

     /* --- Gadgets wiederherstellen ------------------- */
     for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
      {
       gad=node;
       gad->NewGadget.ng_VisualInfo=we->VisualInfo;
       UpdateGadget(gad);
      }
     UpdateFrames(we,FALSE);

     if(we->Window->FirstGadget)
       RefreshGList(we->Window->FirstGadget,we->Window,NULL,-1L);
     RefreshSGadgets(we);
     GTRefreshWindow(we->Window,NULL);

     /* ---- AppIcon entfernen ------------------------- */
     if(we->AppIcon) DeleteAppObject(we->AppIcon);
     if(we->AppMenuItem) DeleteAppObject(we->AppMenuItem);
     we->AppIcon=NULL;
     we->AppMenuItem=NULL;

     return(TRUE);
    }
  }
 return(FALSE);
}

/* ---- Fenster aktivieren */
void ActWindow(windowID)
 UBYTE windowID;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;

 USER;
 if(windowID!=-1)
  {
   we=FindWindowEntry(windowID);
   if(we)
    {
     if(we->Iconify) UnIconifyWindow(windowID);
     Forbid();
     mw->ActiveWindow=we;
     mw->ActiveWindowID=windowID;
     Permit();
    }
  }
 else
  {
   mw->ActiveWindow=NULL;
   mw->ActiveWindowID=-1;
  }
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowAddress(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Window);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowRastPort(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->RastPort);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowWallpaper(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Wallpaper);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowWallpaperName(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Wallpaper))
  {
   return(we->Wallpaper->Node.ln_Name);
  }
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowPointer(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Pointer);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowPointerName(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Pointer))
  {
   return(we->Pointer->Node.ln_Name);
  }
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowScreen(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Screen);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowScreenEntry(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->ScreenEntry);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowBitMap(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->BitMap);
 return(NULL);
}
/* ---- Fensterdaten ermitteln */
APTR GetWindowBitplane(windowID,num)
 UBYTE windowID;
 UBYTE num;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->BitMap))
  {
   if(num<we->BitMap->Depth)
     return(we->BitMap->Planes[num]);
  }
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowViewPort(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->ViewPort);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowLayerInfo(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->LayerInfo);
 return(NULL);
}

APTR GetWindowLayer(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Layer);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowDrawInfo(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->DrawInfo);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowCMap(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->ColorMap);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowCTable(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->ColorMap->ColorTable);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowVisualInfo(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->VisualInfo);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowUserPort(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->UserPort);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
APTR GetWindowTextFont(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->TextFont);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
UBYTE *GetWindowTextFontName(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->TextFont->tf_Message.mn_Node.ln_Name);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowTextFontHeight(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->TextFont->tf_YSize);
 return(0);
}

/* ---- Fensterdaten ermitteln */
BOOL GetWindowIconifyStatus(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Iconify);
 return(TRUE);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowInnerLeftEdge(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->InnerLeftEdge);
 return(0);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowInnerTopEdge(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->InnerTopEdge);
 return(0);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowInnerWidth(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->InnerWidth);
 return(0);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowInnerHeight(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->InnerHeight);
 return(0);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowWidth(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Width);
 return(0);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowHeight(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Height);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowOriginalWidth(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->OWidth);
 return(0);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowOriginalHeight(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->OHeight);
 return(NULL);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowLeftEdge(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->Window->LeftEdge);
 return(0);
}

/* ---- Fensterdaten ermitteln */
UWORD GetWindowTopEdge(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->TopEdge);
 return(0);
}

/* ---- Fensterdaten ermitteln */
FLOAT GetWindowFactorX(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->FactorX);
 return((FLOAT)1.0);
}

/* ---- Fensterdaten ermitteln */
FLOAT GetWindowFactorY(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->FactorY);
 return((FLOAT)1.0);
}

/* ---- User-Info ermitteln */
APTR GetUserInfo()
{
 return(MultiWindowsBase->UserInfo);
}

/* ---- Preferences ermitteln */
APTR GetPreferences()
{
 return(MultiWindowsBase->Preferences);
}

/* ---- User-Level ermitteln */
UBYTE GetUserLevel()
{
 return(MultiWindowsBase->UserInfo->UserLevel);
}

/* ---- Fenster wird inaktiv */
void InactiveWindow(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 mm->Class=MULTI_INACTIVEWINDOW;
 mm->ObjectID=we->WindowID;
 mm->ObjectAddress=we;
 SetPointerColors();
}

/* Fenster wird aktiv */
void ActiveWindow(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{

 UsePointer(we,we->Pointer);
 mm->Class=MULTI_ACTIVEWINDOW;
 mm->ObjectID=we->WindowID;
 mm->ObjectAddress=we;
}

/* Preferences wurden geändert */
void NewPrefs(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 Forbid();
 GetPrefs(&MultiWindowsBase->Preferences,sizeof(struct Preferences));
 Permit();

 mm->Class=MULTI_NEWPREFS;
 mm->ObjectID=we->WindowID;
 mm->ObjectAddress=we;
}

/* ---- Fensterdaten ermitteln */
UWORD WNewX(windowID,value)
 UBYTE windowID;
 UWORD value;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(INewX(we,value));
 return(value);
}

/* ---- Fensterdaten ermitteln */
UWORD WNewY(windowID,value)
 UBYTE windowID;
 UWORD value;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(INewY(we,value));
 return(value);
}

/* ---- Fensterdaten ermitteln */
UWORD WNewWidth(windowID,value)
 UBYTE windowID;
 UWORD value;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(INewWidth(we,value));
 return(value);
}

/* ---- Fensterdaten ermitteln */
UWORD WNewHeight(windowID,value)
 UBYTE windowID;
 UWORD value;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(INewHeight(we,value));
 return(value);
}

/* ---- Fensterdaten ermitteln */
UBYTE *GetWindowTitle(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Window)) return(we->Window->Title);
 return(NULL);
}

/* ---- Fenster-Titel setzen */
void WindowTitle(windowID,title)
 UBYTE  windowID;
 UBYTE *title;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Window))SetWindowTitles(we->Window,title,-1L);
}

/* ---- Fenster-Titel setzen */
void WindowSTitle(windowID,title,stitle)
 UBYTE  windowID;
 UBYTE *title,*stitle;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Window)) SetWindowTitles(we->Window,title,stitle);
}

/* ---- Fenster aktivieren */
void WindowActivate(windowID)
 UBYTE  windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Window)) ActivateWindow(we->Window);
}

/* ---- Fenster hervorholen */
void WindowFront(windowID)
 UBYTE  windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Window)) WindowToFront(we->Window);
}

/* ---- Fenster nach Hinten legen */
void WindowBack(windowID)
 UBYTE  windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Window)) WindowToBack(we->Window);
}

/* ---- Funktion des Zoom-Gadgets */
void WindowZoom(windowID)
 UBYTE  windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if((we)&&(we->Window)) ZipWindow(we->Window);
}

/* ---- Window verschieben */
void WindowMove(windowID,x,y)
 UBYTE windowID;
 WORD  x,y;
{
 struct WindowEntry *we;
 struct Window      *win;

 we=FindWindowEntry(windowID);
 if((we!=NULL)&&(we->Window!=NULL))
  {
   win=we->Window;
   ChangeWindowBox(we->Window,x,y,we->Window->Width,we->Window->Height);
  }
}

/* ---- Window verschieben */
void WindowMoveDelta(windowID,x,y)
 UBYTE windowID;
 WORD  x,y;
{
 struct WindowEntry      *we;
 struct Window           *win;
 struct MultiWindowsUser *mw;

 we=FindWindowEntry(windowID);
 if((we!=NULL)&&(we->Window!=NULL))
  {
   win=we->Window;
   ChangeWindowBox(we->Window,x+we->Window->LeftEdge,y+we->Window->TopEdge,we->Window->Width,we->Window->Height);
  }
}

/* ---- Window vergrößern/verkleinern */
void WindowSize(windowID,w,h)
 UBYTE windowID;
 WORD  w,h;
{
 struct WindowEntry      *we;
 struct Window           *win;
 struct MultiWindowsUser *mw;

 USER;
 w=(UWORD)((FLOAT)w*mw->FactorX);
 h=(UWORD)((FLOAT)h*mw->FactorY);

 we=FindWindowEntry(windowID);
 if((we!=NULL)&&(we->Window!=NULL))
  {
   win=we->Window;
   ChangeWindowBox(we->Window,we->Window->LeftEdge,we->Window->TopEdge,w,h);
  }
}

/* ---- Window vergrößern/verkleinern */
void WindowSizeDelta(windowID,w,h)
 UBYTE windowID;
 WORD  w,h;
{
 struct WindowEntry      *we;
 struct Window           *win;
 struct MultiWindowsUser *mw;

 USER;
 w=(UWORD)((FLOAT)w*mw->FactorX);
 h=(UWORD)((FLOAT)h*mw->FactorY);

 we=FindWindowEntry(windowID);
 if((we!=NULL)&&(we->Window!=NULL))
  {
   win=we->Window;
   ChangeWindowBox(we->Window,we->Window->LeftEdge,we->Window->TopEdge,
                   w+we->Window->Width,h+we->Window->Height);
  }
}

/* ---- Window vergrößern/verkleinern und verschieben */
void WindowBox(windowID,x,y,w,h)
 UBYTE windowID;
 WORD  x,y,w,h;
{
 struct WindowEntry      *we;
 struct Window           *win;
 struct MultiWindowsUser *mw;

 USER;
 w=(UWORD)((FLOAT)w*mw->FactorX);
 h=(UWORD)((FLOAT)h*mw->FactorY);

 we=FindWindowEntry(windowID);
 if((we!=NULL)&&(we->Window!=NULL))
  {
   win=we->Window;
   ChangeWindowBox(we->Window,x,y,w,h);
  }
}

/* ---- Fensterdaten ermitteln */
FLOAT GetWindowAspectX(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->AspectX);
 return((FLOAT)1.0);
}

/* ---- Fensterdaten ermitteln */
FLOAT GetWindowAspectY(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;
 we=FindWindowEntry(windowID);
 if(we) return(we->AspectY);
 return((FLOAT)1.0);
}

/* ---- Frame erstellen */
BOOL AddFrame(id,x,y,w,h,type)
 ULONG id;
 UWORD x,y,w,h;
 UWORD type;
{
 struct WindowEntry *we;
 struct Frame       *fr;

 WE;
 if(we)
  {
   fr=ALLOC2(sizeof(struct Frame));
   if(fr)
    {
     fr->ID=id;
     fr->Type=type;
     fr->LeftEdge=x;
     fr->TopEdge=y;
     fr->Width=w;
     fr->Height=h;
     fr->x=0xffff;
     AddTail(&we->FrameList,fr);
     DrawFrame(we,fr,FALSE);
     return(TRUE);
    }
   else
     NoMemory();
  }
 return(FALSE);
}

/* ---- Frame entfernen */
void RemFrame(id)
 ULONG id;
{
 struct WindowEntry *we;
 struct Frame       *fr;
 struct MinNode     *node;

 WE;
 if(we)
  {
   for(node=we->FrameList.lh_Head;node!=&we->FrameList.lh_Tail;node=node->mln_Succ)
    {
     fr=node;
     if(fr->ID==id)
      {
       Remove(fr);
       FREE2(fr);
       return;
      }
    }
  } 
}

/* ---- Frame zeichnen */
void DrawFrame(we,fr,erase)
 struct WindowEntry *we;
 struct Frame       *fr;
 BOOL                erase;
{
 BOOL recessed,db;

 if(we->Iconify) return;

 if(!erase)
  {
   fr->x=INewX(we,fr->LeftEdge);
   fr->y=INewY(we,fr->TopEdge);
   fr->w=INewWidth(we,fr->Width);
   fr->h=INewHeight(we,fr->Height);

   if(fr->Type==FT_RECESSED) recessed=TRUE; else recessed=FALSE;
   if(fr->Type==FT_DOUBLE) db=TRUE; else db=FALSE;
  }
 if(fr->x!=0xffff) DrawIt(we,fr->x,fr->y,fr->w,fr->h,recessed,db,erase);
}

/* ---- Frames updaten */
void UpdateFrames(we,erase)
 struct WindowEntry *we;
 BOOL                erase;
{
 struct MinNode *node;

 for(node=we->FrameList.lh_Head;node!=&we->FrameList.lh_Tail;node=node->mln_Succ)
   DrawFrame(we,node,erase);
}

