/****h* AmigaTalk/Disk.c [3.0] *****************************************
*
* NAME
*    Disk.c
*
* DESCRIPTION
*    Implement AmigaTalk control over Trackdisk devices.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:Src/Disk.c 3.0 (25-Oct-2004) by J.T. Steichen
*
*    TrackDisk device commands:
*
*     CMD_CLEAR
*     ETD_CLEAR
*     CMD_READ
*     ETD_READ
*     CMD_UPDATE
*     ETD_UPDATE
*     CMD_WRITE
*     ETD_WRITE
*     TD_CHANGENUM
*     TD_CHANGESTATE
*     TD_EJECT
*     TD_FORMAT
*     ETD_FORMAT
*     TD_GETDRIVETYPE
*     TD_GETGEOMETRY
*     TD_GETNUMTRACKS
*     TD_MOTOR
*     ETD_MOTOR
*     TD_PROTSTATUS
*     TD_RAWREAD
*     ETD_RAWREAD
*     TD_RAWWRITE
*     ETD_RAWWRITE
*     TD_SEEK
*     ETD_SEEK
*
*     Not implemented yet:
*
*     TD_ADDCHANGEINT
*     TD_REMCHANGEINT
************************************************************************
*
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/exec.h>
#include <exec/io.h>
#include <AmigaDOSErrs.h>

#include <dos/dosextens.h> 

#include <devices/trackdisk.h>

#ifdef __amigaos4__

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/intuition.h>
# include <proto/graphics.h>

IMPORT struct ExecIFace      *IExec;
IMPORT struct DOSIFace       *IDOS;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "IStructs.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT UBYTE  *UserProblem;
IMPORT UBYTE  *SystemProblem; 

IMPORT UBYTE  *ErrMsg;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

//IMPORT struct MsgPort *CreatePort( char *name, char *name2 );

// ------------------------------------------------------------------

SUBFUNC void ChangeDiskBusy( char *drive, BOOL OnOffFlag )
{
   struct StandardPacket *pk;
   struct Process        *tsk;

   tsk = (struct Process *) FindTask( NULL );

   if ((pk = (struct StandardPacket *) 
              AT_AllocVec( sizeof( struct StandardPacket ),
                           MEMF_PUBLIC | MEMF_CLEAR, 
                           "diskBusyPkt", TRUE ))) // != NULL)
      {
      pk->sp_Msg.mn_Node.ln_Name = (UBYTE *) &(pk->sp_Pkt);

      pk->sp_Pkt.dp_Type = ACTION_INHIBIT;

      pk->sp_Pkt.dp_Link = &(pk->sp_Msg);
      pk->sp_Pkt.dp_Port = &(tsk->pr_MsgPort);
      pk->sp_Pkt.dp_Arg1 = (OnOffFlag == TRUE ? -1L : 0L);

      PutMsg( DeviceProc( drive ), (struct Message *) pk );

      WaitPort( &(tsk->pr_MsgPort) );

      GetMsg( &(tsk->pr_MsgPort) );

      AT_FreeVec( pk, "diskBusyPkt", TRUE );
      }

   return;
}

PRIVATE unsigned int TRACK_SIZE = 0;

/****i* CloseDisk() ************************************************
*
* NAME
*    CloseDisk()
*
* DESCRIPTION
*    Close the TrackDisk device & Remove from AmigaTalk memory.
********************************************************************
*
*/

METHODFUNC void CloseDisk( OBJECT *diskObj )
{
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );
   
   if (!tdptr) // == NULL)
      return;
      
   if (CheckIO( (struct IORequest *) tdptr->etd_IO ) == 0)
      AbortIO( (struct IORequest *) tdptr->etd_IO );

   WaitIO( (struct IORequest *) tdptr->etd_IO );

   ChangeDiskBusy( tdptr->etd_DiskName, FALSE ); // Enable the Validator!

   CloseDevice( (struct IORequest *) tdptr->etd_IO );

   DeleteIORequest( (struct IORequest *) tdptr->etd_IO );
   DeletePort(  tdptr->etd_MsgPort );

   AT_FreeVec( tdptr->etd_DiskName, "closeDisk_DiskName", TRUE );
   AT_FreeVec( tdptr->etd_trkbuff,  "closeDisk_trkbuff" , TRUE );
   AT_FreeVec( tdptr->etd_DG,       "closeDisk_DG"      , TRUE );
   AT_FreeVec( tdptr,               "closeDisk_tdptr"   , TRUE );
   
   return;
}

