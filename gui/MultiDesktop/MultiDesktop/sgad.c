/* MultiWindows-Gadgets */
#include "multiwindows.h"
#include <math.h>

extern struct ExecBase         *SysBase;
extern struct MultiWindowsBase *MultiWindowsBase;

void ShowText();
void ShowNumber();
void ShowWheel();
void ShowSelectBox();
void ShowIcon();
void ShowImage();
void UpdateNumber();
void UpdateText();
void UpdateStatus();
struct Image *CenterImage();

/* ---- Special-Gadget initialisieren */
struct MWGadget *InitSGadget(gadgetID,helpID,kind,x,y,w,h,textID,flags,extSize)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          kind;
 UWORD          x,y,w,h;
 ULONG          textID;
 ULONG          flags;
 ULONG          extSize;
{
 register struct MultiWindowsUser *mw;
 register struct MWGadget         *gad;
 register struct WindowEntry      *we;

 USER;
 WE;
 if(we==NULL) return(NULL);

 gad=ALLOC2(sizeof(struct MWGadget)+extSize);
 if(gad==NULL) return(NULL);
 if(extSize) gad->ExtData=(ULONG)gad+(ULONG)sizeof(struct MWGadget);

 gad->WindowEntry=we;
 gad->GadgetID=gadgetID;
 gad->HelpID=helpID;
 gad->Type=MWGAD_SPECIAL;
 gad->Kind=kind;
 gad->LeftEdge=x;
 gad->TopEdge=y;
 gad->Width=w;
 gad->Height=h;
 gad->NewGadget.ng_LeftEdge=INewX(we,x);
 gad->NewGadget.ng_TopEdge=INewY(we,y);
 gad->NewGadget.ng_Width=INewWidth(we,w);
 gad->NewGadget.ng_Height=INewHeight(we,h);
 gad->NewGadget.ng_GadgetText=FindID(mw->Catalog,textID);
 gad->NewGadget.ng_TextAttr=mw->TextAttr;
 gad->NewGadget.ng_Flags=flags;
 gad->NewGadget.ng_UserData=gad;
 return(gad);
}

/* ---- Standard-Gadget initialisieren */
void InitGadget(gad,g,firstTime)
 struct MWGadget *gad;
 struct Gadget   *g;
 BOOL             firstTime;
{
 g->NextGadget=NULL;
 g->LeftEdge=gad->NewGadget.ng_LeftEdge;
 g->TopEdge=gad->NewGadget.ng_TopEdge;
 g->Width=gad->NewGadget.ng_Width;
 g->Height=gad->NewGadget.ng_Height;
 if(firstTime)
  {
   g->Flags=GADGHNONE;
   g->Activation=RELVERIFY|GADGIMMEDIATE;
   g->GadgetType=BOOLGADGET;
   g->GadgetID=0xffff;
   g->UserData=gad;
   gad->Gadget=g;
  }
}

/* ---- Text-Gadget zeichnen */
void ShowText(gad)
 struct MWGadget *gad;
{
 struct TextData    *td;
 REGISTER BOOL       rec;

 td=gad->ExtData;
 if(!(td->Flags & CTX_NOBORDER))
  {
   if(td->Flags & CGA_RECESSED) rec=TRUE; else rec=FALSE;
   DrawIt(gad->WindowEntry,
          gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,
          gad->NewGadget.ng_Width,gad->NewGadget.ng_Height,rec,FALSE,FALSE);
  }

 WriteMText(gad->WindowEntry,
            gad->NewGadget.ng_LeftEdge+3,gad->NewGadget.ng_TopEdge,
            gad->NewGadget.ng_Width-6,gad->NewGadget.ng_Height,
            gad->TagList[STEXT_TEXT].ti_Data,
            td->Justification,TRUE);
 PrintPP(gad);
}

/* ---- Text-Gadget erstellen */
BOOL AddText(gadgetID,helpID,x,y,w,h,textID,flags,text,justification)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 UBYTE      *text;
 UBYTE       justification;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct TextData         *td;

 WE;
 if(we==NULL) return(NULL);

 gad=InitSGadget(gadgetID,helpID,STEXT_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct TextData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 td=gad->ExtData;
 td->Flags=flags;
 td->Justification=justification;

 gad->TagList[STEXT_TEXT].ti_Data=text;

 if(!we->Iconify) ShowText(gad);
 return(AddMWGadget(gad));
}

/* ---- Text-Anzeige abfragen */
UBYTE *AskText(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,STEXT_KIND);
 if(gad)
   return(gad->TagList[STEXT_TEXT].ti_Data);
 return(0L);
}

