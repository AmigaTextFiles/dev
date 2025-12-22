#include <extras/math.h>
#include "pm.h"
//#include <extras/progressmeter.h>
#include <clib/extras_protos.h>
#include <exec/memory.h>
#include <graphics/rastport.h>
#include <graphics/rpattr.h>
#include <libraries/gadtools.h>
#include <utility/tagitem.h>

#include <proto/diskfont.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>


#include <math.h>
#include <string.h>
#include <stdio.h>

#define CANCEL_ID 0

/* privete protos */
void RenderBar(ProgressMeter PM);
void MyText(struct RastPort *RP, STRPTR Str, UBYTE Pen, WORD X, WORD Y);
void RefreshPM(ProgressMeter PM);

STRPTR def_low   =(UBYTE *)"0%",
       def_high  =(UBYTE *)"100%",
       def_cancel=(UBYTE *)"Cancel",
       def_meter =(UBYTE *)"%ld%%";

struct TextAttr Topaz8=
{
  "topaz.font", 8,0,0
};

/****** extras.lib/AllocProgressMeterA ******************************************
*
*   NAME
*       AllocProgressMeterA -- Allocate and initialize a progressmeter.
*       AllocProgressMeter -- varargs stub for AllocProgressMeterA().
*
*   SYNOPSIS
*       meter = AllocProgressMeterA(TagList)
*
*       ProgressMeter AllocProgressMeterA( struct TagItem *);
*
*       meter = AllocProgressMeterA(Tag, ... )
*
*       ProgressMeter AllocProgressMeterA( Tag, ...);
*
*   FUNCTION
*       This function allocates and initializes a ProgressMeter.
*
*   INPUTS
*       TagList - 
*         One of the following two are required.
*         PM_Screen - The screen to place the meter on.
*                     (struct Screen *)
*         PM_ParentWindow - The parent window of the meter.
*                           (struct Window *)
*                           
*         PM_MsgPort    - Already existing msgport to send the meter's
*                         window events through. (Not implemented)
*
*         PM_TextAttr   - Font to use in the meter. defaults to the
*                         screen font. (struct TextAttr *)
*
*         PM_LeftEdge   - Defaults to be centered on PM_ParentWindow
*         PM_TopEdge    - or PMScreen.
*         PM_MinWidth   - Set the minimum width of the meter's
*                         window.
*         PM_MinHeight  - Set the minimum height of the meter's
*                         window (Not implemented).
*
*         PM_WinTitle   - Meter's Window title. (STRPTR) 
*
*         PM_LowText    - default "0%"   (STRPTR)  
*         PM_HighText   - default "100%" (STRPTR)
*
*         PM_MeterFormat - A printf style format string used inside the meter.
*                          default "%ld%%". (STRPTR) 
*         PM_MeterType   - How PM_MeterFormat is used, 
*                            PM_TYPE_PERCENTAGE - uses the percentage of
*                              where PM_MeterValue is between PM_LowValue and
*                              PM_HighValue for the argument of 
*                              PM_MeterFormat.
*                            PM_TYPE_NUMBER - Uses the meter's value for the 
*                              argument of PM_MeterFormat.
*                            PM_TYPE_STRING - Doens't process the meter's 
*                              value simply displays the text from 
*                              PM_MeterFormat
*         PM_MeterLabel    - The label above the meter.  default NULL 
*         PM_MinMeterWidth - The minimum meter bar width, the default minimum
*                            is 80
*
*         PM_MeterPen      - default fillpen 
*         PM_MeterBgPen    - default backgroundpen 
*         PM_FormatPen     - default highlight text 
*         PM_MeterLabelPen - default highlight text 
*         PM_LowTextPen    - default text pen 
*         PM_HighTextPen   - default text pen 
*
*         PM_MeterValue    - (IS) default   0 (LONG) 
*         PM_LowValue      - (IS) default   0 (LONG)  
*         PM_HighValue     - (IS) default 100 (LONG)
*
*         PM_Ticks         -  Ticks to draw under the meter box
*                               defaults to 0 for none 
*
*         PM_CancelButton - Create a Cancel button? (BOOL)
*         PM_CancelText   - Text for cancel button. default "Cancel". (STRPTR)
*         PM_QueryCancel  - (S) The number of time the user
*                           has pressed the cancel button since the last
*                           PM_QueryCancel (ULONG *)  
*
*         the following three are not implemented 
*         PM_CancelID - Creates an IDCMP_GADGETUP event when the Cancel button
*                       is clicked. IntuiMessage->IAddress will be a pointer
*                       to a gadget whose GadgetID is taken from this tag.
*                       To be used in conjunctoin with the PM_MsgPort tag.
*         PM_CancelSigNum  - Sets a signal when the Cancel button is clicked 
*         PM_CancelSigTask - Task to signal (struct Task *)    
*
*   RESULT
*       returns a pointer to a ProgressMeter. or NULL on failure.
*
*   EXAMPLE
*
*   NOTES
*     requires diskfont, exec, gadtools, graphics, intuition & utility
*     libraries to be open.
*
*   BUGS
*       Currently uses SmartRefresh window.
*
*   SEE ALSO
*       FreeProgressMeter(), UpdateProgressMeterA()
*
******************************************************************************
*
*/


