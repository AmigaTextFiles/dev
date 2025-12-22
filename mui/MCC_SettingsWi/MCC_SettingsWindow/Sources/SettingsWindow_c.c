/* SettingsWindow_c.c
** Copyright 1997-98 by Ingo Weinhold.
**
** This file contains the sources for class and some library stuff.
** Since I didn't get any of these completely C-written MCC templates
** working with my MAXON compiler/linker, I had to use a little
** assembler stub (SettingsWindow_mcc.s).
** I put the functions managing the complex (nested) structures and
** the lists in another file (StructSupport.h) that is included
** directly (uuhhhh) due to some strange problems with the linker.
** Most of the code was hacked together in August/September 1997 and
** seeing it now (Juli 1998) gives me the creeps.
**
** You are allowed to recycle any line of code you want.
** If you want to write a custom class you need to use your own tag
** base (derived from your registration number) of course.
*/

/* MUI */

#include <libraries/mui.h>
#include <MUI/NList_mcc.h>


/* System */

#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/gadtools.h>


/* Prototypes */

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/muimaster_protos.h>
#include <clib/asl_protos.h>
#include <clib/locale_protos.h>


/* ANSI C */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>


/* Compiler specific stuff */

#define REG(x) register __ ## x
#define ASM
#define SAVEDS


/* Useful stuff */

#define FChild (MUIA_Family_Child)
#define IsMinListEmpty(ml)      IsListEmpty((struct List *)(ml))


/* Pragmas */

#include <pragma/exec_lib.h>
#include <pragma/dos_lib.h>
#include <pragma/graphics_lib.h>
#include <pragma/utility_lib.h>


/* Locale stuff */

#define CATCOMP_NUMBERS
#define CATCOMP_ARRAY
#include "SettingsWindow_mcc.lh"


#include "SettingsWindow_mcc.h"

struct Library *MUIClassBase;
struct Library *MUIMasterBase;
struct Library *SysBase;
struct Library *UtilityBase;
extern struct Library *DOSBase;
struct Library *IntuitionBase;
struct Library *GfxBase;
struct Library *AslBase;
struct Library *LocaleBase;

struct Catalog *Catalog;

static struct MUI_CustomClass *ThisClass;

#define CLASS			MUIC_SettingsWindow
#define SUPERCLASS	MUIC_Window


/* Debugging Stuff */

#define DEBUG	0

#define DBFILENAME	"CON:10/10/500/400"

#if DEBUG>0
	FILE *DBFILE;

	#define DBINIT									\
		DBFILE=freopen(DBFILENAME,"w",stdout)


	#define DBEXIT					\
		if (DBFILE)					\
			{							\
			fclose(DBFILE);		\
			}

	#define D(bug)	{bug}
	#define BUG		printf
#else
	#define DBINIT
	#define DBEXIT
	#define D(bug)
#endif

#if DEBUG>1
	#define D2(bug)	{bug}
#else
	#define D2(bug)
#endif



/* Locale support functions */

void InitLocale()
{
	if (LocaleBase = OpenLibrary("locale.library",38))
		{
		Catalog = OpenCatalog(NULL,"SettingsWindow_mcc.catalog",
			OC_Version, 0,
			TAG_DONE);
		}
}


void ExitLocale()
{
	if (LocaleBase)
		{
		if (Catalog)
			{
			CloseCatalog(Catalog);
			}

		CloseLibrary(LocaleBase);
		}
}


STRPTR GetStr(int num)
{
	struct CatCompArrayType *cca = (struct CatCompArrayType *)CatCompArray;

	while (cca->cca_ID != num) cca++;

	if (LocaleBase)
		{
		return(GetCatalogStr(Catalog,num,cca->cca_Str));
		}

	return((char *)cca->cca_Str);
}


Object *MakeButton(int num)
{
	return(SimpleButton(GetStr(num)));
}

/* Memory pool supporting functions */

void *AllocVecPooled(REG(a0) void *pool, REG(d0) ULONG size)
{
	ULONG *mem;

	size+=4;

	if (mem=AllocPooled(pool,size))
		{
		mem[0]=size;
		mem=&mem[1];
		}

	return(mem);
}


void FreeVecPooled(void *pool, void *mem)
{
	mem=&((ULONG *)mem)[-1];

	FreePooled(pool,mem,*(ULONG *)mem);
}


/* a strdup that works on a memory pool */

char *strdupp(void *pool, const char *str)
{
	char *res = 0;
	if (str)
	{
		if (res = AllocVecPooled(pool, strlen(str) + 1))
			strcpy(res, str);
	}
	return res;
}



/**************************/
/*  SettingsWindow-CLASS  */
/**************************/


struct SettingsWindow_Data
{
	ULONG itemnum;
	struct MUIS_SettingsWindow_Item *items;
	ULONG *defitems;
	ULONG usedefaults;
	ULONG nonotify;
	struct MinList	notifylist;
	ULONG portdirectly;
	ULONG testmode;
	void	*pool;
	ULONG changed;
};


/* Private Structures */

struct MUIS_SettingsWindow_Item
{
	Object	*swi_Obj;
	ULONG		swi_Attr;
	ULONG		swi_Type;
	ULONG		swi_Size;
	ULONG		swi_ID;
	ULONG		swi_Contents;
};

struct MUIS_SettingsWindow_ComplexContents
{
	ULONG	swc_Reloc;
	ULONG	swc_Size;
	UBYTE	swc_Entry[0];
};

struct MUIS_SettingsWindow_ListContents
{
	ULONG	swl_Reloc;
	ULONG	swl_Size;
	ULONG	swl_Count;
	ULONG	swl_Entries[0];
};

struct NotifyEntry
{
	struct MinNode ne_Node;
	ULONG				ne_TrigID;
	ULONG				ne_TrigValue;
	Object 			*ne_DestObj;
	ULONG				ne_FollowParams;
	ULONG				ne_Params[0];
};

#define NOTIFYSIZE(params)	(sizeof(struct NotifyEntry)-sizeof(struct MinNode)+4*(params))


#define CASE_LIST					\
	case SWIT_LISTSTANDARD:		\
	case SWIT_LISTSTRING:		\
	case SWIT_LISTSTRUCT:		\
	case SWIT_LISTCOMPLEX:		\
	case SWIT_LISTCUSTOM


