/****h* AmigaTalk/IFF.c [3.0] *****************************************
*
* NAME
*    IFF.c
*
* DESCRIPTION
*    Functions that handle IFF primitives.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
*    24-Jan-2002 - Ready for 1st compilation.
*
* NOTES
*    $VER: AmigaTalk:Src/IFF.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>

#include <libraries/iffparse.h>

#ifdef __SASC

# include <clib/iffparse_protos.h>
# include <clib/exec_protos.h>

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/iffparse.h>

PRIVATE struct IFFParseIFace *IIFFParse;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Object.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "FuncProtos.h"

// -----------------------------------------------------------------

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT UBYTE  *UserPgmError;
IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *UserProblem;
IMPORT UBYTE  *SystemProblem;

IMPORT UBYTE  *ErrMsg;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// -----------------------------------------------------------------

#define  FASTMEM  MEMF_FAST | MEMF_CLEAR | MEMF_PUBLIC

/*
struct IFFHandle {

    ULONG iff_Stream;
    ULONG iff_Flags;
    LONG  iff_Depth;	//  Depth of context stack
};

struct IFFStreamCmd {

    LONG sc_Command;	// Operation to be performed (IFFCMD_)
    APTR sc_Buf;	// Pointer to data buffer
    LONG sc_NBytes;	// Number of bytes to be affected
};

struct ContextNode {

    struct MinNode cn_Node;
    LONG	   cn_ID;
    LONG	   cn_Type;
    LONG	   cn_Size;	//  Size of this chunk
    LONG	   cn_Scan;	//  # of bytes read/written so far
};
*/

/* Some of eIFF might be deleted after all AmigaTalk primitives have
** been debugged:
*/

struct eIFF {
   
   /* Structure associated with an active IFF stream.
   ** "iff_Stream" is a value used by the client's read/write/seek functions -
   ** it will not be accessed by the library itself and can have any value
   ** (could even be a pointer or a BPTR).
   **
   ** This structure can only be allocated by iffparse.library
   */
   struct IFFHandle        *IFFHandlePtr;

   /* When the library calls your stream handler, you'll be passed a pointer
   ** to this structure as the "message packet".
   */
   struct IFFStreamCmd     *IFFStreamCmdPtr;

   /* A node associated with a context on the iff_Stack. Each node
   ** represents a chunk, the stack representing the current nesting
   ** of chunks in the open IFF file. Each context node has associated
   ** local context items in the (private) LocalItems list.  The ID, type,
   ** size and scan values describe the chunk associated with this node.
   **
   ** This structure can only be allocated by iffparse.library
   */
   struct ContextNode      *ContextNodePtr;

   /* Collection Item: the actual node in the collection list at which
   ** client will look. The next pointer crosses context boundaries so
   ** that the complete list is accessable.
   */
   struct CollectionItem   *CollectionItemPtr;

   /* Local context items live in the ContextNode's.  Each class is identified
   ** by its lci_Ident code and has a (private) purge vector for when the
   ** parent context node is popped.
   **
   ** This structure can only be allocated by iffparse.library
   */
   struct LocalContextItem *LocalContextItemPtr;

   /* StoredProperty: a local context item containing the data stored
   ** from a previously encountered property chunk.
   */
   struct StoredProperty   *StoredPropertyPtr;

   /* Structure returned by OpenClipboard(). You may do CMD_POSTs and such
   ** using this structure. However, once you call OpenIFF(), you may not
   ** do any more of your own I/O to the clipboard until you call CloseIFF().
   */
   struct ClipboardHandle  *ClipboardHandlePtr;

   int                      Status;
   int                      StreamType; // 0 = DOS, 1 = Clipboard, 2 = Other
};

/* eIFF->Status values: (IFFF_READ = 0, IFFF_WRITE = 1 also!) */

#define  IFF_OPEN      8
#define  IFF_FILE_OPEN 16
#define  IFF_ALLOCATED 32
#define  IFF_LIB_OPEN  64

PRIVATE struct Library *IFFParseBase = NULL;

// -------------------------------------------------------------------------

/****i* OpenIFFLibrary() [1.9] *****************************
*
* NAME
*    OpenIFFLibrary()
*
* DESCRIPTION
*    Open the iffparse.library
************************************************************
*
*/

SUBFUNC BOOL OpenIFFLibrary( LONG version )
{
   if (IFFParseBase) // != NULL) // Only open the library once!
      return( TRUE ); 

#  ifdef __SASC
   if (!(IFFParseBase = OpenLibrary( "iffparse.library", version )))
      return( FALSE );
   else
      return( TRUE );
#  else
   if ((IFFParseBase = OpenLibrary( "iffparse.library", version )))
      {
      if (!(IIFFParse = (struct IFFParseIFace *) GetInterface( IFFParseBase, "main", 1, NULL )))
         {
	 CloseLibrary( IFFParseBase );
	 return( FALSE );
	 }
      else
         return( TRUE );
      }
   else
      return( FALSE );
#  endif
}

/****i* CloseIFFLibrary() [1.9] ****************************
*
* NAME
*    CloseIFFLibrary()
*
* DESCRIPTION
*    Close the iffparse.library
************************************************************
*
*/

SUBFUNC void CloseIFFLibrary( int statusflag )
{
   if ((statusflag & IFF_LIB_OPEN) == IFF_LIB_OPEN)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
      IIFFParse = NULL;
#     endif

      CloseLibrary( IFFParseBase );

      IFFParseBase = NULL;
      }

   return;
}

/****i* AllocateIFF() [1.9] ********************************
*
* NAME
*    AllocateIFF()
*
* DESCRIPTION
*    Allocate a new IFF handle if argument is NULL.
************************************************************
*
*/

SUBFUNC BOOL AllocateIFF( struct IFFHandle *ip )
{
   if (ip) // != NULL)
      return( TRUE );
      
   if ((ip = (struct IFFHandle *) AllocIFF())) // != NULL)
      return( TRUE );
   else
      return( FALSE );
}

/****i* FreeIFFAllocation() [1.9] **************************
*
* NAME
*    FreeIFFAllocation()
*
* DESCRIPTION
*    Free the IFF handle.
************************************************************
*
*/

SUBFUNC void FreeIFFAllocation( struct IFFHandle *ip )
{
   if (ip) // != NULL)
      {
      FreeIFF( ip );

      ip = NULL;
      }

   return;
}

/****i* OpenIFF_File() [1.9] *******************************
*
* NAME
*    OpenIFF_File()
*
* DESCRIPTION
*    Open the given IFF file.
************************************************************
*
*/

