/* Menüs */
#include "multiwindows.h"

extern struct ExecBase         *SysBase;
extern struct MultiWindowsBase *MultiWindowsBase;
extern struct MultiDesktopBase *MultiDesktopBase;

void GetCommand();
void SysItemHandler();
void MasterItem();
void CallItemAction();

/* ---- Menüpunkt wurde ausgewählt */
void MenuPick(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 UWORD              code;
 struct MWMenuItem *item;

 we->MenuInUse=FALSE;
 MenuHelpClose(we);
 mm->Class=MULTI_MENUPICK;
 code=msg->Code;

 item=ItemAddress(we->FirstMenu,code);
 if(item==NULL) return;
 if(item->Flags & CMI_BARITEM) return;

 mm->Class=MULTI_MENUPICK;
 mm->ObjectID=item->ItemID;
 mm->ObjectAddress=item;
 if(item->MenuItem.Flags & CHECKED) mm->ObjectCode=TRUE;

 if(item->ItemAction)
  { 
   if((we->MenuOn)&&(!we->Iconify))
     ClearMenuStrip(we->Window);
   CallItemAction(we,item);
   if((we->MenuOn)&&(!we->Iconify))
     SetMenuStrip(we->Window,we->FirstMenu);
  }

 SysItemHandler(item);
}

/* ---- System-Item-Behandlung */
void SysItemHandler(item)
 struct MWMenuItem *item;
{

 if(item->Flags & CMI_SYSITEM)
  {
   switch(item->ItemID)
    {
     case STDITEM_ONLINEHELP:
       if(item->MenuItem.Flags & CHECKED) HelpOn(); else HelpOff();
      break;
     case STDITEM_LOADGUIDE:
      break;
     case STDITEM_ABOUTHELP:
      break;
     case STDITEM_DEVELOPER:
       if(item->MenuItem.Flags & CHECKED) DeveloperOn(); else DeveloperOff();
      break;
    }
   return;
  }
}

/* ---- Menüauswahl vorbereiten */
void MenuVerify(we)
 struct WindowEntry *we;
{
 we->MenuInUse=TRUE;
 GadHelpClose(we);
 MenuHelpOpen(we);
}

/* ---- Länge eines Textes in Pixeln ermitteln */
UWORD PixelLength(font,text)
 struct TextFont    *font;
 UBYTE              *text;
{
 struct RastPort rp;

 InitRastPort(&rp);
 SetFont(&rp,font);
 return(TextLength(&rp,text,strlen(text)));
}

/* ---- we->Last... updaten  */
void UpdateLast(we)
 struct WindowEntry *we;
{
 struct MWMenu      *menu;
 struct MWMenuItem  *item;
 struct MWMenuItem  *sub;

 WE;
 if(we==NULL) return;

 we->LastMenu=NULL;
 we->LastMenuItem=NULL;
 we->LastSubItem=NULL;

 menu=we->FirstMenu;
 while(menu!=NULL)
  {
   we->LastMenu=menu;
   item=menu->Menu.FirstItem;
   while(item!=NULL)
    {
     we->LastMenuItem=item;
     sub=item->MenuItem.SubItem;
     while(sub!=NULL)
      {
       we->LastSubItem=sub;
       sub=sub->MenuItem.NextItem;
      }
     item=item->MenuItem.NextItem;
    }
   menu=menu->Menu.NextMenu;
  }
}

/* ---- Menüleiste einschalten */
void ShowMenu()
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 if(we->FirstMenu==NULL) return;

 we->MenuOn=TRUE;
 UpdateLast(we);

 if(!we->Iconify)
   SetMenuStrip(we->Window,we->FirstMenu);
}

/* ---- Menüleiste ausschalten */
void HideMenu()
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 if(we->FirstMenu==NULL) return;

 we->MenuOn=FALSE;
 if(!we->Iconify)
   ClearMenuStrip(we->Window);
}

/* ---- Menüspeicher freigeben */
void DisposeMenu(we)
 struct WindowEntry *we;
{
 struct MWMenu     *menu,*oldmenu;
 struct MWMenuItem *item,*olditem;
 struct MWMenuItem *sub,*oldsub;

 menu=we->FirstMenu;
 while(menu!=NULL)
  {
   item=menu->Menu.FirstItem;
   while(item!=NULL)
    {
     sub=item->MenuItem.SubItem;
     while(sub!=NULL)
      {
       oldsub=sub;
       if(sub->String[0]) FREE2(sub->String[0]);
       if(sub->String[1]) FREE2(sub->String[1]);
       FreeMemory(&sub->Remember);
       FREE2(sub);
       sub=oldsub->MenuItem.NextItem;
      }
     olditem=item;
     if(item->String[0]) FREE2(item->String[0]);
     if(item->String[1]) FREE2(item->String[1]);
     FreeMemory(&item->Remember);
     FREE2(item);
     item=olditem->MenuItem.NextItem;
    }
   oldmenu=menu;
   FREE2(menu);
   menu=oldmenu->Menu.NextMenu;
  }
}

/* ---- Menü löschen */
void KillMenu()
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;

 we->LastMenu=NULL;
 we->LastMenuItem=NULL;
 we->LastSubItem=NULL;

 if(we->FirstMenu)
  {
   DisposeMenu(we);
   we->FirstMenu=NULL;
   we->MenuOn=FALSE;
   if(!we->Iconify) ClearMenuStrip(we->Window);
  }
}

/* ---- Menü suchen */
struct MWMenu *FindMenu(menuID)
 ULONG menuID;
{
 struct WindowEntry *we;
 struct MWMenu      *menu;
 struct MWMenu      *prev;

 WE;
 if(we==NULL) return(NULL);

 prev=NULL;
 menu=we->FirstMenu;
 while(menu!=NULL)
  {
   if(menu->MenuID==menuID)
    {
     menu->FindPrevMenu=prev;
     return(menu);
    }
   prev=menu;
   menu=menu->Menu.NextMenu;
  }
 return(NULL);
}

/* ---- Item suchen */
struct MWMenuItem *FindItem(itemID)
 ULONG itemID;
{
 struct WindowEntry *we;
 struct MWMenu      *menu;
 struct MWMenuItem  *item;
 struct MWMenuItem  *prev;

 WE;
 if(we==NULL) return(NULL);

 menu=we->FirstMenu;
 while(menu!=NULL)
  {
   prev=NULL;
   item=menu->Menu.FirstItem;
   while(item!=NULL)
    {
     if(item->ItemID==itemID)
      {
       item->FindPrevItem=prev;
       item->FindMenu=menu;
       return(item);
      }
     prev=item;
     item=item->MenuItem.NextItem;
    }
   menu=menu->Menu.NextMenu;
  }
 return(NULL);
}

