/* $VER: cd.h 1.11 (12.8.1993) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes'
{#include <devices/cd.h>}
NATIVE {DEVICES_CD_H} CONST

/**************************************************************************
 *									  *
 *   CD Commands							  *
 *									  *
 **************************************************************************/

NATIVE {CD_RESET}	     CONST CD_RESET	     = 1
NATIVE {CD_READ}	     CONST CD_READ	     = 2
NATIVE {CD_WRITE}	     CONST CD_WRITE	     = 3
NATIVE {CD_UPDATE}	     CONST CD_UPDATE	     = 4
NATIVE {CD_CLEAR}	     CONST CD_CLEAR	     = 5
NATIVE {CD_STOP}	     CONST CD_STOP	     = 6
NATIVE {CD_START}	     CONST CD_START	     = 7
NATIVE {CD_FLUSH}	     CONST CD_FLUSH	     = 8
NATIVE {CD_MOTOR}	     CONST CD_MOTOR	     = 9
NATIVE {CD_SEEK}	    CONST CD_SEEK	    = 10
NATIVE {CD_FORMAT}	    CONST CD_FORMAT	    = 11
NATIVE {CD_REMOVE}	    CONST CD_REMOVE	    = 12
NATIVE {CD_CHANGENUM}	    CONST CD_CHANGENUM	    = 13
NATIVE {CD_CHANGESTATE}	    CONST CD_CHANGESTATE	    = 14
NATIVE {CD_PROTSTATUS}	    CONST CD_PROTSTATUS	    = 15

NATIVE {CD_GETDRIVETYPE}     CONST CD_GETDRIVETYPE     = 18
NATIVE {CD_GETNUMTRACKS}     CONST CD_GETNUMTRACKS     = 19
NATIVE {CD_ADDCHANGEINT}     CONST CD_ADDCHANGEINT     = 20
NATIVE {CD_REMCHANGEINT}     CONST CD_REMCHANGEINT     = 21
NATIVE {CD_GETGEOMETRY}	    CONST CD_GETGEOMETRY	    = 22
NATIVE {CD_EJECT}	    CONST CD_EJECT	    = 23


NATIVE {CD_INFO}	    CONST CD_INFO	    = 32
NATIVE {CD_CONFIG}	    CONST CD_CONFIG	    = 33
NATIVE {CD_TOCMSF}	    CONST CD_TOCMSF	    = 34
NATIVE {CD_TOCLSN}	    CONST CD_TOCLSN	    = 35

NATIVE {CD_READXL}	    CONST CD_READXL	    = 36

NATIVE {CD_PLAYTRACK}	    CONST CD_PLAYTRACK	    = 37
NATIVE {CD_PLAYMSF}	    CONST CD_PLAYMSF	    = 38
NATIVE {CD_PLAYLSN}	    CONST CD_PLAYLSN	    = 39
NATIVE {CD_PAUSE}	    CONST CD_PAUSE	    = 40
NATIVE {CD_SEARCH}	    CONST CD_SEARCH	    = 41

NATIVE {CD_QCODEMSF}	    CONST CD_QCODEMSF	    = 42
NATIVE {CD_QCODELSN}	    CONST CD_QCODELSN	    = 43
NATIVE {CD_ATTENUATE}	    CONST CD_ATTENUATE	    = 44

NATIVE {CD_ADDFRAMEINT}	    CONST CD_ADDFRAMEINT	    = 45
NATIVE {CD_REMFRAMEINT}	    CONST CD_REMFRAMEINT	    = 46


/**************************************************************************
 *									  *
 *   Device Driver Error Codes						  *
 *									  *
 **************************************************************************/

NATIVE {CDERR_OPENFAIL}	     CONST CDERR_OPENFAIL	     = (-1) /* device/unit failed to open	  */
NATIVE {CDERR_ABORTED}	     CONST CDERR_ABORTED	     = (-2) /* request terminated early		  */
NATIVE {CDERR_NOCMD}	     CONST CDERR_NOCMD	     = (-3) /* command not supported by device	  */
NATIVE {CDERR_BADLENGTH}      CONST CDERR_BADLENGTH      = (-4) /* invalid length (IO_LENGTH/IO_OFFSET) */
NATIVE {CDERR_BADADDRESS}     CONST CDERR_BADADDRESS     = (-5) /* invalid address (IO_DATA misaligned) */
NATIVE {CDERR_UNITBUSY}	     CONST CDERR_UNITBUSY	     = (-6) /* device opens ok, but unit is busy	  */
NATIVE {CDERR_SELFTEST}	     CONST CDERR_SELFTEST	     = (-7) /* hardware failed self-test		  */

