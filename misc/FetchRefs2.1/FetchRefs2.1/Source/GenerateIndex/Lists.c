#include "GenerateIndex.h"

APTR FilePool;
BOOL KeepScanning;

#define FILE_ENTRY 1
#define REF_ENTRY 2

struct Prefs Settings;

/* GetHead(), GetTail(), GetSucc(), GetPred() [DICE compatible list functions] */
void * GetHead(void *lst)
{
    return ((struct List *)lst)->lh_Head->ln_Succ
	? ((struct List *)lst)->lh_Head
	: NULL;
}

void * GetTail (void *lst)
{
    return ((struct List *)lst)->lh_TailPred->ln_Succ
	? ((struct List *)lst)->lh_TailPred
	: NULL;
}

void * GetSucc (void *nod)
{
    return ((struct Node *)nod)->ln_Succ->ln_Succ
	? ((struct Node *)nod)->ln_Succ
	: NULL;
}

/* IsAlphaNum() - like isalnum() but accepts underscores as well */
static __inline int IsAlphaNum (UBYTE c)
{
    return isalnum(c) || c == '_';
}

/* LoadData() - ask for and load a data file */
void LoadData (STRPTR name)
{
    STRPTR filename;
    struct File_Entry node;
    FILE *file;
    struct List *currentfile;

    filename = name;

    if (!name)
    {
	if (rtFileRequest (DataFileReq, DataName, "Load file...", TAG_END))
	    filename = JoinPath (DataFileReq->Dir, DataName);

	if (!filename)
	    return;
    }

    DetachMainList();

    if (file = fopen (filename, "r"))
    {
	while (fread (&node, sizeof(struct File_Entry), 1, file) > 0)
	{
	    if (node.node.ln_Type == FILE_ENTRY)
	    {
		struct FileEntry *entry;

		if (entry = (struct FileEntry *) AllocPooled (FilePool, node.NodeSize))
		{
		    entry->node.ln_Type = node.node.ln_Type;
		    entry->node.ln_Name = entry->data.Name;
		    fread (entry->FileData, node.NodeSize - sizeof(struct Node), 1, file);
		    NewList (currentfile = &entry->data.RefsList);

		    AddTail (&FileList, &entry->node);
		}
		else
		    fseek(file, node.NodeSize - sizeof(struct Node), SEEK_CUR);
	    }
	    else if (node.node.ln_Type == REF_ENTRY)
	    {
		struct RefsEntry *entry;

		if (entry = (struct RefsEntry *) AllocPooled (FilePool, node.NodeSize))
		{
		    entry->node.ln_Type = node.node.ln_Type;
		    entry->node.ln_Name = entry->data.Name;
		    fread (entry->RefsData, node.NodeSize - sizeof(struct Node), 1, file);

		    AddTail (currentfile, &entry->node);
		}
		else
		    fseek (file, node.NodeSize - sizeof(struct Node), SEEK_CUR);
	    }
	    else
	    {	PostMessage ("Error reading file\nUnknown data found");
		break;
	    }
	}
	fclose (file);
    }

    AttachMainList(NULL);

    if (!name)
	FreeVec(filename);
}

