/****h* AmigaTalk/CDROM.c [3.0] *************************************
*
* NAME 
*   CDROM.c
*
* DESCRIPTION
*   Functions that handle cd.device to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleMiscDevices( int numargs, OBJECT **args )
*                 <218 0 ??> for CDROM
*
* HISTORY
*   24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*   08-Jan-2003 - Moved all string constants to StringConstants.h
*
*   16-May-2002 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/CDROM.c 3.0 (24-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <devices/cd.h>
#include <devices/trackdisk.h> // for struct DriveGeometry

#include <utility/tagitem.h>

#ifndef __amigaos4__
 
# include <clib/exec_protos.h>
# include <clib/dos_protos.h>

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>

IMPORT struct ExecIFace *IExec;

#endif

#include <proto/locale.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"

#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

// --------------------------------------------------------------------

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *SystemProblem;
IMPORT UBYTE *UserPgmError;
IMPORT UBYTE *AllocProblem;

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

struct CDStructs { // HIDDEN

   struct CDInfo *cds_CDInfo;
   union  LSNMSF *cds_LSNMSF;
   struct CDXL   *cds_CDXL;
   union  CDTOC  *cds_CDTOC;
   struct QCode  *cds_QCode;
};

// private1 == struct CDStructs *cds;
// private2 == struct IOStdReq  *cdio;
// private3 == struct MsgPort   *cdmp;

// --------------------------------------------------------------------

PUBLIC char *CDErrStrs[30] = { NULL, };

/*
// CD_CONFIG

#define TAGCD_PLAYSPEED    0x0001
#define TAGCD_READSPEED    0x0002
#define TAGCD_READXLSPEED  0x0003
#define TAGCD_SECTORSIZE   0x0004
#define TAGCD_XLECC        0x0005
#define TAGCD_EJECTRESET   0x0006

// Modes for CD_SEARCH 

#define CDMODE_NORMAL	0	  // Normal play at current play speed	  
#define CDMODE_FFWD	1	  // Fast forward play (skip-play forward)
#define CDMODE_FREV	2	  // Fast reverse play (skip-play reverse)


struct CDInfo {

    UWORD   Status;	    // See flags below
};

// Flags for Status 

#define CDSTSF_CLOSED	 1   // Drive door is closed			  
#define CDSTSF_DISK	 2   // A disk has been detected			  
#define CDSTSF_SPIN	 4   // Disk is spinning (motor is on)		  
#define CDSTSF_TOC	 8   // Table of contents read.  Disk is valid.	  
#define CDSTSF_CDROM	 16  // Track 1 contains CD-ROM data		  
#define CDSTSF_PLAYING	 32  // Audio is playing				  
#define CDSTSF_PAUSED	 64  // Pause mode (pauses on play command)	  
#define CDSTSF_SEARCH	 128 // Search mode (Fast Forward/Fast Reverse)	  
#define CDSTSF_DIRECTION 256 // Search direction (0 = Forward, 1 = Reverse) 


//*************************************************************************
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
 *************************************************************************

struct RMSF {

    UBYTE   Reserved;	    // Reserved (always zero) 
    UBYTE   Minute;	    // Minutes (0-72ish)      
    UBYTE   Second;	    // Seconds (0-59)	      
    UBYTE   Frame;	    // Frame   (0-74)	      
};

union LSNMSF {

   struct RMSF MSF;	    // Minute, Second, Frame  
   ULONG       LSN;	    // Logical Sector Number  
};


//*************************************************************************
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
 *	list is not required by the device driver, you may use it	  *
 *	for your own purposes.	Don't forget to initialize the		  *
 *	the List/MinList before using it!				  *


struct	CDXL {

   struct MinNode  Node;       // double linkage		  
   char           *Buffer;     // data destination (word aligned) 
   LONG            Length;     // must be even # bytes		  
   LONG	           Actual;     // bytes transferred		  
   APTR	           IntData;    // interrupt server data segment   
   VOID	         (*IntCode)(); // interrupt server code entry	  
};


//*************************************************************************
 *									  *
 * CD Table of Contents						  *
 *									  *
 *	The CD_TOC command returns an array of CDTOC entries.		  *
 *	Entry zero contains summary information describing how many	  *
 *	tracks the disk has and the play-time of the disk.		  *
 *	Entries 1 through N (N = Number of tracks on disk) contain	  *
 *	information about the track.					  *
 *									  *
 *************************************************************************

struct TOCSummary {

    UBYTE	 FirstTrack; // First track on disk (always 1)		  
    UBYTE	 LastTrack;  // Last track on disk			  
    union LSNMSF LeadOut;    // Beginning of lead-out track (end of disk) 
};


struct TOCEntry {

    UBYTE	 CtlAdr;     // Q-Code info		     
    UBYTE	 Track;      // Track number		     

    union LSNMSF Position;   // Start position of this track 
};


union CDTOC {

    struct TOCSummary Summary;	// First entry (0) is summary information 
    struct TOCEntry   Entry;	// Entries 1-N are track entries	  
};



//*************************************************************************
 *									  *
 * Q-Code Packets							  *
 *									  *
 *	Q-Code packets are only returned when audio is playing.	  *
 *	Currently, only position packets are returned (ADR_POSITION)	  *
 *	The other ADR_ types are almost never encoded on the disk	  *
 *	and are of little use anyway.  To avoid making the QCode	  *
 *	structure a union, these other ADR_ structures are not defined.   *
 *									  *
 *************************************************************************

struct QCode {

    UBYTE	 CtlAdr;	// Data type / QCode type	    
    UBYTE	 Track;         // Track number		    
    UBYTE	 Index;         // Track subindex number	    
    UBYTE	 Zero;		// The "Zero" byte of Q-Code packet 
    union LSNMSF TrackPosition; // Position from start of track     
    union LSNMSF DiskPosition;	// Position from start of disk	    
};


#define CTLADR_CTLMASK 0xF0   // Control field 

#define CTL_CTLMASK    0xD0   // To be ANDed with CtlAdr before comparisons

#define CTL_2AUD       0x00   // 2 audio channels without preemphasis	  
#define CTL_2AUDEMPH   0x10   // 2 audio channels with preemphasis	  
#define CTL_4AUD       0x80   // 4 audio channels without preemphasis	  
#define CTL_4AUDEMPH   0x90   // 4 audio channels with preemphasis	  
#define CTL_DATA       0x40   // CD-ROM Data				  

#define CTL_COPYMASK   0x20   // To be ANDed with CtlAdr before compared  

#define CTL_COPY       0x20   // When true, this audio/data can be copied 

#define CTLADR_ADRMASK 0x0F   // Address field				  

#define ADR_POSITION   0x01   // Q-Code is position information	  
#define ADR_UPC        0x02   // Q-Code is UPC information (not used)	  
#define ADR_ISRC       0x03   // Q-Code is ISRC (not used)		  
#define ADR_HYBRID     0x05   // This disk is a hybrid disk		  

*/

