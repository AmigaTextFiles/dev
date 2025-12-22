/*
 *  This is a flex input file but should be edited in -*-C-*- mode
 *
 *  C++2LaTeX: Produce prettyprinted LaTeX files from  C++ or C sources.
 *  Copyright (C) 1990 Norbert Kiesel
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 1, or (at your option)
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
 *  Norbert Kiesel     
 *  RWTH Aachen / Institut f. Informatik III
 *  Ahornstr. 55
 *  D-5100 Aachen
 *  West Germany  
 *
 *  Phone:  +49 241 80-7266
 *  EUNET:  norbert@rwthi3.uucp
 *  USENET: ...!mcvax!unido!rwthi3!norbert
 *  X.400:  norbert@rwthi3.informatik.rwth-aachen.de
 *
 *  Please contact me for any bugs you find in this code or any
 *  improvements! I'd also be very happy to get feedback where and
 *  how frequently this program is used (just drop a little mail :-).
 *
 *  ---------------------------------------------------------------------
 *
 *  C++2LaTeX 2.0:
 *  Produce even more prettyprinted LaTeX files from C++ or C sources.
 *
 *  Copyright (C) 1991	Joerg Heitkoetter
 *  Systems Analysis Group, University of Dortmund, Germany.
 *  (heitkoet@gorbi.informatik.uni-dortmund.de).
 *
 */

%x STRING BCOMMENT INCLUDE SLASHCOMMENT
%s CPLUSPLUS

%{
#define KEY		printf ("{\\%s %s}", keyword_font, yytext)
#define CPP		printf ("{\\%s \\%s}", cpp_font, yytext)
#define SYM(x)		printf ("$\\%s$", x)
#define OUT(x)		printf ("%s", x)
#define BTAB		printf ("\\hspace*{%d\\indentation}", tabtobrace)
#define CTAB		printf ("\\hspace*{%d\\indentation}", tabtocomment)
#define FONT(x)		printf ("{\\%s ",x);
#define SUB(x)		substitute(x)
#define IND		indent(yytext)
#define INIT		BEGIN (cplusplus_mode ? CPLUSPLUS : INITIAL);
#define REPARSE		yyless (0)

#include <stdio.h>

#ifdef ANSI_C
  #ifdef C_PLUSPLUS
    #error ANSI_C and C_PLUSPLUS are mutually exclusive
  #else
    int cplusplus_mode = 0;
  #endif
#else /* CPLUSPLUS or default */
  int cplusplus_mode = 1;
#endif

int complete_file	= 0;
int header		= 0;
int tabtotab		= 8;
int piped		= 0;

int aligntoright	= 1;		/* align comments to the right  -joke */
int tabtobrace		= 2;		/* distance between closing brace and corresponding comment  -joke */
int tabtocomment	= 4;		/* distance between statement and corresponding comment  -joke */

char *font_size		= "10";		/* used to be 11  -joke */
char *indentation	= "0.5em";
char *comment_font	= "it";
char *keyword_font	= "bf";
char *header_font	= "sl";
char *cpp_font		= "tt";
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

"#"[ \t]*"include"	{ CPP; BEGIN (INCLUDE); }
"#"[ \t]*"define"	|
"#"[ \t]*"undef"	|
"#"[ \t]*"pragma"	|
"#"[ \t]*"if"		|
"#"[ \t]*"ifdef"	|
"#"[ \t]*"ifndef"       |
"#"[ \t]*"elif"		|
"#"[ \t]*"else"		|
"#"[ \t]*"error"	|
"#"[ \t]*"line"         |		/* added G++ special #line directive  -joke */
"#"[ \t]*"ex"           |		/* added G++ special #ex directive  -joke */
"#"[ \t]*"endif"	CPP;


<INCLUDE>"<"[^>]*/">"	{ OUT ("$<$"); FONT (string_font);
			  SUB (yytext+1); OUT ("}$>$");
			  input(); INIT; }
<INCLUDE>\"[^\"]*/\"	{ OUT ("\""); FONT (string_font);
			  SUB (yytext+1); OUT ("}\"");
			  input(); INIT; }
<INCLUDE>[ \t]+		ECHO;
<INCLUDE>[\n]		OUT ("\\mbox{}\\\\\n");
<INCLUDE>.		{ REPARSE; INIT; }

