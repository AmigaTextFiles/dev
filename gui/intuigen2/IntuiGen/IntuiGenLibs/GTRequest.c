/*
GTRequest.c

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


#include <stddef.h>
#include <stdlib.h>
#include <exec/exec.h>
#include <exec/tasks.h>
#include <exec/libraries.h>
#include <exec/lists.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <intuition/intuition.h>
#include <IntuiGen/GTRequest.h>
#include <devices/keymap.h>
#include <devices/inputevent.h>
#include <devices/console.h>
#include <libraries/gadtools.h>
#include <utility/tagitem.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/alib_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/utility_protos.h>

struct Node *FirstItem(struct List *l)
{
    return l->lh_Head!=&l->lh_Tail ? l->lh_Head : 0;
}

struct Node *NextItem(struct Node *n)
{
    return n->ln_Succ->ln_Succ ? n->ln_Succ : 0;
}

struct ReqNode {
    struct Node Node;
    struct GTRequest *req;
};

struct GTPrivate {
    struct Requester *BlockReq;
    struct Gadget *Context;
    struct VisualInfo *vinfo;
    struct Window *OpenedWindow;
    struct Menu *MenuStrip;
    SHORT Blocked;
    SHORT YOffSet;
    struct IntuiMessage LastGadgetEvent,BeforeLastGadgetEvent;
};

__far int cismember (char c,char *set)
/* returns true if c is in set */
{
    short i;
    for (i=0;set[i];++i)
	if (set[i]==c) return (++i);
    return (0);
}

__far void delchars (char *s,USHORT p,USHORT n)
/* deletes n chars starting at position p from string s */
{
    n+=p;
    if (n>strlen(s)) n=strlen(s);
    do {
	s[p++]=s[n];
    } while (s[n++]);
}

__far BOOL strelim (char *s,char *elim,BOOL k)
/* when k is true, only chars in elim allowed, otherwise,
 * only chars not in elim allowed */
{
    SHORT i=-1;
    BOOL f=0;

    while (s[++i])
	if ((cismember(s[i],elim) && !k)||(!cismember(s[i],elim) && k)) {
	    f=1;
	    delchars (s,i--,1);
	}
    return (f);
}


__far void EndGTRequest(struct GTRequest *req,LONG terminate,
		   struct MessageHandler *mh,struct GTControl *gtc)
{
    req->Terminate=terminate;
    req->EndMsgHandler=mh;
    req->EndControl=gtc;
}

__far struct GTControl *AllocGTControl(struct GTRequest *req,ULONG AdditionalBytes)
{
    struct GTControl *k;

    k=AllocRemember(&req->GTKey,sizeof(struct GTControl)+AdditionalBytes,MEMF_PUBLIC | MEMF_CLEAR);
    return k;
}

__far SHORT ASCIIToRawKey (char c);
__far void BindClassToMsgHandler(struct GTRequest *req,struct MessageHandler *mh);

__far void AddInternalControl(struct GTRequest *req,struct GTControl *parent,struct GTControl *gtc,ULONG type)
{
    struct GTControl *c;
    struct MessageHandler *mh;

    gtc->Flags|=type;
    if (!(gtc->Flags & GTC_GOTRAWKEY) && gtc->ASCIICommand) {
	gtc->RawKeyCommand=ASCIIToRawKey(gtc->ASCIICommand);
	gtc->Flags |= GTC_GOTRAWKEY;
    }
    for (mh=gtc->MsgHandlerList;mh;mh=mh->Next)
	 BindClassToMsgHandler(req,mh);

    gtc->Next=parent->Next;
    parent->Next=gtc;
}

__far struct NewGadget *AllocNewGadget(struct GTRequest *req,struct NewGadget *sg,
					    LONG x,LONG y,LONG w,LONG h)
{
    struct NewGadget *ng=0;

    if (ng=AllocRemember(&req->GTKey,sizeof(*ng),MEMF_PUBLIC | MEMF_CLEAR)) {
	/* if (sg) *ng=*sg; */

	ng->ng_GadgetText=sg->ng_GadgetText;
	ng->ng_TextAttr=sg->ng_TextAttr;
	ng->ng_GadgetID=sg->ng_GadgetID;
	ng->ng_Flags=sg->ng_Flags;

	ng->ng_LeftEdge=x;
	ng->ng_TopEdge=y;
	ng->ng_Width=w;
	ng->ng_Height=h;
    }
    return ng;
}

__far void SendMessageToControl(struct GTRequest *req,struct GTControl *gtc,struct IntuiMessage *msg,
				UBYTE *class)
{
    struct MessageHandler *mh;

    for (mh=gtc->MsgHandlerList;mh;mh=mh->Next)
	if (mh->Name && !strcmp(class,mh->Name)) break;

    if (mh && mh->HandlerFunction)
	(*(mh->HandlerFunction)) (req,msg,gtc,mh);
}

__far void SetControlAttrsA (struct GTRequest *req,struct GTControl *gtc,struct TagItem *ti)
{
    struct TagItem *tia;

    if (tia=FindTagItem(gtc->AttributeTag,ti)) {
	gtc->Attribute=tia->ti_Data;
    }

    if (gtc->SetAttrs) (*(gtc->SetAttrs)) (req,gtc,ti);
    else GT_SetGadgetAttrsA(gtc->Gadget,req->Window,0,ti);
}

__far void SetControlAttrs(struct GTRequest *req,struct GTControl *gtc,Tag tag1,...)
{
    SetControlAttrsA(req,gtc,&tag1);
}

/* Generates the necessary structures and SHORT values for a two pixel thick,
 * two color box.  Returns pointer to first of two Border structures.  All
 * information is allocated on the Remember key
*/
__far struct Border *MakeBox (USHORT w,USHORT h,UBYTE c1,UBYTE c2,struct Remember **key)
{
    struct Border *b,*d;
    SHORT *f,*j;

    b=(struct Border *)AllocRemember (key,sizeof(struct Border)*2,MEMF_PUBLIC | MEMF_CLEAR);
    if (!b) return (0);
    f=(SHORT *)AllocRemember (key,48,MEMF_PUBLIC | MEMF_CLEAR);
    if (!f) return (0);
    d=&b[1];
    j=&f[12];

    b->DrawMode=JAM1;
    b->Count=6;
    *d=*b;

    b->XY=f;
    d->XY=j;
    d->FrontPen=c2;
    b->FrontPen=c1;
    b->NextBorder=d;

    f[1]=j[3]=j[5]=h;
    f[4]=j[0]=j[2]=w;
    f[7]=f[8]=f[9]=f[10]=j[6]=j[11]=1;
    f[6]=j[8]=j[10]=w-1;
    f[11]=j[7]=j[9]=h-1;

    return (b);
}

/************************************************************************/
/* Functions to implement ToggleSelect pseudokind			*/
/************************************************************************/

__far void ToggleGUp (struct GTRequest *req,struct GTControl *gtc,
		 struct IntuiMessage *msg)
{
    gtc->Attribute=gtc->Gadget->Flags & GFLG_SELECTED ? 1 : 0;
}

__far void ToggleSetAttrs (struct GTRequest *req,struct GTControl *gtc,
		      struct TagItem *ti)
{
    ULONG onoff;

    onoff=GetTagData(GTCT_TOGGLED,0xffffffff,ti);
    if (onoff!=0xffffffff) {
	ULONG isonoff;

	onoff = onoff ? 1 : 0;

	isonoff=gtc->Gadget->Flags & GFLG_SELECTED ? 1 : 0;
	if (onoff!=isonoff) {
	    gtc->Gadget->Flags^=GFLG_SELECTED;
	    RefreshGList(gtc->Gadget,req->Window,0,1);
	}
    }
    GT_SetGadgetAttrsA(gtc->Gadget,req->Window,0,ti);
}

__far struct Gadget *CreateToggleSelectKind(struct GTPKind *kclass,struct Gadget *gad,
				  struct GTControl *gtc,struct GTRequest *req,
				  struct VisualInfo *vinfo)
{
    ULONG onoff;

