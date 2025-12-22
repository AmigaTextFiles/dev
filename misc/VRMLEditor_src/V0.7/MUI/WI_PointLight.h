
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_PointLight
{
	APTR	WI_PointLight;
	APTR	STR_DEFPointLightName;
	APTR	CH_PointLightOn;
	APTR	STR_PointLightIntensity;
	APTR	STR_PointLightX;
	APTR	STR_PointLightY;
	APTR	STR_PointLightZ;
	APTR	STR_PointLightR;
	APTR	STR_PointLightG;
	APTR	STR_PointLightB;
	APTR	BT_PointLightOk;
	APTR	BT_PointLightDefault;
	APTR	BT_PointLightCancel;
};

extern struct ObjWI_PointLight * CreateWI_PointLight(void);
extern void DisposeWI_PointLight(struct ObjWI_PointLight *);
