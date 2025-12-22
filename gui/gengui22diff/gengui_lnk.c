
#include <stdlib.h>

#define __USE_SYSBASE

#include <exec/libraries.h>
#include <exec/types.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <libraries/gadtools.h>
#include <proto/intuition.h>
#include <intuition/intuition.h>
#include <proto/graphics.h>
#include <graphics/text.h>
#include <string.h>
#include <intuition/gadgetclass.h>
#include <proto/layers.h>
#include <proto/utility.h>

#include "gengui.h"

#if MWDEBUG
#include <exec/memory.h>
#include <sc:extras/memlib/memwatch.h>
#endif

#define TextID SRx

#ifndef max
#define max(x,y) ((x)>(y)?(x):(y))
#endif
#ifndef min
#define min(x,y) ((x)<(y)?(x):(y))
#endif

#ifdef USE_LOCALE
#include <libraries/locale.h>
#include <proto/locale.h>
extern struct Catalog *Catalog;
#define GetTextStr(gad) (Catalog?(const char *)GetCatalogStr(Catalog,(gad)->Dim.TextID,(STRPTR)(gad)->Text):(gad)->Text)
#else
#define GetTextStr(gad) (gad)->Text
#endif


ULONG Modify[]={0,0,GTCB_Checked,GTIN_Number,GTLV_Selected,
                          GTMX_Active,0,GTCY_Active,GTPA_Color,
                          GTSC_Top,0,GTSL_Level,GTST_String,0};

ULONG Default[]={0,0,FALSE,0,~0,0,0,0,1,0,0,0,(ULONG)"",0};

static ULONG *MergeTags(ULONG *oldlist,ULONG *newlist)
/* oldlist enthält als ersten Eintrag die Länge des Arrays, genauso
   die zurückgegebene Liste */
{
   ULONG *p;
   if(!oldlist) {
      oldlist=malloc(16*sizeof(ULONG));
      if(!oldlist) return(NULL);
      oldlist[0]=16;
      oldlist[1]=TAG_DONE;
   }

   while(*newlist!=TAG_DONE) {
      switch(*newlist) {
         case TAG_IGNORE:  newlist+=2;
                           break;
         case TAG_MORE:    newlist=(ULONG *)newlist[1];
                           break;
         case TAG_SKIP:    newlist+=2*newlist[1]+2;
                           break;
         default:

                           p=oldlist+1;

            /* passenden Eintrag in der Taglist suchen, bzw Ende der Liste */

                           while(*p!=TAG_DONE && *p!=*newlist) p+=2;

                           if(*p==*newlist) {
                              p[1]=newlist[1]; /* alte Daten ueberschreiben */
                              newlist+=2;
                           } else {
                              int n=p-oldlist; /* Position im Array; */

                              if(n>=oldlist[0]-1) { /* Array vergrößern */
                                 ULONG *mem;
                                 mem=realloc(oldlist,oldlist[0]+16*sizeof(ULONG));
                                 if(!mem) return(NULL);
                                 oldlist=mem;
                                 oldlist[0]+=16;
                                 p=oldlist+n;
                              }

                              *p++=*newlist++;
                              *p++=*newlist++;
                              *p=TAG_DONE;
                           }
                           break;
      }
   }
   return(oldlist);
}

BOOL GG_SetGadgetAttrsA(struct Gadget *gad,struct Window *win,
                       struct Requester *req, ULONG *Tag)
{
   ULONG *newtags;
   struct GadInfo *gi;

   gi=GetInfo(gad);

   if(gi->Dim.Kind==GG_GFXBUTTON_KIND) {

      if(Tag[0]==GA_Disabled) { /* Only this tag is supported */
         struct Gadget *g;

         g=(struct Gadget *)gi->SaveTags;

         if( !(g->Flags & GFLG_DISABLED) != !Tag[1]) {
            int index;

            index=RemoveGadget(win,gad);

            if(index!=65535) {
               gad->Flags^=GFLG_DISABLED;
               EraseRect(win->RPort,gad->LeftEdge,gad->TopEdge,gad->LeftEdge+gad->Width-1,gad->TopEdge+gad->Height-1);
               AddGadget(win,gad,index);
               RefreshGList(gad,win,req,1);
            }

         }
         return TRUE;
      }
      return FALSE;
   }


   if(gi->Dim.Kind<0) return FALSE;

   if(!gi->SaveTags) {
      gi->SaveTags=MergeTags(NULL,gi->Tags);
      if(!gi->SaveTags) return(FALSE);
   }

   newtags=MergeTags(gi->SaveTags,Tag);
   if(!newtags) return(FALSE);
   gi->SaveTags=newtags;
   GT_SetGadgetAttrsA(gad,win,req,(struct TagItem *)Tag);
   return(TRUE);
}
BOOL GG_SetGadgetAttrs(struct Gadget *gad,struct Window *win,
                       struct Requester *req, ULONG Tag1,...)
{
   return(GG_SetGadgetAttrsA(gad,win,req,&Tag1));
}

BOOL GG_SetLowlevelAttrsA(struct GadInfo *gad, ULONG *Tag)
{
   ULONG *newtags;

   if(gad->Dim.Kind<0) return FALSE;

   if(!gad->SaveTags) {
      gad->SaveTags=MergeTags(NULL,gad->Tags);
      if(!gad->SaveTags) return(FALSE);
   }

   newtags=MergeTags(gad->SaveTags,Tag);
   if(!newtags) return(FALSE);
   gad->SaveTags=newtags;
   return(TRUE);
}
BOOL GG_SetLowlevelAttrs(struct GadInfo *gad, ULONG Tag1,...)
{
   return(GG_SetLowlevelAttrsA(gad,&Tag1));
}

