/**************************************************************************************************
** DaGuru GUI
***************************************************************************************************
** Preview of DaGuru GUI made up with relgroup.gadget and other gadget classes.
** The use of relgroup.class allows layout to be adjusted without the program having
** to worry about it.
**
** History:
** 20.08.1996	40.0	- Made GUI.
**			- Added CX handling.
**			- Doesn't free menus&gadgets when hiding for speed.
** 09.09.1996	40.1	- Added slider and up/down gadgets with object-interconnection
**			  through the modelclass subclass value.model.
** 25.01.1997	40.2	- Fixed gadget communications.
** 11.02.1997	40.3	* Aminet Developer Release.
**
**************************************************************************************************/
#define DEBUG_IT	 1				/* >0 = ON ,0 = OFF */
#define DEBUG_WAIT	 0				/* 1/5th seconds to wait */
#define NAME		"DaGuru GUI"
#define CODER		"Jeroen Massar"
#define REL		"4.0"
#define VER		"40.3"
#define DATE		"11.02.97"
#define COPYYEARS	"1996-1997"

#include "DaGuru.h"
#include <gadgets/relgroup.h>
#include <gadgets/relbutton.h>
#include <gadgets/virtual.h>
#include <models/value.h>

/**************************************************************************************************
** Debug Stuff
**************************************************************************************************/
#define DEBUGNAME NAME
#include <Shorsha:Cee/Debug.h>

static const char ProgName[]	= NAME;
static const char WinTitle[]	= NAME " " REL;
static const char ScrTitle[]	= NAME " " REL " ©" COPYYEARS " by " CODER;
static const char Version[]	= "$VER: " NAME " " REL " (" DATE ")";
static const char AboutTxT[]	= \
				NAME " " REL "\n"\
				"by " CODER "\n"\
				"\n"\
				"Revision         : " VER "\n"\
				"Date             : " DATE "\n"\
				"\n"\
				"RelGroup.gadget  : %ld.%ld\n"\
				"RelButton.gadget : %ld.%ld\n"\
				"Virtual.gadget   : %ld.%ld\n"\
				"Value.model      : %ld.%ld\n"\
				"ReqTools.library : %ld.%ld";

/**************************************************************************************************
** Id's
**************************************************************************************************/
enum {	ID_PROJECT=666,
	ID_PRJ_ABOUT,
	ID_PRJ_HIDE,
	ID_PRJ_QUIT,

	ID_GAD_CALENDAR,
	ID_GAD_STATUS,
	ID_GAD_PROP,
	ID_GAD_PROP_UP,
	ID_GAD_PROP_DOWN,

	ID_GAD_NUM,

	ID_GAD_NO_0,
	ID_GAD_NO_1,
	ID_GAD_NO_2,
	ID_GAD_NO_3,
	ID_GAD_NO_4,
	ID_GAD_NO_5,
	ID_GAD_NO_6,
	ID_GAD_NO_7,
	ID_GAD_NO_8,
	ID_GAD_NO_9,
	ID_GAD_NO_A,
	ID_GAD_NO_B,
	ID_GAD_NO_C,
	ID_GAD_NO_D,
	ID_GAD_NO_E,
	ID_GAD_NO_F,

	ID_GAD_LIST,
	ID_GAD_LAST,
	ID_GAD_GET,
	ID_GAD_RESET,
	ID_GAD_GURUDOS,
	};

#define MENU_TITLE(txt)	{NM_TITLE,txt,0,0,0,0}
#define MENU_HEAD(txt)	{NM_ITEM,txt,0,0,0,0}
#define MENU_BAR	{NM_ITEM,NM_BARLABEL,0,0,0,0}
#define MENU_SUBBAR	{NM_SUB,NM_BARLABEL,0,0,0,0}
#define MENU_END	{NM_END,0,0,0,0,0,}

#define RB  CHECKIT|MENUTOGGLE
#define RBC CHECKIT|MENUTOGGLE|CHECKED
#define TG  CHECKIT
#define TGC CHECKIT|CHECKED
#define IDISABLED NM_ITEMDISABLED

struct NewMenu MainMenu[] =
{
	MENU_TITLE("Project"),
	{  NM_ITEM,"About..."				,"?",0	,0		,(APTR)ID_PRJ_ABOUT	},
	{  NM_ITEM,"Hide..."				,"H",0	,0		,(APTR)ID_PRJ_HIDE	},
	{  NM_ITEM,"Quit..."				,"Q",0	,0		,(APTR)ID_PRJ_QUIT	},

	MENU_END
};

