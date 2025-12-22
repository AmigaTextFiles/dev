/*
** SettingsWindow-Demo.c - V0.40
**
** Written by Ingo Weinhold.
**
** This program demonstrates the usage of the SettingsWindow.mcc.
** It's written using Maxon C++ 3.0. You might need to change some
** parts (especially the include section).
**
** I hope you are not afraid seeing more than 1000 lines of code - hey,
** a lot of them are comments. The three subclasses are only there to
** make it possible to edit the list contents' comfortably - they are
** not needed to use SettingsWindow.mcc.
*/


/* MUI */

#include <libraries/mui.h>
#include <MUI/SettingsWindow_mcc.h>


/* System */

#include <libraries/asl.h>
#include <libraries/gadtools.h>


/* Prototypes */

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/utility_protos.h>
#include <clib/muimaster_protos.h>


/* ANSI C */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <wbstartup.h>


/* Compiler specific stuff */

#define REG(x) register __ ## x
#define ASM
#define SAVEDS


/* Useful stuff */

#ifndef TAG_INGO
#define TAG_INGO ((0x2c01<<16) | TAG_USER)
#endif

#define FChild (MUIA_Family_Child)

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif


/* Pragmas */

#include <pragma/exec_lib.h>


extern struct Library *SysBase;
struct Library *MUIMasterBase,*UtilityBase;


struct MUI_CustomClass *EditListClass=NULL,*StringListClass=NULL,
	*ComplexListClass=NULL;


LONG __stack = 8192;


/*	Menu Return-Values */

#define menu_quit				0x01
#define menu_iconify			0x02
#define menu_settings		0x03
#define menu_settingsmui	0x04
#define menu_aboutmui		0x05


/* ID's for settings items */

#define setid_number		0x01
#define setid_dir			0x02
#define setid_pen			0x03
#define setid_strlist	0x04
#define setid_cpxlist	0x05


STRPTR regtitles[]= {"Simple Types","StringList","ComplexList",NULL};

static const char introtext[] =
"\tThis little application demonstrates the features of \
SettingsWindow.mcc. It is especially thought for programmers who want \
to take a look at it's source code.\n\tThe main window displays the \
current settings. You can change some simple items, a list of strings \
and a rather complex list.";



/* Supporting Function for Lists */


ULONG getactive(Object *obj, APTR &active)
{
	ULONG pos;

	get(obj,MUIA_List_Active,&pos);

	if (pos!=MUIV_List_Active_Off)
		{
		DoMethod(obj,MUIM_List_GetEntry,pos,&active);
		}

	return(pos);
}



/******************
*  EditListClass  *
******************/

/* This class provides four methods for editing lists. */


#define EditListObject	NewObject(EditListClass->mcc_Class,NULL

/* Instance Data */

struct EditList_Data
{
};

#define MUI_EditList_dummy				(TAG_INGO + 0x0000)

/* Attributes */

#define MUIA_EditList_List				(MUI_EditList_dummy + 0x01)

/* Methods */

#define MUIM_EditList_AddEntry		(MUI_EditList_dummy + 0x01)
#define MUIM_EditList_CloneEntry		(MUI_EditList_dummy + 0x02)
#define MUIM_EditList_RemEntry		(MUI_EditList_dummy + 0x03)
#define MUIM_EditList_ActiveChanged	(MUI_EditList_dummy + 0x04)

/* Method Parameter Structures */

struct MUIP_EditList_AddEntry				{ ULONG MethodID; };
struct MUIP_EditList_CloneEntry			{ ULONG MethodID; };
struct MUIP_EditList_RemEntry				{ ULONG MethodID; };
struct MUIP_EditList_ActiveChanged		{ ULONG MethodID; };


static ULONG EditList_New(struct IClass *cl,Object *obj,struct opSet *msg)
{
	Object *grp_buttons,*bu_add,*bu_clone,*bu_rem;
	struct TagItem *ti;
	BOOL success=FALSE;

	if (ti=FindTagItem(MUIA_EditList_List,msg->ops_AttrList))
		{
		ti->ti_Tag=Child;

		if (obj=(Object *)DoSuperMethodA(cl,obj,(APTR)msg))
			{
			if (grp_buttons=HGroup,
					Child, bu_add=SimpleButton("Add"),
					Child, bu_clone=SimpleButton("Clone"),
					Child, bu_rem=SimpleButton("Remove"),
					End)
				{
				DoMethod(obj,OM_ADDMEMBER,grp_buttons);

				DoMethod(bu_add,MUIM_Notify,MUIA_Pressed,FALSE,
					obj,1,MUIM_EditList_AddEntry);
				DoMethod(bu_clone,MUIM_Notify,MUIA_Pressed,FALSE,
					obj,1,MUIM_EditList_CloneEntry);
				DoMethod(bu_rem,MUIM_Notify,MUIA_Pressed,FALSE,
					obj,1,MUIM_EditList_RemEntry);

				DoMethod(obj,MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,
					obj,1,MUIM_EditList_ActiveChanged);

				success=TRUE;
				}
			}
		}

	if (!success)
		{
		if (obj)
			{
			CoerceMethod(cl,obj,OM_DISPOSE);
			obj=NULL;
			}
		}

	return((ULONG)obj);
}


