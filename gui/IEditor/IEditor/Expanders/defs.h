#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif
#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif
#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif
#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif
#ifndef PRAGMAS_EXEC_PRAGMAS_H
#include <pragmas/exec_pragmas.h>
#endif
#ifndef PRAGMAS_DOS_PRAGMAS_H
#include <pragmas/dos_pragmas.h>
#endif
#include <string.h>

#include "DEV_IE:Include/IEditor.h"
#include "DEV_IE:Include/expanders.h"
#include "DEV_IE:Include/expanders-protos.h"
#include "DEV_IE:Include/generatorlib.h"

extern const unsigned char      LibName[];
extern const unsigned char      LibId[];
extern struct ExecBase         *SysBase;

#ifdef BOOPSI_IEX
extern struct BOOPSIExp        *LibBase;
#else
extern struct Expander         *LibBase;
#endif

extern UBYTE                   *Desc;
