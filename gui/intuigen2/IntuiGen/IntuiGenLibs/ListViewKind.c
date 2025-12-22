/*
ListViewKind.c

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
#include <IntuiGen/GTRequest.h>

#define ALPHA 1  /* For AddNamedNodeToList */

#define NODUPLICATES 1 /* For AddNodeAlpha */

#define FirstNode(l) FirstItem(l)
#define NextNode(n) NextItem(n)

ULONG CountNodesInList(struct List *l)
{
    struct Node *n;
    ULONG c;

    for (c=0,n=FirstNode(l);n;n=NextNode(n),++c);
    return c;
}

LONG AddNodeAlpha(struct List *l,struct Node *n,ULONG flags)
{
    if (l && n) {
	struct Node *c;
	int x=1;

	for (c=l->lh_Head;c->ln_Succ;c=c->ln_Succ) {
	    x=stricmp(n->ln_Name,c->ln_Name);
	    if (x<=0) break;
	}
	if (x || (!(flags & NODUPLICATES) && x<=0) ) {
	    c=c->ln_Pred;
	    Insert(l,n,c);
	    return 1;
	}
    }
    return 0;
}

struct Node *AddNamedNodeToList(struct Remember **key,struct List *l,UBYTE *name,ULONG size,
				ULONG flags)
{
    struct Node *n;

    if (!size) size=sizeof(struct Node);

    if (n=AllocRemember(key,size,MEMF_PUBLIC | MEMF_CLEAR)) {
	if (n->ln_Name=AllocRemember(key,strlen(name)+1,MEMF_PUBLIC)) {
	    strcpy(n->ln_Name,name);
	    if (flags & ALPHA) {
		AddNodeAlpha(l,n,0);
	    } else AddTail(l,n);
	} else n=0;
    }
    return n;
}

UBYTE ChangeNodesName(struct Remember **key,struct GTRequest *req,
	 struct GTControl *gtc,struct List *l,struct Node *n,UBYTE *newname)
{
    UBYTE retval=0;

    SetControlAttrs(req,gtc,GTLV_Labels,~0,TAG_DONE);

    if (n->ln_Name=AllocRemember(key,strlen(newname)+1,MEMF_PUBLIC)) {
	strcpy(n->ln_Name,newname);
	retval=1;
    }

    SetControlAttrs(req,gtc,GTLV_Labels,l,TAG_DONE);

    return retval;
}

struct Node *AddEntryToListBox(struct Remember **key,struct GTRequest *req,
	 struct GTControl *gtc,struct List *l,UBYTE *name,ULONG size,ULONG flags)
{
    struct Node *n;

    SetControlAttrs(req,gtc,GTLV_Labels,~0,TAG_DONE);
    n=AddNamedNodeToList(key,l,name,size,flags);
    SetControlAttrs(req,gtc,GTLV_Labels,l,TAG_DONE);

    return n;
}

UBYTE RemoveEntryFromListBox(struct GTRequest *req,struct GTControl *gtc,
		    struct List *l,struct Node *n)
{
    SetControlAttrs(req,gtc,GTLV_Labels,~0,TAG_DONE);
    Remove(n);
    SetControlAttrs(req,gtc,GTLV_Labels,l,TAG_DONE);

    return 1;
}

ULONG NodeToOrd(struct List *l,struct Node *n)
{
    ULONG x;
    struct Node *c;

    for (x=0,c=FirstItem(l);c && c!=n;c=NextItem(c),++x);
    return x;
}

struct Node *OrdToNode(struct List *l,ULONG ord)
{
    ULONG x;
    struct Node *n;

    if (ord==~0) return 0;

    for (x=0,n=FirstNode(l);n && x<ord;++x,n=NextNode(n));

    return n;
}

