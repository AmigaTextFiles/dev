
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_IFS
{
	APTR	WI_IFS;
	APTR	STR_DEFIFSName;
	APTR	TX_IFSNum;
	APTR	TX_IFSIndex;
	APTR	PR_IFSIndex;
	APTR	BT_IFSAddFace;
	APTR	BT_IFSDeleteFace;
	APTR	LV_IFSCoordIndex;
	APTR	BT_IFSAddPoint;
	APTR	BT_IFSDeletePoint;
	APTR	STR_IFSValue;
	APTR	LV_IFSMaterialIndex;
	APTR	BT_IFSAddMat;
	APTR	BT_IFSDeleteMat;
	APTR	STR_IFSMatValue;
	APTR	LV_IFSNormalIndex;
	APTR	BT_IFSAddNormal;
	APTR	BT_IFSDeleteNormal;
	APTR	STR_IFSNormalValue;
	APTR	LV_IFSTexIndex;
	APTR	BT_IFSAddTex;
	APTR	BT_IFSDeleteTex;
	APTR	STR_IFSTexValue;
	APTR	CH_IFSMat;
	APTR	CH_IFSNormal;
	APTR	CH_IFSTex;
	APTR	BT_IFSOk;
	APTR	BT_IFSCancel;
	char *	STR_TX_IFSNum;
	char *	STR_TX_IFSIndex;
};

extern struct ObjWI_IFS * CreateWI_IFS(void);
extern void DisposeWI_IFS(struct ObjWI_IFS *);
