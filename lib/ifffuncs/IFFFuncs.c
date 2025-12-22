/****h* IFFFuncs.c [2.0] **********************************************
*
* NAME
*    IFFFuncs.c
*
* DESCRIPTION
*    Functions that handle IFF interfacing.  Most of the functions are
*    simple error-checking wrapper functions around the functions
*    available in iffparse.library V37+.  Only Open_IFF() & Close_IFF()
*    are more complex (for now).  Be sure to read the RKM re:
*    iffparse.library (I'm NOT going to re-document the library!).
*
* HISTORY
*    28-Oct-2004 Added AmigaOS4 & gcc support.
*    17-Aug-2003 - Ported file.
*
* NOTES
*    Derived from AmigaTalk:Src/IFF.c
*
*    $VER: IFFFuncs.c 2.0 (28-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>

#include <libraries/iffparse.h>

#ifndef __amigaos4__

# include <clib/iffparse_protos.h>
# include <clib/exec_protos.h>

PUBLIC struct LocaleBase *LocaleBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/iffparse.h>

PUBLIC struct Library     *LocaleBase;
PUBLIC struct LocaleIFace *ILocale;

PRIVATE struct IFFParseIFace *IIFFParse = (struct IFFParseIFace *) NULL;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include <proto/locale.h>

#include "IFFFuncsProtos.h"

#define  CATCOMP_ARRAY 1
#include "IFFFuncsLocale.h"

// -----------------------------------------------------------------

PRIVATE UBYTE em[512] = "", *ErrMsg = &em[0];

// -----------------------------------------------------------------

#ifdef __amigaos4__
# define  FASTMEM  MEMF_FAST | MEMF_CLEAR | MEMF_SHARED
#else
# define  FASTMEM  MEMF_FAST | MEMF_CLEAR | MEMF_PUBLIC
#endif


/* eIFF->Status values: (IFFF_READ = 0, IFFF_WRITE = 1 also!) */

#define  IFF_OPEN       8
#define  IFF_FILE_OPEN  16
#define  IFF_ALLOCATED  32
#define  IFF_LIB_OPEN   64
#define  IFF_IFACE_OPEN 128

// -------------------------------------------------------------------------

#define MY_LANGUAGE "English"

PUBLIC struct Catalog    *IFF_Catalog = NULL;

PRIVATE BOOL              needCatalog = TRUE;

PRIVATE int SetupCatalog( void )
{
#  ifndef __amigaos4__
   if (!(LocaleBase = (struct LocaleBase *) 
                       OpenLibrary( "locale.library", 39L ))) // == NULL)
      {
      return( -1 );
      }
#  else
   if ((LocaleBase = OpenLibrary( "locale.library", 50L ))) // != NULL)
      {
      if (!(ILocale = (struct LocaleIFace *) GetInterface( LocaleBase, "main", 1, NULL )))
         {
	 CloseLibrary( LocaleBase );

	 return( -1 );
	 }
      }
#  endif
   else
      {
      IFF_Catalog = OpenCatalog( NULL, "ifffuncs.catalog",
                                 OC_BuiltInLanguage, MY_LANGUAGE,
                                 TAG_DONE 
                               );
      needCatalog = FALSE;

      return( 0 );
      }
}

PRIVATE STRPTR CMsg( int strIndex, char *defaultString )
{
   if (IFF_Catalog) // != NULL)
      return( (STRPTR) GetCatalogStr( IFF_Catalog, strIndex, defaultString ) );
   else
      return( (STRPTR) defaultString );
}

/****i* OpenIFFLibrary() [2.0] *****************************
*
* NAME
*    OpenIFFLibrary()
*
* DESCRIPTION
*    Open the iffparse.library
************************************************************
*
*/

PRIVATE BOOL OpenIFFLibrary( struct eIFF *ip, LONG version )
{
   if (ip->IFFParseBase) // != NULL) // Only open the library once!
      return( TRUE ); 

#  ifndef __amigaos4__      
   ip->IFFParseBase = OpenLibrary( "iffparse.library", version );

   if (!ip->IFFParseBase) // == NULL)
      return( FALSE );
   else
      {
      ip->Status |= IFF_LIB_OPEN;
   
      return( TRUE );
      }
#  else
   if (version < 50)
      version = 50;
      
   if (!(ip->IFFParseBase = OpenLibrary( "iffparse.library", version )))
      return( FALSE );
   else
      ip->Status |= IFF_LIB_OPEN;
      
   if (!(ip->IIFFParse = (struct IFFParseIFace *) GetInterface( IFFParseBase, "main", 1, NULL )))
      {
      CloseLibrary( ip->IFFParseBase );
      
      ip->Status &= ~IFF_LIB_OPEN;
      
      return( FALSE );
      } 
   else
      {
      IIFFParse   = ip->IIFFParse;
      ip->Status |= IFF_IFACE_OPEN;
   
      return( TRUE );      
      }
#  endif

}

