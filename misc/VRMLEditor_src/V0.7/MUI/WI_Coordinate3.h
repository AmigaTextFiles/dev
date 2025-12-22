
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Coordinate3
{
	APTR	WI_Coordinate3;
	APTR	STR_DEFCoordinate3Name;
	APTR	TX_Coordinate3Num;
	APTR	TX_Coordinate3Index;
	APTR	PR_Coordinate3Index;
	APTR	STR_Coordinate3X;
	APTR	STR_Coordinate3Y;
	APTR	STR_Coordinate3Z;
	APTR	BT_Coordinate3Add;
	APTR	BT_Coordinate3Delete;
	APTR	BT_Coordinate3Ok;
	APTR	BT_Coordinate3Cancel;
	char *	STR_TX_Coordinate3Num;
	char *	STR_TX_Coordinate3Index;
};

extern struct ObjWI_Coordinate3 * CreateWI_Coordinate3(void);
extern void DisposeWI_Coordinate3(struct ObjWI_Coordinate3 *);