ProgressMeter AllocProgressMeter(Tag FirstTag, ... )
{
  return(AllocProgressMeterA((struct TagItem *)&FirstTag));
}

ProgressMeter AllocProgressMeterA(struct TagItem *TagList)
{
  struct TagItem  *ti;
  struct TextAttr *ta;
  struct _ProgressMeter *pm;
  WORD centerx,centery,leftedge,topedge,width,height,winlbor,winrbor,wintbor,winbbor,
       rows=1, highlen,lowlen,hilowlen,meterlablen,cancellen,meterwidth;
  struct NewGadget ng;
  struct Gadget *gad;
  STRPTR wintitle;
  BOOL ok;

  if(pm=AllocVec(sizeof(struct _ProgressMeter),MEMF_CLEAR))
  {
    if(ti=FindTagItem(PM_ParentWindow,TagList))
    {
      pm->pm_ParentWindow=(struct Window *)ti->ti_Data;
      pm->pm_Screen      =pm->pm_ParentWindow->WScreen;
      
      centerx=pm->pm_ParentWindow->LeftEdge + pm->pm_ParentWindow->Width  / 2;
      centery=pm->pm_ParentWindow->TopEdge  + pm->pm_ParentWindow->Height / 2;
    }
    else
      if(ti=FindTagItem(PM_Screen,TagList))
      {
        pm->pm_Screen=(struct Screen *)ti->ti_Data;
      
        centerx=pm->pm_Screen->Width/2;
        centery=pm->pm_Screen->Height/2;
      }
    if(pm->pm_Screen)
    {
      if(pm->pm_VisualInfo=GetVisualInfo(pm->pm_Screen,0))
      {
        winlbor=pm->pm_Screen->WBorLeft;
        winrbor=pm->pm_Screen->WBorRight;
        wintbor=pm->pm_Screen->WBorTop+pm->pm_Screen->RastPort.TxHeight + 1;
        winbbor=pm->pm_Screen->WBorBottom;
  
        ta=(struct TextAttr *)GetTagData(PM_TextAttr, (ULONG)pm->pm_Screen->Font, TagList);
    
        if(!(pm->pm_Font=OpenDiskFont(ta)))
          pm->pm_Font=OpenDiskFont(&Topaz8);
    
        if(pm->pm_Font)
        {
          pm->pm_MeterLabel  =(STRPTR)GetTagData(PM_MeterLabel, 0,TagList);
          pm->pm_MeterFormat =(STRPTR)GetTagData(PM_MeterFormat,(ULONG)def_meter  ,TagList);
          pm->pm_MeterType   =GetTagData(PM_MeterType          ,PM_TYPE_PERCENTAGE,TagList);
          pm->pm_LowText     =(STRPTR)GetTagData(PM_LowText    ,(ULONG)def_low    ,TagList);
          pm->pm_HighText    =(STRPTR)GetTagData(PM_HighText   ,(ULONG)def_high   ,TagList);
          if(GetTagData(PM_CancelButton,0,TagList))
            pm->pm_CancelText  =(STRPTR)GetTagData(PM_CancelText ,(ULONG)def_cancel ,TagList);
          meterwidth         =GetTagData(PM_MinMeterWidth ,80                ,TagList);
    
          highlen     =gui_StrFontLen(pm->pm_Font,pm->pm_HighText)+16;
          lowlen      =gui_StrFontLen(pm->pm_Font,pm->pm_LowText)+16;
          cancellen   =gui_StrFontLen(pm->pm_Font,pm->pm_CancelText)+16;
          meterlablen =gui_StrFontLen(pm->pm_Font,pm->pm_MeterLabel)+16;
                
          hilowlen=max(highlen,lowlen);
    
          width=GetTagData(PM_MinWidth, 0,TagList);
          width=max(width,cancellen+16+winlbor+winrbor);     /* 16 = 8 pixels on either */
          width=max(width,meterlablen+16+winlbor+winrbor); /* side of the gadget.     */
          width=max(width,meterwidth+hilowlen+hilowlen+16+winlbor+winrbor);
          width=min(pm->pm_Screen->Width,width);
    
          /* need to a PM_MinHeight support */
          if(pm->pm_CancelText)
            rows++;
            
          if(pm->pm_MeterLabel)
            rows++;
              
          height  =wintbor+winbbor+(pm->pm_Font->tf_YSize+6)*rows+10;
        
          leftedge          =GetTagData(PM_LeftEdge   ,centerx-width/2 ,TagList);
          topedge           =GetTagData(PM_TopEdge    ,centery-height/2,TagList);
          pm->pm_MeterValue =GetTagData(PM_MeterValue ,0    ,TagList);
          pm->pm_LowValue   =GetTagData(PM_LowValue   ,0    ,TagList);
          pm->pm_HighValue  =GetTagData(PM_HighValue  ,100  ,TagList);
          pm->pm_NumTicks   =GetTagData(PM_Ticks      ,0    ,TagList);
          
          if(pm->pm_DrawInfo=GetScreenDrawInfo(pm->pm_Screen))
          {
            pm->pm_MeterPen     = pm->pm_DrawInfo->dri_Pens[FILLPEN];
            pm->pm_MeterBgPen   = pm->pm_DrawInfo->dri_Pens[BACKGROUNDPEN];
            pm->pm_FormatPen    = pm->pm_DrawInfo->dri_Pens[FILLTEXTPEN];
            pm->pm_MeterLabelPen= pm->pm_DrawInfo->dri_Pens[HIGHLIGHTTEXTPEN];
            pm->pm_LowTextPen   =
             pm->pm_HighTextPen = pm->pm_DrawInfo->dri_Pens[TEXTPEN];
          
            pm->pm_MeterPen   =GetTagData(PM_MeterPen      ,pm->pm_MeterPen     ,TagList);
            pm->pm_MeterBgPen =GetTagData(PM_MeterBgPen    ,pm->pm_MeterBgPen   ,TagList);
            pm->pm_FormatPen  =GetTagData(PM_FormatPen     ,pm->pm_FormatPen    ,TagList);
            pm->pm_MeterLabelPen=GetTagData(PM_MeterLabelPen ,pm->pm_MeterLabelPen    ,TagList);
            pm->pm_LowTextPen =GetTagData(PM_LowTextPen    ,pm->pm_LowTextPen   ,TagList);
            pm->pm_HighTextPen=GetTagData(PM_HighTextPen   ,pm->pm_HighTextPen  ,TagList);
            
            wintitle=(STRPTR)GetTagData(PM_WinTitle,0,TagList);
    
            pm->pm_MeterCenter=(width-winlbor-winrbor)/2+winlbor;
            pm->pm_LowCenter  =winlbor+4+hilowlen/2;
            pm->pm_HighCenter =width-winrbor-4-hilowlen/2;
            pm->pm_LabelY     =wintbor+4;
            pm->pm_HiLowY     =pm->pm_LabelY;
            if(pm->pm_MeterLabel)
            {
              pm->pm_HiLowY+=pm->pm_Font->tf_YSize+6;
            }
          
            pm->pm_BarLeftEdge=winlbor+6+hilowlen;
            pm->pm_BarWidth   =width-winrbor-hilowlen-6-pm->pm_BarLeftEdge;
            pm->pm_BarTopEdge =pm->pm_HiLowY;
            pm->pm_BarHeight  =pm->pm_Font->tf_YSize+6;
            
            pm->pm_HiLowY+=pm->pm_Font->tf_Baseline+2;
            pm->pm_LabelY+=pm->pm_Font->tf_Baseline+2;
            
            ok=TRUE;
            if(pm->pm_CancelText)
            {
              ok=FALSE;
              if(gad=CreateContext(&pm->pm_GList))
              {
                ng.ng_Flags=0;
                ng.ng_TextAttr=ta;
                ng.ng_VisualInfo=pm->pm_VisualInfo;
                ng.ng_GadgetText=0;
                ng.ng_UserData=0;
                ng.ng_Height=pm->pm_Font->tf_YSize+4;       
                
                ng.ng_TopEdge   =pm->pm_BarTopEdge+pm->pm_BarHeight+6;
                ng.ng_GadgetID  =CANCEL_ID;
                ng.ng_LeftEdge  =width/2-cancellen/2;
                ng.ng_Width     =cancellen;
                ng.ng_GadgetText=pm->pm_CancelText;
                if(pm->pm_GTGads[0]=gad=CreateGadget(BUTTON_KIND,gad,&ng,
                                                  TAG_DONE))
                  ok=TRUE;
              }
            }
            if(ok)
            {
              if(pm->pm_MeterWindow=OpenWindowTags(0, WA_Width        ,width,
                                                      WA_Height       ,height,
                                                      WA_Left         ,leftedge,
                                                      WA_Top          ,topedge,
                                                      WA_Title        ,wintitle,
                                                      WA_CustomScreen ,pm->pm_Screen,
                                                      WA_DragBar      ,TRUE,
                                                      WA_DepthGadget  ,TRUE,
                                                      WA_SmartRefresh ,TRUE,
                                                      WA_Gadgets      ,pm->pm_GList,
                                                      WA_IDCMP        ,BUTTONIDCMP,
                                                      TAG_DONE))
              {
                SetFont(pm->pm_MeterWindow->RPort,pm->pm_Font);
                SetDrMd(pm->pm_MeterWindow->RPort,JAM1);

                GT_RefreshWindow(pm->pm_MeterWindow,0);
                RefreshPM(pm);

                return(pm);
              } // endif OpenWindow
            } // endif ok
          } // endif GetScreenDrawInfo
        } // endif pm_Font
      } // endif GetVisualInfo
    } // endif pm_Screen
    FreeProgressMeter(pm);    
  } // endif pm=AllocVec()
  return(NULL);
}      

