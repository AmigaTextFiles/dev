#include <sps/sps_hook.h>

#include <sps/sps_types.h>
#include <sps/sps_exception.h>

#include <proto/exec.h>

SPS_Hook::SPS_Hook()
{
	m_Hook.h_Entry    = (HOOKFUNC)sHookEntry;
	m_Hook.h_SubEntry = NULL;
	m_Hook.h_Data     = this;
}

/*! the hook stub */
int32 SPS_Hook::sHookEntry(struct Hook* hook,APTR object, APTR message)
{
    _D( "SPS_Hook::HookEntry( e0x%08x )\n", hook->h_Data );
    int32 result = -1;
    try {
    	SPS_Hook *pHook = dynamic_cast<SPS_Hook*>((SPS_Hook*)hook->h_Data);
    	if (pHook)
    	{
            result = pHook->OnEntry(object,message);
    	}
    } catch ( ... ) {
        _D( "SPS_Hook::HookEntry( ) - cought an exception!\n" );
    }
    _D( "SPS_Hook::HookEntry( ) = %d\n", result );
	return result;;
}