static int MakeGTGadget(struct WinInfo *winfo,                       /**/
                            struct GadInfo *gad,
                            int left, int top, int width, int height)
{
   struct NewGadget ng;

   if(winfo->Mode==GG_MODE_REFRESH && gad->Dim.Kind>=0) return(0);

   ng.ng_LeftEdge=left + (gad->Dim.XSpace>>1);
   ng.ng_TopEdge=top + (gad->Dim.YSpace>>1);
   ng.ng_Width=width - gad->Dim.XSpace;
   ng.ng_Height=height - gad->Dim.YSpace;
   ng.ng_GadgetText=(char *)GetTextStr(gad);
   ng.ng_TextAttr=gad->TextAttr ? gad->TextAttr : &winfo->TextAttr;
   ng.ng_GadgetID=gad->GadgetID;
   ng.ng_Flags=gad->Flags;
   ng.ng_VisualInfo=winfo->Visual;
   ng.ng_UserData=(void *)gad;

   if(gad->Dim.Kind>=0) {
      /* Falls dies kein erneutes aufsetzen ist: SaveTags neu errechnen */
      if(!gad->SaveTags) { /* || (!(winfo->Box->Dim.Flags & GG_FLAG_BACKUP) && winfo->Mode==GG_MODE_NEW)) { */
         ULONG *tags;
         static ULONG modifytag[]={0,0,TAG_DONE};

         if(gad->SaveTags) free(gad->SaveTags);
         gad->SaveTags=NULL;

         if(Modify[gad->Dim.Kind]) { /* Allocate savetags for use with GG_GetIMsg() */
            modifytag[0]=Modify[gad->Dim.Kind];
            modifytag[1]=Default[gad->Dim.Kind];
            tags=MergeTags(NULL,modifytag);
            if(!tags) return(1);
            gad->SaveTags=tags;
         }
         tags=MergeTags(gad->SaveTags,gad->Tags);
         if(!tags) return(1);
         gad->SaveTags=tags;
      }

      winfo->Prev=gad->ThisGad=winfo->Gadgets[gad->GadNum]=
          CreateGadgetA(gad->Dim.Kind,winfo->Prev,&ng,(struct TagItem *)(gad->SaveTags+1));
      if(winfo->Prev==NULL) return(1); else return(0);
   } else {
      return(gad->CustomFunc(winfo,&ng,gad,left,top,width,height));
   }
} /**/

void GG_GfxPrintSize(struct RastPort *rast,const char *text,struct GG_ObjectSize *size)
{
   int x;
   const char *p;
   struct RastPort rp;
   struct TextExtent ext;

   rp=*rast;

   SetSoftStyle(&rp,FS_NORMAL,-1);

   size->Height=rp.Font->tf_YSize;
   size->Width=0;

   x=0;

   for(p=text;*p;p++) {

      if(*p=='\n') {

         if(p-text>0) {
            TextExtent(&rp,(char *)text,p-text,&ext);
            x+=ext.te_Extent.MaxX-ext.te_Extent.MinX+1;
            if(x>size->Width) size->Width=x;
            x=0;
            size->Height+=rp.Font->tf_YSize;
         }
         text=p+1;

      } else if(*p=='%') {

         if(p[1]=='%') {
            p++;
            TextExtent(&rp,(char *)text,p-text,&ext);
            x+=ext.te_Extent.MaxX-ext.te_Extent.MinX+1;
            text=p+1;

         } else {

            if(p-text>0) {
               TextExtent(&rp,(char *)text,p-text,&ext);
               x+=ext.te_Extent.MaxX-ext.te_Extent.MinX+1;
            }

            p++;

            switch(*p) {

               case 'C': p++; break;
               case 'c': p++; break;

               case 'I': SetSoftStyle(&rp,FSF_ITALIC,FSF_ITALIC);break;
               case 'i': SetSoftStyle(&rp,0,FSF_ITALIC);break;
               case 'B': SetSoftStyle(&rp,FSF_BOLD,FSF_BOLD);break;
               case 'b': SetSoftStyle(&rp,0,FSF_BOLD);break;
               case 'U': SetSoftStyle(&rp,FSF_UNDERLINED,FSF_UNDERLINED);break;
               case 'u': SetSoftStyle(&rp,0,FSF_UNDERLINED);break;

               case 'N': SetSoftStyle(&rp,FS_NORMAL,-1);break;

               default: break;
            }

            text=p+1;
         }
      }
   }

   if(p-text>0) {
      TextExtent(&rp,(char *)text,p-text,&ext);
      x+=ext.te_Extent.MaxX-ext.te_Extent.MinX+1;
      if(x>size->Width) size->Width=x;
   }
}
void GG_GfxPrint(struct RastPort *rast,const char *text,int left,int top)
{
   struct RastPort rp;
   int x;
   const char *p;

   rp=*rast;

   SetDrMd(&rp,JAM2);
   SetAPen(&rp,1);
   SetBPen(&rp,0);
   SetSoftStyle(&rp,FS_NORMAL,-1);

   top+=rp.Font->tf_Baseline;
   x=left;

   for(p=text;*p;p++) {

      if(*p=='\n') {

         if(p-text>0) {
            Move(&rp,x,top);
            Text(&rp,(char *)text,p-text);
            x=left;
            top+=rp.Font->tf_YSize;
         }
         text=p+1;

      } else if(*p=='%') {

         if(p[1]=='%') {
            p++;
            Move(&rp,x,top);
            Text(&rp,(char *)text,p-text);
            x+=TextLength(&rp,(char *)text,p-text);
            text=p+1;

         } else {

            if(p-text>0) {
               Move(&rp,x,top);
               Text(&rp,(char *)text,p-text);
               x+=TextLength(&rp,(char *)text,p-text);
            }

            p++;

            switch(*p) {

               case 'C': p++;SetAPen(&rp,*p-'0');break;
               case 'c': p++;SetBPen(&rp,*p-'0');break;

               case 'I': SetSoftStyle(&rp,FSF_ITALIC,FSF_ITALIC);break;
               case 'i': SetSoftStyle(&rp,0,FSF_ITALIC);break;
               case 'B': SetSoftStyle(&rp,FSF_BOLD,FSF_BOLD);break;
               case 'b': SetSoftStyle(&rp,0,FSF_BOLD);break;
               case 'U': SetSoftStyle(&rp,FSF_UNDERLINED,FSF_UNDERLINED);break;
               case 'u': SetSoftStyle(&rp,0,FSF_UNDERLINED);break;

               case 'N': SetSoftStyle(&rp,FS_NORMAL,-1);break;

               default: break;
            }

            text=p+1;
         }
      }
   }

   if(p-text>0) {
      Move(&rp,x,top);
      Text(&rp,(char *)text,p-text);
   }
}

