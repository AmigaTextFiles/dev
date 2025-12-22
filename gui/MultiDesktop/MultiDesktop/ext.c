/* Zusatzfunktionen */
#include "multiwindows.h"
#include <graphics/gfxbase.h>

void   ShowUserInfo();
void   ShowDateAndMem();
void   ShowSCSI();
UBYTE *bstr();

extern struct ExecBase         *SysBase;
extern struct MultiWindowsBase *MultiWindowsBase;
extern struct ExpansionBase    *ExpansionBase;
extern struct GfxBase          *GfxBase;
extern struct Library          *VersionBase;


/* RastPort-Daten sichern */
void BackupRP(we)
 struct WindowEntry *we;
{
 register struct RastPort *rp;
 register struct RPBackup *ba;

 ba=AllocMem(sizeof(struct RPBackup),MEMF_PUBLIC);
 if(ba==NULL) { NoMemory(); return; }

 rp=we->RastPort;
 ba->Pens[0]=rp->FgPen;
 ba->Pens[1]=rp->BgPen;
 ba->Pens[2]=rp->AOlPen;
 ba->DrawMode=rp->DrawMode;
 ba->X=rp->cp_x;
 ba->Y=rp->cp_y;
 ba->Font=rp->Font;
 ba->NextBackup=we->RPBackup;
 we->RPBackup=ba;
}

/* ---- RastPort-Daten wiederherstellen */
void RestoreRP(we)
 struct WindowEntry *we;
{
 register struct RastPort *rp;
 register struct RPBackup *ba;

 ba=we->RPBackup;
 if(ba==NULL) return;

 rp=we->RastPort;
 rp->FgPen=ba->Pens[0];
 rp->BgPen=ba->Pens[1];
 rp->AOlPen=ba->Pens[2];
 rp->DrawMode=ba->DrawMode;
 rp->cp_x=ba->X;
 rp->cp_y=ba->Y;
 SetFont(rp,ba->Font);

 we->RPBackup=ba->NextBackup;
 FreeMem(ba,sizeof(struct RPBackup));
}

/* ---- Aktuelles TextAttr ermitteln */
struct TextAttr *GetTextAttr()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->TextAttr);
}

/* ---- Aktuelles NonPropTextAttr ermitteln */
struct TextAttr *GetNonPropTextAttr()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->NonPropTextAttr);
}

/* ---- Aktuelles TextAttr ermitteln */
struct TextAttr *GetDefaultTextAttr()
{
 return(MultiWindowsBase->DefaultAttr);
}

/* ---- Aktuelles NonPropTextAttr ermitteln */
struct TextAttr *GetDefaultNonPropTextAttr()
{
 return(MultiWindowsBase->DefaultNonPropAttr);
}

/* ---- Aktuelles TextAttr ermitteln */
struct TextAttr *GetBoldTextAttr()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->BoldTextAttr);
}

/* ---- Aktuellen TextFont ermitteln */
struct TextFont *GetTextFont()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->TextFont);
}

/* ---- Aktuellen NonPropTextFont ermitteln */
struct TextFont *GetNonPropTextFont()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->NonPropTextFont);
}

/* ---- Aktuellen TextFont ermitteln */
struct TextFont *GetDefaultTextFont()
{
 return(MultiWindowsBase->DefaultFont);
}

/* ---- Aktuellen NonPropTextFont ermitteln */
struct TextFont *GetDefaultNonPropTextFont()
{
 return(MultiWindowsBase->DefaultNonPropFont);
}

/* ---- Neue X-Position */
UWORD NewX(oldX)
 UWORD oldX;
{
 REGISTER FLOAT                    newX;
 register struct MultiWindowsUser *mw;
 register struct WindowEntry      *we;
 register struct Screen           *scr;

 USER;
 WE;
 if(we==NULL) return(0);

 scr=we->Screen;
 newX=(FLOAT)oldX*mw->FactorX;
 newX=newX*we->FactorX;
 return((UWORD)newX+(scr->WBorLeft+1));
}

/* ---- Neue Y-Position */
UWORD NewY(oldY)
 UWORD oldY;
{
 REGISTER FLOAT                    newY;
 register struct MultiWindowsUser *mw;
 register struct WindowEntry      *we;
 register struct Screen           *scr;

 USER;
 WE;
 if(we==NULL) return(0);

 scr=we->Screen;
 newY=(FLOAT)oldY*mw->FactorY;
 newY=newY*we->FactorY;
 return((UWORD)newY+(UWORD)(scr->WBorTop+scr->Font->ta_YSize+1));
}

/* ---- Neue Breite */
UWORD NewWidth(oldX)
 UWORD oldX;
{
 REGISTER FLOAT                    newX;
 register struct MultiWindowsUser *mw;
 register struct WindowEntry      *we;

 USER;
 WE;
 if(we==NULL) return(0);

 newX=(FLOAT)oldX*mw->FactorX;
 newX=newX*we->FactorX;
 return((UWORD)newX);
}

/* ---- Neue Höhe */
UWORD NewHeight(oldY)
 UWORD oldY;
{
 REGISTER FLOAT                    newY;
 register struct MultiWindowsUser *mw;
 register struct WindowEntry      *we;

 USER;
 WE;
 if(we==NULL) return(0);

 newY=(FLOAT)oldY*mw->FactorY;
 newY=newY*we->FactorY;
 return((UWORD)newY);
}

