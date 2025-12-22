
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Normal
{
	APTR	WI_Normal;
	APTR	STR_DEFNormalName;
	APTR	TX_NormalNum;
	APTR	TX_NormalIndex;
	APTR	PR_NormalIndex;
	APTR	STR_NormalX;
	APTR	STR_NormalY;
	APTR	STR_NormalZ;
	APTR	BT_NormalAdd;
	APTR	BT_NormalDelete;
	APTR	BT_NormalOk;
	APTR	BT_NormalCancel;
	char *	STR_TX_NormalNum;
	char *	STR_TX_NormalIndex;
};

extern struct ObjWI_Normal * CreateWI_Normal(void);
extern void DisposeWI_Normal(struct ObjWI_Normal *);
