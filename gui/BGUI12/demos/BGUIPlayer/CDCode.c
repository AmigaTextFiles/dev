/*
 *	CDCODE.C
 */

#include "BGUIPlayer.h"

/*
 *	Export data.
 */
Prototype UWORD  Status, Track;
Prototype UBYTE  TOCNumTracks, CDID[ 20 ];

UBYTE		       *SCSIData, *TOCBuffer, *SCSISense, *SCSIDevice;
struct MsgPort	       *SCSIPort;
struct IOStdReq        *SCSIRequest;
ULONG			SCSIError, SCSIUnit;
struct SCSICmd		SCSICommand;

UWORD		 Status;				/* Current drive status.	 */
UWORD		 Track;                                 /* Current audio track.          */
UBYTE		 TOCNumTracks;				/* Number of available tracks.	 */
UBYTE		 TOCFlags[ 256 ];			/* 1 = Data, 0 = Audio		 */
ULONG		 TOCTrackAddr[ 256 ];			/* Starting adresses of tracks.  */
UBYTE		 CDID[ 20 ];				/* File name for the disk.	 */

/*
 *	Setup SCSI muck.
 */
Prototype BOOL SetupSCSI( UBYTE *, ULONG );

BOOL SetupSCSI( UBYTE *dev_name, ULONG dev_id )
{
	UBYTE			*data;

	/*
	 *	Save device and unit.
	 */
	SCSIDevice = dev_name;
	SCSIUnit   = dev_id;

	/*
	 *	Allocate Sense, Data and TOC buffers.
	 */
	if ( data = ( UBYTE * )AllocVec( MAX_DATA_LEN + MAX_TOC_LEN + SENSE_LEN, MEMF_CHIP | MEMF_CLEAR )) {
		/*
		 *	Setup pointers.
		 */
		SCSIData  = data;
		SCSISense = data + MAX_DATA_LEN;
		TOCBuffer = SCSISense + MAX_TOC_LEN;
		/*
		 *	Create port and request.
		 */
		if ( SCSIPort = CreateMsgPort()) {
			if ( SCSIRequest = ( struct IOStdReq * )CreateIORequest( SCSIPort, sizeof( struct IOStdReq ))) {
				/*
				 *	Open the device.
				 */
				if ( SCSIError = OpenDevice( dev_name, dev_id, ( struct IORequest * )SCSIRequest, 0 )) {
					/*
					 *	Error opening the device.
					 */
					ReportError( "_OK", "Unable to open %s (Error %ld).", dev_name, SCSIError );
				} else
					return( TRUE );
			} else
				ReportError( "_OK", "Unable to create IO request." );
		} else
			ReportError( "_OK", "Unable to create message port." );
	} else
		ReportError( "_OK", "Out of memory." );

	EndSCSI();
	return( FALSE );
}

/*
 *	Close down the SCSI muck.
 */
Prototype VOID EndSCSI( void );

VOID EndSCSI( void )
{
	if ( ! SCSIError ) CloseDevice(( struct IORequest * )SCSIRequest );
	if ( SCSIRequest ) DeleteIORequest(( struct IORequest * )SCSIRequest );
	if ( SCSIPort	 ) DeleteMsgPort( SCSIPort );
	if ( SCSIData	 ) FreeVec( SCSIData );
}

/*
 *	Do a SCSI command.
 */
Prototype ULONG DoSCSICmd( UBYTE *, ULONG, UBYTE *, ULONG, UBYTE );

ULONG DoSCSICmd( UBYTE *data, ULONG datasize, UBYTE *cmd, ULONG cmdsize, UBYTE flags )
{
	SCSIRequest->io_Length		= sizeof( struct SCSICmd );
	SCSIRequest->io_Data		= ( APTR )&SCSICommand;
	SCSIRequest->io_Command         = HD_SCSICMD;

	SCSICommand.scsi_Data		= ( APTR )data;
	SCSICommand.scsi_Length         = datasize;
	SCSICommand.scsi_SenseActual	= 0;
	SCSICommand.scsi_SenseData	= SCSISense;
	SCSICommand.scsi_SenseLength	= SENSE_LEN;
	SCSICommand.scsi_Command	= cmd;
	SCSICommand.scsi_CmdLength	= cmdsize;
	SCSICommand.scsi_Flags		= flags;

	DoIO(( struct IORequest * )SCSIRequest );

	return( SCSIRequest->io_Error );
}