/****i* gettracksize() *********************************************
*
* NAME
*    gettracksize()
*
* DESCRIPTION
*    Helper function for OpenDisk() only.
********************************************************************
*
*/

SUBFUNC unsigned int gettracksize( struct eTrackDisk *tdptr )
{
   unsigned int rval = 0;
   
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_GETGEOMETRY;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = tdptr->etd_DG->dg_SectorSize * tdptr->etd_DG->dg_TrackSectors;

   return( rval );
}

#define  FASTMEM  MEMF_CLEAR | MEMF_PUBLIC | MEMF_FAST

/****i* OpenDisk() [1.0] *******************************************
*
* NAME
*    OpenDisk()
*
* DESCRIPTION
*
* NOTES
*    Diskname is in the form:  'DFx:', where x is the drive number.
*    Unit should be a number from 0 to 3 & has to match the drive
*    number in the diskname parameter.
********************************************************************
*
*/

METHODFUNC OBJECT *OpenDisk( char *diskname, int unit )
{
   struct eTrackDisk *tdptr = NULL;
   OBJECT            *rval  = o_nil;
   
   tdptr = (struct eTrackDisk *) 
           AT_AllocVec( sizeof( struct eTrackDisk ), FASTMEM, "tdptr", TRUE );

   if (!tdptr) // == NULL)
      {
      return( rval );
      }

   tdptr->etd_DG = (struct DriveGeometry *) 
                   AT_AllocVec( sizeof( struct DriveGeometry ), 
                                FASTMEM, "driveGeometry", TRUE 
                              );

   if (!tdptr->etd_DG) // == NULL)
      {
      AT_FreeVec( tdptr, "tdptr", TRUE );

      return( rval );
      }

   tdptr->etd_DiskName = (char *) AT_AllocVec( strlen( diskname ) + 1,
                                               FASTMEM,
                                               "diskName", TRUE 
                                             );

   if (!tdptr->etd_DiskName) // == NULL)
      {
      AT_FreeVec( tdptr->etd_DG, "driveGeometry", TRUE );
      AT_FreeVec( tdptr,         "tdptr"        , TRUE );

      return( rval );
      }


   if (!(tdptr->etd_MsgPort = CreatePort( diskname, 0 ))) // == NULL)
      {
      AT_FreeVec( tdptr->etd_DiskName, "diskName"     , TRUE );
      AT_FreeVec( tdptr->etd_DG,       "driveGeometry", TRUE );
      AT_FreeVec( tdptr,               "tdptr"        , TRUE );

      return( rval );
      }

   if (!(tdptr->etd_IO = (struct IOExtTD *) CreateIORequest( tdptr->etd_MsgPort, sizeof( struct IOExtTD ))))
      {
      DeleteMsgPort( tdptr->etd_MsgPort );

      AT_FreeVec( tdptr->etd_DiskName, "diskName"     , TRUE );
      AT_FreeVec( tdptr->etd_DG,       "driveGeometry", TRUE );
      AT_FreeVec( tdptr,               "tdptr"        , TRUE );

      return( rval );
      }

   if (OpenDevice( TD_NAME, unit, (struct IORequest *) tdptr->etd_IO, 
                   TDF_ALLOW_NON_3_5 ) != 0)
      {
      DeleteIORequest( (struct IORequest *) tdptr->etd_IO );
      DeleteMsgPort( tdptr->etd_MsgPort );

      AT_FreeVec( tdptr->etd_DiskName, "diskName"     , TRUE );
      AT_FreeVec( tdptr->etd_DG,       "driveGeometry", TRUE );
      AT_FreeVec( tdptr,               "tdptr"        , TRUE );

      return( rval );
      }

   TRACK_SIZE = gettracksize( tdptr );

   if (TRACK_SIZE == 0)
      {
      CloseDevice( (struct IORequest *) tdptr->etd_IO );

      DeleteIORequest( (struct IORequest *) tdptr->etd_IO );
      DeleteMsgPort( tdptr->etd_MsgPort );

      AT_FreeVec( tdptr->etd_DiskName, "diskName"     , TRUE );
      AT_FreeVec( tdptr->etd_DG,       "driveGeometry", TRUE );
      AT_FreeVec( tdptr,               "tdptr"        , TRUE );

      return( rval );
      }

   tdptr->etd_trkbuff = (char *) AT_AllocVec( TRACK_SIZE, 
                                              FASTMEM, "trkbuff", TRUE 
                                            );

   if (!tdptr->etd_trkbuff) // == NULL)
      {
      CloseDevice( (struct IORequest *) tdptr->etd_IO );

      DeleteIORequest( (struct IORequest *) tdptr->etd_IO );
      DeleteMsgPort( tdptr->etd_MsgPort );

      AT_FreeVec( tdptr->etd_DiskName, "diskName"     , TRUE );
      AT_FreeVec( tdptr->etd_DG,       "driveGeometry", TRUE );
      AT_FreeVec( tdptr,               "tdptr"        , TRUE );

      return( rval );
      }

   StringCopy( tdptr->etd_DiskName, diskname );

   ChangeDiskBusy( diskname, TRUE ); // Stop the Validator!

   return( AssignObj( new_address( (ULONG) tdptr ) ) );
}

