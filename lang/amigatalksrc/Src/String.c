/****h* AmigaTalk/String.c [3.0] ***********************************
*
* NAME
*    String.c
*
* DESCRIPTION
*    string creation and deletion
*
* NOTES
*    $VER: AmigaTalk:Src/String.c 3.0 (25-Oct-2004) by J.T. Steichen
********************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include "ATStructs.h"

#include "object.h"

#include "FuncProtos.h"
#include "Constants.h"
#include "CantHappen.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT int started; // Needed for boostrapping purposes.
IMPORT int ca_str;  // In Global.c where all good globals are.
IMPORT int ca_wal;
IMPORT int ca_walSize;
//IMPORT int wtop;

//PRIVATE char wtable[ WALLOCINITSIZE ] = { 0, };

IMPORT CLASS  *ArrayedCollection;
IMPORT OBJECT *o_acollection;

PRIVATE STRING *lastRecycledString = NULL;
PRIVATE STRING *recycleStringList  = NULL;

PRIVATE STRING *lastAllocdString   = NULL;
PRIVATE STRING *stringList         = NULL;

/****h* walloc() [1.5] ***********************************************
*
* NAME
*    walloc()
*
* DESCRIPTION
*    Allocate a string containing the same chars as the arg
**********************************************************************
*
*/

PUBLIC char *walloc( char *val, int size )
{
   char *p = NULL, *ch = NULL, *start = NULL;

   if (!(p = (char *) AT_calloc( 1, size * sizeof( UBYTE ), "wallocString", FALSE ))) // == NULL)
      {
      // Something different will have to be done here:
      MemoryOut( "walloc()" );
      
      fprintf( stderr, "Ran out of memory in walloc()!\n" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached
      } 

   ca_wal++;
   ca_walSize += size;

   start = p; // Save the start of the byte string.
   
   for (ch = val; size > 0; size--)
      *p++ = *ch++; // Copy val into our allocation
      
   return( start );
}

// -------------------------------------------------------------------

SUBFUNC void freeVecString( STRING *killMe )
{
   STRING *prev = recycleStringList;
   STRING *next = killMe->nextLink;

   /* Dead Strings have no value contents, so we do not have to
   ** FreeVec( killMe->value ) as well.
   */

   if (killMe == prev)
      {
      recycleStringList = next;
      
      AT_free( killMe, "String", FALSE ); // Remove the first item in the List.
      
      return;
      }

   while (prev->nextLink != killMe)
      prev = prev->nextLink;       // Find the previous item.

   if (killMe == lastRecycledString && prev) // != NULL)
      {
      lastRecycledString = prev; // Chop off the tail.
      prev->nextLink     = NULL;
      }      
   else
      prev->nextLink = next; // Disconnect killMe from the list.

   AT_free( killMe, "String", FALSE );
   
   return;
}

/****i* freeVecDeadStrings() [3.0] ******************************
*
* NAME
*    freeVecDeadStrings()
*
* DESCRIPTION
*    Get rid of ALL Strings in the recycleStringList.
**********************************************************************
*
*/

SUBFUNC int freeVecDeadStrings( STRING **recycledList, STRING **last )
{
   STRING *p       = *recycledList;
   STRING *next    =  NULL;
   int     howMany =  0;
   
   while (p) // != NULL)
      {
      next = p->nextLink;
      
      freeVecString( p );

      howMany++;
         
      p = next;
      }

   *recycledList = NULL;
   *last         = NULL;
            
   return( howMany );
}

SUBFUNC void storeString( STRING *i, STRING **last, STRING **list )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last = i;
      *list = i;
      }
   else
      {
      (*last)->nextLink = i;
      }

   i->nextLink = NULL;

   *last = i; // Update the end of the List.
   
   return;       
}

SUBFUNC void removeFromStringList( STRING *killMe, STRING **list, STRING **last )
{
   STRING *prev = *list;
   STRING *next =  killMe->nextLink;

   if (killMe == prev)
      {
      *list = next;
      
      return;
      }

   while (prev->nextLink != killMe)
      prev = prev->nextLink;       // Find the previous item.

   if (killMe == *last && prev) // != NULL)
      {
      *last           = prev; // Chop off the tail.
       prev->nextLink = NULL;
      }
   else
      prev->nextLink = next; // Disconnect killMe from the list.

   return;
}

/****i* findFreeString() [3.0] **********************************
*
* NAME
*    findFreeString()
*
* DESCRIPTION
*    See if there are any unused Strings in the recycleStringList.
**********************************************************************
*
*/

SUBFUNC STRING *findFreeString( void )
{
   STRING *p = recycleStringList;

   FBEGIN( printf( "findFreeString( void )\n" ) );

   if (!p) // == NULL)
      goto exitFinder;
         
   for ( ; p != NULL; p = p->nextLink)
      {
      if ((p->size & MMF_INUSE_MASK) == 0)
         {
         removeFromStringList( p, &recycleStringList, &lastRecycledString );
         
         break; //return( p );
         }
      }

exitFinder:

   FEND( printf( "0x%08LX = findFreeString() exits\n", p ) );   

   return( p );
}
         
/****i* recycleString() [3.0] ***********************************
*
* NAME
*    recycleString()
*
* DESCRIPTION
*    Mark an String as unused in the stringList.
**********************************************************************
*
*/