/**************************************************************************************************
** Global Variables
**************************************************************************************************/
extern struct Library	*SysBase,*DOSBase,*UtilityBase,*IconBase;
struct GfxBase		*GfxBase=NULL;
struct IntuitionBase	*IntuitionBase=NULL;
struct Library		*GadToolsBase=NULL,*ReqToolsBase=NULL,*CxBase=NULL,
			*RGrpGadBase=NULL,*RButGadBase=NULL,*VirtGadBase=NULL,*CalGadBase=NULL,*ValModelBase=NULL;
ULONG			RGrp_AttrStart,RBut_AttrStart,Virt_AttrStart,ValM_AttrStart,
			OldLeft=0,OldTop=0,OldWidth=0,OldHeight=0,cxsigflag=NULL;
struct Screen		*scr=NULL;
struct Menu		*menu=NULL;
struct Window		*win=NULL,*oldprocwinptr=NULL;
void			*vi=NULL;
struct DrawInfo		*dri=NULL;
struct Gadget		*gad,*prop;
struct Object		*propmodel;
#define PubScreenLen 255
char			PubScreenName[PubScreenLen] = "";
CxObj			*Broker=NULL;
struct MsgPort		*BrokerMP=NULL;

struct NewBroker newbroker = {  NB_VERSION,(STRPTR)&ProgName,(STRPTR)&Version[6],(STRPTR)"Tests new GUI",
				/*NBU_NOTIFY|NBU_UNIQUE*/0,COF_SHOW_HIDE,0,0,0};
static const UWORD ZoomData[4] = {0,0,100,10};

/**************************************************************************************************
** Show Error Messages.
**************************************************************************************************/
void ShowErr(char *TxT, ...)
{
	APTR arg=(ULONG *)(((ULONG *)&TxT)+1);
	D(bugA(TxT,arg));
	if (ReqToolsBase)
	{
		struct TagItem Tags[] = {	RTEZ_ReqTitle,(ULONG)NAME " Whoopy...",
						RT_LockWindow,TRUE,
						TAG_DONE,NULL	};
		rtEZRequestA(TxT,"Ok",NULL,arg,(struct TagItem *)&Tags);
	}
	else
	{
		VPrintf(TxT,arg);
		PutStr("\n");			/* Add return */
	}
}

STRPTR DOSErr(void)
{
	static char TxT[125];
	Fault(IoErr(),"DOS-Error ",(STRPTR)&TxT,125);
	return(TxT);
}

/**************************************************************************************************
** Short routines.
**************************************************************************************************/
#define CloseLib(lib) if (lib){ CloseLibrary((struct Library *)lib); lib=NULL;}

ULONG DoClassLibraryMethod (struct ClassLibrary *cl, Msg msg)
{
	return (CallHookPkt(&cl->cl_Class->cl_Dispatcher,(APTR)cl->cl_Class,(APTR)msg));
}

struct MenuItem *FindUData(struct Menu *menu,ULONG id)
{
	BOOL found=FALSE;
	struct MenuItem *item=NULL,*sub=NULL;
	while (!found&&menu)
	{
		item=menu->FirstItem;
		while (!found&&item&&(!(found=((ULONG)GTMENUITEM_USERDATA(item)==id))))
		{
			for (sub=item->SubItem;(sub&&(!(found=((ULONG)GTMENUITEM_USERDATA(sub)==id))));sub=sub->NextItem);
			if (!found) item=item->NextItem;
		}
		if (!found) menu=menu->NextMenu;
	}
	return((sub ? sub : item));
}

#define MenuFind(id) FindUData(menu,id)
#define freevec(m) if (m) {FreeVec(m); m=NULL;}
#define checked(id) ((MenuFind(id)->Flags&CHECKED)>>8)
#define get(obj,attr,store) GetAttr(attr,obj,(ULONG *)store)
#define set(obj,attr,value) SetAttrs(obj,attr,value,TAG_DONE)
#define setg(win,obj,attr,value) SetGadgetAttrs((struct Gadget *)obj,win,NULL,attr,value,TAG_DONE)
#define DisObj(obj) if (obj) {DisposeObject(obj); obj=NULL;}

void setcheck(ULONG id,BOOL state)
{
	struct MenuItem *it;
	it=MenuFind(id);
	it->Flags&=~CHECKED;		/* Clear CHECKED bit */
	it->Flags|=(state&1)<<8;	/* Set/Clear CHECKED bit */
}

ULONG xget(Object *obj,ULONG attr)
{
	ULONG store;
	get(obj,attr,&store);
	return(store);
}

