#include <exec/types.h>
#include <functions.h>

ULONG CallHook( struct Hook *hook, void *object, ULONG command, ... )
{
	return CallHookPkt( hook, object, (void *)&command );
}
