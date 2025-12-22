/****h* AmigaTalk/Courier.c [3.0] **************************************
*
* NAME
*    Courier.c
*
* DESCRIPTION
*    Little Smalltalk  courier - message passing interface
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    02-Nov-2003 - Added tests for TraceFile == NULL.
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*    22-Feb-2001 - Added more debugging output to fnd_message().
*    02-Feb-2001 - Added Tracing code.
*
* NOTES
*    $VER: AmigaTalk:Src/Courier.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include "object.h"
#include "FuncProtos.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "CantHappen.h"

IMPORT OBJECT *o_drive;

IMPORT FILE   *TraceFile;
IMPORT BOOL    traceByteCodes;
IMPORT int     TraceIndent;

/* --------------- all Functions are NOT used in this file: ------------- 
** except for backtrace(), CourierErrPrt(), FindMethodObj() 
** & fnd_message()!
** ----------------------------------------------------------------------
*/

/****h* prnt_messages() [1.6] **************************************
*
* NAME
*    prnt_messages()
*
* DESCRIPTION
*    Print all the messages a class responds to.
*    Needed because the messages names array for some of the 
*    classes are created before ArrayedCollection, and thus some 
*    do not respond to 'do:'
********************************************************************
*
*/

PUBLIC void  prnt_messages( CLASS *aClass )
{
   OBJECT *message_names = aClass->message_names;
   int    i;

   FBEGIN( printf( "void prnt_messages( CLASS * 0x%08LX )\n", aClass ) );

   for (i = 0; i < message_names->size; i++)
      primitive( SYMPRINT, 1, &message_names->inst_var[i] );

   FEND( printf( "prnt_messages() exits\n" ) );

   return;
}

/****i* fnd_message() [1.6] ****************************************
*
* NAME
*    fnd_message()
*
* DESCRIPTION
*    Find the message associated with an interpreter.
********************************************************************
*
*/

PRIVATE char btm[256], *buffer = &btm[0];

PRIVATE char *fnd_message( OBJECT *receiver, OBJECT *bytecodes )
{
   CLASS    *oclass = NULL;
   OBJECT   *messar = NULL;
   char     *rval   = NULL;
//   OBJECT   *temp   = NULL;
   int       i;

   FBEGIN( printf( "fnd_message( rcvr = 0x%08LX, bytes = 0x%08LX )\n", receiver, bytecodes ));

   oclass = fnd_class( receiver );

   // Receiver has NO Class (well, aren't we judgemental!)
   if (is_class( (OBJECT *) oclass ) == FALSE) 
      goto exitFnd_Message;

   messar = oclass->methods; // messar == Methods array.

   for (i = 0; i < objSize( messar ); i++) 
      {
      if ((messar->inst_var[i])->inst_var[0] == bytecodes) 
         {
         sprintf( buffer, CourCMsg( MSG_FMT_CO_BACKTRC_COUR ),
                  symbol_value( (SYMBOL *) oclass->class_name ),
                  symbol_value( (SYMBOL *) 
                                (oclass->message_names)->inst_var[i] 
                              )
                );

         if (debug == TRUE)
            fprintf( stderr, CourCMsg( MSG_FMT_CO_BACKTRC_COUR ),
                     symbol_value( (SYMBOL *) oclass->class_name ),
                     symbol_value( (SYMBOL *) 
                                   (oclass->message_names)->inst_var[i] 
                                 )
                   );

         if (TraceFile && traceByteCodes == TRUE)
            {
            indentTrace();

            fprintf( TraceFile, CourCMsg( MSG_FMT_CO_BACKTRC_COUR ),
                     symbol_value( (SYMBOL *) oclass->class_name ),
                     symbol_value( (SYMBOL *) 
                                   (oclass->message_names)->inst_var[i] 
                                 )
                   );
            }
/*
         temp = AssignObj( new_str( buffer ) );

         (void) primitive( ERRPRINT, 1, &temp );
         (void) obj_dec( temp );
*/
         rval = buffer;

         goto exitFnd_Message;
         }
      }

   fprintf( stderr, "fnd_message() Ran off the rails!\n" );

   cant_happen( PANIC_BACKTRACE );  // Die, you abomination!!

exitFnd_Message:

   FEND( printf( "0x%08LX = fnd_message()\n", rval ) );

   return( rval );
}

/****h* getBackTrace() [3.0] ***************************************
*
* NAME
*    getBackTrace()
*
* DESCRIPTION
*    Generate a backwards message passing trace for the ATalkTracer
*    BackTracing GUI.  Called from fillInTracings() in 
*    ATalkTracer.c
********************************************************************
*
*/

