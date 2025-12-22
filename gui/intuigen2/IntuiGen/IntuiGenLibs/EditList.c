/*
EditList.c

(C) Copyright 1993 Justin Miller
	This file is part of the IntuiGen package.
	Use of this code is pursuant to the license outlined in
	COPYRIGHT.txt, included with the IntuiGen package.

    As per COPYRIGHT.txt:

	1)  This file may be freely distributed providing that
	    it is unmodified, and included in a complete IntuiGen
	    2.0 package (it may not be distributed alone).

	2)  Programs using this code may not be distributed unless
	    their author has paid the Shareware fee for IntuiGen 2.0.
*/

#include <exec/exec.h>
#include <clib/exec_protos.h>
#include <libraries/GadTools.h>
#include <clib/intuition_protos.h>
#include <intuition/gadgetclass.h>
#include <IntuiGen/GTRequest.h>

#define FirstNode(l) FirstItem(l)
#define NextNode(n) NextItem(n)

#define ALPHA 1
#define UPDATING 2
#define CALLBACK 4

struct EditListInfo {
    struct GTControl *Main,*Listc,*Add,*Delete,*Edit;
    struct List *List;
    struct Remember **Key;
    void (*SetLabels) (struct GTRequest *,struct GTControl *,struct List *);
    ULONG Size;
    ULONG Flags;
};

struct Node *FirstItem(struct List *l);
struct Node *NextItem(struct Node *n);



static void DeleteGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh);

static void NewGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh);

static void EditorDSelected(struct GTRequest *req,struct IntuiMessage *msg,
			struct GTControl *gtc,struct MessageHandler *mh);
static void ListGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh);



static struct TextAttr TextAttributes0 =
{
	"topaz.font",
	TOPAZ_EIGHTY,
	NULL,
	FPF_ROMFONT
};

static struct MessageHandler ListDeleteGadgetUpMH =
{
	NULL,
	"GadgetUp",
	NULL,
	DeleteGadgetUp
};

static struct TagItem ListDeleteTags[]=
{
	{  GA_Disabled, 0 },
	{  TAG_DONE,0  }
};

static struct NewGadget NewListDelete=
{
	292,119,
	28,13,
	(UBYTE *)"-",
	&TextAttributes0,
	1,
	0,
	0,
	0
};

static struct GTControl ListDelete =
{
	NULL,
	BUTTON_KIND,
	GTC_INTERNALCONTROL,
	ListDeleteTags,
	NULL,
	&NewListDelete,
	NULL,
	&ListDeleteGadgetUpMH,
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

static struct MessageHandler ListAddGadgetUpMH =
{
	NULL,
	"GadgetUp",
	NULL,
	NewGadgetUp
};

static struct TagItem ListAddTags[]=
{
	{  GA_Disabled, 0 },
	{  TAG_DONE,0  }
};

static struct NewGadget NewListAdd=
{
	292,105,
	28,13,
	(UBYTE *)"+",
	&TextAttributes0,
	0,
	0,
	0,
	0
};

static struct GTControl ListAdd =
{
	&ListDelete,
	BUTTON_KIND,
	GTC_INTERNALCONTROL,
	ListAddTags,
	NULL,
	&NewListAdd,
	NULL,
	&ListAddGadgetUpMH,
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

static struct MessageHandler ListEditorDSelectedHandler = {
	NULL,
	"StringDSelected",
	NULL,
	EditorDSelected
};

static struct TagItem ListEditorTags[]=
{
	{  GA_Disabled, 0 },
	{  GA_Immediate,1  },
	{  GTST_MaxChars,100  },
	{  STRINGA_Justification,GACT_STRINGLEFT  },
	{  TAG_DONE,0  }
};

static struct NewGadget NewListEditor=
{
	100,0,
	150,14,
	(UBYTE *)"",
	&TextAttributes0,
	0,
	0,
	0,
	0
};

static struct GTControl ListEditor =
{
	&ListAdd,
	STRING_KIND,
	GTC_INTERNALCONTROL,
	ListEditorTags,
	NULL,
	&NewListEditor,
	NULL,
	&ListEditorDSelectedHandler,
	'',
	0,
	0,
	0,0,
	NULL,
	NULL,
	NULL,
	100,0,
	0,
	0,
	GTST_String,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};

static struct TagItem ListTags[] =
{
	{  GTLV_Labels, NULL  },
	{  GTLV_Selected, 0  },
	{  GTCT_NEXTDATATOGADGETADDRESS, 0  },
	{  GTLV_ShowSelected, &ListEditor  },
	{  TAG_DONE, 0	}
};

static struct NewGadget NewList =
{
	100,0,
	150,100,
	"",
	&TextAttributes0,
	0,
	PLACETEXT_LEFT,
	NULL,
	NULL
};

static struct MessageHandler ListGadgetUpMH =
{
	NULL,
	"GadgetUp",
	NULL,
	ListGadgetUp
};

static struct GTControl List =
{
	&ListEditor,
	LISTVIEW_KIND,
	GTC_INTERNALCONTROL,
	ListTags,
	NULL,
	&NewList,
	NULL,
	&ListGadgetUpMH,
	'',
	0,
	0,
	0,0,
	NULL,
	NULL,
	NULL,
	0,0,
	0,
	0xffffffff,
	GTLV_Selected,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
};


__far void AddInternalControl(struct GTRequest *req,struct GTControl *parent,struct GTControl *gtc,ULONG type);
__far struct GTControl *AllocGTControl(struct GTRequest *req,ULONG AdditionalBytes);



__far static void InternalSetLabels(struct GTRequest *req,
			struct EditListInfo *eli,struct List *list)
{
    if (eli->SetLabels)
	(*(eli->SetLabels)) (req,eli->Main,list);
    else SetControlAttrs(req,eli->Main,GTLV_Labels,list,TAG_DONE);
}


__far void SetEditListAttrs(struct GTRequest *req,struct GTControl *gtc,
				struct TagItem *ti)
{
    struct EditListInfo *eli;
    struct TagItem *tstate;