/* ---- Menü oder Item suchen */
struct MWMenuItem *FindMenuOrItem(findID,type)
 ULONG  findID;
 UBYTE *type;
{
 struct WindowEntry *we;
 struct MWMenu      *menu;
 struct MWMenuItem  *item;
 struct MWMenu      *prev;
 struct MWMenuItem  *prevItem;

 WE;
 if(we==NULL) return(NULL);

 prev=NULL;
 menu=we->FirstMenu;
 while(menu!=NULL)
  {
   if(menu->MenuID==findID)
    {
     menu->FindPrevMenu=menu;
     *type=FINDTYPE_MENU;
     return(menu);
    }
   prevItem=NULL;
   item=menu->Menu.FirstItem;
   while(item!=NULL)
    {
     if(item->ItemID==findID)
      {
       item->FindPrevItem=prevItem;
       item->FindMenu=menu;
       *type=FINDTYPE_ITEM;
       return(item);
      }
     prevItem=item;
     item=item->MenuItem.NextItem;
    }
   prev=menu;
   menu=menu->Menu.NextMenu;
  }
 return(NULL);
}

/* ---- Sub-Item suchen */
struct MWMenuItem *FindSubItem(subID)
 ULONG subID;
{
 struct WindowEntry *we;
 struct MWMenu      *menu;
 struct MWMenuItem  *item;
 struct MWMenuItem  *sub;
 struct MWMenuItem  *prev;

 WE;
 if(we==NULL) return(NULL);

 menu=we->FirstMenu;
 while(menu!=NULL)
  {
   item=menu->Menu.FirstItem;
   while(item!=NULL)
    {
     prev=NULL;
     sub=item->MenuItem.SubItem;
     while(sub!=NULL)
      {
       if(sub->ItemID==subID)
        {
         sub->FindPrevItem=prev;
         sub->FindMenu=menu;
         sub->FindMasterItem=item;
         return(sub);
        }
       prev=item;
       sub=sub->MenuItem.NextItem;
      }
     item=item->MenuItem.NextItem;
    }
   menu=menu->Menu.NextMenu;
  }
 return(NULL);
}

/* ---- Item oder Sub-Item suchen */
struct MWMenuItem *FindItemOrSubItem(findID)
 ULONG findID;
{
 struct WindowEntry *we;
 struct MWMenu      *menu;
 struct MWMenuItem  *item;
 struct MWMenuItem  *sub;
 struct MWMenuItem  *prev,*prevSub;

 WE;
 if(we==NULL) return(NULL);

 menu=we->FirstMenu;
 while(menu!=NULL)
  {
   item=menu->Menu.FirstItem;
   prev=NULL;
   while(item!=NULL)
    {
     if(item->ItemID==findID)
      {
       item->FindPrevItem=prev;
       item->FindMenu=menu;
       item->FindMasterItem=NULL;
       return(item);
      }
    prevSub=NULL;
    sub=item->MenuItem.SubItem;
     while(sub!=NULL)
      {
       if(sub->ItemID==findID)
        {
         sub->FindPrevItem=prevSub;
         sub->FindMenu=menu;
         sub->FindMasterItem=item;
         return(sub);
        }
       prevSub=sub;
       sub=sub->MenuItem.NextItem;
      }
     prev=item;
     item=item->MenuItem.NextItem;
    }
   menu=menu->Menu.NextMenu;
  }
 return(NULL);
}

/* ---- Menü entfernen */
void RemMenu(menuID)
 ULONG menuID;
{
 struct WindowEntry *we;
 struct MWMenu      *menu,*next;
 WORD                width;

 WE;
 if(we==NULL) return;

 menu=FindMenu(menuID);
 if(menu==NULL) return;

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 /* ---- Menü aus Liste entfernen ----------------------------- */

 if(menu->FindPrevMenu)
   menu->FindPrevMenu->Menu.NextMenu=menu->Menu.NextMenu;
 else
   we->FirstMenu=menu->Menu.NextMenu;

 next=menu->Menu.NextMenu;
 width=menu->Menu.Width;
 FREE2(menu);

 /* ---- Folgende Menüs korrigieren --------------------------- */
 while(next!=NULL)
  {
   next->Menu.LeftEdge-=width;
   next->NextLeftEdge-=width;
   next=next->Menu.NextMenu;
  }

 UpdateLast(we);

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);
}

/* ---- Menü disablen */
void DisableMenu(menuID)
 ULONG menuID;
{
 struct WindowEntry *we;
 struct MWMenu      *menu;

 WE;
 if(we==NULL) return;
 menu=FindMenu(menuID);
 if(menu==NULL) return;


 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 menu->Menu.Flags &= ~MENUENABLED;

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);
}

/* ---- Menü enablen */
void EnableMenu(menuID)
 ULONG menuID;
{
 struct WindowEntry *we;
 struct MWMenu      *menu;

 WE;
 if(we==NULL) return;
 menu=FindMenu(menuID);
 if(menu==NULL) return;


 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 menu->Menu.Flags |= MENUENABLED;

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);
}

/* ---- Menü initialisieren */
struct MWMenu *InitMenu(we,menuID,helpID,textID,flags)
 struct WindowEntry *we;
 ULONG menuID;
 ULONG helpID;
 ULONG textID;
 UWORD flags;
{
 UBYTE                   *text;
 struct MultiWindowsUser *mw;
 struct MWMenu           *menu;

 USER;
 menu=ALLOC2(sizeof(struct MWMenu));
 if(menu==NULL) { NoMemory(); return(NULL); }

 text=FindID(mw->Catalog,textID);
 menu->Menu.TopEdge=0;
 menu->Menu.Width=PixelLength(we->Screen->RastPort.Font,text)+10;
 menu->Menu.Height=mw->TextFont->tf_YSize;
 if(!(flags & CME_DISABLE)) menu->Menu.Flags=MENUENABLED;
 menu->Menu.MenuName=text;

 menu->MenuID=menuID;
 menu->TextID=textID;
 menu->HelpID=helpID;
 menu->Flags=flags;

 return(menu);
}

/* ---- Menü hinzufügen */
BOOL AddMenu(menuID,helpID,textID,flags)
 ULONG menuID;
 ULONG helpID;
 ULONG textID;
 UWORD flags;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct MWMenu           *menu,*prev;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 menu=InitMenu(we,menuID,helpID,textID,flags);
 if(menu==NULL) return(FALSE);

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 /* ---- Menüstruktur einrichten ------------- */
 prev=we->LastMenu;
 if(prev!=NULL)
   menu->Menu.LeftEdge=prev->NextLeftEdge;
 else
   menu->Menu.LeftEdge=5;
 menu->NextLeftEdge=menu->Menu.LeftEdge+menu->Menu.Width;

 /* ---- Menü an Liste anfügen --------------- */
 if(prev!=NULL)
   prev->Menu.NextMenu=menu;
 else
   we->FirstMenu=menu;

 we->LastMenu=menu;
 we->LastMenuItem=NULL;
 we->LastSubItem=NULL;

 if((we->MenuOn)&&(!we->Iconify))
  SetMenuStrip(we->Window,we->FirstMenu);

 return(TRUE);
}