/* Structure Support */

#include "StructSupport.h"


/* Initial TagList */

static TagItem InitTagList[]={
	{MUIA_Window_Menustrip, NULL},
	{TAG_MORE,NULL}};


/*	Menu Return-Values */

#define menu_quit				0x01
#define menu_load				0x02
#define menu_lastsaved		0x03
#define menu_restore			0x04
#define menu_saveas			0x05
#define menu_defaults		0x06


/* Prototypes */

static ULONG SettingsWindow_GetItemNum(Object *obj,
	struct SettingsWindow_Data *data, ULONG num);



static ULONG SettingsWindow_New(struct IClass *cl,Object *obj,struct opSet *msg)
{
	struct SettingsWindow_Data *data;
	BOOL  erfolg=FALSE;
	ULONG testbutton=GetTagData(MUIA_SettingsWindow_TestButton,FALSE,msg->ops_AttrList);
	ULONG usedefaults=GetTagData(MUIA_SettingsWindow_UseDefaults,TRUE,msg->ops_AttrList);

	Object *buttongroup;
	Object *bu_save,*bu_use,*bu_test,*bu_cancel;
	TagItem *roottag;

	D(BUG("New! True Class: %p\n",obj));

	/* insert InitTagList */

	InitTagList[sizeof(InitTagList)/sizeof(struct TagItem)-1].ti_Data=(ULONG)msg->ops_AttrList;
	msg->ops_AttrList=InitTagList;

	/*	Menu */

	InitTagList[0].ti_Data=(ULONG)MenustripObject,
		FChild, MenuObject,
			MUIA_Menu_Title, GetStr(MSG_MENU_PROJECT),
			FChild, MenuitemObject,
				MUIA_Menuitem_Title,GetStr(MSG_MENU_PROJECT_OPEN),
				MUIA_Menuitem_Shortcut,GetStr(MSG_MENU_PROJECT_OPEN_SHORT),
				MUIA_UserData, menu_load,
				End,
			FChild, MenuitemObject,
				MUIA_Menuitem_Title,GetStr(MSG_MENU_PROJECT_SAVEAS),
				MUIA_Menuitem_Shortcut,GetStr(MSG_MENU_PROJECT_SAVEAS_SHORT),
				MUIA_UserData, menu_saveas,
				End,
			FChild, MenuitemObject,
				MUIA_Menuitem_Title, NM_BARLABEL,
				End,
			FChild, MenuitemObject,
				MUIA_Menuitem_Title,GetStr(MSG_MENU_PROJECT_QUIT),
				MUIA_Menuitem_Shortcut,GetStr(MSG_MENU_PROJECT_QUIT_SHORT),
				MUIA_UserData, menu_quit,
				End,
			End,

		FChild, MenuObject,
			MUIA_Menu_Title, GetStr(MSG_MENU_EDIT),
			FChild, MenuitemObject,
				MUIA_Menuitem_Title,GetStr(MSG_MENU_EDIT_DEFAULTS),
				MUIA_Menuitem_Shortcut,GetStr(MSG_MENU_EDIT_DEFAULTS_SHORT),
				MUIA_UserData, menu_defaults,
				End,
			FChild, MenuitemObject,
				MUIA_Menuitem_Title,GetStr(MSG_MENU_EDIT_LASTSAVED),
				MUIA_Menuitem_Shortcut,GetStr(MSG_MENU_EDIT_LASTSAVED_SHORT),
				MUIA_UserData, menu_lastsaved,
				End,
			FChild, MenuitemObject,
				MUIA_Menuitem_Title,GetStr(MSG_MENU_EDIT_RESTORE),
				MUIA_Menuitem_Shortcut,GetStr(MSG_MENU_EDIT_RESTORE_SHORT),
				MUIA_UserData, menu_restore,
				End,
			End,
		End;


	if (roottag=FindTagItem(MUIA_Window_RootObject,msg->ops_AttrList))
		{
		buttongroup=HGroup,
			MUIA_Group_SameSize, TRUE,
			Child, bu_save=MakeButton(MSG_BUTTON_SAVE),
			Child, bu_use=MakeButton(MSG_BUTTON_USE),
			testbutton?Child:TAG_IGNORE,
				testbutton?bu_test=MakeButton(MSG_BUTTON_TEST):NULL,
			Child, bu_cancel=MakeButton(MSG_BUTTON_CANCEL),
			End;

		roottag->ti_Data=(ULONG)VGroup,
			Child, roottag->ti_Data,
			Child, buttongroup,
			End;

		if (obj=(Object *)DoSuperMethodA(cl,obj,(APTR)msg))
			{
			data=INST_DATA(cl,obj);
			data->usedefaults=usedefaults;

			/* Pool für Type SWIT_COMPLEX */

			if (data->pool=CreatePool(MEMF_CLEAR,1024,1024))
				{
				/* Buttons */

				DoMethod(bu_save,MUIM_Notify,MUIA_Pressed,FALSE,
					obj,1,MUIM_SettingsWindow_Save);
				DoMethod(bu_use,MUIM_Notify,MUIA_Pressed,FALSE,
					obj,1,MUIM_SettingsWindow_Use);

				if (testbutton)
					{
					DoMethod(bu_test,MUIM_Notify,MUIA_Pressed,FALSE,
						obj,3,MUIM_Set,MUIA_SettingsWindow_TestMode,TRUE);
					}

				DoMethod(bu_cancel,MUIM_Notify,MUIA_Pressed,FALSE,
					obj,1,MUIM_SettingsWindow_Cancel);
				DoMethod(obj,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
					obj,1,MUIM_SettingsWindow_Cancel);

				/* Menu */

				DoMethod(obj,MUIM_Notify,MUIA_Window_MenuAction,menu_load,
					obj,1,MUIM_SettingsWindow_Load);
				DoMethod(obj,MUIM_Notify,MUIA_Window_MenuAction,menu_defaults,
					obj,1,MUIM_SettingsWindow_Defaults);
				DoMethod(obj,MUIM_Notify,MUIA_Window_MenuAction,menu_lastsaved,
					obj,1,MUIM_SettingsWindow_LastSaved);
				DoMethod(obj,MUIM_Notify,MUIA_Window_MenuAction,menu_restore,
					obj,1,MUIM_SettingsWindow_Restore);
				DoMethod(obj,MUIM_Notify,MUIA_Window_MenuAction,menu_saveas,
					obj,1,MUIM_SettingsWindow_SaveAs);
				DoMethod(obj,MUIM_Notify,MUIA_Window_MenuAction,menu_quit,
					obj,1,MUIM_SettingsWindow_Cancel);

				NewList((struct List *)&data->notifylist);

				erfolg=TRUE;
				}
			}
		}

	if (!erfolg)
		{
		if (obj)
			{
			CoerceMethod(cl,obj,OM_DISPOSE);
			obj=NULL;
			}
		}

	return((ULONG)obj);
}


