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
#include "MyWindow.h"


#include "initcl.h"

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif


unsigned long mMyWindowOM_NEW( struct IClass *cl, Object *obj, struct opSet* msg )
{
 unsigned long _ret = 0;
 MyWindowData *data, _tdata;
 data = &_tdata;
 obj = (Object*)DoSuperNew( cl, obj,

			MUIA_Window_Title, (ULONG)"Koch: Project",
			MUIA_Window_ID, MAKE_ID('K', 'P', 'R', 'J'),
			WindowContents, GroupObject,
				MUIA_Background, MUII_WindowBack,
				Child, StringObject,
				End,
				Child, data->myobj = NewObject( cl_MyClass->mcc_Class, NULL,
				End,
			End

,
 TAG_MORE, (unsigned long)msg->ops_AttrList,
 TAG_DONE );
 if( !obj ) return 0;
 data = INST_DATA( cl, obj );
 memcpy( data, &_tdata, sizeof( MyWindowData ) );
 /* UC Beg */


 /* UC End */

 _ret = (unsigned long)obj;
OM_NEW_exit:
return _ret;
}

 unsigned long mMyWindowWinMet( struct IClass *cl, Object *obj, Msg msg )
{
 /* UC Beg */

/*	short a;
	a = 10;
*/
 MyWindowData *data = INST_DATA( cl, obj );

 if( data->myobj ) DisplayBeep( NULL );
 
 return 0;


 /* UC End */
}

void aMyWindowCustomAttrSet( struct IClass *cl, Object *obj, unsigned long val )
{
 MyWindowData *data = INST_DATA( cl, obj );
 /* UC Beg */


	DisplayBeep( val );


 /* UC End */
}

void aMyWindowCustomAttrGet( struct IClass *cl, Object *obj, unsigned long *store )
{
 MyWindowData *data = INST_DATA( cl, obj );
 /* UC Beg */


	*store = 2;


 /* UC End */
}
