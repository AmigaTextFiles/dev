/****h* AmigaTalk/Keyboard.c [3.0] *************************************
*
* NAME
*    Keyboard.c
*
* DESCRIPTION
*    <222 0-1 ?? parms>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    15-Apr-2002 Created this file.
*
* NOTES
*    FUNCTIONAL INTERFACE:
*       PUBLIC OBJECT *HandleConsoleKeys( int numargs, OBJECT **args );
*
*    $VER: Keyboard.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>

#include <libraries/gadtools.h>

#include <devices/inputevent.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/graphics_protos.h>
# include <clib/gadtools_protos.h>

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Env.h"
#include "ATStructs.h"
#include "FuncProtos.h"

#include "Constants.h" // char_value(), etc.
#include "CProtos.h"   // Console protos

// ----------------------------------------------------------------------

IMPORT OBJECT *o_nil, *o_true, *o_false; // , *o_IDCMP_rval;

/****i* getRawKey() [3.0] ********************************************
*
* NAME
*    getRawKey()
*
* DESCRIPTION
*
* NOTES
*    Smalltalk code has to call this <primitive 222 1 0 self>
*    inside a loop if there is more than one IDCMP event expected.
*
*    ^ <primitive 222 1 0 self>
**********************************************************************
*
*/

METHODFUNC OBJECT *getRawKey( OBJECT *keyObj )
{
   struct Window       *wp = (struct Window *) NULL;
   struct IntuiMessage *message, Msg = { 0, };

   OBJECT *rval     = o_nil;
   ULONG   oldIDCMP = 0L;
   int     checking = TRUE;
   UWORD   qualMask = (UWORD) (~IEQUALIFIER_RELATIVEMOUSE); // 0x7FFF
   
   wp = (struct Window *) CheckObject( keyObj->inst_var[2] ); 

   if (!wp) // == NULL)
      return( rval );

   oldIDCMP = wp->IDCMPFlags;
   
   ModifyIDCMP( wp, (oldIDCMP | IDCMP_RAWKEY & (~IDCMP_VANILLAKEY)) );      	

   Msg.Qualifier = IEQUALIFIER_MIDBUTTON;
   
   while ((checking == TRUE) && ((qualMask & Msg.Qualifier) != 0))    
      {
      if (!(message = GT_GetIMsg( wp->UserPort ))) // == NULL)
         {
         (void) Wait( 1L << wp->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) message, (char *) &Msg, 
               (long) sizeof( struct IntuiMessage )
             );

      (void) GT_ReplyIMsg( message );

      switch (Msg.Class)   
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( wp );
            GT_EndRefresh( wp, TRUE );
            break;

         case IDCMP_RAWKEY:
            {
            OBJECT *newQual;
            
            rval    = new_int( (int) Msg.Code      );
            newQual = new_int( (int) Msg.Qualifier );

            obj_dec( keyObj->inst_var[0] ); // old keyCode
            obj_dec( keyObj->inst_var[1] ); // old keyQualifier

            keyObj->inst_var[0] = AssignObj( rval );
            keyObj->inst_var[1] = AssignObj( newQual );
            }

            if (Msg.Qualifier & qualMask != 0)
               break;
            else
               checking = FALSE; // Only way out of the Loop!

            break;

         default:                        
            break;
         }
      }                // End of while Loop!!

   ModifyIDCMP( wp, oldIDCMP );
   
   return( rval );
}

PRIVATE int vanillaKey[] = {

   '`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0x5C,
   '?', '0', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']',
   '?', '1', '2', '3', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', 0x27,
   '?', '?', '4', '5', '6', '?', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',
   '?', '.', '7', '8', '9', ' ',  8,   9,   10,  10,  27, 0x7F, '?', '?', '?',
   '-', '?', '^',  11, ' ',  8,  '?', '?', '?', '?', '?', '?',  '?', '?', '?', '?',
   '(', ')', '/', '*', '+', '?', '?', '?', '?', '?', '?', '?',  '?', '?', 

   // Shifted values: 

   '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '|',
   '?', '0', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}',
   '?', '1', '2', '3', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"',
   '?', '?', '4', '5', '6', '?', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?',
   '?', '.', '7', '8', '9', ' ',  8,   9,   10,  10, 27, 0x7F, '?', '?', '?',
   '-', '?', '^',  11, ' ',  8,  '?', '?', '?', '?', '?', '?',  '?', '?', '?', '?',
   '(', ')', '/', '*', '+', '?', '?', '?', '?', '?', '?', '?',  '?', '?' 
};

/****h* translateKey() [3.0] *******************************************
*
* NAME
*    translateKey()
*
* DESCRIPTION
*    ^ <primitive 222 1 1 rawKeyCode shiftBoolean>
************************************************************************
*
*/

METHODFUNC OBJECT *translateKey( int rawKeyCode, OBJECT *shiftObj )
{
   int     key   = vanillaKey[ rawKeyCode ];
   BOOL    shift = shiftObj == o_true ? TRUE : FALSE;

   if (shift == TRUE)
      {
      key = vanillaKey[ rawKeyCode + 0x68 ];
      }
      
   return( AssignObj( new_int( (int) key ) ) );
}

/****i* getVanillaKey() [3.0] ****************************************
*
* NAME
*    getVanillaKey()
*
* DESCRIPTION
*
* NOTES
*    Smalltalk code has to call this <primitive 222 1 2 self>
*    inside a loop if there is more than one IDCMP event expected.
*
*    ^ <primitive 222 1 2 self>
**********************************************************************
*
*/

