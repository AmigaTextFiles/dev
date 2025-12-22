/****h* AmigaTalk/Address.c [3.0] ************************************
*
* NAME
*    Address.c
*
* DESCRIPTION
*    Instead of using Integer Objects for AmigaOS structure addresses,
*    we will use these functions to interface addresses to AmigaTalk.
*    This means that Addresses are only internal Objects; there is
*    NO Class definition file for them.
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support
*    08-Dec-2003 - Created this file.
*
* NOTES
*    $VER: AmigaTalk:Src/Address.c 3.0 (24-Oct-2004) by J.T. Steichen
**********************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>
 
#include "object.h"
#include "FuncProtos.h"

#ifndef    AMIGATALKSTRUCTS_H
# include "ATStructs.h"
#endif

#include "Constants.h"

#include "StringConstants.h"

#include "CantHappen.h"

IMPORT int started;
IMPORT int ca_address;     // count address allocations

PRIVATE AT_ADDRESS *recycleAddressList  = NULL;
PRIVATE AT_ADDRESS *lastAllocdAddress   = NULL;
PRIVATE AT_ADDRESS *addressList         = NULL;

/* is_address() is located in Global.c 
**
** CheckObject() has been modified to account for Address Objects
** as well as Integers.
*/

/****i* addr_value() [3.0] *******************************************
*
* NAME
*    addr_value()
*
* DESCRIPTION
*    Return the Address contained in an Address Object.
**********************************************************************
*
*/

PUBLIC ULONG addr_value( OBJECT *obj )
{
   ULONG rval = 0; // NULL;
   
   if (objType( obj ) == MMF_ADDRESS)
      rval = (ULONG) ((AT_ADDRESS *) obj)->value;

   return( rval );
}

/****i* storeAddress() [3.0] *****************************************
*
* NAME
*    storeAddress()
*
* DESCRIPTION
*    Place an Address Object in a List structure.
**********************************************************************
*
*/

SUBFUNC void storeAddress( AT_ADDRESS *b, AT_ADDRESS **last, AT_ADDRESS **list )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last = b;
      *list = b;
      }
   else
      {
      (*last)->nextLink = b;
      }

   b->nextLink = NULL;

   *last = b; // Update the end of the List.
   
   return;       
}

/****i* findFreeAddress() [3.0] ****************************************
*
* NAME
*    findFreeAddress()
*
* DESCRIPTION
*    Find the first Address marked as unused in the recycleAddressList.
**********************************************************************
*
*/

SUBFUNC AT_ADDRESS *findFreeAddress( void )
{
   AT_ADDRESS *p    = recycleAddressList;
   AT_ADDRESS *rval = NULL;

   FBEGIN( printf( "findFreeAddress( void )\n" ) );   

   if (!p) // == NULL)
      goto exitFindFreeAddress;
         
   for ( ; p != NULL; p = p->nextLink)
      {
      if ((p->size & MMF_INUSE_MASK) == 0)
         {
         rval = p;
         
         break;
         }
      }

exitFindFreeAddress:

   FEND( printf( "0x%08LX = findFreeAddress()\n", rval ) );   

   return( rval );
}

/****i* recycleAddress() [3.0] *****************************************
*
* NAME
*    recycleAddress()
*
* DESCRIPTION
*    Mark an element in an Object List as being free to be re-used.
**********************************************************************
*
*/

PRIVATE BOOL firstRecycledAddress = TRUE;

SUBFUNC void recycleAddress( AT_ADDRESS *killMe )
{
   killMe->ref_count = 0;
   killMe->size      = MMF_ADDRESS | ADDRESS_SIZE; // Clear INUSE bit.
   killMe->value     = 0xDEADBEEF;
   
   if (firstRecycledAddress == TRUE)
      {
      firstRecycledAddress = FALSE;
      recycleAddressList   = killMe;
      }
           
   return;
}

// ---- PUBLIC functions: --------------------------------------------

/****h* freeVecAllAddresses() [3.0] **********************************
*
* NAME
*    freeVecAllAddresses()
*
* DESCRIPTION
*    FreeVec ALL Addresss for ShutDown().
**********************************************************************
*
*/

PUBLIC void freeVecAllAddresses( void )
{
   AT_ADDRESS *p    = addressList;
   AT_ADDRESS *next = NULL;
   
   while (p) // != NULL)
      {
      next = p->nextLink;

      AT_free( p, "AT_Address", TRUE );
      
      p = next;
      }

   return;
}

SUBFUNC AT_ADDRESS *allocAddress( void )
{
   AT_ADDRESS *rval = (AT_ADDRESS *) AT_calloc( 1, ADDRESS_SIZE, "AT_Address", TRUE );
   
   if (!rval) // == NULL)
      {
      fprintf( stderr, "Ran out of memory in allocAddress()!\n" );

      MemoryOut( "allocAddress()" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached.      
      }
      
   return( rval );
}

/****h* new_address() **********************************************
*
* NAME
*    new_address()
*
* DESCRIPTION
*    Create a new instance of class Address.
********************************************************************
*
*/

PUBLIC OBJECT *new_address( ULONG addr )
{   
   AT_ADDRESS *New = NULL;

   FBEGIN( printf( "new_address( addr = 0x%08LX )\n", addr ) );

   if (started == TRUE)
      {
      if ((New = findFreeAddress()) != NULL)
         goto setupNewAddress;
      }

   New = allocAddress();
   
   ca_address++;
   
setupNewAddress:

   New->ref_count   = 0;
   New->size        = MMF_INUSE_MASK | MMF_ADDRESS | ADDRESS_SIZE;
   New->value       = addr;
   New->nextLink    = NULL;

   storeAddress( New, &lastAllocdAddress, &addressList );

   FEND( printf( "0x%08LX = new_address()\n" ) );

   return( (OBJECT *) New );
}

/****h* free_address() *********************************************
*
* NAME
*    free_address()
*
* DESCRIPTION
*    Return an unused address to the address free list. 
********************************************************************
*
*/

PUBLIC void free_address( AT_ADDRESS *b )
{
   FBEGIN( printf( "void free_address( Address = 0x%08LX )\n", b ) );

   if (is_address( (OBJECT *) b ) == FALSE) 
      {
      fprintf( stderr, "free_address( 0x%08LX ) NOT an address!\n", b );
      
      cant_happen( WRONGOBJECT_FREED );         // Die, you abomination!!
      }
      
   recycleAddress( b );

   FEND( printf( "free_address() exits\n" ) );

   return;
}

/* -------------------- END of Address.c file! ------------------ */
