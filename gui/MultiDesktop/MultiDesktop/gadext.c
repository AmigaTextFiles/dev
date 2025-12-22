/* Gadgets II */
#include "multiwindows.h"

extern struct ExecBase *SysBase;

void NewSize();
void GadgetUp();
void MXResize();
void IntCheck();
void FloatCheck();
void HexCheck();
void GadErr();
void RefreshSGadgets();
void RefreshSGadget();
struct MWGadget *FindKeyGadget();

#define TYPE_NAMES 3
UBYTE *TypeNames[]=
{
 "GadTools gadget",
 "Intuition gadget",
 "MultiWindows gadget"
 "?",
};

#define GT_NAMES 13
UBYTE *GTNames[]=
{
 "Generic",
 "Button",
 "Check Box",
 "Integer",
 "Listview",
 "Mutual Exclude",
 "Number",
 "Cycle",
 "Palette",
 "Scroller",
 "10",
 "Slider",
 "String",
 "Text",
 "??"
};

#define INTUITION_NAMES 0
UBYTE *IntuitionNames[]=
{
 "??"
};

#define SPECIAL_NAMES 8
UBYTE *SpecialNames[]=
{
 "Toggle Select",
 "Text",
 "Number",
 "Click Box",
 "Status",
 "Wheel",
 "Select Box",
 "Icon",
 "Image",
 "??"
};

UBYTE *Unknown[]={"??"};


/* ---- Name für Gadget-Typ finden */
UBYTE *FindGTypeName(type)
 UWORD type;
{

 if(type>TYPE_NAMES) type=TYPE_NAMES;
 return(GetLStr(1038+type,TypeNames[type]));
}

/* ---- Name für Gadget-Art finden */
BYTE *FindGKindName(type,kind)
 UWORD type,kind;
{
 ULONG  id;
 UBYTE *names;

 switch(type)
  {
   case MWGAD_GADTOOLS:
     id=1060;
     names=&GTNames;
     if(kind>GT_NAMES) kind=GT_NAMES;
    break;
   case MWGAD_INTUITION:
     id=1042;
     names=&IntuitionNames;
     if(kind>INTUITION_NAMES) kind=INTUITION_NAMES;
    break;
   case MWGAD_SPECIAL:
     id=1080;
     names=&SpecialNames;
     if(kind>SPECIAL_NAMES) kind=SPECIAL_NAMES;
    break;
   default:
     kind=0;
     id=1041;
     names=&Unknown;
    break;
  }

 return(GetLStr(id+kind,names[kind]));
}

/* ---- Taste wurde gedrückt (VanillaKey) */
void VanillaKey(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 BOOL               shifted;
 UBYTE              low;
 struct MWGadget   *gad;
 struct MWMenuItem *item;

 item=FindKeyItem(we,msg->Code,msg->Qualifier,FALSE);
 if(item!=NULL)
  {
   CallItem(we,item);
   mm->Class=MULTI_MENUPICK;
   mm->ObjectID=item->ItemID;
   mm->ObjectAddress=item;
   if(item->MenuItem.Flags & CHECKED) mm->ObjectCode=TRUE;
   return;
  }

 gad=FindKeyGadget(we,msg->Code);
 if(gad)
  {
   low=tolower((UBYTE)gad->CommandKey);
   if(low==(UBYTE)msg->Code) shifted=FALSE; else shifted=TRUE;
   CallGadget(we,gad,mm,shifted);
   return;
  }

 mm->Class=MULTI_VANILLAKEY;
 mm->ObjectID=(ULONG)msg->Code;
 mm->ObjectCode=msg->Qualifier;
 mm->ObjectAddress=we;
}

/* ---- Zeitimpuls von Intuition */
void IntuiTicks(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 mm->ObjectAddress=we;
 mm->Class=MULTI_INTUITICKS;
 mm->ObjectID=we->WindowID;
 mm->ObjectData[0]=msg->Seconds;
 mm->ObjectData[1]=msg->Micros;
 GadHelpTimer(we,mm);
 NextPointer(we);
}

