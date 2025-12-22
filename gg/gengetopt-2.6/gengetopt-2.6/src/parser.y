/**
 * Copyright (C) 1999, 2000, 2001  Free Software Foundation, Inc.
 *
 * This file is part of GNU gengetopt 
 *
 * GNU gengetopt is free software; you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License as published by 
 * the Free Software Foundation; either version 2, or (at your option) 
 * any later version. 
 *
 * GNU gengetopt is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details. 
 *
 * You should have received a copy of the GNU General Public License along 
 * with gengetopt; see the file COPYING. If not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. 
 */


%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "argsdef.h"

#include "gengetopt.h"

extern int gengetopt_count_line;

static int gengetopt_package_given = 0;
static int gengetopt_version_given = 0;
static int gengetopt_purpose_given = 0;

extern void yyerror ( char *error ) ;
extern int yylex () ;

#define YYERROR_VERBOSE 1
#define check_result \
	if (o) { switch (o) { case 1: yyerror ("not enough memory"); break; case 2: yyerror ("long option redefined"); break; case 3: yyerror ("short option redefined"); break; case 4: yyerror ("bug found!!"); break; } YYERROR; }
%}

%union {
char * str;
char chr;
int argtype;
int bool;
}

%token           TOK_PACKAGE
%token           TOK_VERSION
%token           TOK_OPTION
%token           TOK_YES
%token           TOK_NO
%token           TOK_FLAG
%token           TOK_PURPOSE
%token <bool>    TOK_ONOFF
%token <str>     TOK_STRING
%token           TOK_DEFAULT
%token <str>     TOK_MLSTRING
%token <chr>     TOK_CHAR
%token <argtype> TOK_ARGTYPE
%type  <str>     exp_str
%type  <str>     exp_mlstr
%type  <bool>    exp_yesno
%type  <str>     def_value


%%


input:	
	| input exp
;


exp_str:	 TOK_STRING             { $$ = $1; }
;

exp_mlstr:	 TOK_MLSTRING           { $$ = $1; }
;


exp_yesno:	  TOK_YES  { $$ = 1; }
		| TOK_NO   { $$ = 0; }
;


exp: TOK_PACKAGE TOK_STRING { if (gengetopt_package_given) { yyerror ("package redefined"); YYERROR; } else { gengetopt_package_given = 1; if (gengetopt_define_package ($2)) { yyerror ("not enough memory"); YYERROR; } } }
;


exp: TOK_VERSION TOK_STRING { if (gengetopt_version_given) { yyerror ("version redefined"); YYERROR; } else { gengetopt_version_given = 1; if (gengetopt_define_version ($2)) { yyerror ("not enough memory"); YYERROR; } } }
;

exp: TOK_PURPOSE exp_mlstr { if (gengetopt_purpose_given) { yyerror ("purpose redefined"); YYERROR; } else { gengetopt_purpose_given = 1; if (gengetopt_define_purpose ($2)) { yyerror ("not enough memory"); YYERROR; } } }
;

exp: TOK_PURPOSE exp_str { if (gengetopt_purpose_given) { yyerror ("purpose redefined"); YYERROR; } else { gengetopt_purpose_given = 1; if (gengetopt_define_purpose ($2)) { yyerror ("not enough memory"); YYERROR; } } }
;
exp: TOK_OPTION TOK_STRING TOK_CHAR exp_str TOK_NO { int o = gengetopt_add_option ($2, $3, $4, ARG_NO, 0, 0, 0); check_result; }
;


exp: TOK_OPTION TOK_STRING TOK_CHAR exp_str TOK_FLAG TOK_ONOFF { int o = gengetopt_add_option ($2, $3, $4, ARG_FLAG, $6, 0, 0); check_result; }
;

     
exp: TOK_OPTION TOK_STRING TOK_CHAR exp_str TOK_ARGTYPE exp_yesno { int o = gengetopt_add_option ($2, $3, $4, $5, 0, $6, 0); check_result; }
;

exp: TOK_OPTION TOK_STRING TOK_CHAR exp_str TOK_ARGTYPE def_value exp_yesno 
{ 
  int o = gengetopt_add_option ($2, $3, $4, $5, 0, $7, $6); 
  check_result; 
  if ($6 != 0 && 
      ($5 == ARG_FLOAT || $5 == ARG_DOUBLE || $5 == ARG_LONGDOUBLE))
    {
      fprintf 
        (stderr, 
         "gengetopt: %d: Warning: default values may not work correctly with "
         "type %s\n", gengetopt_count_line, arg_names [$5]);
      fprintf
        (stderr, "This problem will be fixed in future releases.\n");
    }
}
;

def_value: { $$ = 0; }
         | TOK_DEFAULT '=' TOK_STRING { $$ = $3; }
;

%%


