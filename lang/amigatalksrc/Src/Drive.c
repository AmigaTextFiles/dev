/****h* AmigaTalk/Drive.c [3.0] **************************************
*
* NAME
*    Drive.c
*
* DESCRIPTION
*    Little Smalltalk Parser functions.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    18-Dec-2003 - Had to add PAGE_MAX to line 715 in findvar().
*
*    08-Nov-2003 - Re-wrote the findvar() function & changed variable
*                  management to a Link List.
*
*    18-Oct-2003 - Added the Kill_Vars() function, which is used in
*                  SmallTalk() in Main.c
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
*    25-Dec-2001 - Increased LITMAX from 100 to 1024.
*
* NOTES
*    $VER: AmigaTalk:Src/Drive.c 3.0 (25-Oct-2004) by J.T. Steichen
**********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <AmigaDOSErrs.h>

#include "object.h"

#define    DRIVECODE
# include "drive.h"
#undef     DRIVECODE

#include "ATStructs.h"

#define    USE_NEWCODE
# include "cmds.h"              // Our problem child.
#undef     USE_NEWCODE

#include "FuncProtos.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CantHappen.h"

IMPORT OBJECT *o_nil, *o_true;
IMPORT OBJECT *o_drive;        // ``driver'' interpreter

IMPORT FILE *TraceFile;
IMPORT BOOL  traceByteCodes;
IMPORT int   TraceIndent;

IMPORT int  token;       // Lex.c variables.
IMPORT char toktext[];

IMPORT tok_type t;       // union in Drive.h

// These are MAXBUFFER = 8192 in size:

IMPORT char  *allocd_buffer;  // In Global.c where all good globals are.
IMPORT char  *top_linebuffer;

IMPORT UBYTE *ErrMsg;
IMPORT UBYTE *FATAL_ERROR;
IMPORT UBYTE *FATAL_INTERROR;

IMPORT UBYTE *AaarrggButton;

IMPORT int debug;
IMPORT int buffindex;
IMPORT int prntcmd;
IMPORT int inisstd;
IMPORT int started;

IMPORT struct Window *ATWnd;
 
// IMPORT int lexprnt;

/****h* test_driver() [1.9] ********************************
*
* NAME
*    test_driver()
*
* DESCRIPTION
*    see if the driver should be invoked
*    block  - indicates to use block or non-blocking input
*    bypass - TRUE = get input from User, FALSE = internal
*             control of Interpreter.
************************************************************
*
*/

PUBLIC BOOL test_driver( BOOL block, BOOL bypass )
{
   int   do_what = 0;

   FBEGIN( printf( "test_driver( BOOL block = %d, BOOL bypass = %d )\n", block, bypass ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_TESTD_FUNC_DRIVE ), block );
   
   if (bypass == FALSE)
      do_what = line_grabber( block, allocd_buffer );
   else
      do_what = 2; // allocd_buffer already has a command in it (ExecuteExternalScript()).
      
   switch (do_what) 
      {
      case -1:
         //  return end of file indication:
         FEND( printf( "FALSE <= test_driver()\n" ) );
       
         return( FALSE );

      case 0:
         // enqueue driver process again:
         FEND( printf( "TRUE <= test_driver()\n" ) );
      
         return( TRUE );

      case 1:
         if ( *allocd_buffer == RPAREN_CHAR ) // LeX Command delimiter found.
            {
            dolexcommand( allocd_buffer );  // Do the LeX Command. 

            allocd_buffer = top_linebuffer; // reset allocd_buffer ptr.

            FEND( printf( "TRUE <= test_driver()\n" ) );
   
            return( TRUE );
            }

         if (TraceFile && traceByteCodes == TRUE)
            {
            TraceIndent = 0;
            
            if (strlen( allocd_buffer ) > 1)
               fprintf( TraceFile, "%s\n", allocd_buffer );
            else
               fputs( "\n", TraceFile );
            }
                 
         (void) parse(); // Make sense of what's in the buffer.

         allocd_buffer = top_linebuffer;    // reset allocd_buffer ptr

         FEND( printf( "TRUE <= test_driver()\n" ) );

         return( TRUE );

      case 2: // doing some internal interpreting (via ExecuteExternalScript()):

         if ( *allocd_buffer == RPAREN_CHAR ) // LeX Command delimiter found.
            {
            dolexcommand( allocd_buffer );  // Do the LeX Command. 

            allocd_buffer = top_linebuffer; // reset allocd_buffer ptr.

            if (line_grabber( TRUE, allocd_buffer ) >= 0) // TRUE or FALSE okay.
               {            
               if (TraceFile && traceByteCodes == TRUE)
                  {
                  TraceIndent = 0;
            
                  if (strlen( allocd_buffer ) > 1)
                     fprintf( TraceFile, "%s\n", allocd_buffer );
                  else
                     fputs( "\n", TraceFile );
                  }

               (void) parse();

               allocd_buffer = top_linebuffer; // reset allocd_buffer ptr.
               }
            else // line_grabber() returned -1:
               {
               FEND( printf( "FALSE <= test_driver()\n" ) );

               return( FALSE );
               }

            FEND( printf( "TRUE <= test_driver()\n" ) );
               
            return( TRUE );
            }

         allocd_buffer = top_linebuffer;

         if (line_grabber( TRUE, allocd_buffer ) > 0) // Only TRUE will do here!
            {            
            if (TraceFile && traceByteCodes == TRUE)
               {
               TraceIndent = 0;
            
               if (strlen( allocd_buffer ) > 1)
                  fprintf( TraceFile, "%s\n", allocd_buffer );
               else
                  fputs( "\n", TraceFile );
               }

            (void) parse(); // Make sense of what's in the buffer.

            allocd_buffer = top_linebuffer;

            FEND( printf( "TRUE <= test_driver()\n" ) );
    
            return( TRUE );
            }
         else
            {
            FEND( printf( "FALSE <= test_driver()\n" ) );
            
            return( FALSE );
            }

      default: 
         fprintf( stderr, "test_driver() received %d as do_what!\n", do_what );

         cant_happen( BADARG_SET_STATE );  // Die, you abomination!!
         
         return( FALSE );                  // Unreachable.
      }
}

PRIVATE int errflag = 0;

/****h* lexerr() [1.6] *************************************
*
* NAME
*    lexerr()
*
* DESCRIPTION
*    error printing with limited reformatting
************************************************************
*
*/

PUBLIC void lexerr( char *s, char *v )
{
   OBJECT *New = NULL;
   char    e1[1024] = { 0, };

   if (debug == TRUE)
      fprintf( stderr, DriveCMsg( MSG_DV_LEXER_FUNC_DRIVE ), s, v );
   
   errflag = TRUE;

   sprintf( ErrMsg, s, v );              // format error message

   sprintf( e1, DriveCMsg( MSG_FMT_DV_ERROR_DRIVE ), ErrMsg );

   New = AssignObj( new_str( e1 ) );

   (void) primitive( ERRPRINT, 1, &New );

   (void) obj_dec( New );

   return;
}

/****h* lexIerr() [1.6] ************************************
*
* NAME
*    lexIerr()
*
* DESCRIPTION
*    Internal (driver) error reporter.
************************************************************
*
*/

PUBLIC void lexIerr( char *s, int v )
{
   OBJECT *New = NULL;
   char    e1[1024] = { 0, };

   if (debug == TRUE)
      fprintf( stderr, DriveCMsg( MSG_DV_LEXIR_FUNC_DRIVE ), s, v );
   
   errflag = TRUE;

   sprintf( ErrMsg, s, v );           // format error message

   sprintf( e1, DriveCMsg( MSG_FMT_DV_ERROR_DRIVE ), ErrMsg );

   New = AssignObj( new_str( e1 ) );

   primitive( ERRPRINT, 1, &New );

   (void) obj_dec( New );

   return;
}

