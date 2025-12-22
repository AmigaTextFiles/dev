/*
IGFR.c

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
#include <intuition/intuition.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <IntuiGen/IntuiGen.h>
#include <IntuiGen/IGSBox.h>
#include <clib/intuition_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>

extern struct DosLibrary *DosBase;
void IGFRQuit ();

#define DEVS 0
#define PARENT 1
#define OK 2
#define CANCEL 3
#define EXT 4
#define FILE 5
#define UP 6
#define DOWN 7
#define SCROLL 8


#define DIR 1
#define DISPLAYED 2
#define SELECTED 4

/* #define INCLUDEARROWDATA */
/*  When linking this to other modules, you will often have arrow data
    already defined.  Also, you can define (globally) UpArrowData and
    DownArrowData as being pointers to the info in chip ram.  You can
    do this either by allocating chip ram and copying the arrow data into
    it or adding the __chip identifier supported by most compilers, as follows:

	__chip USHORT UpArrowData[] = {....}
*/

#ifdef INCLUDEARROWDATA

static USHORT UpArrowData[] = {

	/* BitPlane 0 */

	0x0000,
	0x0004,
	0x0004,
	0x0304,
	0x0784,
	0x0CC4,
	0x1864,
	0x1024,
	0x0004,
	0x0004,
	0xFFFC,

	/* BitPlane 1 */

	0xFFFF,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x0000
};

static USHORT DownArrowData[] = {

	/* BitPlane 0 */

	0x0000,
	0x0004,
	0x0004,
	0x1024,
	0x1864,
	0x0CC4,
	0x0784,
	0x0304,
	0x0004,
	0x0004,
	0xFFFC,

	/* BitPlane 1 */

	0xFFFF,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x8000,
	0x0000
};

#else

extern USHORT *UpArrowData,*DownArrowData;

#endif /* INCLUDEARROWDATA */

static struct TextAttr attr=
{
    "topaz.font",TOPAZ_EIGHTY,NULL,FPF_ROMFONT
};

static struct IntuiText IGFRExtText =
{
	1,0,
	JAM2,
	-42,0,
	&attr,
	(UBYTE *)"Ext:",
	NULL
};

static SHORT IGFRExtValues1[] = {0,11,0,0,50,0};

static SHORT IGFRExtValues2[] = {0,11,50,11,50,0};

static struct Border IGFRExtB2 =
{
	-2,-2,
	2,0,
	JAM1,
	3,
	IGFRExtValues1,
	NULL
};

static struct Border IGFRExtB1 =
{
	-2,-2,
	1,0,
	JAM1,
	3,
	IGFRExtValues2,
	&IGFRExtB2
};

static struct Gadget IGFRExt =
{
	NULL,
	102,109,
	47,10,
	GFLG_GADGHCOMP,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_STRGADGET,
	(APTR)&IGFRExtB1,
	NULL,
	&IGFRExtText,
	NULL,
	NULL,
	0,
	NULL
};

static SHORT IGFRBoxValues1[] = {0,122,0,0,310,0,309,1,1,1,1,121};

static SHORT IGFRBoxValues2[] = {0,122,310,122,310,0,309,1,309,121,1,121};

static struct Border IGFRBoxB2 =
{
	5,13,
	2,0,
	JAM1,
	6,
	IGFRBoxValues1,
	NULL
};

static struct Border IGFRBoxB1 =
{
	5,13,
	1,0,
	JAM1,
	6,
	IGFRBoxValues2,
	&IGFRBoxB2
};

static struct IntuiText IGFRCancelText =
{
	1,0,
	JAM2,
	10,3,
	&attr,
	(UBYTE *)"Cancel",
	NULL
};

static SHORT IGFRCancelValues1[] = {0,12,0,0,68,0,67,1,1,1,1,11};

static SHORT IGFRCancelValues2[] = {0,12,68,12,68,0,67,1,67,11,1,11};

static struct Border IGFRCancelB2 =
{
	0,0,
	2,0,
	JAM1,
	6,
	IGFRCancelValues1,
	NULL
};

static struct Border IGFRCancelB1 =
{
	0,0,
	1,0,
	JAM1,
	6,
	IGFRCancelValues2,
	&IGFRCancelB2
};

static struct Border IGFRCancelSelectedB2 =
{
	0,0,
	1,0,
	JAM1,
	6,
	IGFRCancelValues1,
	NULL
};

static struct Border IGFRCancelSelectedB1 =
{
	0,0,
	2,0,
	JAM1,
	6,
	IGFRCancelValues2,
	&IGFRCancelSelectedB2
};

static struct Gadget IGFRCancel =
{
	&IGFRExt,
	244,121,
	68,12,
	GFLG_GADGHIMAGE,
	GACT_RELVERIFY,
	GTYP_BOOLGADGET,
	(APTR)&IGFRCancelB1,
	(APTR)&IGFRCancelSelectedB1,
	&IGFRCancelText,
	NULL,
	NULL,
	853,
	NULL
};

static struct IntuiText IGFROKText =
{
	1,0,
	JAM2,
	10,3,
	&attr,
	(UBYTE *)"OK",
	NULL
};

static SHORT IGFROKValues1[] = {0,12,0,0,36,0,35,1,1,1,1,11};

static SHORT IGFROKValues2[] = {0,12,36,12,36,0,35,1,35,11,1,11};

static struct Border IGFROKB2 =
{
	0,0,
	2,0,
	JAM1,
	6,
	IGFROKValues1,
	NULL
};

static struct Border IGFROKB1 =
{
	0,0,
	1,0,
	JAM1,
	6,
	IGFROKValues2,
	&IGFROKB2
};

