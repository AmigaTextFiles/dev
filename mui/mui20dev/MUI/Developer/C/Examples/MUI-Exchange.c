
  /**********************************************\
  *                                              *
  *  MUI-Exchange                                *
  *                                              *
  *  Version: 0.8 (13.8.93)                      *
  *                                              *
  *  Copyright 1993 by kMel, Klaus Melchior      *
  *  kmel@eifel.adsp.sub.org, 2:242/7.2@Fidonet  *
  *                                              *
  *                                              *
  *  This isn't a proper replacement             *
  *  for the "Exchange" from Commodore,          *
  *  because it can't use the CX-Command         *
  *  'CXCMD_LIST_CHG'.                           *
  *                                              *
  *  All these broker functions are private      *
  *  and rarely documented.                      *
  *                                              *
  \**********************************************/


/* DMAKE */

/* TAB=4 */




/*** escape sequences ***/

#define eR "\033r"
#define eC "\033c"
#define eL "\033l"

#define eN "\033n"
#define eB "\033b"
#define eI "\033i"

#define ePB "\0332"
#define ePW "\0338"




/*** includes ***/

#include "demo.h"

#include <exec/memory.h>
#include <libraries/commodities.h>
#include <clib/commodities_protos.h>

#ifdef __SASC
#include <pragmas/commodities_pragmas.h>
#endif




/*** private structures & defines ***/

struct BrokerCopy	{
	struct Node	bc_Node;
	char	bc_Name[CBD_NAMELEN];
	char	bc_Title[CBD_TITLELEN];
	char	bc_Descr[CBD_DESCRLEN];
	LONG	bc_Task;
	LONG	bc_Dummy1;
	LONG	bc_Dummy2;
	UWORD	bc_Flags;
};

#define COF_ACTIVE 2




/*** private functions of "commodities.library" ***/

#pragma libcall CxBase FindBroker 6c 801
#pragma libcall CxBase CopyBrokerList ba 801
#pragma libcall CxBase FreeBrokerList c0 801
#pragma libcall CxBase BrokerCommand c6 802

CxObj *FindBroker(char *);
LONG CopyBrokerList(struct List *);
LONG FreeBrokerList(struct List *);
LONG BrokerCommand(char *, LONG id);



/*** ids ***/

enum ids {
	ID_DUMMY,
	ID_ABOUT,
	ID_INFO,
	ID_LV_ACTIVE,
	ID_ACTIVATE, ID_DEACTIVATE, ID_REMOVE,
	ID_INTERFACE, ID_SHOW, ID_HIDE,
	ID_QUIT,
};




/*** variables ***/

static APTR app;
static APTR wi_main;
static APTR bt_info;
static APTR lv_broker;
static APTR bt_activate, bt_deactivate, bt_remove;
static APTR bt_show, bt_hide;

struct Library *CxBase;




/*** funcs ***/

/*** find name in broker list ***/

LONG find_broker_name(char *n)
{
	struct BrokerCopy *bc;
	LONG i;

	for (i=0; ; i++)
	{
		DoMethod(lv_broker, MUIM_List_GetEntry, i, &bc);

		/*** last line ? ***/
		if (!bc)
			break;

		/*** found name ? ***/
		if (stricmp(&bc->bc_Name[0], n) == 0)
			return(i);
	}

	return(-1);
}




/*** find task in broker list ***/

LONG find_broker_task(ULONG t)
{
	struct BrokerCopy *bc;
	LONG i;

	for (i=0; ; i++)
	{
		DoMethod(lv_broker, MUIM_List_GetEntry, i, &bc);

		/*** last line ? ***/
		if (!bc)
			break;

		/*** found task ? ***/
		if (bc->bc_Task == t)
			return(i);
	}

	return(-1);
}




/*** disable gadgets & menus, show changes ***/