static ULONG EditList_AddEntry(struct IClass *cl,Object *obj,struct MUIP_EditList_AddEntry *msg)
{
	struct EditList_Data *data=INST_DATA(cl,obj);

	DoMethod(obj,MUIM_List_InsertSingle,NULL,MUIV_List_Insert_Bottom);
	set(obj,MUIA_List_Active,MUIV_List_Active_Bottom);

	return(TRUE);
}


static ULONG EditList_CloneEntry(struct IClass *cl,Object *obj,struct MUIP_EditList_CloneEntry *msg)
{
	struct EditList_Data *data=INST_DATA(cl,obj);
	APTR active;

	if (getactive(obj,active)!=MUIV_List_Active_Off)
		{
		DoMethod(obj,MUIM_List_InsertSingle,active,MUIV_List_Insert_Bottom);
		}

	return(TRUE);
}


static ULONG EditList_RemEntry(struct IClass *cl,Object *obj,struct MUIP_EditList_RemEntry *msg)
{
	struct EditList_Data *data=INST_DATA(cl,obj);
	ULONG pos;

	get(obj,MUIA_List_Active,&pos);

	if (pos!=MUIV_List_Active_Off)
		{
		DoMethod(obj,MUIM_List_Remove,pos);
		}

	return(TRUE);
}


static SAVEDS ASM ULONG EditList_Dispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)
{
	switch (msg->MethodID)
		{
		case OM_NEW								: return(EditList_New				(cl,obj,(APTR)msg));
		case MUIM_EditList_AddEntry		: return(EditList_AddEntry			(cl,obj,(APTR)msg));
		case MUIM_EditList_CloneEntry		: return(EditList_CloneEntry		(cl,obj,(APTR)msg));
		case MUIM_EditList_RemEntry		: return(EditList_RemEntry			(cl,obj,(APTR)msg));
		}

	return(DoSuperMethodA(cl,obj,msg));
}



/********************
*  StringListClass  *
********************/

/* This class is a subclass of EditListClass. It features a list and a
** StringObject for editing the lists entries. The Construct/Destruct-
** Hooks are necessary to handle NULL pointers given from
** MUIM_EditList_AddEntry. Setting MUIA_StringList_String changes the
** active entry.
*/

#define StringListObject	NewObject(StringListClass->mcc_Class,NULL

/* Instance Data */

struct StringList_Data
{
	Object *strobj;
};

#define MUI_StringList_dummy				(TAG_INGO + 0x0010)

/* Attributes */

#define MUIA_StringList_String			(MUI_StringList_dummy + 0x01)

/* Methods */

/* Method Parameter Structures */


/* Construct/DestructHook functions */

static APTR ConstructFunc_Strings(REG(a2) APTR pool, REG(a1) STRPTR str)
{
	STRPTR entry=NULL;

	if (entry=AllocPooled(pool,40))
		{
		if (str) strcpy(entry,str);
		}

	return(entry);
}


static VOID DestructFunc_Strings(REG(a2) APTR pool, REG(a1) STRPTR *entry)
{
	if (entry)
		{
		FreePooled(pool,entry,40);
		}
}


static struct Hook ConstructHook_Strings = { { NULL,NULL },(VOID *)ConstructFunc_Strings,NULL,NULL};
static struct Hook DestructHook_Strings = { { NULL,NULL },(VOID *)DestructFunc_Strings,NULL,NULL};


static ULONG StringList_New(struct IClass *cl,Object *obj,struct opSet *msg)
{
	struct StringList_Data *data;
	TagItem itaglist[]={
		MUIA_EditList_List, NULL,
		Child, NULL,
		TAG_MORE,NULL};

	BOOL success=FALSE;

	/* Create Listview and StringObject */

 	itaglist[0].ti_Data=(ULONG)ListviewObject,
		MUIA_Listview_Input, TRUE,
		MUIA_Listview_DragType, MUIV_Listview_DragType_Immediate,
		MUIA_Listview_List, ListObject,
			MUIA_Frame, MUIV_Frame_InputList,
			MUIA_List_DragSortable, TRUE,
			MUIA_List_ConstructHook, &ConstructHook_Strings,
			MUIA_List_DestructHook, &DestructHook_Strings,
			End,
		End,

	itaglist[1].ti_Data=(ULONG)StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_String_MaxLen, 40,
		End,

	/* Insert the additional tags */

	itaglist[sizeof(itaglist)/sizeof(struct TagItem)-1].ti_Data=(ULONG)msg->ops_AttrList;
	msg->ops_AttrList=itaglist;

	if (obj=(Object *)DoSuperMethodA(cl,obj,(APTR)msg))
		{
		data=INST_DATA(cl,obj);
		data->strobj=(Object *)itaglist[1].ti_Data;

		/* the notification that causes modifying the active entry */

		DoMethod(data->strobj,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,
			obj,3,MUIM_Set,MUIA_StringList_String,MUIV_TriggerValue);

		success=TRUE;
		}

	if (!success)
		{
		if (obj)
			{
			CoerceMethod(cl,obj,OM_DISPOSE);
			obj=NULL;
			}
		}

	return((ULONG)obj);
}


