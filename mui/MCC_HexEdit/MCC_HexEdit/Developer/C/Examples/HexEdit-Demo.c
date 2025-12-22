
#include <exec/memory.h>

#include <intuition/sghooks.h>
#include <libraries/iffparse.h>
#include <libraries/gadtools.h>
#include <libraries/mui.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/utility_protos.h>
#include <clib/dos_protos.h>
#include <clib/muimaster_protos.h>

#include <clib/alib_protos.h>

#ifdef __SASC
#include <pragmas/exec_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/muimaster_pragmas.h>
#endif

#include "/HexEdit/MUI/HexEdit_mcc.h"


/* $setver$ */
static const char VersionString[] = "$VER: HexEdit-Demo 1.0 " __AMIGADATE__ "©1998 Miloslaw Smyk";
#define VERSION  1
#define REVISION 0

#define SAMPLE_MEM_SIZE 507

UBYTE sample_mem[SAMPLE_MEM_SIZE];


/****************************************************************************/
/* Compiler Stuff                                                           */
/****************************************************************************/

#define REG(x) register __ ## x
#define ASM    __asm
#define SAVEDS __saveds


/****************************************************************************/
/* Global Vars                                                              */
/****************************************************************************/

LONG __stack = 12288;

struct Library *MUIMasterBase;
struct Library *GfxBase      ;
struct Library *IntuitionBase;
struct Library *UtilityBase  ;

extern struct Library *DOSBase;

struct MUI_CustomClass *CL_MainWindow ;

/****************************************************************************/
/* Misc Help Functions                                                      */
/****************************************************************************/

LONG xget(Object *obj,ULONG attribute)
{
	LONG x;
	get(obj,attribute,&x);
	return(x);
}

ULONG __stdargs DoSuperNew(struct IClass *cl,Object *obj,ULONG tag1,...)
{
	return(DoSuperMethod(cl,obj,OM_NEW,&tag1,NULL));
}


/****************************************************************************/
/* MainWindow class                                                         */
/****************************************************************************/


#define REGISTER_NR		31284

#define TAGBASE_THORGAL (TAG_USER | (REGISTER_NR << 16))

/*** Methods ***/

#define MW_METH TAGBASE_THORGAL + 0x1000

#define MUIM_MainWindow_Finish        MW_METH + 0x0001


struct MainWindow_Data
{
	Object *HexEdit;
	Object *prop;
};


ULONG MainWindow_Finish(struct IClass *cl,Object *obj,struct MUIP_MainWindow_Finish *msg)
{

	DoMethod((Object *)xget(obj,MUIA_ApplicationObject),MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	return(0);
}


ULONG MainWindow_New(struct IClass *cl,Object *obj,struct opSet *msg)
{
	Object *HexEdit;
	Object *prop;
	ULONG i;

	if (obj = (Object *)DoSuperNew(cl,obj,
			MUIA_Window_Title, "HexEdit-Demo Window",
			MUIA_Window_ID   , MAKE_ID('M','A','I','N'),
			MUIA_Window_UseRightBorderScroller, TRUE,
			MUIA_Window_SizeRight, TRUE,
			WindowContents, VGroup,
					Child, HGroup,
					Child, HexEdit = HexEditObject,
						VirtualFrame,
						MUIA_HexEdit_LowBound, sample_mem,
						MUIA_HexEdit_HighBound, sample_mem + SAMPLE_MEM_SIZE - 1,
						MUIA_HexEdit_BaseAddressOffset, -(LONG)sample_mem,
						MUIA_HexEdit_EditMode, TRUE,
						MUIA_HexEdit_SelectMode, MUIV_HexEdit_SelectMode_Byte,
//						MUIA_HexEdit_ColumnsPerLine, 6,
						MUIA_ShortHelp, "The example HexEdit object.",
						MUIA_CycleChain, 1,
					End,

					Child, prop = ScrollbarObject,
						MUIA_Prop_UseWinBorder, MUIV_Prop_UseWinBorder_Right,
					End,
				End,
				End,

			TAG_MORE, msg->ops_AttrList))
	{
		struct MainWindow_Data *data = INST_DATA(cl,obj);

		data->HexEdit = HexEdit;
		data->prop = prop;

		/* fill the mem with some example data */

		for(i = 0; i < SAMPLE_MEM_SIZE; i++)
			sample_mem[i] = i;

		set(data->HexEdit, MUIA_HexEdit_PropObject, data->prop);

		DoMethod(obj      ,MUIM_Notify,MUIA_Window_CloseRequest,TRUE ,obj,2,MUIM_MainWindow_Finish,0);

		return((ULONG)obj);
	}
	return(0);
}

SAVEDS ASM ULONG MainWindow_Dispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)
{

	switch (msg->MethodID)
	{
		case OM_NEW                 : return(MainWindow_New    (cl,obj,(APTR)msg));
		case MUIM_MainWindow_Finish : return(MainWindow_Finish (cl,obj,(APTR)msg));
	}

	return(DoSuperMethodA(cl,obj,msg));
}



