/* Screen-Verwaltung */
#include "multiwindows.h"

extern struct ExecBase         *SysBase;
extern struct MultiWindowsBase *MultiWindowsBase;

UWORD StdPalette[]={0xaaa,0x000,0xfff,0x68b,0x999,0xbbb,0xba9,0xfba};
UWORD StdPens[]={0,1,1,2,1,3,1,0,2,-1};

UWORD GetScreenWidth();
BOOL  InitBackdrop();
void  RemoveBackdrop();

/* ---- Screen öffnen */
BOOL CreateScreen(screenID,titleID,w,h,d,modeID,type,flags,addTagList)
 UBYTE           screenID;
 UBYTE          *titleID;
 UWORD           w,h;
 UBYTE           d;
 ULONG           modeID;
 ULONG           type;
 UWORD           flags;
 struct TagItem *addTagList;
{
 LONG                      errorCode;
 struct MultiWindowsUser  *mw;
 struct ScreenEntry       *se;
 struct Screen            *scr;

 USER;
 if(screenID>MAXSCREENS)
  { ErrorL(1112,"CreateScreen():\nInvalid ScreenID!");
    return(FALSE); }
 if(mw->ScreenList[screenID]!=NULL)
  { ErrorL(1113,"CreateScreen():\nScreenID already used!");
    return(FALSE); }

 se=ALLOC1(sizeof(struct ScreenEntry));
 if(se==NULL)
  {
   NoMemory();
   return(FALSE);
  }

 se->TagList[0].ti_Tag=SA_Width;
 se->TagList[0].ti_Data=w;
 se->TagList[1].ti_Tag=SA_Height;
 se->TagList[1].ti_Data=h;
 se->TagList[2].ti_Tag=SA_Depth;
 se->TagList[2].ti_Data=d;
 se->TagList[3].ti_Tag=SA_DisplayID;
 se->TagList[3].ti_Data=modeID;
 se->TagList[4].ti_Tag=SA_ErrorCode;
 se->TagList[4].ti_Data=&errorCode;
 se->TagList[5].ti_Tag=SA_SysFont;
 se->TagList[5].ti_Data=1;

 if((d>1)&&(!(flags & CS_NOSTDCOLORS)))
  {
   se->TagList[6].ti_Tag=SA_Pens;
   se->TagList[6].ti_Data=&StdPens;
  }
 else
   se->TagList[6].ti_Tag=TAG_IGNORE;

 se->TagList[7].ti_Tag=SA_Overscan;
 if(flags & CS_TEXTOVERSCAN)
   se->TagList[7].ti_Data=OSCAN_TEXT;
 else if(flags & CS_STDOVERSCAN)
   se->TagList[7].ti_Data=OSCAN_STANDARD;
 else if(flags & CS_MAXOVERSCAN)
   se->TagList[7].ti_Data=OSCAN_MAX;
 else if(flags & CS_VIDEOOVERSCAN)
   se->TagList[7].ti_Data=OSCAN_VIDEO;
 else
   se->TagList[7].ti_Tag=TAG_IGNORE;
 if(!flags & CS_NOAUTOSCROLL)
  {
   se->TagList[8].ti_Tag=SA_AutoScroll;
   se->TagList[8].ti_Data=TRUE;
  }
 else
   se->TagList[8].ti_Tag=TAG_IGNORE;
 se->TagList[9].ti_Tag=SA_Title;
 se->TagList[9].ti_Data=FindID(mw->Catalog,titleID);
 se->TagList[10].ti_Tag=SA_Type;
 se->TagList[10].ti_Data=type;
 if(addTagList)
  {
   se->TagList[11].ti_Tag=TAG_MORE;
   se->TagList[11].ti_Data=addTagList;
  }
 else
   se->TagList[11].ti_Tag=TAG_IGNORE;

 se->TagList[12].ti_Tag=SA_Left;       /* für Iconify/UnIconify         */
 se->TagList[12].ti_Data=0;            /* ACHTUNG: Tag-Nummer 12 und 13 */
 se->TagList[13].ti_Tag=SA_Top;        /*   bei Änderungen beachten!    */
 se->TagList[13].ti_Data=0;

 se->TagList[14].ti_Tag=TAG_DONE;
 se->TagList[14].ti_Data=0;

