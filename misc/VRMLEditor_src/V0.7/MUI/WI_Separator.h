
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Separator
{
	APTR	WI_Separator;
	APTR	STR_DEFSeparatorName;
	APTR	TX_SeparatorNum;
	APTR	CY_SeparatorRenderCulling;
	APTR	BT_SeparatorOk;
	char *	STR_TX_SeparatorNum;
	char *	CY_SeparatorRenderCullingContent[4];
};

extern struct ObjWI_Separator * CreateWI_Separator(void);
extern void DisposeWI_Separator(struct ObjWI_Separator *);