BOOL InsertMenu(prevID,menuID,helpID,textID,flags)
 ULONG prevID;
 ULONG menuID;
 ULONG helpID;
 ULONG textID;
 UWORD flags;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct MWMenu           *menu,*prev;
 WORD                     width;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 /* ---- Menü initialisieren ------------------------- */
 if(prevID==INSERTID_HEAD)
   prev=NULL;
 else if(prevID==INSERTID_TAIL)
  {
   prev=we->FirstMenu;
   if(prev!=NULL)
    { while(prev->Menu.NextMenu!=NULL) prev=prev->Menu.NextMenu; }
  }
 else
  {
   prev=FindMenu(prevID);
   if(prev==NULL) return(FALSE);
  }

 menu=InitMenu(we,menuID,helpID,textID,flags);
 if(menu==NULL) return(FALSE);

 /* ---- Menü in Liste einfügen ---------------------- */

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 if(prev)
  {
   menu->Menu.LeftEdge=prev->NextLeftEdge;
   menu->Menu.NextMenu=prev->Menu.NextMenu;
   prev->Menu.NextMenu=menu;
  }
 else
  {
   menu->Menu.LeftEdge=5;
   menu->Menu.NextMenu=we->FirstMenu;
   we->FirstMenu=menu;
  }
 width=menu->Menu.Width;
 menu->NextLeftEdge=menu->Menu.LeftEdge+width;

 /* ---- Folgende Menüs korrigieren --------------------------- */
 menu=menu->Menu.NextMenu;
 while(menu!=NULL)
  {
   menu->Menu.LeftEdge+=width;
   menu->NextLeftEdge+=width;
   menu=menu->Menu.NextMenu;
  }

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);
 return(TRUE);
}

/* ---- Barlabel updaten */
void UpdateBarlabel(we,item,width)
 struct WindowEntry *we;
 struct MWMenuItem  *item;
 WORD                width;
{
 struct MultiWindowsUser *mw;
 WORD                     i,l1,add1;

 USER;

 add1=(width/mw->BarCharSize);
 l1=add1+2;
 if(item->String[0]) FREE2(item->String[0]);
 item->String[0]=ALLOC2(l1);
 if(item->String[0]!=NULL)
  {
   for(i=0;i<add1;i++)
     item->String[0][i]=MultiWindowsBase->MenuBarChar;
   item->String[0][i]=0x00;
   item->ItemText[0].IText=item->String[0];
  }
 else
   NoMemory();
}

/* ---- MenuItem initialisieren */
struct MWMenuItem *InitItem(we,leftEdge,boxWidth,commSeqWidth,first,itemID,helpID,textID1,textID2,cmd,flags)
 struct WindowEntry *we;
 WORD                leftEdge;
 WORD               *boxWidth;
 WORD               *commSeqWidth;
 struct MWMenuItem  *first;
 ULONG               itemID;
 ULONG               helpID;
 ULONG               textID1;
 ULONG               textID2;
 UBYTE              *cmd;
 UWORD               flags;
{
 BOOL                     correction;
 UBYTE                   *text1,*text2;
 struct MultiWindowsUser *mw;
 struct MWMenuItem       *item,*sub;
 int                      width,i,s1,s2,l1,l2,add1,add2;

 USER;
 item=ALLOC2(sizeof(struct MWMenuItem));
 if(item==NULL) { NoMemory(); return(NULL); }

 correction=FALSE;
 if(textID1!=0)
  {
   text1=FindID(mw->Catalog,textID1);

   /* ---- Textbreite berechnen, Strings kopieren ------------------ */
   add1=0;
   add2=0;
   width=PixelLength(mw->TextFont,text1);
   if(textID2!=NULL)
    {
     text2=FindID(mw->Catalog,textID2);

     /* --- Stringlängen angleichen ---------------- */
     i=PixelLength(mw->TextFont,text2);
     if(width>i) add2=1+((width-i)/mw->SpaceSize);
     if(i>width) add1=1+((i-width)/mw->SpaceSize);
     if(i>width) width=i;

     /* --- String 2 kopieren ---------------------- */
     s2=strlen(text2);
     l2=s2+add2+2;
     item->String[1]=ALLOC2(l2);
     if(item->String[1]==NULL)
      { NoMemory(); return(NULL); }
     CopyMem(text2,item->String[1],l2);
     for(i=0;i<add2;i++)
       item->String[1][i+s2]=' ';
     item->String[1][i+s2]=0x00;
    }

   /* --- String 1 kopieren ---------------------- */
   s1=strlen(text1);
   l1=s1+add1+2;
   item->String[0]=ALLOC2(l1);
   if(item->String[0]==NULL)
    {
     if(item->String[1]) FREE2(item->String[1]);
     NoMemory(); return(NULL);
    }
   CopyMem(text1,item->String[0],l1);
   for(i=0;i<add1;i++)
     item->String[0][i+s1]=' ';
   item->String[0][i+s1]=0x00;
  }
 else
   width=0;

 /* ---- Kommandoauswertung -------------------------------------- */
 if(cmd!=NULL)
  {
   i=strlen(cmd);
   if(i==1)
    {
     item->CommandKey=cmd[0];
     item->CommandFlags=MICF_INTUITION;
     item->MenuItem.Command=cmd[0];

     i=COMMWIDTH+PixelLength(mw->TextFont,cmd);
     width+=i;

     if(i>*commSeqWidth)
      {
       *commSeqWidth=i;
       correction=TRUE;
      }
    }
   else
    {
     GetCommand(item,cmd);
     i=PixelLength(mw->TextFont,cmd);
     width+=i;
     if(i>*commSeqWidth)
      {
       *commSeqWidth=i;
       correction=TRUE;
      }
    }
  }

 width+=MultiWindowsBase->MenuCommSeqSpacing;
 if((flags & CMI_CHECKIT)||(flags & CMI_TOGGLE))  width+=CHECKWIDTH;

 if(*boxWidth<width)
  {
   width+=(width % mw->BarCharSize);
   *boxWidth=width;
   correction=TRUE;
  }

  /* ---- Barlabel-Auswertung ------------------------------------- */
 if(flags & CMI_BARITEM)
   UpdateBarlabel(we,item,*boxWidth);

 /* ---- Korrektur der vorherigen Itemgrößen -------------------- */
 if(flags & CMI_SUBITEM)
   i=*boxWidth-(*boxWidth >> 2);
 else
   i=MultiWindowsBase->MenuItemMove;

 l1=leftEdge+i+*boxWidth; /* right edge */
 if(l1>we->Screen->Width-20)
  {
   if((flags & CMI_SUBITEM)&&(l1-(i/2)>we->Screen->Width-20))
     i=-i;
    else
     i-=(l1-(we->Screen->Width-20));
  }

 if(correction)
  {
   while(first!=NULL)
    {
     first->MenuItem.Width=*boxWidth;
     first->MenuItem.LeftEdge=i;

     if(!(first->Flags & CMI_MASTERITEM))
       first->ItemText[2].LeftEdge=*boxWidth-*commSeqWidth;
     else
       first->ItemText[2].LeftEdge=*boxWidth-mw->SubStringSize;

     if(first->Flags & CMI_BARITEM)
       UpdateBarlabel(we,first,*boxWidth);

     first=first->MenuItem.NextItem;
    }
  }

 /* ---- Initialisieren der Strukturen --------------------------- */
 item->MenuItem.LeftEdge=i;
 item->MenuItem.Width=*boxWidth;
 item->MenuItem.Height=mw->TextFont->tf_YSize+MultiWindowsBase->MenuLineSpacing;

 if(flags & CMI_SUBITEM)
  {
   i=mw->TextFont->tf_YSize+MultiWindowsBase->MenuLineSpacing;
   item->MenuItem.TopEdge=i-(i >> 2);
  }

 if(flags & CMI_BARITEM)
   item->MenuItem.Flags=ITEMTEXT|HIGHNONE|ITEMENABLED;
 else
  {
   item->MenuItem.Flags=ITEMTEXT|HIGHCOMP|ITEMENABLED;

   if(item->CommandFlags==MICF_INTUITION)
     item->MenuItem.Flags |= COMMSEQ;
   if(flags & CMI_DISABLE) item->MenuItem.Flags &= ~ITEMENABLED;
   if(flags & CMI_TOGGLE)
     item->MenuItem.Flags |= MENUTOGGLE|CHECKIT;
   if(flags & CMI_CHECKIT)
     item->MenuItem.Flags |= CHECKIT;
   if(flags & CMI_CHECKED)
     item->MenuItem.Flags |= CHECKED;
  }

 for(i=0;i<2;i++)
   CopyMemQuick(GetTextAttr(),&item->TextAttr[i],sizeof(struct TextAttr));

 if(flags & CMI_T1BOLD)   item->TextAttr[0].ta_Style |= FSF_BOLD;
 if(flags & CMI_T1ITALIC) item->TextAttr[0].ta_Style |= FSF_ITALIC;
 if(flags & CMI_T2BOLD)   item->TextAttr[1].ta_Style |= FSF_BOLD;
 if(flags & CMI_T2ITALIC) item->TextAttr[1].ta_Style |= FSF_ITALIC;

 item->MenuItem.ItemFill=&item->ItemText[0];
 if((flags & CMI_CHECKIT)||(flags & CMI_TOGGLE))
   item->ItemText[0].LeftEdge=CHECKWIDTH;
 item->ItemText[0].TopEdge=1;
 item->ItemText[0].DrawMode=AUTODRAWMODE;
 item->ItemText[0].FrontPen=AUTOFRONTPEN;
 item->ItemText[0].BackPen=AUTOBACKPEN;
 item->ItemText[0].ITextFont=&item->TextAttr[0];
 item->ItemText[0].IText=item->String[0];

 if(item->CommandFlags!=MICF_INTUITION)
  {
   item->ItemText[0].NextText=&item->ItemText[2];
   item->ItemText[2].LeftEdge=*boxWidth-*commSeqWidth;
   item->ItemText[2].TopEdge=1;
   item->ItemText[2].DrawMode=AUTODRAWMODE;
   item->ItemText[2].FrontPen=AUTOFRONTPEN;
   item->ItemText[2].BackPen=AUTOBACKPEN;
   item->ItemText[2].ITextFont=mw->BoldTextAttr;
   item->ItemText[2].IText=cmd;
  }

 if(item->String[1]!=NULL)
  {
   item->MenuItem.Flags &= ~HIGHCOMP;
   item->MenuItem.Flags |= HIGHIMAGE;
   item->MenuItem.SelectFill=&item->ItemText[1];
   if((flags & CMI_CHECKIT)||(flags & CMI_TOGGLE))
     item->ItemText[1].LeftEdge=CHECKWIDTH;
   item->ItemText[1].TopEdge=1;
   item->ItemText[1].DrawMode=AUTODRAWMODE;
   item->ItemText[1].FrontPen=AUTOFRONTPEN;
   item->ItemText[1].BackPen=AUTOBACKPEN;
   item->ItemText[1].ITextFont=&item->TextAttr[1];
   item->ItemText[1].IText=item->String[1];
  }

 item->ItemID=itemID;
 item->HelpID=helpID;
 item->Flags=flags;

 return(item);
}