    gtc->NewGadget->ng_VisualInfo=vinfo;
    gad=CreateGadgetA(BUTTON_KIND,gad,gtc->NewGadget,gtc->GadgetTags);
    if (gad) {
	gad->Activation|=GACT_TOGGLESELECT;
	if (!(gtc->GUpUpdateControl)) gtc->GUpUpdateControl=ToggleGUp;
	gtc->SetAttrs=ToggleSetAttrs;
    }

    onoff=GetTagData(GTCT_TOGGLED,0xffffffff,gtc->GadgetTags);
    if (onoff!=0xffffffff && onoff!=0) SetControlAttrs(req,gtc,GTCT_TOGGLED,onoff,TAG_DONE);
    return gad;
}

/***************************************************************************/
/*		       These are for ImageButton PKind			   */
/***************************************************************************/

__far void ImageButtonSetAttrs (struct GTRequest *req,struct GTControl *gtc,
		      struct TagItem *ti)
{
    ULONG onoff,toggle;

    toggle=GetTagData(GTPK_Toggleselect,0,gtc->GadgetTags);
    if (toggle) {
	onoff=GetTagData(GTPK_Toggled,0xffffffff,ti);
	if (onoff!=0xffffffff) {
	    ULONG isonoff;

	    onoff = onoff ? 1 : 0;

	    isonoff=gtc->Gadget->Flags & GFLG_SELECTED ? 1 : 0;
	    if (onoff!=isonoff) {
		gtc->Gadget->Flags^=GFLG_SELECTED;
		RefreshGList(gtc->Gadget,req->Window,0,1);
	    }
	}
    }
}

__far struct Gadget *CreateImageButtonKind(struct GTPKind *kclass, struct Gadget *gad,
				    struct GTControl *gtc, struct GTRequest *req,
				    struct VisualInfo *vinfo)
{
    struct Gadget *g;
    struct Image *i,*s;
    ULONG toggled,toggle;

    i=GetTagData(GTPK_Image,0,gtc->GadgetTags);
    s=GetTagData(GTPK_SelectedImage,0,gtc->GadgetTags);
    toggle=GetTagData(GTPK_Toggleselect,0,gtc->GadgetTags);
    toggled=GetTagData(GTPK_Toggled,0,gtc->GadgetTags);

    if (g=AllocRemember(&req->GTKey,sizeof(*g),MEMF_PUBLIC | MEMF_CLEAR)) {
	gad->NextGadget=g;

	g->LeftEdge=gtc->NewGadget->ng_LeftEdge;
	g->TopEdge=gtc->NewGadget->ng_TopEdge;
	g->Width=gtc->NewGadget->ng_Width;
	g->Height=gtc->NewGadget->ng_Height;

	g->Flags= s ? GFLG_GADGIMAGE | GFLG_GADGHIMAGE :
	    GFLG_GADGIMAGE | GFLG_GADGHCOMP;
	g->Activation = toggle ? GACT_RELVERIFY | GACT_TOGGLESELECT :
	    GACT_RELVERIFY;
	g->GadgetType=BOOLGADGET;
	g->GadgetRender=i;
	g->SelectRender=s;

	g->GadgetID=gtc->NewGadget->ng_GadgetID;
	g->UserData=gtc->NewGadget->ng_UserData;

	if (toggle && toggled) g->Flags |= GFLG_SELECTED;

	if (!(gtc->GUpUpdateControl) && toggle)
	    gtc->GUpUpdateControl=ToggleGUp;

	gtc->SetAttrs=ImageButtonSetAttrs;
	gtc->Gadget=g;
    }
    return g;
}



struct GTPKind GlobalPKindClassList[]={
    { "ToggleSelect",CreateToggleSelectKind,0 },
    { "ImageButton",CreateImageButtonKind, 0 },
    { 0, 0, 0 }
};

/***********************************************************/
/*  These Keep GTControl->Attribute current on Gadgetup    */
/*  or Gadget Down.  Called by DispatchDefSetControlAttr.  */
/*  Can be overriden in the GTControl structure.	   */
/***********************************************************/

__far void CheckBoxGUp(struct GTRequest *req,struct GTControl *gtc,
		 struct IntuiMessage *msg)
{
    gtc->Attribute=gtc->Gadget->Flags & GFLG_SELECTED;
}

__far void MXGDown (struct GTRequest *req,struct GTControl *gtc,
		 struct IntuiMessage *msg)
{
    gtc->Attribute=msg->Code;
}

__far void CycleGUp(struct GTRequest *req,struct GTControl *gtc,
		 struct IntuiMessage *msg)
{
    gtc->Attribute=msg->Code;
}

__far void SliderGUp(struct GTRequest *req,struct GTControl *gtc,
		 struct IntuiMessage *msg)
{
    gtc->Attribute=msg->Code;
}

__far void ScrollerGUp(struct GTRequest *req,struct GTControl *gtc,
		 struct IntuiMessage *msg)
{
    gtc->Attribute=msg->Code;
}

__far void ListViewGUp(struct GTRequest *req,struct GTControl *gtc,
		 struct IntuiMessage *msg)
{
    gtc->Attribute=msg->Code;
}

struct DefControlAttrUpdater {
    ULONG Kind;
    void (*GadgetUp) (struct GTRequest *,struct GTControl *,
			struct IntuiMessage *);
    void (*GadgetDown) (struct GTRequest *,struct GTControl *,
			struct IntuiMessage *);
};

struct DefControlAttrUpdater DefControlAttrUpdaters[] = {
    { CHECKBOX_KIND,	   CheckBoxGUp,  0 },
    { MX_KIND,		   0,		 MXGDown },
    { CYCLE_KIND,	   CycleGUp,	 0 },
    { SLIDER_KIND,	   SliderGUp,	 0 },
    { SCROLLER_KIND,	   ScrollerGUp,  0 },
    { LISTVIEW_KIND,	   ListViewGUp,  0 },
    { 0,		   0,		 0 }
};

__far void DispatchDefSetControlAttr(struct GTRequest *req,struct GTControl *gtc,
				struct IntuiMessage *msg)
{
    USHORT i;

    for (i=0;DefControlAttrUpdaters[i].Kind;++i) {
	if (gtc->Kind==DefControlAttrUpdaters[i].Kind) {
	    if (msg->Class == IDCMP_GADGETUP &&
		DefControlAttrUpdaters[i].GadgetUp)
		    (*(DefControlAttrUpdaters[i].GadgetUp)) (req,gtc,msg);
	    else if (DefControlAttrUpdaters[i].GadgetDown)
		    (*(DefControlAttrUpdaters[i].GadgetDown)) (req,gtc,msg);
	    break;
	}
    }
}

/***********************************************************/

__far struct GTControl *FindGadgetControl(struct GTControl *gtc,struct Gadget *g)
{
    while (gtc && gtc->Gadget!=g) gtc=gtc->Next;
    return gtc;
}

/***********************************************************/
/*  Message Classes for Global Class List.  Determine if a */
/*  message is of a particular type, and if it affects	   */
/*  given control (note that some messages will "affect"   */
/*  all controls (MOUSEBUTTONS, DISKINSERTED, etc.)        */
/*  If that control has a message handler the given	   */
/*  message it will hear about them.			   */
/***********************************************************/

__far BOOL IsGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class==IDCMP_GADGETUP) {
	if (gtc) {
	    struct GTControl *cgtc;

	    cgtc=FindGadgetControl(req->Controls,msg->IAddress);
	    if (cgtc==gtc) return 1;
	} else return 1;
    }
    return 0;
}

__far BOOL IsGadgetDown(struct GTRequest *req,struct IntuiMessage *msg,
		struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_GADGETDOWN) {
	if (gtc) {
	    struct GTControl *cgtc;

	    cgtc=FindGadgetControl(req->Controls,msg->IAddress);
	    if (cgtc==gtc) return 1;
	} else return 1;
    }
    return 0;
}

__far BOOL IsStringDSelected(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (IsGadgetDown(req,req->LastGadgetEvent,gtc,mh)) {
	struct Gadget *g;
	g=req->LastGadgetEvent->IAddress;
	if ((g->GadgetType & GTYP_GTYPEMASK)==GTYP_STRGADGET) return 1;
    }

    return 0;
}

__far void SetStringControl (struct GTRequest *req,struct GTControl *gtc,UBYTE *string);