static ULONG SettingsWindow_Dispose(struct IClass *cl,Object *obj,Msg msg)
{
	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	/* remove and free notification handlers */

	while (!IsMinListEmpty(&data->notifylist))
		{
		struct MinNode *mn=data->notifylist.mlh_Head;

		Remove((struct Node *)mn);
		FreeVec(mn);
		}

	/* free the settings items */

	if (data->items)
		{
		FreeVec(data->items);
		}

	/* free the default items */

	if (data->defitems)
		{
		FreeVec(data->defitems);
		}

	if (data->pool)
		{
		DeletePool(data->pool);
		}

	return(DoSuperMethodA(cl,obj,(APTR)msg));
}


static ULONG SettingsWindow_Get(struct IClass *cl,Object *obj,struct opGet *msg)
{
	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	switch (msg->opg_AttrID)
		{
		case MUIA_SettingsWindow_Changed:
			*msg->opg_Storage=data->changed;
			break;

		case MUIA_SettingsWindow_PortDirectly:
			*msg->opg_Storage=(ULONG)data->portdirectly;
			break;

		case MUIA_SettingsWindow_TestMode:
			*msg->opg_Storage=(ULONG)data->testmode;
			break;
		default:
			return(DoSuperMethodA(cl,obj,(APTR)msg));
		}

	return(TRUE);
}


static ULONG SettingsWindow_Set(struct IClass *cl,Object *obj,struct opSet *msg)
{
	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	struct TagItem *ti;
	ULONG result;

	if (ti=FindTagItem(MUIA_SettingsWindow_Changed,msg->ops_AttrList))
		{
		if (!data->changed)
			{
			data->changed=ti->ti_Data;
			}
		else
			{
			ti->ti_Tag=TAG_IGNORE;
			}
		}

	if (ti=FindTagItem(MUIA_SettingsWindow_PortDirectly,msg->ops_AttrList))
		{
		data->portdirectly=ti->ti_Data;
		}

	if (ti=FindTagItem(MUIA_SettingsWindow_TestMode,msg->ops_AttrList))
		{
		if (ti->ti_Data)
			{
			DoMethod(obj,MUIM_SettingsWindow_Store);

			data->testmode=TRUE;
			}
		else
			{
			data->testmode=FALSE;
			}
		}

	result=DoSuperMethodA(cl,obj,(APTR)msg);

	/* Reset after Notification */

	if (ti=FindTagItem(MUIA_SettingsWindow_Changed,msg->ops_AttrList))
		{
		data->changed=FALSE;
		}

	return(result);
}


static ULONG SettingsWindow_Export(struct IClass *cl,Object *obj,struct MUIP_Export *msg)
{
	/* Attribute in Datei (bzw. DataspaceObject) exportieren
	**	für portdirect==TRUE direkt von Objekten, sonst aus
	**	SettingsWindow
	*/

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	ULONG i,value;

	for (i=0;i<data->itemnum;i++)
		{
		if (!data->portdirectly)
			{
			/* die settings items exportieren */

			value=SettingsWindow_GetItemNum(obj,data,i);

			switch (data->items[i].swi_Type & SWIT_TYPES)
				{
				/*	Standardattr */

				case SWIT_STANDARD:
					DoMethod(msg->dataspace,MUIM_Dataspace_Add,
						&value,sizeof(LONG),
						data->items[i].swi_ID);
					break;

				/* String */

				case SWIT_STRING:
					if (value)
						{
						DoMethod(msg->dataspace,MUIM_Dataspace_Add,
							value,
							strlen((STRPTR)value)+1,
							data->items[i].swi_ID);
						}
					break;

				/* beliebig (Struktur) */

				case SWIT_STRUCT:
					if (value)
						{
						DoMethod(msg->dataspace,MUIM_Dataspace_Add,
							value,
							data->items[i].swi_Size,
							data->items[i].swi_ID);
						}
					break;

				/* komplexe Struktur */

				case SWIT_COMPLEX:
					if (value)
						{
						/* Zeiger auf Strukturanfang */

						value-=sizeof(struct MUIS_SettingsWindow_ComplexContents);

						DoMethod(msg->dataspace,MUIM_Dataspace_Add,
							value,
							((struct MUIS_SettingsWindow_ComplexContents *)value)->swc_Size,
							data->items[i].swi_ID);
						}
					break;

				/* alle Listentypen */

				CASE_LIST:
					if (value)
						{
						/* Zeiger auf Strukturanfang */

						value-=sizeof(struct MUIS_SettingsWindow_ListContents);

						DoMethod(msg->dataspace,MUIM_Dataspace_Add,
							value,
							((struct MUIS_SettingsWindow_ListContents *)value)->swl_Size,
							data->items[i].swi_ID);
						}
					break;

				}
			}
		else
			{
			/* die Attribute der Objekte direkt exportieren */

			ULONG help;

			switch (data->items[i].swi_Type & SWIT_TYPES)
				{
				/* Standardattr */

				case SWIT_STANDARD:
					get(data->items[i].swi_Obj,data->items[i].swi_Attr,&help);

					DoMethod(msg->dataspace,MUIM_Dataspace_Add,
						&help, sizeof(LONG), data->items[i].swi_ID);
					break;

				/* String */

				case SWIT_STRING:
					get(data->items[i].swi_Obj,data->items[i].swi_Attr,&help);

					DoMethod(msg->dataspace,MUIM_Dataspace_Add,
						help, strlen((STRPTR)help)+1, data->items[i].swi_ID);
					break;

				/* beliebig (Struktur) */

				case SWIT_STRUCT:
					get(data->items[i].swi_Obj,data->items[i].swi_Attr,&help);

					DoMethod(msg->dataspace,MUIM_Dataspace_Add,
						help, data->items[i].swi_Size, data->items[i].swi_ID);
					break;

				/* komplexe Struktur */

				case SWIT_COMPLEX:
					help=(ULONG)Complex_SmartStore(data->items[i].swi_Obj,
						data->items[i].swi_Attr,(UWORD *)data->items[i].swi_Size,
						data->pool);
					DoMethod(msg->dataspace,MUIM_Dataspace_Add,
						help,
						((struct MUIS_SettingsWindow_ComplexContents *)help)->swc_Size,
						data->items[i].swi_ID);
					FreeVecPooled(data->pool,(APTR)help);
					break;

				/* alle Listentypen */

				CASE_LIST:
					help=(ULONG)List_SmartStore(data->items[i].swi_Obj,
						data->items[i].swi_Type,(UWORD *)data->items[i].swi_Size,
						data->pool);
					DoMethod(msg->dataspace,MUIM_Dataspace_Add,
						help,
						((struct MUIS_SettingsWindow_ListContents *)help)->swl_Size,
						data->items[i].swi_ID);
					FreeVecPooled(data->pool, (APTR)help);
					break;
				}
			}
		}

	return(0);
}