static int MakePlainText(struct WinInfo *winfo,                      /**/
                          struct GadInfo *gad,
                          int left,int top,int width,int height)
{
   struct TextFont *newfont=NULL,*oldfont;

   if(!winfo->Render) return 0;

   if(gad->TextAttr) {
      newfont=OpenFont(gad->TextAttr);
      if(!newfont) return 1;

      oldfont=winfo->Window->RPort->Font;
      SetFont(winfo->Window->RPort,newfont);
   }


   if(gad->Flags) {

      struct GG_ObjectSize size;

      GG_GfxPrintSize(winfo->Window->RPort,GetTextStr(gad),&size);

      width-=gad->Dim.XSpace;
      height-=gad->Dim.YSpace;

      if(gad->Flags & GG_HCentered) {
         left+=width-size.Width>>1;
      } else if(gad->Flags & GG_Right) {
         left+=width-size.Width;
      }

      if(gad->Flags & GG_VCentered) {
         top+=height-size.Height>>1;
      } else if(gad->Flags & GG_Bottom) {
         top+=height-size.Height;
      }
   }

   GG_GfxPrint(winfo->Window->RPort,GetTextStr(gad),left+(gad->Dim.XSpace>>1)
                                          ,top+(gad->Dim.YSpace>>1));

   if(newfont) {
      SetFont(winfo->Window->RPort,oldfont);
      CloseFont(newfont);
   }

   return 0;

}
static int MakeGfxButton(struct WinInfo *winfo,                      /**/
                          struct GadInfo *gad,
                          int left,int top,int width,int height)
{
   struct Gadget *g;

   ULONG flags;

   if(winfo->Mode != GG_MODE_NEW && winfo->Mode !=GG_MODE_RESIZE) return 0;

   width-=gad->Dim.XSpace;
   height-=gad->Dim.YSpace;
   left+=gad->Dim.XSpace>>1;
   top+=gad->Dim.YSpace>>1;

   flags=gad->Flags;

   if(!gad->SaveTags && !(gad->SaveTags=calloc(1,sizeof(struct Gadget))))
         return 1;

   g=(struct Gadget *)gad->SaveTags;

   g->LeftEdge=left;
   g->TopEdge=top;
   g->Width=width;
   g->Height=height;

   if((flags ^ GG_FullSize) && gad->Tags[0]) {

      // limit the size to the size of the image or align the image within
      // the allocated space

      struct Image *i,*i2;

      i=(struct Image *)gad->Tags[0];
      i2=(struct Image *)gad->Tags[1];

      // align the button within the allocated room

      // horizontal centered

      if(flags & GG_HCentered) {
         i->LeftEdge=width-i->Width>>1;
         if(i2) i2->LeftEdge=width-i->Width>>1;
      } else if(flags & GG_Right) {
         i->LeftEdge=width-i->Width;
         if(i2) i2->LeftEdge=width-i->Width;
      }

      // vertical centered

      if(flags & GG_VCentered) {
         i->TopEdge=height-i->Height>>1;
         if(i2) i2->TopEdge=height-i->Height>>1;
      } else if(flags & GG_Bottom) {
         i->TopEdge=height-i->Height;
         if(i2) i2->TopEdge=height-i->Height;
      }

      // limit the size to that of the image

      if(!(flags & GG_FullSize)) {
         g->LeftEdge=left+i->LeftEdge;
         g->TopEdge=top+i->TopEdge;
         g->Width=i->Width;
         g->Height=i->Height;

         i->LeftEdge=0;
         i->TopEdge=0;

         if(i2) {
            i2->LeftEdge=0;
            i2->TopEdge=0;
         }
      }

   }

   if(!gad->Code) { /* gad->Code==1 tells, that the gadget is already */
                    /* initialized for resize or after GG_StopGui     */
      gad->Code=1;

      flags&=~GG_IgnoreFlags;

      g->Flags=GFLG_GADGIMAGE
                  | (gad->Tags[0]&&gad->Tags[1]?GFLG_GADGHIMAGE:GFLG_GADGHCOMP)
                  | (flags & 0xffff);

      g->Activation=flags>>16;



      g->GadgetType=GTYP_BOOLGADGET;

      g->GadgetRender=(void *)(gad->Tags[0]);
      g->SelectRender=(void *)(gad->Tags[0]?gad->Tags[1]:0);

      g->GadgetID=gad->GadgetID;

      g->UserData=gad;
   }

   winfo->Prev->NextGadget=g;
   winfo->Prev=gad->ThisGad=winfo->Gadgets[gad->GadNum]=g;

   return 0;
}

