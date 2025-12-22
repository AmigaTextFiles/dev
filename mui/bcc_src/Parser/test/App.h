#ifndef APP_H
#define APP_H

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
#include <proto/exec.h>
#include <proto/muimaster.h>
#include <libraries/mui.h>
#include <proto/intuition.h>

typedef struct {


	Object *win, *up, *down, *left, *right, *trig, *cycle, *inf, *strig;
	Object *EJGup, *EJGdown, *EJGleft, *EJGright, *EJGtrig, *EJGstrig;
	Object *lup, *ldown, *lleft, *lright, *ltrig, *lstrig;
	Object *dval;

	STRPTR lastcont;
	ULONG lastval;
	UBYTE txbuf[ 20 ];

	
	

} AppData;

/* Method Tags */

#define MUIA_App_State 0x8161048e
#define MUIA_App_Port 0x816102a7

extern struct MUI_CustomClass *cl_App;
#define AppObject NewObject( cl_App->mcc_Class, NULL
struct MUI_CustomClass *App_Create( void );


#endif
