/* @(#) pfcustom.c 98/01/26 1.3 */

#ifndef PF_USER_CUSTOM

/***************************************************************
** Call Custom Functions for pForth
**
** Create a file similar to this and compile it into pForth
** by setting -DPF_USER_CUSTOM="mycustom.c"
**
** Using this, you could, for example, call X11 from Forth.
** See "pf_cglue.c" for more information.
**
** Author: Phil Burk
** Copyright 1994 3DO, Phil Burk, Larry Polansky, David Rosenboom
**
** The pForth software code is dedicated to the public domain,
** and any third party may reproduce, distribute and modify
** the pForth software code or any derivative works thereof
** without any compensation or license.  The pForth software
** code is provided on an "as is" basis without any warranty
** of any kind, including, without limitation, the implied
** warranties of merchantability and fitness for a particular
** purpose and their equivalents under the laws of any jurisdiction.
**
***************************************************************/

#include <proto/exec.h>
#include <proto/dos.h>

#include "pf_all.h"

static cell_t Len0(char *AString);
static cell_t EXEC_SysBase();
static cell_t EXEC_DOSBase();
static cell_t CALL0(cell_t Func, cell_t LibBase);
static void  CALL0NR(cell_t Func, cell_t LibBase);
static cell_t CALL1(cell_t parm1, cell_t Func, cell_t LibBase);
static void  CALL1NR(cell_t parm1, cell_t Func, cell_t LibBase);
static cell_t CALL2(cell_t parm1, cell_t parm2, cell_t Func, cell_t LibBase);
static void  CALL2NR(cell_t parm1, cell_t parm2, cell_t Func, cell_t LibBase);
static cell_t CALL3(cell_t parm1, cell_t parm2, cell_t parm3, cell_t Func, cell_t LibBase);
static void  CALL3NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t Func, cell_t LibBase);
static cell_t CALL4(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t Func, cell_t LibBase);
static void  CALL4NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t Func, cell_t LibBase);
static cell_t CALL5(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t Func, cell_t LibBase);
static void  CALL5NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t Func, cell_t LibBase);
static cell_t CALL6(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t Func, cell_t LibBase);
static void  CALL6NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t Func, cell_t LibBase);
static cell_t CALL7(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t parm7, cell_t Func, cell_t LibBase);
static void  CALL7NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t parm7, cell_t Func, cell_t LibBase);
static cell_t CALL8(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t parm7, cell_t parm8, cell_t Func, cell_t LibBase);
static void  CALL8NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t parm7, cell_t parm8, cell_t Func, cell_t LibBase);

/****************************************************************
** Step 1: Put your own special glue routines here
**     or link them in from another file or library.
****************************************************************/
static cell_t Len0 ( char *AString )
{ return strlen(AString); }

static cell_t EXEC_SysBase()
{ return SysBase; }

static cell_t EXEC_DOSBase()
{ return DOSBase; }