SUBFUNC char *translateErrNum( int errNum )
{
   int index = 0;

   // First compute valid indices into CDErrStrs[]:   

   if (errNum <= 0)
      index = errNum + 7;
   else if (errNum > CDERR_Phase)         // CDERR_Phase = 42
      index = 27;                         // point to last entry.                 
   else if (errNum == CDERR_Phase)
      index = 26;
   else if (errNum >= CDERR_NotSpecified) // CDERR_NotSpecified = 20
      index = errNum - 12;

   return( CDErrStrs[ index ] );
}

SUBFUNC void AllocationProblem( void )
{
   MemoryOut( CDROMCMsg( MSG_CR_OPEN_FUNC_CDROM ) );
   return;
}

SUBFUNC int AllocCDROM( OBJECT *cdObj )
{
   struct CDStructs *cds = NULL;

   if (!(cds = (struct CDStructs *) AT_AllocVec( sizeof( struct CDStructs ),
                                                 MEMF_CLEAR | MEMF_ANY,
                                                 "CDStruct", TRUE ))) // == NULL)
      {
      MemoryOut( CDROMCMsg( MSG_CR_OPEN_FUNC_CDROM ) );

      return( -1 );
      }

   if (!(cds->cds_CDInfo = (struct CDInfo *) 
                            AT_AllocVec( sizeof( struct CDInfo ), 
                                          MEMF_CLEAR | MEMF_ANY,
                                          "cds_CDInfo", TRUE ))) // == NULL)
      {
      MemoryOut( CDROMCMsg( MSG_CR_OPEN_FUNC_CDROM ) );

      AT_FreeVec( cds, "CDStruct", TRUE );

      return( -2 );
      }

   if (!(cds->cds_LSNMSF = (union LSNMSF *)
                            AT_AllocVec( sizeof( union LSNMSF ), 
                                         MEMF_CLEAR | MEMF_ANY,
                                         "cds_LSNMSF", TRUE ))) // == NULL)
      { 
      MemoryOut( CDROMCMsg( MSG_CR_OPEN_FUNC_CDROM ) );

      AT_FreeVec( cds->cds_CDInfo, "cds_CDInfo", TRUE );
      AT_FreeVec( cds, "CDStruct", TRUE );

      return( -3 );
      }

   if (!(cds->cds_CDXL = (struct CDXL *) 
                          AT_AllocVec( sizeof( struct CDXL ), 
                                       MEMF_CLEAR | MEMF_ANY,
                                       "cds_CDXL", TRUE ))) // == NULL)
      {
      MemoryOut( CDROMCMsg( MSG_CR_OPEN_FUNC_CDROM ) );

      AT_FreeVec( cds->cds_LSNMSF, "cds_LSNMSF", TRUE );
      AT_FreeVec( cds->cds_CDInfo, "cds_CDInfo", TRUE );
      AT_FreeVec( cds, "CDStruct", TRUE );

      return( -4 );
      }

   if (!(cds->cds_CDTOC = (union CDTOC *)
                           AT_AllocVec( 100 * sizeof( union CDTOC ), 
                                        MEMF_CLEAR | MEMF_ANY,
                                        "cds_CDTOC", TRUE ))) // == NULL)
      {
      MemoryOut( CDROMCMsg( MSG_CR_OPEN_FUNC_CDROM ) );

      AT_FreeVec( cds->cds_CDXL,   "cds_CDXL"  , TRUE );
      AT_FreeVec( cds->cds_LSNMSF, "cds_LSNMSF", TRUE );
      AT_FreeVec( cds->cds_CDInfo, "cds_CDInfo", TRUE );
      AT_FreeVec( cds, "CDStruct", TRUE );

      return( -5 );
      }

   if (!(cds->cds_QCode = (struct QCode *) 
                           AT_AllocVec( sizeof( struct QCode ), 
                                        MEMF_CLEAR | MEMF_ANY,
                                        "cds_QCode", TRUE ))) // == NULL)
      {
      MemoryOut( CDROMCMsg( MSG_CR_OPEN_FUNC_CDROM ) );

      AT_FreeVec( cds->cds_CDTOC,  "cds_CDTOC", TRUE  );
      AT_FreeVec( cds->cds_CDXL,   "cds_CDXL" , TRUE  );
      AT_FreeVec( cds->cds_LSNMSF, "cds_LSNMSF", TRUE );
      AT_FreeVec( cds->cds_CDInfo, "cds_CDInfo", TRUE );
      AT_FreeVec( cds, "CDStruct", TRUE );

      return( -6 );
      }

   obj_dec( cdObj->inst_var[0] ); // Dereference nil.

   cdObj->inst_var[0] = new_address( (ULONG) cds );

   return( 0 );
}

SUBFUNC void FreeCDROM( OBJECT *cdObj )
{
   struct CDStructs *cds = (struct CDStructs *) CheckObject( cdObj->inst_var[0] );
   
   if (NullChk( (OBJECT *) cds ) == TRUE)
      return;
      
   if (cds->cds_QCode) // != NULL)
      AT_FreeVec( cds->cds_QCode, "cds_QCode", TRUE );

   if (cds->cds_CDTOC) // != NULL)
      AT_FreeVec( cds->cds_CDTOC, "cds_CDTOC", TRUE );

   if (cds->cds_CDXL) // != NULL)
      AT_FreeVec( cds->cds_CDXL, "cds_CDXL", TRUE );

   if (cds->cds_LSNMSF) // != NULL)
      AT_FreeVec( cds->cds_LSNMSF, "cds_LSNMSF", TRUE );

   if (cds->cds_CDInfo) // != NULL)
      AT_FreeVec( cds->cds_CDInfo, "cds_CDInfo", TRUE );

   AT_FreeVec( cds, "CDStruct", TRUE );

   return;
}

SUBFUNC void DisplayCDError( int errNum )
{
   if (errNum != 0)
      {
      sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_ERR_CDROM ), translateErrNum( errNum ) ); 

      UserInfo( ErrMsg, CDROMCMsg( MSG_CR_PROBLEM_CDROM ) );
      }
   
   return;
}

/****i* closeCDROM() [2.1] ********************************************
*
* NAME
*    closeCDROM()
*
* DESCRIPTION
*    <primitive 218 0 0 self private1 private2 private3>
***********************************************************************
*
*/

METHODFUNC void closeCDROM( OBJECT *cdObj, 
                            OBJECT *cdsObj, 
                            OBJECT *iorObj, 
                            OBJECT *cdmpObj 
                          )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio =  (struct IOStdReq *) CheckObject( iorObj  );
   struct MsgPort   *cdmp =  (struct MsgPort  *) CheckObject( cdmpObj ); 
   
   if (!cdio || !cdmp || !cds) // == NULL)
      return;
      
   if (CheckIO( (struct IORequest *) cdio ) == 0)
      AbortIO(  (struct IORequest *) cdio );

   WaitIO( (struct IORequest *) cdio );

   CloseDevice( (struct IORequest *) cdio );

   DeleteStdIO( cdio );
   DeletePort( cdmp );

   FreeCDROM( cdObj );
   
   return;
}


