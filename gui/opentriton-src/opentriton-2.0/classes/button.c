/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */


/****** triton.library/class_Button ******
*
*   NAME	
*	class_Button -- A BOOPSI button gadget
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Button
*
*   ATTRIBUTES
*	<Default>        : ULONG buttontype
*	                   - TRBT_TEXT         : Text button (default)
*	                   - TRBT_GETFILE      : GetFile image button
*	                   - TRBT_GETDRAWER    : GetDrawer image button
*	                   - TRBT_GETENTRY     : GetEntry image button
*	                   [create]
*	TRAT_Text        : STRPTR label
*	                   [create]
*	TRAT_Flags       : ULONG flags
*	                   - TRBU_RETURNOK     : Activated by <Return>
*	                   - TRBU_ESCOK        : Activated by <Esc>
*	                   - TRBU_SHIFTED      : Shifted shortcut only
*	                   - TRBU_UNSHIFTED    : Unshifted shortcut only
*	                   - TRBU_YRESIZE (V2) : When this flag is set, the
*	                                         button will be vertically
*	                                         resizeable. This is required
*	                                         because beginning with V2
*	                                         the height of objects which
*	                                         are normally using the
*	                                         button height can be
*	                                         modified in the prefs
*	                                         editor. Set this flags
*	                                         WHEREVER POSSIBLE in order
*	                                         to make buttons adopt to
*	                                         taller objects in the same
*	                                         horizontal group.
*	                   [create]
*
*   APPLICATION MESSAGES
*	TRMS_ACTION is sent when a pressed down button is released.
*
*   NOTES
*	Although image buttons don't display a text string you can
*	still set one using the TRAT_Text attribute in order to create
*	a shortcut for the button.
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON
#define TR_EXTERNAL_ONLY

#include <ctype.h>
#include <dos.h>
#include <utility/hooks.h>
#include <clib/alib_protos.h>
#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "button.def"
#include "/prefs/Triton.h"

extern VOID __asm TR_InternalDrawFrame(register __a0 struct TR_Project *project,
				       register __a1 struct RastPort *rp, register __d1 UWORD left,
				       register __d2 UWORD top, register __d3 UWORD width,
				       register __d4 UWORD height, register __d0 UWORD type,
				       register __d5 BOOL inverted);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Global variables //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct IClass *TRCL_BUTTON_BoopsiImage=NULL;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Private functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct IClass __inline *TRCL_BUTTON_InitBoopsiImage(void);
ULONG __asm TRCL_BUTTON_DispatchBoopsiImage(register __a0 struct IClass *Class,
					    register __a2 Object *Object, register __a1 Msg ObjMsg);
void __inline TRCL_BUTTON_DrawBoopsiImage(struct Image *Image, struct impDraw *DrawMsg);


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define BUTTON object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Button,NEW,NewData)
{
  LONG uspos;
  STRPTR newtext;

  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  data->project->trp_IDCMPFlags|=IDCMP_GADGETUP;
  BUTTON->BClass=TRCL_BUTTON_BoopsiImage;
  DISPLAYOBJECT->MinHeight=(data->project->trp_PropFont->tf_YSize)+4;

  if(BUTTON->Text)
    if((uspos=TR_FirstOccurance(data->project->trp_Underscore,BUTTON->Text)+1))
      DISPLAYOBJECT->Shortcut=tolower(BUTTON->Text[uspos]);

  if(BUTTON->Type==TRBT_TEXT) /* Text button */
    {
      newtext=BUTTON->Text;
      BUTTON->TextLength=TR_FirstOccurance(0,newtext)+1;
      if(!(BUTTON->Text=(STRPTR)AllocVec(BUTTON->TextLength, MEMF_ANY))) return NULL;
      CopyMem((APTR)newtext,(APTR)(BUTTON->Text),BUTTON->TextLength);
      BUTTON->PixelTextLength=TR_TextWidth(data->project,(STRPTR)(BUTTON->Text),0);

      BUTTON->BorderHeight=TR_FrameBorderHeight(data->project,TRFT_ABSTRACT_BUTTON);
      DISPLAYOBJECT->MinHeight+=(2*BUTTON->BorderHeight);
      DISPLAYOBJECT->MinWidth=BUTTON->PixelTextLength+(data->project->trp_PropFont->tf_YSize*2)+4;
      DISPLAYOBJECT->XResize=TRUE;
      if(DISPLAYOBJECT->Flags&TROB_DISPLAYOBJECT_RETURNOK)
        {
          if((((struct TR_AppPrefs *)(data->project->trp_App->tra_Prefs))->flags)&TRPF_RETURNARROW)
            DISPLAYOBJECT->MinWidth+=
	      (((data->project->trp_PropFont->tf_YSize/2)+
		((data->project->trp_PropFont->tf_YSize*16)/11))-2);
          else DISPLAYOBJECT->MinWidth++;
        }
    }
  else /* Image button */
    {
      DISPLAYOBJECT->MinHeight+=2;
      DISPLAYOBJECT->MinWidth=DISPLAYOBJECT->MinHeight+3;
    }

  return (ULONG)object;
}