 errorCode=0;
 scr=OpenScreenTagList(NULL,&se->TagList);
 if(scr==NULL)
  {
   switch(errorCode)
    {
     case OSERR_NOMONITOR:
       ErrorL(1114,"CreateScreen():\nWrong monitor for this ModeID!");
      break;
     case OSERR_NOCHIPS:
       ErrorL(1115,"CreateScreen():\nWrong custom chips for this ModeID!");
      break;
     case OSERR_NOCHIPMEM:
       ErrorL(1116,"CreateScreen():\nWrong custom chips for this ModeID!");
      break;
     case OSERR_PUBNOTUNIQUE:
       ErrorL(1117,"CreateScreen():\nPublic screen name not unique!");
      break;
     case OSERR_UNKNOWNMODE:
       ErrorL(1118,"CreateScreen():\nUnknown ModeID!");
      break;
     default:
       ErrorL(0,0);
      break;
    }
   FREE1(se);
   return(FALSE);
  }

 se->Screen=scr;
 se->Iconify=FALSE;
 se->RastPort=&scr->RastPort;
 se->ViewPort=&scr->ViewPort;
 se->BitMap=se->RastPort->BitMap;
 se->LayerInfo=&scr->LayerInfo;
 se->ColorMap=se->ViewPort->ColorMap;
 scr->UserData=se;

 se->ScreenID=screenID;
 se->ModeID=modeID;
 se->ScreenFlags=flags;
 NewList(&se->WindowList);
 GetDisplayInfoData(NULL,&se->DisplayInfoBuffer,sizeof(struct DisplayInfo),DTAG_DISP,modeID);
 se->DisplayInfo=&se->DisplayInfoBuffer;

 if(!(flags & CS_NOSTDCOLORS))
  {
   if(d==2)
     LoadRGB4(se->ViewPort,&StdPalette,4L);
   else if(d>2)
     LoadRGB4(se->ViewPort,&StdPalette,8L);
  }
 if(!(flags & CS_NOBACKDROP))
   InitBackdrop(se);

 mw->ScreenList[screenID]=se; 
 return(TRUE);
}

/* ---- ScreenEntry für ID ermitteln */
struct ScreenEntry *FindScreenEntry(screenID)
 UBYTE screenID;
{
 struct MultiWindowsUser  *mw;
 struct ScreenEntry       *we;

 USER;
 if(screenID>MAXSCREENS)
  { ErrorL(1119,"FindScreenEntry():\nInvalid ScreenID!");
    return(NULL); }

 we=mw->ScreenList[screenID];
 if(we==NULL)
  { ErrorL(1120,"FindScreenEntry():\nNo screen with this ScreenID available!");
    return(NULL); }
 return(we);
}

/* ---- Prüfen, ob ScreenID gültig ist */
BOOL CheckScreenID(screenID)
 UBYTE screenID;
{
 struct MultiWindowsUser *mw;

 USER;
 if(screenID<=MAXSCREENS)
  { if(mw->ScreenList[screenID]!=NULL) return(TRUE); }
 return(FALSE);
}

/* ---- Screen schließen */
void DeleteScreen(screenID)
 UBYTE screenID;
{
 struct ScreenEntry      *se;
 struct MultiWindowsUser *mw;

 if((CheckScreenID(screenID))==FALSE) return;
 se=FindScreenEntry(screenID);
 if(se!=NULL)
  {
   mw->ScreenList[screenID]=NULL;
   RemoveBackdrop(se);
   if(se->Screen) CloseScreen(se->Screen);
   FREE1(se);
  }
}

/* ---- Displaymodes ermitteln */
struct List *ScanDisplayModes()
{
 struct MultiWindowsUser *mw;
 struct VideoInfo        *vi;
 struct NameInfo          ninfo;
 ULONG                    okay;
 ULONG                    modeID;

 if(MultiWindowsBase->VideoInfoList.lh_Head!=NULL)
   return(&MultiWindowsBase->VideoInfoList);

