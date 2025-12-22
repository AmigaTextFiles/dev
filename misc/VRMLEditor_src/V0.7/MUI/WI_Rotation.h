
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Rotation
{
	APTR	WI_Rotation;
	APTR	STR_DEFRotationName;
	APTR	STR_RotationX;
	APTR	STR_RotationY;
	APTR	STR_RotationZ;
	APTR	STR_RotationA;
	APTR	BT_RotationOk;
	APTR	BT_RotationDefault;
	APTR	BT_RotationCancel;
};

extern struct ObjWI_Rotation * CreateWI_Rotation(void);
extern void DisposeWI_Rotation(struct ObjWI_Rotation *);