SUBFUNC BOOL OpenIFF_File( struct eIFF *ip, int type, char *name )
{
   int status = 0;
   
   if (!ip) // == NULL)
      return( FALSE );
      
   status = ip->Status;
   
   if ((status & IFF_FILE_OPEN) != IFF_FILE_OPEN)
      {   
      switch (type)
         {   
         case 0:
            ip->IFFHandlePtr->iff_Stream = (ULONG) Open( name, MODE_OLDFILE );

            if (ip->IFFHandlePtr->iff_Stream) // != NULL)
               InitIFFasDOS( ip->IFFHandlePtr );
            else
               return( FALSE );
               
            ip->StreamType = type;
            ip->Status    |= IFF_FILE_OPEN;

            return( TRUE);

         case 1: // Clipboard type:
            ip->ClipboardHandlePtr = (struct ClipboardHandle *) 
                                       OpenClipboard( PRIMARY_CLIP );

            if (ip->ClipboardHandlePtr) // != NULL)
               ip->IFFHandlePtr->iff_Stream = (ULONG) ip->ClipboardHandlePtr;
            else
               {
               CloseClipboard( ip->ClipboardHandlePtr );
               return( FALSE );
               }
               
            if (ip->IFFHandlePtr) // != NULL)
               InitIFFasClip( ip->IFFHandlePtr );
            else
               return( FALSE );
               
            ip->StreamType = type;
            ip->Status    |= IFF_FILE_OPEN;

            return( TRUE );

         default:
            break;
         }
      }
  
   return( FALSE );   
}

/****i* CloseIFF_File() [1.9] ******************************
*
* NAME
*    CloseIFF_File()
*
* DESCRIPTION
*    Close the given file handle.
************************************************************
*
*/

SUBFUNC void CloseIFF_File( struct eIFF *ip, int type )
{
   if (ip->Status & IFF_FILE_OPEN != IFF_FILE_OPEN)
      return;
      
   switch (type)
      {   
      case 0:
         if (ip->IFFHandlePtr->iff_Stream) // != NULL)
            {
            Close( ip->IFFHandlePtr->iff_Stream );

            ip->Status &= ~IFF_FILE_OPEN;
            }

         break;

      case 1:
         if (ip->ClipboardHandlePtr) // != NULL)
            {
            CloseClipboard( ip->ClipboardHandlePtr );

            ip->Status &= ~IFF_FILE_OPEN;
            }

         break;

      default:
         break;
      }   

   return;
      
}     

/* IFF return codes. Most functions return either zero for success or
** one of these codes.  The exceptions are the read/write functions which
** return positive values for number of bytes or records read or written,
** or a negative error code.  Some of these codes are not errors per se,
** but valid conditions such as EOF or EOC (End of Chunk).
*/

PUBLIC char *iffErrStrs[15] = { NULL, }; // Visible to CatalogIFF() in CatFuncs2.c;

/****i* translateErrNum() [1.9] ****************************
*
* NAME
*    translateErrNum()
*
* DESCRIPTION
*    Translate an IFF error number into a string.
************************************************************
*
*/

SUBFUNC char *translateErrNum( int errnum )
{
   char *rval = NULL;
   
   if (errnum < IFF_RETURN2CLIENT)
      rval = iffErrStrs[ 13 ];
   else
      rval = iffErrStrs[ errnum - IFF_RETURN2CLIENT ];
      
   return( rval );
}

// ==== <primitive 240 0> functions: ===================================

/****i* Close_IFF() [1.9] **********************************
*
* NAME
*    Close_IFF()
*
* DESCRIPTION
*    <primitive 240 0 0 iffObj>
************************************************************
*
*/

METHODFUNC void Close_IFF( OBJECT *IFFObj )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );
      
   if (!ip) // == NULL)
      return;

   if (ip->Status & IFF_OPEN == IFF_OPEN)
      {
      CloseIFF( ip->IFFHandlePtr );

      ip->Status &= ~IFF_OPEN;
      }

   CloseIFF_File( ip, ip->StreamType );

   FreeIFFAllocation( ip->IFFHandlePtr );
             
   CloseIFFLibrary( ip->Status );

   AT_FreeVec( ip, "eIFFStruct", TRUE );

   return;
}

/****i* Open_IFF() [1.9] ***********************************
*
* NAME
*    Open_IFF()
*
* DESCRIPTION
*    Allocate & Otherwise open an IFF stream for AmigaTalk.
*    Return an Object that contains a pointer to an eIFF
*    structure.
*
*    ^ <primitive 240 0 1 iffFileName type mode>
************************************************************
*
*/

METHODFUNC OBJECT *Open_IFF( char *iffName, int Type, int Mode )
{
   struct eIFF *newIFF = (struct eIFF *) NULL;
   OBJECT      *rval   = o_nil;

   if (!(newIFF = (struct eIFF *) AT_AllocVec( sizeof( struct eIFF ), 
                                               FASTMEM, "eIIFStruct", TRUE ))) // == NULL)
      {
      MemoryOut( IFFCMsg( MSG_OPEN_IFF_FUNC_IFF ) );
      
      return( rval );
      }

#  ifdef __SASC
   if (OpenIFFLibrary( 37L ) == TRUE)
#  else
   if (OpenIFFLibrary( 50L ) == TRUE)
#  endif
      newIFF->Status |= IFF_LIB_OPEN;
   else
      {
      NotOpened( 4 ); // IFF_PARSE_LIB );

      AT_FreeVec( newIFF, "eIFFStruct", TRUE );

      return( rval );
      }

   if (AllocateIFF( newIFF->IFFHandlePtr ) == FALSE)
      {
      MemoryOut( IFFCMsg( MSG_IFFHANDLE_FUNC_IFF ) );

      CloseIFFLibrary( newIFF->Status );

      AT_FreeVec( newIFF, "eIFFStruct", TRUE );
      
      return( rval );
      }
   else
      newIFF->Status |= IFF_ALLOCATED;

   if (OpenIFF_File( newIFF, Type, iffName ) == FALSE)
      {
      NotOpened( 3 ); // IFF_IFFHANDLE_FUNC );

      newIFF->Status &= ~IFF_ALLOCATED;
      
      FreeIFFAllocation( newIFF->IFFHandlePtr );
            
      CloseIFFLibrary( newIFF->Status );

      AT_FreeVec( newIFF, "eIFFStruct", TRUE );
      
      return( rval );
      }
   else
      newIFF->Status |= IFF_FILE_OPEN;
                           
   /* if the Mode is the only thing changed, the user has to call
   ** Close_IFF() before using a different Mode.
   */
   if (Mode & IFFF_READ == IFFF_READ)
      Mode = IFFF_READ;
   else
      Mode = IFFF_WRITE;

   if ((newIFF->Status & IFF_OPEN) != IFF_OPEN)
      {
      // NOT the same as opening the file:
      int chk = (int) OpenIFF( newIFF->IFFHandlePtr, Mode );

      if (chk == 0)
         {
         newIFF->Status |= IFF_OPEN;
         
         rval = AssignObj( new_address( (ULONG) newIFF ) ); // Weesa okey-dokey!
         }
      else
         {
         sprintf( ErrMsg, IFFCMsg( MSG_FMT_IFFERR_IFF ), translateErrNum( chk ) );

         UserInfo( ErrMsg, SystemProblem );

         CloseIFF_File( newIFF, Type );
         
         FreeIFFAllocation( newIFF->IFFHandlePtr );
             
         CloseIFFLibrary( newIFF->Status );

         AT_FreeVec( newIFF, "eIFFStruct", TRUE );
         }
      }

   return( rval );
}

/****i* HandleSetup() [1.9] ****************************************
*
* NAME
*    HandleSetup()
*
* DESCRIPTION
*    ^ <primitive 240 0>
********************************************************************
*
*/