 NewList(&MultiWindowsBase->VideoInfoList);
 modeID=NextDisplayInfo(INVALID_ID);
 while(modeID!=INVALID_ID)
  {
   okay=ModeNotAvailable(modeID);
   if((okay==0)&&(modeID & MONITOR_ID_MASK))
    {
     okay=GetDisplayInfoData(NULL,&ninfo,sizeof(struct NameInfo),DTAG_NAME,modeID);
     if(okay!=NULL)
      {
       vi=AllocMem(sizeof(struct VideoInfo),MEMF_CLEAR|MEMF_PUBLIC);
       if(vi!=NULL)
        {
         CopyMemQuick(&ninfo,&vi->NameInfoBuffer,sizeof(struct NameInfo));
         vi->ModeID=modeID;
         vi->NameInfo=&vi->NameInfoBuffer;
         vi->DisplayInfo=&vi->DisplayInfoBuffer;
         vi->DimensionInfo=&vi->DimensionInfoBuffer;
         vi->MonitorInfo=&vi->MonitorInfoBuffer;
         vi->Node.ln_Name=&vi->NameInfoBuffer.Name;
         GetDisplayInfoData(NULL,&vi->DisplayInfoBuffer,sizeof(struct DisplayInfo),DTAG_DISP,modeID);
         GetDisplayInfoData(NULL,&vi->DimensionInfoBuffer,sizeof(struct DimensionInfo),DTAG_DIMS,modeID);
         GetDisplayInfoData(NULL,&vi->MonitorInfoBuffer,sizeof(struct MonitorInfo),DTAG_MNTR,modeID);
         AddTail(&MultiWindowsBase->VideoInfoList,vi);
         MultiWindowsBase->VideoInfoCount++;
        }
       else
         NoMemory();
      }
    }
   modeID=NextDisplayInfo(modeID);
  }
 return(&MultiWindowsBase->VideoInfoList);
}

/* ---- Screendaten ermitteln */
APTR GetScreenLayerInfo(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if(se) return(se->LayerInfo);
 return(NULL);
}

/* ---- Screendaten ermitteln */
UBYTE *GetScreenTitle(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->Title);
 return(NULL);
}

/* ---- Screendaten ermitteln */
UBYTE *GetScreenDefaultTitle(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->DefaultTitle);
 return(NULL);
}

/* ---- Screendaten ermitteln */
APTR GetScreenRastPort(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if(se) return(se->RastPort);
 return(NULL);
}

/* ---- Screendaten ermitteln */
APTR GetScreenViewPort(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if(se) return(se->ViewPort);
 return(NULL);
}

/* ---- Screendaten ermitteln */
APTR GetScreenBitMap(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if(se) return(se->BitMap);
 return(NULL);
}

/* ---- Screendaten ermitteln */
APTR GetScreenDisplayInfo(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if(se) return(se->DisplayInfo);
 return(NULL);
}

/* ---- Screendaten ermitteln */
APTR GetScreenCMap(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if(se) return(se->ColorMap);
 return(NULL);
}

/* ---- Screendaten ermitteln */
APTR GetScreenCTable(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->ColorMap)) return(se->ColorMap->ColorTable);
 return(NULL);
}

/* ---- Screendaten ermitteln */
APTR GetScreenBitplane(screenID,num)
 UBYTE screenID;
 UBYTE num;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->BitMap))
  {
   if(num<se->BitMap->Depth)
     return(se->BitMap->Planes[num]);
  }
 return(NULL);
}

/* ---- Screendaten ermitteln */
UWORD GetScreenLeftEdge(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->LeftEdge);
 return(0);
}

/* ---- Screendaten ermitteln */
UWORD GetScreenInnerLeftEdge(screenID)
 UBYTE screenID;
{ return(0); }

/* ---- Screendaten ermitteln */
UWORD GetScreenInnerWidth(screenID)
 UBYTE screenID;
{ return(GetScreenWidth(screenID)); }

/* ---- Screendaten ermitteln */
UWORD GetScreenInnerTopEdge(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->BarHeight+1);
 return(0);
}

/* ---- Screendaten ermitteln */
UWORD GetScreenInnerHeight(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->Height-se->Screen->BarHeight-1);
 return(0);
}

/* ---- Screendaten ermitteln */
BOOL GetScreenIconifyStatus(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if(se) return(se->Iconify);
 return(FALSE);
}

/* ---- Screendaten ermitteln */
UWORD GetScreenTopEdge(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->TopEdge);
 return(0);
}

/* ---- Screendaten ermitteln */
UWORD GetScreenWidth(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->Width);
 return(0);
}

