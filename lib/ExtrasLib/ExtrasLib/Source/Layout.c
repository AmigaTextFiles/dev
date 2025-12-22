#include <extras/math.h>
#include <clib/extras/layoutgt_protos.h>
#include <clib/extras_protos.h>

#include <exec/memory.h>

#include <extras/layoutgt.h>
#include <extras/gui.h>
#include <extras/ext_text.h>

#include <intuition/gadgetclass.h>

#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/diskfont.h>

#include <tagitemmacros.h>
#include <math.h>
#include <string.h>
#include <stdio.h>

ULONG KeyTag[]=
{
  0,  //GENERIC_KIND	0
  0,  //BUTTON_KIND	1
  GTCB_Checked,   //CHECKBOX_KIND	2
  GTIN_Number,    //INTEGER_KIND	3
  GTLV_Selected,  //LISTVIEW_KIND	4
  GTMX_Active,    //MX_KIND		5
  0,              //NUMBER_KIND	6
  GTCY_Active,    //CYCLE_KIND	7
  GTPA_Color,     //PALETTE_KIND	8
  GTSC_Top,       //SCROLLER_KIND	9
  0,              //10
  GTSL_Level,     //SLIDER_KIND	11
  0,              //STRING_KIND	12
  0               //TEXT_KIND	13
};

struct CAndGI
{
  struct LG_Control *Control;
  struct LG_GadgetIndex *GIndex;
};

struct LG_GadgetIndex *LG_GetGI(struct LG_Control *Con, ULONG GadID);
void lg_SetGadgetIndexAttrs(struct LG_GadgetIndex *GI, struct TagItem *TagList);
//WORD lg_FigureDim(struct LG_Control *Con, ULONG Code, struct IBox *Bounds,struct lg_DimInfo *Data);
BOOL LG_GetCAndGI(struct LG_Control *Con, ULONG GadID, struct CAndGI *CGI);

struct TextAttr lg_Topaz8=
{
  "topaz.font",
  8,0,0
};


void lg_FixTagList(struct LG_Control *Con, struct TagItem *TagList);


/****** extras.lib/OBSOLETE_LG_CreateGadgets ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       LG_CreateGadgets -- Create multiple Gadtools gadgets.
*
*   SYNOPSIS
*       gcontrol = LG_CreateGadgets(Tags)
*
*       struct LG_Control *LG_CreateGadgets(Tag Tags, ...);
*
*   FUNCTION
*       Creates multiple Gadtools, with some layout options.
*
*   INPUTS
*       Tags (see <extras/layougtgt.h>)
*
*         LG_LeftEdge, LG_XPos - Position of gadget
*         LG_TopEdge,  LG_YPos - Position of gadget
*             The position of the gadget will depend on these attributes
*             and the LG_Justification attribute.  Also see the relational
*             macros in <extras/layoutgt.h>
*         LG_Width  - Gadget width
*         LG_Height - Gadget height
*
*           for the following see the NewGadget structure in 
*           <libraries/gadtools.h>
*         LG_GadgetText
*         LG_TextAttr
*         LG_GadgetID
*         LG_Flags
*         LG_VisualInfo
*         LG_UserData
*         LG_GadgetKind
*         LG_GadgetTags
*         LG_GadgetTagList
*
*         LG_OffsetX - global offset from left of window
*         LG_OffsetY - global offset from top of window 
*            These two set to topleft of the domain.
*            Also these will be added to LG_UseScreenOffsets
*            or LG_UseWindowOffsets if set.
*
*         LG_LabelFlags - see LGLF_ 
*
*         LG_ScaleX - Multiply gadget width and position by these.
*                     (percent * 65536)
*         LG_ScaleY - Multiply gadget height and position by these.
*                     (percent * 65536)
*
*         LG_Justification - Sets the "handle" of the gadget.
*
*         LG_UseScreenOffsets - Sets global offsets based on Window border 
*                           dimensions specified in the Screen structure
*         LG_UseWindowOffsets - Sets global offsets based on Window border 
*                           dimensions
*
*         LG_EraseRemoved - If set gadgets erase themselves when they are 
*                           removed using LG_RemoveGadgets
*
*         LG_KeyClass  - Not used 
*         LG_KeyString - A string of characters that "activate" that 
*              gadget, if not specified, LG_CreateGadget() will scan 
*              the gadget label for the appropriate string.  This 
*              attribute is cleared after each LG_CreateGadget
*               attribute
*         LG_ErrorCode - Not used
*
*         LG_Bounds - set offsets or domain area for gadgets
*         LG_BoundsLeft   - Left of domain. (Alias for LG_OffsetX)
*         LG_BoundsTop    - Top of domain.  (Alias for LG_OffsetY)
*         LG_BoundsWidth  - Width of domain.
*         LG_BoundsHeight - Height of domain.
*
*         LG_RelHorizGap - Gap between certain relative operations
*         LG_RelVertGap  - Gap between certain relative operations
*
*         LG_HorizCells - Sets the number of columns in a table.
*         LG_VertCells - Sets the number of rows in a table. 
*           Sets the number of cells in a table.  The table's pixel size
*           is the current LG_Bound size.  These attributes work in 
*           conjunction with the LG_REL_CELL_ macros defined in 
*           <extras/layoutgt.h>
*           
*         LG_SkipGadgets - Skip the next ti_Data LG_CreateGadgets and 
*           all Tags in between.
*
*   RESULT
*       returns NULL on failure, or a pointer the LG_Control structure 
*       defined in <extras/layoutgt.h>
*
*   EXAMPLE
*       See the supplied example, if there are any.
*
*   NOTES
*       Gadgets created by LG_CreateGadgets() Must be freed using 
*       LG_FreeGadgets OR Removed from it's Window using 
*       LG_RemoveGadgets *BEFORE* the window is closed
*
*   BUGS
*
*   SEE ALSO
*       LG_FreeGadgets, LG_RemoveGadgets, LG_AddGadgets, LG_RemoveGadgets,
*
******************************************************************************
*
*/