/* ---- MenuItem hinzufügen */
BOOL AddItem(itemID,helpID,textID1,textID2,cmd,flags)
 ULONG  itemID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct MWMenu           *menu;
 struct MWMenuItem       *item,*prev;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 menu=we->LastMenu;
 if(menu==NULL) return(FALSE);

 item=InitItem(we,menu->Menu.LeftEdge,&menu->BoxWidth,&menu->KeyLeft,menu->Menu.FirstItem,itemID,helpID,textID1,textID2,cmd,flags);
 if(item==NULL) return(FALSE);

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 /* ---- Menüstruktur einrichten ------------- */
 prev=we->LastMenuItem;
 if(prev!=NULL)
   item->MenuItem.TopEdge=prev->NextTopEdge;
 item->NextTopEdge=item->MenuItem.TopEdge+item->MenuItem.Height;

 /* ---- Menü an Liste anfügen --------------- */
 if(prev!=NULL)
   prev->MenuItem.NextItem=item;
 else
   menu->Menu.FirstItem=item;

 we->LastSubItem=NULL;
 we->LastMenuItem=item;

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);

 return(TRUE);
}

/* ---- Sub-Item hinzufügen */
BOOL AddSubItem(subID,helpID,textID1,textID2,cmd,flags)
 ULONG  subID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct MWMenu           *menu;
 struct MWMenuItem       *sub,*item,*prev;
 int                      i;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 item=we->LastMenuItem;
 if(item==NULL) return(FALSE);

 i=we->LastMenu->Menu.LeftEdge+item->MenuItem.LeftEdge;
 sub=InitItem(we,i,&item->SubBoxWidth,&item->SubKeyLeft,item->MenuItem.SubItem,subID,helpID,textID1,textID2,cmd,flags | CMI_SUBITEM);
 if(sub==NULL) return(FALSE);
 MasterItem(we->LastMenu,item);

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 /* ---- Menüstruktur einrichten ------------- */
 prev=we->LastSubItem;

 if(prev!=NULL)
   sub->MenuItem.TopEdge=prev->NextTopEdge;
 sub->NextTopEdge=sub->MenuItem.TopEdge+sub->MenuItem.Height;

 /* ---- Menü an Liste anfügen --------------- */
 if(prev!=NULL)
   prev->MenuItem.NextItem=sub;
 else
   item->MenuItem.SubItem=sub;
 we->LastSubItem=sub;

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);

 return(TRUE);
}

/* ---- ToggleSelect-Item hinzufügen */
BOOL AddToggleItem(itemID,helpID,textID1,textID2,cmd,flags,checkIt)
 ULONG  itemID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
 BOOL   checkIt;
{
 if(checkIt) flags |= CMI_CHECKED;
 return(AddItem(itemID,helpID,textID1,textID2,cmd,flags | CMI_TOGGLE));
}

