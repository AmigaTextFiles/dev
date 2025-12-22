/* FindRef.c
Originaly written by Anders Melchiorsen, modified by Roland Florac (SAS/C compiler) */

#include "FetchRefs.h"

static APTR __regargs NewMatchList (struct LayoutHandle * h);
static LONG __regargs BuildRefList (struct FindRefOptions *args, struct LayoutHandle * h);
static void __regargs FindRefInteractive (struct FindRefOptions *args, struct FindRefReturnStruct *ret);
static void __regargs PutRef (struct ListViewNode *item, STRPTR destfile, struct FindRefReturnStruct *ret);
static void SwitchToFileIndex (struct LayoutHandle * handle);
static struct Screen * __regargs FindScreen (STRPTR pubname);

APTR ListPool;
static struct List RefsFound;


struct ListViewNode {

/* ln_name in the Node points to the string that is to be shown in the
 * listview. ln_type is 1 for file references, 2 for normal ones.
 *
 * fileentry is a pointer to the FileEntry in which the reference is
 *
 * refsentry is a pointer to the reference to fetch.
 *
 * ListViewText is used if we build a new string for the listview.
 */

    struct Node node;
    struct FileEntry *fileentry;
    struct RefsEntry *refsentry;
    UBYTE ListViewText[0];
};

/* GTLayout specifications */
enum {	ID_LIST_WINDOW = 1,
	ID_LIST_LIST, ID_LIST_PATTERN, ID_LIST_OK, ID_LIST_FILE, ID_LIST_CANCEL
     };

__saveds __asm char * LocaleHookFunc (register __a0 struct Hook * UnusedHook, register __a2 APTR Unused, register __a1 long ID)
{
    return GetString(ID);
}

struct Hook LocaleHook = { 0, 0, (HOOKFUNC) LocaleHookFunc, 0, 0 };

static void __regargs New_Horizontal_group (struct LayoutHandle * Handle, long frame)
{   long i = 1;
    struct TagItem tags[6];
    tags[0].ti_Tag = LA_Type;
    tags[0].ti_Data = HORIZONTAL_KIND;
    if (frame)
    {	tags[i].ti_Tag = LAGR_SameSize; tags[i].ti_Data = TRUE; i++;
	tags[i].ti_Tag = LAGR_Frame;	tags[i].ti_Data = TRUE; i++;
    }
    tags[i].ti_Tag = TAG_DONE;
    LT_NewA (Handle, tags);
}

static void __regargs New_Vertical_group (struct LayoutHandle * Handle, long frame)
{   long i = 1;
    struct TagItem tags[4];
    tags[0].ti_Tag = LA_Type;
    tags[0].ti_Data = VERTICAL_KIND;
    if (frame)
    {	tags[i].ti_Tag = LAGR_Frame;	tags[i].ti_Data = TRUE;     i++;    }
    tags[i].ti_Tag = TAG_DONE;
    LT_NewA (Handle, tags);
}

void TellWeStopOutline (void)
{
    struct LayoutHandle * h;
    struct Window * w;

    h = LT_CreateHandleTags (0, LAHN_LocaleHook, &LocaleHook, TAG_DONE);
    if (h)
    {
	New_Vertical_group (h, 1);
	{
	    LT_New (h,
		LA_Type,	BOX_KIND,
		LABX_AlignText, ALIGNTEXT_Centered,
		LABX_Line,	GetString(TEXTE_REMOVE),
		LABX_DrawBox,	TRUE,
		LABX_DrawBox,	FALSE,
	    TAG_DONE);
	    LT_EndGroup (h);
	}
	w = LT_Build (h,
	    LAWN_Title,     "FetchRefs "VERSION,
	    WA_DepthGadget, TRUE,
	    WA_RMBTrap,     TRUE,
	    WA_DragBar,     TRUE,
	    WA_Activate,    FALSE,
	TAG_DONE);
	if (w)
	    Delay (TICKS_PER_SECOND);
	LT_DeleteHandle (h);
    }
}

static struct LayoutHandle * __regargs ReferenceList (struct Screen * scr)
{
    struct LayoutHandle * h;
    struct Window * w;