struct LG_Control * LG_CreateGadgets(Tag Tags, ...)
{
  return(LG_CreateGadgetsA((struct TagItem *)&Tags));
}

struct LG_Control * LG_CreateGadgetsA(struct TagItem *TagList)
{
  BOOL lg_debug=0;
  struct Screen     *lg_usescreenoffsets;
  struct Window     *lg_usewindowoffsets;
  struct IBox       bounds={0,0,0,0};
  struct LG_Control *control;
  struct Gadget     *gad=0,*gctr,**cgptr;
  struct NewGadget  newgadget={0},
                    workgadget;
  struct TagItem    *ngtaglist=0,
                    *tag, 
                    *tstate;
  struct lg_DimInfo diminfo;
  ULONG   lg_justification=0;
  WORD    lg_swoffsetx=0,lg_swoffsety=0;
  float   lg_scalex=1,lg_scaley=1;
  ULONG   ngkind=0,
          data,
          lg_leftedge,lg_topedge,lg_width,lg_height,
          gadcount=0,
          fitlabel=0,
          ls_left, ls_right, ls_top, ls_bottom,  // Label Size
          js_left, js_right, js_top, js_bottom,
          js2_left, js2_right, js2_top, js2_bottom;  // Just. label Size
  LONG    *lg_getminwidth,
          *lg_getminheight;
//          *lg_addminwidth,
//          *lg_addminheight;
  struct TextFont *tf;
  WORD labelwidth, labelheight;
  ULONG gi_keyclass=0;
  STRPTR gi_keystring=0;
  UBYTE  gi_kstring[3];
  LONG *errorptr;
  
  memset(&diminfo,0,sizeof(diminfo));
  lg_topedge=lg_leftedge=lg_width=lg_height=0;