static cell_t CALL0(cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL0(ULONG,LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL0NR(cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL0(void,LIBBASETYPEPTR,LibBase,Func,Generic); }

static cell_t CALL1(cell_t parm1, cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL1(ULONG,
    AROS_LCA(ULONG,parm1,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL1NR(cell_t parm1, cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL1(void,
    AROS_LCA(ULONG,parm1,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static cell_t CALL2(cell_t parm1, cell_t parm2, cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL2(ULONG,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL2NR(cell_t parm1, cell_t parm2, cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL2(void,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static cell_t CALL3(cell_t parm1, cell_t parm2, cell_t parm3, cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL3(ULONG,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL3NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL3(void,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static cell_t CALL4(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL4(ULONG,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL4NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL4(void,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static cell_t CALL5(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL5(ULONG,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    AROS_LCA(ULONG,parm5,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL5NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL5(void,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    AROS_LCA(ULONG,parm5,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static cell_t CALL6(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL6(ULONG,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    AROS_LCA(ULONG,parm5,D0),
    AROS_LCA(ULONG,parm6,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL6NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL6(void,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    AROS_LCA(ULONG,parm5,D0),
    AROS_LCA(ULONG,parm6,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static cell_t CALL7(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t parm7, cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL7(ULONG,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    AROS_LCA(ULONG,parm5,D0),
    AROS_LCA(ULONG,parm6,D0),
    AROS_LCA(ULONG,parm7,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL7NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t parm7, cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL7(void,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    AROS_LCA(ULONG,parm5,D0),
    AROS_LCA(ULONG,parm6,D0),
    AROS_LCA(ULONG,parm7,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static cell_t CALL8(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t parm7, cell_t parm8, cell_t Func, cell_t LibBase)
{ return AROS_LVO_CALL8(ULONG,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    AROS_LCA(ULONG,parm5,D0),
    AROS_LCA(ULONG,parm6,D0),
    AROS_LCA(ULONG,parm7,D0),
    AROS_LCA(ULONG,parm8,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

static void CALL8NR(cell_t parm1, cell_t parm2, cell_t parm3, cell_t parm4, cell_t parm5, cell_t parm6, cell_t parm7, cell_t parm8, cell_t Func, cell_t LibBase)
{ AROS_LVO_CALL8(void,
    AROS_LCA(ULONG,parm1,D0),
    AROS_LCA(ULONG,parm2,D0),
    AROS_LCA(ULONG,parm3,D0),
    AROS_LCA(ULONG,parm4,D0),
    AROS_LCA(ULONG,parm5,D0),
    AROS_LCA(ULONG,parm6,D0),
    AROS_LCA(ULONG,parm7,D0),
    AROS_LCA(ULONG,parm8,D0),
    LIBBASETYPEPTR,LibBase,Func,Generic); }

/****************************************************************
** Step 2: Create CustomFunctionTable.
**     Do not change the name of CustomFunctionTable!
**     It is used by the pForth kernel.
****************************************************************/

#ifdef PF_NO_GLOBAL_INIT
/******************
** If your loader does not support global initialization, then you
** must define PF_NO_GLOBAL_INIT and provide a function to fill
** the table. Some embedded system loaders require this!
** Do not change the name of LoadCustomFunctionTable()!
** It is called by the pForth kernel.
*/
#define NUM_CUSTOM_FUNCTIONS  (21)
CFunc0 CustomFunctionTable[NUM_CUSTOM_FUNCTIONS];

Err LoadCustomFunctionTable( void )
{
	CustomFunctionTable[0] = Len0;
	CustomFunctionTable[1] = EXEC_SysBase;
	CustomFunctionTable[2] = EXEC_DOSBase;
	CustomFunctionTable[3] = CALL0;
    CustomFunctionTable[4] = CALL0NR;
    CustomFunctionTable[5] = CALL1;
    CustomFunctionTable[6] = CALL1NR;
    CustomFunctionTable[7] = CALL2;
    CustomFunctionTable[8] = CALL2NR;
    CustomFunctionTable[9] = CALL3;
    CustomFunctionTable[10] = CALL3NR;
    CustomFunctionTable[11] = CALL4;
    CustomFunctionTable[12] = CALL4NR;
    CustomFunctionTable[13] = CALL5;
    CustomFunctionTable[14] = CALL5NR;
    CustomFunctionTable[15] = CALL6;
    CustomFunctionTable[16] = CALL6NR;
    CustomFunctionTable[17] = CALL7;
    CustomFunctionTable[18] = CALL7NR;
    CustomFunctionTable[19] = CALL8;
    CustomFunctionTable[20] = CALL8NR;
    
	return 0;
}
#else
/******************
** If your loader supports global initialization (most do.) then just
** create the table like this.
*/
void *CustomFunctionTable[] =
{
	(CFunc0) Len0,
	(CFunc0) EXEC_SysBase,
	(CFunc0) EXEC_DOSBase,
	(CFunc0) CALL0,
    (CFunc0) CALL0NR,
    (CFunc0) CALL1,
    (CFunc0) CALL1NR,
    (CFunc0) CALL2,
    (CFunc0) CALL2NR,
    (CFunc0) CALL3,
    (CFunc0) CALL3NR,
    (CFunc0) CALL4,
    (CFunc0) CALL4NR,
    (CFunc0) CALL5,
    (CFunc0) CALL5NR,
    (CFunc0) CALL6,
    (CFunc0) CALL6NR,
    (CFunc0) CALL7,
    (CFunc0) CALL7NR,
    (CFunc0) CALL8,
    (CFunc0) CALL8NR
};	
#endif

/****************************************************************
** Step 3: Add custom functions to the dictionary.
**     Do not change the name of CompileCustomFunctions!
**     It is called by the pForth kernel.
****************************************************************/

#if (!defined(PF_NO_INIT)) && (!defined(PF_NO_SHELL))
Err CompileCustomFunctions( void )
{
	Err err;
	int i = 0;
/* Compile Forth words that call your custom functions.
** Make sure order of functions matches that in LoadCustomFunctionTable().
** Parameters are: Name in UPPER CASE, Function, Index, Mode, NumParams
*/
	err = CreateGlueToC( "LEN0", i++, C_RETURNS_VALUE, 1 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "EXEC_SYSBASE", i++, C_RETURNS_VALUE, 0 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "EXEC_DOSBASE", i++, C_RETURNS_VALUE, 0 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL0", i++, C_RETURNS_VALUE, 2 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL0NR", i++, C_RETURNS_VOID, 2 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL1", i++, C_RETURNS_VALUE, 3 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL1NR", i++, C_RETURNS_VOID, 3 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL2", i++, C_RETURNS_VALUE, 4 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL2NR", i++, C_RETURNS_VOID, 4 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL3", i++, C_RETURNS_VALUE, 5 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL3NR", i++, C_RETURNS_VOID, 5 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL4", i++, C_RETURNS_VALUE, 6 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL4NR", i++, C_RETURNS_VOID, 6 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL5", i++, C_RETURNS_VALUE, 7 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL5NR", i++, C_RETURNS_VOID, 7 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL6", i++, C_RETURNS_VALUE, 8 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL6NR", i++, C_RETURNS_VOID, 8 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL7", i++, C_RETURNS_VALUE, 9 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL7NR", i++, C_RETURNS_VOID, 9 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL8", i++, C_RETURNS_VALUE, 10 );
	if( err < 0 ) return err;
	err = CreateGlueToC( "CALL8NR", i++, C_RETURNS_VOID, 10 );
	if( err < 0 ) return err;

	return 0;
}
#else
Err CompileCustomFunctions( void ) { return 0; }
#endif

/****************************************************************
** Step 4: Recompile using compiler option PF_USER_CUSTOM
**         and link with your code.
**         Then rebuild the Forth using "pforth -i system.fth"
**         Test:   10 Ctest0 ( should print message then '11' )
****************************************************************/

#endif  /* PF_USER_CUSTOM */