static int MakeGuiGadget(struct WinInfo *winfo,                      /**/
                          struct Box *box,
                          int left,int top,int width,int height)
{
   struct Box **p;
   int relx,rely,absx,absy;
   int w,h;

   left+=box->Dim.LeftCSpace*winfo->FontX+box->Dim.LeftPSpace;
   width-=(box->Dim.LeftCSpace+box->Dim.RightCSpace)*winfo->FontX
          +box->Dim.LeftPSpace+box->Dim.RightPSpace;

   top+=box->Dim.TopCSpace*winfo->FontX+box->Dim.TopPSpace;
   height-=(box->Dim.TopCSpace+box->Dim.BottomCSpace)*winfo->FontX
          +box->Dim.TopPSpace+box->Dim.BottomPSpace;

   if(box->Dim.Kind>0 || box->Dim.Kind==GG_CUSTOM_KIND)
                         return(MakeGTGadget(winfo,(struct GadInfo *)box,
                                                 left,top,width,height));

   if(box->Dim.Kind==GG_PLAINTEXT_KIND)
                         return MakePlainText(winfo,(struct GadInfo *)box,
                                              left,top,width,height);
   if(box->Dim.Kind==GG_GFXBUTTON_KIND)
                         return MakeGfxButton(winfo,(struct GadInfo *)box,
                                              left,top,width,height);

   if(!winfo->Render) {
      for(p=box->Entry;*p;p++) {
         if(MakeGuiGadget(winfo,(*p),0,0,0,0)) return(1);
      }
   } else {

      if(box->Dim.Flags & (GG_FLAG_RAISED | GG_FLAG_RECESSED)) {

         if(box->Backfill) {
            struct Hook *old;

            old=InstallLayerHook(winfo->Window->RPort->Layer,box->Backfill);
            EraseRect(winfo->Window->RPort,left+(box->Dim.XSpace>>1),
                                         top+(box->Dim.YSpace>>1),
                                         left+(box->Dim.XSpace>>1)+width-box->Dim.XSpace-1,
                                         top+(box->Dim.YSpace>>1)+height-box->Dim.YSpace-1);
            InstallLayerHook(winfo->Window->RPort->Layer,old);
         }

         DrawBevelBox(winfo->Window->RPort,
                        left+(box->Dim.XSpace>>1),
                        top+(box->Dim.YSpace>>1),
                        width-box->Dim.XSpace,
                        height-box->Dim.YSpace,
                (box->Dim.Flags & GG_FLAG_RAISED)?TAG_IGNORE:GTBB_Recessed,TRUE,
                        GT_VisualInfo,winfo->Visual,
                        TAG_DONE);

         left+=box->Dim.XSpace;
         top+=box->Dim.YSpace;
         width-=2*box->Dim.XSpace;
         height-=2*box->Dim.YSpace;

      } else {
         if(box->Backfill) {
            struct Hook *old;

            old=InstallLayerHook(winfo->Window->RPort->Layer,box->Backfill);
            EraseRect(winfo->Window->RPort,left,top,
                                         left+width-1,
                                         top+height-1);
            InstallLayerHook(winfo->Window->RPort->Layer,old);
         }

         if(box->Dim.Flags & GG_FLAG_BAR) {
            struct DrawInfo *dinfo;
            struct RastPort rast;

            rast=*winfo->Window->RPort;

            dinfo=GetScreenDrawInfo(winfo->Window->WScreen);

            if(box->Dim.Kind==GG_HBOX) {

               SetAPen(&rast,dinfo->dri_Pens[SHADOWPEN]);
               Move(&rast,left,top);
               Draw(&rast,left+width-1,top);

               SetAPen(&rast,dinfo->dri_Pens[SHINEPEN]);
               Move(&rast,left,top+1);
               Draw(&rast,left+width-1,top+1);

            } else {

               SetAPen(&rast,dinfo->dri_Pens[SHADOWPEN]);
               Move(&rast,left,top);
               Draw(&rast,left,top+height-1);

               SetAPen(&rast,dinfo->dri_Pens[SHINEPEN]);
               Move(&rast,left+1,top);
               Draw(&rast,left+1,top+height-1);

            }

            FreeScreenDrawInfo(winfo->Window->WScreen,dinfo);
         }
      }

      if(!box->Entry) return(0);

      relx=box->Dim.SRx;
      rely=box->Dim.SRy;
      absx=box->Dim.SPx;
      absy=box->Dim.SPy;

      if(box->Dim.Kind==GG_HBOX) {

         width-=absx;
         if(width<0) width=0;

         for(p=box->Entry;*p;p++) {
            w=width * ((*p)->Dim.Rx)/relx + (*p)->Dim.Px;
            h=height * ((*p)->Dim.Ry)/rely + (*p)->Dim.Py;

            if(MakeGuiGadget(winfo,(*p),left,top,w,h)) return(1);

            left+=w;
         }

      } else if(box->Dim.Kind==GG_VBOX) {

         height-=absy;
         if(height<0) height=0;

         for(p=box->Entry;*p;p++) {
            w=width * ((*p)->Dim.Rx)/relx + (*p)->Dim.Px;
            h=height * ((*p)->Dim.Ry)/rely + (*p)->Dim.Py;

            if(MakeGuiGadget(winfo,(*p),left,top,w,h)) return(1);

            top+=h;
         }

      }
   }
   return(0);
}          /**/
static void FreeGuiGadget(struct Box *box)
{
   struct Box **p;

   struct GadInfo *gad;

   if(box->Dim.Kind>0) {
      gad=(struct GadInfo *)box;
      if(gad->SaveTags) free(gad->SaveTags);
      gad->SaveTags=NULL;

      if(box->Dim.Kind==STRING_KIND) {
         if(gad->Code) free((void *)gad->Code);
         gad->Code=NULL;
      }
   } else if(box->Dim.Kind==GG_GFXBUTTON_KIND) {
      gad=(struct GadInfo *)box;
      gad->Code=0; /* delete flag for using old gadget-flags */

   } else {

      if(   (box->Dim.Kind!=GG_VBOX && box->Dim.Kind!=GG_HBOX)
         || !box->Entry) return;

      for(p=box->Entry;*p;p++) FreeGuiGadget(*p);
   }
}

