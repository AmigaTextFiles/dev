
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_PointSet
{
	APTR	WI_PointSet;
	APTR	STR_DEFPointSetName;
	APTR	STR_PointSetStartIndex;
	APTR	STR_PointSetNumPoints;
	APTR	BT_PointSetOk;
	APTR	BT_PointSetDefault;
	APTR	BT_PointSetCancel;
};

extern struct ObjWI_PointSet * CreateWI_PointSet(void);
extern void DisposeWI_PointSet(struct ObjWI_PointSet *);
