
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Group
{
	APTR	WI_Group;
	APTR	STR_DEFGroupName;
	APTR	TX_GroupNum;
	APTR	BT_GroupOk;
	char *	STR_TX_GroupNum;
};

extern struct ObjWI_Group * CreateWI_Group(void);
extern void DisposeWI_Group(struct ObjWI_Group *);
