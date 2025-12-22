
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Translation
{
	APTR	WI_Translation;
	APTR	STR_DEFTranslationName;
	APTR	STR_TranslationX;
	APTR	STR_TranslationY;
	APTR	STR_TranslationZ;
	APTR	BT_TranslationOk;
	APTR	BT_TranslationDefault;
	APTR	BT_TranslationCancel;
};

extern struct ObjWI_Translation * CreateWI_Translation(void);
extern void DisposeWI_Translation(struct ObjWI_Translation *);
