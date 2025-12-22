/****h* AmigaTalk/PrimFuncs.c [3.0] ***********************************
*
* NAME
*   PrimFuncs.c
*
* DESCRIPTION
*    The primitive function has been changed to call primitives via 
*    an array of function pointers returning object *.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    22-Nov-2003 - Added array bounds checking to ObjectAt() & 
*                  ObjectAtPut() functions.
*
*    16-Nov-2003 - Removed a call to o_alloc() in <103> & replaced it
*                  with calloc().
*
*    04-Sep-2003 - Added FileClose() <139> function.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
*    18-Nov-2002 - Added BlockNumArgs( <144> ).
*
*    01-Mar-2002 - Added miscFlag check to fprnt_radix() so that
*                  unsigned values can be displayed as such.
*
*    27-Jan-2002 - Added HandleClassInfo() (which is in ClDict.c) as
*                  primitive 137.
*
*    04-Feb-2001 - Added TraceFile stuff.
*
* WARNINGS
*    Primitive 103 has a memory allocation function in it!
*
* NOTES
*    Primitves 0, 27, 31, 40, 41, 48, 49, 74, 83, 87, 90, 95,
*              147, 166-168  are not used
*
*    Functions for primitives 168-179 are in PlotFuncs.c file.
*
*    $VER: AmigaTalk:Src/PrimFuncs.c 3.0 (25-Oct-2004) by J.T Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <errno.h>
#include <time.h> // for the time() proto

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <graphics/gfxmacros.h> // DrawCircle() & SetDrPt(), etc.

#ifndef __amigaos4__
# include <clib/intuition_protos.h>
#else

# define __USE_INLINE__
# include <proto/intuition.h>

#endif

#include "Env.h"

#ifdef CURSES
# include <curses.h>    // Needs more primitive support.
#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "object.h"
#include "drive.h"
#include "file.h"

#include "Constants.h"
#include "FuncProtos.h"
#include "PFProtos.h"      // for PlotClear() only.
#include "CantHappen.h"

#include "StringConstants.h"
#include "StringIndexes.h"

// --------- Stuff from Global.c file: ------------------------------ 

IMPORT int debug;

//IMPORT UBYTE *DefaultButtons;
IMPORT UBYTE *ErrMsg;

IMPORT int cant_happen( int );
IMPORT int ChkArgCount( int need, int numargs, int primnumber );

IMPORT BOOL  traceByteCodes;
IMPORT int   TraceIndent;
IMPORT FILE *TraceFile;

IMPORT char  outmsg[]; // For APrint() calls.

// ------------------------------------------------------------------

IMPORT double  modf();
IMPORT char    *ctime();

IMPORT int      errno;
IMPORT int      prntcmd;

IMPORT PROCESS *runningProcess;

IMPORT OBJECT  *o_object, *o_true, *o_false;
IMPORT OBJECT  *o_nil, *o_number, *o_magnitude;

#ifndef  TRUE
# define  TRUE  1
# define  FALSE 0
#endif

/* Globals used by the functions, defined in Primitive.c file: */

IMPORT struct file_struct *phil;

IMPORT OBJECT    *resultobj;
IMPORT OBJECT    *leftarg;
IMPORT OBJECT    *rightarg;

IMPORT int        leftint, rightint; // args[0] & args[1]
IMPORT int        i, j;              // also args[2] & args[3]

IMPORT BOOL       miscFlag;          // Used by primitive 26.
IMPORT BOOL       needRadix;         // Used by primitive 26.

IMPORT double     leftfloat, rightfloat;
IMPORT long       myClock;

IMPORT char      *leftp;             // args[0] == string
IMPORT char      *rightp;            // args[1] == string

IMPORT char      *errp;

IMPORT CLASS     *aClass;
IMPORT BYTEARRAY *byarray;

IMPORT char       strbuffer[], tempname[];

PRIVATE char out[256] = { 0, }; // for APrint() statements.

// -------------------------------------------------------------------

/****h* FindObjectClass() [1.7] **************************************
*
* NAME
*    FindObjectClass()
*
* DESCRIPTION
*    Return the Class of an Object (01).
**********************************************************************
*
*/

PUBLIC OBJECT *FindObjectClass( int numargs, OBJECT **args )
{
#  ifndef __amigaos4__    
   IMPORT __far CLASS *fnd_class( OBJECT * );
#  else 
   IMPORT FAR CLASS *fnd_class( OBJECT * ); 
#  endif   

   OBJECT *rval = NULL;
   
   if (is_class( args[0] ) == TRUE)
      resultobj = args[0]; // DO NOT try to find the class of a class!
   else
      resultobj = (OBJECT *) fnd_class( args[0] );

   if (resultobj) // != NULL)
      rval = resultobj;
   else
      rval = o_nil;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FINDOBJCLASS_PFUNC ),
                       args[0], rval
             );

   return( rval );
}

/****h* FindSuperObject() [1.7] **************************************
*
* NAME
*    FindSuperObject()
*
* DESCRIPTION
*    Return the Parent Class of an Object (02).
**********************************************************************
*
*/

PUBLIC OBJECT *FindSuperObject( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   resultobj = fnd_super( args[0] );

   if (resultobj) // != NULL)
      rval = resultobj;
   else
      rval = o_nil;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FINDSUPEROBJ_PFUNC ),
                       args[0], rval
             );

   return( rval );
}

/****h* ClassRespondsToNew() [1.7] ***********************************
*
* NAME
*    ClassRespondsToNew()
*
* DESCRIPTION
*    Return a true or false object indicating whether the Class
*    responds to the 'new' message (03).
**********************************************************************
*
*/

PUBLIC OBJECT *ClassRespondsToNew( int numargs, OBJECT **args )
{
   leftint = 0;

   if (is_class( args[0] ) == FALSE) 
      return( leftint ? o_true : o_false );

   leftint = responds_to( "new", // PFuncCMsg( MSG_PR_NEW_MSG_PFUNC ),
                          (CLASS *) args[0]
                        );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CLASS2NEW_PFUNC ),
                       args[0], 
                       leftint == TRUE ? TRUE_NAME : FALSE_NAME
             );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, "%s = ", leftint ? TRUE_NAME : FALSE_NAME );
      }
      
   return( leftint ? o_true : o_false );
}

/****h* ObjectSize() [1.7] *******************************************
*
* NAME
*    ObjectSize()  <primitive 04 obj>
*
* DESCRIPTION
*    Return an integer Object indicating the size of the Object.
**********************************************************************
*
*/

PUBLIC OBJECT *ObjectSize( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   leftint = objSize( args[0] );
   rval    = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_OBJECTSIZE_PFUNC ), 
               args[0], rval, leftint
             );

   return( rval );
}

/****h* ObjectHashNum() [1.7] ****************************************
*
* NAME
*    ObjectHashNum() <5>
*
* DESCRIPTION
*    Return the Hash number of the Object.
**********************************************************************
*
*/

PUBLIC OBJECT *ObjectHashNum( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (is_integer( leftarg ) == TRUE)
      leftint = int_value( leftarg );

//   else if (is_address( leftarg ) == TRUE)
//      leftint = addr_value( leftarg );

   else if (is_character( leftarg ) == TRUE)
      leftint = int_value( leftarg );

   else if (is_symbol( leftarg ) == TRUE)
      leftint = (int) symbol_value( (SYMBOL *) leftarg );

   else if (is_string( leftarg ) == TRUE) 
      {
      leftp   = string_value( (STRING *) leftarg );
      leftint = 0;

      for (i = 0; leftp != 0; leftp++)
         {
         leftint += *leftp;
         i++;

         if (i > 5)
            break;
         }
      }
   else               // for all other objects return the address:
      {
      leftint = (int) &leftarg;
      rval = new_int( leftint );

      goto ReturnHashNum;
      }

   if (leftint < 0)
      leftint = - leftint;

   rval = new_int( leftint );

ReturnHashNum:

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_OBJHASHNUM_PFUNC ), 
               rval, leftint
             );

   return( rval );
}

/****h* ObjectSameType() [1.7] ***************************************
*
* NAME
*    ObjectSameType() <6>
*
* DESCRIPTION
*    Return true or false indicating whether the Objects are the
*    same Class (06).
**********************************************************************
*
*/

PUBLIC OBJECT *ObjectSameType( int numargs, OBJECT **args )
{
   int t1, t2;
   
   if (ChkArgCount( 2, numargs, 6 ) != 0)
      return( ReturnError() );

   t1 = objType( args[0] );
   t2 = objType( args[1] );
   
   // Convert MMF_ADDRESS (internal) to MMF_INTEGER (external)

   if (t1 == MMF_ADDRESS)
      t1 = MMF_INTEGER;
      
   if (t2 == MMF_ADDRESS)
      t2 = MMF_INTEGER;
      
   leftint = (t1 == t2);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_OBJECTSAME_PFUNC ),
               args[0], args[1], 
               leftint == TRUE ? TRUE_NAME : FALSE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* ObjectsEqual() [1.7] *****************************************
*
* NAME
*    ObjectsEqual() <7>
*
* DESCRIPTION
*    Return true or false indicating whether the Objects are the
*    same (07).
**********************************************************************
*
*/

PUBLIC OBJECT *ObjectsEqual( int numargs, OBJECT **args )
{
   if (ChkArgCount( 2, numargs, 7 ) != 0)
      return( ReturnError() );

   leftint = (args[0] == args[1]);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_OBJECTEQUAL_PFUNC ), 
               args[0], args[1], 
               leftint == TRUE ? TRUE_NAME : FALSE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* ToggleDebug() [1.7] ******************************************
*
* NAME
*    ToggleDebug() <8>
*
* DESCRIPTION
*    Change the Debug mode (08).
**********************************************************************
*
*/

PUBLIC OBJECT *ToggleDebug( int numargs, OBJECT **args )
{
   if (numargs == 0) 
      {
      debug = 1 - debug;
      return( o_nil );
      }

   if (ChkArgCount( 2, numargs, 8 ) != 0) 
      return( ReturnError() );

   if (is_integer( args[0] ) == FALSE) 
      return( PrintArgTypeError( 8 ) );

   if (is_integer( args[1] ) == FALSE) 
      return( PrintArgTypeError( 8 ) );

   leftint  = int_value( args[0] );
   rightint = int_value( args[1] );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_TOGGLEDEBUG_PFUNC ), 
               leftint, 
               leftint == 1 ? PFuncCMsg( MSG_PR_SETPRNTCMD_PFUNC )
                            : PFuncCMsg( MSG_PR_SETDEBUG_PFUNC ), 
               rightint
             );

   switch (leftint) 
      {
      case 1: 
         prntcmd = rightint; 
         break;
      
      case 2: 
         debug   = rightint; 
         break;
      }

   return( o_nil );
}

/****i* generality() [1.0] *******************************************
*
* NAME
*    generality()
*
* DESCRIPTION
*    Numerical generality
**********************************************************************
*
*/

PRIVATE int generality( OBJECT *aNumber )
{
   int i;

   if (is_integer( aNumber ) == TRUE)
      i = 1;
   else if (is_address( aNumber ) == TRUE)
      i = 1;
   else if (is_float( aNumber ) == TRUE)
      i = 2;
   else
      i = 3;

   if (debug == TRUE)
      {
      if (i == 2)
         fprintf( stderr, PFuncCMsg( MSG_FMT_GENERAL2_PFUNC ), aNumber );
      else if (i == 1)
         fprintf( stderr, PFuncCMsg( MSG_FMT_GENERAL1_PFUNC ), aNumber );
      else
         fprintf( stderr, PFuncCMsg( MSG_FMT_GENERAL3_PFUNC ), aNumber );
      }

   return( i );
}

/****h* GeneralityCompare() [1.7] ************************************
*
* NAME
*    GeneralityCompare() <9>
*
* DESCRIPTION
*    Compare the generality of two number Objects (09).
**********************************************************************
*
*/

PUBLIC OBJECT *GeneralityCompare( int numargs, OBJECT **args )
{
   if (ChkArgCount( 2, numargs, 9 ) != 0)
      return( ReturnError() );

   leftint = (generality( args[0] ) > generality( args[1] ));

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GENERALCOMP_PFUNC ), 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* AddIntegers() [1.7] ******************************************
*
* NAME
*    AddIntegers() <10>
*
* DESCRIPTION
*    Add two integer Objects & return the sum Object.
**********************************************************************
*
*/

PUBLIC OBJECT *AddIntegers( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   leftint += rightint;
   rval     = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_ADDINTS_PFUNC ), 
                       int_value( args[0] ), rightint, 
                       rval, leftint
             );

   return( rval );
}

/****h* SubIntegers() [1.7] ******************************************
*
* NAME
*    SubIntegers() <11>
*
* DESCRIPTION
*    Subtract two integer Objects & return the difference Object.
**********************************************************************
*
*/

PUBLIC OBJECT *SubIntegers( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   leftint -= rightint;
   rval     = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SUBINTS_PFUNC ), 
                       int_value( args[0] ), rightint, 
                       rval, leftint
             );

   return( rval );
}

/****h* Int_CharLessThan() [1.7] *************************************
*
* NAME
*    Int_CharLessThan() <12> <42>
*
* DESCRIPTION
*    Perform a '<' comparison on the two integer Objects or character
*    Objects.
*
* NOTES
*    primitives 12 & 42
**********************************************************************
*
*/

PUBLIC OBJECT *Int_CharLessThan( int numargs, OBJECT **args )
{
   leftint = (leftint < rightint);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INTLESSTHAN_PFUNC ), 
               int_value( args[0] ), rightint, 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* Int_CharGreaterThan() [1.7] **********************************
*
* NAME
*    Int_CharGreaterThan() <13> <43>
*
* DESCRIPTION
*    Perform a '>' comparison on the two integer Objects or character
*    Objects.
*
* NOTES
*    primitives 13 & 43
**********************************************************************
*
*/

PUBLIC OBJECT *Int_CharGreaterThan( int numargs, OBJECT **args )
{
   leftint = (leftint > rightint);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INTGREATER_PFUNC ), 
               int_value( args[0] ), rightint, 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* Int_CharLEQ() [1.7] ******************************************
*
* NAME
*    Int_CharLEQ() <14> <44>
*
* DESCRIPTION
*    Perform a '<=' comparison on the two integer Objects or character
*    Objects.
*
* NOTES
*    primitives 14 & 44
**********************************************************************
*
*/