/* SaveData() - ask for filename and save data to a file */
LONG SaveData (STRPTR name)
{
    STRPTR filename;
    struct FileEntry *entry;
    struct RefsEntry *refentry;
    FILE *file;
    void *copy;

    filename = name;

    if (!name)
    {
	if (rtFileRequest (DataFileReq, DataName, "Save as...", RTFI_Flags, FREQF_SAVE, TAG_END))
	    filename = JoinPath (DataFileReq->Dir, DataName);

	if (!filename)
	    return FALSE;
    }

    entry = (struct FileEntry *) GetHead (&FileList);

    if (file = fopen (filename, "w"))
    {
	void *buf;

	FileChanged = FALSE;

	/* Bigger buffer gives faster I/O */
	if (buf = AllocVec (16 * 1024, NULL))
	    setvbuf (file, buf, _IOFBF, 16 * 1024);

	while (entry->node.ln_Succ)
	{
	    int size;

	    /* Need to make a copy 'cause ->NodeSize overwrites this */
	    copy = entry->node.ln_Succ;
	    size = ((sizeofFileEntry + strlen(entry->node.ln_Name) + 1) + 1) & ~1;
	    entry->savedata.NodeSize = size;
	    fwrite (entry, 1, size, file);
	    entry->node.ln_Succ = copy;

	    refentry = GetHead (&entry->data.RefsList);
	    while (refentry->node.ln_Succ)
	    {
		copy = refentry->node.ln_Succ;
		size = ((sizeofRefsEntry + strlen(refentry->node.ln_Name) + 1) + 1) & ~1;
		refentry->savedata.NodeSize = size;
		fwrite (refentry, 1, size, file);
		refentry->node.ln_Succ = copy;

		refentry = GetSucc(refentry);
	    }

	    entry = GetSucc(entry);
	}
	fclose(file);
	FreeVec(buf);
    }

    if (!name)
	FreeVec(filename);

    return TRUE;
}

/* IndexFileList() - call IndexFile() for each file from a ReqTools filereq */
void IndexFileList (STRPTR path, struct rtFileList * lst)
{
    STRPTR dir;

    if (!(dir = FullName (path)))
	return;

    do
    {
	if (lst->StrLen == -1)
	    IndexRecursive (dir, lst->Name);
	else
	    IndexFile (dir, lst->Name);
    }
    while ((lst = lst->Next) && (KeepScanning));
    FreeVec(dir);
}

/* IndexRecursive() - call IndexFile() for files and itself for dirs */
void IndexRecursive (STRPTR path, STRPTR dir)
{
    BPTR lock;
    STRPTR name;
    struct FileInfoBlock *fib;

    if (! KeepScanning)
	return;

    fib = AllocDosObject (DOS_FIB, NULL);
    name = JoinPath (path, dir);
    lock = Lock (name, ACCESS_READ);

    if (fib && name && lock)
    {
	Examine (lock, fib);
	while (ExNext (lock, fib))
	{
	    if (fib->fib_DirEntryType < 0)
		IndexFile (name, fib->fib_FileName);
	    else if (Settings.Recursively)
		IndexRecursive (name, fib->fib_FileName);
	}
    }

    UnLock (lock);
    FreeVec (name);
    if (fib)
	FreeDosObject (DOS_FIB, fib);
}

/* AddAutodocToList() - add the references of an AutoDoc to the list */
static void AddAutodocToList (struct FileEntry *list, STRPTR buf, STRPTR end)
{
    STRPTR at, ff;

    at = ff = buf;

    /* Scan entire file */
    while (at < end)
    {
	STRPTR left, right;
	LONG rightlen = 0;

	/* Find next reference end (at a form feed) */
	if (at >= ff)
	{
	    /* Stop at next form feed or at the end of the file */
	    do
		ff++;
	    while ((ff < end) && (*ff != 12));
	}

	/* Find the start and end of the next line with text */
	for (left = at; (*left == '\f') || (*left == '\n') || (*left == ' ') || (*left == '\t'); )
	    left++;
	for (right = left; (*right != '\n') && (*right != '\f') && (right < end); )
	    right++;
	at = right + 1;

	/* Set 'right' to point to the start of the last word of the
	 * line. After this 'left' will point to the first word and
	 * 'right' to the last one.
	 */
	*right = 0;
	while ((right[-1] == ' ') || (right[-1] == '\t'))
	    *right-- = 0;
	while ((right[-1] != ' ') && (right[-1] != '\t'))
	    right--, rightlen++;

	/* Make sure that we actually have >1 words on this line.
	 * If we do, then check if the first and the last words are
	 * alike; that is the format of a new AutoDoc entry.
	 */
	if ((right > left) && (0 == strncmp(left, right, rightlen)))
	{
	    /* Set 'right' to point to the start of the name.
	     * This is so 'exec.library/AllocVec' will only
	     * be remembered as 'AllocVec'. Quite important.
	     */
	    right += rightlen;
	    while (IsAlphaNum(right[-1]))
	       right--;

	    AddRefToList(list, left - buf, ff - left, 0, right);
	}
	else	/* No more head lines, jump to next entry */
	    at = ff;
    }
}

