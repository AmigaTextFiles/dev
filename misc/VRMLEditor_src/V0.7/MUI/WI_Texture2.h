
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Texture2
{
	APTR	WI_Texture2;
	APTR	STR_DEFTexture2Name;
	APTR	STR_Texture2Filename;
	APTR	CY_Texture2WrapS;
	APTR	CY_Texture2WrapT;
	APTR	STR_Texture2Width;
	APTR	STR_Texture2Height;
	APTR	STR_Texture2Component;
	APTR	BT_Texture2Ok;
	APTR	BT_Texture2Default;
	APTR	BT_Texture2Cancel;
	char *	CY_Texture2WrapSContent[3];
	char *	CY_Texture2WrapTContent[3];
};

extern struct ObjWI_Texture2 * CreateWI_Texture2(void);
extern void DisposeWI_Texture2(struct ObjWI_Texture2 *);
