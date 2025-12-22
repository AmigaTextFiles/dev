
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_MaterialBinding
{
	APTR	WI_MaterialBinding;
	APTR	STR_DEFMaterialBindingName;
	APTR	CY_MaterialBinding;
	APTR	BT_MaterialBindingOk;
	APTR	BT_MaterialBindingCancel;
	char *	CY_MaterialBindingContent[9];
};

extern struct ObjWI_MaterialBinding * CreateWI_MaterialBinding(void);
extern void DisposeWI_MaterialBinding(struct ObjWI_MaterialBinding *);