PUBLIC OBJECT *Int_CharLEQ( int numargs, OBJECT **args )
{
   leftint = (leftint <= rightint);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INTCHARLEQ_PFUNC ), 
               int_value( args[0] ), rightint, 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* Int_CharGEQ() [1.7] ******************************************
*
* NAME
*    Int_CharGEQ() <15> <45>
*
* DESCRIPTION
*    Perform a '>=' comparison on the two integer Objects or character
*    Objects.
*
* NOTES
*    primitives 15 & 45
**********************************************************************
*
*/

PUBLIC OBJECT *Int_CharGEQ( int numargs, OBJECT **args )
{
   leftint = (leftint >= rightint);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INTCHARGEQ_PFUNC ), 
               int_value( args[0] ), rightint, 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* Int_CharEQ() [1.7] *******************************************
*
* NAME
*    Int_CharEQ() <16> <46>
*
* DESCRIPTION
*    Perform a '=' comparison on the two integer Objects or character
*    Objects.
*
* NOTES
*    primitives 16 & 46
*
**********************************************************************
*
*/

PUBLIC OBJECT *Int_CharEQ( int numargs, OBJECT **args )
{
   leftint = (leftint == rightint);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INTCHAR_EQ_PFUNC ), 
               int_value( args[0] ), rightint, 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* Int_CharNEQ() [1.0] ******************************************
*
* NAME
*    Int_CharNEQ() <17> <47>
*
* DESCRIPTION
*    Perform a '!=' comparison on the two integer Objects or character
*    Objects.
*
* NOTES
*    primitives 17 & 47
*
**********************************************************************
*
*/

PUBLIC OBJECT *Int_CharNEQ( int numargs, OBJECT **args )
{
   leftint = (leftint != rightint);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INTCHARNEQ_PFUNC ), 
               int_value( args[0] ), rightint, 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* MultIntegers() [1.7] *****************************************
*
* NAME
*    MultIntegers() <18>
*
* DESCRIPTION
*    Multiply two integer Objects & return the product Object.
**********************************************************************
*
*/

PUBLIC OBJECT *MultIntegers( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   leftint *= rightint;
   rval     = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_MULT_INT_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****h* DSlashIntegers() [1.7] ***************************************
*
* NAME
*    DSlashIntegers() <19>
*
* DESCRIPTION
*    Divide the two integer Objects & return the rounded 
*    quotient Object (19).
**********************************************************************
*
*/

PUBLIC OBJECT *DSlashIntegers( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (rightint == 0) 
      return( PrintNumberError() );

   i  = leftint / rightint;

   if ((leftint < 0) && ((leftint % rightint) != 0))
      i -= 1;

   leftint = i;

   rval = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_DSLASHINT_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****h* GCDIntegers() [1.7] ******************************************
*
* NAME
*    GCDIntegers() <20>
*
* DESCRIPTION
*    Return the greatest common divisor of the two integer Objects.
**********************************************************************
*
*/

PUBLIC OBJECT *GCDIntegers( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (leftint == 0 || rightint == 0) 
      return( PrintNumberError() );

   if (leftint < 0) 
      leftint = - leftint;

   if (rightint < 0) 
      rightint = - rightint;

   if (leftint > rightint) 
      {
      i        = leftint; 
      leftint  = rightint; 
      rightint = i;
      }

   while (i = rightint % leftint)
      {
      rightint = leftint; 
      leftint  = i;
      }

   rval = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GCD_INTS_PFUNC ), 
                       int_value( args[0] ),
                       int_value( args[1] ),
                                  rval, leftint
             );

   return( rval );
}

/****h* BitAt() [1.7] ************************************************
*
* NAME
*    BitAt()
*
* DESCRIPTION
*    Return a 1 or a 0 for the given bit number. <21>
**********************************************************************
*
*/

PUBLIC OBJECT *BitAt( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   leftint = (leftint & (1 << rightint)) ? 1 : 0;
   rval    = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BITAT_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****h* BitOR() [1.7] ************************************************
*
* NAME
*    BitOR()
*
* DESCRIPTION
*    Return the Inclusive OR of two integer Objects <22>
**********************************************************************
*
*/

PUBLIC OBJECT *BitOR( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   leftint |= rightint;
   rval     = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BITOR_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****h* BitAND() [1.7] ***********************************************
*
* NAME
*    BitAND()
*
* DESCRIPTION
*    Return the logical AND of two integer Objects <23>
**********************************************************************
*
*/

PUBLIC OBJECT *BitAND( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   leftint &= rightint;
   rval     = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BITAND_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****h* BitXOR() [1.7] ***********************************************
*
* NAME
*    BitXOR() <24>
*
* DESCRIPTION
*    Return the Exclusive OR of two integer Objects.
**********************************************************************
*
*/

PUBLIC OBJECT *BitXOR( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   leftint ^= rightint;
   rval     = new_int( leftint );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BITXOR_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****h* BitShift() [1.7] *********************************************
*
* NAME
*    BitShift() <25>
*
* DESCRIPTION
*    Shift the bits of the integer Object the given length 
*    & direction.
**********************************************************************
*
*/

PUBLIC OBJECT *BitShift( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   if (rightint < 0)
      leftint >>= - rightint;
   else
      leftint <<= rightint;

   rval = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BITSHIFT_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****i* prnt_radix() [3.0] *******************************************
*
* NAME
*    prnt_radix()
*
* DESCRIPTION
*
* HISTORY
*    06-Dec-2003 - Fixed the while loop to take care of signed
*                  numbers getting to the while loop (& added digs[]).
*
*    28-Nov-2003 - Added the addRadix flag 
**********************************************************************
*
*/

SUBFUNC int prnt_radix( int n, int r, char buffer[], 
                        BOOL signFlag, BOOL addRadix 
                      )
{
   char *p, *q, buffer2[60] = "";

   char  digs[] = "0123456789ABCDEFGHIJKLMNOPQRTSUVWXYZ";
   
   int  i, s = FALSE; // Default to unsigned.

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_PRNTRADIX_PFUNC ),
                       n, r, &buffer[0]
             );

   if (signFlag == TRUE)
      {
      // Number is to be treated as a signed value:
      if (n < 0) 
         {
         n = - n; 
         s = TRUE;
         }
      else 
         s = FALSE;
      }

    p   = buffer2; 
   *p++ = NIL_CHAR; // Ensure the terminator is present.
   
   if (n == 0) 
      *p++ = ZERO_CHAR;
   else
      {
      while (n != 0) 
         {
         i    = ((unsigned int) n) % r;

         *p++ = digs[i];

         n    = ((unsigned int) n) / r;
         }
      }

   if (addRadix == TRUE)
      {
      sprintf( buffer, "%dr", r ); // number base indicator.
      }

   for (q = buffer; *q != NIL_CHAR; q++)
      ; // Skip over Radix char's (if any)
      
   if (s != FALSE)
      *q++ = MINUS_CHAR;                    // Add the minus char'

   for (*p = ZERO_CHAR ; *p != NIL_CHAR; )  // Reverse the string.
      *q++ = *--p;

   *q = NIL_CHAR;

   return( 0 );
}

/****i* fprnt_radix() [2.0] ******************************************
*
* NAME
*    fprnt_radix()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC int fprnt_radix( double f, int n, char buffer[] )
{
   int    sign = 0, exp = 0;
   int    i, j;
   char   *p, *q, tempbuffer[60];
   double ip;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FPRNTRADIX_PFUNC ),
                       f, n, &buffer[0]
             );

   if (f < 0)  
      {
      sign = 1;
      f    = - f;
      }
   else 
      sign = 0;

   if (f != 0) 
      {
      exp = (int) floor( log( f ) / log( (double) n ) );

      if (exp < -4 || 4 < exp) 
         {
         f *= pow( (double) n, (double) - exp );
         }
      else 
         exp = 0;
      }

   f = modf( f, &ip );

   if (sign != 0) 
      ip = - ip;

   prnt_radix( (int) ip, n, buffer, TRUE, needRadix );

   for (p = buffer; *p != NIL_CHAR; p++) 
      ; // Find the end of the buffer & point p to it.

   if (f != 0) 
      {
      *p++ = PERIOD_CHAR;

      for (j = 0; (f != 0) && (j < 6); j++)
         {
         i    = (int) (f *= n);
         *p++ = (i < 10) ? ZERO_CHAR + i : CAP_A_CHAR + (i - 10);
         f   -= i;
         }
      }

   if (exp != 0) 
      {
      *p++ = SMALL_E_CHAR;
      sprintf( tempbuffer, "%d", exp );

      for (q = tempbuffer; *q != 0; )
         *p++ = *q++;
      }

   *p = NIL_CHAR;

   return( 0 );
}

/****h* IntegerRadix() [2.0] *****************************************
*
* NAME
*    IntegerRadix() <26>
*
* DESCRIPTION
*    Print the given Object in the given number base (radix).
*    miscFlag is used here to indicate whether the Integer is to be
*    treated as signed (true) or unsinged (false).
*
*    ^ <primitive 26 self base miscFlag needRadix>
**********************************************************************
*
*/

PUBLIC OBJECT *IntegerRadix( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   int     i;
   
   if (rightint < 2 || rightint > 36) 
      return( PrintNumberError() );

   for (i = 0; i < 256; i++)
      strbuffer[i] = '\0';  // Kill Old contents
   
   // miscFlag & needRadix is set/cleared in Primitive.c:
   prnt_radix( leftint, rightint, strbuffer, miscFlag, needRadix );

   rval = new_str( strbuffer );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INT_RADIX_PFUNC ), 
               leftint, rightint, rval, strbuffer
             );

   return( rval );
}

/****h* DivIntegers() [1.7] ******************************************
*
* NAME
*    DivIntegers() <28>
*
* DESCRIPTION
*    Divide the two integer Objects & return the quotient Object.
**********************************************************************
*
*/

PUBLIC OBJECT *DivIntegers( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (rightint == 0) 
      return( PrintNumberError() );

   leftint /= rightint;
   rval     = new_int( leftint );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_DIV_INTS_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****h* ModulusIntegers() [1.7] **************************************
*
* NAME
*    ModulusIntegers() <29>
*
* DESCRIPTION
*    Divide the two integer Objects & return the Remainder Object.
**********************************************************************
*
*/

PUBLIC OBJECT *ModulusIntegers( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (rightint == 0) 
      return( PrintNumberError() );

   leftint %= rightint;
   rval     = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INT_MODULUS_PFUNC ), 
               int_value( args[0] ), rightint, rval, leftint
             );

   return( rval );
}

/****h* DoPrimitive_2Args() [1.7] ************************************
*
* NAME
*    DoPrimitive_2Args()   <30>
*
* DESCRIPTION
*    Return the result of executing the primitive given by the 1st
*    argument using the values given in the array provided by the
*    2nd argument.
**********************************************************************
*
*/

PUBLIC OBJECT *DoPrimitive_2Args( int numargs, OBJECT **args )
{
   if (ChkArgCount( 2, numargs, 30 ) != 0)
      return( ReturnError() );

   // Recursion, sort of:
   resultobj = primitive( leftint, objSize( args[1] ), &args[1]->inst_var[0] );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_DOPRIM2ARGS_PFUNC ), 
               int_value( args[0] ), args[1], resultobj 
             );

   return( resultobj );
}

/****h* RandomFloat() [1.7] ******************************************
*
* NAME
*    RandomFloat()  <32>
*
* DESCRIPTION
*    Converts an integer value into a number in the range of
*    0.0 to 1.0.  Used to convert a random integer into a random 
*    floating point value (for the Random Class).
*
* NOTES
*    This function needs to be checked!!
**********************************************************************
*
*/

PUBLIC OBJECT *RandomFloat( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   int     t    = int_value( args[0] );

#  ifdef __SAS__
   srand48( (long) t );

   leftfloat = (float) drand48();
#  endif


#  ifndef __SAS__
   srand( (unsigned int ) t );
   leftfloat = (float) rand();

   if (leftfloat > 1.0)
      {
      while (leftfloat > 1.0)
         leftfloat /= 10.0;
      }      
#  endif

   rval = new_float( leftfloat );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_RANDOM_FLOAT_PFUNC ), 
               int_value( args[0] ), rval, leftfloat
             );

   return( rval );
}

/****h* BitInverse() [1.7] *******************************************
*
* NAME
*    BitInverse()  <33>
*
* DESCRIPTION
*    Perform a logical inversion on all the bits of an integer Object.
**********************************************************************
*
*/

PUBLIC OBJECT *BitInverse( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   leftint ^= -1;
   rval     = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BITINVERSE_PFUNC ), 
               int_value( args[0] ), rval, leftint
             );

   return( rval );
}

/****h* HighBit() [1.7] **********************************************
*
* NAME
*    HighBit()  <34>
*
* DESCRIPTION
*    Return the position of the highest set bit in the integer arg.
*
* WARNINGS
*    32-bit length for integers is hard-coded in this function!
**********************************************************************
*
*/

PUBLIC OBJECT *HighBit( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   rightint = leftint;

   for (leftint = 32; leftint >= 0; leftint--)
      {
      if ((rightint & (1 << leftint)) != 0)
         rval = new_int( leftint );
      }

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_HIGHBIT_PFUNC ), 
               int_value( args[0] ), rval, leftint
             );

   return( rval );
}

/****h* RandomNumber() [1.7] *****************************************
*
* NAME
*    RandomNumber()   <35>
*
* DESCRIPTION
*    Return a random number, based on the supplied seed value.
**********************************************************************
*
*/

PUBLIC OBJECT *RandomNumber( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   srand( (unsigned int) leftint );

   leftint = rand(); //  leftint );
   rval    = new_int( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_RANDOM_NUM_PFUNC ), 
               int_value( args[0] ), rval, leftint
             );

   return( rval );
}

/****h* IntegerToChar() [1.7] ****************************************
*
* NAME
*    IntegerToChar() <36>
*
* DESCRIPTION
*    Convert the integer Object to a character Object.
**********************************************************************
*
*/

PUBLIC OBJECT *IntegerToChar( int numargs, OBJECT **args )
{
   OBJECT *rval = new_char( leftint );
   
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INT2CHAR_PFUNC ), 
               leftint, rval, char_value( rval )
             );

   return( rval );
}

/****h* IntegerToString() [1.7] **************************************
*
* NAME
*    IntegerToString()  <37>
*
* DESCRIPTION
*    Convert the integer Object into a string Object.
**********************************************************************
*
*/