/* ---- code generation routines  -------------- */

PRIVATE uchar code[ CODEMAX ] = { 0, };
PRIVATE int   codetop = 0;

/****i* gencode() [1.6] ************************************
*
* NAME
*    gencode()
*
* DESCRIPTION
*    Place a new ByteCode into the code[] array.
************************************************************
*
*/

PRIVATE int gencode( register int value )
{
   if (debug == TRUE)   
      {
      fprintf( stderr, DriveCMsg( MSG_DV_GENCD_FUNC_DRIVE ), value );

      if (IndexChk( value, 256, DriveCMsg( MSG_DV_BYTECODE_DRIVE ) ) == FALSE)
         lexIerr( DriveCMsg( MSG_DV_BIG_CODE_DRIVE ), value );

      if (IndexChk( codetop, CODEMAX, DriveCMsg( MSG_DV_CODE_IDX_DRIVE ) ) == FALSE)
         {
         sprintf( ErrMsg, DriveCMsg( MSG_DV_CODE_OVFLW_DRIVE ), codetop, CODEMAX );  
      
         lexIerr(  ErrMsg, 0 ); // NULL );
         }
      }

   code[ codetop++ ] = (uchar) (value & 0xFF);

   return( 0 );
}

/****i* genhighlow() [1.6] *********************************
*
* NAME
*    genhighlow()
*
* DESCRIPTION
*    Make the high & low values into a bytecode.
************************************************************
*
*/

PRIVATE int genhighlow( register int high, register int low )
{
   FBEGIN( printf( "genhighlow( %X, %X )\n", high, low ) );

   if (high < 0 || high > 16)
      lexIerr( DriveCMsg( MSG_DV_GENHL_ERR1_DRIVE ), high );

   if (low < 0)
      lexIerr( DriveCMsg( MSG_DV_GENHL_ERR2_DRIVE ), low );

   if (low < 16) 
      gencode( high * 16 + low );
   else 
      {
      // Generate the special Two-Byte Opcode form:
      gencode( TWOBIT * 16 + high );
      gencode( low );
      }

   FEND( printf( "genhighLow() exits\n" ) );

   return( 0 );
}

// tempnames[] is used for variables inside Blocks: ---------------------

#define MAXTEMPS 64

PRIVATE char *tempnames[MAXTEMPS] = { NULL, }; // used in genvar(), block()

PRIVATE int   maxtemps = 1;  // used in reset(),  block()
PRIVATE int   temptop  = 0;  // used in reset(),  genvar(), block()

// ----------------------------------------------------------------------

PRIVATE int   littop   = 0;  // used in reset(), aliteral(), addliteral()

/****i* reset() [1.6] **************************************
*
* NAME
*    reset()
*
* DESCRIPTION
*    Reset the driver variables so that new buffer contents
*    can be interpreted.
************************************************************
*
*/

PRIVATE void  reset( void )
{
   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_RESET_FUNC_DRIVE ) );
   
   codetop  = littop = temptop = 0;
   maxtemps = 1;

   return;
}

/*
** Each AmigaTalk variable will have an entry in a varPage structure
** as follows:
**
** variable name (Symbol):  variable value (Object):
**    vp_Items[0],             vp_Items[1],
**    vp_Items[2],             vp_Items[3],
**     ...                      ...
**    vp_Items[122],           vp_Items[123];
**
** This means that the range for vp_ItemsUsed is 0 to 61.
*/

#define ITEM_MAX  123 // ITEM_MAX = 2 * (numElements + 1) vp_Items goes from 0 to 123
#define PAGE_MAX  61  // PAGE_MAX = numElements

PUBLIC struct varPage {

   ULONG           vp_ItemsUsed;
   ULONG           vp_Flags;     // normally 0x8F565000  ".VP."

   struct varPage *vp_Succ;
   ULONG           vp_Reserved;
      
   ULONG           vp_Items[ ITEM_MAX + 1 ];
};

#define MEMFLAGS  MEMF_FAST | MEMF_CLEAR

PRIVATE struct varPage *vpageList       = NULL;
PRIVATE struct varPage *lastAllocdVPage = NULL;

PRIVATE ULONG vpageCount  = 0;
PRIVATE ULONG vItemsCount = 0;

PRIVATE BOOL    varsValid  = FALSE;
PRIVATE OBJECT *var_values = NULL; // Used by bld_interpreter() only

#ifdef TRACE // Used in Tracer.c only:

PRIVATE OBJECT *var_names     = NULL;
PRIVATE BOOL    varNamesValid = FALSE;

// -----------------------------------------------------------------

PUBLIC struct varPage *retrieveVarPages( void )
{
   return( vpageList );
}

PUBLIC ULONG retrieveVarCount( void )
{
   return( vItemsCount );
}

PUBLIC OBJECT *retrieveVarValues( void )
{
   return( var_values );
}

PUBLIC OBJECT *makeVarNameObject( void )
{
   struct varPage *vpage    = vpageList;
   OBJECT         *varNames = NULL;
   int             i, j;

   if (var_names && varNamesValid == TRUE)
      return( var_names ); // No need for a new Object yet!

   else if (var_names && varNamesValid == FALSE)
      KillObject( var_names ); // Get rid of old Object.

   // Have to create a new var_names Object: --------------------
         
   if (!(varNames = new_array( vItemsCount, FALSE ))) // == NULL)
      {
      fprintf( stderr, "Ran out of Memory in makeVarNameObject()!\n" );
      
      MemoryOut( "makeVarNameObject()" );
      
      cant_happen( NO_MEMORY );
            
      return( varNames ); // never reached.
      }
    
   i = 0;
   
   while (i < vItemsCount && vpage != NULL)
      {
      int k;
      
      for (k = 0, j = 0; 
           k < vpage->vp_ItemsUsed && vpage->vp_Items[j] != 0; // NULL;
           i++, j += 2, k++)
         {
         varNames->inst_var[i] = (OBJECT *) vpage->vp_Items[j];
         }
            
      if (i == vItemsCount) // We're done with the while loop!
         break;
         
      vpage = vpage->vp_Succ; // Add another varPage.
      }

   varNamesValid = TRUE; // var_names will be correct (for awhile!)
   
   return( varNames );
}

#endif

/****i* freeVarPages() [2.5] *****************************************
*
* NAME
*    freeVarPages()
*
* DESCRIPTION
*    FreeVec() ALL varPages.
**********************************************************************
*
*/

SUBFUNC void freeVarPages( struct varPage **vpList )
{
   struct varPage *p    = *vpList;
   struct varPage *next = (struct varPage *) NULL;
   
   while (p) // != NULL)
      {
      next = p->vp_Succ;
      
      AT_FreeVec( p, "varPage", TRUE );

      p = next;
      }
   
   return;
}

/****i* storeVarPage() [2.5] ***************************************
*
* NAME
*    storeVarPage()
*
* DESCRIPTION
*    Place the given varPage on the given list & update the
*    pointers.
********************************************************************
*/

SUBFUNC void storeVarPage( struct varPage  *i, 
                           struct varPage **last,
                           struct varPage **list
                         )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last = i;
      *list = i;
      }
   else
      {
      (*last)->vp_Succ = i;
      }

   i->vp_Succ = 0; // NULL;

   *last = i; // Update the end of the List.
   
   return;       
}

