
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_ShapeHints
{
	APTR	WI_ShapeHints;
	APTR	STR_DEFShapeHintsName;
	APTR	CY_ShapeHintsVertexOrdering;
	APTR	CY_ShapeHintsShapeType;
	APTR	CY_ShapeHintsFaceType;
	APTR	STR_ShapeHintsCreaseAngle;
	APTR	BT_ShapeHintsOk;
	APTR	BT_ShapeHintsDefault;
	APTR	BT_ShapeHintsCancel;
	char *	CY_ShapeHintsVertexOrderingContent[4];
	char *	CY_ShapeHintsShapeTypeContent[3];
	char *	CY_ShapeHintsFaceTypeContent[3];
};

extern struct ObjWI_ShapeHints * CreateWI_ShapeHints(void);
extern void DisposeWI_ShapeHints(struct ObjWI_ShapeHints *);
