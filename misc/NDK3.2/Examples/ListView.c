;/*
sc ListView.c LINK NOSTACKCHECK
quit
*/

#include <stdlib.h>
#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <libraries/locale.h>
#include <utility/tagitem.h>
#include <dos/dos.h>

#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/scroller_protos.h>
#include <clib/listview_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/scroller_pragmas.h>
#include <pragmas/listview_pragmas.h>

#include <gadgets/scroller.h>
#include <gadgets/listview.h>

extern struct IntuitionBase* IntuitionBase;

/*****************************************************************************/

#define	IDCMP_FLAGS	IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY | IDCMP_GADGETUP

/*****************************************************************************/

/*****************************************************************************/

#define NUM_LABELS 100

UBYTE labels[NUM_LABELS][50] =
{
	" 0 ",
	" 1 This is a test of my radically super small",
	" 2 amazingly wonderfully and",
	" 3 stupendously cool new listview class.",
	" 4 ",
	" 5 It can't do all sorts of cool",
	" 6 stuff like columns, multi-select, images",
	" 7 and much much more!",
	" 8 ",
	" 9 Now I am just babbling on for no reason",
	"10 at all, other than to make this list",
	"11 longer so that I can look at how fast",
	"12 it scrolls and stuff. But I think this is",
	"13 long enough now so I'll stop.",
	"14 ",
	"15 This is a test of my radically",
	"16 super amazingly wonderfully and",
	"17 stupendously cool new listview class.",
	"18 ",
	"19 It can't do all sorts of cool",
	"20 stuff like columns, multi-select, images",
	"21 and much much more!",
	"22 ",
	"23 Now I am just babbling on for no reason",
	"24 at all, other than to make this list",
	"25 longer so that I can look at how fast",
	"26 it scrolls and stuff. But I think this is",
	"27 long enough now so I'll stop.",
	"28",
	"29 Well so far, this sucker flies....",
	"30",
	"31 This is a test of my radically super small",
	"32 amazingly wonderfully and",
	"33 stupendously cool new listview class.",
	"34 ",
	"35 It can't do all sorts of cool",
	"36 stuff like columns, multi-select, images",
	"37 and much much more!",
	"38 ",
	"39 Now I am just babbling on for no reason",
	"40 at all, other than to make this list",
	"41 longer so that I can look at how fast",
	"42 it scrolls and stuff. But I think this is",
	"43 long enough now so I'll stop.",
	"44 ",
	"45 This is a test of my radically",
	"46 super amazingly wonderfully and",
	"47 stupendously cool new listview class.",
	"48 ",
	"49 It can't do all sorts of cool",
	"50 stuff like columns, multi-select, images",
	"51 and much much more!",
	"52 ",
	"53 Now I am just babbling on for no reason",
	"54 at all, other than to make this list",
	"55 longer so that I can look at how fast",
	"56 it scrolls and stuff. But I think this is",
	"57 long enough now so I'll stop.",
	"58 ",
	"59 ",
	"60 ",
	"61 This is a test of my radically super small",
	"62 amazingly wonderfully and",
	"63 stupendously cool new listview class.",
	"64 ",
	"65 It can't do all sorts of cool",
	"66 stuff like columns, multi-select, images",
	"67 and much much more!",
	"68 ",
	"69 Now I am just babbling on for no reason",
	"70 at all, other than to make this list",
	"71 longer so that I can look at how fast",
	"72 it scrolls and stuff. But I think this is",
	"73 long enough now so I'll stop.",
	"74 ",
	"75 This is a test of my radically",
	"76 super amazingly wonderfully and",
	"77 stupendously cool new listview class.",
	"78 ",
	"79 It can't do all sorts of cool",
	"80 stuff like columns, multi-select, images",
	"81 and much much more!",
	"82 ",
	"83 Now I am just babbling on for no reason",
	"84 at all, other than to make this list",
	"85 longer so that I can look at how fast",
	"86 it scrolls and stuff. But I think this is",
	"87 long enough now so I'll stop.",
	"88",
	"89 Well so far, this sucker flies....",
	"90",
	"91 This is a test of my radically super small",
	"92 amazingly wonderfully and",
	"93 stupendously cool new listview class.",
	"94 ",
	"95 It can't do all sorts of cool",
	"96 stuff like columns, multi-select, images",
	"97 and much much more!",
	"98 ",
	"99 Now I am just babbling on for no reason"
};