static ULONG SettingsWindow_Import(struct IClass *cl,Object *obj,struct MUIP_Import *msg)
{
	/* Importieren der Attribute aus Datei (Dataspaceobject)
	**	für portdirect==TRUE direkt in Objekte laden, sonst in
	**	SettingsWindow und dann mit Reset übernehmen
	*/

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	ULONG i;
	ULONG *value;

	for (i=0;i<data->itemnum;i++)
		{
		if (value = (ULONG *)DoMethod(msg->dataspace,
				MUIM_Dataspace_Find,data->items[i].swi_ID))
			{
			if (!data->portdirectly)
				{
				/* in SettingsWindow importieren */

				switch (data->items[i].swi_Type & SWIT_TYPES)
					{
					/* Standardattr */

					case SWIT_STANDARD:
						swset(obj,data->items[i].swi_ID,*value);
						break;

					/* String oder Struktur */

					case SWIT_STRING:
					case SWIT_STRUCT:
						swset(obj,data->items[i].swi_ID,value);
						break;

					/* komplexe Struktur */

					case SWIT_COMPLEX:
						/* Relozieren in fremdem Speicherbereich!!! */

						Complex_Reloc((APTR)value,
							(UWORD *)data->items[i].swi_Size);

						swset(obj,data->items[i].swi_ID,(ULONG)value+sizeof(struct MUIS_SettingsWindow_ComplexContents));
						break;

					/* alle Listentypen */

					CASE_LIST:
						/* Relozieren in fremdem Speicherbereich!!! */

						List_Reloc((APTR)value,data->items[i].swi_Type,
							(UWORD *)data->items[i].swi_Size);

						swset(obj,data->items[i].swi_ID,(ULONG)value+sizeof(struct MUIS_SettingsWindow_ListContents));
						break;
					}
				}
			else
				{
				/* direkt in Objekte importieren */

				switch (data->items[i].swi_Type & SWIT_TYPES)
					{
					/* Standardattr */

					case SWIT_STANDARD:
						set(data->items[i].swi_Obj,data->items[i].swi_Attr,*value);
						break;

					/* String oder Struktur */

					case SWIT_STRING:
					case SWIT_STRUCT:
						set(data->items[i].swi_Obj,data->items[i].swi_Attr,value);
						break;

					/* komplexe Struktur */

					case SWIT_COMPLEX:
						/* Relozieren in fremdem Speicherbereich!!! */

						Complex_Reloc((APTR)value,
							(UWORD *)data->items[i].swi_Size);
						set(data->items[i].swi_Obj,data->items[i].swi_Attr,
							&((struct MUIS_SettingsWindow_ComplexContents *)value)->swc_Entry);
						break;

					/* alle Listentypen */

					CASE_LIST:
						/* Relozieren in fremdem Speicherbereich!!! */

						List_Reloc((APTR)value,data->items[i].swi_Type,
							(UWORD *)data->items[i].swi_Size);
						List_SmartReset(data->items[i].swi_Obj,
							data->items[i].swi_Type,(APTR)value,
							(UWORD *)data->items[i].swi_Size);
						break;
					}
				}
			}
		}

	if (!data->portdirectly)
		{
		DoMethod(obj,MUIM_SettingsWindow_Reset);

		/* Notifications auf MUIA_..._Changed auslösen */

		set(obj,MUIA_SettingsWindow_Changed,TRUE);
		}

	return(0);
}


static ULONG SettingsWindow_Save(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Save *msg)
{
	/* wie Use, nur zusätzlich ins ENVARC: speichern */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	DoMethod(obj,MUIM_SettingsWindow_Use);

	DoMethod(_app(obj),MUIM_Application_Save,MUIV_Application_Save_ENVARC);

	return(TRUE);
}


static ULONG SettingsWindow_Use(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Use *msg)
{
	/*	Fenster schließen, Attribute von Objekten in Settingswindow
	** übernehmen und ins ENV: speichern
	*/

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	set(obj,MUIA_Window_Open,FALSE);
	DoMethod(obj,MUIM_SettingsWindow_Store);
	set(obj,MUIA_SettingsWindow_TestMode,FALSE);
	DoMethod(_app(obj),MUIM_Application_Save,MUIV_Application_Save_ENV);

	return(TRUE);
}


static ULONG SettingsWindow_Cancel(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Cancel *msg)
{
	/* Fenster schließen und Objekte zurücksetzen */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	set(obj,MUIA_Window_Open,FALSE);

	if (data->testmode)
		{
		/* TestMode -> zuletzt gespeichertes Laden, dann in Items */

		DoMethod(obj,MUIM_SettingsWindow_Restore);
		DoMethod(obj,MUIM_SettingsWindow_Store);
		set(obj,MUIA_SettingsWindow_TestMode,FALSE);
		}

	else
		{
		/* kein TestMode -> Objekte zurücksetzen */

		DoMethod(obj,MUIM_SettingsWindow_Reset);
		}

	return(TRUE);
}