/* ---- Screendaten ermitteln */
UWORD GetScreenHeight(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->Height);
 return(0);
}

/* ---- Screendaten ermitteln */
UBYTE GetScreenDepth(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->Screen)) return(se->Screen->Depth);
 return(0);
}

/* ---- Screendaten ermitteln */
APTR GetScreenAddress(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if(se) return(se->Screen);
 return(NULL);
}

/* ---- Screendaten ermitteln */
ULONG GetScreenModeID(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->ViewPort)) return(GetVPModeID(se->ViewPort));
 return(0);
}

/* ---- Screendaten ermitteln */
UWORD GetScreenViewModes(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;
 se=FindScreenEntry(screenID);
 if((se)&&(se->ViewPort)) return(se->ViewPort->Modes);
 return(0);
}

/* ---- Screen ikonifizieren */
BOOL IconifyScreen(screenID,flags)
 UBYTE screenID;
 UWORD flags;
{
 struct ScreenEntry      *se;
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct Node             *node;
 UWORD                    colors;
 UWORD                   *ctab;

 se=FindScreenEntry(screenID);
 if((se!=NULL)&&(se->Iconify==FALSE))
  {
   colors=8;
   ctab=AllocVec(colors*2,MEMF_ANY);
   if(ctab==NULL)
    {
     NoMemory();
     return(FALSE);
    }
   CopyMem(se->ColorMap->ColorTable,ctab,colors*2);

   if(flags & IF_APPICON)
    {
     se->AppIcon=CreateAppObject(-1L,AOT_ICON,"AppIcon",OT_SCREENENTRY,se);
     if(se->AppIcon==NULL) {
       FreeVec(ctab);
       return(FALSE); }

    }
   if(flags & IF_APPMENU)
    {
     se->AppMenuItem=CreateAppObject(-1L,AOT_MENUITEM,"AppMenuItem",OT_SCREENENTRY,se);
     if(se->AppMenuItem==NULL)
      {
       if(se->AppIcon) DeleteAppObject(se->AppIcon);
       FreeVec(ctab);
       se->AppIcon=NULL;
       return(FALSE);
      }
    }

   for(node=se->WindowList.lh_Head;node!=&se->WindowList.lh_Tail;node=node->ln_Succ)
    {
     we=node;
     IconifyWindow(we->WindowID,IF_NONE);
    }
   RemoveBackdrop(se);

   se->TagList[12].ti_Data=se->Screen->LeftEdge;
   se->TagList[13].ti_Data=se->Screen->TopEdge;

   CloseScreen(se->Screen);
   se->Iconify=TRUE;

   se->Screen=NULL;
   se->RastPort=NULL;
   se->ViewPort=NULL;
   se->BitMap=NULL;
   se->LayerInfo=NULL;
   se->ColorMap=NULL;
   se->CTabBackup=ctab;
   return(TRUE);
  }
 return(FALSE);
}

/* ---- Screen entikonifizieren */
BOOL UnIconifyScreen(screenID)
 UBYTE screenID;
{
 BOOL                     okay,bool;
 struct ScreenEntry      *se;
 struct Screen           *scr;
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct Node             *node;

 se=FindScreenEntry(screenID);
 if((se!=NULL)&&(se->Iconify==TRUE))
  {
   scr=OpenScreenTagList(NULL,&se->TagList);
   if(scr==NULL) return(FALSE);

   se->Screen=scr;
   se->Iconify=FALSE;
   se->RastPort=&scr->RastPort;
   se->ViewPort=&scr->ViewPort;
   se->BitMap=se->RastPort->BitMap;
   se->LayerInfo=&scr->LayerInfo;
   se->ColorMap=se->ViewPort->ColorMap;
   scr->UserData=se;

   LoadRGB4(se->ViewPort,se->CTabBackup,8);
   FreeVec(se->CTabBackup);
   se->CTabBackup=NULL;

   InitBackdrop(se);
   if((se->BgWallpaper!=NULL)&&(se->BgWindow!=NULL))
     ShowWallpaperWindow(se->BgWindow,se->BgWallpaper);

   okay=TRUE;
   for(node=se->WindowList.lh_Head;node!=&se->WindowList.lh_Tail;node=node->ln_Succ)
    {
     we=node;
     bool=UnIconifyWindow(we->WindowID);
     if(bool==FALSE) okay=FALSE;
    }

   if(se->AppIcon) DeleteAppObject(se->AppIcon);
   if(se->AppMenuItem) DeleteAppObject(se->AppMenuItem);
   se->AppIcon=NULL;
   se->AppMenuItem=NULL;

   return(okay);
  }
 return(FALSE);
}