NATIVE {CDERR_NotSpecified}   CONST CDERR_NOTSPECIFIED   = 20   /* general catchall			  */
NATIVE {CDERR_NoSecHdr}	     CONST CDERR_NOSECHDR	     = 21   /* couldn't even find a sector	  */
NATIVE {CDERR_BadSecPreamble} CONST CDERR_BADSECPREAMBLE = 22   /* sector looked wrong		  */
NATIVE {CDERR_BadSecID}	     CONST CDERR_BADSECID	     = 23   /* ditto				  */
NATIVE {CDERR_BadHdrSum}      CONST CDERR_BADHDRSUM      = 24   /* header had incorrect checksum	  */
NATIVE {CDERR_BadSecSum}      CONST CDERR_BADSECSUM      = 25   /* data had incorrect checksum	  */
NATIVE {CDERR_TooFewSecs}     CONST CDERR_TOOFEWSECS     = 26   /* couldn't find enough sectors	  */
NATIVE {CDERR_BadSecHdr}      CONST CDERR_BADSECHDR      = 27   /* another "sector looked wrong"	  */
NATIVE {CDERR_WriteProt}      CONST CDERR_WRITEPROT      = 28   /* can't write to a protected disk	  */
NATIVE {CDERR_NoDisk}	     CONST CDERR_NODISK	     = 29   /* no disk in the drive		  */
NATIVE {CDERR_SeekError}      CONST CDERR_SEEKERROR      = 30   /* couldn't find track 0		  */
NATIVE {CDERR_NoMem}	     CONST CDERR_NOMEM	     = 31   /* ran out of memory			  */
NATIVE {CDERR_BadUnitNum}     CONST CDERR_BADUNITNUM     = 32   /* asked for a unit > NUMUNITS	  */
NATIVE {CDERR_BadDriveType}   CONST CDERR_BADDRIVETYPE   = 33   /* not a drive cd.device understands	  */
NATIVE {CDERR_DriveInUse}     CONST CDERR_DRIVEINUSE     = 34   /* someone else allocated the drive	  */
NATIVE {CDERR_PostReset}      CONST CDERR_POSTRESET      = 35   /* user hit reset; awaiting doom	  */
NATIVE {CDERR_BadDataType}    CONST CDERR_BADDATATYPE    = 36   /* data on disk is wrong type	  */
NATIVE {CDERR_InvalidState}   CONST CDERR_INVALIDSTATE   = 37   /* invalid cmd under current conditions */

NATIVE {CDERR_Phase}	     CONST CDERR_PHASE	     = 42   /* illegal or unexpected SCSI phase	  */
NATIVE {CDERR_NoBoard}	     CONST CDERR_NOBOARD	     = 50   /* open failed for non-existant board   */



/**************************************************************************
 *									  *
 * Configuration							  *
 *									  *
 *	 The drive is configured by TagList items defined as follows:	  *
 *									  *
 **************************************************************************/

NATIVE {TAGCD_PLAYSPEED}	CONST TAGCD_PLAYSPEED	= $0001
NATIVE {TAGCD_READSPEED}	CONST TAGCD_READSPEED	= $0002
NATIVE {TAGCD_READXLSPEED}	CONST TAGCD_READXLSPEED	= $0003
NATIVE {TAGCD_SECTORSIZE}	CONST TAGCD_SECTORSIZE	= $0004
NATIVE {TAGCD_XLECC}		CONST TAGCD_XLECC		= $0005
NATIVE {TAGCD_EJECTRESET}	CONST TAGCD_EJECTRESET	= $0006


/**************************************************************************
 *									  *
 * Information								  *
 *									  *
 *	Information/Status structure describes current speed settings	  *
 *	for read and play commands, sector size, audio attenuation	  *
 *	precision, and drive status.					  *
 *									  *
 **************************************************************************/

NATIVE {CDInfo} OBJECT cdinfo
			    /*				      Default	  */
    {PlaySpeed}	playspeed	:UINT	    /* Audio play speed	      (75)	  */
    {ReadSpeed}	readspeed	:UINT	    /* Data-rate of CD_READ command   (Max)	  */
    {ReadXLSpeed}	readxlspeed	:UINT    /* Data-rate of CD_READXL command (75)	  */
    {SectorSize}	sectorsize	:UINT     /* Number of bytes per sector     (2048)	  */
    {XLECC}	xlecc	:UINT	    /* CDXL ECC enabled/disabled		  */
    {EjectReset}	ejectreset	:UINT     /* Reset on eject enabled/disabled		  */
    {Reserved1}	reserved1[4]	:ARRAY OF UINT   /* Reserved for future expansion		  */

    {MaxSpeed}	maxspeed	:UINT	    /* Maximum speed drive can handle (75, 150)   */
    {AudioPrecision}	audioprecision	:UINT /* 0 = no attenuator, 1 = mute only,	  */
			    /* other = (# levels - 1)			  */
    {Status}	status	:UINT	    /* See flags below				  */
    {Reserved2}	reserved2[4]	:ARRAY OF UINT   /* Reserved for future expansion		  */
    ENDOBJECT