/* ---- Maus wurde bewegt */
void MouseMove(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 struct Gadget   *g;
 struct MWGadget *gad;

 if(we->Window!=msg->IAddress)
  {
   g=msg->IAddress;
   gad=g->UserData;
   switch(gad->Type)
    {
     case MWGAD_GADTOOLS:
       mm->ObjectID=gad->GadgetID;
       mm->ObjectAddress=gad;
       mm->ObjectCode=msg->Code;
       mm->Class=MULTI_GADGETMOUSE;

       switch(gad->Kind)
        {
         case SCROLLER_KIND:
           gad->TagList[SCROLLER_TOP].ti_Data=msg->Code;
           CallAction(gad);
          break;
         case SLIDER_KIND:
           gad->TagList[SLIDER_LEVEL].ti_Data=msg->Code;
           CallAction(gad);
          break;
        }
      break;
    }
  }
 else
  {
   if((we->FMGadget)&&(we->FMGadget->Gadget->Flags & SELECTED))
    {
     gad=we->FMGadget;
     switch(gad->Kind)
      {
       case WHEEL_KIND:
         WheelHandler(gad,msg,mm);
         CallAction(gad);
        break;
      }
    }
   else
    {
     mm->ObjectID=we->WindowID;
     mm->ObjectAddress=we;
     mm->Class=MULTI_MOUSEMOVE;
     mm->ObjectData[0]=msg->MouseX;
     mm->ObjectData[1]=msg->MouseY;
     GadHelpMouse(we,mm);
    }
  }
}

/* ---- Gadget wurde gedrückt */
void GadgetUp(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 struct Gadget      *g;
 struct StringInfo  *si;
 struct StringData  *sd;
 struct MWGadget    *gad;

 we->FMGadget=NULL;
 g=msg->IAddress;
 gad=g->UserData;
 if(gad==NULL) return;

 mm->Class=MULTI_GADGETUP;
 mm->ObjectID=gad->GadgetID;
 mm->ObjectAddress=gad;
 switch(gad->Type)
  {
   case MWGAD_GADTOOLS:
     switch(gad->Kind)
      {
       case BUTTON_KIND:
         if(gad->ExtData==TOGGLE_MAGIC)
          {
           if(gad->Update->Flags & SELECTED)
             gad->TagList[TOGGLE_STATUS].ti_Data=TRUE;
           else
             gad->TagList[TOGGLE_STATUS].ti_Data=FALSE;
          }
        break;
       case CYCLE_KIND:
         gad->TagList[CYCLE_ACTIVE].ti_Data=msg->Code;
         mm->ObjectCode=msg->Code;
        break;
       case SLIDER_KIND:
         gad->TagList[SLIDER_LEVEL].ti_Data=msg->Code;
         mm->ObjectCode=msg->Code;
        break;
       case SCROLLER_KIND:
         gad->TagList[SCROLLER_TOP].ti_Data=msg->Code;
         mm->ObjectCode=msg->Code;
        break;
       case LISTVIEW_KIND:
         gad->TagList[LISTVIEW_SELECTED].ti_Data=msg->Code;
         gad->TagList[LISTVIEW_TOP].ti_Data=msg->Code;
         mm->ObjectCode=msg->Code;
        break;
       case STRING_KIND:
         si=gad->Update->SpecialInfo;
         sd=gad->ExtData;
         strcpy(sd->Buffer,si->Buffer);
         mm->ObjectCode=gad->ExtData;
         switch(sd->SpecialType)
          {
           case SST_HEX:
             HexCheck(we,gad,sd,sd->Special,mm);
            break;
           case SST_FLOAT:
             FloatCheck(we,gad,sd,sd->Special,mm);
            break;
          }
        break;
       case INTEGER_KIND:
         si=gad->Update->SpecialInfo;
         mm->ObjectCode=atol(si->Buffer);
         gad->TagList[INTEGER_INTEGER].ti_Data=mm->ObjectCode;
         IntCheck(we,gad,mm->ObjectCode,gad->ExtData);
        break;
       case CHECKBOX_KIND:
         if(gad->Update->Flags & SELECTED)
           mm->ObjectCode=TRUE;
         else
           mm->ObjectCode=FALSE;
         gad->TagList[CHECKBOX_CHECKED].ti_Data=mm->ObjectCode;
        break;
       case PALETTE_KIND:
         gad->TagList[PALETTE_COLOR].ti_Data=msg->Code;
         mm->ObjectCode=msg->Code;
        break;
      }
    break;
   case MWGAD_SPECIAL:
     switch(gad->Kind)
      {
        case WHEEL_KIND:
         WheelHandler(gad,msg,mm);
        break;
      }
    break;
  }
 if(gad->Action) CallAction(gad);
}