    h = LT_CreateHandleTags (scr, LAHN_LocaleHook, &LocaleHook, TAG_DONE);
    if (h)
    {

	New_Vertical_group (h, 0);
	{
	    LT_New (h,
		LA_Type,	LISTVIEW_KIND,
		GTLV_Selected,	0,
		LALV_Link,	NIL_LINK,
		LA_Chars,	60,
		LALV_CursorKey, TRUE,
		LALV_ResizeY,	TRUE,
		LALV_ResizeX,	TRUE,
		LALV_MinLines,	10,
		LALV_Lines,	scr->Height > 256 ? 20 : 10,
		GTLV_Labels,	&RefsFound,
		LA_ID,		ID_LIST_LIST,
	    TAG_DONE);
	    New_Horizontal_group (h, 0);
	    {
		LT_New (h,
		    LA_Type,	    STRING_KIND,
		    LA_LabelID,     TEXTE_FIND_PATTERN,
		    LA_LabelPlace,  PLACE_Left,
		    LA_ID,	    ID_LIST_PATTERN,
		    LA_Chars,	    48,
		TAG_DONE);
		LT_EndGroup (h);
	    }
	    New_Horizontal_group (h, 1);
	    {
		LT_New (h,
		    LA_Type,	BUTTON_KIND,
		    LA_ID,	ID_LIST_OK,
		    LA_LabelID, TEXTE_FETCHREF,
		    LABT_ReturnKey, TRUE,
		    LABT_ExtraFat, TRUE,
		TAG_DONE);
		LT_New (h,
		    LA_Type,	BUTTON_KIND,
		    LA_ID,	ID_LIST_FILE,
		    LA_LabelID, TEXTE_LISTE,
		TAG_DONE);
		LT_New (h,
		    LA_Type,	BUTTON_KIND,
		    LA_ID,	ID_LIST_CANCEL,
		    LA_LabelID, TEXTE_CANCEL,
		TAG_DONE);
		LT_EndGroup (h);
	    }
	    LT_EndGroup (h);
	}
	w = LT_Build (h,
	    LAWN_Title,     GetString (TEXTE_REFERENCE),
	    WA_ScreenTitle, GetString (TEXTE_VERSION),
	    LAWN_IDCMP,     IDCMP_CLOSEWINDOW | CHECKBOXIDCMP | IDCMP_RAWKEY,
	    WA_DepthGadget, TRUE,
	    WA_RMBTrap,     TRUE,
	    WA_DragBar,     TRUE,
	    WA_Activate,    TRUE,
	    WA_CloseGadget, TRUE,
	TAG_DONE);
	if (w)
	    return h;
	LT_DeleteHandle (h);
    }
    return 0;
}

static long __regargs compute_string_length (struct List * RefsFound)
{
    struct ListViewNode * vn;
    long len = 0;

    for (vn = (struct ListViewNode *) RefsFound->lh_Head;
	    vn->node.ln_Succ;
	    vn = (struct ListViewNode *) vn->node.ln_Succ)
    {
	len += strlen(vn->fileentry->Name) + 1;
    }
    return len;
}

static void __regargs copy_strings (struct List * RefsFound, char * dest)
{
    struct ListViewNode * vn;
    char * r = dest;

    for (vn = (struct ListViewNode *) RefsFound->lh_Head;
	    vn->node.ln_Succ;
	    vn = (struct ListViewNode *) vn->node.ln_Succ)
    {
	strcpy (r, vn->fileentry->Name);
	r += strlen(r);
	if (vn->node.ln_Succ)
	{
	    * r = 10;
	    r++;
	}
    }
    *r = 0;
}

/* FindRef() - interface to fetch a reference to file
 * Actual look-up routine. Copies the reference to 'ref' into a file */
void __regargs FindRef (struct FindRefOptions * args, struct FindRefReturnStruct * ret)
{
    LONG refsfound = 0, l;
    UBYTE pattern[128], * refs;

    /* Assume failure until proven wrong */
    ret->Result = RET_FAULT;
    ret->Number = ERROR_NO_FREE_STORE;

    if (! NewMatchList(0))
	goto error;
    /* Build a list of references matching the requested one */

    /* If the search  pattern  turns out to be blank we show
     * the "references found" window anyway -- to allow the
     * user to enter a new one. */

    if (ParsePatternNoCase (args->Reference, pattern, 128) != -1)
	if (MatchPatternNoCase (pattern, ""))
	    refsfound = 2;

    if (!refsfound)
    {
	refsfound = BuildRefList (args, 0);

	if (refsfound > 0)
	{
	    ret->Result = refsfound;
	    goto error;
	}
	else
	    refsfound = -refsfound;
    }

    if (args->function == FR_FILE)
    {
	if (refsfound > 0)
	{
	    l = compute_string_length (&RefsFound);
	    if (refs = AllocVec (l + 1, MEMF_PUBLIC | MEMF_CLEAR))
	    {
		copy_strings (&RefsFound, refs);
		args->Reference = refs;
		ret->Result = RET_MATCH;
	    }
	    else
		ret->Result = RET_NO_MATCH;
	}
	else
	    ret->Result = RET_NO_MATCH;
    }
    else if (args->function == FR_REQ)
	FindRefInteractive (args, ret);
    else
    {
	/* If exactly one match was found we simply fetch it. Otherwise we
	 * ask the user for further help. */
	if (refsfound == 1)
	    PutRef ((struct ListViewNode *) RefsFound.lh_Head, args->DestFile, ret);
	else if (refsfound > 1)
	    FindRefInteractive (args, ret);
	else
	    ret->Result = RET_NO_MATCH;
    }
error:
    /* Free the list */
    LibDeletePool (ListPool);
    ListPool = NULL;
}