/* Flags for Status */

NATIVE {CDSTSB_CLOSED}	 CONST CDSTSB_CLOSED	 = 0 /* Drive door is closed			  */
NATIVE {CDSTSB_DISK}	 CONST CDSTSB_DISK	 = 1 /* A disk has been detected			  */
NATIVE {CDSTSB_SPIN}	 CONST CDSTSB_SPIN	 = 2 /* Disk is spinning (motor is on)		  */
NATIVE {CDSTSB_TOC}	 CONST CDSTSB_TOC	 = 3 /* Table of contents read.  Disk is valid.	  */
NATIVE {CDSTSB_CDROM}	 CONST CDSTSB_CDROM	 = 4 /* Track 1 contains CD-ROM data		  */
NATIVE {CDSTSB_PLAYING}	 CONST CDSTSB_PLAYING	 = 5 /* Audio is playing				  */
NATIVE {CDSTSB_PAUSED}	 CONST CDSTSB_PAUSED	 = 6 /* Pause mode (pauses on play command)	  */
NATIVE {CDSTSB_SEARCH}	 CONST CDSTSB_SEARCH	 = 7 /* Search mode (Fast Forward/Fast Reverse)	  */
NATIVE {CDSTSB_DIRECTION} CONST CDSTSB_DIRECTION = 8 /* Search direction (0 = Forward, 1 = Reverse) */

NATIVE {CDSTSF_CLOSED}	 CONST CDSTSF_CLOSED	 = $0001
NATIVE {CDSTSF_DISK}	 CONST CDSTSF_DISK	 = $0002
NATIVE {CDSTSF_SPIN}	 CONST CDSTSF_SPIN	 = $0004
NATIVE {CDSTSF_TOC}	 CONST CDSTSF_TOC	 = $0008
NATIVE {CDSTSF_CDROM}	 CONST CDSTSF_CDROM	 = $0010
NATIVE {CDSTSF_PLAYING}	 CONST CDSTSF_PLAYING	 = $0020
NATIVE {CDSTSF_PAUSED}	 CONST CDSTSF_PAUSED	 = $0040
NATIVE {CDSTSF_SEARCH}	 CONST CDSTSF_SEARCH	 = $0080
NATIVE {CDSTSF_DIRECTION} CONST CDSTSF_DIRECTION = $0100


/* Modes for CD_SEARCH */

NATIVE {CDMODE_NORMAL}	CONST CDMODE_NORMAL	= 0	  /* Normal play at current play speed	  */
NATIVE {CDMODE_FFWD}	CONST CDMODE_FFWD	= 1	  /* Fast forward play (skip-play forward)*/
NATIVE {CDMODE_FREV}	CONST CDMODE_FREV	= 2	  /* Fast reverse play (skip-play reverse)*/


/**************************************************************************
 *									  *
 * Position Information						  *
 *									  *
 *	Position information can be described in two forms: MSF and LSN   *
 *	form.  MSF (Minutes, Seconds, Frames) form is a time encoding.	  *
 *	LSN (Logical Sector Number) form is frame (sector) count.	  *
 *	The desired form is selected using the io_Flags field of the	  *
 *	IOStdReq structure.  The flags and the union are described	  *
 *	below.								  *
 *									  *
 **************************************************************************/

NATIVE {RMSF} OBJECT rmsf

    {Reserved}	reserved	:UBYTE	    /* Reserved (always zero) */
    {Minute}	minute	:UBYTE	    /* Minutes (0-72ish)      */
    {Second}	second	:UBYTE	    /* Seconds (0-59)	      */
    {Frame}	frame	:UBYTE	    /* Frame   (0-74)	      */
    ENDOBJECT

NATIVE {LSNMSF} OBJECT lsnmsf

    {MSF}	msf	:rmsf	    /* Minute, Second, Frame  */
    {LSN}	lsn	:ULONG	    /* Logical Sector Number  */
    ENDOBJECT


/**************************************************************************
 *									  *
 * CD Transfer Lists							  *
 *									  *
 *	A CDXL node is a double link node; however only single linkage	  *
 *	is used by the device driver.  If you wish to construct a	  *
 *	transfer list manually, it is only neccessary to define the	  *
 *	mln_Succ pointer of the MinNode.  You may also use the Exec	  *
 *	list functions by defining a List or MinList structure and by	  *
 *	using the AddHead/AddTail functions to create the list.  This	  *
 *	will create a double-linked list.  Although a double-linked	  *
 *	list is not required by the device driver, you may wish use it	  *
 *	for your own purposes.	Don't forget to initialize the		  *
 *	the List/MinList before using it!				  *
 *									  *
 **************************************************************************/