__far BOOL LimitStringContents(struct GTRequest *req,struct IntuiMessage *msg,
			    struct GTControl *gtc,struct MessageHandler *mh)
{
    ULONG retval=0;

    if (gtc && IsStringDSelected(req,msg,gtc,mh)) {
	UBYTE *s,*nogood,*x;
	struct StringInfo *buf;
	buf=(struct StringInfo *)gtc->Gadget->SpecialInfo;
	if (buf) {
	    x=buf->Buffer;
	    if (gtc->ControlTags) nogood=(UBYTE *)GetTagData(GTCT_STRING_INVALIDCHARS,0,gtc->ControlTags);
	    if (nogood) {
		s=AllocVec(strlen(x)+1,MEMF_PUBLIC);
		strcpy(s,x);
		if (strelim(s,nogood,0)) { SetStringControl(req,gtc,s); retval=1; }
		FreeVec(s);
	    }
	}
    }
    return retval;
}


__far void SetIntControl (struct GTRequest *req,struct GTControl *gtc,LONG number);

__far BOOL VerifyIntLimits(struct GTRequest *req,struct IntuiMessage *msg,
			struct GTControl *gtc,struct MessageHandler *mh)
{
    ULONG retval=0;
    if (gtc && IsStringDSelected(req,msg,gtc,mh)) {
	LONG min,max,x;
	UBYTE *s;
	struct StringInfo *sinfo;

	sinfo=(struct StringInfo *)gtc->Gadget->SpecialInfo;
	if (sinfo) {
	    x=atol(sinfo->Buffer);
	    if (gtc->ControlTags) {
		min=GetTagData(GTCT_INT_MIN,0x3f47d8a3,gtc->ControlTags);
		max=GetTagData(GTCT_INT_MAX,0x3f47d8a3,gtc->ControlTags);
		if (min!=0x3f47d8a3 && x<min) { SetIntControl(req,gtc,min); retval=1; }
		else if (max!=0x3f47d8a3 && x>max) { SetIntControl(req,gtc,max); retval=1; }
	    }
	}
    }
    return retval;
}

__far BOOL EndFillGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		 struct GTControl *gtc,struct MessageHandler *mh)
{
    if (IsGadgetUp(req,msg,gtc,mh)) {
	EndGTRequest(req,1,mh,gtc);
	return 1;
    }
    return 0;

}

__far BOOL EndGadgetUp(struct GTRequest *req,struct IntuiMessage *msg,
		 struct GTControl *gtc,struct MessageHandler *mh)
{
    if (IsGadgetUp(req,msg,gtc,mh)) {
	EndGTRequest(req,-1,mh,gtc);
	return 1;
    }
    return 0;
}

__far BOOL IsMouseButtons(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (!gtc || gtc==req->ActiveControl)
	if (msg->Class & IDCMP_MOUSEBUTTONS) return 1;
    return 0;
}

__far BOOL IsMouseMove(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (!gtc || gtc==req->ActiveControl)
	if (msg->Class & IDCMP_MOUSEMOVE) return 1;
    return 0;
}

__far BOOL IsDeltaMove(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (!gtc || gtc==req->ActiveControl)
	if (msg->Class & IDCMP_DELTAMOVE) return 1;
    return 0;
}

__far BOOL IsRawKey(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (!gtc || gtc==req->ActiveControl)
	if (msg->Class & IDCMP_RAWKEY) return 1;
    return 0;
}

__far BOOL IsIntuiTicks(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (!gtc || gtc==req->ActiveControl)
	if (msg->Class & IDCMP_INTUITICKS) return 1;
    return 0;
}

__far BOOL IsDiskInserted(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_DISKINSERTED) return 1;
    return 0;
}

__far BOOL IsDiskRemoved(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_DISKREMOVED) return 1;
    return 0;
}

__far BOOL IsMenuVerify(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_MENUVERIFY) return 1;
    return 0;
}

__far BOOL IsMenuPick(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_MENUPICK) return 1;
    return 0;
}

__far BOOL IsSizeVerify(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_SIZEVERIFY) return 1;
    return 0;
}

__far BOOL IsNewSize(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_NEWSIZE) return 1;
    return 0;
}

__far BOOL IsReqVerify(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_REQVERIFY) return 1;
    return 0;
}

__far BOOL IsReqSet(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_REQSET) return 1;
    return 0;
}

__far BOOL IsReqClear(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_REQCLEAR) return 1;
    return 0;
}

__far BOOL IsActiveWindow(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_ACTIVEWINDOW) return 1;
    return 0;
}

__far BOOL IsInactiveWindow(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_INACTIVEWINDOW) return 1;
    return 0;
}

__far BOOL IsRefreshWindow(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_REFRESHWINDOW) return 1;
    return 0;
}

__far BOOL IsNewPrefs(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_NEWPREFS) return 1;
    return 0;
}

__far BOOL IsCloseWindow(struct GTRequest *req,struct IntuiMessage *msg,
		    struct GTControl *gtc,struct MessageHandler *mh)
{
    if (msg->Class & IDCMP_CLOSEWINDOW) return 1;
    return 0;
}


struct MessageClass GlobalMsgClassList[]={
    { "GadgetUp",IsGadgetUp },
    { "GadgetDown",IsGadgetDown },
    { "MouseButtons",IsMouseButtons },
    { "MouseMove",IsMouseMove },
    { "DeltaMove",IsDeltaMove },
    { "RawKey",IsRawKey },
    { "IntuiTicks",IsIntuiTicks },
    { "DiskInserted",IsDiskInserted },
    { "DiskRemoved",IsDiskRemoved },
    { "MenuVerify",IsMenuVerify },
    { "MenuPick",IsMenuPick },
    { "SizeVerify",IsSizeVerify },
    { "NewSize",IsNewSize },
    { "ReqVerify",IsReqVerify },
    { "ReqSet",IsReqSet },
    { "ReqClear",IsReqClear },
    { "ActiveWindow",IsActiveWindow },
    { "InactiveWindow",IsInactiveWindow },
    { "RefreshWindow",IsRefreshWindow },
    { "NewPrefs",IsNewPrefs },
    { "CloseWindow",IsCloseWindow },
    { "EndGadgetUp",EndGadgetUp },
    { "EndFillGadgetUp",EndFillGadgetUp },
    { "LimitStringContents",LimitStringContents },
    { "VerifyIntLimits",VerifyIntLimits },
    { "StringDSelected",IsStringDSelected },
    {  0, 0 }
};

/***********************************************************/
/* The following routines handle conversion between RAWKEY */
/* and ASCII based on the current Keymap.		   */
/***********************************************************/

__far UBYTE InterpretDKey(UBYTE *start,UBYTE *descrip)
{
    if (*descrip & DPF_DEAD) return(0);
    if (*descrip==0) { ++descrip; return(*descrip); }
    if (*descrip & DPF_MOD) {
	++descrip;
	descrip=start + *descrip;
	return (*descrip);
    }
    return (0);
}



/* Takes RAWKEY code and qualifier (from an IntuiMessage) and returns
   ASCII equivalent
*/

