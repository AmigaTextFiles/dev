/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     funcount
   PURPOSE
     Count the number of function calls, for optimizing purposes.
   NOTES
     
   HISTORY
     Terje Pedersen - Jun 14, 1997: Created.
***/

#include "debug.h"

#if (DEBUG!=0)
#include <devices/timer.h>
#include <stdio.h>
#include <time.h>
#include "funcount.h"


char *zFuncName[] = {
  "XFillPolygon",
  "XFILLRECTANGLE",
  "XCHECKIFEVENT",
  "XCHECKMASKEVENT",
  "XCHECKTYPEDEVENT",
  "XCHECKTYPEDWINDOWEVENT",
  "XCHECKWINDOWEVENT",
  "XCOPYPLANE",
  "XCREATEBITMAPFROMDATA",
  "XCREATECOLORMAP",
  "XCREATEIMAGE",
  "XCREATEPIXMAP",
  "XCREATEPIXMAPFROMBITMAPDATA",
  "XDRAWPOINTS",
  "XEVENTSQUEUED",
  "XGETWINDOWATTRIBUTES",
  "XGRABPOINTER",
  "XIFEVENT",
  "XLOOKUPSTRING",
  "XMOVERESIZEWINDOW",
  "XPEEKIFEVENT",
  "XPUTBACKEVENT",
  "XPUTIMAGE",
  "XQUERYPOINTER",
  "XQUERYTREE",
  "XRAISEWINDOW",
  "XSENDEVENT",
  "XSETINPUTFOCUS",
  "XSETLINEATTRIBUTES",
  "XSETNORMALHINTS",
  "XSETSTANDARDPROPERTIES",
  "XSETSTIPPLE",
  "XSETTILE",
  "XSTORECOLORS",
  "XTEXTEXTENTS",
  "XWARPPOINTER",
  "XWINDOWEVENT",
  "XDRAWARC",
  "XFILLARC",
  "XDRAWLINE",
  "XDRAWRECTANGLE",
  "XDRAWSEGMENTS",
  "XSETFILLSTYLE",
  "XSETDASHES",
  "XCOPYGC",
  "XCREATEGC",
  "XFREEGC",
  "XSETFOREGROUND",
  "XSETBACKGROUND",
  "XSETSTATE",
  "XGETGCVALUES",
  "XSETTSORIGIN",
  "XCHANGEGC",
  "XSETARCMODE",
  "XDESTROYIMAGE",
  "XCOPYAREA",
  "XTEXTWIDTH",
  "XNEXTEVENT",
  "XPENDING",
  "XPEEKEVENT",
  "XSELECTINPUT",
  "XFLUSH",
  "XLOOKUPKEYSYM",
  "XUNGRABPOINTER",
  "XSTRINGTOKEYSYM",
  "XDRAWPOINT",
  "XDRAWLINES",
  "XSTORECOLOR",
  "XQUERYCOLORS",
  "XFREECOLORS",
  "XLOOKUPCOLOR",
  "XALLOCCOLOR",
  "XALLOCCOLORCELLS",
  "XALLOCSTANDARDCOLORMAP",
  "XCOPYCOLORMAPANDFREE",
  "XFREECOLORMAP",
  "XPARSECOLOR",
  "XSETWINDOWCOLORMAP",
  "XGETSUBIMAGE",
  "XGETIMAGE",
  "XFREEPIXMAP",
  "XREADBITMAPFILE",
  "XWRITEBITMAPFILE",
  "XLOADFONT",
  "XLOADQUERYFONT",
  "XFREEFONT",
  "XSETFONT",
  "XLISTFONTS",
  "XCREATEWINDOW",
  "XCREATESIMPLEWINDOW",
  "XDESTROYWINDOW",
  "XUNMAPWINDOW",
  "XMAPWINDOW",
  "XCLEARAREA",
  "XCLEARWINDOW",
  "XDESTROYSUBWINDOWS",
  "XMAPSUBWINDOWS",
  "XWITHDRAWWINDOW",
  "XDEFAULTROOTWINDOW",
  "XMAPRAISED",
  "XGETGEOMETRY",
  "XPARSEGEOMETRY",
  "XSTORENAME",
  "XWMGEOMETRY",
  "XCONFIGUREWINDOW",
  "XMOVEWINDOW",
  "XRECONFIGUREWMWINDOW",
  "XRESIZEWINDOW",
  "XALLOCNAMEDCOLOR",
  "GCContextSwap",
  "GCContextDrawSwap",
  "WinContextSwap",
  "MapMappedChildren",
  "Map_FreeIEntry",
  "ZLAST",
};

int aFuncCounter[ZLAST] = {0};
long aFuncTime[ZLAST] = {0};

void FunCount_Init( void )
{
  int i;

  for( i=0; i<ZLAST; i++ ){
    aFuncTime[i] = 0;
    aFuncCounter[i] = 0;
  }
}

void FunCount_Exit( void )
{
  int i;

  printf("\n\nFunctions used:\n\n");
  for( i=0; i<ZLAST; i++ ){
    if( aFuncCounter[i] )
      printf("Func %s used %d time %d\n",zFuncName[i],aFuncCounter[i],aFuncTime[i]);
  }
  printf("\n\Thats it!\n\n");
}

struct timeval tp1;
struct timeval tp2;

void
FunCount_Enter( int f, int show ){
  aFuncCounter[f]++;
  X_GETTIMEOFDAY( &tp1 );
  if( show ){
    printf("%s\n",zFuncName[f]);
  }
}

void
FunCount_Leave( int f, int show )
{
  long tick2;
  long tick1;

  X_GETTIMEOFDAY( &tp2 );
  tick2 = tp2.tv_secs*CLK_TCK+(tp2.tv_micro/1000); 
  tick1 = tp1.tv_secs*CLK_TCK+(tp1.tv_micro/1000);

  aFuncTime[f] += (tick2-tick1);
  if( show ){
    printf("%s %ld\n",zFuncName[f],aFuncTime[f]);
  }
}

#endif
