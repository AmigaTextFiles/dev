/* Hilfesystem */
#include "multiwindows.h"

extern struct MultiWindowsBase *MultiWindowsBase;
extern struct MultiDesktopBase *MultiDesktopBase;
extern struct ExecBase         *SysBase;
extern struct IntuitionBase    *IntuitionBase;

struct HelpText *CreateHelpText();
void             DeleteHelpText();
void             ShowHelpText();
void             GadHelpClose();
void             DrawHelpWP();
void             PrintHT();

/* ---- Menü-Hilfe updaten */
void MenuHelpUpdate(we)
 struct WindowEntry *we;
{
 UBYTE                    developer[100];
 UBYTE                   *helpStr;
 UBYTE                   *type;
 BOOL                     sys;
 ULONG                    helpID,helpNum,id;
 struct MultiWindowsUser *mw;
 struct MWMenu           *menu;
 struct MWMenuItem       *item,*sub;
 struct Screen           *scr;
 struct HelpText         *ht;

 USER;
 scr=we->MHScreen;
 menu=we->MHMenu;
 item=we->MHMenuItem;
 sub=we->MHSubItem;
 if(menu==NULL)
  {
   WaitBOVP(&scr->ViewPort);
   ShowWallpaperRastPort(&scr->RastPort,MultiWindowsBase->HelpWallpaper,1,1,scr->Width-2,scr->Height-3);
   return;
  }

 sys=FALSE;
 helpID=0;
 if(we->MHSubItem)
  {
   helpNum=GetTextID(we->MHSubItem->HelpID);
   helpID=we->MHSubItem->HelpID;
   type=GetLStr(535,"SubItem");
   id=we->MHSubItem->ItemID;
   if(we->MHSubItem->Flags & CMI_SYSITEM) sys=TRUE;
  }
 else if(we->MHMenuItem)
  {
   helpNum=GetTextID(we->MHMenuItem->HelpID);
   helpID=we->MHMenuItem->HelpID;
   type=GetLStr(534,"Item");
   id=we->MHMenuItem->ItemID;
   if(we->MHMenuItem->Flags & CMI_SYSITEM) sys=TRUE;
  }
 else if(we->MHMenu)
  {
   helpNum=GetTextID(we->MHMenu->HelpID);
   helpID=we->MHMenu->HelpID;
   type=GetLStr(533,"Menu");
   id=we->MHMenu->MenuID;
   if(we->MHMenu->Flags & CME_SYSMENU) sys=TRUE;
  }

 if(mw->DeveloperOn)
  {
   if(sys)
    {
     sprintf(&developer,"~C~B~U%s\n%s-%s, ID=$%08lx\nHelpID=%ld (MultiDesktop-ID)",
             GetLStr(530,"Developer's help"),
             GetLStr(536,"System"),type,id,helpNum);
    }
   else
    {
     sprintf(&developer,"~C~B~U%s\n%s, ID=%ld\nHelpID=%ld",
             GetLStr(530,"Developer's help"),
             type,id,helpNum);
    }
   ht=CreateHelpText(we,&developer);
  }
 else
  {
   if(helpID==0) return;
   helpStr=FindID(MultiDesktopBase->Catalog,helpID);
   ht=CreateHelpText(we,helpStr);
  }
 if(ht==NULL) return;

 if(ht->Lines>2) ht->Lines=2;
 WaitBOVP(&scr->ViewPort);
 ShowWallpaperRastPort(&scr->RastPort,MultiWindowsBase->HelpWallpaper,1,1,scr->Width-2,scr->Height-3);
 PrintHT(&scr->RastPort,mw->TextFont,ht,scr->Width-4,2,2,2);
 DeleteHelpText(ht);
}

/* ---- Menü-Hilfe schließen */
void MenuHelpClose(we)
 struct WindowEntry *we;
{
 if(we->MHScreen)
  {
   CloseScreen(we->MHScreen);
   we->MHScreen=NULL;
   we->MHMenuItem=NULL;
   we->GHTime=0;
  }
}

/* ---- Menü-Hilfe öffnen */
void MenuHelpOpen(we)
 struct WindowEntry *we;
{
 struct MultiWindowsUser *mw;
 struct Screen           *scr;
 struct ColorMap         *cm;
 struct TagItem           tag[10];
 ULONG                    id;
 LONG                     h;