void check_broker(void)
{
	struct BrokerCopy *bc;

	BOOL disable_activate = TRUE, disable_deactivate = TRUE;
	BOOL disable_interface = TRUE;

	DoMethod(lv_broker, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &bc);

	if (bc->bc_Flags & COF_SHOW_HIDE)
		disable_interface = FALSE;

	if (bc->bc_Flags & COF_ACTIVE)
		disable_deactivate = FALSE;
	else
		disable_activate = FALSE;


	/*** set status of gadgets ***/
	set(bt_activate, MUIA_Disabled, disable_activate);
	set(bt_deactivate, MUIA_Disabled, disable_deactivate);

	set(bt_show, MUIA_Disabled, disable_interface);
	set(bt_hide, MUIA_Disabled, disable_interface);


	/*** set status of menus ***/
	DoMethod(wi_main, MUIM_Window_SetMenuState ,ID_ACTIVATE, !disable_activate);
	DoMethod(wi_main, MUIM_Window_SetMenuState ,ID_DEACTIVATE, !disable_deactivate);

	DoMethod(wi_main, MUIM_Window_SetMenuState ,ID_INTERFACE, !disable_interface);
}




/*** insert broker into listview ***/

BOOL insert_broker(void)
{
	static UBYTE count;

	struct List *l;
	ULONG nr, i;
	struct BrokerCopy *bc;

	if (l = AllocMem(sizeof(struct List), MEMF_PUBLIC))
	{
		struct Node *n, *nn;
		LONG pos, curs;

		count++;

		/*** generate an empty list ***/
		NewList(l);

		/*** private function to generate the system broker list ***/
		nr = CopyBrokerList(l);

		get(lv_broker, MUIA_List_Active, &curs);

		/*** start at head of list ***/
		n = l->lh_Head;
		while (n && (nn = n->ln_Succ))
		{
			if ((pos = find_broker_name((char *)&((struct BrokerCopy *)n)->bc_Name[0])) >= 0)
			{
				DoMethod(lv_broker, MUIM_List_GetEntry, pos, &bc);
				bc->bc_Flags = ((struct BrokerCopy *)n)->bc_Flags;
				bc->bc_Node.ln_Type = count;

				if (curs == pos)
					check_broker();
			}
			else
			{
				/*** insert broker ***/
				((struct BrokerCopy *)n)->bc_Node.ln_Type = count;
				DoMethod(lv_broker, MUIM_List_Insert, &n, 1, MUIV_List_Insert_Sorted);
			}

			/*** next node ***/
			n = nn;
		}

		/*** free list and allocated mem ***/
		FreeBrokerList(l);
		FreeMem(l, sizeof(struct List));

		for (i=0; ; i++)
		{
			DoMethod(lv_broker, MUIM_List_GetEntry, i, &bc);

			/*** last line ? ***/
			if (!bc)
				break;

			/*** found old broker ? ***/
			if (bc->bc_Node.ln_Type != count)
				DoMethod(lv_broker, MUIM_List_Remove, i--);
		}
	}

	return(TRUE);
}




/*** image-stuff ***/

/*
DiskObject 'MUI-Exchange_sleep.info': $076bf6b4
Size of DiskObjectStruct: 78  ImageStruct: 20
GadgetRender: $07692038  Size: 560   Width: 54  Height: 35  Depth: 2
*/


