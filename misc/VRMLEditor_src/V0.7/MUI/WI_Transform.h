
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Transform
{
	APTR	WI_Transform;
	APTR	STR_DEFTransformName;
	APTR	STR_TTranslationX;
	APTR	STR_TTranslationY;
	APTR	STR_TTranslationZ;
	APTR	STR_TRotationX;
	APTR	STR_TRotationY;
	APTR	STR_TRotationZ;
	APTR	STR_TRotationA;
	APTR	STR_TScaleFX;
	APTR	STR_TScaleFY;
	APTR	STR_TScaleFZ;
	APTR	STR_TScaleOX;
	APTR	STR_TScaleOY;
	APTR	STR_TScaleOZ;
	APTR	STR_TScaleOA;
	APTR	STR_TCenterX;
	APTR	STR_TCenterY;
	APTR	STR_TCenterZ;
	APTR	BT_TransformOk;
	APTR	BT_TransformDefault;
	APTR	BT_TransformCancel;
};

extern struct ObjWI_Transform * CreateWI_Transform(void);
extern void DisposeWI_Transform(struct ObjWI_Transform *);
