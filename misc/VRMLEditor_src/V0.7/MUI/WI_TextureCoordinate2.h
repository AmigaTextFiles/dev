
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_TextureCoordinate2
{
	APTR	WI_TextureCoordinate2;
	APTR	STR_DEFTextureCoordinate2Name;
	APTR	TX_TextureCoordinate2Num;
	APTR	TX_TextureCoordinate2Index;
	APTR	PR_TextureCoordinate2Index;
	APTR	STR_TextureCoordinate2X;
	APTR	STR_TextureCoordinate2Y;
	APTR	BT_TextureCoordinate2Add;
	APTR	BT_TextureCoordinate2Delete;
	APTR	BT_TextureCoordinate2Ok;
	APTR	BT_TextureCoordinate2Cancel;
	char *	STR_TX_TextureCoordinate2Num;
	char *	STR_TX_TextureCoordinate2Index;
};

extern struct ObjWI_TextureCoordinate2 * CreateWI_TextureCoordinate2(void);
extern void DisposeWI_TextureCoordinate2(struct ObjWI_TextureCoordinate2 *);
