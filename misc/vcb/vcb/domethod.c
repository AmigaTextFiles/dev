#include <intuition/classes.h>

ULONG CoerceMethodA( Class *class, Object *object, Msg msg )
{
	return CallHookPkt( &class->cl_Dispatcher, object, msg );
}

ULONG CoerceMethod( Class *class, Object *object, ULONG MethodID, ... )
{
	return CoerceMethodA( class, object, (Msg)&MethodID );
}

ULONG DoMethodA( Object *object, Msg msg )
{
	return CoerceMethodA( OCLASS( object ), object, msg );
}

ULONG DoMethod( Object *object, ULONG MethodID, ... )
{
	return DoMethodA( object, (Msg)&MethodID );
}

ULONG DoSuperMethodA( Class *class, Object *object, Msg msg )
{
	return CoerceMethodA( class->cl_Super, object, msg );
}

ULONG DoSuperMethod( Class *class, Object *object, ULONG MethodID, ... )
{
	return DoSuperMethodA( class, object, (Msg)&MethodID );
}