PUBLIC OBJECT *IntegerToString( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
#  ifdef __SAS__
   (void) stci_d( strbuffer, leftint );
#  else 
   sprintf( strbuffer,"%d", leftint );
#  endif

   rval = new_str( strbuffer );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INT2STRING_PFUNC ), 
               leftint, rval, strbuffer
             );

   return( rval );
}

/****h* Factorial() [1.7] ********************************************
*
* NAME
*    Factorial()   <38>
*
* DESCRIPTION
*    Return the factorial of the argument.  May return as float if
*    the result is too large for integer type.
**********************************************************************
*
*/

PUBLIC OBJECT *Factorial( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (leftint < 0) 
      return( PrintNumberError() );

   if (leftint < FACTMAX) 
      {
      for (i = 1; leftint; leftint--)
         i *= leftint;

      leftint = i;
      rval    = new_int( leftint );

      if (debug == TRUE)
         fprintf( stderr, PFuncCMsg( MSG_PR_FACTORIALI_PFUNC ), 
                  int_value( args[0] ), rval, leftint
                );

      goto ReturnFactorial;
      }

#  ifndef GAMMA  // gamma not supported, use float multiply:
   leftfloat = (float) 1.0;

   if (leftint < 30) 
      {
      for (i = 1; leftint; leftint--)
         leftfloat *= leftint;
      }
   
   rval = new_float( leftfloat );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FACTORIALG_PFUNC ), 
               int_value( args[0] ), rval, leftfloat
             );

#  else          // compute gamma function:
   leftfloat = (double) (leftint + 1);
   leftarg   = AssignObj( new_float( leftfloat ));

   resultobj = primitive( GAMMAFUN, 1, &leftarg );

   (void) obj_dec( leftarg ); // Mark temporary storage for deletion.

   rval = resultobj;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FACTORIALG_PFUNC ), 
               int_value( args[0] ), rval, float_value( rval )
             );
#  endif

ReturnFactorial:

   return( rval );
}

/****h* IntegerToFloat() [1.7] ***************************************
*
* NAME
*    IntegerToFloat()  <39>
*
* DESCRIPTION
*    Convert an integer into a float Object.
**********************************************************************
*
*/

PUBLIC OBJECT *IntegerToFloat( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   leftfloat = (double) leftint;
   rval      = new_float( leftfloat );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INT2FLOAT_PFUNC ), 
               leftint, rval, leftfloat
             );

   return( rval );
}

/* primitives 40-49 are previously defined! */

/****h* DigitValue() [1.7] *******************************************
*
* NAME
*    DigitValue()  <50>
*
* DESCRIPTION
*    Return the integer value representing the position of the 
*    character in the collating sequence.
**********************************************************************
*
*/

PUBLIC OBJECT *DigitValue( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (isdigit( leftint ) != FALSE)
      {
      leftint -= ZERO_CHAR;
      rval     = new_int( leftint );
      }
   else if (isupper( leftint ) != FALSE) 
      {
      leftint -= CAP_A_CHAR;
      leftint += 10;
      rval     = new_int( leftint );
      }
   else 
      rval = o_nil;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_DIGITVALUE_PFUNC ), 
               int_value( args[0] ), int_value( args[0] ), rval
             );

   
   return( rval );
}

/****h* IsVowelPf() [1.7] ********************************************
*
* NAME
*    IsVowelPf()  <51>
*
* DESCRIPTION
*    Return true Object if the argument is a vowel.
**********************************************************************
*
*/

PUBLIC OBJECT *IsVowelPf( int numargs, OBJECT **args )
{
   if (isupper( leftint ) != FALSE) 
      leftint += SMALL_A_CHAR - CAP_A_CHAR;

   leftint = (leftint == SMALL_A_CHAR) 
              || (leftint == SMALL_E_CHAR) 
              || (leftint == SMALL_I_CHAR) 
              || (leftint == SMALL_O_CHAR) 
              || (leftint == SMALL_U_CHAR);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_IS_VOWEL_PFUNC ), 
               int_value( args[0] ), int_value( args[0] ), 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( leftint ? o_true : o_false );
}

/****h* IsAlphaPf() [1.7] ********************************************
*
* NAME
*    IsAlphaPf()  <52>
*
* DESCRIPTION
*    Return true Object if the argument is a letter.
**********************************************************************
*
*/

PUBLIC OBJECT *IsAlphaPf( int numargs, OBJECT **args )
{
   leftint = isalpha( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_IS_ALPHA_PFUNC ), 
               int_value( args[0] ), int_value( args[0] ), 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* IsLowerPf() [1.7] ********************************************
*
* NAME
*    IsLowerPf()  <53>
*
* DESCRIPTION
*    Return true Object if the argument is a lowercase letter.
**********************************************************************
*
*/

PUBLIC OBJECT *IsLowerPf( int numargs, OBJECT **args )
{
   leftint = islower( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_IS_LOWER_PFUNC ), 
               int_value( args[0] ), int_value( args[0] ), 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* IsUpperPf() [1.7] ********************************************
*
* NAME
*    IsUpperPf()  <54>
*
* DESCRIPTION
*    Return true Object if the argument is an uppercase letter.
**********************************************************************
*
*/

PUBLIC OBJECT *IsUpperPf( int numargs, OBJECT **args )
{
   leftint = isupper( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_IS_UPPER_PFUNC ), 
               int_value( args[0] ), int_value( args[0] ), 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* IsSpacePf() [1.7] ********************************************
*
* NAME
*    IsSpacePf()   <55>
*
* DESCRIPTION
*    Return true Object if the argument is a white space character.
**********************************************************************
*
*/

PUBLIC OBJECT *IsSpacePf( int numargs, OBJECT **args )
{
   leftint = isspace( leftint );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_IS_SPACE_PFUNC ), 
               int_value( args[0] ), int_value( args[0] ), 
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* IsAlNumPf() [1.7] ********************************************
*
* NAME
*    IsAlNumPf()  <56>
*
* DESCRIPTION
*    Return true Object if the argument is a letter or digit.
**********************************************************************
*
*/

PUBLIC OBJECT *IsAlNumPf( int numargs, OBJECT **args )
{
   leftint = isalnum( leftint );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_IS_ALNUM_PFUNC ), 
               int_value( args[0] ), int_value( args[0] ),
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* ChangeCase() [1.7] *******************************************
*
* NAME
*    ChangeCase()  <57>
*
* DESCRIPTION
*    Change the argument to lowercase if uppercase & vice-versa.
**********************************************************************
*
*/

PUBLIC OBJECT *ChangeCase( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   int     strt = leftint;
   
   if (isupper( leftint ) != FALSE)
      leftint += SMALL_A_CHAR - CAP_A_CHAR;
   else if (islower( leftint ) != FALSE)
      leftint += CAP_A_CHAR - SMALL_A_CHAR;
   
   rval = new_char( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CHANGECASE_PFUNC ), 
               strt, rval, leftint
             );

   return( rval );
}

/****h* CharToString() [1.7] *****************************************
*
* NAME
*    CharToString()  <58>
*
* DESCRIPTION
*    Convert a character Object into a string Object.
**********************************************************************
*
*/

PUBLIC OBJECT *CharToString( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   sprintf( strbuffer,"%c", leftint );
   
   rval = new_str( strbuffer );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CHAR2STRING_PFUNC ), 
               leftint, rval, string_value( (STRING *) rval )
             );

   return( rval );
}

/****h* CharToInteger() [1.7] ****************************************
*
* NAME
*    CharToInteger()  <59>
*
* DESCRIPTION
*    Convert a character Object into an integer Object.
**********************************************************************
*
*/

PUBLIC OBJECT *CharToInteger( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   rval = new_int( leftint );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CHAR2INT_PFUNC ), 
               leftint, rval, leftint
             );

   return( rval );
}

/****h* AddFloats() [1.7] ********************************************
*
* NAME
*    AddFloats()  <60>
*
* DESCRIPTION
*    Return the floating-point sum of the two float arguments.
**********************************************************************
*
*/

PUBLIC OBJECT *AddFloats( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   leftfloat += rightfloat;
   rval       = new_float( leftfloat );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_ADDFLOATS_PFUNC ), 
               float_value( args[0] ), rightfloat,
               rval, leftfloat
             );

   return( rval );
}

/****h* SubFloats() [1.7] ********************************************
*
* NAME
*    SubFloats()  <61>
*
* DESCRIPTION
*    Return the floating-point differnece of the two float arguments.
**********************************************************************
*
*/

PUBLIC OBJECT *SubFloats( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   leftfloat -= rightfloat;
   rval       = new_float( leftfloat );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SUBFLOATS_PFUNC ), 
               float_value( args[0] ), rightfloat,
               rval, leftfloat
             );

   return( rval );
}

/****h* FloatLessThan() [1.7] ****************************************
*
* NAME
*    FloatLessThan()  <62>
*
* DESCRIPTION
*    Perform a '<' comparison on two float Objects.
**********************************************************************
*
*/

PUBLIC OBJECT *FloatLessThan( int numargs, OBJECT **args )
{
   leftint = (leftfloat < rightfloat);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOAT_LT_PFUNC ), 
               leftfloat, rightfloat,
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* FloatGreaterThan() [1.7] *************************************
*
* NAME
*    FloatGreaterThan()  <63>
*
* DESCRIPTION
*    Perform a '>' comparison on two float Objects.
**********************************************************************
*
*/

PUBLIC OBJECT *FloatGreaterThan( int numargs, OBJECT **args )
{
   leftint = (leftfloat > rightfloat);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOAT_GT_PFUNC ), 
               leftfloat, rightfloat,
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* FloatLEQ() [1.7] *********************************************
*
* NAME
*    FloatLEQ()  <64>
*
* DESCRIPTION
*    Perform a '<=' comparison on two float Objects.
**********************************************************************
*
*/

PUBLIC OBJECT *FloatLEQ( int numargs, OBJECT **args )
{
   leftint = (leftfloat <= rightfloat);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOAT_LEQ_PFUNC ), 
               leftfloat, rightfloat,
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* FloatGEQ() [1.7] *********************************************
*
* NAME
*    FloatGEQ()  <65>
*
* DESCRIPTION
*    Perform a '>=' comparison on two float Objects.
**********************************************************************
*
*/

PUBLIC OBJECT *FloatGEQ( int numargs, OBJECT **args )
{
   leftint = (leftfloat >= rightfloat);
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOAT_GEQ_PFUNC ), 
               leftfloat, rightfloat,
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* FloatEQ() [1.7] **********************************************
*
* NAME
*    FloatEQ()  <66>
*
* DESCRIPTION
*    Perform a '==' comparison on two float Objects.
**********************************************************************
*
*/

PUBLIC OBJECT *FloatEQ( int numargs, OBJECT **args )
{
   leftint = (leftfloat == rightfloat);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOAT_EQ_PFUNC ), 
               leftfloat, rightfloat,
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* FloatNEQ() [1.7] *********************************************
*
* NAME
*    FloatNEQ()  <67>
*
* DESCRIPTION
*    Perform a '!=' comparison on two float Objects.
**********************************************************************
*
*/

PUBLIC OBJECT *FloatNEQ( int numargs, OBJECT **args )
{
   leftint = (leftfloat != rightfloat);

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOAT_NEQ_PFUNC ), 
               leftfloat, rightfloat,
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* MultFloats() [1.7] *******************************************
*
* NAME
*    MultFloats()  <68>
*
* DESCRIPTION
*    Multiply two float Objects & return the product float Object.
**********************************************************************
*
*/

PUBLIC OBJECT *MultFloats( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   leftfloat *= rightfloat;
   rval       = new_float( leftfloat );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_MULTFLOATS_PFUNC ), 
               float_value( args[0] ), rightfloat, rval, leftfloat
             );

   return( rval );
}

/****h* DivFloats() [1.7] ********************************************
*
* NAME
*    DivFloats()  <69>
*
* DESCRIPTION
*    Divide two float Objects & return the quotient float Object.
**********************************************************************
*
*/

PUBLIC OBJECT *DivFloats( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (rightfloat == 0) 
      return( PrintNumberError() );

   leftfloat /= rightfloat;
   rval       = new_float( leftfloat );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_DIVFLOATS_PFUNC ), 
               float_value( args[0] ), rightfloat, rval, leftfloat
             );

   return( rval );
}

/****h* NaturalLog() [1.7] *******************************************
*
* NAME
*    NaturalLog()  <70>
*
* DESCRIPTION
*    Return the natural logarithm (float) of the float argument.
**********************************************************************
*
*/
      
PUBLIC OBJECT *NaturalLog( int numargs, OBJECT **args )
{
   errno     = 0;
   leftfloat = log( leftfloat );

   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NATURALLOG_PFUNC ), 
               float_value( args[0] ), leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* SquareRoot() [1.7] *******************************************
*
* NAME
*    SquareRoot()  <71>
*
* DESCRIPTION
*    Return the square root (float) of the float argument.
**********************************************************************
*
*/

PUBLIC OBJECT *SquareRoot( int numargs, OBJECT **args )
{
   if (leftfloat < 0) 
      return( PrintNumberError() );

   errno     = 0;
   leftfloat = sqrt( leftfloat );

   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SQUAREROOT_PFUNC ), 
               float_value( args[0] ), leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* Floor() [1.7] ************************************************
*
* NAME
*    Floor()  <72>
*
* DESCRIPTION
*    Return the integer floor of the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *Floor( int numargs, OBJECT **args )
{
   leftint = (int) floor( leftfloat );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOOR_PFUNC ),
                       leftfloat, leftint
             );

   return( new_int( leftint ) );
}

/****h* Ceiling() [1.7] **********************************************
*
* NAME
*    Ceiling()  <73>
*
* DESCRIPTION
*    Return the integer ceiling of the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *Ceiling( int numargs, OBJECT **args )
{
   leftint = (int) ceil( leftfloat );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CEILING_PFUNC ),
                       leftfloat, leftint
             );

   return( new_int( leftint ) );
}

/****h* IntegerPart() [1.7] ******************************************
*
* NAME
*    IntegerPart()  <75>
*
* DESCRIPTION
*    Return the integer portion of the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *IntegerPart( int numargs, OBJECT **args )
{
   leftfloat = modf( leftfloat, &rightfloat );
   leftint   = (int) rightfloat;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INT_PART_PFUNC ), 
               leftfloat, rightfloat, leftint
             );

   return( new_int( leftint ) );
}

/****h* FractionPart() [1.7] *****************************************
*
* NAME
*    FractionPart()  <76>
*
* DESCRIPTION
*    Return the fractional portion of the (float) argument.
**********************************************************************
*
*/

