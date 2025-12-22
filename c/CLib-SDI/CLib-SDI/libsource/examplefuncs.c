#ifndef EXAMPLE_EXAMPLEFUNCS_C
#define EXAMPLE_EXAMPLEFUNCS_C

/* Programmheader

	Name:		examplefuncs.c
	Main:		example
	Versionstring:	$VER: examplefuncs.c 1.1 (21.09.2002)
	Author:		SDI
	Distribution:	Freeware
	Description:	the example library function file

 1.0   25.06.00 : created that example library code
 1.1   21.09.02 : added hook function
*/

#include <proto/example.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <SDI_compiler.h>
#define BASE_REDEFINE	/* either this or BASE_GLOBAL is active */
#include "libinfo.h"

/* this one shows how to call own library functions */
ASM(LONG) LIBex_TestRequest(REG(a0, UBYTE *title), REG(a1, UBYTE *body),
REG(a2, UBYTE *gadgets), REG(a6, struct ExampleBaseP *ExampleBase))
{
  return ex_TestRequest2A(title, body, gadgets, NULL);
}

/* this one shows how functions with variable argument lists are handled */
ASM(LONG) LIBex_TestRequest2A(REG(a0, STRPTR title), REG(a1, STRPTR body),
REG(a2, STRPTR gadgets), REG(a3, APTR args), REG(a6, struct ExampleBaseP *ExampleBase))
{
  struct EasyStruct estr;

  estr.es_StructSize   = sizeof(struct EasyStruct);
  estr.es_Flags        = NULL;
  estr.es_Title        = title;
  estr.es_TextFormat   = body;
  estr.es_GadgetFormat = gadgets;

  ++ExampleBase->exb_NumCalls;

  return EasyRequestArgs(NULL, &estr, NULL, args);
}

/* this one shows how to use callback hooks */
ASM(ULONG) LIBex_TestRequest3(REG(a0, struct Hook *hook),
REG(a6, struct ExampleBaseP *ExampleBase))
{
  return CallHookPkt(hook, "object a2", "param a1");
}

#endif /* EXAMPLE_EXAMPLEFUNCS_C */