static struct Border IGFROKSelectedB2 =
{
	0,0,
	1,0,
	JAM1,
	6,
	IGFROKValues1,
	NULL
};

static struct Border IGFROKSelectedB1 =
{
	0,0,
	2,0,
	JAM1,
	6,
	IGFROKValues2,
	&IGFROKSelectedB2
};

static struct Gadget IGFROK =
{
	&IGFRCancel,
	207,121,
	36,12,
	GFLG_GADGHIMAGE,
	GACT_RELVERIFY,
	GTYP_BOOLGADGET,
	(APTR)&IGFROKB1,
	(APTR)&IGFROKSelectedB1,
	&IGFROKText,
	NULL,
	NULL,
	852,
	NULL
};

static struct IntuiText IGFRParentText =
{
	1,0,
	JAM2,
	10,3,
	&attr,
	(UBYTE *)"Parent",
	NULL
};

static struct Gadget IGFRParent =
{
	&IGFROK,
	234,107,
	68,12,
	GFLG_GADGHIMAGE,
	GACT_RELVERIFY,
	GTYP_BOOLGADGET,
	(APTR)&IGFRCancelB1,
	(APTR)&IGFRCancelSelectedB1,
	&IGFRParentText,
	NULL,
	NULL,
	851,
	NULL
};

static struct IntuiText IGFRDevsText =
{
	1,0,
	JAM2,
	10,3,
	&attr,
	(UBYTE *)"Devices",
	NULL
};

static SHORT IGFRDevsValues1[] = {0,12,0,0,76,0,75,1,1,1,1,11};

static SHORT IGFRDevsValues2[] = {0,12,76,12,76,0,75,1,75,11,1,11};

static struct Border IGFRDevsB2 =
{
	0,0,
	2,0,
	JAM1,
	6,
	IGFRDevsValues1,
	NULL
};

static struct Border IGFRDevsB1 =
{
	0,0,
	1,0,
	JAM1,
	6,
	IGFRDevsValues2,
	&IGFRDevsB2
};

static struct Border IGFRDevsSelectedB2 =
{
	0,0,
	1,0,
	JAM1,
	6,
	IGFRDevsValues1,
	NULL
};

static struct Border IGFRDevsSelectedB1 =
{
	0,0,
	2,0,
	JAM1,
	6,
	IGFRDevsValues2,
	&IGFRDevsSelectedB2
};

static struct Gadget IGFRDevs =
{
	&IGFRParent,
	157,107,
	76,12,
	GFLG_GADGHIMAGE,
	GACT_RELVERIFY,
	GTYP_BOOLGADGET,
	(APTR)&IGFRDevsB1,
	(APTR)&IGFRDevsSelectedB1,
	&IGFRDevsText,
	NULL,
	NULL,
	850,
	NULL
};

static struct IntuiText IGFRFNameText =
{
	1,0,
	JAM2,
	-50,0,
	&attr,
	(UBYTE *)"File:",
	NULL
};

static SHORT IGFRFNameValues1[] = {0,11,0,0,250,0};

static SHORT IGFRFNameValues2[] = {0,11,250,11,250,0};

static struct Border IGFRFNameB2 =
{
	-2,-2,
	2,0,
	JAM1,
	3,
	IGFRFNameValues1,
	NULL
};

static struct Border IGFRFNameB1 =
{
	-2,-2,
	1,0,
	JAM1,
	3,
	IGFRFNameValues2,
	&IGFRFNameB2
};

static struct Gadget IGFRFName =
{
	&IGFRDevs,
	60,96,
	247,10,
	GFLG_GADGHCOMP,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_STRGADGET,
	(APTR)&IGFRFNameB1,
	NULL,
	&IGFRFNameText,
	NULL,
	NULL,
	810,
	NULL
};

static struct Image IGFRScrollDownArrowImage =
{
	0,0,
	14,11,
	2,
	DownArrowData,
	3,0,
	NULL
};

static struct Gadget IGFRScrollDownArrowGad =
{
	&IGFRFName,
	295,82,
	14,11,
	GFLG_GADGHCOMP | GFLG_GADGIMAGE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_BOOLGADGET,
	(APTR)&IGFRScrollDownArrowImage,
	NULL,
	NULL,
	NULL,
	NULL,
	802,
	NULL
};

static struct Image IGFRScrollUpArrowImage =
{
	0,0,
	14,11,
	2,
	UpArrowData,
	3,0,
	NULL
};

static struct Gadget IGFRScrollUpArrowGad =
{
	&IGFRScrollDownArrowGad,
	295,70,
	14,11,
	GFLG_GADGHCOMP | GFLG_GADGIMAGE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_BOOLGADGET,
	(APTR)&IGFRScrollUpArrowImage,
	NULL,
	NULL,
	NULL,
	NULL,
	801,
	NULL
};

static WORD IGFRScrollKnobBuffer[4];

static struct PropInfo IGFRScrollPropInfo =
{
	AUTOKNOB | FREEVERT,0,0,0x0800,0x0800,0,0,0,0,0,0
};

static struct Gadget IGFRScroll =
{
	&IGFRScrollUpArrowGad,
	295,17,
	14,52,
	GFLG_GADGHNONE,
	GACT_RELVERIFY | GACT_IMMEDIATE,
	GTYP_PROPGADGET,
	(APTR)IGFRScrollKnobBuffer,
	NULL,
	NULL,
	NULL,
	(APTR)&IGFRScrollPropInfo,
	800,
	NULL
};

static struct IGDirEntry *DupEntry (struct IGDirEntry *entry)
{
    struct IGDirEntry *dup;
    UBYTE *fname;

