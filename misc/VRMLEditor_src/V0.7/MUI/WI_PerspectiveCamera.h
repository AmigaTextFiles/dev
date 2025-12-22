
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_PerspectiveCamera
{
	APTR	WI_PerspectiveCamera;
	APTR	STR_DEFPerspectiveCameraName;
	APTR	BT_PerspectiveCameraView;
	APTR	BT_PerspectiveCameraGrab;
	APTR	STR_PerspectiveCameraX;
	APTR	STR_PerspectiveCameraY;
	APTR	STR_PerspectiveCameraZ;
	APTR	STR_PerspectiveCameraOX;
	APTR	STR_PerspectiveCameraOY;
	APTR	STR_PerspectiveCameraOZ;
	APTR	STR_PerspectiveCameraOAngle;
	APTR	STR_PerspectiveCameraFocal;
	APTR	STR_PerspectiveCameraHeight;
	APTR	BT_PerspectiveCameraOk;
	APTR	BT_PerspectiveCameraDefault;
	APTR	BT_PerspectiveCameraCancel;
};

extern struct ObjWI_PerspectiveCamera * CreateWI_PerspectiveCamera(void);
extern void DisposeWI_PerspectiveCamera(struct ObjWI_PerspectiveCamera *);