static ULONG StringList_Set(struct IClass *cl,Object *obj,struct opSet *msg)
{
	struct StringList_Data *data=INST_DATA(cl,obj);

	struct TagItem *ti;

	if (ti=FindTagItem(MUIA_StringList_String,msg->ops_AttrList))
		{
		ULONG pos;
		STRPTR active;

		if ((pos=getactive(obj,active))!=MUIV_List_Active_Off)
			{
			strcpy(active,(STRPTR)ti->ti_Data);
			DoMethod(obj,MUIM_List_Redraw,pos);
			}
		}

	return(DoSuperMethodA(cl,obj,(APTR)msg));
}


static ULONG StringList_ActiveChanged(struct IClass *cl,Object *obj,struct MUIP_EditList_ActiveChanged *msg)
{
	struct StringList_Data *data=INST_DATA(cl,obj);
	STRPTR active;

	if (getactive(obj,active)!=MUIV_List_Active_Off)
		{
		set(data->strobj,MUIA_String_Contents,active);
		set(_win(obj),MUIA_Window_ActiveObject,data->strobj);
		}

	return(TRUE);
}


static SAVEDS ASM ULONG StringList_Dispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)
{
	switch (msg->MethodID)
		{
		case OM_NEW									: return(StringList_New					(cl,obj,(APTR)msg));
		case OM_SET									: return(StringList_Set					(cl,obj,(APTR)msg));
		case MUIM_EditList_ActiveChanged		: return(StringList_ActiveChanged	(cl,obj,(APTR)msg));
		}

	return(DoSuperMethodA(cl,obj,msg));
}



/*********************
*  ComplexListClass  *
*********************/

/* This class is a subclass of EditListClass. It features a list and
** six objects for editing the lists entries. Setting any of the
** six attributes changes the related item of the active entry.
*/

/* the cycle entries */

STRPTR amigas[] = {"A500","A600","A1200","A2000","A3000","A4000",NULL};
STRPTR cpus[] = {"68000","68020","68030","68040","68060",NULL};
STRPTR tshirts[] = {"S","M","L","XL","XXL",NULL};

#define amiga_size	(sizeof(struct amiga)+sizeof(struct cpu)+sizeof(struct owner)+40)


/* the type of the list entries */

struct cpu
{
	UBYTE cpu;
	UBYTE pad;
	UWORD freq;
};

struct owner
{
	STRPTR name;
	UWORD age;
	UBYTE tshirt;
};

struct amiga
{
	UWORD amiga;
	struct cpu *cpu;
	struct owner *owner;
};


/* This is the array describing the List's entries (struct amiga). */

static UWORD amiga_des[]=
{
	SWIS_STRUCT,									/* struct amiga */
		SWIS_WORD,									/* UWORD amiga */

		SWIS_POINTER, SWIS_STRUCT,				/* pointer to struct cpu */
			SWIS_BYTE,								/* UBYTE cpu */
			SWIS_BYTE,								/* UBYTE pad */
			SWIS_WORD,								/* UWORD freq */
			SWIS_END,								/* end of struct cpu */

		SWIS_POINTER, SWIS_STRUCT,				/* pointer to struct owner */
			SWIS_POINTER, SWIS_STRING,-1,		/* pointer to string name, length not limited */
			SWIS_WORD,								/* UWORD age */
			SWIS_BYTE,								/* UBYTE tshirt */
			SWIS_END,								/* end of struct owner */
		SWIS_END										/* end of struct amiga */
};


#define ComplexListObject	NewObject(ComplexListClass->mcc_Class,NULL

/* Instance Data */

struct ComplexList_Data
{
	Object *amigaobj,*cpuobj,*freqobj,*nameobj,*ageobj,*tshirtobj;
};

#define MUI_ComplexList_dummy				(TAG_INGO + 0x0020)

/* Attributes */

