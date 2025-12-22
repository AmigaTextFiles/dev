/****h* AmigaTalk/Rexx.c [3.0] *****************************************
*
* NAME
*    Rexx.c
*
* DESCRIPTION
*    Amigatalk command wrappers for comminucating with ARexx.
*
*    PUBLIC OBJECT *HandleARexx( int numargs, OBJECT **args ) <211 0-25>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
*    22-Dec-2002 - added checkRexxMsg, getRexxVar:, & setRexxVar:
*                  primitives 26 through 28.
*
*    04-Dec-2002 - added rexxMsg ^ <primitive 211 25 private>
*
*    27-Nov-2002 - Added findARexxPort: portName method primitive &
*                  the sendOutMessage:to: method primitive.
*
*    19-Nov-2002 - Created this file.
*
* NOTES
*    $VER: AmigaTalk/Src/Rexx.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>

#include <AmigaDOSErrs.h>

#include <rexx/errors.h>
#include <rexx/rexxio.h>
#include <rexx/rxslib.h>
#include <rexx/storage.h>

#include <dos/dos.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/rexxsyslib_protos.h>

IMPORT struct RxsLib *RexxSysBase; // Located in Global.c file.

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/rexxsyslib.h>

PUBLIC struct RexxSysIFace *IRexxSys;
IMPORT struct Library      *RexxSysBase; // Located in Global.c file.

#endif

#include "Constants.h"
#include "Object.h"
#include "FuncProtos.h"
#include "ATStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#define REXX_EXTENSION "rexx"

IMPORT OBJECT *PrintArgTypeError( int primnumber );

// In Global.c: ----------------------------

IMPORT int    debug;
IMPORT UBYTE *ErrMsg;

IMPORT UBYTE *ATalkProblem;
IMPORT UBYTE *UserProblem;

IMPORT OBJECT *o_nil, *o_true, *o_false;

/* RexxSysBase is used in ATBrowser.c functions as well as this 
** file, so it's definition was moved to Global.c 
*/

// ------------------------------------------------------------------

/*
// Command (action) codes for message packets

#define RXCOMM	  0x01000000	       // a command-level invocation
#define RXFUNC	  0x02000000	       // a function call
#define RXCLOSE   0x03000000	       // close the REXX server
#define RXQUERY   0x04000000	       // query for information
#define RXADDFH   0x07000000	       // add a function host
#define RXADDLIB  0x08000000	       // add a function library
#define RXREMLIB  0x09000000	       // remove a function library
#define RXADDCON  0x0A000000	       // add/update a ClipList string
#define RXREMCON  0x0B000000	       // remove a ClipList string
#define RXTCOPN   0x0C000000	       // open the trace console
#define RXTCCLS   0x0D000000	       // close the trace console

// Command modifier flag bits

#define RXFB_NOIO    16	       // suppress I/O inheritance?
#define RXFB_RESULT  17	       // result string expected?
#define RXFB_STRING  18	       // program is a "string file"?
#define RXFB_TOKEN   19	       // tokenize the command line?
#define RXFB_NONRET  20	       // a "no-return" message?

// The flag form of the command modifiers

#define RXFF_NOIO    (1L << RXFB_NOIO  )
#define RXFF_RESULT  (1L << RXFB_RESULT)
#define RXFF_STRING  (1L << RXFB_STRING)
#define RXFF_TOKEN   (1L << RXFB_TOKEN )
#define RXFF_NONRET  (1L << RXFB_NONRET)

#define RXCODEMASK   0xFF000000
#define RXARGMASK    0x0000000F

*/


struct MyRexxStruct {

#  ifdef  __SASC
   struct RxsLib  *mrs_RexxSysBase;
#  else
   struct Library *mrs_RexxSysBase;
#  endif

   char           *mrs_PortName;
   struct MsgPort *mrs_RexxPort;
   struct RexxMsg  mrs_RexxMsg;
};

typedef struct MyRexxStruct MRS;

PRIVATE BOOL opened_mrs_RexxSysBase = FALSE;

/****i* closeARexx() [3.0] *******************************************
*
* NAME
*    closeARexx()
*
* DESCRIPTION 
*    <primitive 211 0 private>
**********************************************************************
*
*/

METHODFUNC void closeARexx( OBJECT *rxObj )
{
   MRS *rx = (MRS *) CheckObject( rxObj );

   if (!rx || (rx == (MRS *) o_nil))
      return;

   if (rx->mrs_RexxPort) // != NULL)      
      DeletePort( rx->mrs_RexxPort );

   if (opened_mrs_RexxSysBase == TRUE)   
      {
      if (rx->mrs_RexxSysBase) // != NULL)    
         {
#        ifdef __amigaos4__
         DropInterface( (struct Interface *) IRexxSys ); 
#        endif	    

         CloseLibrary( (struct Library *) rx->mrs_RexxSysBase );
         
         opened_mrs_RexxSysBase = FALSE;
         }
      }

   AT_FreeVec( rx->mrs_PortName, "arexxPortName", TRUE );

   AT_FreeVec( rx, "MyRexxStruct", TRUE );

   return;
}