/* ---- ToggleSelect-Sub-Item hinzufügen */
BOOL AddSubToggleItem(subID,helpID,textID1,textID2,cmd,flags,checkIt)
 ULONG  subID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
 BOOL   checkIt;
{
 if(checkIt) flags |= CMI_CHECKED;
 return(AddSubItem(subID,helpID,textID1,textID2,cmd,flags | CMI_TOGGLE));
}

/* ----Check-Item hinzufügen */
BOOL AddCheckItem(itemID,helpID,textID1,textID2,cmd,flags,checkIt)
 ULONG  itemID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
 BOOL   checkIt;
{
 if(checkIt) flags |= CMI_CHECKED;
 return(AddItem(itemID,helpID,textID1,textID2,cmd,flags | CMI_CHECKIT));
}

/* ---- Check-Sub-Item hinzufügen */
BOOL AddSubCheckItem(subID,helpID,textID1,textID2,cmd,flags,checkIt)
 ULONG  subID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
 BOOL   checkIt;
{
 if(checkIt) flags |= CMI_CHECKED;
 return(AddSubItem(subID,helpID,textID1,textID2,cmd,flags | CMI_CHECKIT));
}

/* ---- Item verändern und abfragen */
BOOL ModifyItem(itemID,modifyFlags,flag)
 ULONG itemID;
 UBYTE modifyFlags;
 UWORD flag;
{
 BOOL                res;
 struct WindowEntry *we;
 struct MWMenuItem  *item;

 WE;
 if(we==NULL) return(FALSE);

 if(modifyFlags & MIF_SUBITEM)
   item=FindSubItem(itemID);
 else
   item=FindItem(itemID);
 if(item==NULL) return(FALSE);

 if(modifyFlags & MIF_CHECKIT)
   if(!(item->MenuItem.Flags & CHECKIT)) return(FALSE);

 res=FALSE;
 if((we->MenuOn)&&(!we->Iconify)&&(!(modifyFlags & MIF_ASK)))
   ClearMenuStrip(we->Window);

   if(modifyFlags & MIF_UNSET)
     item->MenuItem.Flags &= ~flag;
   else if(modifyFlags & MIF_SET)
     item->MenuItem.Flags |= flag;
   else
     if(item->MenuItem.Flags & flag) res=TRUE;

 if((we->MenuOn)&&(!we->Iconify)&&(!(modifyFlags & MIF_ASK)))
   SetMenuStrip(we->Window,we->FirstMenu);

 return(res);
}

/* ---- Item disablen */
void DisableItem(itemID)
 ULONG itemID;
{
 ModifyItem(itemID,MIF_UNSET,ITEMENABLED);
}

/* ---- Item enablen */
void EnableItem(itemID)
 ULONG itemID;
{
 ModifyItem(itemID,MIF_SET,ITEMENABLED);
}

/* ---- Item checken */
void CheckItem(itemID)
 ULONG itemID;
{
 ModifyItem(itemID,MIF_SET|MIF_CHECKIT,CHECKED);
}

/* ---- Item unchecken */
void UnCheckItem(itemID)
 ULONG itemID;
{
 ModifyItem(itemID,MIF_UNSET|MIF_CHECKIT,CHECKED);
}

/* ---- SubItem disablen */
void DisableSubItem(subID)
 ULONG subID;
{
 ModifyItem(subID,MIF_SUBITEM|MIF_UNSET,ITEMENABLED);
}

/* ---- SubItem enablen */
void EnableSubItem(subID)
 ULONG subID;
{
 ModifyItem(subID,MIF_SUBITEM|MIF_SET,ITEMENABLED);
}

/* ---- SubItem checken */
void CheckSubItem(subID)
 ULONG subID;
{
 ModifyItem(subID,MIF_SUBITEM|MIF_SET|MIF_CHECKIT,CHECKED);
}

/* ---- SubItem unchecken */
void UnCheckSubItem(subID)
 ULONG subID;
{
 ModifyItem(subID,MIF_SUBITEM|MIF_UNSET|MIF_CHECKIT,CHECKED);
}

/* ---- Item abfragen */
BOOL AskItem(itemID)
 ULONG itemID;
{
 return(ModifyItem(itemID,MIF_ASK|MIF_CHECKIT,CHECKED));
}

/* ---- SubItem abfragen */
BOOL AskSubItem(subID)
 ULONG subID;
{
 return(ModifyItem(subID,MIF_SUBITEM|MIF_ASK|MIF_CHECKIT,CHECKED));
}

/* ---- Item entfernen */
void RemItem(itemID)
 ULONG itemID;
{
 struct WindowEntry *we;
 struct MWMenuItem  *item,*next;
 WORD                height;

 WE;
 if(we==NULL) return;

 item=FindItem(itemID);
 if(item==NULL) return;

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 /* ---- Item aus Liste entfernen ----------------------------- */

 if(item->FindPrevItem)
   item->FindPrevItem->MenuItem.NextItem=item->MenuItem.NextItem;
 else
   item->FindMenu->Menu.FirstItem=item->MenuItem.NextItem;

 next=item->MenuItem.NextItem;
 height=item->MenuItem.Height;
 if(item->String[0]) FREE2(item->String[0]);
 if(item->String[1]) FREE2(item->String[1]);
 FreeMemory(&item->Remember);
 FREE2(item);

 /* ---- Folgende Items korrigieren --------------------------- */
 while(next!=NULL)
  {
   next->MenuItem.TopEdge-=height;
   next->NextTopEdge-=height;
   next=next->MenuItem.NextItem;
  }

 UpdateLast(we);

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);
}

/* ---- SubItem entfernen */
void RemSubItem(subID)
 ULONG subID;
{
 struct WindowEntry *we;
 struct MWMenuItem  *sub,*next;
 WORD                height;

 WE;
 if(we==NULL) return;

 sub=FindSubItem(subID);
 if(sub==NULL) return;

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 /* ---- Item aus Liste entfernen ----------------------------- */

 we->LastMenu=NULL;
 we->LastMenuItem=NULL;
 we->LastSubItem=NULL;

 if(sub->FindPrevItem)
   sub->FindPrevItem->MenuItem.NextItem=sub->MenuItem.NextItem;
 else
   sub->FindMasterItem->MenuItem.SubItem=sub->MenuItem.NextItem;

 next=sub->MenuItem.NextItem;
 height=sub->MenuItem.Height;
 if(sub->String[0]) FREE2(sub->String[0]);
 if(sub->String[1]) FREE2(sub->String[1]);
 FreeMemory(&sub->Remember);
 FREE2(sub);

 /* ---- Folgende Items korrigieren --------------------------- */
 while(next!=NULL)
  {
   next->MenuItem.TopEdge-=height;
   next->NextTopEdge-=height;
   next=next->MenuItem.NextItem;
  }

 UpdateLast(we);

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);
}

