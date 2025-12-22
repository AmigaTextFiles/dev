/****h* AmigaTalk/SCSI.c [3.0] *****************************************
*
* NAME
*    SCSI.c
*
* WARNINGS
*    This file is NOT debugged yet.
*
* DESCRIPTION
*    Implement AmigaTalk control over SCSI devices.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    Commands recognized by the scsi.device:
*
*      HD_SCSICMD
*      TD_CHANGESTATE
*      TD_FORMAT
*      TD_PROTSTATUS
*      TD_SEEK
*      CMD_READ
*      CMD_WRITE
*      CMD_START
*      CMD_STOP
*
*    $VER: AmigaTalk:Src/SCSI.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>
#include <exec/exec.h>

#include <AmigaDOSErrs.h>
 
#include <devices/SCSIDisk.h>
#include <devices/TrackDisk.h>
#include <devices/HardBlocks.h>

#ifdef __SASC

# include <clib/dos_protos.h>
# include <clib/exec_protos.h>
# include <devices/SCSI2Commands.h> // Not used yet!!

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>

# include <SCSI2Commands.h> // Located in SDK:Local/INclude/ (Not used yet!!)

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT UBYTE  *ErrMsg;
IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *UserPgmError;

IMPORT OBJECT *o_nil, *o_true, *o_false;

// ------------------------------------------------------

IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

//#define BOARD 0 /* controller board */
//#define LUN   0 /* logical unit */

// PRIVATE int TID   = 1;

// #define UNIT  (BOARD * 100 + LUN * 10 + TID)

/*
struct SCSICmd {

    UWORD  *scsi_Data;		// word aligned data for SCSI Data Phase
				// (optional) data need not be byte aligned
				// (optional) data need not be bus accessable
    ULONG   scsi_Length;	// even length of Data area
				// (optional) data can have odd length
				// (optional) data length can be > 2**24
    ULONG   scsi_Actual;	// actual Data used
    UBYTE  *scsi_Command;	// SCSI Command (same options as scsi_Data)
    UWORD   scsi_CmdLength;	// length of Command
    UWORD   scsi_CmdActual;	// actual Command used
    UBYTE   scsi_Flags;		// includes intended data direction
    UBYTE   scsi_Status;	// SCSI status of command
    UBYTE  *scsi_SenseData;	// sense data: filled if SCSIF_[OLD]AUTOSENSE
				// is set and scsi_Status has CHECK CONDITION
				// (bit 1) set
    UWORD   scsi_SenseLength;	// size of scsi_SenseData, also bytes to
				// request w/ SCSIF_AUTOSENSE, must be 4..255
    UWORD   scsi_SenseActual;	// amount actually fetched (0 means no sense)
};


//----- scsi_Flags -----

#define	SCSIF_WRITE		0 // intended data direction is out
#define	SCSIF_READ		1 // intended data direction is in
#define	SCSIB_READ_WRITE	0 // (the bit to test)

#define	SCSIF_NOSENSE		0 // no automatic request sense
#define	SCSIF_AUTOSENSE		2 // do standard extended request sense
				  // on check condition
#define	SCSIF_OLDAUTOSENSE	6 // do 4 byte non-extended request
				  // sense on check condition
#define	SCSIB_AUTOSENSE		1 // (the bit to test)
#define	SCSIB_OLDAUTOSENSE	2 // (the bit to test)

*/

// private1 == struct SCSICmd  *cmd;
// private2 == struct IOStdReq *io;
// private3 == struct MsgPort  *mp;

/****i* CloseSCSI() [2.1] ********************************************
*
* NAME
*    CloseSCSI()
*
* DESCRIPTION
*    Close scsi.device & remove it from the AmigaTalk program space.
*    <primitive 226 0 private1 private2 private3>
**********************************************************************
*
*/

METHODFUNC void CloseSCSI( OBJECT *cmdObj, OBJECT *iorObj, OBJECT *mportObj )
{
   struct SCSICmd  *cmd  = (struct SCSICmd  *) CheckObject( cmdObj   );
   struct IOStdReq *io   = (struct IOStdReq *) CheckObject( iorObj   );
   struct MsgPort  *mp   = (struct MsgPort  *) CheckObject( mportObj ); 
   
   if (!io || !mp || !cmd) // == NULL)
      return;
      
   if (CheckIO( (struct IORequest *) io ) == 0)
      AbortIO(  (struct IORequest *) io );

   WaitIO( (struct IORequest *) io );

   CloseDevice( (struct IORequest *) io );

   DeleteStdIO( io );
   DeletePort( mp );

   FreeVec( cmd  );
   
   return;
}