PRIVATE INTERPRETER *lastInterp = NULL;

PUBLIC char *getBackTrace( INTERPRETER *current )
{
   char *rval = NULL;

   FBEGIN( printf( "getBackTrace( Interp = 0x%08LX )\n", current ) );   

   if (!current) // == NULL)
      return( rval );
      
   if (!lastInterp) // == NULL)
      lastInterp = current;

   if ((is_interpreter( (OBJECT *) lastInterp->sender ) == TRUE) 
         && (is_driver( (OBJECT *) lastInterp->sender ) == FALSE))
      {
      rval = fnd_message( lastInterp->receiver, lastInterp->bytecodes );

      lastInterp = lastInterp->sender;
      }

   FEND( printf( "0x%08LX = getBacktrace()\n", rval ) );    

   return( rval );
}

/****h* resetBTInterpreter() [3.0] *********************************
*
* NAME
*    resetBTInterpreter()
*
* DESCRIPTION
*    Reset lastInterp so another backTracing can be done.
*    Called from ExitBtClicked() & StopBtClicked() in ATalkTracer.c
********************************************************************
*
*/

PUBLIC void resetBTInterpreter( void )
{
   lastInterp = NULL;
   
   return;
}

/****i* backtrace() [1.6] ******************************************
*
* NAME
*    backtrace()
*
* DESCRIPTION
*    Generate a backwards message passing trace.
********************************************************************
*
*/

PRIVATE void backtrace( INTERPRETER *current )
{
   FBEGIN( printf( "backtrace( Interp = 0x%08LX )\n", current ) );

   while ((is_interpreter( (OBJECT *) current->sender ) == TRUE)
            && (is_driver( (OBJECT *) current->sender ) == FALSE))
      {
      (void) fnd_message( current->receiver, current->bytecodes );

      current = current->sender;
      }

   FEND( printf( "backtrace() exits\n" ) );

   return;
}

/****i* CourierErrPrt() [1.6] **************************************
*
* NAME
*    CourierErrPrt()
*
* DESCRIPTION
*    Tell User there was an error found in send_mess().
********************************************************************
*
*/

PRIVATE void CourierErrPrt( char *msg )
{
   OBJECT *temp = NULL;

   FBEGIN( printf( "CourierErrPrt( %s )\n", msg ) );

   temp = AssignObj( new_str( msg ) );

   (void) primitive( ERRPRINT, 1, &temp );
   
   (void) obj_dec( temp );

   FEND( printf( "CourierErrPrt() exits\n" ) );

   return;
}

/****i* Bytes2Str() [1.7] ******************************************
*
* NAME 
*    Bytes2Str()
*
* DESCRIPTION
*    Convert method bytecodes into a string for the Trace() part
*    of AmigaTalk.
********************************************************************
*
*/

PRIVATE char bts[1024] = { 0, }, *BTS = &bts[0];

PUBLIC char *Bytes2Str( BYTEARRAY *bytes )
{
   char *rval      = BTS;
   char  buffer[4] = { 0, };
   int   i, j, ch, size = bytes->bsize;

   *rval = NIL_CHAR; // Kill the previous contents.

   for (i = 0, j = 0; i < size; i++, j += 3)
      {
      ch = bytes->bytes[ i ];

      // Byt2Str is from CommonFuncs.o
      StringCat( rval, Byt2Str( buffer, (UBYTE) ch ) );

      if (j > 72) // j flags when to send out a newline.
         {
         StringCat( rval, NEWLINE_STR );
         j = 0;
         }
      else
         StringCat( rval, ONE_SPACE );
      }

   return( rval );
}

/****i* AmigaTalk/UnknownMethod() ************************************
*
* NAME
*    UnknownMethod()
*
* DESCRIPTION
*    If we reach this function, then no method has been found 
*    matching the message.
**********************************************************************
*
*/