PRIVATE int allocNewVarPage( void )
{
   struct varPage *rval = (struct varPage *) NULL;
   int             err  = RETURN_OK;

   FBEGIN( printf( "allocNewVarPage( void )\n" ) );      

   rval = (struct varPage *) AT_AllocVec( sizeof( struct varPage ), 
                                          MEMFLAGS, "varPage", TRUE 
                                        );
   
   if (rval) // != NULL)
      {
      rval->vp_Flags = 0x8F565000;
      
      storeVarPage( rval, &lastAllocdVPage, &vpageList );
      
      vpageCount++;
      }
   else
      {
      MemoryOut( "allocNewVarPage()" );
      
      fprintf( stderr, "Ran out of memory in allocNewVarPage()!\n" );
      
      err = ERROR_NO_FREE_STORE;
      }

   FEND( printf( "err = %d = allocNewVarPage()\n", err ) );

   return( err );   
}

// Used by ShutDown() te freeVec the space allocated:

PUBLIC void freeVecVariables( void )
{
   freeVarPages( &vpageList ); 

   return;
}

// Find & return the last varPage in the vpList struct:

SUBFUNC struct varPage *varPageTail( struct varPage *vpList )
{
   struct varPage *prev = vpList;

   FBEGIN( printf( "varPageTail( 0x%08LX )\n", vpList ) );      
 
   while (prev->vp_Succ) // != NULL)
      prev = prev->vp_Succ; // Find the end of the list.

   FEND( printf( "prev = 0x%08LX = varPageTail()\n" ) );   

   return( prev );
}

// Test whether a varPage struct is full:

SUBFUNC BOOL VPageFull( struct varPage *vpage )
{
   if (!vpage) // == NULL)
      return( TRUE );
      
   if (vpage->vp_ItemsUsed < PAGE_MAX)
      return( FALSE );
   else
      return( TRUE );
}

/****i* searchForvar() [3.0] *************************************
*
* NAME
*    searchForVar()
*
* DESCRIPTION
*    Search the entire vpageList for the given variable.  Return
*    the variable index if found, else return -1.
******************************************************************
*
*/

SUBFUNC int searchForVar( SYMBOL *varSym, char *varString, BOOL reportErr )
{
   struct varPage *vpage = vpageList;
   SYMBOL         *vitem = (SYMBOL *) NULL;
   int             i, j, rval = 0;
   
tryNextPage:

   // Scan through current varPage for a match:
   for (i = 0, j = 0; i < vpage->vp_ItemsUsed; i++, j += 2)
      {
      vitem = (SYMBOL *) vpage->vp_Items[j];
         
      if (vitem == varSym)
         {
         (void) obj_dec( (OBJECT *) varSym );

         rval += i;
            
         goto exitSearch;
         }
      }

   if (vpage->vp_Succ) // != NULL) 
      {
      // More than one valid varPage in the list:
      rval += vpage->vp_ItemsUsed; // (vpage->vp_ItemsUsed + 1);

      vpage = vpage->vp_Succ;

      goto tryNextPage; // Search the next page
      }
   else // User expected to find existing variable:
      {
      if (reportErr == TRUE)
         lexerr( DriveCMsg( MSG_FMT_DV_UNKVAR_DRIVE ), varString );

      (void) obj_dec( (OBJECT *) varSym );

      rval = -1; // DEBUG This!!

      goto exitSearch;
      }

exitSearch:

   return( rval );
}

// variable not found & there is room on the varPage, so add one:

SUBFUNC int addToVarPage( struct varPage *vpage, SYMBOL *varSym )
{         
   int idx = 0, rval = 0;
         
   while (idx < ITEM_MAX && vpage->vp_Items[idx]) // != NULL)
      idx += 2; // find end of current varPage...
         
   vpage->vp_Items[idx    ] = (ULONG) AssignObj( (OBJECT *) varSym ); // var_name
   vpage->vp_Items[idx + 1] = (ULONG) AssignObj( o_nil );             // var_value

   vItemsCount++;
   vpage->vp_ItemsUsed++;

   rval      = ((vpageCount - 1) * PAGE_MAX) + (idx / 2);
   varsValid = FALSE;     // Have to build a new var_values Object

#  ifdef TRACE            // Used in Tracer.c only:
   varNamesValid = FALSE;
#  endif

   return( rval );
}

/****i* findvar() [3.0] ************************************
*
* NAME
*    findvar() - De mighty findvar() function!
*
* DESCRIPTION
*    Find a variable in the interpreter space, or add one.
*    drive_init() has already created the first varPage &
*    set the first 3 entries to last, temp & pTempVar.
************************************************************
*
*/

PRIVATE int findvar( char *varString, BOOL makeOne )
{
   struct varPage *vpage    = vpageList;
   SYMBOL         *temp     = (SYMBOL *) NULL;
   int             rval     = 0;
   int             numTries = vpageCount;

   FBEGIN( printf( "findvar( %s, BOOL makeOne = %d )\n", varString, makeOne ) );

   if (!(temp = new_sym( varString ))) // == NULL) // Normally does NOT fail!
      {
      if (!w_search( varString, TRUE )) // == NULL)   // Strike two??
         {
         // I guess we're really screwed:
         sprintf( ErrMsg, DriveCMsg( MSG_FMT_DV_VAR1_DRIVE ), varString );

         SetReqButtons( DriveCMsg( MSG_DV_JUMP_TRAIN_DRIVE ) );         

         UserInfo( ErrMsg, FATAL_ERROR );

         ShutDown();
         }
      else
         {  // Strike three??
         if (!(temp = sy_search( varString, TRUE ))) // == NULL)
            {
            // Let's just commit Hari-kiri:
            sprintf( ErrMsg, DriveCMsg( MSG_FMT_DV_VAR1_DRIVE ), varString );

            SetReqButtons( DriveCMsg( MSG_DV_JUMP_TRAIN_DRIVE ) );         

            UserInfo( ErrMsg, FATAL_ERROR );

            ShutDown();
            }
         } 
      }

   if (makeOne == FALSE)
      {
      if ((rval = searchForVar( temp, varString, TRUE )) < 0)
         {
         rval = 0; // -1 has served its purpose.
         
         goto exitFindVar;
         } 
      }
   else // We're allowed to make a variable if it does NOT exist:
      {
      if ((rval = searchForVar( temp, varString, FALSE )) >= 0)
         {
         goto exitFindVar; // variable already exists, so exit.
         } 

checkNextPage:
         
      if (VPageFull( vpage ) == FALSE)
         {
         rval = addToVarPage( vpage, temp ); // Room on varPage, so add variable
           
         (void) obj_dec( (OBJECT *) temp );

         goto exitFindVar;
         }
      else if (numTries > 1) // && VPageFull() was TRUE
         {
         if (vpage->vp_Succ != NULL)
            vpage = vpage->vp_Succ;
         
         numTries--;
         
         goto checkNextPage;
         }
      else // makeOne == TRUE && page was full, so create a new page:
         {
         if (allocNewVarPage() != RETURN_OK)
            {
            (void) obj_dec( (OBJECT *) temp ); // The well is dry!

            fprintf( stderr, "findvar( %s ) Ran out of Memory!\n", varString );
            
            cant_happen( NO_MEMORY );
            
            return( ERROR_NO_FREE_STORE ); // Never reached! 
            }
         else // Add another varPage to List:
            {
            vpage = varPageTail( vpageList );

            rval  = addToVarPage( vpage, temp );
            
            (void) obj_dec( (OBJECT *) temp );

            goto exitFindVar;
            }
         }
      }

exitFindVar:

   FEND( printf( "%d = findVar()\n", rval ) );

   return( rval );
}

// NUNUNUNUN Functions NOT used in this file: UNUNUNUNUNUNUNUNUNU