/* ---- Neue X-Position */
UWORD INewX(we,oldX)
 struct WindowEntry *we;
 UWORD               oldX;
{
 REGISTER FLOAT                    newX;
 register struct MultiWindowsUser *mw;

 USER;
 newX=(FLOAT)oldX*we->FactorX;
 return((UWORD)newX+we->InnerLeftEdge);
}

/* ---- Neue Y-Position */
UWORD INewY(we,oldY)
 struct WindowEntry *we;
 UWORD               oldY;
{
 REGISTER FLOAT                    newY;
 register struct MultiWindowsUser *mw;

 USER;
 newY=(FLOAT)oldY*we->FactorY;
 return((UWORD)newY+we->InnerTopEdge);
}

/* ---- Neue Breite */
UWORD INewWidth(we,oldX)
 struct WindowEntry *we;
 UWORD               oldX;
{
 REGISTER FLOAT                    newX;
 register struct MultiWindowsUser *mw;

 USER;
 newX=(FLOAT)oldX*we->FactorX;
 return((UWORD)newX);
}

/* ---- Neue Höhe */
UWORD INewHeight(we,oldY)
 struct WindowEntry *we;
 UWORD               oldY;
{
 REGISTER FLOAT                    newY;
 register struct MultiWindowsUser *mw;

 USER;
 newY=(FLOAT)oldY*we->FactorY;
 return((UWORD)newY);
}

/* ---- Lokalisieren */
UBYTE *L(textID)
 ULONG textID;
{
 struct MultiWindowsUser *mw;

 USER;
 return(FindID(mw->Catalog,textID));
}

/* ---- String in Mac-like-Format umwandeln */
void MacFormat(rp,tex,x)
 struct RastPort *rp;
 UBYTE           *tex;
 int              x;
{
 REGISTER UWORD i,j,k,l;

 x-=15;
 if(x<0) x=0;

 k=strlen(tex);
 l=TextLength(rp,tex,k);
 if(l>x)
  {
   i=0;
   j=TextLength(rp,"...",3);
   l=j;
   do
    {
     j+=TextLength(rp,&tex[i],1L);
     i++;
    } while(j<x);
   tex[i]=0x00;
   for(j=i-1;j>0;j--)
    {
     if(tex[j]==' ') tex[j]=0x00; else break;
    }
   if(tex[0]!=0x00) strcat(tex,"...");
  }
}

/* ---- Gadget-Rahmen zeichnen (intern) */
void DrawIt(we,x,y,w,h,recessed,db,erase)
 struct WindowEntry *we;
 UWORD               x,y,w,h;
 BOOL                recessed,db,erase;
{
 UBYTE                     f,b;
 register struct RastPort *rp;
 register struct DrawInfo *di;

 BackupRP(we);
 rp=we->RastPort;
 di=we->DrawInfo;

 if(!erase)
  {
   if(!recessed)
    {
     f=di->dri_Pens[SHINEPEN];
     b=di->dri_Pens[SHADOWPEN];
    }
   else
    {
     b=di->dri_Pens[SHINEPEN];
     f=di->dri_Pens[SHADOWPEN];
    }
   w--;
   h--;

   SetAPen(rp,f);
   Move(rp,x,y+h);
   Draw(rp,x,y);
   Draw(rp,x+w,y);
   Move(rp,x+1,y+h-1);
   Draw(rp,x+1,y+1);

   SetAPen(rp,b);
   Move(rp,x+1,y+h);
   Draw(rp,x+w,y+h);
   Draw(rp,x+w,y);
   Move(rp,x+w-1,y+h-1);
   Draw(rp,x+w-1,y+1);

   if(db) DrawIt(we,x+1,y+1,w-1,h-1,!recessed,FALSE,erase);
  }
 else
  {
   RestoreBackground(we,x,y,w,2);        /* oben   */
   RestoreBackground(we,x,y,3,h);        /* links  */
   RestoreBackground(we,x+w-3,y,3,h);    /* rechts */
   RestoreBackground(we,x,y+h-2,w,2);    /* unten  */
  }
 RestoreRP(we);
}

/* ---- Gadget-Text zentrieren und ausgeben (intern) */
void  PrintText(rp,x,y,w,text)
 struct RastPort *rp;
 UWORD            x,y,w;
 UBYTE           *text;
{
 REGISTER WORD i,l;

 l=TextLength(rp,text,strlen(text));
 i=(w-l)/2;
 Move(rp,x+i,y+9);
 Text(rp,text,strlen(text));
}

/* ---- Text ausgeben */
void WriteText(rp,x,y,w,h,text,justification)
 struct RastPort *rp;
 UWORD            x,y,w,h;
 UBYTE           *text;
 UWORD            justification;
{
 register struct TextFont *tf;
 register int              i,j;

 tf=rp->Font;
 i=(h-tf->tf_YSize)/2;
 y+=(i+tf->tf_Baseline+1);
 j=strlen(text);
 i=TextLength(rp,text,j);

 switch(justification)
  {
   case JSF_CENTER:
     Move(rp,x+((w-i)/2),y);
    break;
   case JSF_RIGHT:
     Move(rp,x+w-i,y);
    break;
   default:
     Move(rp,x,y);
    break;
  }
 SetDrMd(rp,JAM1);
 Text(rp,text,j);
}

