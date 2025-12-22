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
#include "MyApplication.h"
#include "MyWindow.h"

unsigned long mMyApplicationOM_NEW( struct IClass *cl, Object *obj, Msg msg )
{
 MyApplicationData *data, _tdata;
 data = &_tdata;
 obj = (Object*)DoSuperNew( cl, obj,

	MUIA_Application_Author, "Rafaî Mantiuk",
	MUIA_Application_Base, "KOCH",
	MUIA_Application_Title, "Koch",
	MUIA_Application_Version, "$VER: Koch 1.0 (1.1.97)",
	MUIA_Application_Copyright, "Copyright (c)1996, Rafaî Mantiuk",
	MUIA_Application_Description, "Koch's fractals.",
	MUIA_Application_HelpFile, "Koch.guide",

	SubWindow, data->win = MyWindowObject,
	End
,
 TAG_MORE, (unsigned long)msg->ops_AttrList,
 TAG_DONE );
 if( !obj ) return 0;
 data = INST_DATA( cl, obj );
 memcpy( data, &_tdata, sizeof( MyApplicationData ) );
 /* UC Beg */


	DoMethod( data->win, 
		MUIM_Notify,MUIA_Window_CloseRequest, TRUE,
		obj, 2, MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	set( data->win, MUIA_Window_Open, TRUE );


 /* UC End */

 return (unsigned long)obj;
}