 USER;
 GadHelpClose(we);

 if(mw->HelpOn==FALSE) return;
 if(we->Window!=IntuitionBase->ActiveWindow) return;
 if(we!=mw->ActiveWindow) return;

 id=NTSC_MONITOR_ID;
 if(we->Screen->ViewPort.Modes & LACE)
   id |= HIRESLACE_KEY;
 else
   id |= HIRES_KEY;

 h=(3*(mw->TextFont->tf_YSize+we->RastPort->TxSpacing)+6)+6;

 tag[0].ti_Tag=SA_Top;
 tag[0].ti_Data=we->Screen->Height-h+MultiWindowsBase->HelpCorrY;
 tag[1].ti_Tag=SA_Height;
 tag[1].ti_Data=h;
 tag[2].ti_Tag=SA_ShowTitle;
 tag[2].ti_Data=FALSE;
 tag[3].ti_Tag=SA_Depth;
 tag[3].ti_Data=we->Screen->BitMap.Depth;
 tag[4].ti_Tag=SA_DisplayID;
 tag[4].ti_Data=GetVPModeID(we->ViewPort);
 tag[5].ti_Tag=TAG_DONE;
 tag[5].ti_Data=0;

 we->MHScreen=OpenScreenTagList(NULL,&tag);
 scr=we->MHScreen;
 if(scr)
  {
   cm=we->Screen->ViewPort.ColorMap;
   LoadRGB4(&scr->ViewPort,cm->ColorTable,cm->Count);
   ShowWallpaperRastPort(&scr->RastPort,MultiWindowsBase->HelpWallpaper,1,1,scr->Width-2,scr->Height-3);
   SetDrMd(&scr->RastPort,JAM1);
   SetFont(&scr->RastPort,mw->TextFont);

   tag[0].ti_Tag=GT_VisualInfo;
   tag[0].ti_Data=we->VisualInfo;
   tag[1].ti_Tag=GTBB_Recessed;
   tag[1].ti_Data=TRUE;
   tag[2].ti_Data=TAG_DONE;

   DrawBevelBoxA(&scr->RastPort,0,0,scr->Width,scr->Height-1,&tag);
  }
}

/* ---- Hilfefenster schließen */
void GadHelpClose(we)
 struct WindowEntry *we;
{
 struct Window  *win;

 if(we->GHWindow)
  {
   win=we->GHWindow;
   we->GHWindow=NULL;
   UsePointer(we,we->Pointer);
   CloseWindow(win);
  }
 
 we->GHGadget=NULL;
}

