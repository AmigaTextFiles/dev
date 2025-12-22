#ifndef EXAMPLE_LIBINFO_H
#define EXAMPLE_LIBINFO_H

/* Programmheader

	Name:		libinfo.h
	Main:		example
	Versionstring:	$VER: libinfo.h 1.1 (26.09.2002)
	Author:		SDI
	Distribution:	Freeware
	Description:	the example library definition file

 1.0   25.06.00 : created that example library code
 1.1   26.09.02 : added MorphOS support and hooks test
*/

#include <dos/dos.h>
#include <exec/libraries.h>
#include <utility/hooks.h>
#include <SDI_compiler.h>

#define VERSION   1
#define REVISION  1
#define DATETXT	  "26.09.2002"
#define VERSTXT	  "1.1"

#define LIBNAME   "example.library"

#ifdef _M68060
  #define ADDTXT	" 060"
#elif defined(_M68040)
  #define ADDTXT	" 040"
#elif defined(_M68030)
  #define ADDTXT	" 030"
#elif defined(_M68020)
  #define ADDTXT	" 020"
#elif defined(__MORPHOS__)
  #define ADDTXT	" MorphOS"
#else
  #define ADDTXT	""
#endif

#define IDSTRING "example " VERSTXT " (" DATETXT ")" ADDTXT "\r\n"
/************************************************************************
*                    							*
*    SegList pointer definition						*
*                    							*
************************************************************************/

#if defined(_AROS)
  typedef struct SegList * SEGLISTPTR;
#elif defined(__VBCC__)
  typedef APTR SEGLISTPTR;
#else
  typedef BPTR SEGLISTPTR;
#endif

/************************************************************************
*                    							*
*    library base structure						*
*                    							*
************************************************************************/

/* This is the private structure. The official one does not contain all
the private fields! */
struct ExampleBaseP {
  struct Library         exb_LibNode;
  UWORD                  exb_Unused;       /* better alignment */
  ULONG                  exb_NumCalls;
  ULONG                  exb_NumHookCalls;

  struct ExecBase *      exb_SysBase;
  struct IntuitionBase * exb_IntuitionBase;
  struct UtilityBase *   exb_UtilityBase;
  SEGLISTPTR	         exb_SegList;
};

#if defined(BASE_GLOABL)
  extern struct ExecBase      * SysBase;
  extern struct IntuitionBase * IntuitionBase;
  extern struct UtilityBase   * UtilityBase;
  extern struct ExampleBase   * ExampleBase;
#elif defined(BASE_REDEFINE)
  #define SysBase       ExampleBase->exb_SysBase
  #define IntuitionBase ExampleBase->exb_IntuitionBase
  #define UtilityBase   ExampleBase->exb_UtilityBase
#endif

/************************************************************************
*                    							*
*    library accessable function					*
*                    							*
************************************************************************/

ASM(LONG) LIBex_TestRequest(REG(a0, UBYTE *title), REG(a1, UBYTE *body),
REG(a2, UBYTE *gadgets), REG(a6, struct ExampleBaseP *ExampleBase));

ASM(LONG) LIBex_TestRequest2A(REG(a0, STRPTR title), REG(a1, STRPTR body),
REG(a2, STRPTR gadgets), REG(a3, APTR args),
REG(a6, struct ExampleBaseP *ExampleBase));

ASM(ULONG) LIBex_TestRequest3(REG(a0, struct Hook *hook),
REG(a6, struct ExampleBaseP *ExampleBase));

#endif /* EXAMPLE_LIBINFO_H */
