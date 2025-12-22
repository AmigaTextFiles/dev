/*
 *	MAIN.C
 */

#include "BGUIPlayer.h"

Prototype ULONG ReportError( UBYTE *, UBYTE *, ... );
Prototype struct MsgPort *SharedPort;

/*
 *	Global data.
 */
struct Library *BGUIBase;
Object	       *CO_Broker;
ULONG		BrokerSig;
struct MsgPort *SharedPort;

/*
 *	Show a BGUI requester. Used for
 *	error reports and general information.
 */
ULONG ReportError( UBYTE *gads, UBYTE *string, ... )
{
	struct bguiRequest	req = { NULL };

	req.br_GadgetFormat	= gads;
	req.br_TextFormat	= string;
	req.br_Underscore	= '_';
	req.br_Flags		= Player ? BREQF_CENTERWINDOW|BREQF_AUTO_ASPECT|BREQF_LOCKWINDOW : BREQF_CENTERWINDOW|BREQF_AUTO_ASPECT;

	return( BGUI_RequestA( Player, &req, ( ULONG * )( &string + 1 )));
}

/*
 *	Event handler. This routine will handle
 *	all incoming message traffic from the
 *	main window, edit window, timer and
 *	commodity broker.
 */
VOID MsgHandler( void )
{
	ULONG			rc, tmp, sigrec, type, id;
	struct Window	       *sigwin;
	BOOL			running = TRUE;

	do {
		/*
		 *	Let's wait for a signal...
		 */
		sigrec = Wait(( 1L << SharedPort->mp_SigBit ) | TimerMask | BrokerSig );

		/*
		 *	Timer message?
		 */
		if ( sigrec & TimerMask ) {
			/*
			 *	Valid timer message?
			 */
			if ( CheckTimer()) {
				/*
				 *	Reset timer/CD info and the
				 *	pause toggle.
				 */
				SCSI_ReadCDInfo( 1 );
				SetGadgetAttrs(( struct Gadget * )GO_Pause, Player, NULL, GA_Selected, Status == SCSI_STAT_PAUSED ? TRUE : FALSE, TAG_END );
			}
		}

		/*
		 *	Window message?
		 */
		if ( sigrec & ( 1L << SharedPort->mp_SigBit )) {
			while ( sigwin = GetSignalWindow( WO_Player )) {
				/*
				 *	Read the CD information, don't reset the timer.
				 */
				SCSI_ReadCDInfo( 0 );
				/*
				 *	Which window was it?
				 */
				if ( sigwin == Player ) {
					/*
					 *	Poll messages.
					 */
					while (( rc = HandleEvent( WO_Player )) != WMHI_NOMORE ) {
						/*
						 *	One of the track selection buttons?
						 */
						if ( rc >= 1 && rc <= 20 )
							/*
							 *	Play the selected track.
							 */
							SCSI_PlayAudio( rc );
						else {
							switch ( rc ) {

								case	ID_INQUIRE:
									/*
									 *	Show device information.
									 */
									SCSI_Inquire();
									break;

									case	ID_EDIT:
									/*
									 *	Open disk-edit window if
									 *	it is not open yet.
									 */
									if ( ! Disk )
										OpenDiskWindow();
									break;

								case	ID_ABOUT:
									/*
									 *	Show info about this program.
									 */
									ReportError( "_OK", ISEQ_C ISEQ_B VERS " (" DATE ")\n\n"
										     ISEQ_N "By Jan van den Baard\n\n"
										     "Based on the SCSI-2 CD-ROM code from\n"
										     "MultiCDPlayer 1.0 by Boris Jakubaschk\n"
										     "and SCSIUtil 2.0 by Gary Duncan and Heiko Rath" );
									break;

									case	WMHI_CLOSEWINDOW:
									/*
									 *	Close the player window.
									 */
									if ( Player )
										ClosePlayerWindow();
									break;

									case	ID_QUIT:
									/*
									 *	Bye bye.
									 */
									running = FALSE;
									break;

								case	ID_HIDE:
									/*
									 *	Hide all widows.
									 */
									if ( Player ) ClosePlayerWindow();
									if ( Disk   ) CloseDiskWindow();
									break;

								case	ID_PLAY:
									/*
									 *	Start/Continue playing.
									 */
									if ( Status == SCSI_STAT_PAUSED       ) SCSI_PauseResume();
									else if ( Status != SCSI_STAT_PLAYING ) SCSI_PlayAudio( 1 );
									break;

								case	ID_NEXT:
									/*
									 *	Play next track.
									 */
									if ( Status == SCSI_STAT_PLAYING ) SCSI_PlayAudio( Track + 1 );
									break;

								case	ID_PREV:
									/*
									 *	When less than one second played we
									 *	play the previous track. Otherwise we
									 *	restart the current track. Just like a
									 *	regular CD player ;) Mine does...
									 */
									if ( Status == SCSI_STAT_PLAYING ) {
										if ( TimeIDA == 0 && TimeIDB == 0 ) SCSI_PlayAudio( Track - 1 );
										else				    SCSI_PlayAudio( Track );
									}
									break;

								case	ID_PAUSE:
									/*
									 *	Pause/Continue playing.
									 */
									SCSI_PauseResume();
									break;

								case	ID_STOP:
									/*
									 *	Stop playing.
									 */
									SCSI_Stop();
									break;

								case	ID_EJECT:
									/*
									 *	Open drive door and reset
									 *	visuals.
									 */
									SCSI_Eject();
									TrackID = IndexID = TimeIDA = TimeIDB = TogoIDA = TogoIDB = 0;
									break;

								case	ID_FORWARD:
									/*
									 *	Jump ahead 10 seconds (10 frames.)
									 */
									if ( Status == SCSI_STAT_PLAYING ) SCSI_Jump( 750 );
									break;

								case	ID_BACKWARD:
									/*
									 *	Jump back 10 seconds (10 frames.)
									 */
									if ( Status == SCSI_STAT_PLAYING ) SCSI_Jump( -750 );
									break;

									case	ID_VOLUME:
									/*
									 *	Adjust output volume.
									 */
									GetAttr( SLIDER_Level, GO_Volume, &tmp );
									SCSI_SetVolume( tmp, tmp, tmp, tmp );
									break;
							}
						}
					}
				}

				/*
				 *	Disk editor message?
				 */
				if ( sigwin == Disk ) {
					UBYTE		*name, *str;
					/*
					 *	Poll messages.
					 */
					while (( rc = HandleEvent( WO_Disk )) != WMHI_NOMORE ) {
						switch ( rc ) {

							case	WMHI_CLOSEWINDOW:
								/*
								 *	Close the disk editor.
								 */
								if ( Disk ) {
									CloseDiskWindow();
									goto setDisplay;
								}
								break;

							case	ID_DISKLIST:
								/*
								 *	Setup the selected track.
								 */
								if ( name = ( UBYTE * )FirstSelected( GO_DiskList ))
									SetGadgetAttrs(( struct Gadget * )GO_DiskTrack, Disk, NULL, STRINGA_TextVal, name, TAG_END );
								break;

							case	ID_TRACK:
								/*
								 *	Change the track name in the list.
								 */
								if ( name = ( UBYTE * )FirstSelected( GO_DiskList )) {
									GetAttr( STRINGA_TextVal, GO_DiskTrack, ( ULONG * )&str );
									strcpy( name, str );
									BGUI_DoGadgetMethod( GO_DiskList, Disk, NULL, LVM_REPLACE, NULL, name, name );
								}
								break;

							case	ID_SAVEDISK:
								/*
								 *	Get the data from the string objects.
								 */
								GetAttr( STRINGA_TextVal, GO_Disk, ( ULONG * )&name );
								strcpy( DiskName, name );
								GetAttr( STRINGA_TextVal, GO_Artist, ( ULONG * )&name );
								strcpy( Artist, name );
								GetAttr( STRINGA_TextVal, GO_DiskLabel, ( ULONG * )&name );
								strcpy( DiskLabel, name );
								/*
								 *	Save the file to disk.
								 */
								SaveDiskFile();
								/*
								 *	Close the disk editor window.
								 */
								CloseDiskWindow();
								/*
								 *	Setup visuals.
								 */
								setDisplay:
								SetGadgetAttrs(( struct Gadget * )GO_Title,	 Player, NULL, INFO_TextFormat, DiskName, TAG_END );
								SetGadgetAttrs(( struct Gadget * )GO_TrackTitle, Player, NULL, INFO_TextFormat, Status == SCSI_STAT_STOPPED ? Artist : &DiskTracks[ Track - 1 ][ 0 ], TAG_END );
								break;
						}
					}
				}
			}
		}

		/*
		 *	Commodity message?
		 */
		if ( sigrec & BrokerSig ) {
			/*
			 *	Get messages from the broker.
			 */
			while ( MsgInfo( CO_Broker, &type, &id, NULL ) != CMMI_NOMORE ) {
				/*
				 *	Evaluate message.
				 */
				switch ( type ) {

					case	CXM_IEVENT:
						switch ( id ) {
							case	CXK_POPUP:
								/*
								 *	Popup the player window.
								 */
								if ( ! Player )
									OpenPlayerWindow( TRUE );
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
									DisableBroker( CO_Broker );
									break;

								case	CXCMD_ENABLE:
									/*
									 *	Enable the broker.
									 */
									EnableBroker( CO_Broker );
									break;

								case	CXCMD_UNIQUE:
								case	CXCMD_APPEAR:
									/*
									 *	Open the player window.
									 */
									if ( ! Player )
										OpenPlayerWindow( TRUE );
									break;

								case	CXCMD_DISAPPEAR:
									/*
									 *	Close all windows.
									 */
									if ( Player ) ClosePlayerWindow();
									if ( Disk   ) CloseDiskWindow();
									break;
						}
						break;
				}
			}
		}
	} while ( running );
}

