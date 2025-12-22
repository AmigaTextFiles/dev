/****h* Calc.y [1.0] ************************************************
*
* NAME
*    Calc.y
*
* DESCRIPTION
*    The parser for the calculator program.
*
* LAST CHANGED:  03-May-2002
*
******************************************************
*
*/

%{

#include <ctype.h>
#include <stdio.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#define   CATCOMP_ARRAY 1
#include "MyCalcLocale.h"

#include <StringFunctions.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

IMPORT struct Catalog *catalog;

/*  Perhaps someone else can add floating point support!

float  regs[26] = { 0.0 };     // calculator has 26 memories!
float  val      = 0.0;
*/

int    printflag, exitflag, val = 0;

#ifdef PARSE_DEBUG
# define PDBG( f, v )     fprintf( stderr, f, v )
#else
# define PDBG( f, v )
#endif

extern STRPTR CMsg( int strIndex, STRPTR defaultString );

/*
float ConvToFloat( int arg )
{
   float dummy = arg;
   
   return( dummy );
}

int ConvToInt( float arg )
{
   int dummy = (int) arg;
   
   return( dummy );
}
*/

int BreakPoint( void )
{
   return( 0 );
}

%}

%union   {

   char  *y_str;   /* ID     */
   int    y_num;   /* Number */
   float  y_float; /* Float  */

   }

/* %start statement */

%token <y_num>   NUMBER    HEXSTRING
%type  <y_num>   integer   number
%type  <y_num>   statement binary

/*
%type  <y_float> statement expr term factor
%token <y_float> FLOAT
*/

%token NUMBER HEXSTRING EXIT OR    AND   EOL       PLUS MINUS STAR SLASH PERCENT
%token LPAREN RPAREN    XOR  EQUAL YYEOF BITINVERT /* FLOAT */
%token LSHIFT RSHIFT    DOLLAR 

%right EQUAL
%left  OR
%left  XOR
%left  AND
%left  LSHIFT RSHIFT 
%left  PLUS MINUS
%left  STAR SLASH PERCENT
%left  BITINVERT

%%

statement :  exitstmt
          |  binary eol
             { PDBG( "Expr RESULT: %d\n", val ); }
          |  binary eol exitstmt
             { PDBG( "Expr RESULT: %d\n", val ); }
          ;

exitstmt  :  EXIT EOL
             { exitflag = 1; 
               YYACCEPT; 
             }
          ;
          
binary    :  number { val = $$; yyerrok; }
          |  lp binary rp
             { val = $$ = $2; yyerrok; }
          |  binary PLUS  binary
             { val = $$ = $1 + $3; 
               yyerrok; 
             }
          |  binary MINUS binary
             { val = $$ = $1 - $3; yyerrok; }
          |  binary STAR  binary
             { val = $$ = $1 * $3; 
               yyerrok; 
             }
          |  binary SLASH binary
             { if ($3 != 0)
                  { 
                  val = $$ = $1 / $3;
                  } 
               else
                  {
                  fprintf( stderr, CMsg( MSG_DIVIDE_ZERO_ERROR, MSG_DIVIDE_ZERO_ERROR_STR ) );
                  val = $$ = 0;
                  }

               yyerrok; 
             }
          |  binary PERCENT binary
             { if ($3 != 0)
                  val = $$ = $1 % $3; 
               else
                  {
                  fprintf( stderr, CMsg( MSG_DIVIDE_ZERO_ERROR, MSG_DIVIDE_ZERO_ERROR_STR ) );
                  val = $$ = 0;
                  }

               yyerrok; 
             }
          |  binary OR     binary
             { val = $$ = $1 | $3; yyerrok; }
          |  binary AND    binary
             { val = $$ = $1 & $3; 
               yyerrok; 
             }
          |  binary XOR    binary
             { val = $$ = $1 ^ $3; yyerrok; }
          |  binary LSHIFT binary
             { val = $$ = $1 << $3; yyerrok; }
          |  binary RSHIFT binary
             { val = $$ = $1 >> $3; yyerrok; }
          ;
          
eol       :
          |  EOL
          ;

number    :  integer /* | float */ ;

integer   :  NUMBER
             { yyerrok; }
          |  HEXSTRING
             {
               val = $$; /* (void) stch_i( $$, &val ); */
             
               yyerrok; 
             }
          |  BITINVERT NUMBER
             { $$ = ~$2; val = $$; }
          |  BITINVERT HEXSTRING
             {
               $$ = ~$2; val = $$; /* (void) stch_i( $2, &val ); val = ~val; */

               yyerrok;
             }
          |  MINUS NUMBER    %prec BITINVERT
             { $$ = -$2; val = $$; yyerrok; }
          |  MINUS HEXSTRING %prec BITINVERT
             {
               $$ = -$2; val = $$; /* (void) stch_i( $2, &val ); val = -val; */
               
               yyerrok; 
             }
          ;

lp        :  LPAREN  { yyerrok; }
          ;

rp        :  RPAREN  { yyerrok; }
          ;

%%

#ifdef PARSE_DEBUG

void yyerror( char *s )  {  printf( CMsg( MSG_FMT_PARSE_ERROR, MSG_FMT_PARSE_ERROR_STR ), s );  }

void main( int argc, char **argv )
{
   exitflag = 0;

   if (argc == 2)
      yydebug = 1;
     
   for ( ; ; )
      {
      printflag = 1;

      if (yyparse() == 0 && printflag != 0)
         {
         printf( CMsg( MSG_FMT_PARSE_RESULT, MSG_FMT_PARSE_RESULT_STR ), val );

         printflag = 0;
         }

      if (exitflag == 1)
         return;
      }

   return;
}

#else

#include "CPGM:GlobalObjects/CommonFuncs.h"

void yyerror( char *s )
{
   UserInfo( s, CMsg( MSG_CHECK_EXPRESSION_RQTITLE, MSG_CHECK_EXPRESSION_RQTITLE_STR ) );
   
   return;
}

IMPORT char *TTTempFile;

IMPORT int yyin;

PUBLIC int Calculate( char *expr )
{
   char  ErrMsg[512] = { 0, };
   
   int   rval  = 0;
   FILE *tfile = OpenFile( TTTempFile, "w" );
   
   if (!tfile) // == NULL)
      {
      sprintf( ErrMsg, CMsg( MSG_FMT_NO_FILE_WRITE, MSG_FMT_NO_FILE_WRITE_STR ), TTTempFile );
      
      UserInfo( ErrMsg, CMsg( MSG_SYSTEM_PROBLEM_RQTITLE, MSG_SYSTEM_PROBLEM_RQTITLE_STR ) );
      
      return( -1 );
      }
   else
      {
      StringCopy( ErrMsg, expr );

      StringCat( ErrMsg, "\nQ\n" );
      
      fputs( ErrMsg, tfile );

      fclose( tfile );
      
      if (!(tfile = OpenFile( TTTempFile, "r" ))) // == NULL)
         {
         sprintf( ErrMsg, CMsg( MSG_FMT_NO_FILE_READ, MSG_FMT_NO_FILE_READ_STR ), TTTempFile );
      
         UserInfo( ErrMsg, CMsg( MSG_SYSTEM_PROBLEM_RQTITLE, MSG_SYSTEM_PROBLEM_RQTITLE_STR ) );
      
         return( -1 );
         }

      yyin = (int) tfile;
      
      yyparse();
      
      fclose( tfile );
      
      yyin = (int) stdin; /* Just in case */
      
      rval = val;
      }

   return( rval );      
}

#endif

/* ------------ END of Calc.y file! ----------------- */