/* ---- Text-Anzeige updaten */
void UpdateText(gadgetID,text)
 ULONG  gadgetID;
 UBYTE *text;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 UBYTE              *old;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,STEXT_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   gad->TagList[STEXT_TEXT].ti_Data=text;
   if(!we->Iconify) ShowText(gad);
  }
}

/* ---- Number-Gadget zeichnen */
void ShowNumber(gad)
 struct MWGadget *gad;
{
 struct MultiWindowsUser *mw;
 struct NumberData       *nd;
 REGISTER BOOL            rec;
 UBYTE                   *format;
 UBYTE                    text[200];

 USER;
 nd=gad->ExtData;
 if(!(nd->Flags & CNM_NOBORDER))
  {
   if(nd->Flags & CGA_RECESSED) rec=TRUE; else rec=FALSE;
   DrawIt(gad->WindowEntry,
          gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,
          gad->NewGadget.ng_Width,gad->NewGadget.ng_Height,rec,FALSE,FALSE);
  }

 format=nd->FormatString;
 if(format==NULL)
   format="%ld";

 if((mw->Locale!=NULL)&&(!(nd->Flags & CNM_NOLOCALE)))
   LocaleSFormat(&text,format,&gad->TagList[SNUMBER_NUMBER].ti_Data);
 else
   sprintf(&text,format,gad->TagList[SNUMBER_NUMBER].ti_Data);

 WriteMText(gad->WindowEntry,
            gad->NewGadget.ng_LeftEdge+3,gad->NewGadget.ng_TopEdge,
            gad->NewGadget.ng_Width-6,gad->NewGadget.ng_Height,
            &text,
            nd->Justification,TRUE);
 PrintPP(gad);
}

/* ---- Number-Gadget erstellen */
BOOL AddNumber(gadgetID,helpID,x,y,w,h,textID,flags,format,number,justification)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 UBYTE      *format;
 LONG        number;
 UBYTE       justification;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct NumberData       *nd;

 WE;
 if(we==NULL) return(NULL);

 gad=InitSGadget(gadgetID,helpID,SNUMBER_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct NumberData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 nd=gad->ExtData;
 nd->FormatString=format;
 nd->Flags=flags;
 nd->Justification=justification;

 gad->TagList[SNUMBER_NUMBER].ti_Data=number;

 if(!we->Iconify) ShowNumber(gad);
 return(AddMWGadget(gad));
}

/* ---- Zahl-Anzeige abfragen */
LONG AskNumber(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,SNUMBER_KIND);
 if(gad)
   return((LONG)gad->TagList[SNUMBER_NUMBER].ti_Data);
 return(0L);
}

/* ---- Zahl-Anzeige updaten */
void UpdateNumber(gadgetID,number)
 ULONG  gadgetID;
 LONG   number;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 UBYTE              *old;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,SNUMBER_KIND);
 if(gad)
  {
   we=gad->WindowEntry;

   old=gad->TagList[SNUMBER_NUMBER].ti_Data;
   if(old==number)
     return;

   gad->TagList[SNUMBER_NUMBER].ti_Data=number;
   if(!we->Iconify) ShowNumber(gad);
  }
}

/* ---- Status-Gadget zeichnen */
void ShowStatus(gad)
 struct MWGadget *gad;
{
 struct WindowEntry *we;
 struct RastPort    *rp;
 struct StatusData  *sd;
 UBYTE               text[200];
 ULONG               p,l,percent;
 int                 x,y,w,h,rec;

 sd=gad->ExtData;
 if(sd->Flags & CGA_RECESSED) rec=TRUE; else rec=FALSE;
 DrawIt(gad->WindowEntry,
        gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,
        gad->NewGadget.ng_Width,gad->NewGadget.ng_Height,rec,FALSE,FALSE);

 we=gad->WindowEntry;
 rp=we->RastPort;
 BackupRP(we);

 w=gad->NewGadget.ng_Width-5;
 h=gad->NewGadget.ng_Height-3;
 x=gad->NewGadget.ng_LeftEdge+2;
 y=gad->NewGadget.ng_TopEdge+1;
 l=gad->TagList[STATUS_LEVEL].ti_Data;

 if(l>sd->Max) l=sd->Max;
 if(l<sd->Min) l=sd->Min;
 if((sd->Max-sd->Min)==0)
   p=0;
 else {
   percent=(l*100)/(sd->Max-sd->Min);
   p=(l*w)/(sd->Max-sd->Min); }