static UWORD mui_exchange_sleep_img1_data[] = {
	0x0003,0x8000,0x0000,0x0000,0x0004,0x4000,0x0000,0x0000,
	0x0008,0x4000,0x0000,0x0000,0x0018,0x4de0,0x0000,0x0000,
	0x0020,0x3210,0x0000,0x0000,0x0020,0x0008,0x0000,0x0000,
	0x0020,0x0008,0x0000,0x0000,0x0020,0xf008,0x0000,0x0000,
	0x0020,0x2788,0x0000,0x0000,0x0010,0x4108,0x0000,0x0000,
	0x0010,0xf208,0x0000,0x0000,0x0008,0x0790,0x0000,0x0000,
	0x0008,0x0020,0x0000,0x0000,0x003c,0x00c0,0x0000,0x0400,
	0x0046,0x3f00,0x0000,0x0c00,0x0083,0xe008,0x0000,0x0c00,
	0x0100,0x8038,0x0000,0x0c00,0x0101,0x00fc,0x0000,0x0c00,
	0x0386,0x03fc,0x0000,0x0c00,0x04c8,0x0ff0,0x0000,0x0c00,
	0x08b0,0x3ffc,0xc180,0x2c00,0x0500,0xffc0,0x6300,0x4c00,
	0x0203,0xfd80,0x363c,0x8c00,0x000f,0xf180,0x1c41,0x0c00,
	0x003f,0xc180,0x1c42,0x0c00,0x00ff,0x0180,0x3640,0x0c00,
	0x03fc,0x00c0,0x6340,0x0c00,0x03f0,0x003c,0xc180,0x0c00,
	0x01c0,0x0000,0x0080,0x0c00,0x0102,0x0000,0x0100,0x0c00,
	0x0001,0x0000,0x0600,0x0c00,0x0000,0x9fff,0xf800,0x0c00,
	0x0000,0x6000,0x0000,0x0c00,0x0000,0x2000,0x0000,0x0c00,
	0x7fff,0xffff,0xffff,0xfc00,0x0003,0x8000,0x0000,0x0000,
	0x0007,0xc000,0x0000,0x0000,0x000f,0xc000,0x0000,0x0000,
	0x001f,0xcde0,0x0000,0x0000,0x003f,0xfff0,0x0000,0x0000,
	0x003f,0xfff8,0x0000,0x0000,0x003f,0xfff8,0x0000,0x0000,
	0x003f,0x0ff8,0x0000,0x0000,0x003f,0xd878,0x0000,0x0000,
	0x001f,0xbef8,0x0000,0x0000,0x001f,0x0df8,0x0000,0x0000,
	0x000f,0xf870,0x0000,0x0000,0x000f,0xffe0,0x0000,0x0000,
	0xffff,0xffff,0xffff,0xf800,0xd57f,0xff51,0x5552,0x5000,
	0xd5ff,0xf55f,0x8003,0x5000,0xd5ff,0xd527,0xbfff,0x9000,
	0xd5ff,0x5482,0x7fff,0xd000,0xd7ff,0x5205,0xffff,0xe000,
	0xd7fd,0x4813,0xffff,0xf000,0xdff5,0x2043,0x3e7f,0xd000,
	0xd754,0x813f,0x9cff,0x9000,0xd752,0x047f,0xc9c3,0x5000,
	0xd548,0x107e,0x2392,0x5000,0xd520,0x607e,0x2391,0x5000,
	0xd481,0x3e7f,0xc995,0x5000,0xd204,0xff3f,0x9c95,0x5000,
	0xc413,0xffc3,0x3e55,0x5000,0xde47,0xffff,0xff55,0x5000,
	0xbf11,0xffff,0xfe55,0x5000,0xd854,0xffff,0xf955,0x5000,
	0xc555,0x6000,0x0555,0x5000,0xd555,0x1555,0x5555,0x5000,
	0xd555,0x5555,0x5555,0x5000,0x8000,0x0000,0x0000,0x0000,

};

static struct Image mui_exchange_sleep_img1 = {
	0x0000,0x0000,0x0036,0x0023,0x0002,
	&mui_exchange_sleep_img1_data[0],
	0x03,0x00,0x00000000,
};

static struct DiskObject mui_exchange_sleep_dobj = {
	0xe310,0x0001,
	0x00000000,
	0x00db,0x0050,0x0036,0x0024,0x0004,0x0003,0x0001,
	(APTR)&mui_exchange_sleep_img1,NULL,
	0x00000000,0x00000000,0x00000000,
	0x0000,
	0x00000000,
	0x0003,
	0x00000000,0x00000000,0x80000000,0x80000000,
	0x00000000,0x00000000,0x00000000,
};