/****i* CloseIFFLibrary() [2.0] ****************************
*
* NAME
*    CloseIFFLibrary()
*
* DESCRIPTION
*    Close the iffparse.library
************************************************************
*
*/

PRIVATE void CloseIFFLibrary( struct eIFF *ip )
{
   if ((ip->Status & IFF_LIB_OPEN) == IFF_LIB_OPEN)
      {
#     ifdef __amigaos4__
      if ((ip->Status & IFF_IFACE_OPEN) == IFF_IFACE_OPEN)
         {
         DropInterface( (struct Interface *) ip->IIFFParse );

         IIFFParse = ip->IIFFParse = (struct IFFParseIFace *) NULL;

         ip->Status &= ~IFF_IFACE_OPEN;
	 }
#     endif

      CloseLibrary( ip->IFFParseBase );

      ip->IFFParseBase  = NULL;
      ip->Status       &= ~IFF_LIB_OPEN;
      }

   return;
}

/****i* AllocateIFF() [2.0] ********************************
*
* NAME
*    AllocateIFF()
*
* DESCRIPTION
*    Allocate a new IFF handle if argument is NULL.
************************************************************
*
*/

PRIVATE BOOL AllocateIFF( struct IFFHandle *ip )
{
   if (ip) // != NULL)
      return( TRUE );
      
   if ((ip = AllocIFF())) // != NULL)
      return( TRUE );
   else
      return( FALSE );
}

/****i* FreeIFFAllocation() [2.0] **************************
*
* NAME
*    FreeIFFAllocation()
*
* DESCRIPTION
*    Free the IFF handle.
************************************************************
*
*/

PRIVATE void FreeIFFAllocation( struct IFFHandle *ip )
{
   if (ip) // != NULL)
      {
      FreeIFF( ip );

      ip = (struct IFFHandle *) NULL;
      }

   return;
}

/****i* OpenIFF_File() [2.0] *******************************
*
* NAME
*    OpenIFF_File()
*
* DESCRIPTION
*    Open the given IFF file.
************************************************************
*
*/

PRIVATE BOOL OpenIFF_File( struct eIFF *ip, int type, char *name )
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

/****i* CloseIFF_File() [2.0] ******************************
*
* NAME
*    CloseIFF_File()
*
* DESCRIPTION
*    Close the given file handle.
************************************************************
*
*/

PRIVATE void CloseIFF_File( struct eIFF *ip, int type )
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

PRIVATE char *iffErrStrs[15] = { NULL, };

PRIVATE BOOL  ErrStrsSet     = FALSE;

/****i* CatalogIFF() [2.0] *********************************
*
* NAME
*    CatalogIFF()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
************************************************************
*
*/

PRIVATE int CatalogIFF( void )
{
   iffErrStrs[0]  = CMsg( MSG_IFF_ERR_RET2CLIENT, MSG_IFF_ERR_RET2CLIENT_STR ); // IFF_RETURN2CLIENT -12L
   iffErrStrs[1]  = CMsg( MSG_IFF_ERR_NOHOOK,  MSG_IFF_ERR_NOHOOK_STR  );    // IFFERR_NOHOOK
   iffErrStrs[2]  = CMsg( MSG_IFF_ERR_NOTIFF,  MSG_IFF_ERR_NOTIFF_STR  );    // IFFERR_NOTIFF
   iffErrStrs[3]  = CMsg( MSG_IFF_ERR_SYNTAX,  MSG_IFF_ERR_SYNTAX_STR  );    // IFFERR_SYNTAX
   iffErrStrs[4]  = CMsg( MSG_IFF_ERR_MANGLED, MSG_IFF_ERR_MANGLED_STR );    // IFFERR_MANGLED
   iffErrStrs[5]  = CMsg( MSG_IFF_ERR_SEEK,    MSG_IFF_ERR_SEEK_STR    );    // IFFERR_SEEK
   iffErrStrs[6]  = CMsg( MSG_IFF_ERR_WRITE,   MSG_IFF_ERR_WRITE_STR   );    // IFFERR_WRITE
   iffErrStrs[7]  = CMsg( MSG_IFF_ERR_READ,    MSG_IFF_ERR_READ_STR    );    // IFFERR_READ
   iffErrStrs[8]  = CMsg( MSG_IFF_ERR_NOMEM,   MSG_IFF_ERR_NOMEM_STR   );    // IFFERR_NOMEM
   iffErrStrs[9]  = CMsg( MSG_IFF_ERR_NOSCOPE, MSG_IFF_ERR_NOSCOPE_STR );    // IFFERR_NOSCOPE
   iffErrStrs[10] = CMsg( MSG_IFF_ERR_EOC,     MSG_IFF_ERR_EOC_STR     );    // IFFERR_EOC
   iffErrStrs[11] = CMsg( MSG_IFF_ERR_EOF,     MSG_IFF_ERR_EOF_STR     );    // IFFERR_EOF
   iffErrStrs[12] = CMsg( MSG_IFF_ERR_NONE,    MSG_IFF_ERR_NONE_STR    );    // NO ERROR 0
   iffErrStrs[13] = CMsg( MSG_IFF_ERR_UNKNOWN, MSG_IFF_ERR_UNKNOWN_STR );    // Unknown ERROR # 1

   ErrStrsSet = TRUE;
      
   return( 0 );
}