/****i* openCDROM() [2.1] *********************************************
*
* NAME
*    openCDROM()
*
* DESCRIPTION
*    ^ <primitive 218 0 1 self cdDeviceName unitNumber>
***********************************************************************
*
*/

METHODFUNC OBJECT *openCDROM( OBJECT *cdObj, char *cdDevName, int unit )
{
//   IMPORT struct MsgPort *CreatePort( char *name, ULONG addr );
   
   struct IOStdReq *cdio = NULL;
   struct MsgPort  *cdmp = NULL;
   OBJECT          *rval = o_false;

   struct CDStructs *cds = NULL;

   // --------------------------------------------------------------       

   if (AllocCDROM( cdObj ) < 0)
      {
      return( rval );
      }
            
   if (!(cdmp = CreatePort( NULL, 0 ))) // == NULL)
      {
      CannotCreatePort( CDROMCMsg( MSG_CR_CDROM_STR_CDROM ) );

      FreeCDROM( cdObj );

      return( rval );
      }
   
   if (!(cdio = (struct IOStdReq *) CreateStdIO( cdmp ))) // == NULL)
      {
      CannotCreateStdIO( CDROMCMsg( MSG_CR_CDROM_STR_CDROM ) );

      DeletePort( cdmp );

      FreeCDROM( cdObj );

      return( rval );
      }

   if (OpenDevice( cdDevName, unit, (struct IORequest *) cdio, 0 ) != 0)
      {
      DisplayCDError( cdio->io_Error );

      DeleteStdIO( cdio );
      DeletePort( cdmp );

      FreeCDROM( cdObj );

      return( rval );
      }

   cds = (struct CDStructs *) addr_value( cdObj->inst_var[0] ); // private1 <- cds
   
   cdio->io_Length = sizeof( struct CDInfo );
   cdio->io_Data   = (APTR) cds->cds_CDInfo;

   obj_dec( cdObj->inst_var[1] ); // Dereference nils.
   obj_dec( cdObj->inst_var[2] );

   cdObj->inst_var[1] = AssignObj( new_address( (ULONG) cdio )); // private2 <- cdio (StdioReq)
   cdObj->inst_var[2] = AssignObj( new_address( (ULONG) cdmp )); // private3 <- cdmp (MsgPort)
                                                                 // inst_var[3] <- unitNumber
   return( o_true );
}

/****i* translateCDErrorNumber() [2.1] ********************************
*
* NAME
*    translateCDErrorNumber()
*
* DESCRIPTION
*    ^ <primitive 218 0 2 errNumber>
***********************************************************************
*
*/

METHODFUNC OBJECT *translateCDErrorNumber( int errNum )
{
   return( AssignObj( new_str( translateErrNum( errNum ))));
}

// -------------------------------------------------------------------

SUBFUNC void IssueCDCommand( struct IOStdReq *cdio, int command )
{
   cdio->io_Command = command;
   cdio->io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) cdio );
   WaitIO(  (struct IORequest *) cdio );

   return;
}

#ifdef FULLYDOCUMENTED  // -------------------------------------------

/****i* CDROMReset() [2.1] *******************************************
*
* NAME
*    CDROMReset()
*
* DESCRIPTION
*    Undocumented, therefore this method will NOT apprear in the 
*    CDDevice.st file!!
*
*    <primitive 218 0 3 private2>
**********************************************************************
*
*/

METHODFUNC void CDROMReset( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_RESET );

   return;
}

/****i* CDROMWrite() [2.1] *******************************************
*
* NAME
*    CDROMWrite()
*
* DESCRIPTION
*    Undocumented, therefore this method will NOT apprear in the 
*    CDDevice.st file!!
*
*    <primitive 218 0 5 private2>
**********************************************************************
*
*/

METHODFUNC void CDROMWrite( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_WRITE );

   return;
}

/****i* CDROMStop() [2.1] ********************************************
*
* NAME
*    CDROMStop()
*
* DESCRIPTION
*    Undocumented, therefore this method will NOT apprear in the 
*    CDDevice.st file!!
*
*    <primitive 218 0 6 private2>
**********************************************************************
*
*/

METHODFUNC void CDROMStop( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_STOP );

   return;
}

/****i* CDROMStart() [2.1] *******************************************
*
* NAME
*    CDROMStart()
*
* DESCRIPTION
*    Undocumented, therefore this method will NOT apprear in the 
*    CDDevice.st file!!
*
*    <primitive 218 0 7 private2>
**********************************************************************
*
*/

METHODFUNC void CDROMStart( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_START );

   return;
}

/****i* CDROMUpdate() [2.1] ******************************************
*
* NAME
*    CDROMUpdate()
*
* DESCRIPTION
*    Undocumented, therefore this method will NOT apprear in the 
*    CDDevice.st file!!
*
*    <primitive 218 0 8 private2>
**********************************************************************
*
*/

METHODFUNC void CDROMUpdate( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_UPDATE );

   return;
}

/****i* CDROMClear() [2.1] *******************************************
*
* NAME
*    CDROMClear()
*
* DESCRIPTION
*    Undocumented, therefore this method will NOT apprear in the 
*    CDDevice.st file!!
*
*    <primitive 218 0 10 private2>
**********************************************************************
*
*/

METHODFUNC void CDROMClear( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_CLEAR );

   return;
}

/****i* CDROMFlush() [2.1] *******************************************
*
* NAME
*    CDROMFlush()
*
* DESCRIPTION
*    Undocumented, therefore this method will NOT apprear in the 
*    CDDevice.st file!!
*
*    <primitive 218 0 11 private2>
**********************************************************************
*
*/

gMETHODFUNC void CDROMFlush( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_FLUSH );

   return;
}

/****i* CDROMFormat() [2.1] ******************************************
*
* NAME
*    CDROMFormat()
*
* DESCRIPTION
*    Undocumented, THEREFORE UNUSED!!
*
*    <primitive 218 0 15 private2>
**********************************************************************
*
*/

METHODFUNC void CDROMFormat( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_FORMAT );

   return;
}

/****i* CDROMRemove() [2.1] ******************************************
*
* NAME
*    CDROMRemove()
*
* DESCRIPTION
*    Undocumented, THEREFORE UNUSED!!
*
*    <primitive 218 0 16 private2>
**********************************************************************
*
*/

METHODFUNC void CDROMRemove( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   IssueCDCommand( cdio, CD_REMOVE );

   return;
}

