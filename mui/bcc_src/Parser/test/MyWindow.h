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


	long MyVal;
	Object *myobj;
	
	
	
	
	
} MyWindowData;

/* Method Tags */
#define MUIM_MyWindow_WinMet 0xa88b0b85

#define MUIA_MyWindow_MyVal 0xa88b046e
#define MUIA_MyWindow_CustomAttr 0xa88bb394

extern struct MUI_CustomClass *cl_MyWindow;
#define MyWindowObject NewObject( cl_MyWindow->mcc_Class, NULL
struct MUI_CustomClass *MyWindow_Create( void );