#define MUIA_ComplexList_Amiga			(MUI_ComplexList_dummy + 0x01)
#define MUIA_ComplexList_CPU				(MUI_ComplexList_dummy + 0x02)
#define MUIA_ComplexList_Freq				(MUI_ComplexList_dummy + 0x03)
#define MUIA_ComplexList_Name				(MUI_ComplexList_dummy + 0x04)
#define MUIA_ComplexList_Age				(MUI_ComplexList_dummy + 0x05)
#define MUIA_ComplexList_TShirt			(MUI_ComplexList_dummy + 0x06)

/* Methods */

/* Method Parameter Structures */


/* Construct/Destruct/DisplayHook functions */

static APTR ConstructFunc_Complex(REG(a2) APTR pool,
	REG(a1) struct amiga *amiga)
{
	struct amiga *entry=NULL;
	ULONG i;

	if (entry=AllocPooled(pool,amiga_size))
		{
		for (i=0;i<amiga_size;i++) ((UBYTE *)entry)[i]=0;

		if (amiga) entry->amiga=amiga->amiga;
		entry->cpu=(APTR)((ULONG)entry+sizeof(struct amiga));
		entry->owner=(APTR)((ULONG)entry->cpu+sizeof(struct cpu));

		if (amiga)
			{
			*(entry->cpu)=*(amiga->cpu);
			*(entry->owner)=*(amiga->owner);
			}

		entry->owner->name=(APTR)((ULONG)entry->owner+sizeof(struct owner));

		if (amiga) strcpy(entry->owner->name,amiga->owner->name);
		}

	return(entry);
}


static VOID DestructFunc_Complex(REG(a2) APTR pool, REG(a1) amiga *entry)
{
	if (entry)
		{
		FreePooled(pool,entry,amiga_size);
		}
}


static LONG DisplayFunc_Complex(REG(a2) char **array, REG(a1) struct amiga *entry)
{
	static char buf1[5],buf2[5];


	if (entry==NULL)
		{
		/* Titelzeile */

		*array++ = "\033bAmiga";
		*array++ = "\033bCPU";
		*array++ = "\033bFrequency (MHz)";
		*array++ = "\033bOwner";
		*array++ = "\033bAge";
		*array++ = "\033bTShirt Size";
		}
	else
		{
		sprintf(buf1,"%ld",entry->cpu->freq);
		sprintf(buf2,"%ld",entry->owner->age);

		*array++ = amigas[entry->amiga];
		*array++ = cpus[entry->cpu->cpu];
		*array++ = buf1;
		*array++ = entry->owner->name;
		*array++ = buf2;
		*array++ = tshirts[entry->owner->tshirt];
		}

	return(0);
}


static struct Hook ConstructHook_Complex = { { NULL,NULL },(VOID *)ConstructFunc_Complex,NULL,NULL};
static struct Hook DestructHook_Complex = { { NULL,NULL },(VOID *)DestructFunc_Complex,NULL,NULL};
static struct Hook DisplayHook_Complex = { { NULL,NULL },(VOID *)DisplayFunc_Complex,NULL,NULL};


