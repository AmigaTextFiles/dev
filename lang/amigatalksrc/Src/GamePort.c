/****h* AmigaTalk/GamePort.c [3.0] ************************************
*
* NAME
*    GamePort.c
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleGamePort( int numargs, OBJECT **args );
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:Src/GamePort.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/io.h>

#include <AmigaDOSErrs.h>

#include <devices/gameport.h>
#include <devices/inputevent.h>

#ifdef __amigaos4__

# include <clib/alib_protos.h>

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

#include "Constants.h"
#include "Object.h"

#include "FuncProtos.h"

#include "IStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *PrintArgTypeError( int primnumber );

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT UBYTE  *ErrMsg;

/*
struct eGamePort {

   struct MsgPort         *egp_MsgPort;
   struct IOStdReq        *egp_IO;
   struct InputEvent      *egp_IE;
   struct GamePortTrigger *egp_Gpt;
   BYTE                    egp_PrevType; // Usually GPCT_NOCONTROLLER.
};
*/

/****i* CloseGamePort() ************************************
*
* NAME
*    CloseGamePort()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC void CloseGamePort( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   
   if (!eGP) // == NULL)
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );

      return;
      }

   eGP->egp_IO->io_Command = GPD_SETCTYPE;
   eGP->egp_IO->io_Flags   = IOF_QUICK;
   eGP->egp_IO->io_Length  = 1;
   eGP->egp_IO->io_Data    = (APTR) &eGP->egp_PrevType;

   DoIO( (struct IORequest *) eGP->egp_IO ); // Restore controller type.

   if (CheckIO( (struct IORequest *) eGP->egp_IO )) // != NULL)
      AbortIO( (struct IORequest *) eGP->egp_IO );

   WaitIO( (struct IORequest *) eGP->egp_IO );

   CloseDevice( (struct IORequest *) eGP->egp_IO );

   DeleteIORequest( (struct IORequest *) eGP->egp_IO );
   DeletePort( eGP->egp_MsgPort );

   AT_FreeVec( eGP->egp_Gpt, "eGP->egp_Gpt", TRUE );
   AT_FreeVec( eGP->egp_IE,  "eGP->egp_IE" , TRUE );
   AT_FreeVec( eGP,          "eGPStruct"   , TRUE );
   
   return;
}


/****i* OpenGamePort() *************************************
*
* NAME
*    OpenGamePort()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *OpenGamePort( char *gname, int unit )
{
   struct eGamePort *eGP    = (struct eGamePort *) NULL;
   OBJECT           *rval   = o_nil;
   int               errval = 0;
   BYTE              ctype  = GPCT_MOUSE;

   eGP = (struct eGamePort *) AT_AllocVec( sizeof( struct eGamePort ), 
                                           MEMF_CLEAR | MEMF_FAST, 
                                           "eGPStruct", TRUE
                                         );
   if (!eGP) // == NULL)
      {
      MemoryOut( GameCMsg( MSG_GP_OPEN_FUNC_GAME ) );

      return( rval );
      }

   eGP->egp_IE = (struct InputEvent *) 
                   AT_AllocVec( sizeof( struct InputEvent ),
                                MEMF_CLEAR | MEMF_CHIP, 
                                "eGP->egp_IE", TRUE
                              );

   if (!eGP->egp_IE) // == NULL)
      {
      MemoryOut( GameCMsg( MSG_GP_OPEN_FUNC_GAME ) );

      AT_FreeVec( eGP, "eGPStruct", TRUE );

      return( rval );
      }

   eGP->egp_Gpt = (struct GamePortTrigger *) 
                    AT_AllocVec( sizeof( struct GamePortTrigger ),
                                 MEMF_CLEAR | MEMF_CHIP, 
                                 "eGP->egp_Gpt", TRUE
                               );

   if (!eGP->egp_Gpt) // == NULL)
      {
      MemoryOut( GameCMsg( MSG_GP_OPEN_FUNC_GAME ) );

      AT_FreeVec( eGP->egp_IE, "eGP->egp_IE", TRUE );
      AT_FreeVec( eGP,         "eGPStruct"  , TRUE );

      return( rval );
      }

   if (!(eGP->egp_MsgPort = (struct MsgPort *) CreatePort( gname, 0 ))) // == NULL)
      {
      CannotCreatePort( GameCMsg( MSG_GP_GAMEPORT_MSG_GAME ) );

      AT_FreeVec( eGP->egp_Gpt, "eGP->egp_Gpt", TRUE );
      AT_FreeVec( eGP->egp_IE,  "eGP->egp_IE" , TRUE );
      AT_FreeVec( eGP,          "eGPStruct"   , TRUE );

      return( rval );
      }

   eGP->egp_IO = (struct IOStdReq *) CreateIORequest( eGP->egp_MsgPort, sizeof( struct IOStdReq ) );

   if (!eGP->egp_IO) // == NULL)
      {
      CannotCreateStdIO( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );

      DeletePort( eGP->egp_MsgPort );

      AT_FreeVec( eGP->egp_Gpt, "eGP->egp_Gpt", TRUE );
      AT_FreeVec( eGP->egp_IE,  "eGP->egp_IE" , TRUE );
      AT_FreeVec( eGP,          "eGPStruct"   , TRUE );

      return( rval );
      }

   eGP->egp_IO->io_Message.mn_Node.ln_Type = NT_UNKNOWN;
   
   if ((errval = OpenDevice( "gameport.device", unit, // GP_GAMEPORT_DEV, unit, 
                             (struct IORequest *) eGP->egp_IO, 0 )) != 0)
      {
      CannotOpenDevice( "gameport.device" ); // GP_GAMEPORT_DEV );

      DeleteIORequest(  (struct IORequest *) eGP->egp_IO );
      DeletePort( eGP->egp_MsgPort );

      AT_FreeVec( eGP->egp_Gpt, "eGP->egp_Gpt", TRUE );
      AT_FreeVec( eGP->egp_IE,  "eGP->egp_IE" , TRUE );
      AT_FreeVec( eGP,          "eGPStruct"   , TRUE );

      return( rval );
      }

   eGP->egp_IO->io_Command = GPD_ASKCTYPE;
   eGP->egp_IO->io_Length  = 1;
   eGP->egp_IO->io_Data    = (APTR) &ctype;
   
   DoIO( (struct IORequest *) eGP->egp_IO );

   eGP->egp_PrevType = ctype; // Save the original Controller Type.

   if (ctype != GPCT_NOCONTROLLER)
      {
      sprintf( ErrMsg, GameCMsg( MSG_FMT_GP_UNIT_GAME ), unit );

      AlreadyOpen( ErrMsg );

      CloseDevice( (struct IORequest *) eGP->egp_IO );

      DeleteIORequest( (struct IORequest *) eGP->egp_IO );
      DeletePort( eGP->egp_MsgPort );

      AT_FreeVec( eGP->egp_Gpt, "eGP->egp_Gpt", TRUE );
      AT_FreeVec( eGP->egp_IE,  "eGP->egp_IE" , TRUE );
      AT_FreeVec( eGP,          "eGPStruct"   , TRUE );
      
      return( rval );
      }

   rval = AssignObj( new_address( (ULONG) eGP ) );
   
   return( rval );
}

/****i* SetTrigger() [1.0] ******************************************
*
* NAME
*    SetTrigger()
*
* NOTES
*    Helper Function for:
*
*     SetTransition(),
*     SetTimeOut(),
*     SetDeltaX(),
*     SetDeltaY()
*********************************************************************
*
*/