METHODFUNC OBJECT *getVanillaKey( OBJECT *keyObj )
{
   struct Window       *wp = (struct Window *) NULL;
   struct IntuiMessage *message, Msg = { 0, };

   OBJECT *rval     = o_nil;
   ULONG   oldIDCMP = 0L;
   int     checking = TRUE;
   
   wp = (struct Window *) CheckObject( keyObj->inst_var[2] ); 

   if (!wp) // == NULL)
      return( rval );

   oldIDCMP = wp->IDCMPFlags;
   
   ModifyIDCMP( wp, (oldIDCMP | IDCMP_VANILLAKEY & (~IDCMP_RAWKEY)) );

   while (checking == TRUE)    
      {
      if (!(message = GT_GetIMsg( wp->UserPort ))) // == NULL)
         {
         (void) Wait( 1L << wp->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) message, (char *) &Msg, 
               (long) sizeof( struct IntuiMessage )
             );

      (void) GT_ReplyIMsg( message );

      switch (Msg.Class)   
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( wp );
            GT_EndRefresh( wp, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            {
            OBJECT *newQual;
            
            rval    = new_int( (int) Msg.Code      );
            newQual = new_int( (int) Msg.Qualifier );

            obj_dec( keyObj->inst_var[0] ); // old keyCode
            obj_dec( keyObj->inst_var[1] ); // old keyQualifier

            keyObj->inst_var[0] = AssignObj( rval );
            keyObj->inst_var[1] = AssignObj( newQual );
            }

            checking = FALSE; // Only way out of the Loop!
            break;

         default:                        
            break;
         }
      }                // End of while Loop!!

   ModifyIDCMP( wp, oldIDCMP );
   
   return( rval );
}

/****h* HandleKeys() [3.0] *********************************************
*
* NAME
*    HandleKeys()
*
* DESCRIPTION
*    <primitive 222 1 0-2 parms>
************************************************************************
*
*/

SUBFUNC OBJECT *HandleKeys( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 222 );

      return( rval );
      }

   switch (int_value( args[0] ))
      {
      case 0: // getRawKey
              // ^ keyCode <- <primitive 222 1 0 self>  
         rval = getRawKey( args[1] );
         break;
      
      case 1: // translateKey: keyCode
              // ^ <primitive 222 1 1 aKeyCode shiftBoolean>  
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 222 );
         else
            rval = translateKey( int_value( args[1] ), args[2] );
   
         break;
         
      case 2: // getVanillaKey
              // ^ keyCode <- <primitive 222 1 2 self>  
         rval = getVanillaKey( args[1] );
         break;
      
      default:
         break;
      }
   
   return( rval );
}

/****h* HandleConsole() [3.0] ******************************************
*
* NAME
*    HandleConsole()
*
* DESCRIPTION
*    <primitive 222 0 0-6 parms>
************************************************************************
*
*/

SUBFUNC OBJECT *HandleConsole( int numargs, OBJECT **args )
{
   struct Console *con  = NULL;
   OBJECT         *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 222 );

      return( rval );
      }

   switch (int_value( args[0] ))
      {
      case 0: // dispose [private]
         con = (struct Console *) CheckObject( args[1] );
         
         if (con) // != NULL)
            {
            DetachConsole( con );
            }
         
         break;
         
      case 1: // initialize: consoleName for: aWindow
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 222 );
         else
            {
            struct Window *wp = (struct Window *) CheckObject( args[1] );
            
            rval = AssignObj( new_address( (ULONG) 
                                           AttachConsole( wp, 
                                                          string_value( (STRING *) args[2] )))
                            );
            }
            
         break; 

      case 2: // getChar [private]
         con = (struct Console *) CheckObject( args[1] );
         
         if (con) // != NULL)
            rval = AssignObj( new_int( ConGetc( con ) ) );

         break;
               
      case 3: // getString [private]
         con = (struct Console *) CheckObject( args[1] );
         
         if (con) // != NULL)
            rval = AssignObj( new_str( ConGets( con ) ) );

         break;
               
      case 4: // putChar: [private] aCharacter
         con = (struct Console *) CheckObject( args[1] );
         
         if (is_character( args[2] ) == FALSE)
            (void) PrintArgTypeError( 222 );
         else
            {
            if (con) // != NULL)
               ConDumpc( con, char_value( args[2] ) );
            }

         break;
               
      case 5: // putString: [private] sString
         con = (struct Console *) CheckObject( args[1] );
         
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 222 );
         else
            {
            if (con) // != NULL)
               ConDumps( con, string_value( (STRING *) args[2] ) );
            }

         break;

      case 6: //               
      default:
         break;
      }
   
   return( rval );
}

/****h* HandleConsoleKeys() [3.0] **************************************
*
* NAME
*    HandleConsoleKeys()
*
* DESCRIPTION
*    Take care of calls to Keyboard & Consoles
*    <primitive 222 0-1 ?? parms>
************************************************************************
*
*/

PUBLIC OBJECT *HandleConsoleKeys( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 222 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // Console primitives
         rval = HandleConsole( numargs, &args[1] );
         break;

      case 1: // Keyboard primitives
         rval = HandleKeys( numargs, &args[1] );
         
         break;
         
      default:
         break;
      }
      
   return( rval );
}

/* -------------------------- END of Keyboard.c file! ------------------------ */
