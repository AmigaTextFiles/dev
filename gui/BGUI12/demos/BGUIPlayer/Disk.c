/*
 *	DISK.C
 */

#include "BGUIPlayer.h"

/*
 *	Export data.
 */
Prototype UBYTE DiskTracks[ 100 ][ 64 ], DiskName[ 64 ], Artist[ 64 ], DiskLabel[ 64 ];
Prototype Object *WO_Disk, *GO_Disk, *GO_Artist, *GO_DiskLabel, *GO_DiskTrack, *GO_DiskList;
Prototype struct Window *Disk;
Prototype ULONG DiskSig;

UBYTE		DiskTracks[ 100 ][ 64 ];	/* Names of the tracks on the disk. */
UBYTE		DiskName[ 64 ];                 /* Title of the disk.		    */
UBYTE		Artist[ 64 ];			/* Artist.			    */
UBYTE		DiskLabel[ 64 ];		/* Disk label.			    */
UWORD		TrackIdx;			/* Index for reading disk files.    */

/*
 *	Disk editor window data.
 */
Object	       *WO_Disk, *GO_DiskList, *GO_Disk, *GO_Artist, *GO_DiskLabel, *GO_DiskTrack, *GO_Save;
struct Window  *Disk;
ULONG		DiskSig;

/*
 *	A resource hook which prevents the listview class
 *	to make a private copy of the added entries.
 */
SAVEDS ASM APTR ListHookFunc( REG(a0) struct Hook *hook, REG(a2) Object *obj, REG(a1) struct lvResource *lvr )
{
	return( lvr->lvr_Entry );
}

/*
 *	Control the listview with the cursor keys.
 */
SAVEDS ASM VOID ScrollHookFunc( REG(a0) struct Hook *hook, REG(a2) Object *obj, REG(a1) struct IntuiMessage *msg )
{
	struct Window			*window;
	Object				*lv_obj = ( Object * )hook->h_Data;

	/*
	 *	Obtain window pointer.
	 */
	GetAttr( WINDOW_Window,        obj,    ( ULONG * )&window );

	/*
	 *	What key is pressed?
	 */
	switch ( msg->Code ) {

		case	0x4C:
			/*
			 *	UP.
			 */
			if ( msg->Qualifier & ( IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT ))
				SetGadgetAttrs(( struct Gadget * )lv_obj, window, NULL, LISTV_Select, LISTV_Select_Page_Up, TAG_END );
			else if ( msg->Qualifier & IEQUALIFIER_CONTROL )
				SetGadgetAttrs(( struct Gadget * )lv_obj, window, NULL, LISTV_Select, LISTV_Select_First, TAG_END );
			else
				SetGadgetAttrs(( struct Gadget * )lv_obj, window, NULL, LISTV_Select, LISTV_Select_Previous, TAG_END );
			break;

		case	0x4D:
			/*
			 *	DOWN.
			 */
			if ( msg->Qualifier & ( IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT ))
				SetGadgetAttrs(( struct Gadget * )lv_obj, window, NULL, LISTV_Select, LISTV_Select_Page_Down, TAG_END );
			else if ( msg->Qualifier & IEQUALIFIER_CONTROL )
				SetGadgetAttrs(( struct Gadget * )lv_obj, window, NULL, LISTV_Select, LISTV_Select_Last, TAG_END );
			else
				SetGadgetAttrs(( struct Gadget * )lv_obj, window, NULL, LISTV_Select, LISTV_Select_Next, TAG_END );
			break;
	}
}

static struct Hook ListHook   = { NULL, NULL, (HOOKFUNC)ListHookFunc,	NULL, NULL };
static struct Hook ScrollHook = { NULL, NULL, (HOOKFUNC)ScrollHookFunc, NULL, NULL };

/*
 *	Open the disk editor.
 */
Prototype BOOL OpenDiskWindow( void );