  if(control=AllocMem(sizeof(struct LG_Control),MEMF_CLEAR))
  {
    control->lgc_Next=0;
    if(errorptr=(LONG *)GetTagData(LG_ErrorCode,0,TagList))
      *errorptr=-1;
    
    
    ProcessTagList(TagList,tag,tstate)
    {
      switch(tag->ti_Tag)
      {
        case LG_SkipGadgets:
          {
            ULONG skip;
        
            skip=tag->ti_Data;
            while(skip>0)
            {
              if(!(tag=NextTagItem(&tstate)))
                skip=0;
              if(tag->ti_Tag==LG_CreateGadget)
                skip--;
            }
          }
          break;
        case LG_CreateGadget:
          gadcount++;
          break;
      }
    }
    if(control->lgc_GadgetIndex=AllocVec(gadcount * sizeof(struct LG_GadgetIndex),MEMF_CLEAR))
    {
      control->lgc_Left=control->lgc_Top=32767;
      control->lgc_Right=control->lgc_Bottom=0;
      gad=CreateContext(&control->lgc_GadgetList);
  
      ProcessTagList(TagList,tag,tstate)
      {
        data=tag->ti_Data;
        switch(tag->ti_Tag)
        {
          case LG_SkipGadgets:
            {
              ULONG skip;
          
              skip=tag->ti_Data;
              while(skip>0)
              {
                if(!(tag=NextTagItem(&tstate)))
                  skip=0;
                if(tag->ti_Tag==LG_CreateGadget)
                  skip--;
              }
            }
            break;
          case LG_DebugMode:
            lg_debug=data;
            break;
          case LG_NewGadget:
            newgadget=*((struct NewGadget *)data);
            lg_leftedge =newgadget.ng_LeftEdge;
            lg_topedge  =newgadget.ng_TopEdge;
            lg_width    =newgadget.ng_Width;
            lg_height   =newgadget.ng_Height;
            break;
          case LG_LeftEdge:
            lg_leftedge=data;
            break;
          case LG_TopEdge:
            lg_topedge=data;
            break;
          case LG_Width:
            lg_width=data;
            break;
          case LG_Height:
            lg_height=data;
            break;
          case LG_GadgetText:
            newgadget.ng_GadgetText=(UBYTE *)data;
            break;
          case LG_TextAttr:
            newgadget.ng_TextAttr=(struct TextAttr *)data;
            break;
          case LG_GadgetID:
            newgadget.ng_GadgetID=data;
            break;
          case LG_Flags:
            newgadget.ng_Flags=data;
            break;
          case LG_VisualInfo:
            newgadget.ng_VisualInfo = (void *)data;
            break;
          case LG_UserData:
            newgadget.ng_UserData=(void *)data;
            break;
          case LG_GadgetKind:
            ngkind=data;
            break;
          case LG_GadgetTagList:
            if(ngtaglist)  
              FreeTagItems(ngtaglist);
            if((!(ngtaglist=CloneTagItems((struct TagItem *)data))) && data )
              gad=0;
            else
              lg_FixTagList(control,ngtaglist);
              
            break;
          case LG_GadgetTags:
            if(ngtaglist)
              FreeTagItems(ngtaglist);
            if(ngtaglist=AllocateTagItems(data+1))
            {
              LONG tagcnt;
              
              for(tagcnt=0;(tagcnt<data) && (tag=NextTagItem(&tstate));tagcnt++)
              {
                ngtaglist[tagcnt].ti_Tag =tag->ti_Tag;
                ngtaglist[tagcnt].ti_Data=tag->ti_Data;
              }
              ngtaglist[data].ti_Tag=TAG_DONE;
              lg_FixTagList(control,ngtaglist);
            }
            else
              gad=0;  
            break;
          case LG_LabelFlags:
            fitlabel=data & LGLF_FITLABEL;
            break;
          case LG_OffsetX:
            bounds.Left=data;
            break;
          case LG_OffsetY:
            bounds.Top=data;
            break;
          case LG_BoundsWidth:
            bounds.Width=data;
            break;
          case LG_BoundsHeight:
            bounds.Height=data;
            break;
          case LG_Bounds:
            bounds=*((struct IBox *)data);
            break;
          case LG_ScaleX:
            lg_scalex=((float)data)/65535;
            break;
          case LG_ScaleY:
            lg_scaley=((float)data)/65535;
            break;
          case LG_Justification:
            lg_justification=data;
            break;
          case LG_UseScreenOffsets:
            if(lg_usescreenoffsets=(struct Screen *)data)
            {
              lg_swoffsetx=lg_usescreenoffsets->WBorLeft;
              lg_swoffsety=lg_usescreenoffsets->WBorTop + lg_usescreenoffsets->RastPort.TxHeight + 1;
            }
            else
              lg_swoffsetx=lg_swoffsety=0;
            break;
          case LG_UseWindowOffsets:
            if(lg_usewindowoffsets=(struct Window *)data)
            {
              lg_swoffsetx=lg_usewindowoffsets->BorderLeft;
              lg_swoffsety=lg_usewindowoffsets->BorderTop;
            }
            else
              lg_swoffsetx=lg_swoffsety=0;
            break;
            
          case LG_GetMinWidth:
            lg_getminwidth=(APTR)data;
            break;
          
          case LG_GetMinHeight:
            lg_getminheight=(APTR)data;
            break;
          
          case LG_AddMinWidth:
            lg_getminwidth=(APTR)data;
            break;
          
          case LG_AddMinHeight:
            lg_getminheight=(APTR)data;
            break;

          case LG_CreateGadget:
            cgptr=(struct Gadget **)data;
            workgadget=newgadget;
            
//            WORD lg_FigureDim(struct LG_Control *Con, ULONG Code, struct IBox *Bounds,struct lg_DimInfo *Data)
            
            workgadget.ng_LeftEdge  =LG_FigureLeftEdge  (control, lg_leftedge,  &bounds, &diminfo);
            workgadget.ng_TopEdge   =LG_FigureTopEdge   (control, lg_topedge,   &bounds, &diminfo);
            workgadget.ng_Width     =LG_FigureWidth     (control, lg_width,     &bounds, workgadget.ng_LeftEdge, &diminfo);
            workgadget.ng_Height    =LG_FigureHeight    (control, lg_height ,   &bounds, workgadget.ng_TopEdge,  &diminfo);

//            if(workgadget.ng_LeftEdge<0)
//              workgadget.ng_LeftEdge += bounds.Width;
            workgadget.ng_LeftEdge = (workgadget.ng_LeftEdge + bounds.Left) * lg_scalex + lg_swoffsetx;

//            if(workgadget.ng_TopEdge<0)
//              workgadget.ng_TopEdge += bounds.Height;
            workgadget.ng_TopEdge  = (workgadget.ng_TopEdge  + bounds.Top) * lg_scaley + lg_swoffsety;
            
//            if(workgadget.ng_Width<1)
//              workgadget.ng_Width += bounds.Width;
            workgadget.ng_Width  *= lg_scalex;
            
//            if(workgadget.ng_Height<1)
//              workgadget.ng_Height += bounds.Height;
            workgadget.ng_Height *= lg_scaley;

            ls_bottom= ls_top= ls_left= ls_right= 0;
            
            labelwidth=labelheight=0;
            
            if(workgadget.ng_GadgetText)
            {
              if(!(tf=OpenDiskFont(workgadget.ng_TextAttr)))
              {
                workgadget.ng_TextAttr=&lg_Topaz8;
                tf=OpenFont(workgadget.ng_TextAttr);
              }
              
              if(tf)
              {
                UBYTE us[2]={0};
                  
                us[0]=GetTagData(GT_Underscore,0,ngtaglist);
                
                labelwidth=gui_StrLength(SL_TextFont    ,tf,
                                     SL_String      ,workgadget.ng_GadgetText,
                                     SL_IgnoreChars ,us,
                                     TAG_DONE)+8;
//              printf("labelwidth=%d\n",labelwidth);
                labelheight=tf->tf_YSize+4;
                CloseFont(tf);
              }
            }
              
            switch(workgadget.ng_Flags & 0x1f)
            {
              case PLACETEXT_ABOVE:
                ls_top    =labelheight;
                break;
              case PLACETEXT_BELOW:
                ls_bottom =labelheight;
                break;
              case PLACETEXT_LEFT:
                ls_left   =labelwidth;
                break;
              case PLACETEXT_RIGHT:
                ls_right  =labelwidth;
                break;
            }
            
            if(fitlabel)
            {
              workgadget.ng_LeftEdge += ls_left;
              workgadget.ng_Width    -=(ls_left + ls_right); 
              workgadget.ng_TopEdge  += ls_top;
              workgadget.ng_Height   -=(ls_top + ls_bottom); 
            }
            
            if(lg_justification & LG_JUST_WITHLABEL)
            {
              js_left   =ls_left;
              js_right  =ls_right;
              js_top    =ls_top;
              js_bottom =ls_bottom;
            }
            else
              js_bottom= js_top= js_left= js_right= 0;
            
            if(fitlabel)
              js2_bottom= js2_top= js2_left= js2_right= 0;
            else
            {
              js2_left   =ls_left;
              js2_right  =ls_right;
              js2_top    =ls_top;
              js2_bottom =ls_bottom;
            }
            
            switch(lg_justification & LG_JUST_HORIZ_MASK)
            {
              case LG_JUST_LEFT:
                workgadget.ng_LeftEdge+=js_left;
                break;
              case LG_JUST_HCENTER: //                Total Width             /2- left 
                workgadget.ng_LeftEdge-=(workgadget.ng_Width+js_left+js_right)/2-js2_left;
                break;
              case LG_JUST_RIGHT:
                workgadget.ng_LeftEdge-=(workgadget.ng_Width+js_right);
                break;
            }
            
            switch(lg_justification & LG_JUST_VERT_MASK)
            {
              case LG_JUST_TOP:
                workgadget.ng_TopEdge+=js_top;
                break;
              case LG_JUST_VCENTER:
                workgadget.ng_TopEdge-=(workgadget.ng_Height+js_top+js_bottom)/2-js2_top;
                break;
              case LG_JUST_RIGHT:
                workgadget.ng_TopEdge-=(workgadget.ng_Height+js_bottom);
                break;
            }
            
            gad=CreateGadgetA(ngkind,gad,&workgadget,ngtaglist);

            if(lg_debug)
            {
              ULONG Array[2];
              
              Array[0]=(ULONG)gad;
              Array[1]=workgadget.ng_GadgetID;
              
              VPrintf((STRPTR)"gaddr=%8lx gid=%ld\n",Array);
            }
            
            if(errorptr)
            {
              if(gad==0 && *errorptr==-1)
                *errorptr=workgadget.ng_GadgetID;
            }
            
            if(cgptr) 
              *cgptr=gad;
              
            {
              struct LG_GadgetIndex *gi;
              
              gi=&control->lgc_GadgetIndex[control->lgc_IndexCount];
              lg_SetGadgetIndexAttrs(gi,ngtaglist);
              
              gi->gi_Gadget     =gad;
              gi->gi_ID         =newgadget.ng_GadgetID;
              gi->gi_GadKind    =ngkind;
              gi->gi_KeyTagID   =KeyTag[ngkind];
              gi->gi_KeyTagValue=GetTagData(KeyTag[ngkind],0,ngtaglist);
              gi->gi_KeyClass   =gi_keyclass;
              
              if(!gi_keystring)
              {
                if(newgadget.ng_GadgetText)
                {
                  char *keychar;
                  char scorechar;
                  
                  if(scorechar=GetTagData(GT_Underscore,0,ngtaglist))
                  {
                    if(keychar=strchr(newgadget.ng_GadgetText,scorechar))
                    {
                      keychar++;
                      gi_kstring[0]=key_Unshifted(*keychar);
                      gi_kstring[1]=key_Shifted(*keychar);
                      gi_kstring[2]=0;
                      gi_keystring=gi_kstring;
                    }
                  }
                }
              }
 
              gi->gi_KeyString  =CopyString(gi_keystring,MEMF_PUBLIC); 
              //printf("%s keystring=%s\n",newgadget.ng_GadgetText,gi->gi_KeyString);
              gi_keystring=0;
              
              /* determine area displaced by gadget */
              gi->gi_Rect.MinX=workgadget.ng_LeftEdge      - ls_left;
              gi->gi_Rect.MinY=workgadget.ng_TopEdge       - ls_top;
              gi->gi_Rect.MaxX=max(workgadget.ng_Width,0 ) + workgadget.ng_LeftEdge + ls_right;
              gi->gi_Rect.MaxY=max(workgadget.ng_Height,0) + workgadget.ng_TopEdge + ls_bottom;

              control->lgc_Left  =min(control->lgc_Left   ,gi->gi_Rect.MinX);
              control->lgc_Top   =min(control->lgc_Top    ,gi->gi_Rect.MinY);
              control->lgc_Right =max(control->lgc_Right  ,gi->gi_Rect.MaxX);
              control->lgc_Bottom=max(control->lgc_Bottom ,gi->gi_Rect.MaxY);

/*            
              control->lgc_Left  =min(control->lgc_Left  ,workgadget.ng_LeftEdge  - ls_left);
              control->lgc_Top   =min(control->lgc_Top   ,workgadget.ng_TopEdge   - ls_top);
              control->lgc_Right =max(control->lgc_Right ,workgadget.ng_Width + workgadget.ng_LeftEdge + ls_right);
              control->lgc_Bottom=max(control->lgc_Bottom,workgadget.ng_Height+ workgadget.ng_TopEdge + ls_bottom);
*/
              control->lgc_IndexCount++;
              newgadget.ng_GadgetID++;
            }
            break;

          case LG_EraseRemoved:
            if(data)
              control->lgc_Flags|=LGCF_ERASEREMOVED;
            else
              control->lgc_Flags&=(~LGCF_ERASEREMOVED);
             break;

          case LG_KeyClass:
            gi_keyclass=data;
            break;

          case LG_KeyString:
            gi_keystring=(STRPTR)data;
            break;
          case LG_RelHorizGap:
            diminfo.GapHoriz=data;
            break;
          case LG_RelVertGap:
            diminfo.GapVert=data;
            break;  
          case LG_HorizCells:
            diminfo.CellsHoriz=data;
            break;
          case LG_VertCells:
            diminfo.CellsVert=data;
            break;          
        } /* endswitch */
      }
      FreeTagItems(ngtaglist);
      control->lgc_Right =max(control->lgc_Right ,control->lgc_Left);
      control->lgc_Bottom=max(control->lgc_Bottom,control->lgc_Top);
      gctr=control->lgc_GadgetList;
      while(gctr)
      {
        control->lgc_GadgetCount++;
        gctr=gctr->NextGadget;
      }
    }
  }
  if(!gad)
  {
    LG_FreeGadgets(control);
    control=0;
  }
  return(control);
}