/****i* translateErrNum() [2.0] ****************************
*
* NAME
*    translateErrNum()
*
* DESCRIPTION
*    Translate an IFF error number into a string.
************************************************************
*
*/

PRIVATE char *translateErrNum( int errnum )
{
   char *rval = (char *) NULL;
   
   if (errnum < IFF_RETURN2CLIENT)
      rval = iffErrStrs[ 13 ];
   else
      rval = iffErrStrs[ errnum - IFF_RETURN2CLIENT ];
      
   return( rval );
}

/****h* Close_IFF() [2.0] **********************************
*
* NAME
*    Close_IFF()
*
* DESCRIPTION
*    This function releases allocated memory & resources &
*    Closes opened libraries.
************************************************************
*
*/

PUBLIC void Close_IFF( struct eIFF *ip )
{
   if (!ip) // == NULL)
      return;

   if (ip->Status & IFF_OPEN == IFF_OPEN)
      {
      CloseIFF( ip->IFFHandlePtr );

      ip->Status &= ~IFF_OPEN;
      }

   CloseIFF_File( ip, ip->StreamType );

   FreeIFFAllocation( ip->IFFHandlePtr );
             
   CloseIFFLibrary( ip );

   if (needCatalog == FALSE)
      {
      CloseCatalog( IFF_Catalog );
      CloseLibrary( (struct Library *) LocaleBase );
      
      needCatalog = TRUE;
      }
      
   FreeVec( ip );

   ip = (struct eIFF *) NULL;
   
   return;
}

PRIVATE void MemoryOut( char *msg )
{
   sprintf( ErrMsg, "%s", CMsg( MSG_IFF_NOMEM, MSG_IFF_NOMEM_STR ) );

   UserInfo( ErrMsg, msg );
   
   return;
}

PRIVATE void FoundNullPtr( char *msg )
{
   sprintf( ErrMsg, "%s", CMsg( MSG_IFF_NULLPTR, MSG_IFF_NULLPTR_STR ) );

   UserInfo( ErrMsg, msg );
   
   return;
}

/****h* Open_IFF() [2.0] ***********************************
*
* NAME
*    Open_IFF()
*
* DESCRIPTION
*    Allocate & Otherwise open an IFF stream.
*    Return a pointer to an eIFF structure.  This function
*    does most of the work in setting up all that you need
*    to use the rest of the functions:
*
*      1. Opens LocaleBase & sets up the catalog strings.
*      2. Allocates memory for the struct eIFF used by almost
*         all other functions.
*      3. Opens iffparse.library (V37+)
*      4. Allocates the IFF Handle pointer
*      5. Opens the IFF file (or clip).
************************************************************
*
*/

PUBLIC struct eIFF *Open_IFF( char *iffName, int Type, int Mode )
{
   struct eIFF *newIFF = NULL;

   if (needCatalog == TRUE)
      (void) SetupCatalog();
      
   if (ErrStrsSet == FALSE)
      (void) CatalogIFF();

   if (!(newIFF = (struct eIFF *) AllocVec( sizeof( struct eIFF ), FASTMEM ))) // == NULL)
      {
      MemoryOut( CMsg( MSG_IFF_OPEN_IFF_FUNC, MSG_IFF_OPEN_IFF_FUNC_STR ) );
      
      return( newIFF ); // which is NULL
      }

   if (OpenIFFLibrary( newIFF, 37L ) == TRUE)
      newIFF->Status |= IFF_LIB_OPEN;
   else
      {
      sprintf( ErrMsg, CMsg( MSG_FORMAT_LIB_OPEN, MSG_FORMAT_LIB_OPEN_STR ),
               IoErr()
             );
      
      UserInfo( ErrMsg, 
                CMsg( MSG_IFF_IFFHANDLE_FUNC, MSG_IFF_IFFHANDLE_FUNC_STR )
              );
      
      FreeVec( newIFF );

      return( NULL );
      }

   if (AllocateIFF( newIFF->IFFHandlePtr ) == FALSE)
      {
      MemoryOut( CMsg( MSG_IFF_IFFHANDLE_FUNC, MSG_IFF_IFFHANDLE_FUNC_STR ) );

      CloseIFFLibrary( newIFF );

      FreeVec( newIFF );
      
      return( NULL );
      }
   else
      newIFF->Status |= IFF_ALLOCATED;

   if (OpenIFF_File( newIFF, Type, iffName ) == FALSE)
      {
      sprintf( ErrMsg, CMsg( MSG_FORMAT_FILE_OPEN, MSG_FORMAT_FILE_OPEN_STR ),
               IoErr()
             );
      
      UserInfo( ErrMsg, 
                CMsg( MSG_IFF_IFFHANDLE_FUNC, MSG_IFF_IFFHANDLE_FUNC_STR )
              );
      
      newIFF->Status &= ~IFF_ALLOCATED;
      
      FreeIFFAllocation( newIFF->IFFHandlePtr );
            
      CloseIFFLibrary( newIFF );

      FreeVec( newIFF );
      
      return( NULL );
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
         newIFF->Status |= IFF_OPEN; // Weesa okey-dokey!
         }
      else
         {
         sprintf( ErrMsg, CMsg( MSG_FORMAT_IFFERR, MSG_FORMAT_IFFERR_STR ),
                          translateErrNum( chk ) 
                );

         UserInfo( ErrMsg, CMsg( MSG_IFF_SYSTEMPROBLEM, MSG_IFF_SYSTEMPROBLEM_STR ) );

         CloseIFF_File( newIFF, Type );
         
         FreeIFFAllocation( newIFF->IFFHandlePtr );
             
         CloseIFFLibrary( newIFF );

         FreeVec( newIFF );
         }
      }

   return( newIFF );
}

