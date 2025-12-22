/****h* AmigaTalk/SrcFile.c [2.0] *************************************
*
* NAME 
*   SrcFile.c
*
* DESCRIPTION
*   Functions that handle ??? to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleSrcFile( int numargs, OBJECT **args ); <???>
*
* HISTORY
*   27-Dec-2001 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/SrcFile.c 2.0 (05-Feb-2002) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <clib/intuition_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *SystemProblem;

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

/****i* Primitive0() [2.0] ********************************************
*
* NAME
*    Primitive0()
*
* DESCRIPTION
*    ^ <primitive ??? ?? private>
***********************************************************************
*
*/

METHODFUNC OBJECT *Primitive0( OBJECT *dtObject )
{
   APTR    bp   = (APTR) CheckObject( dtObject );
   OBJECT *rval = o_nil;
      
   return( rval );
}

/****i* Primitive1() [2.0] ********************************************
*
* NAME
*    Primitive1()
*
* DESCRIPTION
*    <primitive ??? ?? private>
***********************************************************************
*
*/

METHODFUNC void Primitive1( OBJECT *iclassPtr )
{
   struct IClass *iclass = (struct IClass *) CheckObject( iclassPtr );
   
   return;
}
      
/****h* HandleSrcFile() [2.0] ******************************************
*
* NAME
*    HandleSrcFile() {Primitive ???}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    SrcFile interfacing methods.
************************************************************************
*
*/

PUBLIC OBJECT *HandleSrcFile( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( ??? );
      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: //
         Primitive1( args[1] );
         KillObject( args[1] );

         break;

      case 1: //
         if (!is_string( args[2] ) || !is_array( args[3] ))
            (void) PrintArgTypeError( ??? );
         else
            rval = Primitive0(                          args[1],
                               string_value( (STRING *) args[2] ),
                                                        args[3] 
                             );
         break;
      
      case 2: //
         Primitive2( args[1] );

         break;
      
      default:
         (void) PrintArgTypeError( ??? );

         break;
      }

   return( rval );
}

/* ---------------------- END of SrcFile.c file! ----------------------- */