/****** extras.lib/OBSOLETE_LG_FreeGadgets ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       LG_FreeGadgets - free gadgets allocated be LG_CreateGadgets.
*
*   SYNOPSIS
*       LG_FeeeGadgets(Control)
*
*       void LG_FreeGadgets(struct LG_Control);
*
*   FUNCTION
*       deallocates gadgets ans support structures allocated by 
*        LG_CreateGadget
*
*   INPUTS
*       Con - pointer to structure returned by LG_CreateGadgets.
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*       Gadgets created by LG_CreateGadgets() Must be freed using 
*       LG_FreeGadgets OR Removed from it's Window using 
*       LG_RemoveGadgets *BEFORE* the window is closed
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


void LG_FreeGadgets(struct LG_Control *Con)
{
  struct LG_Control *next;
  ULONG l;
  
  while(Con)
  {
    next=Con->lgc_Next;
    
    LG_RemoveGadgets(Con);
    
    for(l=0;l<Con->lgc_IndexCount;l++)
    {
      //printf("freeing %s %x\n",Con->lgc_GadgetIndex[l].gi_Gadget->GadgetText->IText,Con->lgc_GadgetIndex[l].gi_KeyString);
      FreeVec(Con->lgc_GadgetIndex[l].gi_KeyString);
    }
    
    FreeGadgets(Con->lgc_GadgetList);
    FreeVec(Con->lgc_GadgetIndex);
    FreeMem(Con,sizeof(struct LG_Control));

    Con=next;
  }
}

/****** extras.lib/OBSOLETE_LG_AddGadgets ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       LG_AddGadgets - Add gadgets to a window.
*
*   SYNOPSIS
*
*
*
*
*
*
*   FUNCTION
*
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


void LG_AddGadgets(struct Window *Win, struct LG_Control *Con)
{
  if(Con)
  {  
    LG_RemoveGadgets(Con);  //Make sure there not already on another window.

    if(Con->lgc_GadgetList && Win) // If there's no gadgets, don't add em
      if(Con->lgc_Window=Win)
      {
        AddGList(Win,Con->lgc_GadgetList,-1,Con->lgc_GadgetCount,0);
        RefreshGList(Con->lgc_GadgetList,Win,0,Con->lgc_GadgetCount);
        GT_RefreshWindow(Win,0);
      }
  }
}

/****** extras.lib/OBSOLETE_LG_RemoveGadgets ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       LG_RemoveGadgets - remove gadgets from a window.
*
*   SYNOPSIS
*
*
*
*
*
*
*   FUNCTION
*
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


void LG_RemoveGadgets(struct LG_Control *Con)
{
  struct Window *win;
  struct RastPort *rp;
  struct Gadget *g;
  struct LG_GadgetIndex *gi;
  ULONG l;
  WORD x1,y1,x2,y2;
  //WORD maxx,maxy,minx,miny;
  //BOOL isntgzz;

  if(Con)
  {  
    win=Con->lgc_Window;
    if(win)
    {
      if(Con->lgc_GadgetList)
      {
        rp=Con->lgc_Window->RPort;
        RemoveGList(win, Con->lgc_GadgetList, Con->lgc_GadgetCount);
  
        g=Con->lgc_GadgetList;
        
        for(l=1;l<Con->lgc_GadgetCount;l++)
          g=g->NextGadget;
        
        if(g)
          g->NextGadget=0;
        
        gi=Con->lgc_GadgetIndex;
        
        //isntgzz=!(win->Flags & WFLG_GIMMEZEROZERO);
        
        /*
        maxx=win->Width-win->BorderRight;
        minx=win->BorderLeft;
        maxy=win->Height-win->BorderBottom;
        miny=win->BorderTop;
        */
        
        if(Con->lgc_Flags & LGCF_ERASEREMOVED)
        {
          for(l=0;l<Con->lgc_IndexCount;l++)
          {
            x1=gi->gi_Rect.MinX;
            y1=gi->gi_Rect.MinY;
            x2=gi->gi_Rect.MaxX;
            y2=gi->gi_Rect.MaxY;
         
            EraseRect(rp, x1, y1, x2, y2);
            gi++;
          }  
        }
      }
      Con->lgc_Window=0;
    }
  }
}

