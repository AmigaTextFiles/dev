/*
 *	WALLSTREET.C
 *
 *	(C) Copyright 1995 Jaba Development.
 *	(C) Copyright 1995 Jan van den Baard.
 *	    All Rights Reserved.
 *
 *	The 1000000th commodities Exchange clone :)
 */

#include "WallStreet.h"

/*
 *	Main module data.
 */
static Object *WO_WallStreet, *GO_Brokers, *GO_Show, *GO_HideB, *GO_Active, *GO_Remove;
static Object *GO_Hide, *GO_Quit, *CO_WallStreet;

static struct Window	 *WallStreet;
static ULONG		  WallStreetSig, BrokerSig;
static ULONG		  BuildCount;
static struct ListBroker *LastSelected;
static struct ReadArgs	 *ShellArgs;
static struct Args	  Args;
static UBYTE		**TTypes;
static UBYTE		 *Pubscreen;
struct Library		 *BGUIBase;

/*
 *	Some menus.
 */
static struct NewMenu WallStreetMenus[] = {
	Title( "Project" ),
		Item( "About...",       "?",    ID_ABOUT ),
		ItemBar,
		Item( "Hide",           "H",    ID_HIDE  ),
		Item( "Quit",           "Q",    ID_QUIT  ),
	End
};

/*
 *	Show a BGUI requester. Used for
 *	general information.
 */
static ULONG Report( UBYTE *gads, UBYTE *string, ... )
{
	struct bguiRequest	req = { NULL };

	req.br_GadgetFormat	= gads;
	req.br_TextFormat	= string;
	req.br_Underscore	= '_';
	req.br_Flags		= WallStreet ? BREQF_CENTERWINDOW|BREQF_AUTO_ASPECT|BREQF_LOCKWINDOW : BREQF_CENTERWINDOW|BREQF_AUTO_ASPECT;

	return( BGUI_RequestA( WallStreet, &req, ( ULONG * )( &string + 1 )));
}

/*
 *	Listview resource-hook. This builds the "ListBroker"
 *	structures from the "BrokerCopy" structures.
 */
static SAVEDS ASM APTR ListResourceFunc( REG(a0) struct Hook *hook, REG(a2) Object *obj, REG(a1) struct lvResource *lvr )
{
	struct ListBroker		*lb;
	struct BrokerCopy		*bc;
	APTR				 rc = 0L;

	switch ( lvr->lvr_Command ) {

		case	LVRC_MAKE:
			/*
			 *	Here we construct a ListBroker structure
			 *	from the input BrokerCopy structure.
			 */
			bc = ( struct BrokerCopy * )lvr->lvr_Entry;
			if ( lb = ( struct ListBroker * )AllocVec( sizeof( struct ListBroker ), MEMF_PUBLIC )) {
				/*
				 *	Setup the pre-parse string so that we
				 *	can display active brokers in HIGHLIGHTEXTPEN
				 *	and inactive brokers in TEXTPEN.
				 */
				lb->lb_PreParse[ 0 ] = '\33';
				lb->lb_PreParse[ 1 ] = 'd';
				/*
				 *	Copy name, title and description.
				 */
				strcpy( &lb->lb_Name[ 0 ], &bc->bc_Name[ 0 ] );
				strcpy( &lb->lb_Title[ 0 ], &bc->bc_Title[ 0 ] );
				strcpy( &lb->lb_Descr[ 0 ], &bc->bc_Descr[ 0 ] );
				/*
				 *	And also the task and flags.
				 */
				lb->lb_Task	  = bc->bc_Task;
				lb->lb_Flags	  = bc->bc_Flags;
				/*
				 *	Setup current build counter.
				 */
				lb->lb_BuildCount = BuildCount;
				rc = ( APTR )lb;
			}
			break;

		case	LVRC_KILL:
			/*
			 *	Simply de-allocate the ListBroker
			 *	structure as created above.
			 */
			FreeVec( lvr->lvr_Entry );
			break;
	}
	return( rc );
}

/*
 *	Listiew rendering hook. Simply
 *	returns the name of the broker
 *	prepended by a Info text command
 *	sequence to determine the color.
 */
