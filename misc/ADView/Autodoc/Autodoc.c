//
// Autodoc.c by Jean-Guy Speton.  Last updated: May 2, 1995.
//
// This program uses triton.library Copyright © Stefan Zeiger.
//
// This program was developed using DICE 3.0.  Changed may be needed
// for this program to compile under another C compiler.  Most notably,
// your compiler probably lacks the GetSucc() and GetHead() functions
// which DICE defines in <lists.h>.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <lists.h>
#include <signal.h>

#include <dos/dos.h>
#include <dos/exall.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <libraries/triton.h>

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/triton_protos.h>

#include <pragmas/triton_pragmas.h>

const char version_string[] = "\0$VER: AutodocViewer 1.0 (02-May-95)";

/// Function prototypes.

void BreakFunction(int code);
void do_main(void);
void DispatchAutodoc(STRPTR docname, struct Project *p);
void DispatchEntry(BPTR file_handle, struct Project *p, ULONG count, STRPTR name);
struct Node *AllocNode(STRPTR name);
void FreeProject(struct Project *p);
struct Project *AllocProject(ULONG id);
STRPTR ReadLine(BPTR file, STRPTR buf, ULONG len);

//// Globals.

struct Library *TritonBase;
struct TR_App *app;
struct ExAllControl *eac;
struct ExAllData *ead;
UBYTE EAData[1024];
BPTR lock, oldlock;
struct List doc_list, proj_list;
struct TR_Project *main_proj;

//// Structure definitions.

struct Project {
	struct Project		*proj_Succ, *proj_Pred;
	struct TR_Project	*proj_TRProject;
	BPTR				proj_File;				// File handle for this autodoc.
	ULONG				proj_ID;
	struct List			proj_List;
};

/////////////////////////////////////////////////////////////////////

int main(void)
{
	signal(SIGINT, SIG_IGN);	// We'll handle CTRL-C's ourselves.

	NewList(&doc_list);
	NewList(&proj_list);

	if (TritonBase = OpenLibrary(TRITONNAME, TRITON12VERSION)) {

		if (app = TR_CreateAppTags(
						TRCA_Name,		"ADView",
						TRCA_LongName,	"Autodoc View",
						TRCA_Info,		"Point-and-click autodoc viewer.",
						TRCA_Version,	"1.0",
						TRCA_Release,	"1",
						TRCA_Date,		"2.5.95",
					TAG_END)) {
			do_main();
		}
		else
			PutStr("Couldn't create triton application.\n");
	}
	else
		PutStr("Can't open triton.library v2+.\n");

	BreakFunction(20);
}

void BreakFunction(int code)
{
	struct Node *n;
	struct Project *p;

	// Clean up any still-open windows before shutting down.

	if (main_proj) {
		while (p = GetHead(&proj_list)) {
			Remove((struct Node *)p);
			FreeProject(p);
		}

		TR_CloseProject(main_proj);

		while (n = GetHead(&doc_list)) {
			Remove(n);
			FreeVec(n);
		}
	}

	if (eac)
		FreeDosObject(DOS_EXALLCONTROL, eac);

	if (oldlock)
		CurrentDir(oldlock);

	if (lock)
		UnLock(lock);

	if (app)
		TR_DeleteApp(app);

	if (TritonBase)
		CloseLibrary(TritonBase);

	exit(code);
}

