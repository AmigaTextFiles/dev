
/*  A Bison parser, made from mst.y  */

#define	BANG	258
#define	COLON	259
#define	UPARROW	260
#define	DOT	261
#define	ASSIGN	262
#define	SHARP	263
#define	SEMICOLON	264
#define	OPEN_PAREN	265
#define	CLOSE_PAREN	266
#define	OPEN_BRACKET	267
#define	CLOSE_BRACKET	268
#define	PRIMITIVE_START	269
#define	INTERNAL_TOKEN	270
#define	IDENTIFIER	271
#define	KEYWORD	272
#define	STRING_LITERAL	273
#define	SYMBOL_KEYWORD	274
#define	BINOP	275
#define	VERTICAL_BAR	276
#define	INTEGER_LITERAL	277
#define	FLOATING_LITERAL	278
#define	CHAR_LITERAL	279

#line 26 "mst.y"

#include "mst.h"
#include "mstsym.h"
#include "msttree.h"
#include "mstdict.h"
#include "mstcomp.h"
#include <stdio.h>
#ifdef HAS_ALLOCA_H
#include <alloca.h>
#endif

#define YYDEBUG 1

extern Boolean		quietExecution;


#line 45 "mst.y"
typedef union{
  char		cval;
  double	fval;
  long		ival;
  char		*sval;
  TreeNode	node;
} YYSTYPE;

#ifndef YYLTYPE
typedef
  struct yyltype
    {
      int timestamp;
      int first_line;
      int first_column;
      int last_line;
      int last_column;
      char *text;
   }
  yyltype;

#define YYLTYPE yyltype
#endif

#include <stdio.h>

#ifndef __STDC__
#define const
#endif



#define	YYFINAL		148
#define	YYFLAG		-32768
#define	YYNTBASE	25

#define YYTRANSLATE(x) ((unsigned)(x) <= 279 ? yytranslate[x] : 72)

static const char yytranslate[] = {     0,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     1,     2,     3,     4,     5,
     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
    16,    17,    18,    19,    20,    21,    22,    23,    24
};

static const short yyprhs[] = {     0,
     0,     2,     5,     6,     8,    10,    13,    17,    20,    23,
    27,    30,    34,    36,    39,    43,    46,    50,    54,    59,
    61,    64,    66,    68,    70,    72,    74,    76,    79,    83,
    85,    89,    92,    96,    98,   101,   102,   104,   108,   110,
   114,   118,   119,   121,   123,   126,   129,   133,   135,   137,
   139,   141,   143,   145,   149,   151,   153,   155,   157,   159,
   161,   163,   166,   168,   170,   172,   174,   176,   178,   181,
   184,   188,   190,   193,   195,   197,   199,   201,   203,   208,
   209,   212,   215,   219,   221,   223,   225,   228,   230,   232,
   236,   238,   240,   243,   246,   250,   253,   256,   260,   262,
   265
};

static const short yyrhs[] = {    27,
     0,    26,    32,     0,     0,    15,     0,    28,     0,    27,
    28,     0,    29,    31,     3,     0,    29,     3,     0,    43,
     3,     0,    40,    43,     3,     0,     1,     3,     0,     3,
    30,     3,     0,    47,     0,    32,     3,     0,    31,    32,
     3,     0,    33,    42,     0,    33,    40,    42,     0,    33,
    39,    42,     0,    33,    40,    39,    42,     0,    34,     0,
    35,    36,     0,    37,     0,     1,     0,    16,     0,    20,
     0,    21,     0,    16,     0,    38,    36,     0,    37,    38,
    36,     0,    17,     0,    14,    22,    20,     0,    21,    21,
     0,    21,    41,    21,     0,    36,     0,    41,    36,     0,
     0,    43,     0,     5,    45,    44,     0,    45,     0,    45,
     6,    42,     0,     1,     6,    42,     0,     0,     6,     0,
    47,     0,    46,    47,     0,    36,     7,     0,    46,    36,
     7,     0,    48,     0,    62,     0,    69,     0,    36,     0,
    49,     0,    59,     0,    10,    45,    11,     0,    50,     0,
    51,     0,    53,     0,    54,     0,    55,     0,    22,     0,
    23,     0,     8,    52,     0,    16,     0,    35,     0,    19,
     0,    17,     0,    24,     0,    18,     0,     8,    56,     0,
    10,    11,     0,    10,    57,    11,     0,    58,     0,    57,
    58,     0,    50,     0,    52,     0,    54,     0,    53,     0,
    56,     0,    12,    60,    42,    13,     0,     0,    61,    21,
     0,     4,    36,     0,    61,     4,    36,     0,    63,     0,
    65,     0,    67,     0,    64,    34,     0,    48,     0,    63,
     0,    66,    35,    64,     0,    64,     0,    65,     0,    66,
    68,     0,    38,    66,     0,    68,    38,    66,     0,    62,
    70,     0,     9,    71,     0,    70,     9,    71,     0,    34,
     0,    35,    64,     0,    68,     0
};