static ULONG SettingsWindow_Load(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Load *msg)
{
	/* AslRequester öffnen und Einstellungen aus File in Objekte laden */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	struct FileRequester *req;
	STRPTR filename;
	struct Window *iwin;

	get(obj,MUIA_Window_Window,&iwin);

	if (req=AllocAslRequest(ASL_FileRequest,TAG_DONE))
		{
		set(obj,MUIA_Window_Sleep,TRUE);

		if (AslRequestTags(req,
				ASLFR_Window, iwin,
				ASLFR_TitleText, GetStr(MSG_ASLREQ_LOAD),
				ASLFR_InitialDrawer, "SYS:Prefs/Presets",
				TAG_DONE))
			{
			if (strlen(req->fr_File)>0)
				{
				if (filename=AllocVec(256,MEMF_CLEAR))
					{
					strcpy(filename,req->fr_Drawer);

					if (AddPart(filename,req->fr_File,256))
						{
						/* portdirect=TRUE -> direkt in Objekte, nicht ins
						** SettingsWindow laden
						*/

						set(obj,MUIA_SettingsWindow_PortDirectly,TRUE);
						DoMethod(_app(obj),MUIM_Application_Load,filename);
						set(obj,MUIA_SettingsWindow_PortDirectly,FALSE);
						}

					FreeVec(filename);
					}
				}
			}

		set(obj,MUIA_Window_Sleep,FALSE);
		FreeAslRequest(req);
		}

	return(TRUE);
}


static ULONG SettingsWindow_Defaults(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Defaults *msg)
{
	/* reset to defaults */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	ULONG i;

	if (data->defitems)
	{
		for (i=0;i<data->itemnum;i++)
		{
			switch (data->items[i].swi_Type & SWIT_TYPES)
			{
				/* Standardattr */

				case SWIT_STANDARD:
					set(data->items[i].swi_Obj,data->items[i].swi_Attr,
						data->defitems[i]);
					break;

				/* String oder Struktur */

				case SWIT_STRING:
				case SWIT_STRUCT:
					set(data->items[i].swi_Obj,data->items[i].swi_Attr,
						data->defitems[i]);
					break;

				/* komplexe Struktur */

				case SWIT_COMPLEX:
					set(data->items[i].swi_Obj,data->items[i].swi_Attr,
						&((struct MUIS_SettingsWindow_ComplexContents *)data->defitems[i])->swc_Entry);
					break;

				/* alle Listentypen */

				CASE_LIST:
					List_SmartReset(data->items[i].swi_Obj,
						data->items[i].swi_Type,(APTR)data->defitems[i],
						(UWORD *)data->items[i].swi_Size);
					break;
			}
		}
	}

	return(TRUE);
}


static ULONG SettingsWindow_LastSaved(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_LastSaved *msg)
{
	/* zuletzt gespeicherte Einstellungen laden */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	/* portdirect=TRUE -> direkt in Objekte, nicht ins SettingsWindow */

	set(obj,MUIA_SettingsWindow_PortDirectly,TRUE);
	DoMethod(_app(obj),MUIM_Application_Load,MUIV_Application_Load_ENVARC);
	set(obj,MUIA_SettingsWindow_PortDirectly,FALSE);

	return(TRUE);
}


static ULONG SettingsWindow_Restore(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Restore *msg)
{
	/* zuletzt benutzte Einstellungen laden */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	/* portdirect=TRUE -> direkt in Objekte, nicht ins SettingsWindow */

	set(obj,MUIA_SettingsWindow_PortDirectly,TRUE);
	DoMethod(_app(obj),MUIM_Application_Load,MUIV_Application_Load_ENV);
	set(obj,MUIA_SettingsWindow_PortDirectly,FALSE);

	return(TRUE);
}


static ULONG SettingsWindow_SaveAs(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_SaveAs *msg)
{
	/* AslRequester öffnen und Einstellungen von Objekten in File
	** speichern
	*/

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	struct FileRequester *req;
	STRPTR filename;
	struct Window *iwin;

	get(obj,MUIA_Window_Window,&iwin);

	if (req=AllocAslRequest(ASL_FileRequest,TAG_DONE))
		{
		set(obj,MUIA_Window_Sleep,TRUE);

		if (AslRequestTags(req,
				ASLFR_Window, iwin,
				ASLFR_TitleText, GetStr(MSG_ASLREQ_SAVEAS),
				ASLFR_InitialDrawer, "SYS:Prefs/Presets",
				ASLFR_DoSaveMode, TRUE,
				TAG_DONE))
			{
			if (strlen(req->fr_File)>0)
				{
				if (filename=AllocVec(256,MEMF_CLEAR))
					{
					strcpy(filename,req->fr_Drawer);

					if (AddPart(filename,req->fr_File,256))
						{
						/* portdirect=TRUE -> direkt von Objekten nicht vom
						** SettingsWindow
						*/

						set(obj,MUIA_SettingsWindow_PortDirectly,TRUE);
						DoMethod(_app(obj),MUIM_Application_Save,filename);
						set(obj,MUIA_SettingsWindow_PortDirectly,FALSE);
						}

					FreeVec(filename);
					}
				}
			}

		set(obj,MUIA_Window_Sleep,FALSE);
		FreeAslRequest(req);
		}

	return(TRUE);
}