void do_main(void)
{
	BOOL more;
	ULONG id_count = 1;

	struct Node *n, *n2;
	struct Project *p;

	struct TR_Message *trmsg;

	if (!(lock = Lock("AUTODOC:", ACCESS_READ))) {
		PutStr("Lock on AUTODOC: failed.\n");
		return;
	}

	if (!(eac = (struct ExAllControl *) AllocDosObject(DOS_EXALLCONTROL, NULL))) {
		PutStr("AllocDosObject() failed.\n");
		UnLock(lock);
		return;
	}

	eac->eac_LastKey = 0;
	eac->eac_MatchString = NULL;
	eac->eac_MatchFunc = NULL;

	oldlock = CurrentDir(lock);

	// Build the list of autodoc files.

	do {
		more = ExAll(lock, EAData, sizeof(EAData), ED_NAME, eac);
		if ((!more) && (IoErr() != ERROR_NO_MORE_ENTRIES)) {

			// ExAll failed abnormally.

			break;
		}
		if (eac->eac_Entries == 0)
			break;

		ead = (struct ExAllData *) EAData;
		do {
			if (!stricmp(".doc", &ead->ed_Name[strlen(ead->ed_Name) - 4])) {

				// Autodoc entry, add name to listview.

				if (n = AllocNode(ead->ed_Name)) {

					n2 = GetHead(&doc_list);
					if (strcmp(n->ln_Name, n2->ln_Name) < 0)
						AddHead(&doc_list, n);
					else {
						while (n2) {
							if (n2->ln_Succ) {
								if (strcmp(n->ln_Name, n2->ln_Succ->ln_Name) < 0) {
									Insert(&doc_list, n, n2);
									break;
								}
							}
							n2 = GetSucc(n2);
						}
						if (!n2)
							AddTail(&doc_list, n);
					}
				}
			}
			ead = ead->ed_Next;
		} while (ead);
	} while (more);


	// We now enter our main event loop.

	if (main_proj = TR_OpenProjectTags(app,
								TRWI_Title,		"ADView",
								TRWI_Position,	TRWP_DEFAULT,
								TRWI_ID,		1,

								VertGroupA,
									Space,
									HorizGroupA,
										Space,
										NamedSeparatorN("Autodoc Reader"),
										Space,
									EndGroup,
									Space,
									HorizGroupA,
										Space,
										TROB_Listview,	&doc_list,
											TRAT_ID,	1,
											TRAT_Flags,	TRLV_SELECT,
										Space,
									EndGroup,
									Space,
								EndGroup,
							TAG_END)) {

		while (1) {

			ULONG sigs;

			sigs = TR_Wait(app, SIGBREAKF_CTRL_C);

			if (sigs & SIGBREAKF_CTRL_C)
				BreakFunction(0);

			while (trmsg = TR_GetMsg(app)) {

				switch(trmsg->trm_Class) {

					case TRMS_NEWVALUE:
						if (trmsg->trm_Project == main_proj) {
							n = GetHead(&doc_list);
							while (trmsg->trm_Data--)
								n = GetSucc(n);
							if (p = AllocProject(++id_count)) {
								DispatchAutodoc(n->ln_Name, p);
								if (p->proj_TRProject)
									AddTail(&proj_list, (struct Node *)p);
								else
									FreeProject(p);
							}
						}
						else {
							p = GetHead(&proj_list);
							while (p) {
								if (p->proj_TRProject == trmsg->trm_Project) {
									struct Project *new_p;
									if (new_p = AllocProject(++id_count)) {

										UBYTE *name, count = trmsg->trm_Data;

										n = GetHead(&p->proj_List);
										while (n) {
											if (count-- == 0) {
												name = n->ln_Name;
												break;
											}
											n = GetSucc(n);
										}

										DispatchEntry(p->proj_File, new_p, trmsg->trm_Data, name);
										if (p->proj_TRProject) {
											AddTail(&proj_list, (struct Node *)new_p);
										}
										else
											FreeProject(p);
									}
									break;
								}
								p = GetSucc(p);
							}
						}
						break;

					case TRMS_CLOSEWINDOW:
						if (trmsg->trm_Project == main_proj)
							BreakFunction(0);
						else {
							p = GetHead(&proj_list);
							while (p) {
								if (p->proj_TRProject == trmsg->trm_Project) {
									Remove((struct Node *)p);
									FreeProject(p);
									break;
								}
								p = GetSucc(p);
							}
						}
						break;

					case TRMS_ERROR:
						PutStr(TR_GetErrorString(trmsg->trm_Data));
						break;
				}
				TR_ReplyMsg(trmsg);
			}
		}
	}
}

void DispatchAutodoc(STRPTR docname, struct Project *p)
{
	struct Node *entry;
	UBYTE buf[256];

	if (p->proj_File = Open(docname, MODE_OLDFILE)) {
		do {
			ReadLine(p->proj_File, buf, 255);
		} while(buf[0] == '\0');

		if (!strcmp(buf, "TABLE OF CONTENTS")) {

			while (ReadLine(p->proj_File, buf, 255)) {
				if (buf[0] == 12)	// CTRL-L, first entry starts here.
					break;

				if (buf[0])
					if (entry = AllocNode(buf))
						AddTail(&p->proj_List, (struct Node *)entry);
			}

			if (!(p->proj_TRProject = TR_OpenProjectTags(app,
										TRWI_Title,		"Contents",
										TRWI_Underscore,"~",
										TRWI_Position,	TRWP_CENTERDISPLAY,
										TRWI_ID,		2,

										VertGroupA,
											Space,
											HorizGroupA,
												Space, NamedSeparatorN(docname), Space,
											EndGroup,
											Space,
											HorizGroupA,
												Space,
												TROB_Listview,		&p->proj_List,
													TRAT_Flags,		TRLV_SELECT,
												Space,
											EndGroup,
											Space,
										EndGroup,
									TAG_END)))
				TR_EasyRequestTags(app, "Could not open project window.", "Ok", TAG_END);
		}
		else
			TR_EasyRequest(app, "This is not an autodoc file!", "Ok", TAG_END);
	}
	else
		TR_EasyRequest(app, "Error opening file.", "Ok", TAG_END);
}