struct LG_GadgetIndex *LG_GetGI(struct LG_Control *Con, ULONG GadID)
{
  ULONG l;

  while(Con)
  {
    if(Con->lgc_GadgetIndex)
    {
      for(l=0; l<Con->lgc_IndexCount; l++)
      {
        if(GadID==Con->lgc_GadgetIndex[l].gi_ID)
        {
          return(&Con->lgc_GadgetIndex[l]);
        }
      }
    }
    Con=Con->lgc_Next;
  }
  return(0);
}

BOOL LG_GetCAndGI(struct LG_Control *Con, ULONG GadID, struct CAndGI *CGI)
{
  ULONG l;

  while(Con)
  {
    if(Con->lgc_GadgetIndex)
    {
      for(l=0; l<Con->lgc_IndexCount; l++)
      {
        if(GadID==Con->lgc_GadgetIndex[l].gi_ID)
        {
          CGI->Control=Con;
          CGI->GIndex=&Con->lgc_GadgetIndex[l];
          return(1);
        }
      }
    }
    Con=Con->lgc_Next;
  }
  return(0);
}


/****** extras.lib/OBSOLETE_LG_GetGadget ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       LG_GetGadget - get a gadget pointer using Gadget ID.
*
*   SYNOPSIS
*
*
*
*
*
*
*   FUNCTION
*
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


struct Gadget *LG_GetGadget(struct LG_Control *Con, ULONG GadID)
{
  struct LG_GadgetIndex *gi;

  if(gi=LG_GetGI(Con,GadID))
    return(gi->gi_Gadget);
  return(0);
}

/*
struct Gadget *LG_FindGadget(ULONG GadID, ULONG ConCount, struct LG_Control **Con, ... )
{
  struct Gadget *retval=0;
  ULONG ct,l;
  BOOL go=TRUE;

  if(Con)
  {
    for(ct=0;ct<ConCount && go;ct++)
    {
      if(Con[ct])
      {
        if(Con[ct]->lgc_GadgetIndex)
        {
          for(l=0; l<Con[ct]->lgc_IndexCount && go; l++)
          {
            if(GadID==Con[ct]->lgc_GadgetIndex[l].gi_ID)
            {
              retval=Con[ct]->lgc_GadgetIndex[l].gi_Gadget;
              go=FALSE;
            }
          }
        }
      }
    }
  }
  return(retval);
}
*/

