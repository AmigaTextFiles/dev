/* GadTools-Gadgets */
#include "multiwindows.h"

extern struct ExecBase         *SysBase;
extern struct MultiWindowsBase *MultiWindowsBase;

void Redraw();
void AddHook();
void ChangeListviewEntryNumber();

/* ---- GadTools-Gadget initialisieren */
struct MWGadget *InitGTGadget(gadgetID,helpID,kind,x,y,w,h,textID,flags,extSize)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          kind;
 UWORD          x,y,w,h;
 ULONG          textID;
 ULONG          flags;
 ULONG          extSize;
{
 struct MultiWindowsUser *mw;
 struct MWGadget         *gad;
 int                      i;
 struct WindowEntry      *we;

 USER;
 WE;
 if(we==NULL) return(NULL);

 gad=ALLOC2(sizeof(struct MWGadget)+extSize);
 if(gad==NULL) return(NULL);
 if(extSize) gad->ExtData=(ULONG)gad+(ULONG)sizeof(struct MWGadget);

 for(i=1;i<MWGADGET_TAGS;i++) gad->TagList[i].ti_Tag=TAG_DONE;

 gad->WindowEntry=we;
 gad->GadgetID=gadgetID;
 gad->HelpID=helpID;
 gad->Type=MWGAD_GADTOOLS;
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
 gad->NewGadget.ng_VisualInfo=we->VisualInfo;
 gad->NewGadget.ng_TextAttr=mw->TextAttr;
 gad->NewGadget.ng_Flags=flags;
 gad->NewGadget.ng_UserData=gad;
 gad->TagList[GADGET_UNDERSCORE].ti_Tag=GT_Underscore;
 gad->TagList[GADGET_UNDERSCORE].ti_Data='_';
 gad->TagList[GADGET_DISABLE].ti_Tag=GA_Disabled;
 return(gad);
}

/* --- Gadget-Bereich löschen (wg. Wallpaper) */
void ClearGad(we,gad)
 struct WindowEntry *we;
 struct MWGadget    *gad;
{
 UWORD                x1,y1,x2,y2;
 struct ListViewData *ld;

 if(we->Wallpaper)
  {
   ld=NULL;
   if(gad->Type==MWGAD_GADTOOLS)
    {
     switch(gad->Kind)
      {
       case PALETTE_KIND:
       case MX_KIND:
         return;
        break;
       case LISTVIEW_KIND:
         ld=gad->ExtData;
        break;
      }
    }

   if(ld)
    {
     x1=ld->X1;
     x2=ld->X2-1;
     y1=ld->Y1;
     y2=ld->Y2-1;
    }
   else
    {
     x1=gad->NewGadget.ng_LeftEdge;
     y1=gad->NewGadget.ng_TopEdge;
     x2=gad->NewGadget.ng_LeftEdge+gad->NewGadget.ng_Width;
     y2=gad->NewGadget.ng_TopEdge+gad->NewGadget.ng_Height-1;
    }

   BackupRP(we);
   SetAPen(we->RastPort,0);
   RectFill(we->RastPort,x1,y1,x2,y2);
   RestoreRP(we);
  }
}

/* ---- MultiWindows-Gadget erstellen */
BOOL AddMWGadget(gad)
 struct MWGadget *gad;
{
 UBYTE                   *title;
 struct MultiWindowsUser *mw;
 struct WindowEntry      *we;
 int                      i,j;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 if(gad->Type==MWGAD_GADTOOLS)
  {
   gad->Gadget=CreateContext(&gad->Gadget);
   if(gad->Gadget==NULL)
    {
     FREE2(gad);
     NoMemory();
     return(FALSE);
    }

   gad->Update=CreateGadgetA(gad->Kind,gad->Gadget,&gad->NewGadget,&gad->TagList);
   if(gad->Update==NULL)
    {
     GadErr(1008,"AddMWGadget():\nGadTools CreateGadgetA() error!",gad);
     FreeGadgets(gad->Gadget);
     FREE2(gad);
     return(FALSE);
    }

   switch(gad->Kind)
    {
     case BUTTON_KIND:
       if(gad->ExtData==TOGGLE_MAGIC)
        {
         gad->Update->Activation |= TOGGLESELECT;
         if(gad->TagList[TOGGLE_STATUS].ti_Data==TRUE)
           gad->Update->Flags |= SELECTED;
        }
      break;
     case MX_KIND:
       if(gad->TagList[GADGET_DISABLE].ti_Data) DisableGad(gad->Gadget);
       MXResize(we,gad);
      break;
     case LISTVIEW_KIND:
       LVResize(we,gad);
      break;
     case INTEGER_KIND:
       if(gad->Update->GadgetText)
         gad->Update->GadgetText->ITextFont=mw->TextAttr;
      break;
     case STRING_KIND:
       if(gad->Update->GadgetText)
         gad->Update->GadgetText->ITextFont=mw->TextAttr;
       AddHook(gad);
      break;
    }

   if(!we->Iconify)
     ClearGad(we,gad);
   gad->Gadget->UserData=gad;
  }

 title=gad->NewGadget.ng_GadgetText;
 if(title)
  {
   j=strlen(title);
   for(i=0;i<j;i++)
    {
     if(title[i]=='_')
      {
       gad->CommandKey=toupper(title[i+1]); break;
      }
    }
  }

 AddTail(&we->GadgetList,gad);
 if(!we->Iconify)
  {
   if(gad->Gadget)
    {
     gad->GadgetCount=CountGadgets(gad->Gadget);
     AddGList(we->Window,gad->Gadget,0,-1L,NULL);
     RefreshGList(gad->Gadget,we->Window,NULL,gad->GadgetCount);
     GTRefreshWindow(we->Window,NULL);
    }
  }
 we->LastGadget=gad;

 return(TRUE);
}

/* ---- Gadget suchen */
struct MWGadget *FindGadget(gadgetID)
 ULONG gadgetID;
{
 struct Node        *node;
 struct MWGadget    *gad;
 struct WindowEntry *we;

 WE;
 if(we==NULL) return(FALSE);

 for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
  {
   gad=node;
   if(gad->GadgetID==gadgetID) return(gad);
  }
 return(NULL);
}

/* ---- Gadget disabled */
void DisableGadget(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget     *gad;
 struct WindowEntry  *we;
 struct Gadget       *g;
 int                  i;

 WE;
 if(we==NULL) return;

 gad=FindGadget(gadgetID);
 if(gad)
  {
   if((gad->Type==MWGAD_GADTOOLS)&&(gad->Kind==LISTVIEW_KIND)) return;
   if(gad->TagList[GADGET_DISABLE].ti_Data==TRUE) return;
   gad->TagList[GADGET_DISABLE].ti_Data=TRUE;

   if(gad->Gadget)
    {
     g=gad->Gadget;
     for(i=0;i<gad->GadgetCount;i++)
      {
       g->Flags |= GADGDISABLED;
       g=g->NextGadget;
      }
     RefreshGList(gad->Gadget,we->Window,NULL,gad->GadgetCount);
    }
   if(gad->Type==MWGAD_SPECIAL)
     RefreshSGadget(gad);
  }
}