/* ---- Bar-Item hinzufügen */
BOOL AddBarItem(itemID)
 ULONG  itemID;
{
 return(AddItem(itemID,0,0,0,0,CMI_BARITEM));
}

/* ---- Bar-Sub-Item hinzufügen */
BOOL AddSubBarItem(subID)
 ULONG  subID;
{
 return(AddSubItem(subID,0,0,0,0,CMI_BARITEM));
}

/* ---- Menü-Item einfügen */
BOOL InsertItem(prevID,itemID,helpID,textID1,textID2,cmd,flags)
 ULONG  prevID;
 ULONG  itemID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
{
 UBYTE                    type;
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct MWMenu           *menu;
 struct MWMenuItem       *item,*prev;
 int                      height;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 prev=FindMenuOrItem(prevID,&type);
 if(prev==NULL) return(FALSE);

 if(type==FINDTYPE_ITEM)
  { menu=prev->FindMenu; }
 else
  {
   menu=prev;    /* prevID ist ein Menü, kein Item */
   prev=NULL;
  }

 item=InitItem(we,menu->Menu.LeftEdge,&menu->BoxWidth,&menu->KeyLeft,menu->Menu.FirstItem,itemID,helpID,textID1,textID2,cmd,flags);
 if(item==NULL) return(FALSE);

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 /* ---- Menüstruktur einrichten ------------- */
 if(prev!=NULL)
   item->MenuItem.TopEdge=prev->NextTopEdge;

 item->NextTopEdge=item->MenuItem.TopEdge+item->MenuItem.Height;
 height=item->MenuItem.Height;

 /* ---- Menü an Liste anfügen --------------- */
 if(prev!=NULL)
  {
   item->MenuItem.NextItem=prev->MenuItem.NextItem;
   prev->MenuItem.NextItem=item;
  }
 else
  {
   item->MenuItem.NextItem=menu->Menu.FirstItem;
   menu->Menu.FirstItem=item;
  }

 /* ---- folgende Items korrigieren ---------- */
 item=item->MenuItem.NextItem;
 while(item!=NULL)
  {
   item->MenuItem.TopEdge+=height;
   item->MenuItem.NextTopEdge+=height;
   item=item->MenuItem.NextItem;
  }
 UpdateLast(we);

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);

 return(TRUE);
}

/* ---- Sub-Item einfügen */
BOOL InsertSubItem(prevID,subID,helpID,textID1,textID2,cmd,flags)
 ULONG  prevID;
 ULONG  subID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
{
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct MWMenu           *menu;
 struct MWMenuItem       *sub,*prev,*item;
 int                      i,height;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 prev=FindItemOrSubItem(prevID);
 if(prev==NULL) return(FALSE);
 item=prev->FindMasterItem;
 menu=prev->FindMenu;

 if(item==NULL)
  {
   item=prev; prev=NULL;   /* prevID ist ein Item, kein Sub-Item */
  }

 i=menu->Menu.LeftEdge+item->MenuItem.LeftEdge;
 sub=InitItem(we,i,&item->SubBoxWidth,&item->SubKeyLeft,item->MenuItem.SubItem,subID,helpID,textID1,textID2,cmd,flags | CMI_SUBITEM);
 if(sub==NULL) return(FALSE);
 MasterItem(menu,item);

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 /* ---- Menüstruktur einrichten ------------- */
 if(prev!=NULL)
   sub->MenuItem.TopEdge=prev->NextTopEdge;

 sub->NextTopEdge=sub->MenuItem.TopEdge+sub->MenuItem.Height;
 height=sub->MenuItem.Height;

 /* ---- Menü an Liste anfügen --------------- */
 if(prev!=NULL)
  {
   sub->MenuItem.NextItem=prev->MenuItem.NextItem;
   prev->MenuItem.NextItem=sub;
  }
 else
  {
   sub->MenuItem.NextItem=item->MenuItem.SubItem;
   item->MenuItem.SubItem=sub;
  }

 /* ---- folgende Items korrigieren ---------- */
 sub=sub->MenuItem.NextItem;
 while(sub!=NULL)
  {
   sub->MenuItem.TopEdge+=height;
   sub->MenuItem.NextTopEdge+=height;
   sub=sub->MenuItem.NextItem;
  }
 UpdateLast(we);

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);

 return(TRUE);
}

/* ---- Bar-Item einfügen */
BOOL InsertBarItem(prevID,itemID)
 ULONG prevID,itemID;
{
 return(InsertItem(prevID,itemID,0,0,0,0,CMI_BARITEM));
}

/* ---- Bar-Sub-Item einfügen */
BOOL InsertSubBarItem(prevID,subID)
 ULONG prevID,subID;
{
 return(InsertSubItem(prevID,subID,0,0,0,0,CMI_BARITEM));
}

/* ---- ToggleSelect-Item einfügen */
BOOL InsertToggleItem(prevID,itemID,helpID,textID1,textID2,cmd,flags,checkIt)
 ULONG  prevID;
 ULONG  itemID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
 BOOL   checkIt;
{
 if(checkIt) flags |= CMI_CHECKED;
 return(InsertItem(prevID,itemID,helpID,textID1,textID2,cmd,flags | CMI_TOGGLE));
}

/* ---- ToggleSelect-Sub-Item einfügen */
BOOL InsertSubToggleItem(prevID,subID,helpID,textID1,textID2,cmd,flags,checkIt)
 ULONG  prevID;
 ULONG  subID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
 BOOL   checkIt;
{
 if(checkIt) flags |= CMI_CHECKED;
 return(InsertSubItem(prevID,subID,helpID,textID1,textID2,cmd,flags | CMI_TOGGLE));
}

/* ----Check-Item einfügen */
BOOL InsertCheckItem(prevID,itemID,helpID,textID1,textID2,cmd,flags,checkIt)
 ULONG  prevID;
 ULONG  itemID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
 BOOL   checkIt;
{
 if(checkIt) flags |= CMI_CHECKED;
 return(InsertItem(prevID,itemID,helpID,textID1,textID2,cmd,flags | CMI_CHECKIT));
}

/* ---- Check-Sub-Item einfügen */
BOOL InsertSubCheckItem(prevID,subID,helpID,textID1,textID2,cmd,flags,checkIt)
 ULONG  prevID;
 ULONG  subID;
 ULONG  helpID;
 ULONG  textID1;
 ULONG  textID2;
 UBYTE *cmd;
 UWORD  flags;
 BOOL   checkIt;
{
 if(checkIt) flags |= CMI_CHECKED;
 return(InsertSubItem(prevID,subID,helpID,textID1,textID2,cmd,flags | CMI_CHECKIT));
}