/*
 *	Make sure the device is a CD-ROM player.
 */
Prototype BOOL SCSI_IsCDRom( void );

BOOL SCSI_IsCDRom( void )
{
	static struct SCSICmd6	command = { SCSI_CMD_INQ, 0, 0, 0, 0, 0 };

	command.B4 = MAX_DATA_LEN;

	if ( ! DoSCSICmd(( UBYTE * )SCSIData, MAX_DATA_LEN, ( UBYTE * )&command, sizeof( command ), SCSIF_READ | SCSIF_AUTOSENSE )) {
		/*
		 *	This must result in 5 otherwise
		 *	the drive at this address is not
		 *	a CD-ROM player.
		 */
		return((( SCSIData[ 0 ] & 0x1F ) == 5 ) ? TRUE : FALSE );
	}
	return( FALSE );
}

/*
 *	Show the device it's Inquiry data.
 */
Prototype VOID SCSI_Inquire( void );

/*
 *	ANSI standards.
 */
static UBYTE *ANSIStr[] = {
	"The device might or might not comply to an ANSI-approved standard.",
	"The device complies to ANSI X3.131-1986 (SCSI-1).",
	"The device complies to (SCSI-2)."
};

VOID SCSI_Inquire( void )
{
	static struct SCSICmd6	command = { SCSI_CMD_INQ, 0, 0, 0, 0, 0 };

	command.B4 = MAX_DATA_LEN;

	if ( ! DoSCSICmd(( UBYTE * )SCSIData, MAX_DATA_LEN, ( UBYTE * )&command, sizeof( command ), SCSIF_READ | SCSIF_AUTOSENSE )) {
		/*
		 *	Show the data read from the device.
		 */
		ReportError( "_OK", ISEQ_C "Software Device: %s\nUnit: %ld\n\n"
				    "Type (5): CD-ROM device\n"
				    "ANSI version: %ld, %s\n"
				    "Vendor: " ISEQ_B "%.8s" ISEQ_N "\n"
				    "Product: " ISEQ_B "%.16s" ISEQ_N "\n"
				    "Revision: " ISEQ_B "%.4s",
				    SCSIDevice,
				    SCSIUnit,
				    SCSIData[ 2 ] & 0x07, ANSIStr[ SCSIData[ 2 ] & 0x07 ],
				    &SCSIData[ 8 ],
				    &SCSIData[ 16 ],
				    &SCSIData[ 32 ] );
	}
}

/*
 *	Read the TOC from the device.
 */
Prototype VOID SCSI_ReadTOC( void );

