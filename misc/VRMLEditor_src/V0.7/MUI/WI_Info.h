
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Info
{
	APTR	WI_Info;
	APTR	STR_DEFInfoName;
	APTR	STR_InfoString;
	APTR	BT_InfoOk;
	APTR	BT_InfoCancel;
};

extern struct ObjWI_Info * CreateWI_Info(void);
extern void DisposeWI_Info(struct ObjWI_Info *);