__far UBYTE RawKeyToAscii (USHORT code,USHORT qual)
{
    UBYTE key=0;
    USHORT r;
    struct MsgPort *port=0;
    struct IOStdReq *req=0;
    struct KeyMap *km=0;
    ULONG *kmentry;
    UBYTE *kmflags;
    UBYTE *kmdkey,*kmdstart;
    UBYTE *kmcaps;

    if (code>0x67) return (0);

    port=CreatePort(0,0);
    if (!port) goto error;
    req=CreateStdIO(port);
    if (!req) goto error;

    km=AllocMem(sizeof(struct KeyMap),MEMF_PUBLIC | MEMF_CLEAR);
    if (!km) goto error;

    if (OpenDevice("console.device",-1,req,0)) goto error;
    req->io_Command=CD_ASKDEFAULTKEYMAP;
    req->io_Length=sizeof(struct KeyMap);
    req->io_Data=km;
    DoIO(req);
    if (req->io_Error) { CloseDevice(req); goto error; }

    if (code>0x3f) {
	kmflags=km->km_HiKeyMapTypes;
	kmentry=km->km_HiKeyMap;
	kmcaps=km->km_HiCapsable;
    } else {
	kmflags=km->km_LoKeyMapTypes;
	kmentry=km->km_LoKeyMap;
	kmcaps=km->km_LoCapsable;
    }

    if (code>0x3f) code-=0x40;

    if (qual & IEQUALIFIER_CAPSLOCK) {
	UBYTE byt,bit;
	byt=code/8;
	bit=code%8;
	if (kmcaps[byt] & bit) qual|=IEQUALIFIER_LSHIFT;
    }

    if (kmflags[code] & KCF_STRING) { CloseDevice(req); goto error; }
    if (kmflags[code] & KCF_DEAD) {

	kmdkey=kmdstart=(UBYTE *)kmentry[code];

	if ( ( qual & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT) ) && (kmflags[code] & KCF_SHIFT) ) {
	    kmdkey+=2;
	    if ( ( qual & (IEQUALIFIER_LALT | IEQUALIFIER_RALT) ) && (kmflags[code] & KCF_ALT) ) {
		kmdkey+=4;
		key=InterpretDKey(kmdstart,kmdkey);
	    } else key=InterpretDKey(kmdstart,kmdkey);
	} else if ( ( qual & (IEQUALIFIER_LALT | IEQUALIFIER_RALT) ) && (kmflags[code] & KCF_ALT) ) {
		kmdkey+=4;
		key=InterpretDKey(kmdstart,kmdkey);
	} else { key=InterpretDKey(kmdstart,kmdkey); }

    } else {
	if (qual & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT)) {
	    if (qual & (IEQUALIFIER_LALT | IEQUALIFIER_RALT)) {
		key=(kmentry[code] & 0xff000000) >> 24;
	    } else key=(kmentry[code] & 0xff00) >> 8;
	} else if (qual & (IEQUALIFIER_LALT | IEQUALIFIER_RALT))
		key=(kmentry[code] & 0xff0000) >> 16;
	else { key=kmentry[code] & 0xff; }
    }

    if (qual & IEQUALIFIER_CONTROL) key&=159;

    CloseDevice(req);
error: if (req) DeleteStdIO (req);
       if (port) DeletePort (port);
       if (km) FreeMem(km,sizeof (struct KeyMap));
       return (key);
}


/* Takes ASCII char and returns Rawkey code.  ASCII code must correspond to
   letter painted on keyboard keycap (the unqualified value).  Qualifier
   must be determined as follows (Under IGRequest which does not
   differentiate between right and left):

	SHIFT =  1
	ALT   = 16
	CTRL  =  8
	AMIGA = 64

   Returns -1 error.
*/

__far SHORT ASCIIToRawKey (char c)
{
    UBYTE b;
    SHORT r=-1;
    struct MsgPort *port=0;
    struct IOStdReq *req=0;
    struct KeyMap *km=0;
    ULONG *kmentry;
    UBYTE *kmflags,*kmdkey;

    if (c>='A' && c<='Z') c+='a'-'A';

    port=CreatePort(0,0);
    if (!port) goto error;
    req=CreateStdIO(port);
    if (!req) goto error;
    km=AllocMem (sizeof(struct KeyMap),MEMF_PUBLIC | MEMF_CLEAR);
    if (!km) goto error;

    if (OpenDevice("console.device",-1,req,0)) goto error;
    req->io_Command=CD_ASKDEFAULTKEYMAP;
    req->io_Length=sizeof(struct KeyMap);
    req->io_Data=km;
    DoIO(req);
    if (req->io_Error) { CloseDevice (req); goto error; }

    kmentry = km->km_LoKeyMap;
    kmflags = km->km_LoKeyMapTypes;

    for (r=0;r<0x40;++r,++kmentry,++kmflags) {
	if (*kmflags & KCF_STRING) continue;
	if (*kmflags & KCF_DEAD) {
	    kmdkey=(UBYTE *)(kmentry[0]);
	    b=InterpretDKey(kmdkey,kmdkey);
	    if (b==c) break;
	} else if ((kmentry[0] & 0xff) == c) break;
    }
    if (r==0x40) {
	kmentry = km->km_HiKeyMap;
	kmflags = km->km_HiKeyMapTypes;
	for (;r<0x68;++r,++kmentry,++kmflags) {
	    if (*kmflags & KCF_STRING) continue;
	    if (*kmflags & KCF_DEAD) {
		kmdkey=(UBYTE *)(kmentry[0]);
		b=InterpretDKey(kmdkey,kmdkey);
		if (b==c) break;
	    } else if ((kmentry[0] & 0xff) == c) break;
	}
    }
    if (r>0x67) r=-1;

    CloseDevice(req);
error: if (req) DeleteStdIO (req);
       if (port) DeletePort (port);
       if (km) FreeMem (km,sizeof(struct KeyMap));
       return (r);
}

/***********************************************************/
/* These are the routines that the user will call to	   */
/* GTRequest behavior as it is running. 		   */
/***********************************************************/

__far BYTE GTAllocCLBit (struct GTRequest *req)
{
    BYTE toreturn;
    for (toreturn=0;toreturn<32;++toreturn)
	if (!(req->LoopBitsUsed & (1<<toreturn))) break;
    if (toreturn==32) return (-1);
    req->LoopBitsUsed|=(1<<toreturn);
    return (toreturn);
}


__far void GTFreeCLBit (struct GTRequest *req,UBYTE bit)
{
    FLAGOFF(req->LoopBitsUsed,(1<<bit));
}

#define FreeIntuiMsg(x) FreeMem(x,sizeof(struct IntuiMessage))

__far BOOL GTSendIntuiMsg (struct GTRequest *req,ULONG Class,ULONG Code,
		    USHORT Qualifier,APTR IAddress)
{
    struct IntuiMessage *msg;
    ULONG secs,mics;

    if (!(Class & req->Window->IDCMPFlags)) return (0);

    msg=AllocMem (sizeof(struct IntuiMessage),MEMF_PUBLIC | MEMF_CLEAR);
    if (!msg) return (2);

    CurrentTime(&secs,&mics);

    msg->Class=Class;
    msg->Code=Code;
    msg->Qualifier=Qualifier;
    msg->IAddress=IAddress;
    msg->Seconds=secs;
    msg->Micros=mics;
    msg->MouseX=req->Window->MouseX;
    msg->MouseY=req->Window->MouseY;
    msg->IDCMPWindow=req->Window;

    PutMsg (req->IComPort,msg);
    return (0);
}




__far void StimulateControl (struct GTRequest *req,struct GTControl *gtc)
{
    if (!(gtc->Gadget->Flags & GFLG_DISABLED)) {
	switch(gtc->Kind) {
	    case STRING_KIND:
	    case INTEGER_KIND:
		ActivateGadget (gtc->Gadget,req->Window,0);
		break;
	    case CHECKBOX_KIND:
		SetControlAttrs(req,gtc,GTCB_Checked,
		    !(gtc->Gadget->Flags & GFLG_SELECTED),TAG_DONE);
		break;
	    case CYCLE_KIND:
		SetControlAttrs(req,gtc,GTCY_Active,
		    gtc->Attribute+1,TAG_DONE);
		break;
	    case MX_KIND:
		SetControlAttrs(req,gtc,GTMX_Active,
		    gtc->Attribute+1,TAG_DONE);
		break;
	}
    }
}




__far void GTStimulateGadget(struct GTRequest *req,struct Gadget *g)
{
    struct GTControl *gtc;
    gtc=FindGadgetControl (req->Controls,g);
    if (gtc) StimulateControl(req,gtc);
}

#define GTControlClick(r,g) GTGadgetClick(r,(g)->Gadget)

__far BOOL GTGadgetClick(struct GTRequest *req,struct Gadget *gadg)
{
    BOOL x=0;

    if (!(gadg->Flags & GFLG_DISABLED)) {
	if (gadg->Activation & GACT_IMMEDIATE)
	    x|=GTSendIntuiMsg(req,IDCMP_GADGETDOWN,0,0,(APTR)gadg);
	if (!((gadg->GadgetType & GTYP_GTYPEMASK)==GTYP_STRGADGET)) {
	    if (gadg->Activation & GACT_RELVERIFY)
		x|=GTSendIntuiMsg(req,IDCMP_GADGETUP,0,0,(APTR)gadg);
	}
	if (x) return (x);
	GTStimulateGadget (req,gadg);
    }
    return (0);
}




