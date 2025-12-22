/* include appropriate files depending on the compiler used */

#if LATTICE
#include <stdio.h>
#include <ctype.h>
#include <exec/types.h>
#include <exec/exec.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include <graphics/view.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <proto/all.h>
#endif

/* for manx I use precompiled header files so nothing is needed here... */