#if YYDEBUG != 0
static const short yyrline[] = { 0,
    80,    82,    83,    86,    89,    91,    94,    96,    97,   103,
   110,   114,   118,   159,   171,   184,   187,   189,   191,   196,
   198,   200,   201,   207,   211,   213,   216,   220,   222,   227,
   231,   239,   241,   245,   247,   251,   253,   256,   260,   261,
   264,   271,   273,   276,   278,   281,   283,   288,   290,   291,
   294,   296,   297,   298,   301,   303,   304,   305,   306,   309,
   311,   314,   318,   320,   321,   322,   326,   330,   334,   338,
   340,   344,   346,   351,   353,   354,   355,   356,   359,   364,
   366,   372,   374,   379,   381,   382,   385,   389,   391,   394,
   399,   401,   404,   409,   412,   417,   422,   424,   429,   431,
   433
};

static const char * const yytname[] = {   "$",
"error","$illegal.","BANG","COLON","UPARROW","DOT","ASSIGN","SHARP","SEMICOLON","OPEN_PAREN",
"CLOSE_PAREN","OPEN_BRACKET","CLOSE_BRACKET","PRIMITIVE_START","INTERNAL_TOKEN","IDENTIFIER","KEYWORD","STRING_LITERAL","SYMBOL_KEYWORD","BINOP",
"VERTICAL_BAR","INTEGER_LITERAL","FLOATING_LITERAL","CHAR_LITERAL","program","internal_marker","class_definition_list","class_definition","class_header","class_specification",
"method_list","method","message_pattern","unary_selector","binary_selector","variable_name","keyword_variable_list","keyword","primitive","temporaries",
"variable_names","statements","non_empty_statements","optional_dot","expression","assigns","simple_expression","primary","literal","number",
"symbol_constant","symbol","character_constant","string","array_constant","array","array_constant_list","array_constant_elt","block","opt_block_variables",
"block_variable_list","message_expression","unary_expression","unary_object_description","binary_expression","binary_object_description","keyword_expression","keyword_binary_object_description_list","cascaded_message_expression","semi_message_list",
"message_elt",""
};
#endif

static const short yyr1[] = {     0,
    25,    25,    25,    26,    27,    27,    28,    28,    28,    28,
    28,    29,    30,    31,    31,    32,    32,    32,    32,    33,
    33,    33,    33,    34,    35,    35,    36,    37,    37,    38,
    39,    40,    40,    41,    41,    42,    42,    43,    43,    43,
    43,    44,    44,    45,    45,    46,    46,    47,    47,    47,
    48,    48,    48,    48,    49,    49,    49,    49,    49,    50,
    50,    51,    52,    52,    52,    52,    53,    54,    55,    56,
    56,    57,    57,    58,    58,    58,    58,    58,    59,    60,
    60,    61,    61,    62,    62,    62,    63,    64,    64,    65,
    66,    66,    67,    68,    68,    69,    70,    70,    71,    71,
    71
};

static const short yyr2[] = {     0,
     1,     2,     0,     1,     1,     2,     3,     2,     2,     3,
     2,     3,     1,     2,     3,     2,     3,     3,     4,     1,
     2,     1,     1,     1,     1,     1,     1,     2,     3,     1,
     3,     2,     3,     1,     2,     0,     1,     3,     1,     3,
     3,     0,     1,     1,     2,     2,     3,     1,     1,     1,
     1,     1,     1,     3,     1,     1,     1,     1,     1,     1,
     1,     2,     1,     1,     1,     1,     1,     1,     2,     2,
     3,     1,     2,     1,     1,     1,     1,     1,     4,     0,
     2,     2,     3,     1,     1,     1,     2,     1,     1,     3,
     1,     1,     2,     2,     3,     2,     2,     3,     1,     2,
     1
};

static const short yydefact[] = {     0,
     0,     0,     0,     0,     0,    80,     4,    27,    68,     0,
    60,    61,    67,     0,     0,     5,     0,    51,     0,     0,
    39,     0,    44,    48,    52,    55,    56,    57,    58,    59,
    53,    49,    84,    91,    85,     0,    86,    50,    11,     0,
     0,    51,    13,    42,     0,    63,    66,    65,    25,    26,
    64,    62,    69,     0,     0,     0,     0,    32,    34,     0,
    23,    24,    30,     2,     0,    20,     0,    22,     0,     6,
     8,     0,     0,    46,     0,     0,     9,     0,    51,    45,
     0,    96,    87,     0,     0,    93,    41,    37,    12,    43,
    38,    70,    74,    75,    77,    76,    78,     0,    72,    54,
    82,     0,     0,    81,    33,    35,     0,     0,     0,    16,
    21,     0,    28,     7,     0,    14,    10,    40,    47,    99,
     0,   101,    97,     0,    88,    89,    90,    92,    94,     0,
    71,    73,    79,    83,     0,    18,     0,    17,    29,    15,
   100,    98,    95,    31,    19,     0,     0,     0
};

static const short yydefgoto[] = {   146,
    14,    15,    16,    17,    41,    72,    64,    65,    66,    51,
    18,    68,    69,   108,    19,    60,    87,    88,    91,    21,
    22,    23,    24,    25,    26,    27,    94,    28,    29,    30,
    97,    98,    99,    31,    56,    57,    32,    33,    34,    35,
    36,    37,   122,    38,    82,   123
};