/* FindRefInteractive() - open window and ask which reference to use */
static void __regargs FindRefInteractive (struct FindRefOptions *args, struct FindRefReturnStruct * ret)
{
    struct Screen *scr;
    BOOL swappedscreen = FALSE;
    struct LayoutHandle * h;
    ULONG signal;
    struct IntuiMessage * message;
    struct ListViewNode * f;

    /* Get a pointer to the Screen to open on. The screen is
     * LockPubScreen()'ed and we must unlock (is done further down).
     */
    if (!(scr = FindScreen (args->PubScreen)))
	return;

    /* Bring the screen to the front if it is not already there */
    if (IntuitionBase->FirstScreen != scr)
    {	ScreenToFront (scr);
	swappedscreen = TRUE;
    }

    h = ReferenceList (scr);
    if (h)
    {
	if (IsListEmpty (&RefsFound))
	{
	    /* Disable fetch gadgets if the references window is empty */
	    LT_SetAttributes (h, ID_LIST_FILE, GA_Disabled, TRUE, TAG_END);
	    LT_SetAttributes (h, ID_LIST_OK, GA_Disabled, TRUE, TAG_END);
	    DisplayBeep(0);
	}
	else
	{
	    /* Copy the search pattern into the string gadget buffer */
	    LT_SetAttributes (h, ID_LIST_PATTERN, GTST_String, args->Reference, TAG_END);
	}
	args->Reference = (STRPTR) LT_GetAttributes (h, ID_LIST_PATTERN, TAG_DONE);
	ret->Result = RET_NO_MATCH;
	signal = 1 << h->Window->UserPort->mp_SigBit;
	do
	{   Wait (signal);
	    while (message = LT_GetIMsg (h))
	    {	switch (message->Class)
		{   case IDCMP_CLOSEWINDOW:
			ret->Result = RET_ABORT;
			break;
		    case IDCMP_RAWKEY:
			if (message->Code == 0x5F)
			    GiveHelp (scr);
			break;
		    case IDCMP_GADGETUP:
			switch (((struct Gadget *) message->IAddress)->GadgetID)
			{
			    case ID_LIST_OK:
			    {
list:
				LT_LockWindow (h->Window);
				/* Find the selected node and fetch it */
				f = ListOffsetToPtr (&RefsFound, LT_GetAttributes (h, ID_LIST_LIST, TAG_DONE));
				PutRef (f, args->DestFile, ret);
				LT_UnlockWindow (h->Window);
				break;
			    }
			    case ID_LIST_FILE:
				SwitchToFileIndex (h);
				break;
			    case ID_LIST_CANCEL:
				ret->Result = RET_ABORT;
				break;
			    case ID_LIST_PATTERN:
				LT_LockWindow (h->Window);

				if (BuildRefList (args, h) == 0)
				{
				    /* Disable fetch and 'list file' gadget if no references are
				     * found. */
				    LT_SetAttributes (h, ID_LIST_FILE, GA_Disabled, TRUE, TAG_END);
				    LT_SetAttributes (h, ID_LIST_OK, GA_Disabled, TRUE, TAG_END);
				}
				else
				{
				    /* As we get a new list we can once again do ID_LIST_FILE
				     * and fetch a reference */
				    LT_SetAttributes (h, ID_LIST_FILE, GA_Disabled, FALSE, TAG_END);
				    LT_SetAttributes (h, ID_LIST_OK, GA_Disabled, FALSE, TAG_END);
				}

				/* Now actually display the new list */
				LT_SetAttributes (h, ID_LIST_LIST, GTLV_Labels, (ULONG)&RefsFound, TAG_END);

				/* And finally re-activate the GUI */
				LT_UnlockWindow (h->Window);
				break;
			}
			break;
		    case IDCMP_IDCMPUPDATE:
			goto list;
		}
		LT_ReplyIMsg (message);
	    }
	}
	while (ret->Result == RET_NO_MATCH);
	LT_DeleteHandle (h);
    }
    if (swappedscreen)
	ScreenToBack (scr);
    UnlockPubScreen (NULL, scr);
}