/* Function to make an Exec List from an array.
 */
BOOL make_listview_list(struct List *list)
{
	struct ListLabelNode *node;
	LONG i = 0;
	BOOL ok = TRUE;

	NewList(list);

	while (i<NUM_LABELS)
	{
		node = (struct ListLabelNode *)AllocVec(sizeof(struct ListLabelNode), MEMF_ANY | MEMF_CLEAR);

		if (node)
		{
			node->lvn_RenderForeground = 1;
			node->lvn_RenderBackground = 0;

			node->lvn_SelectForeground = 2;
			node->lvn_SelectBackground = 3;

			node->lvn_Node.ln_Name = labels[i];
			node->lvn_Node.ln_Type = i;

			AddTail(list, (struct Node *)node);
		}
		else
		{
			ok = FALSE;
			break;
		}
		i++;
	}
	return(TRUE);
}


/* Function to free an Exec List.
 */
VOID free_listview_list(struct List *list)
{
	struct Node *node, *nextnode;

	node = list->lh_Head;
	while (nextnode = node->ln_Succ)
	{
		FreeVec(node);
		node = nextnode;
	}
	NewList(list);
}


/* Function to show selection state of nodes
 */
VOID show_listview_list(struct List *list)
{
	register int i = 0;
	struct Node *node;

	node = list->lh_Head;

	if(node)
	{
		do
		{
			if(node->ln_Pri)
				printf("Node #%3d: %d - %s\n",i++,node->ln_Pri, node->ln_Name);
			else
				printf("Node #%3d: %d\n",i++,node->ln_Pri);
	
			node = node->ln_Succ;
		}
		while(node);
	}

	NewList(list);
}

/*****************************************************************************/

/* Try opening the class library from a number of common places */
struct Library *openclass (STRPTR name, ULONG version)
{
 // struct ExecBase *SysBase = (*((struct ExecBase **) 4));
    struct Library *retval;
    UBYTE buffer[256];

    if ((retval = OpenLibrary (name, version)) == NULL)
    {
		sprintf (buffer, ":classes/%s", name);
		if ((retval = OpenLibrary (buffer, version)) == NULL)
		{
		    sprintf (buffer, "classes/%s", name);
		    retval = OpenLibrary (buffer, version);
		}
    }
    return retval;
}

/*****************************************************************************/

struct Library *ScrollerBase;
struct Library *ListViewBase;
struct List listview_list;