/****i* GetErrorString() [1.0] *************************************
*
* NAME
*    GetErrorString()
*
* DESCRIPTION
*
********************************************************************
*
*/

METHODFUNC char *GetErrorString( OBJECT *diskObj )
{
   struct eTrackDisk *tdptr  = (struct eTrackDisk *) CheckObject( diskObj );
   unsigned int       errnum = 0;
   char              *s;

   if (!tdptr) // == NULL)
      return( NULL );

   errnum = tdptr->etd_IO->iotd_Req.io_Error;

   switch (errnum)
      {
      case 0:
         s = DiskCMsg( MSG_DI_ERR_NOERR_DISK );
         break;
      
      case TDERR_NotSpecified:
         s = DiskCMsg( MSG_DI_ERR_UNDET_DISK );
         break;

      case TDERR_NoSecHdr:
         s = DiskCMsg( MSG_DI_ERR_SECHDR_DISK );
         break;

      case TDERR_BadSecPreamble:
         s = DiskCMsg( MSG_DI_ERR_SECPRE_DISK );
         break;

      case TDERR_BadSecID:
         s = DiskCMsg( MSG_DI_ERR_SECIDT_DISK );
         break;

      case TDERR_BadHdrSum:
         s = DiskCMsg( MSG_DI_ERR_HDRSUM_DISK );
         break;

      case TDERR_BadSecSum:
         s = DiskCMsg( MSG_DI_ERR_SECSUM_DISK );
         break;

      case TDERR_TooFewSecs:
         s = DiskCMsg( MSG_DI_ERR_SECNUM_DISK );
         break;

      case TDERR_BadSecHdr:
         s = DiskCMsg( MSG_DI_ERR_NOREAD_DISK );
         break;

      case TDERR_WriteProt:
         s = DiskCMsg( MSG_DI_ERR_WRTPROT_DISK );
         break;

      case TDERR_DiskChanged:
         s = DiskCMsg( MSG_DI_ERR_DSKCHG_DISK );
         break;

      case TDERR_SeekError:
         s = DiskCMsg( MSG_DI_ERR_SEEKERR_DISK );
         break;

      case TDERR_NoMem:
         s = DiskCMsg( MSG_DI_ERR_NOMEM_DISK );
         break;

      case TDERR_BadUnitNum:
         s = DiskCMsg( MSG_DI_ERR_BADUNIT_DISK );
         break;

      case TDERR_BadDriveType:
         s = DiskCMsg( MSG_DI_ERR_BADTYPE_DISK );
         break;

      case TDERR_DriveInUse:
         s = DiskCMsg( MSG_DI_ERR_USEDDR_DISK );
         break;

      case TDERR_PostReset:
         s = DiskCMsg( MSG_DI_ERR_RESET_DISK );
         break;

      case 255:
         s = DiskCMsg( MSG_DI_ERR_EJECT_DISK );
         break;

      default:
         s = DiskCMsg( MSG_DI_ERR_UNKNOWN_DISK );
         break;
      }

   return( s );
}