static void InitGui(struct WinInfo *winfo,struct Box *box)           /**/
{
   struct Box **p;
   struct GadInfo *gad;

   int relx=0,rely=0,absx=0,absy=0;

   if(box->Dim.Kind==BUTTON_KIND) {
      gad=(struct GadInfo *)box;

      if(!(box->Dim.MinCx | box->Dim.MinPx)) {
         box->Dim.MinCx=gad->Text?strlen(GetTextStr(gad)):1;
         box->Dim.MinPx=4;
      }
#if 0 /* bereits in defaults eingestellt */
      if(!(box->Dim.MinCy | box->Dim.MinPy)) {
         box->Dim.MinCy=1;
         box->Dim.MinPy=4;
      }
#endif
   } else if(box->Dim.Kind==CYCLE_KIND) {
      char **label;
      int len=1;

      gad=(struct GadInfo *)box;

      if(!(box->Dim.MinCx | box->Dim.MinPx)) {

         if(gad->Tags && (label=(char **)GetTagData(GTCY_Labels,NULL,(struct TagItem *)gad->Tags))) {
            char **p;
            int n;

            for(p=label;*p;p++) {
               n=strlen(*p);
               if(n>len) len=n;
            }
         }

         box->Dim.MinCx=len;
         box->Dim.MinPx=24;
      }

   } else if(box->Dim.Kind==MX_KIND) {
      char **label;
      int cnt=0;

      gad=(struct GadInfo *)box;

      if(!(box->Dim.MinCy | box->Dim.MinPy)) {

         if(gad->Tags && (label=(char **)GetTagData(GTMX_Labels,NULL,(struct TagItem *)gad->Tags))) {
            char **p;
            for(p=label;*p;p++) cnt++;
         }

         box->Dim.MinCy=cnt;
         box->Dim.MinPy=6;
      }

   } else if(box->Dim.Kind==GG_PLAINTEXT_KIND) {

      if(!(box->Dim.MinCx|box->Dim.MinPx) || !(box->Dim.MinCy|box->Dim.MinPy)) {

         struct GG_ObjectSize size;
         gad=(struct GadInfo *)box;

         GG_GfxPrintSize(winfo->Window->RPort,GetTextStr(gad),&size);


         if(!(box->Dim.MinCx | box->Dim.MinPx) || (box->Dim.Flags & GG_FLAG_DEFAULT_WIDTH)) {
            box->Dim.Flags |= GG_FLAG_DEFAULT_WIDTH;
            box->Dim.MinPx=size.Width;
         }

         if(!(box->Dim.MinCy | box->Dim.MinPy) || (box->Dim.Flags & GG_FLAG_DEFAULT_HEIGHT)) {
            box->Dim.Flags |= GG_FLAG_DEFAULT_HEIGHT;
            box->Dim.MinPy=size.Height;
         }
      }
   } else if(box->Dim.Kind==GG_GFXBUTTON_KIND) {

      if(!(box->Dim.MinCx|box->Dim.MinPx)) {

         struct Image *i,*i2;

         gad=(struct GadInfo *)box;
         i=(struct Image *)gad->Tags[0];
         i2=(struct Image *)gad->Tags[1];

         if(i) box->Dim.MinPx=i->Width;
         if(i2 && i2->Width>i->Width) box->Dim.MinPx=i2->Width;

      }

      if(!(box->Dim.MinCy|box->Dim.MinPy)) {

         struct Image *i,*i2;

         gad=(struct GadInfo *)box;
         i=(struct Image *)gad->Tags[0];
         i2=(struct Image *)gad->Tags[1];


         if(i) box->Dim.MinPy=i->Height;
         if(i2 && i2->Height>i->Height) box->Dim.MinPy=i2->Height;

      }
   }

   box->Dim.Px+=box->Dim.Cx*winfo->FontX;
   box->Dim.Py+=box->Dim.Cy*winfo->FontY;

   box->Dim.MinPx+=box->Dim.MinCx*winfo->FontX;
   box->Dim.MinPy+=box->Dim.MinCy*winfo->FontY;

   if(!box->Entry || box->Dim.Kind>0 || box->Dim.Kind==GG_CUSTOM_KIND) {
      return;
   }

   for(p=box->Entry;*p;p++) InitGui(winfo,*p);

   if(box->Dim.Kind==GG_HBOX) {

      for(p=box->Entry;*p;p++) {
         relx+=(*p)->Dim.Rx;
         absx+=(*p)->Dim.Px;

         rely=max(rely,(*p)->Dim.Ry);
         absy=max(absy,(*p)->Dim.Py);
      }
   } else {
      for(p=box->Entry;*p;p++) {
         rely+=(*p)->Dim.Ry;
         absy+=(*p)->Dim.Py;

         relx=max(relx,(*p)->Dim.Rx);
         absx=max(absx,(*p)->Dim.Px);
      }
   }

   if(relx==0) relx=1;
   if(rely==0) rely=1;

   box->Dim.SRx=relx;
   box->Dim.SRy=rely;
   box->Dim.SPx=absx;
   box->Dim.SPy=absy;

   for(p=box->Entry;*p;p++) {
      box->Dim.Flags|=(*p)->Dim.Flags & GG_FLAG_TRADEMASK;
   }

   return;
}          /**/
static void DeInitGui(struct WinInfo *winfo,struct Box *box)           /**/
{
   struct Box **p;

   box->Dim.Px-=box->Dim.Cx*winfo->FontX;
   box->Dim.Py-=box->Dim.Cy*winfo->FontY;

   box->Dim.MinPx-=box->Dim.MinCx*winfo->FontX;
   box->Dim.MinPy-=box->Dim.MinCy*winfo->FontY;

   if(!box->Entry || box->Dim.Kind>0 || box->Dim.Kind==GG_CUSTOM_KIND) {
      return;
   }

   for(p=box->Entry;*p;p++) DeInitGui(winfo,*p);

   return;
}          /**/
static int BackupGui(struct WinInfo *winfo,struct Box *box)          /**/
{
   struct GadInfo *gad=(struct GadInfo *)box;
   int err=0;

   if(box->Dim.Flags & (GG_FLAG_STRING | GG_FLAG_INTEGER)) {

      if(box->Dim.Kind==INTEGER_KIND) {
         ULONG tags[]={GTIN_Number,0,TAG_DONE};
         tags[1]=GetNumber(gad->ThisGad);
         MergeTags(gad->SaveTags,tags);
/*         gad->Code=GetNumber(gad->ThisGad); */
      } else if(box->Dim.Kind==STRING_KIND) {

         /* gad->Code is used to store the pointer to the memory */

         ULONG tags[]={GTST_String,0,TAG_DONE};
         if(gad->Code) free((void *)gad->Code);
         gad->Code=(ULONG)strdup(GetString(gad->ThisGad));
         if(!gad->Code) return(1);
         tags[1]=gad->Code;
         MergeTags(gad->SaveTags,tags); /* This is always successful, since
                                         * there is always a GTST_String tag
                                         * in the taglist (see MakeGTGadget) */
      } else if(box->Dim.Kind==GG_VBOX || box->Dim.Kind==GG_HBOX) {
         struct Box **p;

         if(!box->Entry) return(0);

         for(p=box->Entry; *p; p++) {
            err|=BackupGui(winfo,*p);
         }
      }
   }
   return(err);
} /**/
static void FindCustom(struct WinInfo *winfo,struct Box *box)        /**/
{
   struct GadInfo *gad=(struct GadInfo *)box;
   static struct NewGadget ng; /* Just to avoid Enforcer Hits */

   if( !(box->Dim.Flags & GG_FLAG_CUSTOM)) return;

   if(box->Dim.Kind==GG_CUSTOM_KIND) {
      gad->CustomFunc(winfo,&ng,gad,0,0,0,0);
   } else if(box->Dim.Kind==GG_VBOX || box->Dim.Kind==GG_HBOX) {
      struct Box **p;

      if(box->Dim.Flags & GG_FLAG_CUSTOM) {
         if(!box->Entry) return;

         for(p=box->Entry; *p; p++) {
            FindCustom(winfo,*p);
         }
      }
   }
} /**/

struct IntuiMessage *GG_GetIMsg(struct MsgPort *userport) /**/
{
   struct IntuiMessage *msg;
   int ignore=1;
   struct Gadget *gad;

   while(ignore && (msg=GT_GetIMsg(userport))) {

      ignore=0;

      switch(msg->Class) {
/*         case IDCMP_MOUSEMOVE: */
         case IDCMP_GADGETUP:
         case IDCMP_GADGETDOWN:
            gad=(struct Gadget *)msg->IAddress;
            if(gad && ((short)gad->GadgetID)>=0) {
               struct GadInfo *gi;
               ULONG tags[]={0,0,TAG_DONE};
               gi=GetInfo(gad);

               if(gi->Dim.Kind>=0 && Modify[gi->Dim.Kind]) {
                  tags[0]=Modify[gi->Dim.Kind];
                  tags[1]=msg->Code;
                  MergeTags(gi->SaveTags,tags); /* always successful in this case */
               }
               if(GetInfo(gad)->HookFunc) ignore=GetInfo(gad)->HookFunc(msg);
            }
            break;
      }
      if(ignore) {
         GT_ReplyIMsg(msg);
      }
   }
   return msg;
} /**/