 if(p>0)
  {
   SetAPen(rp,we->DrawInfo->dri_Pens[FILLPEN]);
   rec=SetTaskPri(SysBase->ThisTask,127);
   WaitBOVP(we->ViewPort);
   RectFill(rp,x,y,x+p,y+h);
   SetAPen(rp,0);
   if(x+p+1<x+w)
     RectFill(rp,x+p+1,y,x+w,y+h);
   SetTaskPri(SysBase->ThisTask,rec);
  }
 else
  {
   rec=SetTaskPri(SysBase->ThisTask,127);
   WaitBOVP(we->ViewPort);
   SetAPen(rp,0);
   RectFill(rp,x,y,x+w,y+h);
   SetTaskPri(SysBase->ThisTask,rec);
  }

 sprintf(&text,sd->FormatString,percent);
 WriteMText(gad->WindowEntry,
            gad->NewGadget.ng_LeftEdge+3,gad->NewGadget.ng_TopEdge,
            gad->NewGadget.ng_Width-6,gad->NewGadget.ng_Height,
            &text,JSF_CENTER,FALSE);

 RestoreRP(we);
 PrintPP(gad);
}

/* ---- Status-Gadget erstellen */
BOOL AddStatus(gadgetID,helpID,x,y,w,h,textID,flags,format,level,min,max)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 UBYTE      *format;
 ULONG       level;
 ULONG       min,max;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct StatusData       *sd;

 WE;
 if(we==NULL) return(NULL);

 gad=InitSGadget(gadgetID,helpID,STATUS_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct StatusData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 sd=gad->ExtData;
 sd->Flags=flags;
 sd->FormatString=format;
 sd->Min=min;
 sd->Max=max;

 gad->TagList[STATUS_LEVEL].ti_Data=level;

 if(!we->Iconify) ShowStatus(gad);
 return(AddMWGadget(gad));
}

/* ---- Prozent-Gadget erstellen */
BOOL AddStatus100(gadgetID,helpID,x,y,w,h,textID,flags,percent)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 ULONG       percent;
{
 return(AddStatus(gadgetID,helpID,x,y,w,h,textID,flags,"%ld%%",percent,0,100));
}

ULONG AskStatus(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,STATUS_KIND);
 if(gad)
   return((ULONG)gad->TagList[STATUS_LEVEL].ti_Data);
 return(0L);
}

/* ---- Status-Anzeige updaten */
void UpdateStatus(gadgetID,level)
 ULONG gadgetID;
 ULONG level;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct StatusData  *sd;
 ULONG               old;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,STATUS_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   sd=gad->ExtData;

   if(level<sd->Min) level=sd->Min;
   if(level>sd->Max) level=sd->Max;

   old=gad->TagList[STATUS_LEVEL].ti_Data;
   if(old==level)
     return;

   gad->TagList[STATUS_LEVEL].ti_Data=level;
   if(!we->Iconify)
    {
     if(sd->Flags & CSG_ANIMPOINTER) NextPointer(gad->WindowEntry);
     ShowStatus(gad);
    }
  }
}

/* ---- Status-Anzeige updaten */
void UpdateStatusLimits(gadgetID,min,max)
 ULONG gadgetID;
 ULONG min,max;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct StatusData  *sd;
 ULONG               level;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,STATUS_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   sd=gad->ExtData;
   sd->Min=min;
   sd->Max=max;

   level=gad->TagList[STATUS_LEVEL].ti_Data;
   if(level<sd->Min) level=sd->Min;
   if(level>sd->Max) level=sd->Max;
   gad->TagList[STATUS_LEVEL].ti_Data=level;

   if(!we->Iconify)
    {
     if(sd->Flags & CSG_ANIMPOINTER) NextPointer(gad->WindowEntry);
     ShowStatus(gad);
    }
  }
}

/* ---- ClickBox-Gadget zeichnen */
void ShowClickBox(gad)
 struct MWGadget *gad;
{
 struct ClickBoxData *cd;
 struct WindowEntry  *we;
 struct RastPort     *rp;
 register int         x1,y1,x2,y2;
 REGISTER BOOL        rec;

 cd=gad->ExtData;
 if(!(cd->Flags & CCB_NOBORDER))
  {
   if(cd->Flags & CGA_RECESSED) rec=TRUE; else rec=FALSE;
   DrawIt(gad->WindowEntry,
          gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,
          gad->NewGadget.ng_Width,gad->NewGadget.ng_Height,rec,FALSE,FALSE);
  }

 we=gad->WindowEntry;
 rp=we->RastPort;

 BackupRP(we);

 if(gad->TagList[CLICKBOX_STATUS].ti_Data==TRUE)
   SetAPen(rp,we->DrawInfo->dri_Pens[TEXTPEN]);
 else
   SetAPen(rp,0);

 x1=gad->NewGadget.ng_LeftEdge+4;
 y1=gad->NewGadget.ng_TopEdge+4;
 x2=gad->NewGadget.ng_LeftEdge+gad->NewGadget.ng_Width-5;
 y2=gad->NewGadget.ng_TopEdge+gad->NewGadget.ng_Height-4;

