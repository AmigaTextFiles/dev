
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Texture2Transform
{
	APTR	WI_Texture2Transform;
	APTR	STR_DEFTexture2TransformName;
	APTR	STR_Texture2TransformTX;
	APTR	STR_Texture2TransformTY;
	APTR	STR_Texture2TransformRot;
	APTR	STR_Texture2TransformSX;
	APTR	STR_Texture2TransformSY;
	APTR	STR_Texture2TransformCenterX;
	APTR	STR_Texture2TransformCenterY;
	APTR	BT_Texture2TransformOk;
	APTR	BT_Texture2TransformDefault;
	APTR	BT_Texture2TransformCancel;
};

extern struct ObjWI_Texture2Transform * CreateWI_Texture2Transform(void);
extern void DisposeWI_Texture2Transform(struct ObjWI_Texture2Transform *);