/****** extras.lib/OBSOLETE_LG_SetGadgetAttrs ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       LG_SetGadgetAttrs - set gadget attrs.
*
*   SYNOPSIS
*
*
*
*
*
*
*   FUNCTION
*
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/



BOOL LG_SetGadgetAttrs(struct LG_Control *Con, ULONG GadID, Tag Tags, ...)
{
  BOOL rv=FALSE;
  struct CAndGI cgi;
  
  if(LG_GetCAndGI(Con,GadID,&cgi))
  {
    if(GadToolsBase->lib_Version>=39 || cgi.Control->lgc_Window)
    {
      rv=TRUE;
      GT_SetGadgetAttrsA(cgi.GIndex->gi_Gadget,cgi.Control->lgc_Window,0,(struct TagItem *)&Tags);
      lg_SetGadgetIndexAttrs(cgi.GIndex,(struct TagItem *)&Tags);
    }
  }
  return(rv);
}

/****** extras.lib/OBSOLETE_LG_GetGadgetAttrs ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       LG_GetGadgetAttrs
*
*   SYNOPSIS
*
*
*
*
*
*
*   FUNCTION
*
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


ULONG LG_GetGadgetAttrs(struct LG_Control *Con, ULONG GadID, Tag Tags, ...)
{
  ULONG rv=0;
  struct CAndGI cgi;
  
  if(GadToolsBase->lib_Version>=39)
  {
    if(LG_GetCAndGI(Con,GadID,&cgi))
    {
      rv=GT_GetGadgetAttrsA(cgi.GIndex->gi_Gadget,cgi.Control->lgc_Window,0,(struct TagItem *)&Tags);
    }
  }
  return(rv);
}

/*
struct IntuiMessage *LG_GetIMsg(struct LG_Control *Con, struct MsgPort *IntuiPort)
{
  struct IntuiMessage *imsg=0,*newimsg;
  ULONG l,icode,iclass;

  if(IntuiPort)
  {
    if(imsg=GT_GetIMsg(IntuiPort))
    {
      if(Con)
      {
        icode =imsg->Code;
        iclass=imsg->Class;
        switch(imsg->Class)
        {
          case IDCMP_RAWKEY:
          case IDCMP_VANILLAKEY:
            for(l=0;l<Con->lgc_IndexCount;l++)
            {
              if(Con->lgc_GadgetIndex[l].KeyClass==imsg->iclass)
              {
                if(Con->lgc_GadgetIndex[l].KeyUp   == icode)
                {
                  newimsg=CopyIMsg(imsg);         
                  newimsg->Class=IDCMP_GADGETUP;
                  newimsg->Code=1;
                  newimsg->
                }
                if(Con->lgc_GadgetIndex[l].KeyDown == icode)
              }
            } 
        }
      }
    }
  }
  return(imsg);
}
  
struct IntuiMessage *CopyIMsg(struct IntuiMessage *IMsg)
{
  struct IntuiMessage *i;
  
  if(i=AllocVec(sizeof(struct IntuiMessage),MEMF_PUBLIC))
  {
    *i=*IMsg;
  }

  return(i);
}
}*/