VOID SCSI_ReadTOC( void )
{
	static struct SCSICmd10 command = { SCSI_CMD_READTOC, 0, 0, 0, 0, 0, 0, 0x03, 0x24, 0 };
	WORD			tocsize, i;
	UBYTE		       *tocptr;

	TOCNumTracks = 0;

	if ( ! DoSCSICmd(( UBYTE * )TOCBuffer, MAX_TOC_LEN, ( UBYTE * )&command,  sizeof( command ), SCSIF_READ | SCSIF_AUTOSENSE )) {
		/*
		 *	Get size of TOC.
		 */
		tocsize = ( TOCBuffer[ 0 ] << 8 ) + TOCBuffer[ 1 ];
		TOCTrackAddr[ 2 ] = 0;
		TOCNumTracks	  = 0;
		if ( tocsize >= 2 ) tocsize -= 2;
		/*
		 *	Copy track addresses.
		 */
		for ( tocptr = &TOCBuffer[ 4 ]; tocptr < ( &TOCBuffer[ 4 ] + tocsize ); tocptr += 8 ) {
			TOCTrackAddr[ TOCNumTracks ] = ( tocptr[ 4 ] << 24 ) | ( tocptr[ 5 ] << 16 ) | ( tocptr[ 6 ] << 8 ) | ( tocptr[ 7 ] );
			/*
			 *	Data or audio track.
			 */
			TOCFlags[     TOCNumTracks ] = ( tocptr[ 1 ] & 0x04 ) ? 1 : 0;
			TOCNumTracks++;
		}
		TOCNumTracks--;
	}

	/*
	 *	Build CD identification. This string is used
	 *	for the file name of the disk-files. Usually this
	 *	should be unique enough. I do not use the CD PIN-Code
	 *	since it seems that not all disks have one.
	 *
	 *	This is also the way MCDP by Boris Jakubaschk does it.
	 */
	sprintf( CDID, "%02ld%06lx%06lx", TOCNumTracks, TOCTrackAddr[ 2 ], TOCTrackAddr[ TOCNumTracks ] );
	/*
	 *	Read disk file.
	 */
	LoadDiskFile();
	/*
	 *	Total disk time.
	 */
	TotalIDA = TOCTrackAddr[ TOCNumTracks ] / 75 / 60;
	TotalIDB = ( TOCTrackAddr[ TOCNumTracks ] / 75 ) % 60;
	SetGadgetAttrs(( struct Gadget * )GO_TotalA, Player, NULL, INDIC_Level, TotalIDA, TAG_END );
	SetGadgetAttrs(( struct Gadget * )GO_TotalB, Player, NULL, INDIC_Level, TotalIDB, TAG_END );
	/*
	 *	Enable/Disable track buttons.
	 */
	for ( i = 0; i < 20; i++ )
		SetGadgetAttrs(( struct Gadget * )TrackButtons[ i ], Player, NULL, GA_Disabled, i < TOCNumTracks ? FALSE : TRUE, TAG_END );
	/*
	 *	Disk and Artist name.
	 */
	if ( Status != SCSI_STAT_NO_DISK ) {
		SetGadgetAttrs(( struct Gadget * )GO_Title,	 Player, NULL, INFO_TextFormat, DiskName, TAG_END );
		SetGadgetAttrs(( struct Gadget * )GO_TrackTitle, Player, NULL, INFO_TextFormat, Artist,   TAG_END );
	}
	/*
	 *	Enable Edit CD menu.
	 */
	if ( WO_Player ) {
		if ( TOCNumTracks )
			DisableMenu( WO_Player, ID_EDIT, FALSE );
	}
}

/*
 *	Play a audio track.
 */
Prototype VOID SCSI_PlayAudio( WORD );