METHODFUNC OBJECT *HandleSetup( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 240 );

      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0:// ^ openIFF: iffFileName type: type mode: mode
         if (!is_string( args[1] ) || !is_integer( args[2] )
                                   || !is_integer( args[3] ))  
            (void) PrintArgTypeError( 240 );
         else
            rval = Open_IFF( string_value( (STRING *) args[1] ),
                                int_value( args[2] ),
                                int_value( args[3] )
                           );
         break;

      case 1: // closeIFF [private]
         Close_IFF( args[1] );
         
         break;

      default:
         break;
      }

   return( rval );
}

// ==== <primitive 240 1> functions: ===================================

/****h* Init_IFF() [1.9] ***********************************
*
* NAME
*    Init_IFF()
*
* DESCRIPTION
*    <primitive 240 1 0 IFFObj hookObj flags>
************************************************************
*
*/

METHODFUNC void Init_IFF( OBJECT *IFFObj, OBJECT *hookObj, int flags )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   struct Hook *hook = (struct Hook *) CheckObject( hookObj );
   
   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_INITIFF_FUNC_IFF ) );

      return;
      }
      
   if (!hook) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_INITIFF_FUNC_IFF ) );

      return;
      }

   InitIFF( ip->IFFHandlePtr, flags, hook );

   return;
}

/****h* Init_IFFAsDOS() [1.9] ******************************
*
* NAME
*    Init_IFFAsDOS()
*
* DESCRIPTION
*    <primitive 240 1 1 IFFObj>
************************************************************
*
*/

METHODFUNC void Init_IFFAsDOS( OBJECT *IFFObj )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );

   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_INITDOS_FUNC_IFF ) );

      return;
      }
      
   InitIFFasDOS( ip->IFFHandlePtr );

   return;
}

/****h* Init_IFFAsClip() [1.9] *****************************
*
* NAME
*    Init_IFFAsClip()
*
* DESCRIPTION
*    <primitive 240 1 2 IFFObj>
************************************************************
*
*/

METHODFUNC void Init_IFFAsClip( OBJECT *IFFObj )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );

   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_INITCLIP_FUNC_IFF ) );

      return;
      }
      
   InitIFFasClip( ip->IFFHandlePtr );
   
   return;
}

/****h* HandleInits() [1.9] ********************************
*
* NAME
*    HandleInits()
*
* DESCRIPTION
*    ^ <primitive 240 1>
************************************************************
*
*/

METHODFUNC OBJECT *HandleInits( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 240 );

      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // initIFFHook: [private] hookObj flags: flags
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 240 );
         else
            Init_IFF( args[1], args[2], int_value( args[3] ) );
   
         break;
         
      case 1: // initIFFAsDOS [private]
         Init_IFFAsDOS( args[1] );
         break;
         
      case 2: // initIFFAsClip [private]
         Init_IFFAsClip( args[1] );
         break;

      default:
         break;
      }

   return( rval );
}

// ==== <primitive 240 2> functions: ===================================

/****i* Close_Clipboard() [1.9] ****************************
*
* NAME
*    Close_Clipboard()
*
* DESCRIPTION
*    <primitive 240 2 0 IFFObj>
************************************************************
*
*/

METHODFUNC void Close_Clipboard( OBJECT *IFFObj )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );
      
   if (ip) // != NULL)
      CloseClipboard( ip->ClipboardHandlePtr );
   else
      FoundNullPtr( IFFCMsg( MSG_CLOSECLIP_FUNC_IFF ) );
      
   return;
}

/****i* Open_Clipboard() [1.9] *****************************
*
* NAME
*    Open_Clipboard()
*
* DESCRIPTION
*    ^ <primitive 240 2 1 IFFObj unit>
************************************************************
*
*/

METHODFUNC OBJECT *Open_Clipboard( OBJECT *IFFObj, int unit )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
      
   if (ip) // != NULL)
      {
      ip->ClipboardHandlePtr = (struct ClipboardHandle *) OpenClipboard( unit );

      rval = AssignObj( new_address( (ULONG) ip->ClipboardHandlePtr ));
      }
   else
      FoundNullPtr( IFFCMsg( MSG_OPENCLIP_FUNC_IFF ) );

   return( rval );
}

/****i* Parse_IFF() [1.9] **********************************
*
* NAME
*    Parse_IFF()
*
* DESCRIPTION
*    ^ <primitive 240 2 2 IFFObj mode>
************************************************************
*
*/

METHODFUNC OBJECT *Parse_IFF( OBJECT *IFFObj, int mode )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
      
   if (ip) // != NULL)
      rval = AssignObj( new_address( (ULONG) ParseIFF( ip->IFFHandlePtr, mode )));
   else
      FoundNullPtr( IFFCMsg( MSG_PARSE_FUNC_IFF ) );

   return( rval );
}

/****i* Read_Chunk_Bytes() [1.9] ***************************
*
* NAME
*    Read_Chunk_Bytes()
*
* DESCRIPTION
*    ^ <primitive 240 2 3 IFFObj bytes numBytes>
************************************************************
*
*/

METHODFUNC OBJECT *Read_Chunk_Bytes( OBJECT *IFFObj, BYTEARRAY *bObj, int numBytes )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
   char        *buff = NULL;
   LONG         len  = 0;

   if (NullChk( (OBJECT *) bObj ) == TRUE)
      {
      FoundNullPtr( IFFCMsg( MSG_READCHK_FUNC_IFF ) );
      
      return( rval );
      }

   if (bObj->bsize < numBytes) // Is there enough room?
      {
      sprintf( ErrMsg, IFFCMsg( MSG_FMT_BARY_SMALL_IFF ), bObj->bsize, numBytes );

      UserInfo( ErrMsg, UserPgmError );
      
      return( rval );
      }

   buff = BYTE_VALUE( bObj );
   
   if (!buff || (buff == (char *) o_nil))
      {
      FoundNullPtr( IFFCMsg( MSG_READCHK_FUNC_IFF ) );
      
      return( rval );
      }
          
   if (ip) // != NULL)
      {
      len  = ReadChunkBytes( ip->IFFHandlePtr, (APTR) buff, numBytes );

      rval = AssignObj( new_int( (int) len ));
      }
   else
      FoundNullPtr( IFFCMsg( MSG_READCHK_FUNC_IFF ) );

   return( rval );
}

/****i* Read_Chunk_Records() [1.9] *************************
*
* NAME
*    Read_Chunk_Records()
*
* DESCRIPTION
*    ^ <primitive 240 2 4 IFFObj bytes numBytes numRecs>
************************************************************
*
*/