/* AddCIncludeToList() - add the references of a C include file to the list */
static void AddCIncludeToList (struct FileEntry *list, STRPTR buf, STRPTR end)
{
    STRPTR at;
    UBYTE name[128];

    /* Remove all comments */
    at = buf;
    while (at < end)
    {
	if ((at[0] == '/') && (at[1] == '*'))
	{
	    *at++ = ' ';
	    do
	    {
		if (*at != '\n')
		    *at = ' ';
		at++;

		if (at + 2 == end)
		    break;
	    } while ((at[0] != '*') || (at[1] != '/'));
	    *at++ = ' ';
	    *at++ = ' ';
	} else if ((at[0] == '/') && (at[1] == '/'))
	{
	    do
		*at++ = ' ';
	    while ((*at != '\n') && (at < end));
	} else
	    at++;
    }

    if (Settings.CPrf.Define)
    {
	LONG line = 1;

	at = buf;
	while (at < end)
	{

	    if (*at == '\n')
		line++;
	    else if ( (at[0] == '#') && (at[1] == 'd') && (at[2] == 'e') && (at[3] == 'f')
		    && (at[4] == 'i') && (at[5] == 'n') && (at[6] == 'e') )
	    {
		at = PickName(name, at + 7) - 1;
		AddRefToList(list, 0, -1, line, name);
	    }

	    at++;
	}
    }

    if (Settings.CPrf.Struct)
    {
	STRPTR lastend = buf;
	LONG line = 1;

	at = FindStructUnion(buf, end, &line);

	while (at)
	{
	    STRPTR start;
	    LONG len, jump, level;

	    /* Get the name of this struct/union */
	    at = PickName(name, at + 6);

	    /* Find end of struct/union */
	    while (*at++ != '{')
		;
	    for (level = 1; level; at++)
	    {
		if (*at == '{')
		    level++;
		else if (*at == '}')
		    level--;
	    }
	    while (*at++ != ';')
		;

	    start = lastend;
	    jump = line;
	    lastend = at;
	    line = 1;

	    /* Find start of the _next_ struct/union. This is
	     * also the end of this reference.
	     */
	    at = FindStructUnion(at, end, &line);
	    len = (at ? at : end) - start;

	    AddRefToList(list, start - buf, len, jump, name);
	}
    }

    if (Settings.CPrf.Typedef)
    {
	LONG line = 1;

	at = buf;
	while (at < end)
	{
	    if (*at == '\n')
		line++;
	    else if ( (at[0] == 't') && (at[1] == 'y') && (at[2] == 'p') && (at[3] == 'e')
		    && (at[4] == 'd') && (at[5] == 'e') && (at[6] == 'f') )
	    {
		while ((*at != ';') && (at < end))
		    at++;
		at--;

		while (IsAlphaNum(*at))
		    at--;
		at++;

		at = PickName(name, at) - 1;
		AddRefToList(list, 0, -1, line, name);
	    }

	    at++;
	}
    }
}