/****h* drv_init() [1.6] ***********************************
*
* NAME
*    drv_init()
*
* DESCRIPTION
*    Initializes the driver, should be called only once
************************************************************
*
*/

PRIVATE BOOL drive_initd = FALSE;

PUBLIC void drv_init( void )
{
   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_DRVINI_FUNC_DRIVE ) );
   
   if (drive_initd == FALSE)   
      {
      if (allocNewVarPage() != RETURN_OK)
         {
         fprintf( stderr, "Ran out of memory in drv_init()!\n" );
         
         MemoryOut( "drv_init()" );
         
         cant_happen( NO_MEMORY );
         
         return; // Never reached.
         }

      reset();
      findvar( "last",     TRUE ); // create variable "last"
      findvar( "temp",     TRUE ); // create variable "temp"      
      findvar( "pTempVar", TRUE ); // create variable "pTempVar"

      drive_initd = TRUE;      // Activate the guard.
      }
   else
      {
      reset(); // We might want to restart, so just do this:
      
      findvar( "last",     TRUE ); // create variable "last"
      findvar( "temp",     TRUE ); // create variable "temp"      
      findvar( "pTempVar", TRUE ); // create variable "pTempVar"
      }

   return;
}

/****h* drv_free() [1.6] ***********************************
*
* NAME
*    drv_free()
*
* DESCRIPTION
*    Place o_nil into every var_values->inst_var[].
************************************************************
*
*/

PUBLIC void drv_free( void )
{
   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_DRVFRE_FUNC_DRIVE ) );
   
   if (var_values) // != NULL)
      KillObject( var_values );

#  ifdef TRACE
   if (var_names) // != NULL)
      KillObject( var_names );
#  endif
            
   return;
}

// NUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNUNU

/****i* isbinary() [1.6] ***********************************
*
* NAME
*    isbinary()
*
* DESCRIPTION
*    See if the current token(s) is a binary operator.
************************************************************
*
*/

PRIVATE BOOL isbinary( char *bbuf )
{
   FBEGIN( printf( "BOOL isbinary( %s )\n", bbuf ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_ISBIN_FUNC_DRIVE ), bbuf );
   
   if ((token == BINARY) || (token == MINUS) 
                         || (token == BAR) 
                         || (token == PE)) 
      {
      StringCopy( bbuf, t.c );
      nextlex( );

      if ((token == BINARY) || (token == MINUS)
                            || (token == BAR) 
                            || (token == PE)) 
         {
         StringCat( bbuf, t.c );
         nextlex( );
         }

      FEND( printf( "TRUE <= isbinary()\n" ) );

      return( TRUE );
      }

   FEND( printf( "FALSE <= isbinary()\n" ) );

   return( FALSE ); // Not a binary operator.
}

/****h* expect() [1.6] *************************************
*
* NAME
*    expect()
*
* DESCRIPTION
*    Tell the user there is an error.
************************************************************
*
*/

PUBLIC void expect( char *str )
{
   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_EXPCT_FUNC_DRIVE ), str );
   
   sprintf( ErrMsg, DriveCMsg( MSG_FMT_DV_EXPECT_DRIVE ), str, toktext );

   lexerr( ErrMsg, EMPTY_STRING );

   return;
}

PRIVATE OBJECT *lit_array[ LITMAX ] = { NULL, };

/****i* addliteral() [1.6] *********************************
*
* NAME
*    addliteral()
*
* DESCRIPTION
*    Add a literal value to lit_array[].
************************************************************
*
*/

PRIVATE int addliteral( OBJECT *lit )
{
   FBEGIN( printf( "addliterla( Obj * 0x%08LX )\n", lit ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_ADDLIT_FUNC_DRIVE ), lit );
   
   if (littop >= LITMAX)
      { 
      fprintf( stderr, DriveCMsg( MSG_FMT_DV_LITTOP_DRIVE ), LITMAX ); 
      
      cant_happen( INTERNAL_BUFF_OVF );  // Die, you abomination!!
      }

   lit_array[ littop++ ] = AssignObj( lit );

   FEND( printf( "%d = addliteral()\n", littop - 1 ) );

   return( littop - 1 );
}

#define ALIT_BYTE_MAXSIZE 2048

/****i* findArrayLiteral() [2.5] ***************************
*
* NAME
*    findArrayLiteral()
*
* DESCRIPTION
*    Find a literal that can be in an array
************************************************************
*
*/

PRIVATE int findArrayLiteral( BOOL must )  // must we find something?
{
   IMPORT BOOL traceByteCodes;

   OBJECT *New      = NULL;
   char   *c        = NULL;

   int   count      = 0;
   int   bytetop    = 0;
   int   varIndex   = 0;
   
   // Changed from 200 to 2048 on 25-Dec-2001, which broke the __stack of 4000 bytes.
   // __stack is now 50,000 bytes -- a more reasonable value.
   
   UBYTE bytes[ ALIT_BYTE_MAXSIZE ] = EMPTY_STRING;

   FBEGIN( printf( "findArrayLiteral( BOOL mustFind = %d \n", must ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_FMT_DV_ALITL_DRIVE ), must, token );
   
   switch (token) 
      {
      case MINUS:
         c = t.c;
         nextlex( );

         if (token == LITNUM) 
            {
            New = new_int( - t.i );   // Negate the integer.
            nextlex( );
            }
         else if (token == LITFNUM) 
            {
            New = new_float( - t.f ); // Negate the float.
            nextlex( );
            }
         else
            New = (OBJECT *) new_sym( c ); // Just a minus.
         break;

      case LITNUM:
         New = new_int( t.i );
         nextlex( );
         break;

      case LITFNUM:
         New = new_float( t.f );
         nextlex( );
         break;

      case LITCHAR:
         New = new_char( t.i );
         nextlex( );
         break;

      case LITSTR:
         New = new_str( t.c );
         nextlex( );
         break;

      case LITSYM:
         New = (OBJECT *) new_sym( t.c );
         nextlex( );
         break;

      case PSEUDO:
         switch (t.p)
            {
            case nilvar:   
               New = o_nil;
               break;
               
            case truevar:  
               New = o_true;
               break;
            
            case falsevar: 
               New = o_false;
               break;

            case smallvar:     // amigatalk == smalltalk 
            case amigavar:
               New = o_smalltalk;
               break;

            // case selfvar:   // These are handled elsewhere.
            // case supervar:
            // case procvar:

            case traceonvar:   // Enable tracing
               traceByteCodes = TRUE;
               break;
               
            case traceoffvar: // Disable tracing
               traceByteCodes = FALSE;
               break;

            default:
               lexIerr( DriveCMsg( MSG_DV_UNK_PSEUDO_DRIVE ), t.p );
            }

         nextlex( );
         break;

      case PS:                   // PS == Pound Sign #
         nextlex( );

         if (token == LP)        // a regular array:
            goto rdarray;

         else if (token == LB)   // We're in a byte array:
            {
            bytetop = 0;

readMoreByteCodes:

            while (nextlex( ) == LITNUM)
               {
               if (IndexChk( bytetop + 1, ALIT_BYTE_MAXSIZE, 
                             DriveCMsg( MSG_DV_ALITRL_FUNC_DRIVE ) ) == FALSE)
                  {
                  return( -1 ); // User already notified.
                  }

               bytes[ bytetop++ ] = itouc( t.i );
               }

            /* This only works for the command line & script file inputs,
            ** the parser can be made to output variable names into the
            ** Array properly, but the byteCode Interpreter does not know
            ** where to find the variable (it could be an instance variable
            ** or a temporary method instance variable, or undefined)
            ** Perhaps later, we'll modify this to search for instance vars,
            ** context, etc:
            */
            if (token == LOWERCASEVAR)
               {
               if ((varIndex = findvar( t.c, FALSE )) >= 0)
                  {
                  if (!is_integer( var_values->inst_var[ varIndex ] )
                      || !is_character( var_values->inst_var[ varIndex ] ))
                     {
                     fprintf( stderr, "UnAllowed variable Type for %s found in ByteArray!\n", t.c );
                     }
                  else
                     {
                     int ba = int_value( var_values->inst_var[ varIndex ] );
                     
                     bytes[ bytetop++ ] = itouc( ba );
                     }
                  }
               else
                  {
                  fprintf( stderr, "Undefined variable %s found in ByteArray!\n", t.c );
                  // else search Instance variables, context, etc:
                  }
                
               goto readMoreByteCodes;
               }

            if (token != RB)
               expect( DriveCMsg( MSG_DV_EXPCT_RBKT_DRIVE ) );
            
            nextlex( );

            if (IndexChk( bytetop + 1, ALIT_BYTE_MAXSIZE, 
                          DriveCMsg( MSG_DV_ALITRL_FUNC_DRIVE ) ) == FALSE)
               {
               return( -1 ); // User already notified.
               }

            /* There needs to be a zero between bytearrays.
            ** (At least for my peace of mind (JTS) 8/29/98): 
            */
            bytes[ bytetop + 1 ] = 0;

            New = new_bytearray( bytes, bytetop + 1 ); // added +1 8/29/98
            }
         else 
            expect( DriveCMsg( MSG_DV_EXPCT_ARRAY_DRIVE ) );
         break;

rdarray:

      case LP:            // read an array:
         count = 0;
         nextlex( );

         while (findArrayLiteral( FALSE ) >= 0)    // Recursive Call!!!
            count++;

         if (token != RP)    
            expect( DriveCMsg( MSG_DV_EXPCT_RPAREN_DRIVE ) );
         
         nextlex( );

         New = new_array( count, 0 );

         while ((count > 0) && (littop > 0))
            New->inst_var[ --count ] = lit_array[ --littop ];

         break;

      /* This only works for the command line & script file inputs,
      ** the parser can be made to output variable names into the
      ** Array properly, but the byteCode Interpreter does not know
      ** where to find the variable (it could be an instance variable
      ** or a temporary method instance variable, or undefined)
      ** Perhaps later, we'll modify this to search for instance vars,
      ** context, etc:
      */
      case LOWERCASEVAR:
         if ((varIndex = findvar( t.c, FALSE )) >= 0)
            New = AssignObj( var_values->inst_var[ varIndex ] );
         else
            {
            fprintf( stderr, "Undefined variable %s found in Array!\n", t.c );
            New = AssignObj( o_nil );
            // else search Instance variables, context, etc:
            }
            
         nextlex();
         
         break;
         
      case UPPERCASEVAR: // Probably should do something with these as well.

      case KEYWORD:
      case COLONVAR:
      case BINARY:
      case PE:
      case BAR:
      case SEMI:
         New = (OBJECT *) new_sym( t.c );
         nextlex( );
         break;

      default:
         if (must == TRUE)
            expect( DriveCMsg( MSG_DV_EXPCT_LITRL_DRIVE ) );
         else 
            return( - 1 );
      }

   FEND( printf( "0x%08LX = findArrayLiteral()\n", New ) );

   return( addliteral( New ) );
}