/**************************************************************************************************
** Open/Close Needed Libraries
**************************************************************************************************/
BOOL OpenLibs(void)
{
	GfxBase		= (struct GfxBase *)		OpenLibrary("graphics.library"	, 39L);
	IntuitionBase	= (struct IntuitionBase *)	OpenLibrary("intuition.library"	, 39L);
	ReqToolsBase	= 				OpenLibrary("reqtools.library"	, REQTOOLSVERSION);
	GadToolsBase	= 				OpenLibrary("gadtools.library"	, 39L);
	return((BOOL)(GfxBase&&IntuitionBase&&ReqToolsBase&&GadToolsBase ? TRUE : FALSE));
}

void CloseLibs(void)
{
	CloseLib(GadToolsBase);
	CloseLib(ReqToolsBase);
	CloseLib(IntuitionBase);
	CloseLib(GfxBase);
}

/**************************************************************************************************
** DoReadArgs (for cli-parameters which override normal ones)
**************************************************************************************************/
BOOL DoReadArgs(void)
{
	char Template[]	= "PS=PUBSCREEN/K,TESTGURU/S,CLEARGURU/S";
	char Help[]	= "PubScreen  - Name of public-screen to open on.\n"\
			  "TestGuru   - This option, when enabled will test for a last\n"\
			  "             Guru and if there was one then the main window\n"\
			  "             will be opened, if there weren't any gurus then\n"
			  "             nothing will be shown onscreen\n"\
			  "ClearGuru  - Clears guru on exit\n";
	struct ArgArray {
		STRPTR	PubScreen;
		ULONG	TestGuru;
		ULONG	ClearGuru;
	} argarray = {0,0,0};
	struct RDArgs *rda,*rdas;
	BOOL	ret=FALSE;

	if (rdas = AllocDosObject(DOS_RDARGS,NULL))
	{
		rdas->RDA_ExtHelp = (char *)&Help;
		if (rda = ReadArgs((char *)&Template,(LONG *)&argarray,rdas))
		{
			if (argarray.PubScreen)
			{
				int x;
				char *to=(char *)&PubScreenName,*from=(char *)argarray.PubScreen;
				for (x=PubScreenLen;x>0&&from[0]!=0;to++,from++) to[0]=from[0];
			}
			ret=TRUE;
		}
		FreeArgs(rda);
		FreeDosObject(DOS_RDARGS,rdas);
	}

	if (!ret)
	{
		char TxT[125];
		Fault(IoErr(),"DOS-Error ",(STRPTR)&TxT,125);
		ShowErr((STRPTR)&TxT);
	}
	return(ret);
}

/**************************************************************************************************
** Open/Close Window & Setup/Dispose Gadgets
**************************************************************************************************/
void FreeGads(void)
{
	DisObj(gad);
	/*DisObj(propmodel);*/
	CloseLib(ValModelBase);
	CloseLib(CalGadBase);
	CloseLib(VirtGadBase);
	CloseLib(RButGadBase);
	CloseLib(RGrpGadBase);
}

/************************************************
 Some handy GUI creation macros.
************************************************/
#define End		TAG_DONE)
#define Virtual		NewObject(NULL,VIRTUALGADGET_NAME,Virt_AttrStart+RGrpA_Frame,NULL,GA_Immediate,TRUE,GA_RelVerify,TRUE,GA_TextAttr,scr->Font
#define VChildG		Virt_AttrStart+VirtA_ChildGadget
#define VChildI		Virt_AttrStart+VirtA_ChildImage
#define Group		NewObject(NULL,RELGROUPGADGET_NAME,RGrp_AttrStart+RGrpA_Frame,NULL,GA_TextAttr,scr->Font
#define GroupV		Group,RGrp_AttrStart+RGrpA_Orientation,RGrpV_Orientation_Vertical
#define GroupH		Group,RGrp_AttrStart+RGrpA_Orientation,RGrpV_Orientation_Horizontal
#define GroupU(c,r)	Group,RGrp_AttrStart+RGrpA_Orientation,RGrpV_Orientation_User,\
			RGrp_AttrStart+RGrpA_Columns,c,RGrp_AttrStart+RGrpA_Rows,r
#define Child		RGrp_AttrStart+RGrpA_Child

#define RButO(id,label)	NewObject(NULL,RELBUTTONGADGET_NAME,\
						GA_ID,				id,\
						ICA_TARGET,			ICTARGET_IDCMP,\
						RBut_AttrStart+RButA_Label,	label,\
						GA_RelVerify,			FALSE,\
						GA_Immediate,			TRUE,\
						GA_TextAttr,			scr->Font
