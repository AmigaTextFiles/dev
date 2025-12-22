/*
IGRequest.c

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
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <intuition/intuition.h>
#include <IntuiGen/IntuiGen.h>
#include <devices/keymap.h>
#include <devices/inputevent.h>
#include <devices/console.h>
#include <rexx/rxslib.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/alib_protos.h>

struct IGPrivate {
    struct Requester *BlockingReq;
    SHORT BlockedCount;
};


/* if you do not need the provisions to convert string gadget entries
 * to floats, comment the next line out
*/

/* #define FLOATINGMATH TRUE */



/* If you don't need to use the ARexx features comment this out. */

/* #define REXX TRUE */



/* If you don't need to use prop gadgets, comment this out.  */

#define PROPS TRUE


/* If you plan to make use of SelectBoxes (list boxes), leave this defined.
 *  for more compact code, comment it out.  Requires Props (above).
*/

#define SBOXES TRUE



/* If you are trying to compile a small memory model program, IGRequest
    can be a lot of over head.	To make it __far, uncomment the next line.
    Make sure that you define IGFAR before you include IGRequest.h! */

/*
#define IGFAR TRUE
*/




/* define these however you want, depending on your routines and
 * your compiler, and the type of floating point you want to use
*/

#define LongToString(s,l) (sprintf((s),"%d",(l)))
#define FloatToString(s,f) (sprintf((s),"%f",(f)))
typedef float IGFloat;




extern APTR IntuitionBase;
extern APTR GfxBase;

/* extern APTR MathBase; */
/* You may need this when using math, depending on your compiler */



/* String handling routines for string gadgets */

int cismember (char c,char *set)
/* returns true if c is in set */
{
    short i;
    for (i=0;set[i];++i)
	if (set[i]==c) return (++i);
    return (0);
}

void delchars (char *s,USHORT p,USHORT n)
/* deletes n chars starting at position p from string s */
{
    n+=p;
    if (n>strlen(s)) n=strlen(s);
    do {
	s[p++]=s[n];
    } while (s[n++]);
}

BOOL strelim (char *s,char *elim,BOOL k)
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


UBYTE InterpretDKey(UBYTE *start,UBYTE *descrip)
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

UBYTE RawKeyToAscii (USHORT code,USHORT qual)
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

SHORT ASCIIToRawKey (char c)
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


/* Procedure IGInitRequester */

void IGInitRequester (struct Window *win,    /* Window values relative to */
		      struct Requester *req, /* Intuition Requester */
		      SHORT rl, SHORT rr,    /* Left, right offsets from
					      * Window edge */
		      SHORT rt,SHORT rb)     /* Top, Bottom offsets from
					      * Window edge */
/*  NOTE: This routine calls Intuition's InitRequest, clearing any
 *   data values previously in requester */
{
	    InitRequester (req);
	    req->LeftEdge=rl;
	    req->TopEdge=rt;
	    req->Width=win->Width-rl-rr;
	    req->Height=win->Height-rt-rb;
}




/* for InitRequesterToOpen */

#define RSOF 2 /* Number of pixels to leave on sides of window */
#define RTOF 12 /* Number of pixels to leave on top */
#define RBOF 2 /* Number of pixels to leave on bottom */




/* LookUp Table for IDCMP functions */

static ULONG ftable[]={ offsetof(struct IGRequest,SizeVerify),
    offsetof(struct IGRequest,NewSize), offsetof(struct IGRequest,RefreshWindow),
    offsetof(struct IGRequest,MouseButtons), offsetof(struct IGRequest,MouseMove),
    offsetof(struct IGRequest,GDownFunction), offsetof(struct IGRequest,GUpFunction),
    offsetof(struct IGRequest,ReqSet), offsetof(struct IGRequest,MenuPick),
    offsetof(struct IGRequest,CloseWindow), offsetof(struct IGRequest,RawKey),
    offsetof(struct IGRequest,ReqVerify), offsetof(struct IGRequest,ReqClear),
    offsetof(struct IGRequest,MenuVerify),offsetof(struct IGRequest,NewPrefs),
    offsetof(struct IGRequest,DiskInserted), offsetof(struct IGRequest,DiskRemoved),
    /* WBenchMessage */ NULL, offsetof(struct IGRequest,ActiveWindow),
    offsetof(struct IGRequest,InActiveWindow), offsetof(struct IGRequest,DeltaMove),
    /* VanillaKey */ NULL, offsetof(struct IGRequest,IntuiTicks)
};


#ifdef PROPS

/* Procedure FixIGProps
 * Fixes all links between Prop Gadgets, their arrows, and SelectBoxes.
 * Only links in IGPropInfo struct for each Prop Gadget need be initialized.
 * Ignores Non-Prop Gadgets
*/

void FixIGProps (struct Gadget *base)
{
    struct SelectBox *sbox;
    struct IGPropArrowInfo *ainfo;
    struct IGPropInfo *igpinfo;
    struct Gadget *gadg;

    while (base) {
	if ((base->GadgetType==GTYP_PROPGADGET) && base->UserData) {
	    igpinfo=(struct IGPropInfo *)base->UserData;
	    gadg=igpinfo->LUArrow;
	    ainfo=(struct IGPropArrowInfo *)gadg->UserData;
	    if (ainfo) ainfo->Prop=base;
	    gadg=igpinfo->RDArrow;
	    ainfo=(struct IGPropArrowInfo *)gadg->UserData;
	    if (ainfo) ainfo->Prop=base;
	    if (igpinfo->SBox) {
		sbox=igpinfo->SBox;
		sbox->Prop=base;
	    }
	}
	base=base->NextGadget;
    }
}




/* Procedure ModifyIGProp */
/* Sets IG Prop Gadget values to those specified in args,
 * refreshes Prop Gadget
*/

void ModifyIGProp (struct IGRequest *req,
		   struct Gadget *prop,
		   USHORT mx,my,dx,dy,
		   USHORT top,left)
{
    struct IGPropInfo *igpinfo;
    struct PropInfo *pinfo;

    if (!req || !prop) return ();

    pinfo=(struct PropInfo *)prop->SpecialInfo;
    igpinfo=(struct IGPropInfo *)prop->UserData;

    if (!pinfo || !igpinfo) return ();
    igpinfo->MaxX=mx;	      igpinfo->MaxY=my;
    igpinfo->DisplayedX=dx;   igpinfo->DisplayedY=dy;
    igpinfo->Top=top;	      igpinfo->Left=left;

    if (dx>mx) mx=dx;
    if (dy>my) my=dy;
    pinfo->HorizBody=(0xffff*dx)/mx;
    pinfo->VertBody=(0xffff*dy)/my;
    if (mx>dx)
	pinfo->HorizPot=(ULONG)((ULONG)left*0xffff/(mx-dx));
    else pinfo->HorizPot=0;
    if (my>dy)
	pinfo->VertPot=(ULONG)((ULONG)top*0xffff/(my-dy));
    else pinfo->VertPot=0;
    if (req->Window) RefreshGList (prop,req->Window,req->Requester,1);
}

#endif /* PROPS */

static struct TextAttr Attr={
    "topaz.font",TOPAZ_EIGHTY,NULL,FPF_ROMFONT
};

static struct IntuiText Template={
    1,0,JAM2,0,0,&Attr,0,0
};



#ifdef SBOXES


/* This Function Should fill in the ScrollFunc field of any prop gadgets
 * associated with a SelectBox
*/
void UpdateSBox (struct IGRequest *req, struct Gadget *gadg,
	    LONG x,LONG y)
{
    struct IGPropInfo *igpinfo;
    struct SelectBox *sbox;
    struct IntuiText text;
    struct SelectBoxEntry *entry,*e2;
    struct IGSBoxGadgetInfo *einfo;
    BYTE oldpen,oldmode,oldfgpen;
    UBYTE string[100];
    text=Template;

    igpinfo=(struct IGPropInfo *)gadg->UserData;
    sbox=igpinfo->SBox;
    einfo=(struct IGSBoxGadgetInfo *)sbox->GList->UserData;
    entry=einfo->Entry;

    for (e2=entry,x=0;x<sbox->Displayed && e2;++x,e2=e2->Next)
	e2->Gadget=0;

    while (entry && entry->Prev && y<entry->ID) entry=entry->Prev;
    while (entry && entry->Next && y>entry->ID) entry=entry->Next;

    oldfgpen=req->Window->RPort->FgPen;
    oldmode=req->Window->RPort->DrawMode;
    oldpen=req->Window->RPort->BgPen;
    SetBPen (req->Window->RPort,0);
    SetDrMd (req->Window->RPort,JAM2);

    text.IText=string;

    for (y=0;y<sbox->Displayed;++y) {
	einfo=(struct IGSBoxGadgetInfo *)sbox->GList[y].UserData;
	sbox->GList[y].Flags=GFLG_GADGHCOMP;
	einfo->Entry=entry;
	SetAPen (req->Window->RPort,0);
	RectFill (req->Window->RPort,sbox->GList[y].LeftEdge,
	    sbox->GList[y].TopEdge,sbox->GList[y].LeftEdge+sbox->GList[y].Width,
	    sbox->GList[y].TopEdge+sbox->GList[y].Height);
	if (entry) {
	    SetAPen (req->Window->RPort,1);
	    entry->Gadget=&(sbox->GList[y]);
	    text.LeftEdge=sbox->GList[y].LeftEdge;
	    text.TopEdge=sbox->GList[y].TopEdge+1;
	    text.FrontPen=entry->Color;
	    strcpy (string,entry->Text);
	    while (IntuiTextLength(&text)>sbox->Width-6)
		string[strlen(string)-1]=0;
	    PrintIText (req->Window->RPort,&text,0,0);
	}
	if (entry && entry->Flags & SB_SELECTED) {
	    sbox->GList[y].Flags=GFLG_SELECTED | GFLG_GADGHCOMP;
	    req->Window->RPort->BgPen=1;
	    SetDrMd (req->Window->RPort,COMPLEMENT | INVERSVID | JAM2);
	    RectFill (req->Window->RPort,sbox->GList[y].LeftEdge,
		sbox->GList[y].TopEdge,
		sbox->GList[y].LeftEdge+sbox->GList[y].Width-1,
		sbox->GList[y].TopEdge+sbox->GList[y].Height-1);
	    req->Window->RPort->BgPen=0;
	    SetDrMd (req->Window->RPort,JAM2);
	}
	if (entry) entry=entry->Next;
    }
    SetAPen (req->Window->RPort,oldfgpen);
    SetBPen (req->Window->RPort,oldpen);
    SetDrMd (req->Window->RPort,oldmode);
}