VOID SCSI_PlayAudio( WORD starttrack )
{
	static struct SCSICmd12 command = { SCSI_CMD_PLAYAUDIO12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	WORD			i = 1;
	ULONG			addr;

	/*
	 *	Force an existing audio track.
	 */
	while (( TOCFlags[ starttrack - 1 ] == 1 ) && ( starttrack < TOCNumTracks )) starttrack++;

	/*
	 *	Start address of the track.
	 */
	addr = TOCTrackAddr[ starttrack - 1 ] + 1;

	command.B2 = ( addr & 0xFF000000 ) >> 24;
	command.B3 = ( addr & 0x00FF0000 ) >> 16;
	command.B4 = ( addr & 0x0000FF00 ) >> 8;
	command.B5 = ( addr & 0x000000FF );

	/*
	 *	End address of the disk.
	 */
	addr = TOCTrackAddr[ TOCNumTracks ] - TOCTrackAddr[ starttrack - 1 ] - 1;

	command.B6 = ( addr & 0xFF000000 ) >> 24;
	command.B7 = ( addr & 0x00FF0000 ) >> 16;
	command.B8 = ( addr & 0x0000FF00 ) >> 8;
	command.B9 = ( addr & 0x000000FF );

	DoSCSICmd(( UBYTE * )SCSIData, MAX_DATA_LEN, ( UBYTE * )&command, sizeof( command ), SCSIF_READ | SCSIF_AUTOSENSE );
};

/*
 *	Pause continue playing.
 */
Prototype VOID SCSI_PauseResume( void );

VOID SCSI_PauseResume( void )
{
	static struct SCSICmd10 command = { SCSI_CMD_PAUSERESUME, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

	command.B8 = ( Status == SCSI_STAT_PLAYING ) ? 0x00 : 0x01;

	DoSCSICmd( 0, 0, ( UBYTE * )&command, sizeof( command ), SCSIF_READ | SCSIF_AUTOSENSE );
}

/*
 *	Open drive door.
 */
Prototype VOID SCSI_Eject( void );

VOID SCSI_Eject( void )
{
	static struct SCSICmd6 command = { SCSI_CMD_SSU, 0, 0, 0, 0, 0 };

	command.B4 = 2;

	DoSCSICmd( 0, 0, ( UBYTE * )&command, sizeof( command ), SCSIF_READ | SCSIF_AUTOSENSE );
}

/*
 *	Stop playing.
 */
Prototype VOID SCSI_Stop( void );

VOID SCSI_Stop( void )
{
	static struct SCSICmd6 command = { SCSI_CMD_SSU, 0, 0, 0, 0, 0 };

	command.B4 = 0;

	DoSCSICmd( 0, 0, ( UBYTE * )&command, sizeof( command ), SCSIF_READ | SCSIF_AUTOSENSE );
}

/*
 *	Adjust output volume.
 */
Prototype VOID SCSI_SetVolume( WORD, WORD, WORD, WORD );

VOID SCSI_SetVolume( WORD vol0, WORD vol1, WORD vol2, WORD vol3 )
{
	WORD			i, j;
	static struct SCSICmd6	modecommand;
	static struct volmodedata {
		UBYTE head[4];
		UBYTE page;	  /* page code 0x0E					*/
		UBYTE plength;	  /* page length					*/
		UBYTE b2;	  /* bit 2: Immed, bit 1: SOTC				*/
		UBYTE b3;	  /* reserved						*/
		UBYTE b4;	  /* reserved						*/
		UBYTE b5;	  /* bit 7: APRVal, bit 3-0: format of LBAs / Sec.	*/
		UWORD bps;	  /* logical blocks per second audio playback		*/
		UBYTE out0;	  /* lower 4 bits: output port 0 channel selection	*/
		UBYTE vol0;	  /* output port 0 volume				*/
		UBYTE out1;	  /* lower 4 bits: output port 1 channel selection	*/
		UBYTE vol1;	  /* output port 1 volume				*/
		UBYTE out2;	  /* lower 4 bits: output port 2 channel selection	*/
		UBYTE vol2;	  /* output port 2 volume				*/
		UBYTE out3;	  /* lower 4 bits: output port 3 channel selection	*/
		UBYTE vol3;	  /* output port 3 volume				*/
	} modedata;

	for ( i = 0; i < 4; i++ ) modedata.head[i] = 0;

	modecommand.Opcode    = SCSI_CMD_MSE;
	modecommand.B1	      = 0;
	modecommand.B2	      = 0x0E;
	modecommand.B3	      = 0;
	modecommand.B4	      = MAX_DATA_LEN;
	modecommand.Control   = 0;

	if ( DoSCSICmd(( UBYTE * )SCSIData, MAX_DATA_LEN, ( UBYTE * )&modecommand, sizeof( modecommand ), SCSIF_READ | SCSIF_AUTOSENSE ))
		return;

	for ( j = ( SCSIData[ 0 ] + 1 ), i = SCSIData[ 3 ] + 4; i < j; i += SCSIData[ i + 1 ] + 2 )
		memcpy( &modedata.page, &SCSIData[ i ], 16 );

	modedata.page		= 0x0E;
	modedata.plength	= 0x0E;

	if ( vol0 >= 0 ) modedata.vol0 = vol0;
	if ( vol1 >= 0 ) modedata.vol1 = vol1;
	if ( vol2 >= 0 ) modedata.vol2 = vol2;
	if ( vol3 >= 0 ) modedata.vol3 = vol3;

	modecommand.Opcode	  = SCSI_CMD_MSL;
	modecommand.B1		  = 0x10;
	modecommand.B2		  = 0;
	modecommand.B3		  = 0;
	modecommand.B4		  = sizeof( modedata );
	modecommand.Control	  = 0;

	DoSCSICmd(( UBYTE * )&modedata, sizeof( modedata ), ( UBYTE * )&modecommand, sizeof( modecommand ), SCSIF_WRITE | SCSIF_AUTOSENSE );
}

/*
 *	Jump "blocks" frames.
 */
Prototype void SCSI_Jump( WORD );

void SCSI_Jump( WORD blocks )
{
	static struct SCSICmd10 command1 = { SCSI_CMD_READSUBCHANNEL, 0, 0x40, 0, 0, 0, 0, 0, 0, 0 };
	static struct SCSICmd12 command2 = { SCSI_CMD_PLAYAUDIO12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	ULONG			addr;

	command1.B2 = 0x40;
	command1.B3 = 1;
	command1.B6 = 0;
	command1.B7 = 255;
	command1.B8 = 255;

	if ( ! DoSCSICmd(( UBYTE * )SCSIData, MAX_DATA_LEN, ( UBYTE * )&command1, sizeof( command1 ), SCSIF_READ | SCSIF_AUTOSENSE)) {

		addr  = ( SCSIData[ 8 ] << 24 ) | ( SCSIData[ 9 ] << 16 ) | ( SCSIData[ 10 ] << 8 ) | ( SCSIData[ 11 ] );
		addr += blocks;

		if (( addr >= TOCTrackAddr[ Track - 1 ] ) && ( addr < TOCTrackAddr[ Track ] )) {
			command2.B2 = ( addr & 0xFF000000 ) >> 24;
			command2.B3 = ( addr & 0x00FF0000 ) >> 16;
			command2.B4 = ( addr & 0x0000FF00 ) >> 8;
			command2.B5 = ( addr & 0x000000FF );

			addr = TOCTrackAddr[ TOCNumTracks ] - TOCTrackAddr[ Track - 1 ] - 1;

			command2.B6 = ( addr & 0xFF000000 ) >> 24;
			command2.B7 = ( addr & 0x00FF0000 ) >> 16;
			command2.B8 = ( addr & 0x0000FF00 ) >> 8;
			command2.B9 = ( addr & 0x000000FF );

			DoSCSICmd(( UBYTE * )SCSIData, MAX_DATA_LEN, ( UBYTE * )&command2, sizeof( command2 ), SCSIF_READ | SCSIF_AUTOSENSE );
		}
	}
}

/*
 *	Read the info of the current CD. Info read is:
 *
 *	Track playing.
 *	Index playing.
 *	Track time played.
 *	Track time to go.
 *
 *	Also reset timer if necessary.
 */
Prototype VOID SCSI_ReadCDInfo( BOOL );

VOID SCSI_ReadCDInfo( BOOL timer )
{
	static struct SCSICmd10 command = { SCSI_CMD_READSUBCHANNEL, 0, 0x40, 0, 0, 0, 0, 0, 0, 0 };
	LONG			microsleft = 950000;
	ULONG			addr;

	command.B2 = 0x40;
	command.B3 = 1;
	command.B6 = 0;
	command.B7 = 255;
	command.B8 = 255;

	if ( DoSCSICmd(( UBYTE * )SCSIData, MAX_DATA_LEN, ( UBYTE * )&command, sizeof( command ), SCSIF_READ | SCSIF_AUTOSENSE )) {
		if ( Status != SCSI_STAT_NO_DISK ) {
			SCSI_ReadTOC();
			/*
			 *	Disable the Edit CD menu and
			 *	update visuals..
			 */
			if ( WO_Player ) {
				DisableMenu( WO_Player, ID_EDIT, TRUE );
				SetGadgetAttrs(( struct Gadget * )GO_Title, Player, NULL, INFO_TextFormat, "<NO DISK>", TAG_END );
				SetGadgetAttrs(( struct Gadget * )GO_TrackTitle, Player, NULL, INFO_TextFormat, "", TAG_END );
			}
			Status = SCSI_STAT_NO_DISK;
		}
	} else if (( SCSIData[ 1 ] == 0x11 ) || ( SCSIData[ 1 ] == 0x12 )) {
		if ( Status == SCSI_STAT_NO_DISK )
			SCSI_ReadTOC();
		/*
		 *	Update disk status.
		 */
		if ( SCSIData[ 1 ] == 0x11 ) Status = SCSI_STAT_PLAYING;
		else			     Status = SCSI_STAT_PAUSED;

		/*
		 *	Update track number.
		 */
		if ( SCSIData[ 6 ] != Track ) {
			Track = TrackID = SCSIData[ 6 ];
			SetGadgetAttrs(( struct Gadget * )GO_TrackTitle, Player, NULL, INFO_TextFormat, &DiskTracks[ Track - 1 ][ 0 ], TAG_END );
		}

		/*
		 *	Update index number.
		 */
		IndexID = SCSIData[ 7 ];

		/*
		 *	Pickup and update title time.
		 */
		addr = ( SCSIData[ 12 ] << 24 ) | ( SCSIData[ 13 ] << 16 ) | ( SCSIData[ 14 ] << 8 ) | ( SCSIData[ 15 ] );

		TimeIDA = addr / 75 / 60;
		TimeIDB = ( addr / 75 ) % 60;

		microsleft = ( Status == SCSI_STAT_PLAYING ) ? (( 75 - addr % 75 ) * 13333 + 1000 ) : 999000;

		/*
		 *	Pickup and update time to go.
		 */
		addr = ( SCSIData[ 8 ] << 24 ) | ( SCSIData[ 9 ] << 16 ) | ( SCSIData[ 10 ] << 8 ) | ( SCSIData[ 11 ] );
		addr = TOCTrackAddr[ SCSIData[ 6 ]] - addr;

		if ( addr > 80 ) microsleft = (( addr < 75 ) ? addr : 74 ) * 13333 + 100;

		TogoIDA = addr / 75 / 60;
		TogoIDB = ( addr / 75 ) % 60;

	} else if ( Status != SCSI_STAT_STOPPED ) {
		if ( Status == SCSI_STAT_NO_DISK )
			SCSI_ReadTOC();
		/*
		 *	Reset all information.
		 */
		Track = 0;
		TrackID = IndexID = TimeIDA = TimeIDB = TogoIDA = TogoIDB = 0;
		Status = SCSI_STAT_STOPPED;
		SetGadgetAttrs(( struct Gadget * )GO_Title,	 Player, NULL, INFO_TextFormat, DiskName, TAG_END );
		SetGadgetAttrs(( struct Gadget * )GO_TrackTitle, Player, NULL, INFO_TextFormat, Artist,   TAG_END );
	}
	/*
	 *	Visual update.
	 */
	SetGadgetAttrs(( struct Gadget * )GO_Track, Player, NULL, INDIC_Level, TrackID, TAG_END );
	SetGadgetAttrs(( struct Gadget * )GO_Index, Player, NULL, INDIC_Level, IndexID, TAG_END );
	SetGadgetAttrs(( struct Gadget * )GO_TimeA, Player, NULL, INDIC_Level, TimeIDA, TAG_END );
	SetGadgetAttrs(( struct Gadget * )GO_TimeB, Player, NULL, INDIC_Level, TimeIDB, TAG_END );
	SetGadgetAttrs(( struct Gadget * )GO_TogoA, Player, NULL, INDIC_Level, TogoIDA, TAG_END );
	SetGadgetAttrs(( struct Gadget * )GO_TogoB, Player, NULL, INDIC_Level, TogoIDB, TAG_END );
	/*
	 *	Re-trigger the timer.
	 */
	if ( timer ) TriggerTimer( microsleft );
}