    tstate=ti;

    eli=(struct EditListInfo *)gtc->ControlTags;

    while (ti=NextTagItem(&tstate)) {
	switch(ti->ti_Tag) {
	    case GTLV_Labels:
		if ((eli->Flags & UPDATING) && !(eli->Flags & CALLBACK)) {
		    eli->Flags |= CALLBACK;
		    InternalSetLabels(req,eli,(struct List *)ti->ti_Data);
		    eli->Flags ^= CALLBACK;
		} else {

		    if (!(ti->ti_Data) && !(eli->Flags & UPDATING)) {
			GT_SetGadgetAttrs(eli->Add->Gadget,req->Window,0,
					GA_Disabled,1,TAG_DONE);
			GT_SetGadgetAttrs(eli->Delete->Gadget,req->Window,0,
					GA_Disabled,1,TAG_DONE);
			GT_SetGadgetAttrs(eli->Edit->Gadget,req->Window,0,
					GA_Disabled,1,TAG_DONE);

		    } else if (!(eli->List) && !(eli->Flags & UPDATING)) {
			GT_SetGadgetAttrs(eli->Add->Gadget,req->Window,0,
					GA_Disabled,0,TAG_DONE);
			GT_SetGadgetAttrs(eli->Delete->Gadget,req->Window,0,
					GA_Disabled,0,TAG_DONE);
			GT_SetGadgetAttrs(eli->Edit->Gadget,req->Window,0,
					GA_Disabled,0,TAG_DONE);
		    }
		    if (!(eli->Flags & UPDATING)) eli->List=(struct List *)ti->ti_Data;
		    GT_SetGadgetAttrs(eli->Listc->Gadget,req->Window,0,
					GTLV_Labels,ti->ti_Data,TAG_DONE);
		}
		break;
	    case GTPK_Remember:
		eli->Key=(struct Remember **)ti->ti_Data;
		break;
	    case GTPK_NodeSize:
		eli->Size=ti->ti_Data;
		break;
	    case GTPK_Alpha:
		break;
	    case GTPK_SetList:
		eli->SetLabels=ti->ti_Data;
		break;

	    case GTLV_Selected:
		gtc->Attribute=ti->ti_Data;
	    default:
		SetControlAttrs(req,eli->Listc, ti->ti_Tag,ti->ti_Data,TAG_DONE);
		break;
	}
    }
}

__far struct Gadget *CreateEditListKind(struct GTPKind *kclass,struct Gadget *gad,
				  struct GTControl *gtc,struct GTRequest *req,
				  struct VisualInfo *vinfo)
{
    struct GTControl *list,*add,*rem,*edit;
    struct NewGadget *ng;
    struct TagItem *listtags,*addtags,*remtags,*edittags;
    SHORT x,y,w,h,n;
    struct EditListInfo *eli;