/* Any time new entries are added, or the selection status of
 * an item is changed, call this function to update the SelectBox
*/
void RefreshSBox (struct IGRequest *req,struct SelectBox *sb)
{
    struct IGPropInfo *pinfo;
    USHORT count,x;
    struct SelectBoxEntry *e;
    struct IGSBoxGadgetInfo *ginfo;

    pinfo=(struct IGPropInfo *)sb->Prop->UserData;
    ginfo=(struct IGSBoxGadgetInfo *)sb->GList->UserData;

    for (count=0,e=sb->Entries;e;e=e->Next,++count) e->ID=count;
    for (x=0,e=sb->Entries;e && e->Next && x<pinfo->Top;e=e->Next,++x);
    ModifyIGProp (req,sb->Prop,0,count,0,sb->Displayed,pinfo->Top,0);
    ginfo->Entry=e;
    UpdateSBox (req,sb->Prop,0,pinfo->Top);
}




/* Called by IGRequest.  Insures that all SelectBoxEntries are properly
 * numbered in their ID fields (Selectbox won't work otherwise).
 * When adding entries and calling RefreshSBox, it is not necessary to
 * call this function, as RefreshSBox also carries out this task
*/
void FixIDs (struct SelectBoxEntry *first)
{
    USHORT i=0;
    while (first) {
	first->ID=i;
	++i;
	first=first->Next;
    }
}

#endif /* SBOXES */


/* Generates the necessary structures and SHORT values for a two pixel thick,
 * two color box.  Returns pointer to first of two Border structures.  All
 * information is allocated on the Remember key
*/
struct Border *MakeBox (USHORT w,USHORT h,UBYTE c1,UBYTE c2,struct Remember **key)
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


#ifdef SBOXES

/* Called by IGRequest to generate borders for any selectbox that doesn't have
 * one.
*/
BOOL MakeSBBorder (struct SelectBox *sb)
{
    USHORT w,h;
    if (sb->BColor1==0 && sb->BColor2==0) return (0);
    sb->SBoxBorder=MakeBox(sb->Width,sb->Displayed*10+6,sb->BColor1,sb->BColor2,&sb->SBKey);
    if (!(sb->SBoxBorder)) return (1);
    return (0);
}




/* Using an array of strings with num entries, generates a corresponding
 * SelectBoxEntry list.  All entries' ItemSelected functions are set to func
*/
struct SelectBoxEntry *MakeSBEntryList (struct Remember **key,
					char *items[],int num,
					void (*func) ())

{
    struct SelectBoxEntry *e;
    USHORT i;

    e=(struct SelectBoxEntry *)AllocRemember (key,
	sizeof(struct SelectBoxEntry)*num,MEMF_PUBLIC);
    if (!e) return(0);
    for (i=0;i<num;++i) {
	e[i].Text=(UBYTE *)items[i];
	e[i].ID=i;
	e[i].Flags=0;
	e[i].ItemSelected=func;
	e[i].Next=&e[i+1];
	e[i].Prev=&e[i-1];
	e[i].Color=1;
    }
    e[0].Prev=0;
    e[i-1].Next=0;
    return (e);
}




/* Insures that all SelecBoxEntries in list are doubly linked.
 * Enables programmer to to define entries in source, singly linking them.
 * Automatically called by IGRequest
*/
void FixLinks (struct SelectBoxEntry *first)
{
    struct SelectBoxEntry *p;
    if (!first) return ();
    first->Prev=0;
    p=first;
    first=first->Next;
    while (first) {
	first->Prev=p;
	p=first;
	first=first->Next;
    }
}




/* Adds a SelectBoxEntry to a SelectBox and a given position */
void AddSBEntry (struct SelectBox *sb,struct SelectBoxEntry *toadd,int pos)
{
    SHORT i=0;
    struct SelectBoxEntry *e;

    if (pos>0) --pos;

    e=sb->Entries;

    while (e && e->Next && i<pos) {
	e=e->Next;
	++i;
    }

    if (!e) i=-1;

    if (i<pos || i==-1) {
	++i;
	while (e && e->Next) e=e->Next;
	if (e) e->Next=toadd;
	toadd->Prev=e;
	toadd->Next=0;
    } else {
	toadd->Prev=e->Prev;
	if (toadd->Prev) toadd->Prev->Next=toadd;
	toadd->Next=e;
	e->Prev=toadd;
    }
    if (i==0) sb->Entries=toadd;
    FixIDs (sb->Entries);
}




void AddSBEntryAlpha (struct SelectBox *sb,struct SelectBoxEntry *entry)
{
    struct SelectBoxEntry *e;
    USHORT i=1;

    e=sb->Entries;

    if (!e) {
	AddSBEntry (sb,entry,0);
	return ();
    }

    while (e && stricmp (e->Text,entry->Text)<0) {
	e=e->Next;
	++i;
    }
    AddSBEntry (sb,entry,i);
}




/* Creates a SelectBoxEntry for a given string, then calls AddSBEntry.
 * Entry is allocated on Remembery key, Returns 1 on error,
 * 0 for success.
*/
BOOL AddEntry (struct SelectBox *sb,
	       char *entry, void (*func) (),
	       int pos)
{
    struct SelectBoxEntry *e;

    e=(struct SelectBoxEntry *)AllocMem (sizeof(struct SelectBoxEntry),
	MEMF_CLEAR | MEMF_PUBLIC);
    if (!e) return (1);

    e->Text=entry;
    e->ItemSelected=func;
    e->Flags=0;
    e->Color=1;
    AddSBEntry (sb,e,pos);
    return (0);
}




/* Same as above, but places Entry in alphabetical order */
BOOL AddEntryAlpha (struct SelectBox *sb,
		    char *entry, void (*func) () )
{
    struct SelectBoxEntry *e;
    USHORT i=1;

    e=sb->Entries;

    if (!e) return (AddEntry (sb,entry,func,0));

    while (e && stricmp (e->Text,entry)<0) {
	e=e->Next;
	++i;
    }
    return (AddEntry (sb,entry,func,i));
}

void RemoveSBEntry (struct SelectBox *sb,struct SelectBoxEntry *e)
{
    if (e->Next) e->Next->Prev=e->Prev;
    if (e->Prev) e->Prev->Next=e->Next;
    if (sb->Entries==e) sb->Entries=e->Next;
    if (sb->Selected==e) sb->Selected=0;
    e->Next=e->Prev=0;
    FixIDs (sb->Entries);
}

void FreeSBEntry (struct SelectBoxEntry *e)
{
    FreeMem (e,sizeof (struct SelectBoxEntry));
}

void ClearSBox (struct SelectBox *sb,BOOL free)
{
    struct SelectBoxEntry *e;
    struct Gadget *prop;
    struct IGPropInfo *pinfo;

    e=sb->Entries;
    while (e) {
	RemoveSBEntry (sb,e);
	if (free) FreeSBEntry (e);
	e=sb->Entries;
    }
    prop=sb->Prop;
    pinfo=(struct IGPropInfo *)prop->UserData;
    pinfo->MaxY=pinfo->Top=0;
}

void SBoxSelectAll (struct SelectBox *sb)
{
    struct SelectBoxEntry *e;

    e=sb->Entries;
    if (!e) return();
    while (e->Next) {
	e->Flags|=SB_SELECTED;
	e=e->Next;
    }
    e->Flags|=SB_SELECTED;
    sb->Selected=e;
}

void SBoxDSelectAll (struct SelectBox *sb)
{
    struct SelectBoxEntry *e;

    e=sb->Entries;
    while (e) {
	FLAGOFF(e->Flags,SB_SELECTED);
	e=e->Next;
    }
    sb->Selected=0;
}

#endif /* SBOXES */