#define RBut(id,label)	RButO(id,label),End
#define RButD(id,label,dis)\
			RButO(id,label),GA_Disabled,dis,End
#define RButT(id,label,sel,dis)\
			RButO(id,label),GA_ToggleSelect,TRUE,GA_Selected,sel,GA_Disabled,dis,End
#define RButT2(id,label,label2,sel)\
			RButO(id,label),GA_ToggleSelect,TRUE,GA_Selected,sel,RBut_AttrStart+RButA_LabelSel,label2,End
#define StrI(id,n)	NewObject(NULL,"strgclass",GA_ID,id,STRINGA_LongVal,n,STRINGA_NoFilterMode,TRUE,STRINGA_MaxChars,15,STRINGA_Justification,GACT_STRINGCENTER,GA_TextAttr,scr->Font,GA_Immediate,TRUE,GA_RelVerify,TRUE,TAG_DONE)
#define PropGad(id,free,top,vis,tot/*,target,map*/)\
			Group,	RGrp_AttrStart+RGrpA_Frame,RGrpV_Frame_Default,IA_FrameType,FRAME_BUTTON,\
				Child,	NewObject(NULL,"propgclass",GA_ID,id,GA_Width,1,GA_Height,1,PGA_NewLook,TRUE,PGA_Freedom,free,PGA_Top,top,PGA_Total,tot,PGA_Visible,vis,PGA_Borderless,FALSE,\
					GA_Immediate,TRUE,GA_RelVerify,TRUE,GA_TextAttr,scr->Font,/*ICA_TARGET,target,ICA_MAP,map,*/TAG_DONE),\
			End
#define ImageGad(id,which/*,target,map*/)\
			NewObject(NULL,"buttongclass",GA_ID,id,GA_Width,1,GA_Height,1,\
				GA_Image,NewObject(NULL,"sysiclass",SYSIA_Size,SYSISIZE_MEDRES,SYSIA_Which,which,SYSIA_DrawInfo,dri,SYSIA_ReferenceFont,scr->Font,TAG_DONE),\
				GA_TextAttr,scr->Font,GA_Immediate,TRUE,GA_RelVerify,TRUE,\
				/*ICA_TARGET,target,ICA_MAP,map,*/TAG_DONE)
/*#define CalGad(id)	NewObject(NULL,"calendar.gadget",GA_ID,id,GA_RelVerify,TRUE,GA_Immediate,TRUE/*,ICA_TARGET,ICTARGET_IDCMP*/,GA_TextAttr,scr->Font,TAG_DONE)*/
#define ValueMod(val,step,min,max)\
			NewObject(NULL,VALUEMODEL_NAME,ValM_AttrStart+ValMA_Value,val,ValM_AttrStart+ValMA_Step,step,ValM_AttrStart+ValMA_Min,min,ValM_AttrStart+ValMA_Max,max,ICA_TARGET,ICTARGET_IDCMP,ICA_MAP,modelmap,TAG_DONE)
/***********************************************/

/* IC maps */
/*ULONG propmap[]		= {	PGA_TOP,	ValMA_Value,	TAG_DONE };
ULONG upmap[]		= {	GA_ID,		ValMA_Decr,	TAG_DONE };
ULONG downmap[]		= {	GA_ID,		ValMA_Incr,	TAG_DONE };
ULONG propmodmap[]	= {	ValMA_Value,	PGA_Top,
				ValMA_Max,	PGA_Total,
				ValMA_Step,	PGA_Visible,	TAG_DONE };
ULONG modelmap[]	= {	TAG_DONE };

#define UpdateMapA(map) map[1]+=ValM_AttrStart
#define UpdateMapB(map) map[0]+=ValM_AttrStart; map[2]+=ValM_AttrStart; map[4]+=ValM_AttrStart

BOOL IC(struct Object *target,ULONG *map,struct Object *model)
{
	struct Object *ic;
	BOOL ret=FALSE;
	if (ic=NewObject(NULL,ICCLASS,ICA_TARGET,target,ICA_MAP,map,TAG_DONE))
	{
		D(bug("Adding IC..."));
		DoMethod((Object *)model,OM_ADDMEMBER,ic);
		ret=TRUE;
	}
	return(ret);
}
*/