/****** extras.lib/FreeProgressMeter ******************************************
*
*   NAME
*       FreeProgressMeter -- Close a PregressMeter.
*
*   SYNOPSIS
*       FreeProgressMeter(PM)
*
*       void FreeProgressMeter(ProgressMeter );
*
*   FUNCTION
*       Close and deallocated a ProgressMeter.
*
*   INPUTS
*       PM - pointer to an existing ProgressMeter or NULL.
*
*   RESULT
*       none.
*
*   EXAMPLE
*
*   NOTES
*     requires diskfont, exec, gadtools, graphics, intuition & utility
*     libraries to be open.
*
*   BUGS
*
*   SEE ALSO
*       AllocProgressMeterA(), UpdateProgressMeterA()
*
******************************************************************************
*
*/

void FreeProgressMeter(ProgressMeter ProgressMeter)
{
  struct _ProgressMeter *PM;
  
  PM=ProgressMeter;
  
  if(PM)
  {

    if(PM->pm_MeterWindow)
      CloseWindow(PM->pm_MeterWindow);
    if(PM->pm_Screen)
      FreeScreenDrawInfo(PM->pm_Screen,PM->pm_DrawInfo);
    FreeGadgets(PM->pm_GList);
    FreeVisualInfo(PM->pm_VisualInfo);
    if(PM->pm_Font)
      CloseFont(PM->pm_Font);
    FreeVec(PM);
  }
}

