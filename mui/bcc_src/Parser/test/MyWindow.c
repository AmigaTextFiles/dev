/* MyWindow class */

#include "MyWindow.h"

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
unsigned long mMyWindowWinMet( struct IClass *cl, Object *obj, Msg msg );
void aMyWindowCustomAttrSet( struct IClass *cl, Object *obj, unsigned long val );
void aMyWindowCustomAttrGet( struct IClass *cl, Object *obj, unsigned long *store );

static unsigned long mMyWindowOM_SET( struct IClass *cl, Object *obj, struct opSet *msg )
{
 MyWindowData *data = INST_DATA(cl, obj);
 struct TagItem *tags, *tag;
	for( tags = msg->ops_AttrList; tag = NextTagItem(&tags); ) {
		switch( tag->ti_Tag ) {
			case MUIA_MyWindow_MyVal: *((unsigned long*)&data->MyVal) = value; break;
			case MUIA_MyWindow_CustomAttr: aMyWindowCustomAttr( cl, obj, tag->ti_Data, BCC_SET ); break;
		}
	}
 return DoSuperMethodA( cl, obj, (Msg)msg );
}

static unsigned long mMyWindowOM_GET( struct IClass *cl, Object *obj, struct opGet *msg )
{
 MyWindowData *data = INST_DATA(cl, obj);
 ULONG tag = msg->opg_AttrID;
	switch( tag ) {
			case MUIA_MyWindow_MyVal: *msg->opg_Storage = (unsigned long)data->MyVal; break;
			case MUIA_MyWindow_CustomAttr: aMyWindowCustomAttrGet( cl, obj, msg->opg_Storage ); break;
	}
 return DoSuperMethodA( cl, obj, (Msg)msg );
}

static unsigned long SAVEDS ASM MyWindow_Dispatcher( REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg )
{
	switch( msg->MethodID ) {
		case MUIM_MyWindow_WinMet: return mMyWindowWinMet( cl, obj, (Msg)msg );
		case OM_SET: return mMyWindowOM_SET( cl, obj, (struct opSet*)msg );
		case OM_GET: return mMyWindowOM_GET( cl, obj, (struct opGet*)msg );
	}
	return( DoSuperMethodA( cl, obj, msg ) );
}

struct MUI_CustomClass *MyWindow_Create( void )
{
	return MUI_CreateCustomClass( NULL, MUIC_Window, NULL, sizeof( MyWindowData ), MyWindow_Dispatcher );
}