static const short yypact[] = {   125,
    70,   293,   293,   338,   293,    12,-32768,-32768,-32768,    30,
-32768,-32768,-32768,    96,   175,-32768,    20,    11,   290,    42,
    66,   293,-32768,    22,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,    74,    58,    76,    64,   101,-32768,-32768,-32768,   200,
    90,-32768,-32768,    92,   308,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,    93,    85,   270,     7,-32768,-32768,    33,
-32768,-32768,-32768,-32768,   150,-32768,    85,    94,    85,-32768,
-32768,    79,   106,-32768,   113,   117,-32768,   200,   120,-32768,
    86,   115,-32768,   293,   293,    94,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,   323,-32768,-32768,
-32768,   118,    85,-32768,-32768,-32768,   112,   250,   225,-32768,
-32768,    85,-32768,-32768,   133,-32768,-32768,-32768,-32768,-32768,
   293,    94,-32768,    86,-32768,-32768,    76,-32768,     6,   293,
-32768,-32768,-32768,-32768,   119,-32768,   250,-32768,-32768,-32768,
    76,-32768,     6,-32768,-32768,   138,   142,-32768
};

static const short yypgoto[] = {-32768,
-32768,-32768,   129,-32768,-32768,-32768,    -8,-32768,   -33,   -14,
     2,-32768,   -34,    36,    87,-32768,   -48,    14,-32768,    50,
-32768,    13,   -65,-32768,   -39,-32768,   152,   -35,   -32,-32768,
   153,-32768,    56,-32768,-32768,-32768,-32768,   -53,   -77,   -80,
   -60,-32768,   123,-32768,-32768,    37
};


#define	YYLAST		359


static const short yytable[] = {    67,
    83,    85,    67,    42,   128,    93,   127,   102,    73,    95,
   103,    59,    96,    20,    43,    55,   110,    74,   125,   125,
    61,    84,    71,    79,   129,    49,    50,   104,    20,   118,
   126,   126,    76,   112,    80,    62,    63,   -88,   -88,    49,
    50,   -88,   -88,   141,    77,     8,    85,   120,     8,   128,
    58,   130,    44,   105,    54,   125,   101,    67,    93,   136,
   138,   106,    95,   115,   125,    96,   121,   126,   111,   143,
   113,    78,    39,   -89,   -89,    40,   126,   -89,   -89,    61,
   -92,   114,    81,   -92,   -92,    42,    42,   130,   145,    85,
   120,    62,    89,    83,    62,    63,    61,    90,    49,    50,
     8,    62,    63,   100,   134,    49,    50,    83,   116,   121,
    63,    62,    63,   139,    84,    49,    50,    63,    40,   117,
    49,    50,    42,   124,    -3,     1,   119,     2,    84,     3,
   133,    42,     4,   135,     5,   140,     6,   147,   144,     7,
     8,   148,     9,    70,   137,    10,    11,    12,    13,   -36,
    75,   109,   -36,   132,     3,    52,    53,     4,    86,     5,
   142,     6,     0,   107,     0,     8,     0,     9,     0,     0,
    10,    11,    12,    13,    -1,     1,     0,     2,     0,     3,
     0,     0,     4,     0,     5,     0,     6,     0,     0,     0,
     8,     0,     9,     0,     0,    10,    11,    12,    13,   -36,
    75,     0,   -36,     0,     3,     0,     0,     4,     0,     5,
     0,     6,   -36,     0,     0,     8,     0,     9,     0,     0,
     0,    11,    12,    13,   -36,    75,     0,   -36,     0,     3,
     0,     0,     4,     0,     5,     0,     6,     0,   107,     0,
     8,     0,     9,     0,     0,     0,    11,    12,    13,   -36,
    75,     0,   -36,     0,     3,     0,     0,     4,     0,     5,
     0,     6,     0,     0,     0,     8,     0,     9,     0,     0,
    75,    11,    12,    13,     3,     0,     0,     4,     0,     5,
     0,     6,   -36,     0,     0,     8,     0,     9,     0,     0,
    75,    11,    12,    13,     3,     0,     0,     4,     0,     5,
     4,     6,     5,     0,     6,     8,     0,     9,     8,     0,
     9,    11,    12,    13,    11,    12,    13,    45,    92,     0,
     0,     0,     0,    46,    47,     9,    48,    49,    50,    11,
    12,    13,    45,   131,     0,     0,     0,     0,    46,    47,
     9,    48,    49,    50,    11,    12,    13,    45,     0,     0,
     0,     0,     0,    46,    47,     0,    48,    49,    50
};

