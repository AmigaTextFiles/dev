/****h* AmigaTalk/Array.c [3.0] ***************************************
*
* NAME
*    Array.c
* 
* DESCRIPTION
*    Array creation for the SmallTalk parts of the program.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *new_iarray( int size );
*    PUBLIC OBJECT *new_array( int size, int initial );
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*    30-Apr-2000 - No more minor changes needed in this file.
*
* NOTES
*    $VER: AmigaTalk:Src/Array.c 3.0 (24-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include "object.h"
#include "FuncProtos.h"

#include "CantHappen.h"

PUBLIC CLASS *Array             = (CLASS *) NULL;
PUBLIC CLASS *ArrayedCollection = (CLASS *) NULL;

IMPORT OBJECT *o_nil, *o_empty, *o_acollection;

IMPORT int started;      // gets set after reading std prelude

// new_iarray - internal form of new array.  Used in Array.c, Class.c

PUBLIC OBJECT *new_iarray( int size )
{
   OBJECT *NewAry = (OBJECT *) NULL;

   FBEGIN( printf( "new_iarray( %d )\n", size ) );
   
   if (size < 0) 
      {
      fprintf( stderr, "new_iarray( %d ) Less than zero!\n", size );
      
      cant_happen( ARRAYSIZE_ERR );  // Die, you abomination!!
      }

   if (!(NewAry = new_obj( Array, size, FALSE ))) // == NULL)
      {
      fprintf( stderr, "new_iarray( %d ) Ran out of memory!\n", size );
      
      cant_happen( NO_MEMORY );  // Die, you abomination!!
      }
      
   if (started == FALSE)         // No ArrayedCollection yet:
      {
      NewAry->super_obj = AssignObj( o_acollection );
      }
   else if (ArrayedCollection) // != NULL) // ArrayedCollection now exists:
      {
      NewAry->super_obj = AssignObj( new_inst( ArrayedCollection ) );
      }

   FEND( printf( "rval = 0x%08LX = new_iarray( %d )\n", NewAry, size ) );

   return( NewAry );
}

// new_array - create a new array:

PUBLIC OBJECT *new_array( int size, BOOL initialize )
{
   OBJECT *NewAry = (OBJECT *) NULL;
   int    i;

   FBEGIN( printf( "new_array( %d, BOOL = %d )\n", size, initialize ) );

   if (size == 0) 
      {
      FEND( printf( "o_empty = 0x%08LX = new_array()\n" ) );

      return( o_empty );
      }

   NewAry = new_iarray( size );

   if (initialize != FALSE) 
      {
      for (i = 0; i < size; i++)
         {
         NewAry->inst_var[i] = AssignObj( o_nil );
         }
      }

   FEND( printf( "0x%08LX = new_array()\n", NewAry ) );

   return( NewAry );
}

/* ----------------- END of Array.c file! ------------------------ */
