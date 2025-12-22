#define __USE_SYSBASE
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/commodities.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/diskfont.h>
#include <intuition/intuitionbase.h>
#include <intuition/gadgetclass.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <extras/gui.h>
#include <extras/ext_text.h>
#include <clib/extras_protos.h>

/****** extras.lib/OBSOLETE_MakeGadgets ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       MakeGadgets -- Minimal layout Gadtools gadgets.
*
*   SYNOPSIS
*       Gadget = MakeGedgets(Scr, VisualInfo, NumGadgets, NewGads, 
*               NewGadTags, NewGadKinds, Gadgets, TextAttr, XScale,
*               YScale)
*
*       struct Gadget * MakeGadgets(struct Screen *,APTR ,ULONG,
*               struct NewGadgets *, ULONG *, ULONG *,
*               struct Gadget **, struct TextAttr *, float, float);
*
*   FUNCTION
*       This function will create Gadgets from an array of
*       Gadtools NewGadgets, scaling the gadgets to the size
*       specified.
*
*   INPUTS
*       Scr - This is the screen that the window containing these
*                gadgets are destine for.  This is only used to get
*                the WBorX values used to offset the gadgets from
*                the window border.  *Set this to NULL if the gadgets
*                are destine for a GimmeZeroZero window*.
*       VisualInfo - VisualInfo pointer from gadtools/GetVisualInfo().
*       NumGadgets - the number of gadgets to process.
*       NewGads - array of struct NewGadget.
*       NewGadTags - array of ULONGS to be processed as TagItems.
*             All the gadget's tags are in this single array.
*             (In the same fashion as GadToolsBox) 
*             Individual tag arrays are NULL(TAG_DONE) terminated,
*             And you may use TAG_MORE for additional Tags per gadget,
*             but the array still must be NULL terminated.
*       NewGadKinds - array of ULONGs, (BUTTON_KIND etc.)
*       Gadgets - (struct Gadget **) Pointer to an array of
*             Gadget pointers.  The Gadgets created by this
*             function can be referenced by the ng_GadgetID of
*             the source NewGadget.
*       TextAttr - (struct TextAttr *) This TextAttr to used for
*             gadgets whose ng_TextAttr is NULL.
*       XScale - the x factor to scale the gadgets.
*       YScale - the y factor to scale the gadgets.
*             
*   RESULT
*       returns a pointer to the context from CreateContext()
*       or NULL on failure.
*
*   EXAMPLE
*
*   NOTES
*       requires diskfont, gadtools & utility libraries to
*       be open.
*
*       This function has a special flag for NewGadget->ng_Flags,
*       NG_FITLABEL.  This flag tells the function to adjust the
*       ng_LeftEdge and/or Width if the PLACETEXT_LEFT or RIGHT
*       flags are set, and the ng_TopEdge and/or Height if the
*       PLACETEXT_ABOVE or BELOW flags are set, so that the 
*       ng_GadgetText will fit inside the area specified for the
*       gadget.  You must also specify one of the PLACETEXT_?
*       values or this will not work.
*
*       For GimmeZeroZero windows set Scr to NULL.
*       
*       This function will not modify any of the arrays 
*       (ie. NewGads, NewGadTags), this way if you have
*       an interface that opens & closes multiple times
*       (like commodities) you will not have to reinitialize
*       the arrays.
*
*       Every ng_GadgetID should be unique and none may have a
*       larger value than the number of elements in the array
*       pointed to by Gadgets.
*
*       GTLV_ShowSelected works differently with this function.
*       specify -1l for the display only gadget, specify the 
*       gadget _id_ of the string gadget for the editable gadget
*       (the string gadget must be created before the listview).
*       Gadtools wants a NULL or poiner to a gadget for this value
*       but this is taken care by this function. 
*
*       Gadgets created by this function can be freed with a 
*       call to FreeGadgets().
*
*   BUGS
*
*   SEE ALSO
*       GetGUIScale()
******************************************************************************
*
*/

