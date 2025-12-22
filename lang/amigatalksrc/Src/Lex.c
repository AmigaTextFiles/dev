/****h* AmigaTalk/Lex.c [3.0] ******************************************
*
* NAME
*    Lex.c
*
* DESCRIPTION
*    Little Smalltalk lexical analyzer for driver 
*
* FUNCTIONS DEFINED: 
*
*    PUBLIC int nextlex( void );
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    09-Nov-2003 - Reinstated pseudo variables smalltalk & amigatalk.
*
*    04-Feb-2003 - Removed pseudo variables smalltalk & amigatalk.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
* EXTERNALS REF'D:
*
*    IMPORT double atof( char * );
*
*    IMPORT void   lexerr( char *, char * );
*
*    IMPORT char  *w_search( char *, int );
*
* NOTES
*    $VER: AmigaTalk:Src/Lex.c 3.0 (25-Oct-2004) by J.T Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#ifdef   __SASC
# define HUGE_VAL
#endif
#include <math.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include "Env.h"

#define DRIVECODE
#include "drive.h"

#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "FuncProtos.h"

#include "CantHappen.h"

IMPORT  int    lexprnt;       // defined in main.c
IMPORT  int    debug;

IMPORT UBYTE *ErrMsg;

/****i* TokenStr() [1.0] *********************************************
*
* NAME
*    TokenStr()
*
* DESCRIPTION
*    Translate a token integer to a string for debugging purposes.
*    This function is only called if lexprnt flag != 0.
**********************************************************************
*
*/

PRIVATE char *TokenStr( int theToken, char *tokenText )
{
   static char TS[256] = { 0, }, *rval = &TS[0];

   switch (theToken)
      {
      case NL:
         StringCopy( rval, " NLine" );
         break;

      case MINUS:
         StringCopy( rval, "-" );
         break;

      case LP:
         StringCopy( rval, "(" );
         break;

      case RP:
         StringCopy( rval, ")" );
         break;

      case LB:
         StringCopy( rval, "[" );
         break;

      case RB:
         StringCopy( rval, "]" );
         break;

      case BAR:
         StringCopy( rval, "| or !" );
         break;

      case PERIOD:
         StringCopy( rval, "." );
         break;

      case SEMI:
         StringCopy( rval, ";" );
         break;

      case PE:
         StringCopy( rval, ">" );
         break;

      case nothing:
         StringCopy( rval, LexCMsg( MSG_LX_NOTHING_LEX ) );
         break;

      case LITNUM:
         sprintf( rval, "%d", t.i );
         break;

      case LITFNUM:
         sprintf( rval, "%g", t.f );
         break;

      case LITCHAR:
         sprintf( rval, "$%d", t.i );
         break;
         
      case LITSTR:
         sprintf( rval, "\'%s\'", t.c );
         break;

      case LITSYM:
         sprintf( rval, "#%s", t.c );
         break;

      case ASSIGN:
         StringCopy( rval, "<-" );
         break;
         
      case PRIMITIVE:
         StringCopy( rval, "<primitive" );
         break;
         
      case PSEUDO:
         switch (t.p)
            {
            case nilvar:
               StringCopy( rval, "nil" ); // MSG_LX_NIL_STR_STR
               break;

            case truevar:
               StringCopy( rval, "true" ); // MSG_LX_TRUE_STR_STR
               break;
                
            case falsevar:
               StringCopy( rval, "false" ); // MSG_LX_FALSE_STR_STR
               break;
                
            case selfvar:
               StringCopy( rval, "self" ); // MSG_LX_SELF_STR_STR
               break;
                
            case supervar:
               StringCopy( rval, "super" ); // MSG_LX_SUPER_STR_STR
               break;
            case procvar:
               StringCopy( rval, "process" );   // MSG_LX_PROC_STR_STR
               break;

            case traceonvar:
               StringCopy( rval, "tracingon" );   // MSG_LX_TRC_ON_STR
               break;

            case traceoffvar:
               StringCopy( rval, "tracingoff" );   // MSG_LX_TRC_OFF_STR
               break;

            case smallvar:
               StringCopy( rval, "smalltalk" ); // MSG_LX_SMALL_STR_STR
               break;
                
            case amigavar:
               StringCopy( rval, "amigatalk" ); // MSG_LX_ATALK_STR_STR
               break;
            }
         break;

      case UPPERCASEVAR:
         sprintf( rval, "%s", tokenText );
         break;
         
      case LOWERCASEVAR:
         sprintf( rval, "%s", tokenText );
         break;

      case COLONVAR:
         sprintf( rval, ":%s", t.c );
         break;

      case PS:
         StringCopy( rval, "#" );
         break;

      case BINARY:
         sprintf( rval, "%s", t.c );
         break;

      case KEYWORD:
         sprintf( rval, "%s:", t.c );
         break;

      case LITARR:
      case LITBYTE:
      default:
         sprintf( rval, LexCMsg( MSG_LX_IMPOSSIBLE_LEX ), theToken );
         break;
      }

   return( rval );
}

