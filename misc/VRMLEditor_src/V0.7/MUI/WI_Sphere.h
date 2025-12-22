
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Sphere
{
	APTR	WI_Sphere;
	APTR	STR_DEFSphereName;
	APTR	STR_SphereRadius;
	APTR	BT_SphereOk;
	APTR	BT_SphereDefault;
	APTR	BT_SphereCancel;
};

extern struct ObjWI_Sphere * CreateWI_Sphere(void);
extern void DisposeWI_Sphere(struct ObjWI_Sphere *);