PUBLIC OBJECT *FractionPart( int numargs, OBJECT **args )
{
   leftfloat = modf( leftfloat, &rightfloat );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FRACTION_PFUNC ), 
               float_value( args[0] ), rightfloat, leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* GammaFunc() [1.7] ********************************************
*
* NAME
*    GammaFunc()  <77>
*
* DESCRIPTION
*    Return the value of the gamma fucntion at the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *GammaFunc( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GAMMA_PFUNC ),
                       numargs, args
             );

#  ifdef GAMMA
   leftfloat = gamma( leftfloat );

   if (leftfloat > 88.0) 
      return( PrintNumberError() );

   leftfloat = exp( leftfloat );

   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

#  else

   StringCopy( errp, PFuncCMsg( MSG_PR_GAMMA_FUNC_PFUNC ) );
   sprintf( strbuffer, PFuncCMsg( MSG_FMT_PR_NOTIMP_PFUNC ), errp );
   StringCopy( errp, strbuffer );

   return( ReturnError() );
#  endif
}

/****h* FloatToString() [1.7] ****************************************
*
* NAME
*    FloatToString()  <78>
*
* DESCRIPTION
*    Convert the float Object to a string Object.
**********************************************************************
*
*/

PUBLIC OBJECT *FloatToString( int numargs, OBJECT **args )
{
   sprintf( strbuffer,"%g", leftfloat );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOAT2STRING_PFUNC ), 
               leftfloat, strbuffer
             );

   return( new_str( strbuffer ) );
}

/****h* Exponent() [1.7] *********************************************
*
* NAME
*    Exponent()  <79>
*
* DESCRIPTION
*    Return the value 'e' raised to the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *Exponent( int numargs, OBJECT **args )
{
   leftfloat = exp( leftfloat );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_EXPONENT_PFUNC ), 
               float_value( args[0] ), leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* NormalizeRadian() [1.7] **************************************
*
* NAME
*    NormalizeRadian()  <80>
*
* DESCRIPTION
*    Return the argument normalized to between 0 & 2 * PI.
**********************************************************************
*
*/

PUBLIC OBJECT *NormalizeRadian( int numargs, OBJECT **args )
{
#  define TWOPI (double) 6.2831853072

   rightfloat = floor( ((leftfloat < 0) ? -leftfloat:leftfloat) / TWOPI );

   if (leftfloat < 0)
      leftfloat += (1 + rightfloat) * TWOPI;
   else
      leftfloat -= rightfloat * TWOPI;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NORM_RADIAN_PFUNC ), 
               float_value( args[0] ), leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* Sin_() [1.7] *************************************************
*
* NAME
*    Sin_()  <81>
*
* DESCRIPTION
*    Return the sine function of the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *Sin_( int numargs, OBJECT **args )
{
   errno     = 0;
   leftfloat = sin( leftfloat );

   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SIN_PFUNC ), 
                       float_value( args[0] ),
                       leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* Cos_() [1.7] *************************************************
*
* NAME
*    Cos_()  <82>
*
* DESCRIPTION
*    Return the cosine function of the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *Cos_( int numargs, OBJECT **args )
{
   errno     = 0;
   leftfloat = cos( leftfloat );

   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_COS_PFUNC ),
                       float_value( args[0] ),
                       leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* ASin_() [1.7] ************************************************
*
* NAME
*    ASin_()  <84>
*
* DESCRIPTION
*    Return the arc-sine function of the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *ASin_( int numargs, OBJECT **args )
{
   errno     = 0;
   leftfloat = asin( leftfloat );

   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_ASIN_PFUNC ),
                       float_value( args[0] ),
                       leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* ACos_() [1.7] ************************************************
*
* NAME
*    ACos_()  <85>
*
* DESCRIPTION
*    Return the arc-cosine function of the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *ACos_( int numargs, OBJECT **args )
{
   errno     = 0;
   leftfloat = acos( leftfloat );

   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_ACOS_PFUNC ),
                       float_value( args[0] ),
                       leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* ATan_() [1.7] ************************************************
*
* NAME
*    ATan_()  <86>
*
* DESCRIPTION
*    Return the arc-tangent function of the argument.
**********************************************************************
*
*/

PUBLIC OBJECT *ATan_( int numargs, OBJECT **args )
{
   errno     = 0;
   leftfloat = atan( leftfloat );

   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_ATAN_PFUNC ),
                       float_value( args[0] ),
                       leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* Power() [1.7] ************************************************
*
* NAME
*    Power()  <88>
*
* DESCRIPTION
*    Return the 1st value raised to the power of the 2nd argument.
*    Both arguments must be floating-point values.
**********************************************************************
*
*/

PUBLIC OBJECT *Power( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_FMT_PR_POWER_PFUNC ),
                       numargs, args
             );

   if (ChkArgCount( 2, numargs, 88 ) != 0)
      return( ReturnError() );

   if (is_float( args[1] ) == FALSE) 
      return( PrintArgTypeError( 88 ) );

   errno     = 0;
   leftfloat = pow( leftfloat, float_value( args[1] ) );
 
   if (errno == ERANGE || errno == EDOM) 
      return( PrintNumberError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_POWER_PFUNC ), 
               float_value( args[0] ), float_value( args[1] ),
               leftfloat
             );

   return( new_float( leftfloat ) );
}

/****h* FloatRadixPrint() [1.7] **************************************
*
* NAME
*    FloatRadixPrint()  <89>
*
* DESCRIPTION
*    Return a string Object of the 1st argument in the base given by
*    the 2nd argument.  The 1st argument must be float, the 2nd, an
*    integer between 2 & 36.
**********************************************************************
*
*/

PUBLIC OBJECT *FloatRadixPrint( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (ChkArgCount( 2, numargs, 89 ) != 0)
      return( ReturnError() );

   if (is_integer( args[1] ) == FALSE) 
      return( PrintArgTypeError( 89 ) );

   i = int_value( args[1] ); // base of the number.

   if (i < 2 || i > 36)
      return( PrintNumberError() );

   fprnt_radix( leftfloat, i, strbuffer );

   rval = new_str( strbuffer );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FLOATRADIX_PRT_PFUNC ), 
               leftfloat, i, rval, strbuffer
             );

   return( rval );
}

/****h* SymbolCompare() [1.7] ****************************************
*
* NAME
*    SymbolCompare()  <91>
*
* DESCRIPTION
*    Return true Object if the two arguments represent the same
*    Symbol.  Used extensively in the interpreter code.
**********************************************************************
*
*/

PUBLIC OBJECT *SymbolCompare( int numargs, OBJECT **args )
{
   //char *other = NULL;

   FBEGIN( printf( "SymbolCompare< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (ChkArgCount( 2, numargs, 91 ) != 0)
      return( ReturnError() );

   if (args[1] == o_nil)
      {
      sprintf( ErrMsg, "Attempted to compare %s to nil!", leftp );

      UserInfo( ErrMsg, "Programmer ATTENTION:" );

      return( o_false );
      }
      
   if (is_symbol( args[1] ) == FALSE) 
      return( PrintArgTypeError( 91 ) );

   /* Since there's only supposed to be one copy of each symbol,
   ** it makes more sense to just compare the symbol values,
   ** in case the program somehow made two identical (in value)
   ** symbols.  This means their addresses would be different,
   ** causing leftp == symbol_value() to fail when it should pass:
   */

   // leftp was setup in primitive()
   // other   = symbol_value( args[1] ); // symbol_value() == sym->value
   // leftint = StringComp( leftp, other );

   leftint = (leftp == symbol_value( (SYMBOL *) args[1] ));

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SYMBOLCOMP_PFUNC ),
               leftp, symbol_value( (SYMBOL *) args[1] ),
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   FEND( printf( "%d = SymbolCompare<>\n", leftint ) );

   return( leftint ? o_true : o_false );
}

/****h* SymbolToString() [1.7] ***************************************
*
* NAME
*    SymbolToString()  <92>
*
* DESCRIPTION
*    Convert a Symbol into a string Object.
**********************************************************************
*
*/

PUBLIC OBJECT *SymbolToString( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   sprintf( strbuffer, "#%s", leftp );

   rval = new_str( strbuffer );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SYM2STRING_PFUNC ), leftp, rval );

   return( rval );
}

/****h* SymbolAsString() [1.7] ***************************************
*
* NAME
*    SymbolAsString()  <93>
*
* DESCRIPTION
*    Convert a Symbol into a string without the leading '#'.
**********************************************************************
*
*/

PUBLIC OBJECT *SymbolAsString( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   sprintf( strbuffer, "%s", leftp );

   rval = new_str( strbuffer );
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SYMASSTRING_PFUNC ),
                       leftp, rval
             );

   return( rval );
}

/****h* SymbolPrint() [1.7] ******************************************
*
* NAME
*    SymbolPrint()  <94>
*
* DESCRIPTION
*    Print the Symbol after 1st indenting by the specified amount.
**********************************************************************
*
*/

PUBLIC OBJECT *SymbolPrint( int numargs, OBJECT **args )
{
   int  i, j;

   FBEGIN( printf( "SymbolPrint< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (numargs == 2) 
      {
      if (is_integer( args[1] ) == FALSE) 
         return( PrintArgTypeError( 94 ) );

      j = int_value( args[1] );

      for (i = int_value( args[1] ); i >= 0; i--)
         APrint( THREE_SPACES );    // Amiga_Printf( "\t" );
      }

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SYMBOL_PRT_PFUNC ), 
                       symbol_value( (SYMBOL *) args[0] ), j
             );

   sprintf( outmsg, "%s\n", leftp );
   APrint( outmsg );

   // Amiga_Printf( "%s\n", leftp );

#  ifdef FLUSHREQ
   fflush( stdout );
#  endif

   FEND( printf( "SymbolPrint<> exits\n" ) );

   return( o_nil );
}  

/****h* instanceVarAccess() [3.0] ************************************
*
* NAME
*    instanceVarAccess()  <95>
*
* DESCRIPTION
*    Either retrieve an instance variable or set one.
**********************************************************************
*
*/

PUBLIC OBJECT *instanceVarAccess( int numargs, OBJECT **args )
{
   OBJECT *rval  = o_nil;
   OBJECT *obj   = o_nil;
   int     index = 0;
   
   if (leftint == 0)
      {
      // instVarAt: index  ^ <primitive 95 0 index self>  
      index = int_value( args[1] );
      obj   = args[2];

      if (is_bltin( obj ) == TRUE)
         {
         sprintf( ErrMsg, PFuncCMsg( MSG_PR_FMT_BUILTIN_ERR_PFUNC ),
                                Class_Name( obj )
                );

         StringCopy( errp, ErrMsg );

         return( ReturnError() );
         }

      if (index < objSize( obj ))
         rval  = obj->inst_var[ index - 1 ];
      else
         {
         sprintf( strbuffer, PFuncCMsg( MSG_PR_FMT_INDEX_TOO_BIG_PFUNC ),
                             index
                );
      
         StringCopy( errp, strbuffer );

         return( ReturnError() );
         }
      }
   else if (leftint == 1)
      {
      // instVarAt: integer put: anObject ^ <primitive 95 1 integer anObject self>  
      OBJECT *newObject = o_nil;
      OBJECT *oldObject = o_nil;
           
      index     = int_value( args[1] );
      obj       = args[3];
      newObject = args[2];
      
      if (is_bltin( obj ) == TRUE)
         {
         sprintf( ErrMsg, PFuncCMsg( MSG_PR_FMT_BUILTIN_ERR_PFUNC ),
                                Class_Name( obj )
                );

         StringCopy( errp, ErrMsg );

         return( ReturnError() );
         }

      if (index < objSize( obj ))
         {
         oldObject = obj->inst_var[ index - 1 ];
         
         obj->inst_var[ index - 1 ] = AssignObj( newObject );
         
         obj_dec( oldObject );
         }
      else
         {
         sprintf( strbuffer, PFuncCMsg( MSG_PR_FMT_INDEX_TOO_BIG_PFUNC ),
                             index
                );
      
         StringCopy( errp, strbuffer );

         return( ReturnError() );
         } 

      rval = newObject;      
      }
     
   if (debug == TRUE)
      {
      fprintf( stderr, PFuncCMsg( MSG_PR_INSTVAR_ACCESS_PFUNC ),
                       int_value( args[0] ), int_value( args[1] ),
                       int_value( args[2] ), leftint == 0 ? 0 : int_value( args[3] )
             );
      }
      
   return( rval );
}  

/****h* ASCIIValue() [1.7] ******************************************
*
* NAME
*    ASCIIValue()  <96>
*
* DESCRIPTION
*    Return a String Object of the given ASCII value.
**********************************************************************
*
*/

PUBLIC OBJECT *ASCIIValue( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (numargs == 1)
      {
      char newstr[2] = { 0, };
      
      if (is_integer( args[0] ) == FALSE) 
         return( PrintArgTypeError( 96 ) );

      sprintf( newstr, "%c", int_value( args[0] ) );

      newstr[1] = NIL_CHAR;           // Just in case.
      rval      = new_str( newstr );
      }

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_ASCII_VALUE_PFUNC ),
                       int_value( args[0] )
             );

   return( rval );
}  

/****h* NewClass() [1.7] *********************************************
*
* NAME
*    NewClass()  <97>
*
* DESCRIPTION
*    Return a new Object of Class 'Class', initialized with the 
*    argument values.  Arguments are class name, superclass name,
*    filename, instance variables, messages, methods, context size,
*    & stackmax value.
*
* NOTES
*    Used by the interpreter a lot when loading the prelude.
**********************************************************************
*
*/

PUBLIC OBJECT *NewClass( int numargs, OBJECT **args )
{
   FBEGIN( printf( "NewClass< %d, OBJ ** 0x%08LX >\n", numargs, args ) );    

   if (ChkArgCount( 8, numargs, 97 ) != 0)
      return( ReturnError() );

   if (is_symbol( args[1] ) == FALSE)  
      return( PrintArgTypeError( 97 ) );

   if (is_symbol( args[2] ) == FALSE)  
      return( PrintArgTypeError( 97 ) );

   if (is_integer( args[6] ) == FALSE) 
      return( PrintArgTypeError( 97 ) );

   if (is_integer( args[7] ) == FALSE) 
      return( PrintArgTypeError( 97 ) );

   resultobj = (OBJECT *) mk_class( leftp, args );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NEW_CLASS_PFUNC ),
                       leftp,
                       symbol_value( (SYMBOL *) args[1] ),
                       symbol_value( (SYMBOL *) args[2] ),
                       args[3], args[4], args[5],
                       int_value( args[6] ), 
                       int_value( args[7] ),
                       resultobj
             );

   FEND( printf( "0x%08LX = NewClass<>\n", resultobj ) );

   return( resultobj );
}