"auto"			|
"double"		|
"int"			|
"struct"		|
"break"			|
"else"			|
"long"			|
"switch"		|
"case"			|
"enum"			|
"register"		|
"typedef"		|
"char"			|
"extern"		|
"return"		|
"union"			|
"const"			|
"float"			|
"short"			|
"unsigned"		|
"continue"		|
"for"			|
"signed"		|
"void"			|
"default"		|
"goto"			|
"sizeof"		|
"volatile"		|
"do"			|
"if"			|
"static"		|
"while"			|
<CPLUSPLUS>"new"	|
<CPLUSPLUS>"delete"	|
<CPLUSPLUS>"this"	|
<CPLUSPLUS>"operator"	|
<CPLUSPLUS>"class"	|
<CPLUSPLUS>"public"	|
<CPLUSPLUS>"protected"	|
<CPLUSPLUS>"private"	|
<CPLUSPLUS>"virtual"	|
<CPLUSPLUS>"friend"	|
<CPLUSPLUS>"inline"	|
<CPLUSPLUS>"dynamic"	|		/* added  -joke */
<CPLUSPLUS>"typeof"	|		/* added  -joke */
<CPLUSPLUS>"all"	|		/* G++ special added  -joke */
<CPLUSPLUS>"except"	|		/* G++ special added  -joke */
<CPLUSPLUS>"exception"	|		/* G++ special added  -joke */
<CPLUSPLUS>"raise"	|		/* G++ special added  -joke */
<CPLUSPLUS>"raises"	|		/* G++ special added  -joke */
<CPLUSPLUS>"reraise"	|		/* G++ special added  -joke */
<CPLUSPLUS>"try"	|		/* G++ special added  -joke */
<CPLUSPLUS>"asm"	|		/* added  -joke */
<CPLUSPLUS>"catch"	|		/* added  -joke */
<CPLUSPLUS>"overload"	KEY;
"->"			SYM ("rightarrow");
"<<"			SYM ("ll");
">>"			SYM ("gg");
"<="			SYM ("leq");
">="			SYM ("geq");
"!="			SYM ("neq");
"||"			SYM ("mid\\mid");
"..."			SYM ("ldots");
"*="			SYM ("ast=");
"<<="			SYM ("ll=");
">>="			SYM ("gg=");
"^="			SYM ("vee=");
"|="			SYM ("mid=");
"~"			SYM ("sim");
"*"			SYM ("ast");
"^"			SYM ("wedge");
"|"			SYM ("mid");
<CPLUSPLUS>"->*"	SYM ("rightarrow\\ast");
"/"			OUT ("$/$");
"<"			OUT ("$<$");
">"			OUT ("$>$");
"&&"			OUT ("\\&\\&");
"%="			OUT ("\\%=");
"&="			OUT ("\\&=");
"{"			OUT ("\\{");
"}"			OUT ("\\}");
"&"			OUT ("\\&");
"%"			OUT ("\\%");
"--"			OUT ("-{}-");
<CPLUSPLUS>".*"		OUT (".$\\ast$");
"?"			|
":"			|
"="			|
","			|
"."			|
";"			|
"!"			|
"-"			|
"+"			|
"/="			|
"=="			|
"++"			|
"+="			|
"-="			|
"("			|
")"			|
"["			|
"]"			|
<CPLUSPLUS>"::"		ECHO;

<CPLUSPLUS>[a-zA-Z_$][a-zA-Z_$0-9]*	|
[a-zA-Z_][a-zA-Z_0-9]*			SUB (yytext);

 /*	1.   Asterisk comments mini scanner */
 /*	1.1. Curly  brace comment */
"}"[ \t]*"/*"	              { BEGIN (BCOMMENT);
                                OUT ("\\}");
                                BTAB;
                                FONT (comment_font);
                                OUT ("/$\\ast$"); }

 /*	1.2. Comments at the beginning of a line */
^[ \t]*"/*"		      { BEGIN (BCOMMENT);
				FONT (comment_font);
                                REPARSE; }

 /*	1.3. Other comments, aligned to right side of paper */
"/*"			      { BEGIN (BCOMMENT);
                                if (aligntoright) {
					OUT ("\\hfill");
				} else {
					CTAB;
				}
				FONT (comment_font);
                                OUT ("/$\\ast$"); }

<BCOMMENT>"*/"		      { INIT; OUT ("$\\ast$/}"); }
<BCOMMENT>"\n"			OUT ("\\mbox{}\\\\\n");
<BCOMMENT>[ \t]+		IND;
<BCOMMENT>.			SUB (yytext);

 /*	2.   Double slash ``//'' comments mini scanner */
 /*	2.1. Curly brace comment */
<CPLUSPLUS>}[ \t]*"//"        { BEGIN (SLASHCOMMENT);
                                OUT ("\\}");
                                BTAB;
				FONT (comment_font);
                                OUT ("//");}

 /*	2.2. Complete line comment */
<CPLUSPLUS>^[ \t]*"//"        { BEGIN (SLASHCOMMENT);
                                FONT (comment_font);
				REPARSE; }

 /*	2.3. Other comments */
<CPLUSPLUS>"//" 	      { BEGIN (SLASHCOMMENT);
                                if (aligntoright) {
					OUT ("\\hfill");
				} else {
					CTAB;
				}
				FONT (comment_font);
                                OUT ("//"); }

<SLASHCOMMENT>"\n"	      { INIT; OUT ("}\\mbox{}\\\\\n"); }
<SLASHCOMMENT>[ \t]+		IND;
<SLASHCOMMENT>.		        SUB (yytext);


L?\" 		              { BEGIN (STRING);
				FONT (string_font); OUT ("\""); }
<STRING>\\\\			OUT ("$\\backslash\\backslash$");
<STRING>\\[bfnrtv'"]	      { OUT ("$\\backslash$"); SUB (yytext+1); }
<STRING>\"		      { INIT; OUT ("\"}"); }
<STRING>"\n"			OUT ("\\mbox{}\\\\\n");
<STRING>^[ \t]+			IND;
<STRING>.			SUB (yytext);

([0-9]*\.[0-9]+[fFlL]?)		 |
([0-9]+\.[0-9]*[fFlL]?)		 |
([0-9]*\.?[0-9]+[eE][+-]?[0-9]+) |
([0-9]+\.?[0-9]*[eE][+-]?[0-9]+) ECHO;

[0-9]+[uUlL]?			ECHO;

L?'[ -~]'			|
L?'\\[ntvbrfa\\?'"]'		|
L?'\\[0-7]{1,3}'		|
L?'\\x[0-9a-fA-F]{1,2}'		SUB (yytext);

0[0-7]+[uUlL]?			ECHO;

0x[0-9a-fA-F]+[uUlL]?		ECHO;

"\\\n"				OUT ("$\\backslash$\\\\\n");
^[ \t]+				IND;
[ \t]+				ECHO;
"\f"[\n]?			OUT ("\\newpage\n");
"\n"				OUT ("\\mbox{}\\\\\n");

%%

#ifndef LATTICE
#include "main.c"
#endif