/* ---- Gadget enablen */
void EnableGadget(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget     *gad;
 struct WindowEntry  *we;
 struct Gadget       *g;
 int                  i;

 WE;
 if(we==NULL) return;

 gad=FindGadget(gadgetID);
 if(gad)
  {
   if((gad->Type==MWGAD_GADTOOLS)&&(gad->Kind==LISTVIEW_KIND)) return;
   if(gad->TagList[GADGET_DISABLE].ti_Data==FALSE) return;
   gad->TagList[GADGET_DISABLE].ti_Data=FALSE;

   if(gad->Gadget)
    {
     g=gad->Gadget;
     for(i=0;i<gad->GadgetCount;i++)
      {
       g->Flags &= ~GADGDISABLED;
       g=g->NextGadget;
      }
     RefreshGList(gad->Gadget,we->Window,NULL,gad->GadgetCount);
    }
   if(gad->Type==MWGAD_SPECIAL)
     RefreshSGadget(gad);
  }
}

/* ---- Mehrere Gadgets disablen */
void DisableGadgetArray(array)
 ULONG *array;
{
 int i;

 i=0;
 while(array[i]!=0)
  {
   DisableGadget(array[i]);
   i++;
   if(i>500) break;
  }
}

/* ---- Mehrere Gadgets enablen */
void EnableGadgetArray(array)
 ULONG *array;
{
 int i;

 i=0;
 while(array[i]!=0)
  {
   EnableGadget(array[i]);
   i++;
   if(i>500) break;
  }
}

/* ---- Gadget entfernen */
void RemGadget(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget     *gad;
 struct WindowEntry  *we;
 struct ListviewData *ld;
 struct IconData     *iconData;
 struct ImageData    *imageData;

 WE;
 if(we==NULL) return;

 gad=FindGadget(gadgetID);
 if(gad)
  {
   Remove(gad);
   if(gad==we->LastGadget) we->LastGadget=NULL;

   if(!we->Iconify)
    {
     if(gad->Gadget) RemoveGList(we->Window,gad->Gadget,gad->GadgetCount);
     RemGad(we,gad);
    }

   switch(gad->Type)
    {
     case MWGAD_GADTOOLS:
       if(gad->Gadget) FreeGList(gad->Gadget,gad->GadgetCount);
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
          break;
        }
      break;
    }
   FreeMemory(&gad->Remember);
   FREE2(gad);
  }
}

/* ---- Gadgets neuzeichnen */
void Redraw()
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 if(we->Iconify) return;

 RefreshSGadgets(we);
 if(we->Window->FirstGadget)
   RefreshGList(we->Window->FirstGadget,we->Window,NULL,-1L);
 GTRefreshWindow(we->Window,NULL);
 RefreshWindowFrame(we->Window);
}

/* ---- Button-Gadget erstellen */
BOOL AddButton(gadgetID,helpID,x,y,w,h,textID,flags)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;

 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,BUTTON_KIND,x,y,w,h,textID,PLACETEXT_IN,0L);
 if(gad==NULL) { NoMemory(); return(FALSE); }

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;

 return(AddMWGadget(gad));
}

/* ---- Toggle-Gadget erstellen */
BOOL AddToggle(gadgetID,helpID,x,y,w,h,textID,flags,selected)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;

 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,BUTTON_KIND,x,y,w,h,textID,PLACETEXT_IN,0L);
 if(gad==NULL) { NoMemory(); return(FALSE); }

 gad->ExtData=TOGGLE_MAGIC;

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[TOGGLE_STATUS].ti_Data=selected;

 return(AddMWGadget(gad));
}

/* ---- Cycle-Gadget erstellen */
BOOL AddCycle(gadgetID,helpID,x,y,w,h,textID,flags,labels,active)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD           flags;
 ULONG         *labels;
 UBYTE          active;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 struct CycleData        *cd;
 int                      i;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,CYCLE_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct CycleData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 cd=gad->ExtData;
 for(i=0;i<12;i++)
  {
   if(labels[i]==0) break;
   cd->Labels[i]=FindID(mw->Catalog,labels[i]);
   cd->LabelCount++;
  }
 cd->Labels[12]=0L;

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[CYCLE_LABELS].ti_Tag=GTCY_Labels;
 gad->TagList[CYCLE_LABELS].ti_Data=&cd->Labels;
 gad->TagList[CYCLE_ACTIVE].ti_Tag=GTCY_Active;
 gad->TagList[CYCLE_ACTIVE].ti_Data=active;

 return(AddMWGadget(gad));
}

/* ---- Toggle-Gadget abfragen */
BOOL AskToggle(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,BUTTON_KIND);
 if((gad)&&(gad->ExtData==TOGGLE_MAGIC))
   return((BOOL)gad->TagList[TOGGLE_STATUS].ti_Data);
 return(FALSE);
}

/* ---- Toggle-Gadget updaten */
void UpdateToggle(gadgetID,selected)
 ULONG gadgetID;
 BOOL  selected;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct CycleData   *cd;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,BUTTON_KIND);
 if((gad)&&(gad->ExtData==TOGGLE_MAGIC))
  {
   we=gad->WindowEntry;
   gad->TagList[TOGGLE_STATUS].ti_Data=selected;
   if(selected)
     gad->Update->Flags |= SELECTED;
   else
     gad->Update->Flags &= ~SELECTED;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Cycle-Gadget updaten */
void UpdateCycle(gadgetID,active)
 ULONG gadgetID;
 UBYTE active;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct CycleData   *cd;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,CYCLE_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   cd=gad->ExtData;
   if(cd->LabelCount==0) return;
   if(active>=cd->LabelCount) active=cd->LabelCount-1;
   gad->TagList[CYCLE_ACTIVE].ti_Data=active;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Auswahl des Cycle-Gadget ermitteln */
WORD AskCycle(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,CYCLE_KIND);
 if(gad)
   return((WORD)gad->TagList[CYCLE_ACTIVE].ti_Data);
 return(-1);
}

/* ---- Cycle-Gadget erstellen */
BOOL AddListview(gadgetID,helpID,x,y,w,h,textID,flags,labels,selected)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 ULONG          flags;
 ULONG         *labels;
 UBYTE          selected;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 struct ListviewData     *ld;
 struct ListviewNode     *ln;
 int                      i,j;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,LISTVIEW_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct ListviewData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 ld=gad->ExtData;
 NewList(&ld->List);

 if(labels)
  {
   i=0;
   while(labels[i]!=NULL)
    {
     j=strlen(labels[i])+1;
     ln=AllocMemory(&ld->Remember,sizeof(struct ListviewNode)+j,MEMF_PUBLIC);
     if(ln==NULL) { NoMemory(); break; }
     ln->Node.ln_Pred=NULL;
     ln->Node.ln_Succ=NULL;
     ln->Node.ln_Type=0;
     ln->Node.ln_Pri=0;
     ln->Node.ln_Name=&ln->Label;
     CopyMem(labels[i],&ln->Label,j);
     AddTail(&ld->List,ln);
     i++;
    }
  }

 gad->TagList[LISTVIEW_LABELS].ti_Tag=GTLV_Labels;
 gad->TagList[LISTVIEW_LABELS].ti_Data=&ld->List;
 gad->TagList[LISTVIEW_TOP].ti_Tag=GTLV_Top;
 gad->TagList[LISTVIEW_TOP].ti_Data=selected;
 gad->TagList[LISTVIEW_SELECTED].ti_Tag=GTLV_Selected;
 gad->TagList[LISTVIEW_SELECTED].ti_Data=selected;
 gad->TagList[LISTVIEW_READONLY].ti_Tag=GTLV_ReadOnly;
 gad->TagList[LISTVIEW_SHOWSELECTED].ti_Tag=TAG_IGNORE;
 gad->TagList[LISTVIEW_RECESSED].ti_Tag=GTBB_Recessed;

 if(flags & CLV_READONLY)
   gad->TagList[LISTVIEW_READONLY].ti_Data=TRUE;

 if(flags & CLV_SHOWSELECTED)
   gad->TagList[LISTVIEW_SHOWSELECTED].ti_Tag=GTLV_ShowSelected;

 if(flags & CGA_RECESSED)
   gad->TagList[LISTVIEW_RECESSED].ti_Data=TRUE;

 if(flags & CLV_NONPROPFONT)
   gad->NewGadget.ng_TextAttr=mw->NonPropTextAttr;

 return(AddMWGadget(gad));
}