static const short yycheck[] = {    14,
    34,    36,    17,     2,    85,    45,    84,    56,    17,    45,
     4,    10,    45,     0,     2,     4,    65,     7,    84,    85,
     1,    36,     3,    22,    85,    20,    21,    21,    15,    78,
    84,    85,    19,    68,    22,    16,    17,    16,    17,    20,
    21,    20,    21,   121,     3,    16,    81,    81,    16,   130,
    21,    86,     3,    21,     5,   121,    55,    72,    98,   108,
   109,    60,    98,    72,   130,    98,    81,   121,    67,   130,
    69,     6,     3,    16,    17,     6,   130,    20,    21,     1,
    17,     3,     9,    20,    21,    84,    85,   122,   137,   124,
   124,    16,     3,   127,    16,    17,     1,     6,    20,    21,
    16,    16,    17,    11,   103,    20,    21,   141,     3,   124,
    17,    16,    17,   112,   129,    20,    21,    17,     6,     3,
    20,    21,   121,     9,     0,     1,     7,     3,   143,     5,
    13,   130,     8,    22,    10,     3,    12,     0,    20,    15,
    16,     0,    18,    15,   109,    21,    22,    23,    24,     0,
     1,    65,     3,    98,     5,     4,     4,     8,    36,    10,
   124,    12,    -1,    14,    -1,    16,    -1,    18,    -1,    -1,
    21,    22,    23,    24,     0,     1,    -1,     3,    -1,     5,
    -1,    -1,     8,    -1,    10,    -1,    12,    -1,    -1,    -1,
    16,    -1,    18,    -1,    -1,    21,    22,    23,    24,     0,
     1,    -1,     3,    -1,     5,    -1,    -1,     8,    -1,    10,
    -1,    12,    13,    -1,    -1,    16,    -1,    18,    -1,    -1,
    -1,    22,    23,    24,     0,     1,    -1,     3,    -1,     5,
    -1,    -1,     8,    -1,    10,    -1,    12,    -1,    14,    -1,
    16,    -1,    18,    -1,    -1,    -1,    22,    23,    24,     0,
     1,    -1,     3,    -1,     5,    -1,    -1,     8,    -1,    10,
    -1,    12,    -1,    -1,    -1,    16,    -1,    18,    -1,    -1,
     1,    22,    23,    24,     5,    -1,    -1,     8,    -1,    10,
    -1,    12,    13,    -1,    -1,    16,    -1,    18,    -1,    -1,
     1,    22,    23,    24,     5,    -1,    -1,     8,    -1,    10,
     8,    12,    10,    -1,    12,    16,    -1,    18,    16,    -1,
    18,    22,    23,    24,    22,    23,    24,    10,    11,    -1,
    -1,    -1,    -1,    16,    17,    18,    19,    20,    21,    22,
    23,    24,    10,    11,    -1,    -1,    -1,    -1,    16,    17,
    18,    19,    20,    21,    22,    23,    24,    10,    -1,    -1,
    -1,    -1,    -1,    16,    17,    -1,    19,    20,    21
};
#define YYPURE 1

/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "/home/sbb/gnu/lib/bison.simple"

/* Skeleton output parser for bison,
   Copyright (C) 1984, 1989, 1990 Bob Corbett and Richard Stallman

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 1, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */


#ifndef alloca
#ifdef __GNUC__
#define alloca __builtin_alloca
#else /* Not GNU C.  */
#if (!defined (__STDC__) && defined (sparc)) || defined (__sparc__)
#include <alloca.h>
#else /* Not sparc */
#ifdef MSDOS
#include <malloc.h>
#endif /* MSDOS */
#endif /* Not sparc.  */
#endif /* Not GNU C.  */
#endif /* alloca not defined.  */

/* This is the parser code that is written into each bison parser
  when the %semantic_parser declaration is not specified in the grammar.
  It was written by Richard Stallman by simplifying the hairy parser
  used when %semantic_parser is specified.  */

/* Note: there must be only one dollar sign in this file.
   It is replaced by the list of actions, each action
   as one case of the switch.  */

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	return(0)
#define YYABORT 	return(1)
#define YYERROR		goto yyerrlab1
/* Like YYERROR except do call yyerror.
   This remains here temporarily to ease the
   transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */
