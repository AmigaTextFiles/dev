#include <exec/types.h>
#include <utility/hooks.h>
#include <clib/alib_protos.h>

VOID SetupHook( struct Hook *hook, ULONG (*c_function)(), VOID *userdata )
{
	extern ULONG HookEntry();

	hook->h_Entry = HookEntry;
	hook->h_SubEntry = c_function;
	hook->h_Data = userdata;
}
