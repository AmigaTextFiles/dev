
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Switch
{
	APTR	WI_Switch;
	APTR	STR_DEFSwitchName;
	APTR	TX_SwitchNum;
	APTR	STR_SwitchWhich;
	APTR	BT_SwitchOk;
	char *	STR_TX_SwitchNum;
};

extern struct ObjWI_Switch * CreateWI_Switch(void);
extern void DisposeWI_Switch(struct ObjWI_Switch *);