    dup=AllocMem(sizeof(struct IGDirEntry)+
	strlen(entry->FileName)+1,MEMF_PUBLIC);
    if (!dup) return (0);
    *dup=*entry;

    fname=(UBYTE *)dup;
    fname+=sizeof(struct IGDirEntry);

    strcpy (fname,entry->FileName);
    dup->FileName=fname;

    return (dup);
}

struct IGDirEntry *DupDirList(struct IGFileRequest *fr,ULONG flags)
{
    struct IGDirEntry *first=0,*current,*de;
    ULONG copyde;

    for (de=fr->First;de;de=de->Next) {
	copyde=1;
	if ( (de->Flags & IGDE_DISPLAYED) && (flags & IGDE_NOTDISPLAYED) )
	    copyde=0;
	if ( (de->Flags & IGDE_SELECTED) && (flags & IGDE_NOTSELECTED) )
	    copyde=0;
	if ( !(de->Flags & IGDE_SELECTED) && (flags & IGDE_SELECTED) )
	    copyde=0;
	if ( !(de->Flags & IGDE_DISPLAYED) && (flags & IGDE_DISPLAYED) )
	    copyde=0;
	if ( !(de->Flags & IGDE_DIR) && (flags & IGDE_DIRSONLY) )
	    copyde=0;
	if ( (de->Flags & IGDE_DIR) && (flags & IGDE_FILESONLY) )
	    copyde=0;

	if (copyde) {
	    if (first) {
		current->Next=DupEntry(de);
		if (!(current->Next)) break;
		current->Next->Prev=current;
		current=current->Next;
		current->Next=0;
	    } else {
		current=first=DupEntry(de);
		if (!first) break;
		first->Prev=first->Next=0;
	    }
	}
    }
    return (first);
}

void FreeDirList(struct IGDirEntry *de)
{
    struct IGDirEntry *next;

    while (de) {
	next=de->Next;
	FreeMem(de,sizeof(struct IGDirEntry) +
	    strlen(de->FileName) + 1);
	de=next;
    }
}

void FixFile (struct IGRequest *req,struct IGFileRequest *fr)
{
    USHORT i;
    struct StringInfo *info;

    info=(struct StringInfo *)fr->Gadgets[FILE].SpecialInfo;

    i=strlen (fr->FileName);
    if (i>30) info->DispPos=i-30;
    else info->DispPos=0;
    info->BufferPos=i;
    RefreshGList (&fr->Gadgets[FILE],req->Window,0,1);
}

void GetFileName (UBYTE *pathfile,UBYTE *file)
{
    USHORT i;
    i=strlen(pathfile);
    while (i && pathfile[i]!=':' && pathfile[i]!='/') --i;
    if (pathfile[i]==':' || pathfile[i]=='/') ++i;
    strcpy (file,&pathfile[i]);
}


void FixDirNameEnding (UBYTE *dirname)
{
    USHORT i;

    i=strlen(dirname)-1;
    if (dirname[i]!='/' && dirname[i]!=':') {
	dirname[++i]='/';
	dirname[++i]=0;
    }
}

void ChopLevel (UBYTE *FileName)
{
    USHORT i;

    i=strlen(FileName);
    if (FileName[--i]==':') FileName[i]=0;
    while (FileName[i]!='/' && FileName[i]!=':' && i) --i;
    if (FileName[i]==':') ++i;
    FileName[i]=0;
}

void GetFRDirName (UBYTE *pathfile,UBYTE *file, struct IGFileRequest *fr)
{
    strcpy (file,pathfile);
    if (fr->Flags & IGFR_FILENAMEPRESENT) ChopLevel(file);
}

void UpDirectory (struct IGRequest *req,struct IGFileRequest *fr)
{
    ChopLevel (fr->FileName);
    FixFile (req,fr);
}

struct MsgPort *CreatePort ();

static VOID ShowDevices(struct IGRequest *req,struct IGFileRequest *fr)
{
    struct DosInfo *dosinfo;
    struct DeviceList *masterlist, *devlist, *worklist;
    struct MsgPort *handler;
    LONG temp;
    UBYTE *nameptr, *text;
    UBYTE len;
    SHORT i;
    struct SelectBoxEntry *entry;

    if (DosBase == NULL) return ();

    ClearSBox (fr->SBox,0);
    RefreshSBox (req,fr->SBox);

    fr->First=fr->DCEntry=0;

    fr->FileName[0]=0;
    FixFile (req,fr);

    if (fr->Flags & IGFR_READING) {
	fr->Flags^=IGFR_READING;
	if (req->CallLoop & (1<<fr->CLBit)) req->CallLoop^=1<<fr->CLBit;
    }
    if (fr->Flags & IGFR_FILENAMEPRESENT)
	fr->Flags^=IGFR_FILENAMEPRESENT;

    temp = (LONG)((struct RootNode *)DosBase->dl_Root)->rn_Info;
    dosinfo = (struct DosInfo *)(temp << 2);        /* reality pointer */
    temp = (LONG)dosinfo->di_DevInfo;
    masterlist = (struct DeviceList *)(temp << 2);  /* reality pointer */

    devlist = masterlist;


    while (devlist)
    {
	if (devlist->dl_Type==DLT_VOLUME || (devlist->dl_Type==DLT_DIRECTORY && fr->Flags & IGFR_INCLUDEASSIGNS)) {

	    nameptr = (UBYTE *)devlist->dl_Name;

FoundName:  temp = (LONG)nameptr;
	    nameptr = (UBYTE *)(temp << 2);
	    len=*nameptr++;
	    if (!len) goto NextDevice;
	    text=AllocRemember (&fr->DirKey,len+2,MEMF_PUBLIC);
	    for (i=0;i<len;++i) text[i]=*nameptr++;
	    text[i++]=':';
	    text[i]=0;
	    entry=AllocRemember (&fr->DirKey,sizeof (struct SelectBoxEntry),MEMF_PUBLIC | MEMF_CLEAR);
	    entry->Text=text;
	    entry->Color=1;
	    AddSBEntryAlpha (fr->SBox,entry);
	}

NextDevice: ;
	temp = devlist->dl_Next;
	devlist = (struct DeviceList *)(temp << 2);
    }
    RefreshSBox (req,fr->SBox);
}