/* For removing a Gadget from the IGRequest's Gadget list that was
   added by an IGObject.  This will normally be called by that
   object's cleanup routine.  IT CANNOT BE CALLED WHILE THE REQUESTER
   IS ACTIVE (ON SCREEN).

   The Following IGRemove functions perform similar functions, just
   on a different structure category.
*/
void IGRemoveGadget (struct IGRequest *req,struct Gadget *rm)
{
    struct Gadget *n;
    if (req->Gadgets==rm) {
	req->Gadgets=rm->NextGadget;
	rm->NextGadget=0;
    } else {
	for (n=req->Gadgets;n->NextGadget;n=n->NextGadget)
	    if (n->NextGadget==rm) {
		n->NextGadget=rm->NextGadget;
		rm->NextGadget=0;
		break;
	    }
    }
}

void IGRemoveBorder (struct IGRequest *req,struct Border *rm)
{
    struct Border *n;
    if (req->Borders==rm) {
	req->Borders=rm->NextBorder;
	rm->NextBorder=0;
    } else {
	for (n=req->Borders;n->NextBorder;n=n->NextBorder)
	    if (n->NextBorder==rm) {
		n->NextBorder=rm->NextBorder;
		rm->NextBorder=0;
		break;
	    }
    }
}

void IGRemoveImage (struct IGRequest *req,struct Image *rm)
{
    struct Image *n;
    if (req->Images==rm) {
	req->Images=rm->NextImage;
	rm->NextImage=0;
    } else {
	for (n=req->Images;n->NextImage;n=n->NextImage)
	    if (n->NextImage==rm) {
		n->NextImage=rm->NextImage;
		rm->NextImage=0;
		break;
	    }
    }
}

void IGRemoveIText (struct IGRequest *req,struct IntuiText *rm)
{
    struct IntuiText *n;
    if (req->ITexts==rm) {
	req->ITexts=rm->NextText;
	rm->NextText=0;
    } else {
	for (n=req->ITexts;n->NextText;n=n->NextText)
	    if (n->NextText==rm) {
		n->NextText=rm->NextText;
		rm->NextText=0;
		break;
	    }
    }
}

void IGRemoveSBox (struct IGRequest *req,struct SelectBox *rm)
{
    struct SelectBox *n;
    if (req->SBoxes==rm) {
	req->SBoxes=rm->Next;
	rm->Next=0;
    } else {
	for (n=req->SBoxes;n->Next;n=n->Next)
	    if (n->Next==rm) {
		n->Next=rm->Next;
		rm->Next=0;
		break;
	    }
    }
}

void IGRemoveIGObject (struct IGRequest *req,struct IGObject *rm)
{
    struct IGObject *n;
    if (req->IGObjects==rm) {
	rm->Next->Prev=0;
	req->IGObjects=rm->Next;
	rm->Next=0;
    } else {
	for (n=req->IGObjects;n->Next;n=n->Next)
	    if (n->Next==rm) {
		rm->Next->Prev=n;
		n->Next=rm->Next;
		rm->Next=rm->Prev=0;
		break;
	    }
    }
}


/* Procedure IGFromStruct */
/* Copies values from datastructure into the requester Gadgets */

void IGFromStruct (ULONG ds,struct Gadget *gadg)
{
    struct IGStringInfo *igsinfo;
    struct IGBoolInfo *binfo;
    struct StringInfo *sinfo;

    if (!ds || !gadg) return ();

    for (;gadg;gadg=gadg->NextGadget) {
	if ((gadg->GadgetType & GTYP_BOOLGADGET) &&
	    (gadg->Activation & GACT_TOGGLESELECT)) {
		binfo=(struct IGBoolInfo *)gadg->UserData;
		if (binfo && (binfo->Type & BOOL_FILL)) {
		    ULONG *field;
		    field=(ULONG *)(ds+binfo->DataStructOffSet);
		    if ((*field) & (1<<binfo->BitToSet)) {
			gadg->Flags|=GFLG_SELECTED;
		    } else FLAGOFF (gadg->Flags,GFLG_SELECTED);
		}
	} else if (gadg->GadgetType & GTYP_STRGADGET) {
	    sinfo=(struct StringInfo *)gadg->SpecialInfo;
	    igsinfo=(struct IGStringInfo *) gadg->UserData;

	    if (!sinfo || !igsinfo) continue;
	    if (igsinfo->Type & STRING_FILL) {
#ifdef FLOATINGMATH
		if (igsinfo->Type & STRING_FLOAT) {
		    IGFloat *p;
		    p=(IGFloat *)(ds+igsinfo->DataStructOffSet);
		    FloatToString (sinfo->Buffer,*p);
		}
#endif /* FLOATINGMATH */
		if (igsinfo->Type & (STRING_SHORT | STRING_LONG)) {
		    LONG *l;
		    SHORT *s;
		    if (igsinfo->Type & STRING_SHORT) {
			s=(SHORT *)(ds+igsinfo->DataStructOffSet);
			LongToString (sinfo->Buffer,*s);
		    } else {
			l=(LONG *)(ds+igsinfo->DataStructOffSet);
			LongToString (sinfo->Buffer,*l);
		    }
		} else if (!(igsinfo->Type & STRING_FLOAT))
		    strcpy (sinfo->Buffer,ds+igsinfo->DataStructOffSet);
	    }
	}
    }
}




/* Procedure IGFillStruct */
/* copies appropriate value into data struct ds for each IG string gadget
 * in the gadget list
*/

void IGFillStruct (ULONG ds,struct Gadget *gadg)
{
    struct IGStringInfo *igsinfo;
    struct IGBoolInfo *binfo;
    struct StringInfo *sinfo;

    if (!ds || !gadg) return ();

    for (;gadg;gadg=gadg->NextGadget) {
	if ((gadg->GadgetType & GTYP_BOOLGADGET) &&
	    (gadg->Activation & GACT_TOGGLESELECT)) {
		binfo=(struct IGBoolInfo *)gadg->UserData;
		if (binfo && (binfo->Type & BOOL_FILL)) {
		    ULONG *field;
		    field=(ULONG *)(ds+binfo->DataStructOffSet);
		    if (gadg->Flags & GFLG_SELECTED) (*field)|=1<<binfo->BitToSet;
		    else FLAGOFF ((*field),1<<binfo->BitToSet);
		}
	} else if (gadg->GadgetType & GTYP_STRGADGET) {
	    sinfo=(struct StringInfo *)gadg->SpecialInfo;
	    igsinfo=(struct IGStringInfo *)gadg->UserData;

	    if (!sinfo || !igsinfo) continue;
	    if (igsinfo->Type & STRING_FILL) {
#ifdef FLOATINGMATH
		if (igsinfo->Type & STRING_FLOAT) {
		    IGFloat x,*p;
		    x=strtod (sinfo->Buffer,0);
		    p=(IGFloat *)(ds+igsinfo->DataStructOffSet);
		    *p=x;
		}
#endif /* FLOATINGMATH */
		if (igsinfo->Type & (STRING_SHORT | STRING_LONG)) {
		    LONG x,*l;
		    SHORT *s;
		    x=strtol (sinfo->Buffer,0,10);
		    if (igsinfo->Type & STRING_SHORT) {
			s=(SHORT *)(ds+igsinfo->DataStructOffSet);
			*s=x;
		    } else {
			l=(LONG *)(ds+igsinfo->DataStructOffSet);
			*l=x;
		    }
		} else if (!(igsinfo->Type & STRING_FLOAT))
		    strcpy(ds+igsinfo->DataStructOffSet,sinfo->Buffer);
	    }
	}
    }
}




/* For internal use by IGRequest, you probably will never need to
 * use this routine yourself
*/

void StringGUp (struct IGRequest *req,struct Gadget *gadg)
{
    struct IGStringInfo *sinfo;
    struct StringInfo *strinfo;
    BOOL refresh=0;

    strinfo=(struct StringInfo *)gadg->SpecialInfo;
    sinfo=(struct IGStringInfo *)gadg->UserData;

#ifdef FLOATINGMATH
    if (sinfo->Type & STRING_FLOAT) {
	IGFloat fl;
	if (strelim(strinfo->Buffer,"-.0987654321",1))
	    refresh=1;
	fl=strtod (strinfo->Buffer,0);
	if (sinfo->Type & STRING_HIGHLIMIT && fl>sinfo->StringHigh) {
	    LongToString (strinfo->Buffer,sinfo->StringHigh);
	    refresh=1;
	}
	if (sinfo->Type & STRING_LOWLIMIT && fl<sinfo->StringLow) {
	    LongToString (strinfo->Buffer,sinfo->StringLow);
	    refresh=1;
	}
    }
#endif /* FLOATINGMATH */
    if (sinfo->Type & (STRING_SHORT | STRING_LONG)) {
	LONG  lng;
	if (strelim(strinfo->Buffer,"-0987654321",1))
	    refresh=1;
	lng=strtol (strinfo->Buffer,0,10);
	if (sinfo->Type & STRING_HIGHLIMIT && lng>sinfo->StringHigh) {
	    LongToString (strinfo->Buffer,sinfo->StringHigh);
	    refresh=1;
	}
	if (sinfo->Type & STRING_LOWLIMIT && lng<sinfo->StringLow) {
	    LongToString (strinfo->Buffer,sinfo->StringLow);
	    refresh=1;
	}
    } else if (!(sinfo->Type & STRING_FLOAT))
	if (strelim (strinfo->Buffer,sinfo->DisAllowedChars,0)) refresh=1;

    if (refresh) RefreshGList (gadg,req->Window,req->Requester,1);
}