BOOL OpenDiskWindow( void )
{
	UWORD			i;

	/*
	 *	Object already created?
	 */
	if ( ! WO_Disk ) {
		/*
		 *	Create listview object.
		 */
		GO_DiskList = ListviewObject,
			GA_ID,			ID_DISKLIST,
			LISTV_ResourceHook,	&ListHook,
			ICA_TARGET,		ICTARGET_IDCMP,
		EndObject;
		/*
		 *	Set it in the window
		 *	IDCMP hook.
		 */
		ScrollHook.h_Data = ( APTR )GO_DiskList;
		/*
		 *	Create the window.
		 */
		WO_Disk = WindowObject,
			WINDOW_Title,		VERS " (" DATE ") - Edit Disk",
			WINDOW_AutoAspect,	TRUE,
			WINDOW_RMBTrap,         TRUE,
			WINDOW_SmartRefresh,	TRUE,
			WINDOW_PubScreenName,	PubScreen,
			WINDOW_ScaleWidth,	20,
			WINDOW_ScaleHeight,	20,
			WINDOW_IDCMPHook,	&ScrollHook,
			WINDOW_IDCMPHookBits,	IDCMP_RAWKEY,
			WINDOW_SharedPort,	SharedPort,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BackFill, SHINE_RASTER,
					StartMember,
						VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
							FRM_Type,		FRTYPE_BUTTON,
							FRM_Recessed,		TRUE,
							StartMember, GO_Disk	  = KeyString( "_Title:",  DiskName,  64, ID_CD     ), FixMinHeight, EndMember,
							StartMember, GO_Artist	  = KeyString( "_Artist:", Artist,    64, ID_ARTIST ), FixMinHeight, EndMember,
							StartMember, GO_DiskLabel = KeyString( "_Label:",  DiskLabel, 64, ID_LABEL  ), FixMinHeight, EndMember,
							StartMember,
								VGroupObject, Spacing( 1 ),
									StartMember, GO_DiskList, EndMember,
									StartMember, GO_DiskTrack = String( NULL, NULL, 64, ID_TRACK ), FixMinHeight, EndMember,
								EndObject,
							EndMember,
						EndObject,
					EndMember,
					StartMember,
						HGroupObject, Spacing( 4 ),
							VarSpace( DEFAULT_WEIGHT ),
							StartMember, GO_Save   = KeyButton( "_Save",   ID_SAVEDISK   ), EndMember,
							VarSpace( DEFAULT_WEIGHT ),
						EndObject, FixMinHeight,
					EndMember,
				EndObject,
		EndObject;

		if ( WO_Disk ) {
			/*
			 *	Add hotkeys/tab cycling.
			 */
			GadgetKey( WO_Disk, GO_Disk,	 "t" );
			GadgetKey( WO_Disk, GO_Artist,	 "a" );
			GadgetKey( WO_Disk, GO_DiskLabel,"l" );
			GadgetKey( WO_Disk, GO_Save,	 "s" );
			DoMethod( WO_Disk, WM_TABCYCLE_ORDER, GO_Disk, GO_Artist, GO_DiskLabel, NULL );
		}
	} else {
		/*
		 *	Reset string contents.
		 */
		SetAttrs( GO_Disk,	STRINGA_TextVal, DiskName,  TAG_END );
		SetAttrs( GO_Artist,	STRINGA_TextVal, Artist,    TAG_END );
		SetAttrs( GO_DiskLabel, STRINGA_TextVal, DiskLabel, TAG_END );
		SetAttrs( GO_DiskTrack, STRINGA_TextVal, NULL,	    TAG_END );
	}

	if ( WO_Disk ) {
		/*
		 *	Empty the listview.
		 */
		ClearList( NULL, GO_DiskList );
		/*
		 *	Add entries.
		 */
		for ( i = 0; i < TOCNumTracks; i++ )
			AddEntry( NULL, GO_DiskList, &DiskTracks[ i ][ 0 ], LVAP_TAIL );
		/*
		 *	Open the window.
		 */
		if ( Disk = WindowOpen( WO_Disk )) {
			GetAttr( WINDOW_SigMask, WO_Disk, &DiskSig );
			return( TRUE );
		}
	}
	return( FALSE );
}

