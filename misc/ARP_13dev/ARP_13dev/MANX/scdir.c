/* Copyright (C) 1986,1987 Manx Software Systems, Inc.  */

/* not exactly re-entrant, is it?  it does make a simple directory scanner though */

#include <exec/memory.h>
#include <libraries/arpbase.h>
#include <user/ftype.h>
#include <functions.h>
#include <errno.h>

#define MAXNAMELEN 256

struct AnchorPath *findfirst(), *findnext();

char *scdir (pat)
char *pat;
{
    register struct AnchorPath *ap;
    static int time = 0;

    Chk_Abort();

    do {
	if (!time) {        /* new pattern */
	    time = 1;
	    ap = findfirst(pat);
	}
	else {		    /* continue pattern */
	    ap = findnext();
	}
    } while (ap && arpisdir(ap));

    if (!ap) {          /* no more (return null) */
	time = 0;
	return NULL;
    }

    return ap->ap_Buf;	/* return ptr to name */
}


/* static struct DefaultTracker *_tr,*_tr2;  */
static struct AnchorPath *_ap;

static
struct AnchorPath *findfirst(path)
char *path;
{
    struct AnchorPath *findrtn();
    struct AnchorPath *allocap();

    if (!_ap && !allocap()) return NULL;

    return findrtn (FindFirst (path,_ap));
}

static
struct AnchorPath *findnext()
{
    struct AnchorPath *findrtn();

    return findrtn (FindNext (_ap));
}

static
struct AnchorPath *findrtn(rc)
ULONG rc;
{
    switch (rc) {
	case 0:
		return _ap;

	case ERROR_BREAK:
		_abort();
	case ERROR_NO_MORE_ENTRIES:
		errno = 0;
		break;

	default:
		errno = rc;
		break;
    }

    FreeAnchorChain (_ap);

    return NULL;
}


static
struct AnchorPath *allocap()
{
    register struct AnchorPath *ap = NULL;

    if ( (ap = ArpAlloc((long)sizeof *ap + MAXNAMELEN)) ) {
	SET_ID(ap,TRAK_ANCHOR);

	if (Enable_Abort) ap->ap_BreakBits = SIGBREAKF_CTRL_C;
	ap->ap_StrLen = MAXNAMELEN;
	_ap = ap;
    }
    else errno = ENOMEM;

    return ap;

#if 0
    register struct DefaultTracker *tr;
    register struct AnchorPath *ap = NULL;

	/* !!! the order of these two allocations is VERY important -
	       unless done in this order, FreeTaskResList() will not be
	       able to call FreeAnchorChain() correctly */

    if ( (ap = ArpAlloc((long)sizeof *ap + MAXNAMELEN)) && (tr = GetTracker(TRAK_ANCHOR)) ) {
	tr->dt_Object.dt_Resource = (CPTR)ap;
	if (Enable_Abort) ap->ap_BreakBits = SIGBREAKF_CTRL_C;
	ap->ap_StrLen = MAXNAMELEN;
	_ap = ap;
    }
    else {
	if (tr) FreeTrackedItem(tr);
	errno = ENOMEM;
    }
    return ap;
#endif

}