/****h* Init_IFFHook() [2.0] *******************************
*
* NAME
*    Init_IFFHook()
*
* DESCRIPTION
*    Initialize IFF stream with a Hook.
*    This is a wrapper around InitIFF() in iffparse.library.
************************************************************
*
*/

PUBLIC void Init_IFFHook( struct eIFF *ip, struct Hook *hook, int flags )
{
   if (!ip) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_INITIFF_FUNC, MSG_IFF_INITIFF_FUNC_STR ) );

      return;
      }
      
   if (!hook) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_INITIFF_FUNC, MSG_IFF_INITIFF_FUNC_STR ) );

      return;
      }

   InitIFF( ip->IFFHandlePtr, flags, hook );

   return;
}

/****h* Init_IFFAsDOS() [2.0] ******************************
*
* NAME
*    Init_IFFAsDOS()
*
* DESCRIPTION
*    This is a wrapper around InitIFFasDOS() in iffparse.library.
************************************************************
*
*/

PUBLIC void Init_IFFAsDOS( struct eIFF *ip )
{
   if (!ip) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_INITDOS_FUNC, MSG_IFF_INITDOS_FUNC_STR ) );

      return;
      }
      
   InitIFFasDOS( ip->IFFHandlePtr );

   return;
}

/****h* Init_IFFAsClip() [2.0] *****************************
*
* NAME
*    Init_IFFAsClip()
*
* DESCRIPTION
*    This is a wrapper around InitIFFasClip() in iffparse.library.
************************************************************
*
*/

PUBLIC void Init_IFFAsClip( struct eIFF *ip )
{
   if (!ip) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_INITCLIP_FUNC, MSG_IFF_INITCLIP_FUNC_STR ) );

      return;
      }
      
   InitIFFasClip( ip->IFFHandlePtr );
   
   return;
}

/****h* Close_Clipboard() [2.0] ****************************
*
* NAME
*    Close_Clipboard()
*
* DESCRIPTION
*    This is a wrapper around CloseClipboard() in iffparse.library.
************************************************************
*
*/

PUBLIC void Close_Clipboard( struct eIFF *ip )
{
   if (ip) // != NULL)
      CloseClipboard( ip->ClipboardHandlePtr );
   else
      FoundNullPtr( CMsg( MSG_IFF_CLOSECLIP_FUNC, MSG_IFF_CLOSECLIP_FUNC_STR ) );
      
   return;
}

/****h* Open_Clipboard() [2.0] *****************************
*
* NAME
*    Open_Clipboard()
*
* DESCRIPTION
*    This is a wrapper around OpenClipboard() in iffparse.library.
************************************************************
*
*/

PUBLIC struct ClipboardHandle *Open_Clipboard( struct eIFF *ip, int unit )
{
   if (ip) // != NULL)
      {
      ip->ClipboardHandlePtr = OpenClipboard( unit );

      return( ip->ClipboardHandlePtr );
      }
   else
      FoundNullPtr( CMsg( MSG_IFF_OPENCLIP_FUNC, MSG_IFF_OPENCLIP_FUNC_STR ) );

   return( (struct ClipboardHandle *) NULL );
}