/****i* OpenSCSI() [2.1] *********************************************
*
* NAME
*    OpenSCSI()
*
* DESCRIPTION
*    ^ boolean <- <primitive 226 1 self scsiDeviceName unitNumber>
**********************************************************************
*
*/

METHODFUNC OBJECT *OpenSCSI( OBJECT *scsiObj, char *scsidevname, int unit )
{
//   IMPORT struct MsgPort *CreatePort( char *, ULONG );
   
   struct IOStdReq *io   = NULL;
   struct MsgPort  *mp   = NULL;
   struct SCSICmd  *cmd  = NULL;
   OBJECT          *rval = o_false;

   // --------------------------------------------------------------       

   if (!(cmd = (struct SCSICmd *) AT_AllocVec( sizeof( struct SCSICmd ),
                                               MEMF_CLEAR | MEMF_ANY,
                                               "SCSICmd", TRUE ))) // == NULL)
      {
      MemoryOut( SCSICMsg( MSG_OPEN_FUNC_SCSI ) );

      return( rval );
      }
      
   if (!(mp = CreatePort( NULL, 0 ))) // == NULL)
      {
      CannotCreatePort( SCSICMsg( MSG_OBJECT_SCSI ) );

      AT_FreeVec( cmd, "SCSICmd", TRUE );

      return( rval );
      }
   
   if (!(io = (struct IOStdReq *) CreateStdIO( mp ))) // == NULL)
      {
      CannotCreateStdIO( SCSICMsg( MSG_OBJECT_SCSI ) );

      AT_FreeVec( cmd, "SCSICmd", TRUE );

      DeletePort( mp );

      return( rval );
      }

   if (OpenDevice( scsidevname, unit, (struct IORequest *) io, 0 ) != 0)
      {
      if (io->io_Error == HFERR_NoBoard)
         {
         StringCopy( ErrMsg, SCSICMsg( MSG_NOT_EXISTS_SCSI ) ); 

         UserInfo( ErrMsg, AllocProblem );
         }
      else
         CannotOpenDevice( scsidevname );
   
      AT_FreeVec( cmd, "SCSICmd", TRUE );

      DeleteStdIO( io );
      DeletePort( mp );

      return( rval );
      }

   io->io_Length = sizeof( struct SCSICmd );
   io->io_Data   = (APTR) cmd;

   obj_dec( scsiObj->inst_var[0] ); // Dereference nils.
   obj_dec( scsiObj->inst_var[1] );
   obj_dec( scsiObj->inst_var[2] );

   scsiObj->inst_var[0] = new_address( (ULONG) cmd  );
   scsiObj->inst_var[1] = new_address( (ULONG) io   );
   scsiObj->inst_var[2] = new_address( (ULONG) mp   );
       
   return( o_true );
}

/****i* AddSenseByte() [2.1] *****************************************
*
* NAME
*    AddSenseByte()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC void AddSenseByte( char *str, UBYTE sb )
{
   char bf[4] = { 0, }, *buf = &bf[0];
   
   sprintf( buf, "%02X ", sb );

   buf[3] = NIL_CHAR; // There's a space after the two Hex digits!

   StringCat( str, buf );

   return;
}

/****i* ReadSCSI() [2.1] *********************************************
*
* NAME
*    ReadSCSI()
*
* DESCRIPTION
*    ^ <primitive 226 2 private1 private2 bufByteArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *ReadSCSI( OBJECT *cmdObj, OBJECT *iorObj, OBJECT *rbaObj )
{
   struct SCSICmd  *cmd  = (struct SCSICmd  *) CheckObject( cmdObj   );
   struct IOStdReq *io   = (struct IOStdReq *) CheckObject( iorObj   );
   
   UWORD           *buff = (UWORD *) ((BYTEARRAY *) rbaObj)->bytes;
   ULONG            siz  =   (ULONG) ((BYTEARRAY *) rbaObj)->bsize;

   char             c[7 ] = { 0, }, *command = &c[0];
   char             s[20] = { 0, }, *sense   = &s[0];
      
   if (!cmd || !io || !buff) // == NULL)
      return( o_nil );

   c[0] = SCSI_READ_BUFFER;
   c[6] = NIL_CHAR;
   
   cmd->scsi_Length      = siz;
   cmd->scsi_Data        = buff;
   cmd->scsi_Flags       = SCSIF_AUTOSENSE | SCSIF_READ;
   cmd->scsi_Command     = command;
   cmd->scsi_CmdLength   = 6;
   cmd->scsi_SenseData   = (UBYTE *) sense;
   cmd->scsi_SenseLength = 20;
   cmd->scsi_SenseActual = 0;
   
   io->io_Flags   |= IOF_QUICK;
   io->io_Command  = HD_SCSICMD;
   
   BeginIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io ); /* ???? */

   if (cmd->scsi_Status != 0)
      {
      int  i;
            
      StringCopy( ErrMsg, SCSICMsg( MSG_SENSE_RETURN_SCSI ) );

      for (i = 0; i < 20; i++)
          AddSenseByte( ErrMsg, sense[i] );

      UserInfo( ErrMsg, SCSICMsg( MSG_CMDPROBLEM_SCSI ) );
      }

   // check IOSer.io_Error field: ?????
   return( rbaObj );
}