/* ---- Text ausgeben und falls nötig entsprechend kürzen */
void WriteMText(we,x,y,width,height,text,justification,fill)
 struct WindowEntry *we;
 UWORD               x,y;
 UWORD               width,height;
 UBYTE              *text;
 UBYTE               justification;
 BOOL                fill;
{
 struct MultiWindowsUser  *mw;
 register struct RastPort *rp;
 register struct DrawInfo *di;
 REGISTER UWORD            i,j;
 UBYTE                     s[204];

 USER;
 BackupRP(we);
 rp=we->RastPort;
 di=we->DrawInfo;
 SetFont(rp,mw->TextFont);

 if(text)
  {
   SetAPen(rp,di->dri_Pens[TEXTPEN]);
   i=strlen(text);
   j=TextLength(rp,text,i);
   if(j>=width)
    {
     if(i>198) { i=198; s[198]=0x00; }
     strncpy(&s,text,i);
     MacFormat(rp,&s,width);
     text=&s;
    }
  }

 SetAPen(rp,0);
 i=SetTaskPri(SysBase->ThisTask,127);
 if(fill)
  {
   WaitBOVP(we->ViewPort);
   RectFill(rp,x+2,y+1,x+width-3,y+height-2);
  }
 if(text)
  {
   SetAPen(rp,di->dri_Pens[TEXTPEN]);
   WriteText(rp,x,y,width,height,text,justification);
  }
 SetTaskPri(SysBase->ThisTask,i);

 RestoreRP(we);
}

/* PlaceText ausgeben */
void PrintPP(gad)
 struct MWGadget *gad;
{
 UBYTE                   *otext,*text,tx[200];
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct RastPort         *rp;
 struct TextFont         *tf;
 int                      i,j,l,underline;
 int                      x,y,w,h;

 USER;
 we=gad->WindowEntry;
 rp=we->RastPort;
 otext=gad->NewGadget.ng_GadgetText;
 if(otext==NULL) return;

 i=0; j=0; underline=0xffff;
 while(otext[i]!=0x00)
  {
   if(otext[i]!='_')
    { tx[j]=otext[i]; j++; }
   else
     underline=i;
   i++;
  }
 tx[j]=0x00;
 text=&tx;

 BackupRP(we);
 tf=mw->TextFont;
 SetFont(rp,tf);
 tf=rp->Font;
 j=strlen(text);
 i=l=TextLength(rp,text,j);
 x=gad->NewGadget.ng_LeftEdge;
 y=gad->NewGadget.ng_TopEdge;
 w=gad->NewGadget.ng_Width;
 h=gad->NewGadget.ng_Height;

 if(gad->NewGadget.ng_Flags & PLACETEXT_IN)
  {
   x+=((w-i)/2);
   i=(h-tf->tf_YSize)/2;
   y+=(i+tf->tf_Baseline+1);
  }
 if(gad->NewGadget.ng_Flags & PLACETEXT_LEFT)
  {
   x-=INTERWIDTH+i;
   i=(h-tf->tf_YSize)/2;
   y+=(i+tf->tf_Baseline+1);
  }
 if(gad->NewGadget.ng_Flags & PLACETEXT_RIGHT)
  {
   x+=w+INTERWIDTH;
   i=(h-tf->tf_YSize)/2;
   y+=(i+tf->tf_Baseline+1);
  }
 else if(gad->NewGadget.ng_Flags & PLACETEXT_ABOVE)
  {
   x+=((w-i)/2);
   y-=INTERHEIGHT+(tf->tf_YSize-tf->tf_Baseline);
  }
 else if(gad->NewGadget.ng_Flags & PLACETEXT_BELOW)
  {
   x+=((w-i)/2);
   y+=h+tf->tf_Baseline+INTERHEIGHT;
  }

 if(gad->NewGadget.ng_Flags & NG_HIGHLABEL)
   SetAPen(rp,we->DrawInfo->dri_Pens[HIGHLIGHTTEXTPEN]);
 else
   SetAPen(rp,we->DrawInfo->dri_Pens[TEXTPEN]);

 gad->TextPos[TX_LEFT]=x;
 gad->TextPos[TX_TOP]=y-tf->tf_Baseline;
 gad->TextPos[TX_WIDTH]=l;
 gad->TextPos[TX_HEIGHT]=tf->tf_YSize;

 SetDrMd(rp,JAM1);
 Move(rp,x,y);
 Text(rp,text,j);

 if(underline!=0xffff)
  {
   j=TextLength(rp,text,underline);
   Move(rp,x+j,y);
   Text(rp,"_",1);
  }

 RestoreRP(we);
}

/* ---- Innere Größe eines Fensters berechnen */
void CalcInnerSize(we)
 struct WindowEntry *we;
{
 struct Window *win;

 win=we->Window;
 we->InnerTopEdge=win->BorderTop;
 we->InnerLeftEdge=win->BorderLeft;
 we->InnerWidth=win->Width-win->BorderLeft-win->BorderRight;
 we->InnerHeight=win->Height-win->BorderTop-win->BorderBottom;
}