 rec=FALSE;

 if(cd->Flags & CCB_STAR)
  {
   rec=TRUE;
   Move(rp,x1,y1);
   Draw(rp,x2,y2);
   Move(rp,x2,y1);
   Draw(rp,x1,y2);

   Move(rp,x1,(y1+y2)/2);
   Draw(rp,x2,(y1+y2)/2);
   Move(rp,(x1+x2)/2,y1);
   Draw(rp,(x1+x2)/2,y2);
  }

 if(cd->Flags & CCB_CIRCLE)
  {
   rec=TRUE;
   DrawEllipse(rp,(x1+x2)/2,(y1+y2)/2,(x2-x1)/2,(y2-y1)/2);
  }

 if(rec==FALSE)
  {
   Move(rp,x1,y1);
   Draw(rp,x2,y2);
   Move(rp,x2,y1);
   Draw(rp,x1,y2);
  }

 RestoreRP(we);
 PrintPP(gad);
}

/* ---- Status-Gadget erstellen */
BOOL AddClickBox(gadgetID,helpID,x,y,w,h,textID,flags,checked)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 BOOL        checked;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct ClickBoxData     *cd;

 WE;
 if(we==NULL) return(NULL);

 gad=InitSGadget(gadgetID,helpID,CLICKBOX_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_RIGHT),sizeof(struct ClickBoxData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 cd=gad->ExtData;
 cd->Flags=flags;
 InitGadget(gad,&cd->Gadget,TRUE);
 cd->Gadget.Activation |= TOGGLESELECT;
 if(checked)
   cd->Gadget.Flags |= SELECTED;

 gad->TagList[CLICKBOX_STATUS].ti_Data=checked;

 if(!we->Iconify) ShowClickBox(gad);
 return(AddMWGadget(gad));
}

/* ---- ClickBox-Status abfragen */
BOOL AskClickBox(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,CLICKBOX_KIND);
 if(gad)
   return((BOOL)gad->TagList[CLICKBOX_STATUS].ti_Data);
 return(FALSE);
}

/* ---- ClickBox-Status updaten */
void UpdateClickBox(gadgetID,status)
 ULONG gadgetID;
 BOOL  status;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,CLICKBOX_KIND);
 if(gad)
  {
   gad->TagList[CLICKBOX_STATUS].ti_Data=status;

   if(!we->Iconify)
     ShowClickBox(gad);
  }
}

/* ---- Wheel-Gadget erstellen */
BOOL AddWheel(gadgetID,helpID,x,y,w,h,textID,flags,current,min,max)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 ULONG       current,min,max;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct WheelData        *wd;

 WE;
 if(we==NULL) return(NULL);

 gad=InitSGadget(gadgetID,helpID,WHEEL_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct WheelData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 wd=gad->ExtData;
 wd->Flags=flags;
 wd->Min=min;
 wd->Max=max;
 wd->Current=current;
 wd->OldX=0xffff;
 wd->OldY=0xffff;
 InitGadget(gad,&wd->Gadget,TRUE);
 if(flags & CGA_DISABLE) wd->Gadget.Flags |= GADGDISABLED;

 if(!we->Iconify) ShowWheel(gad,TRUE);
 return(AddMWGadget(gad));
}

/* ---- Wheel-Status abfragen */
ULONG AskWheel(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;
 struct WheelData   *wd;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,WHEEL_KIND);
 if(gad)
  {
   wd=gad->ExtData;
   return(wd->Current);
  }
 return(0);
}

/* ---- Wheel-Gadget zeichnen */
void ShowWheel(gad,fullUpdate)
 struct MWGadget *gad;
 BOOL             fullUpdate;
{
 struct WheelData    *wd;
 struct WindowEntry  *we;
 struct RastPort     *rp;
 int                  x1,y1,x2,y2;
 register int         vx,vy,mx,my;
 FLOAT                w;
 BOOL                 rec;

 wd=gad->ExtData;
 if(!(wd->Flags & CWH_NOBORDER))
  {
   if(wd->Flags & CGA_RECESSED) rec=TRUE; else rec=FALSE;
   DrawIt(gad->WindowEntry,
          gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,
          gad->NewGadget.ng_Width,gad->NewGadget.ng_Height,rec,FALSE,FALSE);
  }

 we=gad->WindowEntry;
 rp=we->RastPort;

 BackupRP(we);

 x1=gad->NewGadget.ng_LeftEdge+4;
 y1=gad->NewGadget.ng_TopEdge+4;
 x2=gad->NewGadget.ng_LeftEdge+gad->NewGadget.ng_Width-5;
 y2=gad->NewGadget.ng_TopEdge+gad->NewGadget.ng_Height-4;
 vx=((x2-x1)/2)-3;
 vy=((y2-y1)/2)-3;
 mx=(x1+x2)/2;
 my=(y1+y2)/2;

 w=(((FLOAT)wd->Current-(FLOAT)wd->Min)*360.0)/((FLOAT)wd->Max-(FLOAT)wd->Min);

 WaitBOVP(we->ViewPort);
 if(wd->OldX!=0xffff)
  {
   SetAPen(rp,0);
   Move(rp,mx,my);
   Draw(rp,wd->OldX,wd->OldY);
  }
 wd->OldX=mx+(int)((FLOAT)vx*cos(w*PI/180.0));
 wd->OldY=my+(int)((FLOAT)vy*sin(w*PI/180.0));

 SetAPen(rp,we->DrawInfo->dri_Pens[TEXTPEN]);
 Move(rp,mx,my);
 Draw(rp,wd->OldX,wd->OldY);
 if(fullUpdate)
   DrawEllipse(rp,mx,my,vx+3,vy+3);

 RestoreRP(we);
 PrintPP(gad);
}