void GG_ClearWindow(struct Window *win)
{
   RefreshWindowFrame(win);
   EraseRect(win->RPort,win->BorderLeft,
                        win->BorderTop,
                        win->Width-1-win->BorderRight,
                        win->Height-1-win->BorderBottom);
}

int GG_RenderGui(struct Window *win, struct WinInfo *winfo)             /**/
{
   winfo->Window=win;
   winfo->Mode=GG_MODE_NEW;
   winfo->Render=1;

   AskFont(win->RPort,&winfo->TextAttr);

   winfo->FontX = win->RPort->Font->tf_XSize;
   winfo->FontY = win->RPort->Font->tf_YSize;
   winfo->Visual=GetVisualInfoA(win->WScreen,NULL);

   if(!(winfo->Box->Dim.Flags & GG_FLAG_INITED)) {
      winfo->Box->Dim.Flags |= GG_FLAG_INITED;
      InitGui(winfo,winfo->Box);
   }

   if(!winfo->Visual) goto exit_fail2;

   if(!CreateContext(&winfo->GList)) return(1);

   winfo->Prev=winfo->GList;

   if(MakeGuiGadget(winfo,winfo->Box,win->BorderLeft,win->BorderTop,
                     win->Width - win->BorderLeft - win->BorderRight,
                     win->Height - win->BorderTop - win->BorderBottom))
                                                             goto exit_fail3;
   AddGList(win,winfo->GList,-1,-1,NULL);
   RefreshGList(winfo->GList,win,NULL,-1);
   GT_RefreshWindow(win,NULL);

   if(winfo->Box->Dim.Flags & GG_FLAG_BACKUP) {
      winfo->Mode=GG_MODE_RESTORE;
      FindCustom(winfo,winfo->Box);
      winfo->Box->Dim.Flags &= ~GG_FLAG_BACKUP;
   }

   return(0);

exit_fail3:
   if(winfo->GList) FreeGadgets(winfo->GList);
   FreeVisualInfo(winfo->Visual);
exit_fail2:
   return(1);
}  /**/
int GG_ResizeGui(struct WinInfo *winfo)                                 /**/
{
   struct Window *win=winfo->Window;

   if(winfo->GList) {

      winfo->Box->Dim.Flags|=GG_FLAG_SKIPREFRESH|GG_FLAG_RESIZED;
      winfo->Mode=GG_MODE_BACKUP;
      winfo->Render=0;

      FindCustom(winfo,winfo->Box); /* Backup of customgadgets */

      BackupGui(winfo,winfo->Box);

      winfo->Mode=GG_MODE_RESIZE;
      winfo->Render=1;

      RemoveGList(win,winfo->GList,-1);
      FreeGadgets(winfo->GList);

      winfo->GList=NULL;
   }

   if(winfo->Box->Backfill==NULL) GG_ClearWindow(win); else RefreshWindowFrame(win);

   if(!CreateContext(&winfo->GList)) return(1);
   winfo->Prev=winfo->GList;

   if(MakeGuiGadget(winfo,winfo->Box,win->BorderLeft,win->BorderTop,
                     win->Width - win->BorderLeft - win->BorderRight,
                     win->Height - win->BorderTop - win->BorderBottom))
                                                                  return(2);

   AddGList(win,winfo->GList,-1,-1,NULL);
   RefreshGList(winfo->GList,win,NULL,-1);

   GT_RefreshWindow(win,NULL);

   winfo->Mode=GG_MODE_RESTORE;
   winfo->Render=0;
   FindCustom(winfo,winfo->Box);

   return(0);
}  /**/
void GG_BeginResizeGui(struct WinInfo *winfo)
{
   struct Window *win=winfo->Window;

   if(winfo->GList) {

      winfo->Mode=GG_MODE_BACKUP;
      winfo->Render=0;

      FindCustom(winfo,winfo->Box); /* Backup of customgadgets */

      BackupGui(winfo,winfo->Box);

      winfo->Mode=GG_MODE_RESIZE;
      winfo->Render=1;

      RemoveGList(win,winfo->GList,-1);
      FreeGadgets(winfo->GList);

      winfo->GList=NULL;
   }
}

int GG_RefreshGui(struct WinInfo *winfo)                                /**/
{
   struct Window *win=winfo->Window;

   if(winfo->Box->Dim.Flags&GG_FLAG_SKIPREFRESH) {
      winfo->Box->Dim.Flags&=~GG_FLAG_SKIPREFRESH;
      return(0);
   }

   if(!winfo->GList) return 0;

   winfo->Render=1;
   winfo->Mode=GG_MODE_REFRESH;
   if(MakeGuiGadget(winfo,winfo->Box,win->BorderLeft,win->BorderTop,
                    win->Width - win->BorderLeft - win->BorderRight,
                    win->Height - win->BorderTop - win->BorderBottom)) return(1);

   RefreshGList(winfo->GList,win,NULL,-1);
#if 0
   GT_RefreshWindow(winfo->Window,NULL);
#endif
   return 0;
}         /**/

void GG_BeginRefresh(struct WinInfo *winfo)
{
   if(!(winfo->Box->Dim.Flags & GG_FLAG_RESIZED)) {
      GT_BeginRefresh(winfo->Window);
   }
}
void GG_EndRefresh(struct WinInfo *winfo, BOOL complete)
{
   if(!(winfo->Box->Dim.Flags & GG_FLAG_RESIZED)) {
      GT_EndRefresh(winfo->Window,complete);
   } else {
      if(complete) {
         GT_BeginRefresh(winfo->Window);
         GT_EndRefresh(winfo->Window,TRUE);
      }
   }
   if(complete) winfo->Box->Dim.Flags &= ~GG_FLAG_RESIZED;
}

static void FreeStopGui(struct WinInfo *winfo,int backup)                       /**/
{
   winfo->Render=0;
   if(backup) {
      winfo->Mode=GG_MODE_BACKUP;
      BackupGui(winfo,winfo->Box);
      FindCustom(winfo,winfo->Box);
      winfo->Box->Dim.Flags|=GG_FLAG_BACKUP;
      winfo->Mode=GG_MODE_STOP;
      FindCustom(winfo,winfo->Box);
   } else {
      winfo->Mode=GG_MODE_FREE;
      FindCustom(winfo,winfo->Box);
      FreeGuiGadget(winfo->Box);
   }

   if(winfo->GList) {
      RemoveGList(winfo->Window,winfo->GList,-1);
      FreeGadgets(winfo->GList);
      winfo->GList=NULL;
   }
   if(winfo->Visual) {
      FreeVisualInfo(winfo->Visual);
      winfo->Visual=NULL;
   }

   if(winfo->Box->Dim.Flags & GG_FLAG_INITED) {
      winfo->Box->Dim.Flags &= ~GG_FLAG_INITED;
      DeInitGui(winfo,winfo->Box);
   }
} /**/
void GG_FreeGui(struct WinInfo *winfo)
{
   FreeStopGui(winfo,0);
}
void GG_StopGui(struct WinInfo *winfo)
{
   FreeStopGui(winfo,1);
}