/****i* WriteSCSI() [2.1] ********************************************
*
* NAME
*    WriteSCSI()
*
* DESCRIPTION
*    ^ <primitive 226 3 private1 private2 writeByteArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *WriteSCSI( OBJECT *cmdObj, OBJECT *iorObj, OBJECT *wbaObj )
{
   struct SCSICmd  *cmd = (struct SCSICmd  *) CheckObject( cmdObj );
   struct IOStdReq *io  = (struct IOStdReq *) CheckObject( iorObj );

   UWORD           *str = (UWORD *) ((BYTEARRAY *) wbaObj)->bytes;
   ULONG            siz =   (ULONG) ((BYTEARRAY *) wbaObj)->bsize;
      
   char             c[7 ] = { 0, }, *command = &c[0];
   char             s[20] = { 0, }, *sense   = &s[0];
      
   if (!io || !cmd || !str) // == NULL)
      return( o_nil );

   c[0] = SCSI_WRITE_BUFFER;
   c[6] = NIL_CHAR;
     
   cmd->scsi_Length      = siz;  // -1;
   cmd->scsi_Data        = str;
   cmd->scsi_Flags       = SCSIF_AUTOSENSE | SCSIF_WRITE;
   cmd->scsi_Command     = command;
   cmd->scsi_CmdLength   = 6;
   cmd->scsi_SenseData   = (UBYTE *) sense;
   cmd->scsi_SenseLength = 20;
   cmd->scsi_SenseActual = 0;

   io->io_Command  = HD_SCSICMD;
   io->io_Flags   |= IOF_QUICK;

   BeginIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io ); /* ???? */

   if (cmd->scsi_Status != 0)
      {
      int  i;
            
      StringCopy( ErrMsg, SCSICMsg( MSG_SENSE_RETURN_SCSI ) );

      for (i = 0; i < 20; i++)
          AddSenseByte( ErrMsg, sense[i] );

      UserInfo( ErrMsg, SCSICMsg( MSG_CMDPROBLEM_SCSI ) );
      }

   return( AssignObj( new_int( (int) io->io_Error ) ) );
}

/****i* IssueSCSICommand() [2.1] *************************************
*
* NAME
*    IssueSCSICommand()
*
* DESCRIPTION
**********************************************************************
*
*/

SUBFUNC void IssueSCSICommand( struct IOStdReq *io, int command )
{
   io->io_Command = command;
   io->io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return;
}

/****i* StopSCSI() [2.1] *********************************************
*
* NAME
*    StopSCSI()
*
* DESCRIPTION
*    <primitive 226 4 private2>
**********************************************************************
*
*/

METHODFUNC void StopSCSI( OBJECT *iorObj )
{
   struct IOStdReq *io = (struct IOStdReq *) CheckObject( iorObj );

   if (!io) // == NULL)
      return;
   
   IssueSCSICommand( io, CMD_STOP );

   return;
}

/****i* StartSCSI() [2.1] ********************************************
*
* NAME
*    StartSCSI()
*
* DESCRIPTION
*    <primitive 226 5 private2>
**********************************************************************
*
*/

