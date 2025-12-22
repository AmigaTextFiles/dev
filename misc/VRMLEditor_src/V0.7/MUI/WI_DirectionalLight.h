
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_DirectionalLight
{
	APTR	WI_DirectionalLight;
	APTR	STR_DEFDirectionalLightName;
	APTR	CH_DirectionalLightOn;
	APTR	STR_DirectionalLightIntensity;
	APTR	STR_DirectionalLightR;
	APTR	STR_DirectionalLightG;
	APTR	STR_DirectionalLightB;
	APTR	STR_DirectionalLightX;
	APTR	STR_DirectionalLightY;
	APTR	STR_DirectionalLightZ;
	APTR	BT_DirectionalLightOk;
	APTR	BT_DirectionalLightDefault;
	APTR	BT_DirectionalLightCancel;
};

extern struct ObjWI_DirectionalLight * CreateWI_DirectionalLight(void);
extern void DisposeWI_DirectionalLight(struct ObjWI_DirectionalLight *);
