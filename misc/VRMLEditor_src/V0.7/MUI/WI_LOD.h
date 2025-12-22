
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_LOD
{
	APTR	WI_LOD;
	APTR	STR_DEFLODName;
	APTR	TX_LODNum;
	APTR	TX_LODRangeIndex;
	APTR	PR_LODRangeIndex;
	APTR	STR_LODRange;
	APTR	BT_LODAdd;
	APTR	BT_LODDelete;
	APTR	STR_LODCenterX;
	APTR	STR_LODCenterY;
	APTR	STR_LODCenterZ;
	APTR	BT_LODOk;
	char *	STR_TX_LODNum;
	char *	STR_TX_LODRangeIndex;
};

extern struct ObjWI_LOD * CreateWI_LOD(void);
extern void DisposeWI_LOD(struct ObjWI_LOD *);