/* ---- Listview-Gadget updaten */
void UpdateListviewSelection(gadgetID,selected)
 ULONG gadgetID;
 LONG  selected;
{
 struct MWGadget     *gad;
 struct WindowEntry  *we;
 struct ListviewData *ld;
 ULONG                i;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;

   ld=gad->ExtData;
   i=CountNodes(&ld->List);
   if(i==0) return;
   if(selected>=i) selected=i-1;

   if(selected>=0)
    {
     gad->TagList[LISTVIEW_TOP].ti_Data=selected;
     gad->TagList[LISTVIEW_SELECTED].ti_Data=selected;
    }
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Eintrag zum Listview-Gadget hinzufügen */
void AddListviewEntrySort(gadgetID,label,place)
 ULONG  gadgetID;
 UBYTE *label;
 UBYTE  place;
{
 BOOL                  okay;
 struct TagItem        tag[2];
 struct MWGadget      *gad;
 struct WindowEntry   *we;
 struct ListviewData  *ld;
 struct ListviewNode  *ln;
 int                   j;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   ld=gad->ExtData;

   j=strlen(label)+1;
   ln=AllocMemory(&ld->Remember,sizeof(struct ListviewNode)+j,MEMF_PUBLIC);
   if(ln==NULL) { NoMemory(); return; }
   ln->Node.ln_Pred=NULL;
   ln->Node.ln_Succ=NULL;
   ln->Node.ln_Type=0;
   ln->Node.ln_Pri=0;
   ln->Node.ln_Name=&ln->Label;
   CopyMem(label,&ln->Label,j);

   switch(place)
    {
     case ULP_HEAD:
       AddHead(&ld->List,ln);
      break;
     case ULP_TAIL:
       AddTail(&ld->List,ln);
      break;
     case ULP_SORTA:
       InsertSort(&ld->List,ln,SORT_ASCENDING);
      break;
     case ULP_SORTD:
       InsertSort(&ld->List,ln,SORT_DESCENDING);
      break;
    }

   if(!we->Iconify)
    {
     tag[0].ti_Tag=GTLV_Labels;
     tag[0].ti_Data=&ld->List;
     tag[1].ti_Tag=TAG_DONE;
     GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&tag);
    }
  }
}

/* ---- Eintrag zum Listview-Gadget hinzufügen */
void AddListviewEntryNumber(gadgetID,label,num)
 ULONG  gadgetID;
 UBYTE *label;
 ULONG   num;
{
 BOOL                  okay;
 struct TagItem        tag[2];
 struct MWGadget      *gad;
 struct WindowEntry   *we;
 struct ListviewData  *ld;
 struct ListviewNode  *ln;
 struct Node          *pred;
 int                   j;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   ld=gad->ExtData;

   j=strlen(label)+1;
   ln=AllocMemory(&ld->Remember,sizeof(struct ListviewNode)+j,MEMF_PUBLIC);
   if(ln==NULL) { NoMemory(); return; }
   ln->Node.ln_Pred=NULL;
   ln->Node.ln_Succ=NULL;
   ln->Node.ln_Type=0;
   ln->Node.ln_Pri=0;
   ln->Node.ln_Name=&ln->Label;
   CopyMem(label,&ln->Label,j);

   pred=FindNode(&ld->List,num);
   if(pred==NULL)
     AddTail(&ld->List,ln);
   else
     Insert(&ld->List,ln,pred);

   if(!we->Iconify)
    {
     tag[0].ti_Tag=GTLV_Labels;
     tag[0].ti_Data=&ld->List;
     tag[1].ti_Tag=TAG_DONE;
     GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&tag);
    }
  }
}

/* ---- Eintrag im Listview-Gadget entfernen */
void RemListviewEntryLabel(gadgetID,label)
 ULONG  gadgetID;
 UBYTE *label;
{
 struct TagItem       tag[3];
 struct MWGadget     *gad;
 struct WindowEntry  *we;
 struct ListviewData *ld;
 struct ListviewNode *ln;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;

   ld=gad->ExtData;
   ln=FindName(&ld->List,label);
   if(ln==NULL) return;

   Remove(ln);
   FreeMemoryBlock(&ld->Remember,ln);
   gad->TagList[LISTVIEW_SELECTED].ti_Data=-1L;

   if(!we->Iconify)
    {
     tag[0].ti_Tag=GTLV_Labels;
     tag[0].ti_Data=&ld->List;
     tag[1].ti_Tag=GTLV_Selected;
     tag[1].ti_Data=-1L;
     tag[2].ti_Tag=TAG_DONE;
     GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&tag);
    }
   CallAction(gad);
  }
}

/* ---- Eintrag im Listview-Gadget entfernen */
void RemListviewEntryNumber(gadgetID,num)
 ULONG gadgetID;
 LONG  num;
{
 struct TagItem         tag[3];
 struct MWGadget       *gad;
 struct WindowEntry    *we;
 struct ListviewData   *ld;
 struct ListviewNode   *found;
 struct Node  *ln;
 long          i;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   ld=gad->ExtData;

   if(num>0)
    {
     i=0;
     found=NULL;
     for(ln=ld->List.lh_Head;ln!=&ld->List.lh_Tail;ln=ln->ln_Succ)
      {
       if(i==num) { found=ln; break; }
       i++;
      }
     if(found) Remove(found);
    }
   else if(num=0)
     found=RemHead(&ld->List);
   else
     found=RemTail(&ld->List);

   if(found==NULL) return;
   Remove(found);
   FreeMemoryBlock(&ld->Remember,found);
   gad->TagList[LISTVIEW_SELECTED].ti_Data=-1L;

   if(!we->Iconify)
    {
     tag[0].ti_Tag=GTLV_Labels;
     tag[0].ti_Data=&ld->List;
     tag[1].ti_Tag=GTLV_Selected;
     tag[1].ti_Data=-1L;
     tag[2].ti_Tag=TAG_DONE;
     GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&tag);
    }
   CallAction(gad);
  }
}

/* ---- Alle Einträge im Listview-Gadget entfernen */
void RemListviewEntries(gadgetID)
 ULONG gadgetID;
{
 struct TagItem         tag[3];
 struct MWGadget       *gad;
 struct WindowEntry    *we;
 struct ListviewData   *ld;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   ld=gad->ExtData;

   FreeMemory(&ld->Remember);
   NewList(&ld->List);
   gad->TagList[LISTVIEW_SELECTED].ti_Data=-1L;

   if(!we->Iconify)
    {
     tag[0].ti_Tag=GTLV_Labels;
     tag[0].ti_Data=&ld->List;
     tag[1].ti_Tag=GTLV_Selected;
     tag[1].ti_Data=-1L;
     tag[2].ti_Tag=TAG_DONE;
     GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&tag);
    }
   CallAction(gad);
  }
}