METHODFUNC void StartSCSI( OBJECT *iorObj )
{
   struct IOStdReq *io = (struct IOStdReq *) CheckObject( iorObj );

   if (!io) // == NULL)
      return;

   IssueSCSICommand( io, CMD_START );

   return;
}

/****i* GetProtectStatus() [2.1] *************************************
*
* NAME
*    GetProtectStatus()
*
* DESCRIPTION
*    ^ <primitive 226 6 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetProtectStatus( OBJECT *iorObj )
{
   struct IOStdReq *io = (struct IOStdReq *) CheckObject( iorObj );

   if (!io) // == NULL)
      return( o_nil );

   IssueSCSICommand( io, TD_PROTSTATUS );

   if (io->io_Actual == 0)
      return( o_false );
   else
      return( o_true );
}

/****i* GetDiskChange() [2.1] ****************************************
*
* NAME
*    GetDiskChange()
*
* DESCRIPTION
*    ^ <primitive 226 7 private2>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetDiskChange( OBJECT *iorObj )
{
   struct IOStdReq *io = (struct IOStdReq *) CheckObject( iorObj );

   if (!io) // == NULL)
      return( o_nil );

   IssueSCSICommand( io, TD_CHANGESTATE );

   if (io->io_Actual == 0) 
      return( o_true );
   else
      return( o_false );
}

/****i* DoSeek() [2.1] ***********************************************
*
* NAME
*    DoSeek()
*
* DESCRIPTION
*    ^ <primitive 226 8 private2 location>
**********************************************************************
*
*/

METHODFUNC OBJECT *DoSeek( OBJECT *iorObj, int location )
{
   struct IOStdReq *io = (struct IOStdReq *) CheckObject( iorObj );

   if (!io) // == NULL)
      return( o_nil );

   io->io_Offset = location;
   
   IssueSCSICommand( io, TD_SEEK ); // ?????

   if (io->io_Error == 0)
      return( o_true );
   else
      return( o_false );
}

/****i* sendSCSIDirectCmd() [2.1] ************************************
*
* NAME
*    sendSCSIDirectCmd()
*
* DESCRIPTION
*    Send a SCSI-Direct command (inside private1).
*    ^ <primitive 226 9 private1 private2>
**********************************************************************
*
*/

PRIVATE OBJECT *sendSCSIDirectCmd( OBJECT *cmdObj, OBJECT *iorObj )
{
   struct IOStdReq *io  = (struct IOStdReq *) CheckObject( iorObj );
   struct SCSICmd  *cmd = (struct SCSICmd  *) CheckObject( cmdObj );

   if (!io || !cmd) // == NULL)
      return( o_nil );

   io->io_Length  = sizeof( struct SCSICmd );
   io->io_Data    = (APTR) cmd;
   io->io_Command = HD_SCSICMD;

   io->io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return( AssignObj( new_int( (int) io->io_Error ) ) );
}

/****i* setSCSIDataField() [2.1] *************************************
*
* NAME
*    setSCSIDataField()
*
* DESCRIPTION
*    <primitive 226 10 private1 byteArray>
**********************************************************************
*
*/

METHODFUNC void setSCSIDataField( OBJECT *cmdObj, OBJECT *dataObj )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   UWORD          *dat = (UWORD *) ((BYTEARRAY *) dataObj)->bytes;
   ULONG           sz  =   (ULONG) ((BYTEARRAY *) dataObj)->bsize;
   
   if (cmd) // != NULL)
      {
      cmd->scsi_Data   = dat;
      cmd->scsi_Length = sz; 
      }
      
   return;
}

/****i* getActualDataUsed() [2.1] ************************************
*
* NAME
*    getActualDataUsed()
*
* DESCRIPTION
*    ^ <primitive 226 11 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getActualDataUsed( OBJECT *cmdObj )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   if (cmd) // != NULL)
      return( AssignObj( new_int( (int) cmd->scsi_Actual ) ) );
   else
      return( o_nil );
}

/****i* setSCSICommandField() [2.1] **********************************
*
* NAME
*    setSCSICommandField()
*
* DESCRIPTION
*    <primitive 226 12 private1 commandByteArray>
**********************************************************************
*
*/

METHODFUNC void setSCSICommandField( OBJECT *cmdObj, OBJECT *dataObj )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   UBYTE          *dat = (UBYTE *) ((BYTEARRAY *) dataObj)->bytes;
   UWORD           sz  =   (UWORD) ((BYTEARRAY *) dataObj)->bsize;
   
   if (cmd) // != NULL)
      {
      cmd->scsi_Command   = dat;
      cmd->scsi_CmdLength = sz;
      }

   return;
}    