/* GiveHelp() - open guide positioned at the help for <id> */
void __regargs GiveHelp (struct Screen * scr)
{
    struct Library *AmigaGuideBase;
    struct NewAmigaGuide nag = { NULL };
    AMIGAGUIDECONTEXT handle;

    nag.nag_Name = "FetchRefs_FR.guide";
    nag.nag_Screen = scr;
    nag.nag_Node = "4.";

    /* Show the guide */
    if (AmigaGuideBase = OpenLibrary ("amigaguide.library", 34))
    {
	if (handle = OpenAmigaGuideA (&nag, NULL))
	    CloseAmigaGuide (handle);
	else
	    PostMessage (GetString (TEXTE_GUIDE));

	CloseLibrary (AmigaGuideBase);
    }
    else
	PostMessage (GetString (TEXTE_AMIGAGUIDE));
}

/* NewMatchList() - free the list (if any) of matches and allocate new one */
static APTR __regargs NewMatchList (struct LayoutHandle * h)
{
    /* Empty the list and create a new, empty one. Empty the listview, too */
    if (h)
	LT_SetAttributes (h, ID_LIST_LIST, GTLV_Labels, (ULONG)~0, TAG_END);

    NewList (&RefsFound);

    if (h)
    {
	LT_SetAttributes (h, ID_LIST_LIST, GTLV_Labels, (ULONG)&RefsFound, TAG_END);
	LT_SetAttributes (h, ID_LIST_LIST, GTLV_Labels, (ULONG)~0, TAG_END);
    }

    LibDeletePool (ListPool);
    return (ListPool = LibCreatePool (NULL, 8192, 8192));
}

/* PutRef() - writes a reference to file */
/* Write the reference. Handles the writing both to a normal file and to the
 * clipboard (through iffparse.library). */
#define ID_FTXT MAKE_ID('F','T','X','T')
#define ID_CHRS MAKE_ID('C','H','R','S')
static void __regargs PutRef (struct ListViewNode *item, STRPTR destfile, struct FindRefReturnStruct *ret)
{
    BPTR from;
    STRPTR buf = NULL;
    LONG fetchfrom, fetchlength;

    /* Figure out the actual file length if the reference is a complete file.
     * Otherwise just grab the reference size from the list.
     */
    fetchfrom = 0;
    fetchlength = -1;
    if (item->node.ln_Type == 2)
    {
	fetchfrom = item->refsentry->Offset;
	fetchlength = item->refsentry->Length;
    }
    if (fetchlength == -1)
	fetchlength = FileLength (item->fileentry->Name);

    /* Attempt to open file, allocate memory, and read reference */
    if (from = Open (item->fileentry->Name, MODE_OLDFILE))
    {
	if (buf = LibAllocPooled (ListPool, fetchlength))
	{
	    Seek (from, fetchfrom, OFFSET_BEGINNING);
	    Read (from, buf, fetchlength);
	}

	Close (from);
    }
    else
	ret->Number = IoErr();

    /* Now write the reference */
    if (buf)
    {
	/* Write to a normal file if destination is not "CLIP#?" */
	if (strncmp (destfile, "CLIP", 4) != 0)
	{
	    BPTR to;

	    if (to = Open (destfile, MODE_NEWFILE))
	    {
		if (Write (to, buf, fetchlength) == fetchlength)
		    ret->Result = RET_MATCH;
		else
		    ret->Number = IoErr();

		Close (to);
	    } else
		ret->Number = IoErr();

	}
	else  /* Write to a clipboard unit */
	{
	    struct Library *IFFParseBase;
	    if (IFFParseBase = OpenLibrary ("iffparse.library", 37))
	    {
		struct IFFHandle *iff;

		if (iff = AllocIFF())
		{
		    if (iff->iff_Stream = (unsigned long) OpenClipboard (atoi(&(destfile[4]))))
		    {
			InitIFFasClip(iff);
			if (OpenIFF(iff, IFFF_WRITE) == 0)
			{
			    if (PushChunk (iff, ID_FTXT, ID_FORM, IFFSIZE_UNKNOWN) == 0)
			    {
				if (PushChunk (iff, 0, ID_CHRS, fetchlength) == 0)
				{
				    if (WriteChunkBytes (iff, buf, fetchlength) == fetchlength)
				    {
					if (PopChunk (iff) == 0)
					    ret->Result = RET_MATCH;
				    }
				    PopChunk (iff);
				}
			    }
			    CloseIFF (iff);
			}
			CloseClipboard ((struct ClipboardHandle *)iff->iff_Stream);
		    }
		    FreeIFF (iff);
		}
		CloseLibrary (IFFParseBase);
	    }
	}
    }

    /* If we wrote the reference we can return what line number to jump to.
     * For a file reference this is zero.
     */
    if (ret->Result == RET_MATCH)
	ret->Number = (item->node.ln_Type == 1) ? 0 : item->refsentry->Goto;
}