/* ---- Gadget wird gerade gedrückt */
void GadgetDown(we,msg,mm)
 struct WindowEntry  *we;
 struct IntuiMessage *msg;
 struct MultiMessage *mm;
{
 struct Gadget   *g;
 struct MWGadget *gad;

 g=msg->IAddress;
 gad=g->UserData;
 if(gad==NULL) return;

 mm->Class=MULTI_GADGETDOWN;
 mm->ObjectID=gad->GadgetID;
 mm->ObjectAddress=gad;
 switch(gad->Type)
  {
   case MWGAD_GADTOOLS:
     switch(gad->Kind)
      {
       case SLIDER_KIND:
         gad->TagList[SLIDER_LEVEL].ti_Data=msg->Code;
         mm->ObjectCode=msg->Code;
        break;
       case SCROLLER_KIND:
         gad->TagList[SCROLLER_TOP].ti_Data=msg->Code;
         mm->ObjectCode=msg->Code;
        break;
       case MX_KIND:
         gad->TagList[MX_ACTIVE].ti_Data=msg->Code;
         mm->ObjectCode=msg->Code;
        break;
      }
    break;
   case MWGAD_SPECIAL:
     switch(gad->Kind)
      {
       case CLICKBOX_KIND:
         if(g->Flags & SELECTED)
           mm->ObjectCode=TRUE;
         else
           mm->ObjectCode=FALSE;
         gad->TagList[CLICKBOX_STATUS].ti_Data=mm->ObjectCode;
         ShowClickBox(gad);
        break;
       case WHEEL_KIND:
         we->FMGadget=gad;
         WheelHandler(gad,msg,mm);
        break;
       case SELECTBOX_KIND:
         SelectBoxHandler(gad,mm);
        break;
      }
    break;
  }
 if(gad->Action) CallAction(gad);
}

/* ---- Context freigeben */
void FreeGList(gad,count)
 struct Gadget *gad;
 UWORD          count;
{
 struct Gadget *g;
 int            i;

 g=gad;
 if(count>1)
  {
   for(i=1;i<count;i++)
     g=g->NextGadget;
  }
 g->NextGadget=NULL;
 FreeGadgets(gad);
}

/* ---- Textlänge ermitteln */
int TextLen(rp,text)
 struct RastPort *rp;
 UBYTE           *text;
{
 int              len;
 struct TextFont *font;

 font=rp->Font;
 SetFont(rp,GetTextFont());
 len=TextLength(rp,text,strlen(text));
 SetFont(rp,font);
 return(len);
}

/* ---- Gadget disabled machen */
void DisableGad(g)
 struct Gadget *g;
{
 while(g!=NULL)
  {
   g->Flags |= GADGDISABLED;
   g=g->NextGadget;
  }
}

/* ---- Gadget überzeichnen */
void RemGad(we,gad)
 struct WindowEntry *we;
 struct MWGadget    *gad;
{
 struct MXData       *md;
 struct ListviewData *ld;
 struct Gadget       *g;
 struct IntuiText    *it;
 struct TextFont     *font;
 int                  x,y,w,h;

