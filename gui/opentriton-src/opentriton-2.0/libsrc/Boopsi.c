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


#include "triton_lib.h"


struct IClass *TRIM_trLogo;
ULONG	__regargs TRIM_trLogo_DrawBoopsiImage(struct Image *Image, struct impDraw *DrawMsg);
ULONG	__asm TRIM_trLogo_DispatchBoopsiImage(register __a0 struct IClass *Class, register __a2 Object *Object, register __a1 Msg ObjMsg);


#define ARROWLENGTH 4
#define LANCELENGTH 2
#define CURVELENGTH 15


void __stdargs TR_ScaledPolyDraw(struct RastPort *rport, UWORD len, WORD *array, ULONG orgwid, ULONG orghei, ULONG newwid, ULONG newhei, ULONG left, ULONG top)
{
  UWORD i;

  for(i=0;i<len;i++)
  {
    array[i*2]=((array[i*2]*newwid)/orgwid)+left;
    array[(i*2)+1]=((array[(i*2)+1]*newhei)/orghei)+top;
  }
  Move(rport, array[0], array[1]);
  PolyDraw(rport, len-1, &array[2]);
}


ULONG	__regargs TRIM_trLogo_DrawBoopsiImage(struct Image *Image, struct impDraw *DrawMsg)
{
  struct	RastPort        * RPort           = DrawMsg->imp_RPort;
  UWORD                     BackColor       = DrawMsg->imp_DrInfo->dri_Pens[BACKGROUNDPEN],
                            TextColor       = DrawMsg->imp_DrInfo->dri_Pens[TEXTPEN];
  WORD                      left            = Image->LeftEdge + DrawMsg->imp_Offset.X,
                            top             = Image->TopEdge + DrawMsg->imp_Offset.Y,
                            width           = Image->Width,
                            height          = Image->Height,
                            Arrow1Array[ARROWLENGTH*2] = {22,6, 30,2, 26,10, 22,6},
                            Arrow2Array[ARROWLENGTH*2] = {34,18, 42,14, 38,22, 34,18},
                            Arrow3Array[ARROWLENGTH*2] = {46,30, 54,26, 50,34, 46,30},
                            LanceArray[LANCELENGTH*2] = {2,54, 36,20},
                            CurveArray[CURVELENGTH*2] = {24,8, 22,10, 20,14, 19,18, 18,22, 19,26, 20,30, 22,34, 26,36, 30,37, 34,38, 38,37, 42,36, 46,34, 48,32};

  // Background
  SetAfPt(RPort, NULL, -1);
  SetAPen(RPort, BackColor);
  SetDrMd(RPort, JAM1);
  RectFill(RPort, left, top, left+width-1, top+height-1);

  // Adjust size (->square)
  if(width>height)
  {
    left+=((width-height)/2);
    width=height;
  }
  else if(width<height)
  {
    top+=((height-width)/2);
    height=width;
  }

  // Logo
  SetAPen(RPort, TextColor);
  TR_ScaledPolyDraw(RPort,ARROWLENGTH,Arrow1Array,56,56,width,height,left,top);
  TR_ScaledPolyDraw(RPort,ARROWLENGTH,Arrow2Array,56,56,width,height,left,top);
  TR_ScaledPolyDraw(RPort,ARROWLENGTH,Arrow3Array,56,56,width,height,left,top);
  TR_ScaledPolyDraw(RPort,LANCELENGTH,LanceArray,56,56,width,height,left,top);
  TR_ScaledPolyDraw(RPort,CURVELENGTH,CurveArray,56,56,width,height,left,top);

  return(TRUE);
}


ULONG	__asm TRIM_trLogo_DispatchBoopsiImage(register __a0 struct IClass *Class, register __a2 Object *Object, register __a1 Msg ObjMsg)
{
  ULONG retval;
  struct Hook *hook=(struct Hook *)Class;
  ULONG tempa4=__builtin_getreg(12);
  __builtin_putreg(12,(ULONG)hook->h_Data);

  if(ObjMsg->MethodID==IM_DRAW) retval=TRIM_trLogo_DrawBoopsiImage((struct Image *)Object, (struct impDraw *)ObjMsg);
  else retval=DoSuperMethodA(Class, Object, ObjMsg);

  __builtin_putreg(12,tempa4);
  return retval;
}


BOOL __regargs TRIM_trLogo_Init(VOID)
{
  if((TRIM_trLogo = MakeClass(NULL, IMAGECLASS, NULL, 0, 0)))
  {
    TRIM_trLogo->cl_Dispatcher.h_Entry = (HOOKFUNC)TRIM_trLogo_DispatchBoopsiImage;
    TRIM_trLogo->cl_Dispatcher.h_Data  = (void *) __builtin_getreg(12);
  }
  return (BOOL)TRIM_trLogo;
}


VOID __regargs TRIM_trLogo_Free(VOID)
{
  if(TRIM_trLogo) FreeClass(TRIM_trLogo);
}