/* ---- Alle Einträge im Listview-Gadget sortieren */
void SortListviewEntries(gadgetID,place)
 ULONG gadgetID;
 UBYTE place;
{
 struct TagItem         tag[3];
 struct MWGadget       *gad;
 struct WindowEntry    *we;
 struct ListviewData   *ld;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   ld=gad->ExtData;

   SortList(&ld->List,place);
   if(!we->Iconify)
    {
     tag[0].ti_Tag=GTLV_Labels;
     tag[0].ti_Data=&ld->List;
     tag[1].ti_Tag=GTLV_Selected;
     tag[1].ti_Data=-1L;
     tag[2].ti_Tag=TAG_DONE;
     GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&tag);
    }
   CallAction(gad);
  }
}

/* ---- Auswahl des Listview-Gadget ermitteln */
LONG AskListviewSelection(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
   return(gad->TagList[LISTVIEW_SELECTED].ti_Data);
 return(-1L);
}

/* ---- Auswahl des Listview-Gadget ermitteln */
UBYTE *AskListviewSelectionLabel(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget     *gad;
 struct ListviewData *ld;
 struct Node         *node;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   ld=gad->ExtData;
   node=FindNode(&ld->List,gad->TagList[LISTVIEW_SELECTED].ti_Data);
   if(node==NULL) return(NULL);
   return(node->ln_Name);
  }
 return(NULL);
}

/* ---- MX-Gadget erstellen */
BOOL AddMX(gadgetID,helpID,x,y,w,h,pad,flags,labels,active)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          pad;
 UWORD          flags;
 ULONG         *labels;
 UBYTE          active;
{
 UBYTE                   *title;
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 struct MXData           *md;
 struct Gadget           *g;
 int                      i,j,k;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,MX_KIND,x,y,w,h,0,PlaceText(flags,PLACETEXT_RIGHT),sizeof(struct MXData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 md=gad->ExtData;
 for(i=0;i<12;i++)
  {
   if(labels[i]==0) break;
   md->Labels[i]=FindID(mw->Catalog,labels[i]);
   md->LabelCount++;

   title=md->Labels[i];
   if(title)
    {
     j=strlen(title);
     for(k=0;k<j;k++)
      {
       if(title[k]=='_')
        {
         md->CommandKey[i]=toupper(title[k+1]); break;
        }
      }
    }
  }
 md->Labels[12]=0L;

 gad->TagList[GADGET_DISABLE].ti_Tag=TAG_IGNORE;
 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;

 gad->TagList[MX_LABELS].ti_Tag=GTMX_Labels;
 gad->TagList[MX_LABELS].ti_Data=&md->Labels;
 gad->TagList[MX_ACTIVE].ti_Tag=GTMX_Active;
 gad->TagList[MX_ACTIVE].ti_Data=active;

 return(AddMWGadget(gad));
}

/* ---- MX-Gadget updaten */
void UpdateMX(gadgetID,active)
 ULONG gadgetID;
 UBYTE active;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct MXData      *mx;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,MX_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   mx=gad->ExtData;
   if(mx->LabelCount==0) return;
   if(active>=mx->LabelCount) active=mx->LabelCount-1;
   gad->TagList[MX_ACTIVE].ti_Data=active;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Auswahl des MX-Gadget ermitteln */
LONG AskMX(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,MX_KIND);
 if(gad)
   return(gad->TagList[MX_ACTIVE].ti_Data);
 return(-1L);
}

/* ---- String-Gadget erstellen */
BOOL AddString(gadgetID,helpID,x,y,w,h,textID,flags,string,max)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 UBYTE         *string;
 LONG           max;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct StringData       *sd;
 struct Gadget           *g;
 long                     j;

 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,STRING_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct StringData)+max+2);
 if(gad==NULL) { NoMemory(); return(FALSE); }

 sd=gad->ExtData;
 sd->Buffer=(ULONG)gad->ExtData+(ULONG)sizeof(struct StringData);

 if(string==NULL) string="";
 strcpy(sd->Buffer,string);

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[STRING_MAXCHARS].ti_Tag=GTST_MaxChars;
 gad->TagList[STRING_MAXCHARS].ti_Data=max;
 gad->TagList[STRING_STRING].ti_Tag=GTST_String;
 gad->TagList[STRING_STRING].ti_Data=sd->Buffer;
 gad->TagList[STRING_JUSTIFICATION].ti_Tag=STRINGA_Justification;

 if(flags & CST_CENTER)
  j=GACT_STRINGCENTER;
 else if(flags &CST_LEFT)
  j=GACT_STRINGLEFT;
 else
  j=GACT_STRINGRIGHT;
 gad->TagList[STRING_JUSTIFICATION].ti_Data=j;

 if(flags & CST_PASSWORD) {
   if(gad->NewGadget.ng_Height>14)
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password9Attr;
   else
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password5Attr;
  }

 return(AddMWGadget(gad));
}
/* ---- String-Gadget mit Hook erstellen */
BOOL AddHookString(gadgetID,helpID,x,y,w,h,textID,flags,string,max,sh)
 ULONG              gadgetID;
 ULONG              helpID;
 UWORD              x,y,w,h;
 ULONG              textID;
 UWORD              flags;
 UBYTE             *string;
 LONG               max;
 struct StringHook *sh;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct StringData       *sd;
 struct Gadget           *g;
 long                     j;

 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,STRING_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct StringData)+(max*2)+4);
 if(gad==NULL) { NoMemory(); return(FALSE); }

 sd=gad->ExtData;
 sd->Hook=&MultiWindowsBase->UserHook;
 sd->Buffer=(ULONG)gad->ExtData+(ULONG)sizeof(struct StringData);
 sd->WorkBuffer=(ULONG)sd->Buffer+(ULONG)max+2L;
 sd->SpecialType=SST_USER;
 sd->Special=sh;

 if(string==NULL) string="";
 strcpy(sd->Buffer,string);

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[STRING_MAXCHARS].ti_Tag=GTST_MaxChars;
 gad->TagList[STRING_MAXCHARS].ti_Data=max;
 gad->TagList[STRING_STRING].ti_Tag=GTST_String;
 gad->TagList[STRING_STRING].ti_Data=sd->Buffer;
 gad->TagList[STRING_JUSTIFICATION].ti_Tag=STRINGA_Justification;

 if(flags & CST_CENTER)
  j=GACT_STRINGCENTER;
 else if(flags &CST_LEFT)
  j=GACT_STRINGLEFT;
 else
  j=GACT_STRINGRIGHT;
 gad->TagList[STRING_JUSTIFICATION].ti_Data=j;

 if(flags & CST_PASSWORD) {
   if(gad->NewGadget.ng_Height>14)
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password9Attr;
   else
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password5Attr;
  }

 return(AddMWGadget(gad));
}

/* ---- Text des String-Gadget ermitteln */
UBYTE *AskString(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget   *gad;
 struct StringData *sd;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,STRING_KIND);
 if(gad)
  {
   sd=gad->ExtData;
   if((sd->SpecialType!=SST_STRING)&&(sd->SpecialType==SST_USER)) return(NULL);

   return(sd->Buffer);
  }
 return(NULL);
}