BOOL MakeGads(void)
{
	ULONG msg = OM_ATTRSTART;
	BOOL ret=FALSE;
	if ((RGrpGadBase = OpenLibrary(RELGROUPGADGET_LIBPATH RELGROUPGADGET_NAME,RELGROUPGADGET_VMIN))&&
		(RButGadBase  = OpenLibrary(RELBUTTONGADGET_LIBPATH RELBUTTONGADGET_NAME,RELBUTTONGADGET_VMIN))&&
		(VirtGadBase  = OpenLibrary(VIRTUALGADGET_LIBPATH VIRTUALGADGET_NAME,VIRTUALGADGET_VMIN))&&
		/*(CalGadBase   = OpenLibrary("gadgets/calendar.gadget",37))&&*/
		(ValModelBase = OpenLibrary(VALUEMODEL_LIBPATH VALUEMODEL_NAME,VALUEMODEL_VMIN)))
	{
		RGrp_AttrStart=DoClassLibraryMethod((struct ClassLibrary *)RGrpGadBase,(Msg)&msg);
		RBut_AttrStart=DoClassLibraryMethod((struct ClassLibrary *)RButGadBase,(Msg)&msg);
		Virt_AttrStart=DoClassLibraryMethod((struct ClassLibrary *)VirtGadBase,(Msg)&msg);
		ValM_AttrStart=DoClassLibraryMethod((struct ClassLibrary *)ValModelBase,(Msg)&msg);
/*		UpdateMapA(propmap);
		UpdateMapA(upmap);
		UpdateMapA(downmap);
		UpdateMapB(propmodmap);

		if ((propmodel=ValueMod(1,1,0,100))&&*/

		if	(gad = GroupV,
				Child,	GroupH,
					Child, Virtual,
						Virt_AttrStart+VirtA_Virtual,VirtV_Virtual_Always,
						VChildG,RButO(ID_GAD_STATUS,"Status"),
							GA_ReadOnly,TRUE,
							IA_Recessed,TRUE,
						End,
					End,
					/*Child, CalGad(ID_GAD_CALENDAR),*/
					RGrp_AttrStart+RGrpA_Weight,RGrpV_Weight_NoXReSize,
					Child, GroupV,
						Child,	prop=PropGad(ID_GAD_PROP,FREEVERT,1,1,100/*,propmodel,propmap*/),
						RGrp_AttrStart+RGrpA_Weight,RGrpV_Weight_NoYReSize,
						Child,	ImageGad(ID_GAD_PROP_UP  ,UPIMAGE  /*,propmodel,upmap*/),
						Child,	ImageGad(ID_GAD_PROP_DOWN,DOWNIMAGE/*,propmodel,downmap*/),
					End,
				End,
				RGrp_AttrStart+RGrpA_Weight,RGrpV_Weight_NoYReSize,
				Child,	GroupH,
					Child,	GroupV,
						RGrp_AttrStart+RGrpA_Weight,RGrpV_Weight_NoYReSize,
						Child,	GroupH,
							RGrp_AttrStart+RGrpA_Weight,RGrpV_Weight_NoXReSize,
							Child,	RButO(ID_GAD_GURUDOS,"Hex:"),
								GA_ReadOnly,	TRUE,
								IA_Recessed,	TRUE,
								IA_FrameType,	FRAME_BUTTON,
							End,
							RGrp_AttrStart+RGrpA_Weight,RGrpV_Weight_Average,
							Child,	Group,
								RGrp_AttrStart+RGrpA_Frame,RGrpV_Frame_Default,
								IA_FrameType,FRAME_RIDGE,
								Child,	StrI(ID_GAD_NUM,100),
							End,
						End,
						RGrp_AttrStart+RGrpA_Weight,RGrpV_Weight_Average,
						Child,	Group,
							RGrp_AttrStart+RGrpA_Rows, 4,
							Child,	RBut(ID_GAD_NO_0,"0"),
							Child,	RBut(ID_GAD_NO_1,"1"),
							Child,	RBut(ID_GAD_NO_2,"2"),
							Child,	RBut(ID_GAD_NO_3,"3"),
							Child,	RBut(ID_GAD_NO_4,"4"),
							Child,	RBut(ID_GAD_NO_5,"5"),
							Child,	RBut(ID_GAD_NO_6,"6"),
							Child,	RBut(ID_GAD_NO_7,"7"),
							Child,	RBut(ID_GAD_NO_8,"8"),
							Child,	RBut(ID_GAD_NO_9,"9"),
							Child,	RBut(ID_GAD_NO_A,"A"),
							Child,	RBut(ID_GAD_NO_B,"B"),
							Child,	RBut(ID_GAD_NO_C,"C"),
							Child,	RBut(ID_GAD_NO_D,"D"),
							Child,	RBut(ID_GAD_NO_E,"E"),
							Child,	RBut(ID_GAD_NO_F,"F"),
						End,
					End,
					Child,	GroupV,
						RGrp_AttrStart+RGrpA_Weight,200,
						Child, GroupU(2,2),
							Child,	RButD(ID_GAD_GET	,"Get",TRUE),
							Child,	RButD(ID_GAD_LIST	,"List",TRUE),
							Child,	RButD(ID_GAD_LAST	,"Last",TRUE),
							Child,	RBut(ID_GAD_RESET	,"Reset"),
						End,
						RGrp_AttrStart+RGrpA_Weight,100,
						Child,	RButT2(ID_GAD_GURUDOS	,"Guru (hex)","DOS Error (dec)",FALSE),
					End,
				End,
			End)
		{
/*			D(bug("Adding IC to the model"));
			if (IC((struct Object *)prop,propmodmap,propmodel))*/ ret=TRUE;/*
			else ShowErr("Couldn't create Interconnections.");*/
		}
		else ShowErr("Couldn't create gadgets.");
	}
	else ShowErr("Couldn't open public gadget-class.");
	if (!ret) FreeGads();
	return(ret);
}