SUBFUNC int SetTrigger( struct eGamePort *eGP )
{
   eGP->egp_IO->io_Command = GPD_SETTRIGGER;
   eGP->egp_IO->io_Length  = (LONG) sizeof( struct GamePortTrigger );
   eGP->egp_IO->io_Data    = (APTR) eGP->egp_Gpt;
   eGP->egp_IO->io_Flags   = IOF_QUICK;

   DoIO( (struct IORequest *) eGP->egp_IO );

   return( eGP->egp_IO->io_Error );
}

// flags = GPTF_DOWNKEYS and/or GPTF_UPKEYS:

/****i* SetTransition() ************************************
*
* NAME
*    SetTransition()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *SetTransition( OBJECT *gameObj, int flags )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   
   if (!eGP) // == NULL)
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   eGP->egp_Gpt->gpt_Keys = (UWORD) flags; // key transition triggers.

   return( AssignObj( new_int( SetTrigger( eGP ) ) ) );
}

/****i* SetTimeOut() ***************************************
*
* NAME
*    SetTimeOut()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *SetTimeOut( OBJECT *gameObj, int value )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   eGP->egp_Gpt->gpt_Timeout = (UWORD) value; // time trig vert blk units.

   return( AssignObj( new_int( SetTrigger( eGP ) ) ) );
}

/****i* SetDeltaX() ****************************************
*
* NAME
*    SetDeltaX()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *SetDeltaX( OBJECT *gameObj, int value )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   eGP->egp_Gpt->gpt_XDelta = (UWORD) value; // X Distance trigger.

   return( AssignObj( new_int( SetTrigger( eGP ) ) ) );
}

/****i* SetDeltaY() ****************************************
*
* NAME
*    SetDeltaY()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *SetDeltaY( OBJECT *gameObj, int value )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   eGP->egp_Gpt->gpt_YDelta = (UWORD) value; // Y Distance trigger.

   return( AssignObj( new_int( SetTrigger( eGP ) ) ) );
}

/****i* ClearGamePort() ************************************
*
* NAME
*    ClearGamePort()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *ClearGamePort( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   eGP->egp_IO->io_Command = CMD_CLEAR;
   eGP->egp_IO->io_Flags   = IOF_QUICK;
   eGP->egp_IO->io_Data    = NULL;
   eGP->egp_IO->io_Length  = 0;

   DoIO( (struct IORequest *) eGP->egp_IO );

   return( AssignObj( new_int( eGP->egp_IO->io_Error ) ) );
}

/****i* GetControllerType() [1.0] **********************************
*
* NAME
*    GetControllerType()
********************************************************************
*/

