/****h* AmigaTalk/ATStructs.h [1.6] *********************************
*
* NAME
*    ATStructs.h
*
* NOTES
*    All Smalltalk internal structures that were in separate 
*    files have been grouped into this file.
*********************************************************************
*
*/

#ifndef  AMIGATALKSTRUCTS_H
#define  AMIGATALKSTRUCTS_H   1

# ifndef  uchar
#  include "Env.h"
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

struct obj_struct {

   int                  ref_count;
   int                  size;
   struct class_struct *Class;
   struct obj_struct   *super_obj;
   struct obj_struct   *nextLink; // The last memory Mgmt struct!
   struct obj_struct   *reserved;
   struct obj_struct   *inst_var[2]; // default instances
};

typedef struct obj_struct OBJECT;


/****i* AmigaTalk/SDict *********************************************
*
* NOTES
*    System Dictionary structure (See SDict.c)
*********************************************************************
*
*/

struct SDict {

   FILE   *sd_File;
   UBYTE  *sd_FileName;
   ULONG   sd_NumEntries; // The number of lines in the File.dictionary
   UBYTE  *sd_Storage;    // Actually a SystemDictionary Object.
};

typedef struct SDict SDICT;

/****i* AmigaTalk/adr_struct ****************************************
*
* NOTES
*    Instead of using Integers for AmigaOS structure addresses,
*    we now use these:
*********************************************************************
*
*/

struct adr_struct {

   int                ref_count;
   int                size;
   ULONG              value;
   struct adr_struct *nextLink;
};

typedef struct adr_struct AT_ADDRESS;

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

struct spec_object  {

   int                 ref_count;
   int                 size;
   OBJECT             *class_name;     // Usually a Symbol OBJECT.
   OBJECT             *super_class;    // The Class that contains this struct.
   struct spec_object *nextLink;
   OBJECT             *myInstance;
   int                 flags;          // bit 0 == Initialized flag.
   OBJECT             *reserved1;
   OBJECT             *reserved2;
};

# define SPB_INITIALIZED 0

# define SPF_INITIALIZED (1 << SPB_INITIALIZED)

typedef struct spec_object CLASS_SPEC;

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

struct class_struct {

   int                  ref_count;
   int                  size;       // CLASSSIZE = 0xFFFFFFFF = -1
   OBJECT              *class_name; // Usually a Symbol OBJECT.
   OBJECT              *super_class;
   OBJECT              *file_name;
   OBJECT              *inst_vars;
   OBJECT              *message_names;
   OBJECT              *methods;
   int                  context_size;
   int                  stack_max;
   CLASS_SPEC          *class_special; // Added for Singleton support on 06-Jan-2002
   OBJECT              *classVars;     // Not used yet
   OBJECT              *reserved1;
   OBJECT              *reserved2;
   OBJECT              *reserved3;
   struct class_struct *nextLink;
};

typedef struct class_struct CLASS;

// string_struct is the structure for String Objects.

struct string_struct {

   int                   ref_count;
   int                   size;     // STRINGSIZE  = 0xFFFFFFF6 = -10
   char                 *value;
   OBJECT               *super_obj;
   OBJECT               *reserved1;
   struct string_struct *nextLink;
};

typedef struct string_struct STRING;

/****i* AmigaTalk/byte_struct *****************************************
*
* NOTES
*    byte_struct is the structure that is used for bytearray Objects. 
***********************************************************************
*
*/

struct byte_struct {

   int                 ref_count;
   int                 size;      // BYTEARRAYSIZE = 0xFFFFFFFE = -2
   int                 bsize;     // How many bytes are in the bytearray.
   UBYTE              *bytes;     // The actual bytearray.
   struct byte_struct *nextLink;
};

typedef struct byte_struct BYTEARRAY;

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

struct symbol_struct {

   int   ref_count;
   int   size;        // SYMBOLSIZE    = 0xFFFFFFFD = -3
   char *value;
   // struct symbol_struct *nextLink; // Not needed yet
};

typedef struct symbol_struct SYMBOL;

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

# ifndef  UBYTE
#  define UBYTE uchar // Use Little Smalltalk definition
# endif

# define STACK_MAX 16

struct interp_struct {

   int                   ref_count;
   int                   size;       // INTERPSIZE  = 0xFFFFFFFC = -4

   struct interp_struct *creator;
   struct interp_struct *sender;

   OBJECT               *bytecodes;
   OBJECT               *receiver;
   OBJECT               *literals;
   OBJECT               *context;
   UBYTE                *currentbyte;
   struct interp_struct *nextLink;

   OBJECT              **stacktop;
   ULONG                 stack[ STACK_MAX ]; // OBJECT *stack;
};

typedef struct interp_struct INTERPRETER;

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

struct  process_struct {

   int                    ref_count;
   int                    size;     // PROCSIZE = 0xFFFFFFFB = -5

   INTERPRETER           *interp;

   struct process_struct *prev;
   struct process_struct *next;

   int                    state;
   OBJECT                *reserved;
   struct process_struct *nextLink;
};

typedef struct process_struct PROCESS;


struct block_struct {
   
   int                  ref_count;
   int                  size;        // BLOCKSIZE   = 0xFFFFFFFA = -6
   INTERPRETER         *interpreter; // So a Block knows why it exists.
   int                  numargs;
   int                  arglocation;
   OBJECT              *tempVars;    // Currently unused.
   OBJECT              *reserved;
   struct block_struct *nextLink;    // Memory Mgmt support.
};

typedef struct block_struct BLOCK;


struct file_struct {            // FILESIZE    = 0xFFFFFFF9 = -7

   int                 ref_count;
   int                 size;
   int                 file_mode;
   FILE               *fp;
   struct file_struct *nextLink;
};

typedef struct file_struct file, AT_FILE;

struct int_struct { 
   
   int ref_count;
   int size;     // INTEGERSIZE = 0xFFFFFFF7 = -9
   int value; 
};

typedef struct int_struct INTEGER;

struct chr_struct { 
   
   int ref_count;
   int size;     // CHARSIZE    = 0xFFFFFFF6 = -10
   int value; 
};

typedef struct chr_struct CHARACTER;

struct float_struct {

   int                  ref_count;
   int                  size;   // FLOATSIZE   = 0xFFFFFFF5 = -11
   double               value;
   struct float_struct *nextLink;
};

typedef struct float_struct SFLOAT;


/****i* AmigaTalk/mem_struct *****************************************
* 
* NOTES
*     mstruct is used (via casts) to store linked lists of 
*     structures of various types for memory saving and recovering.
**********************************************************************
*
*/

struct mem_struct {

   struct mem_struct *mlink;
};

typedef struct mem_struct MSTRUCT;

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

PUBLIC struct class_entry {  

   int                 size;          // For the MMF_INUSE_MASK only.
   char               *className;
   OBJECT             *classObject;   // The return value.
   struct class_entry *nextLink;
   CLASS_SPEC         *specialObject; // int cl_pad;
};

typedef struct class_entry CLASS_ENTRY;

#endif

/* --------------- END of AmigaTalkStructs.h file! -------------------- */