static int RenderSubGui(struct WinInfo *winfo,                              /**/
                 int left,int top,int width, int height)
{
   InitGui(winfo,winfo->Box);

   if(MakeGuiGadget(winfo,winfo->Box,left,top,width,height)) return(1);

   return(0);
} /**/
static int ResizeSubGui(struct WinInfo *winfo,                              /**/
                 int left, int top,int width,int height)
{
   if(MakeGuiGadget(winfo,winfo->Box,left,top,width,height)) return(1);

   return(0);
} /**/
static int RefreshSubGui(struct WinInfo *winfo,int left,int top,int width,int height) /**/
{
   winfo->Mode=GG_MODE_REFRESH;
   return(MakeGuiGadget(winfo,winfo->Box,left,top,width,height));
} /**/
static void FreeSubGui(struct WinInfo *winfo)                               /**/
{
   winfo->Mode=GG_MODE_FREE;
   FindCustom(winfo,winfo->Box);
   FreeGuiGadget(winfo->Box);
   DeInitGui(winfo,winfo->Box);
}                                         /**/
static void StopSubGui(struct WinInfo *winfo)                               /**/
{
   winfo->Mode=GG_MODE_STOP;
   FindCustom(winfo,winfo->Box);
   DeInitGui(winfo,winfo->Box);
}                                         /**/

int GG_SubGui(struct WinInfo *parent, struct WinInfo *winfo,            /**/
                  int left,int top,int width, int height)
{
   int ret=0;

   memcpy((void *)(((ULONG)winfo)+2*sizeof(void *)),
          (void *)(((ULONG)parent)+2*sizeof(void *)),
          sizeof(struct WinInfo)-2*sizeof(void *));

   switch(parent->Mode) {

      case GG_MODE_NEW:  ret=RenderSubGui(winfo,left,top,width,height);
                         winfo->Box->Dim.Flags&=~GG_FLAG_BACKUP;
                         break;
      case GG_MODE_RESIZE:
                         ret=ResizeSubGui(winfo,left,top,width,height);
                         winfo->Box->Dim.Flags&=~GG_FLAG_BACKUP;
                         break;
      case GG_MODE_REFRESH:
                         ret=RefreshSubGui(winfo,left,top,width,height);
                         break;
      case GG_MODE_STOP: StopSubGui(winfo);
                         break;
      case GG_MODE_FREE: FreeSubGui(winfo);
                         break;
      case GG_MODE_RESTORE:
                         FindCustom(winfo,winfo->Box);
                         break;
      case GG_MODE_BACKUP:
                         ret=BackupGui(winfo,winfo->Box);
                         FindCustom(winfo,winfo->Box);
                         winfo->Box->Dim.Flags|=GG_FLAG_BACKUP;
                         break;
   }
   parent->Prev=winfo->Prev;
   return(ret);
}  /**/
static void GetMinSize(struct WinInfo *winfo,                      /**/
                          struct Box *box,
                          struct GG_ObjectSize *size)
{
   struct Box **p;
   int relx,rely,absx,absy;
   int w,h;


   if(box->Dim.Kind>0 || box->Dim.Kind<=GG_CUSTOM_KIND) {

      size->Width=box->Dim.MinPx+box->Dim.XSpace
                 +(box->Dim.LeftCSpace+box->Dim.RightCSpace)*winfo->FontX
                 +box->Dim.LeftPSpace+box->Dim.RightPSpace;
      size->Height=box->Dim.MinPy+box->Dim.YSpace
                 +(box->Dim.TopCSpace+box->Dim.BottomCSpace)*winfo->FontY
                 +box->Dim.TopPSpace+box->Dim.BottomPSpace;

      if(!box->Dim.Rx) size->Width=box->Dim.Px;
      if(!box->Dim.Ry) size->Height=box->Dim.Py;

   } else {

      struct GG_ObjectSize osize;
      int rwidth,rheight;

      size->Width=size->Height=0;

      if(!box->Entry) return;
      if(box->Dim.Flags & GG_FLAG_BAR) return; /* wird bereits beim Init berücksichtigt */

      /* Sonderbehandlung, falls explizit angegeben */

      if((box->Dim.MinCx|box->Dim.MinPx) && (box->Dim.MinCy|box->Dim.MinPy)) {
         size->Width=box->Dim.MinPx+box->Dim.XSpace
                 +(box->Dim.LeftCSpace+box->Dim.RightCSpace)*winfo->FontX
                 +box->Dim.LeftPSpace+box->Dim.RightPSpace;
         size->Height=box->Dim.MinPy+box->Dim.YSpace
                 +(box->Dim.TopCSpace+box->Dim.BottomCSpace)*winfo->FontY
                 +box->Dim.TopPSpace+box->Dim.BottomPSpace;
         return;
      }


      if(!box->Dim.Rx && !box->Dim.Ry) {
         size->Width=box->Dim.Px;
         size->Height=box->Dim.Py;
         return;
      }

      relx=box->Dim.SRx;
      rely=box->Dim.SRy;
      absx=box->Dim.SPx;
      absy=box->Dim.SPy;

      if(box->Dim.Kind==GG_HBOX) {

         rheight=absy;
         rwidth=0;

         for(p=box->Entry;*p;p++) {

            if((*p)->Dim.Rx || (*p)->Dim.Ry) GetMinSize(winfo,*p,&osize);

            if((*p)->Dim.Rx) {
               w=(osize.Width+(*p)->Dim.Rx-1)/(*p)->Dim.Rx*relx;
               rwidth=max(rwidth,w);
            }

            if((*p)->Dim.Ry) {
               h=(osize.Height+(*p)->Dim.Ry-1)/(*p)->Dim.Ry*rely;
               rheight=max(rheight,h);
            }
         }

         size->Width=rwidth+absx;
         size->Height=rheight;
      } else {

         rheight=0;
         rwidth=absx;

         for(p=box->Entry;*p;p++) {

            if((*p)->Dim.Rx || (*p)->Dim.Ry) GetMinSize(winfo,*p,&osize);

            if((*p)->Dim.Ry) {
               h=(osize.Height+(*p)->Dim.Ry-1)/(*p)->Dim.Ry*rely;
               rheight=max(rheight,h);
            }

            if((*p)->Dim.Rx) {
               w=(osize.Width+(*p)->Dim.Rx-1)/(*p)->Dim.Rx*relx;
               rwidth=max(rwidth,w);
            }
         }

         size->Width=rwidth;
         size->Height=rheight+absy;
      }

      if(box->Dim.Flags & (GG_FLAG_RAISED | GG_FLAG_RECESSED)) {

         size->Width+=2*box->Dim.XSpace;
         size->Height+=2*box->Dim.YSpace;
      }

      /* Explizit angegebene Werte überschreiben berechnete */

      if(box->Dim.MinCx|box->Dim.MinPx) size->Width=box->Dim.MinPx+box->Dim.XSpace;
      if(box->Dim.MinCy|box->Dim.MinPy) size->Height=box->Dim.MinPy+box->Dim.YSpace;

      size->Width+=(box->Dim.LeftCSpace+box->Dim.RightCSpace)*winfo->FontX
                   +box->Dim.LeftPSpace+box->Dim.RightPSpace;

      size->Height+=(box->Dim.TopCSpace+box->Dim.BottomCSpace)*winfo->FontY
                    +box->Dim.TopPSpace+box->Dim.BottomPSpace;

      if(!box->Dim.Rx) size->Width=box->Dim.Px;
      if(!box->Dim.Ry) size->Height=box->Dim.Py;
   }