NATIVE {CDXL} OBJECT cdxl

    {Node}	node	:mln	       /* double linkage		  */
    {Buffer}	buffer	:ARRAY OF CHAR	       /* data destination (word aligned) */
    {Length}	length	:VALUE	       /* must be even # bytes		  */
    {Actual}	actual	:VALUE	       /* bytes transferred		  */
    {IntData}	intdata	:APTR	       /* interrupt server data segment   */
    {IntCode}	intcode	:NATIVE {VOID	      (*)()} PTR    /* interrupt server code entry	  */
    ENDOBJECT


/**************************************************************************
 *									  *
 * CD Table of Contents						  *
 *									  *
 *	The CD_TOC command returns an array of CDTOC entries.		  *
 *	Entry zero contains summary information describing how many	  *
 *	tracks the disk has and the play-time of the disk.		  *
 *	Entries 1 through N (N = Number of tracks on disk) contain	  *
 *	information about the track.					  *
 *									  *
 **************************************************************************/

NATIVE {TOCSummary} OBJECT tocsummary

    {FirstTrack}	firsttrack	:UBYTE /* First track on disk (always 1)		  */
    {LastTrack}	lasttrack	:UBYTE  /* Last track on disk			  */
    {LeadOut}	leadout	:lsnmsf    /* Beginning of lead-out track (end of disk) */
    ENDOBJECT


NATIVE {TOCEntry} OBJECT tocentry

    {CtlAdr}	ctladr	:UBYTE     /* Q-Code info		     */
    {Track}	track	:UBYTE      /* Track number		     */
    {Position}	position	:lsnmsf   /* Start position of this track */
    ENDOBJECT


NATIVE {CDTOC} OBJECT cdtoc

    {Summary}	summary	:tocsummary	/* First entry (0) is summary information */
    {Entry}	entry	:tocentry	/* Entries 1-N are track entries	  */
    ENDOBJECT



/**************************************************************************
 *									  *
 * Q-Code Packets							  *
 *									  *
 *	Q-Code packets are only returned when audio is playing.	  *
 *	Currently, only position packets are returned (ADR_POSITION)	  *
 *	The other ADR_ types are almost never encoded on the disk	  *
 *	and are of little use anyway.  To avoid making the QCode	  *
 *	structure a union, these other ADR_ structures are not defined.   *
 *									  *
 **************************************************************************/

NATIVE {QCode} OBJECT qcode

    {CtlAdr}	ctladr	:UBYTE	/* Data type / QCode type	    */
    {Track}	track	:UBYTE	/* Track number		    */
    {Index}	index	:UBYTE	/* Track subindex number	    */
    {Zero}	zero	:UBYTE		/* The "Zero" byte of Q-Code packet */
    {TrackPosition}	trackposition	:lsnmsf /* Position from start of track     */
    {DiskPosition}	diskposition	:lsnmsf	/* Position from start of disk	    */
    ENDOBJECT


NATIVE {CTLADR_CTLMASK} CONST CTLADR_CTLMASK = $F0   /* Control field */

NATIVE {CTL_CTLMASK}    CONST CTL_CTLMASK    = $D0   /* To be ANDed with CtlAdr before compared  */

NATIVE {CTL_2AUD}       CONST CTL_2AUD       = $00   /* 2 audio channels without preemphasis	  */
NATIVE {CTL_2AUDEMPH}   CONST CTL_2AUDEMPH   = $10   /* 2 audio channels with preemphasis	  */
NATIVE {CTL_4AUD}       CONST CTL_4AUD       = $80   /* 4 audio channels without preemphasis	  */
NATIVE {CTL_4AUDEMPH}   CONST CTL_4AUDEMPH   = $90   /* 4 audio channels with preemphasis	  */
NATIVE {CTL_DATA}       CONST CTL_DATA       = $40   /* CD-ROM Data				  */

NATIVE {CTL_COPYMASK}   CONST CTL_COPYMASK   = $20   /* To be ANDed with CtlAdr before compared  */

NATIVE {CTL_COPY}       CONST CTL_COPY       = $20   /* When true, this audio/data can be copied */

NATIVE {CTLADR_ADRMASK} CONST CTLADR_ADRMASK = $0F   /* Address field				  */

NATIVE {ADR_POSITION}   CONST ADR_POSITION   = $01   /* Q-Code is position information	  */
NATIVE {ADR_UPC}        CONST ADR_UPC        = $02   /* Q-Code is UPC information (not used)	  */
NATIVE {ADR_ISRC}       CONST ADR_ISRC       = $03   /* Q-Code is ISRC (not used)		  */
NATIVE {ADR_HYBRID}     CONST ADR_HYBRID     = $05   /* This disk is a hybrid disk		  */