/*** mui-stuff ***/

/*** list hooks ***/

SAVEDS ASM struct BrokerCopy *broker_list_confunc(
	REG(a0) struct Hook *hook,
	REG(a2) APTR mem_pool,
	REG(a1) struct BrokerCopy *b)
{
	struct BrokerCopy *bc;

	if (bc = AllocMem(sizeof(struct BrokerCopy), MEMF_ANY))
	{
		int i;
		UBYTE *s, *d;

		s = (BYTE *)b;
		d = (BYTE *)bc;

		for (i=0; i < sizeof(struct BrokerCopy); i++)
			*d++ = *s++;

		return(bc);
	}

	/*** insert nothing ***/
	return(0);
}

static struct Hook broker_list_conhook = {
	{NULL, NULL},
	(void *)broker_list_confunc,
	NULL, NULL
};


SAVEDS ASM LONG broker_list_desfunc(
	REG(a0) struct Hook *hook,
	REG(a2) APTR mem_pool,
	REG(a1) struct BrokerCopy *bc)
{
	FreeMem(bc, sizeof(struct BrokerCopy));
	return(0);
}

static struct Hook broker_list_deshook = {
	{NULL, NULL},
	(void *)broker_list_desfunc,
	NULL, NULL
};


SAVEDS ASM LONG broker_list_dspfunc(
	REG(a0) struct Hook *hook,
	REG(a2) char **array,
	REG(a1) struct BrokerCopy *bc)
{
	*array = bc->bc_Name;
	return(0);
}

static struct Hook broker_list_dsphook = {
	{NULL, NULL},
	(void *)broker_list_dspfunc,
	NULL, NULL
};


SAVEDS ASM LONG broker_list_cmpfunc(
	REG(a0) struct Hook *hook,
	REG(a2) struct BrokerCopy *bc1,
	REG(a1) struct BrokerCopy *bc2)
{
	return(stricmp(bc2->bc_Name, bc1->bc_Name));
}

static struct Hook broker_list_cmphook = {
	{NULL, NULL},
	(void *)broker_list_cmpfunc,
	NULL, NULL
};



/*** broker hook ***/

SAVEDS ASM LONG broker_list_brkfunc(
	REG(a0) struct Hook *hook,
	REG(a2) Object obj,
	REG(a1) CxMsg *cm)
{
	if ((CxMsgType(cm) == CXM_COMMAND) && (CxMsgID(cm) == CXCMD_LIST_CHG))
		insert_broker();

	return(0);
}

static struct Hook broker_list_brkhook = {
	{NULL, NULL},
	(void *)broker_list_brkfunc,
	NULL, NULL
};




/*** arexx hooks ***/

SAVEDS ASM LONG select_name_rxfunc(
	REG(a0) struct Hook *hook,
	REG(a2) Object *appl,
	REG(a1) ULONG *arg)
{
	char *name;

	/*** name valid ? ***/
	if (name = (char *)*arg)
	{
		ULONG pos;

		if (pos = find_broker_name(name))
		{
			/*** set cursor & listview ***/
			set(lv_broker, MUIA_List_Active, pos);
			DoMethod(lv_broker, MUIM_List_Jump, pos);

			return(RETURN_OK);
		}
	}

	return(RETURN_ERROR);
}

static const struct Hook select_name_rxhook = {
	{NULL, NULL},
	(void *)select_name_rxfunc,
	NULL,NULL
};


SAVEDS ASM LONG select_task_rxfunc(
	REG(a0) struct Hook *hook,
	REG(a2) Object *appl,
	REG(a1) ULONG *arg)
{
	ULONG task;

	/*** task valid ? ***/
	if (task = *((ULONG *)*arg))
	{
		ULONG pos;

		if (pos = find_broker_task(task))
		{
			/*** set cursor & listview ***/
			set(lv_broker, MUIA_List_Active, pos);
			DoMethod(lv_broker, MUIM_List_Jump, pos);

			return(RETURN_OK);
		}
	}

	return(RETURN_ERROR);
}