void lg_FixTagList(struct LG_Control *Con, struct TagItem *TagList)
{
  ULONG data;
  struct TagItem    *tag, 
                    *tstate;
  ProcessTagList(TagList,tag,tstate)
  {
    data=tag->ti_Data;
    switch(tag->ti_Tag)
    {
      case GTLV_ShowSelected:
        if(data)
        {
          tag->ti_Data=(ULONG)LG_GetGadget(Con,data);
        }
        break;
   }
  }
}

//ULONG LG_GadIDFromIE()

BOOL LG_GadForKey(struct LG_Control *Con, UBYTE Key, ULONG *GadID, ULONG *Code)
{
  char *c;
  ULONG l;

  if(Con)
  {
    if(Con->lgc_GadgetIndex)
    {
      for(l=0; l<Con->lgc_IndexCount; l++)
      {
        if(Con->lgc_GadgetIndex[l].gi_KeyString && Con->lgc_GadgetIndex[l].gi_Disabled==0)
        {
          if(c=strchr(Con->lgc_GadgetIndex[l].gi_KeyString,Key))
          {
            *Code=((ULONG)c)-((ULONG)Con->lgc_GadgetIndex[l].gi_KeyString);
            *GadID=Con->lgc_GadgetIndex[l].gi_Gadget->GadgetID;
            return(1);
          }
        }
      }
    }
  }
  return(0);
}