/* ---- App-Objekt erstellen */
struct AppObject *CreateAppObject(appID,type,data,ownerType,owner)
 ULONG appID;
 UBYTE type;
 APTR  data;
 UBYTE ownerType;
 APTR  owner;
{
 struct MultiWindowsUser *mw;
 struct AppObject        *ao;

 USER;
 ao=AllocMem(sizeof(struct AppObject),MEMF_CLEAR|MEMF_PUBLIC);
 if(ao==NULL) return(NULL);

 ao->AppID=appID;
 ao->AppObjectType=type;
 ao->AppObjectData=data;
 ao->OwnerType=ownerType;
 ao->Owner=owner;

 switch(type)
  {
   case AOT_ICON:
     ao->AppObject=AddAppIconA(-1L,ao,data,mw->AppPort,0L,mw->Icon,NULL);
    break;
   case AOT_MENUITEM:
     ao->AppObject=AddAppMenuItemA(-1L,ao,data,mw->AppPort,0L);
    break;
   case AOT_WINDOW:
     ao->AppObject=AddAppWindowA(-1L,ao,data,mw->AppPort,0L);
    break;
  }

 if(ao->AppObject!=NULL)
   AddTail(&mw->AppObjectList,ao);
 else
  {
   ErrorL(1121,"CreateAppObject():\nUnable to create app object!");
   FreeMem(ao,sizeof(struct AppObject));
   ao=NULL;
  }

 return(ao);
}

/* ---- App-Objekt entfernen */
void DeleteAppObject(ao)
 struct AppObject *ao;
{
 if(ao==NULL) return;

 Remove(ao);
 switch(ao->AppObjectType)
  {
   case AOT_ICON:
     RemoveAppIcon(ao->AppObject);
    break;
   case AOT_MENUITEM:
     RemoveAppMenuItem(ao->AppObject);
    break;
   case AOT_WINDOW:
     RemoveAppWindow(ao->AppObject);
    break;
  }
 FreeMem(ao,sizeof(struct AppObject));
}

/* ---- App-Objekt suchen */
struct AppObject *FindAppObject(appID)
 ULONG appID;
{
 struct MultiWindowsUser *mw;
 struct AppObject        *ao;
 struct List             *list;
 struct Node             *node;

 USER;

 for(node=mw->AppObjectList.lh_Head;node!=&mw->AppObjectList.lh_Tail;node=node->ln_Succ)
  {
   ao=node;
   if((ao->AppID==appID)) return(ao);
  }
 return(NULL);
}

/* ---- AppMenuItem erstellen */
BOOL CreateAppMenuItem(appID,title)
 ULONG  appID;
 UBYTE *title;
{
 struct MultiWindowUser *mw;
 struct AppObject       *ao;

 USER;
 ao=CreateAppObject(appID,AOT_MENUITEM,FindID(mw->Catalog,title),OT_USER,NULL);
 if(ao) return(TRUE); else return(FALSE);
}

/* ---- AppIcon erstellen */
BOOL CreateAppIcon(appID,title)
 ULONG  appID;
 UBYTE *title;
{
 struct MultiWindowUser *mw;
 struct AppObject *ao;

 USER;
 ao=CreateAppObject(appID,AOT_ICON,FindID(mw->Catalog,title),OT_USER,NULL);
 if(ao) return(TRUE); else return(FALSE);
}

/* ---- AppIcon entfernen */
void DeleteAppIcon(appID)
 ULONG appID;
{
 struct AppObject *ao;

 ao=FindAppObject(appID);
 if(ao) DeleteAppObject(ao);
}

/* ---- AppMenuItem entfernen */
void DeleteAppMenuItem(appID)
 ULONG appID;
{ DeleteAppIcon(appID); }

/* ---- AppWindow erstellen */
BOOL CreateAppWindow(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;

 we=FindWindowEntry(we);
 if(we!=NULL)
  {
   we->AppWindow=CreateAppObject(-1L,AOT_WINDOW,we->Window,OT_WINDOWENTRY,we);
   if(we->AppWindow) return(TRUE);
  }
 else
   return(FALSE);
}

/* ---- AppWindow entfernen */
void DeleteAppWindow(windowID)
 UBYTE windowID;
{
 struct WindowEntry *we;

 we=FindWindowEntry(we);
 if(we!=NULL)
   if(we->AppWindow) DeleteAppObject(we->AppWindow);
}

/* ---- Aktuelles TextAttr ermitteln */
UBYTE *GetTextFontName()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->TextAttr->ta_Name);
}

/* ---- Aktuelles NonPropTextAttr ermitteln */
UBYTE *GetNonPropTextFontName()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->NonPropTextAttr->ta_Name);
}

/* ---- Aktuelles TextAttr ermitteln */
UBYTE *GetDefaultTextFontName()
{
 return(MultiWindowsBase->DefaultAttr->ta_Name);
}

/* ---- Aktuelles NonPropTextAttr ermitteln */
UBYTE *GetDefaultNonPropTextFontName()
{
 return(MultiWindowsBase->DefaultNonPropAttr->ta_Name);
}

/* ---- Aktuelles TextAttr ermitteln */
UWORD GetTextFontHeight()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->TextAttr->ta_YSize);
}

/* ---- Aktuelles NonPropTextAttr ermitteln */
UWORD GetNonPropTextFontHeight()
{
 register struct MultiWindowsUser *mw;

 USER;
 return(mw->NonPropTextAttr->ta_YSize);
}

/* ---- Aktuelles TextAttr ermitteln */
UWORD GetDefaultTextFontHeight()
{
 return(MultiWindowsBase->DefaultAttr->ta_YSize);
}