/* ---- Text des String-Gadget updaten */
void UpdateString(gadgetID,string)
 ULONG  gadgetID;
 UBYTE *string;
{
 UBYTE              *mem;
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct StringData  *sd;
 long                i,j;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,STRING_KIND);
 if(gad)
  {
   we=gad->WindowEntry;

   sd=gad->ExtData;
   if((sd->SpecialType!=SST_STRING)&&(sd->SpecialType!=SST_USER)) return;

   mem=sd->Buffer;
   if(string!=NULL)
    {
     i=strlen(string)+1;
     j=gad->TagList[STRING_MAXCHARS].ti_Data;
     if(i>j) i=j;
     CopyMem(string,mem,i);
     mem[i]=0x00;
    }
   else
     mem[0]=0x00;

   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Integer-Gadget erstellen */
BOOL AddInteger(gadgetID,helpID,x,y,w,h,textID,flags,integer,min,max)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 LONG           integer;
 LONG           min;
 LONG           max;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct Gadget           *g;
 struct IntegerData      *id;
 long                     j;

 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,INTEGER_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct IntegerData));
 if(gad==NULL) { NoMemory(); return(FALSE); }
 id=gad->ExtData;

 id->Min=min;
 id->Max=max;
 if(integer<id->Min) integer=id->Min;
 if(integer>id->Max) integer=id->Max;

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[INTEGER_MAXCHARS].ti_Tag=GTIN_MaxChars;
 gad->TagList[INTEGER_MAXCHARS].ti_Data=14;
 gad->TagList[INTEGER_INTEGER].ti_Tag=GTIN_Number;
 gad->TagList[INTEGER_INTEGER].ti_Data=integer;
 gad->TagList[INTEGER_JUSTIFICATION].ti_Tag=STRINGA_Justification;

 if(flags & CIN_CENTER)
   j=GACT_STRINGCENTER;
 else if(flags & CIN_LEFT)
   j=GACT_STRINGLEFT;
 else
   j=GACT_STRINGRIGHT;
 gad->TagList[STRING_JUSTIFICATION].ti_Data=j;

 if(flags & CIN_PASSWORD) {
  if(gad->NewGadget.ng_Height>14)
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password9Attr;
   else
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password5Attr;
  }

 return(AddMWGadget(gad));
}

/* ---- Nummer im Integer-Gadget ermitteln */
LONG AskInteger(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget   *gad;
 struct StringInfo *si;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,INTEGER_KIND);
 if(gad)
  {
   si=gad->Update->SpecialInfo;
   return(atol(si->Buffer));
  }
 return(NULL);
}

/* ---- Nummer im Integer-Gadget updaten */
void UpdateInteger(gadgetID,integer)
 ULONG  gadgetID;
 LONG   integer;
{
 UBYTE              *mem;
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct IntegerData *id;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,INTEGER_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   id=gad->ExtData;

   if(integer<id->Min) integer=id->Min;
   if(integer>id->Max) integer=id->Max;

   gad->TagList[INTEGER_INTEGER].ti_Data=integer;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Horizontales Slider-Gadget erstellen */
BOOL AddHSlider(gadgetID,helpID,x,y,w,h,textID,flags,level,min,max)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 LONG           level,min,max;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,SLIDER_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),0L);
 if(gad==NULL) { NoMemory(); return(FALSE); }

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[SLIDER_MIN].ti_Tag=GTSL_Min;
 gad->TagList[SLIDER_MIN].ti_Data=min;
 gad->TagList[SLIDER_MAX].ti_Tag=GTSL_Max;
 gad->TagList[SLIDER_MAX].ti_Data=max;
 gad->TagList[SLIDER_LEVEL].ti_Tag=GTSL_Level;
 gad->TagList[SLIDER_LEVEL].ti_Data=level;
 gad->TagList[SLIDER_RELVERIFY].ti_Tag=GA_RelVerify;
 gad->TagList[SLIDER_RELVERIFY].ti_Data=TRUE;
 gad->TagList[SLIDER_IMMEDIATE].ti_Tag=GA_Immediate;
 gad->TagList[SLIDER_IMMEDIATE].ti_Data=TRUE;
 gad->TagList[SLIDER_FREEDOM].ti_Tag=PGA_Freedom;
 gad->TagList[SLIDER_FREEDOM].ti_Data=LORIENT_HORIZ;
 gad->TagList[SLIDER_FOLLOWMOUSE].ti_Tag=GA_FollowMouse;
 gad->TagList[SLIDER_FOLLOWMOUSE].ti_Data=TRUE;
 return(AddMWGadget(gad));
}

/* ---- Vertikales Slider-Gadget erstellen */
BOOL AddVSlider(gadgetID,helpID,x,y,w,h,textID,flags,level,min,max)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 LONG           level,min,max;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,SLIDER_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),0L);
 if(gad==NULL) { NoMemory(); return(FALSE); }

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[SLIDER_MIN].ti_Tag=GTSL_Min;
 gad->TagList[SLIDER_MIN].ti_Data=min;
 gad->TagList[SLIDER_MAX].ti_Tag=GTSL_Max;
 gad->TagList[SLIDER_MAX].ti_Data=max;
 gad->TagList[SLIDER_LEVEL].ti_Tag=GTSL_Level;
 gad->TagList[SLIDER_LEVEL].ti_Data=level;
 gad->TagList[SLIDER_RELVERIFY].ti_Tag=GA_RelVerify;
 gad->TagList[SLIDER_RELVERIFY].ti_Data=TRUE;
 gad->TagList[SLIDER_FREEDOM].ti_Tag=PGA_Freedom;
 gad->TagList[SLIDER_FREEDOM].ti_Data=LORIENT_VERT;
 gad->TagList[SLIDER_FOLLOWMOUSE].ti_Tag=GA_FollowMouse;
 gad->TagList[SLIDER_FOLLOWMOUSE].ti_Data=TRUE;

 return(AddMWGadget(gad));
}

/* ---- Slider abfragen */
LONG AskSlider(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,SLIDER_KIND);
 if(gad)
   return((WORD)gad->TagList[SLIDER_LEVEL].ti_Data);
 return(-1);
}

/* ---- Slider updaten */
void UpdateSlider(gadgetID,level)
 ULONG gadgetID;
 LONG  level;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,SLIDER_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   if(level!=-1L) gad->TagList[SLIDER_LEVEL].ti_Data=level;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Slider updaten */
void UpdateSliderLimits(gadgetID,min,max)
 ULONG gadgetID;
 LONG  min,max;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,SLIDER_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   if(min!=-1L) gad->TagList[SLIDER_MIN].ti_Data=min;
   if(max!=-1L) gad->TagList[SLIDER_MAX].ti_Data=max;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Horizontales Scroller-Gadget erstellen */
BOOL AddHScroller(gadgetID,helpID,x,y,w,h,textID,flags,top,visible,total)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 LONG           top,visible,total;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 int                      arrows;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,SCROLLER_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct CycleData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 if(flags & CSC_ARROWS)
  {  if(w<50) arrows=0; else arrows=15; }
 else
  arrows=0;

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[SCROLLER_TOP].ti_Tag=GTSC_Top;
 gad->TagList[SCROLLER_TOP].ti_Data=top;
 gad->TagList[SCROLLER_TOTAL].ti_Tag=GTSC_Total;
 gad->TagList[SCROLLER_TOTAL].ti_Data=total;
 gad->TagList[SCROLLER_VISIBLE].ti_Tag=GTSC_Visible;
 gad->TagList[SCROLLER_VISIBLE].ti_Data=visible;
 gad->TagList[SCROLLER_ARROWS].ti_Tag=GTSC_Arrows;
 gad->TagList[SCROLLER_ARROWS].ti_Data=arrows;
 gad->TagList[SCROLLER_RELVERIFY].ti_Tag=GA_RelVerify;
 gad->TagList[SCROLLER_RELVERIFY].ti_Data=TRUE;
 gad->TagList[SCROLLER_IMMEDIATE].ti_Tag=GA_Immediate;
 gad->TagList[SCROLLER_IMMEDIATE].ti_Data=TRUE;
 gad->TagList[SCROLLER_FREEDOM].ti_Tag=PGA_Freedom;
 gad->TagList[SCROLLER_FREEDOM].ti_Data=LORIENT_HORIZ;

 return(AddMWGadget(gad));
}