/****i* getActualCommandUsed() [2.1] *********************************
*
* NAME
*    getActualCommandUsed()
*
* DESCRIPTION
*    ^ <primitive 226 13 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getActualCommandUsed( OBJECT *cmdObj )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   if (cmd) // != NULL)
      return( AssignObj( new_int( (int) cmd->scsi_CmdActual ) ) );
   else
      return( o_nil );
}

/****i* getActualSense() [2.1] ***************************************
*
* NAME
*    getActualSense()
*
* DESCRIPTION
*    ^ <primitive 226 14 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getActualSense( OBJECT *cmdObj )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   if (cmd) // != NULL)
      return( AssignObj( new_int( (int) cmd->scsi_SenseActual ) ) );
   else
      return( o_nil );
}

/****i* getSCSIStatus() [2.1] ****************************************
*
* NAME
*    getSCSIStatus()
*
* DESCRIPTION
*    ^ <primitive 226 15 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getSCSIStatus( OBJECT *cmdObj )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   if (cmd) // != NULL)
      return( AssignObj( new_int( (int) cmd->scsi_Status ) ) );
   else
      return( o_nil );
}

/****i* setSCSIFlagsField() [2.1] ************************************
*
* NAME
*    setSCSIFlagsField()
*
* DESCRIPTION
*    <primitive 226 16 private1 newFlags>
**********************************************************************
*
*/

METHODFUNC void setSCSIFlagsField( OBJECT *cmdObj, UBYTE newFlags )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   if (cmd) // != NULL)
      {
      cmd->scsi_Flags = newFlags;
      }

   return;
}    

/****i* setSCSIStatusField() [2.1] ***********************************
*
* NAME
*    setSCSIStatusField()
*
* DESCRIPTION
*    <primitive 226 17 private1 newStatus>
**********************************************************************
*
*/

METHODFUNC void setSCSIStatusField( OBJECT *cmdObj, UBYTE newStatus )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   if (cmd) // != NULL)
      {
      cmd->scsi_Status = newStatus;
      }

   return;
}    

/****i* getSCSISenseData() [2.1] *************************************
*
* NAME
*    getSCSISenseData()
*
* DESCRIPTION
*    ^ <primitive 226 18 private1 byteArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *getSCSISenseData( OBJECT *cmdObj, OBJECT *senseObj )
{
   struct SCSICmd *cmd   = (struct SCSICmd *) CheckObject( cmdObj );

   BYTEARRAY      *bytes = (BYTEARRAY *) senseObj;
   UBYTE          *sns   =     (UBYTE *) bytes->bytes;
   UWORD           len   =       (UWORD) bytes->bsize;
   
   if (cmd) // != NULL)
      {
      if (len < 4 || len > 255)
         {
         sprintf( ErrMsg, SCSICMsg( MSG_OUT_RANGE_SCSI ), len );
         
         UserInfo( ErrMsg, UserPgmError );

         return( o_nil );
         }
         
      if (cmd->scsi_SenseLength <= len)
         {
         int i;
         
         for (i = 0; i < len; i++) // Clear out the old stuff. 
            *(sns + i) = NIL_CHAR;
            
         for (i = 0; i < cmd->scsi_SenseLength; i++)
            *(sns + i) = *(cmd->scsi_SenseData + i);
         
         return( senseObj ); 
         }
      else // senseObj NOT big enough!!
         {
         sprintf( ErrMsg, SCSICMsg( MSG_NOT_ENOUGH_SCSI ), 
                          len, cmd->scsi_SenseLength
                );
         
         UserInfo( ErrMsg, UserPgmError );
         
         return( o_nil );
         }   
      }
   else
      return( o_nil );
}

/****i* sendFormat() [2.1] *******************************************
*
* NAME
*    sendFormat()
*
* DESCRIPTION
*    ^ <primitive 226 19 private1 private2 dataByteArray location>
**********************************************************************
*
*/