static SAVEDS ASM UBYTE *ListRenderFunc( REG(a0) struct Hook *hook, REG(a2) Object *obj, REG(a1) struct lvRender *lvr )
{
	struct ListBroker		*lb = ( struct ListBroker * )lvr->lvr_Entry;

	/*
	 *	Active brokers are rendered in highlight text pen
	 *	and non-activated brokers in normal text pen.
	 */
	lb->lb_PreParse[ 2 ] = (( lb->lb_Flags & COF_ACTIVE ) ? HIGHLIGHTTEXTPEN : TEXTPEN ) + 48;

	return( &(( struct ListBroker * )lvr->lvr_Entry )->lb_PreParse[ 0 ] );
}

/*
 *	The hook structures for the listview.
 */
static struct Hook ListResource = { NULL, NULL, ( HOOKFUNC )ListResourceFunc, NULL, NULL };
static struct Hook ListRender	= { NULL, NULL, ( HOOKFUNC )ListRenderFunc,   NULL, NULL };

/*
 *	Find the broker entry by referencing
 *	it's task address.
 */
static struct ListBroker *FindListBroker( LONG task )
{
	struct ListBroker	*lb = NULL;

	/*
	 *	Get the first broker from the list.
	 */
	if ( lb = ( struct ListBroker * )FirstEntry( GO_Brokers )) {
		do {
			/*
			 *	Is this the one we are
			 *	looking for?
			 */
			if ( lb->lb_Task == task ) {
				/*
				 *	Yes. Update the build counter
				 *	and stop looking.
				 */
				lb->lb_BuildCount = BuildCount;
				break;
			}
			/*
			 *	Next please...
			 */
			lb = ( struct ListBroker * )NextEntry( GO_Brokers, lb );
		} while ( lb );
	}
	return( lb );
}

/*
 *	Recreate the broker list. Please note that this
 *	is not very pretty code.
 *
 *	It runs down the broker list replacing/adding
 *	entries and when that is done it runs down the
 *	listed brokers to remove the obsolete entries.
 *
 *	All in all much work.
 */
static VOID BuildBrokerList( void )
{
	struct Node		*node;
	struct ListBroker	*inlist, *rem = NULL;
	struct List		 list;

	/*
	 *	Increase build counter.
	 */
	BuildCount++;

	/*
	 *	Initialize and setup the
	 *	broker list.
	 */
	NewList( &list );
	CopyBrokerList( &list );

	/*
	 *	Browse through the new list.
	 */
	for ( node = list.lh_Head; node->ln_Succ; node = node->ln_Succ ) {
		/*
		 *	Was this one in the list already?
		 */
		if ( inlist = FindListBroker( (( struct BrokerCopy *)node )->bc_Task )) {
			/*
			 *	Yes. Update the data from this
			 *	broker.
			 */
			rem = ( struct ListBroker * )ReplaceEntry( WallStreet, GO_Brokers, inlist, node );
			/*
			 *	Was it the last selected one? If so set it
			 *	to the replaced entry to keep double-clicks
			 *	working.
			 */
			if ( inlist == LastSelected )
				LastSelected = rem;
		} else
			/*
			 *	Not available yet. Add it to the
			 *	list.
			 */
			AddEntry( WallStreet, GO_Brokers, node, LVAP_TAIL );
	}

	/*
	 *	Free the system broker list.
	 */
	FreeBrokerList( &list );

	/*
	 *	This needs to be NULL incase there
	 *	are no entries to remove.
	 */
	rem = NULL;

	/*
	 *	All brokers which have a build counter
	 *	different from the current counter are
	 *	not running anymore so we remove them
	 *	here.
	 */
	if ( inlist = ( struct ListBroker * )FirstEntry( GO_Brokers )) {
		do {
			/*
			 *	Different counter value?
			 */
			if ( inlist->lb_BuildCount != BuildCount ) {
				/*
				 *	Yes. Remove it.
				 */
				rem    = inlist;
				inlist = ( struct ListBroker * )NextEntry( GO_Brokers, inlist );
				RemoveEntry( GO_Brokers, rem );
			} else
				/*
				 *	Next please.
				 */
				inlist = ( struct ListBroker * )NextEntry( GO_Brokers, inlist );
		} while ( inlist );
		/*
		 *	Visual update when there were brokers
		 *	are removed.
		 */
		if ( rem )
			RefreshList( WallStreet, GO_Brokers );
	}
}

/*
 *	Send a command to all selected brokers.
 */