PRIVATE void UnknownMethod( INTERPRETER *sender,
                            OBJECT      *receiver, 
                            char        *message
                          )
{
   IMPORT INTERPRETER *BackTracer( INTERPRETER *startInterp );

   OBJECT *tempclassobj = NULL;
   OBJECT *robject      = NULL;

   FBEGIN( printf( "UnknownMethod( 0x%08LX, 0x%08LX, %s )\n", sender, receiver, message ));

   tempclassobj         = new_obj( (CLASS *) 0, 2, 0 );
   robject              = AssignObj( tempclassobj );
   robject->inst_var[0] = AssignObj( receiver );
   robject->inst_var[1] = AssignObj( (OBJECT *) new_sym( message ) );

   // <129 == NO_RESPOND_ERROR> 
   (void) primitive( NORESPONDERROR, 2, &(robject->inst_var[0]) );

   (void) obj_dec( robject->inst_var[0] );
   (void) obj_dec( robject->inst_var[1] );
   (void) obj_dec( robject              ); // Mark it for free()'ing.

//   generate a message passing trace:
//   backtrace( sender );

   // generate a message passing trace:
   if (BackTracer( sender ) == (INTERPRETER *) o_nil) 
      {
      // User terminated Trace:      
      
      INTERPRETER *interp = NULL;
      
      // return nil by default:
      if (is_interpreter( (OBJECT *) sender ) == TRUE)
         push_object( sender, o_nil );

      interp = sender;
      
      while (interp != (INTERPRETER *) o_drive)
         interp = interp->sender; // Retreat all the way back to o_drive!
         
      link_to_process( interp );

      return; // DEBUG this!!
      }

   // return nil by default:
   if (is_interpreter( (OBJECT *) sender ) == TRUE)
      push_object( sender, o_nil );

   link_to_process( sender );

   FEND( printf( "UnknownMethod() exits\n" ) );

   return;
}

/*
   IMPORT INTERPRETER *BackTracer( INTERPRETER *sender ); // In ATalkTracer.c

   OBJECT *tempclassobj = NULL;
   OBJECT *robject      = NULL;
    
   tempclassobj         = new_obj( (CLASS *) NULL, 2, FALSE );
   robject              = AssignObj( tempclassobj );
   robject->inst_var[0] = AssignObj( receiver );
   robject->inst_var[1] = AssignObj( (OBJECT *) new_sym( message ) );

   (void) primitive( NORESPONDERROR, 2, &(robject->inst_var[0]) );

   (void) obj_dec( robject->inst_var[0] );
   (void) obj_dec( robject->inst_var[1] );
   (void) obj_dec( robject              ); // Mark it for free()'ing.

   // generate a message passing trace:
   if (BackTracer( sender ) == (INTERPRETER *) o_nil) 
      {
      // User terminated Trace:      
      
      INTERPRETER *interp = NULL;
      
      // return nil by default:
      if (is_interpreter( (OBJECT *) sender ) == TRUE)
         push_object( sender, o_nil );

      interp = sender;
      
      while (interp != (INTERPRETER *) o_drive)
         interp = interp->sender; // Retreat all the way back to o_drive!
         
      link_to_process( interp );

      return; // DEBUG this!!
      }

   // return nil by default:
   if (is_interpreter( (OBJECT *) sender ) == TRUE)
      push_object( sender, o_nil );

   link_to_process( sender );

   return;
*/

/****h* FindMethodObj() [1.9] **************************************
*
* NAME
*    FindMethodObj()
*
* DESCRIPTION
*    Take a name and find the associated Method object;
*    return a pointer to the bytearray that represents the 
*    method.
*********************************************************************
*
*/

PUBLIC OBJECT *FindMethodObj( CLASS *classptr, char *methodname )
{   
   OBJECT *p    = classptr->message_names;
   OBJECT *r    = classptr->methods;
   OBJECT *rval = NULL;
   
   int     i;

   FBEGIN( printf( "FindMethodObj( CLASS * 0x%08LX, %s )\n", classptr, methodname ) );   

   for (i = 0; i < objSize( p ); i++)
      {
      if (StringComp( methodname, symbol_value( (SYMBOL *) p->inst_var[i] )) == 0)
         {
         rval = (OBJECT *) r->inst_var[i];

         break; // return( rval );
         }
      }

   FEND( printf( "0x%08LX = FindMethodObj()\n", rval ) );

   return( rval );
}

/****h* send_mess() [1.6] ******************************************
*
* NAME
*    send_mess()
*
* DESCRIPTION
*    Find the method needed to respond to a message, create the
*    proper context and interpreter for executing the method.
*
*    Called from the bytecode interpreter in resume() (interp.c).
********************************************************************
*
*/