__far BOOL GTKeyClick (struct GTRequest *req,UBYTE *keyinfo,UBYTE key)
{
    USHORT qual=0,rk;
    if (cismember('a',keyinfo)) qual|=0x10;
    if (cismember('A',keyinfo)) qual|=0x40;
    if (cismember('s',keyinfo)) qual|=0x01;
    if (cismember('c',keyinfo)) qual|=0x08;

    rk=ASCIIToRawKey(key);
    if (rk==-1) return (3);
    return (GTSendIntuiMsg(req,IDCMP_RAWKEY,rk,qual,0));
}


/*

__far BOOL MenuPick (struct IGRequest *req,struct IGMenu *igm)
{
    BOOL result;
    result=GTSendIntuiMsg (req,IDCMP_MENUPICK,igm->Code,0,0);
    return result;
}

*/





__far void SetStringControl (struct GTRequest *req,struct GTControl *gtc,UBYTE *string)
{
    if (!((gtc->Gadget->GadgetType & GTYP_GTYPEMASK)==GTYP_STRGADGET)) return;

    SetControlAttrs(req,gtc,GTST_String,string,TAG_DONE);
    if (gtc->Gadget->Activation & GACT_IMMEDIATE) GTSendIntuiMsg (req,IDCMP_GADGETDOWN,0,0,gtc->Gadget);
    if (gtc->Gadget->Activation & GACT_RELVERIFY) GTSendIntuiMsg (req,IDCMP_GADGETUP,0,0,gtc->Gadget);
}

__far void GTSetStringGad (struct GTRequest *req,struct Gadget *gadg,UBYTE *string)
{
    struct GTControl *gtc;
    gtc=FindGadgetControl(req->Controls,gadg);
    if (gtc) SetStringControl(req,gtc,string);
}

__far void SetIntControl (struct GTRequest *req,struct GTControl *gtc,LONG number)
{
    if (!((gtc->Gadget->GadgetType & GTYP_GTYPEMASK)==GTYP_STRGADGET)) return;

    SetControlAttrs(req,gtc,GTIN_Number,number,TAG_DONE);
    if (gtc->Gadget->Activation & GACT_IMMEDIATE) GTSendIntuiMsg (req,IDCMP_GADGETDOWN,0,0,gtc->Gadget);
    if (gtc->Gadget->Activation & GACT_RELVERIFY) GTSendIntuiMsg (req,IDCMP_GADGETUP,0,0,gtc->Gadget);
}

__far void GTSetIntGad (struct GTRequest *req,struct Gadget *gadg,LONG number)
{
    struct GTControl *gtc;
    gtc=FindGadgetControl(req->Controls,gadg);
    if (gtc) SetIntControl(req,gtc,number);
}


/*
    BlockIGInput Function opens an blank intuition requester on top
    of an IGRequest, thereby blocking its input
*/
__far void GTBlockInput(struct GTRequest *req)
{
    struct GTPrivate *id;
    struct Requester *areq;

    if (req && req->Window) {
	id=(struct GTPrivate *)req->InternalData;

	if (!(id->Blocked)) {
	    if (areq=AllocMem(sizeof(struct Requester),MEMF_PUBLIC | MEMF_CLEAR)) {
		Request(areq,req->Window);
		req->Flags|=GT_INPUTBLOCKED;
		id->BlockReq=areq;
		id->Blocked=1;
	    }
	} else ++id->Blocked;
    }
}





/*
    UnBlockIGInput closes blank requester opened by BlockIGInput, thereby
    permitting messages to come through again
*/
__far void GTUnBlockInput(struct GTRequest *req)
{
    struct Requester *areq;
    struct GTPrivate *id;

    if (req && (req->Flags & GT_INPUTBLOCKED)) {
	id=(struct GTPrivate *)req->InternalData;

	--id->Blocked;
	if (!(id->Blocked)) {
	    if (areq=id->BlockReq) {
		EndRequest(areq,req->Window);
		FreeMem(areq,sizeof(struct Requester));
		FLAGOFF(req->Flags,GT_INPUTBLOCKED);
		id->BlockReq=0;
	    }
	}
    }
}




#define GTREQUESTIDCMP (IDCMP_GADGETUP | IDCMP_GADGETDOWN | \
			IDCMP_INTUITICKS | IDCMP_RAWKEY | IDCMP_MOUSEBUTTONS | \
			IDCMP_MOUSEMOVE | IDCMP_REFRESHWINDOW | IDCMP_MENUPICK)

/* You must use this instead of ModifyIDCMP!! */

__far void GTReqModifyIDCMP(struct GTRequest *req,ULONG IDCMP)
{
    req->AppIDCMP=IDCMP;

    ModifyIDCMP(req->Window,IDCMP | GTREQUESTIDCMP);
}




/***********************************************************/
/*  These routines are used by GTRequest internally.
/***********************************************************/

/*
    ClearWindow Function, clears inside of window to background (0)
    Used by GTRequest on exit if it doesn't close the window.
*/
__far void ClearWindow (struct Window *w)
{
    SHORT x,y,X,Y;
    BYTE oldpen;
    if (!w) return ();
    x=w->BorderLeft+1;
    y=w->BorderTop+1;
    X=w->Width;
    Y=w->Height;
    X-=w->BorderRight+1;
    Y-=w->BorderBottom+1;
    oldpen=w->RPort->FgPen;
    SetAPen (w->RPort,0);
    RectFill (w->RPort,x,y,X,Y);
    SetAPen (w->RPort,oldpen);
}

__far void StoreGTCAttr(struct GTRequest *req,struct GTControl *gtc)
{
    UBYTE *stringbuffer=0,condition;
    ULONG t,*tp;

    if (req->Flags & STOREDATA) {
	if (gtc->Flags & STOREDATA) {
	    UBYTE *data;

	    data=req->DataStruct;
	    data+=gtc->FieldOffset;

	    if ((gtc->Gadget->GadgetType & GTYP_GTYPEMASK)==GTYP_STRGADGET) {
		struct StringInfo *si;
		si=(struct StringInfo *)gtc->Gadget->SpecialInfo;
		stringbuffer=si->Buffer;
	    }

	    if (gtc->SetDataFromGadget) (*(gtc->SetDataFromGadget)) (req,gtc,data);
	    else {
		condition=stringbuffer && ISFLAGOFF(gtc->Flags,GTC_ATTROVERRIDESSTRING);
		switch (gtc->FieldType) {
		    case FLD_SHORT: {
			SHORT *sp;
			sp=(BYTE *)data;
			*sp= condition ? atol(stringbuffer) : gtc->Attribute;
			}
			break;
		    case FLD_BYTE: {
			BYTE *bp;
			bp=(BYTE *)data;
			*bp= condition ? atol(stringbuffer) : gtc->Attribute;
			}
			break;
		    case FLD_FLOAT: {
			GTFLOAT *f;
			f=(GTFLOAT *)data;
			if (condition) {
			    *f=(GTFLOAT)StringToFloat(stringbuffer);
			    break;
			}
			}
		    case FLD_POINTER:
		    case FLD_LONG:
		    case FLD_STRINGPTR: {
			ULONG *lp;
			lp=(ULONG *)data;
			*lp= condition && gtc->FieldType==FLD_LONG ?
				atol(stringbuffer) : gtc->Attribute;
			}
			break;
		    case FLD_STRINGINSTRUCT: {
			UBYTE *s;
			s= condition ? stringbuffer : (UBYTE *)gtc->Attribute;
			strncpy(data,s,gtc->FieldSize);
			}
			break;
		    case FLD_STRINGPOINTEDTOINSTRUCT: {
			UBYTE **p,*x,*s;
			p=(UBYTE **)data;
			x=*p;
			s= condition ? stringbuffer : (UBYTE *)gtc->Attribute;
			strncpy(x,s,gtc->FieldSize);
			}
			break;
		    case FLD_BOOLBIT: {
			ULONG *lp;
			lp=(ULONG *)data;

			SETFLAG(*lp,1<<gtc->FieldBit,gtc->Attribute);
			}
			break;
		    case FLD_ATTRBIT: {
			ULONG *lp;
			lp=(ULONG *)data;
			*lp=1<<gtc->Attribute;
			}
			break;
		    case FLD_ORATTR: {
			ULONG *lp;
			lp=(ULONG *)data;
			*lp|=gtc->Attribute;
			}
			break;
		    case FLD_ORATTRBIT: {
			ULONG *lp;
			lp=(ULONG *)data;
			*lp|=1<<gtc->Attribute;
			}
			break;
		}
	    }
	}
    }
}

