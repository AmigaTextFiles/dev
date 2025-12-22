
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_ILS
{
	APTR	WI_ILS;
	APTR	STR_DEFILSName;
	APTR	TX_ILSNum;
	APTR	TX_ILSIndex;
	APTR	PR_ILSIndex;
	APTR	BT_ILSAddLine;
	APTR	BT_ILSDeleteLine;
	APTR	LV_ILSCoordIndex;
	APTR	BT_ILSAddPoint;
	APTR	BT_ILSDeletePoint;
	APTR	STR_ILSValue;
	APTR	LV_ILSMaterialIndex;
	APTR	BT_ILSAddMat;
	APTR	BT_ILSDeleteMat;
	APTR	STR_ILSMatValue;
	APTR	LV_ILSNormalIndex;
	APTR	BT_ILSAddNormal;
	APTR	BT_ILSDeleteNormal;
	APTR	STR_ILSNormalValue;
	APTR	LV_ILSTexIndex;
	APTR	BT_ILSAddTex;
	APTR	BT_ILSDeleteTex;
	APTR	STR_ILSTexValue;
	APTR	CH_ILSMat;
	APTR	CH_ILSNormal;
	APTR	CH_ILSTex;
	APTR	BT_ILSOk;
	APTR	BT_ILSCancel;
	char *	STR_TX_ILSNum;
	char *	STR_TX_ILSIndex;
};

extern struct ObjWI_ILS * CreateWI_ILS(void);
extern void DisposeWI_ILS(struct ObjWI_ILS *);