/* ---- Aktuelles NonPropTextAttr ermitteln */
UWORD GetDefaultNonPropTextFontHeight()
{
 return(MultiWindowsBase->DefaultNonPropAttr->ta_YSize);
}

/* ---- Aktuellen TextFont ermitteln */
struct TextFont *GetTopazTextFont()
{
 return(MultiWindowsBase->TopazFont);
}

/* ---- Aktuellen TextFont ermitteln */
struct TextFont *GetPassword5TextFont()
{
 return(MultiWindowsBase->Password5Font);
}

/* ---- Aktuellen TextFont ermitteln */
struct TextFont *GetPassword9TextFont()
{
 return(MultiWindowsBase->Password9Font);
}

/* ---- Aktuellen TextAttr ermitteln */
struct TextAttr *GetTopazTextAttr()
{
 return(MultiWindowsBase->TopazAttr);
}

/* ---- Aktuellen TextAttr ermitteln */
struct TextAttr *GetPassword5TextAttr()
{
 return(MultiWindowsBase->Password5Attr);
}

/* ---- Aktuellen TextAttr ermitteln */
struct TextAttr *GetPassword9TextAttr()
{
 return(MultiWindowsBase->Password9Attr);
}

/* ---- Informationsfenster öffneen */
BOOL OpenInformationBox()
{
 UBYTE              *dat;
 BOOL                bool;
 struct WindowEntry *we;

 dat=GetMem(256,MEMF_ANY);
 if(dat==NULL) return(FALSE);

 bool=CreateWindow(WindowID_InformationBox,"1205§Information",50,50,450,235,CW_CLOSE|CW_DEPTH|CW_SIZE|CW_DRAG, 0 ,NULL);
 if(bool==FALSE) return(FALSE);
 we=FindWindowEntry(WindowID_InformationBox);
 we->WESpecialData[1]=dat;

 AddFrame(1,5,5,260,100,FT_DOUBLE);
 AddText(1,0,10,12,250,20,0L,0,"MultiWindows",JSF_CENTER);
 AddText(1,0,10,36,250,20,0L,0,"Copyright © 1995-1996 by",JSF_CENTER);
 AddText(1,0,10,58,250,20,0L,0,"Thomas Dreibholz",JSF_CENTER);
 AddText(1,0,10,80,250,20,0L,0,"All rights reserved.",JSF_CENTER);

 AddFrame(2,270,5,155,100,FT_DOUBLE);
 AddNumber(50,0,350,12,65,20,"Chip:",CGA_LEFT|CGA_RECESSED,"%ld KB",AvailChipMem()/1024L,JSF_RIGHT);
 AddNumber(51,0,350,34,65,20,"Fast:",CGA_LEFT|CGA_RECESSED,"%ld KB",AvailFastMem()/1024L,JSF_RIGHT);
 AddNumber(52,0,350,56,65,20,"VMem:",CGA_LEFT|CGA_RECESSED,"%ld KB",AvailVMem()/1024L,JSF_RIGHT);
 AddNumber(53,0,350,80,65,20,"Total:",CGA_LEFT|CGA_RECESSED,"%ld KB",AvailMemory()/1024L,JSF_RIGHT);
 AddText(54,0,5,110,420,20,0L,CGA_RECESSED,0L,JSF_CENTER);
 AddListview(55,0,5,135,420,80,0L,CLV_NONPROPFONT|CLV_READONLY,0L,0);
 ShowUserInfo();

 AddMenu(100,"1135§Select item to be displayed.","1136§Display",CME_DEFAULT);

 AddItem(200,"1149§Shows informations about MultiDesktop.","MultiDesktop",0L,0L,0);
 AddSubItem(119,"1137§Shows informations about the user.","1138§User",0L,"U",0);
 AddSubBarItem(301);
 AddSubItem(115,"1139§Shows the application list.","1140§Applications",0L,"A",0);
 AddSubItem(116,"1141§Shows the wallpaper list.","1142§Wallpapers",0L,"W",0);
 AddSubItem(117,"1143§Shows the pointer list.","1144§Pointers",0L,"P",0);
 AddSubBarItem(302);
 AddSubItem(118,"1145§Shows the cached fonts list.","1146§Cached Fonts",0L,"F",0);

 AddBarItem(201);
 AddItem(202,"1150§Shows informations about your software.","1151§Software",0L,0L,0);
 AddSubItem(152,"1152§Shows informations about the operating system.","1153§Operating System",0L,"O",0);
 AddSubBarItem(210);
 AddSubItem(104,"1154§Shows informations about libraries.","1155§Libraries",0L,"L",0);
 AddSubItem(105,"1156§Shows informations about devices.","1157§Devices",0L,"D",0);
 AddSubItem(106,"1158§Shows informations about resources.","1159§Resources",0L,"R",0);
 AddSubItem(107,"1160§Shows informations about message ports.","1161§Ports",0L,"P",0);
 AddSubItem(108,"1162§Shows informations about tasks.","1163§Tasks",0L,"T",0);
 AddSubItem(109,"1164§Shows informations about semaphores.","1165§Semaphores",0L,"W",0);
 AddSubItem(110,"1166§Shows informations about memory.","1167§Memory",0L,"M",0);

 AddItem(203,"1170§Shows informations about your hardware.","1171§Hardware",0L,0L,0);
 AddSubItem(151,"1172§Shows informations about processors.","1173§Processors",0L,"H",0);
 AddSubItem(112,"1174§Shows informations about expansion.","1175§Expansion",0L,"X",0);
 AddSubItem(150,"1176§Shows informations about SCSI.","1177§SCSI",0L,"S",0);
 AddSubItem(111,"1178§Shows informations about boot priorities.","1179§Boot Priorities",0L,"B",0);
 AddSubBarItem(300);
 AddSubItem(113,"1180§Shows informations about screen modes.","1181§Screen Modes",0L,"V",0);

 AddBarItem(204);
 AddItem(205,"1190§Closes information window.","1191§Close Window","99§Are you sure?","Q", CMI_T2BOLD);
 AddStdMenus();
 ShowMenu();
 ShowDateAndMem();

 return(TRUE);
}

