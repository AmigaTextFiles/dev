;/* Execute me to compile with DICE V3.0
dcc testpopbutton.c -3.0 -mi -ms -proto -lpopbuttonclass.o -lbgui -ldebug
quit
*/
/*
 *	TESTPOPBUTTON.C
 *
 *	(C) Copyright 1995 Jaba Development.
 *	(C) Copyright 1995 Jan van den Baard.
 *	    All Rights Reserved.
 */

#include <exec/types.h>
#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/bgui.h>
#include <proto/dos.h>
#include <proto/utility.h>

#include "popbuttonclass.h"

/*
 *	Object ID.
 */
#define ID_QUIT                 1
#define ID_POPMENU1		2
#define ID_POPMENU2		3
#define ID_POPMENU3		4

/*
 *	Menu entries.
 */
struct PopMenu Project[] = {
	"New",          0, 0,
	"Open...",      0, 0,
	PMB_BARLABEL,	0, 0,
	"Save",         0, 0,
	"Save As...",   0, 0,
	PMB_BARLABEL,	0, 0,
	"Print",        0, 0,
	"Print As...",  0, 0,
	PMB_BARLABEL,	0, 0,
	"About...",     0, 0,
	PMB_BARLABEL,	0, 0,
	"Quit",         0, 0,
	NULL,		0, 0 };

struct PopMenu	Edit[] = {
	"Cut",          0, 0,
	"Copy",         0, 0,
	"Paste",        0, 0,
	PMB_BARLABEL,	0, 0,
	"Erase",        0, 0,
	NULL,		0, 0 };

/*
 *	This menu has checkable items and mutual exclusion.
 *
 *	The first item will mutually-exclude the last
 *	four items and any of the last four items will
 *	mutually-exclude the first item.
 */
struct PopMenu	Exclude[] = {
	"Uncheck below",        PMF_CHECKIT,                    (1<<2)|(1<<3)|(1<<4)|(1<<5),
	PMB_BARLABEL,		0,				0,
	"Item 1",               PMF_CHECKIT|PMF_CHECKED,        (1<<0),
	"Item 2",               PMF_CHECKIT|PMF_CHECKED,        (1<<0),
	"Item 3",               PMF_CHECKIT|PMF_CHECKED,        (1<<0),
	"Item 4",               PMF_CHECKIT|PMF_CHECKED,        (1<<0),
	NULL,			0,				0
};

/*
 *	Library base and class base.
 */
struct Library *BGUIBase;
Class	       *PMBClass;

/*
 *	Put up a simple requester.
 */
ULONG Req( struct Window *win, UBYTE *gadgets, UBYTE *body, ... )
{
	struct bguiRequest	req = { NULL };

	req.br_GadgetFormat	= gadgets;
	req.br_TextFormat	= body;
	req.br_Flags		= BREQF_CENTERWINDOW|BREQF_AUTO_ASPECT|BREQF_LOCKWINDOW|BREQF_FAST_KEYS;

	return( BGUI_RequestA( win, &req, ( ULONG * )( &body + 1 )));
}

