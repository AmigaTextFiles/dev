/****h* AmigaTalk/TagFuncs.c [3.0] ************************************
*
* NAME 
*   TagFuncs.c
*
* DESCRIPTION
*   Functions that handle Tags & Tag lists for AmigaTalk primitives.
*   These functions are called via primitive #210 in DTInterface.c
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC struct TagItem *ArrayToTagList( OBJECT *inArray );
*
*   PUBLIC void TagListToArray( struct TagItem *tags, OBJECT *tagArray );
*
*   PUBLIC void ATSetTagItem( OBJECT *theArray, OBJECT *theTag, 
*                             OBJECT *theValue 
*                           );
*
*   PUBLIC OBJECT *ATGetTagItem( OBJECT *theArray, OBJECT *theTag );
*
*   PUBLIC OBJECT *AddTagItem( OBJECT *theArray, OBJECT *theTag, 
*                              OBJECT *theValue 
*                            );
*
*   PUBLIC OBJECT *DeleteTagItem( OBJECT *theArray, OBJECT *theTag );
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    17-Nov-2003 - Changed ->size to objSize().
*
*    04-Jan-2003 - Moved all string constants to StringConstants.h
*
*    14-Nov-2002 - Added Object decoding to ArrayToTagList().
*
*    17-Mar-2002 - Killed a bug in ArrayToTagList() by adding sizeof( ULONG )
*                  to AllocVec().
*
*    02-Dec-2001 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/TagFuncs.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <utility/tagitem.h>

#ifdef __SASC

# include <clib/utility_protos.h>

#else

# define __USE_INLINE__

# include <proto/utility.h>

IMPORT struct Library      *UtilityBase;
IMPORT struct UtilityIFace *IUtility;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

// See Global.c for these: --------------------------------------------

IMPORT BOOL NullChk( OBJECT *testMe );

IMPORT UBYTE *UserPgmError;
IMPORT UBYTE *AllocProblem;

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

SUBFUNC OBJECT *grabObj( OBJECT *obj )
{
   ULONG i = (ULONG) int_value( (OBJECT *) obj ); // default decoding.

   FBEGIN( printf( "0x%08LX = grabObj( 0x%08LX )\n", i, obj ) );

   return( (OBJECT *) i );
}

SUBFUNC OBJECT *grabClass( OBJECT *obj )
{
   FBEGIN( printf( "0x%08LX = grabClass( 0x%08LX )\n", obj, obj ) );

   return( obj );
}

SUBFUNC OBJECT *grabByteArray( OBJECT *obj )
{
   OBJECT *rval = (OBJECT *) BYTE_VALUE( (BYTEARRAY *) obj ); 

   FBEGIN( printf( "0x%08LX = grabByteArray( 0x%08LX )\n", rval, obj ) );

   return( rval );
}

SUBFUNC OBJECT *grabSymbol( OBJECT *obj )
{
   OBJECT *rval = (OBJECT *) symbol_value( (SYMBOL *) obj );

   FBEGIN( printf( "%26.26s = grabSymbol( 0x%08LX )\n", rval, obj ) );

   return( rval );
}

SUBFUNC OBJECT *grabInterp( OBJECT *obj )
{
   FBEGIN( printf( "0x%08LX = grabInterp( 0x%08LX )\n", obj, obj ) );

   return( obj );
}

SUBFUNC OBJECT *grabProcess( OBJECT *obj )
{
   FBEGIN( printf( "0x%08LX = grabProcess( 0x%08LX )\n", obj, obj ) );

   return( obj );
}

SUBFUNC OBJECT *grabBlock( OBJECT *obj )
{
   FBEGIN( printf( "0x%08LX = grabBlock( 0x%08LX )\n", obj, obj ) );

   return( obj ); // ((BLOCK *) obj->interpreter);
}

SUBFUNC OBJECT *grabFile( OBJECT *obj )
{
   AT_FILE *x = (AT_FILE *) obj;
   
   FBEGIN( printf( "0x%08LX = grabFile( 0x%08LX )\n", x->fp, obj ) );

   return( (OBJECT *) x->fp );
}

SUBFUNC OBJECT *grabChar( OBJECT *obj )
{
   ULONG ch = (ULONG) char_value( (INTEGER *) obj );
   
   FBEGIN( printf( "$%c = grabChar( 0x%08LX )\n", (UBYTE) ch, obj ) );

   return( (OBJECT *) ch );
}

SUBFUNC OBJECT *grabInteger( OBJECT *obj )
{
   ULONG i = (ULONG) int_value( (INTEGER *) obj );
   
   FBEGIN( printf( "%d = grabInteger( 0x%08LX )\n", i, obj ) );

   return( (OBJECT *) i );
}

SUBFUNC OBJECT *grabString( OBJECT *obj )
{
   ULONG str = (ULONG) string_value( (STRING *) obj );

   FBEGIN( printf( "%s = grabString( 0x%08LX )\n", str, obj ) );

   return( (OBJECT *) str );
}

SUBFUNC OBJECT *grabFloat( OBJECT *obj )
{
   double f = float_value( (SFLOAT *) obj );

   FBEGIN( printf( "%f = grabFloat( 0x%08LX )\n", f, obj ) );

   return( o_nil ); // (OBJECT *) f );
}

SUBFUNC OBJECT *grabClassSpec( OBJECT *obj )
{
   FBEGIN( printf( "o_nil = 0x%08LX = grabClassSpec( 0x%08LX )\n", o_nil, obj ) );

   return( o_nil );
}

SUBFUNC OBJECT *grabClassEntry( OBJECT *obj )
{
   FBEGIN( printf( "o_nil = 0x%08LX = grabClassEntry( 0x%08LX )\n", o_nil, obj ) );

   return( o_nil );
}

SUBFUNC OBJECT *grabUnknown( OBJECT *obj )
{
   FBEGIN( printf( "o_nil = 0x%08LX = grabUnknown( 0x%08LX )\n", o_nil, obj ) );

   return( o_nil );
}

SUBFUNC OBJECT *grabAddress( OBJECT *obj )
{
   ULONG adr = (ULONG) addr_value( obj );

   FBEGIN( printf( "0x%08LX = grabAddress( 0x%08LX )\n", adr, obj ) );

   return( (OBJECT *) adr );
}


PUBLIC ULONG tagGrabbers[] = {

   (ULONG) &grabObj,       (ULONG) &grabClass,      (ULONG) &grabByteArray, (ULONG) &grabSymbol,
   (ULONG) &grabInterp,    (ULONG) &grabProcess,    (ULONG) &grabBlock,     (ULONG) &grabFile,
   (ULONG) &grabChar,      (ULONG) &grabInteger,    (ULONG) &grabString,    (ULONG) &grabFloat,
   (ULONG) &grabClassSpec, (ULONG) &grabClassEntry, (ULONG) &grabUnknown,   (ULONG) &grabAddress
};

/****i* ArrayToTagList() [2.2] ****************************************
*
* NAME
*    ArrayToTagList()
*
* DESCRIPTION
*    Convert a Little-Smalltalk array to an Amiga OS TagList.
***********************************************************************
*
*/