/****i* findLiteral() [1.6] ********************************
*
* NAME
*    findLiteral()
*
* DESCRIPTION
*    Find a literal that is part of a literal array
************************************************************
*
*/

PRIVATE int findLiteral( BOOL must )  // must we find something?
{
   IMPORT BOOL traceByteCodes;

   OBJECT *New      = NULL;
   char   *c        = NULL;

   int   count      = 0;
   int   bytetop    = 0;
   int   varIndex   = 0;
   
   // Changed from 200 to 2048 on 25-Dec-2001, which broke the __stack of 4000 bytes.
   // __stack is now 50,000 bytes -- a more reasonable value.
   
   UBYTE bytes[ ALIT_BYTE_MAXSIZE ] = EMPTY_STRING;

   FBEGIN( printf( "findLiteral( BOOL mustFind = %d \n", must ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_FMT_DV_ALITL_DRIVE ), must, token );
   
   switch (token) 
      {
      case MINUS:
         c = t.c;
         nextlex( );

         if (token == LITNUM) 
            {
            New = new_int( - t.i );   // Negate the integer.
            nextlex( );
            }
         else if (token == LITFNUM) 
            {
            New = new_float( - t.f ); // Negate the float.
            nextlex( );
            }
         else
            New = (OBJECT *) new_sym( c ); // Just a minus.
         break;

      case LITNUM:
         New = new_int( t.i );
         nextlex( );
         break;

      case LITFNUM:
         New = new_float( t.f );
         nextlex( );
         break;

      case LITCHAR:
         New = new_char( t.i );
         nextlex( );
         break;

      case LITSTR:
         New = new_str( t.c );
         nextlex( );
         break;

      case LITSYM:
         New = (OBJECT *) new_sym( t.c );
         nextlex( );
         break;

      case PSEUDO:
         switch (t.p)
            {
            case nilvar:   
               New = o_nil;
               break;
               
            case truevar:  
               New = o_true;
               break;
            
            case falsevar: 
               New = o_false;
               break;

            case smallvar:     // amigatalk == smalltalk 
            case amigavar:
               New = o_smalltalk;
               break;

            // case selfvar:   // These are handled elsewhere.
            // case supervar:
            // case procvar:

            case traceonvar:   // Enable tracing
               traceByteCodes = TRUE;
               break;
               
            case traceoffvar: // Disable tracing
               traceByteCodes = FALSE;
               break;

            default:
               lexIerr( DriveCMsg( MSG_DV_UNK_PSEUDO_DRIVE ), t.p );
            }

         nextlex( );
         break;

      case PS:                   // PS == Pound Sign #
         nextlex( );

         if (token == LP)        // a regular array:
            goto rdarray;

         else if (token == LB)   // We're in a byte array:
            {
            bytetop = 0;

readMoreByteCodes:

            while (nextlex( ) == LITNUM)
               {
               if (IndexChk( bytetop + 1, ALIT_BYTE_MAXSIZE, 
                             DriveCMsg( MSG_DV_ALITRL_FUNC_DRIVE ) ) == FALSE)
                  {
                  return( -1 ); // User already notified.
                  }

               bytes[ bytetop++ ] = itouc( t.i );
               }

            /* This only works for the command line & script file inputs,
            ** the parser can be made to output variable names into the
            ** Array properly, but the byteCode Interpreter does not know
            ** where to find the variable (it could be an instance variable
            ** or a temporary method instance variable, or undefined)
            ** Perhaps later, we'll modify this to search for instance vars,
            ** context, etc:
            */
            if (token == LOWERCASEVAR)
               {
               if ((varIndex = findvar( t.c, FALSE )) >= 0)
                  {
                  if (!is_integer( var_values->inst_var[ varIndex ] )
                      || !is_character( var_values->inst_var[ varIndex ] ))
                     {
                     fprintf( stderr, "UnAllowed variable Type for %s found in ByteArray!\n", t.c );
                     }
                  else
                     {
                     int ba = int_value( var_values->inst_var[ varIndex ] );
                     
                     bytes[ bytetop++ ] = itouc( ba );
                     }
                  }
               else
                  {
                  fprintf( stderr, "Undefined variable %s found in ByteArray!\n", t.c );
                  // else search Instance variables, context, etc:
                  }
                
               goto readMoreByteCodes;
               }

            if (token != RB)
               expect( DriveCMsg( MSG_DV_EXPCT_RBKT_DRIVE ) );
            
            nextlex( );

            if (IndexChk( bytetop + 1, ALIT_BYTE_MAXSIZE, 
                          DriveCMsg( MSG_DV_ALITRL_FUNC_DRIVE ) ) == FALSE)
               {
               return( -1 ); // User already notified.
               }

            /* There needs to be a zero between bytearrays.
            ** (At least for my peace of mind (JTS) 8/29/98): 
            */
            bytes[ bytetop + 1 ] = 0;

            New = new_bytearray( bytes, bytetop + 1 ); // added +1 8/29/98
            }
         else 
            expect( DriveCMsg( MSG_DV_EXPCT_ARRAY_DRIVE ) );
         break;

rdarray:

      case LP:            // read an array:
         count = 0;
         nextlex( );

         while (findArrayLiteral( FALSE ) >= 0) // findLiteral( FALSE ) >= 0) Recursive Call!!!
            count++;

         if (token != RP)    
            expect( DriveCMsg( MSG_DV_EXPCT_RPAREN_DRIVE ) );
         
         nextlex( );

         New = new_array( count, 0 );

         while ((count > 0) && (littop > 0))
            New->inst_var[ --count ] = lit_array[ --littop ];

         break;

      case UPPERCASEVAR:
      case LOWERCASEVAR:
      case KEYWORD:
      case COLONVAR:
      case BINARY:
      case PE:
      case BAR:
      case SEMI:
         New = (OBJECT *) new_sym( t.c );
         nextlex( );
         break;

      default:
         if (must == TRUE)
            expect( DriveCMsg( MSG_DV_EXPCT_LITRL_DRIVE ) );
         else 
            return( - 1 );
      }

   FEND( printf( "0x%08LX = findLiteral()\n", New ) );

   return( addliteral( New ) );
}