/****** extras.lib/UpdateProgressMeterA ******************************************
*
*   NAME
*       UpdateProgressMeterA -- Change ProgressMeter attributes.
*       UpdateProgressMeter -- varargs stub.
*
*   SYNOPSIS
*       numProcessed UpdateProgressMeterA(PM,TagList)
*
*       LONG UpdateProgressMeterA(ProgressMeter ,struct TagItem *);
*
*       numProcessed UpdateProgressMeter(PM,FirstTag)
*
*       LONG UpdateProgressMeter(ProgressMeter , Tag, ...);
*
*   FUNCTION
*       Updates a ProgressMeter's attributes  and refreshes
*       it as neccessary.
*
*   INPUTS
*       PM - Pointer to an existing ProgressMeter or NULL.
*       TagList - TagList of attributes to change or NULL.
*           Only these four tags are processed.
*             PM_QueryCancel
*             PM_MeterValue
*             PM_LowValue
*             PM_HighValue
*
*   RESULT
*       returns the number of tags processed.
*
*   EXAMPLE
*
*   NOTES
*     requires diskfont, exec, gadtools, graphics, intuition & utility
*     libraries to be open.
*
*   BUGS
*
*   SEE ALSO
*     AllocProgressMeterA(), FreeProgressMeter() 
*
******************************************************************************
*
*/