PUBLIC struct TagItem *ArrayToTagList( OBJECT *inArray )
{
   ULONG *tags = (ULONG *) NULL;
   int    i    = 0;

   if (is_array( inArray ) == FALSE)
      {
      sprintf( ErrMsg, TagCMsg( MSG_ARG_NOT_ARRAY_TAG ),
                       TagCMsg( MSG_ARRAY2TAGLIST_FUNC_TAG )
             );

      UserInfo( ErrMsg, UserPgmError );
      
      return( NULL );
      }
         
   if (objSize( inArray ) < 1) // one tag is probably wrong also!
      {
      sprintf( ErrMsg, TagCMsg( MSG_BAD_ARRAY_SIZE_TAG ), 
                       TagCMsg( MSG_ARRAY2TAGLIST_FUNC_TAG )
             );

      UserInfo( ErrMsg, UserPgmError );
      
      return( NULL );
      }
   else
      {
      tags = (ULONG *) AT_AllocVec( objSize( inArray ) * sizeof( ULONG ),
                                    MEMF_CLEAR | MEMF_ANY, "tagArray", TRUE 
                                  );
      
      if (!tags) // == NULL)
         {
         MemoryOut( TagCMsg( MSG_ARRAY2TAGLIST_FUNC_TAG ) );

         return( NULL );
         }
         
      for (i = 0; i < objSize( inArray ); i++)
         {
         OBJECT *x = inArray->inst_var[i];
         
         if ((x == o_nil) || (x == o_false)) // Goofy things a User might do.
            tags[i] = FALSE;
         else if (x == o_true)
            tags[i] = TRUE;
         else
            {
            tags[i] = (ULONG) 
                      ObjActionByType( x, (OBJECT * (**)( OBJECT * )) tagGrabbers );
            }
         }
      
      return( (struct TagItem *) tags );
      }   
}