/* BuildRefList() - builds a list of all the matching references */
/* This is a call back function for the sort routine.. */
BOOL __regargs SortListFunct (struct ListViewNode *a, struct ListViewNode *b, ULONG data)
{   BOOL r;
    /* Sort alphabetically */
    if (a->node.ln_Type == b->node.ln_Type)
    {	r = ( stricmp (a->node.ln_Name, b->node.ln_Name) > 0 );
	return r;
    }

    /* Put files at the top */
    r = (a->node.ln_Type == 2);
    return r;
}

static LONG __regargs BuildRefList (struct FindRefOptions *args, struct LayoutHandle * h)
{
    STRPTR pattern;
    LONG numofrefs = 0, len, res;
    struct RefsEntry *currref;
    struct FileEntry *currfile;

    /* First of all: Initialize the list of matching references */
    if (! NewMatchList (h))
	return ERROR_NO_FREE_STORE;

    /* Tokenize pattern string */
    len = strlen (args->Reference) * 2 + 2;

    /* We just return as fail code is already set above */
    if (! (pattern = LibAllocPooled (ListPool, len)))
	return ERROR_NO_FREE_STORE;

    /* Tokenize the search string */
    if (args->Case)
	res = ParsePattern (args->Reference, pattern, len);
    else
	res = ParsePatternNoCase (args->Reference, pattern, len);

    if (res == -1)
	return ERROR_TOO_MANY_LEVELS;

    /* Pick up all references */
    for (currfile = (struct FileEntry *) FileList.lh_Head;
	    currfile->node.ln_Succ;
	    currfile = (struct FileEntry *) currfile->node.ln_Succ)
    {
	/* Check for a match on the file name */
	if (args->FileRef)
	{
	    UBYTE name[108], *cutptr;
	    /* Isolate the base name (eg. 'INCLUDE:libraries/dos.h' -> 'dos') */
	    strcpy (name, FilePart (currfile->Name));
	    cutptr = name;
	    while (*cutptr)
	    {
		if ((*cutptr >= 'a' && *cutptr <= 'z') ||
		    (*cutptr >= 'A' && *cutptr <= 'Z') ||
		    (*cutptr >= '0' && *cutptr <= '9') ||
		    (*cutptr == '_'))
		    cutptr++;
		else
		    *cutptr = 0;
	    }

	    /* Create an item to add to the RefsFound list */
	    if ((args->Case) ? MatchPattern(pattern, name) : MatchPatternNoCase(pattern, name))
	    {
		struct ListViewNode *r;

		if (r = LibAllocPooled (ListPool, sizeof(struct ListViewNode)))
		{
		    r->fileentry = currfile;
		    r->node.ln_Type = 1;
		    r->node.ln_Name = currfile->Name;

		    AddTail (&RefsFound, &r->node);
		    numofrefs++;
		}
	    }
	}

	/* Check all the RefsEntry's in this FileEntry for a match */
	for (currref = (struct RefsEntry *) currfile->RefsList.lh_Head;
		currref->node.ln_Succ;
		currref = (struct RefsEntry *) currref->node.ln_Succ)
	{
	    if ((args->Case) ? MatchPattern(pattern, currref->Name) : MatchPatternNoCase(pattern, currref->Name))
	    {
		struct ListViewNode *r;
		if (r = LibAllocPooled (ListPool, sizeof(struct ListViewNode) + strlen(currfile->Name) + strlen(currref->Name) + 5))
		{
		    r->fileentry = currfile;
		    r->refsentry = currref;
		    r->node.ln_Type = 2;
		    r->node.ln_Name = r->ListViewText;

		    SPrintf (r->ListViewText, "%s => %s", currref->Name, currfile->Name);

		    AddTail (&RefsFound, &r->node);
		    numofrefs++;
		}
	    }
	}
    }
    SortExecList (&RefsFound, SortListFunct, 0);

    /* Negate the number of matches; positive return code means failure */
    return -numofrefs;
}