void ShowDir (struct IGRequest *req,struct IGFileRequest *fr)
{
    ClearSBox (fr->SBox,0);
    RefreshSBox (req,fr->SBox);

    if (fr->Flags & IGFR_FILENAMEPRESENT) {
	UpDirectory (req,fr);
	fr->Flags^=IGFR_FILENAMEPRESENT;
    }
    if (fr->Flags & IGFR_READING) {
	fr->Flags^=IGFR_READING;
	if (req->CallLoop & (1<<fr->CLBit)) req->CallLoop^=1<<fr->CLBit;
	UnLock (fr->Lock);
	FreeMem (fr->FInfo,sizeof(struct FileInfoBlock));
	fr->Lock=(BPTR)fr->FInfo=0;
    }
    if (!(fr->FileName[0])) goto devs;

    fr->FInfo=(struct FileInfoBlock *)AllocMem
	(sizeof(struct FileInfoBlock),MEMF_PUBLIC | MEMF_CLEAR);
    if (!(fr->FInfo)) goto devs;

    fr->Lock=Lock (fr->FileName,ACCESS_READ);

handlelock: ;
    if (!(fr->Lock)) {
	FreeMem (fr->FInfo,sizeof(struct FileInfoBlock));
	fr->FInfo=0;
	goto devs;
    }

    Examine (fr->Lock,fr->FInfo);
    if (fr->FInfo->fib_DirEntryType<0) {
	UBYTE FName[200];
	UnLock (fr->Lock);
	if (fr->Flags & IGFR_MULTISELECT) {
	    ChopLevel (fr->FileName);
	    fr->Lock=Lock (fr->FileName,ACCESS_READ);
	    goto handlelock;
	}
	strcpy (FName,fr->FileName);
	ChopLevel (FName);
	fr->Lock=Lock (FName,ACCESS_READ);
	goto handlelock;
    } else {
	fr->First=fr->DCEntry=0;
	fr->Flags|=IGFR_READING | IGFR_FREEDIRKEY;
	req->CallLoop|=1<<fr->CLBit;
    }
    return ();
devs: ;
    ShowDevices (req,fr);
}

void SetDirectory (struct IGRequest *req,struct IGFileRequest *fr,UBYTE *dir)
{
    if (dir[0] && strcmp(fr->FileName,dir)) {
	strcpy (fr->FileName,dir);
	FLAGOFF(fr->Flags,IGFR_FILENAMEPRESENT);
	FixFile (req,fr);
	ShowDir (req,fr);
    }
}

static void FRLoop (struct IGRequest *);
void ClearIGOServiced (struct IGRequest *);

BOOL SelectFile (struct IGRequest *req,struct IGFileRequest *fr,UBYTE *file)
{
    struct IGDirEntry *de;

    if (fr->Flags & IGFR_MULTISELECT) {
	while (req->CallLoop & 1<<fr->CLBit) {
	    ClearIGOServiced (req);
	    FRLoop (req);
	}
	de=fr->First;
	while (de && strcmp(de->FileName,file)) de=de->Next;
	if (de && !(de->Flags & DIR) && !(de->Flags & SELECTED)) {
	    de->Flags|=SELECTED;
	    de->SBE->Flags|=SB_SELECTED;
	    RefreshSBox(req,fr->SBox);
	} else return (1);
    } else if (!(fr->Flags & IGFR_NOFILESELECT)) {
	if (fr->Flags & IGFR_FILENAMEPRESENT)
	    UpDirectory (req,fr);
	FixDirNameEnding (fr->FileName);
	strcat (fr->FileName,file);
	FixFile (req,fr);
	fr->Flags|=IGFR_FILENAMEPRESENT;
    }
    return (0);
}

void IGFRSelectAll (struct IGRequest *req, struct IGFileRequest *fr)
{
    struct IGDirEntry *de;

    if (fr->Flags & IGFR_MULTISELECT) {
	while (req->CallLoop & 1<<fr->CLBit) {
	    ClearIGOServiced(req);
	    FRLoop (req);
	}
	for (de=fr->First;de;de=de->Next) {
	    if (!(de->Flags & SELECTED)) {
		de->Flags|=SELECTED;
		de->SBE->Flags|=SB_SELECTED;
	    }
	}
	RefreshSBox(req,fr->SBox);
    }
}

void IGFRDeSelectAll (struct IGRequest *req, struct IGFileRequest *fr)
{
    struct IGDirEntry *de;

    if (fr->Flags & IGFR_MULTISELECT) {
	while(req->CallLoop & 1<<fr->CLBit) {
	    ClearIGOServiced(req);
	    FRLoop(req);
	}
	for (de=fr->First;de;de=de->Next) {
	    if (de->Flags & SELECTED) {
		de->Flags^=SELECTED;
		de->SBE->Flags^=SB_SELECTED;
	    }
	}
	RefreshSBox(req,fr->SBox);
    } else if (fr->Flags & IGFR_FILENAMEPRESENT) UpDirectory(req,fr);
}