/****h* InstallClass() [1.7] *****************************************
*
* NAME
*    InstallClass()  <98>
*
* DESCRIPTION
*    Insert an Object into the internal class dictionary.  First
*    argument must be Symbol (name of class), 2nd is class definition,
*    3rd argument is a Symbol that tells enter_class() about special
*    classes being present, such as Singleton classes.
*
* NOTES
*    Used by the interpreter a lot when loading the prelude.
**********************************************************************
*
*/

PUBLIC OBJECT *InstallClass( int numargs, OBJECT **args )
{
   FBEGIN( printf( "InstallClass< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (ChkArgCount( 3, numargs, 98 ) == RETURN_OK)
      {
      if (is_class( args[1] ) == FALSE) 
         return( PrintArgTypeError( 98 ) );

      if (debug == TRUE)
         fprintf( stderr, PFuncCMsg( MSG_PR_INSTALL_CLASS1_PFUNC ),
                          leftp, args[1], args[2]
                );

      enter_class( leftp, args[1], args[2] );
   
      return( o_nil );
      }
   else if (ChkArgCount( 2, numargs, 98 ) != RETURN_OK)
      return( ReturnError() );

   // Old p.code form only has 2 arguments:
   if (is_class( args[1] ) == FALSE) 
      return( PrintArgTypeError( 98 ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_INSTALL_CLASS2_PFUNC ),
                       leftp, args[1]
             );

   enter_class( leftp, args[1], NULL );

   FEND( printf( "InstallClass<> exits\n" ) );

   return( o_nil );
}

/****h* FindClass() [1.7] ********************************************
*
* NAME
*    FindClass()  <99>
*
* DESCRIPTION
*    Search for an Object in the internal class dictionary.  The 
*    argument is a Symbol representing the class name.
**********************************************************************
*
*/

PUBLIC OBJECT *FindClass( int numargs, OBJECT **args )
{
   FBEGIN( printf( "FindClass< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (ChkArgCount( 1, numargs, 99 ) != 0)
      return( ReturnError() );

   resultobj = (OBJECT *) lookup_class( leftp );

   if (!resultobj) // == (OBJECT *) NULL) 
      {
      sprintf( errp, PFuncCMsg( MSG_FMT_PR_NOCLASS_PFUNC ), leftp );

      resultobj = AssignObj( new_str( errp ) );

      (void) primitive( ERRPRINT, 1, &resultobj );
      (void) obj_dec( resultobj );

      resultobj = (OBJECT *) lookup_class( OBJECT_NAME );
      
      if (resultobj == 0) 
         cant_happen( NOFIND_CLASSOBJECT );  // Die, you abomination!!
      }

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FIND_CLASS_PFUNC ),
                       leftp, resultobj
             );

   FEND( printf( "0x%08LX = FindClass<>\n", resultobj ) );

   return( resultobj );
}

/****h* StringLen() [1.7] ********************************************
*
* NAME
*    StringLen()  <100>
*
* DESCRIPTION
*    Return an integer Object representing the length of the string.
**********************************************************************
*
*/

PUBLIC OBJECT *StringLen( int numargs, OBJECT **args )
{
   leftint = strlen( leftp );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STRINGLEN_PFUNC ),
                       leftp, leftint
             );

   return( new_int( leftint ) );
}

/****h* StringCompare() [1.7] ****************************************
*
* NAME
*    StringCompare()  <101>
*
* DESCRIPTION
*    Compare two string Objects lexically.
**********************************************************************
*
*/

PUBLIC OBJECT *StringCompare( int numargs, OBJECT **args )
{
   leftint = StringComp( leftp, rightp );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STRINGCOMP_PFUNC ),
               string_value( (STRING *) args[0] ), 
               string_value( (STRING *) args[1] ),
               leftint
             );

   return( new_int( leftint ) );
}

/****h* StringCompNoCase() [1.7] *************************************
*
* NAME
*    StringCompNoCase()  <102>
*
* DESCRIPTION
*    Compare two string Objects lexically without caring about case.
**********************************************************************
*
*/

PUBLIC OBJECT *StringCompNoCase( int numargs, OBJECT **args )
{
   leftint = 1; // leftint == TRUE

   while (leftp || rightp) 
      {
      i = *leftp++;
      j = *rightp++;

      if (i >= CAP_A_CHAR && i <= CAP_Z_CHAR)
         i = i - CAP_A_CHAR + SMALL_A_CHAR;

      if (j >= CAP_A_CHAR && j <= CAP_Z_CHAR)
         j = j - CAP_A_CHAR + SMALL_A_CHAR;

      if (i != j) 
         {
         leftint = 0;  // leftint == FALSE!

         break;
         }
      }

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STRCP_NOCASE_PFUNC ),
               string_value( (STRING *) args[0] ), 
               string_value( (STRING *) args[1] ),
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* String_Cat() [1.7] *******************************************
*
* NAME
*    String_Cat()  <103>
*
* DESCRIPTION
*    Return a new string formed by concatenating the argument strings.
**********************************************************************
*
*/

PUBLIC OBJECT *String_Cat( int numargs, OBJECT **args )
{
   char *newstr = NULL;
   int   i;

   FBEGIN( printf( "Stringcat< 103, %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   // Figure out the length of the resultant string:
   for (i = leftint = 0; i < numargs; i++) 
      {
      if (is_string( args[i] ) == FALSE) 
         return( PrintArgTypeError( 103 ) );

      leftint += strlen( string_value( (STRING *) args[i] ) );
      }

   // was o_alloc() which is now incorrect:
    newstr = (char *) AT_calloc( 1, (unsigned) (1 + leftint), "StringCat", FALSE );
   *newstr = NIL_CHAR;

   for (i = 0; i < numargs; i++)
      strcat( newstr, string_value( (STRING *) args[i] ) );

   resultobj = (OBJECT *) new_istr( newstr );

   if (debug == TRUE)
      {
      fprintf( stderr, PFuncCMsg( MSG_PR_STRINGCAT_PFUNC ), 
               string_value( (STRING *) args[0] )
             );
      
      for (i = 1; i < numargs; i++) 
         fprintf( stderr, "%s ", string_value( (STRING *) args[i] ) );
         
      fprintf( stderr, "> <- 0x%08LX = %s\n", resultobj );
      }

   FEND( printf( "0x%08LX = StringCat< %26.26s >\n", resultobj, newstr ) );

   return( resultobj );
}

/****h* StringAt() [1.7] *********************************************
*
* NAME
*    StringAt()  <104>
*
* DESCRIPTION
*    Return the character found at the position in the string
*    indicated by the second argument.
**********************************************************************
*
*/

PUBLIC OBJECT *StringAt( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   
   if (ChkArgCount( 2, numargs, 104 ) != 0)
      return( ReturnError() );

   leftint = leftp[ i ]; // all of these var's were set in primitive()

   rval = new_char( leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STRING_AT_PFUNC ), 
               leftp, i, rval, leftint
             );

   return( rval );
}

/****h* StringAtPut() [1.7] ******************************************
*
* NAME
*    StringAtPut()  <105>
*
* DESCRIPTION
*    At the position given by the 2nd argument in the string, insert 
*    the character given by the 3rd argument.
**********************************************************************
*
*/

PUBLIC OBJECT *StringAtPut( int numargs, OBJECT **args )
{
   if (ChkArgCount( 3, numargs, 105 ) != 0)
      return( ReturnError() );

   if (is_character( args[2] ) == FALSE) 
      return( PrintArgTypeError( 105 ) );

   leftp[ i ] = int_value( args[2] );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STRING_ATPUT_PFUNC ), 
               leftp, i, int_value( args[2] )
             );

   return( o_nil );
}

/****h* CopyFromLength() [1.7] ***************************************
*
* NAME
*    CopyFromLength()  <106>
*
* DESCRIPTION
*    Starting at the position given by the 2nd argument in the 
*    string, return the substring of the length given by the 3rd
*    argument.
**********************************************************************
*
*/

PUBLIC OBJECT *CopyFromLength( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;
   int     strt = i;
      
   if (ChkArgCount( 3, numargs, 106 ) != 0)
      return( ReturnError() );

   if (is_integer( args[2] ) == 0) 
      return( PrintArgTypeError( 106 ) );

   j = int_value( args[2] );

   if (j < 0) 
      return( PrintIndexError() );

   for (rightp = strbuffer; j > 0; j--, i++)
      *rightp++ = leftp[ i ];

   *rightp = NIL_CHAR;

   rval = new_str( strbuffer );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_COPYFROM_PFUNC ), 
               leftp, strt, int_value( args[2] ), rval
             );

   return( rval );
}

/****h* String_Copy() [1.7] ******************************************
*
* NAME
*    String_Copy()  <107>
*
* DESCRIPTION
*    Return a new string Object identical to the given string.
**********************************************************************
*
*/

PUBLIC OBJECT *String_Copy( int numargs, OBJECT **args )
{
   resultobj = new_str( leftp );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STRINGCOPY_PFUNC ), 
               leftp, resultobj
             );

   return( resultobj );
}

/****h* StringAsSymbol() [1.7] ***************************************
*
* NAME
*    StringAsSymbol()  <108>
*
* DESCRIPTION
*    Return the argument converted into a Symbol.
**********************************************************************
*
*/

PUBLIC OBJECT *StringAsSymbol( int numargs, OBJECT **args )
{
   resultobj = (OBJECT *) new_sym( leftp );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STR_AS_SYM_PFUNC ), 
               leftp, resultobj
             );

   return( resultobj );
}

/****h* StrPrintString() [1.7] ***************************************
*
* NAME
*    StrPrintString()  <109>
*
* DESCRIPTION
*    Return the argument string with single quote marks around it.
**********************************************************************
*
*/

PUBLIC OBJECT *StrPrintString( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STR_PRTSTR_PFUNC ),
                       leftp
             );

   sprintf( strbuffer,"\'%s\'", leftp );

   return( new_str( strbuffer ) );
}

/****h* New_Object() [1.7] *******************************************
*
* NAME
*    New_Object()  <110>
*
* DESCRIPTION
*    Return an untyped Object of the given size.  The Argument must
*    be a positive integer.  Untyped objects are used during system
*    bootstrapping.
**********************************************************************
*
*/

PUBLIC OBJECT *New_Object( int numargs, OBJECT **args )
{
   FBEGIN( printf( "New_Object< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (ChkArgCount( 1, numargs, 110 ) != 0)
      return( ReturnError() );

   if (is_integer( args[0] ) == FALSE) 
      return( PrintArgTypeError( 110 ) );

   leftint = int_value( args[0] );

   if (leftint < 0)
      return( PrintNumberError() );

   resultobj = new_obj( (CLASS *) NULL, leftint, TRUE );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NEW_OBJECT_PFUNC ),
                       int_value( args[0] ), resultobj
             );

   FEND( printf( "0x%08LX = New_Object<>\n", resultobj ) );

   return( resultobj );
}

/****h* ObjectAt() [1.7] *********************************************
*
* NAME
*    ObjectAt()  <111>
*
* DESCRIPTION
*    Return the value found at the given location in the argument.
*    2nd argument MUST be a POSITIVE (> 0) integer.
**********************************************************************
*
*/

PUBLIC OBJECT *ObjectAt( int numargs, OBJECT **args )
{
   FBEGIN( printf( "ObjectAt< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (ChkArgCount( 2, numargs, 111 ) != 0)
      return( ReturnError() );

   if (i < 1 || i > objSize( args[0] ))
      {
      // Index out of bounds:
      PrintIndexError();
      
      resultobj = o_nil;
      
      goto exitObjectAt;
      }
      
   resultobj = args[0]->inst_var[ i - 1 ];

   if (!resultobj) // == NULL)
      {
      // Head off catastrophic failure of the Interpreter:
      resultobj = o_nil;
      
      sprintf( ErrMsg, PFuncCMsg( MSG_FMT_RE_NULL_POINTER_PFUNC ),
                       "<primitive ?? ?? 111> (ObjectAt() -- changed to nil)"
             );
             
      UserInfo( ErrMsg, PFuncCMsg( MSG_RQTITLE_USERPGM_ERROR_PFUNC ) 
              );
      }
      
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_OBJECT_AT_PFUNC ), 
                       args[0], i, resultobj
             );

exitObjectAt:

   FEND( printf( "0x%08LX = ObjectAt<>\n", resultobj ) );

   return( resultobj );
}

/****h* ObjectAtPut() [1.7] ******************************************
*
* NAME
*    ObjectAtPut()  <112>
*
* DESCRIPTION
*    At the location given by the 2nd argument (args[1]), place the 
*    value given by the 3rd argument (args[2]) into the array given
*    by the first argument (args[0]).
**********************************************************************
*
*/

PUBLIC OBJECT *ObjectAtPut( int numargs, OBJECT **args )
{
   FBEGIN( printf( "ObjectAtPut< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (ChkArgCount( 3, numargs, 112 ) != 0)
      return( ReturnError() );

   if (i < 1 || i > objSize( args[0] )) // i is int_value( args[1] )
      {
      // Index out of bounds:
      PrintIndexError();
      
      resultobj = args[2] == NULL ? o_nil : args[2];
      
      goto exitObjectAtPut;
      }
                       
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_OBJECT_ATPUT_PFUNC ), 
               args[0], i, args[2]
             );

   if (!args[2]) // == NULL)
      {
      // Head off catastrophic failure of the Interpreter:
      args[2] = o_nil;
      
      sprintf( ErrMsg, PFuncCMsg( MSG_FMT_RE_NULL_POINTER_PFUNC ),
                       "<primitive ?? ?? ?? 112> (ObjectAtPut() -- changed to nil)"
             );
             
      UserInfo( ErrMsg, PFuncCMsg( MSG_RQTITLE_USERPGM_ERROR_PFUNC ) );
      }
      
   args[0]->inst_var[i - 1] = AssignObj( args[2] );

exitObjectAtPut:

   FEND( printf( "ObjectAtPut<> exits\n" ) );

   return( args[2] );
}