void CloseWin(BOOL kill)
{
	struct Process *proc = (struct Process *)FindTask(NULL);
	if (win==oldprocwinptr) proc->pr_WindowPtr=oldprocwinptr;
	if (win)
	{
		OldLeft		=win->LeftEdge;
		OldTop		=win->TopEdge;
		OldWidth	=win->Width;
		OldHeight	=win->Height;
		ClearMenuStrip(win);
		CloseWindow(win);
		win=NULL;
	}
	if (kill)
	{
		FreeGads();
		if (menu)
		{
			FreeMenus(menu);
			menu=NULL;
		}
	}
	if (vi)
	{
		FreeVisualInfo(vi);
		vi=NULL;
	}
	if (dri)
	{
		FreeScreenDrawInfo(scr,dri);
		dri=NULL;
	}
	if (scr)
	{
		UnlockPubScreen(NULL, scr);
		scr=NULL;
	}
}

BOOL OpenWin(STRPTR PubScreenName)
{
	BOOL ret=FALSE;
	struct Process *proc;
	struct gpDomain dom;

	if (!win)
	{
		if (scr=LockPubScreen(PubScreenName))
		{
			if (vi=GetVisualInfo(scr,TAG_DONE))
			{
				if (dri = GetScreenDrawInfo(scr))
				{
					/* Build and layout menus using the right font */
					if (!menu) menu=CreateMenus(MainMenu,TAG_DONE);
					if (menu)
					{
						if (LayoutMenus(menu, vi,
							GTMN_NewLookMenus, TRUE,
							TAG_DONE))
						{
							if (MakeGads())
							{
								dom.MethodID=GM_DOMAIN;
								dom.gpd_GInfo=NULL;
								dom.gpd_RPort=&scr->RastPort;
								dom.gpd_Which=GDOMAIN_MINIMUM;
								dom.gpd_Domain.Left=dom.gpd_Domain.Top=dom.gpd_Domain.Width=dom.gpd_Domain.Height=0;
								dom.gpd_Attrs=NULL;
								DoMethodA((Object *)gad,(Msg)&dom);
								/*D(bug("Left=%ld,Top=%ld,Width=%ld,Height=%ld",dom.gpd_Domain.Left,dom.gpd_Domain.Top,dom.gpd_Domain.Width,dom.gpd_Domain.Height));*/
								if (win = OpenWindowTags(NULL,
									WA_Left,		(OldLeft  ?OldLeft  :100),
									WA_Top,			(OldTop   ?OldTop   :50),
									WA_Width,		(OldWidth ?OldWidth :(scr->WBorLeft+dom.gpd_Domain.Width+scr->WBorRight)),
									WA_Height,		(OldHeight?OldHeight:(scr->WBorTop+scr->Font->ta_YSize+1+dom.gpd_Domain.Height+scr->WBorBottom)),
									WA_MinWidth,		(scr->WBorLeft+dom.gpd_Domain.Width+scr->WBorRight),
									WA_MinHeight,		(scr->WBorTop+scr->Font->ta_YSize+1+dom.gpd_Domain.Height+scr->WBorBottom),
									WA_MaxWidth,		~0,
									WA_MaxHeight,		~0,
									WA_Title,		WinTitle,
									WA_ScreenTitle,		ScrTitle,
									WA_PubScreen,		scr,
									WA_PubScreenFallBack,	FALSE,
									WA_Zoom,		ZoomData,
									WA_Gadgets,		gad,
									WA_SizeGadget,		TRUE,
									WA_DragBar,		TRUE,
									WA_DepthGadget,		TRUE,
									WA_CloseGadget,		TRUE,
									WA_Activate,		TRUE,
									WA_SimpleRefresh,	TRUE,
									WA_SizeBBottom,		TRUE,
									WA_MenuHelp,		TRUE,
									WA_IDCMP,		IDCMP_CLOSEWINDOW|IDCMP_MENUPICK|IDCMP_MENUHELP|IDCMP_GADGETHELP|IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_IDCMPUPDATE,
									WA_NewLookMenus,	TRUE,
									WA_PointerDelay,	TRUE,
									TAG_DONE,NULL))
								{
									/*RefreshWindowFrame(win);*/
									SetMenuStrip(win, menu);
									proc = (struct Process *)FindTask(NULL);
									oldprocwinptr=proc->pr_WindowPtr;
									proc->pr_WindowPtr=win;
									ret=TRUE;
								}
								else ShowErr("Couldn't open window.");
							}
						}
						else ShowErr("Couldn't layout menus.");
					}
					else ShowErr("Couldn't create menus.");
				}
				else ShowErr("Couldn't get ScreenDrawInfo.");
			}
			else ShowErr("Couldn't get VisualInfo for screen \"%s\".",PubScreenName);
		}
		else ShowErr("Couldn't find public screen \"%s\".\nEither the screen is in private state\nor the name is misspelled.",PubScreenName);
		if (!ret) CloseWin(TRUE);
	}
	return(ret);
}

