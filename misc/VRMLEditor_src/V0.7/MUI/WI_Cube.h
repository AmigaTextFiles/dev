
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Cube
{
	APTR	WI_Cube;
	APTR	STR_DEFCubeName;
	APTR	STR_CubeWidth;
	APTR	STR_CubeHeight;
	APTR	STR_CubeDepth;
	APTR	BT_CubeOk;
	APTR	BT_CubeDefault;
	APTR	BT_CubeCancel;
};

extern struct ObjWI_Cube * CreateWI_Cube(void);
extern void DisposeWI_Cube(struct ObjWI_Cube *);