/* ---- Wheel-Gadget wurde angeklickt */
void WheelHandler(gad,msg,mm)
 struct MWGadget     *gad;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 int               x1,y1,x2,y2,i,winkel;
 register int      vx,vy,mx,my,x,y;
 FLOAT             a,b,f1,f2;
 BOOL              x90;
 struct WheelData *wd;

 wd=gad->ExtData;
 x1=gad->NewGadget.ng_LeftEdge+4;
 y1=gad->NewGadget.ng_TopEdge+4;
 x2=gad->NewGadget.ng_LeftEdge+gad->NewGadget.ng_Width-5;
 y2=gad->NewGadget.ng_TopEdge+gad->NewGadget.ng_Height-4;
 mx=(x1+x2)/2;
 my=(y1+y2)/2;
 vx=((x2-x1)/2)-3;
 vy=((y2-y1)/2)-3;

 x=msg->MouseX;
 y=msg->MouseY;
 a=(FLOAT)(x-mx)/(FLOAT)vx;
 b=(FLOAT)(y-my)/(FLOAT)vy;

 winkel=0;
 x90=FALSE;
 if((a<0)&&(b<0)) winkel+=180;
 if((a<0)&&(b>0)) { winkel+=90; x90=TRUE; }
 if((a>0)&&(b<0)) { winkel+=270; x90=TRUE; }

 if(a<0) a=-a;
 if(b<0) b=-b;

 for(i=0;i<362;i+=3)
  {
   f1=sin((FLOAT)i*PI/180.0);
   f2=sin((FLOAT)(i+2)*PI/180.0);
   if((f1>=b)&&(b<=f2))
    { i++; break; }
  }

 if(x90)
   winkel+=(90-i);
 else
   winkel+=i;

 wd->Current=((ULONG)winkel*(wd->Max-wd->Min))/360+wd->Min;
 if(wd->Current>wd->Max) wd->Current=wd->Max;
 if(wd->Current<wd->Min) wd->Current=wd->Min;

 mm->ObjectID=gad->GadgetID;
 mm->ObjectAddress=gad;
 mm->ObjectCode=wd->Current;
 switch(msg->Class)
  {
   case MOUSEMOVE:
     mm->Class=MULTI_GADGETMOUSE;
    break;
   case GADGETUP:
     mm->Class=MULTI_GADGETUP;
    break;
   default:
     mm->Class=MULTI_GADGETDOWN;
    break;
  }
 ShowWheel(gad,FALSE);
}

/* ---- Wheel-Gadget updaten */
void UpdateWheel(gadgetID,current)
 ULONG gadgetID;
 ULONG current;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct WheelData   *wd;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,WHEEL_KIND);
 if(gad)
  {
   wd=gad->ExtData;
   wd->Current=current;
   if(wd->Current>wd->Max) wd->Current=wd->Max;
   if(wd->Current<wd->Min) wd->Current=wd->Min;
   if(!we->Iconify)
     ShowWheel(gad);
  }
}

/* ---- Wheel-Gadget updaten */
void UpdateWheelLimits(gadgetID,min,max)
 ULONG gadgetID;
 ULONG min,max;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct WheelData   *wd;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,WHEEL_KIND);
 if(gad)
  {
   wd=gad->ExtData;
   wd->Min=min;
   wd->Max=max;
   if(wd->Current>wd->Max) wd->Current=wd->Max;
   if(wd->Current<wd->Min) wd->Current=wd->Min;

   if(!we->Iconify)
     ShowWheel(gad);
  }
}