LONG   UpdateProgressMeter(ProgressMeter PM, Tag FirstTag, ...)
{
  return(UpdateProgressMeterA(PM,(struct TagItem *)&FirstTag));
}

LONG   UpdateProgressMeterA(ProgressMeter PMeter, struct TagItem *TagList)
{
  struct _ProgressMeter *PM;
  LONG parsed=0;
  ULONG data,count,*dp;
  BOOL refreshbar=FALSE;
  struct TagItem *tstate,*tag;
  struct IntuiMessage *imsg;
  
  PM=PMeter;
  
  if(PM && TagList)
  {
    tstate=TagList;
    while(tag=NextTagItem(&tstate))
    {
      parsed++;
      data=tag->ti_Data;
      dp=(ULONG *)data;
      switch(tag->ti_Tag)
      {
        case PM_QueryCancel:
          
          if(dp)
          {
            count=0;
            while(imsg=GT_GetIMsg(PM->pm_MeterWindow->UserPort))
            {
              if(imsg->Class==IDCMP_GADGETUP)
               // if(((struct Gadget *)imsg->IAddress)->GadgetID==CANCEL_ID)
                  count++;
              GT_ReplyIMsg(imsg);
            }
            *dp=count;
            
          }
          break;
        case PM_MeterValue:
          PM->pm_MeterValue=data;
          refreshbar=TRUE;
          break;
        case PM_LowValue:
          PM->pm_LowValue=data;
          refreshbar=TRUE;
          break;
        case PM_HighValue:
          PM->pm_HighValue=data;
          refreshbar=TRUE;
          break;
        default:
          parsed--;
          break;
      }
    }
  }
  if(refreshbar)
    RenderBar(PM);
  return(parsed);
}

void RenderBar(ProgressMeter PMeter)
{
  struct RastPort *rp;
  LONG hi,lo;
  float percent;
  LONG ipercent;
  WORD x,y,w,y1,pos;
  UBYTE *fb;
  UBYTE formatbuffer[26];
  struct _ProgressMeter *PM;

  PM=PMeter;


  
  if(PM)
  {
    rp=PM->pm_MeterWindow->RPort;
    x=PM->pm_BarLeftEdge+2;
    w=PM->pm_BarWidth-4;

    y=PM->pm_BarTopEdge+1;
    y1=PM->pm_BarHeight-3+y;
    
    lo=PM->pm_LowValue;
    hi=PM->pm_HighValue-lo;
    
    if(hi)
      percent=(float)(PM->pm_MeterValue-lo) / hi;
    else
      percent=1.0;
    
    if(percent>1.0) percent=1.0;
    if(percent<0.0) percent=0.0;
    
    ipercent=(ULONG)(percent*100+.5);
    
    pos=(WORD)(w*percent+x-1);
    
    if(y1>=y)
    {
      if(x<pos)
      {
        SetAPen(rp,PM->pm_MeterPen);
        RectFill(rp,x,y,pos,y1);
      }
      pos++;  
      if(pos < x+w-1 )
      {
        SetAPen(rp,PM->pm_MeterBgPen);
        RectFill(rp,pos,y,x+w-1,y1);
      }
    }
    if(PM->pm_MeterFormat)
    {
      switch(PM->pm_MeterType)
      {
        case PM_TYPE_PERCENTAGE:
          fb=formatbuffer;
          sprintf(formatbuffer,PM->pm_MeterFormat,ipercent);
          break;
        case PM_TYPE_NUMBER:
          fb=formatbuffer;
          sprintf(formatbuffer,PM->pm_MeterFormat,PM->pm_MeterValue);
          break;
        case PM_TYPE_STRING:
          fb=PM->pm_MeterFormat;
          break;
        default:
          fb=0;
          break;
      }
      if(PM->pm_Screen->BitMap.Depth<2)
        SetDrMd(rp,COMPLEMENT);

      MyText(rp,fb, PM->pm_FormatPen,
         PM->pm_MeterCenter,PM->pm_HiLowY);

      SetDrMd(rp,JAM1);
    } 
  }
}