    ng=gtc->NewGadget;
    x=ng->ng_LeftEdge;
    y=ng->ng_TopEdge;
    w=ng->ng_Width;
    h=ng->ng_Height;

    if (list=AllocGTControl(req,0)) {
	if (add=AllocGTControl(req,0)) {
	    if (rem=AllocGTControl(req,0)) {
		if (edit=AllocGTControl(req,0)) {
		    *list=List;
		    *add=ListAdd;
		    *rem=ListDelete;
		    *edit=ListEditor;

		    if (list->NewGadget=AllocNewGadget(req,ng,x,y,w-19,h)) {
			if (add->NewGadget=AllocNewGadget(req,&NewListAdd,
			 x+w-18,y+h-18,18,10)) {
			    if (rem->NewGadget=AllocNewGadget(req,&NewListDelete,
			     x+w-18,y+h-7,18,10)) {
				if (edit->NewGadget=AllocNewGadget(req,&NewListEditor,
				 x,y+h-14,w-19,14)) {

				    if (listtags=AllocRemember(&req->GTKey,
				     sizeof(struct TagItem) * 14, MEMF_PUBLIC)) {
					if (eli=AllocRemember(&req->GTKey,
					 sizeof(*eli),MEMF_PUBLIC | MEMF_CLEAR)) {


					    addtags=&listtags[5];
					    remtags=&listtags[7];
					    edittags=&listtags[9];

					    list->GadgetTags=listtags;

					    for (x=0;x<5;++x) {
						listtags[x]=ListTags[x];
						edittags[x]=ListEditorTags[x];
					    }

					    for (x=0;x<2;++x) {
						addtags[x]=ListAddTags[x];
						remtags[x]=ListDeleteTags[x];
					    }

					    add->GadgetTags=addtags;
					    rem->GadgetTags=remtags;
					    edit->GadgetTags=edittags;

					    listtags[0].ti_Data=GetTagData(GTPK_List,
						0,gtc->GadgetTags);
					    listtags[3].ti_Data=edit;

					    list->UserData=eli;
					    add->UserData=eli;
					    rem->UserData=eli;
					    edit->UserData=eli;

					    AddInternalControl(req,gtc,list,0);
					    AddInternalControl(req,gtc,add,0);
					    AddInternalControl(req,gtc,rem,0);
					    AddInternalControl(req,gtc,edit,0);

					    eli->Main=gtc;
					    eli->Edit=edit;
					    eli->Listc=list;
					    eli->Add=add;
					    eli->Delete=rem;
					    eli->List=(struct List *)listtags[0].ti_Data;
					    eli->Key=(struct Remember **)
					     GetTagData(GTPK_Remember,0,gtc->GadgetTags);
					    eli->Flags = GetTagData(GTPK_Alpha,0,
						gtc->GadgetTags) ? ALPHA : 0;
					    eli->Size = GetTagData(GTPK_NodeSize,
						sizeof(struct Node),gtc->GadgetTags);

					    eli->SetLabels =
						GetTagData(GTPK_SetList,0,gtc->GadgetTags);

					    if (!(eli->List)) {
						addtags[0].ti_Data=
						remtags[0].ti_Data=
						edittags[0].ti_Data=1;
					    }
					    gtc->SetAttrs=SetEditListAttrs;
					    gtc->ControlTags=(struct Gadget *)eli;
					    gtc->Attribute=0xffffffff;
					    return gad;
					}
				    }
				}
			    }
			}
		    }
		}
	    }
	}
    }
    return 0;
}

/* Rules for edittable list to follow:

    gadgetup(editor) :- ord=~0, not(blank(editor)), AddEntryToListBox(),
			 select(lastentry).
    gadgetup(editor) :- ord=~0, blank(editor), select(firstentry).
    gadgetup(editor) :- ord\=~0, not(blank(editor)), ChangeNodesName(ord).
    gadgetup(editor) :- ord\=~0, blank(editor), gadgetup(delete).

    gadgetup(new) :- SetOrd(~0),ActivateGadget(editor).
    gadgetup(delete) :- ord\=~0, RemoveEntryFromListBox(ord).

*/

UBYTE SetUpdating(struct EditListInfo *eli)
{
    if (!(eli->Flags & UPDATING)) {
	eli->Flags|=UPDATING;
	return 1;
    }
    return 0;
}

void ClearUpdating(UBYTE state,struct EditListInfo *eli)
{
    if (state) FLAGOFF(eli->Flags,UPDATING);
}

static void DeleteGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    struct EditListInfo *eli;
    struct Node *n;
    UBYTE state;