/* AddEIncludeToList() - add the references of an E include file to the list */
static void AddEIncludeToList (struct FileEntry *list, STRPTR buf, STRPTR end)
{
    STRPTR at;
    UBYTE name[128];

    if (Settings.EPrf.Const)
    {
	at = buf;

	while (at < end)
	{
	    if (*at == '\n')
	    {
		if ( (at[1] == 'C') && (at[2] == 'O') && (at[3] == 'N')
		    && (at[4] == 'S') && (at[5] == 'T') )
		{
		    STRPTR start = at + 1, stop;
		    LONG lines;

		    /* Find end of CONST block */
		    for (stop = at + 1; ; stop++)
			if ((*stop == '\n') && (strncmp(&stop[1], "     ", 5)))
			    break;
		    stop--;

		    /* Add each CONST entry */
		    for (lines = 1; at < stop; lines++)
		    {
			at = PickName(name, at + 7);
			AddRefToList(list, start - buf, stop - start, lines, name);

			while ((*at) && (*at != '\n'))
			    at++;
		    }
		}
	    }

	    at++;
	}
    }

    if (Settings.EPrf.Object)
    {
	at = buf;

	while (at < end)
	{
	    if ( (at[0] == 'O') && (at[1] == 'B') && (at[2] == 'J')
	      && (at[3] == 'E') && (at[4] == 'C') && (at[5] == 'T') )
	    {
		STRPTR stop;
		LONG len;

		/* Find end of OBJECT block */
		if (stop = strstr(at, "ENDOBJECT"))
		{
		    while ((*stop) && (*stop != '\n'))
			stop++;

		    len = stop - at;
		    stop--;

		    /* Save reference */
		    PickName(name, at + 6);
		    AddRefToList(list, at - buf, len, 0, name);
		    at = stop;
		}
	    }

	    at++;
	}
    }

    if (Settings.EPrf.Proc)
    {
	for (at = buf; at < end; at++)
	    if (*at == '\n')
	    {
		if ( (at[1] == 'P') && (at[2] == 'R') && (at[3] == 'O')
		    && (at[4] == 'C') )
		{
		    STRPTR c;

		    at++;
		    for (c = at; (*c) && (*c != '\n'); c++)
			;

		    PickName(name, at + 5);
		    AddRefToList(list, at - buf, c - at, 0, name);
		    at = c;
		}
	    }
    }
}

