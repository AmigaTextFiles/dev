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
#include "Test.h"




unsigned long mTestBlee( struct IClass *cl, Object *obj, Msg msg )
{
 unsigned long _ret = 1;
 TestData *data = INST_DATA( cl, obj );
 /* UC Beg */

	data->p = (data->p);
	
	DoMethod( data->next, BOPM_Test_Blee , 20, 60, 13 );

 /* UC End */
Blee_exit:
return _ret;
}

/* BOP - Test class dispatcher */

unsigned long mTestBlee( struct IClass *cl, Object *obj, Msg msg );

static unsigned long mTestOM_SET( struct IClass *cl, Object *obj, struct opSet *msg )
{
 TestData *data = INST_DATA(cl, obj);
 struct TagItem *tags, *tag;
	for( tags = msg->ops_AttrList; tag = NextTagItem(&tags); ) {
		switch( tag->ti_Tag ) {
			case BOPA_Test_next: *((unsigned long*)&data->next) = value; break;
		}
	}
 return DoSuperMethodA( cl, obj, (Msg)msg );
}

static unsigned long mTestOM_GET( struct IClass *cl, Object *obj, struct opGet *msg )
{
 TestData *data = INST_DATA(cl, obj);
 ULONG tag = msg->opg_AttrID;
	switch( tag ) {
			case BOPA_Test_next: *msg->opg_Storage = (unsigned long)data->next; break;
	}
 return DoSuperMethodA( cl, obj, (Msg)msg );
}

static unsigned long SAVEDS ASM Test_Dispatcher( REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg )
{
	switch( msg->MethodID ) {
		case BOPM_Test_Blee: return mTestBlee( cl, obj, (Msg)msg );
		case OM_SET: return mTestOM_SET( cl, obj, (struct opSet*)msg );
		case OM_GET: return mTestOM_GET( cl, obj, (struct opGet*)msg );
	}
	return( DoSuperMethodA( cl, obj, msg ) );
}

struct IClass *Test_Create( void )
{
struct IClass *cl;
	if( cl = MakeClass( NULL, "rootclass", NULL, sizeof( TestData ), 0 ) ) {
		cl->cl_Dispatcher.h_Entry = (ULONG (*)())Test_Dispatcher;
		cl->cl_Dispatcher.h_SubEntry = NULL;
		return cl;
	}
	return 0;
}
