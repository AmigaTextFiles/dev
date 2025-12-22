/****h* AmigaTalk/ATStructs.hpp [3.0] *******************************
*
* NAME
*    ATStructs.hpp
*
* NOTES
*    All Smalltalk internal structures that were in separate 
*    files have been grouped into this file.
*********************************************************************
*
*/

#ifndef  AMIGATALKSTRUCTS_HPP
#define  AMIGATALKSTRUCTS_HPP   1

# ifndef    FILE
#  include <stdio.h>
# endif

# ifndef    UBYTE
#  include <exec/types.h>
# endif

# ifndef  uchar
#  define uchar UBYTE  // # include "Env.h"
# endif

# ifndef  "CONSTANTS_H"
#  include <constants.h>
# endif

/****i* AmigaTalk/obj_struct ****************************************
*
* NOTES
*     For objects, the inst_var array is actually made as large as
*     necessary (as large as the size field).  Since C does not do
*     subscript bounds checking, array indexing can be used.
*********************************************************************
*
*/

class CLASS;

class OBJECT {

public:    

   void obj_inc();
   int  obj_dec();
   
   int  objType( const OBJECT *o ) { return( o->size & MMF_BUILTIN_MASK ); };
   int  objSize( const OBJECT *o ) { return( o->size & MMF_MAX_OBJSIZE  ); };   

   BOOL NullChk( const void *o ) {};
    
private:
   
   int     ref_count;
   int     size;
   CLASS  *Class;
   OBJECT *super_obj;
   OBJECT *nextLink;    // The last memory Mgmt struct!
   OBJECT *reserved;
   OBJECT *inst_var[2]; // default instances
};

/****i* AmigaTalk/SDict *********************************************
*
* NOTES
*    System Dictionary structure (See SDict.c)
*********************************************************************
*
*/

class SDICT {
    
public:

   FILE   *sd_File;
   UBYTE  *sd_FileName;
   ULONG   sd_NumEntries; // The number of lines in the File.dictionary
   UBYTE  *sd_Storage;    // Actually a SystemDictionary Object.
};

/****i* AmigaTalk/adr_struct ****************************************
*
* NOTES
*    Instead of using Integers for AmigaOS structure addresses,
*    we now use these:
*********************************************************************
*
*/

class AT_ADDRESS {

public:

   int         ref_count;
   int         size;
   ULONG       value;
   AT_ADDRESS *nextLink;
};

/****i* AmigaTalk/spec_object ******************************************
*
* NAME 
*    struct spec_object {}
*
* DESCRIPTION
*    This structure points to special information used by enter_class()
*    that's used by <primitive 250 xx xx> to create Singleton classes.
*
* HISTORY
*    06-Jan-2002 - Created this structure.
*
* NOTES
*    SPECIALSIZE = 0xFFFFFFF4.
*
*    This might be expanded in the future to add dependencies, Pool
*    Dictionaries, or other advanced Smalltalk capabilities.
************************************************************************
*
*/

class CLASS_SPEC {
    
public:    

   int         ref_count;
   int         size;
   OBJECT     *class_name;     // Usually a Symbol OBJECT.
   OBJECT     *super_class;    // The Class that contains this struct.
   CLASS_SPEC *nextLink;
   OBJECT     *myInstance;
   int         flags;          // bit 0 == Initialized flag.
   OBJECT     *reserved1;
   OBJECT     *reserved2;
};

# define SPB_INITIALIZED 0

# define SPF_INITIALIZED (1 << SPB_INITIALIZED)

/****i *AmigaTalk/class_struct *****************************************
*
* NOTES
*    For classes:
*      c_size = CLASSSIZE = 0xFFFFFFFF
*
*      class_name and super_class are SYMBOLs,
*      containing the names of the class and superclass,
*      respectively.
*
*      c_inst_vars is an array of symbols, containing the
*      names of the instance variables.
*
*      context size is the size of the context that should be
*      created each time a message is sent to objects of this
*      class.
*
*      message_names is an array of symbols, corresponding
*      to the messages accepted by objects of this class.
*
*      methods is an array of arrays, each element being a
*      two element array of bytecodes and literals.
***********************************************************************
*
*/

class CLASS {

public:

   int         ref_count;
   int         size;       // CLASS_SIZE
   OBJECT     *class_name; // Usually a Symbol OBJECT.
   OBJECT     *super_class;
   OBJECT     *file_name;
   OBJECT     *inst_vars;
   OBJECT     *message_names;
   OBJECT     *methods;
   int         context_size;
   int         stack_max;
   CLASS_SPEC *class_special; // Added for Singleton support on 06-Jan-2002
   OBJECT     *classVars;     // Not used yet
   OBJECT     *reserved1;
   OBJECT     *reserved2;
   OBJECT     *reserved3;
   CLASS      *nextLink;
};

// string_struct is the structure for String Objects.

class STRING {

public:    

   int     ref_count;
   int     size;     // STRING_SIZE
   char   *value;
   OBJECT *super_obj;
   OBJECT *reserved1;
   STRING *nextLink;
};

/****i* AmigaTalk/byte_struct *****************************************
*
* NOTES
*    byte_struct is the structure that is used for bytearray Objects. 
***********************************************************************
*
*/