/*
 *	Setup the program.
 */
static BOOL SetupBGP( void )
{
	ULONG			added;

	/*
	 *	Open BGUI.
	 */
	if ( BGUIBase = OpenLibrary( BGUINAME, BGUIVERSION )) {
		/*
		 *	Create commodity broker.
		 */
		CO_Broker = CommodityObject,
			COMM_Name,		VERS,
			COMM_Title,		VERS " (" DATE ")",
			COMM_Description,	"Compact Disk Digital Audio Player.",
			COMM_Priority,		0,
			COMM_ShowHide,		TRUE,
		EndObject;
		/*
		 *	OK?
		 */
		if ( CO_Broker ) {
			/*
			 *	Load preferences.
			 */
			LoadConfig();
			/*
			 *	Get commadity signal.
			 */
			GetAttr( COMM_SigMask, CO_Broker, &BrokerSig );
			/*
			 *	Add popup key.
			 */
			added = AddHotkey( CO_Broker, Popkey, CXK_POPUP, 0L );
			/*
			 *	OK?
			 */
			if ( added == 1 ) {
				/*
				 *	Setup the SCSI CD-ROM communication stuff.
				 */
				if ( SetupSCSI( DeviceName, DevID )) {
					/*
					 *	Is the device a CD-ROM?
					 */
					if ( SCSI_IsCDRom()) {
						/*
						 *	Setup the timer.deice.
						 */
						if ( SetupTimer()) {
							/*
							 *	Enable the broker.
							 */
							EnableBroker( CO_Broker );
							/*
							 *	Create the shared message port.
							 */
							if ( SharedPort = CreateMsgPort())
								return( TRUE );
							else
								ReportError( "_OK", "Can't create a message port." );
							KillTimer();
						}
					} else
						ReportError( "_OK", "The device can not be established\nto be a CD-ROM player!" );
					EndSCSI();
				}
			} else
				ReportError( "_OK", "Unable to setup commodity hotkey!" );
			DisposeObject( CO_Broker );
		} else
			ReportError( "_OK", "Unable to create a commodity object!" );
		CloseLibrary( BGUIBase );
	} else
		Printf( "Unable to open the bgui.library V37 or better!\n" );
	return( FALSE );
}

/*
 *	Close resources.
 */
static VOID CloseBGP( void )
{
	if ( WO_Disk	) DisposeObject( WO_Disk    );
	if ( WO_Player	) DisposeObject( WO_Player  );
	if ( CO_Broker	) DisposeObject( CO_Broker  );
	EndSCSI();
	KillTimer();
	if ( SharedPort ) DeleteMsgPort( SharedPort );
	CloseLibrary( BGUIBase );
}

/*
 *	Main entry point. Dunno if SAS takes this...
 */
int _main( int ac, char *av )
{
	if ( SetupBGP()) {
		SCSI_ReadCDInfo( 1 );
		OpenPlayerWindow( Popup );
		MsgHandler();
		CloseBGP();
	}
	_exit( 0 );

#ifdef _DCC
extern void _waitwbmsg( void );
	_waitwbmsg();
#endif
}
