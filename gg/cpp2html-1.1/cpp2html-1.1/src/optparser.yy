%{
/*
 * Copyright (C) 1999, 2000, Lorenzo Bettini, lorenzo.bettini@penteres.it
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

#include <stdio.h>
#include <string.h>
#include <iostream.h>

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif // HAVE_CONFIG_H

#ifdef HAVE_STRSTREAM_H
#include <strstream.h>
#else
#ifdef HAVE_STRSTREA_H
#include <strstrea.h>
#endif // HAVE_STRSTREA_H
#endif // HAVE_STRSTREAM_H

#include "tags.h"
#include "colors.h"
#include "keys.h"
#include "messages.h"

static int yyparse() ;
static void yyerror( char *s ) ;

int line = 0 ;

void parseTags() ;

static FILE *openTagsFile() ;

extern int opsc_lex() ;
extern FILE *yyin ;

%}

%union {
  int tok ; /* command */
  char * string ; /* string : id, ... */
  int flag ;
  Tag *tag ;
  Tags *tags ; 
} ;

%token <flag> BOLD ITALICS UNDERLINE
%token <string> KEY COLOR 

%type <tag> option
%type <tags> options
%type <flag> values value

%%

globaltags : options { setTags( $1 ) ; }

options : options option { $1->AddTag( $2 ) ; }
        | option { $$ = new Tags() ; $$->AddTag( $1 ) ;  }
        ;

option : KEY COLOR 
             { 
                 printMessage( $1 ) ;
                 printMessage( $2 ) ;
             } 
         values ';' 
             { 
	       $$ = new Tag( strdup($1), strdup($2) ) ;
               $$->SetFlags($4) ; 
	     } 
       ;

values : values ',' value { $$ = $1 | $3 ; }
       | value
       ;

value : { $$ = 0 ; printMessage( " (no options) " ) ; }
      | BOLD { printMessage( " - bold" ) ; $$ = ISBOLD ; }
      | ITALICS { printMessage( " - italics" ) ; $$ = ISITALIC ; }
      | UNDERLINE { printMessage( " - underline" ) ; $$ = ISUNDERLINE ; }
      ;

%%

// this should be passed by the compiler
#ifndef CPP2HTML_DATA_DIR
#define CPP2HTML_DATA_DIR "."
#endif

#define TAGS_FILE "tags.j2h"

void parseTags() {

  // opens the file for yylex
  yyin = openTagsFile() ;
  if (! yyin) {
    printWarning( "No tags.j2h file, using defaults ...", cerr ) ;
    setTags( NULL ) ;
    return ;
  }

  printMessage( "Parsing tags.j2h file ...", cerr ) ;
  yyparse() ;
  printMessage( "Parsing done!", cerr ) ;
}

FILE *openTagsFile()
{
  printMessage( "Trying with..." ) ;
  
  printMessage( TAGS_FILE ) ;
  FILE *file = fopen( TAGS_FILE, "r") ;
  if ( file )
    return file ;

  file = fopen( CPP2HTML_DATA_DIR "/" TAGS_FILE, "r") ;
  printMessage( CPP2HTML_DATA_DIR "/" TAGS_FILE ) ;
  
  return file ;
}

void yyerror( char *s ) {
  strstream str ;
  str << "*** " << s << " on option # " << line << ends ;
  printError( str.str(), cerr ) ;
  printError( "Using default tags...", cerr ) ;
}