    eli=(struct EditListInfo *)gtc->UserData;
    if (eli->List==0 || eli->List==(struct List *)0xffffffff) return;

    state=SetUpdating(eli);

    if (eli->Main->Attribute!=~0) {
	if (n=OrdToNode(eli->List,eli->Listc->Attribute))
	    RemoveEntryFromListBox(req,eli->Main,eli->List,n);
	    msg->IAddress=(APTR)n;
	    SendMessageToControl(req,eli->Main,msg,"DeletedEntry");
	    msg->IAddress=(APTR)eli->List;
	    SendMessageToControl(req,eli->Main,msg,"ChangedList");
	    msg->Code=CountNodesInList(eli->List)-1;
	    msg->IAddress=(APTR)n;
	    SendMessageToControl(req,eli->Main,msg,"GadgetUp");
    }
    ClearUpdating(state,eli);
}

static void NewGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    struct EditListInfo *eli;
    UBYTE state;

    eli=(struct EditListInfo *)gtc->UserData;
    if (eli->List==0 || eli->List==(struct List *)0xffffffff || eli->Key==0) return;

    state=SetUpdating(eli);

    SetControlAttrs(req,eli->Main,GTLV_Selected,~0,TAG_DONE);
    msg->Code=~0;
    msg->IAddress=0;
    SendMessageToControl(req,eli->Main,msg,"GadgetUp");
    ActivateGadget(eli->Edit->Gadget,req->Window,0);

    ClearUpdating(state,eli);
}

static void EditorDSelected(struct GTRequest *req,struct IntuiMessage *msg,
			struct GTControl *gtc,struct MessageHandler *mh)
{
    struct EditListInfo *eli;
    struct StringInfo *si;
    UBYTE isblank;
    UBYTE state;

    eli=(struct EditListInfo *)gtc->UserData;
    if (eli->List==0 || eli->List==(struct List *)0xffffffff || eli->Key==0) return;

    state=SetUpdating(eli);

    si=(struct StringInfo *)eli->Edit->Gadget->SpecialInfo;
    isblank=!(si->Buffer[0]);


    if (eli->Main->Attribute==~0) {
	if (!isblank) {
	    struct Node *n;

	    n=AddEntryToListBox(eli->Key,req,eli->Main,eli->List,si->Buffer,
		 eli->Size,eli->Flags);

	    msg->IAddress=n;
	    SendMessageToControl(req,eli->Main,msg,"AddedEntry");
	    msg->IAddress=eli->List;
	    SendMessageToControl(req,eli->Main,msg,"ChangedList");

	    msg->Code=NodeToOrd(eli->List,n);
	    SetControlAttrs(req,eli->Listc,GTLV_Selected,
		msg->Code,TAG_DONE);

	    msg->IAddress=n;

	    SendMessageToControl(req,eli->Main,msg,"GadgetUp");
	} else {
	    SetControlAttrs(req,eli->Listc,GTLV_Selected,0,TAG_DONE);
	    msg->Code=0;
	    msg->IAddress=(APTR)OrdToNode(eli->List,0);
	    SendMessageToControl(req,eli->Main,msg,"GadgetUp");
	}
    } else {
	if (!isblank) {
	    struct Node *n;

	    if (n=OrdToNode(eli->List,eli->Main->Attribute))
		ChangeNodesName(eli->Key,req,eli->Main,eli->List,n,si->Buffer);
	    msg->IAddress=n;
	    SendMessageToControl(req,eli->Main,msg,"ChangedEntry");
	    msg->IAddress=eli->List;
	    SendMessageToControl(req,eli->Main,msg,"ChangedList");
	} else {
	    DeleteGadgetUp(req,msg,gtc,mh);
	}
    }
    ClearUpdating(state,eli);
}

static void ListGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    struct EditListInfo *eli;

    eli=(struct EditListInfo *)gtc->UserData;

    eli->Main->Attribute=msg->Code;

    SendMessageToControl(req,eli->Main,msg,"GadgetUp");
}