/*
 *	Close the disk editor.
 */
Prototype VOID CloseDiskWindow( void );

VOID CloseDiskWindow( void )
{
	WindowClose( WO_Disk );
	Disk	= NULL;
	DiskSig = 0L;
}

/*
 *	Load disk file.
 */
Prototype VOID LoadDiskFile( void );

/*
 *	The disk files know two commands.
 */
static VOID ParseCD( ULONG * );
static VOID ParseTrack( ULONG * );

static CONFIGCOMM CDCommands[] = {
	{ "CD",         "NAME,ARTIST,LABEL",    ParseCD         },
	{ "TRACK",      "NAME/F",               ParseTrack      }
};

/*
 *	Evaluate the CD command.
 */
static VOID ParseCD( ULONG *args )
{
	if ( args[ 0 ] ) strncpy( DiskName,  ( UBYTE * )args[ 0 ], 64 );
	if ( args[ 1 ] ) strncpy( Artist,    ( UBYTE * )args[ 1 ], 64 );
	if ( args[ 2 ] ) strncpy( DiskLabel, ( UBYTE * )args[ 2 ], 64 );
}

/*
 *	Evaluate the TRACK command.
 */
static VOID ParseTrack( ULONG *args )
{
	if ( args[ 0 ] )
		strncpy( &DiskTracks[ TrackIdx++ ][ 0 ], ( UBYTE * )args[ 0 ], 64 );
}

/*
 *	Load the disk file from the specified
 *	directory.
 */
VOID LoadDiskFile( void )
{
	UBYTE		path[ 256 ];
	ULONG		line = 0;

	/*
	 *	Build the filename of this disk.
	 */
	strncpy( path, DiskPath, 256 );
	AddPart( path, CDID, 256 );
	/*
	 *	Reset track index.
	 */
	TrackIdx = 0;
	/*
	 *	Load the disk file.
	 */
	if ( ReadConfigFile( path, CDCommands, &line )) {
		/*
		 *	Oops. This file does not exist
		 *	or an error occured.
		 */
		strcpy( DiskName,  "<Unknown>" );
		strcpy( Artist,    "<Unknown>" );
		strcpy( DiskLabel, "<Unknown>" );
		for ( line = 0; line < TOCNumTracks; line++ )
			strcpy( &DiskTracks[ line ][ 0 ], "<Unknown>" );
	}
}

/*
 *	Save the current disk file.
 */
Prototype VOID SaveDiskFile( void );

static VOID Fprintf( BPTR handle, UBYTE *fstr, ... )
{
	VFPrintf( handle, fstr, ( ULONG * )( & fstr + 1 ));
}

VOID SaveDiskFile( void )
{
	UBYTE	path[ 256 ], i;
	BPTR	file;

	/*
	 *	Build file name.
	 */
	strncpy( path, DiskPath, 256 );
	AddPart( path, CDID, 256 );
	/*
	 *	Does this file already exist?
	 */
	if ( file = Open( path, MODE_OLDFILE )) {
		if ( ! ReportError( "_Yes|_No", ISEQ_C ISEQ_B "This CD file already exists!\n"
				    ISEQ_N "Overwrite?" )) {
			Close( file );
			return;
		} else
			Close( file );
	}
	/*
	 *	Write the CD and TRACK commands.
	 */
	if ( file = Open( path, MODE_NEWFILE )) {
		Fprintf( file, "CD \"%s\" \"%s\" \"%s\"\n", DiskName, Artist, DiskLabel );
		for ( i = 0; i < TOCNumTracks; i++ )
			Fprintf( file, "TRACK %s\n", &DiskTracks[ i ][ 0 ] );
		Close( file );
	}
}
