/* Includes used by GUICreator */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <gadgets/textfield.h>
#include <graphics/gfxbase.h>
#include <intuition/icclass.h>
#include <intuition/gadgetclass.h>
#include <datatypes/pictureclass.h>

#ifdef __GNUC__
#include <proto/asl.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/alib.h>
#include <proto/utility.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>
#include <proto/gadtools.h>
#include <proto/datatypes.h>
#include <proto/intuition.h>
#include <proto/textfield.h>
#else
#include <clib/asl_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/utility_protos.h>
#include <clib/graphics_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/datatypes_protos.h>
#include <clib/intuition_protos.h>
#include <clib/textfield_protos.h>

#endif

#ifdef __MAXON__
#include <pragma/asl_lib.h>
#include <pragma/dos_lib.h>
#include <pragma/exec_lib.h>
#include <pragma/utility_lib.h>
#include <pragma/graphics_lib.h>
#include <pragma/diskfont_lib.h>
#include <pragma/gadtools_lib.h>
#include <pragma/datatypes_lib.h>
#include <pragma/intuition_lib.h>
#include <pragma/textfield_lib.h>
#endif

#ifdef __STORM__
#include <pragma/asl_lib.h>
#include <pragma/dos_lib.h>
#include <pragma/exec_lib.h>
#include <pragma/utility_lib.h>
#include <pragma/graphics_lib.h>
#include <pragma/diskfont_lib.h>
#include <pragma/gadtools_lib.h>
#include <pragma/datatypes_lib.h>
#include <pragma/intuition_lib.h>
#include <pragma/textfield_lib.h>
#endif

#ifdef _DCC
#include <pragmas/textfield_pragmas.h>
#endif

