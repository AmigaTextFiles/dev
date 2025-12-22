
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_MatrixTransform
{
	APTR	WI_MatrixTransform;
	APTR	STR_DEFMatrixTransformName;
	APTR	STR_MatrixTransform0;
	APTR	STR_MatrixTransform1;
	APTR	STR_MatrixTransform2;
	APTR	STR_MatrixTransform3;
	APTR	STR_MatrixTransform4;
	APTR	STR_MatrixTransform5;
	APTR	STR_MatrixTransform6;
	APTR	STR_MatrixTransform7;
	APTR	STR_MatrixTransform8;
	APTR	STR_MatrixTransform9;
	APTR	STR_MatrixTransform10;
	APTR	STR_MatrixTransform11;
	APTR	STR_MatrixTransform12;
	APTR	STR_MatrixTransform13;
	APTR	STR_MatrixTransform14;
	APTR	STR_MatrixTransform15;
	APTR	BT_MatrixTransformOk;
	APTR	BT_MatrixTransformDefault;
	APTR	BT_MatrixTransformCancel;
};

extern struct ObjWI_MatrixTransform * CreateWI_MatrixTransform(void);
extern void DisposeWI_MatrixTransform(struct ObjWI_MatrixTransform *);
