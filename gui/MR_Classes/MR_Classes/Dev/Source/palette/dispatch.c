#define DEBUG
#include <debug.h>

#include "ui.h"
#include "edata.h"

#include <clib/alib_protos.h>
#include <clib/extras/string_protos.h>

#include <classes/requesters/palette.h>

#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/utility.h>

#include <exec/memory.h>

#include <math.h>

#include <tagitemmacros.h>

// OBSOLETE

ULONG soSetAttrs(Class *C, Object *Obj, struct opSet *Set);
ULONG soGetAttrs(Class *C, Object *Obj, struct opGetAttrs *Get);
ULONG soGetAttr(Class *C, Object *Obj, struct opGet *Get);
STRPTR copystring(STRPTR Source, STRPTR *dest);

ULONG __saveds __asm EditorDispatcher(register __a0 Class *C, register __a2 Object *Obj, register __a1 Msg M, register __a6 struct Library *Lib)
{
  struct SData *sdata;
  ULONG retval=0;

//  sdata=INST_DATA(C, Obj);

  switch(M->MethodID)
  {
    case OM_NEW:
      //DKP("OM_NEW\n");
      if(Obj=(Object *)DoSuperMethodA(C,Obj,(Msg)M))
      {
        sdata=INST_DATA(C, Obj);
        
        if(i_NewWindowObject(C,Obj,(APTR)M))
        {
          soSetAttrs(C,Obj,(struct opSet *)M);
          retval=(ULONG)Obj;
        }
        else
        {
          retval=0;
          DoSuperMethod(C,Obj,OM_DISPOSE);
        }
      }
      break;

    case OM_DISPOSE:
      //DKP("OM_DISPOSE\n");
//      Delay(60);
      i_DisposeWindowObject(C,Obj);
      //DKP("Window disposed\n");
//      Delay(60);
      retval=DoSuperMethodA(C,Obj,(Msg)M);
      break;

    case OM_SET:
      //DKP("OM_SET\n");
      retval=soSetAttrs(C,Obj,(struct opSet *)M);
      break;

    case OM_GET:
      //DKP("OM_GET\n");
      retval=soGetAttr(C,Obj,(struct opGet *)M);
      break;



//    case OM_GETATTRS:
//      retval=soGetAttrs(C,Obj,(struct opGetAttrs *)M);
      break;

    case RM_DOREQUEST:
      //DKP("MPEM_EDIT\n");
      retval=i_OpenEditor(C,Obj,(APTR)M);      
//      Delay(60);
      //DKP("  end MPEM_EDIT\n");
//      Delay(60);
      break;
      
/*
    case OM_DUPEOBJECT:
      {
        retval=soDupeObject(C, Obj);        
      }
      break;*/
/*    case MPM_MATCHSCREEN:
*/    


    default:
      retval=DoSuperMethodA(C,Obj,(Msg)M);
      break;
  }
  return(retval);
}


