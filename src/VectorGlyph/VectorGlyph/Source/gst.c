/*
**	GST.c
**
**	Copyright (C) 1997 by Bernardo Innocenti
**
**	This is a dummy source file used to make the Global Symbol Table
**	for VectorGlyphDemo.
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/execbase.h>
#include <dos/dos.h>
#include <graphics/gfxbase.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <utility/tagitem.h>

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>

#include "CompilerSpecific.h"
#include "Debug.h"

#include "VectorGlyphIClass.h"

/* Can't include this one in GST because it defines some inline functions
 * #include "BoopsiStubs.h"
 */