__far void InitGTCAttr(struct GTRequest *req,struct GTControl *gtc)
{
    BYTE f=0;


    if (!stricmp(gtc->NewGadget->ng_GadgetText,"Ind. W/H:")) f=1;
    if (req->Flags & INITFROMDATA) {
	if (gtc->Flags & INITFROMDATA) {
	    UBYTE *data;

	    data=req->DataStruct;
	    data+=gtc->FieldOffset;

	    if (gtc->SetGadgetFromData) (*(gtc->SetGadgetFromData)) (req,gtc,data);
	    else {
		switch (gtc->FieldType) {
		    case FLD_SHORT: {
			SHORT *sp;
			sp=(BYTE *)data;
			SetControlAttrs(req,gtc,gtc->AttributeTag,*sp,TAG_DONE);
			gtc->Attribute=*sp;
			}
			break;
		    case FLD_BYTE: {
			BYTE *bp;
			bp=(BYTE *)data;
			SetControlAttrs(req,gtc,gtc->AttributeTag,*bp,TAG_DONE);
			gtc->Attribute=*bp;
			}
			break;
		    case FLD_FLOAT: {
			UBYTE buf[30];
			GTFLOAT *fp;
			fp=(GTFLOAT *)data;
			FloatToString(*fp,buf);
			SetControlAttrs(req,gtc,gtc->AttributeTag,buf,TAG_DONE);
			gtc->Attribute=(ULONG)*fp;
			}
			break;
		    case FLD_POINTER:
		    case FLD_LONG:
		    case FLD_STRINGPOINTEDTOINSTRUCT:
		    case FLD_STRINGPTR: {
			ULONG *lp;
			lp=(ULONG *)data;
			SetControlAttrs(req,gtc,gtc->AttributeTag,*lp,TAG_DONE);
			gtc->Attribute=*lp;
			}
			break;
		    case FLD_STRINGINSTRUCT:
			SetControlAttrs(req,gtc,gtc->AttributeTag,data,TAG_DONE);
			break;
		    case FLD_BOOLBIT: {
			ULONG *lp,x;
			lp=(ULONG *)data;
			x=ISFLAGON(*lp,1<<gtc->FieldBit) ? 1 : 0;
			SetControlAttrs(req,gtc,gtc->AttributeTag,x,TAG_DONE);
			gtc->Attribute=x;
			}
			break;
		    case FLD_ATTRBIT: {
			ULONG *lp,n,c;
			lp=(ULONG *)data;
			c=*lp;
			if (c) for (n=1;n<32 && c!=1;++n,c>>=1);
			else n=0;
			if (n!=32) {
			    SetControlAttrs(req,gtc,gtc->AttributeTag,n,TAG_DONE);
			    gtc->Attribute=n;
			}
			}
			break;
			/* If more than one bit is set, nothing happens!! */

			/* break; */
			/* Not necessary for last case */
		}
	    }
	}
    }
}

__far struct GTPKind *FindGTPKClassInList(UBYTE *Name,struct GTPKind *list)
{
    for (;list && list->Name;list++)
	if (!strcmp(list->Name,Name)) return list;
    return 0;
}

__far struct GTPKind *FindGTPKClass(struct GTRequest *req,UBYTE *Name)
{
    struct GTPKind *gc;
    if (gc=FindGTPKClassInList(Name,req->LocalPKindClassList)) return gc;
    return FindGTPKClassInList(Name,GlobalPKindClassList);
}

__far struct MessageClass *FindMsgClassInList (UBYTE *Name,struct MessageClass *list)
{
    for (;list && list->Name;list++)
	if (!strcmp(list->Name,Name)) return list;
    return 0;
}

__far struct MessageClass *FindMsgClass(struct GTRequest *req,UBYTE *Name)
{
    struct MessageClass *mc;

    if (mc=FindMsgClassInList(Name,req->LocalMsgClassList)) return mc;
    return FindMsgClassInList(Name,GlobalMsgClassList);
}

__far void BindClassToMsgHandler(struct GTRequest *req,struct MessageHandler *mh)
{
    if (!(mh->IsType) && mh->Name) {
	struct MessageClass *mc;

	mc=FindMsgClass(req,mh->Name);
	if (mc) {
	    mh->IsType=mc->IsType;
	}
    }
}

__far void ProcessMsgHandler (struct GTRequest *req,struct MessageHandler *mh,
			struct IntuiMessage *msg,struct GTControl *gtc)
{

    if (mh->IsType) {
	if ((*(mh->IsType)) (req,msg,gtc,mh)) {
	    if (mh->HandlerFunction) {
		(*(mh->HandlerFunction)) (req,msg,gtc,mh);
	    }
	}
    }
}

extern struct Library *GadToolsBase;

struct Gadget *ControlToGadget(struct GTRequest *req,struct Gadget *gad,
			       struct GTControl *gtc,struct VisualInfo *vinfo)
{
   if (!(gtc->Flags & GTC_INTERNALCONTROLIGNORE)) {
	if (gtc->Flags & GTC_PSEUDOKIND) {
	    struct GTPKind *gc;
	    if (gc=FindGTPKClass(req,(UBYTE *)gtc->Kind)) {
		if (gc->Create)
		    gtc->Gadget=gad=(*(gc->Create)) (gc,gad,gtc,req,vinfo);
	    }
	} else {
	    gtc->NewGadget->ng_VisualInfo=vinfo;
	    gtc->Gadget=gad=CreateGadgetA(gtc->Kind,gad,gtc->NewGadget,gtc->GadgetTags);
	    if(gad && (gtc->Kind==STRING_KIND || gtc->Kind==INTEGER_KIND)) {
		if (GadToolsBase->lib_Version==37)
		    gad->Activation|=GACT_IMMEDIATE;
	    }
	    /* ALL string and integer gadgets
		should have GACT_IMMEDIATE set
		if you want the verify functions
		or DSelect functions to work.
		This flag is only directly set
		under v37 to conform to RKM.
		Applications should set it
		in their taglists!
	    */
	}
    }
    return gad;
}

struct Menu *GTInitMenus(struct GTRequest *req,struct VisualInfo *vinfo)
{
    struct Menu *MenuStrip;

    if (MenuStrip=CreateMenus(req->Menus,TAG_DONE)) {
	if (LayoutMenus(MenuStrip,vinfo,TAG_DONE)) {
	    if (SetMenuStrip(req->Window,MenuStrip)) {
		return MenuStrip;
	    }
	}
	FreeMenus(MenuStrip);
    }
    return 0;
}

void InitReqSet(struct GTReqSet *rs)
{
    rs->MsgPort=0;
    NewList(&rs->List);
}

void EndAllRequests(struct GTReqSet *rs,LONG terminate,struct MessageHandler *mh,
		       struct GTControl *gtc)
{
    struct ReqNode *rn;

    for (rn=FirstItem(&rs->List);rn;rn=NextItem(rn)) {
	EndGTRequest(rn->req,terminate,mh,gtc);
    }
}

void StripIntuiMessages(struct MsgPort *mp,struct Window *win)
{
    struct IntuiMessage *msg;
    struct Node *succ;

    msg=(struct IntuiMessage *)mp->mp_MsgList.lh_Head;

    while (succ = msg->ExecMessage.mn_Node.ln_Succ)
    {
	if (msg->IDCMPWindow == win) {
	    Remove(msg);
	    if (msg->ExecMessage.mn_ReplyPort)
		ReplyMsg(msg);
	    else FreeIntuiMsg(msg);
	}
	msg=(struct IntuiMessage *)succ;
    }
}

void DetachUserPort(struct Window *win)
{
    Forbid();

    StripIntuiMessages(win->UserPort,win);
    win->UserPort=0;
    ModifyIDCMP(win,0);

    Permit();
}

