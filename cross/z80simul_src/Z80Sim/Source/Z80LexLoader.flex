/************************************************************************
** Z80LexLoader.flex    The FLeX source for Z80LexLoader.c
**                      Used with Z80Loader.c
**
*************************************************************************/

%{
   
#include <exec/types.h>
#include <string.h>
#include <ctype.h>

#define   MAXLINE        255

#define   UNALLOWED      0
#define   WHITE          1
#define   REG            2
#define   ALPHA          3
#define   COLON          4
#define   BYTE           5
#define   BREAK          6
#define   LOAD           7
#define   ENDMARK        8
#define   ENDLINE        9
#define   DELIM          10

char  nil1[ MAXLINE ], *loadfile_buff = &nil1[0];


#ifdef   LOADFILE_DEBUG    /* TestLexLoader is the target!! */

extern char  *yytext;
extern FILE  *yyin;

void  main( int argc, char **argv )
{
   char  *infile = "Z80.cfg";
   int   tokval  = 0;

   if ((yyin = fopen( infile, "r" )) == NULL)  
      {
      fprintf( stderr, "Couldn't open %s for input!!\n", infile );
      exit( -1 );
      }
   tokval  = yylex();
   while (tokval >= 0)    
      {
      switch( tokval )  
         {
         case  UNALLOWED:  fprintf( stderr, "Not allowed: %s\n",
                                            loadfile_buff );
                           break;
         case  COLON:      fprintf( stderr, "-:-" );
                           break;
         case  BYTE:       fprintf( stderr, "#%s#", yytext );
                           break;
         case  WHITE:      fprintf( stderr, "\nWhite Space!\n" );
                           break;
         case  ENDLINE:    fprintf( stderr, "\n" );
                           break;
         case  REG:        fprintf( stderr, "REG" ); break;
         case  ALPHA:      fprintf( stderr, "<%s>", loadfile_buff );
                           break;
         case  BREAK:      fprintf( stderr, "BREAK" );  break;
         case  LOAD:       fprintf( stderr, "LOAD" );   break;
         case  DELIM:      fprintf( stderr, "@" );      break;
         case  ENDMARK:    fprintf( stderr, "END\n\n" );
                           break;
         default:          fprintf( stderr, "\ntokval = %d\n", tokval );
                           break;
         }
      tokval = yylex();
      }
   fclose( yyin );
   return;
}

#endif      /* LOADFILE_DEBUG */

%}
%%

[\n]+          { return ENDLINE; }
[ \t]+         { return WHITE;   }
[\:]           { return COLON;   }
"LOAD"         { return LOAD;    }
"BREAK"        { return BREAK;   }
"REG"          { return REG;     }
"END"          { return ENDMARK; }
[\@]           { return DELIM;   }

[ABCDEFHILR]|[ABCDEFHLS][P]|[I][XY]|[PC] { (void) strcpy( loadfile_buff, yytext );
                                      return ALPHA;
                                    }
                          
[0-9a-fA-F][0-9a-fA-F]   { strcpy( loadfile_buff, yytext );
                           return( BYTE ); 
                         } 

[\001-\010\016-\037\041-\057\073-\077GJKMNOQTUVWZ\133-\140gjkmnoqtuvwz\173-\177]* { (void) strcpy( loadfile_buff, yytext );
                           return( UNALLOWED ); 
                         }

%%