class BYTEARRAY {

   int        ref_count;
   int        size;      // BYTEARRAY_SIZE
   int        bsize;     // How many bytes are in the bytearray.
   UBYTE     *bytes;     // The actual bytearray.
   BYTEARRAY *nextLink;
};

/****i* AmigaTalk/symbol_struct ****************************************
*
* NOTES
*    For symbols,  y_size = SYMBOLSIZE
*
*    Only one text copy of each symbol is kept.
*    A global symbol table is searched each time a new symbol is
*    created, and symbols with the same character representation are
*    given the same entry.
*
************************************************************************
*
*/

class SYMBOL {

public:

   int   ref_count;
   int   size;        // SYMBOL_SIZE
   char *value;

   // SYMBOL *nextLink; // Not needed yet
};

/****i* AmigaTalk/interp_struct ****************************************
*
* NOTES
*    For interpreters:
*      t_size = INTERPSIZE = 0xFFFFFFFC (-4)
*       
*      creator is a pointer to the interpreter which created
*      the current interpreter.  It is zero except in the case 
*      of blocks, in which case it points to the creating
*      interpreter for a block.  It is NOT a reference, ie,
*      the ref_count field of the creator is not incremented when
*      this field is set - this avoids memory reference loops.
*
*      stacktop is a pointer to a pointer to an object, however it
*      is not considered a reference.  Changing stacktop does
*      not alter reference counts.
************************************************************************
*
*/

# define STACK_MAX 16

class INTERPRETER {

public:

   int           ref_count;
   int           size;       // INTERPRETER_SIZE

   INTERPRETER  *creator;
   INTERPRETER  *sender;

   OBJECT       *bytecodes;
   OBJECT       *receiver;
   OBJECT       *literals;
   OBJECT       *context;
   UBYTE        *currentbyte;
   INTERPRETER  *nextLink;

   OBJECT      **stacktop;
   ULONG         stack[ STACK_MAX ]; // OBJECT *stack;
};

/****i* AmigaTalk/process_struct **************************************
*
* NOTES
*    interp  = pointer to the head of the process' interpreter chain.
*    p_state = current state of the process.
*    next    = link to the next process in the active list.
*    prev    = link to the previous process in the active list.
***********************************************************************
*
*/

class PROCESS {

public:
   int          ref_count;
   int          size;     // PROCESS_SIZE

   INTERPRETER *interp;

   PROCESS     *prev;
   PROCESS     *next;

   int          state;
   OBJECT      *reserved;
   PROCESS     *nextLink;
};

class BLOCK {
    
public:
   
   int          ref_count;
   int          size;        // BLOCK_SIZE
   INTERPRETER *interpreter; // So a Block knows why it exists.
   int          numargs;
   int          arglocation;
   OBJECT      *tempVars;    // Currently unused.
   OBJECT      *reserved;
   BLOCK       *nextLink;    // Memory Mgmt support.
};

class AT_FILE {

public:    

   int      ref_count;
   int      size;
   int      file_mode;
   FILE    *fp;
   AT_FILE *nextLink;
};

class INTEGER : OBJECT {

public:   

   INTEGER *new_int( int newInt ) 
      
      { 
         INTEGER *i = new INTEGER;

         i->ref_count = 0;
         i->value     = newInt;
         i->size      = MMF_INUSE_MASK | MMF_INTEGER | INTEGER_SIZE;
      
         return( i );
      };
    
   void obj_inc( INTEGER *i ) { ::obj_inc( i ); };
   void obj_dec( INTEGER *i ) { ::obj_dec( i ); };

   int objSize( const INTEGER *i ) { ::objSize( i ); };
   int objType( const INTEGER *i ) { ::objType( i ); };

   int int_value( const INTEGER *i ) { return( i->value ); };

   BOOL is_integer( const INTEGER *i ) { if (::NullChk( i ) || i->size & MMF_INTEGER == 0)
                                            return( FALSE );
                                         else
                                            return( TRUE );
                                       };    
private:

   int ref_count;
   int size;     // INTEGER_SIZE
   int value; 
};

class CHARACTER {
    
public:
   
   int ref_count;
   int size;     // CHARACTER_SIZE
   int value; 
};

class SFLOAT {

public:
    
   int     ref_count;
   int     size;        // FLOAT_SIZE
   double  value;
   SFLOAT *nextLink;
};

/****i* AmigaTalk/mem_struct *****************************************
* 
* NOTES
*     mstruct is used (via casts) to store linked lists of 
*     structures of various types for memory saving and recovering.
**********************************************************************
*
*/

class MSTRUCT {

public:    

   struct mem_struct {

      struct mem_struct *mlink;
   };
};

/****h* AmigaTalk/class_entry ***************************************
*
* NAME
*    class_entry
*
* DESCRIPTION
*    structure for internal dictionary, declared in ClDict.c:
*********************************************************************
*
*/

class CLASS_ENTRY {

public:
    
   int          size;          // For the MMF_INUSE_MASK only.
   char        *className;
   OBJECT      *classObject;   // The return value.
   CLASS_ENTRY *nextLink;
   CLASS_SPEC  *specialObject; // int cl_pad;
};

#endif

/* --------------- END of AmigaTalkStructs.hpp file! -------------------- */