METHODFUNC OBJECT *GetControllerType( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   int               rval = 0;
      
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   eGP->egp_IO->io_Command = GPD_ASKCTYPE;
   eGP->egp_IO->io_Length  = 1;
   eGP->egp_IO->io_Flags   = IOF_QUICK;
   eGP->egp_IO->io_Data    = (APTR) &rval;
   
   DoIO( (struct IORequest *) eGP->egp_IO );

   /* rval will be one of the following: 

      GPCT_ALLOCATED      -1 // allocated by another user
      GPCT_NOCONTROLLER    0 // Not being used.
      GPCT_MOUSE           1
      GPCT_RELJOYSTICK     2
      GPCT_ABSJOYSTICK     3
   */

#  ifdef DEBUG
   fprintf( stderr, GameCMsg( MSG_FMT_GP_GETCT_GAME ), rval, gameObj );
#  endif   

   return( AssignObj( new_int( (int) (rval & 0xFF) ) ) );
}

/****i* AskTrigger() [1.0] ******************************************
*
* NAME
*    AskTrigger()
*
* NOTES
*    Helper Function for:
*
*     PRIVATE int GetTriggerKeys( char *gname );
*     PRIVATE int GetTriggerTime( char *gname );
*     PRIVATE int GetTriggerXDelta( char *gname );
*     PRIVATE int GetTriggerYDelta( char *gname );
*********************************************************************
*
*/

SUBFUNC int AskTrigger( struct eGamePort *eGP )
{
   eGP->egp_IO->io_Error   = 0;
   eGP->egp_IO->io_Command = GPD_ASKTRIGGER;
   eGP->egp_IO->io_Flags   = IOF_QUICK;
   eGP->egp_IO->io_Length  = sizeof( struct GamePortTrigger );
   eGP->egp_IO->io_Data    = (APTR) eGP->egp_Gpt;
   
   DoIO( (struct IORequest *) eGP->egp_IO );

   return( eGP->egp_IO->io_Error );
}