METHODFUNC OBJECT *sendFormat( OBJECT *cmdObj, OBJECT *iorObj, 
                               OBJECT *dba,    int     location 
                             )
{
//   struct SCSICmd  *cmd = (struct SCSICmd *) CheckObject( cmdObj );
   struct IOStdReq *io  = (struct IOStdReq *) CheckObject( iorObj );

   UBYTE           *dat = (UBYTE *) ((BYTEARRAY *) dba)->bytes;
   UWORD            sz  =   (UWORD) ((BYTEARRAY *) dba)->bsize;

   if (!io) // == NULL)
      return( o_nil );

   io->io_Data   = dat;
   io->io_Offset = location;
   io->io_Length = sz;

   IssueSCSICommand( io, TD_FORMAT ); // ?????
     
   return( AssignObj( new_int( (int) io->io_Actual ) ) );
}

/****i* readSCSICommand() [2.1] **************************************
*
* NAME
*    readSCSICommand()
*
* DESCRIPTION
*    ^ <primitive 226 20 private1 private2>
**********************************************************************
*
*/

//*      CMD_READ

/****i* writeSCSICommand() [2.1] *************************************
*
* NAME
*    writeSCSICommand()
*
* DESCRIPTION
*    ^ <primitive 226 21 private1 private2>
**********************************************************************
*
*/

//*      CMD_WRITE

PRIVATE char scsim[128] = { 0, }, *scsiErr = &scsim[0];

/****i* TranslateSCSIErr() [2.1] *************************************
*
* NAME
*    TranslateSCSIErr()
*
* DESCRIPTION
*    Translate a SCSI error number into a string.
*    ^ <primitive 226 22 errNumber>
**********************************************************************
*
*/

METHODFUNC OBJECT *TranslateSCSIErr( int number )
{
   switch (number)
      {
      case HFERR_SelfUnit:
         (void) StringCopy( scsiErr, SCSICMsg( MSG_HFERR_SUNIT_SCSI ) );
         break;

      case HFERR_DMA:
         (void) StringCopy( scsiErr, SCSICMsg( MSG_HFERR_DMA_SCSI ) );
         break;

      case HFERR_Phase:
         (void) StringCopy( scsiErr, SCSICMsg( MSG_HFERR_PHASE_SCSI ) );
         break;

      case HFERR_Parity:
         (void) StringCopy( scsiErr, SCSICMsg( MSG_HFERR_PARITY_SCSI ) );
         break;

      case HFERR_SelTimeout:
         (void) StringCopy( scsiErr, SCSICMsg( MSG_HFERR_TIMEOUT_SCSI ) );
         break;

      case HFERR_BadStatus:
         (void) StringCopy( scsiErr, SCSICMsg( MSG_HFERR_BADSTAT_SCSI ) );
         break;
      
      case HFERR_NoBoard:
         (void) StringCopy( scsiErr, SCSICMsg( MSG_NOT_EXISTS_SCSI ) ); 
         break;
      
      default:
         sprintf( scsiErr, SCSICMsg( MSG_HFERR_UNKNOWN_SCSI ), number );
         break;
      } 

   return( AssignObj( new_str( scsiErr ) ) );
}

/****i* setSCSISenseDataField() [2.1] ********************************
*
* NAME
*    setSCSISenseDataField()
*
* DESCRIPTION
*    <primitive 226 23 private1 senseByteArray>
**********************************************************************
*
*/

METHODFUNC void setSCSISenseDataField( OBJECT *cmdObj, OBJECT *dataObj )
{
   struct SCSICmd *cmd = (struct SCSICmd *) CheckObject( cmdObj );

   UBYTE          *dat = (UBYTE *) ((BYTEARRAY *) dataObj)->bytes;
   UWORD           sz  =   (UWORD) ((BYTEARRAY *) dataObj)->bsize;
   
   if (cmd) // != NULL)
      {
      cmd->scsi_SenseData   = dat;
      cmd->scsi_SenseLength = sz;
      }

   return;
}    

