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

#include <string.h>

#include "tags.h"
#include "tokens.h"

#include "optparser.h"

extern int line ;

%}

ws [ ]+
tabs [\t]+

nl \n
cr \r
IDE [a-zA-Z_]([a-zA-Z0-9_])*

STRING \"[^\"\n]*\"

%%

[ ] {}

\r {}

"keyword" |
"type" |
"string" |
"comment" |
"number" { yylval.string = strdup(yytext) ; return KEY ; }

"green" |
"red" |
"darkred" |
"blue" |
"brown" |
"pink" |
"yellow" |
"cyan" |
"purple" |
"orange" |
"brightorange" |
"darkgreen" |
"black" { yylval.string = strdup(yytext) ; return COLOR ; }

"b" { yylval.flag = BOLD ; return BOLD ; }
"i" { yylval.flag = ITALICS ; return ITALICS ; }
"u" { yylval.flag = UNDERLINE ; return UNDERLINE ; }

"," { return ',' ; }
";" { return ';' ; }

\n { ++line ; }

.  { return yytext[0] ; }

%%