 if(gad->Type==MWGAD_GADTOOLS)
  {
   if(gad->Kind==MX_KIND)
    {
     md=gad->ExtData;
     RestoreBackground(we,md->X1,md->Y1,md->X2-md->X1,md->Y2-md->Y1);
    }
   else if(gad->Kind==LISTVIEW_KIND)
    {
     ld=gad->ExtData;
     RestoreBackground(we,ld->X1,ld->Y1,ld->X2-ld->X1,ld->Y2-ld->Y1);
    }

   g=gad->Gadget;
   while(g!=NULL)
    {
     it=g->GadgetText;
     if(it)
      {
       w=TextLen(we->RastPort,it->IText);
       font=GetTextFont();
       h=font->tf_YSize;
       x=g->LeftEdge+it->LeftEdge;
       y=g->TopEdge+it->TopEdge;
       RestoreBackground(we,x,y,w,h);
      }
     g=g->NextGadget;
    }
   RestoreBackground(we,gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,gad->NewGadget.ng_Width+1,gad->NewGadget.ng_Height+1);
  }
 else
  {
   if(gad->TextPos[TX_WIDTH]!=0)
    {
     RestoreBackground(we,gad->TextPos[TX_LEFT],gad->TextPos[TX_TOP],
                          gad->TextPos[TX_WIDTH],gad->TextPos[TX_HEIGHT]);
    }
   RestoreBackground(we,gad->NewGadget.ng_LeftEdge,gad->NewGadget.ng_TopEdge,gad->NewGadget.ng_Width,gad->NewGadget.ng_Height);
  }
}

/* ---- Textplatzierung aus Flags ermitteln */
ULONG PlaceText(flags,def)
 UWORD flags;
 ULONG def;
{
 if(flags & CGA_LEFT)  def=PLACETEXT_LEFT;
 if(flags & CGA_RIGHT) def=PLACETEXT_RIGHT;
 if(flags & CGA_ABOVE) def=PLACETEXT_ABOVE;
 if(flags & CGA_BELOW) def=PLACETEXT_BELOW;
 if(flags & CGA_IN)    def=PLACETEXT_IN;
 if(flags & CGA_HIGHLABEL) def |= NG_HIGHLABEL;
 return(def);
}

/* ---- Integer-Gadget-Werte korrigieren */
void IntCheck(we,gad,num,id)
 struct WindowEntry *we;
 struct MWGadget    *gad;
 LONG                num;
 struct IntegerData *id;
{

 if(num<id->Min) num=id->Min;
 if(num>id->Max) num=id->Max;
 gad->TagList[INTEGER_INTEGER].ti_Data=num;
 GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
}

/* ---- Float-Gadget-Werte korrigieren */
void FloatCheck(we,gad,sd,fd,mm)
 struct WindowEntry  *we;
 struct MWGadget     *gad;
 struct StringData   *sd;
 struct FloatData    *fd;
 struct MultiMessage *mm;
{
 FLOAT num;

 num=atof(sd->Buffer);
 if(num<fd->Min) num=fd->Min;
 if(num>fd->Max) num=fd->Max;
 sprintf(sd->Buffer,"%f",num);
 mm->ObjectCode=num;
 GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
}

/* ---- Hex-Gadget-Werte korrigieren */
void HexCheck(we,gad,sd,hd,mm)
 struct WindowEntry  *we;
 struct MWGadget     *gad;
 struct StringData   *sd;
 struct HexData      *hd;
 struct MultiMessage *mm;
{
 ULONG num;

 sscanf("%lx",&num);
 if(num<hd->Min) num=hd->Min;
 if(num>hd->Max) num=hd->Max;
 sprintf(sd->Buffer,"%lx",num);
 GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
}

/* ---- Zu CommandKey passendes Gadget suchen */
struct MWGadget *FindKeyGadget(we,chr)
 struct WindowEntry *we;
 UBYTE               chr;
{
 struct Node        *node;
 struct MWGadget    *gad;
 struct MXData      *md;
 int                 i;

 chr=toupper(chr);
 for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
  {
   gad=node;
   if((gad->Type==MWGAD_GADTOOLS)&&(gad->Kind==MX_KIND))
    {
     md=gad->ExtData;
     for(i=0;i<12;i++)
       if(md->CommandKey[i]==chr)
        {
         if(gad->TagList[GADGET_DISABLE].ti_Data==FALSE)
          {
           gad->CommandKey=i;
           return(gad);
          }
        }
    }
   else {
     if((gad->CommandKey==chr)&&(gad->TagList[GADGET_DISABLE].ti_Data==FALSE)) {
       return(gad); }}
  }
 return(NULL);
}

/* ---- MX-Gadget-Größe bestimmen */
void MXResize(we,gad)
 struct WindowEntry *we;
 struct MWGadget    *gad;
{
 struct Gadget    *g;
 struct MXData    *md;
 struct IntuiText *it;
 long              i,j;

 g=gad->Gadget;
 if(g==NULL) return;
 md=gad->ExtData;