// -------------------------------------------------------------------

PRIVATE char   ocbuf       = 0;     // index for pbbuf[].
PRIVATE int    pbbuf[ 20 ] = { 0, };   // putback buffer!

/****i* PUTBAK() [1.0] ***********************************************
*
* NAME
*    PUTBAK()
*
* DESCRIPTION
*    Add character 'c' to the put-back buffer 'pbbuf'.
**********************************************************************
*
*/

PRIVATE void PUTBAK( char c )
{
   if (debug == TRUE)
      {
      if (IndexChk( ocbuf + 1, 32, 
                    LexCMsg( MSG_LX_PUTBAK1_LEX ) ) == FALSE)
         {
         int ans = 0;
      
         sprintf( ErrMsg, LexCMsg( MSG_LX_PUTBAK2_LEX ), ocbuf, pbbuf );
      
         ans = Handle_Problem( ErrMsg, LexCMsg( MSG_LX_FATALERR_LEX ), NULL );
      
         if (ans == 0)
            return;
         else
            ShutDown();
         }
      }

   pbbuf[ ocbuf++ ] = c;

   return;
}

/****i* input() [1.0] ************************************************
*
* NAME
*    input()
*
* DESCRIPTION
*    Return a character from either line_grabber()-filled 
*    buffer, allocd_buffer, or the putback buffer pbuf[].
**********************************************************************
*
*/

PRIVATE char input( void )
{
   IMPORT char *allocd_buffer; // defined in Global.c
   IMPORT int  buffindex;      // defined in Global.c
   
   char  rval;
   
   if (ocbuf > 0)
      rval = pbbuf[ --ocbuf ]; // There's a character in the pbbuf[]. 
   else
      {
      rval = *allocd_buffer++; // Side effect of input()!!
      buffindex++;             // Used to be lexptr.
      }

/*
   if (lexprnt > 0)
      fprintf( stderr, "%c", rval );
*/

   if (debug == TRUE)
      {
      fprintf( stderr, "%c", rval );
      fflush( stderr );
      }

   return( rval );
}

//              Used by parse() in interp.c:

PUBLIC char     toktext[ MAXTOKEN ] = { 0, }; // MAXTOKEN >= 256
PUBLIC int      token;

PUBLIC tok_type t;

   
/****i* lexsave() [1.0] **********************************************
*
* NAME
*    lexsave()
*
* DESCRIPTION
*    Assign 'type' to 'token'.
*    Search for current toktext & set t.c to return value of
*    w_search( char *, int ).  Return with token == type.
**********************************************************************
*
*/
   
PRIVATE int lexsave( int type )
{
   if (debug == TRUE)
      fprintf( stderr, LexCMsg( MSG_LX_LEXSAVE_LEX ), type );

   if ((t.c = w_search( toktext, 1 )) == NULL)
      lexerr( LexCMsg( MSG_LX_NO_SYMBOLS_LEX ), toktext );

   // assign token, and return value:
   token = type;

/*
   if (lexprnt > 0)
      {
      fprintf( stderr, "token: %d\n", token );
      fprintf( stderr, "toktext: %s\n", toktext );
      }
*/

   return( token );
}

PRIVATE char *psuvars[]  = { "nil", "true", "false",   // LX_NIL_STR,   LX_TRUE_STR,  LX_FALSE_STR,
                             "smalltalk", "amigatalk", // LX_SMALL_STR, LX_ATALK_STR,
                             "tracingon", "tracingoff",
                             0
                           };

PRIVATE int   psuval[]   = { nilvar, truevar, falsevar, 
                             smallvar, amigavar,
                             traceonvar, traceoffvar,
                             0 
                           };

PRIVATE char  symbols[]  = "\n-()[]!|.;>" ;