/* ---- Vertikales Scroller-Gadget erstellen */
BOOL AddVScroller(gadgetID,helpID,x,y,w,h,textID,flags,top,visible,total)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 LONG           top,visible,total;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 int                      arrows;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,SCROLLER_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct CycleData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 if(flags & CSC_ARROWS)
  {  if(h<40) arrows=0; else arrows=15; }
 else
  arrows=0;

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[SCROLLER_TOP].ti_Tag=GTSC_Top;
 gad->TagList[SCROLLER_TOP].ti_Data=top;
 gad->TagList[SCROLLER_TOTAL].ti_Tag=GTSC_Total;
 gad->TagList[SCROLLER_TOTAL].ti_Data=total;
 gad->TagList[SCROLLER_VISIBLE].ti_Tag=GTSC_Visible;
 gad->TagList[SCROLLER_VISIBLE].ti_Data=visible;
 gad->TagList[SCROLLER_ARROWS].ti_Tag=GTSC_Arrows;
 gad->TagList[SCROLLER_ARROWS].ti_Data=arrows;
 gad->TagList[SCROLLER_RELVERIFY].ti_Tag=GA_RelVerify;
 gad->TagList[SCROLLER_RELVERIFY].ti_Data=TRUE;
 gad->TagList[SCROLLER_IMMEDIATE].ti_Tag=GA_Immediate;
 gad->TagList[SCROLLER_IMMEDIATE].ti_Data=TRUE;
 gad->TagList[SCROLLER_FREEDOM].ti_Tag=PGA_Freedom;
 gad->TagList[SCROLLER_FREEDOM].ti_Data=LORIENT_VERT;

 return(AddMWGadget(gad));
}

/* ---- Scroller abfragen */
LONG AskScroller(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,SCROLLER_KIND);
 if(gad)
   return((WORD)gad->TagList[SCROLLER_TOP].ti_Data);
 return(-1);
}

/* ---- Scroller updaten */
void UpdateScroller(gadgetID,top,visible,total)
 ULONG gadgetID;
 LONG  top,visible,total;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,SCROLLER_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   if(top!=-1L) gad->TagList[SCROLLER_TOP].ti_Data=top;
   if(total!=-1L) gad->TagList[SCROLLER_TOTAL].ti_Data=total;
   if(visible!=-1L) gad->TagList[SCROLLER_VISIBLE].ti_Data=visible;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Palette hinzufügen */
BOOL AddPalette(gadgetID,helpID,x,y,w,h,textID,flags,depth,cOffset,color)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD           flags;
 UBYTE           depth,cOffset,color;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 struct CycleData        *cd;
 int                      i;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,PALETTE_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct CycleData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[PALETTE_DEPTH].ti_Tag=GTPA_Depth;
 gad->TagList[PALETTE_DEPTH].ti_Data=depth;
 gad->TagList[PALETTE_OFFSET].ti_Tag=GTPA_ColorOffset;
 gad->TagList[PALETTE_OFFSET].ti_Data=cOffset;
 gad->TagList[PALETTE_COLOR].ti_Tag=GTPA_Color;
 gad->TagList[PALETTE_COLOR].ti_Data=color;
 gad->TagList[PALETTE_IWIDTH].ti_Tag=GTPA_IndicatorWidth;
 if(flags & CPL_IBOX) gad->TagList[PALETTE_IWIDTH].ti_Data=40;

 return(AddMWGadget(gad));
}

/* ---- Palette abfragen */
UBYTE AskPalette(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,PALETTE_KIND);
 if(gad)
   return((WORD)gad->TagList[PALETTE_COLOR].ti_Data);
 return(-1);
}

/* ---- Palette updaten */
void UpdatePalette(gadgetID,color)
 ULONG gadgetID;
 UWORD color;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,PALETTE_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   if(color<(2^(gad->TagList[PALETTE_DEPTH].ti_Data)))
     gad->TagList[PALETTE_COLOR].ti_Data=color;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Checkbox hinzufügen */
BOOL AddCheckbox(gadgetID,helpID,x,y,w,h,textID,flags,checked)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 BOOL           checked;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 struct CycleData        *cd;
 int                      i;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,CHECKBOX_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct CycleData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[CHECKBOX_CHECKED].ti_Tag=GTCB_Checked;
 gad->TagList[CHECKBOX_CHECKED].ti_Data=checked;

 return(AddMWGadget(gad));
}

/* ---- Checkbox abfragen */
BOOL AskCheckbox(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,CHECKBOX_KIND);
 if(gad)
   return((WORD)gad->TagList[CHECKBOX_CHECKED].ti_Data);
 return(-1);
}

/* ---- Checkbox updaten */
void UpdateCheckbox(gadgetID,checked)
 ULONG gadgetID;
 BOOL  checked;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,CHECKBOX_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   gad->TagList[CHECKBOX_CHECKED].ti_Data=checked;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Text-Anzeige hinzufügen */
BOOL AddTX(gadgetID,helpID,x,y,w,h,textID,flags,text)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 UBYTE         *text;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 struct CycleData        *cd;
 int                      i;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,TEXT_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct CycleData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 gad->TagList[TEXT_TEXT].ti_Tag=GTTX_Text;
 gad->TagList[TEXT_TEXT].ti_Data=text;
 gad->TagList[TEXT_BORDER].ti_Tag=GTTX_Border;
 gad->TagList[TEXT_RECESSED].ti_Tag=GTBB_Recessed;

 if(!(flags & CTX_NOBORDER)) gad->TagList[TEXT_BORDER].ti_Data=TRUE;
 if(flags & CGA_RECESSED) gad->TagList[TEXT_RECESSED].ti_Data=TRUE;

 return(AddMWGadget(gad));
}

/* ---- Text-Anzeige abfragen */
UBYTE *AskTX(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,TEXT_KIND);
 if(gad)
   return((WORD)gad->TagList[TEXT_TEXT].ti_Data);
 return(0L);
}

/* ---- Text-Anzeige updaten */
void UpdateTX(gadgetID,text)
 ULONG  gadgetID;
 UBYTE *text;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,TEXT_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   gad->TagList[TEXT_TEXT].ti_Data=text;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Zahl-Anzeige hinzufügen */
BOOL AddNM(gadgetID,helpID,x,y,w,h,textID,flags,number)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 LONG           number;
{
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct MultiWindowsUser *mw;
 struct CycleData        *cd;
 int                      i;

 USER;
 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,NUMBER_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct CycleData));
 if(gad==NULL) { NoMemory(); return(FALSE); }

 gad->TagList[NUMBER_NUMBER].ti_Tag=GTNM_Number;
 gad->TagList[NUMBER_NUMBER].ti_Data=number;
 gad->TagList[NUMBER_BORDER].ti_Tag=GTNM_Border;
 gad->TagList[NUMBER_RECESSED].ti_Tag=GTBB_Recessed;

 if(!(flags & CNM_NOBORDER)) gad->TagList[NUMBER_BORDER].ti_Data=TRUE;
 if(flags & CGA_RECESSED) gad->TagList[NUMBER_RECESSED].ti_Data=TRUE;

 return(AddMWGadget(gad));
}

/* ---- Zahl-Anzeige abfragen */
LONG AskNM(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget    *gad;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,NUMBER_KIND);
 if(gad)
   return((WORD)gad->TagList[NUMBER_NUMBER].ti_Data);
 return(0L);
}

