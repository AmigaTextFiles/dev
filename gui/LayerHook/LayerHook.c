/*
** $VER: LayerHook.c 1.181 (19.3.95)
**
** Tests backfill hooks in screens
**
** (W) by Pierre Carrette & Walter Dörwald
*/

#include "ImageBackFill.h"

struct Screen *Scr;
struct Window *Win;

UBYTE PubName[] = "BackFillHookTest";

struct BackFillOptions Options =
{
	256,256,
	// !!! 0,0,
	TRUE,FALSE,
	0,0,
	TRUE
};

struct BackFillInfo BFInfo;

long main(int argc,char *argv[])
{
	static UWORD Pens[] = { (UWORD)~0 };
	LONG OldMode;

	if (argc<=1)
	{
		printf("Usage:\n"
		       "\t%s FILENAME/A",argv[0]);
		exit(5);
	}
	if (Scr = OpenScreenTags(NULL,SA_LikeWorkbench,TRUE,
	                              SA_Title        ,"Backfillhook Test - Break me to finish",
	                              SA_Interleaved  ,TRUE,
	                              SA_Overscan     ,OSCAN_TEXT,
	                              SA_Pens         ,Pens,
	                              SA_SharePens    ,TRUE,
	                              SA_PubName      ,PubName,
	                              TAG_DONE))
	{
		if (LoadBackgroundImage(&BFInfo,argc>1 ? argv[1] : "SYS:Prefs/Patterns/Pflaster",Scr,&Options))
		{
			if (Win = OpenWindowTags(NULL,
			                         WA_Left        ,0,
			                         WA_Top         ,Scr->BarHeight+1,
			                         WA_Width       ,Scr->Width,
			                         WA_Height      ,Scr->Height-Scr->BarHeight-1,
			                         WA_Flags       ,WFLG_BACKDROP|WFLG_BORDERLESS|WFLG_SIMPLE_REFRESH|WFLG_NOCAREREFRESH,
			                         WA_CustomScreen,Scr,
			                         WA_BackFill    ,&BFInfo,
			                         TAG_DONE))
			{
				PubScreenStatus(Scr,0L); /* Make Screen Public */
				OldMode = SetPubScreenModes(SHANGHAI);
				SetDefaultPubScreen(PubName);

				Wait(SIGBREAKF_CTRL_C);

				SetPubScreenModes(OldMode); /* Make WorkBench become Default Pub Screen again */
				SetDefaultPubScreen(NULL);

				while (!(PubScreenStatus(Scr,PSNF_PRIVATE)&0x1))
					Delay(50L);
				CloseWindow(Win);
			}
			UnloadBackgroundImage(&BFInfo);
		}
		while (!CloseScreen(Scr))
			Delay(50L);
	}
	return 0;
}
