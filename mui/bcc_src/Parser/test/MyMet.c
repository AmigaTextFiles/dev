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
#include "MyClass.h"
#include <proto/graphics.h>

unsigned long mMyClassMyMet( struct IClass *cl, Object *obj, Msg msg )
{
 MyClassData *data = INST_DATA( cl, obj );
 /* UC Beg */


	short a = 0;
	a += 1;


 /* UC End */
return DoSuperMethodA( cl, obj, (Msg)msg );
}

unsigned long mMyClassMUIM_AskMinMax( struct IClass *cl, Object *obj, struct MUIP_AskMinMax* msg )
{
 MyClassData *data = INST_DATA( cl, obj );
 DoSuperMethodA( cl, obj, (Msg)msg );
 /* UC Beg */

	msg->MinMaxInfo->MinWidth  += 100;
	msg->MinMaxInfo->DefWidth  += 120;
	msg->MinMaxInfo->MaxWidth  += MBQ_MUI_MAXMAX;

	msg->MinMaxInfo->MinHeight += 40;
	msg->MinMaxInfo->DefHeight += 90;
	msg->MinMaxInfo->MaxHeight += MBQ_MUI_MAXMAX;


 /* UC End */

 return 0;
}

unsigned long mMyClassMUIM_Draw( struct IClass *cl, Object *obj, struct MUIP_Draw* msg )
{
 MyClassData *data = INST_DATA( cl, obj );
 DoSuperMethodA( cl, obj, (Msg)msg );
 /* UC Beg */


	if ( msg->flags & MADF_DRAWOBJECT ) {

		SetAPen( _rp( obj ), 1 );
		Move( _rp( obj ), _mleft( obj ), _mtop( obj ) );
		Draw( _rp( obj ), _mright( obj ), _mbottom( obj ) );

	}
	

 /* UC End */

 return 0;
}

unsigned long mMyClassOM_NEW( struct IClass *cl, Object *obj, Msg msg )
{
 MyClassData *data, _tdata;
 data = &_tdata;
 obj = (Object*)DoSuperNew( cl, obj,

		MUIA_Frame, MUIV_Frame_Button
,
 TAG_MORE, (unsigned long)msg->ops_AttrList,
 TAG_DONE );
 if( !obj ) return 0;
 data = INST_DATA( cl, obj );
 memcpy( data, &_tdata, sizeof( MyClassData ) );
 /* UC Beg */



 /* UC End */

 return (unsigned long)obj;
}
