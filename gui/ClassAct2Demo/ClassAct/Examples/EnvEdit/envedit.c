
/**
 **  EnvEdit.c -- Environmental variable editor.
 **
 **  This is a cute little tool to edit your environmental variables with a
 **  GUI.  Seen a dozen of these already have you eh?  Well, this one is
 **  different.  It uses a hierarchical listbrowser, so you can not only
 **  see simple environmental variables, but also ones buried deep in
 **  directories (we'll call those directories "records", since these are
 **  supposed to be variables).  Also, we do not have to call an external
 **  text editor to edit the value of variables, not are we limited to
 **  one-line variables because we use textfield for editing variables.
 **
 **  With all that said, there are somethings missing: the ability to delete,
 **  rename and create variables.  Think of this as an exercise in learning
 **  ClassAct, to add these features (and send us the source when you're
 **  done :).
 **
 **/

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/exall.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>
#include <utility/tagitem.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/icon.h>
#include <proto/intuition.h>
#include <classact.h>
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>

/* #define D(x) x to compile with debugging output.
 */
#define D(x)

#ifdef _DCC
#define SAVEDS __geta4
#define ASM
#define REG_A0 __A0
#define REG_A1 __A1
#else
#define SAVEDS __saveds
#define ASM __asm
#define REG_A0 register __a0
#define REG_A1 register __a1
#endif

enum { GAD_LIST, GAD_EDIT, GAD_SAVE, GAD_USE, GAD_CANCEL };

/* ARexx command IDs
 */
enum { REXX_NAME, REXX_VERSION, REXX_AUTHOR, REXX_ACTIVATE, REXX_DEACTIVATE,
		REXX_QUIT, REXX_WINDOWTOBACK, REXX_WINDOWTOFRONT };



/* Some additional info we put in listbrowser node userdata field.
 */
struct LBUserData
{
	UBYTE lbud_FileName[255];
	BOOL lbud_Changed;
	STRPTR lbud_Buf;
	ULONG lbud_BufSize;
};


/* Function prototypes.
 */