PUBLIC void send_mess( INTERPRETER *sender, 
                       OBJECT      *receiver, 
                       char        *message, 
                       OBJECT     **args, 
                       int          numargs 
                     )
{
   INTERPRETER *Interpreter  = (INTERPRETER *) NULL;
   OBJECT      *robject      = (OBJECT *) NULL;
   OBJECT      *method       = (OBJECT *) NULL;
   OBJECT      *context      = (OBJECT *) NULL;
   OBJECT      *tempclassobj = (OBJECT *) NULL;
   CLASS       *objclass     = (CLASS  *) NULL;

   int          i, maxctxt   = 0;

   FBEGIN( printf( "send_mess( 0x%08LX, 0x%08LX, %s, Obj ** 0x%08LX, %d )\n", sender, receiver, message, args, numargs ) );

   for (robject = receiver; robject != (OBJECT *) NULL; /***/ ) 
      {
      // The for ( robject != NULL ) should make this un-necessary:
      if (robject == (OBJECT *) NULL) 
         {
         CourierErrPrt( CourCMsg( MSG_CO_NULL_RCVR_COUR ) );

         break;
         }

      // Get the Class to start the method search with: 
      if (is_bltin( robject ) == TRUE)
         objclass = fnd_class( robject );
      else
         objclass = robject->Class;

      // Flag a Not found Class:
      if (!objclass) // == (CLASS *) NULL)
         {
         CourierErrPrt( CourCMsg( MSG_CO_NO_ENTRY_COUR ) ); 

         break;
         }

      // Flag an Object that's NOT a Class:
      if (is_class( (OBJECT *) objclass ) == FALSE)
         {
         CourierErrPrt( CourCMsg( MSG_CO_NOT_CLASS_COUR ) );

         break;
         }

      if ((method = FindMethodObj( objclass, message ))) // != NULL)
         {
         maxctxt = objclass->context_size;

         goto do_cmd;
         }

      // Go up to the parent class & search its methods:
      if (is_bltin( robject ))
         robject = fnd_super( robject );
      else
         robject = robject->super_obj;

      if (!robject) // == NULL) // I think this was tried before...
         robject = (OBJECT *) lookup_class( symbol_value( (SYMBOL *)
                                            objclass->super_class ) ); 
      }
  
   // Bomb out on this message:
   UnknownMethod( sender, receiver, message );

   FEND( printf( "send_mess() abnormal exit\n" ) );

   return;

   // Do an interpreted method.
   // Make a context and fill it in, make an interpeter and link it into
   // process queue. 

do_cmd:

   if (debug == TRUE)
      {
      fprintf( stderr, "%s = %s\n", 
               message,
               Bytes2Str( (BYTEARRAY *) method->inst_var[0] )
             );
      }

   if (TraceFile && traceByteCodes == TRUE)
      {
      indentTrace();
      fprintf( TraceFile, "%s =\n\n", message );

//      Bytes2Str( (BYTEARRAY *) method->inst_var[0] ));
      }

   tempclassobj = new_obj( (CLASS *) 0, maxctxt, 0 );
   context      = AssignObj( tempclassobj );

   // copy the arguments into     the context->inst_var[] Objects:
   for (i = 0; i <= numargs; i++)
      context->inst_var[i] = AssignObj( args[i] );


   // copy o_nil into the rest of the context->inst_var[] Objects: 
   for ( ; i < maxctxt; i++ )
      context->inst_var[i] = AssignObj( o_nil );

   // Located in Interp.c:
   Interpreter = cr_interpreter( sender, 
                                 robject,             // Receiver
                                 method->inst_var[1], // Literals
                                 method->inst_var[0], // ByteArray
                                 context              // Context
                               );

   link_to_process( Interpreter );

   if (debug == TRUE)
      fprintf( stderr, CourCMsg( MSG_FMT_CO_INTERP_COUR ), message, Interpreter );

   if (TraceFile && traceByteCodes == TRUE)
      {
      TraceIndent++;
      fprintf( TraceFile, NEWLINE_STR );

      indentTrace();
      fprintf( TraceFile, CourCMsg( MSG_FMT_CO_INTERP_COUR ), message, Interpreter );
      }

   (void) obj_dec( context );

   FEND( printf( "send_mess() exits normally\n" ) );

   return;
}

/****h* responds_to() [1.6] ****************************************
*
* NAME
*    responds_to()
*
* DESCRIPTION
*    See if a class responds to a message.
********************************************************************
*
*/

PUBLIC BOOL responds_to( char *message, CLASS *aClass )
{
   OBJECT *msgnames = aClass->message_names;
   char   *MsgName  = NULL;
   BOOL    rval     = FALSE;
   int     i;

   FBEGIN( printf( "responds_to( %s, CLASS * 0x%08LX )\n", message, aClass ) );

   for (i = 0; i < objSize( msgnames ); i++)
      {
      MsgName = symbol_value( (SYMBOL *) msgnames->inst_var[i] );

      if (STR_EQ( MsgName, message ) == TRUE)
         {
         rval = TRUE;
         
         break;
         }
      }

   FEND( printf( "BOOL = %d = responds_to()\n", rval ) );

   return( rval );
}

/* -------------------- END of Courier.c file! ----------------------- */
