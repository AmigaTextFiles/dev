/* MyApplication class */

#include "MyApplication.h"

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
mMyApplicationOM_NEW( struct IClass *cl, Object *obj, Msg msg );

static unsigned long SAVEDS ASM MyApplication_Dispatcher( REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg )
{
	switch( msg->MethodID ) {
		case OM_NEW: return mMyApplicationOM_NEW( cl, obj, msg );
	}
	return( DoSuperMethodA( cl, obj, msg ) );
}

struct MUI_CustomClass *MyApplication_Create( void )
{
	return MUI_CreateCustomClass( NULL, MUIC_Application, NULL, sizeof( MyApplicationData ), MyApplication_Dispatcher );
}
