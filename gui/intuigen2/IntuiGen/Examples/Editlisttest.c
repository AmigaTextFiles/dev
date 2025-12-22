#include <stddef.h>
#include <stdlib.H>
#include <stdio.H>
#include <exec/exec.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/classusr.h>
#include <intuition/icclass.h>
#include <libraries/asl.h>
#include <libraries/commodities.h>
#include <rexx/storage.h>
#include <rexx/simplerexx.h>
#include <libraries/gadtools.h>
#include <workbench/startup.h>
#include <workbench/icon.h>
#include <utility/tagitem.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/alib_protos.h>
#include <clib/asl_protos.h>
#include <clib/commodities_protos.h>
#include <clib/dos_protos.h>
#include <clib/wb_protos.h>
#include <clib/icon_protos.h>
#include <clib/utility_protos.h>
#include <IntuiGen/EditList.h>


struct GTPKind {
    UBYTE *Name;
    struct Gadget * (*Create) (struct GTPKind *,struct Gadget *,struct GTControl *,struct GTRequest *,struct VisualInfo *);
    void (*Destroy) (struct GTPKind *,struct GTControl *,struct GTRequest *);
};

struct GTPKind LocalPKindList[] = {
    { "EditList",CreateEditListKind,0 },
    { 0,0,0 }
};

struct TextAttr TextAttributes0 =
{
	"topaz.font",
	TOPAZ_EIGHTY,
	NULL,
	FPF_ROMFONT
};

struct TagItem QuitTags[]=
{
	{  GT_Underscore,'_'  },
	{  TAG_DONE,0  }
};

struct NewGadget NewQuit=
{
	216,182,
	52,13,
	(UBYTE *)"Quit",
	&TextAttributes0,
	0,
	0,
	0,
	0
};

struct MessageHandler QuitEndGadgetUp =
{
	NULL,
	"EndGadgetUp",
	NULL,
	NULL
};

struct GTControl Quit =
{
	NULL,
	BUTTON_KIND,
	INITFROMDATA | STOREDATA,
	QuitTags,
	NULL,
	&NewQuit,
	NULL,
	&QuitEndGadgetUp,
	'',
	0,
	0,
	0,0,
	NULL,
	NULL,
	NULL,
	0,0,
	0,
	0,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem TestTags[] =
{
	{  GTPK_List, NULL  },
	{  GTPK_Remember, 0  },
	{  TAG_DONE, 0	}
};

struct NewGadget NewTest =
{
	26,18,
	195,153,
	"",
	&TextAttributes0,
	0,
	PLACETEXT_LEFT,
	NULL,
	NULL
};

struct GTControl Test =
{
	&Quit,
	"EditList",
	INITFROMDATA | STOREDATA | GTC_PSEUDOKIND,
	TestTags,
	NULL,
	&NewTest,
	NULL,
	NULL,
	'',
	0,
	0,
	0,0,
	NULL,
	NULL,
	NULL,
	0,0,
	0,
	0,
	GTLV_Selected,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem NewWindowTags[]=
{
	{  WA_Left, 21	},
	{  WA_Top, 15  },
	{  WA_InnerWidth, 304  },
	{  WA_InnerHeight, 193	},
	{  WA_IDCMP,
		IDCMP_GADGETUP	},
	{  WA_Title, "Test Edit"  },
	{  WA_MinWidth, 310  },
	{  WA_MinHeight, 206  },
	{  WA_MaxWidth, 310  },
	{  WA_MaxHeight, 206  },
	{  WA_AutoAdjust, 1  },
	{  WA_Flags,
		WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SMART_REFRESH | WFLG_ACTIVATE  }
};


struct GTMenuInfo ReqGTMenuInfo[] =
{
	{ 0, 0 }
};

struct GTRequest Req =
{
	NewWindowTags,
	NULL,		/* Window */
	NULL,		    /* Menus */
	ReqGTMenuInfo,		/* MenuInfo */
	&Test,		/* Controls */
	INITFROMDATA | STOREDATA,		/* Flags */
	NULL,		/* RequestTags */
	NULL,		/* Borders */
	NULL,		/* Images */
	NULL,		/* ITexts */
	NULL,		/* InitFunc */
	0,
	NULL,
	NULL,		/* DataStruct */
	NULL,		/* EndFunction */
	NULL,		/* LoopFunction */
	0,0,		/* CallLoop, LoopBitsUsed */
	0,0,		/* AdditionalSignals, SignalFunction */
	NULL,		/* LocalMsgClassList */
	LocalPKindList, 	  /* LocalPKindClassList */
	NULL,		/* MsgHandlerList */
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

main()
{
    struct Remember *key=0;
    struct List l;

    TestTags[0].ti_Data=&l;
    TestTags[1].ti_Data=&key;

    NewList(&l);

    GTRequest(&Req);

    FreeRemember(&key,1);
    return 0;
}