/* ---- Informationsfenster schließen */
void CloseInformationBox()
{
 struct WindowEntry *we;

 we=FindWindowEntry(WindowID_InformationBox);
 if(we)
   DisposeMem(we->WESpecialData[1]);
 DeleteWindow(WindowID_InformationBox);
}

/* ---- Messages im Informationsfenster verarbeiten */
BOOL HandleInformationBox(mm)
 struct MultiMessage *mm;
{
 UBYTE                    text[256],str[256];
 ULONG                    i,j,k;
 BOOL                     ende;
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 struct List             *liste,*liste2;
 struct Node             *node;
 struct Library          *lib;
 struct ConfigDev        *cd;
 struct BootNode         *bn;
 struct UserNode         *un;
 struct MemHeader        *mh;

 USER;
 we=FindWindowEntry(WindowID_InformationBox);
 if(we==NULL) return;

 ende=FALSE;
 switch(mm->Class)
  {
   case MULTI_INTUITICKS:
     we->WESpecialData[0]++;
     if(we->WESpecialData[0]>=8)
      {
       we->WESpecialData[0]=0;
       ShowDateAndMem();
      }
    break;
   case MULTI_CLOSEWINDOW:
     ende=TRUE;
    break;
   case MULTI_MENUPICK:
     if((mm->ObjectID>=104)&&(mm->ObjectID<=118))
      {
       liste=NULL;
       Forbid();
       switch(mm->ObjectID)
        {
         case 205:
           ende=TRUE;
          break;
         case 104:
           liste=DupList(&SysBase->LibList,sizeof(struct Library));
          break;
         case 105:
           liste=DupList(&SysBase->DeviceList,sizeof(struct Library));
          break;
         case 106:
           liste=DupList(&SysBase->ResourceList,sizeof(struct Library));
          break;
         case 107:
           liste=DupList(&SysBase->PortList,sizeof(struct Library));
          break;
         case 108:
           Disable();
           liste=DupList(&SysBase->TaskWait,sizeof(struct Node));
           liste2=DupList(&SysBase->TaskReady,sizeof(struct Node));
           Enable();
           ConcatList(liste,liste2);
          break;
         case 109:
           liste=DupList(&SysBase->SemaphoreList,sizeof(struct Node));
          break;
         case 110:
           liste=DupList(&SysBase->MemList,sizeof(struct MemHeader));
          break;
         case 111:
           liste=DupList(&ExpansionBase->MountList,sizeof(struct BootNode));
          break;
         case 112:
           liste=DupList(&ExpansionBase->eb_Private05,sizeof(struct ConfigDev));
          break;
         case 113:
           liste=DupList(&MultiWindowsBase->VideoInfoList,sizeof(struct Node));
          break;
         case 115:
           liste=DupList(&MultiWindowsBase->AppList,sizeof(struct UserNode));
          break;
         case 116:
           liste=DupList(&MultiWindowsBase->WallpaperList,sizeof(struct Node));
          break;
         case 117:
           liste=DupList(&MultiWindowsBase->PointerList,sizeof(struct Node));
          break;
         case 118:
           liste=DupList(&mw->CachedFontsList,sizeof(struct Node));
          break;
        }
       Permit();
       if(liste!=NULL)
        {
         Pointer(MultiWindowsBase->WorkPointerName);
         SortList(liste,SORT_ASCENDING);
         RemListviewEntries(55);
         for(node=liste->lh_Head;node!=&liste->lh_Tail;node=node->ln_Succ)
          {
           if(node->ln_Name==NULL) node->ln_Name=GetLStr(98,"[Untitled]");
           switch(mm->ObjectID)
            {
             case 104:
             case 105:
             case 106:
               lib=node;
               sprintf(&text,"%-30s  %5d.%-4d  %4d",node->ln_Name,lib->lib_Version,lib->lib_Revision,lib->lib_OpenCnt);
              break;
             case 110:
               mh=node;
               if(mh->mh_Attributes & MEMF_CHIP)
                 strcpy(&text[200],"Chip");
               else
                {
                 if(mh->mh_Attributes & (MEMF_FAST|MEMF_PUBLIC))
                   strcpy(&text[200],"Fast");
                 else
                   strcpy(&text[200],"VMem");
                }
               sprintf(&text,"%-30s  %s  %5ld KB",node->ln_Name,&text[200],((ULONG)mh->mh_Upper-(ULONG)mh->mh_Lower+(ULONG)sizeof(struct MemHeader)+(ULONG)sizeof(struct MemChunk))/1024L);
              break;
             case 111:
               bn=node;
               sprintf(&text,"%-20s  %4d",bstr(&str[160],(struct DeviceNode *)(bn->bn_DeviceNode)->dn_Name),node->ln_Pri);
              break;
             case 112:
               cd=node;
               sprintf(&text,"%03ld/%03ld  $%08lx %5ld KB  ",
                             cd->cd_Rom.er_Manufacturer,
                             cd->cd_Rom.er_Product,
                             cd->cd_BoardAddr,
                             (ULONG)cd->cd_BoardSize/1024L);

               if((cd->cd_Rom.er_Manufacturer==513)&&(cd->cd_Rom.er_Product==1))
                 strcat(&text,"[CBM Bridgeboard]");
               else if(cd->cd_Rom.er_Manufacturer==514)
                {
                 switch(cd->cd_Rom.er_Product)
                  {
                   case 81:
                     strcat(&text,"[CBM 68030/68882 Turbo]");
                    break;
                   case 3:
                     strcat(&text,"[CBM SCSI Controller]");
                    break;
                   case 10:
                     strcat(&text,"[CBM Memory Card]");
                    break;
                  }
                }
              break;
             case 113:
             case 114:
             case 116:
             case 117:
             case 118:
               strcpy(&text,node->ln_Name);
              break;
             case 115:
               un=node;
               sprintf(&text,"%-36s  %2d.%03d",node->ln_Name,un->Version/1000,un->Version % 1000);
              break;
             default:
               sprintf(&text,"%-36s  %4d",node->ln_Name,node->ln_Pri);
              break;
            }
           AddListviewEntrySort(55,&text,ULP_TAIL);
           AnimPointer();
          }
        }
       if(liste) FreeList(liste);
       Pointer(NULL);
      }
     else
      {
       switch(mm->ObjectID)
        {
         case 151:
           RemListviewEntries(55);
           AddListviewEntrySort(55,GetLStr(1192,"Testing CPU/FPU/MMU..."),ULP_HEAD);
           i=GetCPUType();
           j=GetFPUType();
           k=GetMMUType();
           RemListviewEntries(55);
           AddListviewEntrySort(55,GetLStr(1193,"Main Processors:"),ULP_TAIL);
           sprintf(&text,"CPU: %ld",i);
           AddListviewEntrySort(55,&text,ULP_TAIL);
           if(j)
             sprintf(&text,"FPU: %ld",j);
           else
             strcpy(&text,GetLStr(1194,"FPU: not installed"));
           AddListviewEntrySort(55,&text,ULP_TAIL);
           if(k)
             sprintf(&text,"MMU: %ld",k);
           else
             strcpy(&text,GetLStr(1195,"MMU: not installed"));
           AddListviewEntrySort(55,&text,ULP_TAIL);

           AddListviewEntrySort(55,"",ULP_TAIL);
           AddListviewEntrySort(55,GetLStr(1196,"Graphics Processors:"),ULP_TAIL);
           if(GfxBase->ChipRevBits0 & GFXF_HR_AGNUS)
             AddListviewEntrySort(55,"Agnus:  ECS",ULP_TAIL);
           else
             AddListviewEntrySort(55,"Agnus:  OCS",ULP_TAIL);

           if(GfxBase->ChipRevBits0 & GFXF_HR_DENISE)
             AddListviewEntrySort(55,"Denise: ECS",ULP_TAIL);
           else
             AddListviewEntrySort(55,"Denise: OCS",ULP_TAIL);
          break;
         case 152:
           RemListviewEntries(55);
           sprintf(&text,"Kickstart %d.%d",SysBase->LibNode.lib_Version,SysBase->LibNode.lib_Revision);
           AddListviewEntrySort(55,&text,ULP_TAIL);
           if(VersionBase)
             sprintf(&text,"Workbench %d.%d",VersionBase->lib_Version,VersionBase->lib_Revision);
           else
             strcat(&text,"<< version.library not available >>");
           AddListviewEntrySort(55,&text,ULP_TAIL);
          break;
         case 150:
           ShowSCSI();
          break;
         case 119:
           ShowUserInfo();
          break;
         case 250:
           ende=TRUE;
          break;
        }
      }
    break;
  }
 return(ende);
}