/* AddAsmToList() - add the references of an Asm include file to the list */
static void AddAsmToList (struct FileEntry *list, STRPTR buf, STRPTR end)
{
    STRPTR at;
    UBYTE name[128];
    LONG line;

    /* Remove comments */
    for (at = buf; at < end; at++)
	if ((*at == ';') || (*at == '*'))
	    while ((*at) && (*at != '\n'))
		*at++ = ' ';

    if (Settings.AsmPrf.Equ)
    {
	line = 1;
	at = buf;

	while (at < end)
	{
	    /* Handle EQU definiton */
	    if ( ((at[1]|0x20) == 'e') && ((at[2]|0x20) == 'q') && ((at[3]|0x20) == 'u')
		&& (at[0] == ' ' || at[0] == '\t')
		&& (at[4] == ' ' || at[4] == '\t') )
	    {
		/* Find word before EQU */
		while (*at == ' ' || *at == '\t')
		    at--;
		while (IsAlphaNum(*at))
		    at--;

		/* If the word starts with a backslash (92) it is probably
		 * part of a macro and we ignore it.
		 */
		if (*at != 92)
		{
		    at++;
		    PickName(name, at);
		    AddRefToList(list, 0, -1, line, name);
		}

		while ((*at) && (*at != '\n'))
		    at++;
	    }

	    /* Unroll BITDEF macro */
	    if ( ((at[0]|0x20) == 'b') && ((at[1]|0x20) == 'i') && ((at[2]|0x20) == 't')
		&& ((at[3]|0x20) == 'd') && ((at[4]|0x20) == 'e') && ((at[5]|0x20) == 'f')
		&& (at[6] == ' ' || at[6] == '\t') )
	    {
		UBYTE mprefix[32], mname[32];
		ULONG i;

		at += 6;
		while (*at == ' ' || *at == '\t')
		    at++;

		for (i = 0; IsAlphaNum(*at); )
		    mprefix[i++] = *at++;
		mprefix[i] = 0;

		if (*at == ',')
		{
		    while (!IsAlphaNum(*at))
			at++;

		    for (i = 0; IsAlphaNum(*at); )
			mname[i++] = *at++;
		    mname[i] = 0;

		    /* Build e.g. MEMB_CLEAR */
		    strcpy(name, mprefix);
		    strcat(name, "B_");
		    strcat(name, mname);
		    AddRefToList(list, 0, -1, line, name);

		    /*	Change to MEMF_CLEAR */
		    name[strlen(mprefix)] = 'F';
		    AddRefToList(list, 0, -1, line, name);
		}

		while ((*at) && (*at != '\n'))
		    at++;
	    }

	    if (*at == '\n')
		line++;
	    at++;
	}
    }

    if (Settings.AsmPrf.Structure)
    {
	line = 1;
	at = buf;

	while (at < end)
	{
	    if ( ((at[0]|0x20) == 's') && ((at[1]|0x20) == 't') && ((at[2]|0x20) == 'r')
		&& ((at[3]|0x20) == 'u') && ((at[4]|0x20) == 'c') && ((at[5]|0x20) == 't')
		&& ((at[6]|0x20) == 'u') && ((at[7]|0x20) == 'r') && ((at[8]|0x20) == 'e')
		&& (at[9] == ' ' || at[9] == '\t') )
	    {
		at = PickName(name, at + 9);
		while ((*at) && (*at != '\n'))
		    at++;

		/* Workaround for the 'STRUCTURE MACRO' definition */
		if (stricmp(name, "MACRO"))
		    AddRefToList(list, 0, -1, line, name);
	    }

	    if (*at == '\n')
		line++;
	    at++;
	}
    }

    if (Settings.AsmPrf.Macro)
    {
	line = 1;
	at = buf;

	while (at < end)
	{
	    if ( ((at[0]|0x20) == 'm') && ((at[1]|0x20) == 'a') && ((at[2]|0x20) == 'c')
		&& ((at[3]|0x20) == 'r') && ((at[4]|0x20) == 'o')
		&& (at[5] == ' ' || at[5] == '\t' || at[5] == '\n') )
	    {
		/* Find name before MACRO */
		at--;
		while (*at == ' ' || *at == '\t')
		    at--;

		/* A few macros, like PARALLELNAME, have a colon here */
		if (*at == ':')
		    at--;

		while (IsAlphaNum(*at))
		    at--;
		at++;

		at = PickName(name, at);
		while ((*at) && (*at != '\n'))
		    at++;

		AddRefToList(list, 0, -1, line, name);
	    }

	    if (*at == '\n')
		line++;
	    at++;
	}
    }
}