/****i* TagListToArray() [1.8] ****************************************
*
* NAME
*    TagListToArray()
*
* DESCRIPTION
*    Convert an Amiga OS TagList to a Little-Smalltalk Array.
***********************************************************************
*
*/

PUBLIC void TagListToArray( struct TagItem *tags, OBJECT *tagArray )
{
   OBJECT *oldptr = o_nil;
   int     i;
   
   if (is_array( tagArray ) == FALSE)
      {
      sprintf( ErrMsg, TagCMsg( MSG_ARG_NOT_ARRAY_TAG ), 
                       TagCMsg( MSG_TAGLIST2ARRAY_FUNC_TAG )
             );

      UserInfo( ErrMsg, UserPgmError );
      
      return;
      }

   for (i = 0; i < objSize( tagArray ); i++)
      {
      /* obj_dec() might free() our OBJECT, so we have to save 
      ** the OBJECT pointer temporarily.
      */
      oldptr                = tagArray->inst_var[i];
      tagArray->inst_var[i] = AssignObj( new_int( (int) &tags[i] ) );

      obj_dec( oldptr ); // Now decrement.
      }

   return;
}

/****i* ATSetTagItem() [1.8] ******************************************
*
* NAME
*    ATSetTagItem()
*
* DESCRIPTION
*    Search for the theTag in theArray (which is really a Little
*    Smalltalk Array), & set it to theValue.
*    <primitive 210 32 self tag newTagValue> (see DTInterface.c also)
***********************************************************************
*
*/

PUBLIC void ATSetTagItem( OBJECT *theArray, 
                          OBJECT *theTag, 
                          OBJECT *theValue 
                        )
{
   OBJECT *oldptr = o_nil;
   
   if ((NullChk( theArray ) == TRUE) 
      || (NullChk( theTag ) == TRUE)
      || (NullChk( theValue ) == TRUE))
      { 
      return;
      }
   else
      {
      int i;
      
      for (i = 0; i < objSize( theArray ); i++)
         {
         if (int_value( theArray->inst_var[i] ) == int_value( theTag ))
            {
            i++; // point to ti_Data field.

            /* obj_dec() might free() our OBJECT, so we have to save 
            ** the OBJECT pointer temporarily.
            */
            oldptr                = theArray->inst_var[i];
            theArray->inst_var[i] = AssignObj( theValue ); // overwrite

            obj_dec( oldptr ); // Now decrement.
            }
         }
      }

   return;
}

/****i* ATGetTagItem() [1.8] ******************************************
*
* NAME
*    ATGetTagItem()
*
* DESCRIPTION
*    Search for the theTag in theArray (which is really a Little
*    Smalltalk Array), & return the ti_Data field of the Tag.
*    ^ <primitive 210 33 self tag> (see DTInterface.c also).
***********************************************************************
*
*/