static ULONG ComplexList_New(struct IClass *cl,Object *obj,struct opSet *msg)
{
	struct ComplexList_Data *data;
	Object *amigaobj,*cpuobj,*freqobj,*nameobj,*ageobj,*tshirtobj;
	TagItem itaglist[]={
		MUIA_EditList_List, NULL,
		TAG_MORE,NULL};

	BOOL success=FALSE;

	/* Create the Listview and the other objects */

 	itaglist[0].ti_Data=(ULONG)HGroup,
		Child, ListviewObject,
			MUIA_Listview_Input, TRUE,
			MUIA_Listview_DragType, MUIV_Listview_DragType_Immediate,
			MUIA_Listview_List, ListObject,
				MUIA_Frame, MUIV_Frame_InputList,
				MUIA_List_DragSortable, TRUE,
				MUIA_List_ConstructHook, &ConstructHook_Complex,
				MUIA_List_DestructHook, &DestructHook_Complex,
				MUIA_List_DisplayHook, &DisplayHook_Complex,
				MUIA_List_Format, ",,,,,",
				MUIA_List_Title, TRUE,
				End,
			End,

		Child, ColGroup(2),
			Child, Label("Computer:"),
			Child, amigaobj=MUI_MakeObject(MUIO_Cycle,NULL,amigas),
			Child, VSpace(0), Child, VSpace(0),

			Child, Label("CPU:"),
			Child, cpuobj=MUI_MakeObject(MUIO_Cycle,NULL,cpus),
			Child, VSpace(0), Child, VSpace(0),

			Child, Label("Frequency (MHz):"),
			Child, freqobj=SliderObject,
				MUIA_Numeric_Min, 1,
				MUIA_Numeric_Max, 200,
				End,
			Child, VSpace(0), Child, VSpace(0),

			Child, Label("Owner:"),
			Child, nameobj=StringObject,
				MUIA_Frame, MUIV_Frame_String,
				MUIA_String_MaxLen, 40,
				End,
			Child, VSpace(0), Child, VSpace(0),

			Child, Label("Age:"),
			Child, ageobj=SliderObject,
				MUIA_Numeric_Min, 1,
				MUIA_Numeric_Max, 100,
				End,
			Child, VSpace(0), Child, VSpace(0),

			Child, Label("TShirt Size:"),
			Child, tshirtobj=MUI_MakeObject(MUIO_Cycle,NULL,tshirts),
			End,
		End,

	/* Insert the additional tags */

	itaglist[sizeof(itaglist)/sizeof(struct TagItem)-1].ti_Data=(ULONG)msg->ops_AttrList;
	msg->ops_AttrList=itaglist;

	if (obj=(Object *)DoSuperMethodA(cl,obj,(APTR)msg))
		{
		data=INST_DATA(cl,obj);
		data->amigaobj=amigaobj;
		data->cpuobj=cpuobj;
		data->freqobj=freqobj;
		data->nameobj=nameobj;
		data->ageobj=ageobj;
		data->tshirtobj=tshirtobj;

		/* the notifications that cause modifying the active entry */

		DoMethod(amigaobj,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
			obj,3,MUIM_Set,MUIA_ComplexList_Amiga,MUIV_TriggerValue);
		DoMethod(cpuobj,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
			obj,3,MUIM_Set,MUIA_ComplexList_CPU,MUIV_TriggerValue);
		DoMethod(freqobj,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,
			obj,3,MUIM_Set,MUIA_ComplexList_Freq,MUIV_TriggerValue);
		DoMethod(nameobj,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,
			obj,3,MUIM_Set,MUIA_ComplexList_Name,MUIV_TriggerValue);
		DoMethod(ageobj,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,
			obj,3,MUIM_Set,MUIA_ComplexList_Age,MUIV_TriggerValue);
		DoMethod(tshirtobj,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
			obj,3,MUIM_Set,MUIA_ComplexList_TShirt,MUIV_TriggerValue);

		success=TRUE;
		}

	if (!success)
		{
		if (obj)
			{
			CoerceMethod(cl,obj,OM_DISPOSE);
			obj=NULL;
			}
		}

	return((ULONG)obj);
}


static ULONG ComplexList_Set(struct IClass *cl,Object *obj,struct opSet *msg)
{
	struct ComplexList_Data *data=INST_DATA(cl,obj);

	struct TagItem *ti;
	ULONG pos;
	struct amiga *active;

	if (ti=FindTagItem(MUIA_ComplexList_Amiga,msg->ops_AttrList))
		{
		if ((pos=getactive(obj,active))!=MUIV_List_Active_Off)
			{
			active->amiga=(UWORD)ti->ti_Data;
			DoMethod(obj,MUIM_List_Redraw,pos);
			}
		}

	if (ti=FindTagItem(MUIA_ComplexList_CPU,msg->ops_AttrList))
		{
		if ((pos=getactive(obj,active))!=MUIV_List_Active_Off)
			{
			active->cpu->cpu=(UBYTE)ti->ti_Data;
			DoMethod(obj,MUIM_List_Redraw,pos);
			}
		}

	if (ti=FindTagItem(MUIA_ComplexList_Freq,msg->ops_AttrList))
		{
		if ((pos=getactive(obj,active))!=MUIV_List_Active_Off)
			{
			active->cpu->freq=(UWORD)ti->ti_Data;
			DoMethod(obj,MUIM_List_Redraw,pos);
			}
		}

	if (ti=FindTagItem(MUIA_ComplexList_Name,msg->ops_AttrList))
		{
		if ((pos=getactive(obj,active))!=MUIV_List_Active_Off)
			{
			strcpy(active->owner->name,(STRPTR)ti->ti_Data);
			DoMethod(obj,MUIM_List_Redraw,pos);
			}
		}

	if (ti=FindTagItem(MUIA_ComplexList_Age,msg->ops_AttrList))
		{
		if ((pos=getactive(obj,active))!=MUIV_List_Active_Off)
			{
			active->owner->age=(UWORD)ti->ti_Data;
			DoMethod(obj,MUIM_List_Redraw,pos);
			}
		}

	if (ti=FindTagItem(MUIA_ComplexList_TShirt,msg->ops_AttrList))
		{
		if ((pos=getactive(obj,active))!=MUIV_List_Active_Off)
			{
			active->owner->tshirt=(UBYTE)ti->ti_Data;
			DoMethod(obj,MUIM_List_Redraw,pos);
			}
		}

	return(DoSuperMethodA(cl,obj,(APTR)msg));
}