/****h* Parse_IFF() [2.0] **********************************
*
* NAME
*    Parse_IFF()
*
* DESCRIPTION
*    This is a wrapper around ParseIFF() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Parse_IFF( struct eIFF *ip, int mode )
{
   if (ip) // != NULL)
      return( ParseIFF( ip->IFFHandlePtr, mode ) );
   else
      FoundNullPtr( CMsg( MSG_IFF_PARSE_FUNC, MSG_IFF_PARSE_FUNC_STR ) );

   return( 0L );
}

/****h* Read_Chunk_Bytes() [2.0] ***************************
*
* NAME
*    Read_Chunk_Bytes()
*
* DESCRIPTION
*    This is a wrapper around ReadChunkBytes() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Read_Chunk_Bytes( struct eIFF *ip, APTR buff, LONG numBytes )
{
   if (!buff) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_READCHK_FUNC, MSG_IFF_READCHK_FUNC_STR ) );
      
      return( 0L );
      }
          
   if (ip) // != NULL)
      {
      return( ReadChunkBytes( ip->IFFHandlePtr, buff, numBytes ) );
      }
   else
      FoundNullPtr( CMsg( MSG_IFF_READCHK_FUNC, MSG_IFF_READCHK_FUNC_STR ) );

   return( 0L );
}

/****h* Read_Chunk_Records() [2.0] *************************
*
* NAME
*    Read_Chunk_Records()
*
* DESCRIPTION
*    This is a wrapper around ReadChunkRecords() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Read_Chunk_Records( struct eIFF *ip,
                                APTR         buff,
                                int          numBytes, 
                                int          numRecs
                              )
{
   if (!buff) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_READCHKR_FUNC, MSG_IFF_READCHKR_FUNC_STR ) );
      
      return( 0L );
      }
           
   if (ip) // != NULL)
      {
      return( ReadChunkRecords( ip->IFFHandlePtr, buff, numBytes, numRecs ) );
      }
   else
      FoundNullPtr( CMsg( MSG_IFF_READCHKR_FUNC, MSG_IFF_READCHKR_FUNC_STR ) );

   return( 0L );
}

/****h* Write_Chunk_Bytes() [2.0] **************************
*
* NAME
*    Write_Chunk_Bytes()
*
* DESCRIPTION
*    This is a wrapper around WriteChunkBytes() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Write_Chunk_Bytes( struct eIFF *ip, CONST APTR buff, int numBytes )
{
   if (!buff) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_WRTCHK_FUNC, MSG_IFF_WRTCHK_FUNC_STR ) );
      
      return( 0L );
      }
     
   if (ip) // != NULL)
      {
      return( WriteChunkBytes( ip->IFFHandlePtr, buff, numBytes ) );
      } 
   else
      FoundNullPtr( CMsg( MSG_IFF_WRTCHK_FUNC, MSG_IFF_WRTCHK_FUNC_STR ) );

   return( 0L );
}

/****h* Write_Chunk_Records() [2.0] ************************
*
* NAME
*    Write_Chunk_Records()
*
* DESCRIPTION
*    This is a wrapper around WriteChunkRecords() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Write_Chunk_Records( struct eIFF *ip,
                                 CONST APTR   buff,
                                 int          numBytes, 
                                 int          numRecs 
                               )
{
   if (!buff) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_WRTCHKR_FUNC, MSG_IFF_WRTCHKR_FUNC_STR ) );
      
      return( 0L );
      }
     
   if (ip) // != NULL)
      {
      return( WriteChunkRecords( ip->IFFHandlePtr, buff, numBytes, numRecs ) );
      }
   else
      FoundNullPtr( CMsg( MSG_IFF_WRTCHKR_FUNC, MSG_IFF_WRTCHKR_FUNC_STR ) );

   return( 0L );
}

/****i* CheckType_ID() [2.0] *******************************
*
* NAME
*    CheckType_ID()
*
* DESCRIPTION
*    Verify that the IFF type & id are valid.
************************************************************
*
*/

PRIVATE BOOL CheckType_ID( int type, int id )
{
   BOOL rval = FALSE;
   
   if (GoodType( type ) == FALSE)
      {
      sprintf( ErrMsg, CMsg( MSG_FORMAT_INVALIDTYPE, MSG_FORMAT_INVALIDTYPE_STR ), type );

      UserInfo( ErrMsg, CMsg( MSG_USERPGM_ERROR, MSG_USERPGM_ERROR_STR ) );
      
      return( rval );
      }
   
   if (GoodID( id ) == FALSE)
      {
      sprintf( ErrMsg, CMsg( MSG_FORMAT_INVALID_ID, MSG_FORMAT_INVALID_ID_STR ), id );

      UserInfo( ErrMsg, CMsg( MSG_USERPGM_ERROR, MSG_USERPGM_ERROR_STR ) );
      
      return( rval );
      }
   else
      return( TRUE );   
}

/****h* Stop_Chunk() [2.0] *********************************
*
* NAME
*    Stop_Chunk()
*
* DESCRIPTION
*    This is a wrapper around StopChunk() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Stop_Chunk( struct eIFF *ip, int type, int id )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( FALSE );
                 
   if (ip) // != NULL)
      return( StopChunk( ip->IFFHandlePtr, type, id ) );
   else
      FoundNullPtr( CMsg( MSG_IFF_STOPCHK_FUNC, MSG_IFF_STOPCHK_FUNC_STR ) );

   return( FALSE );
}

/****h* Current_Chunk() [2.0] ******************************
*
* NAME
*    Current_Chunk()
*
* DESCRIPTION
*    This is a wrapper around CurrentChunk() in iffparse.library.
************************************************************
*
*/

PUBLIC struct ContextNode *Current_Chunk( struct eIFF *ip )
{
   if (ip) // != NULL)
      {
      ip->ContextNodePtr = CurrentChunk( ip->IFFHandlePtr );

      return( ip->ContextNodePtr );
      }
   else
      FoundNullPtr( CMsg( MSG_IFF_CRNTCHK_FUNC, MSG_IFF_CRNTCHK_FUNC_STR ) );
       
   return( (struct ContextNode *) NULL );
}