/****h* ObjectGrow() [1.7] *******************************************
*
* NAME
*    ObjectGrow()  <113>
*
* DESCRIPTION
*    Return a new Object with the same instance variables as the
*    1st argument but with the 2nd argument added to the end.  The
*    argument is usually an array.
**********************************************************************
*
*/

PUBLIC OBJECT *ObjectGrow( int numargs, OBJECT **args )
{
   leftarg  = args[0];
   rightarg = args[1];

   FBEGIN( printf( "ObjectGrow< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (is_bltin( leftarg ) == TRUE) 
      return( PrintArgTypeError( 113 ) ); // Can't increase built-ins!

   resultobj = new_obj( leftarg->Class, objSize( leftarg ) + 1, 0 );

   if (leftarg->super_obj) // != NULL)
      {
      resultobj->super_obj = AssignObj( leftarg->super_obj );
      }

   for (i = 0; i < objSize( leftarg ); i++)
      {
      resultobj->inst_var[i] = leftarg->inst_var[i]; // AssignObj( leftarg->inst_var[i] );
      }

   resultobj->inst_var[i] = AssignObj( rightarg );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_OBJECT_GROW_PFUNC ), 
               leftarg, rightarg, resultobj
             );

   FEND( printf( "0x%08LX = ObjectGrow<>\n", resultobj ) );

   return( resultobj );
}

/****h* NewArray() [1.7] *********************************************
*
* NAME
*    NewArray()  <114>
*
* DESCRIPTION
*    Return a new instance of Array of the given size.  Differs from
*    primitive 110 in that the Object is given Class 'Array'.
**********************************************************************
*
*/

PUBLIC OBJECT *NewArray( int numargs, OBJECT **args )
{
   FBEGIN( printf( "NewArray< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   resultobj = new_array( i, TRUE );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NEW_ARRAY_PFUNC ),
                       i, resultobj
             );

   FEND( printf( "0x%08LX = NewArray<>\n", resultobj ) );

   return( resultobj );
}

/****h* NewString() [1.7] ********************************************
*
* NAME
*    NewString()  <115>
*
* DESCRIPTION
*    Return a new string of the given size.  characters are all 
*    spaces.  
*
* WARNINGS 
*    strings will be silently limited to MAX_PRIM_BUFFER_SIZE (512).
**********************************************************************
*
*/
   
PUBLIC OBJECT *NewString( int numargs, OBJECT **args )
{
   IMPORT const int MAX_PRIM_BUFFER_SIZE; // in Primitive.c

   OBJECT *rval = NULL;
   int     pj   = 0;

   FBEGIN( printf( "NewString< 115: %d, OBJ ** 0x%08LX>\n", numargs, args ) );

   // i == int_value( args[0] )
   
   if (i > MAX_PRIM_BUFFER_SIZE)
      i = MAX_PRIM_BUFFER_SIZE - 1; // This is all you get!
      
   for (pj = 0; pj < i; pj++)
      strbuffer[ pj ] = SPACE_CHAR;

   strbuffer[ pj ] = NIL_CHAR;

   rval = new_str( strbuffer );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NEW_STRING_PFUNC ), i, rval );

   FEND( printf( "0x%08LX = NewString( %26.26s )\n", rval, strbuffer ) );   
 
   return( rval );
}

/****h* NewByteArray() [1.7] *****************************************
*
* NAME
*    NewByteArray()  <116>
*
* DESCRIPTION
*    Return a new ByteArray of the given size (initialized).
**********************************************************************
*
*/
   
PUBLIC OBJECT *NewByteArray( int numargs, OBJECT **args )
{
   IMPORT const int MAX_PRIM_BUFFER_SIZE; // in Primitive.c

   int k;
   
   if (i > MAX_PRIM_BUFFER_SIZE)
      {
      sprintf( outmsg, PFuncCMsg( MSG_FMT_BY_BADRNGE_PFUNC ),
                       i, MAX_PRIM_BUFFER_SIZE
             );

      APrint( outmsg );
/*
      Amiga_Printf( "%d out of range! (0 to %d)\n", 
                    i, MAX_PRIM_BUFFER_SIZE
                  );
*/
      return( ReturnError() );
      }
      
   for (k = 0; k < i; k++)
      strbuffer[k] = NIL_CHAR; // clean the strbuffer.
      
   resultobj = new_bytearray( strbuffer, i );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NEW_BARRAY_PFUNC ),
                       i, resultobj
             );

   return( resultobj );
}

/****h* ByteArraySize() [1.7] ****************************************
*
* NAME
*    ByteArraySize()  <117>
*
* DESCRIPTION
*    Return an integer Object representing the size of the ByteArray
*    argument.
**********************************************************************
*
*/

PUBLIC OBJECT *ByteArraySize( int numargs, OBJECT **args )
{
   if (ChkArgCount( 1, numargs, 117 ) != 0)
      return( ReturnError() );

   leftint = byarray->bsize;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BARRAY_SIZE_PFUNC ),
                       byarray, leftint
             );

   return( new_int( leftint ) );
}

/****h* ByteArrayAt() [1.7] ******************************************
*
* NAME
*    ByteArrayAt()  <118>
*
* DESCRIPTION
*    Return the integer Object of the ByteArray at the given location.
*
* WARNINGS
*    There is no bounds checking performed!
**********************************************************************
*
*/

PUBLIC OBJECT *ByteArrayAt( int numargs, OBJECT **args )
{
   if (ChkArgCount( 2, numargs, 118 ) != 0)
      return( ReturnError() );

   leftint = uctoi( byarray->bytes[i] );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BARRAY_AT_PFUNC ),
                       byarray, leftint
             );

   return( new_int( leftint ) );
}

/****h* ByteArrayAtPut() [1.7] ***************************************
*
* NAME
*    ByteArrayAtPut()  <119>
*
* DESCRIPTION
*    At the location given by the 2nd argument, place the value
*    given by the 3rd argument.  1st argument must be a ByteArray.
*
* WARNINGS
*    There is no bounds checking performed!
**********************************************************************
*
*/

PUBLIC OBJECT *ByteArrayAtPut( int numargs, OBJECT **args )
{
   if (ChkArgCount( 3, numargs, 119 ) != 0)
      return( ReturnError() );

   if (int_value( args[2] ) == 0) 
      return( PrintArgTypeError( 119 ) );

   byarray->bytes[i] = itouc( int_value( args[2] ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BARRAY_ATPUT_PFUNC ), 
               byarray, i, int_value( args[2] )
             );

   return( o_nil );
}

/****h* PrintNOReturn() [1.7] ****************************************
*
* NAME
*    PrintNOReturn()  <120>
*
* DESCRIPTION
*    Display the argument string on the output with no carriage
*    return added.
**********************************************************************
*
*/

PUBLIC OBJECT *PrintNOReturn( int numargs, OBJECT **args )
{
   FBEGIN( printf( "PrintNOReturn< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_PRINT_NORET_PFUNC ), leftp );

   sprintf( outmsg, "%s", leftp );
   APrint( outmsg );
   
   // Amiga_Printf( "%s", leftp );

#  ifdef FLUSHREQ
   fflush( stdout );
#  endif

   FEND( printf( "PrintNOReturn<> exits\n" ) );

   return( o_nil );
}

/****h* Print_Return() [1.7] *****************************************
*
* NAME
*    Print_Return()  <121>
*
* DESCRIPTION
*    Display the argument string on the output with a carriage
*    return added.
**********************************************************************
*
*/

PUBLIC OBJECT *Print_Return( int numargs, OBJECT **args )
{
   FBEGIN( printf( "Print_Return< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_PRINT_RETN_PFUNC ), leftp );

   sprintf( outmsg, "%s\n", leftp );
   APrint( outmsg );
   
   // Amiga_Printf( "%s\n", leftp );

#  ifdef FLUSHREQ
   fflush( stdout );
#  endif

   FEND( printf( "Print_Return<> exits\n" ) );

   return( o_nil );
}

/****h* FormatError() [1.7] ******************************************
*
* NAME
*    FormatError()  <122>
*
* DESCRIPTION
*    Display a message on the error output.  1st argument is the
*    receiver, 2nd is a string.  The class of the receiver will be
*    printed, followed by the string.
**********************************************************************
*
*/

PRIVATE BOOL SkipFormatErrorReqs = FALSE;

PUBLIC OBJECT *FormatError( int numargs, OBJECT **args )
{
//   int ans = 0;
   
   aClass = fnd_class( args[1] );

   sprintf( strbuffer,"%s: %s",
            symbol_value( (SYMBOL *) aClass->class_name ), leftp 
          );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FMT_ERR_PFUNC ), 
               symbol_value( (SYMBOL *) aClass->class_name ),
               leftp
             );

   leftp = strbuffer;

   sprintf( outmsg, "%s", leftp );
   APrint( outmsg );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, "%s\n", leftp );
      }

   // Amiga_Printf( "%s", leftp );

/*
   if (SkipFormatErrorReqs == FALSE)
      {
      SetReqButtons( "CONTINUE|Deactivate More Format Error Req's!" );
      ans = Handle_Problem( leftp, "ERROR Report:", NULL );
      SetReqButtons( DefaultButtons );   
      }

   if (ans < 0)
      SkipFormatErrorReqs = TRUE;
   else
      SkipFormatErrorReqs = FALSE;
*/

#  ifdef FLUSHREQ
   fflush( stderr );
#  endif

   return( o_nil );
}

/****h* ErrorPrint() [1.7] *******************************************
*
* NAME
*    ErrorPrint()  <123>
*
* DESCRIPTION
*    Display a string on the error output.
**********************************************************************
*
*/

PRIVATE BOOL SkipErrorReqs = FALSE;

PUBLIC OBJECT *ErrorPrint( int numargs, OBJECT **args )
{
//   int ans = 0;
   
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_ERROR_PRT_PFUNC ), 
               numargs, args, leftp
             );

   sprintf( outmsg, "%s", leftp );
   APrint( outmsg );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, "%s\n", leftp );
      }
   
   // Amiga_Printf( "%s", leftp );

/*
   if (SkipErrorReqs == FALSE)
      {
      SetReqButtons( "CONTINUE|Deactivate More Error Requesters!" );
      ans = Handle_Problem( leftp, "ERROR Print:", NULL );
      SetReqButtons( DefaultButtons );   
      }

   if (ans < 0)
      SkipErrorReqs = TRUE;
   else
      SkipErrorReqs = FALSE;
*/

#  ifdef FLUSHREQ
   fflush( stderr );
#  endif

   return( o_nil );
}

/****h* SystemCall() [1.7] *******************************************
*
* NAME
*    SystemCall()  <125>
*
* DESCRIPTION
*    Execute a system call using the argument as the command string.
**********************************************************************
*
*/

PUBLIC OBJECT *SystemCall( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SYS_CALL_PFUNC ),
                       numargs, args
             );

#  ifndef NOSYSTEM
   leftint = ATSystem( leftp );

   return( new_int( leftint ) );

#  else

   sprintf( strbuffer, PFuncCMsg( MSG_FMT_PR_NOTIMP_PFUNC ),
                       SYSTEM_FUNC
          );

   StringCopy( errp, strbuffer );

   return( ReturnError() );
#  endif
}

/****h* PrintAt() [1.7] **********************************************
*
* NAME
*    PrintAt()  <126>
*
* DESCRIPTION
*    Print a string at a specific point on the terminal.
*
* WARNINGS
*    This function is implemented with the Curses package.
**********************************************************************
*
*/

PUBLIC OBJECT *PrintAt( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_PRINT_AT_PFUNC ),
                       numargs, args
             );

#  ifndef CURSES
   StringCopy( errp, PFuncCMsg( MSG_NO_CURSES_PKG_PFUNC ) );
   return( ReturnError() );

#  else

   if (ChkArgCount( 3, numargs, 126 ) != 0)
      return( ReturnError() );
   
   if ((is_string( args[0] ) == FALSE) || (is_integer( args[1] ) == FALSE)
                                       || (is_integer( args[2] ) == FALSE))
      {
      return( PrintArgTypeError( 126 ) );
      }

   if (debug == TRUE)
      fprintf( stderr, "%s, (%d, %d)\n", 
               string_value( (STRING *) args[0] ), 
               int_value( args[2] ),
               int_value( args[1] )
             );

   // Curses functions:
   move( int_value( args[2] ), int_value( args[1] ) );
   addstr( string_value( (STRING *) args[0] ) );
   refresh();
   move( 0, LINES - 1 );

   return( o_nil );
#  endif
}

/****h* BlockReturn() [1.7] ******************************************
*
* NAME
*    BlockReturn()  <127>
*
* DESCRIPTION
*    Issue an error message that a Block return was attempted without
*    the creating context being active.
**********************************************************************
*
*/

PUBLIC OBJECT *BlockReturn( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BLOCK_RETN_PFUNC ),
                       numargs, args
             );

   StringCopy( errp, PFuncCMsg( MSG_NO_BLK_CTXT_PFUNC ) );

   return( ReturnError() );
}

/****h* ReferenceError() [1.7] ***************************************
*
* NAME
*    ReferenceError()  <128>
*
* DESCRIPTION
*    A reference count was detected that was less than zero.
*    This is a SmallTalk System ERROR!
**********************************************************************
*
*/

PUBLIC OBJECT *ReferenceError( int numargs, OBJECT **args )
{
   if (ChkArgCount( 1, numargs, 128 ) != 0)
      return( ReturnError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_REF_ERROR_PFUNC ), 
               args[0], args[0]->ref_count
             );

   sprintf( strbuffer, PFuncCMsg( MSG_FMT_OBJ_REFCNT_PFUNC ), 
                       args[0], args[0]->ref_count 
          );

   StringCopy( errp, strbuffer );

   return( ReturnError() );
}

/****h* DoesNotRespond() [1.7] ***************************************
*
* NAME
*    DoesNotRespond()  <129>
*
* DESCRIPTION
*    Print a message indicating that an attempt was made to send a
*    message to an Object that did not know how to respond to it.
*    1st argument is the Object to which the message was sent, 2nd
*    argument is the message.
**********************************************************************
*
*/

PUBLIC OBJECT *DoesNotRespond( int numargs, OBJECT **args )
{
   if (ChkArgCount( 2, numargs, 129 ) != 0)
      return( ReturnError() );

   if (is_symbol( args[1] ) == FALSE) 
      return( PrintArgTypeError( 129 ) );

   sprintf( outmsg, PFuncCMsg( MSG_FMT_RSP_ERROR_PFUNC ), 
                    symbol_value( (SYMBOL *) args[1] ) 
          );
   
   APrint( outmsg );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, PFuncCMsg( MSG_FMT_RSP_ERROR_PFUNC ), 
                    symbol_value( (SYMBOL *) args[1] )
             );
      }