void DispatchEntry(BPTR file_handle, struct Project *p, ULONG count, STRPTR name)
{
	UBYTE ch, buf[256];
	ULONG oldpos, len = strlen(name);
	BOOL success = FALSE;
	struct Node *line;

	if (Seek(file_handle, 0L, OFFSET_BEGINNING) == -1)
		return;

	do {
		// Skip to next CTRL-L (12).

		do {
			ch = FGetC(file_handle);
			if (ch == -1) return;		// Unexpected EOF.
		} while(ch != 12);

		// We want the start of this entry in case we have to
		// go back to its beginning.

		oldpos = Seek(file_handle, 0, OFFSET_CURRENT);

		// It's possible the entry starts with a/some blank line(s).

		do {
			ReadLine(file_handle, buf, 255);
		} while(buf[0] == '\0');

		// Check lines against name until we reach a blank line or match.

		do {
			if (buf[0]) {
				if (!strncmp(name, buf, len))
					success = TRUE;
			}
			else
				break;

			ReadLine(file_handle, buf, 255);
		} while(!success);

		if (success) {	// We matched on this entry.
			Seek(file_handle, oldpos, OFFSET_BEGINNING);
			while (ReadLine(file_handle, buf, 255)) {
				if (buf[0] == 12)
					break;
				if (line = AllocNode(buf))
					AddTail(&p->proj_List, line);
			}
		}
	} while(!success);

	// We've loaded the autodoc entry, now display it.

	if (!(p->proj_TRProject = TR_OpenProjectTags(app,
										TRWI_Title,		"Entry",
										TRWI_Underscore,"~",
										TRWI_Position,	TRWP_CENTERDISPLAY,
										TRWI_ID,		3,

										VertGroupA,
											Space,
											HorizGroupA,
												Space, NamedSeparatorN(name), Space,
											EndGroup,
											Space,
											HorizGroupA,
												Space,
												TROB_Listview,		&p->proj_List,
													TRAT_Flags,		TRLV_READONLY | TRLV_FWFONT,
												Space,
											EndGroup,
											Space,
										EndGroup,
									TAG_END)))
		TR_EasyRequestTags(app, "Could not open project window.", "Ok", TAG_END);
}

struct Node *AllocNode(STRPTR name)
{
	struct Node *n;

	if (n = (struct Node *) AllocVec(sizeof(struct Node) + strlen(name) + 1, MEMF_CLEAR | MEMF_ANY)) {
		n->ln_Name = (UBYTE *)(n+1);
		strcpy(n->ln_Name, name);
	}
	return n;
}

struct Project *AllocProject(ULONG id)
{
	struct Project *p;

	if (p = (struct Project *) AllocVec(sizeof(struct Project), MEMF_CLEAR | MEMF_ANY)) {
		p->proj_ID = id;
		NewList(&p->proj_List);
	}
	return p;
}

void FreeProject(struct Project *p)
{
	struct Node *n;

	if (p->proj_TRProject)
		TR_CloseProject(p->proj_TRProject);

	while (n = GetHead(&p->proj_List)) {
		Remove(n);
		FreeVec(n);
	}

	if (p->proj_File)
		Close(p->proj_File);

	FreeVec(p);
}

STRPTR ReadLine(BPTR file, STRPTR buf, ULONG len)
{
	UBYTE ch, *s = buf, i;

	while ((ch = FGetC(file)) != -1) {
		if (ch == '\t') {
			for (i = 0; i < 8; i++)
				*s++ = ' ';
		}
		else if (ch == '\n')
			break;
		else
			*s++ = ch;
	}
	*s = '\0';

	if (ch == -1)
		return NULL;
	return buf;
}