static ULONG ComplexList_ActiveChanged(struct IClass *cl,Object *obj,struct MUIP_EditList_ActiveChanged *msg)
{
	struct ComplexList_Data *data=INST_DATA(cl,obj);
	struct amiga *active;

	if (getactive(obj,active)!=MUIV_List_Active_Off)
		{
		set(data->amigaobj,MUIA_Cycle_Active,(ULONG)active->amiga);
		set(data->cpuobj,MUIA_Cycle_Active,(ULONG)active->cpu->cpu);
		set(data->freqobj,MUIA_Numeric_Value,(ULONG)active->cpu->freq);
		set(data->nameobj,MUIA_String_Contents,active->owner->name);
		set(data->ageobj,MUIA_Numeric_Value,(ULONG)active->owner->age);
		set(data->tshirtobj,MUIA_Cycle_Active,(ULONG)active->owner->tshirt);
		}

	return(TRUE);
}


static SAVEDS ASM ULONG ComplexList_Dispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)
{
	switch (msg->MethodID)
		{
		case OM_NEW									: return(ComplexList_New				(cl,obj,(APTR)msg));
		case OM_SET									: return(ComplexList_Set				(cl,obj,(APTR)msg));
		case MUIM_EditList_ActiveChanged		: return(ComplexList_ActiveChanged	(cl,obj,(APTR)msg));
		}

	return(DoSuperMethodA(cl,obj,msg));
}





void ExitClasses()
{
	if (ComplexListClass) MUI_DeleteCustomClass(ComplexListClass);
	if (StringListClass) MUI_DeleteCustomClass(StringListClass);
	if (EditListClass) MUI_DeleteCustomClass(EditListClass);
}


static VOID fail(Object *app, char *str)
{
	/* Application */

	MUI_DisposeObject(app);

	/* Classes */

	ExitClasses();

	/* Libraries */

	if (MUIMasterBase) CloseLibrary(MUIMasterBase);
	if (UtilityBase) CloseLibrary(UtilityBase);

	if (str)
		{
		puts(str);
		exit(20);
		}

	exit(0);
}


void InitClasses()
{
	if (EditListClass = MUI_CreateCustomClass(NULL,MUIC_Group,NULL,sizeof(struct EditList_Data),EditList_Dispatcher))
		{
		StringListClass = MUI_CreateCustomClass(NULL,NULL,EditListClass,sizeof(struct StringList_Data),StringList_Dispatcher);
		ComplexListClass = MUI_CreateCustomClass(NULL,NULL,EditListClass,sizeof(struct ComplexList_Data),ComplexList_Dispatcher);
		}

	if (!((EditListClass) && (StringListClass) && (ComplexListClass)))
		{
		fail(NULL,"Failed to init all custom classes.");
		}
}


static VOID init(VOID)
{
	/* Libraries */

	if (!(UtilityBase = OpenLibrary("utility.library",0)))
		fail(NULL,"Failed to open utility.library.");

	if (!(MUIMasterBase = OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN)))
		fail(NULL,"Failed to open "MUIMASTER_NAME".");

	/* Classes */

	InitClasses();
}


BOOL CheckAsl(ULONG returnid, Object *app, Object *popasl)
{
	if (returnid==MUIV_Application_ReturnID_Quit)
		{
		ULONG active;

		get(popasl,MUIA_Popasl_Active,&active);

		if (active)
			{
			MUI_Request(app,NULL,0,NULL,"OK",
				"Cannot quit now, still an asl popup opened.");
			return(1);
			}
		}

	return(returnid);
}



