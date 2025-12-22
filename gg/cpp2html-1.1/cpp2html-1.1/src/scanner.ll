%{
/*
 * Copyright (C) 1999, 2000 Lorenzo Bettini, lorenzo.bettini@penteres.it
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */                         

int lineno = 1 ; /* numero di linee scandite */
char linebuf[1024] ; /* linea di codice attuale */
int tokenpos = 0 ; /* posizione del token corrente nella linea corrente */

#include "tags.h"
#include "tokens.h"
#include "colors.h"

#include "main.h"

%}

ws [ ]+
tabs [\t]+

nl \n
cr \r
IDE [a-zA-Z_]([a-zA-Z0-9_])*

STRING \"[^\"\n]*\"

not_alpha [^a-zA-Z0-9]

%s COMMENT_STATE
%s SINGLELINE_COMMENT
%s STRING_STATE
%s CHAR_STATE
%s INCLUDE_STATE

%%



\r {}

<INITIAL>"/*" { BEGIN COMMENT_STATE ;
       startComment( yytext ) ;      
     }
<INITIAL>"/*".*"*/" { generateComment( yytext ) ;  }



<COMMENT_STATE>"*/" { endComment(yytext) ;
                      BEGIN INITIAL ; /* end of the comment */ }

<INITIAL>"//" { BEGIN SINGLELINE_COMMENT ; startComment( yytext ) ; }
<SINGLELINE_COMMENT>"//" { generate( yytext ) ; }
<SINGLELINE_COMMENT>\n { 
   BEGIN INITIAL ; 
   endComment( yytext ) ; 
   /* if we encounter another // during a comment we simply
      treat it as a ordinary string */
 }

"<" { generate( LESS_THAN ) ; }

">" { generate( GREATER_THAN ) ; }

"&" { generate( AMPERSAND ) ; }

<INITIAL>\" { BEGIN STRING_STATE ; startString( yytext );  }
<STRING_STATE>\\\\ {  generate( yytext ) ; }
<STRING_STATE>"\\\"" {  generate( yytext ) ; }
<STRING_STATE>\" { BEGIN INITIAL ; endString( yytext ) ; }

<INITIAL>\' { BEGIN CHAR_STATE ; startString( yytext );  }
<CHAR_STATE>\\\\ {  generate( yytext ) ; }
<CHAR_STATE>"\\\'" {  generate( yytext ) ; }
<CHAR_STATE>\' { BEGIN INITIAL ; endString( yytext ) ; }

<INITIAL>\#include { BEGIN INCLUDE_STATE ; generateKeyWord( yytext ) ; }

<INITIAL>\#[^\"\n ]* |
<INITIAL>auto |
<INITIAL>break |
<INITIAL>case |
<INITIAL>catch |
<INITIAL>class |
<INITIAL>const |
<INITIAL>const_cast |
<INITIAL>continue |
<INITIAL>default |
<INITIAL>delete |
<INITIAL>do |
<INITIAL>dynamic_cast |
<INITIAL>else |
<INITIAL>enum |
<INITIAL>explicit |
<INITIAL>extern |
<INITIAL>false |
<INITIAL>for |
<INITIAL>friend |
<INITIAL>goto |
<INITIAL>if |
<INITIAL>inline |
<INITIAL>mutable |
<INITIAL>naked |
<INITIAL>namespace |
<INITIAL>new |
<INITIAL>operator |
<INITIAL>private |
<INITIAL>protected |
<INITIAL>public |
<INITIAL>reinterpret_cast |
<INITIAL>return |
<INITIAL>sizeof |
<INITIAL>static |
<INITIAL>static_cast |
<INITIAL>struct |
<INITIAL>switch |
<INITIAL>template |
<INITIAL>throw |
<INITIAL>this |
<INITIAL>true |
<INITIAL>try |
<INITIAL>typedef |
<INITIAL>typeid |
<INITIAL>typename |
<INITIAL>union |
<INITIAL>using |
<INITIAL>virtual |
<INITIAL>volatile |
<INITIAL>while  { generateKeyWord( yytext ) ; }


<INITIAL>bool |
<INITIAL>char |
<INITIAL>double |
<INITIAL>float |
<INITIAL>int |
<INITIAL>long |
<INITIAL>register |
<INITIAL>short |
<INITIAL>signed |
<INITIAL>unsigned |
<INITIAL>void { generateBaseType( yytext ) ; }

<INITIAL>0[xX][0-9a-fA-F]* { generateNumber( yytext ) ; }
<INITIAL>[0-9][0-9]*(.[0-9]*[eE]?[-+]?[0-9]*)? { generateNumber( yytext ) ; }

<INCLUDE_STATE>\<[^\"\n ]*\> { startString("") ; generate( LESS_THAN ) ; generate( yytext, 1, yyleng-2 ) ; generate( GREATER_THAN ) ; endString("") ; }
<INCLUDE_STATE>\"[^\"\n]*\" { generateString( yytext ) ; }
<INCLUDE_STATE>\n { 
       ++lineno;
       generateNewLine() ;
       BEGIN INITIAL ;
}

[a-zA-Z_]([a-zA-Z0-9_])* { generate( yytext ) ; }

\t {
        generateTab() ;
}

. { generate( yytext ) ; /* anything else */ }

\n { 
       ++lineno;
       generateNewLine() ;
}

%%

void yyerror( char *s ) ;

void yyerror( char *s )
{  
  fprintf( stderr, "%d: %s: %s\n%s\n", lineno, s, yytext, linebuf ) ;
  fprintf( stderr, "%*s\n", tokenpos, "^" ) ;
}