/* ---- SelectBox-Gadget erstellen */
BOOL AddSelectBox(gadgetID,helpID,x,y,w,h,textID,flags,titleArray,selected)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 ULONG      *titleArray;
 UBYTE       selected;
{
 struct MultiWindowsUser      *mw;
 struct MWGadget              *gad;
 struct WindowEntry           *we;
 struct SelectBoxData         *sd;
 register struct ExtNewWindow *nw;
 int                           i,j;

 WE;
 USER;
 if(we==NULL) return(NULL);

 flags &= ~CGA_IN;
 gad=InitSGadget(gadgetID,helpID,SELECTBOX_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct SelectBoxData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 sd=gad->ExtData;
 sd->Flags=flags;
 sd->TitleArray=titleArray;
 sd->Selected=selected;

 while(titleArray[sd->TitleCount]!=0L)
  {
   sd->TitleCount++;
   if(sd->TitleCount>30) break;
  }

 nw=&sd->NewWindow;
 nw->Width=50;
 for(i=0;i<sd->TitleCount;i++)
  {
   j=20+PixelLength(mw->TextFont,FindID(mw->Catalog,sd->TitleArray[i]));
   if(j>nw->Width) nw->Width=j;
  }

 nw->Height=mw->TextFont->tf_YSize*sd->TitleCount+2*(gad->WindowEntry->Screen->WBorTop+1);
 nw->BlockPen=1;
 nw->IDCMPFlags=MOUSEMOVE|MOUSEBUTTONS|VANILLAKEY|INACTIVEWINDOW;
 nw->Flags=ACTIVATE|NOCAREREFRESH|RMBTRAP|WFLG_NW_EXTENDED;
 nw->Screen=gad->WindowEntry->Screen;
 nw->Type=CUSTOMSCREEN;
 nw->Extension=&sd->TagList;

 sd->TagList[0].ti_Tag=WA_InnerWidth;
 sd->TagList[0].ti_Data=nw->Width;
 sd->TagList[1].ti_Tag=WA_InnerHeight;
 sd->TagList[1].ti_Data=nw->Height;
 sd->TagList[2].ti_Tag=WA_AutoAdjust;
 sd->TagList[2].ti_Data=TRUE;
 sd->TagList[3].ti_Tag=TAG_DONE;
 sd->TagList[3].ti_Data=0;

 InitGadget(gad,&sd->Gadget,TRUE);
 if(flags & CGA_DISABLE)
   sd->Gadget.Flags |= GADGDISABLED;

 if(!we->Iconify) ShowSelectBox(gad,TRUE);
 return(AddMWGadget(gad));
}

/* ---- SelectBox-Gadget zeichnen */
void ShowSelectBox(gad)
 struct MWGadget *gad;
{
 REGISTER BOOL            rec;
 struct SelectBoxData    *sd;
 struct MultiWindowsUser *mw;

 USER;
 sd=gad->ExtData;
 if(!(sd->Flags & CSB_NOBORDER))
  {
   if(sd->Flags & CGA_RECESSED) rec=TRUE; else rec=FALSE;
   DrawIt(gad->WindowEntry,
          gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,
          gad->NewGadget.ng_Width,gad->NewGadget.ng_Height,rec,FALSE,FALSE);
  }
 WriteMText(gad->WindowEntry,
            gad->NewGadget.ng_LeftEdge+3,gad->NewGadget.ng_TopEdge,
            gad->NewGadget.ng_Width-6,gad->NewGadget.ng_Height,
            FindID(mw->Catalog,sd->TitleArray[sd->Selected]),
            JSF_CENTER,TRUE);
 PrintPP(gad);
}

/* ---- SelectBox wird geöffnet */
void SelectBoxHandler(gad,mm)
 struct MWGadget     *gad;
 struct MultiMessage *mm;
{
 struct MultiWindowsUser *mw;
 struct SelectBoxData    *sd;
 struct Window           *win;
 struct RastPort         *rp;
 struct IntuiMessage     *m;
 ULONG                    class;
 UWORD                    code,i,l,old;
 BOOL                     okay;
 ULONG                   *array;
 UBYTE                   *t,low;

 USER;
 sd=gad->ExtData;
 array=sd->TitleArray;
 if(array==NULL) return;

 old=sd->Selected;
 sd->NewWindow.TopEdge=gad->NewGadget.ng_TopEdge;
 sd->NewWindow.LeftEdge=gad->NewGadget.ng_LeftEdge;
 win=OpenWindow(&sd->NewWindow);
 if(win)
  {
   rp=win->RPort;
   SetFont(rp,mw->TextFont);
   for(i=0;i<sd->TitleCount;i++)
    {
     t=FindID(mw->Catalog,sd->TitleArray[i]);
     l=strlen(t);
     if(sd->Selected!=i)
       SetAPen(rp,gad->WindowEntry->DrawInfo->dri_Pens[TEXTPEN]);
     else
       SetAPen(rp,gad->WindowEntry->DrawInfo->dri_Pens[HIGHLIGHTTEXTPEN]);
     Move(rp,10+win->BorderLeft,((i+1)*mw->TextFont->tf_YSize)+win->BorderTop);
     Text(rp,t,l);
    }

   okay=FALSE;
   while(okay==FALSE)
    {
     WaitPort(win->UserPort);
     m=GetMsg(win->UserPort);
     class=m->Class;
     code=m->Code;
     ReplyMsg(m);
     switch(class)
      {
       case MOUSEBUTTONS:
         i=m->MouseY;
         i-=(win->BorderTop+win->BorderTop);
         i/=mw->TextFont->tf_YSize;
         if(i>=sd->TitleCount) i=sd->TitleCount-1;
         sd->Selected=i;
         okay=TRUE;
        break;
       case VANILLAKEY:
         low=tolower(code);
         if(low==tolower(gad->CommandKey))
          {
           SetAPen(rp,gad->WindowEntry->DrawInfo->dri_Pens[TEXTPEN]);
           Move(rp,10+win->BorderLeft,((sd->Selected+1)*mw->TextFont->tf_YSize)+win->BorderTop);
           t=FindID(mw->Catalog,sd->TitleArray[sd->Selected]);
           Text(rp,t,strlen(t));

           if(low==code)
            {
             sd->Selected++;
             if(sd->Selected>=sd->TitleCount) sd->Selected=0;
            }
           else
            {
             if(sd->Selected>0)
               sd->Selected--;
             else
               sd->Selected=sd->TitleCount-1;
            }

           SetAPen(rp,gad->WindowEntry->DrawInfo->dri_Pens[HIGHLIGHTTEXTPEN]);
           Move(rp,10+win->BorderLeft,((sd->Selected+1)*mw->TextFont->tf_YSize)+win->BorderTop);
           t=FindID(mw->Catalog,sd->TitleArray[sd->Selected]);
           Text(rp,t,strlen(t));
          }
         else if(code==13)
           okay=TRUE;
        break;
       case INACTIVEWINDOW:
         okay=TRUE;
        break;
      }
    }
   CloseWindow(win);
   if(sd->Selected!=old)
     ShowSelectBox(gad);
  }
 mm->Class=MULTI_GADGETUP;
 mm->ObjectCode=sd->Selected;
}

/* ---- SelectBox abfragen */
UBYTE AskSelectBox(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget      *gad;
 struct SelectBoxData *sd;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,SELECTBOX_KIND);
 if(gad)
  {
   sd=gad->ExtData;
   return(sd->Selected);
  }
 return(0);
}