/****i* GetTriggerKeys() ***********************************
*
* NAME
*    GetTriggerKeys()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetTriggerKeys( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   int               rval = 0;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }
      
   rval = AskTrigger( eGP );

   if (rval != 0)
      {
      CouldNotPerform( GameCMsg( MSG_GP_ASKT_FUNC_GAME ), GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );

      return( o_nil );
      }

   return( AssignObj( new_int( eGP->egp_Gpt->gpt_Keys ) ) );
}

/****i* GetTriggerTime() ***********************************
*
* NAME
*    GetTriggerTime()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetTriggerTime( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   int               rval = 0;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }
        
   rval = AskTrigger( eGP );

   if (rval != 0)
      {
      CouldNotPerform( GameCMsg( MSG_GP_ASKT_FUNC_GAME ), GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );
   
      return( o_nil );
      }

   return( AssignObj( new_int( eGP->egp_Gpt->gpt_Timeout ) ) );
}

/****i* GetTriggerXDelta() *********************************
*
* NAME
*    GetTriggerXDelta()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetTriggerXDelta( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   int               rval = 0;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   rval = AskTrigger( eGP );

   if (rval != 0)
      {
      CouldNotPerform( GameCMsg( MSG_GP_ASKT_FUNC_GAME ), GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );
   
      return( o_nil );
      }

   return( AssignObj( new_int( eGP->egp_Gpt->gpt_XDelta ) ) );
}

/****i* GetTriggerYDelta() *********************************
*
* NAME
*    GetTriggerYDelta()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetTriggerYDelta( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   int               rval = 0;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   rval = AskTrigger( eGP );

   if (rval != 0)
      {
      CouldNotPerform( GameCMsg( MSG_GP_ASKT_FUNC_GAME ), GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );
   
      return( o_nil );
      }

   return( AssignObj( new_int( eGP->egp_Gpt->gpt_YDelta ) ) );
}

/****i* SetControllerType() [1.0] *******************************
*
* NAME
*    SetControllerType()
*
* NOTES
*    newtype has to be one of the following:
*
*      GPCT_ALLOCATED   -1 - Custom device.
*      GPCT_MOUSE        1
*      GPCT_RELJOYSTICK  2
*      GPCT_ABSJOYSTICK  3
***************************************************************** 
*
*/

METHODFUNC OBJECT *SetControllerType( OBJECT *gameObj, int newtype )
{
   struct eGamePort *eGP     = (struct eGamePort *) CheckObject( gameObj );
   BYTE              type    = GPCT_ALLOCATED;
   BOOL              success = FALSE;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_false );
      }

   if (    (newtype != GPCT_ALLOCATED)     // -1
        && (newtype != GPCT_MOUSE)         //  1
        && (newtype != GPCT_RELJOYSTICK)   //  2
        && (newtype != GPCT_ABSJOYSTICK)   //  3
      )
      {
      InvalidItem( GameCMsg( MSG_GP_GAMEPORT_CT_GAME ) );

      return( o_false );
      }

   Forbid();  // Watch out!

    eGP->egp_IO->io_Command = GPD_ASKCTYPE;
    eGP->egp_IO->io_Flags   = IOF_QUICK;
    eGP->egp_IO->io_Length  = 1;
    eGP->egp_IO->io_Data    = (APTR) &type;
   
    DoIO( (struct IORequest *) eGP->egp_IO );

    if (type == GPCT_NOCONTROLLER)
       {
       // GamePort currently NOT being used:
       type                    = (BYTE) newtype;

       eGP->egp_IO->io_Command = GPD_SETCTYPE;
       eGP->egp_IO->io_Flags   = IOF_QUICK;
       eGP->egp_IO->io_Length  = 1;
       eGP->egp_IO->io_Data    = (APTR) &type;
   
       DoIO( (struct IORequest *) eGP->egp_IO );
       success = TRUE;
       }

   Permit();

   if (success != TRUE)
      {
      AlreadyOpen( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );
      }

#  ifdef DEBUG
   else
      fprintf( stderr, GameCMsg( MSG_FMT_GP_SETCT_GAME ), gameObj, type );
#  endif
   
   if (success == TRUE)   
      return( o_true );   
   else
      return( o_false );
}

/****i* ReadEvent() [1.0] *******************************************
*
* NAME
*    ReadEvent()
*
* NOTES
*    Helper Function for:
*
*     PRIVATE int GetButtonCode( char *gname );
*     PRIVATE int GetQualifiers( char *gname );
*     PRIVATE int GetMouseXPos( char *gname );
*     PRIVATE int GetMouseYPos( char *gname );
*     PRIVATE int GetIE_Address( char *gname );
*     PRIVATE int GetTimeStamp( char *gname );
*********************************************************************
*
*/

SUBFUNC void ReadEvent( struct IOStdReq *io, struct InputEvent *ie )
{
   io->io_Flags   = 0;
   io->io_Command = (UWORD) GPD_READEVENT;
   io->io_Length  = (ULONG) sizeof( struct InputEvent );
   io->io_Data    = (APTR)  ie;

   SendIO( (struct IORequest *) io );

   return;
}