/* ---- Command-String auswerten */
void GetCommand(item,cmd)
 struct MWMenuItem *item;
 UBYTE             *cmd;
{
 UBYTE  str[200];
 UBYTE *s;
 int    i,j,l;

 strcpy(&str,cmd);
 l=strlen(&str);

 s=&str;
 for(i=0;i<=l;i++)
  {
   if((str[i]=='-')||(str[i]=='+')||(str[i]==0x00))
    {
     str[i]=0x00;
     /* ---------------------------------- */
     j=strlen(s);
     if(j==1)
      {
       item->CommandKey=toupper(s[0]);
      }
     else
      {
       if(s[0]=='F')
        {
         if((j==2)&&(s[1]>='1')&&(s[1]<='9'))
          {
           item->CommandKey=s[1]-49;
           item->CommandFlags |= MICF_FKEY;
          }
         else if(!(strncmp(s,"F10")))
          {
           item->CommandKey=9;
           item->CommandFlags |= MICF_FKEY;
          }
        }
       else
        {
         if(!(strcmp(s,"ALT"))) item->CommandFlags |= MICF_ALT;
         else if(!(strcmp(s,"SHIFT"))) item->CommandFlags |= MICF_SHIFT;
         else if(!(strcmp(s,"CTRL"))) item->CommandFlags |= MICF_CTRL;
         else if(!(strcmp(s,"AMIGA"))) item->CommandFlags |= MICF_AMIGAR;
         else if(!(strcmp(s,"RAMIGA"))) item->CommandFlags |= MICF_AMIGAR;
         else if(!(strcmp(s,"LAMIGA"))) item->CommandFlags |= MICF_AMIGAL;
         else if(!(strcmp(s,"HELP")))
          {
           item->CommandFlags |= MICF_HELP;
           item->CommandKey=0x5f;
          }
         else
          {
           j=0;
           while(MultiWindowsBase->CommandTable[j]->CommandString!=NULL)
            {
             if(!(strcmp(s,MultiWindowsBase->CommandTable[j]->CommandString)))
              {
               item->CommandKey=MultiWindowsBase->CommandTable[j]->CommandKey;
               break;
              }
             j++;
            }
          }
        }
      }

     /* ---------------------------------- */
     i++; s=&str[i];
    }
   else
     str[i]=toupper(str[i]);
  }
}

/* ---- Standard-Menü-Texte */
UBYTE *HelpText[]=
{
 "500§Help",
 "501§~C~U~BThe 'Help' menu\nHere you can switch on/off the online help, load the guide file,\n"
    "see informations about the online help and switch on/off the developer's mode.",
 "502§Online Help",
 "503§~C~U~BThe 'Online Help' item\nHere you can switch the Online Help on or off.",
 "504§Load guide...",
 "505§~C~U~BThe 'Load guide' item\nThis item will load the guide file of the application.",
 "506§About Online Help...",
 "507§~C~U~BThe 'About Online Help' item\nHere you can see informations about the Online Help",
 "508§Developer's mode",
 "509§~C~U~BThe 'Developer's mode' item\nHere you can switch the developer's mode on or off.\n"
    "This will show informations about IDs instead of help texts.",
};

/* ---- Standard-Menüs erzeugen */
void AddStdMenus()
{
 BOOL                     bool,off;
 UWORD                    flags;
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct MWMenu           *menu;

 USER;
 WE;
 if(we==NULL) return;

 /* --- Vorbereitungen ----------------------------------------------- */
 if(we->MenuOn)
  {
   HideMenu();
   off=TRUE;
  }
 else
  off=FALSE;

 /* --- Hilfe-Menü --------------------------------------------------- */
 bool=AddMenu(-1L,HelpText[1],HelpText[0],CME_SYSMENU);
 if(bool)
  {
   menu=we->LastMenu;
   menu->Menu.LeftEdge=(we->Screen->Width-20)-menu->Menu.Width;
  }
 else
   return;

 /* --- Hilfe aktivieren --------------------------------------------- */
 bool=AddToggleItem(STDITEM_ONLINEHELP,HelpText[3],HelpText[2],0,"Shift-Help",CMI_SYSITEM,mw->HelpOn);
 if(bool) we->HelpOnItem=we->LastMenuItem;

 /* --- Guide laden -------------------------------------------------- */
 flags=CMI_SYSITEM;
 if(mw->GuideName==NULL) flags |= CMI_DISABLE;
 AddItem(STDITEM_LOADGUIDE,HelpText[5],HelpText[4],0,"Alt-Help",flags);

 /* --- About -------------------------------------------------------- */
 AddItem(-1L,0,0,0,0L,CMI_BARITEM|CMI_SYSITEM);
 AddItem(STDITEM_ABOUTHELP,HelpText[7],HelpText[6],0,"Alt-Shift-Help",CMI_SYSITEM);
 AddItem(-1L,0,0,0,0L,CMI_BARITEM|CMI_SYSITEM);

 /* --- Developer's mode --------------------------------------------- */
 bool=AddToggleItem(STDITEM_DEVELOPER,HelpText[9],HelpText[8],0,"Ctrl-Help",CMI_SYSITEM,mw->DeveloperOn);
 if(bool) we->DeveloperOnItem=we->LastMenuItem;

 if(off) ShowMenu();
}

/* ---- Ausgewähltes Item suchen */
void FindActiveItem(we)
 struct WindowEntry *we;
{
 struct MWMenu      *menu;
 struct MWMenuItem  *item;
 struct MWMenuItem  *sub;

 WE;
 if(we==NULL) return;

 we->MHMenu=NULL;
 we->MHMenuItem=NULL;
 we->MHSubItem=NULL;

 menu=we->FirstMenu;
 while(menu!=NULL)
  {
   if(menu->Menu.Flags & MIDRAWN)
    {
     we->MHMenu=menu;

     /* --- Menü ist gezeichnet ------------------------ */
     item=menu->Menu.FirstItem;
     while(item!=NULL)
      {


       if(item->MenuItem.Flags & ISDRAWN)
        {
         we->MHMenuItem=item;
         /* --- Sub-Menüs sind gezeichnet -------------- */
         sub=item->MenuItem.SubItem;
         while(sub!=NULL)
          {
           if(sub->MenuItem.Flags & HIGHITEM)
            {
             if(!(sub->Flags & CMI_BARITEM))
               we->MHSubItem=sub;
             return;
            }
           sub=sub->MenuItem.NextItem;
          }
         /* -------------------------------------------- */
         return;
        }
       else if(item->MenuItem.Flags & HIGHITEM)
        {
         /* --- Item ist selektiert -------------------- */
         if(!(item->Flags & CMI_BARITEM))
           we->MHMenuItem=item;
         /* -------------------------------------------- */
         return;
        }


       /* ---------------------------------------------- */
       item=item->MenuItem.NextItem;
      }
     /* ------------------------------------------------ */
     return;
    }
   menu=menu->Menu.NextMenu;
  }
 return;
}

/* ---- Master-Item initialisieren */
void MasterItem(menu,item)
 struct MWMenu     *menu;
 struct MWMenuItem *item;
{
 struct MultiWindowsUser *mw;

 USER;
 item->Flags |= CMI_MASTERITEM;
 item->MenuItem.Flags &= ~COMMSEQ;
 item->CommandFlags=MICF_NONE;
 item->CommandKey=0;