/* ---- SelectBox updaten */
void UpdateSelectBox(gadgetID,selected)
 ULONG gadgetID;
 UBYTE selected;
{
 struct MWGadget      *gad;
 struct WindowEntry   *we;
 struct SelectBoxData *sd;

 gad=GetGadget(gadgetID,MWGAD_SPECIAL,SELECTBOX_KIND);
 if(gad)
  {
   sd=gad->ExtData;
   if(selected>=sd->TitleCount) selected=sd->TitleCount-1;
   if(sd->Selected!=selected)
    {
     sd->Selected=selected;
     if(!we->Iconify)
       ShowSelectBox(gad);
    }
  }
}

/* ---- Icon-Gadget hinzufügen */
BOOL AddIcon(gadgetID,helpID,x,y,w,h,textID,flags,name)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 UBYTE      *name;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct IconData    *id;

 WE;
 if(we==NULL) return(NULL);

 gad=InitSGadget(gadgetID,helpID,ICON_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct IconData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 id=gad->ExtData;
 id->Flags=flags;
 id->Icon=GetDiskObject(name);
 InitGadget(gad,&id->Gadget,TRUE);
 if(id->Icon!=NULL)
  {
   id->Gadget.GadgetRender=CenterImage(id->Icon->do_Gadget.GadgetRender,
                                       gad->NewGadget.ng_Width,
                                       gad->NewGadget.ng_Height);
   id->Gadget.SelectRender=CenterImage(id->Icon->do_Gadget.SelectRender,
                                       gad->NewGadget.ng_Width,
                                       gad->NewGadget.ng_Height);
   id->Gadget.Flags=id->Icon->do_Gadget.Flags;
  }
 if(flags & CGA_DISABLE)
   id->Gadget.Flags |= GADGDISABLED;

 if(!we->Iconify)
   ShowIcon(gad);

 return(AddMWGadget(gad));
}