/* ---- Hilfefenster öffnen */
void GadHelpOpen(we,gad,helpStr)
 struct WindowEntry *we;
 struct MWGadget    *gad;
 UBYTE              *helpStr;
{
 struct MultiWindowsUser *mw;
 struct ExtNewWindow     *nw;
 struct TagItem           tag[4];
 struct Pointer          *po;
 struct ListviewData     *ld;
 struct HelpText         *ht;
 int                      w,h;
 int                      i;
 UBYTE                    developer[150];

 USER;
 nw=AllocVec(sizeof(struct ExtNewWindow),MEMF_CLEAR|MEMF_PUBLIC);
 if(nw==NULL) { NoMemory(); return; }

 if(mw->DeveloperOn)
  {
   sprintf(&developer,
           "~U~B~C%s\n\nGadgetID: %ld\nHelpID: %ld\n%s: %s\n%s: %s",
           GetLStr(530,"Developer's Help"),
           gad->GadgetID,GetTextID(gad->HelpID),
           GetLStr(531,"Gadget type"),
           FindGTypeName(gad->Type),
           GetLStr(532,"Gadget kind"),
           FindGKindName(gad->Type,gad->Kind));
   ht=CreateHelpText(we,&developer);
  }
 else
   ht=CreateHelpText(we,helpStr);
 if(ht==NULL) { FreeVec(nw); NoMemory(); return; }

 /* ---- Fensterdaten berechnen und einstellen ------------------- */

 nw->BlockPen=1;
 nw->Screen=we->Screen;
 nw->Type=CUSTOMSCREEN;
 nw->Flags=WFLG_NW_EXTENDED;
 nw->Extension=&tag;

 if((gad->Type==MWGAD_GADTOOLS)&&(gad->Kind==LISTVIEW_KIND))
  {
   ld=gad->ExtData;
   w=ld->X2-ld->X1;
   h=ld->Y2-ld->Y1;
  }
 else
  {
   w=gad->NewGadget.ng_Width;
   h=gad->NewGadget.ng_Height;
  }

 nw->LeftEdge=we->Window->LeftEdge+gad->NewGadget.ng_LeftEdge+w-6;
 nw->TopEdge=we->Window->TopEdge+gad->NewGadget.ng_TopEdge+h-6;

 w=ht->Width;
 h=ht->Height;

 if(nw->LeftEdge+w>we->Screen->Width)
  {
   i=we->Window->LeftEdge+(gad->NewGadget.ng_LeftEdge)-w+6;
   if(i>=0) nw->LeftEdge=i;
  }

 if(nw->TopEdge+h>we->Screen->Height)
  {
   i=we->Window->TopEdge+(gad->NewGadget.ng_TopEdge)-h+6;
   if(i>=0) nw->TopEdge=i;
  }

 tag[0].ti_Tag=WA_InnerWidth;
 tag[0].ti_Data=w;
 tag[1].ti_Tag=WA_InnerHeight;
 tag[1].ti_Data=h;
 tag[2].ti_Tag=WA_AutoAdjust;
 tag[2].ti_Data=TRUE;
 tag[3].ti_Tag=TAG_DONE;

 /* ------------- Ausgabe ---------------------------------------- */
 we->GHWindow=OpenWindow(nw);
 if(we->GHWindow)
  {
   if(MultiWindowsBase->HelpPointer)
     ShowPointer(we,MultiWindowsBase->HelpPointer,0);
   ShowHelpText(we->GHWindow,ht);
  }

 DeleteHelpText(ht);
 FreeVec(nw);
}

/* ---- Zeitimpuls */
void GadHelpTimer(we,mm)
 struct WindowEntry  *we;
 struct MultiMessage *mm;
{
 struct MWGadget         *gad;
 struct MultiWindowsUser *mw;
 UBYTE                   *help;
 APTR                     a,b,c;

 USER;
 if(mw->HelpOn==FALSE) return;

 if(we->MHScreen!=NULL)
  {
   a=we->MHMenu;
   b=we->MHMenuItem;
   c=we->MHSubItem;
   FindActiveItem(we);
   if((a!=we->MHMenu)||(b!=we->MHMenuItem)||(c!=we->MHSubItem))
     we->GHTime=0;
   we->GHTime++;
   if(we->GHTime==MultiWindowsBase->HelpAvoidFlicker)
     MenuHelpUpdate(we);
  }
 else
  {
   if(mw->HasGadgetHelp)
    {
     gad=we->GHGadget;
     if((we->GHWindow==NULL)&&(gad!=NULL))
      {
       we->GHTime+=10;
       if(we->GHTime>=MultiWindowsBase->HelpTicks)
        {
         help=FindID(mw->Catalog,gad->HelpID);
         GadHelpOpen(we,gad,help);
        }
      }
    }
  }
}

/* ---- Mausbewegung */
void GadHelpMouse(we,mm)
 struct WindowEntry  *we;
 struct MultiMessage *mm;
{
 struct Node         *node;
 struct MWGadget     *gad;
 struct MWGadget     *found;
 struct MXData       *mx;
 struct ListviewData *ld;
 UWORD                 x,y,x1,y1,x2,y2;

 x=mm->ObjectData[0];
 y=mm->ObjectData[1];