int main( int argc, char **argv )
{
	struct Window		*window;
	Object			*WO_Window, *GO_Quit, *GO_PMB, *GO_PMB1, *GO_PMB2;
	ULONG			 signal, rc, tmp = 0;
	UBYTE			*txt;
	BOOL			 running = TRUE;

	/*
	 *	Open BGUI.
	 */
	if ( BGUIBase = OpenLibrary( BGUINAME, BGUIVERSION )) {
		/*
		 *	Initialize the popbuttonclass.
		 */
		if ( PMBClass = InitPMBClass()) {
			/*
			 *	Create the popmenu buttons.
			 */
			GO_PMB	= NewObject( PMBClass, NULL, PMB_MenuEntries,	 Project,
							     /*
							      *         Let this one activate
							      *         the About item.
							      */
							     PMB_PopPosition,	 9,
							     LAB_Label,          "_Project",
							     LAB_Underscore,	 '_',
							     GA_ID,		 ID_POPMENU1,
							     TAG_END );

			GO_PMB1 = NewObject( PMBClass, NULL, PMB_MenuEntries,	 Edit,
							     LAB_Label,          "_Edit",
							     LAB_Underscore,	 '_',
							     GA_ID,		 ID_POPMENU2,
							     TAG_END );

			GO_PMB2 = NewObject( PMBClass, NULL, PMB_MenuEntries,	 Exclude,
							     LAB_Label,          "E_xclude",
							     LAB_Underscore,	 '_',
							     GA_ID,		 ID_POPMENU3,
							     TAG_END );
			/*
			 *	Create the window object.
			 */
			WO_Window = WindowObject,
				WINDOW_Title,		"PopButtonClass Demo",
				WINDOW_AutoAspect,	TRUE,
				WINDOW_SmartRefresh,	TRUE,
				WINDOW_RMBTrap,         TRUE,
				WINDOW_MasterGroup,
					VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
						GROUP_BackFill,         SHINE_RASTER,
						StartMember,
							HGroupObject, Spacing( 4 ), HOffset( 6 ), VOffset( 4 ),
								NeXTFrame,
								FRM_BackDriPen,         FILLPEN,
								StartMember, GO_PMB, FixMinWidth, EndMember,
								StartMember, VertSeparator, EndMember,
								StartMember, GO_PMB1, FixMinWidth, EndMember,
								StartMember, VertSeparator, EndMember,
								StartMember, GO_PMB2, FixMinWidth, EndMember,
								StartMember, VertSeparator, EndMember,
							EndObject, FixMinHeight,
						EndMember,
						StartMember,
							InfoFixed( NULL, ISEQ_C
									 "This demonstrates the usage of the \"PopButtonClass\"\n"
									 "When you click inside the above popmenu buttons a small\n"
									 "popup-menu will appear which you can choose from.\n\n"
									 "You can also key-activate the menus and browse though the\n"
									 "items using the cursor up and down keys. Return or Enter\n"
									 "acknowledges the selection and escape cancels it.",
									 NULL, 7 ),
						EndMember,
						StartMember,
							HGroupObject,
								VarSpace( DEFAULT_WEIGHT ),
								StartMember, GO_Quit = KeyButton( "_Quit", ID_QUIT ), EndMember,
								VarSpace( DEFAULT_WEIGHT ),
							EndObject, FixMinHeight,
						EndMember,
					EndObject,
			EndObject;

			/*
			 *	Object created OK?
			 */
			if ( WO_Window ) {
				tmp += GadgetKey( WO_Window, GO_Quit,  "q" );
				tmp += GadgetKey( WO_Window, GO_PMB,   "p" );
				tmp += GadgetKey( WO_Window, GO_PMB1,  "e" );
				tmp += GadgetKey( WO_Window, GO_PMB2,  "x" );
				if ( tmp == 4 ) {
					if ( window = WindowOpen( WO_Window )) {
						GetAttr( WINDOW_SigMask, WO_Window, &signal );
						do {
							Wait( signal );
							while (( rc = HandleEvent( WO_Window )) != WMHI_NOMORE ) {
								switch ( rc ) {

									case	WMHI_CLOSEWINDOW:
									case	ID_QUIT:
										running = FALSE;
										break;

									case	ID_POPMENU3:
										GetAttr( PMB_MenuNumber, GO_PMB2, &tmp );
										txt = Exclude[ tmp ].pm_Label;
										goto def;

									case	ID_POPMENU2:
										GetAttr( PMB_MenuNumber, GO_PMB1, &tmp );
										txt = Edit[ tmp ].pm_Label;
										goto def;

									case	ID_POPMENU1:
										GetAttr( PMB_MenuNumber, GO_PMB, &tmp );
										switch ( tmp ) {
											case	9:
												Req( window, "*OK", ISEQ_C ISEQ_B "PopButtonClass DEMO\n" ISEQ_N "(C) Copyright 1995 Jaba Development." );
												break;

											case	11:
												running = FALSE;
												break;

											default:
												txt = Project[ tmp ].pm_Label;
												def:
												Req( window, "*OK", ISEQ_C "Selected Item %ld <" ISEQ_B "%s" ISEQ_N ">", tmp, txt );
												break;
										}
										break;
								}
							}
						} while ( running );
					}
				}
				DisposeObject( WO_Window );
			}
			FreePMBClass( PMBClass );
		}
		CloseLibrary( BGUIBase );
	}
}

#ifdef _DCC
int wbmain( struct WBStartup *wbs )
{
	return( main( 0, wbs ));
}
#endif