METHODFUNC OBJECT *Read_Chunk_Records( OBJECT    *IFFObj, 
                                       BYTEARRAY *bObj, 
                                       int        numBytes, 
                                       int        numRecs
                                     )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
   char        *buff = NULL;
   LONG         len  = 0;

   if (NullChk( (OBJECT *) bObj ) == TRUE)
      {
      FoundNullPtr( IFFCMsg( MSG_READCHKR_FUNC_IFF ) );
      
      return( rval );
      }
           
   if (bObj->bsize < numBytes) // Is there enough room?
      {
      sprintf( ErrMsg, IFFCMsg( MSG_FMT_BARY_SMALL_IFF ), bObj->bsize, numBytes );

      UserInfo( ErrMsg, UserPgmError );
      
      return( rval );
      }

   buff = BYTE_VALUE( bObj );
   
   if (!buff || (buff == (char *) o_nil))
      {
      FoundNullPtr( IFFCMsg( MSG_READCHKR_FUNC_IFF ) );
      
      return( rval );
      }
     
   if (ip) // != NULL)
      {
      len = ReadChunkRecords( ip->IFFHandlePtr, (APTR) buff, numBytes, numRecs );

      rval = AssignObj( new_int( (int) len ) );
      }
   else
      FoundNullPtr( IFFCMsg( MSG_READCHKR_FUNC_IFF ) );

   return( new_int( (int) len ) );
}

/****i* Write_Chunk_Bytes() [1.9] **************************
*
* NAME
*    Write_Chunk_Bytes()
*
* DESCRIPTION
*    ^ <primitive 240 2 5 IFFObj bytes numBytes>
************************************************************
*
*/

METHODFUNC OBJECT *Write_Chunk_Bytes( OBJECT *IFFObj, BYTEARRAY *bObj, int numBytes )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
   char        *buff = NULL;
   LONG         err  = 0;

   if (NullChk( (OBJECT *) bObj ) == TRUE)
      {
      FoundNullPtr( IFFCMsg( MSG_WRTCHK_FUNC_IFF ) );
      
      return( rval );
      }
           
   if (numBytes > bObj->bsize) // Is there enough room?
      {
      numBytes = bObj->bsize;

      UserInfo( IFFCMsg( MSG_TRUNCATED_IFF ), UserPgmError );
      }

   buff = BYTE_VALUE( bObj );
   
   if (!buff || (buff == (char *) o_nil))
      {
      FoundNullPtr( IFFCMsg( MSG_WRTCHK_FUNC_IFF ) );
      
      return( rval );
      }
     
   if (ip) // != NULL)
      {
      err  = WriteChunkBytes( ip->IFFHandlePtr, (APTR) buff, numBytes );

      rval = AssignObj( new_int( (int) err ) );
      } 
   else
      FoundNullPtr( IFFCMsg( MSG_WRTCHK_FUNC_IFF ) );

   return( rval );
}

/****i* Write_Chunk_Records() [1.9] ************************
*
* NAME
*    Write_Chunk_Records()
*
* DESCRIPTION
*    ^ <primitive 240 2 6 IFFObj bytes numBytes numRecs>
************************************************************
*
*/

METHODFUNC OBJECT *Write_Chunk_Records( OBJECT    *IFFObj, 
                                        BYTEARRAY *bObj,
                                        int        numBytes, 
                                        int        numRecs 
                                      )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
   char        *buff = NULL;
   LONG         err  = 0;

   if (NullChk( (OBJECT *) bObj ) == TRUE)
      {
      FoundNullPtr( IFFCMsg( MSG_WRTCHKR_FUNC_IFF ) );
      
      return( rval );
      }
           
   if (numBytes > bObj->bsize) // Is there enough room?
      {
      numBytes = bObj->bsize;
      UserInfo( IFFCMsg( MSG_TRUNCATED_IFF ), UserPgmError );
      }

   buff = BYTE_VALUE( bObj );
   
   if (!buff || (buff == (char *) o_nil))
      {
      FoundNullPtr( IFFCMsg( MSG_WRTCHKR_FUNC_IFF ) );
      
      return( rval );
      }
     
   if (ip) // != NULL)
      {
      err  = WriteChunkRecords( ip->IFFHandlePtr, (APTR) buff, numBytes, numRecs );

      rval = AssignObj( new_int( (int) err ) );
      }
   else
      FoundNullPtr( IFFCMsg( MSG_WRTCHKR_FUNC_IFF ) );

   return( rval );
}

/****i* CheckType_ID() [1.9] *******************************
*
* NAME
*    CheckType_ID()
*
* DESCRIPTION
*    Verify that the IFF type & id are valid.
************************************************************
*
*/

SUBFUNC BOOL CheckType_ID( int type, int id )
{
   BOOL rval = FALSE;
   
   if (GoodType( type ) == FALSE)
      {
      sprintf( ErrMsg, IFFCMsg( MSG_FMT_INVALIDTYPE_IFF ), type );

      UserInfo( ErrMsg, UserPgmError );
      
      return( rval );
      }
   
   if (GoodID( id ) == FALSE)
      {
      sprintf( ErrMsg, IFFCMsg( MSG_FMT_INVALID_ID_IFF ), id );

      UserInfo( ErrMsg, UserPgmError );
      
      return( rval );
      }
   else
      return( TRUE );   
}

/****i* Stop_Chunk() [1.9] *********************************
*
* NAME
*    Stop_Chunk()
*
* DESCRIPTION
*    ^ <primitive 240 2 7 IFFObj type id>
************************************************************
*
*/

METHODFUNC OBJECT *Stop_Chunk( OBJECT *IFFObj, int type, int id )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;

   if (CheckType_ID( type, id ) != TRUE)
      return( rval );
                 
   if (ip) // != NULL)
      rval = AssignObj( new_address( (ULONG) StopChunk( ip->IFFHandlePtr, type, id )));
   else
      FoundNullPtr( IFFCMsg( MSG_STOPCHK_FUNC_IFF ) );

   return( rval );
}

/****i* Current_Chunk() [1.9] ******************************
*
* NAME
*    Current_Chunk()
*
* DESCRIPTION
*    ^ <primitive 240 2 8 IFFObj>
************************************************************
*
*/

METHODFUNC OBJECT *Current_Chunk( OBJECT *IFFObj )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
     
   if (ip) // != NULL)
      {
      ip->ContextNodePtr = (struct ContextNode *) CurrentChunk( ip->IFFHandlePtr );

      rval = AssignObj( new_address( (ULONG) ip->ContextNodePtr ));
      }
   else
      FoundNullPtr( IFFCMsg( MSG_CRNTCHK_FUNC_IFF ) );
       
   return( rval );
}

/****i* Prop_Chunk() [1.9] *********************************
*
* NAME
*    Prop_Chunk()
*
* DESCRIPTION
*    ^ <primitive 240 2 9 IFFObj type id>
************************************************************
*
*/

METHODFUNC OBJECT *Prop_Chunk( OBJECT *IFFObj, int type, int id )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;

   if (CheckType_ID( type, id ) != TRUE)
      return( rval );
     
   if (ip) // != NULL)
      rval = AssignObj( new_address( (ULONG) PropChunk( ip->IFFHandlePtr, type, id )));
   else
      FoundNullPtr( IFFCMsg( MSG_PROPCHK_FUNC_IFF ) );

   return( rval );
}

/****i* Find_Prop() [1.9] **********************************
*
* NAME
*    Find_Prop()
*
* DESCRIPTION
*    ^ <primitive 240 2 10 IFFObj type id>
************************************************************
*
*/

METHODFUNC OBJECT *Find_Prop( OBJECT *IFFObj, int type, int id )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );

   if (CheckType_ID( type, id ) != TRUE)
      return( o_nil );
                 
   if (ip) // != NULL)
      ip->StoredPropertyPtr = (struct StoredProperty *) FindProp( ip->IFFHandlePtr, type, id );
   else
      FoundNullPtr( IFFCMsg( MSG_FINDPROP_FUNC_IFF ) );

   return( AssignObj( new_address( (ULONG) ip->StoredPropertyPtr )));
}