BOOL SetPathFile (struct IGRequest *req,struct IGFileRequest *fr,UBYTE *path)
{
    BPTR lock;
    struct FileInfoBlock fib;
    UBYTE DirName[200];
    UBYTE FName[50];

    lock=Lock(path,ACCESS_READ);
    if (!lock) return (1);
    Examine (lock,&fib);
    UnLock (lock);

    strcpy (DirName,path);
    if (fib.fib_DirEntryType<0) {
	ChopLevel (DirName);
	GetFileName (path,FName);
    } else FName[0]=0;

    if (DirName[0]) SetDirectory (req,fr,DirName);
    if (FName[0])
	if (SelectFile (req,fr,FName)) return (1);;
    return (0);
}

static void Devices (struct IGRequest *req,struct IntuiMessage *msg)
{
    struct Gadget *gadg;
    struct IGBoolInfo *iginfo;
    struct IGFileRequest *fr;

    gadg=(struct Gadget *)msg->IAddress;
    iginfo=(struct IGBoolInfo *)gadg->UserData;
    fr=(struct IGFileRequest *)iginfo->IGObject->Address;
    ShowDevices (req,fr);
}

static void ParentDirectory (struct IGRequest *req,struct IntuiMessage *msg)
{
    struct Gadget *gadg;
    struct IGBoolInfo *iginfo;
    struct IGFileRequest *fr;

    gadg=(struct Gadget *)msg->IAddress;
    iginfo=(struct IGBoolInfo *)gadg->UserData;
    fr=iginfo->IGObject->Address;
    UpDirectory (req,fr);
    ShowDir (req,fr);
}

static BOOL MatchExtension (UBYTE *name,UBYTE *ext)
{
    USHORT l,p;

    p=strlen (name);
    l=strlen (ext);
    p-=l;
    if (!stricmp (&name[p],ext)) return (1);
    return (0);
}

static void NewExtReal (struct IGRequest *req,struct IGFileRequest *fr);

static void FRLoop (struct IGRequest *req)
{
    struct IGObject *obj;
    struct IGFileRequest *fr;
    struct IGPropInfo *pinfo;
    struct Gadget *prop;
    struct IGSBoxGadgetInfo *ginfo;
    char *s;
    USHORT i,x;

    for (obj=req->IGObjects;obj->Next;obj=obj->Next);

    while (obj->Serviced || strcmp (obj->Class,"IGFileRequest")) obj=obj->Prev;

    obj->Serviced=1;

    fr=(struct IGFileRequest *)obj->Address;
    prop=&fr->Gadgets[SCROLL];
    pinfo=(struct IGPropInfo *)prop->UserData;
    ginfo=(struct IGSBoxGadgetInfo *)fr->SBox->GList->UserData;

    if (fr->Flags & IGFR_FREEDIRKEY) {
	fr->Flags^=IGFR_FREEDIRKEY;
	FreeRemember (&fr->DirKey,1);
	fr->Number=0;
    }
    if (fr->Flags & IGFR_INIT) {
	fr->Flags^=IGFR_INIT;
	req->CallLoop^=1<<fr->CLBit;
	if (fr->FileName[0]) {
	    if (fr->Flags & IGFR_VARSSAVED) {
		fr->Flags^=IGFR_VARSSAVED;
		NewExtReal (req,fr);
		if (fr->Flags & IGFR_READING) req->CallLoop|=1<<fr->CLBit;
	    } else {
		ShowDir (req,fr);
	    }
	} else ShowDevices (req,fr);
    } else if (fr->Flags & IGFR_READING) {
	if (!ExNext (fr->Lock,fr->FInfo)) {
	    FreeMem (fr->FInfo,sizeof (struct FileInfoBlock));
	    fr->FInfo=0;
	    UnLock (fr->Lock);
	    fr->Lock=0;
	    fr->Flags^=IGFR_READING;
	    req->CallLoop^=1<<fr->CLBit;
	    RefreshSBox (req,fr->SBox);
	} else {
	    UBYTE  infoflag=0;
	    struct SelectBoxEntry *item;
	    struct IGDirEntry *de,*ix;

	    ++fr->Number;
	    de=(struct IGDirEntry *)AllocRemember (&fr->DirKey,
		sizeof (struct IGDirEntry),MEMF_PUBLIC);
	    de->FileName=(UBYTE *)AllocRemember(&fr->DirKey,
		strlen(fr->FInfo->fib_FileName)+1,MEMF_PUBLIC);
	    item=de->SBE=(struct SelectBoxEntry *)AllocRemember (&fr->DirKey,
		sizeof(struct SelectBoxEntry),MEMF_PUBLIC | MEMF_CLEAR);
	    s=(UBYTE *)AllocRemember (&fr->DirKey,
		strlen(fr->FInfo->fib_FileName)+8,MEMF_PUBLIC);
	    strcpy (de->FileName,fr->FInfo->fib_FileName);
	    strcpy (s,de->FileName);

	    item->Text=s;
	    item->IGObject=obj;
	    item->UserData=(APTR)de;
	    item->Color=1;

	    de->Flags=0;

	    if (fr->FInfo->fib_DirEntryType>0) {
		strcat (s," (DIR)");
		de->Flags=DIR | DISPLAYED;

		ix=fr->First;
		if (!ix) {
		    de->Next=de->Prev=0;
		} else {
		    if (!(ix->Flags & DIR)) {
			de->Next=ix;
			de->Prev=0;
			ix->Prev=de;
		    } else {
			while (ix->Next && stricmp(ix->FileName,de->FileName)<0 && ix->Flags & DIR)
			    ix=ix->Next;
			if (!(ix->Next) && stricmp (ix->FileName,de->FileName)<0 && ix->Flags & DIR) {
			    ix->Next=de;
			    de->Prev=ix;
			    de->Next=0;
			} else {
			    de->Next=ix;
			    de->Prev=ix->Prev;
			    if (ix->Prev) ix->Prev->Next=de;
			    ix->Prev=de;
			}
		    }
		}
		if (!(de->Prev)) fr->First=de;
		if (de->Prev) AddSBEntry (fr->SBox,de->SBE,de->Prev->SBE->ID+2);
		else AddSBEntry (fr->SBox,de->SBE,1);
		ModifyIGProp (req,prop,0,fr->Number,0,7,pinfo->Top,0);
		ginfo->Entry=de->SBE;
	    } else {
		if (fr->Flags & IGFR_NOFILESELECT) item->Color=2;
		ix=fr->First;
		if (!ix) {
		    de->Next=de->Prev=0;
		} else {
		    while (ix->Next && ix->Flags & DIR) ix=ix->Next;
		    if (!(ix->Next) && ix->Flags & DIR) {
			ix->Next=de;
			de->Prev=ix;
			de->Next=0;
		    } else {
			while (ix->Next && stricmp(ix->FileName,de->FileName)<0)
			    ix=ix->Next;
			if (!(ix->Next) && stricmp(ix->FileName,de->FileName)<0) {
			    ix->Next=de;
			    de->Prev=ix;
			    de->Next=0;
			} else {
			    de->Next=ix;
			    de->Prev=ix->Prev;
			    if (ix->Prev) ix->Prev->Next=de;
			    ix->Prev=de;
			}
		    }
		}
		if (!(de->Prev)) fr->First=de;

		if ((fr->Flags & IGFR_NOINFO) &&
		  MatchExtension (de->FileName,".info"))
		    infoflag=1;
		if (!infoflag && MatchExtension (de->FileName,fr->Extension)) {
		    de->Flags=DISPLAYED;
		    ix=de->Prev;
		    while (ix && !(ix->Flags & DISPLAYED)) ix=ix->Prev;
		    if (!ix) AddSBEntry (fr->SBox,de->SBE,1);
		    else AddSBEntry (fr->SBox,de->SBE,ix->SBE->ID+2);
		    ModifyIGProp (req,prop,0,fr->Number,0,7,pinfo->Top,0);
		    ginfo->Entry=de->SBE;
		}
	    }
	}
    }
    if (fr->LoopFunction) (*(fr->LoopFunction)) (req);
}