/****i* CDROMGetDriveType() [2.1] ************************************
*
* NAME
*    CDROMGetDriveType()
*
* DESCRIPTION
*    Undocumented, therefore NOT USED!!
*
*    ^ <primitive 218 0 20 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMGetDriveType( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );
   
   IssueCDCommand( cdio, CD_GETDRIVETYPE );

   return( o_true );
}

/****i* CDROMGetNumTracks() [2.1] ************************************
*
* NAME
*    CDROMGetNumTracks()
*
* DESCRIPTION
*    Undocumented, therefore NOT USED!!
*
*    ^ <primitive 218 0 21 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMGetNumTracks( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );
   
   IssueCDCommand( cdio, CD_GETNUMTRACKS );

   return( o_true );
}

#endif // FULLYDOCUMENTED --------------------------------------------


/****i* CDROMRead() [2.1] ********************************************
*
* NAME
*    CDROMRead()
*
* DESCRIPTION
*    ^ <primitive 218 0 4 private2 dataByteArray startLocation>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMRead( OBJECT *cdioObj, OBJECT *dbaObj, int start )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );
   APTR            *data = (APTR)  ((BYTEARRAY *) dbaObj)->bytes;
   ULONG            size = (ULONG) ((BYTEARRAY *) dbaObj)->bsize;

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );

   if (size % 2 != 0)
      {
      if (size > 2)
         {
         size--;
      
         sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_BY_UNEVEN_CDROM ), size + 1, size );

         UserInfo( ErrMsg, UserPgmError );
         }
      else
         {
         sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_BY_ODD_CDROM ), size );
         
         UserInfo( ErrMsg, UserPgmError );
         
         return( o_nil );
         }
      }
   
   if (start % 2 != 0)
      {
      if (start > 2)
         {
         start--;
      
         sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_BY_UNEVEN_CDROM ), start + 1, start );

         UserInfo( ErrMsg, UserPgmError );
         }
      else
         {
         sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_BY_ODD_CDROM ), start );
         
         UserInfo( ErrMsg, UserPgmError );
         
         return( o_nil );
         }
      }
         
   cdio->io_Data   = data;
   cdio->io_Length = size;
   cdio->io_Offset = start;
         
   IssueCDCommand( cdio, CD_READ );

   if (cdio->io_Error != 0)
      {
      DisplayCDError( cdio->io_Error );
      
      return( o_nil );
      }
      
   return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}


/****i* CDROMPause() [2.1] *******************************************
*
* NAME
*    CDROMPause()
*
* DESCRIPTION
*    ^ <primitive 218 0 9 private2 pauseState>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMPause( OBJECT *cdioObj, int pauseState )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );

   cdio->io_Length = (pauseState != 0) ? 1 : 0;
   cdio->io_Data   = NULL;
      
   IssueCDCommand( cdio, CD_PAUSE );

   DisplayCDError( cdio->io_Error ); // If any!

   return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}

/****i* CDROMMotor() [2.1] *******************************************
*
* NAME
*    CDROMMotor()
*
* DESCRIPTION
*    ^ <primitive 218 0 12 private2 motorState>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMMotor( OBJECT *cdioObj, int motorState )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );

   cdio->io_Length = (motorState != 0) ? 1 : 0;
      
   IssueCDCommand( cdio, CD_MOTOR );

   DisplayCDError( cdio->io_Error ); // If any!

   return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}

/****i* CDROMEject() [2.1] *******************************************
*
* NAME
*    CDROMEject()
*
* DESCRIPTION
*    ^ <primitive 218 0 13 private2 booleanState>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMEject( OBJECT *cdioObj, int state )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );

   cdio->io_Data = NULL;

   if (state == FALSE)
      cdio->io_Length = 0; // Close
   else 
      cdio->io_Length = 1; // Open (Eject!  Eject!)
         
   IssueCDCommand( cdio, CD_EJECT );

   DisplayCDError( cdio->io_Error ); // If any!

   return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}

/****i* CDROMSeek() [2.1] ********************************************
*
* NAME
*    CDROMSeek()
*
* DESCRIPTION
*    <primitive 218 0 14 private2 location>
**********************************************************************
*
*/

METHODFUNC void CDROMSeek( OBJECT *cdioObj, int location )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;

   cdio->io_Offset = location;
      
   IssueCDCommand( cdio, CD_SEEK );

   DisplayCDError( cdio->io_Error ); // If any!

   return;
}