/****i* Collection_Chunk() [1.9] ***************************
*
* NAME
*    Collection_Chunk()
*
* DESCRIPTION
*    ^ <primitive 240 2 11 IFFObj type id>
************************************************************
*
*/

METHODFUNC OBJECT *Collection_Chunk( OBJECT *IFFObj, int type, int id )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;

   if (CheckType_ID( type, id ) != TRUE)
      return( rval );
                 
   if (ip) // != NULL)
      rval = AssignObj( new_address( (ULONG) CollectionChunk( ip->IFFHandlePtr, type, id )));
   else
      FoundNullPtr( IFFCMsg( MSG_COLLCHK_FUNC_IFF ) );

   return( rval );
}

/****i* Find_Collection() [1.9] ****************************
*
* NAME
*    Find_Collection()
*
* DESCRIPTION
*    ^ <primitive 240 2 12 IFFObj type id>
************************************************************
*
*/

METHODFUNC OBJECT *Find_Collection( OBJECT *IFFObj, int type, int id )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );

   if (CheckType_ID( type, id ) != TRUE)
      return( o_nil );
                 
   if (ip) // != NULL)
      ip->CollectionItemPtr = (struct CollectionItem *) FindCollection( ip->IFFHandlePtr, type, id );
   else
      FoundNullPtr( IFFCMsg( MSG_FINDCOLL_FUNC_IFF ) );

   return( AssignObj( new_address( (ULONG) ip->CollectionItemPtr )));
}

/****i* Stop_OnExit() [1.9] ********************************
*
* NAME
*    Stop_OnExit()
*
* DESCRIPTION
*    ^ <primitive 240 2 13 IFFObj type id>
************************************************************
*
*/

METHODFUNC OBJECT *Stop_OnExit( OBJECT *IFFObj, int type, int id )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
     
   if (CheckType_ID( type, id ) != TRUE)
      return( rval );
                 
   if (ip) // != NULL)
      rval = AssignObj( new_address( (ULONG) StopOnExit( ip->IFFHandlePtr, type, id )));
   else
      FoundNullPtr( IFFCMsg( MSG_STOPEXIT_FUNC_IFF ) );

   return( rval );
}

/****i* Entry_Handler() [1.9] ******************************
*
* NAME
*    Entry_Handler()
*
* DESCRIPTION
*    ^ <primitive 240 2 14 IFFObj hookObj anObject type id pos>
************************************************************
*
*/

METHODFUNC OBJECT *Entry_Handler( OBJECT *IFFObj, 
                                  OBJECT *hookObj,
                                  OBJECT *anObject,
                                  int     type, 
                                  int     id, 
                                  int     position 
                                )
{
   struct Hook *hook      = (struct Hook *) CheckObject( hookObj );
   struct eIFF *ip        = (struct eIFF *) CheckObject( IFFObj );
   APTR         theObject =          (APTR) CheckObject( anObject );
   OBJECT      *rval      = o_nil;
   LONG         chk       = 0L;
        
   if (CheckType_ID( type, id ) != TRUE)
      return( rval );
                 
   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_ENTRHAND_FUNC_IFF ) );
      
      return( rval );
      }
      
   if (!hook) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_ENTRHAND_FUNC_IFF ) );
      
      return( rval );
      }

   if (!theObject) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_ENTRHAND_FUNC_IFF ) );
      
      return( rval );
      }
   
   chk  = EntryHandler( ip->IFFHandlePtr, type, id, 
                        position, hook, theObject
                      );

   rval = AssignObj( new_int( (int) chk ) );
   
   return( rval );
}

/****i* Exit_Handler() [1.9] *******************************
*
* NAME
*    Exit_Handler()
*
* DESCRIPTION
*    ^ <primitive 240 2 15 IFFObj hookObj anObject type id pos>
************************************************************
*
*/

METHODFUNC OBJECT *Exit_Handler( OBJECT *IFFObj, 
                                 OBJECT *hookObj,
                                 OBJECT *anObject,
                                 int     type, 
                                 int     id, 
                                 int     position 
                               )
{
   struct Hook *hook      = (struct Hook *) CheckObject( hookObj  );
   struct eIFF *ip        = (struct eIFF *) CheckObject( IFFObj   );
   APTR         theObject =          (APTR) CheckObject( anObject );
   OBJECT      *rval      = o_nil;
   LONG         chk       = 0L;
        
   if (CheckType_ID( type, id ) != TRUE)
      return( rval );
                 
   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_EXITHAND_FUNC_IFF ) );
      
      return( rval );
      }
      
   if (!hook) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_EXITHAND_FUNC_IFF ) );
      
      return( rval );
      }

   if (!theObject) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_EXITHAND_FUNC_IFF ) );
      
      return( rval );
      }
   
   chk  = ExitHandler( ip->IFFHandlePtr, type, id, position, hook, theObject );

   rval = AssignObj( new_int( (int) chk ) );
   
   return( rval );
}

/****i* Stop_Chunks() [1.9] ********************************
*
* NAME
*    Stop_Chunks()
*
* DESCRIPTION
*    ^ <primitive 240 2 16 IFFObj propArray numPairs>
************************************************************
*
*/

METHODFUNC OBJECT *Stop_Chunks( OBJECT *IFFObj, OBJECT *propArray, int numPairs )
{
   struct TagItem *tags = (struct TagItem *) NULL;
   struct eIFF    *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT         *rval = o_nil;

   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_STOPCHKS_FUNC_IFF ) );
      
      return( rval );
      }

   if (!(tags = ArrayToTagList( propArray ))) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_STOPCHKS_FUNC_IFF ) );
      
      return( rval );
      }

   if (numPairs > 0)
      rval = AssignObj( new_address( (ULONG) StopChunks( ip->IFFHandlePtr,
                                                         (CONST LONG *) tags, numPairs 
                                                       )
                                   ) 
                      );

   AT_FreeVec( tags, "stopChunksTags", TRUE );
   
   return( rval );
}

/****i* Prop_Chunks() [1.9] ********************************
*
* NAME
*    Prop_Chunks()
*
* DESCRIPTION
*    ^ <primitive 240 2 17 IFFObj propArray numPairs>
************************************************************
*
*/

METHODFUNC OBJECT *Prop_Chunks( OBJECT *IFFObj, OBJECT *propArray, int numPairs )
{
   struct TagItem *tags = (struct TagItem *) NULL;
   struct eIFF    *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT         *rval = o_nil;

   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_PROPCHKS_FUNC_IFF ) );
      
      return( rval );
      }

   if (!(tags = ArrayToTagList( propArray ))) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_PROPCHKS_FUNC_IFF ) );
      
      return( rval );
      }

   if (numPairs > 0)
      rval = AssignObj( new_address( (ULONG) PropChunks( ip->IFFHandlePtr,
                                                         (CONST LONG *) tags, numPairs
                                                       )
                                   ) 
                      );
   
   AT_FreeVec( tags, "propChunksTags", TRUE );
   
   return( rval );
}