static VOID SendCxCmd( ULONG command )
{
	struct ListBroker		*lb;

	/*
	 *	Get the first selected broker.
	 */
	if ( lb = ( struct ListBroker * )FirstSelected( GO_Brokers )) {
		/*
		 *	Get 'm all.
		 */
		do {
			/*
			 *	Send the command to the broker. Don't you
			 *	just love undocumented OS features ;)
			 */
			BrokerCommand( &lb->lb_Name[ 0 ], command );
			/*
			 *	Get the next broker.
			 */
			lb = ( struct ListBroker * )NextSelected( GO_Brokers, lb );
		} while ( lb );
	}
}

/*
 *	Build the WallStreet window.
 */
static VOID OpenWallStreetWindow( void )
{
	/*
	 *	Object created already?
	 */
	if ( ! WO_WallStreet ) {
		/*
		 *	No. Create it.
		 */
		WO_WallStreet = WindowObject,
			WINDOW_Title,			VERS " (" DATE ")",
			WINDOW_AutoAspect,		TRUE,
			WINDOW_SmartRefresh,		TRUE,
			WINDOW_MenuStrip,		WallStreetMenus,
			WINDOW_PubScreenName,		Pubscreen,
			WINDOW_ScaleWidth,		15,
			WINDOW_ScaleHeight,		15,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BackFill, SHINE_RASTER,
					StartMember,
						VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
							FRM_Type,		FRTYPE_BUTTON,
							FRM_Recessed,		TRUE,
							StartMember,
								GO_Brokers = ListviewObject,
									LISTV_MultiSelect,		TRUE,
									LISTV_MultiSelectNoShift,	TRUE,
									LISTV_ResourceHook,		&ListResource,
									LISTV_DisplayHook,		&ListRender,
									GA_ID,				ID_BROKERLIST,
								EndObject,
							EndMember,
							StartMember,
								HGroupObject, Spacing( 4 ), GROUP_EqualWidth, TRUE,
									StartMember, GO_Show  = KeyButton( "_Show", ID_SHOW        ), EndMember,
									StartMember, GO_HideB = KeyButton( "Hi_de", ID_HIDEBROKERS ), EndMember,
								EndObject, FixMinHeight,
							EndMember,
							StartMember,
								HGroupObject, Spacing( 4 ), GROUP_EqualWidth, TRUE,
									StartMember, GO_Active = KeyButton( "_Flip Status", ID_ACTIVE ), EndMember,
									StartMember, GO_Remove = KeyButton( "_Remove",      ID_REMOVE ), EndMember,
								EndObject, FixMinHeight,
							EndMember,
						EndObject,
					EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							StartMember, GO_Hide = KeyButton( "_Hide", ID_HIDE ), EndMember,
							VarSpace( DEFAULT_WEIGHT ),
							StartMember, GO_Quit = KeyButton( "_Quit", ID_QUIT ), EndMember,
						EndObject, FixMinHeight,
					EndMember,
				EndObject,
		EndObject;

		if ( WO_WallStreet ) {
			/*
			 *	Attach gadget keys. Although, strictly
			 *	speaking I should, I do no error
			 *	checking here...
			 */
			GadgetKey( WO_WallStreet, GO_Show,	"s" );
			GadgetKey( WO_WallStreet, GO_HideB,	"d" );
			GadgetKey( WO_WallStreet, GO_Active,	"f" );
			GadgetKey( WO_WallStreet, GO_Remove,	"r" );
			GadgetKey( WO_WallStreet, GO_Hide,	"h" );
			GadgetKey( WO_WallStreet, GO_Quit,	"q" );
		}
	}

	/*
	 *	Object OK?
	 */
	if ( WO_WallStreet ) {
		/*
		 *	Create/Update the broker list.
		 */
		BuildBrokerList();
		/*
		 *	Pop the window.
		 */
		if ( WallStreet = WindowOpen( WO_WallStreet ))
			/*
			 *	Get window signal mask.
			 */
			GetAttr( WINDOW_SigMask, WO_WallStreet, &WallStreetSig );
	}
}

/*
 *	Close the WallStreet window.
 */
static VOID CloseWallStreetWindow( void )
{
	/*
	 *	Close the window and nuke the
	 *	pointer and signal mask.
	 */
	WindowClose( WO_WallStreet );
	WallStreet    = NULL;
	WallStreetSig = 0L;
}

/*
 *	Handle all incoming message traffic.
 */
