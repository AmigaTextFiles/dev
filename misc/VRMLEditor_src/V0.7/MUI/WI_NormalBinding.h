
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_NormalBinding
{
	APTR	WI_NormalBinding;
	APTR	STR_DEFNormalBindingName;
	APTR	CY_NormalBindingValue;
	APTR	BT_NormalBindingOk;
	APTR	BT_NormalBindingCancel;
	char *	CY_NormalBindingValueContent[9];
};

extern struct ObjWI_NormalBinding * CreateWI_NormalBinding(void);
extern void DisposeWI_NormalBinding(struct ObjWI_NormalBinding *);
