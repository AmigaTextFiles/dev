#include <utility/hooks.h>

void SetupHook( struct Hook *hook, ULONG (*c_function)(), void *userdata )
{
	extern ULONG HookEntry();

	hook->h_Entry = HookEntry;
	hook->h_SubEntry = c_function;
	hook->h_Data = userdata;
}
