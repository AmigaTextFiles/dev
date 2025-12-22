/*
 *  p2LaTeX: Produce prettyprinted LaTeX files from Pascal sources.
 *  Copyright (C) 1993 Torsten Poulin
 *    Note: This program is derived from work done by others (see below).
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Torsten Poulin 
 *  Banebrinken 99, 2, 77
 *  DK-2400 Copenhagen NV
 *  DENMARK
 *
 *  e-mail: torsten@diku.dk
 *  --------------------------------------------------------------------
 *  p2latex is derived from the code for the program C++2LaTeX 2.0 which
 *  produces prettyprinted LaTeX files from C++ or C sources.
 *
 *  C++2LaTeX 2.0 is copyright (C) 1991 Joerg Heitkoetter
 *
 *     Systems Analysis Research Group
 *     University of Dortmund
 *     (heitkoet@gorbi.informatik.uni-dortmund.de).
 *
 *  The original C++2LaTeX is copyright (C) 1990 Norbert Kiesel
 *
 *      Norbert Kiesel
 *      RWTH Aachen / Institut f. Informatik III
 *      Ahornstr. 55
 *      D-5100 Aachen
 *      West Germany
 *
 *      Phone:  +49 241 80-7266
 *      EUNET:  norbert@rwthi3.uucp
 *      USENET: ...!mcvax!unido!rwthi3!norbert
 *      X.400:  norbert@rwthi3.informatik.rwth-aachen.de
 *  --------------------------------------------------------------------
 * p2latex p2main.l revision history.
 * $Log:	p2latex.l,v $
 * Revision 1.3  93/12/09  01:20:12  Torsten
 * Now sets the insidestring flag when inside a string.
 * Corrected the indentation of comments preceded only by white-space.
 * The copyleft comment now refers to version 2 of the GPL.
 * 
 * Revision 1.2  93/11/06  14:43:51  Torsten
 * Added a few lines to the comment at the top of the program
 * giving credit to the authors of C++2LaTeX.
 * Minus now emits -- (a TeX number-range dash) when not in
 * a comment or a string.
 * Strings are now printed using \frenchspacing to suppress
 * extra space after punctuation. 
 * 
 * Revision 1.1  93/10/15  23:41:49  Torsten
 * Initial revision
 *
 */

%x STRING BCOMMENT

%{
#define KEY		printf ("{\\%s %s}", keyword_font, yytext)
#define FANCYKEY(x)	fancysymbols ? printf(x) : KEY
#define SYM(x)		printf ("$\\%s$", x)
#define FANCY(x,y)	printf ("%s", fancysymbols ? x : y)
#define OUT(x)		printf ("%s", x)
#define ETAB		printf ("\\hspace*{%d\\indentation}", tabtoend)
#define CTAB		printf ("\\hspace*{%d\\indentation}", tabtocomment)
#define FONT(x)		printf ("{\\%s ",x)
#define SUB(x)		substitute(x)
#define IDENTIFIER	printf ("{\\%s %s\\/}", ident_font, yytext)
#define IND		indent(yytext)
#define INIT		BEGIN (INITIAL);

#include <stdio.h>

static char RCSid[] = "$Id: p2latex.l,v 1.3 93/12/09 01:20:12 Torsten Rel $";

static void nindent(char *, int);
int insidestring	= 0;

int complete_file	= 0;
int header		= 0;
int tabtotab		= 8;
int piped		= 0;
int fancysymbols	= 0;

int aligntoright	= 1;		/* align comments to the right */
int tabtoend		= 2;		/* distance between end and comment */
int tabtocomment	= 4;		/* distance between statement and comment*/

char *font_size		= "10";
char *indentation	= "0.5em";
char *comment_font	= "it";
char *ident_font	= "it";
char *keyword_font	= "bf";
char *header_font	= "sl";
char *string_font	= "tt";

#ifdef __STDC__
void substitute(const char *);
void indent(const char *);
void newpage(int);
void usage(const char *);
#else
void substitute();
void indent();
void newpage();
void usage();
#endif
%}

%%

			INIT;