static ULONG SettingsWindow_Init(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Init *msg)
{
	/* Initialisierung des SettingsWindows */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	ULONG i=0,size=0;
	APTR	curdata;

	while (msg->Items[i].swi_Obj)
		{
		/* Ermittlung der Anzahl der Einträge und des benötigten Speichers */

		switch ((msg->Items[i].swi_Type & SWIT_TYPES))
			{
			case SWIT_STRING:
			case SWIT_STRUCT:
				size=(size+msg->Items[i].swi_Size+3) & (~3L);
				break;
			}

		i++;
		}

	data->itemnum=i;
	size+=sizeof(struct MUIS_SettingsWindow_Item)*data->itemnum;

	if (data->items=AllocVec(size,MEMF_CLEAR))
		{
		/* curdata: Pointer auf Speicher für Werte */

		curdata=(APTR)((ULONG)data->items+sizeof(struct MUIS_SettingsWindow_Item)*data->itemnum);

		for (i=0;i<data->itemnum;i++)
			{
			*((struct MUIS_SettingsWindow_Init_Item *)&data->items[i])=msg->Items[i];

			switch ((data->items[i].swi_Type & SWIT_TYPES))
				{
				/* Nur für Strings und Structs, sonst reicht swi_Contents */

				case SWIT_STRING:
				case SWIT_STRUCT:
					data->items[i].swi_Contents=(ULONG)curdata;
					curdata=(APTR)(((ULONG)curdata+msg->Items[i].swi_Size+3) & (~3L));
					break;
				}
			}

		/* Attribute von Objekten übernehmen, zu defaults kopieren und
		**	aktuelle Einstellungen laden
		*/

		/* avoid double notification on MUIA_..._Changed */

		data->changed=TRUE;
		DoMethod(obj,MUIM_SettingsWindow_Store);
		data->changed=FALSE;

		/* these settings are the default ones, so copy them */

		if (data->usedefaults)
		{
			if (data->defitems = AllocVec(data->itemnum*sizeof(ULONG), MEMF_CLEAR))
			{
				for (i = 0; i < data->itemnum; i++)
				{
					if (data->items[i].swi_Contents)
					{
						switch ((data->items[i].swi_Type & SWIT_TYPES))
						{
							/*	Standardattr. */

							case SWIT_STANDARD:
								data->defitems[i] = data->items[i].swi_Contents;
								break;

							/*	String */

							case SWIT_STRING:
								data->defitems[i] = (ULONG)strdupp(data->pool,
									(STRPTR)data->items[i].swi_Contents);
								break;

							/*	Struktur */

							case SWIT_STRUCT:
								if (data->defitems[i] = (ULONG)AllocVecPooled(
									data->pool, data->items[i].swi_Size))
									memcpy((APTR)data->defitems[i],
										(APTR)data->items[i].swi_Contents,
										data->items[i].swi_Size);
								break;

							/* komplexe Struktur */

							case SWIT_COMPLEX:
								data->defitems[i] = (ULONG)Complex_Duplicate(
									(APTR)data->items[i].swi_Contents,
									(UWORD *)data->items[i].swi_Size, data->pool);
								break;

							/* alle Listentypen */

							CASE_LIST:
								data->defitems[i] =(ULONG)List_Duplicate(
									(struct MUIS_SettingsWindow_ListContents *)data->items[i].swi_Contents,
									data->items[i].swi_Type,
									(UWORD *)data->items[i].swi_Size, data->pool);
								break;
						}
					}
				}
			}
		}

		DoMethod(_app(obj),MUIM_Application_Load,MUIV_Application_Load_ENV);

D(BUG("Settingswindow completely initialized!\n"));

		return(TRUE);
		}

	return(FALSE);
}


static ULONG SettingsWindow_GetItemNum(Object *obj,
	struct SettingsWindow_Data *data, ULONG num)
{
	/* Get des Items über Nummer statt über ID */

	if (data->items[num].swi_Type & SWIT_EMPTY)
		{
		/* Wert == NULL */

		return(NULL);
		}
	else
		{
		switch (data->items[num].swi_Type & SWIT_TYPES)
			{
			/* Bei Complex/Listen Zeiger auf Entry/Entrytable verschieben */

			case SWIT_COMPLEX:
				return(data->items[num].swi_Contents
					+sizeof(struct MUIS_SettingsWindow_ComplexContents));
				break;

			CASE_LIST:
				return(data->items[num].swi_Contents
					+sizeof(struct MUIS_SettingsWindow_ListContents));
				break;
			}

		return(data->items[num].swi_Contents);
		}
}


static ULONG SettingsWindow_GetItem(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_GetItem *msg)
{
	/* Äquivalent zu OM_Get */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	ULONG i;

	for (i=0;i<data->itemnum;i++)
		{
		if (data->items[i].swi_ID==msg->ID)
			{
			/*	ein Standardattr. oder bloß Zeiger kopieren */

			*msg->Storage=SettingsWindow_GetItemNum(obj,data,i);

			return(TRUE);
			}
		}

	return(FALSE);
}


static void SettingsWindow_NotifyItem(Object *obj,
	struct SettingsWindow_Data *data, ULONG itemid, ULONG itemvalue)
{
	/* notification mgl., Notificationliste parsen */

	if (!IsMinListEmpty(&data->notifylist))
		{
		struct NotifyEntry *ne=(struct NotifyEntry *)&data->notifylist;

		while (ne=(struct NotifyEntry *)ne->ne_Node.mln_Succ)
			{
			if ((itemid==ne->ne_TrigID)
				&& (ne->ne_TrigValue==MUIV_EveryTime
					|| ne->ne_TrigValue==itemvalue))
				{
				/* passende Notification */

				ULONG *trigmsg,i;

				if (trigmsg=AllocVec(4*ne->ne_FollowParams,MEMF_CLEAR))
					{
					Object *destobj=ne->ne_DestObj;

					/*	MUIV_Notify_Self/Window/Application ersetzen */

					switch ((ULONG)destobj)
						{
						case MUIV_Notify_Self:
						case MUIV_Notify_Window:
							destobj=obj;
							break;

						case MUIV_Notify_Application:
							destobj=_app(obj);
							break;
						}

					/*	MUIV_(Not)TriggerValue ersetzen */

					for (i=0;i<ne->ne_FollowParams;i++)
						{
						switch (ne->ne_Params[i])
							{
							case MUIV_TriggerValue:
								trigmsg[i]=itemvalue;
								break;

							case MUIV_NotTriggerValue:
								trigmsg[i]=!itemvalue;
								break;

							default:
								trigmsg[i]=ne->ne_Params[i];
							}
						}

					/* Notification ausführen */

					DoMethodA(destobj,(Msg)trigmsg);

					FreeVec(trigmsg);
					}
				}
			}
		}
}