struct Gadget *MakeGadgets(struct Screen    *Scr,
                           APTR             VisualInfo,
                           ULONG            NumGadgets,
                           struct NewGadget *NewGads,
                           ULONG            *NewGadTags,
                           ULONG            *NewGadKinds,
                           struct Gadget    **Gadgets,
                           struct TextAttr  *TA,
                           float            XMult,
                           float            YMult)
{
  UBYTE underscore[2];
  ULONG  l,tgn;
  struct TextFont *tf;
  struct NewGadget ng;
  struct Gadget *check,*gad,*gfirst=NULL;
  struct TagItem *ti,*ts,*worktags;
  WORD   wx,wy,labelwidth,labelheight;
//  WORD   totwidth,totheight;

  if(Scr)
  {
    wx=Scr->WBorLeft;
    wy=Scr->WBorTop + Scr->RastPort.TxHeight + 1;
  }
  else
    wx=wy=0;
    
             
  if(tf=OpenDiskFont(TA))
  {
    if(gad=CreateContext(&gfirst))
    {    
      ng.ng_TextAttr   = TA;
      ng.ng_VisualInfo = VisualInfo;
      tgn=0;
      for(l=0;l<NumGadgets;l++)
      {
        ng.ng_LeftEdge  =NewGads[l].ng_LeftEdge * XMult + wx;
        ng.ng_TopEdge   =NewGads[l].ng_TopEdge  * YMult + wy;
        ng.ng_Width     =NewGads[l].ng_Width    * XMult;
        ng.ng_Height    =NewGads[l].ng_Height   * YMult;
        ng.ng_GadgetText=NewGads[l].ng_GadgetText;
        ng.ng_GadgetID  =NewGads[l].ng_GadgetID;
        ng.ng_Flags     =NewGads[l].ng_Flags & 0x7fffffff;
        ng.ng_UserData  =NewGads[l].ng_UserData;
        if(NewGads[l].ng_TextAttr)
          ng.ng_TextAttr=NewGads[l].ng_TextAttr;
        else
          ng.ng_TextAttr=TA;
          
//        totwidth    =ng.ng_Width;
//        totheight   =ng.ng_Height;
        
        labelwidth=gui_StrFontLen(tf,ng.ng_GadgetText)+8;
        labelheight=tf->tf_YSize;

        underscore[0]=GetTagData(GT_Underscore,0,(struct TagItem *)NewGadTags);
        underscore[1]=0;

        if(underscore[0] && ng.ng_GadgetText)
          if(strchr(ng.ng_GadgetText,underscore[0]))
            labelwidth-=gui_StrFontLen(tf,underscore);
/*
        // Justtification 
        if(ng.ng_Flags & NG_JUST_RIGHT)
          ng.ng_LeftEdge -=ng.ng_Width + (ng.ng_Flags & NG_JUST_LABEL && ng.ng_Flags & (PLACETEXT_RIGHT|PLACETEXT_IN) ? labelwidth:0) ;
        else
          if(ng.ng_Flags & NG_JUST_HORIZCENTER)
            ng.ng_LeftEdge-=(ng.ng_Width + (ng.ng_Flags & NG_JUST_LABEL && ng.ng_Flags & (PLACETEXT_RIGHT|PLACETEXT_LEFT) ? labelwidth:0))/2;
          else // NG_JUST_LEFT
            ng.ng_LeftEdge +=(ng.ng_Flags & NG_JUST_LABEL && ng.ng_Flags & PLACETEXT_LEFT ? labelwidth:0);
*/
        /*
        
        // verticle 
        if(ng.ng_Flags & NG_JUST_BOTTOM)
          ng.ng_TopEdge-=ng.ng_Height+labelheight;
        else
          if(ng.ng_Flags & NG_JUST_VERTCENTER)
            ng.ng_TopEdge-=(ng.ng_Height+labelheight)/2;
          else
            ng.ng_TopEdge+=labelheight;
        */


        
        if(ng.ng_Flags & NG_FITLABEL)
        {
          if(ng.ng_Flags & PLACETEXT_ABOVE)
          {
            ng.ng_TopEdge+=labelheight;
            ng.ng_Height -=labelheight;
          }
          else
            if(ng.ng_Flags & PLACETEXT_BELOW)
            {
              ng.ng_Height -=labelheight;
            }
            else
            {

              if(ng.ng_Flags & PLACETEXT_LEFT)
              {
                ng.ng_LeftEdge+=labelwidth;
                ng.ng_Width   -=labelwidth;
              }
              else
                if(ng.ng_Flags & PLACETEXT_RIGHT)
                {
                  ng.ng_Width -=labelwidth;
                }
                else
                {
                  if(ng.ng_Flags & PLACETEXT_IN)
                  {
                    ng.ng_Width +=labelwidth;
                    //owidth=ng.ng_Width;
                  }
                }
            }
        }
        else

        ng.ng_Flags&=NG_REAL_GT_FLAGS;
        
        check=0;
  
        if(worktags=CloneTagItems((struct TagItem *)&NewGadTags[tgn]))
        {
          ts=worktags;
  
          switch(NewGadKinds[l])
          {
            //case BUTTON_KIND:      
            //case CHECKBOX_KIND:
            //case CYCLE_KIND:
            //case INTEGER_KIND:
            case LISTVIEW_KIND:
              while(ti=NextTagItem(&ts))
                switch(ti->ti_Tag)
                {
                  case GTLV_ShowSelected:
                    if(ti->ti_Data!=~0)
                      ti->ti_Data=(ULONG)Gadgets[ti->ti_Data];
                    else
                      ti->ti_Data=0;
                    break;
                  case GTLV_ScrollWidth:
                    ti->ti_Data*=XMult;
                    break;
                  case GTLV_ItemHeight:
                    ti->ti_Data*=YMult;
                    break;
                }
              break;
            case MX_KIND:
              while(ti=NextTagItem(&ts))
                switch(ti->ti_Tag)
                {
                  case GTMX_Spacing:
                  case LAYOUTA_Spacing:
                    ti->ti_Data*=YMult;
                    break;
                }
              break;
            case PALETTE_KIND:
              while(ti=NextTagItem(&ts))
                switch(ti->ti_Tag)
                {
                  case GTPA_IndicatorWidth:
                    ti->ti_Data*=XMult;
                    break;
                  case GTPA_IndicatorHeight:
                    ti->ti_Data*=YMult;
                    break;
                }
              break;
            case SCROLLER_KIND:
              if(ti=FindTagItem(GTSC_Arrows ,worktags))
                switch(GetTagData(PGA_Freedom,LORIENT_HORIZ,worktags))
                {
                  case LORIENT_HORIZ:
                    ti->ti_Data*=XMult;
                    break;
                  case LORIENT_VERT:
                    ti->ti_Data*=YMult;
                    break;
                }
              break;
            case SLIDER_KIND:
              if(ti=FindTagItem(GTSL_MaxPixelLen ,worktags))
                ti->ti_Data*=XMult;
              break;
          }
          check=Gadgets[ng.ng_GadgetID]=gad=CreateGadgetA(NewGadKinds[l],gad,&ng,worktags);
    
          FreeTagItems(worktags);
        }     
        if(!check)
        {
          FreeGadgets(gfirst);
          CloseFont(tf);
          return(NULL);
        }
        while(NewGadTags[tgn]) tgn+=2;
          tgn++;
      }
    }  
    CloseFont(tf);
  }
  return(gfirst);                 
}




