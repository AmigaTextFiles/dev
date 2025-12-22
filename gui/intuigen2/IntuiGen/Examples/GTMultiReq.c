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

#include <IntuiGen/GTRequest.h>

struct GTReqSet {
    struct List List;
    struct MsgPort *MsgPort;
};

void Click(struct GTRequest *req,struct IntuiMessage *msg,
			 struct GTControl *gtc,struct MessageHandler *mh)
{
    puts(gtc->NewGadget->ng_GadgetText);
}

void mCloseWindow(struct GTRequest *req,struct IntuiMessage *msg,
			struct GTControl *gtc,struct MessageHandler *mh)
{
    EndGTRequest(req,1,mh,gtc);
}

struct NewMenu Req1Menus[] =
{
	{ NM_TITLE, "Project1", 0, 0, 0, 0 },
	{  NM_ITEM, "Open1", 0, NULL, 0, 0 },
	{  NM_ITEM, "Close1", 0, NULL, 0, 0 },
	{ NM_END, NULL, 0, 0, 0, 0 }
};

struct TextAttr TextAttributes0 =
{
	"topaz.font",
	TOPAZ_EIGHTY,
	NULL,
	FPF_ROMFONT
};

struct TagItem Click1Tags[]=
{
	{  GT_Underscore,'_'  },
	{  TAG_DONE,0  }
};

struct NewGadget NewClick1=
{
	23,19,
	68,13,
	(UBYTE *)"Click1",
	&TextAttributes0,
	0,
	0,
	0,
	0
};

struct MessageHandler Click1GadgetUpMH =
{
	NULL,
	"GadgetUp",
	NULL,
	Click
};

struct GTControl Click1 =
{
	NULL,
	BUTTON_KIND,
	INITFROMDATA | STOREDATA,
	Click1Tags,
	NULL,
	&NewClick1,
	NULL,
	&Click1GadgetUpMH,
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

struct TagItem NewWin1Tags[]=
{
	{  WA_Left, 84	},
	{  WA_Top, 64  },
	{  WA_InnerWidth, 117  },
	{  WA_InnerHeight, 44  },
	{  WA_IDCMP,
		IDCMP_GADGETUP | IDCMP_CLOSEWINDOW | IDCMP_MENUPICK  },
	{  WA_Title, "Window 1"  },
	{  WA_MinWidth, 123  },
	{  WA_MinHeight, 57  },
	{  WA_MaxWidth, 123  },
	{  WA_MaxHeight, 57  },
	{  WA_AutoAdjust, 1  },
	{  WA_Flags,
		WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH |
	WFLG_ACTIVATE  }
};

void Open1(struct GTRequest *req,struct IntuiMessage *msg)
{
    puts("Open1");
}

void Close1(struct GTRequest *req,struct IntuiMessage *msg)
{
    puts("Close1");
}

struct GTMenuInfo Req1GTMenuInfo[] =
{
	{ 0 | (0 << 5) | (63 << 11), Open1 },
	{ 0 | (1 << 5) | (63 << 11), Close1 },
	{ 0, 0 }
};

struct MessageHandler Req1CloseWindowMH =
{
	NULL,
	"CloseWindow",
	NULL,
	mCloseWindow
};

struct GTRequest Req1 =
{
	NewWin1Tags,
	NULL,		/* Window */
	Req1Menus,		/* Menus */
	Req1GTMenuInfo, 	/* MenuInfo */
	&Click1,		/* Controls */
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
	NULL,		/* LocalPKindCassList */
	&Req1CloseWindowMH, /* MsgHandlerList */
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

struct NewMenu Req2Menus[] =
{
	{ NM_TITLE, "Project2", 0, 0, 0, 0 },
	{  NM_ITEM, "Open2", 0, NULL, 0, 0 },
	{  NM_ITEM, "Close2", 0, NULL, 0, 0 },
	{ NM_END, NULL, 0, 0, 0, 0 }
};

struct TagItem Click2Tags[]=
{
	{  GT_Underscore,'_'  },
	{  TAG_DONE,0  }
};

struct NewGadget NewClick2=
{
	41,22,
	68,13,
	(UBYTE *)"Click2",
	&TextAttributes0,
	0,
	0,
	0,
	0
};

struct MessageHandler Click2GadgetUpMH =
{
	NULL,
	"GadgetUp",
	NULL,
	Click
};

struct GTControl Click2 =
{
	NULL,
	BUTTON_KIND,
	INITFROMDATA | STOREDATA,
	Click2Tags,
	NULL,
	&NewClick2,
	NULL,
	&Click2GadgetUpMH,
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

struct TagItem Newwin2Tags[]=
{
	{  WA_Left, 365  },
	{  WA_Top, 145	},
	{  WA_InnerWidth, 138  },
	{  WA_InnerHeight, 49  },
	{  WA_IDCMP,
		IDCMP_GADGETUP | IDCMP_CLOSEWINDOW | IDCMP_MENUPICK  },
	{  WA_Title, "Window 2"  },
	{  WA_MinWidth, 144  },
	{  WA_MinHeight, 62  },
	{  WA_MaxWidth, 144  },
	{  WA_MaxHeight, 62  },
	{  WA_AutoAdjust, 1  },
	{  WA_Flags,
		WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH |
	WFLG_ACTIVATE  }
};


void Open2(struct GTRequest *req,struct IntuiMessage *msg)
{
    puts("Open2");
}

void Close2(struct GTRequest *req,struct IntuiMessage *msg)
{
    puts("Close2");
}

struct GTMenuInfo Req2GTMenuInfo[] =
{
	{ 0 | (0 << 5) | (63 << 11), Open2 },
	{ 0 | (1 << 5) | (63 << 11), Close2 },
	{ 0, 0 }
};

struct MessageHandler Req2CloseWindowMH =
{
	NULL,
	"CloseWindow",
	NULL,
	mCloseWindow
};

struct GTRequest Req2 =
{
	Newwin2Tags,
	NULL,		/* Window */
	Req2Menus,		/* Menus */
	Req2GTMenuInfo, 	/* MenuInfo */
	&Click2,		/* Controls */
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
	NULL,		/* LocalPKindCassList */
	&Req2CloseWindowMH,  /* MsgHandlerList */
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
    struct GTReqSet rs;

    InitReqSet(&rs);

    AddGTRequest(&rs,&Req1);
    AddGTRequest(&rs,&Req2);

    ProcessReqSet (&rs);
    return 0;
}

