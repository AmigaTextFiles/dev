
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_WWWAnchor
{
	APTR	WI_WWWAnchor;
	APTR	STR_DEFWWWAnchorName;
	APTR	TX_WWWAnchorNum;
	APTR	STR_WWWAnchorName;
	APTR	STR_WWWAnchorDescription;
	APTR	CY_WWWAnchorMap;
	APTR	BT_WWWAnchorOk;
	char *	STR_TX_WWWAnchorNum;
	char *	CY_WWWAnchorMapContent[3];
};

extern struct ObjWI_WWWAnchor * CreateWI_WWWAnchor(void);
extern void DisposeWI_WWWAnchor(struct ObjWI_WWWAnchor *);