UBYTE *bstr(dest,src)
 UBYTE *dest;
 BSTR   src;
{
 UWORD  i;
 UBYTE *Help;

 Help=(UBYTE *)BADDR(src);
 for(i=0;i<(*Help);i++)
  dest[i]=*(Help+i+1);
 dest[i]=0x00;
 return(dest);
}

/* ---- UserInfo anzeigen */
void ShowUserInfo()
{
 UBYTE text[256];

 RemListviewEntries(55);
 sprintf(&text,"%s %s",GetLStr(1198,"Name:     "),&MultiWindowsBase->UserInfo->Name);
 AddListviewEntrySort(55,&text,ULP_TAIL);
 sprintf(&text,"%s %s",GetLStr(1199,"Address:  "),&MultiWindowsBase->UserInfo->Address[0]);
 AddListviewEntrySort(55,&text,ULP_TAIL);
 sprintf(&text,"           %s",&MultiWindowsBase->UserInfo->Address[1]);
 AddListviewEntrySort(55,&text,ULP_TAIL);
 sprintf(&text,"           %s",&MultiWindowsBase->UserInfo->Country);
 AddListviewEntrySort(55,&text,ULP_TAIL);
 sprintf(&text,"%s %s",GetLStr(1200,"Phone:    "),&MultiWindowsBase->UserInfo->PhoneNumber);
 AddListviewEntrySort(55,&text,ULP_TAIL);
 sprintf(&text,"%s %s",GetLStr(1201,"Fax:      "),&MultiWindowsBase->UserInfo->FaxNumber);
 AddListviewEntrySort(55,&text,ULP_TAIL);
 AddListviewEntrySort(55,"",ULP_TAIL);
 switch(MultiWindowsBase->UserInfo->UserLevel)
  {
   case USERLEVEL_EXPERT:
     AddListviewEntrySort(55,GetLStr(1202,"Level: Expert",ULP_TAIL));
    break;
   case USERLEVEL_ADVANCED:
     AddListviewEntrySort(55,GetLStr(1203,"Level: Advanced",ULP_TAIL));
    break;
   case USERLEVEL_BEGINNER:
     AddListviewEntrySort(55,GetLStr(1204,"Level: Beginner",ULP_TAIL));
    break;
  }
}