/*
   Amiga_Printf( "\n\trespond error:  %s\n", 
                 symbol_value( (SYMBOL *) args[1] ) 
               );
*/
   aClass = fnd_class( args[0] );
   
   if (is_class( (OBJECT *) aClass ) == FALSE) 
      return( PrintArgTypeError( 129 ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NO_RESPONSE_PFUNC ), 
               symbol_value( (SYMBOL *) aClass->class_name ),
               symbol_value( (SYMBOL *) args[1] )
             );


   sprintf( strbuffer, PFuncCMsg( MSG_FMT_NO_RESPOND_PFUNC ),
                       symbol_value( (SYMBOL *) aClass->class_name ), 
                       symbol_value( (SYMBOL *) args[1] )
          );

   StringCopy( errp, strbuffer );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, "%s\n", errp );
      }

   return( ReturnError() );
}

/****h* FileOpen() [1.7] *********************************************
*
* NAME
*    FileOpen()  <130>
*
* DESCRIPTION
*    Open the named file.  2nd argument is the filename as a Symbol,
*    3rd argument is the mode, as a string.
**********************************************************************
*
*/

PUBLIC OBJECT *FileOpen( int numargs, OBJECT **args )
{

   if (ChkArgCount( 3, numargs, 130 ) != 0)
      return( ReturnError() );

   if (is_string( args[1] ) == FALSE) 
      return( PrintArgTypeError( 130 ) );

   if (is_string( args[2] ) == FALSE) 
      return( PrintArgTypeError( 130 ) );

   file_open( phil, string_value( (STRING *) args[1] ), 
                    string_value( (STRING *) args[2] ) 
            );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FILE_OPEN_PFUNC ), 
               phil, 
               string_value( (STRING *) args[1] ), 
               string_value( (STRING *) args[2] )
             );

   return( o_nil );
}

/****h* FileRead() [1.7] *********************************************
*
* NAME
*    FileRead()  <131>
*
* DESCRIPTION
*    Return the next Object from a file.
**********************************************************************
*
*/

PUBLIC OBJECT *FileRead( int numargs, OBJECT **args )
{
   if (ChkArgCount( 1, numargs, 131 ) != 0)
      return( ReturnError() );

   resultobj = file_read( phil );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FILE_READ_PFUNC ), 
               phil->fp, resultobj
             );

   return( resultobj );
}

/****h* FileWrite() [1.7] ********************************************
*
* NAME
*    FileWrite()  <132>
*
* DESCRIPTION
*    Write the Object given by the 2nd argument into the file.
*    The argument must be appropriate for the mode of the file.
**********************************************************************
*
*/

PUBLIC OBJECT *FileWrite( int numargs, OBJECT **args )
{
   if (ChkArgCount( 2, numargs, 132 ) != 0)
      return( ReturnError() );

   file_write( phil, args[1] );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FILE_WRITE_PFUNC ), 
               phil->fp, args[1]
             );

   return( o_nil );
}

/****h* SetFileMode() [1.7] ******************************************
*
* NAME
*    SetFileMode()  <133>
*
* DESCRIPTION
*    Change the mode of a file.
**********************************************************************
*
*/

PUBLIC OBJECT *SetFileMode( int numargs, OBJECT **args )
{
   if (ChkArgCount( 2, numargs, 133 ) != 0)
      return( ReturnError() );

   if (is_integer( args[1] ) == FALSE) 
      return( PrintArgTypeError( 133 ) );

   phil->file_mode = int_value( args[1] );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SETFILE_MODE_PFUNC ), 
               phil->fp, int_value( args[1] )
             );

   return( o_nil );
}

/****h* GetFileSize() [1.7] ******************************************
*
* NAME
*    GetFileSize()  <134>
*
* DESCRIPTION
*    Compute the size of a file (in bytes).
*
* WARNINGS
*    No saving of the current file position is performed!
**********************************************************************
*
*/

PUBLIC OBJECT *GetFileSize( int numargs, OBJECT **args )
{
   fseek( phil->fp, (long) 0, 2 );

   leftint = (int) ftell( phil->fp );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GETFILE_SIZE_PFUNC ), 
               phil->fp, leftint
             );

   return( new_int( leftint ) );
}

/****h* SetFilePosition() [1.7] **************************************
*
* NAME
*    SetFilePosition()  <135>
*
* DESCRIPTION
*    Set the file index pointer to the position given by the 2nd
*    argument.
**********************************************************************
*
*/

PUBLIC OBJECT *SetFilePosition( int numargs, OBJECT **args )
{
   if (ChkArgCount( 2, numargs, 135 ) != 0)
      return( ReturnError() );

   if (is_integer( args[1] ) == FALSE) 
      return( PrintArgTypeError( 135 ) );

   leftint = fseek( phil->fp, (long) int_value( args[1] ), 0 );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SETFILE_POS_PFUNC ), 
               phil->fp, int_value( args[1] ), leftint
             );

   return( new_int( leftint ) );
}

/****h* GetFilePosition() [1.7] **************************************
*
* NAME
*    GetFilePosition()  <136>
*
* DESCRIPTION
*    Return an integer representing the current position in the file.
**********************************************************************
*
*/

PUBLIC OBJECT *GetFilePosition( int numargs, OBJECT **args )
{
   if (ChkArgCount( 1, numargs, 136 ) != 0)
      return( ReturnError() );

   leftint = (int) ftell( phil->fp );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GETFILE_POS_PFUNC ), 
               phil->fp, leftint
             );

   return( new_int( leftint ) );
}

// Primitive 137 handler in ClDict.c

/****h* FileClose() [3.0] ********************************************
*
* NAME
*    FileClose()  <139>
*
* DESCRIPTION
*    Close an open File.
**********************************************************************
*
*/

PUBLIC OBJECT *FileClose( int numargs, OBJECT **args )
{
   if (ChkArgCount( 1, numargs, 139 ) != 0)
      return( ReturnError() );

   free_file( phil ); // in File.c

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FILE_CLOSE_PFUNC ), 
               phil->fp
             );

   return( o_nil );
}

/****h* BlockExecute() [1.7] *****************************************
*
* NAME
*    BlockExecute()  <140>
*
* DESCRIPTION
*    Execute the block argument.  This primitive cannot be executed
*    via a 'doPrimitive' command.
**********************************************************************
*
*/

PUBLIC OBJECT *BlockExecute( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BLOCK_EXEC_PFUNC ),
                       numargs, args
             );

   StringCopy( errp, PFuncCMsg( MSG_NO_BLK_EXEC_PFUNC ) );

   return( ReturnError() );
}

/****h* NewProcessPrim() [1.7] ***************************************
*
* NAME
*    NewProcessPrim()  <141>
*
* DESCRIPTION
*    The 1st argument must be a block.  If the 2nd argument is given,
*    it must be an array of arguments to be used as parameters to the
*    block.  A new process is created that will execute the block.
**********************************************************************
*
*/

PUBLIC OBJECT *NewProcessPrim( int numargs, OBJECT **args )
{
   if (numargs < 1)
      {
      sprintf( strbuffer, PFuncCMsg( MSG_FMT_WRONG_ARGS_PFUNC ), numargs );

      StringCopy( errp, strbuffer );

      return( ReturnError() );
      }

   if (is_block( args[0] ) == FALSE) 
      return( PrintArgTypeError( 141 ) );

   if (numargs == 1)
      resultobj = (OBJECT *)
                   block_execute( (INTERPRETER *) NULL, 
                                  (BLOCK *) args[0], 0, args 
                                );

   else if (numargs == 2)
      resultobj = (OBJECT *) block_execute( (INTERPRETER *) NULL, 
                                            (BLOCK *) args[0], 
                                            objSize( args[1] ),
                                            &(args[1]->inst_var[0])
                                          );
   else
      {
      sprintf( strbuffer, PFuncCMsg( MSG_FMT_WRONG_ARGS_PFUNC ),
                          numargs
             );

      StringCopy( errp, strbuffer );

      return( ReturnError() );
      }

   if (!resultobj) // == ((OBJECT *) NULL)) 
      return( o_nil );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_NEW_PROCESS_PFUNC ),
                       args[0], args[1]
             );

   resultobj = (OBJECT *) cr_process( (INTERPRETER *) resultobj );

   return( resultobj );
}

/****h* TerminateProcess() [1.7] *************************************
*
* NAME
*    TerminateProcess()  <142>
*
* DESCRIPTION
*    Terminate the Process argument.
**********************************************************************
*
*/

PUBLIC OBJECT *TerminateProcess( int numargs, OBJECT **args )
{
   if (ChkArgCount( 1, numargs, 142 ) != 0)
      return( ReturnError() );

   if (is_process( args[0] ) == FALSE) 
      return( PrintArgTypeError( 142 ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_TERM_PROCESS_PFUNC ),
                       args[0]
             );

   terminate_process( (PROCESS *) args[0] );

   return( o_nil );
}

/****h* Perform_W_Args() [1.7] ***************************************
*
* NAME
*    Perform_W_Args()  <143>
*
* DESCRIPTION
*    The 1st argument is a Symbol representing the message to be 
*    sent.  The 2nd argument is an Array of values to be used in 
*    performing the message.  The 1st element of this array is the
*    receiver of the message.  This primitive cannot be executed
*    via a 'doPrimitive:' command.
**********************************************************************
*
*/

PUBLIC OBJECT *Perform_W_Args( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_PRFM_WARGS_PFUNC ),
                       numargs, args
             );

   StringCopy( errp, PFuncCMsg( MSG_PERFORM_NOTRAP_PFUNC ) );

   return( ReturnError() );
}

/****h* BlockNumArgs() [2.3] **********************************
*
* NAME
*    BlockNumArgs() <144>
*
* DESCRIPTION
*    Return/Set the numargs field of the Block structure.
*    <primitive 144 0-1 self ?> (was unused primitive).
***************************************************************
*
*/

PUBLIC OBJECT *BlockNumArgs( int numargs, OBJECT **args )
{
   OBJECT *rval   = o_nil;
   int     action = 0;
   
   if (is_integer( args[1] ) == FALSE)
      {
      (void) PrintArgTypeError( 144 );
      
      return( rval );
      }  
   else
      action = int_value( args[1] );

   switch (action)
      {
      case 0: // retrieve numArguments only.
         if (numargs != 2)
            return( ArgCountError( 3, 144 ) );
         else if (!is_integer( args[1] ) || !is_block( args[2] ))
            {
            (void) PrintArgTypeError( 144 );

            break;
            }
         else
            rval = new_int( ((BLOCK *) args[2])->numargs );
   
         break;
                  
      case 1: // Set the numargs field.   
         if (numargs != 3) 
            return( ArgCountError( 3, 144 ) );
         else if (!is_integer( args[1] ) || !is_block( args[2] )
                                         || !is_integer( args[3] ))
            {
            (void) PrintArgTypeError( 144 );

            break;
            }

         ((BLOCK *) args[2])->numargs = int_value( args[3] );
         /* FALL THROUGH */

      default:  // Bonehead User!!
         break;
      }

   return( rval );
}

/****h* SetProcessState() [1.7] **************************************
*
* NAME
*    SetProcessState()  <145>
*
* DESCRIPTION
*    Change the state of the Process argument.
**********************************************************************
*
*/

PUBLIC OBJECT *SetProcessState( int numargs, OBJECT **args )
{
   char st[20] = { 0, };
   
   if (ChkArgCount( 2, numargs, 145 ) != 0)
      return( ReturnError() );

   if (is_process( args[0] ) == FALSE) 
      return( PrintArgTypeError( 145 ) );

   if (is_integer( args[1] ) == FALSE) 
      return( PrintArgTypeError( 145 ) );

   leftint = int_value( args[1] );

   switch (leftint) 
      {
      case 0: // == ACTIVE??   
         leftint = READY;               // READY <= ~SUSPENDED
         StringCopy( &st[0], PFuncCMsg( MSG_PROC_READY_PFUNC ) );
         break;

      case 1: // == SUSPENDED??  
         leftint = SUSPENDED;
         StringCopy( &st[0], PFuncCMsg( MSG_PROC_SUSPENDED_PFUNC ) );
         break;

      case 2: // == BLOCKED??  
         leftint = BLOCKED;
         StringCopy( &st[0], PFuncCMsg( MSG_PROC_BLOCKED_PFUNC ) );
         break;

      case 3:   
         leftint = UNBLOCKED;           // UNBLOCKED <= ~BLOCKED
         StringCopy( &st[0], PFuncCMsg( MSG_PROC_UNBLOCKED_PFUNC ) );
         break;

      default:  
         StringCopy( errp, PFuncCMsg( MSG_INVALID_STATE_PR_PFUNC ) );
         return( ReturnError() );
      }

   set_state( (PROCESS *) args[0], leftint );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_SET_PROCSTATE_PFUNC ),
                       args[0], &st[0]
             );

   return( new_int( leftint ) );
}

/****h* GetProcessState() [1.7] **************************************
*
* NAME
*    GetProcessState()  <146>
*
* DESCRIPTION
*    Return an integer OBject indicating the state of the Process.
**********************************************************************
*
*/

PUBLIC OBJECT *GetProcessState( int numargs, OBJECT **args )
{
   if (ChkArgCount( 1, numargs, 146 ) != 0)
      return( ReturnError() );

   if (is_process( args[0] ) == FALSE) 
      return( PrintArgTypeError( 146 ) );

   leftint = set_state( (PROCESS *) args[0], CUR_STATE );

   if (debug == TRUE)
      {
      char st[20] = { 0, };
      
      switch (leftint)
         {
         case BLOCKED:
            StringCopy( &st[0], PFuncCMsg( MSG_PROC_BLOCKED_PFUNC ) );
            break;
            
         case SUSPENDED:
            StringCopy( &st[0], PFuncCMsg( MSG_PROC_SUSPENDED_PFUNC ) );
            break;
            
         case TERMINATED:
            StringCopy( &st[0], PFuncCMsg( MSG_PROC_TERMINATED_PFUNC ) );
            break;
            
         case READY:
            StringCopy( &st[0], PFuncCMsg( MSG_PROC_READY_PFUNC ) );
            break;
            
         case UNBLOCKED:
            StringCopy( &st[0], PFuncCMsg( MSG_PROC_UNBLOCKED_PFUNC ) );
            break;
            
         case CUR_STATE:
            StringCopy( &st[0], PFuncCMsg( MSG_PROC_CUR_STATE_PFUNC ) );
            break;
         }

      fprintf( stderr, PFuncCMsg( MSG_PR_GET_PROCSTATE_PFUNC ), 
                       args[0], &st[0]
             );
      }

   return( new_int( leftint ) );
}