/****h* gensend() [1.6] ************************************
*
* NAME
*    gensend()
*
* DESCRIPTION
*    Generate a message send
************************************************************
*
*/

PUBLIC int gensend( char *message, int numargs )
{
   char **p      = (char **) NULL;
   int    litnum = 0;
   int    i;

   FBEGIN( printf( "gensend( %s, %d )\n", message, numargs ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_GENSND_FUNC_DRIVE ), message, numargs );
   
   if (numargs == 0) 
      {
      for (p = unspecial, i = 0; *p != NULL; i++, p++)
         if (StringComp( *p, message ) == 0)
            {
            // UNSEND means Unary Send:
            genhighlow( UNSEND, i );      // 0xA0 + i.

            goto exitGenSend;
            }
      }
   else if (numargs == 1) 
      {
      for (p = binspecial, i = 0; *p != NULL; i++, p++)
         if (StringComp( *p, message ) == 0)
            {
            genhighlow( BINSEND, i );     // 0xB0 + i

            goto exitGenSend;
            }

      for (p = arithspecial, i = 0; *p != NULL; i++, p++)
         if (StringComp( *p, message ) == 0)
            {
            genhighlow( ARITHSEND, i );   // 0xC0 + i

            goto exitGenSend;
            }
      }
   else if (numargs == 2) 
      {
      for (p = keyspecial, i = 0; *p != NULL; i++, p++)
         if (StringComp( *p, message ) == 0)
            {
            genhighlow( KEYSEND, i );     // 0xD0 + i

            goto exitGenSend;
            }
      }

   // Non-special message found:
   genhighlow( SEND, numargs );           // 0x80 + numargs
   
   litnum = addliteral( (OBJECT *) new_sym( message ) );

   gencode( litnum );

exitGenSend:
   
   FEND( printf( "gensend() exits\n" ) );   

   return 0;
}

/****i* ucontinuation() [1.6] ******************************
*
* NAME
*    ucontinuation()
*
* DESCRIPTION
*    Unary continuation
************************************************************
*
*/