static void SwitchToFileIndex (struct LayoutHandle * h)
{
    struct FileEntry *file;
    struct RefsEntry *selectedref, *ref;
    struct ListViewNode *selected;
    LONG selectedpos = 0;

    LT_LockWindow (h->Window);
    LT_SetAttributes (h, ID_LIST_FILE, GA_Disabled, TRUE, TAG_END);

    selected = ListOffsetToPtr (&RefsFound, LT_GetAttributes (h, ID_LIST_LIST, TAG_DONE));
    file = selected->fileentry;
    selectedref = selected->refsentry;

    if (! NewMatchList (h))
	goto nomem;

    /* Build a new list */
    for (ref = (struct RefsEntry *) file->RefsList.lh_Head;
	    ref->node.ln_Succ;
	    ref = (struct RefsEntry *) ref->node.ln_Succ)
    {
	struct ListViewNode *r;

	if (r = LibAllocPooled (ListPool, sizeof(struct ListViewNode) + strlen(ref->Name) + 4 + strlen(file->Name) + 1))
	{
	    r->fileentry = file;
	    r->refsentry = ref;
	    r->node.ln_Type = 2;
	    r->node.ln_Name = r->ListViewText;
	    SPrintf (r->ListViewText, "%s => %s", ref->Name, file->Name);

	    AddTail (&RefsFound, &r->node);
	}
    }

    SortExecList (&RefsFound, SortListFunct, 0);

    /* Figure out where the reference we started with has ended in new list */
    for (selected = (struct ListViewNode *) RefsFound.lh_Head;
	    selected->node.ln_Succ;
	    selected = (struct ListViewNode *) selected->node.ln_Succ)
    {
	if (selected->refsentry == selectedref)
	    break;
	selectedpos++;
    }
    if (!selected->node.ln_Succ)
	selectedpos = 0;

nomem:
    /* Update GUI */
    LT_SetAttributes (h, ID_LIST_LIST, GTLV_Labels, (ULONG)&RefsFound, TAG_END);
    LT_SetAttributes (h, ID_LIST_LIST, GTLV_Selected, selectedpos, TAG_END);
    LT_SetAttributes (h, ID_LIST_LIST, GTLV_Top, selectedpos, TAG_END);

    LT_UnlockWindow (h->Window);
}

/* FindScreen() - return best Screen, based prefered <pubname> PubScr name */
static struct Screen * __regargs FindScreen (STRPTR pubname)
{
    struct Screen *s = NULL;

    /* A specific public screen is wanted */
    if (pubname)
	s = LockPubScreen (pubname);

    /* Go for the currently active screen */
    if (!s)
    {
	UBYTE wantname[MAXPUBSCREENNAME+1];
	struct Screen *wantscr;
	struct List *publist;
	struct PubScreenNode *pubnode;

	publist = LockPubScreenList();
	wantscr = IntuitionBase->ActiveScreen;
	pubnode = (struct PubScreenNode *) publist->lh_Head;
	while (pubnode->psn_Node.ln_Succ)
	{
	    if (pubnode->psn_Screen == wantscr)
		strcpy (wantname, pubnode->psn_Node.ln_Name);
	    pubnode = (struct PubScreenNode *) pubnode->psn_Node.ln_Succ;
	}
	UnlockPubScreenList();
	s = LockPubScreen (wantname);
    }

    /* Last option: default public screen */
    if (!s)
	s = LockPubScreen (NULL);

    return s;
}

/* FileLength() - returns file length or -1 for failure */
LONG __regargs FileLength (STRPTR name)
{
    BPTR lock;
    __aligned struct FileInfoBlock fib;

    if (lock = Lock (name, ACCESS_READ))
    {
	Examine (lock, &fib);
	UnLock (lock);
	return fib.fib_Size;
    }
    else
	return -1;
}

void * __regargs ListOffsetToPtr (struct List *l, LONG o)
{
    struct Node *n;

    if (o < 0)
	return NULL;

    n = l->lh_Head;
    while ((o--) && (n->ln_Succ))
	n = n->ln_Succ;

    return (n->ln_Succ) ? n : NULL;
}
