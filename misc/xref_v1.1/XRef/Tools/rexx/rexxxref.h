/*
** $PROJECT: rexxxref.library
**
** $VER: rexxxref.h 1.1 (08.01.95)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1995
** All Rights Reserved !
**
** $HISTORY:
**
** 08.01.95 : 001.001 : initial
*/

/* ------------------------------- includes ------------------------------- */

#include <dos/dos.h>
#include <dos/dosextens.h>
#include <exec/types.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <exec/lists.h>
#include <exec/execbase.h>
#include <clib/alib_protos.h>
#include <clib/alib_stdio_protos.h>
#include <string.h>
#include <dos.h>
#include <libraries/xref.h>

#include <rexx/rexxio.h>
#include <rexx/rxslib.h>
#include <rexx/errors.h>

#include <clib/macros.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/utility_protos.h>
#include <clib/xref_protos.h>
#include <clib/rexxsyslib_protos.h>

#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/xref_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>

/* --------------------------- include my stuff --------------------------- */

#include <register.h>
#include <debug.h>

#define ClassCall    LibCall

#include "protos.h"

/* ------------------------- RexxXRefBase structure -------------------------- */

struct RexxXRefBase
{
    struct Library               rxb_Lib;
    struct Library              *rxb_SysBase;
    struct Library              *rxb_DOSBase;
    struct Library              *rxb_IntuitionBase;
    struct Library              *rxb_UtilityBase;
    struct Library              *rxb_XRefBase;
    struct Library              *rxb_RexxSysBase;
    BPTR                         rxb_SegList;
};

/* ---------------------------- library bases ----------------------------- */

#define SysBase                 rxb->rxb_SysBase
#define DOSBase                 rxb->rxb_DOSBase
#define UtilityBase             rxb->rxb_UtilityBase
#define IntuitionBase           rxb->rxb_IntuitionBase
#define XRefBase                rxb->rxb_XRefBase
#define RexxSysBase             rxb->rxb_RexxSysBase

/* ------------------------ rexx function define's ------------------------ */

#define RXERR_NO_FREE_STORE         ERR10_003
#define RXERR_REQUIRED_ARG_MISSING  ERR10_017

enum
{
   FX_FUNCTIONNAME,
   FX_STRING,
   FX_CATEGORY,
   FX_LIMIT,
   FX_NOPATTERN,
   FX_NOCASE,
   FX_STEM
};

#define FX_MAX    FX_STEM

enum
{
   LX_FUNCTIONNAME,
   LX_FILE,
   LX_XREFPRI,
   LX_LOCK,
   LX_INDEX
};

#define LX_MAX    LX_INDEX

enum
{
   EX_FUNCTIONNAME,
   EX_CATEGORY,
   EX_FILE,
   EX_FORCE
};

#define EX_MAX    EX_FORCE


