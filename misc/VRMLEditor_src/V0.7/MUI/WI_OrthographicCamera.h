
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_OrthographicCamera
{
	APTR	WI_OrthographicCamera;
	APTR	STR_DEFOrthographicCameraName;
	APTR	BT_OrthographicCameraView;
	APTR	BT_OrthographicCameraGrab;
	APTR	STR_OrthographicCameraPosX;
	APTR	STR_OrthographicCameraPosY;
	APTR	STR_OrthographicCameraPosZ;
	APTR	STR_OrthographicCameraOX;
	APTR	STR_OrthographicCameraOY;
	APTR	STR_OrthographicCameraOZ;
	APTR	STR_OrthographicCameraOAngle;
	APTR	STR_OrthographicCameraFocal;
	APTR	STR_OrthographicCameraHeight;
	APTR	BT_OrthographicCameraOk;
	APTR	BT_OrthographicCameraDefault;
	APTR	BT_OrthographicCameraCancel;
};

extern struct ObjWI_OrthographicCamera * CreateWI_OrthographicCamera(void);
extern void DisposeWI_OrthographicCamera(struct ObjWI_OrthographicCamera *);