/****i* CDROMChangeNum() [2.1] ***************************************
*
* NAME
*    CDROMChangeNum()
*
* DESCRIPTION
*    ^ <primitive 218 0 17 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMChangeNum( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );
   
   IssueCDCommand( cdio, CD_CHANGENUM );

   if (cdio->io_Error != 0)
      {
      DisplayCDError( cdio->io_Error );
      
      return( o_nil );
      }
   else
      return( AssignObj( new_int( cdio->io_Actual ) ) );
}

/****i* CDROMChangeState() [2.1] *************************************
*
* NAME
*    CDROMChangeState()
*
* DESCRIPTION
*    ^ <primitive 218 0 18 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMChangeState( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_false );
   
   IssueCDCommand( cdio, CD_CHANGESTATE );

   if (cdio->io_Error == 0)
      {
      if (cdio->io_Actual == 0)
         return( o_true );
      else
         return( o_false );
      }
   else
      {
      DisplayCDError( cdio->io_Error );

      return( o_false );
      }
}

/****i* CDROMProtStatus() [2.1] **************************************
*
* NAME
*    CDROMProtStatus()
*
* DESCRIPTION
*    ^ <primitive 218 0 19 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMProtStatus( OBJECT *cdioObj )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );
   
   IssueCDCommand( cdio, CD_PROTSTATUS );

   if (cdio->io_Error != 0)
      {
      DisplayCDError( cdio->io_Error );
      
      return( o_nil );
      }
   else
      {
      if (cdio->io_Actual == 0)
         return( o_false );
      else
         return( o_true );
      }
}

/****i* CDROMGetGeometry() [2.1] *************************************
*
* NAME
*    CDROMGetGeometry()
*
* DESCRIPTION
*    ^ <primitive 218 0 22 private2 geometryObject>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMGetGeometry( OBJECT *cdioObj, OBJECT *geoObj )
{
   struct IOStdReq      *cdio = (struct IOStdReq      *) CheckObject( cdioObj );
   struct DriveGeometry *geo  = (struct DriveGeometry *) CheckObject( geoObj  );
   
   if (NullChk( (OBJECT *) cdio ) == TRUE 
      || NullChk( (OBJECT *) geo ) == TRUE)
      return( o_nil );
   
   cdio->io_Data   = (APTR) geo;
   cdio->io_Length = sizeof( struct DriveGeometry );
   
   IssueCDCommand( cdio, CD_GETGEOMETRY );

   DisplayCDError( cdio->io_Error ); // If any!
      
   return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}

/****i* CDROMInfo() [2.1] ********************************************
*
* NAME
*    CDROMInfo()
*
* DESCRIPTION
*    ^ <primitive 218 0 23 private1 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMInfo( OBJECT *cdsObj, OBJECT *cdioObj )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );

   cdio->io_Data   = cds->cds_CDInfo;
   cdio->io_Length = sizeof( struct CDInfo );
      
   IssueCDCommand( cdio, CD_INFO );

   DisplayCDError( cdio->io_Error ); // If any!
      
   return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}

/****i* CDROMConfig() [2.1] ******************************************
*
* NAME
*    CDROMConfig()
*
* DESCRIPTION
*    This command sets one or more of the configuration items.
*    The configuration items are:
*
*    TAGCD_PLAYSPEED                 Default: 75
*    TAGCD_READSPEED                 Default: 75 (do not count on this)
*    TAGCD_READXLSPEED               Default: 75
*    TAGCD_SECTORSIZE                Default: 2048
*    TAGCD_XLECC                     Default: 1 (on)
*    TAGCD_EJECTRESET                Default: can be 0 (off) or 1 (on)
*
*    ^ <primitive 218 0 24 private2 tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMConfig( OBJECT *cdioObj, OBJECT *tagArray )
{
   IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );
   struct TagItem  *tags = NULL;
   
   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );
   
   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );

   cdio->io_Data   = (APTR) tags;
   cdio->io_Length = 0;
         
   IssueCDCommand( cdio, CD_CONFIG );

   if (tags) // != NULL)
      AT_FreeVec( tags, "CDROMConfigTags", TRUE );
      
   return( AssignObj( new_int( (int) cdio->io_Error ) ) );
}

/****i* CDROMTocMsf() [2.1] ******************************************
*
* NAME
*    CDROMTocMsf()
*
* DESCRIPTION
*    ^ <primitive 218 0 25 private1 private2 numEntries start>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMTocMsf( OBJECT *cdsObj,     OBJECT *cdioObj,
                                int     numEntries, int     start
                              )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (  NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   
   cdio->io_Data   = (APTR) cds->cds_CDTOC;
   cdio->io_Length = (numEntries <= 100) ? numEntries : 100;
   cdio->io_Offset = start;
         
   IssueCDCommand( cdio, CD_TOCMSF );

   if (cdio->io_Error != 0)
      {
      DisplayCDError( cdio->io_Error );
      
      return( o_nil );
      }
   else
      return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}

/****i* CDROMTocLsn() [2.1] ******************************************
*
* NAME
*    CDROMTocLsn()
*
* DESCRIPTION
*    ^ <primitive 218 0 26 private1 private2 numEntries startLocation>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMTocLsn( OBJECT *cdsObj,     OBJECT *cdioObj,
                                int     numEntries, int     start
                              )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (  NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );

   cdio->io_Data   = (APTR) cds->cds_CDTOC;
   cdio->io_Length = (numEntries <= 100) ? numEntries : 100;
   cdio->io_Offset = start;
         
   IssueCDCommand( cdio, CD_TOCLSN );

   if (cdio->io_Error != 0)
      {
      DisplayCDError( cdio->io_Error );
      
      return( o_nil );
      }
   else
      return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}

/****i* CDROMReadXL() [2.1] ******************************************
*
* NAME
*    CDROMReadXL()
*
* DESCRIPTION
*    ^ <primitive 218 0 27 private1 private2 length start>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMReadXL( OBJECT *cdsObj, OBJECT *cdioObj, 
                                int     length, int     start  
                              )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (  NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );

   if ((length != 0) && ((length % 2) != 0))
      {
      if (length > 2)
         {
         length--;

         sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_TR_UNEVEN_CDROM ), length + 1, length );

         UserInfo( ErrMsg, UserPgmError );
         }
      else
         {
         sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_TR_ODD_CDROM ), length );
         
         UserInfo( ErrMsg, UserPgmError );
         
         return( o_nil );
         }   
      }

   if ((start % 2) != 0)
      {
      if (start > 2)
         {
         start--;
      
         sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_ST_UNEVEN_CDROM ), start + 1, start );

         UserInfo( ErrMsg, UserPgmError );
         }
      else
         {
         sprintf( ErrMsg, CDROMCMsg( MSG_FMT_CR_ST_ODD_CDROM ), start );
         
         UserInfo( ErrMsg, UserPgmError );
         
         return( o_nil );
         }
      }
            
   cdio->io_Data   = (APTR) cds->cds_CDXL;
   cdio->io_Length = length;
   cdio->io_Offset = start;

   IssueCDCommand( cdio, CD_READXL );

   if (cdio->io_Error != 0)
      {
      DisplayCDError( cdio->io_Error );
              
      return( o_nil );
      }
   else
      return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
}

/****i* CDROMPlayTrack() [2.1] ***************************************
*
* NAME
*    CDROMPlayTrack()
*
* DESCRIPTION
*    <primitive 218 0 28 private2 numTracks startTrack>
**********************************************************************
*
*/

METHODFUNC void CDROMPlayTrack( OBJECT *cdioObj, int numTracks, int startTrack )
{
   struct IOStdReq *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if ((NullChk( (OBJECT *) cdio ) == TRUE)
      || (numTracks == 0) 
      || (startTrack < 1))
      return;

   cdio->io_Error   = 0;
   cdio->io_Data    = NULL;
   cdio->io_Length  = numTracks;
   cdio->io_Offset  = startTrack;
   cdio->io_Command = CD_PLAYTRACK;
         
   SendIO( (struct IORequest *) cdio );

   DisplayCDError( cdio->io_Error ); // If any!

   return;
}

/****i* CDROMPlayMsf() [2.1] *****************************************
*
* NAME
*    CDROMPlayMsf()
*
* DESCRIPTION
*    <primitive 218 0 29 private2 duration startLoc>
**********************************************************************
*
*/

METHODFUNC void CDROMPlayMsf( OBJECT *cdioObj, int duration, int startLoc )
{
   struct IOStdReq *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;
   
   cdio->io_Error   = 0;
   cdio->io_Data    = NULL;
   cdio->io_Length  = duration;
   cdio->io_Offset  = startLoc;
   cdio->io_Command = CD_PLAYMSF;
      
   SendIO( (struct IORequest *) cdio );

   DisplayCDError( cdio->io_Error ); // If any!

   return;
}

/****i* CDROMPlayLsn() [2.1] *****************************************
*
* NAME
*    CDROMPlayLsn()
*
* DESCRIPTION
*    <primitive 218 0 30 private2 duration startLocation>
**********************************************************************
*
*/

METHODFUNC void CDROMPlayLsn( OBJECT *cdioObj, int duration, int startLoc )
{
   struct IOStdReq *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return;

   cdio->io_Error   = 0;
   cdio->io_Data    = NULL;
   cdio->io_Length  = duration;
   cdio->io_Offset  = startLoc;
   cdio->io_Command = CD_PLAYLSN;
      
   SendIO( (struct IORequest *) cdio );

   DisplayCDError( cdio->io_Error ); // If any!

   return;
}