static void NewExtReal (struct IGRequest *req,struct IGFileRequest *fr)
{
    struct IGDirEntry *de;
    USHORT i;

    ClearSBox (fr->SBox,0);
    RefreshSBox (req,fr->SBox);
    fr->DCEntry=0;

    for (i=1,de=fr->First;de;de=de->Next) {
	if (de->Flags & DISPLAYED) de->Flags^=DISPLAYED;
	if (de->Flags & DIR) {
	    AddSBEntry (fr->SBox,de->SBE,i++);
	    de->Flags|=DISPLAYED;
	} else if (MatchExtension (de->FileName,fr->Extension)) {
	    AddSBEntry (fr->SBox,de->SBE,i++);
	    de->Flags|=DISPLAYED;
	}
    }
    RefreshSBox (req,fr->SBox);
}

static void NewExt (struct IGReqeust *req,struct IntuiMessage *msg)
{
    struct Gadget *gadg;
    struct IGStringInfo *iginfo;
    struct IGFileRequest *fr;

    gadg=(struct Gadget *)msg->IAddress;
    iginfo=(struct IGStringInfo *)gadg->UserData;
    fr=(struct IGFileRequest *)iginfo->IGObject->Address;

    NewExtReal (req,fr);
}

static void TypedDir (struct IGRequest *req,struct IntuiMessage *msg)
{
    struct Gadget *gadg;
    struct IGStringInfo *iginfo;
    struct IGFileRequest *fr;

    gadg=(struct Gadget *)msg->IAddress;
    iginfo=(struct IGBoolInfo *)gadg->UserData;
    fr=(struct IGFileRequest *)iginfo->IGObject->Address;

    ShowDir (req,fr);
}

static void HandleSelection (struct IGRequest *req,
		      struct SelectBox *sbox,
		      struct SelectBoxEntry *entry,
		      struct IntuiMessage *msg)
{
    struct IGDirEntry *de;
    struct IGFileRequest *fr;
    USHORT i;
    UBYTE dcf=0;

    fr=(struct IGFileRequest *)sbox->IGObject->Address;
    de=(struct IGDirEntry *)entry->UserData;

    if (fr->DCEntry==de)
	if (DoubleClick (fr->DCSecs,fr->DCMics,msg->Seconds,msg->Micros))
	    dcf=1;
    if (!dcf) {
	fr->DCEntry=de;
	fr->DCSecs=msg->Seconds;
	fr->DCMics=msg->Micros;
    }

    if (!de) {
	strcpy (fr->FileName,entry->Text);
	FixFile (req,fr);
	ShowDir (req,fr);
    } else if (de->Flags & DIR) {
	if (!(fr->Flags & IGFR_MULTISELECT) || dcf) {
	    if (fr->Flags & IGFR_FILENAMEPRESENT) {
		UpDirectory (req,fr);
		fr->Flags^=IGFR_FILENAMEPRESENT;
	    }
	    FixDirNameEnding (fr->FileName);
	    strcat (fr->FileName,de->FileName);
	    FixFile (req,fr);
	    ShowDir (req,fr);
	} else de->Flags^=SELECTED;
    } else {
	if (!(fr->Flags & IGFR_NOFILESELECT)) {
	    if (fr->Flags & IGFR_MULTISELECT)
		de->Flags^=SELECTED;
	    else {
		if (dcf) {
		    msg->IAddress=&fr->Gadgets[OK];
		    IGFRQuit (req,msg);
		    return ();
		}
		if (fr->Flags & IGFR_FILENAMEPRESENT) UpDirectory (req,fr);
		i=strlen (fr->FileName)-1;
		if (!(fr->FileName[i]=='/' || fr->FileName[i]==':')) {
		    fr->FileName[++i]='/';
		    fr->FileName[++i]=0;
		}
		strcat (fr->FileName,de->FileName);
		fr->Flags|=IGFR_FILENAMEPRESENT;
		FixFile (req,fr);
	    }
	}
    }
}