/****i* setup_rexx_port() [3.0] **************************************
*
* NAME
*    setup_rexx_port()
*
* DESCRIPTION 
*    If the ARexx port is not already in the system, then use
*    CreatePort() to add it.  Used by openARexx() only
**********************************************************************
*
*/

PRIVATE struct MsgPort *setup_rexx_port( char *HostFuncPort )
{
//   IMPORT struct MsgPort *CreatePort( char *, LONG );
   
   struct MsgPort *the_port = (struct MsgPort *) NULL;

   Forbid();

      the_port = FindPort( HostFuncPort );

      // look for someone else that looks just like us!
      if (the_port) // != NULL)
         {
         Permit();

         AlreadyOpen( HostFuncPort );
         
         APrint( ErrMsg );       

         return( the_port );
         }

      the_port = CreatePort( HostFuncPort, 0L );

   Permit();

   return( the_port );
}

/****i* openARexx() [3.0] ********************************************
*
* NAME
*    openARexx()
*
* DESCRIPTION 
*    ^ <primitive 211 1 arexxPortName>
**********************************************************************
*
*/

METHODFUNC OBJECT *openARexx( char *portName )
{
   OBJECT         *rval = o_nil;
   struct RexxMsg *rm   = NULL;

   MRS    *mrs  = (MRS *) AT_AllocVec( sizeof( MRS ), MEMF_ANY | MEMF_CLEAR,
                                       "MyRexxStruct", TRUE 
                                     );

   char   *name = (char *) AT_AllocVec( StringLength( portName ) + 1,
                                        MEMF_ANY | MEMF_CLEAR, "arexxPortName", TRUE 
                                      );

   if (!mrs || !name) // == NULL)
      {
      MemoryOut( RexxCMsg( MSG_OPEN_AREXX_FUNC_REXX ) );
      
      if (name) // != NULL)
         AT_FreeVec( name, "arexxPortName", TRUE );

      if (mrs) // != NULL)
         AT_FreeVec( mrs, "MyRexxStruct", TRUE );
         
      return( rval );
      }   

   mrs->mrs_PortName = name;
   StringCopy( name, portName );

   if (RexxSysBase) // != NULL)
#     ifdef __SASC
      mrs->mrs_RexxSysBase = RexxSysBase;
#     else
      mrs->mrs_RexxSysBase = (struct Library *) RexxSysBase;
#     endif
   else
      {
#     ifdef __SASC
      if ((mrs->mrs_RexxSysBase = (struct RxsLib *) OpenLibrary( RXSNAME, 0L )) == NULL)  
         {
#     else
      if ((mrs->mrs_RexxSysBase = OpenLibrary( RXSNAME, 50L ))) // == NULL)  
         {
	 if (!(IRexxSys = (struct RexxSysIFace *) GetInterface( RexxSysBase, "main", 1, NULL )))
	    {
	    CloseLibrary( RexxSysBase );
            NotOpened( 5 ); // RXSNAME

            if (name) // != NULL)
               AT_FreeVec( name, "arexxPortName", TRUE );

            if (mrs) // != NULL)
               AT_FreeVec( mrs, "MyRexxStruct", TRUE );
         
            return( rval ); // return( ERROR_INVALID_RESIDENT_LIBRARY );
	    }
	 }
      else
         {
#     endif
         NotOpened( 5 ); // RXSNAME

         if (name) // != NULL)
            AT_FreeVec( name, "arexxPortName", TRUE );

         if (mrs) // != NULL)
            AT_FreeVec( mrs, "MyRexxStruct", TRUE );
         
         return( rval ); // return( ERROR_INVALID_RESIDENT_LIBRARY );
         }
      
      opened_mrs_RexxSysBase = TRUE;
      }

   // set up a public port for rexx to talk to us later:
   if (!(mrs->mrs_RexxPort = setup_rexx_port( portName ))) // == NULL)
      {
      CannotSetup( RexxCMsg( MSG_PUBLIC_REXXPORT_REXX ) );

      if (opened_mrs_RexxSysBase != FALSE)
         {
#        ifdef __amigaos4__
         DropInterface( (struct Interface *) IRexxSys );
#        endif	    

         CloseLibrary( (struct Library *) mrs->mrs_RexxSysBase );

         opened_mrs_RexxSysBase = FALSE;
         }

      if (name) // != NULL)
         AT_FreeVec( name, "arexxPortName", TRUE );

      if (mrs) // != NULL)
         AT_FreeVec( mrs, "MyRexxStruct", TRUE );
         
      return( rval ); // return( IoErr() );
      }

   mrs->mrs_RexxPort->mp_Node.ln_Name = portName;
   
   if (!(rm = CreateRexxMsg( mrs->mrs_RexxPort, REXX_EXTENSION,
                             mrs->mrs_RexxPort->mp_Node.ln_Name ))) // == NULL)
      {
      CannotSetup( RexxCMsg( MSG_PUBLIC_REXXPORT_REXX ) );

      if (opened_mrs_RexxSysBase != FALSE)
         {
#        ifdef __amigaos4__
         DropInterface( (struct Interface *) IRexxSys );
#        endif	    

         CloseLibrary( (struct Library *) mrs->mrs_RexxSysBase );

         opened_mrs_RexxSysBase = FALSE;
         }

      DeletePort( mrs->mrs_RexxPort );

      if (name) // != NULL)
         AT_FreeVec( name, "arexxPortName", TRUE );

      if (mrs) // != NULL)
         AT_FreeVec( mrs, "MyRexxStruct", TRUE );
         
      return( rval ); // return( IoErr() );
      }
   else
      CopyMem( rm, &(mrs->mrs_RexxMsg), sizeof( struct RexxMsg ) );

   mrs->mrs_RexxMsg.rm_Action = RXCOMM | RXFF_STRING; // default Action code.
  
   rval = AssignObj( new_address( (ULONG) mrs ) );
    
   return( rval );
}

// -------------------------------------------------------------------

PUBLIC char *rxErrors[ 50 ] = { NULL, }; // Visible to CatalogRexx()

/****i* TranslateErrorNumber() [3.0] *********************************
*
* NAME
*    TranslateErrorNumber()
*
* DESCRIPTION
*    ^ <primitive 211 2 errNumber>
**********************************************************************
*
*/

METHODFUNC OBJECT *TranslateErrorNumber( int errnum )
{
   if (errnum <= 48 && errnum >= 0 )
      return( new_str( rxErrors[ errnum ] ) );
   else
      {
      sprintf( ErrMsg, RexxCMsg( MSG_RXERR_OUTOF_RANGE_REXX ), errnum );
      
      return( AssignObj( new_str( ErrMsg ) ) );
      }
}

/****i* createArgString() [3.0] **************************************
*
* NAME
*    createArgString()
*
* DESCRIPTION
*    ^ <primitive 211 3 aString length>
*
* NOTES 
*    Even though CreateArgstring() returns a UBYTE *, we have to 
*    treat it as an Object since there is information in front of
*    the returned pointer (negative offset of -8).
**********************************************************************
*
*/

METHODFUNC OBJECT *createArgString( char *str, int length )
{
   OBJECT *rval = o_nil;
   
   if ((length < 1) || !str || (str == (char *) o_nil))
      return( rval );
      
   rval = AssignObj( new_address( (ULONG) CreateArgstring( str, (ULONG) length )));
   
   return( rval );
}

/****i* deleteArgString() [3.0] **************************************
*
* NAME
*    deleteArgString()
*
* DESCRIPTION
*    <primitive 211 4 argString>
*
* NOTES 
*    Even though CreateArgstring() returns a UBYTE *, we have to 
*    treat it as an Object since there is information in front of
*    the returned pointer (negative offset of -8).
**********************************************************************
*
*/

METHODFUNC void deleteArgString( OBJECT *argObj )
{
   struct RexxArg *argString = (struct RexxArg *) CheckObject( argObj ); // UBYTE *
   
   if (NullChk( (OBJECT *) argString ) == TRUE)
      return;
      
   DeleteArgstring( argString );
   
   return;
}

/****i* lengthArgString() [3.0] **************************************
*
* NAME
*    lengthArgString()
*
* DESCRIPTION
*    ^ <primitive 211 5 argString>
*
* NOTES 
*    Even though CreateArgstring() returns a UBYTE *, we have to 
*    treat it as an Object since there is information in front of
*    the returned pointer (negative offset of -8).
**********************************************************************
*
*/

METHODFUNC OBJECT *lengthArgString( OBJECT *argObj )
{
   UBYTE *argString = (UBYTE *) CheckObject( argObj );
   
   if (NullChk( (OBJECT *) argString ) == TRUE)
      return( o_nil );
      
   return( AssignObj( new_int( (int) LengthArgstring( argString ))));
}

/****i* defaultExtension() [3.0] *************************************
*
* NAME
*    defaultExtension()
*
* DESCRIPTION
*    ^ <primitive 211 6>
**********************************************************************
*
*/

METHODFUNC OBJECT *defaultExtension( void )
{
   return( AssignObj( new_str( REXX_EXTENSION ) ) );
}

/****i* createRexxMsg() [3.0] ****************************************
*
* NAME
*    createRexxMsg()
*
* DESCRIPTION
*    ^ <primitive 211 7 msgPortObj extString portName>
**********************************************************************
*
*/

METHODFUNC OBJECT *createRexxMsg( OBJECT *mpObj, char *extension, char *portName )
{
   struct MsgPort *mport = (struct MsgPort *) CheckObject( mpObj );
   struct RexxMsg *rxmsg = NULL;
   OBJECT         *rval  = o_nil;

   if (!mport || (mport == (struct MsgPort *) o_nil))
      return( rval );
          
   if (!(rxmsg = CreateRexxMsg( mport, extension, portName ))) // == NULL)
      return( rval );

   rxmsg->rm_Node.mn_Node.ln_Name = portName;

   rxmsg->rm_Action = RXCOMM | RXFF_STRING; // default action code.
         
   rval = AssignObj( new_address( (ULONG) rxmsg ) );
   
   return( rval );      
}

/****i* deleteRexxMsg() [3.0] ****************************************
*
* NAME
*    deleteRexxMsg()
*
* DESCRIPTION
*    <primitive 211 8 rexxMsgObj>
**********************************************************************
*
*/

METHODFUNC void deleteRexxMsg( OBJECT *rxMsgObj )
{  
   struct RexxMsg *rxmsg = (struct RexxMsg *) CheckObject( rxMsgObj );
   
   if (NullChk( (OBJECT *) rxmsg ) == TRUE)
      return;
      
   DeleteRexxMsg( rxmsg );
   
   return;
}

/****i* clearRexxMsg() [3.0] *****************************************
*
* NAME
*    clearRexxMsg()
*
* DESCRIPTION
*    <primitive 211 9 rexxMsgObj count>
**********************************************************************
*
*/

METHODFUNC void clearRexxMsg( OBJECT *rxMsgObj, ULONG count )
{  
   struct RexxMsg *rxmsg = (struct RexxMsg *) CheckObject( rxMsgObj );

   if (NullChk( (OBJECT *) rxmsg ) == TRUE)
      return;
      
   ClearRexxMsg( rxmsg, count );
   
   return;
}

/****i* fillRexxMsg() [3.0] ******************************************
*
* NAME
*    fillRexxMsg()
*
* DESCRIPTION
*    ^ <primitive 211 10 rexxMsgObj count mask>
**********************************************************************
*
*/

METHODFUNC OBJECT *fillRexxMsg( OBJECT *rxMsgObj, ULONG count, ULONG mask )
{
   struct RexxMsg *rxmsg = (struct RexxMsg *) CheckObject( rxMsgObj );
   OBJECT         *rval  = o_false;
   
   if (NullChk( (OBJECT *) rxmsg ) == TRUE)
      return( rval );
      
   if (FillRexxMsg( rxmsg, count, mask ) != FALSE)
      return( o_true );
   else
      return( rval );
}

/****i* isRexxMsg() [3.0] ********************************************
*
* NAME
*    isRexxMsg()
*
* DESCRIPTION
*    ^ <primitive 211 11 chkThisObject>
**********************************************************************
*
*/

METHODFUNC OBJECT *isRexxMsg( OBJECT *rxObj )
{
   struct Message *rx   = (struct Message *) CheckObject( rxObj );
   OBJECT         *rval = o_false;
   
   if (NullChk( (OBJECT *) rx ) == TRUE)
      return( rval );
      
   if (IsRexxMsg( rx ) != FALSE)
      return( o_true );
   else
      return( rval );
}

/****i* sendRexxCmd() [3.0] ******************************************
*
* NAME
*    sendRexxCmd()
*
* DESCRIPTION
*    ^ <primitive 211 12 private aString>
**********************************************************************
*
*/

METHODFUNC OBJECT *sendRexxCmd( OBJECT *rxObj, char *aString )
{
   MRS *rx = (MRS *) CheckObject( rxObj );
   
   struct MsgPort *rexxport; // this will be rexx's port

   OBJECT *rval = o_nil;
   
   if (NullChk( (OBJECT *) rx ) == TRUE)
      return( rval );
      
   // lock things temporarily:
   Forbid();

      // if rexx is not active, just return nil
      if (!(rexxport = FindPort( RXSDIR ))) // == NULL)
         {
         Permit();

         return( rval );
         }

      // create an argument string and install it in the message:
      rx->mrs_RexxMsg.rm_Args[0] = (STRPTR) CreateArgstring( aString, strlen( aString ) );

      if (rx->mrs_RexxMsg.rm_Args[0]) // != NULL) // PASS MESSAGE!!
         PutMsg( rexxport, (struct Message *) &rx->mrs_RexxMsg );
      else
         {
         Permit(); // CreateArgstring() failed, return o_false.
         
         return( rval );
         }
         
   Permit();

//   DeleteArgstring( rx->mrs_RexxMsg.rm_Args[0] ); // Kills exec memory list

   return( o_true );
}

/****i* arrayToArgs() [3.0] ******************************************
*
* NAME
*    arrayToArgs()
*
* DESCRIPTION
*    store an array into the arexx Object
*    <primitive 211 13 private inputArray>
**********************************************************************
*
*/

METHODFUNC void arrayToArgs( OBJECT *rxObj, OBJECT *inArray )
{
   MRS *rx    = (MRS *) CheckObject( rxObj );
   int  count = objSize( inArray ), i;

   if (!rx || (rx == (MRS *) o_nil))
      return;
   
   if ((count < 1) || (count > (MAXRMARG + 1)))
      {
      UserInfo( RexxCMsg( MSG_REXX_TOO_MANY_ARGS_REXX ), UserProblem );

      return;
      }
               
   for (i = 0; i < count; i++)
      {
      switch (objType( inArray->inst_var[i] ))
         {
         case MMF_INTEGER:
         default:
            {
            char aa[80];
            
            itoa( int_value( inArray->inst_var[i] ), aa );
            // rx->mrs_RexxMsg.rm_Args[i] = CVi2arg( int_value( inArray->inst_var[i] ), 12 );
            rx->mrs_RexxMsg.rm_Args[i] = (STRPTR) CreateArgstring( aa, strlen( aa ) ); 
            }
            break;

         case MMF_STRING:
            {
            char *str = string_value( (STRING *) inArray->inst_var[i] );
            
            rx->mrs_RexxMsg.rm_Args[i] = (STRPTR) CreateArgstring( str, strlen( str ) );
            }
            break;
         }
      }

   return;
}

/****i* getRexxMsg() [3.0] *******************************************
*
* NAME
*    getRexxMsg()
*
* DESCRIPTION
*    ^ <primitive 211 14 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *getRexxMsg( OBJECT *rxObj )
{
   OBJECT *rval = o_nil;
   MRS    *rx   = (MRS *) CheckObject( rxObj );

   struct RexxMsg *rxmsg = NULL; // incoming rexx messages
   
   if (NullChk( (OBJECT *) rx ) == TRUE)
      return( rval );
      

   Wait( 1L << rx->mrs_RexxPort->mp_SigBit ); // now wait for msg from rexx.

   // did we get something from rexx?
   if ((rxmsg = (struct RexxMsg *) GetMsg( rx->mrs_RexxPort ))) // != NULL)
      {
      // is this a reply to a previous message?
      if (rxmsg->rm_Node.mn_Node.ln_Type == NT_REPLYMSG)
         {
#        ifdef DEBUG
         printf( RexxCMsg( MSG_FMT_TERM_CODE_REXX ),
                 rxmsg->rm_Args[0], rxmsg->rm_Result1, rxmsg->rm_Result2
               );
#        endif

         return( rxObj ); 
         }
      else
         {
         // a rexx macro has sent us a command, deal with it.
         CopyMem( rxmsg, &rx->mrs_RexxMsg, sizeof( struct RexxMsg ) );
         
         ReplyMsg( (struct Message *) rxmsg );
         }
      }

   return( rxObj );
}

/****i* setRMAction() [3.0] ******************************************
*
* NAME
*    setRMAction()
*
* DESCRIPTION
*    <primitive 211 15 private actionCode>
**********************************************************************
*
*/

METHODFUNC void setRMAction( OBJECT *rxObj, LONG actionCode )
{
   MRS *rx = (MRS *) CheckObject( rxObj );

   if (NullChk( (OBJECT *) rx ) == TRUE)
      return;
      
   rx->mrs_RexxMsg.rm_Action = actionCode;

   return;
}

/****i* getPrimaryResult() [3.0] *************************************
*
* NAME
*    getPrimaryResult()
*
* DESCRIPTION
*    ^ <primitive 211 16 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *getPrimaryResult( OBJECT *rxObj )
{
   MRS *rx = (MRS *) CheckObject( rxObj );

   if (NullChk( (OBJECT *) rx ) == TRUE)
      return( o_nil );
      
   return( AssignObj( new_int( (int) rx->mrs_RexxMsg.rm_Result1 )));
}
   
/****i* getSecondaryResult() [3.0] ***********************************
*
* NAME
*    getSecondaryResult()
*
* DESCRIPTION
*    ^ <primitive 211 17 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *getSecondaryResult( OBJECT *rxObj )
{
   MRS *rx = (MRS *) CheckObject( rxObj );

   if (NullChk( (OBJECT *) rx ) == TRUE)
      return( o_nil );
      
   return( AssignObj( new_int( (int) rx->mrs_RexxMsg.rm_Result2 )));
}

/****i* setArgument() [3.0] ******************************************
*
* NAME
*    setArgument()
*
* DESCRIPTION
*    setArgument: argNumber for: rexxMsgObj to: argValue
*      <primitive 211 18 rexxMsgObj argNumber argString>
**********************************************************************
*
*/

METHODFUNC void setArgument( OBJECT *rxMsgObj, int argNumber, char *argString )
{
   struct RexxMsg *rxMsg = (struct RexxMsg *) CheckObject( rxMsgObj );

   if (NullChk( (OBJECT *) rxMsg ) == TRUE)
      return;

   // This should never happen (see ARexx.st)
   if (argNumber < 0 || argNumber > 15)
      {
      UserInfo( RexxCMsg( MSG_PARM_OUTOF_RANGE_REXX ), ATalkProblem );
      
      return;
      }
            
   rxMsg->rm_Args[ argNumber ] = argString;
   
   return;
}  

/****i* getArgument() [3.0] ******************************************
*
* NAME
*    getArgument()
*
* DESCRIPTION
*    getArgument: [private] argNumber
*      ^ <primitive 211 19 private argNumber>
**********************************************************************
*
*/

METHODFUNC OBJECT *getArgument( OBJECT *rxObj, int argNumber )
{
   MRS *rx = (MRS *) CheckObject( rxObj );

   if (NullChk( (OBJECT *) rx ) == TRUE)
      return( o_nil );
      
   return( AssignObj( new_str( rx->mrs_RexxMsg.rm_Args[ argNumber ] )));
}

/****i* setFileExtension() [3.0] *************************************
*
* NAME
*    setFileExtension()
*
* DESCRIPTION
*    setFileExtension: [private] newExtString
*      <primitive 211 20 private newExtString>
**********************************************************************
*
*/

METHODFUNC void setFileExtension( OBJECT *rxObj, char *newExt )
{
   MRS *rx = (MRS *) CheckObject( rxObj );

   if (NullChk( (OBJECT *) rx ) == TRUE)
      return;
      
   rx->mrs_RexxMsg.rm_FileExt = newExt;
   
   return;
}

/****i* getFileExtension() [3.0] *************************************
*
* NAME
*    getFileExtension()
*
* DESCRIPTION
*    fileExtension [private]
*      ^ <primitive 211 21 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *getFileExtension( OBJECT *rxObj )
{
   MRS *rx = (MRS *) CheckObject( rxObj );

   if (NullChk( (OBJECT *) rx ) == TRUE)
      return( o_nil );
      
   return( AssignObj( new_str( rx->mrs_RexxMsg.rm_FileExt )));
}

/****i* portNameIs() [3.0] *******************************************
*
* NAME
*    portNameIs()
*
* DESCRIPTION
*    portNameIs [private]
*      ^ <primitive 211 22 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *portNameIs( OBJECT *rxObj )
{
   MRS *rx = (MRS *) CheckObject( rxObj );

   if (NullChk( (OBJECT *) rx ) == TRUE)
      return( o_nil );
      
   return( AssignObj( new_str( rx->mrs_RexxMsg.rm_CommAddr )));
}

/****i* findARexxPort() [3.0] ****************************************
*
* NAME
*    findARexxPort()
*
* DESCRIPTION
*    findARexxPort: portName
*      ^ <primitive 211 23 portName>
**********************************************************************
*
*/

METHODFUNC OBJECT *findARexxPort( char *portName )
{
   struct MsgPort *retPort = NULL;
   OBJECT         *rval    = o_nil;
   
   if (NullChk( (OBJECT *) portName ) == TRUE
       || strlen( portName ) < 1)
      {
      return( rval );
      }

   Forbid();

      retPort = FindPort( portName );

   Permit();

   if (retPort) // != NULL)
      rval = AssignObj( new_address( (ULONG) retPort ) ); // portName was found!

   return( rval );
}

/****i* sendOutMessage() [3.0] ***************************************
*
* NAME
*    sendOutMessage()
*
* DESCRIPTION
*    sendOutMessage: [private] aString to: rexxMsgObj
*      ^ <primitive 211 24 private rexxMsgObj aString>
**********************************************************************
*
*/

METHODFUNC OBJECT *sendOutMessage( OBJECT *myPortObj, 
                                   OBJECT *rxMsgObj, 
                                   char   *aString 
                                 )
{
   MRS            *myPort = (MRS *) CheckObject( myPortObj );
   struct RexxMsg *rxMsg  = (struct RexxMsg *) CheckObject( rxMsgObj );
   struct RexxMsg  tmpMsg = { 0, };
   struct MsgPort *sendTo = NULL;
   OBJECT         *rval   = o_false;
   
   if ((NullChk( (OBJECT *) rxMsg ) == TRUE)
      || (NullChk( (OBJECT *) myPort ) == TRUE))
      { 
      return( rval );
      }
   
   // create an argument string and install it in the message:
   rxMsg->rm_Args[0] = (STRPTR) CreateArgstring( aString, strlen( aString ) );

   // tmpMsg is for debugging purposes only.
   CopyMem( rxMsg, &tmpMsg, sizeof( struct RexxMsg ) );
         
   tmpMsg.rm_Node.mn_ReplyPort = myPort->mrs_RexxPort; // Is this correct??

   // lock things temporarily:
   Forbid();

      if (!(sendTo = FindPort( rxMsg->rm_Node.mn_Node.ln_Name ))) // == NULL)
         {
         Permit(); // Destination port not active, return o_false.

         return( rval );
         }

      // if rexx is not active, just return O-false
      if (!(sendTo = FindPort( RXSDIR ))) // == NULL)
         {
         Permit();

         return( rval );
         }

      if (rxMsg->rm_Args[0]) // != NULL) // PASS MESSAGE!!
         {
         PutMsg( sendTo, (struct Message *) &tmpMsg );
         }
      else // CreateArgstring() failed, just return o_false.
         {
         Permit();
         
         return( rval );
         }

   Permit();
   
//   (void) WaitPort( rxMsg->rm_Node.mn_ReplyPort ); // myPort->mrs_RexxPort );
//   (void) GetMsg(   rxMsg->rm_Node.mn_ReplyPort ); // Throw away reply.

//   DeleteArgstring( rxMsg->rm_Args[0] ); // Kills exec memory list

   return( o_true );
}

/****i* myRexxMsg() [3.0] ********************************************
*
* NAME
*    myRexxMsg()
*
* DESCRIPTION
*    rexxMsg
*      ^ <primitive 211 25 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *myRexxMsg( OBJECT *myPortObj )
{
   MRS            *myPort = (MRS *) CheckObject( myPortObj );
   struct RexxMsg *rval   = NULL;
   
   if (NullChk( (OBJECT *) myPort ) == TRUE)
      { 
      return( o_nil );
      }

   rval = &(myPort->mrs_RexxMsg);
   
   return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* checkRexxMsg() [3.0] *****************************************
*
* NAME
*    checkRexxMsg()
*
* DESCRIPTION
*    See if a RexxMsg is from ARexx
*
*    checkRexxMsg
*      ^ <primitive 211 26 private>
**********************************************************************
*
*/

#ifdef __SASC
METHODFUNC OBJECT *checkRexxMsg( OBJECT *myPortObj )
{
   IMPORT BOOL CheckRexxMsg( const struct RexxMsg *rexxmsg );
   
   MRS    *myPort = (MRS *) CheckObject( myPortObj );
   OBJECT *rval   = o_false;

   if (NullChk( (OBJECT *) myPort ) == TRUE)
      return( rval );
       
   if (CheckRexxMsg( &(myPort->mrs_RexxMsg) ) == TRUE)
      rval = o_true;
      
   return( rval );
}
#endif

/****i* getRexxVar() [3.0] *******************************************
*
* NAME
*    getRexxVar()
*
* DESCRIPTION
*    getRexxVar: [private] varName into: resultString
*      ^ <primitive 211 27 private varName resultString>
**********************************************************************
*
*/

#ifdef __SASC
METHODFUNC OBJECT *getRexxVar( OBJECT *myPortObj, char *varName, char *result )
{
   IMPORT LONG GetRexxVar( const struct RexxMsg *rexxmsg,
                           CONST_STRPTR          varName,
                           char                 *resultString );
   
   MRS    *myPort = (MRS *) CheckObject( myPortObj );
   LONG    rval   = 0L;

   if (NullChk( (OBJECT *) myPort ) == TRUE)
      return( o_nil );
       
   rval = GetRexxVar( &(myPort->mrs_RexxMsg), varName, result );
   
   return( AssignObj( new_address( (ULONG) rval ) ) );
}
#endif

/****i* setRexxVar() [3.0] *******************************************
*
* NAME
*    setRexxVar()
*
* DESCRIPTION
*    setRexxVar: [private] varName with: valueString
*      ^ <primitive 211 28 private varName valueString>
**********************************************************************
*
*/

#ifdef __SASC
METHODFUNC OBJECT *setRexxVar( OBJECT *myPortObj, char *varName, char *value )
{
   IMPORT LONG SetRexxVar( struct RexxMsg *rexxmsg, 
                           CONST_STRPTR    name, 
                           CONST_STRPTR    value, 
                                      LONG length 
                         );

   MRS  *myPort = (MRS *) CheckObject( myPortObj );
   LONG  rval   = 0L;
   
   if (NullChk( (OBJECT *) myPort ) == TRUE)
      return( o_nil );
       
   rval = SetRexxVar( &(myPort->mrs_RexxMsg), varName, value, strlen( value ) );
   
   return( AssignObj( new_int( (int) rval ) ) );
}
#endif

/****h* HandleARexx() [3.0] ******************************************
*
* NAME
*    HandleARexx()
*
* DESCRIPTION
*    Translate AmigaTalk primitives (211) to ARexx Port commands.
**********************************************************************
*
*/

PRIVATE BOOL openedRexxLibrary = FALSE;

PUBLIC OBJECT *HandleARexx( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 211 );

      return( rval );
      }

   if (!RexxSysBase) // == NULL)
      {
#     ifdef  __SASC
      if (!(RexxSysBase = (struct RxsLib *) OpenLibrary( RXSNAME, 0L ))) // == NULL)  
         {
         NotOpened( 4 ); // RXSNAME );

         return( rval );
         }
#     else
      if ((RexxSysBase = OpenLibrary( RXSNAME, 50L ))) // != NULL)  
         {
	 if (!(IRexxSys = (struct RexxSysIFace *) GetInterface( RexxSysBase, "main", 1, NULL )))
	    {
            CloseLibrary( RexxSysBase );
	    
            NotOpened( 4 ); // RXSNAME );

            return( rval );
	    }
	 }
      else
         {
         NotOpened( 4 ); // RXSNAME );

         return( rval );
	 }
#     endif

      openedRexxLibrary = TRUE;
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // close [private] <primitive 211 0 private>
         closeARexx( args[1] );

         break;
      
      case 1: // open: arexxPortName ^ <primitive 211 1>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            rval = openARexx( string_value( (STRING *) args[1] ) ); 
            
         break;

      case 2: // ^ <primitive 211 2 errNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            rval = TranslateErrorNumber( int_value( args[1] ) );
            
         break;  

      case 3: // createArgString: aString length: len
              // ^ private <- <primitive 211 3 aString length>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 211 );
         else
            rval = createArgString( string_value( (STRING *) args[1] ),
                                       int_value( args[2] ) 
                                  );
                                  
         break;

      case 4: // dispose [private]
              // <primitive 211 4 argObjString>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            {
            deleteArgString( args[1] );
            }
            
         break;

      case 5: // length [private]
              // ^ <primitive 211 5 argObjString>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            rval = lengthArgString( args[1] );
         
         break;

      case 6: // defaultExtension  ^ <primitive 211 6>
         rval = defaultExtension();
         break;

      case 7: // createRexxMsg: msgPortObj extension: extString port: portName
              // ^ <primitive 211 7 msgPortObj extString portName>
         if (!is_string( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 211 );
         else
            rval = createRexxMsg(                          args[1], 
                                  string_value( (STRING *) args[2] ),
                                  string_value( (STRING *) args[3] )
                                );
         break;

      case 8: // deleteRexxMsg: rexxMsgObj
              // <primitive 211 8 rexxMsgObj>
         deleteRexxMsg( args[1] );
         
         break;

      case 9: // clearRexxMsg: rexxMsgObj count: c
              // <primitive 211 9 rexxMsgObj count>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            clearRexxMsg( args[1], (ULONG) int_value( args[2] ));

      case 10: // fillRexxMsg: rexxMsgObj count: c mask: m
               // ^ <primitive 211 10 rexxMsgObj count mask>
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 211 );
         else
            rval = fillRexxMsg( args[1], (ULONG) int_value( args[2] ),
                                (ULONG) int_value( args[3] )
                              );
         break;
      
      case 11: // isRexxMsg: chkThisObject
               // ^ <primitive 211 11 chkThisObject>
         rval =  isRexxMsg( args[1] );

      case 12: // sendRexxCmd: [private] argString
               // ^ <primitive 211 12 private argString>
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            rval = sendRexxCmd( args[1], string_value( (STRING *) args[2] ));
         
         break;
 
      case 13: // arrayToArgs: [private] inputArray
               // <primitive 211 13 private inputArray>
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            arrayToArgs( args[1], args[2] );
            
         break;

      case 14: // getRexxMsg [private]
               // ^ <primitive 211 14 private>
         rval = getRexxMsg( args[1] );
         break;

      case 15: // setRMAction: [private] actionCode
               // <primitive 211 15 private actionCode>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            setRMAction( args[1], (LONG) int_value( args[2] ) );

         break;

      case 16: // getPrimaryResult [private]
               // ^ <primitive 211 16 private>
         rval = getPrimaryResult( args[1] );
         break;
      
      case 17: // getSecondaryResult [private]
               // ^ <primitive 211 17 private>
         rval = getSecondaryResult( args[1] );
         break;

      case 18: // setArgument: [private] argNumber to: argString
               // <primitive 211 18 private argNumber argString>
         if (!is_integer( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 211 );
         else
            setArgument( args[1], int_value( args[2] ),
                         string_value( (STRING *) args[3] )
                       );
         break;

      case 19: // getArgument: [private] argNumber
               // ^ <primitive 211 19 private argNumber>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            rval = getArgument( args[1], int_value( args[2] ) );
            
         break;

      case 20: // setFileExtension: newExtString
               // <primitive 211 20 private newExtString>
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            setFileExtension( args[1], string_value( (STRING *) args[2] ) );
            
         break;

      case 21: // fileExtension [private]
               // ^ <primitive 211 21 private>
         rval = getFileExtension( args[1] );
         break;
      
      case 22: // portNameIs [private]
               // ^ <primitive 211 22 private>
         rval = portNameIs( args[1] );
         break;

      case 23: // findARexxPort: portName
               // ^ <primitive 211 23 portName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            rval = findARexxPort( string_value( (STRING *) args[1] ) );

         break;

      case 24: // sendOutMessage: [private] aString to: rexxMsgObj
               // ^ <primitive 211 24 private rexxMsgObj aString>
         if (is_string( args[3] ) == FALSE)
            (void) PrintArgTypeError( 211 );
         else
            rval = sendOutMessage( args[1], args[2],
                                   string_value( (STRING *) args[3] ) 
                                 );
            
         break;

      case 25: // rexxMsg  ^ <primitive 211 25 private>

         rval = myRexxMsg( args[1] );
         break;

#     ifdef    __SASC
      case 26: // checkRexxMsg ^ <primitive 211 26 private>

         rval = checkRexxMsg( args[1] );
         break;

      case 27: // getRexxVar: [private] varName into: resultString
               // ^ <primitive 211 27 private varName resultString>
         if (!is_string( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 211 );
         else
            rval = getRexxVar( args[1],
                               string_value( (STRING *) args[2] ),
                               string_value( (STRING *) args[3] )
                             );
         break;

      case 28: // setRexxVar: [private] varName with: valueString
               // ^ <primitive 211 28 private varName valueString>
         if (!is_string( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 211 );
         else
            rval = setRexxVar( args[1],
                               string_value( (STRING *) args[2] ),
                               string_value( (STRING *) args[3] )
                             );
         break;
#     endif
  
      default:
         (void) PrintArgTypeError( 211 );
         break;
      }

   if (openedRexxLibrary == TRUE)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IRexxSys );
      IRexxSys = NULL;
#     endif

      CloseLibrary( (struct Library *) RexxSysBase );

      openedRexxLibrary = FALSE;
      RexxSysBase       = NULL;
      }

   return( rval );
}

/* ---------------------- END of Rexx.c file! ----------------- */