TR_SIMPLEMETHOD(Button,DISPOSE)
{
  if(BUTTON->Type==TRBT_TEXT) if(BUTTON->Text) FreeVec((APTR)(BUTTON->Text));
  return 1L;
}


TR_METHOD(Button,INSTALL,InstallData)
{
  struct Gadget *gadget;

  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);

  if(!(BUTTON->Image=(struct Image *)NewObject(BUTTON->BClass,NULL,
						   IA_Height,      DISPLAYOBJECT->Height,
						   IA_Width,       DISPLAYOBJECT->Width,
						   SYSIA_DrawInfo, OBJECT->Project->trp_DrawInfo,
						   TAG_END)))
    return NULL;

  if(!(gadget=TR_CreateGadgetTags(
				  OBJECT->Project,
				  OBJECT,
				  GENERIC_KIND,
				  DISPLAYOBJECT->Left,
				  DISPLAYOBJECT->Top,
				  DISPLAYOBJECT->Width,
				  DISPLAYOBJECT->Height,
				  TAG_END)))
    return NULL;

  BUTTON->Gadget=gadget;

  gadget->Flags |= GFLG_GADGIMAGE|GFLG_GADGHIMAGE;
  gadget->GadgetType |= GTYP_BOOLGADGET;
  gadget->Activation |= GACT_RELVERIFY;
  gadget->GadgetRender = gadget->SelectRender = BUTTON->Image;
  BUTTON->Image->ImageData=(USHORT *)object;
  if(TR_DO_DISABLED) gadget->Flags |= GFLG_DISABLED;
  return 1L;
}


TR_SIMPLEMETHOD(Button,REMOVE)
{
  if(BUTTON->Image) DisposeObject((Object *)(BUTTON->Image));
  return TRDP_DisplayObject_REMOVE(object,messageid,data,metaclass->trc_SuperClass);
}