 md->X1=g->LeftEdge;
 md->Y1=g->TopEdge;
 md->X2=g->LeftEdge+g->Width;
 md->Y2=g->TopEdge+g->Height;

 md->X1=gad->NewGadget.ng_LeftEdge;
 md->Y1=gad->NewGadget.ng_TopEdge;
 while(g!=NULL)
  {
   j=0;
   if(md->X2<g->LeftEdge+g->Width) md->X2=g->LeftEdge+g->Width;
   if(md->Y2<g->TopEdge+g->Height) md->Y2=g->TopEdge+g->Height;
   if(!we->Iconify)
    {
     it=g->GadgetText;
     if(it)
      {
       i=strlen(it->IText);
       j=TextLength(we->RastPort,it->IText,i);
       j+=it->LeftEdge;
      }
    }
   if(md->X2<g->LeftEdge+g->Width+j) md->X2=g->LeftEdge+g->Width+j;
   if(md->Y2<g->TopEdge+g->Height) md->Y2=g->TopEdge+g->Height;
   g=g->NextGadget;
  }
 gad->NewGadget.ng_Width=md->X2-md->X1;
 gad->NewGadget.ng_Height=md->Y2-md->Y1;
}

/* ---- LV-Gadget-Größe bestimmen */
void LVResize(we,gad)
 struct WindowEntry *we;
 struct MWGadget    *gad;
{
 struct Gadget       *g;
 struct ListivewData *ld;

 g=gad->Gadget;
 if(g==NULL) return;
 ld=gad->ExtData;

 ld->X1=g->LeftEdge;
 ld->Y1=g->TopEdge;
 ld->X2=g->LeftEdge+g->Width;
 ld->Y2=g->TopEdge+g->Height;

 ld->X1=gad->NewGadget.ng_LeftEdge;
 ld->Y1=gad->NewGadget.ng_TopEdge;
 while(g!=NULL)
  {
   if(ld->X2<g->LeftEdge+g->Width) ld->X2=g->LeftEdge+g->Width;
   if(ld->Y2<g->TopEdge+g->Height) ld->Y2=g->TopEdge+g->Height;
   if(ld->X2<g->LeftEdge+g->Width) ld->X2=g->LeftEdge+g->Width;
   if(ld->Y2<g->TopEdge+g->Height) ld->Y2=g->TopEdge+g->Height;
   g=g->NextGadget;
  }
}

/* ---- Gadgets zählen */
UWORD CountGadgets(gad)
 struct Gadget *gad;
{
 UWORD i;

 i=0;
 while(gad!=NULL)
  {
   i++;
   gad=gad->NextGadget;
  }
 return(i);
}

/* ---- GetGadget()-Fehler */
void GGErr(num,id,ft,fk,gt,gk)
 UBYTE num;
 ULONG id;
 UWORD ft,fk,gt,gk;
{
 UBYTE str[250];
 UBYTE *a,*b,*c,*d,*e;

 switch(num)
  {
   case 1:
     a=GetLStr(1010,"Wrong gadget type or kind!");
     b=GetLStr(1013,"Current gadget type");
     c=GetLStr(1014,"Current gadget kind");
     d=GetLStr(1015,"Required gadget type");
     e=GetLStr(1016,"Required gadget kind");
     sprintf(&str,"%s\nGadgetID: %ld\n%s: %s\n%s: %s\n%s: %s\n%s: %s",a,id,
                  b,FindGTypeName(ft),
                  c,FindGKindName(ft,fk),
                  d,FindGTypeName(gt),
                  e,FindGKindName(gt,gk));
    break;
   case 2:
     a=GetLStr(1009,"Wrong GadgetID - gadget not available!");
     sprintf(&str,"%s\nGadgetID: %ld",a,id);
    break;
  }
 ErrorRequest("1011:GetGadget()-Error",&str,"1012:Continue");
}

