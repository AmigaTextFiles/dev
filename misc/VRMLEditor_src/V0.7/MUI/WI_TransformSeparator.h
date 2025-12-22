
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_TransformSeparator
{
	APTR	WI_TransformSeparator;
	APTR	STR_DEFTransformSeparatorName;
	APTR	TX_TransformSeparatorNum;
	APTR	BT_TransformSeparatorOk;
	char *	STR_TX_TransformSeparatorNum;
};

extern struct ObjWI_TransformSeparator * CreateWI_TransformSeparator(void);
extern void DisposeWI_TransformSeparator(struct ObjWI_TransformSeparator *);