 found=NULL;
 for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
  {
   gad=node;

   if((gad->Type==MWGAD_GADTOOLS)&&(gad->Kind==MX_KIND))
    {
     mx=gad->ExtData;
     x1=mx->X1;
     y1=mx->Y1;
     x2=mx->X2;
     y2=mx->Y2;
    }
   else if((gad->Type==MWGAD_GADTOOLS)&&(gad->Kind==LISTVIEW_KIND))
    {
     ld=gad->ExtData;
     x1=ld->X1;
     y1=ld->Y1;
     x2=ld->X2;
     y2=ld->Y2;
    }
   else
    {
     x1=gad->NewGadget.ng_LeftEdge;
     y1=gad->NewGadget.ng_TopEdge;
     x2=x1+gad->NewGadget.ng_Width;
     y2=y1+gad->NewGadget.ng_Height;
    }

   if((x1<=x)&&(y1<=y) && (x2>=x)&&(y2>=y))
    {
     found=gad;
     break;
    }
  }
 if((found==NULL)||(found->HelpID==0))
  {
   GadHelpClose(we);
   return;
  }

 if(found!=we->GHGadget)
  {
   we->GHGadget=found;
   we->GHTime=0;
  }
}

/* ---- Online-Hilfe und Developer-Items updaten */
void UpdateHelpItems()
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 int                      i;

 USER;
 for(i=0;i<MAXWINDOWS;i++)
  {
   we=mw->WindowList[i];
   if(we!=NULL)
    {
     if((we->MenuOn)&&(!we->Iconify))
       ClearMenuStrip(we->Window);

     if(mw->HelpOn)
       we->HelpOnItem->MenuItem.Flags |= CHECKED;
     else
       we->HelpOnItem->MenuItem.Flags &= ~CHECKED;
     if(mw->DeveloperOn)
       we->DeveloperOnItem->MenuItem.Flags |= CHECKED;
     else
       we->DeveloperOnItem->MenuItem.Flags &= ~CHECKED;

     if((we->MenuOn)&&(!we->Iconify))
       SetMenuStrip(we->Window,we->FirstMenu);
    }
  }
}

/* ---- Hilfe einschalten */
void HelpOn()
{
 struct MultiWindowsUser *mw;

 USER;
 mw->HelpOn=TRUE;
 UpdateHelpItems();
}

/* ---- Hilfe ausschalten */
void HelpOff()
{
 struct MultiWindowsUser *mw;
 int                     i;

 USER;
 mw->HelpOn=FALSE;
 UpdateHelpItems();
 for(i=0;i<MAXWINDOWS;i++)
  {
   if(mw->WindowList[i])
    {
     GadHelpClose(mw->WindowList[i]);
     MenuHelpClose(mw->WindowList[i]);
     mw->WindowList[i]->GHGadget=NULL;
    }
  }
}

/* ---- Developer-Modus einschalten */
void DeveloperOn()
{
 struct MultiWindowsUser *mw;

 USER;
 mw->DeveloperOn=TRUE;
 UpdateHelpItems();
}

/* ---- Developer-Modus ausschalten */
void DeveloperOff()
{
 struct MultiWindowsUser *mw;

 USER;
 mw->DeveloperOn=FALSE;
 UpdateHelpItems();
}