VOID load_text(struct Window *);
LONG file_size(char *);
VOID save_changed(struct List *, STRPTR, BOOL);
BOOL read_files(struct List *, STRPTR, WORD);
VOID bstrcpy(STRPTR, BSTR);
VOID free_list(struct List *);
LONG easy_req(struct Window *, char *, char *, char *, ...);
VOID ASM rexx_name(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_version(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_author(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_activate(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_deactivate(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_quit(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_about(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_windowtoback(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_windowtofront(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);

/* Global variables.
 */
struct List file_list;
struct Gadget *layout, *list_gad, *edit_gad;
struct DrawInfo *drinfo;
Object *window_obj;
struct Window *win;
BOOL ok = TRUE;

struct ColumnInfo ci[] =
{
	{ 75, "Variable", 0 },
	{ 25, "Size", 0 },
	{ 75, "Date", 0 },
	{ 25, "Time", 0 },
	{ -1, (STRPTR)~0, -1 }
};

/* ARexx command table.  These commands may not seem terribly useful at first,
 * but these are a basic set of commands that every app should support.
 */
struct ARexxCmd arexx_cmds[] =
{
	{ "NAME",			REXX_NAME,			rexx_name,			NULL,		NULL, },
	{ "VERSION",		REXX_VERSION,		rexx_version,		NULL,		NULL, },
	{ "AUTHOR",			REXX_AUTHOR,		rexx_author,		NULL,		NULL, },
	{ "ACTIVATE",		REXX_ACTIVATE,		rexx_activate,		NULL,		NULL, },
	{ "DEACTIVATE",		REXX_DEACTIVATE,	rexx_deactivate,	NULL,		NULL, },
	{ "QUIT",			REXX_QUIT,			rexx_quit,			NULL,		NULL, },
	{ "WINDOWTOBACK",	REXX_WINDOWTOBACK,	rexx_windowtoback,	NULL,		NULL, },
	{ "WINDOWTOFRONT",	REXX_WINDOWTOFRONT,	rexx_windowtofront,	NULL,		NULL, },
	{ NULL,				NULL,				NULL,				NULL,		NULL, }
};


/* Custom leaf/show/hide images for the hierarchy control.
 */
__chip UWORD leaf_data[27] =
{
	/* Plane 0 */
	0x0800, 0x1C00, 0x3600, 0x6B00,
	0xD580, 0x6B00, 0x3600, 0x1C00,
	0x0800,
	/* Plane 1 */
	0x0800, 0x1800, 0x3400, 0x6A00,
	0xD500, 0x6A00, 0x3400, 0x1800,
	0x0000,
};

struct Image leaf_image =
{
	0, 0, 9, 9, 2, &leaf_data[0], 0x3, 0x0, NULL
};

__chip UWORD show_data[27] =
{
	/* Plane 0 */
	0x7C00, 0xD600, 0xABC0, 0x8020,
	0xD560, 0xAAA0, 0xD560, 0xAAA0,
	0x7FC0,
	/* Plane 1 */
	0x7C00, 0xD600, 0xABC0, 0x8000,
	0xD540, 0xAA80, 0xD540, 0xAA80,
	0x0000,
};

struct Image show_image =
{
	0, 0, 11, 9, 2, &show_data[0], 0x3, 0x0, NULL
};

__chip UWORD hide_data[27] =
{
	/* Plane 0 */
	0x7C00, 0xD600, 0xABC0, 0xFFF0,
	0xF558, 0xEAA8, 0xD550, 0xFFE0,
	0x7FC0,
	/* Plane 1 */
	0x7C00, 0xD600, 0xABC0, 0xAFF0,
	0xD550, 0xAAA0, 0xD540, 0xFFC0,
	0x0000,
};

struct Image hide_image =
{
	0, 0, 13, 9, 2, &hide_data[0], 0x3, 0x0, NULL
};


/* This is the start of our programme.
 */
#ifdef _DCC
wbmain() { main(); }
#endif

main()
{
	struct Screen *screen = NULL;

	if (!ButtonBase) return(20);

	/* We'll just open up on the default public screen, and use its screen font.
	 */
	if (screen = LockPubScreen(NULL))
	{
		UWORD mapping[4];

		drinfo = GetScreenDrawInfo(screen);

		NewList(&file_list);
		read_files(&file_list, "ENV:", 1);

		/* Setup a simple mapping.
		 */
		mapping[0] = drinfo->dri_Pens[BACKGROUNDPEN];
		mapping[1] = drinfo->dri_Pens[SHADOWPEN];
		mapping[2] = drinfo->dri_Pens[SHINEPEN];
		mapping[3] = drinfo->dri_Pens[FILLPEN];

		/* Do the layout.
		 */
		if (layout = LayoutObject,
							GA_DrawInfo, drinfo,
							ICA_TARGET, ICTARGET_IDCMP,
							LAYOUT_DeferLayout, TRUE,

							LAYOUT_SpaceOuter, TRUE,
							LAYOUT_Orientation, LAYOUT_ORIENT_VERT,
							LAYOUT_HorizAlignment, LAYOUT_ALIGN_CENTER,

							LAYOUT_AddChild, list_gad = ListBrowserObject,
								GA_ID, GAD_LIST,
								GA_RelVerify, TRUE,
								LISTBROWSER_Labels, (ULONG)&file_list,
								LISTBROWSER_ColumnInfo, (ULONG)&ci,
								LISTBROWSER_ColumnTitles, TRUE,
								LISTBROWSER_ShowSelected, TRUE,
								LISTBROWSER_Separators, FALSE,
								LISTBROWSER_Hierarchical, TRUE,
								LISTBROWSER_LeafImage, &leaf_image,
								LISTBROWSER_ShowImage, &show_image,
								LISTBROWSER_HideImage, &hide_image,
								LISTBROWSER_AutoFit, TRUE,
								ListBrowserEnd,
							CHILD_WeightedHeight, 100,

							LAYOUT_AddChild, edit_gad = TextFieldObject,
								GA_ID, GAD_EDIT,
								GA_RelVerify, TRUE,
								TEXTFIELD_Border, TEXTFIELD_BORDER_DOUBLEBEVEL,
								TextFieldEnd,
							CHILD_MinHeight, screen->Font->ta_YSize + 6,
							CHILD_WeightedHeight, 50,

							LAYOUT_AddChild, LayoutObject,
								LAYOUT_Orientation, LAYOUT_ORIENT_HORIZ,
								LAYOUT_EvenSize, TRUE,
	
								LAYOUT_AddChild, ButtonObject,
									GA_ID, GAD_SAVE,
									GA_Text, "_Save",
									GA_RelVerify, TRUE,
									ButtonEnd,
								CHILD_NominalSize, TRUE,
								CHILD_WeightedWidth, 0,

								LAYOUT_AddChild, ButtonObject,
									GA_ID, GAD_USE,
									GA_Text, "_Use",
									GA_RelVerify, TRUE,
									ButtonEnd,
								CHILD_NominalSize, TRUE,
								CHILD_WeightedWidth, 0,

								LAYOUT_AddChild, ButtonObject,
									GA_ID, GAD_CANCEL,
									GA_Text, " _Cancel ",
									GA_RelVerify, TRUE,
									ButtonEnd,
								CHILD_NominalSize, TRUE,
								CHILD_WeightedWidth, 0,

								LayoutEnd,
							CHILD_WeightedHeight, 0,
							LayoutEnd)
		{
			struct MsgPort *app_port;

			/* Create a message port for App* messages.  This is needed for
			 * iconification.  We're being a touch naughty by not checking
			 * the return code, but that just means that iconification won't
			 * work, nothing really bad will happen.
			 */
			app_port = CreateMsgPort();

			/* Create the window object.
			 */
			if (window_obj = WindowObject,
								WA_Left, 0,
								WA_Top, screen->Font->ta_YSize + 3,
								WA_CustomScreen, screen,
								WA_IDCMP, IDCMP_CLOSEWINDOW,
								WA_Flags, WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
											WFLG_SIZEGADGET | WFLG_ACTIVATE | WFLG_SMART_REFRESH,
								WA_Title, "Environmental Variable Editor",
								WA_NewLookMenus, TRUE,
								WINDOW_ParentGroup, layout,
								WINDOW_IconifyGadget, TRUE,
								WINDOW_Icon, GetDiskObject("PROGDIR:EnvEdit"),
								WINDOW_IconTitle, "EnvEdit",
								WINDOW_AppPort, app_port,
								TAG_DONE))
			{
				/* Increase the initial hieght.
				 */
				SetAttrs(window_obj,
					WA_InnerHeight, screen->Font->ta_YSize * 16,
					TAG_DONE);

				/*  Open the window.
				 */
				if (win = (struct Window *)CA_OpenWindow(window_obj))
				{
					Object *arexx_obj;

					/* Create host object.
					 */
					if (arexx_obj = ARexxObject,
										AREXX_HostName, "ENVEDIT",
										AREXX_Commands, arexx_cmds,
										ARexxEnd)
					{
						/* Input Event Loop
						 */
						while (ok)
						{
							ULONG signal, winsig, rxsig;
							ULONG result;
	
							/* Obtain the window and ARexx wait signal masks.
							 */
							GetAttr(WINDOW_SigMask, window_obj, &winsig);
							GetAttr(AREXX_SigMask, arexx_obj, &rxsig);		
	
							signal = Wait(rxsig | winsig | (1L << app_port->mp_SigBit) | SIGBREAKF_CTRL_C);
	
							/* ARexx event?
							 */
							if (signal & rxsig)
								CA_HandleRexx(arexx_obj);

							/* Window event?
							 */
							if (signal & winsig)
							{
								/* CA_HandleInput() returns the gadget ID of a clicked
								 * gadget, or one of several pre-defined values.  For
								 * this demo, we're only actually interested in a
								 * close window and a couple of gadget clicks.
								 */
								while ((result = CA_HandleInput(window_obj, NULL)) != WMHI_LASTMSG)
								{
									switch(result & WMHI_CLASSMASK)
									{
										case WMHI_CLOSEWINDOW:
											ok = FALSE;
											break;
		
										case WMHI_GADGETUP:
											switch (result & WMHI_GADGETMASK)
											{
												case GAD_LIST:
													D( PutStr("Load text\n"); )
													load_text(win);
													break;
		
												case GAD_EDIT:
													D( PutStr("Text edited\n"); )
													{
														struct Node *node;
		
														GetAttr(LISTBROWSER_SelectedNode, list_gad, (ULONG *)&node);
														if (node)
														{
															struct LBUserData *lbud;
															ULONG flags;
		
															/* Gotta change a flag in
															 * our special user data
															 * structure.
															 */
															GetListBrowserNodeAttrs(node,
																LBNA_Flags, &flags,
																LBNA_UserData, &lbud,
																TAG_DONE);
															if (lbud && !(flags & LBFLG_HASCHILDREN))
																lbud->lbud_Changed = TRUE;
														}
													}
													break;
		
												case GAD_SAVE:
													save_changed(&file_list, "ENV:", TRUE);
													save_changed(&file_list, "ENVARC:", FALSE);
													ok = FALSE;
													break;
		
												case GAD_USE:
													save_changed(&file_list, "ENV:", FALSE);
													ok = FALSE;
													break;
		
												case GAD_CANCEL:
													ok = FALSE;
													break;
		
												default:
													break;
											}
											break;
		
										case WMHI_ICONIFY:
											if (CA_Iconify(window_obj))
												win = NULL;
											break;
									 
										case WMHI_UNICONIFY:
											win = CA_OpenWindow(window_obj);
											break;
		
										default:
											break;
									}
								}
							}
							/* CTRL-C should quit.
							 */
							if (signal & SIGBREAKF_CTRL_C)
							{
								ok = FALSE;
							}
						}
						/* Free up ARexx.
						 */
						DisposeObject(arexx_obj);
					}
					else
						easy_req(NULL, "EnvEdit failed to start\nCouldn't create ARexx host", "Quit", "");
 				}
				else
					easy_req(NULL, "EnvEdit failed to start\nCouldn't open window", "Quit", "");

				/* Disposing of the window object will also close the
				 * window if it is already opened and it will dispose of
				 * all objects attached to it.
				 */
				DisposeObject(window_obj);
			}
			else
				easy_req(NULL, "EnvEdit failed to start\nCouldn't create window", "Quit", "");

			/* Lose the App* message port.
			 */
			if (app_port)
				DeleteMsgPort(app_port);
		}
		else
			easy_req(NULL, "EnvEdit failed to start\nCouldn't create layout", "Quit", "");

		free_list(&file_list);

		if (drinfo)
			FreeScreenDrawInfo(screen, drinfo);

	    UnlockPubScreen(0, screen);
	}
	else
		easy_req(NULL, "EnvEdit failed to start\nCouldn't lock destination screen", "Quit", "");

	exit(0);
}


/* Load text for the currently selected item in the variable list into the
 * textfield gadget.
 */
VOID load_text(struct Window *win)
{
	struct Node *node;

	SetGadgetAttrs(edit_gad, win, NULL,
		TEXTFIELD_Text, "",
		TAG_DONE);

	/* Get the selected node.
	 */
	GetAttr(LISTBROWSER_SelectedNode, list_gad, (ULONG *)&node);
	if (node)
	{
		struct LBUserData *lbud;
		ULONG flags;

		/* We stashed some important info in the userdata, so get that.
		 */
		GetListBrowserNodeAttrs(node,
			LBNA_Flags, &flags,
			LBNA_UserData, &lbud,
			TAG_DONE);
		if (lbud && !(flags & LBFLG_HASCHILDREN))
		{
			/* Open up the file for read.
			 */
			if (lbud->lbud_FileName)
			{
				LONG size;

				/* Found out how big the file is.
				 */
				if (size = file_size(lbud->lbud_FileName))
				{
					BPTR fh;

					/* Open up the file for read.
					 */
					if (fh = Open(lbud->lbud_FileName, MODE_OLDFILE))
					{
						/* Allocate a buffer large enough to load the whole
						 * file into, if we don't already have one big enough.
						 */
						if (size > lbud->lbud_BufSize)
						{
							if (lbud->lbud_Buf)
								FreeVec(lbud->lbud_Buf);
							lbud->lbud_Buf = (STRPTR)AllocVec(size + 1, MEMF_ANY);
							lbud->lbud_BufSize = size + 1;
						}
						
						if (lbud->lbud_Buf)
						{
							/* Go ahead and load our text in.
							 */
							lbud->lbud_BufSize = Read(fh, lbud->lbud_Buf, size);
							lbud->lbud_Buf[lbud->lbud_BufSize] = '\0';

							/* Tell the edit gadget to display it.
							 */
							SetGadgetAttrs(edit_gad, win, NULL,
								TEXTFIELD_Text, lbud->lbud_Buf,
								TAG_DONE);
						}
						else
						{
							D( PutStr("No buffer\n"); )
							lbud->lbud_BufSize = 0;
						}

						Close(fh);
					}
					D( else PutStr("Can't open file\n"); )
				}
				D( else PutStr("No file size\n"); )
			}
			D( else PutStr("No filename\n"); )
		}
		else if (flags & LBFLG_HASCHILDREN)
		{
			ULONG relevent;

			GetAttr(LISTBROWSER_RelEvent, list_gad, &relevent);
			if (relevent != LBRE_SHOWCHILDREN && relevent != LBRE_HIDECHILDREN)
			{
				SetGadgetAttrs(list_gad, win, NULL,
					LISTBROWSER_Labels, ~0,
					TAG_DONE);

				if (flags & LBFLG_SHOWCHILDREN)
					HideListBrowserNodeChildren(node);
				else
					ShowListBrowserNodeChildren(node, 1);

				SetGadgetAttrs(list_gad, win, NULL,
					LISTBROWSER_Labels, &file_list,
					TAG_DONE);
			}
		}
	}
	D( else PutStr("No selected node\n"); )
}

/* Get the file size (in bytes) of a file.
 */
LONG file_size(char *filename)
{
	BPTR lock;
	LONG size = -1;

	if (lock = Lock(filename, ACCESS_READ))
	{
		struct FileInfoBlock *fib;

		if (fib = (struct FileInfoBlock *)AllocDosObject(DOS_FIB,TAG_END))
		{
			if (Examine(lock, fib))
				size = fib->fib_Size;
			FreeDosObject(DOS_FIB, fib);
		}
		UnLock(lock);
	}
	return(size);
}


/* Save all changed variables to the specified directory.
 */
VOID save_changed(struct List *list, STRPTR dir, BOOL nochange)
{
	struct Node *node;

	/* Peruse all nodes.
	 */
	for (node = list->lh_Head; node->ln_Succ; node = node->ln_Succ)
	{
		struct LBUserData *lbud;
		ULONG flags;

		/* Get our user data structure.
		 */
		GetListBrowserNodeAttrs(node,
			LBNA_Flags, &flags,
			LBNA_UserData, &lbud,
			TAG_DONE);
		if (lbud && !(flags & LBFLG_HASCHILDREN))
		{
			/* See if the node has changed and if we have a filename
			 * and if we have a buffer.
			 */
			if (lbud->lbud_Changed && lbud->lbud_FileName)
			{
				UBYTE open_file[255];
				BPTR fh;

				/* Convert the filename.
				 */
				sprintf(open_file, "%s%s", dir, lbud->lbud_FileName + 4);

				/* Try and open the file for write.
				 */
				if (fh = Open(open_file, MODE_NEWFILE))
				{
					if (lbud->lbud_BufSize == Write(fh, lbud->lbud_Buf, lbud->lbud_BufSize))
						lbud->lbud_Changed = nochange;
					Close(fh);
				}
			}
		}
	}
}


/* Read files in a directory to a listbrowser list.
 */
BOOL read_files(struct List *list, STRPTR dir, WORD generation)
{
	BPTR lock;

	D( Printf("Read directory: %s\n", dir); )

	if (lock = Lock(dir, ACCESS_READ))
	{
		char *eadata;

		if (eadata = (char *)AllocVec(sizeof(struct ExAllData) * 200, MEMF_CLEAR))
		{
			struct ExAllControl *eac;

			if (eac = (struct ExAllControl *)AllocDosObject(DOS_EXALLCONTROL, NULL))
			{
				BOOL more;

				eac->eac_LastKey = 0;
				do
				{
					struct ExAllData *ead;

					more = ExAll(lock, eadata, sizeof(struct ExAllData) * 200, ED_DATE, eac);
					if (!more && IoErr() != ERROR_NO_MORE_ENTRIES)
						return(FALSE);

					if (eac->eac_Entries == 0)
						return(FALSE);

					ead = (struct ExAllData *)eadata;
					do
					{
						struct Node *node;
						struct DateTime dat;
						char temp1[255], temp2[12], temp3[12], temp4[12];
						ULONG flags = LBFLG_CUSTOMPENS;

						if (ead->ed_Type == ST_USERDIR)
						{
							flags |= LBFLG_HASCHILDREN;
							strcpy(temp2, "Record");
						}
						else
							sprintf(temp2, "%ld", ead->ed_Size);

						if (generation > 1)
							flags |= LBFLG_HIDDEN;

						/* Convert the date and time to strings.
						 */
						dat.dat_Stamp.ds_Days = ead->ed_Days;
						dat.dat_Stamp.ds_Minute = ead->ed_Mins;
						dat.dat_Stamp.ds_Tick = ead->ed_Ticks;
						dat.dat_Flags = 0;
						dat.dat_StrDate = temp3;
						dat.dat_StrTime = temp4;
						dat.dat_StrDay = NULL;

						if (!DateToStr(&dat))
							temp3[0] = temp4[0] = '\0';

						if (node = AllocListBrowserNode(4,
										LBNA_Column, 0,
											LBNCA_CopyText, TRUE,
											LBNCA_Text, ead->ed_Name,
											LBNCA_FGPen, drinfo->dri_Pens[TEXTPEN],
										LBNA_Column, 1,
											LBNCA_CopyText, TRUE,
											LBNCA_Text, temp2,
											LBNCA_FGPen, (ead->ed_Type == ST_USERDIR? drinfo->dri_Pens[HIGHLIGHTTEXTPEN] : drinfo->dri_Pens[TEXTPEN]),
											LBNCA_Justification, LCJ_RIGHT,
										LBNA_Column, 2,
											LBNCA_CopyText, TRUE,
											LBNCA_Text, temp3,
											LBNCA_FGPen, drinfo->dri_Pens[TEXTPEN],
										LBNA_Column, 3,
											LBNCA_CopyText, TRUE,
											LBNCA_Text, temp4,
											LBNCA_FGPen, drinfo->dri_Pens[TEXTPEN],
										LBNA_Generation, generation,
										LBNA_Flags, flags,
										TAG_DONE))
						{
							struct LBUserData *lbud;

							AddTail(list, (struct Node *)node);

							strcpy(temp1, dir);
							AddPart(temp1, ead->ed_Name, 255);

							if (lbud = (struct LBUserData *)AllocVec(sizeof(struct LBUserData), MEMF_CLEAR))
							{
								strcpy(lbud->lbud_FileName, temp1);

								SetListBrowserNodeAttrs(node,
									LBNA_UserData, lbud,
									TAG_DONE);
							}

							if (ead->ed_Type == ST_USERDIR)
							{
								read_files(list, temp1, generation + 1);
							}
						}

						ead = ead->ed_Next;
					} while (ead);
				} while (more);

				FreeDosObject(DOS_EXALLCONTROL, eac);
			}
			else
				return(FALSE);
			FreeVec(eadata);
		}
		else
			return(FALSE);
		UnLock(lock);
	}
	else
		return(FALSE);

	return(TRUE);
}


/* Copy a B string to a C string.
 */
VOID bstrcpy(STRPTR cstr, BSTR bstr)
{
	strncpy(cstr, (char *)BADDR(bstr) + 1, ((char *)BADDR(bstr))[0]);
	cstr[((char *)BADDR(bstr))[0]] = '\0';
}


/* Function to free an Exec List.
 */
VOID free_list(struct List *list)
{
	struct Node *node, *nextnode;

	node = list->lh_Head;
	while (nextnode = node->ln_Succ)
	{
		struct LBUserData *lbud;

		GetListBrowserNodeAttrs(node,
			LBNA_UserData, &lbud,
			TAG_DONE);
		if (lbud)
			if (lbud->lbud_Buf);
				FreeVec(lbud->lbud_Buf);

		FreeListBrowserNode(node);
		node = nextnode;
	}
	NewList(list);
}


/* Do an easy requester.
 */
LONG easy_req(struct Window *win, char *reqtext, char *reqgads, char *reqargs, ...)
{
	struct EasyStruct general_es =
	{
		sizeof(struct EasyStruct),
		0,
		"SBGen",
		NULL,
		NULL
	};

	general_es.es_TextFormat = reqtext;
	general_es.es_GadgetFormat = reqgads;

	return(EasyRequestArgs(win, &general_es, NULL, &reqargs));
}

/* NAME
 */
VOID SAVEDS ASM rexx_name(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	ac->ac_Result = "EnvEdit";
}

/* VERSION
 */
VOID SAVEDS ASM rexx_version(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	ac->ac_Result = "1.0";
}

/* AUTHOR
 */
VOID SAVEDS ASM rexx_author(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	ac->ac_Result = "Timothy Aston";
}

/* DEACTIVATE
 */
VOID SAVEDS ASM rexx_deactivate(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	if (CA_Iconify(window_obj))
		win = NULL;
}

/* ACTIVATE
 */
VOID SAVEDS ASM rexx_activate(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	win = CA_OpenWindow(window_obj);
}

/* QUIT
 */
VOID SAVEDS ASM rexx_quit(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	ok = FALSE;
}

/* 
 */
VOID SAVEDS ASM rexx_windowtoback(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	WindowToBack(win);
}

/* WINDOWTOFRONT
 */
VOID SAVEDS ASM rexx_windowtofront(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	WindowToFront(win);
}
