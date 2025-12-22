/****h* AmigaTalk/Class.c [3.0] *************************************
*
* NAME
*    Class.c
*
* DESCRIPTION
*    Class instance creation and deletion.
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    11-Nov-2003 - Cleaned out old commented-out code.
*
*    09-Nov-2003 - Set up for memory management support to be added.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
*    28-Apr-2000
*
* NOTES
*
*    $VER: AmigaTalk:Src/Class.c 3.0 (24-Oct-2004) by J.T. Steichen
*
* TODO
*    Add some Debugging code to these functions.
*********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include "ATStructs.h"

#include "object.h"
#include "file.h"
#include "FuncProtos.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CantHappen.h"

IMPORT BOOL STR_EQ( char *a, char *b ); // Global.c file.

IMPORT int started;
IMPORT int ca_class;                    // count class alloc's (Global.c)

IMPORT CLASS  *Array, *ArrayedCollection;

IMPORT OBJECT *o_object, *o_empty, *o_number, *o_magnitude;
IMPORT OBJECT *o_acollection, *o_smalltalk; 

// -------------------------------------------------------------------

//PRIVATE CLASS *lastRecycledClass = NULL;
PRIVATE CLASS *recycleClassList  = NULL;

PRIVATE CLASS *lastAllocdClass   = NULL;
PRIVATE CLASS *classList         = NULL;

/****i* freeVecDeadClasses() [3.0] ***********************************
*
* NAME
*    freeVecDeadClasses()
*
* DESCRIPTION
*    Free the memory space of all Class items in the
*    recycleClassList.
**********************************************************************
*
*/

SUBFUNC int freeVecDeadClasses( CLASS **recycledList, CLASS **last )
{
   CLASS *p       = *recycledList;
   CLASS *next    = (CLASS *) NULL;
   
   int    howMany = 0;
   
   while (p) // != NULL)
      {
      next = p->nextLink;
      
      if (p->size & MMF_INUSE_MASK == 0)
         howMany++;
         
      p = next;
      }
      
   return( howMany );
}

// Add a link to the classList:

SUBFUNC void storeClass( CLASS *c, CLASS **last, CLASS **list )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last = c;
      *list = c;
      }
   else
      {
      (*last)->nextLink = c;
      }

   c->nextLink = NULL;

   *last = c; // Update the end of the List.
   
   return;       
}

/****i* findFreeClass() [3.0] ****************************************
*
* NAME
*    findFreeClass()
*
* DESCRIPTION
*    Find the first Class marked as unused in the Class Object List.
**********************************************************************
*
*/

SUBFUNC CLASS *findFreeClass( void )
{
   CLASS *p    = recycleClassList;
   CLASS *rval = NULL;
   
   FBEGIN( printf( "findFreeClass( void )\n" ) );

   if (!p) // == NULL)
      goto exitFindFreeClass;
         
   for ( ; p != (CLASS *) NULL; p = p->nextLink)
      {
      if ((p->size & MMF_INUSE_MASK) == 0)
         {
         rval = p;

         break;
         }
      }
   
exitFindFreeClass:

   FEND( printf( "0x%08LX = findFreeClass()\n", rval ) );

   return( rval );
}

/****i* recycleClass() [3.0] *****************************************
*
* NAME
*    recycleClass()
*
* DESCRIPTION
*    Mark an element in an Object List as being free to be re-used.
**********************************************************************
*
*/

PRIVATE BOOL firstRecycledClass = TRUE;

PRIVATE void recycleClass( CLASS *killMe )
{
   FBEGIN( printf( "void recycleClass( 0x%08LX )\n", killMe ) );

   killMe->ref_count = 0;
   killMe->size      = MMF_CLASS | CLASS_SIZE; // ~MMF_INUSE_MASK; // Clear INUSE bit.

   if (firstRecycledClass == TRUE)
      {
      firstRecycledClass = FALSE;
      recycleClassList   = killMe;
      }
      
   FEND( printf( "recycleClass() exits\n" ) );      

   return;
}

/****h* freeVecAllClasses() [3.0] ************************************
*
* NAME
*    freeVecAllCLasses()
*
* DESCRIPTION
*    FreeVec the entire Class Object memory for ShutDown().
**********************************************************************
*
*/