/****i* CDROMSearch() [2.1] ******************************************
*
* NAME
*    CDROMSearch()
*
* DESCRIPTION
*    ^ <primitive 218 0 31 private2 searchMode>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMSearch( OBJECT *cdioObj, int searchMode )
{
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );

   cdio->io_Data = NULL;
   
   if ((searchMode >= 0) && (searchMode < 3))
      cdio->io_Length = searchMode;
   else
      cdio->io_Length = 0;
         
   IssueCDCommand( cdio, CD_SEARCH );

   if (cdio->io_Error == 0)
      return( AssignObj( new_int( (int) cdio->io_Actual ) ) );
   else
      {
      DisplayCDError( cdio->io_Error );
      
      return( o_nil );
      }
}

/****i* CDROMQCodeMsf() [2.1] ****************************************
*
* NAME
*    CDROMQCodeMsf()
*
* DESCRIPTION
*    ^ <primitive 218 0 32 private1 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMQCodeMsf( OBJECT *cdsObj, OBJECT *cdioObj )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (  NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );

   cdio->io_Data   = (APTR) cds->cds_QCode;
   cdio->io_Length = 0;
   
   IssueCDCommand( cdio, CD_QCODEMSF );

   if (cdio->io_Error == 0)
      return( o_true );
   else
      {
      DisplayCDError( cdio->io_Error );
      
      return( o_false );
      }
}

/****i* CDROMQCodeLsn() [2.1] ****************************************
*
* NAME
*    CDROMQCodeLsn()
*
* DESCRIPTION
*    ^ <primitive 218 0 33 private1 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMQCodeLsn( OBJECT *cdsObj, OBJECT *cdioObj )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (  NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );

   cdio->io_Data   = (APTR) cds->cds_QCode;
   cdio->io_Length = 0;
      
   IssueCDCommand( cdio, CD_QCODELSN );

   if (cdio->io_Error == 0)
      return( o_true );
   else
      {
      DisplayCDError( cdio->io_Error );
      
      return( o_false );
      }
}

/****i* CDROMAttenuate() [2.1] ***************************************
*
* NAME
*    CDROMAttenuate()
*
* DESCRIPTION
*    ^ <primitive 218 0 34 private2 duration factor>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMAttenuate( OBJECT *cdioObj, 
                                   int     duration,
                                   int     factor 
                                 )
{
//   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE)
      return( o_nil );
   
   cdio->io_Data   = NULL;
   cdio->io_Length = duration;
   cdio->io_Offset = factor;
   
   IssueCDCommand( cdio, CD_ATTENUATE );

   return( AssignObj( new_int( cdio->io_Actual ) ) );
}

/****i* CDROMAddChangeInt() [2.1] ************************************
*
* NAME
*    CDROMAddChangeInt()
*
* DESCRIPTION
*    ^ <primitive 218 0 35 private1 private2 changeInterrupt>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMAddChangeInt( OBJECT *cdsObj, OBJECT *cdioObj, APTR cInf )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (  NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );

   cdio->io_Command = CD_ADDCHANGEINT;
   cdio->io_Flags  |= IOF_QUICK;
   cdio->io_Length  = sizeof( struct Interrupt );
   cdio->io_Data    = cInf;

   SendIO( (struct IORequest *) cdio );
   
   return( AssignObj( new_int( (int) cdio->io_Error ) ) );
}

/****i* CDROMRemChangeInt() [2.1] ************************************
*
* NAME
*    CDROMRemChangeInt()
*
* DESCRIPTION
*    <primitive 218 0 36 private2 changeInterrupt>
**********************************************************************
*
*/

METHODFUNC void CDROMRemChangeInt( OBJECT *cdioObj, APTR cInf )
{
   struct IOStdReq *cdio = (struct IOStdReq *) CheckObject( cdioObj );

   if (NullChk( (OBJECT *) cdio ) == TRUE
      || cInf == NULL)
      return;
   
   cdio->io_Data   = cInf;
   cdio->io_Length = sizeof( struct Interrupt );

   IssueCDCommand( cdio, CD_REMCHANGEINT );

   DisplayCDError( cdio->io_Error );
   
   return;
}

/****i* CDROMAddFrameInt() [2.1] ************************************
*
* NAME
*    CDROMAddFrameInt()
*
* DESCRIPTION
*    ^ <primitive 218 0 37 private1 private2 frameInterrupt>
**********************************************************************
*
*/

