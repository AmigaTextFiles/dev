/****h* AmigaTalk/ClDict.c [2.4] **************************************
*
* NAME
*   ClDict.c
*
* DESCRIPTION
*   Internal class dictionary
*
* HISTORY
*    09-Nov-2003 - Set up for better memory management support.
*
*    13-Mar-2003 - Added getClassDictionary() function for the 
*                  Delete Class function for the Browser code.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*   In order to facilitate lookup, classes are kept in an internal data
*   dictionary.  Classes are inserted into this dictionary using a
*   primitive, and are removed by either being overridden, or being
*   flushed at the end of execution.
*
*   $VER: AmigaTalk:Src/ClDict.c 2.4 (13-Mar-2003) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include <AmigaDOSErrs.h>

#ifdef __SASC

# include <clib/dos_protos.h>
# include <proto/locale.h>

#else

# define __USE_INLINE__

# include <proto/locale.h>
# include <proto/dos.h>

IMPORT struct Library  *DOSBase;

IMPORT struct DOSIFace     *IDOS;

#endif

# include <StringFunctions.h>

#include "ATStructs.h"

#include "object.h"

#include "FuncProtos.h"
#include "CantHappen.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

IMPORT int      started;
IMPORT int      ca_cdict; // In Global.c, where all good globals are.

IMPORT OBJECT  *o_nil, *o_true, *o_false;

IMPORT int      ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT  *ReturnError( void );
IMPORT OBJECT  *PrintArgTypeError( int primnumber );

/*  Moved to ATStructs.h file  (Ref only!)

PUBLIC struct class_entry {  // structure for internal dictionary:

   char               *className;
   OBJECT             *classObject;
   struct class_entry *nextLink;
   CLASS_SPEC         *specialObject;
};
*/

typedef struct class_entry CLDICT;

/* Class Entries have to have their own freeList because their structure
** is different from generic Objects.
*/

PRIVATE CLDICT  *lastAllocdClassEntry = NULL;
PRIVATE CLDICT  *class_dictionary     = NULL;

PRIVATE ULONG    allocatedCESize      = 0L;

// -----------------------------------------------------------------

SUBFUNC void *makeClassEntryPool( int poolSize )
{
   void *rval = NULL;

   FBEGIN( printf( "makeClassEntryPool( %d = size )\n", poolSize ) );

   if (poolSize == 0)   
      {
      poolSize = 25000 * CLASS_ENTRY_SIZE;
      }
   else if (poolSize % CLASS_ENTRY_SIZE != 0)
      {
      // Round poolSize to even CLASS_ENTRY_SIZE:
      int number = poolSize / CLASS_ENTRY_SIZE + 1;
      
      poolSize = number * CLASS_ENTRY_SIZE;
      }
      
   if ((rval = AT_AllocVec( (ULONG) poolSize, 
                            MEMF_CLEAR | MEMF_FAST,
                            "class_dictionary", TRUE ))) // != NULL)
      {
      class_dictionary = (CLDICT *) rval;

      allocatedCESize  = poolSize;
      }

   // NULL condition will be checked for in allocClassEntryPool().   

   FEND( printf( "0x%08LX = makeClassEntryPool()\n", rval ) );

   return( rval );
}