/****i* GetButtonCode() ************************************
*
* NAME
*    GetButtonCode()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetButtonCode( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   UWORD             code = 0;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }
        
   ReadEvent( eGP->egp_IO, eGP->egp_IE );

   Wait( 1L << eGP->egp_MsgPort->mp_SigBit );

   if (!GetMsg( eGP->egp_MsgPort )) // == NULL)
      return( new_int( IECODE_NOBUTTON ) );

   code = eGP->egp_IE->ie_Code;

#  ifdef DEBUG
   fprintf( stderr, GameCMsg( MSG_FMT_GP_BUTCD_GAME ), code );
#  endif

   return( AssignObj( new_int( code ) ) );
}

/****i* GetQualifiers() ************************************
*
* NAME
*    GetQualifiers()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetQualifiers( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   UWORD             qual = 0;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }
        
   ReadEvent( eGP->egp_IO, eGP->egp_IE );

   Wait( 1L << eGP->egp_MsgPort->mp_SigBit );

   if (!GetMsg( eGP->egp_MsgPort )) // == NULL)
      return( new_int( 0 ) ); // no qualifiers.
      
   qual = eGP->egp_IE->ie_Qualifier;

#  ifdef DEBUG
   fprintf( stderr, GameCMsg( MSG_FMT_GP_QUALS_GAME ), qual );
#  endif

   return( AssignObj( new_int( qual ) ) );
}

/****i* GetMouseXPos() *************************************
*
* NAME
*    GetMouseXPos()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetMouseXPos( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   WORD              xpos = 0;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }
        
   ReadEvent( eGP->egp_IO, eGP->egp_IE );

   Wait( 1L << eGP->egp_MsgPort->mp_SigBit );

   if (!GetMsg( eGP->egp_MsgPort )) // == NULL)
      return( new_int( 0 ) );
  
   xpos = eGP->egp_IE->ie_X;

#  ifdef DEBUG
   fprintf( stderr, GameCMsg( MSG_FMT_GP_XPOS_GAME ), xpos );
#  endif

   return( AssignObj( new_int( xpos ) ) );
}

/****i* GetMouseYPos() *************************************
*
* NAME
*    GetMouseYPos()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetMouseYPos( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   WORD              ypos = 0;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   ReadEvent( eGP->egp_IO, eGP->egp_IE );

   Wait( 1L << eGP->egp_MsgPort->mp_SigBit );

   if (!GetMsg( eGP->egp_MsgPort )) // == NULL)
      return( new_int( 0 ) );
      
   ypos = eGP->egp_IE->ie_Y;

#  ifdef DEBUG
   fprintf( stderr, GameCMsg( MSG_FMT_GP_YPOS_GAME ), ypos );
#  endif

   return( AssignObj( new_int( ypos ) ) );
}

/****i* GetIE_Address() ************************************
*
* NAME
*    GetIE_Address()
*
* DESCRIPTION
*
************************************************************
*
*/

METHODFUNC OBJECT *GetIE_Address( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   void             *addr = NULL;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }

   ReadEvent( eGP->egp_IO, eGP->egp_IE );

   Wait( 1L << eGP->egp_MsgPort->mp_SigBit );

   if (!GetMsg( eGP->egp_MsgPort )) // == NULL)
      return( new_int( 0 ) );

   addr = (void *) eGP->egp_IE->ie_EventAddress;

#  ifdef DEBUG
   fprintf( stderr, GameCMsg( MSG_FMT_GP_IEADR_GAME ), addr );
#  endif

   return( AssignObj( new_address( (ULONG) addr ) ) );
}

/****i* GetTimeStamp() *************************************
*
* NAME
*    GetTimeStamp()
*
* DESCRIPTION
*
************************************************************
*
*/