static ULONG SettingsWindow_SetItem(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_SetItem *msg)
{
	/* Äquivalent zu MUIM_Set */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	ULONG i;

	for (i=0;i<data->itemnum;i++)
		{
		if (data->items[i].swi_ID==msg->ID)
			{
			/* Attribut gefunden */

			if (msg->Value==data->items[i].swi_Contents
				|| msg->Value==NULL && (data->items[i].swi_Type & SWIT_EMPTY))
				{
				/* Endlosloops vermeiden */

				data->nonotify=TRUE;
				}

			if (msg->Value!=NULL)
				{
				/* Value != NULL -> SWIT_EMPTY löschen */

				data->items[i].swi_Type &= ~SWIT_EMPTY;

				switch ((data->items[i].swi_Type & SWIT_TYPES))
					{
					/*	Standardattr. */

					case SWIT_STANDARD:
						data->items[i].swi_Contents=msg->Value;
						break;

					/*	String */

					case SWIT_STRING:
						strcpy((STRPTR)data->items[i].swi_Contents,(STRPTR)msg->Value);
						break;

					/*	Struktur */

					case SWIT_STRUCT:
						memcpy((APTR)data->items[i].swi_Contents,(APTR)msg->Value,data->items[i].swi_Size);
						break;

					/* komplexe Struktur */

					case SWIT_COMPLEX:
						if (data->items[i].swi_Contents)
							{
							FreeVecPooled(data->pool,(APTR)data->items[i].swi_Contents);
							data->items[i].swi_Contents=NULL;
							}

						data->items[i].swi_Contents=(ULONG)Complex_Duplicate(
							(APTR)(msg->Value-sizeof(struct MUIS_SettingsWindow_ComplexContents)),
							(UWORD *)data->items[i].swi_Size,data->pool);
						break;

					/* alle Listentypen */

					CASE_LIST:
						if (data->items[i].swi_Contents)
							{
							FreeVecPooled(data->pool, (APTR)data->items[i].swi_Contents);
							data->items[i].swi_Contents=NULL;
							}

						data->items[i].swi_Contents=(ULONG)List_Duplicate(
							(APTR)(msg->Value-sizeof(struct MUIS_SettingsWindow_ListContents)),
							data->items[i].swi_Type,
							(UWORD *)data->items[i].swi_Size, data->pool);
						break;

					}
				}
			else
				{
				/* Value == NULL -> SWIT_EMPTY setzen für korrektes Get */

				data->items[i].swi_Type |= SWIT_EMPTY;

				switch ((data->items[i].swi_Type & SWIT_TYPES))
					{
					/*	Standardattr. -> trotzdem setzen */

					case SWIT_STANDARD:
						data->items[i].swi_Contents=msg->Value;
						break;

					/*	ein String oder beliebige Daten */

//					case SWIT_STRING:
//					case SWIT_STRUCT:
//						break;

					/* komplexe Struktur */

					case SWIT_COMPLEX:
						if (data->items[i].swi_Contents)
							{
							FreeVecPooled(data->pool,(APTR)data->items[i].swi_Contents);
							data->items[i].swi_Contents=NULL;
							}
						break;

					/* alle Listentypen */

					CASE_LIST:
						if (data->items[i].swi_Contents)
							{
							FreeVecPooled(data->pool, (APTR)data->items[i].swi_Contents);
							data->items[i].swi_Contents=NULL;
							}
						break;
					}
				}

			if (data->nonotify)
				{
				/*	keine Notification, data->nonotify zurücksetzen */

				data->nonotify=FALSE;
				}
			else
				{
				SettingsWindow_NotifyItem(obj,data,msg->ID,msg->Value);
				}

			return(TRUE);
			}
		}

	return(FALSE);
}


static ULONG SettingsWindow_NNSetItem(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_NNSetItem *msg)
{
	/* Äquivalent zu MUIM_NoNotifySet
	** durch nonotify=TRUE Notification verhindern, dann normales SetItem
	*/

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	data->nonotify=TRUE;

	return(SettingsWindow_SetItem(cl,obj,(APTR)msg));
}


static ULONG SettingsWindow_Notify(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Notify *msg)
{
	/* Äquivalent zu MUIM_Notify
	** fügt Notificationhandler (=struct NotifyEntry) in NotifyList ein
	*/

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	struct NotifyEntry *ne;

	if (ne=AllocVec(sizeof(struct NotifyEntry)+msg->FollowParams*4,MEMF_CLEAR))
		{
		/* Speicher besorgt, nun kopieren und in Liste */

		memcpy(&ne->ne_TrigID,&msg->TrigID,NOTIFYSIZE(msg->FollowParams));
		AddTail((struct List *)&data->notifylist,(struct Node *)ne);
		return(TRUE);
		}

	return(FALSE);
}


static ULONG SettingsWindow_KillNotify(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_KillNotify *msg)
{
	/* Äquivalent zu MUIM_KillNotify
	** entfernt Notificationhandler (=struct NotifyEntry) aus NotifyList
	*/

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	struct NotifyEntry *ne=(struct NotifyEntry *)&data->notifylist;

	while ((ne=(struct NotifyEntry *)ne->ne_Node.mln_Succ)
		&& (msg->TrigID!=ne->ne_TrigID))
		{
		}

	if (ne)
		{
		/* Notificationhandler gefunden - removen und freigeben */

		Remove((struct Node *)ne);
		FreeVec(ne);

		return(TRUE);
		}

	return(FALSE);
}


static ULONG SettingsWindow_KillNotifyObj(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_KillNotifyObj *msg)
{
	/* Äquivalent zu MUIM_KillNotifyObj
	** entfernt Notificationhandler (=struct NotifyEntry) aus NotifyList
	*/

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	struct NotifyEntry *ne=(struct NotifyEntry *)&data->notifylist;

	while ((ne=(struct NotifyEntry *)ne->ne_Node.mln_Succ)
		&& (msg->TrigID!=ne->ne_TrigID)
		&& (msg->DestObj!=ne->ne_DestObj))
		{
		}

	if (ne)
		{
		/* Notificationhandler gefunden - removen und freigeben */

		Remove((struct Node *)ne);
		FreeVec(ne);

		return(TRUE);
		}

	return(FALSE);
}