static void DiskChanged (struct IGRequest *req,struct IntuiMessage *msg)
{
    struct IGFileRequest *fr;
    struct IGObject *obj;

    for (obj=req->IGObjects;obj->Next;obj=obj->Next);
    while (obj->Serviced || strcmp (obj->Class,"IGFileRequest")) obj=obj->Prev;

    obj->Serviced=1;
    fr=(struct IGFileRequest *)obj->Address;
    if (!(fr->FileName[0])) ShowDevices (req,fr);
    if (msg->Class & IDCMP_DISKINSERTED) {
	if(fr->DInserted) (*(fr->DInserted)) (req,msg);
    } else if (fr->DRemoved) (*(fr->DRemoved)) (req,msg);
}

static void IGFRQuit (struct IGRequest *req,struct IntuiMessage *msg)
{
    struct Gadget *gadg;
    struct IGBoolInfo *info;
    struct IGFileRequest *fr;

    gadg=(struct Gadget *)msg->IAddress;
    info=(struct IGBoolInfo *)gadg->UserData;
    fr=(struct IGFileRequest *)info->IGObject->Address;

    if (gadg==&fr->Gadgets[OK]) req->Terminate=1;
    else req->Terminate=-1;
}

static void KillIGFileRequest (struct IGRequest *req,struct IGObject *obj,APTR ignore)
{
    USHORT i;
    struct IGFileRequest *fr;
    struct SelectBoxEntry *e,*nxt;

    fr=(struct IGFileRequest *)obj->Address;

    if (!(fr->Flags & IGFR_MULTISELECT)) {
	FreeRemember (&fr->DirKey,1);
	fr->First=0;
    }

    fr->DCEntry=0;
    if (fr->Lock) UnLock (fr->Lock);
    if (fr->FInfo) FreeMem (fr->FInfo,sizeof (struct FileInfoBlock));
    fr->Lock=fr->FInfo=0;

    if (fr->Gadgets)
	for (i=0;i<9;++i) {
	    if ((i==OK || i==CANCEL) && !(fr->Flags & IGFR_OKCANCEL)) continue;
	    IGRemoveGadget (req,&fr->Gadgets[i]);
    }
    if (fr->Borders) {
	IGRemoveBorder (req,fr->Borders->NextBorder);
	IGRemoveBorder (req,fr->Borders);
    }
    if (fr->SBox) IGRemoveSBox (req,fr->SBox);
    FreeRemember (&fr->Key,1);
    if ( req->CallLoop & (1<<fr->CLBit) ) req->CallLoop ^= 1 << fr->CLBit;
    FreeCLBit (req,fr->CLBit);
    fr->TopEdge-=obj->GadgetYOffSet;
    req->LoopFunction=fr->LoopFunction;
    req->DiskRemoved=fr->DRemoved;
    req->DiskInserted=fr->DInserted;
}