/* IndexFile() - index a file, taking care of all settings, and add to list */
void IndexFile (STRPTR dir, STRPTR filename)
{
    BPTR lock;
    STRPTR name, buf, end;

    if (! KeepScanning)
	return;

    /* Join path and name unless they already are joined */
    if (! dir)
	name = filename;
    else if (!(name = JoinPath (dir, filename)))
	return;

    if (lock = Lock (name, SHARED_LOCK))
    {
	LONG bufsize;
	BPTR file;

	bufsize = FileLength (lock);

	if (file = Open (name, MODE_OLDFILE))
	{
	    if (buf = AllocVec (bufsize + 1, NULL))
	    {
		/* We add one extra byte to make sure that the file is '\0'
		 * terminated. Some of the scanning routines depend on this. */

		LONG filetype;

		Read (file, buf, bufsize);
		end = buf + bufsize;
		*end = 0;

		filetype = FileType (buf, bufsize);
		if (filetype != FILE_UNKNOWN)
		{
		    struct FileEntry *list;

		    /* Remove the refs of the old one if a copy already exists.
		     * Otherwise allocate a new, empty list. */
		    if (list = IsFileInList (lock, FilePart(name)))
		    {
			struct Node *r;

			DetachRefList ();
			while (r = RemHead (&list->data.RefsList))
			    FreePooled (FilePool, r, sizeofRefsEntry + strlen(r->ln_Name) + 1);
			AttachRefList ();
		    }
		    else
			list = AddFileToList (name);

		    if (list)
		    {
			BOOL freefile = FALSE;

			switch (filetype)
			{
			    case FILE_AUTODOC:
				AddAutodocToList (list, buf, end);      break;

			    case FILE_C:
				AddCIncludeToList (list, buf, end);     break;

			    case FILE_E:
				AddEIncludeToList (list, buf, end);     break;

			    case FILE_ASM:
				AddAsmToList (list, buf, end);          break;

			    /* Warn user about wrong file type */
			    case FILE_EMODULE:
				{
				    static LONG warned;

				    if (!warned)
					PostMessage ("You CANNOT scan E modules!\n"
						    "Use the output of ShowModule instead.");
				    warned = TRUE;
				    freefile = TRUE;
				}
				break;

			    case FILE_AMIGAGUIDE:
				{
				    static LONG warned;

				    if (!warned)
					PostMessage ("You CANNOT scan AmigaGuides! Use regular AutoDocs instead.\n"
						    "You may use the Shell utility 'Guide2AutoDoc'");
				    warned = TRUE;
				    freefile = TRUE;
				}
				break;
			}

			if ((freefile) || ((!Settings.KeepEmpty) && IsListEmpty(&list->data.RefsList)))
			    FreeFile (list);
			else
			{
			    /* Sort the references of this file */
			    SortExecList (&((struct FileEntry *)GetTail(&FileList))->data.RefsList, SortCompareFunc, NULL);
			    FileChanged = TRUE;
			}
		    }
		}
		FreeVec(buf);
	    }
	    Close(file);
	}

	UnLock(lock);
    }

    /* Only free if we actually joined names */
    if (name != filename)
	FreeVec (name);

    /* Check for IDCMP; user may have pressed 'Stop' */
    HandleGUI();
}

/* StartScanning() - initialize scanner */
void StartScanning (void)
{
    KeepScanning = TRUE;

    /* Make sure that the list view is empty as we are going to manipulate
     * the list heavily (which GadTools does not allow when it is attached
     * to a view). */
    AttachMainList (&EmptyList);

    OpenScanStatWindow ();
}

/* StopScanning() - signal scanner that it is time to stop */
void StopScanning (BOOL force)
{
    KeepScanning = FALSE;
    CloseScanStatWindow ();
    if (!force)
    {
	AttachMainList (&FileList);
	AttachRefList ();
    }
}

/* FileType() - figure out what kind of file the buffer comes from */
LONG FileType (STRPTR buf, LONG bufsize)
{
    STRPTR b;
    LONG checksize;

    for (checksize = 256; bufsize > 0; )
    {
	if (Settings.AutoDocPrf.Active)
	    if (FindKeyword (buf, "TABLE OF CONTENTS", checksize))
		return FILE_AUTODOC;

	if (Settings.CPrf.Active)
	    if (FindKeyword (buf, "#if", checksize) || FindKeyword(buf, "#define", checksize))
		return FILE_C;

	if (Settings.EPrf.Active)
	    if (FindKeyword (buf, "\n(---) OBJECT", checksize) ||
		FindKeyword (buf, "\nCONST", checksize)        ||
		FindKeyword (buf, "\nPROC", checksize)
	       )
		return FILE_E;

	if (Settings.AsmPrf.Active)
	    if (FindKeyword (buf, "IFND", checksize)        ||
		FindKeyword (buf, "EQU", checksize)         ||
		FindKeyword (buf, "STRUCTURE", checksize)   ||
		FindKeyword (buf, "MACRO", checksize)       ||
		FindKeyword (buf, "BITDEF", checksize)
	       )
	    return FILE_ASM;

	/* Nothing found; adjust parameters */
	buf = buf + (checksize - 10);
	bufsize = bufsize - (checksize - 10);
	checksize *= 2;
    }

    /* A few unsupported file types to be able to warn the user */
    if (0 == strncmp (buf, "EMOD", 4))
	return FILE_EMODULE;

    if ((b = FindKeyword (buf, "@", bufsize)) && (0 == strnicmp(&b[1], "database", 8)))
	return FILE_AMIGAGUIDE;

    /* Unrecognized file type - treat it as an AutoDoc? */
    if (Settings.UnknownAsAutoDoc)
	return FILE_AUTODOC;

    /* Everything failed. We really do not know this file type! */
    return FILE_UNKNOWN;
}

