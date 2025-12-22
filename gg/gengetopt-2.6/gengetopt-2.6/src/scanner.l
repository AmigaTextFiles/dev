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
#include <string.h>
#include "argsdef.h"
#include "parser.h"
extern int gengetopt_count_line;

static void update_count_line (char *str);

%}

%%

[Pp][Aa][Cc][Kk][Aa][Gg][Ee]		   return TOK_PACKAGE;
[Vv][Ee][Rr][Ss][Ii][Oo][Nn]		   return TOK_VERSION;
[Oo][Pp][Tt][Ii][Oo][Nn]		   return TOK_OPTION;
[Ss][Tt][Rr][Ii][Nn][Gg]	yylval.argtype = ARG_STRING; return TOK_ARGTYPE;
[Ii][Nn][Tt]			yylval.argtype = ARG_INT; return TOK_ARGTYPE;
[Ss][Hh][Oo][Rr][Tt]		yylval.argtype = ARG_SHORT; return TOK_ARGTYPE;
[Ll][Oo][Nn][Gg]		yylval.argtype = ARG_LONG; return TOK_ARGTYPE;
[Ff][Ll][Oo][Aa][Tt]		yylval.argtype = ARG_FLOAT; return TOK_ARGTYPE;
[Dd][Oo][Uu][Bb][Ll][Ee]	yylval.argtype = ARG_DOUBLE; return TOK_ARGTYPE;
[Ll][Oo][Nn][Gg][Dd][Oo][Uu][Bb][Ll][Ee]   yylval.argtype = ARG_LONGDOUBLE; return TOK_ARGTYPE;
[Ll][Oo][Nn][Gg][Ll][Oo][Nn][Gg]   yylval.argtype = ARG_LONGLONG; return TOK_ARGTYPE;
[Yy][Ee][Ss]				   return TOK_YES;
[Nn][Oo]				   return TOK_NO;
[Ff][Ll][Aa][Gg]			   return TOK_FLAG;
[Oo][Nn]				   yylval.bool = 1; return TOK_ONOFF;
[Oo][Ff][Ff]				   yylval.bool = 0; return TOK_ONOFF;
[Pp][Uu][Rr][Pp][Oo][Ss][Ee]		   return TOK_PURPOSE;
[Dd][Ee][Ff][Aa][Uu][Ll][Tt]               return TOK_DEFAULT;

"=" { return '='; }

[[:alnum:]-]			yylval.chr = yytext[0]; return TOK_CHAR;
\"[^\"\n]*\"	{
  /* if you add or remove symbols, change canonize_vars
     function */
  yytext [strlen(yytext) - 1] = 0;
  yylval.str = yytext + 1;
  return TOK_STRING;
}

\"[^\"]*\"	{
  /* if you add or remove symbols, change canonize_vars
     function */
  yytext [strlen(yytext) - 1] = 0;
  yylval.str = yytext + 1;
  update_count_line (yylval.str);
  return TOK_MLSTRING;
}

[ \t]+				/* eat spaces */
#[^\n]*				/* comments begin with # in any place */
\n				gengetopt_count_line++; /* return '\n'; */

.		{ 
  return 1000; /* little hack to produce a parse error too. */ 
}

%%

/*
  Otherwise '\n' within a TOK_MLSTRING would not be counted
*/
void
update_count_line (char *str)
{
  char *p;

  for (p = str; *p; ++p)
    if (*p == '\n')
      ++gengetopt_count_line;
}