/****i* Collection_Chunks() [1.9] **************************
*
* NAME
*    Collection_Chunks()
*
* DESCRIPTION
*    ^ <primitive 240 2 18 IFFObj propArray numPairs>
************************************************************
*
*/

METHODFUNC OBJECT *Collection_Chunks( OBJECT *IFFObj, OBJECT *propArray, int numPairs )
{
   struct TagItem *tags = (struct TagItem *) NULL;
   struct eIFF    *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT         *rval = o_nil;

   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_COLLCHKS_FUNC_IFF ) );
      
      return( rval );
      }

   if (!(tags = ArrayToTagList( propArray ))) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_COLLCHKS_FUNC_IFF ) );
      
      return( rval );
      }

   if (numPairs > 0)
      rval = AssignObj( new_address( (ULONG) CollectionChunks( ip->IFFHandlePtr, 
                                                               (CONST LONG *) tags, numPairs
                                                             )
                                   )
                      );
   
   AT_FreeVec( tags, "collChunksTags", TRUE );
   
   return( rval );
}

/****h* HandleChunks() [1.9] *******************************
*
* NAME
*    HandleChunks()
*
* DESCRIPTION
*    ^ <primitive 240 2 IFFObj xx xx xx>
************************************************************
*
*/

METHODFUNC OBJECT *HandleChunks( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 240 );

      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // closeClipboard [private]
         Close_Clipboard( args[1] );
         break; 
      
      case 1: // ^ openClipboard: [private] clipUnitNumber
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 240 );
         else
            {
            int unit = int_value( args[2] );
            
            if ((unit < 0) || (unit > 255))
               {
               UserInfo( IFFCMsg( MSG_BAD_CLIPNUM_IFF ), UserPgmError );
               
               unit = 0;
               }
               
            rval = Open_Clipboard( args[1], unit );
            }
            
         break;

      case 2: // ^ parseIFF: [private] mode
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 240 );
         else
            rval = Parse_IFF( args[1], int_value( args[2] ) );
   
         break;
         
      case 3: // ^ readChunkBytes: [private] byteArray size: numBytes
         if (!is_bytearray( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Read_Chunk_Bytes( args[1], (BYTEARRAY *) args[2], int_value( args[3] ) );
         
         break;
         
      case 4: // ^ readChunkRecords: [private] byteArray size: numBytes number: numRecs
         if (!is_bytearray( args[2] ) || !is_integer( args[3] )
                                      || !is_integer( args[4] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Read_Chunk_Records( args[1], (BYTEARRAY *) args[2],
                                       int_value( args[3] ), 
                                       int_value( args[4] ) 
                                     );
         break;
         
      case 5: // ^ writeChunkBytes: [private] byteArray size: numBytes
         if (!is_bytearray( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Write_Chunk_Bytes( args[1], (BYTEARRAY *) args[2],
                                      int_value( args[3] )
                                    );
         break;

      case 6: // ^ writeChunkRecords: [private] bytes size: numBytes number: numRecs
         if (!is_bytearray( args[2] ) || !is_integer( args[3] )
                                      || !is_integer( args[4] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Write_Chunk_Records( args[1], (BYTEARRAY *) args[2],
                                        int_value( args[3] ), 
                                        int_value( args[4] ) 
                                      );
         break;

      case 7: // ^ stopChunk: [private] type id: id
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Stop_Chunk( args[1], int_value( args[2] ), 
                                        int_value( args[3] )
                             );
         break;

      case 8: // ^ currentChunk [private]
         rval = Current_Chunk( args[1] );
         break;

      case 9: // ^ propChunk: [private] type id: id
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Prop_Chunk( args[1], int_value( args[2] ),
                                        int_value( args[3] )
                             );
         break;

      case 10: // ^ findProp: [private] type id: id
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Find_Prop( args[1], int_value( args[2] ),
                                       int_value( args[3] )
                            );
         break;

      case 11: // ^ collectionChunk: [private] type id: id
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Collection_Chunk( args[1], int_value( args[2] ),
                                              int_value( args[3] )
                                   );
         break;

      case 12: // ^ findCollection: [private] type id: id
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Find_Collection( args[1], int_value( args[2] ),
                                             int_value( args[3] )
                                  );
         break;

      case 13: // ^ stopOnExit: [private] type id: id
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Stop_OnExit( args[1], int_value( args[2] ),
                                         int_value( args[3] )
                              );
         break;

      case 14: // ^ addEntryHandlerHook: [private] hookObj for: anObject
               //   type: type id: id position: pos
         if (ChkArgCount( 7, numargs, 240 ) != 0)
            return( ReturnError() );
         
         if (!is_integer( args[4] ) || !is_integer( args[5] )
                                    || !is_integer( args[6] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Entry_Handler( args[1], args[2], args[3],
                                  int_value( args[4] ),
                                  int_value( args[5] ),
                                  int_value( args[6] )
                                );
         break;

      case 15: // ^ addExitHandlerHook: [private] hookObj for: anObject
               //   type: type id: id position: pos
         if (ChkArgCount( 7, numargs, 240 ) != 0)
            return( ReturnError() );
         
         if (!is_integer( args[4] ) || !is_integer( args[5] )
                                    || !is_integer( args[6] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Exit_Handler( args[1], args[2], args[3],
                                 int_value( args[4] ),
                                 int_value( args[5] ),
                                 int_value( args[6] )
                               );
         break;

      case 16: // stopChunks: iffObj with: propertyArray size: numPairs
         if (ChkArgCount( 4, numargs, 240 ) != 0)
            return( ReturnError() );
         
         if (!is_array( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Stop_Chunks( args[1], args[2], int_value( args[3] ));
            
         break;

      case 17: // propChunks: iffObj with: propertyArray size: numPairs
         if (ChkArgCount( 4, numargs, 240 ) != 0)
            return( ReturnError() );
         
         if (!is_array( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Prop_Chunks( args[1], args[2], int_value( args[3] ));
            
         break;

      case 18: // collectionChunks: iffObj with: propertyArray size: numPairs
         if (ChkArgCount( 4, numargs, 240 ) != 0)
            return( ReturnError() );
         
         if (!is_array( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Collection_Chunks( args[1], args[2], int_value( args[3] ));
            
         break;

      
      default:
         break;
      }

   return( rval );
}

// ==== <primitive 240 3> functions: =========================================

/****i* Push_Chunk() [1.9] *********************************
*
* NAME
*    Push_Chunk()
*
* DESCRIPTION
*    ^ <primitive 240 3 0 IFFObj type id size>
************************************************************
*
*/

METHODFUNC OBJECT *Push_Chunk( OBJECT *IFFObj, int type, int id, int size )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
        
   if (CheckType_ID( type, id ) != TRUE)
      return( rval );
                 
   if (ip) // != NULL)
      rval = AssignObj( new_address( (ULONG) PushChunk( ip->IFFHandlePtr, type, id, size )));
   else
      FoundNullPtr( IFFCMsg( MSG_PUSHCHK_FUNC_IFF ) );

   return( rval );
}

/****i* Pop_Chunk() [1.9] **********************************
*
* NAME
*    Pop_Chunk()
*
* DESCRIPTION
*    ^ <primitive 240 3 1 IFFObj>
************************************************************
*
*/

METHODFUNC OBJECT *Pop_Chunk( OBJECT *IFFObj )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
        
   if (ip) // != NULL)
      rval = AssignObj( new_address( (ULONG) PopChunk( ip->IFFHandlePtr )));
   else
      FoundNullPtr( IFFCMsg( MSG_POPCHK_FUNC_IFF ) );

   return( rval );
}

/****i* Parent_Chunk() [1.9] *******************************
*
* NAME
*    Parent_Chunk()
*
* DESCRIPTION
*    ^ <primitive 240 3 2 IFFObj>
************************************************************
*
*/

METHODFUNC OBJECT *Parent_Chunk( OBJECT *IFFObj )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );
        
   if (ip) // != NULL)
      ip->ContextNodePtr = (struct ContextNode *) ParentChunk( ip->ContextNodePtr );
   else
      FoundNullPtr( IFFCMsg( MSG_PARCHK_FUNC_IFF ) );
      
   return( AssignObj( new_address( (ULONG) ip->ContextNodePtr )));
}

/****h* HandleChunkStack() [1.9] ***************************
*
* NAME
*    HandleChunkStack()
*
* DESCRIPTION
*    ^ <primitive 240 3 IFFObj xx xx xx>
************************************************************
*
*/

METHODFUNC OBJECT *HandleChunkStack( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if ( !is_integer( args[0] ) )
      {
      (void) PrintArgTypeError( 240 );

      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // ^ pushChunkType: [private] type id: id size: size
         if (!is_integer( args[2] ) || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Push_Chunk(            args[1], 
                               int_value( args[2] ),
                               int_value( args[3] ), 
                               int_value( args[4] )
                             );
         break;
         
      case 1: // ^ popChunk [private]
         rval = Pop_Chunk( args[1] );
         break;
         
      case 2: // ^ parentChunk [private]
         rval = Parent_Chunk( args[1] );
         break;
         
      default:
         break;
      }

   return( rval );
}

// ==== <primitive 240 4> functions: ======================================

/****i* Alloc_LocalItem() [1.9] ****************************
*
* NAME
*    Alloc_LocalItem()
*
* DESCRIPTION
*    <primitive 240 4 0 IFFObj type id ident dataSize>
************************************************************
*
*/

METHODFUNC OBJECT *Alloc_LocalItem( OBJECT *IFFObj, 
                                    int     type, 
                                    int     id, 
                                    int     ident, 
                                    int     dataSize
                                  )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );
        
   if (CheckType_ID( type, id ) != TRUE)
      return( o_nil );
                 
   if (ip) // != NULL)
      ip->LocalContextItemPtr = (struct LocalContextItem *) AllocLocalItem( type, id, ident, dataSize ); 
   else
      FoundNullPtr( IFFCMsg( MSG_ALLC_FUNC_IFF ) );

   return( AssignObj( new_address( (ULONG) ip->LocalContextItemPtr )));
}

/****i* Local_ItemData() [1.9] *****************************
*
* NAME
*    Local_ItemData()
*
* DESCRIPTION
*    <primitive 240 4 1 IFFObj>
************************************************************
*
*/

METHODFUNC OBJECT *Local_ItemData( OBJECT *IFFObj )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
        
   if (ip) // != NULL)
      rval = AssignObj( new_address( (ULONG) LocalItemData( ip->LocalContextItemPtr )));
   else
      FoundNullPtr( IFFCMsg( MSG_LCLDATA_FUNC_IFF ) );

   return( rval );
}

/****i* Store_LocalItem() [1.9] ****************************
*
* NAME
*    Store_LocalItem()
*
* DESCRIPTION
*    <primitive 240 4 2 IFFObj position>
************************************************************
*
*/

METHODFUNC OBJECT *Store_LocalItem( OBJECT *IFFObj, int position )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj );
   OBJECT      *rval = o_nil;
   LONG         chk  = 0L;
           
   if (ip) // != NULL)
      {
      chk  = StoreLocalItem( ip->IFFHandlePtr, ip->LocalContextItemPtr, position );

      rval = AssignObj( new_int( (int) chk ) );
      }
   else
      FoundNullPtr( IFFCMsg( MSG_STOLI_FUNC_IFF ) );
      
   return( rval );
}

/****i* Store_ItemInContext() [1.9] ************************
*
* NAME
*    Store_ItemInContext()
*
* DESCRIPTION
*    <primitive 240 4 3 IFFObj>
************************************************************
*
*/

METHODFUNC void Store_ItemInContext( OBJECT *IFFObj )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );
        
   if (ip) // != NULL)
      StoreItemInContext( ip->IFFHandlePtr, 
                          ip->LocalContextItemPtr, 
                          ip->ContextNodePtr 
                        );
   else
      FoundNullPtr( IFFCMsg( MSG_STOIC_FUNC_IFF ) );

   return;
}

/****i* Find_PropContext() [1.9] ***************************
*
* NAME
*    Find_PropContext()
*
* DESCRIPTION
*    <primitive 240 4 4 IFFObj>
************************************************************
*
*/

METHODFUNC OBJECT *Find_PropContext( OBJECT *IFFObj )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );
        
   if (ip) // != NULL)
      ip->ContextNodePtr = FindPropContext( ip->IFFHandlePtr );
   else
      FoundNullPtr( IFFCMsg( MSG_FINDPROPC_FUNC_IFF ) );
      
   return( AssignObj( new_address( (ULONG) ip->ContextNodePtr )));
}

/****i* Find_LocalItem() [1.9] *****************************
*
* NAME
*    Find_LocalItem()
*
* DESCRIPTION
*    <primitive 240 4 5 IFFObj type id ident>
************************************************************
*
*/

METHODFUNC OBJECT *Find_LocalItem( OBJECT *IFFObj, int type, int id, int ident )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );
        
   if (CheckType_ID( type, id ) != TRUE)
      return( o_nil );
                 
   if (ip) // != NULL)
      ip->LocalContextItemPtr = FindLocalItem( ip->IFFHandlePtr, type, id, ident );
   else
      FoundNullPtr( IFFCMsg( MSG_FINDLCLI_FUNC_IFF ) );

   return( AssignObj( new_address( (ULONG) ip->LocalContextItemPtr )));
}

/****i* Free_LocalItem() [1.9] *****************************
*
* NAME
*    Free_LocalItem()
*
* DESCRIPTION
*    <primitive 240 4 6 IFFObj>
************************************************************
*
*/

METHODFUNC void Free_LocalItem( OBJECT *IFFObj )
{
   struct eIFF *ip = (struct eIFF *) CheckObject( IFFObj );
        
   if (ip) // != NULL)
      FreeLocalItem( ip->LocalContextItemPtr );
   else
      FoundNullPtr( IFFCMsg( MSG_FREELI_FUNC_IFF ) );

   return;
}

/****i* Set_LocalItem_Purge() [1.9] ************************
*
* NAME
*    Set_LocalItem_Purge()
*
* DESCRIPTION
*    <primitive 240 4 7 IFFObj hookObj>
************************************************************
*
*/

METHODFUNC void Set_LocalItem_Purge( OBJECT *IFFObj, OBJECT *hookObj )
{
   struct eIFF *ip   = (struct eIFF *) CheckObject( IFFObj  );
   struct Hook *hook = (struct Hook *) CheckObject( hookObj );
        
   if (!ip) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_SETPURGE_FUNC_IFF ) );

      return;
      }

   if (!hook) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_SETPURGE_FUNC_IFF ) );

      return;
      }
      
   SetLocalItemPurge( ip->LocalContextItemPtr, hook );
   
   return; 
}