#define YYFAIL		goto yyerrlab
#define YYRECOVERING()  (!!yyerrstatus)
#define YYBACKUP(token, value) \
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    { yychar = (token), yylval = (value);			\
      yychar1 = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { yyerror ("syntax error: cannot back up"); YYERROR; }	\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

#ifndef YYPURE
#define YYLEX		yylex()
#endif

#ifdef YYPURE
#ifdef YYLSP_NEEDED
#define YYLEX		yylex(&yylval, &yylloc)
#else
#define YYLEX		yylex(&yylval)
#endif
#endif

/* If nonreentrant, generate the variables here */

#ifndef YYPURE

int	yychar;			/*  the lookahead symbol		*/
YYSTYPE	yylval;			/*  the semantic value of the		*/
				/*  lookahead symbol			*/

#ifdef YYLSP_NEEDED
YYLTYPE yylloc;			/*  location data for the lookahead	*/
				/*  symbol				*/
#endif

int yynerrs;			/*  number of parse errors so far       */
#endif  /* not YYPURE */

#if YYDEBUG != 0
int yydebug;			/*  nonzero means print parse trace	*/
/* Since this is uninitialized, it does not stop multiple parsers
   from coexisting.  */
#endif

/*  YYINITDEPTH indicates the initial size of the parser's stacks	*/

#ifndef	YYINITDEPTH
#define YYINITDEPTH 200
#endif

/*  YYMAXDEPTH is the maximum size the stacks can grow to
    (effective only if the built-in stack extension method is used).  */

#if YYMAXDEPTH == 0
#undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
#define YYMAXDEPTH 10000
#endif

#ifndef __cplusplus

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_bcopy (from, to, count)
     char *from;
     char *to;
     int count;
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#else /* __cplusplus */

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_bcopy (char *from, char *to, int count)
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#endif

#line 160 "/home/sbb/gnu/lib/bison.simple"
int
yyparse()
{
  register int yystate;
  register int yyn;
  register short *yyssp;
  register YYSTYPE *yyvsp;
  int yyerrstatus;	/*  number of tokens to shift before error messages enabled */
  int yychar1;		/*  lookahead token as an internal (translated) token number */

  short	yyssa[YYINITDEPTH];	/*  the state stack			*/
  YYSTYPE yyvsa[YYINITDEPTH];	/*  the semantic value stack		*/

  short *yyss = yyssa;		/*  refer to the stacks thru separate pointers */
  YYSTYPE *yyvs = yyvsa;	/*  to allow yyoverflow to reallocate them elsewhere */

#ifdef YYLSP_NEEDED
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;
  YYLTYPE yylsa[YYINITDEPTH];	/*  the location stack			*/

#define YYPOPSTACK   (yyvsp--, yysp--, yylsp--)
#else
#define YYPOPSTACK   (yyvsp--, yysp--)
#endif

  int yystacksize = YYINITDEPTH;

#ifdef YYPURE
  int yychar;
  YYSTYPE yylval;
  int yynerrs;
#ifdef YYLSP_NEEDED
  YYLTYPE yylloc;
#endif
#endif

  YYSTYPE yyval;		/*  the variable used to return		*/
				/*  semantic values from the action	*/
				/*  routines				*/

  int yylen;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Starting parse\n");
#endif

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.  */

  yyssp = yyss - 1;
  yyvsp = yyvs;
#ifdef YYLSP_NEEDED
  yylsp = yyls;
#endif

/* Push a new state, which is found in  yystate  .  */
/* In all cases, when you get here, the value and location stacks
   have just been pushed. so pushing a state here evens the stacks.  */
yynewstate:

  *++yyssp = yystate;

  if (yyssp >= yyss + yystacksize - 1)
    {
      /* Give user a chance to reallocate the stack */
      /* Use copies of these so that the &'s don't force the real ones into memory. */
      YYSTYPE *yyvs1 = yyvs;
      short *yyss1 = yyss;
#ifdef YYLSP_NEEDED
      YYLTYPE *yyls1 = yyls;
#endif

      /* Get the current used size of the three stacks, in elements.  */
      int size = yyssp - yyss + 1;

#ifdef yyoverflow
      /* Each stack pointer address is followed by the size of
	 the data in use in that stack, in bytes.  */
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
#ifdef YYLSP_NEEDED
		 &yyls1, size * sizeof (*yylsp),
#endif
		 &yystacksize);

      yyss = yyss1; yyvs = yyvs1;
#ifdef YYLSP_NEEDED
      yyls = yyls1;
#endif
#else /* no yyoverflow */
      /* Extend the stack our own way.  */
      if (yystacksize >= YYMAXDEPTH)
	{
	  yyerror("parser stack overflow");
	  return 2;
	}
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;
      yyss = (short *) alloca (yystacksize * sizeof (*yyssp));
      __yy_bcopy ((char *)yyss1, (char *)yyss, size * sizeof (*yyssp));
      yyvs = (YYSTYPE *) alloca (yystacksize * sizeof (*yyvsp));
      __yy_bcopy ((char *)yyvs1, (char *)yyvs, size * sizeof (*yyvsp));
#ifdef YYLSP_NEEDED
      yyls = (YYLTYPE *) alloca (yystacksize * sizeof (*yylsp));
      __yy_bcopy ((char *)yyls1, (char *)yyls, size * sizeof (*yylsp));
#endif
#endif /* no yyoverflow */

      yyssp = yyss + size - 1;
      yyvsp = yyvs + size - 1;
#ifdef YYLSP_NEEDED
      yylsp = yyls + size - 1;
#endif

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Stack size increased to %d\n", yystacksize);
#endif

      if (yyssp >= yyss + yystacksize - 1)
	YYABORT;
    }

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Entering state %d\n", yystate);
#endif

 yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* yychar is either YYEMPTY or YYEOF
     or a valid token in external form.  */

  if (yychar == YYEMPTY)
    {
#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Reading a token: ");
#endif
      yychar = YYLEX;
    }

  /* Convert token to internal form (in yychar1) for indexing tables with */

  if (yychar <= 0)		/* This means end of input. */
    {
      yychar1 = 0;
      yychar = YYEOF;		/* Don't call YYLEX any more */

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Now at end of input.\n");
#endif
    }
  else
    {
      yychar1 = YYTRANSLATE(yychar);

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Next token is %d (%s)\n", yychar, yytname[yychar1]);
#endif
    }

  yyn += yychar1;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != yychar1)
    goto yydefault;

  yyn = yytable[yyn];

  /* yyn is what to do for this token type in this state.
     Negative => reduce, -yyn is rule number.
     Positive => shift, yyn is new state.
       New state is final state => don't bother to shift,
       just return success.
     0, or most negative number => error.  */

  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrlab;

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting token %d (%s), ", yychar, yytname[yychar1]);
#endif

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  /* count tokens shifted since error; after three, turn off error status.  */
  if (yyerrstatus) yyerrstatus--;

  yystate = yyn;
  goto yynewstate;

