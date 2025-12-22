/****h* AmigaTalk/Object.h [1.6] **********************************
* 
* NAME
*    Object.h
*
* DESCRIPTION
*    Smalltalk object definitions
*
* HISTORY
*    24-Feb-2000 - the is_????() macros were changed to functions
*                  for several reasons:
*
*    1. The Compiler will check for correct argument passing to 
*       functions (this cannot be done with a macro!)
*    2. The return type is clear & unambiguous.
*    3. Speed is not as important as being able to find bugs in
*       the source code.
*    4. My Amiga is fast enough to make up for the overhead.
*******************************************************************
*
*/

#ifndef  OBJECT_H
# define OBJECT_H 1

# ifndef CONSTANTS_H
#  include "Constants.h"
# endif

# ifndef EXEC_TYPES_H
#  include <exec/types.h>
# endif

# ifndef AMIGATALKSTRUCTS_H
#  include "ATStructs.h"
# endif 

# include "env.h"

// Built-in Classes have negative size values:

//                                 Old values:
# define CLASSSIZE        -1    // 0xFFFFFFFD = -3
# define BYTEARRAYSIZE    -2    // 0xFFFFFDC9 = -567
# define SYMBOLSIZE       -3    // 0xFFFFFFF2 = -14
# define INTERPSIZE       -4    // 0xFFFFFFF1 = -15
# define PROCSIZE         -5    // 0xFFFFFF9C = -100
# define BLOCKSIZE        -6    // 0xFFFFFFAD = -83
# define FILESIZE         -7    // 0xFFFFFFFB = -5
# define CHARSIZE         -8    // 0xFFFFFFDF = -33
# define INTEGERSIZE      -9    // 0xFFFFFFEF = -17
# define STRINGSIZE       -10   // 0xFFFFFEFE = -258
# define FLOATSIZE        -11   // 0xFFFF8549 = -31415


IMPORT OBJECT *new_sinst();   // an internal (system) version of new_inst

IMPORT OBJECT *o_nil;         // current value of pseudo variable nil
IMPORT OBJECT *o_true;        // current value of pseudo variable true
IMPORT OBJECT *o_false;       // current value of pseudo variable false
IMPORT OBJECT *o_smalltalk;   // current value of pseudo var smalltalk

IMPORT int     debug;         // debugging toggle switch.

/*************************************************************************
** objects with non-object value (classes, integers, etc) have a
** negative size field, the particular value being used to indicate
** the type of object (the class field cannot be used for this purpose
** since all classes, even those for built in objects, can be redefined
**
** The following classes are builtin
**
**    Block
**    ByteArray
**    Char 
**    Class
**    File
**    Float
**    Integer
**    Interpreter
**    Process
**    String
**    Symbol
**************************************************************************
*/

IMPORT int n_incs, n_decs;

/* reference count macro, used during debugging */

// # define rc(x) (((OBJECT *) x)->ref_count )

/*
   if INLINE is defined ( see env.h ) , inline code will be generated 
   for object increments.  inline code is generally faster, but
   larger than using subroutine calls for incs and decs

# ifdef INLINE

#  define obj_inc(x) (n_incs++, (x)->ref_count++)

IMPORT OBJECT *_dx;

#  define obj_dec(x) { n_decs++; if (-- ((_dx = x)->ref_count) <= 0) \
   ob_dec(_dx); }

# endif // INLINE

*/

#endif

/* -------------------- END of Object.h file! ------------------- */