   return;
}          /**/

void GG_MinSize(struct Window *win, struct WinInfo *winfo,struct GG_ObjectSize *size)
{
   int inited=0;
   struct Window *oldwin;

   oldwin=winfo->Window;

   if(winfo->Box->Dim.Flags & GG_FLAG_INITED) {
      inited=1;
      if(winfo->Window!=win) {
         DeInitGui(winfo,winfo->Box);
         winfo->Window=win;
         winfo->FontX = winfo->Window->RPort->Font->tf_XSize;
         winfo->FontY = winfo->Window->RPort->Font->tf_YSize;
         InitGui(winfo,winfo->Box);
      }
   } else {
      winfo->Window=win;
      winfo->FontX = winfo->Window->RPort->Font->tf_XSize;
      winfo->FontY = winfo->Window->RPort->Font->tf_YSize;
      InitGui(winfo,winfo->Box);
   }

   GetMinSize(winfo,winfo->Box,size);

   if(inited) {
      if(oldwin!=winfo->Window) {
         DeInitGui(winfo,winfo->Box);
         winfo->Window=oldwin;
         winfo->FontX = winfo->Window->RPort->Font->tf_XSize;
         winfo->FontY = winfo->Window->RPort->Font->tf_YSize;
         InitGui(winfo,winfo->Box);
      }
   } else {
      DeInitGui(winfo,winfo->Box);
   }
}
void GG_MinSizeFont(struct TextFont *font,struct WinInfo *winfo,struct GG_ObjectSize *size)
{
   struct Window win;
   struct RastPort rp;

   win.RPort=&rp;
   InitRastPort(&rp);

   SetFont(&rp,font);

   GG_MinSize(&win,winfo,size);
   return;
}

static struct TextAttr topaz={
   "topaz.font",TOPAZ_EIGHTY,FS_NORMAL,FPF_ROMFONT};

int GG_SmartRenderGui(struct Window *win, struct WinInfo *winfo,struct TextFont **font)
{
   struct GG_ObjectSize size;
   int left,top,width,height;
   ULONG idcmp;
   short changed;

   GG_MinSize(win,winfo,&size);

   size.Width+=win->BorderLeft+win->BorderRight;
   size.Height+=win->BorderTop+win->BorderBottom;

   if(size.Width>win->WScreen->Width || size.Height>win->WScreen->Height) {

      if(*font || (*font=OpenFont(&topaz))) {
         SetFont(win->RPort,*font);
      }

      GG_MinSize(win,winfo,&size);
      size.Width+=win->BorderLeft+win->BorderRight;
      size.Height+=win->BorderTop+win->BorderBottom;
   }

   if(size.Width>win->WScreen->Width) size.Width=win->WScreen->Width;
   if(size.Height>win->WScreen->Height) size.Height=win->WScreen->Height;


   Forbid();

   if(size.Width<=win->Width && size.Height<=win->Height) {

      /* Window is large enough, just set Windowlimits */

      WindowLimits(win,size.Width,size.Height,-1,-1);
      Permit();
      return GG_RenderGui(win,winfo);
   }

   Permit();


   /* Calculate the new window-dimensions */

   left=win->LeftEdge;
   top=win->TopEdge;
   width=win->Width;
   height=win->Height;

   if(size.Width>width) width=size.Width;
   if(size.Height>height) height=size.Height;
   if(left+width>win->WScreen->Width) left=win->WScreen->Width-width;
   if(top+height>win->WScreen->Height) top=win->WScreen->Height-height;

   idcmp=win->IDCMPFlags;
   if(!ModifyIDCMP(win,(idcmp|IDCMP_CHANGEWINDOW) & ~IDCMP_NEWSIZE))
            return 1; /* Could not Modify IDCMP */

   WindowLimits(win,0,0,-1,-1);
   ChangeWindowBox(win,left,top,width,height);

   changed=0;

   while(!changed) { /* Wait until the window has changed it dimensions, */
                     /* but keep all other Messages                      */

      struct IntuiMessage *msg,*succ;

      Wait(1<<win->UserPort->mp_SigBit);

      Forbid();

      for(msg=(struct IntuiMessage *) win->UserPort->mp_MsgList.lh_Head;
            (succ=(struct IntuiMessage *)msg->ExecMessage.mn_Node.ln_Succ)
               && !changed; msg=succ) {

         if(msg->IDCMPWindow==win && msg->Class==IDCMP_CHANGEWINDOW) {

            Remove((struct Node *)msg);
            ReplyMsg((struct Message *)msg);
            changed=1;
         }
      }

      Permit();
   }

   ModifyIDCMP(win,idcmp);
   WindowLimits(win,size.Width,size.Height,-1,-1);

   /* The next refresh is caused by IDCMP_CHANGEWINDOW. Since the
      GUI was not rendered yet, we may skip it */

   winfo->Box->Dim.Flags|=GG_FLAG_SKIPREFRESH;
   return GG_RenderGui(win,winfo);
}