/* Do the default action for the current state.  */
yydefault:

  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;

/* Do a reduction.  yyn is the number of a rule to reduce with.  */
yyreduce:
  yylen = yyr2[yyn];
  yyval = yyvsp[1-yylen]; /* implement default value of the action */

#if YYDEBUG != 0
  if (yydebug)
    {
      int i;

      fprintf (stderr, "Reducing via rule %d (line %d), ",
	       yyn, yyrline[yyn]);

      /* Print the symboles being reduced, and their result.  */
      for (i = yyprhs[yyn]; yyrhs[i] > 0; i++)
	fprintf (stderr, "%s ", yytname[yyrhs[i]]);
      fprintf (stderr, " -> %s\n", yytname[yyr1[yyn]]);
    }
#endif


  switch (yyn) {

case 2:
#line 82 "mst.y"
{ compileMethod(yyvsp[0].node); ;
    break;}
case 4:
#line 87 "mst.y"
{ clearMethodStartPos(); ;
    break;}
case 7:
#line 95 "mst.y"
{ skipCompilation = false; ;
    break;}
case 8:
#line 96 "mst.y"
{ skipCompilation = false; ;
    break;}
case 9:
#line 97 "mst.y"
{ if (!hadError) {
					    executeStatements(nil, yyvsp[-1].node,
							    quietExecution); 
					  }
					  hadError = false;
					;
    break;}
case 10:
#line 104 "mst.y"
{ if (!hadError) {
					    executeStatements(yyvsp[-2].node, yyvsp[-1].node,
							    quietExecution); 
                                          }
					  hadError = false;
                                        ;
    break;}
case 11:
#line 110 "mst.y"
{ hadError = false;
					  yyerrok; ;
    break;}
case 12:
#line 115 "mst.y"
{ clearMethodStartPos(); ;
    break;}
case 13:
#line 119 "mst.y"
{ executeStatements(nil, 
				    makeStatementList(yyvsp[0].node, nil), true); ;
    break;}
case 14:
#line 160 "mst.y"
{ if (!hadError) {
					    if (skipCompilation) {
					      freeTree(yyvsp[-1].node);
					    } else {
					      compileMethod(yyvsp[-1].node);
					      clearMethodStartPos();
					    }
					  } else {
					    hadError = false;
					  }
					;
    break;}
case 15:
#line 171 "mst.y"
{ if (!hadError) {
					    if (skipCompilation) {
					      freeTree(yyvsp[-1].node);
					    } else {
					      compileMethod(yyvsp[-1].node);
					      clearMethodStartPos();
					    }
					  } else {
					    hadError = false;
					  }
					;
    break;}
case 16:
#line 186 "mst.y"
{ yyval.node = makeMethod(yyvsp[-1].node, nil, 0, yyvsp[0].node); ;
    break;}
case 17:
#line 188 "mst.y"
{ yyval.node = makeMethod(yyvsp[-2].node, yyvsp[-1].node, 0, yyvsp[0].node); ;
    break;}
case 18:
#line 190 "mst.y"
{ yyval.node = makeMethod(yyvsp[-2].node, nil, yyvsp[-1].ival, yyvsp[0].node); ;
    break;}
case 19:
#line 192 "mst.y"
{ yyval.node = makeMethod(yyvsp[-3].node, yyvsp[-2].node, yyvsp[-1].ival, yyvsp[0].node); ;
    break;}
case 20:
#line 197 "mst.y"
{ yyval.node = makeUnaryExpr(nil, yyvsp[0].sval); ;
    break;}
case 21:
#line 198 "mst.y"
{ yyval.node = makeBinaryExpr(nil, yyvsp[-1].sval,
						              yyvsp[0].node); ;
    break;}
case 22:
#line 200 "mst.y"
{ yyval.node = makeKeywordExpr(nil, yyvsp[0].node); ;
    break;}
case 23:
#line 201 "mst.y"
{ errorf("Invalid message pattern");
					  hadError = true;
					  yyerrok;
					  yyval.node = nil; ;
    break;}
case 27:
#line 217 "mst.y"
{ yyval.node = makeVariable(yyvsp[0].sval); ;
    break;}
case 28:
#line 221 "mst.y"
{ yyval.node = makeKeywordList(yyvsp[-1].sval, yyvsp[0].node); ;
    break;}
case 29:
#line 223 "mst.y"
{ addNode(yyvsp[-2].node, makeKeywordList(yyvsp[-1].sval, yyvsp[0].node));
					  yyval.node = yyvsp[-2].node; ;
    break;}
case 31:
#line 233 "mst.y"
{ yyval.ival = yyvsp[-1].ival;
					  if (strcmp(yyvsp[0].sval, ">") != 0) {
					    YYERROR;
					  }
					;
    break;}
case 32:
#line 240 "mst.y"
{ yyval.node = nil; ;
    break;}
case 33:
#line 242 "mst.y"
{ yyval.node = yyvsp[-1].node; ;
    break;}
case 34:
#line 246 "mst.y"
{ yyval.node = makeVariableList(yyvsp[0].node); ;
    break;}
case 35:
#line 247 "mst.y"
{ addNode(yyvsp[-1].node, makeVariableList(yyvsp[0].node));
					  yyval.node = yyvsp[-1].node; ;
    break;}
case 36:
#line 252 "mst.y"
{ yyval.node = nil; ;
    break;}
case 38:
#line 258 "mst.y"
{ yyval.node = makeStatementList(makeReturn(yyvsp[-1].node),
				       			nil); ;
    break;}
case 39:
#line 260 "mst.y"
{ yyval.node = makeStatementList(yyvsp[0].node, nil); ;
    break;}
case 40:
#line 263 "mst.y"
{ yyval.node = makeStatementList(yyvsp[-2].node, yyvsp[0].node); ;
    break;}
case 41:
#line 264 "mst.y"
{ yyval.node = yyvsp[0].node;
				  yyerrok;
				  errorf("Error in expression");
				  hadError = true;
				;
    break;}
case 45:
#line 278 "mst.y"
{ yyval.node = makeAssign(yyvsp[-1].node, yyvsp[0].node); ;
    break;}
case 46:
#line 282 "mst.y"
{ yyval.node = makeVariableList(yyvsp[-1].node); ;
    break;}
case 47:
#line 284 "mst.y"
{ addNode(yyvsp[-2].node, makeVariableList(yyvsp[-1].node));
					  yyval.node = yyvsp[-2].node; ;
    break;}
case 54:
#line 298 "mst.y"
{ yyval.node = yyvsp[-1].node; ;
    break;}
case 60:
#line 310 "mst.y"
{ yyval.node = makeIntConstant(yyvsp[0].ival); ;
    break;}
case 61:
#line 311 "mst.y"
{ yyval.node = makeFloatConstant(yyvsp[0].fval); ;
    break;}
case 62:
#line 315 "mst.y"
{ yyval.node = makeSymbolConstant(yyvsp[0].node); ;
    break;}
case 63:
#line 319 "mst.y"
{ yyval.node = internIdent(yyvsp[0].sval); ;
    break;}
case 64:
#line 320 "mst.y"
{ yyval.node = internBinOP(yyvsp[0].sval); ;
    break;}
case 65:
#line 321 "mst.y"
{ yyval.node = internIdent(yyvsp[0].sval); ;
    break;}
case 66:
#line 322 "mst.y"
{ yyval.node = internIdent(yyvsp[0].sval); ;
    break;}
case 67:
#line 327 "mst.y"
{ yyval.node = makeCharConstant(yyvsp[0].cval); ;
    break;}
case 68:
#line 331 "mst.y"
{ yyval.node = makeStringConstant(yyvsp[0].sval); ;
    break;}
case 69:
#line 335 "mst.y"
{ yyval.node = makeArrayConstant(yyvsp[0].node); ;
    break;}
case 70:
#line 339 "mst.y"
{ yyval.node = nil; ;
    break;}
case 71:
#line 341 "mst.y"
{ yyval.node = yyvsp[-1].node; ;
    break;}
case 72:
#line 345 "mst.y"
{ yyval.node = makeArrayElt(yyvsp[0].node); ;
    break;}
case 73:
#line 347 "mst.y"
{ addNode(yyvsp[-1].node, makeArrayElt(yyvsp[0].node));
					  yyval.node = yyvsp[-1].node; ;
    break;}
case 79:
#line 361 "mst.y"
{ yyval.node = makeBlock(yyvsp[-2].node, yyvsp[-1].node); ;
    break;}
case 80:
#line 365 "mst.y"
{ yyval.node = nil; ;
    break;}
case 82:
#line 373 "mst.y"
{ yyval.node = makeVariableList(yyvsp[0].node); ;
    break;}
case 83:
#line 375 "mst.y"
{ addNode(yyvsp[-2].node, makeVariableList(yyvsp[0].node));
					  yyval.node = yyvsp[-2].node; ;
    break;}
case 87:
#line 386 "mst.y"
{ yyval.node = makeUnaryExpr(yyvsp[-1].node, yyvsp[0].sval); ;
    break;}
case 90:
#line 396 "mst.y"
{ yyval.node = makeBinaryExpr(yyvsp[-2].node, yyvsp[-1].sval, yyvsp[0].node); ;
    break;}
case 93:
#line 406 "mst.y"
{ yyval.node = makeKeywordExpr(yyvsp[-1].node, yyvsp[0].node); ;
    break;}
case 94:
#line 411 "mst.y"
{ yyval.node = makeKeywordList(yyvsp[-1].sval, yyvsp[0].node); ;
    break;}
case 95:
#line 413 "mst.y"
{ addNode(yyvsp[-2].node, makeKeywordList(yyvsp[-1].sval, yyvsp[0].node));
					  yyval.node = yyvsp[-2].node; ;
    break;}
case 96:
#line 419 "mst.y"
{ yyval.node = makeCascadedMessage(yyvsp[-1].node, yyvsp[0].node); ;
    break;}
case 97:
#line 423 "mst.y"
{ yyval.node = makeMessageList(yyvsp[0].node); ;
    break;}
case 98:
#line 425 "mst.y"
{ addNode(yyvsp[-2].node, makeMessageList(yyvsp[0].node));
					  yyval.node = yyvsp[-2].node; ;
    break;}
case 99:
#line 430 "mst.y"
{ yyval.node = makeUnaryExpr(nil, yyvsp[0].sval); ;
    break;}
case 100:
#line 432 "mst.y"
{ yyval.node = makeBinaryExpr(nil, yyvsp[-1].sval, yyvsp[0].node); ;
    break;}
case 101:
#line 434 "mst.y"
{ yyval.node = makeKeywordExpr(nil, yyvsp[0].node); ;
    break;}
}
   /* the action file gets copied in in place of this dollarsign */