/* ---- Hilfetext erstellen */
struct HelpText *CreateHelpText(we,helpStr)
 struct WindowEntry *we;
 UBYTE              *helpStr;
{
 struct MultiWindowsUser *mw;
 UBYTE                   *help;
 struct HelpText         *ht;
 struct RastPort         *rp;
 struct TextFont         *font;
 int                      i,len;

 /* ---- Speicher beschaffen, Vorbereitungen treffen ------------- */

 USER;
 font=mw->TextFont;

 len=strlen(helpStr);
 ht=AllocVec(sizeof(struct HelpText)+len+2,MEMF_ANY);
 if(ht==NULL) return(NULL);

 strcpy(&ht->HelpString,helpStr);
 help=&ht->HelpString;

 BackupRP(we);
 rp=we->RastPort;
 SetFont(rp,font);

 /* ---- Hilfetext auswerten ------------------------------------- */

 ht->Lines=0;
 ht->Width=0;
 ht->HelpLine[0].String=help;
 ht->HelpLine[0].Flags=0;
 ht->HelpLine[0].Pen=we->DrawInfo->dri_Pens[TEXTPEN];

 for(i=0;i<len;i++)
  {
   if(help[i]=='\n')
    {
     help[i]=0x00;
     if(i<len)
      {
       if(ht->Lines==9)
         break;
       else
        {
         ht->HelpLine[ht->Lines].Width=TextLength(rp,ht->HelpLine[ht->Lines].String,
                                                  strlen(ht->HelpLine[ht->Lines].String));
         if(ht->HelpLine[ht->Lines].Width>ht->Width) ht->Width=ht->HelpLine[ht->Lines].Width;
         ht->Lines++;
         ht->HelpLine[ht->Lines].String=&help[i+1];
         ht->HelpLine[ht->Lines].Flags=0;
         ht->HelpLine[ht->Lines].Pen=we->DrawInfo->dri_Pens[TEXTPEN];
        }
      }
    }
   /* ----Kommando-Auswertung --------------------------------- */
   else if(help[i]=='~')
    {
     if((i+1<len)&&(help[i+1]!='~'))
      {
       ht->HelpLine[ht->Lines].String=&help[i+2];
       switch(help[i+1])
        {
         case 'C':
           ht->HelpLine[ht->Lines].Flags |= HLF_CENTER;
          break;
         case 'R':
           ht->HelpLine[ht->Lines].Flags |= HLF_RIGHT;
          break;
         case 'U':
           ht->HelpLine[ht->Lines].Flags |= HLF_UNDERLINE;
          break;
         case 'B':
           ht->HelpLine[ht->Lines].Flags |= HLF_BOLD;
          break;
         case 'I':
           ht->HelpLine[ht->Lines].Flags |= HLF_ITALIC;
          break;
        }
       i++;
      }
    }
  }
 /* ---- Abschließende Berechnungen -------------------------------- */
 ht->HelpLine[ht->Lines].Width=TextLength(rp,ht->HelpLine[ht->Lines].String,
                                          strlen(ht->HelpLine[ht->Lines].String));
 if(ht->HelpLine[ht->Lines].Width>ht->Width) ht->Width=ht->HelpLine[ht->Lines].Width;
 ht->Height=(ht->Lines+1)*(font->tf_YSize+rp->TxSpacing)+6;
 RestoreRP(we);

 ht->Width+=30;
 return(ht);
}

/* ---- Hilfetext löschen */
void DeleteHelpText(ht)
 struct HelpText *ht;
{
 FreeVec(ht);
}

void ShowHelpText(win,ht)
 struct Window   *win;
 struct HelpText *ht;
{
 struct MultiWindowsUser *mw;
 struct RastPort         *rp;
 struct TextFont         *font;

 /* ---- Vorbereitungen ------------------------------------------- */
 USER;
 rp=win->RPort;

 ShowWallpaperWindow(win,MultiWindowsBase->HelpWallpaper);
 SetDrMd(rp,JAM1);
 SetFont(rp,mw->TextFont);
 PrintHT(rp,mw->TextFont,ht,win->Width,win->BorderTop,win->BorderLeft,win->BorderRight);
}

/* ---- Hilfetext-Ausgabe */
void PrintHT(rp,font,ht,Width,BorderTop,BorderLeft,BorderRight)
 struct RastPort *rp;
 struct TextFont *font;
 struct HelpText *ht;
 int              Width,BorderTop,BorderLeft,BorderRight;
{
 int flags,x,y,w,i;

 x=15+BorderLeft;
 w=(Width-BorderLeft-BorderRight)-30;

 for(i=0;i<=ht->Lines;i++)
  {
   flags=FS_NORMAL;
   if(ht->HelpLine[i].Flags & HLF_UNDERLINE) flags = FSF_UNDERLINED;
   if(ht->HelpLine[i].Flags & HLF_BOLD) flags |= FSF_BOLD;
   if(ht->HelpLine[i].Flags & HLF_ITALIC) flags |= FSF_ITALIC;
   SetSoftStyle(rp,flags,AskSoftStyle(rp));
   SetAPen(rp,ht->HelpLine[i].Pen);

   if(ht->HelpLine[i].Flags & HLF_CENTER)
     flags=JSF_CENTER;
   else if(ht->HelpLine[i].Flags & HLF_RIGHT)
     flags=JSF_RIGHT;
   else
     flags=JSF_LEFT;

   y=BorderTop+3+(i*(font->tf_YSize+rp->TxSpacing));

   WriteText(rp,x,y,w,font->tf_YSize,
                ht->HelpLine[i].String,flags);
  }
}