/* ---- Backdrop erstellen */
BOOL InitBackdrop(se)
 struct ScreenEntry *se;
{
 struct TagItem tags[7];

 tags[0].ti_Tag=WA_Width;
 tags[0].ti_Data=se->Screen->Width;
 tags[1].ti_Tag=WA_Height;
 tags[1].ti_Data=se->Screen->Height-se->Screen->BarHeight-1;
 tags[2].ti_Tag=WA_Top;
 tags[2].ti_Data=se->Screen->BarHeight+1;
 tags[3].ti_Tag=WA_CustomScreen;
 tags[3].ti_Data=se->Screen;
 tags[4].ti_Tag=WA_Flags;
 tags[4].ti_Data=BORDERLESS|BACKDROP|RMBTRAP;
 tags[5].ti_Tag=TAG_DONE;
 tags[5].ti_Data=0;

 se->BgWindow=OpenWindowTagList(NULL,&tags);
 if(se->BgWindow==NULL)
   ErrorL(1122,"InitBackdrop():\nUnable to open backdrop window!");
 else
   SetWindowTitles(se->BgWindow,-1L,se->Screen->DefaultTitle);
}

/* ---- Backdrop entfernen */
void RemoveBackdrop(se)
 struct ScreenEntry *se;
{
 if(se->BgWindow)
  {
   CloseWindow(se->BgWindow);
   se->BgWindow=NULL;
  }
}

/* ---- Screen verschieben */
void ScreenMove(screenID,x,y)
 UBYTE screenID;
 WORD  x,y;
{
 struct ScreenEntry *se;
 struct Screen      *scr;

 se=FindScreenEntry(screenID);
 if((se!=NULL)&&(se->Screen!=NULL))
  {
   scr=se->Screen;
   MoveScreen(scr,x-scr->LeftEdge,y-scr->TopEdge);
  }
}

/* ---- Screen verschieben */
void ScreenMoveDelta(screenID,x,y)
 UBYTE screenID;
 WORD  x,y;
{
 struct ScreenEntry *se;
 struct Screen      *scr;

 se=FindScreenEntry(screenID);
 if((se!=NULL)&&(se->Screen!=NULL))
  {
   scr=se->Screen;
   MoveScreen(scr,x,y);
  }
}

/* ---- Screen noch Vorne legen */
void ScreenFront(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;

 if(screenID==SCREENID_WORKBENCH)
   WBenchToFront();
 else
  {
   se=FindScreenEntry(screenID);
   if((se!=NULL)&&(se->Screen!=NULL))
     ScreenToFront(se->Screen);
  }
}

/* ---- Screen noch Hinten legen */
void ScreenBack(screenID)
 UBYTE screenID;
{
 struct ScreenEntry *se;

 if(screenID==SCREENID_WORKBENCH)
   WBenchToBack();
 else
  {
   se=FindScreenEntry(screenID);
   if((se!=NULL)&&(se->Screen!=NULL))
     ScreenToBack(se->Screen);
  }
}

/* ---- Screen-Titel setzen */
void ScreenTitle(screenID,title)
 UBYTE  screenID;
 UBYTE *title;
{
 struct ScreenEntry *se;

 se=FindScreenEntry(screenID);
 if((se!=NULL)&&(se->Screen!=NULL))
  {
   se->Screen->Title=title;
   ShowTitle(se->Screen,TRUE);
  }
}

/* ---- Screen-Titel setzen */
void ScreenDefaultTitle(screenID,title)
 UBYTE  screenID;
 UBYTE *title;
{
 struct ScreenEntry *se;

 se=FindScreenEntry(screenID);
 if((se!=NULL)&&(se->Screen!=NULL))
  {
   if(se->BgWindow) SetWindowTitles(se->BgWindow,-1L,se->Screen->DefaultTitle);
   se->Screen->DefaultTitle=title;
   ShowTitle(se->Screen,TRUE);
  }
}