static const struct Hook select_task_rxhook = {
	{NULL, NULL},
	(void *)select_task_rxfunc,
	NULL,NULL
};




/*** arexx list ***/

static struct MUI_Command arexx_list[] =
{
	{"select_name",		"NAME/A",			1,				&select_name_rxhook},
	{"select_task",		"TASKADR/N/A",		1,				&select_task_rxhook},

	{"activate",		MC_TEMPLATE_ID,		ID_ACTIVATE,	NULL},
	{"deactivate",		MC_TEMPLATE_ID,		ID_DEACTIVATE,	NULL},
	{"remove",			MC_TEMPLATE_ID,		ID_REMOVE,		NULL},

	{"interface_show",	MC_TEMPLATE_ID,		ID_SHOW,		NULL},
	{"interface_hide",	MC_TEMPLATE_ID,		ID_HIDE,		NULL},

	{NULL,				NULL,				0,				NULL}
};




/*** menu ***/

static const struct NewMenu menu_list[] =
{
	{ NM_TITLE,	"Project",			0,	0,	0,	0							},

	{ NM_ITEM,	"About...",			"?",0,	0,	(APTR) ID_ABOUT				},
	{ NM_ITEM,	NM_BARLABEL,		0,	0,	0,	0							},
	{ NM_ITEM,	"Quit",				"Q",0,	0,	(APTR) ID_QUIT				},


	{ NM_TITLE,	"Broker",			0,	0,	0,	0							},

	{ NM_ITEM,	"Info",				"I",0,	0,	(APTR) ID_INFO				},
	{ NM_ITEM,	NM_BARLABEL,		0,	0,	0,	0							},
	{ NM_ITEM,	"Activate",			"A",0,	0,	(APTR) ID_ACTIVATE			},
	{ NM_ITEM,	"Deactivate",		"D",0,	0,	(APTR) ID_DEACTIVATE		},
	{ NM_ITEM,	"Remove",			"R",0,	0,	(APTR) ID_REMOVE			},
	{ NM_ITEM,	NM_BARLABEL,		0,	0,	0,	0							},
	{ NM_ITEM,	"Interface",		0,	0,	0,	(APTR) ID_INTERFACE			},
	{ NM_SUB,	"Show",				"S",0,	0,	(APTR) ID_SHOW				},
	{ NM_SUB,	"Hide",				"H",0,	0,	(APTR) ID_HIDE				},

	{ NM_END,	NULL,				0,	0,	0,	0							},
};




