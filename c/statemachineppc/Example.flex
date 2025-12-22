/****h* [2.0] **********************************************
*
* NAME
*    Example.flex
*
* DESCRIPTION
*    The FLEX definition file for Example program.
*
* RETURNS
*    Integer value
*
* HISTORY
*    18-Nov-2004 - Ported to AmigaOS4 & gcc.
*
************************************************************
*
*/

%option noyywrap

%{
               /* Defines & EXAMPLE_DEBUG Stuff: */

#include <stdio.h>
#include <string.h>

#include "Example.h"

#define  MAXLINE  255

int      loc = 0, i = 0;
char     yylvalbuff[ MAXLINE ];
char     *idstr = &yylvalbuff[0];

#ifdef   EXAMPLE_DEBUG

void  main( void )
{
   int   tokval = 0;

   tokval  = yylex();

   while (tokval != 0)  
      {
      switch (tokval)     
         {
         case  WHITE_:         
            fprintf( stderr, "%s", idstr );
            break;

         case  EOL_:           
            fprintf( stderr, "\n" );
            break;

         case  COMMA_:         
            fprintf( stderr, "," );
            break;

         case  SEMICOLON_:          
            fprintf( stderr, ";" );
            break;

         case  LORES_:            
            fprintf( stderr, "%s", idstr );
            break;

         case  HIRES_:            
            fprintf( stderr, "%s", idstr );
            break;

         case  MOVE_:            
            fprintf( stderr, "%s", idstr );
            break;

         case  DRAW_:            
            fprintf( stderr, "%s", idstr );
            break;

         case  COLOR_:            
            fprintf( stderr, "%s", idstr );
            break;

         case  NUMBER_:            
            fprintf( stderr, "%s", idstr );
            break;

         case  EOF_:          
            fprintf( stderr, "End of File!!\n" );
            break;

         default:             
            fprintf( stderr, "\nToken: %s\n", idstr );
            break;
         }

      tokval = yylex();
      }

   return;
}

#endif      /* EXAMPLE_DEBUG */

%}
%%

[ ]+                 { i = 0;

                       while (*(yytext + i) == ' ')
                          { 
                          idstr[i] = *(yytext + i);
                          i++;
                          }

                       idstr[i] = '\0';
                       return( WHITE_ ); 
                     }

[\t]+                { strncpy( idstr, "   \0", 4 );
                       return( WHITE_ );
                     }

[\n]                 { idstr[0] = '\n';
                       idstr[1] = '\0';
                       return( EOL_ ); 
                     }

[\032]               { idstr[0] = '\0'; return( EOF_ ); }

","                  { idstr[0] = ',';
                       idstr[1] = '\0';
                       return( COMMA_ ); 
                     }
   
";"                  { idstr[0] = ';';
                       idstr[1] = '\0';
                       return( SEMICOLON_ ); 
                     }

"HIRES"              { strncpy( &idstr[0], "HIRES", 5 );
                       return( HIRES_ ); 
                     }

"LORES"              { strncpy( &idstr[0], "LORES", 5 );
                       return( LORES_ ); 
                     }

"DRAW"               { strncpy( &idstr[0], "DRAW", 4 );
                       return( DRAW_ ); 
                     }

"MOVE"               { strncpy( &idstr[0], "MOVE", 4 );
                       return( MOVE_ ); 
                     }

"COLOR"              { strncpy( &idstr[0], "COLOR", 5 );
                       return( COLOR_ ); 
                     }
[0-9]+               { idstr[0] = '\0';
                       sscanf( yytext, "%s", idstr );
                       return( NUMBER_ );      
                     }
%%

/* -------------------- End of Example.flex ------------------------ */