PRIVATE OBJECT *GetTimeStamp( OBJECT *gameObj )
{
   struct eGamePort *eGP = (struct eGamePort *) CheckObject( gameObj );
   int               time = -1;
   
   if (!eGP) // == NULL))
      {
      NotFound( GameCMsg( MSG_GP_GAMEPORT_STR_GAME ) );  

      return( o_nil );
      }
        
   ReadEvent( eGP->egp_IO, eGP->egp_IE );
 
   Wait( 1L << eGP->egp_MsgPort->mp_SigBit );

   if (!GetMsg( eGP->egp_MsgPort )) // == NULL)
      return( o_nil );
  
   time = eGP->egp_IE->ie_TimeStamp.tv_secs;

#  ifdef DEBUG
   fprintf( stderr, GameCMsg( MSG_FMT_GP_TIME_GAME ), time );
#  endif

   return( AssignObj( new_int( time ) ) );
}

/****h* HandleGamePort() [1.9] *************************************
*
* NAME
*    HandleGamePort()
*
* DESCRIPTION
*    Translate primitives (223) to GamePort commands to the OS.
********************************************************************
*
*/

PUBLIC OBJECT *HandleGamePort( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 223 );
      return( o_nil );
      }
         
   switch (int_value( args[0] ))
      {
      case 0:  
         if (NullChk( args[1] ) == FALSE)
            {
            CloseGamePort( args[1] );
            }
         break;
      
      case 1:
         if ( !is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 223 );
         else
            {
            rval = OpenGamePort( string_value( (STRING *) args[1] ),
                                 int_value( args[2] )
                               );
            }

         break;

      case 2:
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 223 );
         else
            {
            if (   (int_value( args[2] ) == GPTF_UPKEYS) 
                || (int_value( args[2] ) == GPTF_DOWNKEYS)
                || (int_value( args[2] ) == (GPTF_UPKEYS | GPTF_DOWNKEYS))
               )
               {
               rval = SetTransition( args[1], int_value( args[2] )); 
               }
            else
               {
               int transition = GPTF_UPKEYS | GPTF_DOWNKEYS;

               rval = SetTransition( args[1], transition );
               }
            }

         break;

      case 3:
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 223 );
         else
            {
            if (int_value( args[2] ) < 0)
               {
               rval = SetTimeOut( args[1], 0 );
               }
            else
               rval = SetTimeOut( args[1], int_value( args[2] ) );
            }

         break;

      case 4:
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 223 );
         else
            {
            rval = SetDeltaX( args[1], int_value( args[2] ) );
            }

         break;

      case 5:
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 223 );
         else
            {
            rval = SetDeltaY( args[1], int_value( args[2] ) );
            }
         
         break;

      case 6:
         rval = ClearGamePort( args[1] ); 

         break;

      case 7:
         /* rval will be one of the following: 

            GPCT_ALLOCATED      -1 // allocated by another user
            GPCT_NOCONTROLLER    0 // Not being used.
            GPCT_MOUSE           1
            GPCT_RELJOYSTICK     2
            GPCT_ABSJOYSTICK     3
         */

         rval = GetControllerType( args[1] );

         break;

      case 8:
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 223 );
         else
            {
            if ((int_value( args[2] ) == GPCT_ALLOCATED)   ||
                (int_value( args[2] ) == GPCT_MOUSE)       ||
                (int_value( args[2] ) == GPCT_RELJOYSTICK) ||
                (int_value( args[2] ) == GPCT_ABSJOYSTICK)
               )
               {
               rval = SetControllerType( args[1], int_value( args[2] ) );
               }
            else
               {
               InvalidItem( GameCMsg( MSG_GP_GAMEPORT_CT_GAME ) );
            
               rval = o_false;
               }
            }

         break;
          
      case 10:
         rval = GetButtonCode( args[1] );

         break;

      case 11:
         rval = GetQualifiers( args[1] );

         break;

      case 12:
         rval = GetMouseXPos( args[1] );

         break;

      case 13:
         rval = GetMouseYPos( args[1] );

         break;

      case 14:
         rval = GetIE_Address( args[1] );

         break;
    
      case 15:
         rval = GetTimeStamp( args[1] );

         break;

      case 16:
         rval = GetTriggerKeys( args[1] );

         break;
         
      case 17:
         rval = GetTriggerTime( args[1] );

         break;

      case 18: 
         rval = GetTriggerXDelta( args[1] );

         break;

      case 19:
         rval = GetTriggerYDelta( args[1] );

         break;

      default:
         (void) PrintArgTypeError( 223 );
         break;
      }

   return( rval );
}

/* -------------------- END of GamePort.c file! --------------------- */