int main(int argc,char *argv[])
{
	/*** variables ***/
	ULONG timer_sig = 0;

	/*** init ***/
	BOOL not_end = TRUE;

	init();
	if (CxBase = OpenLibrary("commodities.library", 0))
	{

		/*** create mui-application ***/
		app = ApplicationObject,
			MUIA_Application_Title,				"MUI-Exchange",
			MUIA_Application_Version,			"$VER: MUI-Exchange 0.8 (13.8.93)",
			MUIA_Application_Copyright,			"© 1993 by kMel, Klaus Melchior",
			MUIA_Application_Author,			"Klaus Melchior",
			MUIA_Application_Description,		"Manages the system commodities list",
			MUIA_Application_Base,				"MUIEXCH",
			MUIA_Application_Menu,				menu_list,
			MUIA_Application_Commands,			arexx_list,
			MUIA_Application_BrokerHook,		&broker_list_brkhook,
			MUIA_Application_SingleTask,		TRUE,
			MUIA_Application_DiskObject,		&mui_exchange_sleep_dobj,

			SubWindow, wi_main = WindowObject,
				MUIA_Window_ID, MAKE_ID('M','A','I','N'),
				MUIA_Window_Title, "MUI-Exchange",
				WindowContents, VGroup,
					Child, VGroup,
						Child, HGroup,
							GroupSpacing(0),
							Child, bt_info		= KeyButton("Info",'i'),
							End,
						Child, VGroup,
							GroupSpacing(0),
							Child, lv_broker = ListviewObject,
								MUIA_Listview_DoubleClick, TRUE,
								MUIA_Listview_List, ListObject,
									InputListFrame,
									MUIA_List_ConstructHook, &broker_list_conhook,
									MUIA_List_DestructHook, &broker_list_deshook,
									MUIA_List_CompareHook, &broker_list_cmphook,
									MUIA_List_DisplayHook, &broker_list_dsphook,
									End,
								End,
							Child, HGroup,
								GroupSpacing(0),
								Child, bt_activate		= KeyButton("Activate",'a'),
								Child, bt_deactivate	= KeyButton("Deactivate",'d'),
								Child, bt_remove		= KeyButton("Remove",'r'),
								End,
							End,
						Child, HGroup,
							GroupSpacing(0),
							Child, bt_show	= KeyButton("Show Interface",'s'),
							Child, bt_hide	= KeyButton("Hide Interface",'h'),
							End,
						End,
					End,
				End,
			End;


		/*** application failed ? ***/
		if (!app)
			fail(app, "Creating application failed !");

		/*** connections & cycle ***/

		DoMethod(wi_main,		MUIM_Notify,	MUIA_Window_CloseRequest,	TRUE,	app,	2,	MUIM_Application_ReturnID,	ID_QUIT			);

		DoMethod(lv_broker,		MUIM_Notify,	MUIA_Listview_DoubleClick,	TRUE,	app,	2,	MUIM_Application_ReturnID,	ID_INFO			);
		DoMethod(lv_broker,		MUIM_Notify,	MUIA_Listview_SelectChange,	TRUE,	app,	2,	MUIM_Application_ReturnID,	ID_LV_ACTIVE	);

		DoMethod(lv_broker, MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
			app, 2,
			MUIM_Application_ReturnID, ID_LV_ACTIVE);

		DoMethod(bt_info,		MUIM_Notify,	MUIA_Pressed,				FALSE,	app,	2,	MUIM_Application_ReturnID,	ID_INFO			);

		DoMethod(bt_activate,	MUIM_Notify,	MUIA_Pressed,				FALSE,	app,	2,	MUIM_Application_ReturnID,	ID_ACTIVATE		);
		DoMethod(bt_deactivate,	MUIM_Notify,	MUIA_Pressed,				FALSE,	app,	2,	MUIM_Application_ReturnID,	ID_DEACTIVATE	);
		DoMethod(bt_remove,		MUIM_Notify,	MUIA_Pressed,				FALSE,	app,	2,	MUIM_Application_ReturnID,	ID_REMOVE		);

		DoMethod(bt_hide,		MUIM_Notify,	MUIA_Pressed,				FALSE,	app,	2,	MUIM_Application_ReturnID,	ID_HIDE			);
		DoMethod(bt_show,		MUIM_Notify,	MUIA_Pressed,				FALSE,	app,	2,	MUIM_Application_ReturnID,	ID_SHOW			);


		DoMethod(wi_main,		MUIM_Window_SetCycleChain,
			lv_broker,
			bt_activate, bt_deactivate, bt_remove,
			bt_hide, bt_show,
			bt_info,
			NULL);


		/*** open window ***/
		set(wi_main, MUIA_Window_Open,			TRUE);
		set(wi_main, MUIA_Window_ActiveObject,	lv_broker);


		/*** get brokerlist ***/
		insert_broker();

		/*** first scan & activate first entry ***/
		set(lv_broker, MUIA_List_Active, 0);

		/*** create timer_port to refresh broker_list ***/
		{
			struct timerequest *timer_io;
			struct MsgPort *timer_port;
			struct Message *timer_msg;
			ULONG error;

			if (timer_port = CreatePort(0, 0))
			{
				timer_sig = (1<<(timer_port->mp_SigBit));

				if (timer_io = (struct timerequest *) CreateExtIO(timer_port, sizeof(struct timerequest)))
				{
					if (!(error = OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest *) timer_io, 0)))
					{
						/*** refresh-cycle is 1 second ***/
						timer_io->tr_node.io_Command = TR_ADDREQUEST;
						timer_io->tr_time.tv_secs = 1;
						timer_io->tr_time.tv_micro = 0;

						SendIO((struct IORequest *) timer_io);

						/*** main-loop ***/
						while (not_end)
						{
							ULONG signal, ret_sig, id, ret;
							char *n;
							struct BrokerCopy *bc;

							switch (id = DoMethod(app, MUIM_Application_Input, &signal))
							{
								case ID_ABOUT:
									MUI_Request(app, wi_main, 0, NULL, "OK",
										eC ePW "MUI-Exchange\n\n"
										ePB "Version 0.8 (13.8.93)\n"
										"Copyright 1993 by kMel, Klaus Melchior.\n"
										"\nThis is a MUI-Application.\n"
										"MUI is copyrighted by Stefan Stuntz.",
										TAG_END);
								break;

								case MUIV_Application_ReturnID_Quit:
								case ID_QUIT:
									not_end = FALSE;
								break;


								case ID_INFO:
									DoMethod(lv_broker, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &bc);

									MUI_Request(app, wi_main, 0, NULL, "OK",
										eC ePW "%s\n\n"
										ePB eN "%s\n"
										"%s",
										bc->bc_Name, bc->bc_Title, bc->bc_Descr,
									TAG_END);
								break;

								case ID_LV_ACTIVE:
									check_broker();
								break;


								case ID_ACTIVATE:
									DoMethod(lv_broker, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &bc);
									BrokerCommand(n = bc->bc_Name, CXCMD_ENABLE);
								break;

								case ID_DEACTIVATE:
									DoMethod(lv_broker, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &bc);
									BrokerCommand(n = bc->bc_Name, CXCMD_DISABLE);
								break;

								case ID_REMOVE:
									DoMethod(lv_broker, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &bc);
									BrokerCommand(bc->bc_Name, CXCMD_KILL);
								break;

								case ID_SHOW:
									DoMethod(lv_broker, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &bc);
									ret = BrokerCommand(bc->bc_Name, CXCMD_APPEAR);
								break;

								case ID_HIDE:
									DoMethod(lv_broker, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &bc);
									ret = BrokerCommand(bc->bc_Name, CXCMD_DISAPPEAR);
								break;


								/*** default ***/

								default:
									if (id)
										printf("ID: %d = %08lx\n", id, id);
								break;
							}

							if (not_end && signal)
								ret_sig = Wait(signal | timer_sig);

							/*** timer signal ? ***/
							if (ret_sig & timer_sig)
							{
								while (timer_msg = GetMsg(timer_port))
									;

								insert_broker();

								/*** refresh cycle is 1 second ***/
								timer_io->tr_node.io_Command = TR_ADDREQUEST;
								timer_io->tr_time.tv_secs = 1;
								timer_io->tr_time.tv_micro = 0;

								SendIO((struct IORequest *) timer_io);
							}

						}

						/*** clean up & close timer.device ***/
						if (!(CheckIO((struct IORequest *)timer_io)))
							AbortIO((struct IORequest *)timer_io);
						WaitIO((struct IORequest *)timer_io);
						CloseDevice((struct IORequest *) timer_io);
					}

					DeleteExtIO((struct IORequest *) timer_io);
				}

				while (timer_msg = GetMsg(timer_port))
					;
				DeletePort(timer_port);
			}
		}

		CloseLibrary(CxBase);
	}
	fail(app, NULL);
}