/**************************************************************************************************
** Create/Remove Commodity & Handling of CX Messages
**************************************************************************************************/
BOOL CreateCX(void)
{
	BOOL ret=FALSE;
	LONG err=CBERR_SYSERR;
	if ((CxBase=OpenLibrary("commodities.library",36L))&&(BrokerMP=CreatePort(0,0)))
	{
		newbroker.nb_Port	= BrokerMP;
		cxsigflag		= 1L<<BrokerMP->mp_SigBit;
		newbroker.nb_Pri	= 0;
		if (Broker=CxBroker(&newbroker,&err))
		{
			ActivateCxObj(Broker,TRUE);
			ret=TRUE;
		}
	}
	if ((err!=CBERR_OK)&&(err!=CBERR_DUP)) ShowErr("Couldn't create commodities broker, CxErr=%ld",err);
	return(ret);
}

void DisposeCX(void)
{
	struct Message *msg;
	if (Broker) DeleteCxObjAll(Broker);
	if (BrokerMP)
	{
		while (msg=GetMsg(BrokerMP)) ReplyMsg(msg);
		DeletePort(BrokerMP);
	}
	CloseLib(CxBase);
}

BOOL ProcessCxMsg(CxMsg *msg)
{
	ULONG	msgid=CxMsgID(msg),msgtype=CxMsgType(msg);
	BOOL	quit=FALSE;

	switch (msgtype)
	{
		/*case CXM_IEVENT: break;*/
		case CXM_COMMAND:	switch(msgid)
					{
						case CXCMD_DISABLE:	ActivateCxObj(Broker,FALSE);	break;
						case CXCMD_ENABLE:	ActivateCxObj(Broker,TRUE);	break;
						case CXCMD_DISAPPEAR:	CloseWin(FALSE);		break;
						case CXCMD_UNIQUE:	/* Fall Through */
						case CXCMD_APPEAR:	if (!win) OpenWin((strlen(PubScreenName)?(STRPTR)&PubScreenName:NULL));
									else
									{
										ActivateWindow(win);
										WindowToFront(win);
									}				break;
						case CXCMD_KILL:	quit=TRUE;			break;
					}
	}
	ReplyMsg((struct Message *)msg);
	return(quit);
}