PUBLIC OBJECT *ATGetTagItem( OBJECT *theArray, OBJECT *theTag )
{
   OBJECT *rval = o_nil;

   if (is_array( theArray ) == FALSE)
      {
      sprintf( ErrMsg, TagCMsg( MSG_ARG_NOT_ARRAY_TAG ), 
                       TagCMsg( MSG_ATGETTAGITEM_FUNC_TAG )
             );

      UserInfo( ErrMsg, UserPgmError );
      
      return( rval );
      }

   if ((NullChk( theArray ) == TRUE) // NullChk() in Global.c 
      || (NullChk( theTag ) == TRUE))
      { 
      return( rval );
      }
   else
      {
      struct TagItem *taglist = ArrayToTagList( theArray );
            
      if (taglist) // != NULL)
         {
         struct TagItem *item = FindTagItem( (ULONG) int_value( theTag ), taglist ); 
            
         rval = AssignObj( new_int( (int) item->ti_Data ) );
            
         AT_FreeVec( taglist, "tagArray", TRUE ); 
         }
      }

   return( rval );
}

/****i* AddTagItem() [1.8] ********************************************
*
* NAME
*    AddTagItem()
*
* DESCRIPTION
*    Add theTag & theValue to theArray.
*    ^ <primitive 210 34 self newTag newTagValue>
***********************************************************************
*
*/

PUBLIC OBJECT *AddTagItem( OBJECT *theArray, OBJECT *theTag, 
                           OBJECT *theValue 
                         )
{
   OBJECT *rval    = o_nil;
   int     newsize = 0;

   if (is_array( theArray ) == FALSE)
      {
      sprintf( ErrMsg, TagCMsg( MSG_ARG_NOT_ARRAY_TAG ), 
                       TagCMsg( MSG_ADDTAGITEM_FUNC_TAG )
             );

      UserInfo( ErrMsg, UserPgmError );
      
      return( NULL );
      }

   if ((NullChk( theArray ) == TRUE) 
      || (NullChk( theTag ) == TRUE)
      || (NullChk( theValue ) == TRUE))
      { 
      return( rval );
      }
   else
      {
      OBJECT *newArray = o_nil;
      int     i;
      
      newsize  = objSize( theArray ) + 2;
      newArray = AssignObj( new_array( newsize, FALSE ) );
      
      newArray->inst_var[0] = AssignObj( theTag );
      newArray->inst_var[1] = AssignObj( theValue );
      
      for (i = 2; i < newsize; i++)
         {
         newArray->inst_var[i] = AssignObj( theArray->inst_var[ i - 2 ] );
         }
      
      rval = newArray;

      // Help old array to die:
      for (i = 0; i < objSize( theArray ); i++)
         {
         obj_dec( theArray->inst_var[i] );
         }

      KillObject( theArray );
      }

   return( rval );
}

/****i* DeleteTagItem() [1.8] *****************************************
*
* NAME
*    DeleteTagItem()
*
* DESCRIPTION
*    Delete theTag (& its value) from theArray.
*    ^ <primitive 210 35 self theTag>
***********************************************************************
*
*/

PUBLIC OBJECT *DeleteTagItem( OBJECT *theArray, OBJECT *theTag )
{
   OBJECT *rval = o_nil;
     
   if (is_array( theArray ) == FALSE)
      {
      sprintf( ErrMsg, TagCMsg( MSG_ARG_NOT_ARRAY_TAG ),
                       TagCMsg( MSG_DELETETAGITEM_FUNC_TAG )
             );

      UserInfo( ErrMsg, UserPgmError );
      
      return( NULL );
      }

   if ((NullChk( theArray ) == TRUE) 
      || (NullChk( theTag ) == TRUE))
      { 
      return( rval );
      }
   else
      {
      OBJECT *newArray  = new_array( objSize( theArray ) - 2, FALSE );
      int     i, j, tag = int_value( theTag );
      
      for (i = 0, j = 0; i < objSize( theArray ); i++)
         {
         if (int_value( theArray->inst_var[i] ) == tag)
            {
            i += 2;
            }

         newArray->inst_var[j] = theArray->inst_var[i];
         
         obj_inc( newArray->inst_var[j] );
         
         j++;
         }

      // Help old array to die: 
      for (i = 0; i < objSize( theArray ); i++)
         obj_dec( theArray->inst_var[i] );
         
      KillObject( theArray );
      
      rval = newArray;
      }
      
   return( rval );
}

/* ----------------- END of TagFuncs.c file! -------------------- */