/****i* GetTrackSize() [1.0] ***************************************
*
* NAME
*    GetTrackSize()
*
* DESCRIPTION
*
********************************************************************
*
*/

METHODFUNC unsigned int GetTrackSize( OBJECT *diskObj )
{
   unsigned int       rval  = 0;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( 0 );
   
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_GETGEOMETRY;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = tdptr->etd_DG->dg_SectorSize * tdptr->etd_DG->dg_TrackSectors;

   return( rval );
} 

/****i* AddDGFlag() [1.0] ******************************************
*
* NAME
*    AddDGFlag()
*
* DESCRIPTION
*    Helper function for GetDeviceType().
********************************************************************
*
*/

SUBFUNC void AddDGFlag( struct eTrackDisk *tdptr, char *str )
{
   if ((tdptr->etd_DG->dg_Flags & DGF_REMOVABLE) == DGF_REMOVABLE)
      StringCat( str, DiskCMsg( MSG_DI_REMOVABLE_DISK ) );
   else
      StringCat( str, DiskCMsg( MSG_DI_NOREMOVABLE_DISK ) );

   return;
}

char dt[128] = { 0, }, *dtype = &dt[0];

/****i* GetDeviceType() [1.0] **************************************
*
* NAME
*    GetDeviceType()
*
* DESCRIPTION
*
********************************************************************
*
*/

METHODFUNC char *GetDeviceType( OBJECT *diskObj )
{
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );
   int    deviceType = 0;
   
   if (!tdptr) // == NULL)
      return( NULL );
   
   tdptr->etd_DG->dg_DeviceType       = 0xFF;
   
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_GETGEOMETRY;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   deviceType = (int) tdptr->etd_DG->dg_DeviceType; // Stupid gcc compiler
   
   if (deviceType >= 0)
      {
      switch (tdptr->etd_DG->dg_DeviceType)
         {
         case DG_DIRECT_ACCESS:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_DACC_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_SEQUENTIAL_ACCESS:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_SACC_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_PRINTER:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_PRTR_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_PROCESSOR:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_PROC_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_WORM:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_WORM_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_CDROM:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_CDROM_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_SCANNER:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_SCANR_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_OPTICAL_DISK:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_OPTDSK_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_MEDIUM_CHANGER:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_MEDCHG_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         case DG_COMMUNICATION:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_COMM_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;

         default:
         case DG_UNKNOWN:
            StringCopy( dtype, DiskCMsg( MSG_DI_TYPE_UNKNOWN_DISK ) );
            AddDGFlag( tdptr, dtype );
            break;
         }
   
      return( dtype );
      }
   else
      {
      sprintf( ErrMsg, DiskCMsg( MSG_FMT_DI_UNKGEOM_DISK ), tdptr->etd_DiskName );

      UserInfo( ErrMsg, UserProblem );

      return( NULL );
      }
}

/****i* ReadTrack() [1.0] ******************************************
*
* NAME
*    ReadTrack()
*
* DESCRIPTION
*
********************************************************************
*
*/

METHODFUNC OBJECT *ReadTrack( OBJECT *diskObj, int tnum )
{
   OBJECT            *rval  = o_nil;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Length  = TRACK_SIZE;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_trkbuff;
   tdptr->etd_IO->iotd_Req.io_Offset  = (ULONG) (TRACK_SIZE * tnum);
   tdptr->etd_IO->iotd_Req.io_Command = CMD_READ;

   BeginIO( (struct IORequest *) tdptr->etd_IO );
   WaitIO(  (struct IORequest *) tdptr->etd_IO ); /* ???? */

   if (tdptr->etd_IO->iotd_Req.io_Error != 0)
      {
      sprintf( ErrMsg, DiskCMsg( MSG_FMT_DI_READERR_DISK ), GetErrorString( diskObj ) );

      UserInfo( ErrMsg, SystemProblem );

      return( rval );
      }

   rval = AssignObj( (OBJECT *) new_bytearray( (uchar *) tdptr->etd_trkbuff, 
                                                         TRACK_SIZE
                                             )
                   );
    
   return( rval );
}