PUBLIC void freeVecAllClasses( void )
{
   CLASS *p    = classList;
   CLASS *next = NULL;
   
   while (p) // != NULL)
      {
      next = p->nextLink;
      
      AT_free( p, "Class", FALSE );
      
      p = next;
      }

   return;
}

/****h* freeSlackClassMemory() [3.0] *********************************
*
* NAME
*    freeSlackClassMemory()
*
* DESCRIPTION
*    Get rid of ALL Class items in the recycleClassList.
**********************************************************************
*
*/

PUBLIC int freeSlackClassMemory( void )
{
   return( freeVecDeadClasses( &recycleClassList, NULL )); // &lastRecycledClass ));
}

// -------------------------------------------------------------------

SUBFUNC OBJECT *returnObjClass( OBJECT *obj )
{
   FBEGIN( printf( "0x%08LX = returnObjClass( 0x%08LX )\n", obj->Class, obj ) );

   return( (OBJECT *) obj->Class );
}

SUBFUNC OBJECT *returnClassClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Class" );

   FBEGIN( printf( "0x%08LX = returnClassClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnByteClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "ByteArray" );

   FBEGIN( printf( "0x%08LX = returnByteClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnSymbolClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Symbol" );

   FBEGIN( printf( "0x%08LX = returnSymbolClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnInterpClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Interp" );

   FBEGIN( printf( "0x%08LX = returnInterpClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnProcessClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Process" );

   FBEGIN( printf( "0x%08LX = returnProcessClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnBlockClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Block" );

   FBEGIN( printf( "0x%08LX = returnBlockClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnFileClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "File" );

   FBEGIN( printf( "0x%08LX = returnFileClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnCharClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Char" );

   FBEGIN( printf( "0x%08LX = returnCharClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnIntegerClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Integer" );

   FBEGIN( printf( "0x%08LX = returnIntegerClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnStringClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "String" );

   FBEGIN( printf( "0x%08LX = returnStringClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnFloatClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Float" );

   FBEGIN( printf( "0x%08LX = returnFloatClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnCSClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Special_Class" );

   FBEGIN( printf( "0x%08LX = returnCSClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnCEClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Class_Entry" );

   FBEGIN( printf( "0x%08LX = returnCEClass( 0x%08LX )\n", result, obj ) );
   
   return( (OBJECT *) result );
}

SUBFUNC OBJECT *returnSDictClass( OBJECT *obj )
{
   FBEGIN( printf( "nil = returnSDictClass( 0x%08LX )\n", obj ) );

   return( (OBJECT *) lookup_class( "UndefinedObject" ) );
}

/****i* returnAddressClass() [2.6] *******************************
*
* NAME
*    returnAddressClass()
*
* DESCRIPTION
*    Since Address is an Internal class only, we tell AmigaTalk 
*    that it's really supposed to be an Integer Object.
******************************************************************
*
*/

SUBFUNC OBJECT *returnAddressClass( OBJECT *obj )
{
   CLASS *result = lookup_class( "Integer" );
   
   FBEGIN( printf( "0x%08LX = returnAddressClass( 0x%08LX )\n", result, obj ) );

   return( (OBJECT *) result );
}

PRIVATE ULONG getClassName[] = {
    
   (ULONG) &returnObjClass,    (ULONG) &returnClassClass,   (ULONG) &returnByteClass,   (ULONG) &returnSymbolClass,
   (ULONG) &returnInterpClass, (ULONG) &returnProcessClass, (ULONG) &returnBlockClass,  (ULONG) &returnFileClass,
   (ULONG) &returnCharClass,   (ULONG) &returnIntegerClass, (ULONG) &returnStringClass, (ULONG) &returnFloatClass,
   (ULONG) &returnCSClass,     (ULONG) &returnCEClass,      (ULONG) &returnSDictClass,  (ULONG) &returnAddressClass
};

/****h* fnd_class() [1.5] ********************************************
*
* NAME
*    fnd_class()
*
* DESCRIPTION
*    Find the class of a special object
*
* NOTES
*    Moved from Object.c to this file (which makes more sense).
**********************************************************************
*
*/

#ifndef __amigaos4__
PUBLIC __far CLASS *fnd_class( OBJECT *anObject )
#else
PUBLIC CLASS *fnd_class( OBJECT *anObject )
#endif
{
   CLASS *result = NULL;

   FBEGIN( printf( "fnd_class( Obj = 0x%08LX )\n", anObject ) );

   result = (CLASS *) ObjActionByType( anObject, 
                                       (OBJECT * (**)( OBJECT *)) getClassName 
                                     );

   FEND( printf( "0x%08LX = fnd_class()\n", result ) );

   return( result );
}

SUBFUNC CLASS *allocClass( void )
{
   CLASS *rval = (CLASS *) AT_calloc( 1, CLASS_SIZE, "Class", FALSE );

   FBEGIN( printf( "0x%08LX = allocClass( void )\n", rval ) );   

   if (!rval) // == NULL)
      {
      fprintf( stderr, "Ran out of memory in allocClass()!\n" );
      
      MemoryOut( "allocClass()" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // never reached
      }

   FEND( printf( "allocClass() exits\n" ) );      

   return( rval );
}

/****h* new_class() [1.9] ******************************************
*
* NAME
*    new_class()
*
* DESCRIPTION
*    Add a class from the class array or Allocate one.
********************************************************************
*
*/

PUBLIC CLASS *new_class( void )
{
   CLASS *New = NULL;

   FBEGIN( printf( "new_class( void )\n" ) );

   if (started == TRUE)
      {
      if ((New = findFreeClass())) // != NULL)
         goto setupNewClass;
      }

   New = allocClass();

   ca_class++;
   
setupNewClass:

   New->ref_count     = 0;
   New->size          = MMF_INUSE_MASK | MMF_CLASS | CLASS_SIZE;
   New->super_class   = NULL;
   New->context_size  = 0;
   New->stack_max     = 4; // Default is > 0
   New->file_name     = AssignObj( o_nil );
   New->class_name    = AssignObj( o_nil );
   New->inst_vars     = AssignObj( o_nil );
   New->message_names = AssignObj( o_nil );
   New->methods       = AssignObj( o_nil );
   
   // Will be filled in by enter_class() in ClDict.c:
   New->class_special = NULL;

/*
   New->classVars     = NULL;
   New->reserved1     = NULL;
   New->reserved2     = NULL;
*/
   storeClass( New, &lastAllocdClass, &classList );

   FEND( printf( "0x%08LX = new_class()\n", New ) );      

   return( New );
}

/****i* resetBootStrapClass() [3.0] ****************************
*
* NAME
*    resetBootStrapClass()
*
* DESCRIPTION
*    Redefine a built-in Class.  This is for mk_class() only.
****************************************************************
*
*/

SUBFUNC void resetBootStrapClass( char *classname, CLASS *New )
{
   // These Classes get redefined by the standard prelude:
   if (STR_EQ( classname, ARRAY_NAME ) == TRUE) 
      {
      (void) obj_dec( (OBJECT *) Array );
      
      Array = (CLASS *) AssignObj( (OBJECT *) New );

      (void) obj_dec( o_empty );
      
      o_empty = AssignObj( new_iarray( 0 ) );
      }
   else if (STR_EQ( classname, ARRAYEDCOLL_NAME ) == TRUE) 
      {
      (void) obj_dec( (OBJECT *) ArrayedCollection );

      ArrayedCollection = (CLASS *) AssignObj( (OBJECT *) New );

      (void) obj_dec( o_acollection );
      (void) obj_dec( o_empty );
      
      o_acollection     = AssignObj( new_inst( New ) );
      o_empty           = AssignObj( new_iarray( 0 ) );
      }
   else if (STR_EQ( classname, FALSE_NAME ) == TRUE)
      {
      (void) obj_dec( o_false );
  
      o_false = AssignObj( new_inst( New ) );
      }
   else if (STR_EQ( classname, MAGNITUDE_NAME ) == TRUE)
      {
      (void) obj_dec( o_magnitude );
      
      o_magnitude = AssignObj( new_inst( New ) );
      }
   else if (STR_EQ( classname, NUMBER_NAME ) == TRUE)
      {
      (void) obj_dec( o_number );
      
      o_number = AssignObj( new_inst( New ) );
      }
   else if (STR_EQ( classname, OBJECT_NAME ) == TRUE) 
      {
      (void) obj_dec( o_object );
      
      o_object = AssignObj( new_inst( New ) );
      }
   else if (STR_EQ( classname, ATALK_NAME ) == TRUE)
      {
      (void) obj_dec( o_smalltalk );
      
      o_smalltalk = AssignObj( new_inst( New ) );
      }
   else if (STR_EQ( classname, TRUE_NAME ) == TRUE) 
      {
      (void) obj_dec( o_true );

      o_true = AssignObj( new_inst( New ) );
      }
   else if (STR_EQ( classname, UNDEFINED_NAME ) == TRUE)
      { 
      (void) obj_dec( o_nil );
      
      o_nil = AssignObj( new_inst( New ) );
      }

   return;
}

/****h* mk_class() [1.5] *******************************************
*
* NAME
*    mk_class()
*
* DESCRIPTION
*    Make a new Class or redefine a built-in Class.  This is for
*    primitive 97 (NewClass).
*      args[] are as follows:
*    
*      args[0] == classname.
*      args[1] == super_class.
*      args[2] == file_name.
*      args[3] == inst_vars array.
*      args[4] == message_names array.
*      args[5] == methods array.
*      args[6] == context_size.
*      args[7] == stack_max.    (Minimum > 0)
*
* NOTES
*    STR_EQ() is: return( strcmp( a, b ) == 0 ) in Global.c.
********************************************************************
*
*/

PUBLIC CLASS *mk_class( char *classname, OBJECT **args )
{
   CLASS  *New  = NULL;

   FBEGIN( printf( "mk_class( %s, args = 0x%08LX )\n", classname, args ) );

   New = new_class();

   (void) obj_dec( New->class_name    ); // o_nil decrement
   (void) obj_dec( New->file_name     ); // Get rid of o_nils
   (void) obj_dec( New->inst_vars     );
   (void) obj_dec( New->message_names );
   (void) obj_dec( New->methods       );

   New->class_name = AssignObj( args[0] );

   if (StringComp( classname, "Object" ) != 0) // OBJECT_NAME
      {
      // We're not Object, so we have a super_class:
      New->super_class = AssignObj( args[1] );
      }

   New->file_name     = AssignObj( args[2] );
   New->inst_vars     = AssignObj( args[3] );
   New->message_names = AssignObj( args[4] );
   New->methods       = AssignObj( args[5] );

   New->context_size  = int_value( args[6] );
   New->stack_max     = int_value( args[7] ) > 0 ? int_value( args[7] ) : 4;

   resetBootStrapClass( classname, New );

   FEND( printf( "0x%08LX = mk_class()\n", New ) );   

   return( New );
}

// These Classes do NOT have a new method:

PRIVATE BOOL Check_UnNew_Classes( char *cname )
{
   if ((STR_EQ(     cname, "Block"   ) == TRUE) 
        || (STR_EQ( cname, "Char"    ) == TRUE) 
        || (STR_EQ( cname, "Class"   ) == TRUE)
        || (STR_EQ( cname, "Float"   ) == TRUE)
        || (STR_EQ( cname, "Integer" ) == TRUE)
        || (STR_EQ( cname, "Process" ) == TRUE)
        || (STR_EQ( cname, "Symbol"  ) == TRUE))
      {
      return( TRUE );
      }
   else
      return( FALSE );
}

/****h* new_sinst() [1.5] ******************************************
*
* NAME
*    new_sinst()
*
* DESCRIPTION
*    Make a new Class instance with an explicit super Object.
********************************************************************
*
*/

PUBLIC OBJECT *new_sinst( CLASS *aclass, OBJECT *super )
{
   OBJECT *New       = NULL;
   char   *classname = NULL;
   char   buffer[80];

   FBEGIN( printf( "new_sinst( CLASS * 0x%08LX, super = 0x%08LX )\n", aclass, super ) );

   if (is_class( (OBJECT *) aclass ) == FALSE)
      {
      fprintf( stderr, "new_sinst( 0x%08LX ) NOT a Class!\n", aclass );

      cant_happen( MAKEINST_NONCLASS );   // Die, you abomination!!
      }

   classname = symbol_value( (SYMBOL *) aclass->class_name );

   if (Check_UnNew_Classes( classname ) == TRUE)
      {
      sprintf( buffer, ClassCMsg( MSG_FMT_CL_NO_NEW_CLASS ), classname );

      New = AssignObj( new_str( buffer ) );

      (void) primitive( ERRPRINT, 1, &New );
      (void) obj_dec( New );
      
      if (super) // != NULL) // get rid of unwanted object:
         {
         (void) obj_inc( super ); 
         (void) obj_dec( super );
         }

      New = o_nil;
      }
   else if (STR_EQ( classname, "File" ) == TRUE)
      {
      New = new_file();

      if (super) // != NULL) // get rid of unwanted object:
         {
         (void) obj_inc( super ); 
         (void) obj_dec( super );
         }
      }
   else if (STR_EQ( classname, "String" ) == TRUE) 
      {
      /*
      ** Since STRING & other OBJECT types have their super_obj pointers
      ** in different locations, we have to do some extra work to keep 
      ** the Compiler on the straight & narrow path (of producing 
      ** correct code):
      */
      STRING *NewStr = (STRING *) new_str( EMPTY_STRING );

      if (super) // != NULL)
         NewStr->super_obj = AssignObj( super );
      
      New = (OBJECT *) NewStr;
      }
   else 
      {
      New = new_obj( aclass, objSize( aclass->inst_vars ), TRUE );

      if (super) // != NULL)
         New->super_obj = AssignObj( super );
      }

   FEND( printf( "0x%08LX = new_sinst()\n", New ) );

   return( New );
}

/****h* new_inst() [1.5] *******************************************
*
* NAME
*    new_inst()
*
* DESCRIPTION
*    Make a new Class instance.
********************************************************************
*
*/

PUBLIC OBJECT *new_inst( CLASS *aclass )
{
   OBJECT *super         = NULL;
   OBJECT *sp_class_name = NULL;
   CLASS  *super_class   = NULL;
   OBJECT *rval          = NULL;
     
   FBEGIN( printf( "new_inst( CLASS * 0x%08LX )\n", aclass ) );

   if (is_class( (OBJECT *) aclass ) == FALSE)
      {
      fprintf( stderr, "new_inst( 0x%08LX ) NOT a Class!\n", aclass );

      cant_happen( MAKEINST_NONCLASS );              // Die, you abomination!!
      }

   if (aclass == o_object->Class)
      {
      FEND( printf( "o_object = 0x%08LX = new_inst()\n", o_object ) );
      
      return( o_object ); // We only want & need one of these!
      }

   super         = NULL;
   sp_class_name = aclass->super_class;

   if ((sp_class_name) && (is_symbol( sp_class_name ) == TRUE)) 
      {
      super_class = (CLASS *) 
                     lookup_class( symbol_value( (SYMBOL *) 
                                                  sp_class_name 
                                               )
                                 );

      if (super_class
          && (is_class( (OBJECT *) super_class ) == TRUE)) 
         { 
         super = new_inst( super_class );
         }
      }

   rval = new_sinst( aclass, super );
   
   FEND( printf( "0x%08LX = new_inst()\n", rval ) );   

   return( rval );
}

/****h* free_class() [1.5] *****************************************
*
* NAME
*    free_class()
*
* DESCRIPTION
*    Remove a class from the SmallTalk system & place its space
*    on the class free list.
********************************************************************
*
*/

PUBLIC int free_class( CLASS *c )
{
   FBEGIN( printf( "void free_class( CLASS * 0x%08LX )\n", c ) );

   if (is_class( (OBJECT *) c ) == FALSE)
      {
      fprintf( stderr, "free_class( 0x%08LX ) NOT a Class!\n", c );

      cant_happen( WRONGOBJECT_FREED );         // Die, you abomination!!    
      }
      
   (void) obj_dec( c->class_name ); // This is a Symbol

   if (c->super_class) // != NULL)
      (void) obj_dec( c->super_class ); // This is a Symbol
      
   (void) obj_dec( c->file_name     ); // This is a Symbol
   (void) obj_dec( c->inst_vars     );
   (void) obj_dec( c->message_names );
   (void) obj_dec( c->methods       );

   recycleClass( c );

   FEND( printf( "free_class() exits\n" ) );   

   return( 0 );
}

/* --------------- END of Class.c file! ----------------------- */