/* FileLength() - returns file length of locked file */
LONG FileLength (BPTR lock)
{
    __aligned struct FileInfoBlock fib;

    Examine (lock, &fib);
    return fib.fib_Size;
}

/* FindKeyword() - like strstr() but with length limit */
STRPTR FindKeyword (STRPTR buf, STRPTR keyword, LONG size)
{
    STRPTR c1, c2;

    do
    {
	c1 = buf;
	c2 = keyword;

	while ((*c1) && (*c1 == *c2))
	    c1++, c2++;

	if (!*c2)
	    return buf;

    }
    while((*buf++) && (size--));

    return NULL;
}

/* FullName() - return pointer to AllocVec()'ed full path of arg */
STRPTR FullName (STRPTR path)
{
    UBYTE *dir;

    dir = path;
    while (*dir)
	if (*dir++ == ':')
	{
	    if (dir = AllocVec (strlen(path) + 1, NULL))
		strcpy (dir, path);
	    return dir;
	}

    if (dir = AllocVec (512, NULL))
    {
	BPTR lok;

	if (lok = Lock (path, ACCESS_READ))
	{
	    NameFromLock (lok, dir, 512);
	    UnLock (lok);
	}
    }
    return dir;
}

/* JoinPath() - return ptr to AllocVec()'ed joined file name */
UBYTE * JoinPath (STRPTR dir, STRPTR name)
{
    LONG len;
    UBYTE * both;

    len = strlen(dir) + 1 + strlen(name) + 1;

    if (both = AllocVec (len, NULL))
    {
	strcpy (both, dir);
	if (name[0])
	    AddPart (both, name, len);
    }
    return both;
}

/* FindStructUnion() - return pointer to start of next struct/union definition */
STRPTR FindStructUnion (STRPTR ptr, STRPTR end, LONG *l)
{
    STRPTR ret;
    UBYTE name[128];

    while (ptr <= end)
    {
	if (*ptr == '\n')
	    *l = *l + 1;
	else if ( ((ptr[0] == 's') && (ptr[1] == 't') && (ptr[2] == 'r') && (ptr[3] == 'u') && (ptr[4] == 'c') && (ptr[5] == 't'))
	 || ((ptr[0] == 'u') && (ptr[1] == 'n') && (ptr[2] == 'i') && (ptr[3] == 'o') && (ptr[4] == 'n')) )
	{
	    /* Pick next word */
	    ret = ptr;
	    ptr = PickName(name, ptr + 6);

	    if (name[0])
	    {
		/* Find '{' (hopefully) */
		while (*ptr == ' ' || *ptr == '\t' || *ptr == '\n' || *ptr == '\f')
		    ptr++;

		/* If the format is 'struct <name> {' we have one */
		if (*ptr == '{')
		    return ret;
	    }
	}

	ptr++;
    }
    return NULL;
}

/* PickName() - skip initial white space and return next word */
STRPTR PickName (STRPTR buf, STRPTR ptr)
{
    while (*ptr == ' ' || *ptr == '\t')
	ptr++;
    while (IsAlphaNum (* ptr))
	*buf++ = *ptr++;
    *buf = 0;
    return ptr;
}

/* SortCompareFunc() - call back function for sortlist.lib functions */
BOOL __regargs SortCompareFunc (struct FileEntry * a, struct FileEntry * b, ULONG data)
{
    if (stricmp (a->node.ln_Name, b->node.ln_Name) > 0)
	return 1;
    return 0;
}

