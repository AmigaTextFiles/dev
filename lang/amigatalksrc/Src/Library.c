/****h* AmigaTalk/Library.c [3.0] ***********************************
* 
* NAME
*    Library.c
*
* DESCRIPTION
*    Functions that handle AmigaTalk library primitives.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    28-Dec-2001 - Re-written to remove Libraries from the 
*                  tyranny of the AList() code.
*
* FUNCTIONAL INTERFACE
*
*   PUBLIC OBJECT *HandleLibraries( int numargs, OBJECT **args );
* 
* NOTES
*    $VER: AmigaTalk:Src/Library.c 3.0 (25-Oct-2004) by J.T Steichen
*********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <exec/execbase.h>
#include <AmigaDOSErrs.h>

#ifdef    __SASC
# include <clib/exec_protos.h>
#else

# define __USE_INLINE__

# include <proto/exec.h>

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Object.h"
#include "Constants.h"

#include "FuncProtos.h"


IMPORT OBJECT *o_nil;

IMPORT UBYTE  *ErrMsg;
IMPORT UBYTE  *ATalkProblem;


/****i* CloseTheLibrary() [3.0] **************************************
*
* NAME
*    CloseTheLibrary()
*
* DESCRIPTION
*    <primitive 190 0 private>
**********************************************************************
*
*/

PRIVATE void CloseTheLibrary( OBJECT *libObj )
{
   struct Library *libptr = (struct Library *) CheckObject( libObj );

   if (libptr) // != NULL)
      CloseLibrary( libptr );
      
   return;
}

/****i* OpenALibrary() [3.0] *****************************************
*
* NAME
*    OpenALibrary()
*
* DESCRIPTION
*    private <- <primitive 190 1 libName version>
**********************************************************************
*
*/

PRIVATE OBJECT *OpenALibrary( char *libName, int version )
{
   OBJECT         *NewObj = (OBJECT *) NULL;
   struct Library *lib    = OpenLibrary( libName, version );

   if (!lib) // == NULL)
      {
      sprintf( ErrMsg, "%s V%d", libName, version );

      NotOpened( 4 );

      return;
      }

   NewObj = AssignObj( new_address( (ULONG) lib ) );

   return( NewObj );
}

/****i* GetLibraryPart() [3.0] ***************************************
*
* NAME
*    GetLibraryPart()
*
* DESCRIPTION
*    ^ <primitive 190 2 whichpart private>
**********************************************************************
*
*/
     
METHODFUNC OBJECT *GetLibraryPart( int whichpart, OBJECT *libObj )
{
   struct Library *libptr = (struct Library *) CheckObject( libObj );
   OBJECT         *rval   = o_nil;

   if (!libptr) // == NULL)
      return( rval );
      
   switch (whichpart)
      {
      case 1: // NegSize: 
         rval = AssignObj( new_int( libptr->lib_NegSize ));
         break;

      case 2: // PosSize:
         rval = AssignObj( new_int( libptr->lib_PosSize ));
         break;

      case 3: // Flags:
         rval = AssignObj( new_int( libptr->lib_Flags ));
         break;

      case 4: // Version:
         rval = AssignObj( new_int( libptr->lib_Version ));
         break;

      case 5: // Revision:
         rval = AssignObj( new_int( libptr->lib_Revision ));
         break;

      case 6: // CheckSum:
         rval = AssignObj( new_int( libptr->lib_Sum ));
         break;

      case 7: // OpenCount:
         rval = AssignObj( new_int( libptr->lib_OpenCnt ));
         break;

      default:
         break;
      } 

   return( rval );
}


/****h* HandleLibraries() [3.0] **************************************
*
* NAME
*    HandleLibraries()
*
* DESCRIPTION
*    Translate primitives (190) to Library handlers.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleLibraries( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 190 );
      return( rval );
      }
 
   numargs--;
           
   switch (int_value( args[0] ))
      {
      case 0: // close ! private !
         if (NullChk( args[1] ) == FALSE)
            {
            CloseTheLibrary( args[1] );
            }

         break;
      
      case 1: // openLibrary: libName version: ver ! private !
         if (numargs != 2)
            return( ArgCountError( 2, 190 ) );

         if (is_string( args[1] ) == FALSE || !is_integer( args[2] ))
            (void) PrintArgTypeError( 190 );
         else
            rval = OpenALibrary( string_value( (STRING *) args[1] ),
                                    int_value( args[2] ) 
                               ); 
         break;

      case 2: // get a piece of the library structure:
         if (numargs != 2)
            return( ArgCountError( 2, 190 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 190 ) );
         else
            rval = GetLibraryPart( int_value( args[1] ), args[2] );

         break;

      default:
         (void) PrintArgTypeError( 190 );
         break;
      }
   
   return( rval );
}

/* -------------------- END of Library.c file! ----------------------- */