METHODFUNC OBJECT *CDROMAddFrameInt( OBJECT *cdsObj, OBJECT *cdioObj, APTR cInf )
{
   struct CDStructs *cds  = (struct CDStructs *) CheckObject( cdsObj  );
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (  NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   
   cdio->io_Command = CD_ADDFRAMEINT;
   cdio->io_Flags  |= IOF_QUICK;
   cdio->io_Length  = sizeof( struct Interrupt );
   cdio->io_Data    = cInf;

   SendIO( (struct IORequest *) cdio );

   return( AssignObj( new_int( 0 ) ) );
}

/****i* CDROMRemFrameInt() [2.1] ************************************
*
* NAME
*    CDROMRemFrameInt()
*
* DESCRIPTION
*    <primitive 218 0 38 private2 frameInterrupt>
**********************************************************************
*
*/

METHODFUNC void CDROMRemFrameInt( OBJECT *cdioObj, APTR cInf )
{
   struct IOStdReq  *cdio = (struct  IOStdReq *) CheckObject( cdioObj );

   if (  NullChk( (OBJECT *) cdio ) == TRUE
      || NullChk( (OBJECT *) cInf ) == TRUE)      
      return;

   cdio->io_Data   = cInf;
   cdio->io_Length = sizeof( struct Interrupt );
      
   IssueCDCommand( cdio, CD_REMFRAMEINT );

   DisplayCDError( cdio->io_Error );

   return;
}

/****i* newGeometryObject() [2.1] ************************************
*
* NAME
*    newGeometryObject()
*
* DESCRIPTION
*    ^ <primitive 218 0 39>
**********************************************************************
*
*/

METHODFUNC OBJECT *newGeometryObject( void )
{
   struct DriveGeometry *dg = NULL;
   
   dg = (struct DriveGeometry *) AT_AllocVec( sizeof( struct DriveGeometry ),
                                              MEMF_CLEAR | MEMF_ANY,
                                              "cdGeometry", TRUE 
                                            );
   
   if (!dg) // == NULL)
      {
      MemoryOut( CDROMCMsg( MSG_CR_GEOOBJ_FUNC_CDROM ) );
      
      return( o_nil );
      }
   else
      return( AssignObj( new_address( (ULONG) dg ) ) ); 
}        

/****i* disposeGeometryObject() [2.1] ********************************
*
* NAME
*    disposeGeometryObject()
*
* DESCRIPTION
*    <primitive 218 0 40 geoObj>
**********************************************************************
*
*/

METHODFUNC void disposeGeometryObject( OBJECT *geoObj )
{
   struct DriveGeometry *dg = (struct DriveGeometry *) CheckObject( geoObj );
   
   if (NullChk( (OBJECT *) dg ) != TRUE)
      AT_FreeVec( dg, "cdGeometry", TRUE );

   return;
}

/****i* getPlaySpeed() [2.1] *****************************************
*
* NAME
*    getPlaySpeed()
*
* DESCRIPTION
*    ^ <primitive 218 0 41 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getPlaySpeed( OBJECT *cdsObj )
{
   struct CDStructs *cds = (struct CDStructs *) CheckObject( cdsObj );
   
   if (NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   else
      return( AssignObj( new_int( (int) cds->cds_CDInfo->PlaySpeed )));
}

/****i* getReadSpeed() [2.1] *****************************************
*
* NAME
*    getReadSpeed()
*
* DESCRIPTION
*    ^ <primitive 218 0 42 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getReadSpeed( OBJECT *cdsObj )
{
   struct CDStructs *cds = (struct CDStructs *) CheckObject( cdsObj );
   
   if (NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   else
      return( AssignObj( new_int( (int) cds->cds_CDInfo->ReadSpeed )));
}

/****i* getReadXLSpeed() [2.1] ***************************************
*
* NAME
*    getReadXLSpeed()
*
* DESCRIPTION
*    ^ <primitive 218 0 43 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getReadXLSpeed( OBJECT *cdsObj )
{
   struct CDStructs *cds = (struct CDStructs *) CheckObject( cdsObj );
   
   if (NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   else
      return( AssignObj( new_int( (int) cds->cds_CDInfo->ReadXLSpeed )));
}

/****i* getSectorSize() [2.1] ****************************************
*
* NAME
*    getSectorSize()
*
* DESCRIPTION
*    ^ <primitive 218 0 44 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getSectorSize( OBJECT *cdsObj )
{
   struct CDStructs *cds = (struct CDStructs *) CheckObject( cdsObj );
   
   if (NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   else
      return( AssignObj( new_int( (int) cds->cds_CDInfo->SectorSize )));
}

/****i* getMaxSpeed() [2.1] ******************************************
*
* NAME
*    getMaxSpeed()
*
* DESCRIPTION
*    ^ <primitive 218 0 45 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getMaxSpeed( OBJECT *cdsObj )
{
   struct CDStructs *cds = (struct CDStructs *) CheckObject( cdsObj );
   
   if (NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   else
      return( AssignObj( new_int( (int) cds->cds_CDInfo->MaxSpeed )));
}

/****i* getAudioPrecision() [2.1] ************************************
*
* NAME
*    getAudioPrecision()
*
* DESCRIPTION
*    ^ <primitive 218 0 46 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getAudioPrecision( OBJECT *cdsObj )
{
   struct CDStructs *cds = (struct CDStructs *) CheckObject( cdsObj );
   
   if (NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   else
      return( AssignObj( new_int( (int) cds->cds_CDInfo->AudioPrecision )));
}

/****i* getStatus() [2.1] ********************************************
*
* NAME
*    getStatus()
*
* DESCRIPTION
*    ^ <primitive 218 0 47 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getStatus( OBJECT *cdsObj )
{
   struct CDStructs *cds = (struct CDStructs *) CheckObject( cdsObj );
   
   if (NullChk( (OBJECT *) cds ) == TRUE)      
      return( o_nil );
   else
      return( AssignObj( new_int( (int) cds->cds_CDInfo->Status )));
}

/****h* CDROMPrimitive() [2.1] *****************************************
*
* NAME
*    CDROMPrimitive() {Primitive 218 0 ??}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    CDROM interfacing methods.
************************************************************************
*
*/

SUBFUNC OBJECT *CDROMPrimitive( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 218 );
      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // close   <primitive 218 0 0 self>
         closeCDROM( args[1], args[1]->inst_var[0],
                              args[1]->inst_var[1], 
                              args[1]->inst_var[2] 
                   );
         break;

      case 1: // open: cdDeviceName unit: unitNumber
              // ^ <primitive 218 0 1 self cdDeviceName unitNumber>
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 218 );
         else
            rval = openCDROM( args[1],
                              string_value( (STRING *) args[2] ),
                                 int_value( args[3] ) 
                            );
         break;

      case 2: // translateCDErrorNumber: errNumber
              // ^ <primitive 218 0 2 errNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 218 );
         else
            rval = translateCDErrorNumber( int_value( args[1] ) );
         
         break;

#     ifdef FULLYDOCUMENTED // -------------------------------------------

      case 3: // reset   <primitive 218 0 3 private2>
         CDROMReset( args[1] );
         break;

      case 5: // write: UNUSED
              //   <primitive 218 0 5 private2>
         CDROMWrite( args[1] );
         break;

      case 6: // stop   <primitive 218 0 6 private2>
         CDROMStop( args[1] );
         break;

      case 7: // start  <primitive 218 0 7 private2>
         CDROMStart( args[1] );
         break;

      case 8: // update
              //   <primitive 218 0 8 private2>
         CDROMUpdate( args[1] );
         break;

      case 10: // clear
               //  <primitive 218 0 10 private2>
         CDROMClear( args[1] );
         break;

      case 11: // flush
               //  <primitive 218 0 11 private2>
         CDROMFlush( args[1] );
         break;
   

      case 15: // format   <primitive 218 0 15 private2>
         CDROMFormat( args[1] );
         break;

      case 16: // remove   <primitive 218 0 16 private2>
         CDROMRemove( args[1] );
         break;

      case 20: // getDriveType UNUSED
               // ^ <primitive 218 0 20 private2>
         rval = CDROMGetDriveType( args[1] );
         break;

      case 21: // getNumTracks UNUSED
               // ^ <primitive 218 0 21 private2>
         rval = CDROMGetNumTracks( args[1] );
         break;