PUBLIC void *allocClassEntryPool( int poolSize )
{
   void *rval = class_dictionary;
   
   FBEGIN( printf( "allocClassEntryPool( size = %d )\n", poolSize ) );

   if (class_dictionary) // != NULL)
      goto exitAllocClassEntryPool;

   if (!(rval = makeClassEntryPool( poolSize ))) // == NULL)
      {
      fprintf( stderr, "allocClassEntryPool( %d ) ran out of memory!\n", poolSize );

      MemoryOut( "allocClassEntryPool()" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // never reached.
      }

   class_dictionary = rval;

exitAllocClassEntryPool:
   
   FEND( printf( "0x%08LX = allocClassEntryPool()\n", rval ) );
      
   return( rval );
}

/****i* freeVecDeadClassEntries() [2.5] ******************************
*
* NAME
*    freeVecDeadClassEntries()
*
* DESCRIPTION
*    Free the memory space of all ClassEntry items in the 
*    recycleClassEntryList.
**********************************************************************
*
*/

SUBFUNC int freeVecDeadClassEntries( CLDICT **recycledList, CLDICT **last )
{
   return( 0 );
}

SUBFUNC void storeClassEntry( CLDICT *c, CLDICT **last, CLDICT **list )
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

SUBFUNC CLDICT *allocClassEntry( void )
{
   CLDICT *New = (CLDICT *) NULL;

   FBEGIN( printf( "allocClassEntry( void )\n" ) );

   if ((ca_cdict + 1) * CLASS_ENTRY_SIZE > allocatedCESize)
      {
      // We're going to exceed the Pool size, so die instead:
      fprintf( stderr, "Ran out of memory in allocClassEntry()!\n" );
      
      MemoryOut( "allocClassEntry()" );

      cant_happen( NO_MEMORY );
      
      return( (CLDICT *) NULL ); // Never reached
      }
      
   if (lastAllocdClassEntry == NULL)
      {
      // the first Class Entry to get created:
      New                  = class_dictionary;
      New->nextLink        = 0; // NULL;
      lastAllocdClassEntry = New;
      }
   else
      {
      CLDICT *prev = lastAllocdClassEntry;
      
      while (prev->nextLink) // != NULL)
         prev = prev->nextLink; // Find the end of the list.

      New = ++prev;
      
      storeClassEntry( New, &lastAllocdClassEntry, &class_dictionary );
      }      

   FEND( printf( "0x%08LX = allocClassEntry()\n", New ) );

   return( New );
}

/****h* freeVecAllClassEntries() [2.5] *******************************
*
* NAME
*    freeVecAllClassEntries()
*
* DESCRIPTION
*    FreeVec the entire Class Dictionary list.
**********************************************************************
*
*/

PUBLIC void freeVecAllClassEntries( void )
{
   CLDICT *p    = class_dictionary;
   CLDICT *next = NULL;
   
   while (p) // != NULL)
      {
      next = p->nextLink;

      if (p->specialObject) // != NULL)
         {
         AT_free( p->specialObject, "Class_Spec", FALSE );
      
         p->specialObject = NULL;
         }

      p = next;
      }

   if (class_dictionary) // != NULL)
      {
      AT_FreeVec( class_dictionary, "class_dictionary", TRUE );
      
      class_dictionary = NULL;
      }
   
   return;
}

/****h* freeSlackClassEntryMemory() [2.5] ****************************
*
* NAME
*    freeSlackClassEntryMemory()
*
* DESCRIPTION
*    Get rid of ALL ClassEntry items in the recycleClassEntryList.
**********************************************************************
*
*/

PUBLIC int freeSlackClassEntryMemory( void )
{
   return( 0 );
}

/****h* getClassDictionary() [2.4] *********************************
*
* NAME
*    getClassDictionary()
*
* DESCRIPTION
*    Allow access to the internal class dictionary list.
********************************************************************
*
*/

PUBLIC struct class_entry *getClassDictionary( void )
{
   return( class_dictionary );
}

/*
struct spec_object  {

   int      ref_count;
   int      size;
   OBJECT  *class_name;     // Usually a Symbol OBJECT.
   OBJECT  *super_class;    // The Class that contains this struct.
   OBJECT  *nextLink;
   OBJECT  *myInstance;     // uniqueInstance value.
   int      flags;          // bit 0 == Initialized flag.

//# define SPF_INITIALIZED (1 << SPB_INITIALIZED)

   OBJECT  *reserved1;
   OBJECT  *reserved2;
};
*/

SUBFUNC CLASS_SPEC *allocClassSpec( void )
{
   CLASS_SPEC *rval = (CLASS_SPEC *) AT_calloc( 1, CLASS_SPEC_SIZE, 
                                                "Class_Spec", FALSE
                                              );

   FBEGIN( printf( "allocClassSpec( void )\n" ) );   

   if (!rval) // == NULL)
      {
      fprintf( stderr, "Ran out of memory in allocClassSpec()!\n" );

      MemoryOut( "allocClassSpec()" );

      cant_happen( NO_MEMORY );
      
      return( NULL ); // never reached. 
      }

   FEND( printf( "0x%08LX = allocClassSpec()\n", rval ) );      

   return( rval );
}

/****i* InitializeSpecial() [1.9] **********************************
*
* NAME
*    InitializeSpecial()
*
* DESCRIPTION
*    A special class specifier was found in the p.code.  Make a
*    special structure that can be found via primitives in the
*    Class Dictionary.
********************************************************************
*
*/

PRIVATE CLASS_SPEC *InitializeSpecial( OBJECT *super, char *typeStr )
{
   CLASS_SPEC *mySpecial = allocClassSpec();

   FBEGIN( printf( "InitializeSpecial( Obj = 0x%08LX, %s )\n", super, typeStr ) );

   mySpecial->super_class = super;
   mySpecial->ref_count   = 1;
   mySpecial->size        = MMF_CLASS_SPEC | MMF_INUSE_MASK | CLASS_SPEC_SIZE;
   mySpecial->myInstance  = o_nil;
   mySpecial->nextLink    = NULL;
   mySpecial->flags       = 0;           // clear all flags.

   if (!typeStr) // == NULL)
      mySpecial->class_name = (OBJECT *) new_sym( "Ordinary_Class" );
   else if (StringComp( typeStr, "isSingleton" ) == 0)
      mySpecial->class_name = (OBJECT *) new_sym( "Singleton_Class" );
   else
      mySpecial->class_name = (OBJECT *) new_sym( "Ordinary_Class" );

   FEND( printf( "0x%08LX = InitializeSpecial()\n", mySpecial ) );

   return( mySpecial );
}

SUBFUNC CLDICT *findClassEntry( char *name, OBJECT *description, OBJECT *special )
{
   CLDICT *p = (CLDICT *) NULL;

   FBEGIN( printf( "findClassEntry( %s, 0x%08LX, 0x%08LX )\n", name, description, special ));

   for (p = class_dictionary; p != NULL; p = p->nextLink)
      {
      if (StringComp( name, p->className ) == 0) 
         {
         p->classObject = AssignObj( description );
         
         if (NullChk( special ) == FALSE)
            {
            if (is_symbol( special ) == FALSE)
               {
               fprintf( stderr, "findClassEntry( 0x%08LX ) NOT a Symbol!\n", special );

               cant_happen( SPECIAL_NOT_SYMBOL );

               return( NULL ); // never reached!
               }
               
            if (StringComp( symbol_value( (SYMBOL *) special ), "isSingleton" ) == 0)
               {
               p->specialObject = InitializeSpecial( description, "isSingleton" );
               }
            else
               p->specialObject = InitializeSpecial( description, NULL ); // Ordinary class.
            }
         else
            p->specialObject = InitializeSpecial( description, NULL ); // Ordinary class.

         goto exitFindClassEntry;
         }
      }

exitFindClassEntry:

   FEND( printf( "0x%08LX = findClassEntry()\n", p ) );

   return( p );
}

/****h* enter_class() [1.5] ****************************************
*
* NAME
*    enter_class()
*
* DESCRIPTION
*    Enter a class into the internal class dictionary list.
********************************************************************
*
*/

PUBLIC void enter_class( char *name, OBJECT *description, OBJECT *special )
{   
   CLDICT *p = (CLDICT *) NULL;

   FBEGIN( printf( "void enter_class( %s, 0x%08LX, 0x%08LX )\n", name, description, special ) );

   if (class_dictionary) // != NULL) //  && (started == TRUE))
      {
      if ((p = findClassEntry( name, description, special )) != NULL)
         goto exitEnter_Class;
      }

   p = allocClassEntry(); // Handles class_dictionary linkage

   ca_cdict++;
    
   p->size        = MMF_INUSE_MASK | MMF_CLASS_ENTRY | CLASS_ENTRY_SIZE;
   p->className   = name;
   p->classObject = AssignObj( description );

   if (NullChk( special ) == FALSE)
      {
      if (is_symbol( special ) == FALSE)
         {
         fprintf( stderr, "findClassEntry( 0x%08LX ) NOT a Symbol!\n", special );

         cant_happen( SPECIAL_NOT_SYMBOL );

         return; // never reached!
         }
               
      if (StringComp( symbol_value( (SYMBOL *) special ), "isSingleton" ) == 0)
         p->specialObject = InitializeSpecial( description, "isSingleton" );
      else
         p->specialObject = InitializeSpecial( description, NULL ); // Ordinary class.
      }
   else
      p->specialObject = InitializeSpecial( description, NULL );

exitEnter_Class:

   FEND( printf( "enter_class() exits\n" ) );

   return;
}

/****h* FindClassTypeSymbol() [1.9] ********************************
*
* NAME
*    FindClassTypeSymbol()
*
* DESCRIPTION
*    Determine if the class is Ordinary_Class, Singleton_Class,
*    or something else.  This function is used by 
*    <primitive 250 4 0 classObject> (Reference System.c)
********************************************************************
*
*/

PUBLIC OBJECT *FindClassTypeSymbol( CLASS *classPtr )
{
   CLDICT *p    = (CLDICT *) NULL;
   OBJECT *rval = o_nil;
   char   *name = ((SYMBOL *) classPtr->class_name)->value;

   FBEGIN( printf( "FindClassTypeSymbol( CLASS * 0x%08LX )\n", classPtr ) );   

   for (p = class_dictionary; p != NULL; p = p->nextLink)
      {
      if (StringComp( name, p->className ) == 0)
         {
         if (!p->specialObject) // == NULL) 
            {
            // True for bootstrap classes Array & ArrayedCollection:
            rval = (OBJECT *) new_sym( "Ordinary_Class" );

            break;
            }
         else   
            {
            if (p->specialObject->class_name != o_nil)
               rval = p->specialObject->class_name;
            else
               rval = (OBJECT *) new_sym( "Ordinary_Class" );

            break;
            }
         }
      }

   FEND( printf( "0x%08LX = FindClassTypeSymbol()\n", rval ) );

   return( rval );
}

/****h* FindClassSpeciall() [1.9] **********************************
*
* NAME
*    FindClassSpecial()
*
* DESCRIPTION
*    Determine if the class is Ordinary_Class, Singleton_Class,
*    or something else.  This function is used by 
*    <primitive 250 4 1 className> (Reference System.c)
********************************************************************
*
*/

PUBLIC OBJECT *FindClassSpecial( char *className )
{
   CLDICT *p    = (CLDICT *) NULL;
   OBJECT *rval = o_nil;
   
   FBEGIN( printf( "FindClassSpecial( %s )\n", className ) );

   for (p = class_dictionary; p != NULL; p = p->nextLink)
      {
      if (StringComp( className, p->className ) == 0)
         {
         if (p->specialObject == NULL)
            break;
         else   
            {
            rval = (OBJECT *) p->specialObject;
            
            break;
            }
         }
      }

   FEND( printf( "0x%08LX = FindClassSpecial()\n", rval ) );

   return( rval );
}

/****h* GetClassTypeFlags() [1.9] **********************************
*
* NAME
*    GetClassTypeFlags()
*
* DESCRIPTION
*    Return the flags field from p->specialObject.
*    <primitive 250 4 2 classObject> (Reference System.c)
********************************************************************
*
*/

PUBLIC OBJECT *GetClassTypeFlags( CLASS *classPtr )
{
   CLDICT *p    = (CLDICT *) NULL;
   OBJECT *rval = o_nil;
   char   *name = ((SYMBOL *) classPtr->class_name)->value;

   FBEGIN( printf( "GetClassTypeFlags( CLASS * 0x%08LX )\n", classPtr ) );

   for (p = class_dictionary; p != NULL; p = p->nextLink)
      {
      if (StringComp( name, p->className ) == 0)
         {
         rval = new_int( p->specialObject->flags );
         
         break;
         }
      }

   FEND( printf( "0x%08LX = GetClassTypeFlags()\n", rval ) );

   return( rval );
}

/****h* GetInstanceVar() [1.9] *************************************
*
* NAME
*    GetInstanceVar()
*
* DESCRIPTION
*    Return the uniqueInstance instance variable from
*    p->specialObject->myInstance.
*    <primitive 250 4 3 classObject> (Reference System.c)
********************************************************************
*
*/

PUBLIC OBJECT *GetInstanceVar( CLASS *classPtr )
{
   CLDICT *p    = (CLDICT *) NULL;
   char   *name = ((SYMBOL *) classPtr->class_name)->value;

   for (p = class_dictionary; p != NULL; p = p->nextLink)
      {
      if (StringComp( name, p->className ) == 0)
         {
         if (!p->specialObject) // == NULL)
            return( o_nil );
         else   
            return( p->specialObject->myInstance );
         }
      }

   return( o_nil );
}

/****h* SetInstanceVar() [1.9] *************************************
*
* NAME
*    SetInstanceVar()
*
* DESCRIPTION
*    change the uniqueInstance instance variable from
*    p->specialObject->myInstance to a proper value.
*    <primitive 250 4 4 classObject newObject> (Reference System.c)
********************************************************************
*
*/

PUBLIC void SetInstanceVar( CLASS *classPtr, OBJECT *newObject )
{
   CLDICT *p    = (CLDICT *) NULL;
   char   *name = ((SYMBOL *) classPtr->class_name)->value;

   for (p = class_dictionary; p != NULL; p = p->nextLink)
      {
      if (StringComp( name, p->className ) == 0)
         {
         if (!p->specialObject) // == NULL)
            p->specialObject = InitializeSpecial( (OBJECT *) classPtr, NULL );
         
         p->specialObject->myInstance  = (OBJECT *) newObject;
         p->specialObject->flags      |= SPF_INITIALIZED;

         break;
         }
      }

   return;
}

/****h* lookup_class() [1.5] ***************************************
*
* NAME
*    lookup_class()
*
* DESCRIPTION
*    take a name and find the associated class object
*    classObject field actually points to a CLASS structure, 
*    not OBJECT!
********************************************************************
*
*/

PUBLIC CLASS *lookup_class( char *name )
{   
   CLDICT *p    = (CLDICT *) NULL;
   CLASS  *rval = (CLASS  *) NULL;
   BOOL    chk2 = FALSE;

   FBEGIN( printf( "lookup_class( %s )\n", name ) );   

   for (p = class_dictionary; p != NULL; p = p->nextLink)
      {
      // Since name was taken from a Symbol & should point to
      // p->className, because p->className was where the 
      // Symbol->value came from:

      if (name == p->className)  
         chk2 = TRUE; // return( (CLASS *) p->classObject );

      if (StringComp( name, p->className ) == 0)
         {
         rval = (CLASS *) p->classObject;
         
         break;
         }
      }

   FEND( printf( "0x%08LX = lookup_class()\n", rval ) );

   return( rval );
}

/****h* lookup_method() [1.5] **************************************
*
* NAME
*    lookup_method()
*
* DESCRIPTION
*    Take a name and find the associated Method object;
*    return a pointer to the bytearray that represents the 
*    method.
*
* TODO 
*    Figure out a way for send_mess() in Courier.c to use this 
*    function.
********************************************************************
*
*/

PUBLIC BYTEARRAY *lookup_method( CLASS *classptr, char *methodname )
{   
   OBJECT    *p    = (OBJECT *) classptr->message_names;
   OBJECT    *r    = (OBJECT *) classptr->methods;
   OBJECT    *temp = (OBJECT *) NULL;
   BYTEARRAY *rval = (BYTEARRAY *) NULL;
   
   int i;

   FBEGIN( printf( "lookup_method( CLASS * 0x%08LX, %s )\n", classptr, methodname ) );   

   for (i = 0; i < objSize( p ); i++) // p->size; i++)
      {
      if (StringComp( methodname, 
                      symbol_value( (SYMBOL *) p->inst_var[i] )) == 0)
         {
         temp = (OBJECT    *) r->inst_var[i];
         rval = (BYTEARRAY *) temp->inst_var[0];

         break;
         }
      }

   FEND( printf( "0x%08LX = lookup_method()\n", rval ) );

   return( rval );
}

PRIVATE FILE *outfile = NULL;

/****h* ListClassesToFile() [1.5] **********************************
*
* NAME
*    ListClassesToFile()
*
* DESCRIPTION
*    List all the subclasses of a class (RECURSIVELY),
*    indenting by a specified number of spaces, to a file.
* 
* WARNING
*    outfile MUST BE closed by the caller of ListClassesToFile(),
*    since it's a RECURSIVE function!
********************************************************************
*
*/
   
METHODFUNC int ListClassesToFile( CLASS *c, char *filename, int numspaces )
{
   CLDICT *p    = NULL;
   CLASS  *q    = NULL;
   char   *name = NULL;
   int     i;
    
   if (!outfile) // == NULL)  // Only open the file once!
      {
      if (!(outfile = fopen( filename, "w" ))) // == NULL)
         return( -1 );
      }

   if (is_symbol( c->class_name ) == FALSE)
      {
      fclose( outfile );

      return( -2 );
      }

   name = symbol_value( (SYMBOL *) c->class_name );

   for (i = 0; i < numspaces; i++)
      fputc( SPACE_CHAR, outfile );

   fputs( name, outfile );
   fputc( NEWLINE_CHAR, outfile );

   // now find all subclasses and print them out:
   for (p = class_dictionary; p != NULL; p = p->nextLink) 
      {
      q = (CLASS *) p->classObject;

      if (!q) // == NULL)
         goto skipCompare;
         
      if ((is_symbol( q->super_class ) == TRUE) && 
          (StringComp( name, symbol_value( (SYMBOL *) q->super_class ) ) == 0))

         ListClassesToFile( q, filename, numspaces + 1 ); //RECURSIVE!!!

skipCompare:
      ;

      }
   
   // outfile MUST be closed by the caller!

   return( 0 );
}

/****h* class_list() [1.5] *****************************************
*
* NAME
*    class_list()
*
* DESCRIPTION
*    List all the subclasses of a class (RECURSIVELY),
*    indenting by a specified number of tab stops.
********************************************************************
*
*/
   
PUBLIC void class_list( CLASS *c, int numtabs )
{   
   OBJECT *prs[2];
   CLDICT *p    = (CLDICT *) NULL;
   CLASS  *q    = (CLASS  *) NULL;
   char   *name = NULL;

   // first print out this class name:
   if (is_symbol( c->class_name ) ==FALSE)
      return;

   name   = symbol_value( (SYMBOL *) c->class_name );

   prs[0] = AssignObj( (OBJECT *) c->class_name );

   prs[1] = AssignObj( new_int( numtabs ) );

   (void) primitive( SYMPRINT, 2, prs );

   (void) obj_dec( prs[0] );
   (void) obj_dec( prs[1] );

   // now find all subclasses and print them out:
   for (p = class_dictionary; p != NULL; p = p->nextLink) 
      {
      q = (CLASS *) p->classObject;

      if (!q) // == NULL)
         goto skipRecurse;
          
      if ((is_symbol( q->super_class ) == TRUE) && 
          (StringComp( name, 
                       symbol_value( (SYMBOL *) q->super_class ) ) == 0))
         {
         class_list( q, numtabs + 1 ); //RECURSIVE!!!
         }

skipRecurse:
      ; 

      }

   return;
}

/****h* free_all_classes() [1.5] ***********************************
*
* NAME
*    free_all_classes()
*
* DESCRIPTION
*    Flush all references for the class dictionary list.
********************************************************************
*
*/

PUBLIC void free_all_classes( void )
{   
   CLDICT *p = (CLDICT *) NULL;

   for (p = class_dictionary; p != NULL; p = p->nextLink) 
      {
      if (p->specialObject != NULL)
         (void) obj_dec( (OBJECT *) p->specialObject );
         
      (void) obj_dec( p->classObject );
      }

   return;
}

/****h* WriteBrowserClassFile() [1.9] ******************************
*
* NAME
*    WriteBrowserClassFile()
*
* DESCRIPTION
*    List the Class tree for the given matches to whichDir, of a 
*    class (RECURSIVELY), indenting by a specified number of spaces,
*    to a file.
*    <primitive 137 0 2 'filename' 'whichDir' numSpaces>
*
* NOTES 
*    whichDir has one of the following values:
*      'AmigaTalk:General'
*      'AmigaTalk:Intuition'
*      'AmigaTalk:System'
*      'AmigaTalk:User'
* 
* WARNING
*    BCfile MUST BE closed by the caller of WriteBrowserClassFile(),
*    since it's a RECURSIVE function!
********************************************************************
*
*/

PRIVATE FILE *BCfile = NULL;
   
METHODFUNC int WriteBrowserClassFile( CLASS *c,
                                      char  *filename, 
                                      char  *whichDir,
                                      int    numspaces
                                    )
{
   CLDICT *p    = (CLDICT *) NULL;
   CLASS  *q    = (CLASS  *) NULL;
   char   *name = NULL;
   char   pt[512] = { 0, }, *path = &pt[0];
   char   fl[512] = { 0, }, *file = &fl[0];
   int     i;
    
   if (!BCfile) // == NULL)  // Only open the file once!
      {
      if (!(BCfile = fopen( filename, FILE_WRITE_STR ))) // == NULL)
         return( -1 );
      }

   StringCopy( path, symbol_value( (SYMBOL *) c->file_name ) );

   file = (char *) FilePart( path );
   path = GetPathName( path, symbol_value( (SYMBOL *) c->file_name ), 512 );

   if (is_symbol( c->class_name ) == FALSE)
      {
      fclose( BCfile );

      return( -2 );
      }

   name = symbol_value( (SYMBOL *) c->class_name );

   if (StringIComp( path, whichDir ) == 0)
      {
      for (i = 0; i < numspaces; i++)
         fputc( SPACE_CHAR, BCfile );
      
      if (!c->super_class) // == NULL)
         fprintf( BCfile, CLDCMsg( MSG_FMT_CD_OBJECT_CLDICT ), name, file ); // Root class is Object
      else
         fprintf( BCfile, "%s:%s:%s\n", name, file,
                          symbol_value( (SYMBOL *) c->super_class ) 
                );
      }

   // now find all subclasses and print them out:
   for (p = class_dictionary; p != NULL; p = p->nextLink) 
      {
      q = (CLASS *) p->classObject;

      if (!q) // == NULL)
         goto skipCompare;
         
      if ((is_symbol( q->super_class ) == TRUE) && 
          (StringComp( name, symbol_value( (SYMBOL *) q->super_class ) ) == 0))
         {
         if (WriteBrowserClassFile( q, filename, whichDir, numspaces + 1 ) < 0)
            return( -3 ); //RECURSIVE!!!
         }

skipCompare:
      ;

      }
   
   // BCfile MUST be closed by the caller!

   return( 0 );
}

// ---------------------------------------------------------------------

PRIVATE char iv[256] = { 0, }, *rval_iv = &iv[0];

SUBFUNC char *BuildInstVarString( OBJECT *vars )
{
   char *rval = NULL; 
   int   i = 0, size = 0;

   FBEGIN( printf( "BuildInstVarString( OBj = 0x%08LX )\n", vars ) );   

   rval_iv[0] = NIL_CHAR; // Reset in case this is a second call.
   
   if (NullChk( vars ) == TRUE)
      goto exitBuilder;

   size = objSize( vars ); // ->size;
   
   if (size > 0)
      StringCopy( rval_iv, symbol_value( (SYMBOL *) vars->inst_var[i++] ) );
   else
      goto exitBuilder;
      
   while (i < size)
      {
      StringCat( rval_iv, ONE_SPACE );
      StringCat( rval_iv, symbol_value( (SYMBOL *) vars->inst_var[i] ) );

      i++;
      }
                
   rval = &rval_iv[0];

exitBuilder:

   FEND( printf( "0x%08LX = BuildInstVarString()\n", rval ) );   

   return( rval );
}

/****h* WriteBrowserIVFile() [1.9] *********************************
*
* NAME
*    WriteBrowserIVFile()
*
* DESCRIPTION
*    List the Class tree & instance variables for the given matches
*    to whichDir, of a class (RECURSIVELY), to a file.
*
*    writeBrowserInstanceVarFile: whichDir to: fileName
*       ^ <primitive 137 0 3 'filename' 'whichDir'>
*
* NOTES 
*    whichDir has one of the following values:
*      'AmigaTalk:General'
*      'AmigaTalk:Intuition'
*      'AmigaTalk:System'
*      'AmigaTalk:User'
* 
* WARNING
*    BIfile MUST BE closed by the caller of WriteBrowserIVFile(),
*    since it's a RECURSIVE function!
********************************************************************
*
*/

PRIVATE FILE *BIfile = NULL;
   
METHODFUNC int WriteBrowserIVFile( CLASS *c, char  *filename, char  *whichDir )
{
   CLDICT *p    = (CLDICT *) NULL;
   CLASS  *q    = (CLASS  *) NULL;
   char   *name = NULL;
   char   pt[512] = { 0, }, *path = &pt[0];
   char   fl[512] = { 0, }, *file = &fl[0];

   FBEGIN( printf( "WriteBrowserIVFile( CLASS * 0x%08LX, %s, %s )\n", c, filename, whichDir));

   if (!BIfile) // == NULL)  // Only open the file once!
      {
      if (!(BIfile = fopen( filename, FILE_WRITE_STR ))) // == NULL)
         return( -1 );
      }

   StringCopy( path, symbol_value( (SYMBOL *) c->file_name ) );

   file = (char *) FilePart( path );
   path = GetPathName( path, symbol_value( (SYMBOL *) c->file_name ), 512 );

   if (is_symbol( c->class_name ) == FALSE)
      {
      fclose( BIfile );

      return( -2 );
      }

   name = symbol_value( (SYMBOL *) c->class_name );

   if (StringIComp( path, whichDir ) == 0)
      {
      char *instVars = BuildInstVarString( c->inst_vars );

      if (instVars) // != NULL)
         {   
         fprintf( BIfile, "%s |%s| :%s\n", name, instVars, 
                                   symbol_value( (SYMBOL *) c->super_class ) 
                );
         }
      }

   // now find all subclasses and print them out:
   for (p = class_dictionary; p != NULL; p = p->nextLink) 
      {
      q = (CLASS *) p->classObject;

      if (!q) // == NULL)
         goto skipCompare;
         
      if ((is_symbol( q->super_class ) == TRUE) && 
          (StringComp( name, symbol_value( (SYMBOL *) q->super_class ) ) == 0))
         {
         if (WriteBrowserIVFile( q, filename, whichDir ) < 0)
            return( -3 ); //RECURSIVE!!!
         }

skipCompare:
      ;

      }
   
   // BIfile MUST be closed by the caller!

   FEND( printf( "WriteBrowserIVFile() exits\n" ) );

   return( 0 );
}


/****h* HandleClassInfo() [1.9] ************************************
*
* NAME
*    HandleClassInfo()
*
* DESCRIPTION
*    Handle placing Class Information (from classes & the class
*    Dictionary) into various files.
*    ^ <primitive 137 xx xx Object option1 option2>
*
* NOTES
*    This primitive handler will be expanded later to take care of
*    the Browser files in AmigaTalk:Browser/
********************************************************************
*
*/

PUBLIC OBJECT *HandleClassInfo( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;

   FBEGIN( printf( "HandleClassInfo( %d, OBJ ** = 0x%08LX )\n", numargs, args ) );   

   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 137 );

      return( rval );
      }
   
   numargs--; // subtract off args[0] reference.
            
   switch (int_value( args[0] ))
      {
      case 0:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 137 );
         else
            {
            numargs--; // subtract off args[1] reference.
            
            switch (int_value( args[1] ))
               {
               case 0: // listClassDictionaryTo: fileName indent: numSpaces
                  if (ChkArgCount( 2, numargs, 137 ) != 0)
                     return( ReturnError() );
                  
                  if (!is_string( args[2] ) || !is_integer( args[3] ))
                     (void) PrintArgTypeError( 137 );
                  else
                     {
                     CLASS *Root = lookup_class( OBJECT_NAME );
                     int    chk  = 0;
                     
                     chk = ListClassesToFile(                          Root,
                                              string_value( (STRING *) args[2] ),
                                                 int_value(            args[3] )
                                            );

                     // ListClassesToFile() is recursive:
                     fclose( outfile );

                     outfile = NULL; // Reset for the next primitive call

                     if (chk == 0)
                        rval = o_true;
                     else 
                        rval = o_false;
                     }

                  break;

               case 1: // listClassesOf: classObj to: fileName indent: numSpaces
                  if (ChkArgCount( 3, numargs, 137 ) != 0)
                     return( ReturnError() );
                  
                  if (!is_string( args[3] ) || !is_integer( args[4] ))
                     (void) PrintArgTypeError( 137 );
                  else
                     {
                     int    chk = 0;
                     
                     chk = ListClassesToFile(                (CLASS *) args[2],
                                              string_value( (STRING *) args[3] ),
                                                 int_value(            args[4] )
                                            );
                     
                     // ListClassesToFile() is recursive:
                     fclose( outfile );
                     outfile = NULL; // Reset for the next primitive call

                     if (chk == 0)
                        rval = o_true;
                     else 
                        rval = o_false;
                     }

                  break;

               case 2: // writeBrowserClassFile: whichDir to: fileName indent: numSpaces
                  if (ChkArgCount( 3, numargs, 137 ) != 0)
                     return( ReturnError() );
                  
                  if (!is_string( args[2] ) || !is_string(  args[3] )
                                            || !is_integer( args[4] ))
                     (void) PrintArgTypeError( 137 );
                  else
                     {
                     CLASS *Root = lookup_class( OBJECT_NAME );
                     int    chk  = 0;
                     
                     chk = WriteBrowserClassFile(                          Root,
                                                  string_value( (STRING *) args[2] ),
                                                  string_value( (STRING *) args[3] ),
                                                     int_value(            args[4] )
                                                );

                     // WriteBrowserClassFile() is recursive:
                     fclose( BCfile );

                     BCfile = NULL; // Reset for the next primitive call

                     if (chk == 0)
                        rval = o_true;
                     else 
                        rval = o_false;
                     }

                  break;

               case 3: // writeBrowserInstanceVarFile: whichDir to: fileName
                  if (ChkArgCount( 2, numargs, 137 ) != 0)
                     return( ReturnError() );
                  
                  if (!is_string( args[2] ) || !is_string(  args[3] ))
                     (void) PrintArgTypeError( 137 );
                  else
                     {
                     CLASS *Root = lookup_class( OBJECT_NAME );
                     int    chk  = 0;
                     
                     chk = WriteBrowserIVFile(                          Root,
                                               string_value( (STRING *) args[2] ),
                                               string_value( (STRING *) args[3] )
                                             );

                     // WriteBrowserIVFile() is recursive:
                     fclose( BIfile );

                     BIfile = NULL; // Reset for the next primitive call

                     if (chk == 0)
                        rval = o_true;
                     else 
                        rval = o_false;
                     }

                  break;

               default:
                  break;
               }
            }

         break;
      
      default:
         break;
      }

   FEND( printf( "0x%08LX = HandleClassInfo()\n", rval ) );

   return( rval );
}

/* ------------------- END of ClDict.c file! --------------------- */