static ULONG SettingsWindow_Reset(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Reset *msg)
{
	/* Zurücksetzen der Objekte auf Einstellungen des SettingsWindows */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	ULONG i,value;

D(BUG("SettingsWindow_Reset\n"));

	for (i=0;i<data->itemnum;i++)
		{
		value=SettingsWindow_GetItemNum(obj,data,i);

		D(BUG("Item: %ld (%p), value: %p\n",i,data->items[i].swi_Type,value));

		switch (data->items[i].swi_Type & SWIT_TYPES)
			{
			/* Standard, String, Struktur und komplexe Struktur */

			case SWIT_STANDARD:
			case SWIT_STRING:
			case SWIT_STRUCT:
			case SWIT_COMPLEX:
				set(data->items[i].swi_Obj,data->items[i].swi_Attr,
					value);
				break;

			/* alle Listentypen */

			CASE_LIST:
				D(BUG("ListString!\n"));
				List_Reset(&data->items[i]);
				break;
			}
		}

D(BUG("SettingsWindow_Reset End\n"));

	return(TRUE);
}


static ULONG SettingsWindow_Store(struct IClass *cl,Object *obj,struct MUIP_SettingsWindow_Store *msg)
{
	/* Übernehmen der Attribute von Objekten ins SettingsWindow */

	struct SettingsWindow_Data *data=INST_DATA(cl,obj);

	ULONG i,help;

D(BUG("SettingsWindow_Store\n"));

	for (i=0;i<data->itemnum;i++)
		{
		switch(data->items[i].swi_Type & SWIT_TYPES)
			{
			/* Standard, String und Struktur */

			case SWIT_STANDARD:
			case SWIT_STRING:
			case SWIT_STRUCT:
				get(data->items[i].swi_Obj,data->items[i].swi_Attr,&help);
				swset(obj,data->items[i].swi_ID,help);
				break;

			/* komplexe Struktur */

			case SWIT_COMPLEX:
				Complex_Store(&data->items[i],data->pool);
				SettingsWindow_NotifyItem(obj,data,data->items[i].swi_ID,
					data->items[i].swi_Contents
					+sizeof(struct MUIS_SettingsWindow_ComplexContents));
				break;

			/* alle Listentypen */

			CASE_LIST:
				List_Store(&data->items[i], data->pool);
				SettingsWindow_NotifyItem(obj,data,data->items[i].swi_ID,
					data->items[i].swi_Contents
					+sizeof(struct MUIS_SettingsWindow_ListContents));
				break;
			}
		}

	/* Notifications auf MUIA_..._Changed auslösen */

	set(obj,MUIA_SettingsWindow_Changed,TRUE);

D(BUG("SettingsWindow_Store End\n"));

	return(TRUE);
}



static SAVEDS ASM ULONG SettingsWindow_Dispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)
{
	switch (msg->MethodID)
		{
		case OM_NEW											: return(SettingsWindow_New					(cl,obj,(APTR)msg));
		case OM_GET											: return(SettingsWindow_Get					(cl,obj,(APTR)msg));
		case OM_SET											: return(SettingsWindow_Set					(cl,obj,(APTR)msg));
		case MUIM_Export									: return(SettingsWindow_Export				(cl,obj,(APTR)msg));
		case MUIM_Import									: return(SettingsWindow_Import				(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Save					: return(SettingsWindow_Save					(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Use					: return(SettingsWindow_Use					(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Cancel				: return(SettingsWindow_Cancel				(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Load					: return(SettingsWindow_Load					(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Defaults			: return(SettingsWindow_Defaults				(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_LastSaved			: return(SettingsWindow_LastSaved			(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Restore				: return(SettingsWindow_Restore				(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_SaveAs				: return(SettingsWindow_SaveAs				(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Init					: return(SettingsWindow_Init					(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_GetItem				: return(SettingsWindow_GetItem				(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_SetItem				: return(SettingsWindow_SetItem				(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_NNSetItem			: return(SettingsWindow_NNSetItem			(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Notify				: return(SettingsWindow_Notify				(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_KillNotify			: return(SettingsWindow_KillNotify			(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_KillNotifyObj		: return(SettingsWindow_KillNotifyObj		(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Reset				: return(SettingsWindow_Reset					(cl,obj,(APTR)msg));
		case MUIM_SettingsWindow_Store				: return(SettingsWindow_Store					(cl,obj,(APTR)msg));
		case OM_DISPOSE									: return(SettingsWindow_Dispose				(cl,obj,(APTR)msg));
		}

	return(DoSuperMethodA(cl,obj,msg));
}



/***********************/
/*  MCC/Library stuff  */
/***********************/


LONG ASM MCC_Init(REG(a6) struct Library *mybase)
{
	SysBase = *((struct Library **)4);
	MUIClassBase = mybase;

	InitLocale();

	if (MUIMasterBase = OpenLibrary("muimaster.library",8))
		{
		if (AslBase = OpenLibrary("asl.library",0))
			{
			if (ThisClass = MUI_CreateCustomClass(mybase,SUPERCLASS,NULL,sizeof(struct SettingsWindow_Data),SettingsWindow_Dispatcher))
				{
				UtilityBase		= ThisClass->mcc_UtilityBase;
				DOSBase			= ThisClass->mcc_DOSBase;
				IntuitionBase	= ThisClass->mcc_IntuitionBase;
				GfxBase			= ThisClass->mcc_GfxBase;

				DBINIT;

				return(0);
				}

			CloseLibrary(AslBase);
			}

		CloseLibrary(MUIMasterBase);
		}

	if (LocaleBase)
		{
		CloseLibrary(LocaleBase);
		}

	return(-1);
}


void ASM MCC_Cleanup(REG(a6) struct Library *mybase)
{
	DBEXIT;

	if (MUIMasterBase)
		{
		if (ThisClass) MUI_DeleteCustomClass(ThisClass);
		CloseLibrary(MUIMasterBase);
		}

	if (AslBase)
		{
		CloseLibrary(AslBase);
		}

	ExitLocale();
}


SAVEDS ASM struct MUI_CustomClass *MCC_GetClass(REG(d0) LONG which)
{
	switch (which)
		{
		case 0: return(ThisClass);
		}

	return(NULL);
}



/*
************************
*  Anmerkungen / Bugs  *
************************


* HACK: Relocating in unknown memory area: MUIM_Import->portdirectly->Lists



*/