/* AddFileToList() - append arg to list of indexed files */
struct FileEntry * AddFileToList (STRPTR name)
{
    struct FileEntry *entry;

    if (entry = (struct FileEntry *) AllocPooled (FilePool, sizeofFileEntry + strlen(name) + 1))
    {
	strcpy (entry->data.Name, name);
	entry->node.ln_Name = entry->data.Name;
	entry->node.ln_Type = FILE_ENTRY;
	NewList (&entry->data.RefsList);

	AddTail (&FileList, &entry->node);
    }
    return entry;
}

/* AddRefToList() - add a ref to the list of refs of the specified file */
struct RefsEntry * AddRefToList (struct FileEntry *fileentry, LONG offset, LONG length, WORD gotoline, STRPTR name)
{
    struct RefsEntry *entry;

    /* Do not add the reference if the name is empty (ie ""). */
    if (!name[0])
	return (NULL);

    if (entry = (struct RefsEntry *) AllocPooled (FilePool, sizeofRefsEntry + strlen(name) + 1))
    {
	entry->data.Offset = offset;
	entry->data.Length = length;
	entry->data.Goto = gotoline;
	strcpy (entry->data.Name, name);
	entry->node.ln_Name = entry->data.Name;
	entry->node.ln_Type = REF_ENTRY;

	AddTail (&fileentry->data.RefsList, &entry->node);
    }
    return entry;
}

/* IsFileInList() - return ptr to FileEntry of lock */
struct FileEntry * IsFileInList (BPTR newlock, STRPTR filepart)
{
    struct Node *n;

    if (n = GetHead (&FileList))
    {
	for (; n->ln_Succ; n = n->ln_Succ)
	{
	    /* Check if filenames are the same */
	    if (0 == strcmp (FilePart(n->ln_Name), filepart))
	    {
		BPTR oldlock;

		/* Check if this really is the same file */
		if (oldlock = Lock (n->ln_Name, SHARED_LOCK))
		{
		    LONG val;

		    val = SameLock (oldlock, newlock);
		    UnLock (oldlock);

		    if (val == LOCK_SAME)
			return ((struct FileEntry *) n);
		}
	    }
	}
    }
    return NULL;
}

/* FreeFile() - free a FileEntry and all references in it */
void FreeFile (struct FileEntry *f)
{
    struct Node *n;

    /* Free all references of the file */
    DetachRefList();
    while (n = RemHead (&f->data.RefsList))
	FreePooled (FilePool, n, sizeofRefsEntry + strlen(n->ln_Name) + 1);
    AttachRefList();

    /* Free the file itself */
    Remove(&f->node);
    FreePooled (FilePool, f, sizeofFileEntry + strlen(f->node.ln_Name) + 1);
}

/* FreeRef() - free just a reference in a FileEntry */
void FreeRef (struct RefsEntry *r)
{
    /* Detach the reference and free the memory to the pool */
    DetachRefList();
    Remove (&r->node);
    AttachRefList();
    FreePooled (FilePool, r, sizeofRefsEntry + strlen(r->node.ln_Name) + 1);
}

/* InitializeFileList() - prepare a memory pool and Exec list */
void InitializeFileList (void)
{
    DetachMainList ();      /* voir GUI.c */
    DetachRefList ();       /* voir GUI.c */

    if (FilePool)
	FreeFileList ();    /* voir ci-dessous */

    NewList (&FileList);
    AttachMainList (NULL);  /* voir GUI.c */
    AttachRefList ();       /* voir GUI.c */

    if (!(FilePool = CreatePool (NULL, 8192, 8192)))
	CloseAll (ERROR_NO_FREE_STORE);
}

/* FreeFileList() - remove the memory pool of indexed files */
void FreeFileList (void)
{
    /* Free existing pool, just in case one exists */
    DeletePool (FilePool);
    FilePool = NULL;
}