BOOL MakeIGFileRequest (struct IGRequest *req,struct IGObject *obj)
{
    struct IGFileRequest *fr;
    USHORT i;

    fr=(struct IGFileRequest *)obj->Address;
    if (!fr) goto error;
    fr->TopEdge+=obj->GadgetYOffSet;

    fr->Gadgets=fr->SBox=fr->Borders=0;
    fr->Flags &= (1 | 4 | 16 | 64 | 128 | 256 | 512 | 1024);
    obj->Class=(UBYTE *)"IGFileRequest";
    fr->Flags|=IGFR_INIT;
    fr->CLBit=AllocCLBit (req);
    if (fr->CLBit==-1) goto error;

    req->CallLoop|=1<<fr->CLBit;

     /* These are first so that we know */
     /* Even on error, that they have */
     /* Been Changed. */

    fr->LoopFunction=req->LoopFunction;
    req->LoopFunction=FRLoop;
    fr->DInserted=req->DiskInserted;
    fr->DRemoved=req->DiskRemoved;
    req->DiskInserted=req->DiskRemoved=DiskChanged;

    obj->AbortFunction=obj->RequestEndedFunction=KillIGFileRequest;

    fr->Gadgets=AllocRemember (&fr->Key,sizeof (struct Gadget)*9,MEMF_PUBLIC);
    fr->SBox=AllocRemember (&fr->Key,sizeof (struct SelectBox),MEMF_PUBLIC |
	MEMF_CLEAR);
    fr->Borders=AllocRemember (&fr->Key,sizeof (struct Border)*2,MEMF_PUBLIC);

    if (!(fr->Gadgets) || !(fr->SBox) || !(fr->Borders)) goto error;


    fr->Borders[0]=IGFRBoxB1;
    fr->Borders[1]=IGFRBoxB2;
    fr->Borders[0].NextBorder=&fr->Borders[1];
    fr->Borders[0].FrontPen=fr->BColor2;
    fr->Borders[1].FrontPen=fr->BColor1;
    fr->Borders[0].LeftEdge=fr->Borders[1].LeftEdge+=fr->LeftEdge-5;
    fr->Borders[0].TopEdge=fr->Borders[1].TopEdge+=fr->TopEdge-12;
    fr->Borders[1].NextBorder=req->Borders;
    req->Borders=fr->Borders;

    fr->SBox->LeftEdge=4+fr->LeftEdge;
    fr->SBox->TopEdge=4+fr->TopEdge;
    fr->SBox->Width=284;
    fr->SBox->Displayed=7;
    fr->SBox->BColor1=fr->BColor1;
    fr->SBox->BColor2=fr->BColor2;
    fr->SBox->Prop=&fr->Gadgets[SCROLL];
    fr->SBox->ItemSelected=fr->SBox->ItemDSelected=HandleSelection;
    fr->SBox->Flags=fr->Flags & IGFR_MULTISELECT ? SB_TOGGLEALL : SB_RELVERIFY;
    fr->SBox->IGObject=obj;
    fr->SBox->Next=req->SBoxes;
    req->SBoxes=fr->SBox;

    fr->Gadgets[DEVS]=IGFRDevs;
    fr->Gadgets[PARENT]=IGFRParent;
    fr->Gadgets[OK]=IGFROK;
    fr->Gadgets[CANCEL]=IGFRCancel;
    fr->Gadgets[EXT]=IGFRExt;
    fr->Gadgets[FILE]=IGFRFName;

    fr->Gadgets[UP]=IGFRScrollUpArrowGad;
    fr->Gadgets[DOWN]=IGFRScrollDownArrowGad;
    IGFRScrollDownArrowImage.ImageData = DownArrowData;
    IGFRScrollUpArrowImage.ImageData = UpArrowData;

    fr->Gadgets[SCROLL]=IGFRScroll;

    for (i=0;i<4;++i) {
	struct IGBoolInfo *info;
	info=(struct IGBoolInfo *)fr->Gadgets[i].UserData=AllocRemember
	    (&fr->Key,sizeof (struct IGBoolInfo),MEMF_PUBLIC | MEMF_CLEAR);
	if (!info) goto error;
	info->Type=GADG_BOOL;
	info->IGObject=obj;
	switch (i) {
	    case DEVS:	    info->GUpFunction=Devices;
			    break;
	    case PARENT:    info->GUpFunction=ParentDirectory;
			    break;
	    case OK:	    info->GUpFunction=IGFRQuit;
			    break;
	    case CANCEL:    info->GUpFunction=IGFRQuit;
			    break;
	}
    }

    for (i=4;i<6;++i) {
	struct IGStringInfo *info;
	struct StringInfo *sinfo;

	info=(struct IGStringInfo *)fr->Gadgets[i].UserData=AllocRemember
	    (&fr->Key,sizeof (struct IGStringInfo),MEMF_PUBLIC | MEMF_CLEAR);
	sinfo=(struct StringInfo *)fr->Gadgets[i].SpecialInfo=AllocRemember
	    (&fr->Key,sizeof (struct StringInfo),MEMF_PUBLIC | MEMF_CLEAR);
	if (!info || !sinfo) goto error;
	info->Type=GADG_STRING;
	info->IGObject=obj;
	if (i==EXT) {
	    info->DisAllowedChars="/:";
	    sinfo->MaxChars=10;
	    sinfo->Buffer=fr->Extension;
	    info->DSelectFunction=NewExt;
	} else {
	    sinfo->MaxChars=200;
	    sinfo->Buffer=fr->FileName;
	    info->DSelectFunction=TypedDir;
	}
    }

    {
	struct PropInfo *info;
	struct IGPropInfo *iginfo;

	info=AllocRemember
	    (&fr->Key,sizeof (struct PropInfo),MEMF_PUBLIC);
	fr->Gadgets[SCROLL].GadgetRender=AllocRemember (&fr->Key,8,MEMF_PUBLIC | MEMF_CLEAR);
	iginfo=AllocRemember (&fr->Key,
	    sizeof (struct IGPropInfo),MEMF_PUBLIC | MEMF_CLEAR);
	if (!info || !(fr->Gadgets[SCROLL].GadgetRender) || !iginfo) goto error;
	fr->Gadgets[SCROLL].SpecialInfo=(APTR)info;
	fr->Gadgets[SCROLL].UserData=(APTR)iginfo;
	*info=IGFRScrollPropInfo;
	iginfo->Type=GADG_PROP;
	iginfo->DisplayedY=7;
	iginfo->ScrollFunc=UpdateSBox;
	iginfo->LUArrow=&fr->Gadgets[UP];
	iginfo->RDArrow=&fr->Gadgets[DOWN];
	iginfo->SBox=fr->SBox;
	iginfo->IGObject=obj;
    }

    for (i=6;i<8;++i) {
	struct IGPropArrowInfo *info;

	info=AllocRemember
	    (&fr->Key,sizeof (struct IGPropArrowInfo),MEMF_PUBLIC | MEMF_CLEAR);
	if (!info) goto error;
	fr->Gadgets[i].UserData=(APTR)info;
	info->Type=GADG_ARROW;
	info->Prop=&fr->Gadgets[SCROLL];
	info->IGObject=obj;
    }
    for (i=0;i<9;++i) {
	fr->Gadgets[i].LeftEdge+=fr->LeftEdge-5;
	fr->Gadgets[i].TopEdge+=fr->TopEdge-12;
	fr->Gadgets[i].NextGadget=&fr->Gadgets[i+1];
    }
    fr->Gadgets[8].NextGadget=req->Gadgets;
    if (!(fr->Flags & IGFR_OKCANCEL))
	fr->Gadgets[OK-1].NextGadget=&fr->Gadgets[CANCEL+1];
    req->Gadgets=fr->Gadgets;

    return (0);

error: return (1);
}

