
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Cylinder
{
	APTR	WI_Cylinder;
	APTR	STR_DEFCylinderName;
	APTR	STR_CylinderRadius;
	APTR	STR_CylinderHeight;
	APTR	CH_CylinderSides;
	APTR	CH_CylinderTop;
	APTR	CH_CylinderBottom;
	APTR	BT_CylinderOk;
	APTR	BT_CylinderDefault;
	APTR	BT_CylinderCancel;
};

extern struct ObjWI_Cylinder * CreateWI_Cylinder(void);
extern void DisposeWI_Cylinder(struct ObjWI_Cylinder *);