/*
struct Gadget *MakeSimpleGadgets(struct Screen    *Scr,
                                 struct NewGadget *NewGads,
                                 ULONG            *NewGadTags,
                                 ULONG            *NewGadTypes,
                                 struct Gadget   **Gadgets)
{
  int     l,tgn;
  struct  NewGadget ng;
  struct  Gadget *gad,*gfirst=NULL;
  struct  TagItem *ti;
  ULONG   OldTagValue;
  BOOL    ResetTag;
  WORD    wx,wy;
  
  wx=Scr->WBorLeft;
  wy=Scr->WBorTop + Scr->RastPort.TxHeight + 1;
               
  if(gad=CreateContext(&gfirst))
  {    
    ng.ng_VisualInfo = VisualInfo;
    tgn=0;
    for(l=0;l<GADGETS;l++)
    {
      ng.ng_LeftEdge  =NewGads[l].ng_LeftEdge+wx;
      ng.ng_TopEdge   =NewGads[l].ng_TopEdge+wy;
      ng.ng_Width     =NewGads[l].ng_Width;
      ng.ng_Height    =NewGads[l].ng_Height;
      ng.ng_GadgetText=NewGads[l].ng_GadgetText;
      ng.ng_GadgetID  =NewGads[l].ng_GadgetID;
      ng.ng_Flags     =NewGads[l].ng_Flags;

      ResetTag=FALSE;

      if(ng.ng_GadgetID==GD_LIST)
      {
        if(ti=FindTagItem(GTLV_ShowSelected,(struct TagItem *)&NewGadTags[tgn]))
        {
          ResetTag=TRUE;
          OldTagValue=ti->ti_Data;
          ti->ti_Data=(ULONG)Gadgets[GD_NAME];
        }
      }
      
      Gadgets[ng.ng_GadgetID] = 
          gad = CreateGadgetA(NewGadTypes[l],gad,&ng,(struct TagItem *)&NewGadTags[tgn]);
      
      if(ResetTag)
        if(ti=FindTagItem(GTLV_ShowSelected,(struct TagItem *)&NewGadTags[tgn]))
          ti->ti_Data=OldTagValue;
      
      if(!gad)
      {
        FreeGadgets(gfirst);
        return(NULL);
      }
      while(NewGadTags[tgn]) tgn+=2;
        tgn++;
    }
  }  
  return(gfirst);                 
}
*/