/**************************************************************************************************
** Handle Menus
**************************************************************************************************/
BOOL HandleMenuEvent(UWORD code)
{
	BOOL ret=FALSE;
	struct MenuItem *item;
	/*D(bug("Handling Menu event."));*/
	while ((!ret)&&(code!=MENUNULL)&&(item = ItemAddress(menu,code)))
	{
		/*D(bug("Code : %ld, Item $%lx, ItemID %ld",code,item,(ULONG)GTMENUITEM_USERDATA(item)));*/
		switch ((ULONG)GTMENUITEM_USERDATA(item))
		{
			case ID_PRJ_ABOUT:	{
							struct TagItem Tags[] = {RTEZ_ReqTitle,(ULONG)"About...",RT_LockWindow,TRUE,TAG_DONE,NULL};
							rtEZRequest((char *)AboutTxT,"Ok",NULL,(struct TagItem *)&Tags,RGrpGadBase->lib_Version,RGrpGadBase->lib_Revision,RButGadBase->lib_Version,RButGadBase->lib_Revision,VirtGadBase->lib_Version,VirtGadBase->lib_Revision,ValModelBase->lib_Version,ValModelBase->lib_Revision,ReqToolsBase->lib_Version,ReqToolsBase->lib_Revision);
						}
						break;
			case ID_PRJ_HIDE:	CloseWin(FALSE);
						ret=TRUE;
						break;
			case ID_PRJ_QUIT:	ret=TRUE;
						break;
		}
		code=item->NextSelect;
	}
	if ((ret)&&(win==NULL)) ret=FALSE;
	return(ret);
}

void ShowHelp(STRPTR TxT)
{
	rtEZRequestTags(TxT,"Ok",NULL,NULL,RTEZ_ReqTitle,NAME " Help...",RT_LockWindow,TRUE,TAG_DONE);
}

/*
** Handle Help-button presses when selecting an menu-item.
*/
void HandleMenuHelp(UWORD code)
{
	struct MenuItem *item;
	/*D(bug("Handling MenuHelp"));*/
	if (item = ItemAddress(menu,code))
	{
		switch ((ULONG)GTMENUITEM_USERDATA(item))
		{
			case ID_PRJ_ABOUT:	ShowHelp("Shows about/information of "NAME); break;
			case ID_PRJ_HIDE:	ShowHelp("Hides "NAME); break;
			case ID_PRJ_QUIT:	ShowHelp("Quits "NAME); break;
			default:		ShowHelp("No help available for this item."); break;
		}
	}
}

/**************************************************************************************************
** Main Program
**************************************************************************************************/
int main(int argc,char *argv[])
{
	struct IntuiMessage	*imsg;
	ULONG			imsgClass,signal=0;
	UWORD			imsgCode;
	struct Gadget		*imsgGAddr;
	int			ret=20;
	BOOL			quit=FALSE;

	if (OpenLibs())
	{
		if (DoReadArgs())
		{
			if (CreateCX())
			{
				if (OpenWin((strlen(PubScreenName)?(STRPTR)&PubScreenName:NULL)))
				{
					ret=0;
					while (!quit)
					{
						if (win) signal=Wait((1<<win->UserPort->mp_SigBit)|cxsigflag);
						else signal=Wait(cxsigflag);
						if (signal&cxsigflag)
						{
							CxMsg *cxmsg;
							while ((!quit)&&(cxmsg=(CxMsg *)GetMsg(BrokerMP))) quit=ProcessCxMsg(cxmsg);
						}
						if ((win)&&(signal&(1<<win->UserPort->mp_SigBit)))
						{
							while ((!quit)&&(win)&&(imsg = (struct IntuiMessage *)GetMsg(win->UserPort)))
							{
								imsgClass = imsg->Class;
								imsgCode  = imsg->Code;
								imsgGAddr = (struct Gadget *)imsg->IAddress;
								ReplyMsg((struct Message *)imsg);
								D(bug("Msg : imsgClass=>%ld<",imsgClass));
								switch (imsgClass)
								{
									case IDCMP_MENUHELP:	HandleMenuHelp(imsgCode); break;
									case IDCMP_MENUPICK:	quit = HandleMenuEvent(imsgCode); break;
									case IDCMP_CLOSEWINDOW:	quit=TRUE;
												break;
									/*case IDCMP_GADGETUP:	if (imsgGAddr)
												{
													switch (imsgGAddr->GadgetID)
													{
														case 0: /* */ break;
													}
												}
												break;*/
									case IDCMP_GADGETUP:	D(bug("GADGETUP")); break;
									case IDCMP_GADGETDOWN:	D(bug("GADGETDOWN")); break;
									case IDCMP_IDCMPUPDATE:	D(bug("IDCMPUPDATE")); break;
									case IDCMP_GADGETHELP:	D(bug("GADGETHELP")); break;
									default:		D(bug("???IDCMP???")); break;
								}
							}
						}
					}
				}
				CloseWin(TRUE);
			}
			DisposeCX();
		}
	}
	else ShowErr("Couldn't open a required resource (library/device).");
	CloseLibs();
	return(ret);
}