/****i* WriteTrack() [1.0] *****************************************
*
* NAME
*    WriteTrack()
*
* DESCRIPTION
*
********************************************************************
*
*/

METHODFUNC OBJECT *WriteTrack( OBJECT *diskObj, BYTEARRAY *bstr, int tnum )
{
   int                rval  = 0;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( o_false );
   
   tdptr->etd_IO->iotd_Req.io_Length  = -1;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) bstr->bytes;
   tdptr->etd_IO->iotd_Req.io_Offset  = (ULONG) (TRACK_SIZE * tnum);
   tdptr->etd_IO->iotd_Req.io_Command = CMD_WRITE; // TD_FORMAT??

   BeginIO( (struct IORequest *) tdptr->etd_IO );
   WaitIO(  (struct IORequest *) tdptr->etd_IO ); /* ???? */

   rval = tdptr->etd_IO->iotd_Req.io_Error;

   if (rval != 0)
      {
      sprintf( ErrMsg, DiskCMsg( MSG_FMT_DI_WRITERR_DISK ), GetErrorString( diskObj ) );

      UserInfo( ErrMsg, SystemProblem );
      }

   if (rval == 0)
      return( o_true );
   else
      return( AssignObj( new_int( rval ) ) );
}

/****i* GetDriveType() [1.0] ***************************************
*
* NAME
*    GetDriveType()
*
* DESCRIPTION
*
********************************************************************
*
*/

METHODFUNC int GetDriveType( OBJECT *diskObj )
{
   int                rval  = -1;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Command = TD_GETDRIVETYPE;

   BeginIO( (struct IORequest *) tdptr->etd_IO );
   WaitIO(  (struct IORequest *) tdptr->etd_IO ); /* ???? */

   rval = tdptr->etd_IO->iotd_Req.io_Actual;

   // 1 == DRIVE3_5, 2 == DRIVE5_25, 3 == DRIVE3_5_150RPM

   return( rval );
}

/****i* SeekTrack() [1.0] ******************************************
*
* NAME
*    SeekTrack()
*
* DESCRIPTION
*
********************************************************************
*
*/

METHODFUNC void SeekTrack( OBJECT *diskObj, int tnum )
{
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return;
     
   tdptr->etd_IO->iotd_Req.io_Offset  = (ULONG) (TRACK_SIZE * tnum);
   tdptr->etd_IO->iotd_Req.io_Command = TD_SEEK;

   BeginIO( (struct IORequest *) tdptr->etd_IO );
   WaitIO(  (struct IORequest *) tdptr->etd_IO ); /* ???? */

   if (tdptr->etd_IO->iotd_Req.io_Error != 0)
      {
      sprintf( ErrMsg, DiskCMsg( MSG_FMT_DI_SEEKERR_DISK ), GetErrorString( diskObj ) );

      UserInfo( ErrMsg, SystemProblem );
      }

   return;
}

/****i* GetSectorSize() *******************************************
*
* NAME
*    GetSectorSize()
*
* DESCRIPTION
*    Return the TrackDisk SectorSize (normally 512 bytes).
*******************************************************************
*
*/

METHODFUNC unsigned int GetSectorSize( OBJECT *diskObj )
{
   unsigned int       rval  = 0;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_GETGEOMETRY;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = tdptr->etd_DG->dg_SectorSize;

   return( rval );
}


/****i* GetNumberTracks() *****************************************
*
* NAME
*    GetNumberTracks()
*
* DESCRIPTION
*    Return the number of tracks.
*******************************************************************
*
*/

METHODFUNC unsigned int GetNumberTracks( OBJECT *diskObj )
{
   unsigned int       rval  = 0;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_GETGEOMETRY;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = tdptr->etd_DG->dg_Heads * tdptr->etd_DG->dg_Cylinders;

   return( rval );
}

/****i* GetTotalSectors() *****************************************
*
* NAME
*    GetTotalSectors()
*
* DESCRIPTION
*    Return the total number of sectors on the disk.
*    1760 for a 3-1/2" disk.
*******************************************************************
*
*/