int main(int argc,char *argv[])
{
	Object *app,*mainwin,*setwin;
	Object *bu_settings;
	Object *sl_number,*te_displaynumber;
	Object *pa_dir,*te_displaydir;
	Object *pp_pen,*pd_displaypen;
	Object *li_strings,*li_displaystrings;
	Object *li_complex,*li_displaycomplex;

	init();

	/* Let's create the application object */

	app = ApplicationObject,
		MUIA_Application_Title      , "SettingsWindow-Demo",
		MUIA_Application_Version    , "$VER: SettingsWindow-Demo 0.40 (14.12.97)",
		MUIA_Application_Copyright  , "©1997 Ingo Weinhold",
		MUIA_Application_Author     , "Ingo Weinhold",
		MUIA_Application_Description, "SettingsWindow-Demo",
		MUIA_Application_Base       , "SettingsWindow-Demo",

		/* the main window */

		SubWindow, mainwin = WindowObject,
			MUIA_Window_Title, "SettingsWindow-Demo",
			MUIA_Window_ID, MAKE_ID('S','W','D','E'),

			MUIA_Window_Menustrip, MenustripObject,
				FChild, MenuObject,
					MUIA_Menu_Title, "Project",
					FChild, MenuitemObject,
						MUIA_Menuitem_Title,"Settings...",
						MUIA_Menuitem_Shortcut,"?",
						MUIA_UserData, menu_settings,
						End,
					FChild, MenuitemObject,
						MUIA_Menuitem_Title,"Settings MUI...",
						MUIA_UserData, menu_settingsmui,
						End,
					FChild, MenuitemObject,
						MUIA_Menuitem_Title, NM_BARLABEL,
						End,
					FChild, MenuitemObject,
						MUIA_Menuitem_Title,"About MUI...",
						MUIA_UserData, menu_aboutmui,
						End,
					FChild, MenuitemObject,
						MUIA_Menuitem_Title, NM_BARLABEL,
						End,
					FChild, MenuitemObject,
						MUIA_Menuitem_Title,"Iconify",
						MUIA_Menuitem_Shortcut,"i",
						MUIA_UserData, menu_iconify,
						End,
					FChild, MenuitemObject,
						MUIA_Menuitem_Title,"Quit",
						MUIA_Menuitem_Shortcut,"q",
						MUIA_UserData, menu_quit,
						End,
					End,
				End,

			WindowContents, VGroup,
				Child, VGroup,
					Child, ListviewObject,
						MUIA_Weight, 50,
						MUIA_Listview_Input, FALSE,
						MUIA_Listview_List, FloattextObject,
							MUIA_Frame, MUIV_Frame_ReadList,
							MUIA_Background, MUII_ReadListBack,
							MUIA_Floattext_Text, introtext,
							MUIA_Floattext_TabSize, 4,
							MUIA_Floattext_Justify, TRUE,
							End,
						End,

					Child, RegisterObject,
						MUIA_Register_Titles, regtitles,
						Child, ColGroup(2),
							Child, Label2("Number:"),
							Child, te_displaynumber=TextObject,
								MUIA_Background, MUII_TextBack,
								MUIA_Frame, MUIV_Frame_Text,
								End,

							Child, Label2("Directory:"),
							Child, te_displaydir=TextObject,
								MUIA_Background, MUII_TextBack,
								MUIA_Frame, MUIV_Frame_Text,
								End,

							Child, Label2("Pen:"),
							Child, pd_displaypen=PendisplayObject,
								MUIA_Frame, MUIV_Frame_Text,
								MUIA_InnerLeft, 0,
								MUIA_InnerTop, 0,
								MUIA_InnerRight, 0,
								MUIA_InnerBottom, 0,
								MUIA_Dropable, FALSE,
								End,
							End,

						Child, ListviewObject,
							MUIA_Listview_Input, FALSE,
							MUIA_Listview_List, li_displaystrings=ListObject,
								MUIA_Frame, MUIV_Frame_ReadList,
								MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
								MUIA_List_DestructHook, MUIV_List_DestructHook_String,
								End,
							End,

						Child, ListviewObject,
							MUIA_Listview_Input, FALSE,
							MUIA_Listview_List, li_displaycomplex=ListObject,
								MUIA_Frame, MUIV_Frame_ReadList,
								MUIA_List_ConstructHook, &ConstructHook_Complex,
								MUIA_List_DestructHook, &DestructHook_Complex,
								MUIA_List_DisplayHook, &DisplayHook_Complex,
								MUIA_List_Format, ",,,,,",
								MUIA_List_Title, TRUE,
								End,
							End,
						End,
					End,

				Child, bu_settings=SimpleButton("Settings..."),
				End,
			End,


		/* Here comes the SettingsWindow object.
		**
		** Just create it like an ordinary window. The root object you
		** supply is put above the Save/Use/Cancel button group.
		** Don't use MUIA_Window_Menustrip!
		**
		** To get a "Test" button you must init
		** MUIA_SettingsWindow_TestButton, TRUE.
		*/

		SubWindow, setwin = SettingsWindowObject,
			MUIA_Window_Title, "SettingsWindow-Demo - Settings",
			MUIA_Window_ID, MAKE_ID('S','W','S','E'),
			MUIA_SettingsWindow_TestButton, TRUE,

			WindowContents, VGroup,
				Child, RegisterObject,
					MUIA_Register_Titles, regtitles,

					Child, ColGroup(2),

						Child, Label1("Number:"),
						Child, sl_number=SliderObject,
							MUIA_Numeric_Min, 1,
							MUIA_Numeric_Max, 100,
							MUIA_Numeric_Value, 5,
							End,

						Child, Label2("Directory:"),
						Child, pa_dir=PopaslObject,
							MUIA_Popstring_String, StringObject,
								MUIA_Frame, MUIV_Frame_String,
								MUIA_String_MaxLen, 256,
								MUIA_String_Contents, "SYS:",
								End,
							MUIA_Popstring_Button, PopButton(MUII_PopDrawer),
							MUIA_Popasl_Type, ASL_FileRequest,
							ASLFR_TitleText, "Select Directory...",
							ASLFR_DrawersOnly, TRUE,
							End,

						Child, Label("Pen:"),
						Child, pp_pen=PoppenObject,
							End,
						End,

					Child, li_strings=StringListObject, End,

					Child, li_complex=ComplexListObject, End,

					End,
				End,
			End,

		End;


	if (!app)
		{
		fail(NULL,"Failed to create application!\n");
		}


	/*** MAINWINDOW ***/

	DoMethod(mainwin,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	/* Menu */

	DoMethod(mainwin,MUIM_Notify,MUIA_Window_MenuAction,menu_settings,
		setwin,3,MUIM_Set,MUIA_Window_Open,TRUE);
	DoMethod(mainwin,MUIM_Notify,MUIA_Window_MenuAction,menu_settingsmui,
		app,2,MUIM_Application_OpenConfigWindow,0);
	DoMethod(mainwin,MUIM_Notify,MUIA_Window_MenuAction,menu_iconify,
		app,3,MUIM_Set,MUIA_Application_Iconified,TRUE);
	DoMethod(mainwin,MUIM_Notify,MUIA_Window_MenuAction,menu_aboutmui,
		app,2,MUIM_Application_AboutMUI,mainwin);
	DoMethod(mainwin,MUIM_Notify,MUIA_Window_MenuAction,menu_quit,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	/* Pressing the settings button implies opening the settings window */

	DoMethod(bu_settings,MUIM_Notify,MUIA_Pressed,FALSE,
		setwin,3,MUIM_Set,MUIA_Window_Open,TRUE);


	/*** SETTINGSWINDOW ***/

	/* Notify when the user has set another...*/

	/* ... Number: */

	DoMethod(setwin,MUIM_SettingsWindow_Notify,setid_number,MUIV_EveryTime,
		te_displaynumber,4,MUIM_SetAsString,MUIA_Text_Contents,"%ld",MUIV_TriggerValue);

	/* ... Directory: */

	DoMethod(setwin,MUIM_SettingsWindow_Notify,setid_dir,MUIV_EveryTime,
		te_displaydir,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue);

	/* ... Pen: */

	DoMethod(setwin,MUIM_SettingsWindow_Notify,setid_pen,MUIV_EveryTime,
		pd_displaypen,3,MUIM_Set,MUIA_Pendisplay_Spec,MUIV_TriggerValue);


	/* ... Listcontents
	**
	**	First clear the list, then insert all entries.
	*/

	/* StringList */

	DoMethod(setwin,MUIM_SettingsWindow_Notify,setid_strlist,MUIV_EveryTime,
		li_displaystrings,1,MUIM_List_Clear);
	DoMethod(setwin,MUIM_SettingsWindow_Notify,setid_strlist,MUIV_EveryTime,
		li_displaystrings,4,MUIM_List_Insert,MUIV_TriggerValue,-1,MUIV_List_Insert_Bottom);

	/* ComplexList */

	DoMethod(setwin,MUIM_SettingsWindow_Notify,setid_cpxlist,MUIV_EveryTime,
		li_displaycomplex,1,MUIM_List_Clear);
	DoMethod(setwin,MUIM_SettingsWindow_Notify,setid_cpxlist,MUIV_EveryTime,
		li_displaycomplex,4,MUIM_List_Insert,MUIV_TriggerValue,-1,MUIV_List_Insert_Bottom);


	/*	Initialize the SettingsWindow
	**
	** Doing it after setting up the notifications causes that the
	** notification methods are executed if old settings could be loaded.
	*/

	DoMethod(setwin,MUIM_SettingsWindow_Init,
		sl_number,MUIA_Numeric_Value,SWIT_STANDARD,0,setid_number,
		pa_dir,MUIA_String_Contents,SWIT_STRING,256,setid_dir,
		pp_pen,MUIA_Pendisplay_Spec,SWIT_STRUCT,sizeof(struct MUI_PenSpec),setid_pen,
		li_strings,0,SWIT_LISTSTRING,-1,setid_strlist,
		li_complex,0,SWIT_LISTCOMPLEX,amiga_des,setid_cpxlist,
		NULL);


	/* Open the main window */

	set(mainwin,MUIA_Window_Open,TRUE);

	/* The main loop is slightly changed to make sure that the ASL
	** requester is closed when exiting.
	*/

		{
		ULONG sigs = 0;

		while (CheckAsl(DoMethod(app,MUIM_Application_NewInput,&sigs),
			app, pa_dir) != MUIV_Application_ReturnID_Quit)
			{
			if (sigs)
				{
				sigs = Wait(sigs | SIGBREAKF_CTRL_C);
				if (sigs & SIGBREAKF_CTRL_C) break;
				}
			}
		}

	set(mainwin,MUIA_Window_Open,FALSE);

	fail(app,NULL);
}