/* ---- Image-Gadget hinzufügen */
BOOL AddImage(gadgetID,helpID,x,y,w,h,textID,flags,number)
 ULONG       gadgetID;
 ULONG       helpID;
 UWORD       x,y,w,h;
 ULONG       textID;
 UWORD       flags;
 UWORD       number;
{
 struct TagItem      tags[10];
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct ImageData   *id;
 APTR                image,gadget;

 WE;
 if(we==NULL) return(NULL);

 tags[0].ti_Tag=SYSIA_Which;
 tags[0].ti_Data=number;
 tags[1].ti_Tag=SYSIA_Size;
 tags[1].ti_Data=SYSISIZE_HIRES;
 tags[2].ti_Tag=SYSIA_DrawInfo;
 tags[2].ti_Data=we->DrawInfo;
 tags[3].ti_Tag=TAG_DONE;
 tags[3].ti_Data=0;
 image=NewObjectA(NULL,"sysiclass",&tags);
 if(image==NULL) {
   NoMemory(); return(FALSE);
  }

 tags[0].ti_Tag=GA_Left;
 tags[0].ti_Data=INewX(we,x);
 tags[1].ti_Tag=GA_Top;
 tags[1].ti_Data=INewY(we,y);
 tags[2].ti_Tag=GA_Width;
 tags[2].ti_Data=INewWidth(we,w);
 tags[3].ti_Tag=GA_Height;
 tags[3].ti_Data=INewX(we,h);
 tags[4].ti_Tag=GA_Image;
 tags[4].ti_Data=image;
 tags[5].ti_Tag=GA_RelVerify;
 tags[5].ti_Data=TRUE;
 tags[6].ti_Tag=GA_Immediate;
 tags[6].ti_Data=TRUE;
 tags[7].ti_Tag=GA_Disabled;
 if(flags & CGA_DISABLE)
   tags[7].ti_Data=TRUE;
 else
   tags[7].ti_Data=FALSE;
 tags[8].ti_Tag=GA_DrawInfo;
 tags[8].ti_Data=we->DrawInfo;
 tags[9].ti_Tag=TAG_DONE;
 tags[9].ti_Data=0;
 gadget=NewObjectA(NULL,"buttongclass",&tags);
 if(gadget==NULL)
  {
   DisposeObject(image);
   NoMemory(); return(FALSE);
  }

 gad=InitSGadget(gadgetID,helpID,IMAGE_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct IconData));
 if(gad==NULL) {
   DisposeObject(image);
   DisposeObject(gadget);
   NoMemory(); return(FALSE);
  }

 id=gad->ExtData;
 id->Flags=flags;

 id->Gadget=gadget;
 id->Image=image;
 gad->Gadget=gadget;
 gad->Gadget->UserData=gad;
 gad->Gadget->GadgetID=0xffff;
 gad->Gadget->GadgetRender=CenterImage(gad->Gadget->GadgetRender,
                                       gad->NewGadget.ng_Width,
                                       gad->NewGadget.ng_Height);
 gad->Gadget->SelectRender=CenterImage(gad->Gadget->SelectRender,
                                       gad->NewGadget.ng_Width,
                                       gad->NewGadget.ng_Height);

 if(!we->Iconify)
   ShowImage(gad);

 return(AddMWGadget(gad));
}

/* ---- Image zentrieren */
struct Image *CenterImage(image,w,h)
 struct Image *image;
 int           w,h;
{
 if(image==NULL) return(NULL);

 image->LeftEdge=(w-image->Width)/2;
 image->TopEdge=(h-image->Height)/2;
 return(image);
}

/* ---- Icon-Gadget zeigen */
void ShowImage(gad)
 struct MWGadget *gad;
{
 struct ImageData *id;
 REGISTER BOOL     rec;

 id=gad->ExtData;
 if(!(id->Flags & CIM_NOBORDER))
  {
   if(id->Flags & CGA_RECESSED) rec=TRUE; else rec=FALSE;
   DrawIt(gad->WindowEntry,
          gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,
          gad->NewGadget.ng_Width,gad->NewGadget.ng_Height,rec,FALSE,FALSE);
  }
 PrintPP(gad);
}

/* ---- Icon-Gadget zeigen */
void ShowIcon(gad)
 struct MWGadget *gad;
{
 struct IconData *id;
 REGISTER BOOL    rec;

 id=gad->ExtData;
 if(!(id->Flags & CIC_NOBORDER))
  {
   if(id->Flags & CGA_RECESSED) rec=TRUE; else rec=FALSE;
   DrawIt(gad->WindowEntry,
          gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,
          gad->NewGadget.ng_Width,gad->NewGadget.ng_Height,rec,FALSE,FALSE);
  }
 PrintPP(gad);
}