/* ---- Zahl-Anzeige updaten */
void UpdateNM(gadgetID,number)
 ULONG gadgetID;
 LONG  number;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,NUMBER_KIND);
 if(gad)
  {
   we=gad->WindowEntry;
   gad->TagList[NUMBER_NUMBER].ti_Data=number;
   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Zahleneingabe für Float-Zahlen ---------------------------- */
BOOL AddFloat(gadgetID,helpID,x,y,w,h,textID,flags,number,min,max)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 FLOAT          number;
 FLOAT          min,max;
{
 struct StringData       *sd;
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct Gadget           *g;
 struct FloatData        *fd;
 long                     j;

 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,STRING_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct StringData)+sizeof(struct FloatData)+2*22);
 if(gad==NULL) { NoMemory(); return(FALSE); }

 sd=gad->ExtData;
 sd->Hook=&MultiWindowsBase->FloatHook;
 sd->Special=(ULONG)gad->ExtData+(ULONG)sizeof(struct StringData);
 sd->Buffer=(ULONG)sd->Special+sizeof(struct FloatData);
 sd->WorkBuffer=sd->Buffer+22;
 sd->Flags=flags;
 sd->SpecialType=SST_FLOAT;

 fd=sd->Special;
 fd->Min=min;
 fd->Max=max;

 if(number<min) number=min;
 if(number>max) number=max;
 sprintf(sd->Buffer,"%f",number);

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[STRING_MAXCHARS].ti_Tag=GTST_MaxChars;
 gad->TagList[STRING_MAXCHARS].ti_Data=20;
 gad->TagList[STRING_STRING].ti_Tag=GTST_String;
 gad->TagList[STRING_STRING].ti_Data=sd->Buffer;
 gad->TagList[STRING_JUSTIFICATION].ti_Tag=STRINGA_Justification;

 if(flags & CST_CENTER)
  j=GACT_STRINGCENTER;
 else if(flags &CST_LEFT)
  j=GACT_STRINGLEFT;
 else
  j=GACT_STRINGRIGHT;
 gad->TagList[STRING_JUSTIFICATION].ti_Data=j;

 if(flags & CST_PASSWORD) {
  if(gad->NewGadget.ng_Height>14)
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password9Attr;
   else
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password5Attr;
  }

 return(AddMWGadget(gad));
}

/* ---- Zahl des Float-Gadget ermitteln */
FLOAT AskFloat(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget   *gad;
 struct StringData *sd;
 FLOAT              result;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,STRING_KIND);
 if(gad)
  {
   sd=gad->ExtData;
   if(sd->SpecialType!=SST_FLOAT) return(0.0);

   sscanf(sd->Buffer,"%f",&result);
   return(result);
  }
 return(0.0);
}

/* ---- Zahl des Float-Gadget updaten */
void UpdateFloat(gadgetID,number)
 ULONG gadgetID;
 FLOAT number;
{
 struct MWGadget    *gad;
 struct StringData  *sd;
 struct FloatData   *fd;
 struct WindowEntry *we;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,STRING_KIND);
 if(gad)
  {
   we=gad->WindowEntry;

   sd=gad->ExtData;
   if(sd->SpecialType!=SST_FLOAT) return;

   fd=sd->Special;
   if(fd==NULL) return;

   if(number<fd->Min) number=fd->Min;
   if(number>fd->Max) number=fd->Max;
   sprintf(sd->Buffer,"%f",number);

   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Zahleneingabe für Hex-Zahlen ---------------------------- */
BOOL AddHex(gadgetID,helpID,x,y,w,h,textID,flags,number,min,max)
 ULONG          gadgetID;
 ULONG          helpID;
 UWORD          x,y,w,h;
 ULONG          textID;
 UWORD          flags;
 ULONG          number;
 ULONG          min,max;
{
 struct StringData       *sd;
 struct HexData          *hd;
 struct MWGadget         *gad;
 struct WindowEntry      *we;
 struct Gadget           *g;
 long                     j;

 WE;
 if(we==NULL) return(FALSE);

 gad=InitGTGadget(gadgetID,helpID,STRING_KIND,x,y,w,h,textID,PlaceText(flags,PLACETEXT_ABOVE),sizeof(struct StringData)+sizeof(struct HexData)+2*10);
 if(gad==NULL) { NoMemory(); return(FALSE); }

 sd=gad->ExtData;
 sd->Hook=&MultiWindowsBase->HexHook;
 sd->Special=(ULONG)gad->ExtData+(ULONG)sizeof(struct StringData);
 sd->Buffer=(ULONG)sd->Special+sizeof(struct HexData);
 sd->WorkBuffer=sd->Buffer+10;
 sd->Flags=flags;
 sd->SpecialType=SST_HEX;

 hd=sd->Special;
 hd->Min=min;
 hd->Max=max;

 if(number<min) number=min;
 if(number>max) number=max;
 sprintf(sd->Buffer,"%lx",number);

 if(flags & CGA_DISABLE) gad->TagList[GADGET_DISABLE].ti_Data=TRUE;
 gad->TagList[STRING_MAXCHARS].ti_Tag=GTST_MaxChars;
 gad->TagList[STRING_MAXCHARS].ti_Data=8;
 gad->TagList[STRING_STRING].ti_Tag=GTST_String;
 gad->TagList[STRING_STRING].ti_Data=sd->Buffer;
 gad->TagList[STRING_JUSTIFICATION].ti_Tag=STRINGA_Justification;

 if(flags & CST_CENTER)
  j=GACT_STRINGCENTER;
 else if(flags &CST_LEFT)
  j=GACT_STRINGLEFT;
 else
  j=GACT_STRINGRIGHT;
 gad->TagList[STRING_JUSTIFICATION].ti_Data=j;

 if(flags & CST_PASSWORD) {
  if(gad->NewGadget.ng_Height>14)
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password9Attr;
   else
     gad->NewGadget.ng_TextAttr=MultiWindowsBase->Password5Attr;
  }

 return(AddMWGadget(gad));
}

/* ---- Zahl des Hex-Gadget ermitteln */
ULONG AskHex(gadgetID)
 ULONG gadgetID;
{
 struct MWGadget   *gad;
 struct StringData *sd;
 ULONG              result;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,STRING_KIND);
 if(gad)
  {
   sd=gad->ExtData;
   if(sd->SpecialType!=SST_HEX) return(0);

   sscanf(sd->Buffer,"%lx",&result);
   return(result);
  }
 return(0);
}

/* ---- Zahl des Hex-Gadget updaten */
void UpdateHex(gadgetID,number)
 ULONG gadgetID;
 ULONG number;
{
 struct MWGadget    *gad;
 struct WindowEntry *we;
 struct StringData  *sd;
 struct HexData     *hd;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,STRING_KIND);
 if(gad)
  {
   we=gad->WindowEntry;

   sd=gad->ExtData;
   if(sd->SpecialType!=SST_HEX) return;

   hd=sd->Special;
   if(hd==NULL) return;

   if(number<hd->Min) number=hd->Min;
   if(number>hd->Max) number=hd->Max;
   sprintf(sd->Buffer,"%lx",number);

   if(!we->Iconify) GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&gad->TagList);
  }
}

