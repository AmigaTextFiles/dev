/*****************************************************************
**    Z80XLATE.FLEX  An Intel Hex File to Z80 Simulator
**                   translator program.
**
**    PATHNAME:      DH0:CPGM/Z80/Z80Xlate.flex
**
**    SEQUENCE:      z80xlate source_file out_file
**
**    PARAMETERS:    source_file - a file containing hexadecimal object
**                                 code.
**                   out_file    - an output file that the Z80 Simulator
**                                 can use.
**
**    LAST CHANGED:  03/01/94 - Translated into a FLeX source file.
**                   12/25/90
**
**    How to make Z80Xlate:
**
**    flex Z80Xlate.flex
**    SC data=far nostackcheck objectname=RAM:Z80Xlate.o Z80Xlate.c
**    FSMGen <Z80Xlate.defn >Z80Xlatemain.c
**    SC data=far nostackcheck objectname=RAM:Z80Xlatemain.o Z80Xlatemain.c
**    COPY RAM:Z80Xlate.o Z80Xlate.o
**    COPY RAM:Z80Xlatemain.o Z80Xlatemain.o
**    SLINK LIB:c.o,Z80Xlate.o,Z80Xlatemain.o TO Z80Xlate WITH TheLIBS
**
**    How to make Z80Xlator:
**
**    flex Z80Xlate.flex
**    SC data=far define XLATE_DEBUG=1 nostackcheck objectname=RAM:Z80XlateD.o 
**                Z80Xlate.c
**    SC data=far nostackcheck objectname=RAM:Z80XlatemainD.o Z80Xlatemain.c
**    COPY RAM:Z80XlateD.o Z80XlateD.o
**    COPY RAM:Z80XlatemainD.o Z80XlatemainD.o
**    SLINK LIB:c.o,Z80XlateD.o,Z80XlatemainD.o TO Z80Xlator WITH TheLIBS
**
**    TheLIBS:
**
**    LIBRARY LIB:sc.lib,LIB:scm.lib,LIB:Amiga.lib,LIB:Funcs.lib
**
******************************************************************/

%{

#include <exec/types.h>
#include <string.h>
#include <ctype.h>

#define   MAXLINE        255

#define   UNALLOWED      0
#define   WHITE          1
#define   COLON          2
#define   BYTE           3
#define   ENDLINE        4
#define   ENDFILE        5

int    yylval = 0;

extern char    *yytext;

#ifdef   XLATE_DEBUG

void  main( int argc, char **argv )
{
   int   tokval = 0, prevtok = 0;

   tokval  = yylex();
   prevtok = tokval;
   while (tokval >= 0)
      {
      switch( tokval )  
         {
         case  UNALLOWED:  fprintf( stderr, "Not allowed: %s\n", yytext );
                           break;
         case  COLON:      fprintf( stderr, ":" );
                           break;
         case  BYTE:       fprintf( stderr, "%s", yytext );
                           break;
         case  WHITE:      fprintf( stderr, "\nWhite Space!\n" );
                           break;
         case  ENDLINE:    fprintf( stderr, "\n" );
                           break;
         case  ENDFILE:    fprintf( stderr, "EOF!\n" );
                           break;
         default:          fprintf( stderr, "\ntokval = %d\n", tokval );
                           break;
         }
      tokval = yylex();
      if (tokval == prevtok)    
         {
         fprintf( stderr, "\nToken Loop: %d *** Aborting! ***\n", tokval );
         return;
         }
      prevtok = tokval;
      }
   return;
}

#endif      /* XLATE_DEBUG */

%}
%%

[\000-\010\013\016-\031\033-\037!-/\;-@G-Zg-z]*|[\133-\140\173-\177]* { return( UNALLOWED ); }

[\n]    { return( ENDLINE ); }

[\032]  { return( ENDFILE ); }

[\t ]+  { return( WHITE ); }

[\:]    { return( COLON ); }

[0-9a-fA-F][0-9a-fA-F]   { sscanf( yytext, "%02X", &yylval );
                           return( BYTE ); 
                         } 
%%