METHODFUNC unsigned int GetTotalSectors( OBJECT *diskObj )
{
   unsigned int       rval  = 0;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );

   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_GETGEOMETRY;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = tdptr->etd_DG->dg_TotalSectors;

   return( rval );
}

/****i* ClearReadBuffer() *****************************************
*
* NAME
*    ClearReadBuffer()
*
* DESCRIPTION
*    Tell the TrackDisk Device to mark the track buffer as 
*    invalid, forcing a re-read of the disk on the next operation.  
*******************************************************************
*
*/

METHODFUNC void ClearReadBuffer( OBJECT *diskObj )
{
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return;

   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = CMD_CLEAR;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   return;
}

/****i* isDiskPresent() *******************************************
*
* NAME
*    isDiskPresent()
*
* DESCRIPTION
*    Return true if a disk is in the TrackDisk, false otherwise.   
*******************************************************************
*
*/

METHODFUNC BOOL isDiskPresent( OBJECT *diskObj )
{
   BOOL               rval  = FALSE;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
      
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_CHANGESTATE;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   if (tdptr->etd_IO->iotd_Req.io_Actual == 0)
      rval = TRUE;
   else
      rval = FALSE;

   return( rval );
}

/****i* isWriteProtected() ****************************************
*
* NAME
*    isWriteProtected()
*
* DESCRIPTION
*    Return true if a disk is write_protected, false otherwise.   
*******************************************************************
*
*/

METHODFUNC BOOL isWriteProtected( OBJECT *diskObj )
{
   BOOL               rval  = FALSE;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_PROTSTATUS;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   if (tdptr->etd_IO->iotd_Req.io_Actual == 0)
      rval = FALSE;
   else
      rval = TRUE;

   return( rval );
}

/****i* EjectDisk() ***********************************************
*
* NAME
*    EjectDisk()
*
* DESCRIPTION
*    Send an Eject Disk command.
*******************************************************************
*
*/

METHODFUNC int EjectDisk( OBJECT *diskObj )
{
   int                rval  = -1;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_DG;
   tdptr->etd_IO->iotd_Req.io_Command = TD_EJECT;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = tdptr->etd_IO->iotd_Req.io_Actual;

   return( rval );
}

/****i* TurnMotorOn() *********************************************
*
* NAME
*    TurnMotorOn()
*
* DESCRIPTION
*    Start the Disk drive motor.
*******************************************************************
*
*/

METHODFUNC void TurnMotorOn( OBJECT *diskObj )
{
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return;

   tdptr->etd_IO->iotd_Req.io_Length  = 1; // Turn Motor on signal.
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Command = TD_MOTOR;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   return;
}

/****i* TurnMotorOff() ********************************************
*
* NAME
*    TurnMotorOff()
*
* DESCRIPTION
*    Turn off the Disk drive motor.
*******************************************************************
*
*/

METHODFUNC void TurnMotorOff( OBJECT *diskObj )
{
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return;

   TurnMotorOn( diskObj ); // Start in a Known state.
   
   tdptr->etd_IO->iotd_Req.io_Length  = 0; // Turn Motor off signal.
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Command = TD_MOTOR;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   return;
}

/****i* FormatTrack() *********************************************
*
* NAME
*    FormatTrack()
*
* DESCRIPTION
*    Format the given tracknumber.
*******************************************************************
*
*/

METHODFUNC int FormatTrack( OBJECT *diskObj, BYTEARRAY *data, int tnum )
{
   int                rval  = -1;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Length  = TRACK_SIZE;
   tdptr->etd_IO->iotd_Req.io_Flags   = IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) data->bytes;
   tdptr->etd_IO->iotd_Req.io_Offset  = (ULONG) (TRACK_SIZE * tnum);
   tdptr->etd_IO->iotd_Req.io_Command = TD_FORMAT;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = tdptr->etd_IO->iotd_Req.io_Actual;
   
   return( rval );
}

/****i* ReadRawData() *********************************************
*
* NAME
*    ReadRawData()
*
* DESCRIPTION
*    Read Raw (MFM) data into the buffer.
*******************************************************************
*
*/