PRIVATE void ucontinuation( void )
{
   FBEGIN( printf( "ucontinuation( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_UCONT_FUNC_DRIVE ) );
   
   while (token == LOWERCASEVAR) 
      {
      gensend( t.c, 0 );
      nextlex( );
      }

   FEND( printf( "ucontinuation() exits\n" ) );

   return;
}

/****i* bcontinuation() [1.6] ******************************
*
* NAME
*    bcontinuation()
*
* DESCRIPTION
*    Binary continuation
************************************************************
*
*/

PRIVATE void bcontinuation( void )
{
   char bbuf[3] = EMPTY_STRING;

   FBEGIN( printf( "bcontinuation( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_BCONT_FUNC_DRIVE ) );
   
   ucontinuation();

   while (isbinary( bbuf )) 
      {
      primary( TRUE );
      ucontinuation();
      gensend( bbuf, 1 );
      }

   FEND( printf( "bcontinuation() exits\n" ) );

   return;
}

/****i* kcontinuation() [1.6] ******************************
*
* NAME
*    kcontinuation()
*
* DESCRIPTION
*    Keyword continuation ByteCode generation.
************************************************************
*
*/

PRIVATE void kcontinuation( void )
{
   char kbuf[256] = EMPTY_STRING;
   int  kcount    = 0;

   FBEGIN( printf( "kcontinuation( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_KCONT_FUNC_DRIVE ) );
   
   bcontinuation( );

   if (token == KEYWORD) 
      {
      kbuf[0] = NIL_CHAR;
      kcount  = 0;

      while (token == KEYWORD) 
         {
         StringCat( kbuf, t.c );
         StringCat( kbuf, ":" );

         kcount++;

         nextlex( );
         primary( TRUE );

         bcontinuation( );
         }

      gensend( kbuf, kcount ); // 0xA0 through 0xDF
      }

   FEND( printf( "kcontinuation() exits\n" ) );

   return;
}

/****i* cexpression() [1.6] ********************************
*
* NAME
*    cexpression()
*
* DESCRIPTION
*    Code for a (possibly cascaded ; ; ) expression
************************************************************
*
*/

PRIVATE void cexpression( void )
{
   FBEGIN( printf( "cexpression( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_CEXPR_FUNC_DRIVE ) );
   
   kcontinuation( );

   while (token == SEMI) 
      {
      genhighlow( SPECIAL, DUPSTACK ); // 0xF1
      nextlex( );
      
      kcontinuation( );
      genhighlow( SPECIAL, POPSTACK ); // 0xF2
      }

   FEND( printf( "cexpression() exits\n" ) );

   return;
}

/****h* genvar() [1.6] *************************************
*
* NAME
*    genvar()
*
* DESCRIPTION
*    Generate a ByteCode for dealing with a variable. 
************************************************************
*
*/

PUBLIC void genvar( char *name )
{
   int i;

   FBEGIN( printf( "void genvar( %s )\n", name ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_GENVAR_FUNC_DRIVE ), name );
   
   for (i = 0; i < temptop; i++)
      if (StringComp( name, tempnames[i] ) == 0) 
         {
         // name already in memory (Must be for a Block):

         genhighlow( PUSHTEMP, i + 1 ); // 0x20 + (i + 1) why the + 1??

         return;
         }

   genhighlow( PUSHINSTANCE, findvar( name, FALSE ) ); // 0x10 + findvar()

   FEND( printf( "genvar() exits\n" ) );

   return;
}

/****i* aprimary() [1.6] ***********************************
*
* NAME
*    aprimary()
*
* DESCRIPTION
*    Primary or beginning of assignment
************************************************************
*
*/

PRIVATE int aprimary( void )
{
   char *c    = NULL;
   int   rval = -1;
   
   FBEGIN( printf( "aprimary( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_APRIM_FUNC_DRIVE ) );
   
   if (token == LOWERCASEVAR) 
      {
      c = t.c;

      if (nextlex( ) == ASSIGN) 
         {
         nextlex( );  // Get the right half.

         // Find variable or add it:         
         rval = findvar( c, TRUE );
         
         goto exitAPrimary;
         }
      else 
         {
         genvar( c );
         
         goto exitAPrimary;
         }
      }

   primary( TRUE );  // More to go.

exitAPrimary:

   FEND( printf( "%d = aprimary() exits\n" ) );

   return( rval );
}

/****i* asign() [1.6] **************************************
*
* NAME
*    asign()
*
* DESCRIPTION
*    Code for an assignment statement - leaves result 
*    on stack
************************************************************
*
*/

PRIVATE void asign( int RcvrInstPos )
{
   int i = -1;

   FBEGIN( printf( "void asign( %d )\n", RcvrInstPos ) );   

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_ASSIGN_FUNC_DRIVE ), RcvrInstPos );
   
   i = aprimary();

   if (i >= 0)
      asign( i );    // Recursive call!!
   else 
      cexpression( );

   genhighlow( SPECIAL, DUPSTACK );        // 0xF1
   genhighlow( POPINSTANCE, RcvrInstPos ); // 0x60 + RcvrInstPos

   FEND( printf( "asign() exits\n" ) );

   return;
}

/****i* expression() [1.6] *********************************
*
* NAME
*    expression()
*
* DESCRIPTION
*    Read an expression, leaving result on stack
************************************************************
*
*/

PRIVATE int expression( void )
{
   int i = -1;

   FBEGIN( printf( "expression( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_EXPR_FUNC_DRIVE ) );
   
   i = aprimary();

   if (i >= 0) 
      asign( i );
   else
      cexpression( );

   FEND( printf( "expression() exits\n" ) );

   return 0;
}

/****i* block() [1.6] **************************************
*
* NAME
*    block()
*
* DESCRIPTION
*    Parse a block ( [theBlock] ) definition
************************************************************
*
*/

PRIVATE int block( void )
{
   int count    = 0;
   int i        = 0;
   int position = 0;

   FBEGIN( printf( "block( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_BLOCK1_FUNC_DRIVE ) );

   if (token == COLONVAR)  
      {
      while (token == COLONVAR) 
         {
         if (IndexChk( temptop + 1, MAXTEMPS, DriveCMsg( MSG_DV_BLOCK2_FUNC_DRIVE ) ) == FALSE)
            {
            return( -1 );
            }

         tempnames[temptop++] = t.c; // Only place tempnames gets added.

         if (temptop > maxtemps) 
            maxtemps = temptop;

         count++;
         nextlex( );
         }

      if (token != BAR) 
         expect( DriveCMsg( MSG_DV_EXPCT_BAR_DRIVE ) );

      nextlex( );
      }

   genhighlow( BLOCKCREATE, count ); // 0xE0 + count.

   if (count != 0)       // where arguments go in context:
      gencode( 1 + (temptop - count) );

   position = codetop;
   gencode( 0 );

   if (token == RB) 
      genhighlow( PUSHSPECIAL, 13 );  // 0x5D = end of block found.
   else
      while (1) // FOREVER
         {
         i = aprimary( );

         if (i >= 0) 
            {
            expression( );

            if (token != PERIOD)
               genhighlow( SPECIAL, DUPSTACK ); // 0xF1

            // i = receiver->inst_var[] index:
            genhighlow( POPINSTANCE, i );       // 0x60 + i
            }
         else 
            {
            cexpression( );

            if (token == PERIOD)
               genhighlow( SPECIAL, POPSTACK ); // 0xF2 
            }

         if (token != PERIOD)
            break;

         nextlex( );
         }

   genhighlow( SPECIAL, RETURN ); // 0xF3

   if (token != RB)       
      expect( DriveCMsg( MSG_DV_EXPCT_BLKEND_DRIVE ) );

   if (temptop - count < 0)
      {
      (void) IndexChk( temptop - count, MAXTEMPS, DriveCMsg( MSG_DV_BLOCK3_FUNC_DRIVE ) );

      return( -2 );
      }

   temptop -= count;

   nextlex( );

   i = (codetop - position) - 1;

   if (i > 255)
      lexIerr( DriveCMsg( MSG_FMT_DV_BLKBIG_DRIVE ), i );

   if (IndexChk( position, CODEMAX, DriveCMsg( MSG_DV_BLOCK4_FUNC_DRIVE ) ) == FALSE)
      return( -3 );
      
   code[ position ] = itouc( i );

   FEND( printf( "block() exits normally\n" ) );

   return( 0 ); // All okay (so far).
}

/****h* primary() [1.6] ************************************
*
* NAME
*    primary()
*
* DESCRIPTION
*    Find a primary expression
************************************************************
*
*/

PUBLIC int primary( BOOL must )  // must we find something?
{
   int i     = 0;
   int count = 0;

#  ifdef DEBUG
   fprintf( stderr, DriveCMsg( MSG_DV_PRIMY_FUNC_DRIVE ), must );
#  endif

   FBEGIN( printf( "primary( BOOL must = %d )\n", must ) );

   switch (token) 
      {
      case UPPERCASEVAR:
         genhighlow( PUSHCLASS, findLiteral( TRUE ) ); // 0x40 + findLiteral()
         break;

      case LOWERCASEVAR:
         genvar( t.c );
         nextlex( );
         break;

      case LITNUM:
         if (t.i >= 0 && t.i < 10) 
            {
            genhighlow( PUSHSPECIAL, t.i );         // 0x50 + t.i
            nextlex( );
            }
         else
            genhighlow( PUSHLIT, findLiteral( TRUE )); // 0x30 + findLiteral()
         break;

      case MINUS:
      case LITFNUM:
      case LITCHAR:
      case LITSTR:
      case LITSYM:
      case PS:
         genhighlow( PUSHLIT, findLiteral( TRUE ) );   // 0x30 + findLiteral()
         break;

      case PSEUDO:
         switch(t.p) 
            {
            case nilvar:    
               i        = 13; 
               break;
            
            case truevar:  
               i        = 11; 
               break;
            
            case falsevar:  
               i        = 12; 
               break;

            case smallvar:  
            case amigavar:  // amigatalk == smalltalk
               i        = 14; 
               break;

            case traceonvar:  // Enable tracing
               genhighlow( SPECIAL, METHOD_CTRL ); // 0xFD
               genhighlow( 0, 1 );
               goto avoidPushSpecial;
               
               break;
               
            case traceoffvar: // Disable tracing
               genhighlow( SPECIAL, METHOD_CTRL ); // 0xFD
               genhighlow( 0, 0 );
               goto avoidPushSpecial;

               break;

            default:        
               lexIerr( DriveCMsg( MSG_DV_UNK_PSEUDOV_DRIVE ), t.p );
            }

         genhighlow( PUSHSPECIAL, i ); // 0x50 + i

avoidPushSpecial:

         nextlex( );

         break;

      case PRIMITIVE:
         if (nextlex( ) != LITNUM) 
            expect( DriveCMsg( MSG_DV_EXPCT_PRMNUM_DRIVE ) );

         i = t.i;                        // The primitive number??

         nextlex( );

         count = 0;

         // Generate ByteCodes for primitive arguments:
         while (primary( FALSE ))        // Recursive Call!!!
            count++;

         if (token != PE)        
            expect( DriveCMsg( MSG_DV_EXPCT_PRMEND_DRIVE ) );

         nextlex( );                     // Discard newline. 
         genhighlow( SPECIAL, PRIMCMD ); // 0xFA
         gencode( count );               // number of arguments.
         gencode( i );                   // the primitive number.
         break;

      case LP:
         nextlex( );
         expression( );

         if (token != RP)       
            expect( DriveCMsg( MSG_DV_EXPCT_RPAREN_DRIVE ) );

         nextlex( );
         break;

      case LB:
         nextlex( );

         if (block() < 0)
            return( 0 );   // Tell Houston we have a problem.

         break;

      default:
         if (must == TRUE)       
            expect( DriveCMsg( MSG_DV_EXPCT_PREXPR_DRIVE ) );

         return( 0 );      // Tell Houston we have a problem.
      }

   FEND( printf( "primary() exits normally\n" ) );

   return( 1 );
}

SUBFUNC OBJECT *allocVarSpace( int count )
{
   OBJECT *vars = (OBJECT *) NULL;
   
   if (count > PAGE_MAX) // Have we overflowed one vpage?
      vars = new_obj( (CLASS *) NULL,        count, FALSE ); // yes
   else
      vars = new_obj( (CLASS *) NULL, PAGE_MAX + 1, FALSE ); // no

   if (!vars) // == NULL)
      {
      fprintf( stderr, "Ran out of Memory in allocVarSpace()!\n" );

      MemoryOut( "allocVarSpace()" );
      
      cant_happen( NO_MEMORY );
      }            

   return( vars );
}

SUBFUNC void copyVarValues( OBJECT *varSpace )
{
   struct varPage *vpage = vpageList;
   int             size  = 0;
   int             i     = 0, j = 0, newIdx = 0;

   // The first time for copyVarValues(), var_values will be NULL &
   // this loop will not execute:
   if (var_values) // != NULL)
      {
      size = objSize( var_values );
         
      for (i = 0; var_values->inst_var[i] != NULL && i < size; i++)
         {
         // Copy old values to new Array:
      
         varSpace->inst_var[i] = (OBJECT *) var_values->inst_var[i];

         newIdx++;
         }
      }

   if (newIdx < vItemsCount) // Hopefully, only one more entry to get:
      {
      while (newIdx < vItemsCount && vpage != NULL)
         {
         // j has to start at an odd number:

         for (i = 0, j = 1; 
              newIdx < vItemsCount && i < vpage->vp_ItemsUsed 
                                   && vpage->vp_Items[j]; // != NULL; 
              i++, j += 2)
            {
            varSpace->inst_var[ newIdx ] = (OBJECT *) vpage->vp_Items[j];

            newIdx++;
            }

         if (newIdx == vItemsCount) // We're done with the while loop!
            break;
         
         vpage = vpage->vp_Succ; // Add another varPage.
         }
      }

   return;
}

SUBFUNC OBJECT *makeVarValueObject( void )
{
   OBJECT *vars     = (OBJECT *) NULL;
   BOOL    killVars = FALSE;
   
   FBEGIN( printf( "makeVarValueObject( void )\n" ) );

   if (var_values && varsValid == TRUE) // new variable added?
      {
      return( var_values );
      }

   // New code to test:   
   else if (var_values && varsValid == FALSE && vItemsCount < PAGE_MAX)
      {
      vars = var_values; // killVars = FALSE;
      
      goto setupVarValues;
      }

   // Have to create a new var_values Object: --------------------
   vars     = allocVarSpace( vItemsCount );
   killVars = TRUE;                           // Throw out old var_values.
      
setupVarValues:

   copyVarValues( vars );

   if (killVars == TRUE && var_values && varsValid == FALSE)
      free_obj( var_values, FALSE ); // Get rid of old Object (but not inst_var[]s!).

   varsValid = TRUE; // var_values will be correct (for awhile!)

   FEND( printf( "0x%08LX = vars = makeVarValueObject()\n", vars ) );   

   return( vars );
}

/****h* bld_interpreter() [1.6] ****************************
*
* NAME
*    bld_interpreter()
*
* DESCRIPTION
*    Add a new bytecode interpreter to the program.
************************************************************
*
*/

PUBLIC int bld_interpreter( void )
{
   INTERPRETER *interp    = (INTERPRETER *) NULL;
   OBJECT      *literals  = (OBJECT *) NULL;
   OBJECT      *bytecodes = (OBJECT *) NULL;
   OBJECT      *Newbytes  = (OBJECT *) NULL;
   OBJECT      *context   = (OBJECT *) NULL;
   int         i          = 0;
   int         rval       = FALSE;
   
   FBEGIN( printf( "bld_interpreter( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_BLDINT_FUNC_DRIVE ) );

   if (codetop == 0)
      {
      rval = TRUE;
      
      goto exitBuilder;
      }

   // If 0xF3 is present, we do NOT need 0xF5 as well:
   if (code[ codetop - 1 ] != 0xF3)
      genhighlow( SPECIAL, SELFRETURN );  // 0xF5

   // Safety measure:
   gencode( 0 );                       // 0x00 mark end of bytecodes.    

   literals = AssignObj( new_array( littop, FALSE ) );

   for (i = 0; i < littop; i++)
      literals->inst_var[ i ] = lit_array[i];

   Newbytes  = new_bytearray( code, codetop );

   bytecodes = AssignObj( Newbytes );
   context   = AssignObj( new_obj( (CLASS *) 0, 1 + maxtemps, TRUE ) );

   if (!(var_values = makeVarValueObject())) // == NULL)
      {
      fprintf( stderr, "bld_interpreter() Ran out of memory!\n" );

      cant_happen( NO_MEMORY );
      
      return( FALSE ); // Never reached.
      }
      
   // Located in Interp.c:
   interp = cr_interpreter( (INTERPRETER *) o_drive, // sender   field
                            var_values,              // receiver field
                            literals, 
                            bytecodes, 
                            context
                          );

   link_to_process( interp );

   (void) obj_dec( context   );
   (void) obj_dec( bytecodes );
   (void) obj_dec( literals  );

exitBuilder:

   FEND( printf( "%d = bld_interpreter()\n", rval ) );

   return( rval );
}

/****h* parse() [1.6] **************************************
*
* NAME
*    parse()
*
* DESCRIPTION
*    Main parser in the AmigaTalk program.
************************************************************
*
*/

PUBLIC int parse( void )
{
   int i    = 0;
   int rval = -1;
   
   FBEGIN( printf( "parse( void )\n" ) );

   if (debug == TRUE)   
      fprintf( stderr, DriveCMsg( MSG_DV_PARSE_FUNC_DRIVE ) );

   errflag = FALSE;
   reset();

   if (nextlex() == nothing) 
      {
      rval = 1;

      goto exitParser;
      }

   if (token == NL) 
      {
      rval = 2;
      
      goto exitParser;
      }

   i = aprimary();

   if (i >= 0) 
      {
      asign( i );

      if ((prntcmd > 0) && inisstd)
         genhighlow( UNSEND, PRNTCMD ); // 0xA8, PRNTCMD is in Cmds.h
      }
   else 
      {
      cexpression( );

      if (prntcmd > 0 && inisstd)
         genhighlow( UNSEND, PRNTCMD ); // 0xA8
      }

   genhighlow( POPINSTANCE, 0 );        // 0x60 = assign to ``last''.

   if (errflag != FALSE)
      goto exitParser;

   if (token == nothing) 
      {
      bld_interpreter();
      
      rval = 1;
      
      goto exitParser;
      }
   else if (token == NL) 
      {
      bld_interpreter();

      rval = 2;
      
      goto exitParser;
      }

   expect( DriveCMsg( MSG_DV_EXPCT_EXPEND_DRIVE ) );

exitParser:

   FEND( printf( "%d = parse()\n" ) );

   return( rval );
}

/* ------------------- END of drive.c file! -------------------------- */