ULONG soSetAttrs(Class *C, Object *Obj, struct opSet *Set)
{
  struct EData *edata;
  struct TagItem *tag,*tstate;
  ULONG retval=0,data;

  edata=INST_DATA(C, Obj);
  
  ProcessTagList(Set->ops_AttrList,tag,tstate)
  {
    data=tag->ti_Data;
    switch(tag->ti_Tag)
    {
     case PR_Screen:
        DKP("  PR_Screen %8lx\n",data);
        edata->pr_Screen=(struct Screen *)data;
        edata->pr_Window=((struct Window *)0);
        edata->pr_PubScreenName=(STRPTR)0;
        
        SetAttrs(edata->Win_Object, WA_CustomScreen,    data, 
                                    WINDOW_Position,    WPOS_CENTERSCREEN,
                                    TAG_DONE);
        break;

      case PR_Window:
        DKP("  PR_Window %8lx\n",data);
        edata->pr_Window=(struct Window *)data;
        edata->pr_Screen=(struct Screen *)0;
        edata->pr_PubScreenName=(STRPTR)0;

        SetAttrs(edata->Win_Object, WINDOW_RefWindow,   data, 
                                    WINDOW_Position,    WPOS_CENTERWINDOW,
                                    TAG_DONE);
        break;
        
      case PR_PubScreenName:
        DKP("  PR_PubScreenName %s\n",data);
        edata->pr_PubScreenName=(STRPTR)data;

        edata->pr_Window=(struct Window *)0;
        edata->pr_Screen=(struct Screen *)0;

        SetAttrs(edata->Win_Object, WA_PubScreenName,   data,
                                    WINDOW_Position,    WPOS_CENTERSCREEN,
                                    TAG_DONE);
        break;
   
      case PR_Colors:
        //DKP("  PR_Colors %ld\n",data);
        
        data=max(1,data);
        data=min(data,256);
        edata->pr_Colors=data;

        //SetGadgetAttrs(edata->G_Palette, edata->Window, 0, TCPALETTE_NumColors, data, TAG_DONE);
        break;
   
      case PR_InitialPalette:
        //DKP("  PR_InitialPalette %8lx\n",data);
        {
          struct prRGB *rgb;
          ULONG l;
          
          rgb=(APTR)data;
          
          for(l=0;l<edata->pr_Colors;l++)
            edata->pr_InitialPalette[l]=rgb[l];
        }
        break;
        
/*
      case PR_ObtainPens:
        //DKP("  PR_ObtainPens %8lx\n",data);
        edata->pr_Flags|=PRFLAG_OBTAINPENS;
        edata->pr_PenMode=PR_ObtainPens;
        break;

      case PR_ObtainBestPens:
        //DKP("  PR_ObtainBestPens %8lx\n",data);
        edata->pr_PenMode=PR_ObtainBestPens;
        break;
        
      case PR_ColorTable:
        //DKP("  PR_ColorTable %8lx\n",data);
        edata->pr_UserColorTable=(APTR)data;
        edata->pr_PenMode=PR_ColorTable;
        break;
*/
        
      case PR_TextAttr:
        //DKP("  PR_TextAttr %8lx\n",data);
        edata->pr_TextAttr=(APTR)data;
        break;
        
      case PR_TitleText:
        //DKP("  PR_Title %s\n",data);
        edata->pr_TitleText=(APTR)data;
        break;
        
      case PR_RedBits:
        edata->pr_Flags&=(~PRFLAG_USER_REDBITS);
        if(data)
        {
          edata->pr_RedBits=data;
          edata->pr_Flags|=PRFLAG_USER_REDBITS;
        }
        break;
        
      case PR_GreenBits:
        edata->pr_Flags&=(~PRFLAG_USER_GREENBITS);
        if(data)
        {
          edata->pr_GreenBits=data;
          edata->pr_Flags|=PRFLAG_USER_GREENBITS;
        }
        break;
        
      case PR_BlueBits:
        edata->pr_Flags&=(~PRFLAG_USER_BLUEBITS);
        if(data)
        {
          edata->pr_BlueBits=data;
          edata->pr_Flags|=PRFLAG_USER_BLUEBITS;
        }
        break;
        
      case PR_ModeIDRGBBits:
        {
          struct DisplayInfo di;
          
          //DKP("  PR_ModeIDRGBBits %8x\n",data);
          
          if(GetDisplayInfoData(0,(UBYTE *)&di,sizeof(di),DTAG_DISP,data))
          {
            edata->pr_RedBits   =max(di.RedBits,1);
            edata->pr_GreenBits =max(di.GreenBits,1);
            edata->pr_BlueBits  =max(di.BlueBits,1);
            
            edata->pr_Flags|=PRFLAG_USER_REDBITS|PRFLAG_USER_GREENBITS|PRFLAG_USER_BLUEBITS;
          }
        }
        break;
        
      case PR_InitialLeftEdge:
        edata->pr_Flags&=(~PRFLAG_USER_LEFTEDGE);
        if(data>=0)
        {
          edata->pr_Flags|=(PRFLAG_USER_LEFTEDGE);
          edata->pr_InitialLeftEdge=data;
        }
        break;
        
      case PR_InitialTopEdge:
        edata->pr_Flags&=(~PRFLAG_USER_TOPEDGE);
        if(data>=0)
        {
          edata->pr_Flags|=(PRFLAG_USER_TOPEDGE);
          edata->pr_InitialTopEdge=data;
        }
        break;
        
      case PR_InitialWidth:
        edata->pr_Flags&=(~PRFLAG_USER_WIDTH);
        if(data>=0)
        {
          edata->pr_Flags|=(PRFLAG_USER_WIDTH);
          edata->pr_InitialWidth=data;
        }
        break;
      case PR_InitialHeight:
        edata->pr_Flags&=(~PRFLAG_USER_HEIGHT);
        if(data>=0)
        {
          edata->pr_Flags|=(PRFLAG_USER_HEIGHT);
          edata->pr_InitialHeight=data;
        }
        break;
        
      case PR_PositiveText:
        edata->pr_PositiveText=data;
        break;

      case PR_NegativeText:
        edata->pr_NegativeText=data;
        break;
        
        
    } // endswitch()
  }// in ProcessTagList()

  return(retval);
}

ULONG soGetAttr(Class *C, Object *Obj, struct opGet *Get)
{
  struct EData *edata;
/*
  union 
  {
    struct TTextAttr *ta;
    struct RGB *rgb;
    APTR   aptr;
    STRPTR strptr;
    ULONG  ulong;
  } *data;
  */

  ULONG retval=0;

  edata=INST_DATA(C, Obj);
  
  switch(Get->opg_AttrID)
  {
    case PR_Palette:
//      GetAttr(TCPALETTE_RGBPalette, edata->G_Palette, Get->opg_Storage);
      memcpy(Get->opg_Storage,edata->pr_InitialPalette, edata->pr_Colors * sizeof(struct prRGB) );//   (44.3.2) (09/03/00)
      retval=1;
      break;
  }
  return(retval);
}



STRPTR copystring(STRPTR Source, STRPTR *dest)
{
  STRPTR ns;

  if(Source)
  {
    if(ns=CopyString(Source,MEMF_PUBLIC))
    {
      FreeVec(*dest);
      *dest=ns;
      return(ns);
    }
    else
    {
      FreeVec(*dest);
      *dest=0;
    }
  }
  return(*dest);
}


struct PData
{
  struct SData  *SData;
  struct Screen *Screen;
  WORD   Width,Height,Depth;
};