/* ---- Zeitanzeige */
void ShowDateAndMem()
{
 UBYTE                    str[100];
 UBYTE                   *dat;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 struct Locale           *locale;
 struct MultiTime         mt;
 struct DateStamp         ds;

 USER;
 GetTime(&mt);
 locale=mw->Locale;
 if(locale)
  {
   DateStamp(&ds);
   LocaleDFormat(&str,locale->loc_DateTimeFormat,&ds);
  }
 else
  {
   sprintf(&str,"%2d:%02d:%02d  %02d/%02d/%04d",mt.Hour,mt.Minute,mt.Second,mt.Month,mt.Day,mt.Year);
  }

 we=FindWindowEntry(WindowID_InformationBox);
 if(we)
  {
   dat=we->WESpecialData[1];
   sprintf(dat,"%s    %ld.%04ld",&str,mt.StarDate[0],mt.StarDate[1]);
   UpdateText(54,dat);
  }

 UpdateNumber(50,AvailChipMem()/1024L);
 UpdateNumber(51,AvailFastMem()/1024L);
 UpdateNumber(52,AvailVMem()/1024L);
 UpdateNumber(53,AvailMemory()/1024L);
}

/* ---- SCSI */
struct DriveInfo
{
 UBYTE PeripheralType;
 UBYTE Modifier;
 UBYTE Version;
 UBYTE Flags1;
 UBYTE AdditionalLength;
 UBYTE reserved[2];
 UBYTE Flags2;
 UBYTE Vendor[8];
 UBYTE Product[16];
 UBYTE Revision[4];
};
UBYTE Inquiry[6]={0x12,0x00,0x00,0x00,0x90,0x00};

void ShowSCSI()
{
 struct MsgPort   *port;
 struct IOStdReq  *io;
 struct SCSICmd   *cmd;
 struct DriveInfo *di;
 long              i,j;
 UBYTE             Sense[20];
 UBYTE             str[128],vendor[10],product[18],revision[6];

 RemListviewEntries(55);
 AddListviewEntrySort(55,GetLStr(1197,"Unit  Device     Vendor     Type"),ULP_TAIL);
 Pointer(MultiWindowsBase->WorkPointerName);

 di=AllocVec(sizeof(struct DriveInfo),MEMF_PUBLIC|MEMF_24BITDMA);
 if(di!=NULL)
  {
   port=CreatePort(0,0);
   if(port!=NULL)
    {
     io=CreateExtIO(port,sizeof(struct IOStdReq));
     if(io!=NULL)
      {
       for(i=0;i<=7;i++)
        {
         j=OpenDevice("scsi.device",i,io,0);
         if(j==0)
          {
           cmd=AllocVec(sizeof(struct SCSICmd),MEMF_PUBLIC|MEMF_CLEAR);
           if(cmd!=NULL)
            {
             for(j=0;j<20;j++) Sense[j]=0x00;
             io->io_Length=sizeof(struct SCSICmd);
             io->io_Data=cmd;
             io->io_Command=HD_SCSICMD;
             cmd->scsi_Data=di;
             cmd->scsi_Length=sizeof(struct DriveInfo);
             cmd->scsi_Flags=SCSIF_AUTOSENSE|SCSIF_READ;
             cmd->scsi_SenseData=AllocMem(20,MEMF_PUBLIC|MEMF_CLEAR);
             cmd->scsi_SenseLength=18;
             cmd->scsi_SenseActual=0;
             cmd->scsi_Command=&Inquiry;
             cmd->scsi_CmdLength=6;
             DoIO(io);

             if(cmd->scsi_Status!=0)
               sprintf(&str,"%4ld   SCSI I/O Error #%ld",cmd->scsi_Status);
             else
              {
               strncpy(&vendor,&di->Vendor,8); vendor[8]=0x00;
               strncpy(&product,&di->Product,16); product[16]=0x00;
               strncpy(&revision,&di->Revision,4); revision[4]=0x00;
               sprintf(&str,"%4ld   %-8s   %-16s  %-4s",i,&vendor,&product,&revision);
              }
             FreeVec(cmd);
            }
           CloseDevice(io);
          }
         else
           sprintf(&str,"%4ld  N/A",i);

         AddListviewEntryNumber(55,&str,999);
         AnimPointer();
        }
       DeleteExtIO(io);
      }
     DeletePort(port);
    }
   FreeVec(di);
  }
 Pointer(NULL);
}

