
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Add
{
	APTR	WI_Add;
	APTR	LV_AddNode;
	APTR	STR_AddNodeName;
	APTR	BT_AddOk;
	APTR	BT_AddCancel;
};

extern struct ObjWI_Add * CreateWI_Add(void);
extern void DisposeWI_Add(struct ObjWI_Add *);
