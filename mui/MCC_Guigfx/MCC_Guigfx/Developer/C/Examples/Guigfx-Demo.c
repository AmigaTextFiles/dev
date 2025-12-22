#include <stdlib.h>
#include <string.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/icon.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/asl.h>
#include <proto/utility.h>
#include <libraries/mui.h>
#include <dos/dos.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <clib/alib_protos.h>
#include <clib/muimaster_protos.h>
#include <clib/debug_protos.h>
#include <lib/mb_utils.h>
#include <pragmas/muimaster_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <mui/guigfx_mcc.h>

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif
#define REG(x) register __ ## x

#define SCALEMODEMASK(u,d,p,s) (((u)?GGSMF_SCALEUP:0)|((d)?GGSMF_SCALEDOWN:0)|((p)?GGSMF_KEEPASPECT_PICTURE:0)|((s)?GGSMF_KEEPASPECT_SCREEN:0))


/* program-specific definitions */
#define FILENAME_DEFAULT "Test.png"
#define FILENAME_HOTKEY 'f'
#define QUALITY_HOTKEY 'q'
#define QUALITY_DEFAULT MUIV_Guigfx_Quality_Low
#define SCALEUP_HOTKEY 'u'
#define SCALEUP_DEFAULT FALSE
#define SCALEDOWN_HOTKEY 'd'
#define SCALEDOWN_DEFAULT TRUE
#define TRANSMASK_HOTKEY 'm'
#define TRANSMASK_DEFAULT FALSE
#define TRANSCOLOR_HOTKEY 'c'
#define TRANSCOLOR_DEFAULT FALSE
#define TRANSRGB_HOTKEY 'r'
#define TRANSRGB_DEFAULT (0x0)
#define PICASPECT_DEFAULT TRUE
#define PICASPECT_HOTKEY 'a'
#define SCREENASPECT_DEFAULT TRUE
#define SCREENASPECT_HOTKEY 's'


/* local protos */
static BOOL __inline BuildApp(void);
static void __inline MainLoop(void);
static void __inline DestroyApp(void);
static APTR CreatePictureObject(STRPTR, LONG, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, LONG);
static __inline STRPTR TranslateQuality(LONG);
static __saveds __asm LONG NewPicHookFunc(REG(a1) STRPTR*);
static __saveds __asm LONG QualityHookFunc(REG(a1) LONG*);
static __saveds __asm LONG TransparencyHookFunc(void);
static __saveds __asm LONG ScalingHookFunc(void);


/* globals */
UBYTE VersionString[] = "$VER: GuigfxDemo V1.1 "__AMIGADATE__;
struct Library *MUIMasterBase;
LONG __stack = 12288;
APTR App, WI_Main, IM_Pic, ST_File, SL_Quality, TX_Quality, CM_ScaleUp, CM_ScaleDown, 
		CM_TransMask, CM_TransColor, CM_PicAspect, CM_ScreenAspect, GR_Img;

/* hooks */
static const struct Hook NewPicHook = {{NULL,NULL},(void*)(&NewPicHookFunc),NULL,NULL};
static const struct Hook QualityHook = {{NULL,NULL},(void*)(&QualityHookFunc),NULL,NULL};
static const struct Hook TransparencyHook = {{NULL,NULL},(void*)(&TransparencyHookFunc),NULL,NULL};
static const struct Hook ScalingHook = {{NULL,NULL},(void*)(&ScalingHookFunc),NULL,NULL};

/************************************************************************/
/*                              Code                                    */
/************************************************************************/

LONG main(void)
{
LONG rcode=RETURN_OK;

	KPrintf("Guigfx demo starts\n");
	if(MUIMasterBase = OpenLibrary("muimaster.library",18))
	{
		if(BuildApp())
		{
			MainLoop();
			DestroyApp();
		}
	} else
	{
		Printf("Guigfx-Demo: can't open muimaster.library V18!\n");
		rcode = RETURN_FAIL;
	}
	KPrintf("Guigfx demo ends\n");
	return rcode;
}

/************************************************************************/