/****************************************************************************/
/* Init/Exit Functions                                                      */
/****************************************************************************/

VOID ExitLibs(VOID)
{
	if (IntuitionBase) CloseLibrary(IntuitionBase);
	if (GfxBase      ) CloseLibrary(GfxBase      );
	if (UtilityBase  ) CloseLibrary(UtilityBase  );
	if (MUIMasterBase) CloseLibrary(MUIMasterBase);
}

BOOL InitLibs(VOID)
{
	MUIMasterBase = OpenLibrary("muimaster.library",11);
	UtilityBase   = OpenLibrary("utility.library"  ,36);
	GfxBase       = OpenLibrary("graphics.library" ,36);
	IntuitionBase = OpenLibrary("intuition.library",36);

	if (MUIMasterBase && UtilityBase && GfxBase && IntuitionBase)
		return(TRUE);

	ExitLibs();
	return(FALSE);
}

VOID ExitClasses(VOID)
{
	if (CL_MainWindow  ) MUI_DeleteCustomClass(CL_MainWindow  );
}

BOOL InitClasses(VOID)
{
	CL_MainWindow   = MUI_CreateCustomClass(NULL, MUIC_Window    , NULL, sizeof(struct MainWindow_Data  ), MainWindow_Dispatcher  );

	if(CL_MainWindow)
		return(TRUE);

	ExitClasses();
	return(FALSE);
}

/****************************************************************************/
/* Main Program                                                             */
/****************************************************************************/

/*int main(int argc,char *argv[])*/
void __stdargs __main(char *comline)
{
	extern struct WBStartup *_WBenchMsg;
	ULONG sigs=0;
	Object *app;
	Object *win;
	int msg;

	if (InitLibs())
	{
		if (InitClasses())
		{
			app = ApplicationObject,
				MUIA_Application_Title      , "HexEdit-Demo",
				MUIA_Application_Version    , VersionString,
				MUIA_Application_Copyright  , "©1998, Miloslaw Smyk / World Federation of Mad Hackers",
				MUIA_Application_Author     , "Miloslaw Smyk",
				MUIA_Application_Description, "An example for HexEdit class",
				MUIA_Application_Base       , "HED",
				MUIA_Application_Window     , win = NewObject(CL_MainWindow->mcc_Class,NULL,TAG_DONE),
				End;

			if (app)
			{
				if (_WBenchMsg)
					msg = 0;
				else
					msg = 0; //HandleArgs(win);

				if (!msg)
				{
					set(win,MUIA_Window_Open,TRUE);

					while (DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit)
					{
						if (sigs)
						{
							sigs = Wait(sigs | SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_E | SIGBREAKF_CTRL_F);

							/* quit when receiving break from console */
							if (sigs & SIGBREAKF_CTRL_C)
								break;

							/* deiconify & activate on ctrl-f just like the other prefs programs */
							if (sigs & SIGBREAKF_CTRL_F)
							{
								set(app,MUIA_Application_Iconified,FALSE);
								set(win,MUIA_Window_Open,TRUE);
							}
						}
					}

					set(win,MUIA_Window_Open,FALSE);
				}
				MUI_DisposeObject(app);
			}

			ExitClasses();
		}

		ExitLibs();
	}

}
