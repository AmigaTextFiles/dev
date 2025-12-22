
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Prefs
{
	APTR	WI_Prefs;
	APTR	GR_PrefsRegister;
	APTR	STR_PrefsOutput;
	APTR	RA_PrefsType;
	APTR	CH_PrefsResolve;
	APTR	STR_PrefsConeResolution;
	APTR	STR_PrefsCylinderResolution;
	APTR	STR_PrefsSphereResolution;
	APTR	STR_PrefsR;
	APTR	STR_PrefsG;
	APTR	STR_PrefsB;
	APTR	PA_PrefsScreen;
	APTR	STR_PA_PrefsScreen;
	APTR	STR_PrefsAngle;
	APTR	STR_PrefsGZip;
	APTR	BT_PrefsUse;
	APTR	BT_PrefsSave;
	char *	STR_GR_PrefsRegister[4];
	char *	RA_PrefsTypeContent[3];
};

extern struct ObjWI_Prefs * CreateWI_Prefs(void);
extern void DisposeWI_Prefs(struct ObjWI_Prefs *);