/****h* Prop_Chunk() [2.0] *********************************
*
* NAME
*    Prop_Chunk()
*
* DESCRIPTION
*    This is a wrapper around PropChunk() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Prop_Chunk( struct eIFF *ip, int type, int id )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( 0L );
     
   if (ip) // != NULL)
      return( PropChunk( ip->IFFHandlePtr, type, id ) );
   else
      FoundNullPtr( CMsg( MSG_IFF_PROPCHK_FUNC, MSG_IFF_PROPCHK_FUNC_STR ) );

   return( 0L );
}

/****h* Find_Prop() [2.0] **********************************
*
* NAME
*    Find_Prop()
*
* DESCRIPTION
*    This is a wrapper around FindProp() in iffparse.library.
************************************************************
*
*/

PUBLIC struct StoredProperty *Find_Prop( struct eIFF *ip, int type, int id )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( (struct StoredProperty *) NULL );
                 
   if (ip) // != NULL)
      ip->StoredPropertyPtr = FindProp( ip->IFFHandlePtr, type, id );
   else
      FoundNullPtr( CMsg( MSG_IFF_FINDPROP_FUNC, MSG_IFF_FINDPROP_FUNC_STR ) );

   return( ip->StoredPropertyPtr );
}

/****h* Collection_Chunk() [2.0] ***************************
*
* NAME
*    Collection_Chunk()
*
* DESCRIPTION
*    This is a wrapper around CollectionChunk() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Collection_Chunk( struct eIFF *ip, int type, int id )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( 0L );
                 
   if (ip) // != NULL)
      return( CollectionChunk( ip->IFFHandlePtr, type, id ) );
   else
      FoundNullPtr( CMsg( MSG_IFF_COLLCHK_FUNC, MSG_IFF_COLLCHK_FUNC_STR ) );

   return( 0L );
}

/****h* Find_Collection() [2.0] ****************************
*
* NAME
*    Find_Collection()
*
* DESCRIPTION
*    This is a wrapper around FindCollection() in iffparse.library.
************************************************************
*
*/

PUBLIC struct CollectionItem *Find_Collection( struct eIFF *ip, int type, int id )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( (struct CollectionItem *) NULL );
                 
   if (ip) // != NULL)
      ip->CollectionItemPtr = FindCollection( ip->IFFHandlePtr, type, id );
   else
      FoundNullPtr( CMsg( MSG_IFF_FINDCOLL_FUNC, MSG_IFF_FINDCOLL_FUNC_STR ) );

   return( ip->CollectionItemPtr );
}

