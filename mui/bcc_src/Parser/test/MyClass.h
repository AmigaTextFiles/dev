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
typedef struct {


	short a;
	long i;
	
	

} MyClassData;

/* Method Tags */
#define MUIM_MyClass_MyMet 0x966305e3


extern struct MUI_CustomClass *cl_MyClass;
#define MyClassObject NewObject( cl_MyClass->mcc_Class, NULL