void RefreshPM(ProgressMeter PMeter)
{
  WORD x,w,x1,y;
  LONG l,shine,shadow;
  float tickspace;
  struct RastPort *rp;
  struct _ProgressMeter *PM;

  PM=PMeter;

  rp=PM->pm_MeterWindow->RPort;

  SetDrMd(rp,JAM1);

  MyText(rp,PM->pm_LowText, PM->pm_LowTextPen,
         PM->pm_LowCenter,PM->pm_HiLowY);
  MyText(rp,PM->pm_HighText, PM->pm_HighTextPen,
         PM->pm_HighCenter,PM->pm_HiLowY);
  MyText(rp,PM->pm_MeterLabel, PM->pm_MeterLabelPen,
         PM->pm_MeterCenter,PM->pm_LabelY);
  

  DrawBevelBox(rp,PM->pm_BarLeftEdge,PM->pm_BarTopEdge,
                  PM->pm_BarWidth,PM->pm_BarHeight,
                    GTBB_Recessed   ,TRUE,
                    GT_VisualInfo   ,PM->pm_VisualInfo,
                    TAG_DONE);
  
  
  x=PM->pm_BarLeftEdge;
  w=PM->pm_BarWidth;
  y=PM->pm_BarTopEdge+PM->pm_BarHeight-1;
  
  shine =PM->pm_DrawInfo->dri_Pens[SHINEPEN];
  shadow=PM->pm_DrawInfo->dri_Pens[SHADOWPEN];  

  if(PM->pm_NumTicks)
  {
    tickspace=w/PM->pm_NumTicks;
    for(l=1;l<PM->pm_NumTicks;l++)
    {
      x1=x+l*tickspace+1;
      SetAPen(rp,shadow);
      Move(rp,x1,y);
      Draw(rp,x1,y+4);
      SetAPen(rp,shine);
      Draw(rp,x1+1,y+4);
      Draw(rp,x1+1,y);
    }
  }
  RenderBar(PM);
}

void MyText(struct RastPort *RP, STRPTR Str, UBYTE Pen, WORD X, WORD Y)
{
  WORD l,len;
  if(RP && Str)
  {
    len=strlen(Str);
    l=TextLength(RP,Str,len);
    X=X-l/2;
    Move(RP,X,Y);
    SetAPen(RP,Pen);
    Text(RP,Str,len);
  }
}
  
/*
       ng.ng_TopEdge=wintbor +4;
              ng.ng_LeftEdge=winlbor+4;

            if(pm->pm_MeterLabel)
            {
              ng.ng_GadgetID=0;
              ng.ng_Width=width-8-winlbor-winlbor;
              pm->pm_GTGads[0]=gad=CreateGadget(TEXT_KIND,gad,&ng,
                          GTTX_Justification,GTJ_CENTER,
                          GTTX_Clipped      ,TRUE,
                          GTTX_Text   ,pm->pm_MeterLabel,
                          GTTX_Border ,FALSE,
                          TAG_DONE);
              ng.ng_TopEdge+=(pm->pm_Font->tf_YSize+6);
            }

            pm->pm_BarTopEdge=ng.ng_TopEdge;
            pm->pm_BarHeight =pm->pm_Font->tf_YSize+4;

            ng.ng_Width=hilowlen;
          
            ng.ng_GadgetID=1;
            ng.ng_LeftEdge=winlbor+4;
            pm->pm_GTGads[1]=gad=CreateGadget(TEXT_KIND,gad,&ng,
                            GTTX_Justification,GTJ_CENTER,
                            GTTX_Clipped      ,TRUE,
                            GTTX_Text   ,pm->pm_LowText,
                            GTTX_Border ,FALSE,
                            TAG_DONE);
            pm->pm_BarLeftEdge=ng.ng_LeftEdge+hilowlen+2;
            
            ng.ng_GadgetID=2;
            ng.ng_LeftEdge=width-winrbor-4-hilowlen;
            
            pm->pm_GTGads[1]=gad=CreateGadget(TEXT_KIND,gad,&ng,
                            GTTX_Justification,GTJ_CENTER,
                            GTTX_Clipped      ,TRUE,
                            GTTX_Text   ,pm->pm_HighText,
                            GTTX_Border ,FALSE,
                            TAG_DONE);

            pm->pm_BarWidth   =ng.ng_LeftEdge-pm->pm_BarLeftEdge-2;
*/

