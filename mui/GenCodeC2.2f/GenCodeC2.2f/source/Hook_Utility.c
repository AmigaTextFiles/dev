#include "Hook_Utility.h"

#ifdef __GNUC__

static APTR Function_Hook(void)
{
	register struct Hook *a0 __asm("a0");
	register APTR a2 __asm("a2");
	register APTR a1 __asm("a1");
	register APTR a4 __asm("a4");
	
	a4=(APTR)a0->h_MinNode.mln_Succ;

	return ((proto_c_function)a0->h_SubEntry)(a0,a2,a1);
}

void InstallHook(struct Hook *hook, proto_c_function c_function, APTR Data)
{
	register APTR a4 __asm("a4");
	struct MinNode null_node;
	
	null_node.mln_Succ=(struct MinNode*)a4;
	null_node.mln_Pred=NULL;

	hook->h_MinNode = null_node;
	hook->h_Entry = (ULONG (*)()) Function_Hook;
	hook->h_SubEntry = (ULONG (*)())c_function;
	hook->h_Data = Data;
}

#else

#include <dos.h>

static APTR __asm Function_Hook(register __a0 struct Hook *hook,
								  register __a2 APTR		object,
								  register __a1 APTR		message)
{
	putreg(REG_A4,(long)hook->h_MinNode.mln_Succ);
	
	return(((proto_c_function)hook->h_SubEntry)(hook,object,message));
}

void InstallHook(struct Hook *hook, proto_c_function c_function, APTR Data)
{
	struct MinNode null_node;
	
	null_node.mln_Succ=(struct MinNode*)getreg(REG_A4);
	null_node.mln_Pred=NULL;

	hook->h_MinNode = null_node;
	hook->h_Entry = (ULONG (*)()) Function_Hook;
	hook->h_SubEntry = (ULONG (*)())c_function;
	hook->h_Data = Data;
}


#endif /* __GNUC__ */