/* req Must be part of a set when this is called. */
__far void FreeRequest(struct GTReqSet *rs, struct GTRequest *req)
{
    struct GTPrivate *priv;
    struct GTControl *prev=0,*gtc;
    UBYTE flag=1;

    priv=(struct GTPrivate *)req->InternalData;

    if (!priv) return;

    if (priv->MenuStrip) {
	ClearMenuStrip(req->Window);
	FreeMenus(priv->MenuStrip);
    }

    if (req->Flags & GT_GADGETSADDED)
	RemoveGList(req->Window,priv->Context,-1);

    if (priv->Context) {
	for (gtc=req->Controls;gtc;gtc=gtc->Next) {
	    if (flag) {
		if (!(gtc->Flags & GTC_INTERNALCONTROLIGNORE)) {
		    if (gtc->Gadget) {
			if (gtc->Flags & GTC_PSEUDOKIND) {
			    struct GTPKind *gc;
			    if(gc=FindGTPKClass(req,(UBYTE *)gtc->Kind)) {
				if (gc->Destroy)
				    (*(gc->Destroy)) (gc,gtc,req);
			    }
			}
		    } else flag=0;
		}
	    }
	    if (gtc->Flags & (GTC_INTERNALCONTROL | GTC_INTERNALCONTROLIGNORE)) {
		if (prev) prev->Next=gtc->Next;
	    } else prev=gtc;
	}
	if (!prev) req->Controls=0;

	FreeGadgets(priv->Context);
    }

    if (priv->vinfo) FreeVisualInfo(priv->vinfo);

    {
	USHORT i;
	struct ReqNode *rn;

	for (rn=FirstItem(&rs->List),i=0;rn;rn=NextItem(rn),++i);

	if (priv->OpenedWindow) {
	    if (i!=1) DetachUserPort(req->Window);
	    else rs->MsgPort=0;
	    req->Window=0;
	    CloseWindow(priv->OpenedWindow);
	} else {
	    ClearWindow(req->Window);
	    if (i==1) rs->MsgPort=0;
	    else {
		DetachUserPort(req->Window);
		ModifyIDCMP(req->Window,req->AppIDCMP);
	    }
	}
    }

    {
	struct IntuiText *t;
	struct Border *b;
	struct Image *i;

	for (t=req->ITexts;t;t=t->NextText)
	    t->TopEdge-=priv->YOffSet;
	for (b=req->Borders;b;b=b->NextBorder)
	    b->TopEdge-=priv->YOffSet;
	for (i=req->Images;i;i=i->NextImage)
	    i->TopEdge-=priv->YOffSet;

	for (gtc=req->Controls;gtc;gtc=gtc->Next)
	    if (gtc->NewGadget) gtc->NewGadget->ng_TopEdge-=priv->YOffSet;
    }


    FreeRemember(&req->GTKey,1);
    req->InternalData=0;
}

/* req must be part of rs before initialized */
__far LONG InitShowRequest(struct GTReqSet *rs,struct GTRequest *req)
{
    struct Gadget *gad;
    struct GTControl *gtc;
    struct GTPrivate *priv;

    req->GTKey=0;

    if (priv=AllocRemember(&req->GTKey,sizeof(*priv),MEMF_PUBLIC | MEMF_CLEAR)) {

	req->InternalData=(APTR)priv;

	/* Note that "binding" classes to handlers only happens when GTRequest
	    is first called.  This means that you can't add unbound message
	    handler structures (with IsType==0) while GTRequest is running.
	    You can however bind an unbound message handler structure using
	    BindClassToMsgHandler as per below and then add that bound MsgHandler.
	*/

	priv->Context=0;
	priv->OpenedWindow=0;
	priv->YOffSet=0;

	FLAGOFF(req->Flags,GT_GADGETSADDED);

	{
	    struct MessageHandler *mh;

	    for (gtc=req->Controls;gtc;gtc=gtc->Next) {
		for (mh=gtc->MsgHandlerList;mh;mh=mh->Next)
		    BindClassToMsgHandler(req,mh);
	    }

	    for (mh=req->MsgHandlerList;mh;mh=mh->Next)
		BindClassToMsgHandler(req,mh);
	}

	req->Terminate=0;
	req->ActiveControl=0;

	for (gtc=req->Controls;gtc;gtc=gtc->Next) {
	    if (!(gtc->Flags & GTC_GOTRAWKEY) && gtc->ASCIICommand) {
		gtc->RawKeyCommand=ASCIIToRawKey(gtc->ASCIICommand);
		gtc->Flags |= GTC_GOTRAWKEY;
	    }
	    gtc->Gadget=0;
	}

	if (req->Window ||
	  (priv->OpenedWindow=req->Window=OpenWindowTagList(NULL,req->NewWindowTags))) {

	    req->AppIDCMP=req->Window->IDCMPFlags;

	    if (rs->MsgPort) {
		ModifyIDCMP(req->Window,0);
		req->Window->UserPort=rs->MsgPort;
		ModifyIDCMP(req->Window,req->AppIDCMP | GTREQUESTIDCMP);
	    } else {
		ModifyIDCMP(req->Window,req->AppIDCMP | GTREQUESTIDCMP);
		rs->MsgPort=req->Window->UserPort;
	    }

	    {
		struct Screen *s;
		struct IntuiText *t;
		struct Border *b;
		struct Image *i;

		s=req->Window->WScreen;
		priv->YOffSet=s->WBorTop + s->Font->ta_YSize - 9;

		for (t=req->ITexts;t;t=t->NextText)
		    t->TopEdge+=priv->YOffSet;
		for (b=req->Borders;b;b=b->NextBorder)
		    b->TopEdge+=priv->YOffSet;
		for (i=req->Images;i;i=i->NextImage)
		    i->TopEdge+=priv->YOffSet;

		for (gtc=req->Controls;gtc;gtc=gtc->Next)
		    if (gtc->NewGadget) gtc->NewGadget->ng_TopEdge+=priv->YOffSet;
	    }



	    if (req->ITexts) PrintIText(req->Window->RPort,req->ITexts,0,0);
	    if (req->Borders) DrawBorder(req->Window->RPort,req->Borders,0,0);
	    if (req->Images) DrawImage(req->Window->RPort,req->Images,0,0);

	    if (priv->vinfo=GetVisualInfo(req->Window->WScreen,TAG_DONE)) {
		gtc=0;
		if (gad=CreateContext(&priv->Context)) {
		    struct Gadget *lasttime;

		    do {
			struct TagItem *tia,*nti;

			lasttime=gad;
			for (gtc=req->Controls;gtc;gtc=gtc->Next) {
			    if (!(gtc->Gadget)) {
				nti=0;

				if (tia=FindTagItem(GTCT_NEXTDATATOGADGETADDRESS,
				 gtc->GadgetTags)) {
				    struct GTControl *gtc2;

				    tia++;
				    gtc2=(struct GTControl *)tia->ti_Data;
				    if (gtc2->Gadget) {
					if (nti=CloneTagItems(gtc->GadgetTags)) {
					    tia=FindTagItem(GTCT_NEXTDATATOGADGETADDRESS,nti);
					    tia->ti_Tag=TAG_IGNORE;
					    ++tia;
					    tia->ti_Data=gtc2->Gadget;
					    tia=gtc->GadgetTags;
					    gtc->GadgetTags=nti;
					}
				    } else continue;
				}
				gad=ControlToGadget(req,gad,gtc,priv->vinfo);
				if (nti) {
				    gtc->GadgetTags=tia;
				    FreeTagItems(nti);
				}
				if (!gad) break;
			    }
			}
		    } while (lasttime!=gad && gad);
		    if (gad) {
			if (req->Menus) priv->MenuStrip=GTInitMenus(req,priv->vinfo);

			if (!(req->Menus) || priv->MenuStrip) {
			    req->LastGadgetEvent=&priv->LastGadgetEvent;
			    req->BeforeLastGadgetEvent=&priv->BeforeLastGadgetEvent;

			    AddGList(req->Window,priv->Context,-1,-1,0);
			    RefreshGList(priv->Context,req->Window,0,-1);
			    GT_RefreshWindow(req->Window,NULL);

			    req->Flags |= GT_GADGETSADDED;

			    if (req->Flags & INITFROMDATA) {
				for (gtc=req->Controls;gtc;gtc=gtc->Next)
				    InitGTCAttr(req,gtc);
			    }

			    if (req->InitFunction) (*(req->InitFunction)) (req);

			    return 1;
			}
		    }
		}
	    }
	}
	FreeRequest (rs,req);

    }
    return 0;
}