static VOID EventHandler( void )
{
	BOOL			 running = TRUE;
	ULONG			 sigrec, rc, type, id, ds[ 2 ], dm[ 2 ];
	struct ListBroker	*lb;

	do {
		/*
		 *	Wait for a signal...
		 */
		sigrec = Wait( WallStreetSig | BrokerSig );

		/*
		 *	A window signal?
		 */
		if ( sigrec & WallStreetSig ) {
			/*
			 *	Get the messages.
			 */
			while ( WallStreet && (( rc = HandleEvent( WO_WallStreet )) != WMHI_NOMORE )) {
				switch ( rc ) {

					case	WMHI_CLOSEWINDOW:
					case	ID_HIDE:
						/*
						 *	Close the window.
						 */
						if ( WallStreet )
							CloseWallStreetWindow();
						break;

					case	ID_ABOUT:
						/*
						 *	Show'm the info.
						 */
						Report( "_Continue", ISEQ_C ISEQ_HIGHLIGHT VERS " (" DATE ")\n\n" ISEQ_TEXT
								     "(C) Copyright 1995 Jaba Development\n"
								     "Written by Jan van den Baard" );
						break;

					case	ID_QUIT:
						/*
						 *	Bye now.
						 */
						running = FALSE;
						break;

					case	ID_SHOW:
						/*
						 *	Show selected brokers.
						 */
						SendCxCmd( CXCMD_APPEAR );
						break;

					case	ID_HIDEBROKERS:
						/*
						 *	Hide selected brokers.
						 */
						SendCxCmd( CXCMD_DISAPPEAR );
						break;

					case	ID_ACTIVE:
						/*
						 *	Flip activity status of the selected brokers.
						 */
						if ( lb = ( struct ListBroker * )FirstSelected( GO_Brokers )) {
							do {
								BrokerCommand( &lb->lb_Name[ 0 ], lb->lb_Flags & COF_ACTIVE ? CXCMD_DISABLE : CXCMD_ENABLE );
								lb = ( struct ListBroker * )NextSelected( GO_Brokers, lb );
							} while ( lb );
						}
						break;

					case	ID_BROKERLIST:
						/*
						 *	Get the last selected entry.
						 */
						GetAttr( LISTV_LastClicked, GO_Brokers, ( ULONG * )&lb );
						/*
						 *	The same one as the previous selection?
						 */
						if ( lb == LastSelected ) {
							/*
							 *	Time it.
							 */
							CurrentTime( &ds[ 1 ], &dm[ 1 ] );
							/*
							 *	Double clicked?
							 */
							if ( DoubleClick( ds[ 0 ], dm[ 0 ], ds[ 1 ], dm[ 1 ] ))
								/*
								 *	Yes. Show it's information.
								 */
								Report( "_OK", ISEQ_C "%s\n%s", &lb->lb_Title[ 0 ], &lb->lb_Descr[ 0 ] );
						}
						/*
						 *	Setup this selection.
						 */
						LastSelected = lb;
						/*
						 *	Time it.
						 */
						CurrentTime( &ds[ 0 ], &dm[ 0 ] );
						break;

					case	ID_REMOVE:
						/*
						 *	Remove all selected brokers.
						 */
						SendCxCmd( CXCMD_KILL );
						break;
				}
			}
		}

		/*
		 *	Commodity signal?
		 */
		if ( sigrec & BrokerSig ) {
			/*
			 *	Get messages from the broker.
			 */
			while ( MsgInfo( CO_WallStreet, &type, &id, NULL ) != CMMI_NOMORE ) {
				/*
				 *	Evaluate message.
				 */
				switch ( type ) {

					case	CXM_IEVENT:
						switch ( id ) {
							case	CXK_SHOW:
								/*
								 *	Popup the window.
								 */
								if ( ! WallStreet )
									OpenWallStreetWindow();
								break;
						}
						break;

					case	CXM_COMMAND:
						switch ( id ) {
								case	CXCMD_KILL:
									/*
									 *	Bye bye.
									 */
									running = FALSE;
									break;

								case	CXCMD_DISABLE:
									/*
									 *	Disable the broker.
									 */
									DisableBroker( CO_WallStreet );
									break;

								case	CXCMD_ENABLE:
									/*
									 *	Enable the broker.
									 */
									EnableBroker( CO_WallStreet );
									break;

								case	CXCMD_UNIQUE:
								case	CXCMD_APPEAR:
									/*
									 *	Open the window.
									 */
									if ( ! WallStreet )
										OpenWallStreetWindow();
									break;

								case	CXCMD_DISAPPEAR:
									/*
									 *	Close window.
									 */
									if ( WallStreet )
										CloseWallStreetWindow();
									break;

								case	CXCMD_LIST_CHG:
									/*
									 *	Update broker list.
									 */
									BuildBrokerList();
									break;
						}
						break;
				}
			}
		}

		/*
		 *	No. We cannot be stopped by a CTRL-C.
		 *
		 *	A fearless violation of the C= commodities
		 *	programming rules which clearly states:
		 *
		 *	"The break key for any commodity should be CTRL-C."
		 */

	} while ( running );
}