/****h* BeginAtomicAction() [1.7] ************************************
*
* NAME
*    BeginAtomicAction()  <148>
*
* DESCRIPTION
*    Begin executing atomic actions.  While executing in this mode,
*    no new Processes will be started.  Thus the current process can
*    execute without interruption by Little SmallTalk.
**********************************************************************
*
*/

PUBLIC OBJECT *BeginAtomicAction( int numargs, OBJECT **args )
{
   IMPORT int atomcnt; // in Process.c

   if (ChkArgCount( 0, numargs, 148 ) != 0)
      return( ReturnError() );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_BEGIN_ATOMIC_PFUNC ),
                       atomcnt + 1
             );

   atomcnt++;

   return( o_nil );
}

/****h* EndAtomicAction() [1.7] **************************************
*
* NAME
*    EndAtomicAction()  <149>
*
* DESCRIPTION
*    End executing atomic actions.
**********************************************************************
*
*/

PUBLIC OBJECT *EndAtomicAction( int numargs, OBJECT **args )
{
   IMPORT int atomcnt; // in Process.c

   if (ChkArgCount( 0, numargs, 149 ) != 0)
      return( ReturnError() );

   if (atomcnt == 0) 
      {
      StringCopy( errp, PFuncCMsg( MSG_NOT_ATOMIC_PFUNC ) );
      return( ReturnError() );
      }

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_END_ATOMIC_PFUNC ),
                       atomcnt - 1
             );

   atomcnt--;

   return( o_nil );
}

/****h* EditClass() [1.7] ********************************************
*
* NAME
*    EditClass()  <150>
*
* DESCRIPTION
*    Place the user in an Editor, editing the description of the 
*    given class.  When the user exits the editor, the class descrip-
*    tion will automatically be re-parsed & included.
**********************************************************************
*
*/

PUBLIC OBJECT *EditClass( int numargs, OBJECT **args )
{
   IMPORT int writeable( char *name );

   char name[100], *tempname = NULL;
   
   leftp = symbol_value( (SYMBOL *) aClass->file_name );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_EDIT_CLASSFILE_PFUNC ),
                       leftp
             );

   if (writeable( leftp ) == 0) 
      {
#     ifndef NOSYSTEM
      tempname = tmpnam( &name[0] );

      sprintf( strbuffer, PFuncCMsg( MSG_FMT_COPY_CMD_PFUNC ), 
                          leftp, tempname
             );

      system( strbuffer );

      leftp = tempname;
#     endif
      }

   if (lexedit( leftp ) == 0) 
      lexinclude( leftp );

   return( o_nil );
}

/****h* FindSuperClass() [1.7] ***************************************
*
* NAME
*    FindSuperClass()  <151>
*
* DESCRIPTION
*    Return the superclass of the argument class.
**********************************************************************
*
*/

PUBLIC OBJECT *FindSuperClass( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   FBEGIN( printf( "FindSuperClass< %d, OBJ ** 0x%08LX >\n", numargs, args ) );   

   if (!aClass->super_class) // == NULL)
      {
      rval = o_nil;
      goto ReturnSuperClass;
      }

   rval = resultobj = (OBJECT *) aClass->super_class;

   if (is_symbol( rval ) == FALSE) // No Parent!
      {
      rval = o_nil;
      goto ReturnSuperClass;
      }

   rval = (OBJECT *) lookup_class( symbol_value( (SYMBOL *) resultobj ) );

   if (!rval) // == NULL) 
      rval = o_nil;

ReturnSuperClass:

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_FIND_SUPERCLASS_PFUNC ), 
               symbol_value( (SYMBOL *) aClass->class_name ),
               rval
             );

   if (TraceFile && traceByteCodes == TRUE)
      {
      if (rval != o_nil)
         fprintf( TraceFile, "%s = ", 
                  symbol_value( (SYMBOL *) aClass->class_name ) 
                );
      else
         fprintf( TraceFile, PFuncCMsg( MSG_NIL_EQUAL_PFUNC ) );
      }

   FEND( printf( "0x%08LX = FindSuperClass<>\n", rval ) );      

   return( rval );
}

/****h* GetClassName() [1.7] *****************************************
*
* NAME
*    GetClassName()  <152>
*
* DESCRIPTION
*    Return a Symbol representing the name of the argument class.
**********************************************************************
*
*/

PUBLIC OBJECT *GetClassName( int numargs, OBJECT **args )
{
   resultobj = aClass->class_name;
   leftp     = symbol_value( (SYMBOL *) resultobj );
   resultobj = new_str( leftp );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GET_CLASSNAME_PFUNC ),
               symbol_value( (SYMBOL *) aClass->class_name ),
               resultobj
             );

   return( resultobj );
}

/****h* ClassNew() [1.7] *********************************************
*
* NAME
*    ClassNew()  <153>
*
* DESCRIPTION
*    Return a new instance of the given class.
**********************************************************************
*
*/

PUBLIC OBJECT *ClassNew( int numargs, OBJECT **args )
{
   FBEGIN( printf( "ClassNew< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (ChkArgCount( 2, numargs, 153 ) != 0)
      return( ReturnError() );

   if (args[1] == o_nil)
      resultobj = new_inst( aClass );
   else
      resultobj = new_sinst( aClass, args[1] );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CLASS_NEW_PFUNC ), 
               symbol_value( (SYMBOL *) aClass->class_name ),
               args[1] == o_nil ? PFuncCMsg( MSG_LX_NIL_STR_PFUNC ) 
                                : PFuncCMsg( MSG_ARGUMENTS_STRING_PFUNC ), 
               resultobj
             );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, "%s = ",
               symbol_value( (SYMBOL *) aClass->class_name ) 
             );
      }

   FEND( printf( "0x%08LX = ClassNew<>\n", resultobj ) );
      
   return( resultobj );
}

/****h* PrintMessages() [1.7] ****************************************
*
* NAME
*    PrintMessages()  <154>
*
* DESCRIPTION
*    List all the methods to which the class responds.
**********************************************************************
*
*/
   
PUBLIC OBJECT *PrintMessages( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_PRNT_MSGS_PFUNC ), 
               symbol_value( (SYMBOL *) aClass->class_name ) 
             );

   prnt_messages( aClass );

   return( o_nil );
}

/****h* ClassRespondsTo() [1.7] **************************************
*
* NAME
*    ClassRespondsTo()  <155>
*
* DESCRIPTION
*    Return true Object if the class responds to the Symbol re-
*    presented by the 2nd argument.
**********************************************************************
*
*/

PUBLIC OBJECT *ClassRespondsTo( int numargs, OBJECT **args )
{
   FBEGIN( printf( "ClassRespondsTo< %d, OBJ ** 0x%08LX >\n", numargs, args ) );

   if (ChkArgCount( 2, numargs, 155 ) != 0)
      return( ReturnError() );

   if (is_symbol( args[1] ) == FALSE) 
      return( PrintArgTypeError( 155 ) );

   leftint = responds_to( symbol_value( (SYMBOL *) args[1] ), aClass );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CLASS_RESPONSE_PFUNC ),
               symbol_value( (SYMBOL *) aClass->class_name ), 
               symbol_value( (SYMBOL *) args[1] ),
               leftint == FALSE ? FALSE_NAME : TRUE_NAME
             );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, "%s-%s = ",
               symbol_value( (SYMBOL *) aClass->class_name ), 
               symbol_value( (SYMBOL *) args[1] )
             );
      }

   FEND( printf( "%d = ClassRespondsTo<>\n", leftint ) );
      
   return( (leftint != FALSE) ? o_true : o_false );
}

/****h* ViewClass() [1.7] ********************************************
*
* NAME
*    ViewClass()  <156>
*
* DESCRIPTION
*    Place the user in an Editor, editing the description of the 
*    given class.  Changed class is NOT included when the user exits.
**********************************************************************
*
*/

PUBLIC OBJECT *ViewClass( int numargs, OBJECT **args )
{
   char name[100], *tempname = NULL;

   leftp    = symbol_value( (SYMBOL *) aClass->file_name );
   tempname = tmpnam( &name[0] );

#  ifndef NOSYSTEM
   sprintf( strbuffer, PFuncCMsg( MSG_FMT_COPY_CMD_PFUNC ),
                       leftp, tempname
          );

   system( strbuffer );
#  endif

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_VIEW_CLASS_PFUNC ),
                       leftp
             );

   leftp = tempname;
   lexedit( leftp );

   return( o_nil );
}

/****h* ListSubClasses() [1.7] ***************************************
*
* NAME
*    ListSubClasses()  <157>
*
* DESCRIPTION
*    List all sub-classes of the given class.
**********************************************************************
*
*/

PUBLIC OBJECT *ListSubClasses( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_LIST_SUBS_PFUNC ), 
               symbol_value( (SYMBOL *) aClass->class_name ) 
             );

   class_list( aClass, 0 );

   return( o_nil );
}

/****h* ClassesInstVars() [1.7] **************************************
*
* NAME
*    ClassesInstVars()  <158>
*
* DESCRIPTION
*    Return an array of Symbols representing the names of the 
*    instance variables for the given class.
**********************************************************************
*
*/

PUBLIC OBJECT *ClassesInstVars( int numargs, OBJECT **args )
{
   resultobj = aClass->inst_vars;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CLASS_INSTS_PFUNC ), 
               symbol_value( (SYMBOL *) aClass->class_name ), 
               resultobj
             );

   return( resultobj );
}

/****h* AmigaTalk/GetByteCodeArray() [1.7] **************************
*
* NAME
*    GetByteCodeArray( Class *classptr, char *methodname );
*
* NOTES
*    Added on 09/26/1998, NOT an original Little SmallTalk primitive.
*
* SEE ALSO
*    lookup_method();  <159>
*********************************************************************
*
*/

PUBLIC OBJECT *GetByteCodeArray( int numargs, OBJECT **args )
{
   BYTEARRAY *rval = NULL;
    
   if (ChkArgCount( 2, numargs, 159 ) != 0)
      return( ReturnError() );

   if (is_string( args[1] ) == FALSE) 
      return( PrintArgTypeError( 159 ) );

   rval = lookup_method( aClass, string_value( (STRING *) args[1] ) );

   if (rval) // != NULL)
      obj_inc( (OBJECT *) rval ); // Don't want the ByteArray to disappear!
      
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GET_BARRAY_PFUNC ), 
               symbol_value( (SYMBOL *) aClass->class_name ), 
               string_value( (STRING *) args[1] ), 
               rval 
             );

   return( (OBJECT *) rval );
}

/****h* GetCurrentTime() [1.7] ***************************************
*
* NAME
*    GetCurrentTime()  <160>
*
* DESCRIPTION
*    Return a string representing the current time & date.
**********************************************************************
*
*/

PUBLIC OBJECT *GetCurrentTime( int numargs, OBJECT **args )
{
   time( &myClock );
   StringCopy( strbuffer, ctime( &myClock ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GET_CTIME_PFUNC ),
                       strbuffer
             );

   return( new_str( strbuffer ) );
}

/****h* TimeCounter() [1.7] ******************************************
*
* NAME
*    TimeCounter()  <161>
*
* DESCRIPTION
*    Return an integer Object that is counted as a seconds time clock.
**********************************************************************
*
*/

PUBLIC OBJECT *TimeCounter( int numargs, OBJECT **args )
{
   leftint = (int) time( (long *) NULL );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_TIME_CNTR_PFUNC ),
                       leftint
             );

   return( new_int( leftint ) );
}

/****h* ClearScreen() [1.7] ******************************************
*
* NAME
*    ClearScreen()  <162>
*
* DESCRIPTION
*    Clear the User's screen (If Curses or Plot3 is used).
**********************************************************************
*
*/

PUBLIC OBJECT *PFClearScreen( int numargs, OBJECT **args )
{
   OBJECT *rval = NULL;

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_CLR_SCREEN_PFUNC ),
                       numargs, args
             );

#  ifdef CURSES
   clear();
   move( 0, 0 );
   refresh();
#  endif

#  ifdef PLOT3
   rval = PlotClear( numargs, args );  /* primitive 170 */
   return( rval );
#  else
   return( o_nil );
#  endif
}

/****h* GetString() [1.7] ********************************************
*
* NAME
*    GetString()  <163>
*
* DESCRIPTION
*    Returns text typed at the terminal as a string Object.
*    This function does NOT currently do anything!
**********************************************************************
*
*/

PUBLIC OBJECT *GetString( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_GET_STRING_PFUNC ),
                       numargs, args
             );

   return( o_nil );
}

/****h* StringToInteger() [1.7] **************************************
*
* NAME
*    StringToInteger()  <164>
*
* DESCRIPTION
*    Convert a string Object to an integer Object.
**********************************************************************
*
*/

PUBLIC OBJECT *StringToInteger( int numargs, OBJECT **args )
{
   if (numargs != 1) 
      return( ArgCountError( 1, 164 ) );

   if (is_string( args[0]) == FALSE)
      return( PrintArgTypeError( 164 ) );

   leftint = atoi( string_value( (STRING *) args[0] ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STR2INT_PFUNC ), 
               leftint, string_value( (STRING *) args[0] )
             );

   return( new_int( leftint ) );
}

/****h* StringToFloat() [1.7] ****************************************
*
* NAME
*    StringToFloat()  <165>
*
* DESCRIPTION
*    Convert a string Object to a float Object.
**********************************************************************
*
*/

PUBLIC OBJECT *StringToFloat( int numargs, OBJECT **args )
{
   if (numargs != 1) 
      return( ArgCountError( 1, 165 ) );

   if (is_string( args[0] ) == FALSE)
      return( PrintArgTypeError( 165 ) );

   leftfloat = atof( string_value( (STRING *) args[0] ) );

   if (debug == TRUE)
      fprintf( stderr, PFuncCMsg( MSG_PR_STR2FLOAT_PFUNC ), 
               leftfloat, string_value( (STRING *) args[0] )
             );

   return( new_float( leftfloat ) );
}

/* -------------------- END of PrimFuncs.c file! -------------------- */