SUBFUNC void recycleString( STRING *killMe )
{
   FBEGIN( printf( "recycleString( 0x%08LX )\n", killMe ) );

   removeFromStringList( killMe, &stringList, &lastAllocdString );
   
   killMe->size &= ~MMF_INUSE_MASK; // Clear INUSE bit.

   if (killMe->value) // != NULL)
      {
      AT_free( killMe->value, "wallocString", FALSE );
         
      killMe->value = NULL;
      }

   storeString( killMe, &lastRecycledString, &recycleStringList );

   FEND( printf( "recycleString() exits\n" ) );                     

   return;
}

/****h* freeSlackStringMemory() [3.0] ******************************
*
* NAME
*    freeSlackStringMemory()
*
* DESCRIPTION
*    Get rid of all Strings in the recycleStringList.
********************************************************************
*
*/

PUBLIC int freeSlackStringMemory( void )
{
   return( freeVecDeadStrings( &recycleStringList, &lastRecycledString ) );
}

/****h* freeVecAllStrings() [3.0] ************************************
*
* NAME
*    freeVecAllStrings()
*
* DESCRIPTION
*    FreeVec ALL Strings for ShutDown().
**********************************************************************
*
*/

PUBLIC void freeVecAllStrings( void )
{
   STRING *p    = stringList;
   STRING *next = NULL;
      
   while (p) // != NULL)
      {
      next = p->nextLink;

      if (p->value) // != NULL)
         {
         AT_free( p->value, "wallocString", FALSE );
         } 
              
      AT_free( p, "String", FALSE );
      
      p = next;
      }

   p = recycleStringList;
   
   while (p) // != NULL)
      {
      next = p->nextLink;

      if (p->value) // != NULL)
         {
         AT_free( p->value, "wallocString", FALSE );
         } 
              
      AT_free( p, "String", FALSE );
      
      p = next;
      }

   return;
}

/*---------------------------------------*/

//PRIVATE MSTRUCT *fr_string = NULL;

//typedef struct string_struct BOZO;

//PRIVATE BOZO st_Init_Table[ STRINITSIZE ] = { { 0, 0, NULL, NULL }, };

/****h* str_init() [1.5] *********************************************
*
* NAME
*    str_init()
*
* DESCRIPTION
*    Initialize the internal starting memory space st_Init_Table.
**********************************************************************
*
*/

PUBLIC void str_init( void )
{
   return;
}

IMPORT int started;

/****i* new_rstr() [1.5] *********************************************
*
* NAME
*    new_rstr()
*
* DESCRIPTION
*    Make a new real String space.
**********************************************************************
*
*/

PRIVATE void new_rstr( STRING *New )
{
   New->ref_count = 0;
   New->size      = MMF_INUSE_MASK | MMF_STRING | STRING_SIZE; // STRINGSIZE;
   
   if (started == FALSE)
      New->super_obj = AssignObj( o_acollection );
   else if (ArrayedCollection) // != NULL)
      New->super_obj = AssignObj( new_inst( ArrayedCollection ) );
   else
      New->super_obj = NULL;

   return;
}

SUBFUNC STRING *allocString( void )
{
   STRING *rval = (STRING *) AT_calloc( 1, STRING_SIZE, "String", FALSE );

   FBEGIN( printf( "allocString( void )\n" ) );   

   if (!rval) // == NULL)
      {
      MemoryOut( "allocString()" );
      
      fprintf( stderr, "Ran out of memory in allocString()!\n" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // never reached.
      }

   FEND( printf( "0x%08LX = allocString() exits\n", rval ) );      

   return( rval );
}

/****h* new_istr() [1.5] *********************************************
*
* NAME
*    new_istr()
*
* DESCRIPTION
*
**********************************************************************
*
*/

PUBLIC STRING *new_istr( char *text )
{
   STRING *New = allocString();

   FBEGIN( printf( "new_istr( %s )\n", text ) );

   ca_str++;

   New->value = text;
   
   new_rstr( New ); // Setup the rest of the structure

   FEND( printf( "0x%08LX = new_istr()\n", New ) );

   return( New );
}

/****h* new_str() [1.5] **********************************************
*
* NAME
*    new_str()
*
* DESCRIPTION
*    Make a new string Object with the given text.
**********************************************************************
*
*/

PUBLIC OBJECT *new_str( char *text )
{
   STRING *New  = NULL;

   FBEGIN( printf( "new_str( %s )\n", text ) );

   if (started == TRUE)
      {
      if ((New = findFreeString())) // != NULL)
         {
         New->value     = walloc( text, strlen( text ) + 1 );
         New->nextLink  = NULL;
         New->ref_count = 0;
         New->size      = MMF_INUSE_MASK | MMF_STRING | STRING_SIZE;

         goto setupNewString;   
         }
      }

   New = (STRING *) new_istr( walloc( text, strlen( text ) + 1 ) );

setupNewString:

   storeString( New, &lastAllocdString, &stringList );

   FEND( printf( "0x%08LX = new_str()\n", New ) );

   return( (OBJECT *) New );
}

/****h* free_string() [1.5] ******************************************
*
* NAME
*    free_string()
*
* DESCRIPTION
*
**********************************************************************
*
*/

PUBLIC void free_string( STRING *s )
{
   IMPORT struct Window *ATWnd;

   FBEGIN( printf( "void free_string( 0x%08LX )\n", s ) );      

   if (!s) // == NULL)
      {
      if (ATWnd) // != NULL)
         {
         if (NullFound( StrCMsg( MSG_FREE_FUNC_STRING ) ) == FALSE)
            ShutDown();
         else
            return; 
         }
      }

   if (s->super_obj) // != NULL)
      (void) obj_dec( s->super_obj );

   recycleString( s );

   FEND( printf( "free_string() exits\n" ) );

   return;
}

/* ---------------- END of String.c file! ------------------------ */