#     endif // FULLYDOCUMENTED -------------------------------------------

      case 4: // readInto: dataByteArray start: location
              // ^ <primitive 218 0 4 private2 dataByteArray startLocation>
         if (!is_bytearray( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 218 );
         else
            rval = CDROMRead( args[1], args[2], int_value( args[3] ) );

         break;

      case 9: // pause
              // ^ <primitive 218 0 9 private2 pauseState>
         if (args[2] == o_true)
            rval = CDROMPause( args[1], 1 );
         else
            rval = CDROMPause( args[1], 0 );
            
         break;

      case 12: // motor: onOrOff
               // ^ <primitive 218 0 12 private2 onOrOff>
         if (args[2] == o_true)
            rval = CDROMMotor( args[1], 1 );
         else
            rval = CDROMMotor( args[1], 0 );
         break;

      case 13: // eject: trueOrFalse
               // ^ <primitive 218 0 13 private2 ejectState>
         if (args[2] == o_true)
            rval = CDROMEject( args[1], 1 );
         else
            rval = CDROMEject( args[1], 0 );

         break;

      case 14: // seekTo: location
               //   <primitive 218 0 14 private2 location>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 218 );
         else
            CDROMSeek( args[1], int_value( args[2] ) );
         break;

      case 22: // getGeometry: geometryObject
               // ^ <primitive 218 0 22 private2 geometryObject>
         rval = CDROMGetGeometry( args[1], args[2] );
         break;

      case 23: // info
               // ^ <primitive 218 0 23 private1 private2>
         rval = CDROMInfo( args[1], args[2] );
         break;

      case 24: // configuration: tagArray
               // ^ <primitive 218 0 24 private2 tagArray>
         rval = CDROMConfig( args[1], args[2] );
         break;

      case 25: // tocMsf: numEntries startingAt: start
               // ^ <primitive 218 0 25 private1 private2 numEntries start>
         if (!is_integer( args[3] ) || !is_integer( args[4] ))
            (void) PrintArgTypeError( 218 );
         else
            rval = CDROMTocMsf( args[1], args[2], int_value( args[3] ), 
                                                  int_value( args[4] ) 
                              );
         break;

      case 26: // tocLsn: numEntries startingAt: start
               // ^ <primitive 218 0 26 private1 private2 numEntries start>
         if (!is_integer( args[3] ) || !is_integer( args[4] ))
            (void) PrintArgTypeError( 218 );
         else
            rval = CDROMTocLsn( args[1], args[2], int_value( args[3] ), 
                                                  int_value( args[4] ) 
                              );
         break;

      case 27: // readXL: length startingAt: start
               // ^ <primitive 218 0 27 private1 private2 length start>
         if (!is_integer( args[3] ) || !is_integer( args[4] ))
            (void) PrintArgTypeError( 218 );
         else
            rval = CDROMReadXL( args[1], args[2], int_value( args[3] ),
                                                  int_value( args[4] )
                              );
         break;

      case 28: // playTracks: numTracks startingAt: startTrack
               // ^ <primitive 218 0 28 private2 numTracks startTrack>
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 218 );
         else
            CDROMPlayTrack( args[1], int_value( args[2] ),
                                     int_value( args[3] )
                          );
         break;

      case 29: // playMsf: duration startingAt: startLocation
               // ^ <primitive 218 0 29 private2 duration startLocation>
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 218 );
         else
            CDROMPlayMsf( args[1], int_value( args[2] ), int_value( args[3] ) );

         break;

      case 30: // playLsn: duration startingAt: startLocation
               // ^ <primitive 218 0 30 private2 duration startLocation>
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 218 );
         else
            CDROMPlayLsn( args[1], int_value( args[2] ), int_value( args[3] ) );

         break;

      case 31: // search: searchMode
               // ^ <primitive 218 0 31 private2 searchMode>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 218 );
         else
            rval = CDROMSearch( args[1], int_value( args[2] ) );
   
         break;

      case 32: // qCodeMsf
               // ^ <primitive 218 0 32 private1 private2>
         rval = CDROMQCodeMsf( args[1], args[2] );
         break;

      case 33: // qCodeLsn
               // ^ <primitive 218 0 33 private1 private2>
         rval = CDROMQCodeLsn( args[1], args[2] );
         break;

      case 34: // attenuateBy: factor for: duration
               // ^ <primitive 218 0 34 private2 duration factor>
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 218 );
         else
            rval = CDROMAttenuate( args[1], int_value( args[2] ),
                                            int_value( args[3] )
                                 );
         break;

      case 35: // addChangeInterrupt: interruptObject
               // ^ <primitive 218 0 35 private1 private2 interruptObject>
         if (is_address( args[3] ) == FALSE)
            (void) PrintArgTypeError( 218 );
         else
            rval = CDROMAddChangeInt( args[1], args[2], (APTR) addr_value( args[3] ) );
   
         break;

      case 36: // removeChangeInterrupt: interruptObject
               //   <primitive 218 0 36 private2 interruptObject>
         if (is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 218 );
         else
            CDROMRemChangeInt( args[1], (APTR) addr_value( args[2] ) );
         
         break;

      case 37: // addFrameInterrupt: interruptObject
               // ^ <primitive 218 0 37 private1 private2 interruptObject>
         if (is_address( args[3] ) == FALSE)
            (void) PrintArgTypeError( 218 );
         else
            rval = CDROMAddFrameInt( args[1], args[2], (APTR) addr_value( args[3] ) );
   
         break;

      case 38: // removeFrameInterrupt: interruptObject
               //   <primitive 218 0 38 private2 interruptObject>
         if (is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 218 );
         else
            CDROMRemFrameInt( args[1], args[2] ); // void *cInf );

         break;

      case 39: // newGeometryObject
               // ^ <primitive 218 0 39> 
         rval = newGeometryObject();
         
         break;
               
      case 40: // dispose: geometryObject
               //   <primitive 218 0 40 geometryObject> 
         disposeGeometryObject( args[1] );
         
         break;

      case 41: // playSpeed
               // ^ <primitive 218 0 41 private1>
         rval = getPlaySpeed( args[1] );
         break;
         
      case 42: // readSpeed
               // ^ <primitive 218 0 42 private1>
         rval = getReadSpeed( args[1] );
         break;
        
      case 43: // readXLSpeed
               // ^ <primitive 218 0 43 private1>
         rval = getReadXLSpeed( args[1] );
         break;

      case 44: // sectorSize
               // ^ <primitive 218 0 44 private1>
         rval = getSectorSize( args[1] );
         break;

      case 45: // maxSpeed
               // ^ <primitive 218 0 45 private1>
         rval = getMaxSpeed( args[1] );
         break;

      case 46: // audioPrecision
               // ^ <primitive 218 0 46 private1>
         rval = getAudioPrecision( args[1] );
         break;

      case 47: // status
               // ^ <primitive 218 0 47 private1>
         rval = getStatus( args[1] );
         break;
               
      default:
         (void) PrintArgTypeError( 218 );

         break;
      }

   return( rval );
}

/****h* HandleMiscDevices() [2.1] **************************************
*
* NAME
*    HandleMiscDevices() {Primitive 218 ?? ??}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    Other Device interfacing methods.
*    <218 0 ??>  is for cd.device primitives.
*
************************************************************************
*
*/

PUBLIC OBJECT *HandleMiscDevices( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 218 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // HandleCDROM();
         rval = CDROMPrimitive( numargs, args );

         break;

      case 1: // Future Expansion
         break;
      
      default:
         (void) PrintArgTypeError( 218 );

         break;
      }

   return( rval );
}

/* ---------------------- END of CDROM.c file! ----------------------- */