/*
 *	Setup the program.
 */
static BOOL SetupWallStreet( UBYTE **args )
{
	static UBYTE		*defpopup = "YES", *defpopkey = "control alt help";
	struct Process		*proc = ( struct Process * )FindTask( NULL );
	LONG			 priority;
	UBYTE			*popup, *popkey;

	/*
	 *	Shell?
	 */
	if ( proc->pr_CLI ) {
		/*
		 *	Obtain startup arguments from the shell.
		 */
		if ( ShellArgs = ReadArgs( SHELL, ( LONG * )&Args, NULL )) {
			priority  = sArgInt( Args.Pri,	     0	       );
			popup	  = sArgStr( Args.Popup,     defpopup  );
			popkey	  = sArgStr( Args.Popkey,    defpopkey );
			Pubscreen = sArgStr( Args.PubScreen, NULL      );
		} else
			return( FALSE );
	} else {
		/*
		 *	Obtain startup arguments from the Workbench.
		 */
		TTypes = ( UBYTE ** )ArgArrayInit( NULL, args );

		priority  = ArgInt(    TTypes, "CX_PRIORITY",  0         );
		popup	  = ArgString( TTypes, "CX_POPUP",     defpopup  );
		popkey	  = ArgString( TTypes, "CX_POPKEY",    defpopkey );
		Pubscreen = ArgString( TTypes, "CX_PUBSCREEN", NULL      );
	}

	/*
	 *	Open BGUI. This program does require version
	 *	39 or better of the bgui.library.
	 */
	if ( BGUIBase = OpenLibrary( BGUINAME, BGUIVERSION )) {
		/*
		 *	Create the broker.
		 */
		CO_WallStreet = CommodityObject,
			COMM_Name,		"Exchange", /* WE MUST HAVE THIS NAME!!! */
			COMM_Title,		VERS " (" DATE ")",
			COMM_Description,	"Another Exchange Clone.",
			COMM_ShowHide,		TRUE,
			COMM_Priority,		priority,
		EndObject;
		/*
		 *	OK?
		 */
		if ( CO_WallStreet ) {
			/*
			 *	Get signal mask.
			 */
			GetAttr( COMM_SigMask, CO_WallStreet, &BrokerSig );
			/*
			 *	Setup popkey.
			 */
			if ( AddHotkey( CO_WallStreet, popkey, CXK_SHOW, 0 )) {
				/*
				 *	Fire up the broker.
				 */
				EnableBroker( CO_WallStreet );
				/*
				 *	Open the window?
				 */
				if ( ! stricmp( popup, "YES" ))
					OpenWallStreetWindow();
				return( TRUE );
			}
			DisposeObject( CO_WallStreet );
		}
		CloseLibrary( BGUIBase );
	}
	return( FALSE );
}

/*
 *	Free all resources.
 */
static VOID CloseWallStreet( void )
{
	if ( WO_WallStreet ) DisposeObject( WO_WallStreet );
	if ( CO_WallStreet ) DisposeObject( CO_WallStreet );
	if ( BGUIBase	   ) CloseLibrary( BGUIBase );
	if ( TTypes	   ) ArgArrayDone();
	if ( ShellArgs	   ) FreeArgs( ShellArgs );
}

/*
 *	Main entry point. This should work for both
 *	shell and WB startup with SAS (I think).
 */
int main( int argc, char **argv )
{
	if ( SetupWallStreet( argv )) {
		EventHandler();
		CloseWallStreet();
	}
	return( 0 );
}

/*
 *	DICE specific workbench startup
 *	entry point.
 */
#ifdef _DCC
int wbmain( struct WBStartup *wbs )
{
	return( main( 0, ( char ** )wbs ));
}
#endif