int main (int argc, char **argv)
{
	struct IntuiMessage *imsg;
	struct Screen *scr;
	struct Window *win;
	ULONG sigr;
	ULONG visible,top,total;
	BOOL going = TRUE;
	WORD ms = 1;

    struct Gadget *listview_gad;
 // struct Gadget *prop_gad;

	if (scr = LockPubScreen(NULL))
	{
		if (ListViewBase = openclass ("gadgets/listview.gadget", 0L))
		{
			if (win = OpenWindowTags (NULL,
				WA_Left, 20,
				WA_Top, scr->Font->ta_YSize + 20,
				WA_Width, 270,
				WA_Height, 140,
				WA_IDCMP, IDCMP_GADGETUP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY |
							IDCMP_CLOSEWINDOW | IDCMP_GADGETDOWN,
				WA_Flags, WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
							WFLG_SIZEGADGET | WFLG_ACTIVATE | WFLG_SIMPLE_REFRESH,
				WA_MinWidth, 75,
				WA_MinHeight, 75,
				WA_MaxWidth, -1,
				WA_MaxHeight, -1,
				WA_Title,		"ReAction listview.gadget Test",
				WA_SimpleRefresh,	TRUE,
				WA_NoCareRefresh,	TRUE,
				WA_CustomScreen,	scr,
				TAG_DONE))
			{
				printf("Creating List...\n");

				/* Create the listview list
				 */
				make_listview_list(&listview_list);

				printf("Created\n");
		
				if (listview_gad = (struct Gadget *)NewObject(LISTVIEW_GetClass(), NULL,
					GA_ID, 1,
					GA_Top, (win->BorderTop) + 3L,
					GA_Left, (win->BorderLeft) + 6L,
					GA_RelHeight, -((win->BorderTop + win->BorderBottom) + 6L),
					GA_RelWidth, -((win->BorderLeft + win->BorderRight) + 10L),
					GA_RelVerify, TRUE,

					LISTVIEW_Labels, &listview_list,
					LISTVIEW_Top, 0,
					LISTVIEW_MultiSelect, TRUE,
					TAG_DONE))
				{
					AddGList(win, listview_gad, -1, -1, NULL);

					RefreshGList(listview_gad, win, NULL, -1);
		
					while (going)
					{
						sigr = Wait ((1L << win->UserPort->mp_SigBit | SIGBREAKF_CTRL_C));
		
						if (sigr & SIGBREAKF_CTRL_C)
							going = FALSE;
		
						while (imsg = (struct IntuiMessage *) GetMsg (win->UserPort))
						{
							switch (imsg->Class)
							{
								case IDCMP_CLOSEWINDOW:
									going = FALSE;
									break;
		
								case IDCMP_VANILLAKEY:
									switch (imsg->Code)
									{
										case 'u':
											SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_ScrollUp, 1, TAG_DONE);
											break;
	
										case 'j':
											SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_ScrollDown, 1, TAG_DONE);
											break;
	
										case 'U':
											GetAttr(LISTVIEW_Visible,listview_gad,&visible);
											GetAttr(LISTVIEW_Top,listview_gad,&top);
											SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_Top, top-visible, TAG_DONE);
											break;
	
										case 'J':
											GetAttr(LISTVIEW_Visible,listview_gad,&visible);
											GetAttr(LISTVIEW_Top,listview_gad,&top);
											SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_Top, top+visible, TAG_DONE);
											break;
	
										case 'C':	// doesn't correctly work yet...
											GetAttr(LISTVIEW_Total,listview_gad,&total);
											SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_Top, (total/2), TAG_DONE);
											break;
	
										case 'm':
										case 'M':
											ms ^= 1;
											SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_MultiSelect, ms, TAG_DONE);
											break;
#if 0
										case '0':
											if ( SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_Spacing, 0, TAG_DONE) )
											{
												RefreshGList(listview_gad, win, NULL, 1L);
											}
											break;

										case '1':
											if ( SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_Spacing, 1, TAG_DONE) )
											{
												RefreshGList(listview_gad, win, NULL, 1L);
											}
											break;

										case '2':
											if ( SetGadgetAttrs(listview_gad, win, NULL,
												LISTVIEW_Spacing, 2, TAG_DONE) )
											{
												RefreshGList(listview_gad, win, NULL, 1L);
											}
											break;
#endif
										case 'd':
										case 'D':
											if ( SetGadgetAttrs(listview_gad, win, NULL,
												GA_Disabled, TRUE, TAG_DONE) )
											{
												RefreshGList(listview_gad, win, NULL, 1L);
											}
											break;

										case 'e':
										case 'E':
											if ( SetGadgetAttrs(listview_gad, win, NULL,
												GA_Disabled, FALSE, TAG_DONE) )
											{
												RefreshGList(listview_gad, win, NULL, 1L);
											}
											break;

										case  27:
										case 'q':
										case 'Q':
											going = FALSE;
											break;
									}
									break;	
							}
							ReplyMsg ((struct Message *) imsg);
						}
					}

					RemoveGList(win, listview_gad, -1);
					DisposeObject(listview_gad);
				}
				
				CloseWindow (win);

				//show_listview_list(&listview_list);

				free_listview_list(&listview_list);
			}
			else
			{
				puts ("\nCouldn't open the window\n");
			}
		    UnlockPubScreen(0, scr);
			CloseLibrary ((struct Library *) ListViewBase);
		}	
		else
		{
			puts ("\ncouldn't open listview.gadget\n");
		}
	}

	exit(0);
}

