
/*
** $Id: tip_include.h,v 1.2 1999/11/12 20:47:01 carlos Exp $
*/

/*** includes ***/

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <exec/memory.h>
#include <clib/alib_protos.h>
#include <clib/asl_protos.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/muimaster_protos.h>
#include <pragmas/muimaster_pragmas.h>
#include <libraries/gadtools.h>
#include <libraries/mui.h>
#include <libraries/locale.h>
#include <proto/locale.h>
#include <libraries/openurl.h>
#include <proto/openurl.h>

#include <clib/iffparse_protos.h>
#include <devices/clipboard.h>

#if MUIMASTER_VLATEST <= 14
#include <mui/mui33_mcc.h>
#endif

#include <mui/mui.h>

#define MYDEBUG 0
#include "debug.h"

#include "muiundoc.h"
//#include "//vapor/textinput/textinput_mcc.h"