#define FreeIntuiMsg(x) FreeMem(x,sizeof(struct IntuiMessage))

BOOL SendIntuiMsg (struct IGRequest *req,ULONG Class,ULONG Code,
		    USHORT Qualifier,APTR IAddress)
{
    struct IntuiMessage *msg;
    ULONG secs,mics;

    if (!(req->IComPort)) return (1);

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




BYTE AllocCLBit (struct IGRequest *req)
{
    BYTE toreturn;
    for (toreturn=0;toreturn<32;++toreturn)
	if (!(req->LoopBitsUsed & (1<<toreturn))) break;
    if (toreturn==32) return (-1);
    req->LoopBitsUsed|=(1<<toreturn);
    return (toreturn);
}


void FreeCLBit (struct IGRequest *req,UBYTE bit)
{
    FLAGOFF(req->LoopBitsUsed,(1<<bit));
}




/* internal use */
void ClearIGOServiced (struct IGRequest *req)
{
    struct IGObject *igo;
    for (igo=req->IGObjects;igo;igo=igo->Next)
	igo->Serviced=0;
}


void StimulateGadget (struct IGRequest *req,struct Gadget *gadg)
{
    if (!(gadg->Flags & GFLG_DISABLED)) {
	if (gadg->GadgetType & GTYP_STRGADGET)
	    ActivateGadget (gadg,req->Window,req->Requester);
	else if (gadg->GadgetType & GTYP_BOOLGADGET) {
	    gadg->Flags^=GFLG_SELECTED;
	    RefreshGList (gadg,req->Window,req->Requester,1);
	    if (!(gadg->Activation & GACT_TOGGLESELECT)) {
		gadg->Flags^=GFLG_SELECTED;
		RefreshGList (gadg,req->Window,req->Requester,1);
	    }
	}
    }
}


BOOL GadgetClick(struct IGRequest *req,struct Gadget *gadg)
{
    BOOL x=0;

    if (!(gadg->Flags & GFLG_DISABLED)) {
	if (gadg->Activation & GACT_IMMEDIATE)
	    x|=SendIntuiMsg(req,IDCMP_GADGETDOWN,0,0,(APTR)gadg);
	if (!(gadg->GadgetType & GTYP_STRGADGET)) {
	    if (gadg->Activation & GACT_RELVERIFY)
		x|=SendIntuiMsg(req,IDCMP_GADGETUP,0,0,(APTR)gadg);
	}
	if (x) return (x);
	StimulateGadget (req,gadg);
    }
    return (0);
}




BOOL KeyClick (struct IGRequest *req,UBYTE *keyinfo,UBYTE key)
{
    USHORT qual=0,rk;
    if (cismember('a',keyinfo)) qual|=0x10;
    if (cismember('A',keyinfo)) qual|=0x40;
    if (cismember('s',keyinfo)) qual|=0x01;
    if (cismember('c',keyinfo)) qual|=0x08;

    rk=ASCIIToRawKey(key);
    if (rk==-1) return (3);
    return (SendIntuiMsg(req,IDCMP_RAWKEY,rk,qual,0));
}



#ifdef REXX

struct Gadget *FindRexxGadget (struct Gadget *gadg,UBYTE *name)
{
    struct IGBoolInfo *binfo;
    struct IGStringInfo *sinfo;

    for (;gadg;gadg=gadg->NextGadget) {
	if (gadg->GadgetType & GTYP_BOOLGADGET) {
	    binfo=gadg->UserData;
	    if (binfo)
		if (!stricmp(binfo->RexxName,name)) break;
	} else if (gadg->GadgetType & GTYP_STRGADGET) {
	    sinfo=gadg->UserData;
	    if (sinfo)
		if (!stricmp(sinfo->RexxName,name)) break;
	}
    }
    return (gadg);
}




struct IGMenu *FindRexxMenu (struct IGRequest *req,UBYTE *name)
{
    struct IGMenu *igm;

    igm=req->Menus;

    for (;igm->Code;++igm)
	if (!stricmp(igm->RexxName,name)) break;
    if (!(igm->Function)) igm=0;
    return (igm);
}

#endif /* REXX */




BOOL MenuPick (struct IGRequest *req,struct IGMenu *igm)
{
    BOOL result;
    result=SendIntuiMsg (req,IDCMP_MENUPICK,igm->Code,0,0);
    return result;
}





void SetStringGad (struct IGRequest *req,struct Gadget *gadg,UBYTE *string)
{
    struct StringInfo *info;

    if (!(gadg->GadgetType & GTYP_STRGADGET)) return;

    info=(struct StringInfo *)gadg->SpecialInfo;
    strcpy (info->Buffer,string);
    info->BufferPos=info->DispPos=0;
    RefreshGList (gadg,req->Window,req->Requester,1);
    SendIntuiMsg (req,IDCMP_GADGETDOWN,0,0,gadg);
    SendIntuiMsg (req,IDCMP_GADGETUP,0,0,gadg);
}


#ifdef REXX

#define RxPullWord(rxcom,combuf,ndx,len) \
    PullWordIndex(rxcom,combuf,ndx," ,","",len)

LONG PullWordIndex (UBYTE *slist,UBYTE *word,USHORT index,
		      UBYTE *delim,UBYTE *retdelim,USHORT len)
{
    USHORT i,quotes=0,b,x;
    UBYTE quotetypestack[10]; /* Up to 10 levels of nested quotes */
    SHORT qsx=-1;

    if (!slist[index]) return (index);
    i=index;

    while (cismember(slist[i],delim)) ++i;
    for (b=i;slist[i] &&
	     ( (!cismember(slist[i],delim) && !cismember(slist[i],retdelim) )
	      || quotes);
			 ++i) {

	if (slist[i]=='\'' || slist[i]=='\"') {
	    if (qsx>-1 && slist[i]==quotetypestack[qsx]) {
		--qsx;
		if (qsx==-1) quotes=0;
	    } else if (qsx<9) {
		++qsx;
		quotetypestack[qsx]=slist[i];
		quotes=1;
	    }
	}
    }

    if (b==i && cismember(slist[i],retdelim)) ++i;

    for (x=0;b<i;++x,++b) {
	if (x==len-1) break;
	word[x]=slist[b];
    }
    word[x]=0;

    return (i);
}

BOOL IGProcessRexxMsg (struct IGRequest *req,struct RexxMsg *rm)
{
    struct Gadget *gadg;
    UBYTE com[30],*rxcom;
    USHORT rk,ndx;
    UBYTE CommandStatus=0;

    rxcom=rm->rm_Args[0];
    if (!rxcom) return;

    ndx=RxPullWord(rxcom,com,0,30);

    if (!stricmp(com,"KEYCLICK")) {
	UBYTE arg1[30],arg2[4];
	ndx=RxPullWord(rxcom,arg1,ndx,30);
	ndx=RxPullWord(rxcom,arg2,ndx,4);

	if (arg1[0] && arg2[0]) {
	    rm->rm_Result1=KeyClick (req,arg1,arg2[0]);
	    if (rm->rm_Result1) rm->rm_Result1+=10;
	} else rm->rm_Result1=10;

    } else if (!stricmp(com,"GADGETCLICK")) {
	UBYTE arg1[50];
	ndx=RxPullWord(rxcom,arg1,ndx,50);
	if (arg1[0]) {
	    gadg=FindRexxGadget(req->Gadgets,arg1);
	    if (gadg) {
		rm->rm_Result1=GadgetClick(req,gadg);
		if (rm->rm_Result1) rm->rm_Result1+=10;
	    } else CommandStatus=1;
	} else rm->rm_Result1=10;

    } else if (!stricmp(com,"SETSTRINGGAD")) {
	UBYTE arg1[50],arg2[200];
	ndx=RxPullWord(rxcom,arg1,ndx,50);
	ndx=RxPullWord(rxcom,arg2,ndx,200);

	if (arg1[0] && arg2[0]) {
	    gadg=FindRexxGadget(req->Gadgets,arg1);
	    if (gadg) {
		SetStringGad (req,gadg,arg2);
	    } else CommandStatus=1;
	} else rm->rm_Result1=10;

    } else if (!stricmp(com,"MENUPICK")) {
	UBYTE arg1[100];
	ndx=RxPullWord(rxcom,arg1,ndx,100);
	if (arg1[0]) {
	    struct IGMenu *igm;
	    igm=FindRexxMenu(req,arg1);
	    if (igm) MenuPick(req,igm);
	    else CommandStatus=1;
	} else rm->rm_Result1=10;

    } else {
	struct IGObject *obj;
	BOOL processed=0;
	for (obj=req->IGObjects;obj;obj=obj->Next) {
	    if (!stricmp(com,obj->RexxName)) {
		if (obj->RexxFunction) processed=(*(obj->RexxFunction)) (req,obj,rm);
		break;
	    }
	}
	CommandStatus = !processed;
    }

    return (CommandStatus);
}

#endif /* REXX */




/*
    BlockIGInput Function opens an blank intuition requester on top
    of an IGRequest, thereby blocking its input
*/
void BlockIGInput(struct IGRequest *req)
{
    struct IGPrivate *p;

    if (req && req->Window) {
	p=(struct IGPrivate *)req->InternalData;
	if (!(p->BlockedCount)) {
	    struct Requester *areq;

	    if (areq=AllocMem(sizeof(struct Requester),MEMF_PUBLIC | MEMF_CLEAR)) {
		Request(areq,req->Window);
		req->Flags|=IG_INPUTBLOCKED;
		p->BlockingReq=areq;
		++p->BlockedCount;
	    }
	} else ++p->BlockedCount;
    }
}




/*
    UnBlockIGInput closes blank requester opened by BlockIGInput, thereby
    permitting messages to come through again
*/
void UnBlockIGInput(struct IGRequest *req)
{
    if (req && req->Flags & IG_INPUTBLOCKED) {
	struct IGPrivate *p;

	p=req->InternalData;
	--p->BlockedCount;

	if (!(p->BlockedCount)) {
	    EndRequest(p->BlockingReq,req->Window);
	    FreeMem(p->BlockingReq,sizeof(struct Requester));
	    FLAGOFF(req->Flags,IG_INPUTBLOCKED);
	    p->BlockingReq=0;
	}
    }
}




/*
    Adjust NewWindow Dimensions so that they fit on the screen
*/
void FixNewWindowDimensions(struct NewWindow *nw,struct Screen *s)
{
    SHORT x;

    if (nw->LeftEdge+nw->Width>s->Width) {
	x=s->Width-nw->Width;
	if (x>=0) nw->LeftEdge=x;
	else {
	    nw->LeftEdge=0;
	    nw->Width=s->Width;
	}
    }
    if (nw->TopEdge+nw->Height>s->Height) {
	x=s->Height-nw->Height;
	if (x>=0) nw->TopEdge=x;
	else {
	    nw->TopEdge=0;
	    nw->Height=s->Height;
	}
    }
}




/*
    ClearWindow Function, clears inside of window to background (0)
*/
void ClearWindow (struct Window *w)
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


/* IGRequest Function, handles request for IGRequest req */

/* If you are trying to compile a small memory model program, IGRequest
    can be a lot of over head.	To make it __far, uncomment the next line.
    Make sure that you define IGFAR before you include IGRequest.h! */

#ifdef IGFAR

__far

#endif

struct IGEndList *IGRequest (struct IGRequest *req)
{
    BOOL OpenedWindow=0,OpenedRequester=0,AddedGadgets=0,AllocedStuff=0,
	 PropInProgress=0;
    struct Gadget *DSel=0,*gadg,*prop,*DClick=0,*KeyPress=0;
    struct IntuiMessage msg,*msgp;
    struct IGEndList *el=0;
    ULONG Signals=0,DCSecs,DCMics,WaitSignals;
    USHORT i,GadgetYOffSet=0;
    struct IGPrivate igprivate;

    req->Terminate=0;
    FLAGOFF(req->Flags,IG_INPUTBLOCKED);
    req->InternalData=(APTR)&igprivate;

    igprivate.BlockedCount=0;
    igprivate.BlockingReq=0;

    if (!(req->Window)) {
	if (!(req->NewWindow)) goto error;
	if (req->NewWindow->Type != WBENCHSCREEN) {
	    struct Screen *s;
	    s=req->NewWindow->Screen;
	    GadgetYOffSet=s->WBorTop + s->Font->ta_YSize - 9;
	    req->NewWindow->Height+=GadgetYOffSet;
	    FixNewWindowDimensions(req->NewWindow,s);
	} else {
	    struct Screen s;
	    GetScreenData(&s,sizeof(struct Screen),WBENCHSCREEN,0);
	    GadgetYOffSet=s.WBorTop + s.Font->ta_YSize - 9;
	    req->NewWindow->Height+=GadgetYOffSet;
	    FixNewWindowDimensions(req->NewWindow,&s);
	}

	req->Window=OpenWindow (req->NewWindow);
	if (!(req->Window)) goto error;
	OpenedWindow=1;
    } else {
	struct Screen *s;
	s=req->Window->WScreen;
	GadgetYOffSet=s->WBorTop + s->Font->ta_YSize - 9;
	if (GadgetYOffSet) {
	    struct Window *w;
	    w=req->Window;
	    if (!((ULONG)w->UserData & WUD_FIXEDSIZE)) {
		if (w->TopEdge+w->Height+GadgetYOffSet>s->Height) {
		    SHORT x;
		    x=w->TopEdge+w->Height+GadgetYOffSet-s->Height;
		    if ((SHORT)w->TopEdge-x<0) {
			x=0-w->TopEdge;
			MoveWindow(w,0,x);
			SizeWindow(w,0,s->Height-w->Height);
		    } else {
			MoveWindow(w,0,0-x);
			SizeWindow(w,0,GadgetYOffSet);
		    }
		} else SizeWindow(w,0,GadgetYOffSet);
		w->UserData|=WUD_FIXEDSIZE;
	    }
	}
    }

    SetWindowTitles(req->Window,-1,req->ScreenName);

    if (!(req->Requester)) {
	if ((req->Flags & IG_ADDGADGETS) && GadgetYOffSet) {
	    struct Gadget *gadg;
	    for (gadg=req->Gadgets;gadg;gadg=gadg->NextGadget)
		gadg->TopEdge+=GadgetYOffSet;
	}
	if (req->Borders) {
	    if (GadgetYOffSet) {
		struct Border *bord;
		for (bord=req->Borders;bord;bord=bord->NextBorder)
		    bord->TopEdge+=GadgetYOffSet;
	    }
	}
	if (req->Images) {
	    if (GadgetYOffSet) {
		struct Image *image;
		for (image=req->Images;image;image=image->NextImage)
		    image->TopEdge+=GadgetYOffSet;
	    }
	}
	if (req->ITexts) {
	    if (GadgetYOffSet) {
		struct IntuiText *it;
		for (it=req->ITexts;it;it=it->NextText)
		    it->TopEdge+=GadgetYOffSet;
	    }
	}
    }
    if (req->IGObjects) {
	struct IGObject *igo,*prev;
	for (igo=req->IGObjects,prev=0;igo;igo=igo->Next) {
	    igo->Prev=prev;
	    prev=igo;
	    igo->GadgetYOffSet=GadgetYOffSet;
	    if (igo->InitFunction) {
		if ((*(igo->InitFunction)) (req,igo)) {
		    goto error;
		}
	    }
	}
    }
    if (req->KeyCommands) {
	struct IGKeyCommand *kc;

	for (kc=req->KeyCommands;kc->Gadget;++kc) {
	    if (!(kc->Command) && (kc->ASCIICommand))
		kc->Command=ASCIIToRawKey(kc->ASCIICommand);
	}
    }
    if (!(req->ReqKey)) {
	struct StringInfo *sinfo;
	struct IGStringInfo *igsinfo;

	AllocedStuff=1;

	for (gadg=req->Gadgets;gadg;gadg=gadg->NextGadget) {
	    if (gadg->GadgetType==GTYP_STRGADGET) {

		sinfo=(struct StringInfo *)gadg->SpecialInfo;
		igsinfo=(struct IGStringInfo *)gadg->UserData;

		if ( !(sinfo->Buffer) || (igsinfo->Type & STRING_ALLOC) ) {
		    sinfo->Buffer=(UBYTE *)AllocRemember (&req->ReqKey,
					    sinfo->MaxChars,MEMF_PUBLIC | MEMF_CLEAR);
		    if (!(sinfo->Buffer)) goto error;
		    igsinfo->Type|=STRING_ALLOC;
		    if (igsinfo->InitialValue) {
			strcpy (sinfo->Buffer,igsinfo->InitialValue);
			FLAGOFF (igsinfo->Type,STRING_INITONCE);
		    }
		}
	    }
	}
    }
#ifdef PROPS
    FixIGProps (req->Gadgets);
#endif /* PROPS */

    for (gadg=req->Gadgets;gadg;gadg=gadg->NextGadget) {
	struct StringInfo *sinfo;
	struct IGStringInfo *igsinfo;
	struct IGBoolInfo *igbinfo;
	struct IGPropInfo *igpinfo;

	igsinfo=(struct IGStringInfo *)gadg->UserData;

#ifdef PROPS
	if (gadg->GadgetType==GTYP_PROPGADGET) {
	    igpinfo=(struct IGPropInfo *)igsinfo;
	    ModifyIGProp (req,gadg,igpinfo->MaxX,igpinfo->MaxY,
		igpinfo->DisplayedX,igpinfo->DisplayedY,
		igpinfo->Top,igpinfo->Left);
	} else if ((igsinfo->Type & (STRING_INITONCE | STRING_INITALWAYS))) {
#else

	if ((igsinfo->Type & (STRING_INITONCE | STRING_INITALWAYS))) {
#endif /* PROPS */
	    if (igsinfo->Type & GADG_STRING) {
		sinfo=(struct StringInfo *)gadg->SpecialInfo;

		if (igsinfo->InitialValue) {
		    strcpy (sinfo->Buffer,igsinfo->InitialValue);
		    FLAGOFF(igsinfo->Type,STRING_INITONCE);
		}
	    } else if (igsinfo->Type & GADG_BOOL) {
		igbinfo=(struct IGBoolInfo *)igsinfo;
		if (igbinfo->InitialValue) gadg->Flags|=GFLG_SELECTED;
		else FLAGOFF(gadg->Flags,GFLG_SELECTED);
		FLAGOFF(igbinfo->Type,GADG_INITONCE);
	    }
	}
    }

    if (!(req->Flags & IG_INITDATASTRUCT)) IGFromStruct ((ULONG)req->DataStruct,req->Gadgets);
    if (req->InitFunction) (*(req->InitFunction)) (req);
    if ((req->RequesterToOpen)) {
	if (req->Flags & IG_INITREQUESTERTOOPEN) {
	    IGInitRequester (req->Window,req->RequesterToOpen,
		RSOF,RSOF,RTOF,RBOF);
	    req->RequesterToOpen->ReqGadget=req->Gadgets;
	    req->RequesterToOpen->ReqBorder=req->Borders;
	    req->RequesterToOpen->ReqText=req->ITexts;
	}
	req->Requester=req->RequesterToOpen;
	if (!Request(req->RequesterToOpen,req->Window)) goto error;
	OpenedRequester=1;
	RefreshWindowFrame (req->Window);
    }
    if (!(req->Requester)) {
	if ((req->Flags & IG_ADDGADGETS)) {
	    AddGList (req->Window,req->Gadgets,-1,-1,0);
	    AddedGadgets=1;
	}
	RefreshWindowFrame (req->Window);
	if (req->Borders) {
	    DrawBorder (req->Window->RPort,req->Borders,0,0);
	}
	if (req->Images) {
	    DrawImage  (req->Window->RPort,req->Images,0,0);
	}
	if (req->ITexts) {
	    PrintIText (req->Window->RPort,req->ITexts,0,0);
	}
#ifdef SBOXES
	if (req->SBoxes) {
	    struct SelectBox *sb;
	    struct IGSBoxGadgetInfo *sbinfo;

	    sb=req->SBoxes;
	    while (sb) {
		if (!(sb->IGObject)) sb->TopEdge+=GadgetYOffSet;
		sb->GList=AllocRemember(&sb->SBKey,
		    sizeof(struct Gadget)*sb->Displayed,MEMF_PUBLIC | MEMF_CLEAR);
		if (!(sb->GList)) goto error;
		sbinfo=AllocRemember (&sb->SBKey,sizeof(struct IGSBoxGadgetInfo)*sb->Displayed,
		    MEMF_PUBLIC | MEMF_CLEAR);
		if (!sbinfo) goto error;
		gadg=sb->GList;
		for (i=0;i<sb->Displayed;++i) {
		    gadg[i].NextGadget=&gadg[i+1];
		    gadg[i].TopEdge=sb->TopEdge+3+10*i;
		    gadg[i].LeftEdge=sb->LeftEdge+3;
		    gadg[i].Width=sb->Width-6;
		    gadg[i].Height=10;
		    gadg[i].Activation=sb->Flags & (SB_TOGGLEALL | SB_TOGGLEONE) ?
			GACT_TOGGLESELECT | GACT_RELVERIFY : GACT_RELVERIFY;
		    gadg[i].GadgetID=0xFFFF;  /* reserved exclusively for SB Gadgets,
					       * to avoid mixing them up with others */
		    gadg[i].GadgetType=GTYP_BOOLGADGET;
		    gadg[i].UserData=(APTR)&sbinfo[i];
		    sbinfo[i].Type=GADG_SBOX;
		    sbinfo[i].SBox=sb;
		}
		gadg[i-1].NextGadget=0;
		sbinfo->Entry=sb->Entries;
		if (!(sb->SBoxBorder))
		    if (MakeSBBorder (sb)) goto error;
		DrawBorder (req->Window->RPort,sb->SBoxBorder,sb->LeftEdge,sb->TopEdge);
		AddGList (req->Window,sb->GList,-1,-1,0);
		sb->Flags|=SB_ADDEDGADGETS;
		FixLinks (sb->Entries);
		RefreshSBox (req,sb);
		sb=sb->Next;
	    }
	}
#endif /* SBOXES */
    }

    req->IComPort=CreatePort (0,0);
    if (!(req->IComPort)) goto error;

    if (req->StringToActivate) GadgetClick (req,req->StringToActivate);
    if (req->MenuStrip) SetMenuStrip (req->Window,req->MenuStrip);

    for (el=req->EndList;el->Class!=0xffffffff;++el);

    while (!(req->Terminate)) {
	USHORT rq=0;

	ClearIGOServiced (req);

	Signals|=SetSignal(0,0);

#ifdef REXX
	if (req->ArexxPort && (Signals & 1<<req->ArexxPort->mp_SigBit)) {
	    struct RexxMsg *rm;
	    rm=(struct RexxMsg *)GetMsg (req->ArexxPort);
	    if (IGProcessRexxMsg(req,rm)) {
		if (req->ArexxFunction)
		    (*(req->ArexxFunction)) (req,rm);
		else rm->rm_Result1=10;
	    }
	    ReplyMsg (rm);
	    Signals ^= 1<<req->ArexxPort->mp_SigBit;
	    continue;
	}
#endif /* REXX */

	if (!(msgp=(struct IntuiMessage *)GetMsg (req->Window->UserPort))) {
	    if (!(msgp=(struct IntuiMessage *)GetMsg (req->IComPort))) {
		BOOL cont=0;

		if (req->SignalFunction)
		    cont=(*(req->SignalFunction)) (req,Signals);

		if (req->CallLoop && req->LoopFunction) {
		    (*(req->LoopFunction)) (req);
		} else if (!cont) {
		    if (req->Terminate) break;
		    WaitSignals=req->AdditionalSignals |
			1<<req->Window->UserPort->mp_SigBit |
			1<<req->IComPort->mp_SigBit;
		    if (req->ArexxPort) WaitSignals |= 1<<req->ArexxPort->mp_SigBit;
		    Signals=Wait ( WaitSignals );
		}
		continue;
	    } else {
		msg=*msgp;
		FreeIntuiMsg(msgp);
	    }
	} else {
	    msg=*msgp;
	    ReplyMsg (msgp);
	}

KeysBegin: ;
	if (msg.Qualifier & 7) rq=1;  /* shift */
	if (msg.Qualifier & 8) rq|=8; /* control */
	if (msg.Qualifier & 0x30) rq|=0x10; /* alt */
	if (msg.Qualifier & 0xc0) rq|=0x40; /* command (Amiga) */
	msg.Qualifier=rq;

	for (i=0;i<23;++i)
	    if ((1<<i) & msg.Class) {
		void (**func) ();
		if (ftable[i]) {
		    func=(ULONG)req+ftable[i];
			   /* Previous line will generate a warning */
		    if (*func) (**func) (req,&msg);
		    break;
		}
	    }

	if (req->OtherMessages) {
	    struct MessageHandler *mh;
	    for (mh=req->OtherMessages;mh;mh=mh->Next)
		if ((*mh->IsType) (req,&msg)) (mh->HandlerFunction) (req,&msg);
	}
	if (msg.Class & IDCMP_MENUPICK && req->Menus) {
	    struct IGMenu *menus;
	    for (menus=req->Menus;menus->Code;++menus)
		if (menus->Code==msg.Code) {
		    (*(menus->Function)) (req,&msg);
		    break;
		}
	}

	if ( DSel && ( msg.Class & ( IDCMP_MOUSEBUTTONS | IDCMP_GADGETDOWN | IDCMP_GADGETUP
		    | IDCMP_RAWKEY | IDCMP_REQSET | IDCMP_CLOSEWINDOW | IDCMP_INACTIVEWINDOW) ) ) {

	    struct IGStringInfo *info;

	    info=(struct IGStringInfo *)DSel->UserData;
	    StringGUp (req,DSel);
	    if (req->DSelectFunction || (info && info->DSelectFunction)) {
		struct IntuiMessage cp;
		cp=msg;
		cp.Class=IDCMP_GADGETUP;
		cp.IAddress=(APTR)DSel;
		if (req->DSelectFunction) (*(req->DSelectFunction)) (req,&cp);
		if (info->DSelectFunction) (*(info->DSelectFunction)) (req,&cp);
	    }
	    DSel=0;
	}

	if ( (msg.Class & (IDCMP_GADGETUP | IDCMP_GADGETDOWN)) || PropInProgress ) {
	    struct Gadget *nxtstr=0;
	    struct IGBoolInfo *info;
	    void (*gu) ()=0;
	    void (*gd) ()=0;

#ifdef PROPS
	    if (PropInProgress) {
		info=(struct IGBoolInfo *)gadg->UserData;
		goto handlearrow;
	    }
#endif /* PROPS */
	    gadg=(struct Gadget *)msg.IAddress;
	    prop=gadg;

	    if (gadg->UserData) {
		info=(struct IGBoolInfo *)gadg->UserData;
		if (info->Type & GADG_BOOL) {
		    gu=info->GUpFunction;
		    gd=info->GDownFunction;
		    if (msg.Class & IDCMP_GADGETUP) {
			if (gadg==DClick) {
			    if (DoubleClick(DCSecs,DCMics,msg.Seconds,msg.Micros)) {
				if (req->DoubleClick) (*(req->DoubleClick)) (req,&msg);
				if (info->DClickFunction) (*(info->DClickFunction)) (req,&msg);
			    }
			}
			DClick=gadg;
			DCSecs=msg.Seconds;
			DCMics=msg.Micros;
			if (gadg->Activation & GACT_TOGGLESELECT) {
			    struct Gadget *tgadg;

			    if (gadg->Flags & GFLG_SELECTED &&
			      gadg->MutualExclude) {

				tgadg=req->Gadgets;
				while (tgadg) {
				    if (tgadg->Activation & GACT_TOGGLESELECT &&
				      tgadg->MutualExclude & gadg->MutualExclude &&
				      tgadg->Flags & GFLG_SELECTED &&
				      tgadg!=gadg) {
					tgadg->Flags^=GFLG_SELECTED;
					RefreshGList (tgadg,req->Window,
					 req->Requester,1);
				    }
				    tgadg=tgadg->NextGadget;
				}
			    } else if (gadg->MutualExclude &&
			      info->Type & GADG_ONESELECTED) {
				UBYTE somethingon=0;
				tgadg=req->Gadgets;
				while (tgadg) {
				    if (tgadg->Activation & GACT_TOGGLESELECT &&
				      tgadg->MutualExclude & gadg->MutualExclude &&
				      tgadg->Flags & GFLG_SELECTED) {
					somethingon=1;
					break;
				    }
				    tgadg=tgadg->NextGadget;
				}
				if (!somethingon) {
				    gadg->Flags|=GFLG_SELECTED;
				    RefreshGList(gadg,req->Window,
				      req->Requester,1);
				}
			    }
			}
		    }
		} else if (info->Type & GADG_STRING) {
		    struct IGStringInfo *sinfo;
		    sinfo=(struct IGStringInfo *)info;
		    gu=sinfo->GUpFunction;
		    gd=sinfo->GDownFunction;
		    if (msg.Class & IDCMP_GADGETDOWN) DSel=gadg;
		    else if (msg.Code!=0x09) nxtstr=sinfo->NextStringGadget;
#ifdef SBOXES
		} else if (info->Type & GADG_SBOX) {
		    struct IGSBoxGadgetInfo *sinfo;
		    struct SelectBoxEntry *entry;

		    sinfo=(struct IGSBoxGadgetInfo *)info;
		    entry=sinfo->Entry;

		    if (entry) {
			void (*ItemFunc) ();
			void (*BoxFunc) ();

		      if (!(entry->Flags & SB_SELECTED)) {
			if (sinfo->SBox->Flags & SB_TOGGLEONE && sinfo->SBox->Selected) {
			    struct SelectBoxEntry *e;
			    BYTE oldpen,oldmode;
			    e=sinfo->SBox->Selected;
			    e->Flags=0;
			    if (e->Gadget) {
				oldpen=req->Window->RPort->BgPen;
				oldmode=req->Window->RPort->DrawMode;
				SetDrMd (req->Window->RPort,COMPLEMENT | JAM2 |
				    INVERSVID);
				SetBPen (req->Window->RPort,1);
				e->Gadget->Flags=GFLG_GADGHCOMP;
				RectFill (req->Window->RPort,e->Gadget->LeftEdge,
				    e->Gadget->TopEdge,e->Gadget->LeftEdge+e->Gadget->Width-1,
				    e->Gadget->TopEdge+e->Gadget->Height-1);
				SetDrMd (req->Window->RPort,oldmode);
				SetBPen (req->Window->RPort,oldpen);
			    }
			}
			if (sinfo->SBox->Flags & (SB_TOGGLEONE | SB_TOGGLEALL))
			    entry->Flags=SB_SELECTED;
			sinfo->SBox->Selected=entry;
			ItemFunc=entry->ItemSelected;
			BoxFunc=sinfo->SBox->ItemSelected;
			if (BoxFunc)
			    (*BoxFunc) (req,sinfo->SBox,entry,&msg);
			if (ItemFunc)
			    (*ItemFunc) (req,sinfo->SBox,entry,&msg);
		      } else {
			sinfo->SBox->Selected=0;
			entry->Flags=0;
			if (entry->Gadget) entry->Gadget->Flags=GFLG_GADGHCOMP;
			ItemFunc=entry->ItemDSelected;
			BoxFunc=sinfo->SBox->ItemDSelected;
			if (BoxFunc)
			    (*BoxFunc) (req,sinfo->SBox,entry,&msg);
			if (ItemFunc)
			    (*ItemFunc) (req,sinfo->SBox,entry,&msg);
		      }
		    } else if (sinfo->SBox->Flags & (SB_TOGGLEONE | SB_TOGGLEALL)) {
			BYTE oldpen,oldmode;
			gadg->Flags=GFLG_GADGHCOMP;
			oldpen=req->Window->RPort->BgPen;
			oldmode=req->Window->RPort->DrawMode;
			SetDrMd (req->Window->RPort,COMPLEMENT | JAM2 |
			    INVERSVID);
			SetBPen (req->Window->RPort,1);
			gadg->Flags=GFLG_GADGHCOMP;
			RectFill (req->Window->RPort,gadg->LeftEdge,
			    gadg->TopEdge,gadg->LeftEdge+gadg->Width-1,
			    gadg->TopEdge+gadg->Height-1);
			SetDrMd (req->Window->RPort,oldmode);
			SetBPen (req->Window->RPort,oldpen);
		    }
#endif /* SBOXES */
		}
#ifdef PROPS
handlearrow:	if (info->Type & GADG_ARROW) {
		    struct IGPropArrowInfo *arrow;
		    struct IGPropInfo *igpinfo;
		    struct PropInfo *pinfo;
		    BOOL refresh=1;
		    int n;

		    arrow=(struct IGPropArrowInfo *)info;
		    if (msg.Class & IDCMP_GADGETUP) {
			gu=arrow->GUpFunction;
			goto gadgdone;
		    }
		    if (arrow->GDownFunction && (msg.Class & IDCMP_GADGETDOWN))
			(*(arrow->GDownFunction)) (req,&msg);
		    prop=arrow->Prop;
		    pinfo=(struct PropInfo *)prop->SpecialInfo;
		    igpinfo=(struct IGPropInfo *)prop->UserData;


		    if ((pinfo->Flags & FREEVERT) && igpinfo->DisplayedY>igpinfo->MaxY)
			goto gadgdone;
		    if ((pinfo->Flags & FREEHORIZ) && igpinfo->DisplayedX>igpinfo->MaxX)
			goto gadgdone;

		    n=0xffff / (pinfo->Flags & FREEVERT ? igpinfo->MaxY :
				  igpinfo->MaxX);

		    if (gadg==igpinfo->LUArrow) {
			if (pinfo->Flags & FREEVERT) {
			    if (pinfo->VertPot>=n)
				pinfo->VertPot-=n;
			    else if (pinfo->VertPot>0) pinfo->VertPot=0;
			    else refresh=0;
			} else if (pinfo->Flags & FREEHORIZ) {
			    if (pinfo->HorizPot>=n)
				pinfo->HorizPot-=n;
			    else if (pinfo->HorizPot>0) pinfo->HorizPot=0;
			    else refresh=0;
			}
		    } else if (gadg==igpinfo->RDArrow) {
			if (pinfo->Flags & FREEVERT) {
			    if (pinfo->VertPot<=0xffff-n)
				pinfo->VertPot+=n;
			    else if (pinfo->VertPot<0xffff) pinfo->VertPot=0xffff;
			    else refresh=0;
			} else if (pinfo->Flags & FREEHORIZ) {
			    if (pinfo->HorizPot<=0xffff-n)
				pinfo->HorizPot+=n;
			    else if (pinfo->HorizPot<0xffff) pinfo->HorizPot=0xffff;
			    else refresh=0;
			}
		    }
		    if (refresh) RefreshGList (prop,req->Window,req->Requester,1);
		    info->Type=GADG_PROP | GADG_ARROW;
		}
handleprop:	if (info->Type & GADG_PROP) {
		    struct PropInfo *pinfo;
		    struct IGPropInfo *igpinfo;
		    ULONG top;
		    BOOL change=0;

		    igpinfo=(struct IGPropInfo *)prop->UserData;
		    pinfo=(struct PropInfo *)prop->SpecialInfo;
		    if (pinfo->Flags & FREEVERT) {
			if (igpinfo->MaxY>igpinfo->DisplayedY)
			    top=((ULONG)pinfo->VertPot * (igpinfo->MaxY-igpinfo->DisplayedY))/0xffff;
			else top=0;
			if (igpinfo->Top!=top) {
			    igpinfo->Top=top;
			    change=1;
			}
		    }
		    if (pinfo->Flags & FREEHORIZ) {
			if (igpinfo->MaxX>igpinfo->DisplayedX)
			    top=((ULONG)pinfo->HorizPot * (igpinfo->MaxX-igpinfo->DisplayedX))/0xffff;
			else top=0;
			if (igpinfo->Left!=top) {
			    igpinfo->Left=top;
			    change=1;
			}
		    }
		    if (change && igpinfo->ScrollFunc)
			(*(igpinfo->ScrollFunc)) (req,prop,igpinfo->Left,igpinfo->Top);
		    if (msg.Class & IDCMP_GADGETUP) goto gadgdone;
		    if (!(msgp=(struct IntuiMessage *)GetMsg(req->Window->UserPort)) ) {
			if (info->Type & GADG_ARROW) goto handlearrow;
			goto handleprop;
		    }
		    msg=*msgp;
		    ReplyMsg (msgp);
		    if (msg.Class & (IDCMP_GADGETUP | IDCMP_GADGETDOWN |
			 IDCMP_MOUSEBUTTONS | IDCMP_REQSET |
			 IDCMP_CLOSEWINDOW | IDCMP_INACTIVEWINDOW)) {
			    PropInProgress=0;
			    ClearIGOServiced (req);
			    goto KeysBegin;
		    } else {
			PropInProgress=1;
			ClearIGOServiced (req);
			goto KeysBegin;
		    }
		}
#endif /* PROPS */

gadgdone:	if (gd && msg.Class & IDCMP_GADGETDOWN) (*gd) (req,&msg);
		if (gu && msg.Class & IDCMP_GADGETUP) (*gu) (req,&msg);
		if (nxtstr) GadgetClick (req,nxtstr);
	    }
	}


KeyPressGUp: ;
	if (msg.Class & IDCMP_RAWKEY) {
	    struct IGKeyCommand *kc;
	    for (kc=req->KeyCommands;kc->Gadget;++kc) {
		if (kc->Command==msg.Code && kc->Qualifier==msg.Qualifier)
		    GadgetClick (req,kc->Gadget);
	    }
	}

	for (el=req->EndList;el->Class!=0xffffffff;++el) {
	    if ( ((el->Class & IDCMP_GADGETUP) && (msg.Class & IDCMP_GADGETUP))
		|| ((el->Class & IDCMP_GADGETDOWN) && (msg.Class & IDCMP_GADGETDOWN)) ) {
		    if (el->Gadget==(struct Gadget *)msg.IAddress) {
			if (el->OKToEnd) if (!(*(el->OKToEnd)) (req,&msg)) break;
			req->Terminate=el->FillStruct ? 1 : -1;
			break;
		    }
	    } else if (el->Class==msg.Class && el->Code==msg.Code
		       && el->Qualifier==msg.Qualifier) {
		    if (el->OKToEnd) if (!(*(el->OKToEnd)) (req,&msg)) break;
		    req->Terminate=el->FillStruct ? 1 : -1;
		    break;
	    }
	}
    }

    if (req->Terminate>0) IGFillStruct ((ULONG)req->DataStruct,req->Gadgets);

    if (req->EndFunction) (*(req->EndFunction)) (req,&msg);

    if (el->Class!=0xffffffff) {
	if (el->Function) (*(el->Function)) (req,&msg);
    } else {
	el->FillStruct=req->Terminate;
    }

    goto done;

error: if (AllocedStuff) FreeRemember (&req->ReqKey,1);
       {
	    struct IGObject *igo;
	    for (igo=req->IGObjects;igo->Next;igo=igo->Next);
	    for (;igo;igo=igo->Prev)
		if (igo->AbortFunction) (*(igo->AbortFunction)) (req,igo,0);
       }
       el=0;

done: ;
    if (OpenedRequester) EndRequest (req->Requester,req->Window);
#ifdef SBOXES
    if (req->SBoxes) {
	struct SelectBox *sb;
	sb=req->SBoxes;
	while (sb) {
	    if (!(sb->IGObject)) sb->TopEdge-=GadgetYOffSet;
	    if (sb->Flags & SB_ADDEDGADGETS) {
		RemoveGList (req->Window,sb->GList,sb->Displayed);
		sb->Flags^=SB_ADDEDGADGETS;
	    }
	    sb->SBoxBorder=0;

	    FreeRemember (&sb->SBKey,1);
	    sb=sb->Next;
	}
    }
#endif SBOXES
    if (OpenedWindow) {
	if (req->Flags & IG_RECORDWINDOWPOS) {
	    req->NewWindow->LeftEdge=req->Window->LeftEdge;
	    req->NewWindow->TopEdge=req->Window->TopEdge;
	    req->NewWindow->Width=req->Window->Width;
	    req->NewWindow->Height=req->Window->Height;
	}
	CloseWindow (req->Window);
	req->NewWindow->Height-=GadgetYOffSet;
	req->Window=0;
    } else {
	RemoveGList(req->Window,req->Gadgets,-1);
	ClearWindow (req->Window);
    }
    if (req->IComPort) {
	while (msgp=GetMsg(req->IComPort))
	    FreeIntuiMsg(msgp);

	DeletePort (req->IComPort);
    }
    if (el && req->IGObjects) {
	struct IGObject *igo;
	for (igo=req->IGObjects;igo->Next;igo=igo->Next);
	for (;igo;igo=igo->Prev)
	    if (igo->RequestEndedFunction) (*(igo->RequestEndedFunction))
		    (req,igo,el);
    }

    if ((req->Flags & IG_ADDGADGETS)) {
	if (GadgetYOffSet) {
	    struct Gadget *gadg;
	    for (gadg=req->Gadgets;gadg;gadg=gadg->NextGadget)
		gadg->TopEdge-=GadgetYOffSet;
	}
    }
    if (req->Borders) {
	if (GadgetYOffSet) {
	    struct Border *bord;
	    for (bord=req->Borders;bord;bord=bord->NextBorder)
		bord->TopEdge-=GadgetYOffSet;
	}
    }
    if (req->Images) {
	if (GadgetYOffSet) {
	    struct Image *image;
	    for (image=req->Images;image;image=image->NextImage)
		image->TopEdge-=GadgetYOffSet;
	}
    }
    if (req->ITexts) {
	if (GadgetYOffSet) {
	    struct IntuiText *it;
	    for (it=req->ITexts;it;it=it->NextText)
		it->TopEdge-=GadgetYOffSet;
	}
    }

    return (el);
}

static struct Gadget GadgTemplate =
{
    0,0,0,0,0,GFLG_GADGHIMAGE,GACT_RELVERIFY,GTYP_BOOLGADGET | GTYP_REQGADGET,
    0,0,0,0,0,0,0
};

BOOL BoolRequest (struct IGRequest *req,UBYTE *string,UBYTE *g1,UBYTE *g2)
{
    struct Remember *key=0;
    struct Requester areq;
    struct Gadget *gadg;
    struct IntuiText *it,*firsttext;
    UBYTE s[200],*c,flag=0;
    USHORT width,i,x,lines,n,t;
    ULONG  oldidcmp;

    if (!(req->Window)) return (1);
    width=req->Window->Width-20;

    it=(struct IntuiText *)AllocRemember (&key,sizeof (struct IntuiText),MEMF_PUBLIC);
    *it=Template;
    firsttext=it;

    i=n=strlen (string);
    while (i*8>width) i/=2;
    strcpy (s,string);
    for (lines=0,x=0;s[x] && !flag;++lines) {
	c=&s[x];
	for (x+=i,t=x; x<n && x && s[x]!=32;--x);
	if (x>=n) {
	    x=n;
	    flag=1;
	}
	if (!x) x=t;
	s[x++]=0;
	it->IText=c;
	it->LeftEdge=5;
	it->TopEdge=lines*10+5;
	if (!flag) {
	    it->NextText=AllocRemember (&key,sizeof(struct IntuiText),MEMF_PUBLIC);
	    it=it->NextText;
	    *it=Template;
	}
    }
    width=(req->Window->Width-(8*i))/2-10;
    IGInitRequester (req->Window,&areq,width,width,RTOF,RBOF);
    areq.Height=(lines+2)*10+7;
    areq.LeftEdge=(req->Window->Width-areq.Width)/2;
    areq.TopEdge=(req->Window->Height-areq.Height)/2;
    areq.ReqBorder=MakeBox (areq.Width-1,areq.Height-1,2,1,&key);
    width=req->Window->Width-2*width;
    areq.ReqGadget=(struct Gadget *)AllocRemember(&key,sizeof(struct Gadget)*2,MEMF_PUBLIC);
    areq.ReqText=firsttext;

    gadg=areq.ReqGadget;

    c=g1;
    while (gadg) {
	*gadg=GadgTemplate;
	gadg->GadgetText=AllocRemember (&key,sizeof (struct IntuiText),MEMF_PUBLIC);
	*(gadg->GadgetText)=Template;
	gadg->GadgetText->IText=c;
	gadg->GadgetText->LeftEdge=10;
	gadg->GadgetText->TopEdge=3;
	gadg->GadgetRender=MakeBox (strlen(c)*8+20,12,2,1,&key);
	gadg->SelectRender=MakeBox (strlen(c)*8+20,12,1,2,&key);
	gadg->TopEdge=lines*10+10;
	gadg->LeftEdge= gadg==areq.ReqGadget ? 4 : width-4-(strlen(c)*8+20);
	gadg->Width=strlen(c)*8+20;
	gadg->Height=12;
	if (g1 && g2) areq.ReqGadget->NextGadget=&areq.ReqGadget[1];
	gadg=gadg->NextGadget;
	c=g2;
    }

    Request (&areq,req->Window);
    i=5;
    oldidcmp=req->Window->IDCMPFlags;
    ModifyIDCMP(req->Window,IDCMP_GADGETUP);

    FOREVER {
	struct IntuiMessage *msg;
	ULONG class;
	WaitPort (req->Window->UserPort);
	msg=(struct IntuiMessage *)GetMsg (req->Window->UserPort);
	class=msg->Class;
	gadg=(struct Gadget *)msg->IAddress;
	ReplyMsg (msg);
	if (gadg==areq.ReqGadget) i=0;
	else if (gadg==areq.ReqGadget->NextGadget) i=1;
	if (i<5) break;
    }
    EndRequest (&areq,req->Window);
    FreeRemember (&key,1);
    ModifyIDCMP(req->Window,oldidcmp);
    return (i);
}