/****h* Stop_OnExit() [2.0] ********************************
*
* NAME
*    Stop_OnExit()
*
* DESCRIPTION
*    This is a wrapper around StopOnExit() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Stop_OnExit( struct eIFF *ip, int type, int id )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( 0L );
                 
   if (ip) // != NULL)
      return( StopOnExit( ip->IFFHandlePtr, type, id ) );
   else
      FoundNullPtr( CMsg( MSG_IFF_STOPEXIT_FUNC, MSG_IFF_STOPEXIT_FUNC_STR ) );

   return( 0L );
}

/****h* Entry_Handler() [2.0] ******************************
*
* NAME
*    Entry_Handler()
*
* DESCRIPTION
*    This is a wrapper around EntryHandler() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Entry_Handler( struct eIFF *ip,
                           struct Hook *hook,
                           APTR         theObject,
                           int          type, 
                           int          id, 
                           int          position 
                         )
{
   LONG chk = 0L;
        
   if (CheckType_ID( type, id ) != TRUE)
      return( 0L );
                 
   if (!ip || !hook || !theObject) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_ENTRHAND_FUNC, MSG_IFF_ENTRHAND_FUNC_STR ) );
      
      return( 0L );
      }
      
   chk = EntryHandler( ip->IFFHandlePtr, type, id, 
                       position, hook, theObject
                     );

   return( chk );
}

/****h* Exit_Handler() [2.0] *******************************
*
* NAME
*    Exit_Handler()
*
* DESCRIPTION
*    This is a wrapper around ExitHandler() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Exit_Handler( struct eIFF *ip, 
                          struct Hook *hook,
                          APTR         theObject,
                          int          type, 
                          int          id, 
                          int          position 
                        )
{
   LONG chk = 0L;
        
   if (CheckType_ID( type, id ) != TRUE)
      return( 0L );
                 
   if (!ip || !hook || !theObject) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_EXITHAND_FUNC, MSG_IFF_EXITHAND_FUNC_STR ) );
      
      return( 0L );
      }
      
   chk = ExitHandler( ip->IFFHandlePtr, type, id, position, hook, theObject );

   return( chk );
}

/****h* Stop_Chunks() [2.0] ********************************
*
* NAME
*    Stop_Chunks()
*
* DESCRIPTION
*    This is a wrapper around StopChunks() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Stop_Chunks( struct eIFF *ip, CONST LONG *propArray, int numPairs )
{
   if (!ip) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_STOPCHKS_FUNC, MSG_IFF_STOPCHKS_FUNC_STR ) );
      
      return( 0L );
      }

   if (numPairs > 0)
      return( StopChunks( ip->IFFHandlePtr,
                          propArray, numPairs 
                        ) );
   else
      return( 0L );
}

/****h* Prop_Chunks() [2.0] ********************************
*
* NAME
*    Prop_Chunks()
*
* DESCRIPTION
*    This is a wrapper around PropChunks() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Prop_Chunks( struct eIFF *ip, CONST LONG *propArray, int numPairs )
{
   if (!ip) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_PROPCHKS_FUNC, MSG_IFF_PROPCHKS_FUNC_STR ) );
      
      return( 0L );
      }

   if (numPairs > 0)
      return( PropChunks( ip->IFFHandlePtr,
                          propArray, numPairs
                        ) );
   else 
      return( 0L );
}

/****h* Collection_Chunks() [2.0] **************************
*
* NAME
*    Collection_Chunks()
*
* DESCRIPTION
*    This is a wrapper around CollectionChunks() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Collection_Chunks( struct eIFF *ip, CONST LONG *propArray, int numPairs )
{
   if (!ip) // == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_COLLCHKS_FUNC, MSG_IFF_COLLCHKS_FUNC_STR ) );
      
      return( 0L );
      }

   if (numPairs > 0)
      return( CollectionChunks( ip->IFFHandlePtr, 
                                propArray, numPairs
                              ) );
   else
      return( 0L );
}

/****h* Push_Chunk() [2.0] *********************************
*
* NAME
*    Push_Chunk()
*
* DESCRIPTION
*    This is a wrapper around PushChunk() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Push_Chunk( struct eIFF *ip, int type, int id, int size )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( 0L );
                 
   if (ip) // != NULL)
      return( PushChunk( ip->IFFHandlePtr, type, id, size ) );
   else
      FoundNullPtr( CMsg( MSG_IFF_PUSHCHK_FUNC, MSG_IFF_PUSHCHK_FUNC_STR ) );

   return( 0L );
}

/****h* Pop_Chunk() [2.0] **********************************
*
* NAME
*    Pop_Chunk()
*
* DESCRIPTION
*    This is a wrapper around PopChunk() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Pop_Chunk( struct eIFF *ip )
{
   if (ip) // != NULL)
      return( PopChunk( ip->IFFHandlePtr ) );
   else
      FoundNullPtr( CMsg( MSG_IFF_POPCHK_FUNC, MSG_IFF_POPCHK_FUNC_STR ) );

   return( 0L );
}

/****h* Parent_Chunk() [2.0] *******************************
*
* NAME
*    Parent_Chunk()
*
* DESCRIPTION
*    This is a wrapper around ParentChunk() in iffparse.library.
************************************************************
*
*/

PUBLIC struct ContextNode *Parent_Chunk( struct eIFF *ip )
{
   if (ip) // != NULL)
      ip->ContextNodePtr = ParentChunk( ip->ContextNodePtr );
   else
      FoundNullPtr( CMsg( MSG_IFF_PARCHK_FUNC, MSG_IFF_PARCHK_FUNC_STR ) );
      
   return( ip->ContextNodePtr );
}

/****h* Alloc_LocalItem() [2.0] ****************************
*
* NAME
*    Alloc_LocalItem()
*
* DESCRIPTION
*    This is a wrapper around AllocLocalItem() in iffparse.library.
************************************************************
*
*/

PUBLIC struct LocalContextItem *Alloc_LocalItem( struct eIFF *ip,
                                                 int          type, 
                                                 int          id, 
                                                 int          ident, 
                                                 int          dataSize
                                               )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( NULL );
                 
   if (ip) // != NULL)
      ip->LocalContextItemPtr = AllocLocalItem( type, id, ident, dataSize ); 
   else
      FoundNullPtr( CMsg( MSG_IFF_ALLC_FUNC, MSG_IFF_ALLC_FUNC_STR ) );

   return( ip->LocalContextItemPtr );
}

/****h* Local_ItemData() [2.0] *****************************
*
* NAME
*    Local_ItemData()
*
* DESCRIPTION
*    This is a wrapper around LocalItemData() in iffparse.library.
************************************************************
*
*/

PUBLIC APTR Local_ItemData( struct eIFF *ip )
{
   if (ip) // != NULL)
      return( LocalItemData( ip->LocalContextItemPtr ) );
   else
      FoundNullPtr( CMsg( MSG_IFF_LCLDATA_FUNC, MSG_IFF_LCLDATA_FUNC_STR ) );

   return( (APTR) NULL );
}

/****h* Store_LocalItem() [2.0] ****************************
*
* NAME
*    Store_LocalItem()
*
* DESCRIPTION
*    This is a wrapper around StoreLocalItem() in iffparse.library.
************************************************************
*
*/