/****h* HandleLocalItems() [1.9] ***************************
*
* NAME
*    HandleLocalItems()
*
* DESCRIPTION
*    ^ <primitive 240 4>
************************************************************
*
*/

METHODFUNC OBJECT *HandleLocalItems( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 240 );

      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // ^ Alloc_LocalItem <IFFObj type id ident dataSize>
         if (ChkArgCount( 6, numargs, 240 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[2] ) || !is_integer( args[3] )
                                     || !is_integer( args[4] )
                                     || !is_integer( args[5] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Alloc_LocalItem( args[1], int_value( args[2] ),
                                             int_value( args[3] ),
                                             int_value( args[4] ),
                                             int_value( args[5] )
                                  );
         break; 

      case 1: // ^ Local_ItemData( OBJECT *IFFObj )
         rval = Local_ItemData( args[1] );
         break;

      case 2: // ^ Store_LocalItem( OBJECT *IFFObj, int position )
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 240 );
         else
            rval = Store_LocalItem( args[1], int_value( args[2] ) );

         break;

      case 3: // Store_ItemInContext( OBJECT *IFFObj )
         Store_ItemInContext( args[1] );
         break;

      case 4: // ^ Find_PropContext( OBJECT *IFFObj )
         rval = Find_PropContext( args[1] );
         break;

      case 5: // ^ Find_LocalItem <IFFObj type id ident>
         if (ChkArgCount( 5, numargs, 240 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[2] ) || !is_integer( args[3] )
                                     || !is_integer( args[4] ))
            (void) PrintArgTypeError( 240 );
         else
            rval = Find_LocalItem( args[1], int_value( args[2] ),
                                            int_value( args[3] ),
                                            int_value( args[4] )
                                 );
         break;

      case 6: // Free_LocalItem <IFFObj>
         Free_LocalItem( args[1] );
         break;

      case 7: // Set_LocalItem_Purge <IFFObj hookObj>
         if (ChkArgCount( 3, numargs, 240 ) != 0)
            return( ReturnError() );

         Set_LocalItem_Purge( args[1], args[2] );

         break;

      default:
         break;
      }
   return( rval );
}