METHODFUNC OBJECT *ReadRawData( OBJECT *diskObj, int tnum )
{
   OBJECT            *rval  = o_nil;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Length  = TRACK_SIZE;
   tdptr->etd_IO->iotd_Req.io_Flags  |= IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) tdptr->etd_trkbuff;
   tdptr->etd_IO->iotd_Req.io_Offset  = (ULONG) (TRACK_SIZE * tnum);
   tdptr->etd_IO->iotd_Req.io_Command = TD_RAWREAD;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = AssignObj( (OBJECT *) new_bytearray( (uchar *) tdptr->etd_trkbuff, 
                                                TRACK_SIZE
                                             )
                   );
   
   return( rval );
}

/****i* WriteRawData() ********************************************
*
* NAME
*    WriteRawData()
*
* DESCRIPTION
*    Write Raw (MFM) data to the track.
*******************************************************************
*
*/

METHODFUNC int WriteRawData( OBJECT *diskObj, BYTEARRAY *bstr, int tnum )
{
   int                rval  = -1;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   
   tdptr->etd_IO->iotd_Req.io_Length  = TRACK_SIZE;
   tdptr->etd_IO->iotd_Req.io_Flags  |= IOF_QUICK;
   tdptr->etd_IO->iotd_Req.io_Data    = (APTR) bstr->bytes;
   tdptr->etd_IO->iotd_Req.io_Offset  = (ULONG) (TRACK_SIZE * tnum);
   tdptr->etd_IO->iotd_Req.io_Command = TD_RAWWRITE;

   DoIO( (struct IORequest *) tdptr->etd_IO );

   rval = tdptr->etd_IO->iotd_Req.io_Actual;
   
   return( rval );
}

/****i* SetSyncType() *********************************************
*
* NAME
*    SetSyncType()
*
* DESCRIPTION
*    Change the sync-word that TrackDisk will use during 
*    reads & writes.
*******************************************************************
*
*/

METHODFUNC void SetSyncType( OBJECT *diskObj, int syncType )
{
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return;
   
   if (syncType == 0)
      tdptr->etd_IO->iotd_Req.io_Flags = IOTDF_INDEXSYNC;
   else
      tdptr->etd_IO->iotd_Req.io_Flags = IOTDF_WORDSYNC;
   
   return;
}

/****i* GetBufferPointer() *****************************************
*
* NAME
*    GetBufferPointer()
*
* DESCRIPTION
*    Helper function for HandleDisk().
********************************************************************
*
*/

SUBFUNC char *GetBufferPointer( OBJECT *diskObj )
{
   char              *rval  = NULL;
   struct eTrackDisk *tdptr = (struct eTrackDisk *) CheckObject( diskObj );

   if (!tdptr) // == NULL)
      return( rval );
   else 
      rval = tdptr->etd_trkbuff;

   return( rval );
}


/****h* HandleDisk() [1.5] *****************************************
*
* NAME
*    HandleDisk()
*
* DESCRIPTION
*    Translate primitives (229) into TrackDisk commands for the OS.
********************************************************************
*
*/