PRIVATE int   symval[]   = { NL,  MINUS, LP,     RP,   LB, RB, 
                             BAR, BAR,   PERIOD, SEMI, PE 
                           };

/****h* nextlex() [1.5] **********************************************
*
* NAME
*    nextlex()
*
* DESCRIPTION
*    Process the next lexical token(s).
**********************************************************************
*
*/

PUBLIC int nextlex( void ) 
{
   register char *p = NULL;
   register char c  = NIL_CHAR;

   char   *q = NULL;
   double  d, denom;
   int     i, n, base, rval = -1;

   if (debug == TRUE)
      fprintf( stderr, LexCMsg( MSG_LX_NEXTLEX_LEX ) );

   do {                  // read whitespace (including comments):
      c = input( );

      //if (lexprnt != 0)
        // fprintf( stderr, "%c", c );

      if (c == '\"')  // Start of comment??
         {
         if (lexprnt != 0)
            fprintf( stderr, "%c", c );

         while ((c = input( )) && c != '\"')  // eat comments!
            {
            if (lexprnt != 0)
               fprintf( stderr, "%c", c );
            }
            
         if (c == '\"') 
            {
            if (lexprnt != 0)
               fprintf( stderr, "%c", c );
            
            c = input( );
            }
         else
            {
            lexerr( LexCMsg( MSG_UNTERMD_COMMENT_LEX ), "" );

            if (lexprnt != 0)
               fprintf( stderr, "%c", c );
            }
         }

      } while (c == SPACE_CHAR || c == TAB_CHAR);

   if (c == 0)       
      {
      rval = token = nothing;
      goto ReturnToken;
      }

    p         = toktext;
   *p         = c;
   toktext[1] = NIL_CHAR;

   // Identifiers and keywords are checked for here:

   if (( c >= SMALL_A_CHAR && c <= SMALL_Z_CHAR) 
       || (c >= CAP_A_CHAR && c <= CAP_Z_CHAR)) 
      {
      // Slurp up an identifier or string:
      for (*p++ = c; (c = input( )) && isalnum(c); *p++ = c) 
         {
         // This 'if' statement isn't in the original code:
         if (StringLength( toktext ) >= MAXTOKEN)
            {
            lexerr( LexCMsg( MSG_LX_LONG_TOKEN_LEX ), toktext );

            cant_happen( INTERNAL_BUFF_OVF ); // Die, you abomination!!

            break;                            // Unreachable point.
            }
         }

      *p = NIL_CHAR;
      lexsave( 0 ); // token <- 0

      if (c == COLON_CHAR) 
         {
         rval = token = KEYWORD; // token = 'keyword:'

         goto ReturnToken;
         }
      else 
         {
         PUTBAK( c );

         if ((toktext[0] >= SMALL_A_CHAR) && (toktext[0] <= SMALL_Z_CHAR)) 
            {
            // First letter is lower case:
            for (i = 0; psuvars[i] != NULL; i++) // check for a Pseudo var:
               {
               if (StringComp( toktext, psuvars[i] ) == 0) 
                  {
                  t.p  = psuval[i];
                  rval = token = PSEUDO;

                  goto ReturnToken;
                  }
               }

            rval = token = LOWERCASEVAR; // 1st letter was lower case.
            goto ReturnToken;
            }
         else 
            {
            rval = token = UPPERCASEVAR; // 1st letter was upper case.
            goto ReturnToken;
            }
         }
      }
   
   if (c >= ZERO_CHAR && c <= NINE_CHAR) 
      {                        // check for number strings here:
      i = c - ZERO_CHAR;

      // this loop used to be scandigits() macro: 
      for (*p++ = c; (c = input()) && isdigit( c ); *p++ = c)
          i = 10 * i + (c - ZERO_CHAR);

      if (c == PERIOD_CHAR || c == SMALL_E_CHAR) 
         {
         if (c == PERIOD_CHAR) 
            {
            // peek at the next char to make sure:
            n = input( ); 
            PUTBAK( n );

            if ( !isdigit( n ) )
               goto ret_int;

            // this loop used to be scandigits( 0 ) macro: 
            for (*p++ = c; (c = input()) && isdigit( c ); *p++ = c)
               ;
            }

         if (c == SMALL_E_CHAR)     // exponent definition?
            {
            *p++ = c;
            c = input( );

            if (c == PLUS_CHAR || c == MINUS_CHAR) 
               {
               *p++ = c; 
               c    = input( ); 
               }

            // this loop used to be scandigits( 0 ) macro: 
            for (*p++ = c; (c = input()) && isdigit( c ); *p++ = c)
               ;
            }

         PUTBAK( c );

         *p   = NIL_CHAR;
         t.f  = atof( toktext );
         rval = token = LITFNUM; // number string was a Float!

         goto ReturnToken;
         }

      else if ((c == SMALL_R_CHAR) && ((i >= 2) && (i <= 36))) // radix in number?
         {
         base = i;
         i    = 0;

         for (*p++ = c; c = input( ); *p++ = c) 
            {
            if ((c >= ZERO_CHAR) && (c <= NINE_CHAR))      // isdigit( c )) 
               n = c - ZERO_CHAR;
            else if ((c >= CAP_A_CHAR) && (c <= CAP_Z_CHAR)) // isupper( c )) 
               n = (c - CAP_A_CHAR) + 10;
            else if ((c >= SMALL_A_CHAR) && (c <= SMALL_Z_CHAR)) // islower( c )) 
               n = (c - SMALL_A_CHAR) + 10;
            else 
               break;

            if (n >= base)       
               break;

            i = base * i + n;
            }

         if (c == PERIOD_CHAR || c == SMALL_E_CHAR)  // floating point radix??
            {
            d = (double) i;

            if (c == PERIOD_CHAR) 
               {
               // just peek at the next char:
               n = input( ); 
               PUTBAK( n );

               if (( !isdigit( n ) ) && ( !isupper( n ) )) 
                  goto ret_int;

               denom = 1.0 / (double) base;

               for (*p++ = c; c = input( ); *p++ = c) 
                  {
                  if ((c >= ZERO_CHAR) && (c <= NINE_CHAR))      // isdigit( c ))
                     n = c - ZERO_CHAR;
                  else if ((c >= CAP_A_CHAR) && (c <= CAP_Z_CHAR)) // isupper( c ))
                     n = (c - CAP_A_CHAR) + 10;
                  else if ((c >= SMALL_A_CHAR) && (c <= SMALL_Z_CHAR)) // islower( c ))
                     n = (c - SMALL_A_CHAR) + 10;
                  else 
                     break;

                  if (n >= base) 
                     break;

                  d     += n * denom;
                  denom /= base;
                  }
               }

            if (c == SMALL_E_CHAR) 
               {
               *p++ = c;
               c    = input( );

               if (c == PLUS_CHAR || c == MINUS_CHAR) 
                  {
                  n    = c;
                  *p++ = c;
                  c    = input( );
                  }
               else 
                  n = 0;

               i = c - ZERO_CHAR;

               // this loop used to be scandigits() macro: 
               for (*p++ = c; (c = input()) && isdigit( c ); *p++ = c)
                  i = 10 * i + (c - ZERO_CHAR);

               if (n == MINUS_CHAR) 
                  i = - i;

               d *= pow( (double) base, (double) i );
               }

            PUTBAK( c );

            *p   = NIL_CHAR;
            t.f  = d;
            rval = token = LITFNUM;

            goto ReturnToken;
            }
         }

ret_int:                   // Found an integer:

      PUTBAK( c );

      *p   = NIL_CHAR;
      t.i  = i;
      rval = token = LITNUM;

      goto ReturnToken;
      }

   if (c == POUND_CHAR) 
      {                     
      // symbol definition found:
      i = 1;

      while (i != 0)
         {
         switch (c = input( )) 
            {
            case NIL_CHAR: 
            case SPACE_CHAR: 
            case TAB_CHAR: 
            case NEWLINE_CHAR:
            case RBRKT_CHAR:  // Not part of a Symbol!
            case LPAREN_CHAR: // Start of          Array definition. 
            case LBRKT_CHAR:  // Start of ByteCode Array definition.
            case RPAREN_CHAR: // End   of          Array definition.

               PUTBAK( c );
               i = 0;

               break;

            default:
               *p++ = c; // definitely a symbol, not just a pound sign!
            }
         }

      if (p == toktext)
         {
         rval = token = PS;   // just a pound sign, no symbol.
         goto ReturnToken;
         }
      else 
         {
         *p = NIL_CHAR;

         if ((p - toktext) >= MAXTOKEN) 
            cant_happen( INTERNAL_BUFF_OVF ); // Die, you abomination!!

         rval = lexsave( LITSYM );       // Literal Symbol found!

         goto ReturnToken;
         }
      }

   if (c == SQUOTE_CHAR) 
      {               
      // quoted string definition found:
      do {

         for ( ; (c = input( )) && c != SQUOTE_CHAR; *p++ = c) 
            {
            if (StringLength( toktext ) >= MAXTOKEN)
               {
               lexerr( LexCMsg( MSG_LX_LONG_TOKEN_LEX ), toktext );

               cant_happen( INTERNAL_BUFF_OVF ); // Die, you abomination!!

               break;                            // Unreachable.
               }
            }

         c = input();

         if (c == SQUOTE_CHAR) 
            *p++ = SQUOTE_CHAR;

         } while (c == SQUOTE_CHAR);

      PUTBAK( c );
      *p = NIL_CHAR;

      if ((p - toktext) >= MAXTOKEN)       // overflow in toktext[]??
         cant_happen( INTERNAL_BUFF_OVF ); // Die, you abomination!!

      t.c  = toktext;
      rval = token = LITSTR;          // Literal string defined.

      goto ReturnToken;
      }

   if (c == COLON_CHAR) 
      {               
      // colon or argument name found:
      c = input( );

      if (c == EQUAL_CHAR) 
         {
         rval = token = ASSIGN;  // Assign == ':=' (use '<-' instead!)
         goto ReturnToken;
         }
      else if (isalnum( c )) 
         {
         for (*p++ = c; isalnum( c = input( ) ); *p++ = c )
            ; // read entire string into *p.

         PUTBAK( c );

         *p = NIL_CHAR;
         rval = lexsave( COLONVAR );   // found :ColonVar token

         goto ReturnToken;
         }

      PUTBAK( c );
      rval = lexsave( BINARY );

      goto ReturnToken;
      }

   if (c == LESS_CHAR) 
      {     
      // assign, less than or primitive found:
      *p++ = c; 
      *p   = NIL_CHAR;
       c   = input( );

      if (c == MINUS_CHAR)
         {
         rval = token = ASSIGN;  // Assignment operator '<-' found.
         goto ReturnToken;
         }

      for (p = q = "primitive"; (*p != NIL_CHAR) && (*p == c); p++)
         c = input( );

      PUTBAK( c );

      if (*p != NIL_CHAR) 
         {
         for (p--; p >= q; p--) 
            PUTBAK( *p );

         rval = lexsave( BINARY );  // Just a '<' BINARY op.
         goto ReturnToken;
         }
      else 
         {
         rval = token = PRIMITIVE;  // found '<primitive' string.
         goto ReturnToken;
         }
      }

   if (c == PERIOD_CHAR) 
      {                  
      // number or period found:
      c = input( );

      if (c >= ZERO_CHAR && c <= NINE_CHAR) 
         {
         PUTBAK( c );            // reparse with digit
         PUTBAK( PERIOD_CHAR );  // inserted in front of period
         PUTBAK( ZERO_CHAR   );  // so it looks like a number.

         rval = nextlex( );      // Recursive call!!

         goto ReturnToken;
         }

      PUTBAK( c );
      return( token = PERIOD );  // just found a period.
      }

   if (c == BACK_CHAR) // '\\' is no longer in Integer.st. 
      {
      // binary or hidden newline:
      c = input( );

      if (c == NEWLINE_CHAR)
         {
         if (lexprnt != 0)
            fprintf( stderr, "\\" ); // output the backslash!
            
         rval = nextlex( ); // ignore '\' line continuation token!
         goto ReturnToken;
         }

      PUTBAK( c );              // this should never be reached.
      rval = lexsave( BINARY ); // this should never be reached.

      goto ReturnToken;         // this should never be reached.
      }

   if (c == DOLLAR_CHAR) 
      {                
      // literal character or binary:
      c = input( );

      if (c != 0)
         {
         t.i  = c;
         rval = token = LITCHAR; // found a Literal character token

         goto ReturnToken;
         }

      rval = lexsave( BINARY );
      goto ReturnToken;
      }

   for (i = 0; symbols[i]; i++)
      {
      if (c == symbols[i])
         {
         rval = lexsave( symval[i] );
         goto ReturnToken;
         }
      }

   rval = lexsave( BINARY );

ReturnToken:

   if (lexprnt > 0)
      {
      fprintf( stderr, "(%d = %s)\n", token, TokenStr( token, toktext ) );
      }

   return( rval );
}

/* ------------------- END of Lex.c file! -------------------------- */