 item->ItemText[0].NextText=&item->ItemText[2];
 item->ItemText[2].LeftEdge=menu->BoxWidth-mw->SubStringSize;
 item->ItemText[2].TopEdge=1;
 item->ItemText[2].DrawMode=AUTODRAWMODE;
 item->ItemText[2].FrontPen=AUTOFRONTPEN;
 item->ItemText[2].BackPen=AUTOBACKPEN;
 item->ItemText[2].ITextFont=mw->BoldTextAttr;
 item->ItemText[2].IText=MultiWindowsBase->MenuSubString;
}

/* ---- RawKey nach VanillaKey konviertieren */
UBYTE ConvertToVanillaKey(code,qualifier)
 UBYTE code,qualifier;
{
 struct InputEvent ie;
 UBYTE             buffer[2];
 LONG              i;

 ie.ie_NextEvent=NULL;
 ie.ie_Class=IECLASS_RAWKEY;
 ie.ie_SubClass=0;
 ie.ie_Code=code;
 ie.ie_Qualifier=qualifier;
 ie.ie_EventAddress=NULL;
 i=MapRawKey(&ie,&buffer,1L,NULL);
 if(i==-1) return(0x00);
 return(buffer[0]);
}

/* ---- VanillaKey nach RawKey konvertieren */
void ConvertToRawKey(code,buffer)
 UBYTE  code;
 UBYTE *buffer;
{
 UBYTE str[2];

 str[0]=code;
 str[1]=0x00;
 MapANSI(&str,1,buffer,6,NULL);
}

/* ---- Menu-Item zu Tastenkombination suchen */
struct MWMenuItem *FindKeyItem(we,code,qualifier,raw)
 struct WindowEntry *we;
 UBYTE               code;
 ULONG               qualifier;
 BOOL                raw;
{
 UWORD              flags;
 struct MWMenuItem *menu;
 struct MWMenuItem *item,*sub;
 UBYTE              buffer[12];

 menu=we->FirstMenu;
 if(menu==NULL) return(NULL);
 if(menu->Menu.FirstItem==NULL) return(NULL);

 if(raw==FALSE)
  {
   ConvertToRawKey(code,&buffer);
   code=toupper(ConvertToVanillaKey(buffer[0],0));
   qualifier=buffer[1];
  }

 flags=0;
 if(qualifier & IEQUALIFIER_RALT) flags |= MICF_ALT;
 if(qualifier & IEQUALIFIER_LALT) flags |= MICF_ALT;
 if(qualifier & IEQUALIFIER_RCOMMAND) flags |= MICF_AMIGAR;
 if(qualifier & IEQUALIFIER_LCOMMAND) flags |= MICF_AMIGAL;
 if(qualifier & IEQUALIFIER_CONTROL) flags |= MICF_CTRL;
 if(qualifier & IEQUALIFIER_RSHIFT) flags |= MICF_SHIFT;
 if(qualifier & IEQUALIFIER_LSHIFT) flags |= MICF_SHIFT;
 if(raw)
  {
   if((code>=0x50)&&(code<=0x59))
    {
     flags |= MICF_FKEY;
     code-=0x50;
    }
   else if(code==0x5f)
    {
     flags |= MICF_HELP;
    }
   else
     return(NULL);
  }

 while(menu!=NULL)
  {
   item=menu->Menu.FirstItem;
   while(item!=NULL)
    {
     if((item->CommandKey==code)&&(item->CommandFlags==flags)) return(item);
     sub=item->MenuItem.SubItem;
     while(sub!=NULL)
      {
       if((sub->CommandKey==code)&&(sub->CommandFlags==flags)) return(sub);
       sub=sub->MenuItem.NextItem;
      }
     item=item->MenuItem.NextItem;
    }
   menu=menu->Menu.NextMenu;
  }

 return(NULL);
}

/* ---- Item-Aktion ausführen */
void CallItem(we,item)
 struct WindowEntry *we;
 struct MenuItem    *item;
{

 if((we->MenuOn)&&(!we->Iconify))
   ClearMenuStrip(we->Window);

 if(item->MenuItem.Flags & MENUTOGGLE)
  {
   if(item->MenuItem.Flags & CHECKED)
     item->MenuItem.Flags &= ~CHECKED;
   else
     item->MenuItem.Flags |= CHECKED;
  }
 else if(item->MenuItem.Flags & CHECKIT)
   item->MenuItem.Flags |= CHECKED;

 if(item->ItemAction) CallItemAction(we,item);

 if((we->MenuOn)&&(!we->Iconify))
   SetMenuStrip(we->Window,we->FirstMenu);
}

/* ---- ItemAction erstellen */
BOOL MakeItemAction(targetID,flags)
 ULONG targetID;
 UWORD flags;
{
 struct WindowEntry      *we;
 struct MWMenuItem       *item;
 struct ItemAction       *action;
 
 WE;
 if(we==NULL) return(FALSE);
 item=we->LastSubItem;
 if(item==NULL) item=we->LastMenuItem;
 if(item==NULL)
  {
   ErrorL(1123,"MakeItemAction():\nThere's no valid item or subitem!");
   return(FALSE);
  }

 action=AllocMemory(&item->Remember,sizeof(struct ItemAction),MEMF_PUBLIC);
 if(action==NULL)
  {
   NoMemory();
   return(FALSE);
  }
 
 action->TargetID=targetID;
 action->Flags=flags;
 action->NextItemAction=item->ItemAction;
 item->ItemAction=action;
}

/* ---- ItemAction-Liste entfernen */
void UnMakeItemAction(itemID)
 ULONG itemID;
{
 struct MWMenuItem *item;

 item=FindItemOrSubItem(itemID);
 if(item!=NULL)
  {
   item->ItemAction=NULL;
   FreeMemory(&item->Remember);
  }
}

/* ---- ItemAction ausführen */
void CallItemAction(we,item)
 struct WindowEntry *we;
 struct MWMenuItem  *item;
{
 struct ItemAction *action;
 struct MWMenuItem *target;
 UBYTE              windowID;

 windowID=ActWindow(we->WindowID);

 action=item->ItemAction;
 while(action!=NULL)
  {
   target=FindItemOrSubItem(action->TargetID);
   if(target!=NULL)
    {
     switch(action->Flags)
      {
       case IAF_UNCHECK:
         if(target->MenuItem.Flags & CHECKIT)
           target->MenuItem.Flags &= ~CHECKED;
        break;
       case IAF_CHECK:
         if(target->MenuItem.Flags & CHECKIT)
           target->MenuItem.Flags |= CHECKED;
        break;
       case IAF_DISABLE:
         target->MenuItem.Flags &= ~ITEMENABLED;
        break;
       case IAF_ENABLE:
         target->MenuItem.Flags |= ITEMENABLED;
        break;
      }
    }
   action=action->NextItemAction;
  }

 ActWindow(windowID);
}