TR_METHOD(Button,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case 0:
      BUTTON->Type=data->value;
      return 1;

    case TRAT_Flags:
      BUTTON->Flags=data->value;
      if((BUTTON->Flags)&(TRBU_RETURNOK)) DISPLAYOBJECT->Flags|=TROB_DISPLAYOBJECT_RETURNOK;
      if((BUTTON->Flags)&(TRBU_ESCOK)) DISPLAYOBJECT->Flags|=TROB_DISPLAYOBJECT_ESCOK;
      if((BUTTON->Flags)&(TRBU_YRESIZE)) DISPLAYOBJECT->YResize=TRUE;
      return 1;

    case TRAT_Text:
      BUTTON->Text=(STRPTR)(data->value);
      return 1;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_METHOD(Button,KEYDOWN,EventData)
{
  if(!BUTTON->IsPressed)
    {
      if((data->imsg->Code)&&((BUTTON->Flags)&TRBU_UNSHIFTED)) return NULL;
      if((!(data->imsg->Code))&&((BUTTON->Flags)&TRBU_SHIFTED)) return NULL;
      TR_SelectGadget(OBJECT->Project, BUTTON->Gadget,TRUE);
      BUTTON->IsPressed=TRUE;
    }
  return 1L;
}


TR_METHOD(Button,KEYCANCELLED_DISABLED_ENABLED,EventData)
{
  if(BUTTON->IsPressed)
    {
      TR_SelectGadget(OBJECT->Project, BUTTON->Gadget,FALSE);
      BUTTON->IsPressed=FALSE;
    }
  if((messageid==TROM_DISABLED)||(messageid==TROM_ENABLED))
    TR_DisableGadget(OBJECT->Project, BUTTON->Gadget, TR_DO_DISABLED);
  return 1L;
}


TR_METHOD(Button,KEYUP,EventData)
{
  struct TR_Message *m;

  if(BUTTON->IsPressed) if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
    {
      m->trm_ID=DISPLAYOBJECT->ID;
      m->trm_Class=TRMS_ACTION;
    }

  return TR_DIRECTMETHODCALL(Button,KEYCANCELLED_DISABLED_ENABLED);
}


TR_METHOD(Button,EVENT,EventData)
{
  struct TR_Message *m;

  if((data->imsg->Class==IDCMP_GADGETUP)&&(data->imsg->IAddress==(APTR)(BUTTON->Gadget)))
    if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
      {
	m->trm_ID=DISPLAYOBJECT->ID;
	m->trm_Class=TRMS_ACTION;
	return TROM_EVENT_SWALLOWED;
      }
  return TROM_EVENT_CONTINUE;
}


TR_SIMPLEMETHOD(Button,CREATECLASS)
{
  if(!(TRCL_BUTTON_BoopsiImage=TRCL_BUTTON_InitBoopsiImage())) return TRUE;
  return FALSE;
}


TR_SIMPLEMETHOD(Button,DISPOSECLASS)
{
  if(TRCL_BUTTON_BoopsiImage) FreeClass(TRCL_BUTTON_BoopsiImage);
  return NULL;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////// BOOPSI image class 'BUTTON' //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

ULONG	__asm TRCL_BUTTON_DispatchBoopsiImage(register __a0 struct IClass *Class, register __a2 Object *Object, register __a1 Msg ObjMsg)
{
  ULONG retval=TRUE;
  struct Hook *hook=(struct Hook *)Class;
  ULONG tempa4=__builtin_getreg(12);

  __builtin_putreg(12,(ULONG)hook->h_Data);

  if(ObjMsg->MethodID==IM_DRAW)
    TRCL_BUTTON_DrawBoopsiImage((struct Image *)Object, (struct impDraw *)ObjMsg);
  else
    retval=DoSuperMethodA(Class, Object, ObjMsg);

  __builtin_putreg(12,tempa4);
  return retval;
}


struct IClass __inline *TRCL_BUTTON_InitBoopsiImage(void)
{
  struct IClass *TRCL_BUTTON_BoopsiClass;

  if((TRCL_BUTTON_BoopsiClass = MakeClass(NULL, IMAGECLASS, NULL, 0, 0)))
  {
    TRCL_BUTTON_BoopsiClass->cl_Dispatcher.h_Entry = (HOOKFUNC)TRCL_BUTTON_DispatchBoopsiImage;
    TRCL_BUTTON_BoopsiClass->cl_Dispatcher.h_Data  = (void *) __builtin_getreg(12);
  }

  return TRCL_BUTTON_BoopsiClass;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////// BOOPSI image drawing functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

VOID __inline TR_DrawReturnArrowImage(struct RastPort *rp,ULONG l,ULONG t,ULONG w,ULONG h, ULONG shinepen, ULONG shadowpen)
{
  SetAPen(rp,shadowpen);
  if(h<11)
  {
    t+=((h-8)/2);
    Move(rp,l+3,t+6);
    Draw(rp,l+1,t+4);
    Draw(rp,l+3,t+2);
    Move(rp,l+3,t+7);
    Draw(rp,l,t+4);
    Draw(rp,l+3,t+1);
    Draw(rp,l+4,t+1);
    Draw(rp,l+4,t+3);
    Draw(rp,l+w-4,t+3);
    Draw(rp,l+w-4,t);
    Draw(rp,l+w-1,t);
    SetAPen(rp,shinepen);
    Move(rp,l+w-1,t+1);
    Draw(rp,l+w-1,t+5);
    Draw(rp,l+4,t+5);
    Draw(rp,l+4,t+7);
  }
  else
  {
    Move(rp,l+((w*5)/16),t+h);
    Draw(rp,l,t+((h*6)/11));
    Draw(rp,l+((w*5)/16),t+(h/11));
    Move(rp,l+1+((w*5)/16),t+h);
    Draw(rp,l+1,t+((h*6)/11));
    Draw(rp,l+1+((w*5)/16),t+(h/11));
    Draw(rp,l+1+((w*5)/16),t+((h*4)/11));
    Draw(rp,l+((w*11)/16),t+((h*4)/11));
    Draw(rp,l+((w*11)/16),t);
    Draw(rp,l+w,t);
    SetAPen(rp,shinepen);
    Move(rp,l+w,t+1);
    Draw(rp,l+w,t+((h*8)/11));
    Draw(rp,l+1+((w*5)/16),t+((h*8)/11));
    Draw(rp,l+1+((w*5)/16),t+h);
  }
}


void __inline TRCL_BUTTON_DrawBoopsiImage_BUTTON(struct RastPort *RPort,
						 UWORD left, UWORD top, UWORD width, UWORD height,
						 struct TROD_Button *object, struct TR_Project *project,
						 BOOL selected, struct impDraw *DrawMsg)
{
  SetDrMd(RPort, JAM1);

  // Text
  if(BUTTON->Text)
  {
    if(((((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->flags)&TRPF_RETURNARROW)&&(DISPLAYOBJECT->Flags&TROB_DISPLAYOBJECT_RETURNOK))
    {
      TR_InternalPrintText(project,RPort,BUTTON->Text,
        left+((width-BUTTON->PixelTextLength-(((project->trp_PropFont->tf_YSize)*16)/11)-((project->trp_PropFont->tf_YSize)/2))/2), // left+project->trp_PropFont->tf_YSize,
        top+((height-project->trp_PropFont->tf_YSize)/2),width /*dummy*/,
        selected?TRTX_SELECTED:NULL);
      TR_DrawReturnArrowImage(RPort,
        left+BUTTON->PixelTextLength+((project->trp_PropFont->tf_YSize)/2)+((width-BUTTON->PixelTextLength-(((project->trp_PropFont->tf_YSize)*16)/11)-((project->trp_PropFont->tf_YSize)/2))/2), // left+1+width-(((project->trp_PropFont->tf_YSize)*16)/11)-(project->trp_PropFont->tf_YSize),
        top+((height-project->trp_PropFont->tf_YSize)/2),
        ((project->trp_PropFont->tf_YSize)*16)/11,
        project->trp_PropFont->tf_YSize,
        DrawMsg->imp_DrInfo->dri_Pens[SHINEPEN],
        DrawMsg->imp_DrInfo->dri_Pens[SHADOWPEN]);
    }
    else
    {
      TR_InternalPrintText(project,RPort,BUTTON->Text,
        left+((width-BUTTON->PixelTextLength)/2),
        top+((height-project->trp_PropFont->tf_YSize)/2),width /*dummy*/,
        ((DISPLAYOBJECT->Flags&TROB_DISPLAYOBJECT_RETURNOK)?
	 TRTX_BOLD:NULL)|(selected?TRTX_SELECTED:NULL));
    }
  }
}


void __inline TRCL_BUTTON_DrawBoopsiImage_GETFILE(struct RastPort *RPort,
						  UWORD left, UWORD top, UWORD width, UWORD height,
						  struct TROD_Button *object, struct TR_Project *project,
						  BOOL selected, struct impDraw *DrawMsg)
{
  WORD i, FileArray[22]   = {0,-2, 6,-2, 6,2, 11,2, 11,7, 0,7, 0,-2, 6,-2, 11,2, 11,7, 0,7},
       DeltaX, DeltaY, DeltaX2, DeltaY2;

  // Reposition vectors to new positions
  for(i=0; i<11; i++)
  {
    FileArray[(i<<1)]+=(left+4);
    FileArray[(i<<1)+1]+=(top+5);
  }

  // Scale image
  DeltaX=width-20;
  DeltaY=height-16;
  DeltaX2=DeltaX>>1;
  DeltaY2=DeltaY>>1;
  FileArray[2]+=DeltaX2;
  FileArray[4]+=DeltaX2;
  FileArray[6]+=DeltaX;
  FileArray[8]+=DeltaX;
  FileArray[14]+=DeltaX2;
  FileArray[16]+=DeltaX;
  FileArray[18]+=DeltaX;
  FileArray[5]+=DeltaY2;
  FileArray[7]+=DeltaY2;
  FileArray[9]+=DeltaY;
  FileArray[11]+=DeltaY;
  FileArray[17]+=DeltaY2;
  FileArray[19]+=DeltaY;
  FileArray[21]+=DeltaY;

  // Draw image
  SetAPen(RPort, DrawMsg->imp_DrInfo->dri_Pens[TEXTPEN]);
  Move(RPort, left + 4, top + 5 + DeltaY2);
  PolyDraw(RPort, 11, &FileArray[0]);
}


void __inline TRCL_BUTTON_DrawBoopsiImage_GETDRAWER(struct RastPort *RPort,
						    UWORD left, UWORD top, UWORD width, UWORD height,
						    struct TROD_Button *object, struct TR_Project *project,
						    BOOL selected, struct impDraw *DrawMsg)
{
  WORD i, DrawerArray[28] = {0,7, 1,7, 1,0, 1,7, 11,7, 11,0, 9,-2, 6,-2, 3,0, 2,0, 2,1, 4,1, 6,2, 10,2},
       DeltaX, DeltaY, DeltaX2, DeltaY2, DeltaY3;

  // Reposition vectors to new positions
  for(i=0; i<14; i++)
  {
    DrawerArray[(i<<1)]+=(left+4);
    DrawerArray[(i<<1)+1]+=(top+5);
  }

  // Scale image
  DeltaX=width-20;
  DeltaY=height-16;
  DeltaX2=DeltaX>>1;
  DeltaY2=DeltaY>>1;
  DeltaY3=DeltaY>>2;

  DrawerArray[8]+=DeltaX;
  DrawerArray[10]+=DeltaX;
  DrawerArray[12]+=DeltaX;
  DrawerArray[26]+=DeltaX;
  DrawerArray[14]+=DeltaX2;
  DrawerArray[16]+=DeltaX2;
  DrawerArray[22]+=DeltaX2;
  DrawerArray[24]+=DeltaX2;
  DrawerArray[1]+=DeltaY;
  DrawerArray[3]+=DeltaY;
  DrawerArray[7]+=DeltaY;
  DrawerArray[9]+=DeltaY;
  DrawerArray[5]+=DeltaY3;
  DrawerArray[11]+=DeltaY3;
  DrawerArray[17]+=DeltaY3;
  DrawerArray[19]+=DeltaY3;
  DrawerArray[21]+=DeltaY3;
  DrawerArray[23]+=DeltaY3;
  DrawerArray[25]+=DeltaY2;
  DrawerArray[27]+=DeltaY2;

  // Draw image
  SetAPen(RPort, DrawMsg->imp_DrInfo->dri_Pens[TEXTPEN]);
  Move(RPort, left + 4, top + 5 + DeltaY3);
  PolyDraw(RPort, 14, &DrawerArray[0]);
}


void __inline TRCL_BUTTON_DrawBoopsiImage_GETENTRY(struct RastPort *RPort,
						   UWORD left, UWORD top, UWORD width, UWORD height,
						   struct TROD_Button *object, struct TR_Project *project,
						   BOOL selected, struct impDraw *DrawMsg)
{
  LONG PointWidth, Len, Foot, i;

  // Adjust image for wider borders
  left+=(BUTTON->BorderHeight-1);
  top+=(BUTTON->BorderHeight-1);
  width-=2*(BUTTON->BorderHeight-1);
  height-=2*(BUTTON->BorderHeight-1);

  // Picker

  SetAPen(RPort, DrawMsg->imp_DrInfo->dri_Pens[TEXTPEN]);

  left+=2;
  top+=1;
  width-=4;
  height-=2;

  left+=(width+15)/16;
  top+=(height+15)/16;

  width-=2*((width+15)/16);
  height-=2*((height+15)/16);

  Foot=top+top+height-1;

  PointWidth=(width+1)/2;

  if(2*PointWidth>width) PointWidth--;

  if(PointWidth)
  {
    for(i=0; i<(height+31)/32; i++)
    {
      Move(RPort,left,Foot-(top+i));
      Draw(RPort,left+width-1,Foot-(top+i));
    }
    top+=(height+15)/16;
    for(i=0; i<(height+1)/2; i++)
    {
      if(Len=(PointWidth*(i+1))/((height+1)/2))
      {
        Move(RPort,left+PointWidth-Len,Foot-(top+i));
        Draw(RPort,left+PointWidth+Len,Foot-(top+i));
      }
    }
    if(Len=((width+3)/4)/2)
    {
      for(i=height/2; i<height-(height+15)/16; i++)
      {
        Move(RPort,left+PointWidth-Len,Foot-(top+i));
        Draw(RPort,left+PointWidth+Len,Foot-(top+i));
      }
    }
  }
}


void __inline TRCL_BUTTON_DrawBoopsiImage(struct Image *Image, struct impDraw *DrawMsg)
{
  struct TROD_Button *object = (struct TROD_Button *)(Image->ImageData);
  struct RastPort *RPort = DrawMsg->imp_RPort;
  UWORD left = Image ->LeftEdge + DrawMsg->imp_Offset.X, top = Image ->TopEdge + DrawMsg->imp_Offset.Y,
        width = Image ->Width, height = Image ->Height;
  struct TR_Project *project = OBJECT->Project;
  BOOL s = (DrawMsg->imp_State==IDS_SELECTED);

  /* Background */
  TR_InternalAreaFill(project, RPort, left, top, left+width-1, top+height-1, s?TRSI_SBUTTONBACK:TRSI_USBUTTONBACK);

  /* Border */
  TR_InternalDrawFrame(project,RPort,left,top,width,height,TRFT_ABSTRACT_BUTTON,s?TRUE:FALSE);

  switch(BUTTON->Type)
    {
    case TRBT_GETFILE:
      TRCL_BUTTON_DrawBoopsiImage_GETFILE(RPort,left,top,width,height,object,project,s,DrawMsg);
      return;

    case TRBT_GETDRAWER:
      TRCL_BUTTON_DrawBoopsiImage_GETDRAWER(RPort,left,top,width,height,object,project,s,DrawMsg);
      return;

    case TRBT_GETENTRY:
      TRCL_BUTTON_DrawBoopsiImage_GETENTRY(RPort,left,top,width,height,object,project,s,DrawMsg);
      return;

    default:
      TRCL_BUTTON_DrawBoopsiImage_BUTTON(RPort,left,top,width,height,object,project,s,DrawMsg);
    }
}