/****h* HandleSCSI() [2.1] *******************************************
*
* NAME
*    HandleSCSI()
*
* DESCRIPTION
*    Translate primitive 226 calls into scsi.device calls.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleSCSI( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 226 );

      return( rval );
      }

   numargs--; // lop off args[0] from numargs.
      
   switch (int_value( args[0] ))
      {
      case 0: // close
              //   <primitive 226 0 private1 private2 private3>
         if (ChkArgCount( 3, numargs, 226 ) != 0)
            return( ReturnError() );
         else   
            {
            CloseSCSI( args[1], args[2], args[3] );
            }
         
         break;
         
      case 1: // open: scsiDeviceName unit: unitNumber
              // ^ boolean <- <primitive 226 1 self scsiDeviceName unitNumber>
         if ( !is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 226 );
         else
            rval = OpenSCSI( args[1], string_value( (STRING *) args[2] ),
                                         int_value( args[3] )
                           );
         break;
         
      case 2: // readInto: bufByteArray
              // ^ <primitive 226 2 private1 private2 bufByteArray>
         if (is_bytearray( args[3] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            rval = ReadSCSI( args[1], args[2], args[3] );
            
         break;
         
         
      case 3: // write: writeByteArray
              // ^ <primitive 226 3 private1 private2 writeByteArray>
         if (is_bytearray( args[3] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            rval = WriteSCSI( args[1], args[2], args[3] );

         break;
         
      case 4: // stop   <primitive 226 4 private2>
         StopSCSI( args[1] );

         break;

      case 5: // start  <primitive 226 5 private2>
         StartSCSI( args[1] );
         
         break;
         
      case 6: // protectionStatus      ^ <primitive 226 6 private2>
         rval = GetProtectStatus( args[1] );
         
         break;
         
      case 7: // diskChanged           ^ <primitive 226 7 private2>
         rval = GetDiskChange( args[1] );
         break;
         
      case 8: // seekTo: location      ^ <primitive 226 8 private2 location>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            rval = DoSeek( args[1], int_value( args[2] ) );

         break;

      case 9: // sendCommand           ^ <primitive 226 9 private1 private2>
         rval = sendSCSIDirectCmd( args[1], args[2] );
         break;
                  
      case 10: // setSCSIDataField: dataByteArray
               //   <primitive 226 10 private1 dataByteArray>
         if (is_bytearray( args[2] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            setSCSIDataField( args[1], args[2] );

         break;
         
      case 11: // actualDataUsedSize   ^ <primitive 226 11 private1>
         rval = getActualDataUsed( args[1] );
         break;
         
      case 12: // setSCSICommandField: cmdByteArray
               //   <primitive 226 12 private1 cmdByteArray>
         if (is_bytearray( args[2] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            setSCSICommandField( args[1], args[2] );

         break;
         
      case 13: // actualCommandUsed   ^ <primitive 226 13 private1>
         rval = getActualCommandUsed( args[1] );

         break;
         
      case 14: // actualSense         ^ <primitive 226 14 private1>
         rval = getActualSense( args[1] );

         break;
         
      case 15: // scsiStatus          ^ <primitive 226 15 private1>
         rval = getSCSIStatus( args[1] );

         break;

      case 16: // setSCSIFlagsField: newFlags
               //   <primitive 226 16 private1 newFlags>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            setSCSIFlagsField( args[1], (UBYTE) int_value( args[2] ) );

         break;

      case 17: // setSCSIStatusField: newStatus
               //   <primitive 226 17 private1 newStatus>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            setSCSIStatusField( args[1], (UBYTE) int_value( args[2] ) );

         break;

      case 18: // scsiSenseData: senseByteArray ^ <primitive 226 18 private1 senseByteArray>
         if (is_bytearray( args[2] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            rval = getSCSISenseData( args[1], args[2] );
          
         break;

      case 19: // format: dataByteArray at: location
               // ^ <primitive 226 19 private1 private2 dataByteArray location>
         if (!is_bytearray( args[3] )  || !is_integer( args[4] ))
            (void) PrintArgTypeError( 226 );
         else
            rval = sendFormat( args[1], args[2], args[3], 
                               int_value( args[4] )
                             );
         break;
      
      case 20: // readSCSICommand   ^ <primitive 226 20 private1 private2>
         break;

      case 21: // writeSCSICommand  ^ <primitive 226 21 private1 private2>
         break;

      case 22: // translateSCSIErrNumber: errNumber
               // ^ <primitive 226 22 errNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            rval = TranslateSCSIErr( int_value( args[1] ) );

         break;

      case 23: // setSCSISenseDataField: senseByteArray
               //   <primitive 226 23 private1 senseByteArray>
         if (is_bytearray( args[2] ) == FALSE)
            (void) PrintArgTypeError( 226 );
         else
            setSCSISenseDataField( args[1], args[2] );
            
         break;
 
      default:
         (void) PrintArgTypeError( 226 );

         break;
      }

   return( rval );
}

/* --------------------- END of SCSI.c file! -------------------------- */