#line 423 "/home/sbb/gnu/lib/bison.simple"

  yyvsp -= yylen;
  yyssp -= yylen;
#ifdef YYLSP_NEEDED
  yylsp -= yylen;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

  *++yyvsp = yyval;

#ifdef YYLSP_NEEDED
  yylsp++;
  if (yylen == 0)
    {
      yylsp->first_line = yylloc.first_line;
      yylsp->first_column = yylloc.first_column;
      yylsp->last_line = (yylsp-1)->last_line;
      yylsp->last_column = (yylsp-1)->last_column;
      yylsp->text = 0;
    }
  else
    {
      yylsp->last_line = (yylsp+yylen-1)->last_line;
      yylsp->last_column = (yylsp+yylen-1)->last_column;
    }
#endif

  /* Now "shift" the result of the reduction.
     Determine what state that goes to,
     based on the state we popped back to
     and the rule number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTBASE] + *yyssp;
  if (yystate >= 0 && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTBASE];

  goto yynewstate;

yyerrlab:   /* here on detecting error */

  if (! yyerrstatus)
    /* If not already recovering from an error, report this error.  */
    {
      ++yynerrs;

#ifdef YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (yyn > YYFLAG && yyn < YYLAST)
	{
	  int size = 0;
	  char *msg;
	  int x, count;

	  count = 0;
	  for (x = 0; x < (sizeof(yytname) / sizeof(char *)); x++)
	    if (yycheck[x + yyn] == x)
	      size += strlen(yytname[x]) + 15, count++;
	  msg = (char *) xmalloc(size + 15);
	  strcpy(msg, "parse error");

	  if (count < 5)
	    {
	      count = 0;
	      for (x = 0; x < (sizeof(yytname) / sizeof(char *)); x++)
		if (yycheck[x + yyn] == x)
		  {
		    strcat(msg, count == 0 ? ", expecting `" : " or `");
		    strcat(msg, yytname[x]);
		    strcat(msg, "'");
		    count++;
		  }
	    }
	  yyerror(msg);
	  free(msg);
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror("parse error");
    }

yyerrlab1:   /* here on error raised explicitly by an action */

  if (yyerrstatus == 3)
    {
      /* if just tried and failed to reuse lookahead token after an error, discard it.  */

      /* return failure if at end of input */
      if (yychar == YYEOF)
	YYABORT;

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Discarding token %d (%s).\n", yychar, yytname[yychar1]);
#endif

      yychar = YYEMPTY;
    }

  /* Else will try to reuse lookahead token
     after shifting the error token.  */

  yyerrstatus = 3;		/* Each real token shifted decrements this */

  goto yyerrhandle;

yyerrdefault:  /* current state does not do anything special for the error token. */

#if 0
  /* This is wrong; only states that explicitly want error tokens
     should shift them.  */
  yyn = yydefact[yystate];  /* If its default is to accept any token, ok.  Otherwise pop it.*/
  if (yyn) goto yydefault;
#endif

yyerrpop:   /* pop the current state because it cannot handle the error token */

  if (yyssp == yyss) YYABORT;
  yyvsp--;
  yystate = *--yyssp;
#ifdef YYLSP_NEEDED
  yylsp--;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "Error: state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

yyerrhandle:

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yyerrdefault;

  yyn += YYTERROR;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != YYTERROR)
    goto yyerrdefault;

  yyn = yytable[yyn];
  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrpop;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrpop;

  if (yyn == YYFINAL)
    YYACCEPT;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting error token, ");
#endif

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  yystate = yyn;
  goto yynewstate;
}
#line 438 "mst.y"

/*     
ADDITIONAL C CODE
*/