PUBLIC OBJECT *HandleDisk( int numargs, OBJECT **args )
{
   IMPORT int DisplayBytes( BYTEARRAY *, char *wtitle );

   OBJECT *rval = o_nil;
   int     temp = 0;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 229 );
      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // void CloseDisk( OBJECT *diskObj )
         if (NullChk( args[1] ) == FALSE)
            {
            CloseDisk( args[1] );
            }    
     
         break;
         
      case 1: // OBJECT *OpenDisk( char *diskname, int unit )
         if ( !is_string( args[1] ) || !is_integer( args[2] ) )
            (void) PrintArgTypeError( 229 );
         else
            {
            rval = OpenDisk( string_value( (STRING *) args[1] ), 
                             int_value(               args[2] )
                           );
            }

         break;
         
      case 2: // OBJECT *ReadTrack( OBJECT *diskObj, int tnum )
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 229 );
         else
            {
            // rval is really a ByteArray!
            rval = ReadTrack( args[1], int_value( args[2] ) ); 
            }

         break;
         
      case 3: // int WriteTrack( OBJECT *diskObj, BYTEARRAY *bstr, int tnum)
         if ( !is_bytearray( args[2] ) || !is_integer(   args[3] ))
            (void) PrintArgTypeError( 229 );
         else
            rval = WriteTrack( args[1], (BYTEARRAY *) args[2],
                               int_value( args[3] ) 
                             );
         break;

      case 4: // void ClearReadBuffer( OBJECT *diskObj )
         ClearReadBuffer( args[1] );
         break;
         
      case 5: // void SetSyncType( OBJECT *diskObj, int syncType )
              // for Raw Reads & Writes 
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 229 );
         else
            SetSyncType( args[1], int_value( args[2] ) ); 

         break;
         
      case 6: // BOOL isDiskPresent( OBJECT *diskObj )
         if (isDiskPresent( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;

         break;

      case 7: // BOOL isWriteProtected( OBJECT *diskObj )
         if (isWriteProtected( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;

         break;

      case 8: // char *GetErrorString( OBJECT *diskObj )
         rval = AssignObj( new_str( GetErrorString( args[1] ) )); 

         break;

      case 9: // char *GetDeviceType( OBJECT *diskObj )
         rval = AssignObj( new_str( GetDeviceType( args[1] ) )); 

         break;

      case 10: // unsigned int GetTrackSize( OBJECT *diskObj )
         rval = AssignObj( new_int( GetTrackSize( args[1] ) )); 

         break;

      case 11: // int GetDriveType( OBJECT *diskObj )
         rval = AssignObj( new_int( GetDriveType( args[1] ) )); 

         break;

      case 12: // unsigned int GetSectorSize( OBJECT *diskObj )
         rval = AssignObj( new_int( GetSectorSize( args[1] ) )); 

         break;

      case 13: // unsigned int GetNumberTracks( OBJECT *diskObj )
         rval = AssignObj( new_int( GetNumberTracks( args[1] ) )); 

         break;

      case 14: // unsigned int GetTotalSectors( OBJECT *diskObj )
         rval = AssignObj( new_int( GetTotalSectors( args[1] ) )); 

         break;

      case 15: // void SeekTrack( OBJECT *diskObj, int tnum )
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 229 );
         else
            SeekTrack( args[1], int_value( args[2] ) ); 

         break;

      case 16: // int EjectDisk( OBJECT *diskObj )
         rval = AssignObj( new_int( EjectDisk( args[1] ) ));

         break;

      case 17: // void TurnMotorOn( OBJECT *diskObj )
         TurnMotorOn( args[1] );

         break;

      case 18: // void TurnMotorOff( OBJECT *diskObj )
         TurnMotorOff( args[1] );

         break;

      case 19: // int FormatTrack( OBJECT *diskObj, BYTEARRAY *data, int tnum )
         if ( !is_bytearray( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 229 );
         else
            rval = AssignObj( new_int( FormatTrack( args[1], (BYTEARRAY *) args[2],
                                                    int_value( args[3] )
                                                  )
                                     )
                          );

         break;

      case 20: // OBJECT *ReadRawData( OBJECT *diskObj, int tnum )
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 229 );
         else
            {
            // rval is really a ByteArray!
            rval = ReadRawData( args[1], int_value( args[2] ) );
            }

         break;

      case 21: // int WriteRawData( OBJECT *diskObj, BYTEARRAY *bstr, int tnum)
         if (!is_bytearray( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 229 );
         else
            {
            if ((temp = WriteRawData( args[1], (BYTEARRAY *) args[2],
                                      int_value( args[3] ))) >= 0)
               {
               rval = AssignObj( new_int( temp ) );
               }
            }

         break;

      case 22: // IMPORT int DisplayBytes( BYTEARRAY *, char *wtitle );
         
         if (is_bytearray( args[1] ) == FALSE || !is_string( args[2] ))
            (void) PrintArgTypeError( 229 );
         else
            {
            if ((temp = DisplayBytes( (BYTEARRAY *) args[1],
                                      string_value( (STRING *) args[2] )
                                    )) >= 0)
               {
               rval = o_nil;
               }
            }

         break;

      default:
         (void) PrintArgTypeError( 229 );
         break;
      }
 
   return( rval );
}

/* --------------------- END of Disk.c file! ------------------------- */
