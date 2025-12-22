/* ---------------------------------------------- */
/* BCC header. Inserted into every generated file */
/* ---------------------------------------------- */

#ifndef _BCC_EVERY
#define _BCC_EVERY

/* Includes necessary for every mui c code */

#include <proto/exec.h>
#include <proto/muimaster.h>
#include <libraries/mui.h>

#include <mui/muiextra.h>

#include <string.h>

/* defines that help adjusting to any compiler */

#ifdef _DCC
	#define REG(x) __ ## x
	#define ASM
	#define SAVEDS __geta4
#else
	#define REG(x) register __ ## x

	#ifdef _STORM

			#define ASM
			#define SAVEDS __saveds

	#else

		#if defined __MAXON__ || defined __GNUC__
			#define ASM
			#define SAVEDS
		#else
			#define ASM	__asm
			#define SAVEDS __saveds
		#endif
	
	#endif

#endif

#define CallSuper() DoSuperMethodA(cl, obj, msg)
#define value (tag->ti_Data)
#define GetData() INST_DATA(cl, obj)

#endif
struct MUI_CustomClass *MyApplication_Create( void );
struct MUI_CustomClass *MyClass_Create( void );
struct MUI_CustomClass *MyWindow_Create( void );

#include "initcl.h"

struct MUI_CustomClass *cl_MyApplication;
struct MUI_CustomClass *cl_MyClass;
struct MUI_CustomClass *cl_MyWindow;

short _initclasses( void )
{
	if( !(cl_MyApplication = MyApplication_Create()) ) goto error;
	if( !(cl_MyClass = MyClass_Create()) ) goto error;
	if( !(cl_MyWindow = MyWindow_Create()) ) goto error;

	return 1;
 error:
	_freeclasses();
	return 0;
}

void _freeclasses( void )
{
	MUI_DeleteCustomClass( cl_MyApplication );
	MUI_DeleteCustomClass( cl_MyClass );
	MUI_DeleteCustomClass( cl_MyWindow );
}
