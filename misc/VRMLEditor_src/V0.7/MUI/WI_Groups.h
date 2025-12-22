
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Groups
{
	APTR	WI_Groups;
	APTR	STR_DEFGroupsName;
	APTR	CY_GroupsType;
	APTR	TX_GroupsNum;
	APTR	GR_GroupsLOD;
	APTR	TX_LODRangeIndex;
	APTR	PR_LODRangeIndex;
	APTR	STR_LODRange;
	APTR	BT_LODAdd;
	APTR	BT_LODDelete;
	APTR	STR_LODCenterX;
	APTR	STR_LODCenterY;
	APTR	STR_LODCenterZ;
	APTR	GR_GroupsSeparator;
	APTR	CY_SeparatorRenderCulling;
	APTR	GR_GroupsSwitch;
	APTR	STR_SwitchWhich;
	APTR	GR_GroupsWWWAnchor;
	APTR	STR_WWWAnchorName;
	APTR	STR_WWWAnchorDescription;
	APTR	CY_WWWAnchorMap;
	APTR	BT_GroupsOk;
	char *	STR_TX_GroupsNum;
	char *	STR_TX_LODRangeIndex;
	char *	CY_GroupsTypeContent[7];
	char *	CY_SeparatorRenderCullingContent[4];
	char *	CY_WWWAnchorMapContent[3];
};


extern struct ObjWI_Groups * CreateWI_Groups(void);
extern void DisposeWI_Groups(struct ObjWI_Groups *);
