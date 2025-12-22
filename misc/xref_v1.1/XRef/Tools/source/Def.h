/*
** $PROJECT: XRef-Tools
**
** $VER: Def.h 1.1 (04.09.94)
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
** 04.09.94 : 001.001 :  initial
*/

/* --------------------------- system include's --------------------------- */

#define INTUITION_IOBSOLETE_H           TRUE

#include <string.h>
#include <ctype.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <utility/tagitem.h>
#include <utility/hooks.h>

/* workbench include's */

#include <workbench/startup.h>
#include <workbench/workbench.h>
#include <workbench/icon.h>

/* graphics include's */

#include <graphics/rastport.h>
#include <graphics/text.h>
#include <graphics/gfxmacros.h>

/* intuition include's */

#include <intuition/intuition.h>
#include <intuition/classusr.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/pointerclass.h>
#include <intuition/icclass.h>
#include <intuition/cghooks.h>
#include <intuition/sghooks.h>

/* libraries include's */

#include <libraries/amigaguide.h>
#include <libraries/asl.h>
#include <libraries/commodities.h>
#include <libraries/gadtools.h>
#include <libraries/iffparse.h>
#include <libraries/locale.h>

/* dos include's */

#include <dos/dostags.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/exall.h>

/* diskfont include's */

#include <diskfont/diskfont.h>

/* prototype include's */

#include <clib/alib_protos.h>
#include <clib/alib_stdio_protos.h>
#include <clib/amigaguide_protos.h>
#include <clib/asl_protos.h>
#include <clib/commodities_protos.h>
#include <clib/console_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/icon_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/input_protos.h>
#include <clib/intuition_protos.h>
#include <clib/layers_protos.h>
#include <clib/locale_protos.h>
#include <clib/macros.h>
#include <clib/timer_protos.h>
#include <clib/utility_protos.h>
#include <clib/wb_protos.h>

#ifndef _DCC
#include <proto/all.h>
#endif

/* ---------------------------- xref include's ---------------------------- */

#include <libraries/xref.h>
#include <proto/xref.h>

/* ---------------------------- other includes ---------------------------- */

#include "//Goodies/extrdargs/extrdargs.h"

#include "//myinclude/register.h"
#include "//myinclude/debug.h"