/* ---- Hook für Float-Gadgets */
ULONG FloatHookProc(hook,sg,msg)
 struct Hook   *hook;
 struct SGWork *sg;
 ULONG         *msg;
{
 int i,found;

 if(*msg==SGH_KEY)
  {
   if((sg->EditOp==EO_REPLACECHAR)||(sg->EditOp==EO_INSERTCHAR))
    {
     if(!( ((sg->Code>='0') && (sg->Code<='9')) || (sg->Code=='-') || (sg->Code=='.') || (sg->Code=='+') ))
      {
       sg->Actions |= SGA_BEEP;
       sg->Actions &= ~SGA_USE;
       return(~0);
      }
     if((sg->Code=='-')||(sg->Code=='+'))
      {
       if(sg->BufferPos!=1)
        {
         sg->Actions |= SGA_BEEP;
         sg->Actions &= ~SGA_USE;
         return(~0);
        }
      }
     if(sg->Code=='.')
      {
       found=0;
       for(i=0;i<sg->NumChars;i++)
        {
         if(sg->WorkBuffer[i]=='.')
          {
           found++;
           if(found>1)
            {
             sg->Actions |= SGA_BEEP;
             sg->Actions &= ~SGA_USE;
             return(~0);
            }
          }
        }
      }
    }
  }
 return(0L);
}

/* ---- Hook für Hex-Gadgets */
ULONG HexHookProc(hook,sg,msg)
 struct Hook   *hook;
 struct SGWork *sg;
 ULONG         *msg;
{
 UBYTE              code;
 struct MWGadget   *gad;
 struct StringData *sd;

 if(*msg==SGH_KEY)
  {
   code=toupper(sg->Code);
   if((sg->EditOp==EO_REPLACECHAR)||(sg->EditOp==EO_INSERTCHAR))
    {
     if(!( ((code>='0') && (code<='9')) ||
           ((code>='A') && (code<='F')) ))
      {
       sg->Actions |= SGA_BEEP;
       sg->Actions &= ~SGA_USE;
       return(~0);
      }
     else
      {
       gad=sg->Gadget->UserData;
       sd=gad->ExtData;
       if(sd->Flags & CHX_TOUPPER)
         sg->WorkBuffer[sg->BufferPos-1]=code;
       else if(sd->Flags & CHX_TOLOWER)
         sg->WorkBuffer[sg->BufferPos-1]=tolower(code);
      }
    }
  }
 return(0L);
}

/* ---- Hook für UserHook-Gadgets */
ULONG UserHookProc(hook,sg,msg)
 struct Hook   *hook;
 struct SGWork *sg;
 ULONG         *msg;
{
 BOOL               found;
 UBYTE              code;
 LONG               res;
 struct MWGadget   *gad;
 struct StringData *sd;
 struct StringHook *sh;
 int                i;

 gad=sg->Gadget->UserData;
 sd=gad->ExtData;
 sh=sd->Special;

 if(*msg==SGH_KEY)
  {
   code=sg->Code;
   if((sg->EditOp==EO_REPLACECHAR)||(sg->EditOp==EO_INSERTCHAR))
    {
     if(sh->Flags & SHF_USERROUTINE)
      {
       res=sh->UserRoutine(sh->UserData,sg,msg);
       if(res==URR_RETURN) return(~0);
       if(res==URR_OKAY) return(0L);
      }

     if(sh->Flags & SHF_TOUPPER) code=toupper(code);
     if(sh->Flags & SHF_TOLOWER) code=tolower(code);

     if(sh->Flags & SHF_CHARTABLE)
      {
       i=0; found=FALSE;
       while((sh->CharTable[i]!=0x00)&&(i<256))
        {
         if(sh->CharTable[i]==code)
          {
           found=TRUE;
           break;
          }
         i++;
        }
       if(found==FALSE)
        {
         sg->Actions |= SGA_BEEP;
         sg->Actions &= ~SGA_USE;
         return(~0);
        }
      }

     sg->WorkBuffer[sg->BufferPos-1]=code;
    }
  }
 return(0L);
}

/* ---- Hook in Gadget->StringInfo->Extension schreiben */
void AddHook(gad)
 struct MWGadget *gad;
{
 struct StringData   *sd;
 struct StringInfo   *si;
 struct StringExtend *se;

 si=gad->Update->SpecialInfo;
 se=si->Extension;
 sd=gad->ExtData;
 if(sd->WorkBuffer==NULL) return;   /* Normales String-Gadget -> Ende */

 se->EditHook=sd->Hook;
 se->WorkBuffer=sd->Buffer;
}


/* ---- Eintrag im Listview-Gadget updaten */
void ChangeListviewEntryNumber(gadgetID,num,label)
 ULONG  gadgetID;
 ULONG  num;
 UBYTE *label;
{
 struct TagItem       tag[2];
 struct MWGadget     *gad;
 struct WindowEntry  *we;
 struct ListviewData *ld;
 struct ListviewNode *ln,*new;
 struct Node         *pred;
 int                  j;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;

   ld=gad->ExtData;
   ln=FindNode(&ld->List,num);
   if(ln==NULL) return;

   pred=ln->Node.ln_Pred;
   Remove(ln);

   j=strlen(label)+1;
   new=AllocMemory(&ld->Remember,sizeof(struct ListviewNode)+j,MEMF_PUBLIC);
   if(new==NULL) { NoMemory(); return; }
   new->Node.ln_Pred=NULL;
   new->Node.ln_Succ=NULL;
   new->Node.ln_Type=0;
   new->Node.ln_Pri=0;
   new->Node.ln_Name=&new->Label;
   CopyMem(label,&new->Label,j);

   Insert(&ld->List,new,pred);
   FreeMemoryBlock(&ld->Remember,ln);

   if(!we->Iconify)
    {
     tag[0].ti_Tag=GTLV_Labels;
     tag[0].ti_Data=&ld->List;
     tag[1].ti_Tag=TAG_DONE;
     GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&tag);
    }
  }
}

/* ---- Aktuellen Eintrag im Listview-Gadget updaten */
void ChangeListviewEntrySelected(gadgetID,label)
 ULONG  gadgetID;
 UBYTE *label;
{
 LONG i;

 i=AskListviewSelection(gadgetID);
 if(i>=0)
   ChangeListviewEntryNumber(gadgetID,label,i);
}

/* ---- Einträge im Listview-Gadget updaten */
void SetListviewList(gadgetID,list)
 ULONG         gadgetID;
 struct List *list;
{
 struct TagItem       tag[3];
 struct WindowEntry  *we;
 struct MWGadget     *gad;
 struct ListviewData *ld;
 struct Node         *node;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   we=gad->WindowEntry;

   ld=gad->ExtData;
   FreeMemory(&ld->Remember);
   NewList(&ld->List);

   for(node=list->lh_Head;node!=&list->lh_Tail;node=node->ln_Succ)
     AddListviewEntrySort(gad->GadgetID,node->ln_Name,ULP_TAIL);

   if(!we->Iconify)
    {
     tag[0].ti_Tag=GTLV_Labels;
     tag[0].ti_Data=&ld->List;
     tag[1].ti_Tag=GTLV_Selected;
     tag[1].ti_Data=-1L;
     tag[2].ti_Tag=TAG_DONE;
     GTSetGadgetAttrsA(gad->Update,we->Window,NULL,&tag);
    }

   CallAction(gad);
  }
}

/* ---- Einträge im Listview-Gadget als Liste zurückliefern */
struct List *GetListviewList(gadgetID)
 ULONG         gadgetID;
{
 struct MWGadget     *gad;
 struct ListviewData *ld;

 gad=GetGadget(gadgetID,MWGAD_GADTOOLS,LISTVIEW_KIND);
 if(gad)
  {
   ld=gad->ExtData;
   return(&ld->List);
  }
 return(NULL);
}