PUBLIC LONG Store_LocalItem( struct eIFF *ip, int position )
{
   if (ip) // != NULL)
      {
      return( StoreLocalItem( ip->IFFHandlePtr, ip->LocalContextItemPtr, position ));
      }
   else
      FoundNullPtr( CMsg( MSG_IFF_STOLI_FUNC, MSG_IFF_STOLI_FUNC_STR ) );
      
   return( 0L );
}

/****h* Store_ItemInContext() [2.0] ************************
*
* NAME
*    Store_ItemInContext()
*
* DESCRIPTION
*    This is a wrapper around StoreItemInContext() in iffparse.library.
************************************************************
*
*/

PUBLIC void Store_ItemInContext( struct eIFF *ip )
{
   if (ip) // != NULL)
      StoreItemInContext( ip->IFFHandlePtr, 
                          ip->LocalContextItemPtr, 
                          ip->ContextNodePtr 
                        );
   else
      FoundNullPtr( CMsg( MSG_IFF_STOIC_FUNC, MSG_IFF_STOIC_FUNC_STR ) );

   return;
}

/****h* Find_PropContext() [2.0] ***************************
*
* NAME
*    Find_PropContext()
*
* DESCRIPTION
*    This is a wrapper around FindPropContext() in iffparse.library.
************************************************************
*
*/

PUBLIC struct ContextNode *Find_PropContext( struct eIFF *ip )
{
   if (ip) // != NULL)
      ip->ContextNodePtr = FindPropContext( ip->IFFHandlePtr );
   else
      FoundNullPtr( CMsg( MSG_IFF_FINDPROPC_FUNC, MSG_IFF_FINDPROPC_FUNC_STR ) );
      
   return( ip->ContextNodePtr );
}

/****h* Find_LocalItem() [2.0] *****************************
*
* NAME
*    Find_LocalItem()
*
* DESCRIPTION
*    This is a wrapper around FindLocalItem() in iffparse.library.
************************************************************
*
*/

PUBLIC struct LocalContextItem *Find_LocalItem( struct eIFF *ip, int type, int id, int ident )
{
   if (CheckType_ID( type, id ) != TRUE)
      return( NULL );
                 
   if (ip) // != NULL)
      ip->LocalContextItemPtr = FindLocalItem( ip->IFFHandlePtr, type, id, ident );
   else
      FoundNullPtr( CMsg( MSG_IFF_FINDLCLI_FUNC, MSG_IFF_FINDLCLI_FUNC_STR ) );

   return( ip->LocalContextItemPtr );
}

/****h* Free_LocalItem() [2.0] *****************************
*
* NAME
*    Free_LocalItem()
*
* DESCRIPTION
*    This is a wrapper around FreeLocalItem() in iffparse.library.
************************************************************
*
*/

PUBLIC void Free_LocalItem( struct eIFF *ip )
{
   if (ip) // != NULL)
      FreeLocalItem( ip->LocalContextItemPtr );
   else
      FoundNullPtr( CMsg( MSG_IFF_FREELI_FUNC, MSG_IFF_FREELI_FUNC_STR ) );

   return;
}

/****h* Set_LocalItem_Purge() [2.0] ************************
*
* NAME
*    Set_LocalItem_Purge()
*
* DESCRIPTION
*    This is a wrapper around SetLocalItemPurge() in iffparse.library.
************************************************************
*
*/

PUBLIC void Set_LocalItem_Purge( struct eIFF *ip, struct Hook *hook )
{
   if (!ip || !hook) //  == NULL)
      {
      FoundNullPtr( CMsg( MSG_IFF_SETPURG_FUNC, MSG_IFF_SETPURG_FUNC_STR ) );

      return;
      }

   SetLocalItemPurge( ip->LocalContextItemPtr, hook );
   
   return; 
}

/****h* GetErrorString() [2.0] *****************************
*
* NAME
*    GetErrorString()
*
* DESCRIPTION
*    Return an ERROR string that corresponds to the ERROR
*    number argument (if valid).
************************************************************
*
*/

PUBLIC char *GetErrorString( int errnum )
{
   return( translateErrNum( errnum ) );
}

/****h* idToString() [2.0] *********************************
*
* NAME
*    idToString()
*
* DESCRIPTION
*    Transform an identifier number into a string of 
*    characters.  The result will be only 5 bytes in size.
*    This is a wrapper around IDtoStr() in iffparse.library.
************************************************************
*
*/

PRIVATE char ids[10] = "";

PUBLIC STRPTR idToString( int identifier )
{
   STRPTR chk = NULL;

   ids[0] = '\0';
      
   if (GoodID( identifier ) != FALSE)
      chk = IDtoStr( identifier, &ids[0] );
   else
      {
      strncpy( ids, CMsg( MSG_IFF_BAD_ID, MSG_IFF_BAD_ID_STR ), 10 );

      chk = &ids[0];
      }

   return( chk );
}

/* -------------------- END of IFFFuncs.c file! ----------------------- */