/****i* GetErrorString() [1.9] *****************************
*
* NAME
*    GetErrorString()
*
* DESCRIPTION
*    ^ <primitive 240 5 errNum>
************************************************************
*
*/

METHODFUNC OBJECT *GetErrorString( int errnum )
{
   return( AssignObj( new_str( translateErrNum( errnum ) )));
}

/****i* idToString() [1.9] *********************************
*
* NAME
*    idToString()
*
* DESCRIPTION
*    ^ <primitive 240 6 identifier>
************************************************************
*
*/

PRIVATE char ids[10] = { 0, };

METHODFUNC OBJECT *idToString( int identifier )
{
   STRPTR chk = (STRPTR) NULL;
   
   if (GoodID( identifier ) != FALSE)
      chk = IDtoStr( identifier, &ids[0] );
   else
      {
      StringCopy( ids, IFFCMsg( MSG_BAD_ID_IFF ) );

      chk = &ids[0];
      }

   return( AssignObj( new_str( chk )));
}

/****i* GetPropertyField() [1.9] ***************************
*
* NAME
*    GetPropertyField()
*
* DESCRIPTION
*    ^ <primitive 240 7 x propObject>
************************************************************
*
*/

METHODFUNC OBJECT *GetPropertyField( int which, OBJECT *propObj )
{
   struct StoredProperty *sp   = (struct StoredProperty *) CheckObject( propObj );
   OBJECT                *rval = o_nil;
        
   if (!sp) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_GETPROPF_FUNC_IFF ) );
      
      return( rval );
      }

   switch (which)
      {
      case 0: // getPropertySize: propertyObject ^ <primitive 240 7 0 propertyObject>
         rval = AssignObj( new_int( (int) sp->sp_Size ) );
         break;

      case 1: // getPropertyData: propertyObject ^ <primitive 240 7 1 propertyObject>
         rval = AssignObj( new_address( (ULONG) sp->sp_Data ) );
         break;
         
      default:
         break;
      }

   return( rval );
}

/****i* GetCollectionField() [1.9] *************************
*
* NAME
*    GetCollectionField()
*
* DESCRIPTION
*    ^ <primitive 240 8 x collObject>
************************************************************
*
*/

METHODFUNC OBJECT *GetCollectionField( int which, OBJECT *collObj )
{
   struct CollectionItem *cp   = (struct CollectionItem *) CheckObject( collObj );
   OBJECT                *rval = o_nil;
        
   if (!cp) // == NULL)
      {
      FoundNullPtr( IFFCMsg( MSG_GETCOLLF_FUNC_IFF ) );
      
      return( rval );
      }

   switch (which)
      {
      case 0: // getCollectionSize: collObject ^ <primitive 240 8 0 collObject>
         rval = AssignObj( new_int( (int) cp->ci_Size ));
         break;

      case 1: // getCollectionData: collObject ^ <primitive 240 8 1 collObject>
         rval = AssignObj( new_address( (ULONG) cp->ci_Data ));
         break;
      
      case 2: // Not currently used.
         rval = AssignObj( new_address( (ULONG) cp->ci_Next ));
         break;
         
      default:
         break;
      }

   return( rval );
}

/****i* HandleIFF() [1.9] ******************************************
*
* NAME
*    HandleIFF()
*
* DESCRIPTION
*    Primitive <240> IFF translation.
********************************************************************
*
*/

PUBLIC OBJECT *HandleIFF( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 240 );

      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0:
         rval = HandleSetup( numargs - 1, &args[1] );
         break;

      case 1:
         rval = HandleInits( numargs - 1, &args[1] );
         break;

      case 2:
         rval = HandleChunks( numargs - 1, &args[1] );
         break;

      case 3:
         rval = HandleChunkStack( numargs - 1, &args[1] );
         break;

      case 4:
         rval = HandleLocalItems( numargs - 1, &args[1] );
         break;

      case 5: // ^ <primitive 240 5 errNum>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 240 );
         else
            rval = GetErrorString( int_value( args[1] ) );
   
         break;

      case 6: // idToString: identifier         
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 240 );
         else
            rval = idToString( int_value( args[1] ) );
   
         break;
      
      case 7: // getPropertyField: propertyObject
         if (args[1] == o_nil)
            rval = new_str( IFFCMsg( MSG_BAD_ERRNUM_IFF ) );
         else if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 240 );
         else
            rval = GetPropertyField( int_value( args[1] ), args[2] );
         
         break;

      case 8: // getCollectionField: collectionObject
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 240 );
         else
            rval = GetCollectionField( int_value( args[1] ), args[2] );
         
         break;

      default:
         break;
      }

   return( rval );
}

/* -------------------- END of IFF.c file! ---------------------------- */