/* ---- Gadget suchen */
struct MWGadget *GetGadget(gadgetID,type,kind)
 ULONG gadgetID;
 UWORD type,kind;
{
 struct Node        *node;
 struct MWGadget    *gad,*found;
 struct WindowEntry *we;

 WE;
 if(we==NULL) return(NULL);

 found=NULL;
 for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
  {
   gad=node;
   if(gad->GadgetID==gadgetID)
    {
     found=gad; break;
    }
  }

 if(found)
  {
   if((found->Type==type)&&(found->Kind==kind))
     return(found);
   else
     GGErr(1,found->GadgetID,found->Type,found->Kind,type,kind);
  }
 else
   GGErr(2,gadgetID,0,0,0,0);
 return(NULL);
}

/* ---- Gadget-Fehler */
void GadErr(num,def,gad)
 ULONG            num;
 UBYTE           *def;
 struct MWGadget *gad;
{
 UBYTE str[100];

 sprintf(&str,"%s\nGadgetID: %ld",GetLStr(num,def),gad->GadgetID);
 ErrorRequest("1021:Gadget Error!",&str,"1012:Continue");
 SetError(MERR_GadgetError);
}

/* ---- Fenstergröße wurde geändert */
void NewSize(we)
 struct WindowEntry *we;
{
 struct Node     *node;
 struct MWGadget *gad;
 int              oldW,oldH,newW,newH;

 /* ---- Neue Streckungsfaktoren berechnen --------------------------- */
 UpdateFrames(we,TRUE);

 we->FactorX=(FLOAT)we->Window->Width/(FLOAT)we->OWidth;
 we->FactorY=(FLOAT)we->Window->Height/(FLOAT)we->OHeight;

 oldW=we->InnerWidth+we->InnerLeftEdge;
 oldH=we->InnerHeight+we->InnerTopEdge;
 CalcInnerSize(we);
 newW=we->InnerWidth+we->InnerLeftEdge;
 newH=we->InnerHeight+we->InnerTopEdge;
 if(we->Wallpaper)
  {
   if(oldW<newW)
     RestoreBackground(we,oldW,we->InnerTopEdge,
                          newW-oldW,we->InnerHeight);

   if(oldH<newH)
     RestoreBackground(we,we->InnerLeftEdge,oldH,
                          we->InnerWidth,newH-oldH);
  }
 we->Width=we->Window->Width;
 we->Height=we->Window->Height;

 /* ---- Hintergrund wiederherstellen und Größe berechnen ------------ */
 for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
  {
   gad=node;

   RemGad(we,gad);
   gad->NewGadget.ng_LeftEdge=INewX(we,gad->LeftEdge);
   gad->NewGadget.ng_TopEdge=INewY(we,gad->TopEdge);
   gad->NewGadget.ng_Width=INewWidth(we,gad->Width);
   gad->NewGadget.ng_Height=INewHeight(we,gad->Height);
  }

 /* ---- Alten Schalter entfernen und wieder einfügen ---------------- */
 for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
  {
   gad=node;
   UpdateGadget(gad);
  }

 /* ---- Refresh für Schalter und Fenster ---------------------------- */
 if(we->Window->FirstGadget)
   RefreshGList(we->Window->FirstGadget,we->Window,NULL,-1L);
 RefreshSGadgets(we);
 UpdateFrames(we,FALSE);

 GTRefreshWindow(we->Window,NULL);
 RefreshWindowFrame(we->Window);
}

/* ---- Alle MultiWindows-Gadgets neu zeichnen */
void RefreshSGadgets(we)
 struct WindowEntry *we;
{
 struct Node *node;

 for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
   RefreshSGadget(node);
}

/* ---- Ein MultiWindows-Gadget neu zeichnen */
void RefreshSGadget(gad)
 struct MWGadget *gad;
{
 if(gad->Type==MWGAD_SPECIAL)
  {
   switch(gad->Kind)
    {
     case WHEEL_KIND:
       ShowWheel(gad,TRUE);
      break;
     case STEXT_KIND:
       ShowText(gad);
      break;
     case SNUMBER_KIND:
       ShowNumber(gad);
      break;
     case STATUS_KIND:
       ShowStatus(gad);
      break;
     case CLICKBOX_KIND:
       ShowClickBox(gad);
      break;
     case SELECTBOX_KIND:
       ShowSelectBox(gad);
      break;
     case ICON_KIND:
       ShowIcon(gad);
      break;
     case IMAGE_KIND:
       ShowImage(gad);
      break;
    }
  }
}