LONG AddGTRequest(struct GTReqSet *rs,struct GTRequest *gtr)
{
    struct ReqNode *rn;

    if (rn=AllocMem(sizeof(*rn),MEMF_PUBLIC | MEMF_CLEAR)) {
	rn->req=gtr;
	AddTail(&rs->List,rn);

	if (InitShowRequest(rs,gtr))
	    return 1;

	Remove(rn);
	FreeMem(rn,sizeof(*rn));
    }
    return 0;
}

__far void ProcessReqSet (struct GTReqSet *set)
{
    struct GTControl *gtc;
    UBYTE cont;
    struct IntuiMessage Msg,*pMsg;
    ULONG Signals=0;
    struct ReqNode *rn,*nextrn;
    struct GTRequest *req;
    struct GTPrivate *priv;

    while (FirstItem(&set->List)) {

	for (rn=FirstItem(&set->List);rn;rn=nextrn) {
	    nextrn=NextItem(rn);
	    if (rn->req->Terminate) {
		if (req->Flags & STOREDATA && req->Terminate>0) {
		    for (gtc=req->Controls;gtc;gtc=gtc->Next)
			StoreGTCAttr(req,gtc);
		}
		FreeRequest(set,req);
		Remove(rn);
		FreeMem(rn,sizeof(*rn));
	    }
	}
	if (!FirstItem(&set->List)) break;

	Signals|=SetSignal(0,0);
	cont=0;

	pMsg=GT_GetIMsg(set->MsgPort);

	if (!pMsg) {
	    for (rn=FirstItem(&set->List);rn;rn=NextItem(rn)) {
		if (rn->req->SignalFunction)
		    cont=(*(rn->req->SignalFunction)) (rn->req,Signals) ? 1 : cont;
	    }
	}

	if (!cont && !pMsg) {
	    for (rn=FirstItem(&set->List);rn;rn=NextItem(rn)) {
		if (rn->req->CallLoop) {
		    if (rn->req->LoopFunction) {
			(*(rn->req->LoopFunction)) (req);
			cont=1;
		    }
		}
	    }
	}

	if (cont) continue;
	if (!pMsg) {
	    ULONG WaitSignals;

	    WaitSignals=1<<set->MsgPort->mp_SigBit;

	    for (rn=FirstItem(&set->List);rn;rn=NextItem(rn))
		WaitSignals|=rn->req->AdditionalSignals;

	    Signals=Wait(WaitSignals);
	    continue;
	}
	if (pMsg) {
	    Msg=*pMsg;
	    if (pMsg->ExecMessage.mn_ReplyPort)
		GT_ReplyIMsg(pMsg);
	    else FreeIntuiMsg(pMsg);
	    pMsg=0;
	}

	for (rn=FirstItem(&set->List);rn;rn=NextItem(rn))
	    if (rn->req->Window==Msg.IDCMPWindow) break;

	if (rn) req=rn->req;
	else continue;

	priv=(struct GTPrivate *)req->InternalData;

	/* Process Message Now */

	if (Msg.Class==IDCMP_RAWKEY) {
	    BOOL Processed=0;

	    for (gtc=req->Controls;gtc;gtc=gtc->Next) {
		if (gtc->HandleKeyCommand)
		    Processed=(*(gtc->HandleKeyCommand)) (req,gtc,&Msg);
		else if (gtc->ASCIICommand) {
		    USHORT rq=0;
		    if (Msg.Qualifier & 7) rq=1;  /* shift */
		    if (Msg.Qualifier & 8) rq|=8; /* control */
		    if (Msg.Qualifier & 0x30) rq|=0x10; /* alt */
		    if (Msg.Qualifier & 0xc0) rq|=0x40; /* command (Amiga) */
		    if (gtc->RawKeyCommand==Msg.Code
		     && gtc->Qualifier==rq) {
			GTControlClick(req,gtc);
			Processed=1;
		    }
		}
		if (Processed) break;
	    }
	    if (Processed) continue;
	}


	if (Msg.Class & req->AppIDCMP) {
	    struct MessageHandler *mh;

	    for (mh=req->MsgHandlerList;mh;mh=mh->Next)
		ProcessMsgHandler (req,mh,&Msg,0);

	    for (gtc=req->Controls;gtc;gtc=gtc->Next) {
		for (mh=gtc->MsgHandlerList;mh;mh=mh->Next)
		    ProcessMsgHandler(req,mh,&Msg,gtc);
	    }
	    if (Msg.Class & IDCMP_MENUPICK && req->MenuInfo) {
		struct GTMenuInfo *menus;

		for (menus=req->MenuInfo;menus->Code;++menus)
		    if (menus->Code==Msg.Code) {
			if (menus->Function)
			    (*(menus->Function)) (req,&Msg);
			break;
		    }
	    }
	}

	if (Msg.Class==IDCMP_GADGETUP ||
	 Msg.Class==IDCMP_GADGETDOWN) {
	    if (gtc=FindGadgetControl(req->Controls,Msg.IAddress)) {

		if (Msg.Class==IDCMP_GADGETDOWN) {
		    if (gtc->GDownUpdateControl!=0xffffffff) {
			if (gtc->GDownUpdateControl)
			    (*(gtc->GDownUpdateControl)) (req,gtc,&Msg);
			else DispatchDefSetControlAttr(req,gtc,&Msg);
		    }
		    if (!((gtc->Gadget->GadgetType
		     & GTYP_GTYPEMASK)==GTYP_STRGADGET))
			req->ActiveControl=gtc;
		    else req->ActiveControl=0;
		} else {
		    if (gtc->GUpUpdateControl!=0xffffffff) {
			if (gtc->GUpUpdateControl)
			    (*(gtc->GUpUpdateControl)) (req,gtc,&Msg);
			else DispatchDefSetControlAttr(req,gtc,&Msg);
		    }
		    req->ActiveControl=0;
		}
	    }

	    if (Msg.Class==IDCMP_GADGETUP) {
		struct Gadget *g;
		g=(struct Gadget *)Msg.IAddress;
		if (g && (g->GadgetType
		 & GTYP_GTYPEMASK)==GTYP_STRGADGET) {
		    g=g->NextGadget;
		    if (g && (g->GadgetType
		     & GTYP_GTYPEMASK)==GTYP_STRGADGET) {
			ActivateGadget(g,req->Window,0);
		    }
		}

	    }
	    priv->BeforeLastGadgetEvent=priv->LastGadgetEvent;
	    priv->LastGadgetEvent=Msg;
	}

    }
}

__far LONG GTRequest(struct GTRequest *req)
{
    LONG retval;
    struct GTReqSet rs;

    InitReqSet(&rs);

    if (retval=AddGTRequest(&rs,req)) {
	ProcessReqSet (&rs);

	retval=req->Terminate;
    }
    return retval;
}

struct GTControl *DuplicateControl(struct Remember **key,struct GTControl *c)
{
    struct GTControl *d;

    if (d=AllocRemember(key,sizeof(*d),MEMF_PUBLIC)) {
	*d=*c;
    }
    return d;
}

struct GTControl *DuplicateControlList(struct Remember **key,struct GTControl *c)
{
    struct GTControl *p,*d,*h=0;

    p=0;

    while (c) {
	if (d=DuplicateControl(key,c)) {
	    if (p) {
		p->Next=d;
	    } else h=d;
	    p=d;
	} else { h=0; break; }
	c=c->Next;
    }

    return h;
}


struct Request *DuplicateRequest (struct Remember **key,struct GTRequest *req)
{
    struct GTRequest *dreq;

    if (key) {
	if (dreq=AllocRemember(key,sizeof(*dreq),MEMF_PUBLIC)) {
	    *dreq=*req;

	    if (dreq->Controls=DuplicateControlList(key,req->Controls)) {
		return dreq;
	    }

	}
    }
    return 0;
}