void lg_SetGadgetIndexAttrs(struct LG_GadgetIndex *GI, struct TagItem *TagList)
{
  GI->gi_Disabled=GetTagData(GA_Disabled, GI->gi_Disabled, TagList);
}

void LG_AddLGControl(struct LG_Control *Parent, struct LG_Control *Child)
{
  if(Child && Parent)
  {
    Child->lgc_Next=Parent->lgc_Next;
    Parent->lgc_Next=Child;
  }
}

BOOL LG_RemoveLGControl(struct LG_Control *Parent, struct LG_Control *Child)
{
  struct LG_Control *work;
  
  if(Child && Parent)
  {
    work=Parent;
    if(work->lgc_Next==Child)
    {
      work->lgc_Next=Child->lgc_Next;
      return(1);
    }
  }
  return(0);
}

/*
union Decode
{
  ULONG Long;
  struct
  {
    BYTE Type, Code;
    WORD Word;
  } Decode;
};

WORD lg_FigureDim(struct LG_Control *Con, ULONG Code, struct IBox *Bounds,struct lg_DimInfo *Data)
{
  struct LG_GadgetIndex *gi;
  union Decode command;
  WORD word,w,h,retval;
  BYTE code;

  command.Long=Code;
  word=command.Decode.Word;
  code=command.Decode.Code;
  
  retval=word;
  
//  le =Bounds->Left;
//  te =Bounds->Top;
  w  =Bounds->Width;
  h  =Bounds->Height ;
  
  switch(command.Type)
  {
    case 1:
      switch(command.Decode.Code)
      {
        case 0: // LG_REL_RIGHT
          retval=(w + word);
          break;
        case 1: // LG_REL_WIDTH
          retval=(w + word);    
          break;
        case 2: // LG_REL_BOTTOM
          retval=(h + word);
          break;
        case 3: // LG_REL_HEIGHT
          retval=(h + word);    
          break;
        case 4: // LG_REL_CELL_LEFTEDGE
          if(Data->CellsHoriz)
            retval=((word * Bounds->Width + Data->GapHoriz)/Data->CellsHoriz);
          break;         
        case 5: // LG_RELCELL_TOPEDGE
          if(Data->CellsVert)
            retval=((word * Bounds->Height+ Data->GapVert)/Data->CellsVert);
          break;
        case 6: // LG_REL_CELL_WIDTH
          if(Data->CellsHoriz)
            retval=((word * (Bounds->Width + Data->GapHoriz))/Data->CellsHoriz - Data->GapHoriz);
          else
            retval=(Bounds->Width);
          break;          
        case 7: // LG_REL_CELL_HEIGHT
          if(Data->CellsVert)
            retval=((word * (Bounds->Height + Data->GapVert))/Data->CellsVert - Data->GapVert);
          else
            retval=(Bounds->Width);
          break;          
      }
      break;
    case 2: // LG_REL_LEFTOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MinX+code);
      }
      break;
    case 3: // LG_REL_TOPOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MinY+code);
      }
      break;
    case 4: // LG_REL_WIDTHOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxX-gi->gi_Rect.MinX+code);
      }
      break;      
    case 5: // LG_REL_HEIGHTOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxY-gi->gi_Rect.MinY+code);
      }
      break;      
    case 6: // LG_REL_RIGHTOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxX+code);
      }
      break;      
    case 7: // LG_REL_BOTTOMOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxY+code);
      }
      break;      
  }
  return(retval);
}





*/