"array"			|
"begin"			|
"case"			|
"const"			|
"div"			|
"do"			|
"downto"		|
"else"			|
"end"			|
"file"			|
"for"			|
"function"		|
"goto"			|
"if"			|
"in"			|
"label"			|
"mod"			|
"nil"			|
"of"			|
"packed"		|
"procedure"		|
"program"		|
"record"		|
"repeat"		|
"set"			|
"then"			|
"to"			|
"type"			|
"until"			|
"var"			|
"while"			|
"with"			KEY;
"and"			FANCYKEY("$\\wedge$");
"not"			FANCYKEY("$\\neg$");
"or"			FANCYKEY("$\\vee");
"<="			FANCY ("$\\leq$", "$<$=");
">="			FANCY ("$\\geq$", "$>$=");
"<>"			FANCY ("$\\neq$", "$<>$");
"*"			SYM ("ast");
"^"			SYM ("uparrow");
"/"			OUT ("$/$");
"<"			OUT ("$<$");
">"			OUT ("$>$");
"-"			OUT ("--");
"("			|
")"			|
":"			|
"="			|
","			|
"."			|
";"			|
"+"			|
"["			|
"]"			ECHO;

[a-z_][a-z_0-9]*		IDENTIFIER;

 /* Comments mini scanner */
 /* 1. Comment after 'end;', 'end.', or 'end'  */
"end"[;\.]?[ \t]*"(*"		{ BEGIN (BCOMMENT);
				{ int i;
				  printf("{\\%s ", keyword_font);
				  for (i = 0; i < 3; i++)
				    printf("%c", yytext[i]);
				  printf("}");
				  if (yytext[i] == ';' || yytext[i] == '.')
				    printf("%c", yytext[i]); }
                                ETAB;
                                OUT ("($\\ast$");
                                FONT (comment_font); }
"end"[;\.]?[ \t]*"{"		{ BEGIN (BCOMMENT);
				{ int i;
				  printf("{\\%s ", keyword_font);
				  for (i = 0; i < 3; i++)
				    printf("%c", yytext[i]);
				  printf("}");
				  if (yytext[i] == ';' || yytext[i] == '.')
				    printf("%c", yytext[i]); }
                                ETAB;
                                OUT ("\\{");
                                FONT (comment_font); }

 /* 2. Comments at the beginning of a line */
^[ \t]*"(*"		      { BEGIN (BCOMMENT);
				nindent(yytext, yyleng - 2);
                                OUT ("($\\ast$");
				FONT (comment_font); }
^[ \t]*"{"		      { BEGIN (BCOMMENT);
				nindent(yytext, yyleng - 1);
				OUT ("\\{");
				FONT (comment_font); }

 /* 3. Other comments, aligned to right side of paper */
"(*"			      { BEGIN (BCOMMENT);
                                if (aligntoright) {
					OUT ("\\hfill");
				} else {
					CTAB;
				}
                                OUT ("($\\ast$");
				FONT (comment_font); }
"{"			      { BEGIN (BCOMMENT);
                                if (aligntoright) {
					OUT ("\\hfill");
				} else {
					CTAB;
				}
                                OUT ("\\{");
				FONT (comment_font); }


<BCOMMENT>"*)"		      { INIT; OUT ("}$\\ast$)"); }
<BCOMMENT>"}"		      { INIT; OUT ("}\\}"); }
<BCOMMENT>"\n"			OUT ("\\mbox{}\\\\\n");
<BCOMMENT>[ \t]+		IND;
<BCOMMENT>.			SUB (yytext);

L?\' 		              { BEGIN (STRING);
				FONT (string_font);
				OUT ("\\frenchspacing{");
				OUT ("\'");
				insidestring = 1; }
<STRING>\'		      { INIT;
				OUT ("\'}}");
				insidestring = 0; }
<STRING>"\n"			OUT ("\\mbox{}\\\\\n");
<STRING>^[ \t]+			IND;
<STRING>.			SUB (yytext);

([0-9]*\.[0-9]+)		|
([0-9]+\.[0-9]*)		|
([0-9]*\.?[0-9]+e[+-]?[0-9]+)	|
([0-9]+\.?[0-9]*e[+-]?[0-9]+)	ECHO;

[0-9]+				ECHO;

^[ \t]+				IND;
[ \t]+				ECHO;
"\f"[\n]?			OUT ("\\newpage\n");
"\n"				OUT ("\\mbox{}\\\\\n");

%%

static void nindent(char *blanks, int n)
{
  int i, bl;

  for (i = bl = 0; i < n; i++) {
    if (*blanks == ' ') {
      bl++;
    }
    else {			/* *blanks == '\t' */
      while (++bl % tabtotab) ;
    }
    blanks++;
  }
  printf("\\hspace*{%d\\indentation}", bl);
}
