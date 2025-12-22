/*
** $PROJECT: xrefsupport.lib
**
** $VER: gauge.c 1.1 (07.09.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 07.09.94 : 001.001 :  initial
*/

#include "/source/def.h"

#include "xrefsupport.h"

void draw_gauge(struct Gauge *gauge,ULONG actual,ULONG maximal)
{
   if(maximal == 0)
   {
      EraseRect(gauge->RPort,gauge->Left  ,gauge->Top,
                             gauge->Right ,gauge->Bottom);
      gauge->LastPixel = gauge->Left;
   } else
   {
      ULONG pixel = (gauge->Right - gauge->Left) * actual / maximal;

      pixel += gauge->Left;

      if(pixel > gauge->LastPixel)
      {
         SetDrMd(gauge->RPort,JAM1);
         SetAPen(gauge->RPort,gauge->FillPen);
         RectFill(gauge->RPort,gauge->LastPixel,gauge->Top,
                               pixel           ,gauge->Bottom);
         gauge->LastPixel = pixel;
      }
   }
}

void draw_gaugeinit(struct Window *win,struct Gauge *gauge,UBYTE shinepen,UBYTE shadowpen)
{
   struct RastPort *rp = win->RPort;

   UWORD left   = gauge->Left;
   UWORD top    = gauge->Top;
   UWORD right  = gauge->Right;
   UWORD bottom = gauge->Bottom;

   gauge->RPort  = rp;

   SetDrMd(rp,JAM1);

   SetAPen(rp,shinepen);
   Move(rp,right     ,top       );
   Draw(rp,left      ,top       );
   Draw(rp,left      ,bottom    );
   Move(rp,left + 1  ,bottom - 1);
   Draw(rp,left + 1  ,top       );

   SetAPen(rp,shadowpen);

   Move(rp,right     ,top       );
   Draw(rp,right     ,bottom    );
   Draw(rp,left  + 1 ,bottom    );
   Move(rp,right - 1 ,bottom    );
   Draw(rp,right - 1 ,top    + 1);

   gauge->Left   += 2;
   gauge->Right  -= 2;
   gauge->Top    += 1;
   gauge->Bottom -= 1;
   gauge->LastPixel = gauge->Left;
}