static BOOL __inline BuildApp(void)
{
	KPrintf("Starting to build MUI object tree...");
	App = ApplicationObject,
		MUIA_Application_Title      , "Guigfx demo",
		MUIA_Application_Version    , VersionString,
		MUIA_Application_Copyright  , "1999-2000",
		MUIA_Application_Author     , "Matthias Bethke",
		MUIA_Application_Description, "Shows off Guigfx.mcc",
		MUIA_Application_Base       , "GGxD",
		SubWindow, WI_Main = WindowObject,
			MUIA_Window_Title, "Guigfx demo",
			MUIA_Window_ID, MAKE_ID('G','G','D','1'),
			WindowContents, VGroup,
				Child, HGroup,
					Child, ColGroup(2),
						GroupFrameT("Settings"),
						Child, KeyLabel2("Filename:",FILENAME_HOTKEY),
						Child, PopaslObject,
							MUIA_Popstring_Button, ImageObject,
								ImageButtonFrame,
								MUIA_InputMode, MUIV_InputMode_RelVerify,
								MUIA_Image_Spec, MUII_PopFile,
								MUIA_Background, MUII_ButtonBack,
								MUIA_ControlChar, 'f',
							End,
							MUIA_Popstring_String, ST_File = String(FILENAME_DEFAULT,200),
						End,

						Child, KeyLabel2("Quality:",QUALITY_HOTKEY),
						Child, HGroup,
							Child, SL_Quality = KeySlider(MUIV_Guigfx_Quality_Low,
																	MUIV_Guigfx_Quality_Best,
																	QUALITY_DEFAULT,
																	QUALITY_HOTKEY),
							Child, TX_Quality = TextObject,
								TextFrame,
								MUIA_Text_Contents, TranslateQuality(QUALITY_DEFAULT),
							End,
						End,

						Child, KeyLabel2("Scale up:",SCALEUP_HOTKEY),
						Child, HGroup,
							Child, CM_ScaleUp = KeyCheckMark(FALSE,SCALEUP_HOTKEY),
							Child, HSpace(0),
						End,

						Child, KeyLabel2("Scale down:",SCALEDOWN_HOTKEY),
						Child, HGroup,
							Child, CM_ScaleDown = KeyCheckMark(SCALEDOWN_DEFAULT,SCALEDOWN_HOTKEY),
							Child, HSpace(0),
						End,

						Child, KeyLabel1("Transp. Mask:",TRANSMASK_HOTKEY),
						Child, HGroup,
							Child, CM_TransMask = KeyCheckMark(TRANSMASK_DEFAULT,TRANSMASK_HOTKEY),
							Child, HSpace(0),
						End,

						Child, KeyLabel1("Transp. Color:",TRANSCOLOR_HOTKEY),
						Child, HGroup,
							Child, CM_TransColor = KeyCheckMark(TRANSCOLOR_DEFAULT,TRANSCOLOR_HOTKEY),
							Child, HSpace(0),
						End,

						Child, KeyLabel1("Fix aspect:",PICASPECT_HOTKEY),
						Child, HGroup,
							Child, CM_PicAspect = KeyCheckMark(PICASPECT_DEFAULT,PICASPECT_HOTKEY),
							Child, HSpace(0),
						End,

						Child, KeyLabel1("Use screen aspect:",SCREENASPECT_HOTKEY),
						Child, HGroup,
							Child, CM_ScreenAspect = KeyCheckMark(SCREENASPECT_DEFAULT,SCREENASPECT_HOTKEY),
							Child, HSpace(0),
						End,

						Child, VSpace(0),
						Child, VSpace(0),
					End,

					Child, GR_Img = VGroup,
						TextFrame,
						Child, VSpace(0),
						Child, IM_Pic = CreatePictureObject(FILENAME_DEFAULT,QUALITY_DEFAULT,
																		SCALEUP_DEFAULT,SCALEDOWN_DEFAULT,
																		PICASPECT_DEFAULT,SCREENASPECT_DEFAULT,
																		TRANSMASK_DEFAULT,TRANSCOLOR_DEFAULT,
																		TRANSRGB_DEFAULT),
						Child, VSpace(0),
					End,
				End,
			End,
		End,
	End;

	if(App)
	{
		// let closegadget quit app
		DoMethod(WI_Main, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, MUIV_Notify_Application,
					2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

		// load new image if requested
		DoMethod(ST_File, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, MUIV_Notify_Self,
					3, MUIM_CallHook, &NewPicHook, MUIV_TriggerValue);

		// call a hook for transparency changes
		DoMethod(CM_TransMask, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, MUIV_Notify_Self,
					2, MUIM_CallHook, &TransparencyHook);
		DoMethod(CM_TransColor, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, MUIV_Notify_Self,
					2, MUIM_CallHook, &TransparencyHook);

		// call a hook for scalemode changes
		DoMethod(CM_ScaleUp, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, MUIV_Notify_Self,
					2, MUIM_CallHook, &ScalingHook);
		DoMethod(CM_ScaleDown, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, MUIV_Notify_Self,
					2, MUIM_CallHook, &ScalingHook);
		DoMethod(CM_PicAspect, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, MUIV_Notify_Self,
					2, MUIM_CallHook, &ScalingHook);
		DoMethod(CM_ScreenAspect, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, MUIV_Notify_Self,
					2, MUIM_CallHook, &ScalingHook);

		// have slider call quality hook
		DoMethod(SL_Quality, MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime, MUIV_Notify_Self,
					3, MUIM_CallHook, &QualityHook, MUIV_TriggerValue);


		// set pr_WindowPtr
		get(WI_Main,MUIA_Window_Window,&(((struct Process*)FindTask(NULL))->pr_WindowPtr));

		KPrintf("succeeded!\n");
		return TRUE;
	} else Printf("Can't create application!\n");
	KPrintf("failed!\n");
	return FALSE;
}
/************************************************************************/

static void __inline DestroyApp()
{
	MUI_DisposeObject(App);
	KPrintf("Destroyed application object\n");
}

/************************************************************************/

static void __inline MainLoop(void)
{
ULONG sigs=0;

	set(WI_Main,MUIA_Window_Open,TRUE);

	KPrintf("Opened window, entering main loop\n");
	while(DoMethod(App,MUIM_Application_NewInput,&sigs) !=MUIV_Application_ReturnID_Quit)
	{
		if(sigs)
		{
			sigs = Wait(sigs | SIGBREAKF_CTRL_C);
			if(sigs & SIGBREAKF_CTRL_C) break;
		}
	}
	KPrintf("Left main loop\n");
}

/************************************************************************/
/*                             Hooks                                    */
/************************************************************************/

static __saveds __asm LONG NewPicHookFunc(REG(a1) STRPTR *s)
{
APTR pic;
LONG Quality, ScaleUp, ScaleDown, TransColor, TransMask, PicAspect, ScreenAspect, TransRGB=0;

	KPrintf("NewPicHookFunc() called\n");
	get(SL_Quality, MUIA_Slider_Level, &Quality);
	get(CM_ScaleUp, MUIA_Selected, &ScaleUp);
	get(CM_ScaleDown, MUIA_Selected, &ScaleDown);
	get(CM_PicAspect,MUIA_Selected,&PicAspect);
	get(CM_ScreenAspect,MUIA_Selected,&ScreenAspect);
	get(CM_TransMask, MUIA_Selected, &TransMask);
	get(CM_TransColor, MUIA_Selected, &TransColor);
	if(pic = CreatePictureObject(*s,Quality,ScaleUp,ScaleDown,PicAspect,ScreenAspect,TransColor,TransMask,TransRGB))
	{
		DoMethod(GR_Img,MUIM_Group_InitChange);
		DoMethod(GR_Img,OM_REMMEMBER,IM_Pic);
		MUI_DisposeObject(IM_Pic);
		DoMethod(GR_Img,OM_ADDMEMBER,IM_Pic=pic);
		DoMethod(GR_Img,MUIM_Group_ExitChange);
	} else DisplayBeep(NULL);
	KPrintf("NewPicHookFunc() ends\n");
	return 0;
}

/************************************************************************/

static __saveds __asm LONG QualityHookFunc(REG(a1) LONG *val)
{
	set(TX_Quality,MUIA_Text_Contents,TranslateQuality(*val));
	set(IM_Pic,MUIA_Guigfx_Quality,*val);
	KPrintf("Set quality to %ld\n",*val);
	return 0;
}

/************************************************************************/

static __saveds __asm LONG TransparencyHookFunc(void)
{
LONG Mask, Color;

	get(CM_TransMask,MUIA_Selected,&Mask);
	get(CM_TransColor,MUIA_Selected,&Color);
	set(IM_Pic,MUIA_Guigfx_Transparency,(Mask?GGTRF_MASK:0)|(Color?GGTRF_RGB:0));
	KPrintf("Set transparency to %sMask/%sColor\n",Mask?"":"No",Color?"":"No");
	return 0;
}

/************************************************************************/

static __saveds __asm LONG ScalingHookFunc(void)
{
LONG Up, Down, Pic, Screen;

	DoMethod(GR_Img,MUIM_Group_InitChange);
	get(CM_ScaleUp,MUIA_Selected,&Up);
	get(CM_ScaleDown,MUIA_Selected,&Down);
	get(CM_PicAspect,MUIA_Selected,&Pic);
	get(CM_ScreenAspect,MUIA_Selected,&Screen);
	set(IM_Pic,MUIA_Guigfx_ScaleMode,SCALEMODEMASK(Up,Down,Pic,Screen));
	DoMethod(GR_Img,MUIM_Group_ExitChange);
	KPrintf("Set scalemode to %sScaleUp/%sScaleDown\n",Up?"":"No",Down?"":"No");
	return 0;
}

/************************************************************************/
/*                        Other functions                               */
/************************************************************************/

static APTR CreatePictureObject( STRPTR Name,
											LONG Quality,
											BOOL ScaleUp,
											BOOL ScaleDown,
											BOOL PicAspect,
											BOOL ScreenAspect,
											BOOL TransMask,
											BOOL TransColor,
											LONG TransRGB)
{
	return GuigfxObject,
				MUIA_Guigfx_FileName, Name,
				MUIA_Guigfx_Quality, Quality,
				MUIA_Guigfx_ScaleMode,SCALEMODEMASK(ScaleUp,ScaleDown,PicAspect,ScreenAspect),
				MUIA_Guigfx_Transparency,(TransMask ? GGTRF_MASK:0) |
													(TransColor ? GGTRF_RGB : 0),
			End;
}

static __inline STRPTR TranslateQuality(LONG val)
{
static const STRPTR Qualities[] = {"Low","Medium","High","Best"};
	return Qualities[val];
}
