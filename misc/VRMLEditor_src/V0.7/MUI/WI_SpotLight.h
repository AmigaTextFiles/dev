
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_SpotLight
{
	APTR	WI_SpotLight;
	APTR	STR_DEFSpotLightName;
	APTR	CH_SpotLightOn;
	APTR	STR_SpotLightIntensity;
	APTR	STR_SpotLightR;
	APTR	STR_SpotLightG;
	APTR	STR_SpotLightB;
	APTR	STR_SpotLightX;
	APTR	STR_SpotLightY;
	APTR	STR_SpotLightZ;
	APTR	STR_SpotLightDirX;
	APTR	STR_SpotLightDirY;
	APTR	STR_SpotLightDirZ;
	APTR	STR_SpotLightDrop;
	APTR	STR_SpotLightCut;
	APTR	BT_SpotLightOk;
	APTR	BT_SpotLightDefault;
	APTR	BT_SpotLightCancel;
};

extern struct ObjWI_SpotLight * CreateWI_SpotLight(void);
extern void DisposeWI_SpotLight(struct ObjWI_SpotLight *);
