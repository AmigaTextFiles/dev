
/*  A Bison parser, made from tg.y
 by  GNU Bison version 1.27
  */

#define YYBISON 1  /* Identify Bison output.  */

#define	TOK_NUM	257
#define	TOK_FLOAT	258
#define	TOK_NAME	259
#define	TOK_STRING	260
#define	TOK_CHAR	261
#define	TOK_DOL	262
#define	TOK_DIV	263
#define	TOK_DOT	264
#define	TOK_COM	265
#define	TOK_STAR	266
#define	TOK_PLUS	267
#define	TOK_MINUS	268
#define	TOK_PLUSPLUS	269
#define	TOK_MINUSMINUS	270
#define	TOK_PLUS_S	271
#define	TOK_MINUS_S	272
#define	TOK_DIV_S	273
#define	TOK_MUL_S	274
#define	TOK_CLOSE	275
#define	TOK_CLOSEB	276
#define	TOK_NL	277
#define	TOK_OPEN	278
#define	TOK_OPENB	279
#define	TOK_COLON	280
#define	TOK_SCOL	281
#define	TOK_AT	282
#define	TOK_EQ	283
#define	TOK_IN	284
#define	TOK_EQEQ	285
#define	TOK_LT	286
#define	TOK_NE	287
#define	TOK_GT	288
#define	TOK_NOT	289
#define	TOK_AND	290
#define	TOK_OR	291
#define	TOK_LTEQ	292
#define	TOK_GTEQ	293
#define	TOK_IF	294
#define	TOK_ELSE	295
#define	TOK_ENDIF	296
#define	TOK_EMBED	297
#define	TOK_EMIT	298
#define	TOK_OUTPUT	299
#define	TOK_LOCAL	300
#define	TOK_PUSH	301
#define	TOK_POP	302
#define	TOK_FUNCTION	303
#define	TOK_ENDFUNCTION	304
#define	TOK_SWITCH	305
#define	TOK_CASE	306
#define	TOK_FOR	307
#define	TOK_ENDSWITCH	308
#define	TOK_ENDFOR	309
#define	TOK_RETURN	310
#define	TOK_BREAK	311
#define	TOK_USE	312
#define	TOK_EXIT	313


#line 99 "tg.y"
typedef union  {
    struct int_rec {
            int            val;
            int            line;
            int            start, end;
    } i;

    struct float_rec {
            float          val;
            int            line;
            int            start, end;
    } f;
    
    struct char_rec {
            char          *val;
            int            line;
            int            start, end;
    } s;
    
    struct ptr_rec {
            void          *val;
            int            line;
            int            start, end;
    } p;
    
    struct line_rec {
        int    line;
        struct command *cmd;
    } l;
} YYSTYPE;
#line 130 "tg.y"

#include "alloc.h"
#include "generator.h"    
#include "util.h"    
    
#include <stdio.h>
#define FL     fflush(stdout);    
#define dpr    printf 
#define P(s)   {dpr(s);}

#undef  YYDEBUG        
#define YYDEBUG 1

#undef  YYERROR_VERBOSE        
#define YYERROR_VERBOSE   1
    
int   yydebug = 0;        
char *errmsg = "syntax error";

extern struct txttab *text_table;
extern struct lintab *line_table;
extern int curfilen;
extern int lineno;

#define  ERR(msg) save_error(atom_name(curfilen), lineno, msg)
#include <stdio.h>

#ifndef __cplusplus
#ifndef __STDC__
#ifndef const
#define const
#endif
#endif
#endif



#define	YYFINAL		232
#define	YYFLAG		-32768
#define	YYNTBASE	60

#define YYTRANSLATE(x) ((unsigned)(x) <= 313 ? yytranslate[x] : 101)

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
     2,     2,     2,     2,     2,     1,     3,     4,     5,     6,
     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,
    27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
    37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
    47,    48,    49,    50,    51,    52,    53,    54,    55,    56,
    57,    58,    59
};

#if YYDEBUG != 0
static const short yyprhs[] = {     0,
     0,     1,     3,     6,    10,    12,    14,    16,    18,    20,
    23,    26,    28,    30,    32,    34,    36,    38,    40,    42,
    44,    46,    48,    50,    52,    54,    56,    58,    60,    62,
    64,    66,    68,    70,    72,    74,    76,    78,    80,    82,
    84,    86,    88,    90,    92,    94,    97,   102,   105,   107,
   111,   115,   117,   119,   121,   123,   125,   127,   129,   131,
   133,   135,   137,   139,   141,   143,   147,   149,   153,   157,
   161,   165,   167,   171,   175,   179,   183,   185,   189,   193,
   199,   203,   207,   210,   212,   214,   217,   220,   223,   226,
   229,   232,   234,   236,   238,   242,   245,   247,   249,   254,
   259,   263,   267,   268,   270,   272,   276,   278,   280,   282,
   284,   286,   288,   290,   292,   294,   296,   298,   300,   302,
   304,   306,   308,   311,   317,   326,   329,   332,   334,   342,
   345,   346,   348,   350,   354,   360,   365,   367,   370,   376,
   379,   385,   388,   396,   402,   405,   408,   411,   413,   415,
   417,   418,   420,   422,   425,   428,   431,   434,   437,   440,
   443,   445
};

static const short yyrhs[] = {    -1,
    62,     0,    60,    61,     0,    60,    61,    62,     0,    23,
     0,    63,     0,    78,     0,    64,     0,    65,     0,    63,
    64,     0,    63,    65,     0,     3,     0,     4,     0,     5,
     0,     6,     0,     7,     0,    10,     0,    26,     0,    27,
     0,    11,     0,    29,     0,    32,     0,    30,     0,    33,
     0,    34,     0,    35,     0,    36,     0,    37,     0,    31,
     0,    38,     0,    39,     0,    12,     0,    13,     0,    18,
     0,    17,     0,    20,     0,    19,     0,    14,     0,    15,
     0,    16,     0,     9,     0,    24,     0,    21,     0,    25,
     0,    22,     0,     8,    66,     0,     8,    24,    68,    21,
     0,     8,     1,     0,    75,     0,    66,    10,    75,     0,
    66,    10,     1,     0,    31,     0,    29,     0,    32,     0,
    34,     0,    33,     0,    38,     0,    39,     0,    20,     0,
    19,     0,    17,     0,    18,     0,    37,     0,    36,     0,
    69,     0,    68,    67,    69,     0,    70,     0,    69,    13,
    70,     0,    69,    14,    70,     0,    69,    13,     1,     0,
    69,    14,     1,     0,    74,     0,    70,    12,    74,     0,
    70,     9,    74,     0,    70,    12,     1,     0,    70,     9,
     1,     0,    68,     0,    71,    11,    68,     0,     5,    26,
    68,     0,    72,    11,     5,    26,    68,     0,    25,    71,
    22,     0,    25,    72,    22,     0,    25,     1,     0,    65,
     0,    73,     0,    74,    15,     0,    15,    74,     0,    35,
    74,     0,    14,    74,     0,    74,    16,     0,    16,    74,
     0,     3,     0,     4,     0,     6,     0,    24,    68,    21,
     0,    24,     1,     0,     5,     0,    65,     0,    75,    24,
    76,    21,     0,    75,    25,    68,    22,     0,    75,    24,
     1,     0,    75,    25,     1,     0,     0,    77,     0,    68,
     0,    77,    11,    68,     0,    79,     0,    81,     0,    84,
     0,    87,     0,    94,     0,    95,     0,    96,     0,    97,
     0,    98,     0,    89,     0,    90,     0,    91,     0,    92,
     0,    99,     0,   100,     0,    28,     0,    28,     1,     0,
    40,    68,    23,    60,    42,     0,    40,    68,    23,    60,
    41,    23,    60,    42,     0,    40,     1,     0,    60,    50,
     0,     1,     0,    49,     5,    24,    82,    21,    23,    80,
     0,    49,     1,     0,     0,    83,     0,     5,     0,    83,
    11,     5,     0,    51,    68,    23,    85,    54,     0,    51,
    68,    23,     1,     0,    86,     0,    85,    86,     0,    52,
    68,    26,    23,    60,     0,    52,     1,     0,    53,    88,
    23,    60,    55,     0,    53,     1,     0,    24,    93,    27,
    93,    27,    93,    21,     0,    24,    65,    30,    68,    21,
     0,    24,     1,     0,    56,    68,     0,    56,     1,     0,
    57,     0,    47,     0,    48,     0,     0,    68,     0,     1,
     0,    28,    68,     0,    43,    68,     0,    44,    68,     0,
    45,    68,     0,    46,     5,     0,    58,     5,     0,    58,
     6,     0,    59,     0,    59,    68,     0
};

#endif

#if YYDEBUG != 0
static const short yyrline[] = { 0,
   158,   159,   160,   161,   164,   167,   170,   176,   180,   186,
   191,   198,   199,   200,   201,   202,   203,   204,   205,   206,
   207,   208,   209,   210,   211,   212,   213,   214,   215,   216,
   217,   218,   219,   220,   221,   222,   223,   224,   225,   227,
   229,   230,   231,   232,   233,   236,   242,   248,   254,   260,
   266,   272,   273,   274,   275,   276,   277,   278,   279,   280,
   281,   282,   283,   284,   287,   288,   296,   297,   303,   309,
   313,   319,   320,   326,   332,   335,   340,   345,   352,   358,
   367,   373,   379,   385,   386,   387,   393,   399,   405,   411,
   417,   423,   429,   435,   445,   451,   456,   466,   471,   477,
   483,   486,   492,   493,   496,   502,   510,   511,   512,   513,
   514,   515,   516,   517,   518,   519,   520,   521,   522,   523,
   524,   525,   527,   533,   537,   541,   546,   547,   551,   562,
   568,   569,   572,   576,   583,   588,   593,   596,   602,   606,
   611,   615,   620,   624,   630,   635,   638,   643,   648,   653,
   658,   659,   660,   665,   669,   673,   677,   681,   685,   687,
   693,   696
};
#endif


#if YYDEBUG != 0 || defined (YYERROR_VERBOSE)

static const char * const yytname[] = {   "$","error","$undefined.","TOK_NUM",
"TOK_FLOAT","TOK_NAME","TOK_STRING","TOK_CHAR","TOK_DOL","TOK_DIV","TOK_DOT",
"TOK_COM","TOK_STAR","TOK_PLUS","TOK_MINUS","TOK_PLUSPLUS","TOK_MINUSMINUS",
"TOK_PLUS_S","TOK_MINUS_S","TOK_DIV_S","TOK_MUL_S","TOK_CLOSE","TOK_CLOSEB",
"TOK_NL","TOK_OPEN","TOK_OPENB","TOK_COLON","TOK_SCOL","TOK_AT","TOK_EQ","TOK_IN",
"TOK_EQEQ","TOK_LT","TOK_NE","TOK_GT","TOK_NOT","TOK_AND","TOK_OR","TOK_LTEQ",
"TOK_GTEQ","TOK_IF","TOK_ELSE","TOK_ENDIF","TOK_EMBED","TOK_EMIT","TOK_OUTPUT",
"TOK_LOCAL","TOK_PUSH","TOK_POP","TOK_FUNCTION","TOK_ENDFUNCTION","TOK_SWITCH",
"TOK_CASE","TOK_FOR","TOK_ENDSWITCH","TOK_ENDFOR","TOK_RETURN","TOK_BREAK","TOK_USE",
"TOK_EXIT","lines","eol","cmd","data_line","other_token","dol_exp","obj","relop",
"exp","ear","emul","array","record","constructor","smp_exp","objpart","arglist",
"arglist1","ctl_cmd","cmd_if","fun_body","cmd_function","param_list","param_list1",
"cmd_switch","case_list","case_item","cmd_for","forctl","cmd_return","cmd_break",
"cmd_push","cmd_pop","optexp","cmd_exp","cmd_embed","cmd_emit","cmd_output",
"cmd_local","cmd_use","cmd_exit", NULL
};
#endif

static const short yyr1[] = {     0,
    60,    60,    60,    60,    61,    62,    62,    63,    63,    63,
    63,    64,    64,    64,    64,    64,    64,    64,    64,    64,
    64,    64,    64,    64,    64,    64,    64,    64,    64,    64,
    64,    64,    64,    64,    64,    64,    64,    64,    64,    64,
    64,    64,    64,    64,    64,    65,    65,    65,    66,    66,
    66,    67,    67,    67,    67,    67,    67,    67,    67,    67,
    67,    67,    67,    67,    68,    68,    69,    69,    69,    69,
    69,    70,    70,    70,    70,    70,    71,    71,    72,    72,
    73,    73,    73,    74,    74,    74,    74,    74,    74,    74,
    74,    74,    74,    74,    74,    74,    75,    75,    75,    75,
    75,    75,    76,    76,    77,    77,    78,    78,    78,    78,
    78,    78,    78,    78,    78,    78,    78,    78,    78,    78,
    78,    78,    78,    79,    79,    79,    80,    80,    81,    81,
    82,    82,    83,    83,    84,    84,    85,    85,    86,    86,
    87,    87,    88,    88,    88,    89,    89,    90,    91,    92,
    93,    93,    93,    94,    95,    96,    97,    98,    99,    99,
   100,   100
};

static const short yyr2[] = {     0,
     0,     1,     2,     3,     1,     1,     1,     1,     1,     2,
     2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     2,     4,     2,     1,     3,
     3,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     3,     1,     3,     3,     3,
     3,     1,     3,     3,     3,     3,     1,     3,     3,     5,
     3,     3,     2,     1,     1,     2,     2,     2,     2,     2,
     2,     1,     1,     1,     3,     2,     1,     1,     4,     4,
     3,     3,     0,     1,     1,     3,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     2,     5,     8,     2,     2,     1,     7,     2,
     0,     1,     1,     3,     5,     4,     1,     2,     5,     2,
     5,     2,     7,     5,     2,     2,     2,     1,     1,     1,
     0,     1,     1,     2,     2,     2,     2,     2,     2,     2,
     1,     2
};

static const short yydefact[] = {     1,
    12,    13,    14,    15,    16,     0,    41,    17,    20,    32,
    33,    38,    39,    40,    35,    34,    37,    36,    43,    45,
    42,    44,    18,    19,     0,    21,    23,    29,    22,    24,
    25,    26,    27,    28,    30,    31,     0,     0,     0,     0,
     0,   149,   150,     0,     0,     0,     0,   148,     0,   161,
     0,     2,     6,     8,     9,     7,   107,   108,   109,   110,
   116,   117,   118,   119,   111,   112,   113,   114,   115,   120,
   121,    48,    97,     0,    98,    46,    49,   123,    92,    93,
    94,     0,     0,     0,     0,     0,     0,    84,   154,    65,
    67,    85,    72,   126,     0,   155,   156,   157,   158,   130,
     0,     0,   142,     0,     0,   147,   146,   159,   160,   162,
     5,     3,    10,    11,     0,     0,     0,     0,    89,    87,
    91,    96,     0,    83,     0,    77,     0,     0,    88,    61,
    62,    60,    59,    53,    52,    54,    56,    55,    64,    63,
    57,    58,     0,     0,     0,     0,     0,    86,    90,     1,
   131,     0,   145,    84,   152,     0,     1,     4,    47,    51,
    50,   101,   105,     0,   104,   102,     0,    95,     0,     0,
    81,     0,    82,    66,    70,    68,    71,    69,    76,    74,
    75,    73,     0,   133,     0,   132,   136,     0,     0,   137,
     0,     0,     0,    99,     0,   100,    79,    78,     0,     0,
   124,     0,     0,   140,     0,   135,   138,     0,   153,     0,
   141,   106,     0,     1,     0,   134,     0,   144,     0,    80,
     0,   128,     0,   129,     1,     0,   125,   127,   139,   143,
     0,     0
};

static const short yydefgoto[] = {    51,
   112,    52,    53,    54,    88,    76,   143,   155,    90,    91,
   127,   128,    92,    93,    77,   164,   165,    56,    57,   224,
    58,   185,   186,    59,   189,   190,    60,   105,    61,    62,
    63,    64,   156,    65,    66,    67,    68,    69,    70,    71
};

static const short yypact[] = {   280,
-32768,-32768,-32768,-32768,-32768,    19,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,    33,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,   401,   615,   615,   615,
    20,-32768,-32768,    50,   615,     6,   426,-32768,    59,   615,
    12,-32768,   337,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,   615,-32768,     1,    55,-32768,-32768,-32768,
-32768,   615,   615,   615,   451,    94,   615,-32768,   785,    76,
    60,-32768,    90,-32768,   624,   785,   785,   785,-32768,-32768,
    22,   647,-32768,   124,    29,-32768,   785,-32768,-32768,   785,
-32768,   280,-32768,-32768,   670,    37,   162,   476,    90,    90,
    90,-32768,   693,-32768,    47,   785,    48,    49,    90,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,   615,   501,   526,   551,   576,-32768,-32768,   280,
    79,     2,    69,    56,   785,    74,   280,-32768,-32768,-32768,
    55,-32768,   785,    82,    96,-32768,   716,-32768,   615,   615,
-32768,   106,-32768,    76,-32768,    60,-32768,    60,-32768,    90,
-32768,    90,   -13,-32768,    92,   103,-32768,   601,    24,-32768,
   615,   376,   -15,-32768,   615,-32768,   785,   785,    89,    97,
-32768,    98,   112,-32768,   739,-32768,-32768,   762,-32768,    95,
-32768,   785,   615,   280,   223,-32768,   100,-32768,   187,   785,
    21,-32768,   -19,-32768,   280,   105,-32768,-32768,   101,-32768,
   131,-32768
};

static const short yypgoto[] = {  -148,
-32768,    23,-32768,    80,     0,-32768,-32768,   -24,    -9,   -53,
-32768,-32768,-32768,   -65,    25,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,   -52,-32768,-32768,-32768,-32768,
-32768,-32768,  -187,-32768,-32768,-32768,-32768,-32768,-32768,-32768
};


#define	YYLAST		824


static const short yytable[] = {    55,
    89,   183,   187,   111,   210,    75,   103,   111,   193,   111,
   116,   231,    95,    96,    97,    98,   119,   120,   121,    72,
   102,   129,   107,    73,    99,   110,     6,   200,   201,   104,
   228,   226,  -122,    78,   111,    79,    80,   160,    81,   211,
     6,    73,    74,   111,     6,   151,    82,    83,    84,   115,
   100,   157,   114,   188,   101,  -122,    85,    86,   170,   172,
   123,   126,   227,   108,   109,   221,   223,    87,   146,   171,
   173,   147,   169,  -122,  -122,   188,   229,   206,   117,   118,
   180,   182,  -122,   184,  -122,   191,  -122,  -122,   144,   145,
   176,   178,   163,   167,   124,  -153,    79,    80,   125,    81,
   192,     6,   194,   154,   148,   149,   195,    82,    83,    84,
   199,    55,   202,   203,   213,    75,   216,    85,    86,   214,
   215,   219,   225,   111,   153,   230,    79,    80,    87,    81,
   232,     6,   113,   174,   158,     0,   207,    82,    83,    84,
   161,     0,     0,     0,   197,   198,     0,    85,    86,    55,
  -151,     0,     0,     0,     0,     0,    55,     0,    87,     0,
     0,     0,   162,   205,    79,    80,   208,    81,     0,     6,
   212,     0,     0,     0,     0,    82,    83,    84,     0,     0,
     0,     0,  -103,     0,     0,    85,    86,   209,   220,    79,
    80,     0,    81,     0,     6,     0,    87,     0,     0,     0,
    82,    83,    84,     0,     0,     0,     0,  -151,     0,     0,
    85,    86,     0,    55,    55,     0,     0,     0,     0,     0,
     0,    87,     0,   222,    55,     1,     2,     3,     4,     5,
     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
    16,    17,    18,    19,    20,    -1,    21,    22,    23,    24,
    25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
    35,    36,    37,     0,     0,    38,    39,    40,    41,    42,
    43,    44,    -1,    45,     0,    46,     0,     0,    47,    48,
    49,    50,     1,     2,     3,     4,     5,     6,     7,     8,
     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
    19,    20,     0,    21,    22,    23,    24,    25,    26,    27,
    28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
     0,     0,    38,    39,    40,    41,    42,    43,    44,     0,
    45,     0,    46,     0,     0,    47,    48,    49,    50,     1,
     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,
    12,    13,    14,    15,    16,    17,    18,    19,    20,     0,
    21,    22,    23,    24,     0,    26,    27,    28,    29,    30,
    31,    32,    33,    34,    35,    36,   209,     0,    79,    80,
     0,    81,     0,     6,     0,     0,     0,     0,     0,    82,
    83,    84,     0,     0,     0,     0,     0,     0,     0,    85,
    86,    94,  -151,    79,    80,     0,    81,     0,     6,     0,
    87,     0,     0,     0,    82,    83,    84,     0,     0,     0,
     0,     0,     0,     0,    85,    86,   106,     0,    79,    80,
     0,    81,     0,     6,     0,    87,     0,     0,     0,    82,
    83,    84,     0,     0,     0,     0,     0,     0,     0,    85,
    86,   122,     0,    79,    80,     0,    81,     0,     6,     0,
    87,     0,     0,     0,    82,    83,    84,     0,     0,     0,
     0,     0,     0,     0,    85,    86,   166,     0,    79,    80,
     0,    81,     0,     6,     0,    87,     0,     0,     0,    82,
    83,    84,     0,     0,     0,     0,     0,     0,     0,    85,
    86,   175,     0,    79,    80,     0,    81,     0,     6,     0,
    87,     0,     0,     0,    82,    83,    84,     0,     0,     0,
     0,     0,     0,     0,    85,    86,   177,     0,    79,    80,
     0,    81,     0,     6,     0,    87,     0,     0,     0,    82,
    83,    84,     0,     0,     0,     0,     0,     0,     0,    85,
    86,   179,     0,    79,    80,     0,    81,     0,     6,     0,
    87,     0,     0,     0,    82,    83,    84,     0,     0,     0,
     0,     0,     0,     0,    85,    86,   181,     0,    79,    80,
     0,    81,     0,     6,     0,    87,     0,     0,     0,    82,
    83,    84,     0,     0,     0,     0,     0,     0,     0,    85,
    86,   204,     0,    79,    80,     0,    81,     0,     6,     0,
    87,     0,     0,     0,    82,    83,    84,    79,    80,     0,
    81,     0,     6,     0,    85,    86,     0,     0,    82,    83,
    84,     0,     0,     0,     0,    87,     0,     0,    85,    86,
   130,   131,   132,   133,     0,     0,   150,     0,     0,    87,
     0,     0,   134,     0,   135,   136,   137,   138,     0,   139,
   140,   141,   142,   130,   131,   132,   133,     0,     0,   152,
     0,     0,     0,     0,     0,   134,     0,   135,   136,   137,
   138,     0,   139,   140,   141,   142,   130,   131,   132,   133,
   159,     0,     0,     0,     0,     0,     0,     0,   134,     0,
   135,   136,   137,   138,     0,   139,   140,   141,   142,   130,
   131,   132,   133,   168,     0,     0,     0,     0,     0,     0,
     0,   134,     0,   135,   136,   137,   138,     0,   139,   140,
   141,   142,   130,   131,   132,   133,     0,   196,     0,     0,
     0,     0,     0,     0,   134,     0,   135,   136,   137,   138,
     0,   139,   140,   141,   142,   130,   131,   132,   133,     0,
     0,     0,     0,     0,   217,     0,     0,   134,     0,   135,
   136,   137,   138,     0,   139,   140,   141,   142,   130,   131,
   132,   133,   218,     0,     0,     0,     0,     0,     0,     0,
   134,     0,   135,   136,   137,   138,     0,   139,   140,   141,
   142,   130,   131,   132,   133,     0,     0,     0,     0,     0,
     0,     0,     0,   134,     0,   135,   136,   137,   138,     0,
   139,   140,   141,   142
};

static const short yycheck[] = {     0,
    25,   150,     1,    23,   192,     6,     1,    23,   157,    23,
    10,     0,    37,    38,    39,    40,    82,    83,    84,     1,
    45,    87,    47,     5,     5,    50,     8,    41,    42,    24,
    50,   219,     0,     1,    23,     3,     4,     1,     6,    55,
     8,     5,    24,    23,     8,    24,    14,    15,    16,    74,
     1,    23,    53,    52,     5,    23,    24,    25,    11,    11,
    85,    86,    42,     5,     6,   214,   215,    35,     9,    22,
    22,    12,    26,    41,    42,    52,   225,    54,    24,    25,
   146,   147,    50,     5,    52,    30,    54,    55,    13,    14,
   144,   145,   117,   118,     1,    27,     3,     4,     5,     6,
    27,     8,    21,   104,    15,    16,    11,    14,    15,    16,
     5,   112,    21,    11,    26,   116,     5,    24,    25,    23,
    23,    27,    23,    23,     1,    21,     3,     4,    35,     6,
     0,     8,    53,   143,   112,    -1,   189,    14,    15,    16,
   116,    -1,    -1,    -1,   169,   170,    -1,    24,    25,   150,
    27,    -1,    -1,    -1,    -1,    -1,   157,    -1,    35,    -1,
    -1,    -1,     1,   188,     3,     4,   191,     6,    -1,     8,
   195,    -1,    -1,    -1,    -1,    14,    15,    16,    -1,    -1,
    -1,    -1,    21,    -1,    -1,    24,    25,     1,   213,     3,
     4,    -1,     6,    -1,     8,    -1,    35,    -1,    -1,    -1,
    14,    15,    16,    -1,    -1,    -1,    -1,    21,    -1,    -1,
    24,    25,    -1,   214,   215,    -1,    -1,    -1,    -1,    -1,
    -1,    35,    -1,     1,   225,     3,     4,     5,     6,     7,
     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
    28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
    38,    39,    40,    -1,    -1,    43,    44,    45,    46,    47,
    48,    49,    50,    51,    -1,    53,    -1,    -1,    56,    57,
    58,    59,     3,     4,     5,     6,     7,     8,     9,    10,
    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
    21,    22,    -1,    24,    25,    26,    27,    28,    29,    30,
    31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
    -1,    -1,    43,    44,    45,    46,    47,    48,    49,    -1,
    51,    -1,    53,    -1,    -1,    56,    57,    58,    59,     3,
     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
    14,    15,    16,    17,    18,    19,    20,    21,    22,    -1,
    24,    25,    26,    27,    -1,    29,    30,    31,    32,    33,
    34,    35,    36,    37,    38,    39,     1,    -1,     3,     4,
    -1,     6,    -1,     8,    -1,    -1,    -1,    -1,    -1,    14,
    15,    16,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    24,
    25,     1,    27,     3,     4,    -1,     6,    -1,     8,    -1,
    35,    -1,    -1,    -1,    14,    15,    16,    -1,    -1,    -1,
    -1,    -1,    -1,    -1,    24,    25,     1,    -1,     3,     4,
    -1,     6,    -1,     8,    -1,    35,    -1,    -1,    -1,    14,
    15,    16,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    24,
    25,     1,    -1,     3,     4,    -1,     6,    -1,     8,    -1,
    35,    -1,    -1,    -1,    14,    15,    16,    -1,    -1,    -1,
    -1,    -1,    -1,    -1,    24,    25,     1,    -1,     3,     4,
    -1,     6,    -1,     8,    -1,    35,    -1,    -1,    -1,    14,
    15,    16,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    24,
    25,     1,    -1,     3,     4,    -1,     6,    -1,     8,    -1,
    35,    -1,    -1,    -1,    14,    15,    16,    -1,    -1,    -1,
    -1,    -1,    -1,    -1,    24,    25,     1,    -1,     3,     4,
    -1,     6,    -1,     8,    -1,    35,    -1,    -1,    -1,    14,
    15,    16,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    24,
    25,     1,    -1,     3,     4,    -1,     6,    -1,     8,    -1,
    35,    -1,    -1,    -1,    14,    15,    16,    -1,    -1,    -1,
    -1,    -1,    -1,    -1,    24,    25,     1,    -1,     3,     4,
    -1,     6,    -1,     8,    -1,    35,    -1,    -1,    -1,    14,
    15,    16,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    24,
    25,     1,    -1,     3,     4,    -1,     6,    -1,     8,    -1,
    35,    -1,    -1,    -1,    14,    15,    16,     3,     4,    -1,
     6,    -1,     8,    -1,    24,    25,    -1,    -1,    14,    15,
    16,    -1,    -1,    -1,    -1,    35,    -1,    -1,    24,    25,
    17,    18,    19,    20,    -1,    -1,    23,    -1,    -1,    35,
    -1,    -1,    29,    -1,    31,    32,    33,    34,    -1,    36,
    37,    38,    39,    17,    18,    19,    20,    -1,    -1,    23,
    -1,    -1,    -1,    -1,    -1,    29,    -1,    31,    32,    33,
    34,    -1,    36,    37,    38,    39,    17,    18,    19,    20,
    21,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    29,    -1,
    31,    32,    33,    34,    -1,    36,    37,    38,    39,    17,
    18,    19,    20,    21,    -1,    -1,    -1,    -1,    -1,    -1,
    -1,    29,    -1,    31,    32,    33,    34,    -1,    36,    37,
    38,    39,    17,    18,    19,    20,    -1,    22,    -1,    -1,
    -1,    -1,    -1,    -1,    29,    -1,    31,    32,    33,    34,
    -1,    36,    37,    38,    39,    17,    18,    19,    20,    -1,
    -1,    -1,    -1,    -1,    26,    -1,    -1,    29,    -1,    31,
    32,    33,    34,    -1,    36,    37,    38,    39,    17,    18,
    19,    20,    21,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
    29,    -1,    31,    32,    33,    34,    -1,    36,    37,    38,
    39,    17,    18,    19,    20,    -1,    -1,    -1,    -1,    -1,
    -1,    -1,    -1,    29,    -1,    31,    32,    33,    34,    -1,
    36,    37,    38,    39
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "/gg/share/bison.simple"
/* This file comes from bison-1.27.  */

/* Skeleton output parser for bison,
   Copyright (C) 1984, 1989, 1990 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* This is the parser code that is written into each bison parser
  when the %semantic_parser declaration is not specified in the grammar.
  It was written by Richard Stallman by simplifying the hairy parser
  used when %semantic_parser is specified.  */

#ifndef YYSTACK_USE_ALLOCA
#ifdef alloca
#define YYSTACK_USE_ALLOCA
#else /* alloca not defined */
#ifdef __GNUC__
#define YYSTACK_USE_ALLOCA
#define alloca __builtin_alloca
#else /* not GNU C.  */
#if (!defined (__STDC__) && defined (sparc)) || defined (__sparc__) || defined (__sparc) || defined (__sgi) || (defined (__sun) && defined (__i386))
#define YYSTACK_USE_ALLOCA
#include <alloca.h>
#else /* not sparc */
/* We think this test detects Watcom and Microsoft C.  */
/* This used to test MSDOS, but that is a bad idea
   since that symbol is in the user namespace.  */
#if (defined (_MSDOS) || defined (_MSDOS_)) && !defined (__TURBOC__)
#if 0 /* No need for malloc.h, which pollutes the namespace;
	 instead, just don't use alloca.  */
#include <malloc.h>
#endif
#else /* not MSDOS, or __TURBOC__ */
#if defined(_AIX)
/* I don't know what this was needed for, but it pollutes the namespace.
   So I turned it off.   rms, 2 May 1997.  */
/* #include <malloc.h>  */
 #pragma alloca
#define YYSTACK_USE_ALLOCA
#else /* not MSDOS, or __TURBOC__, or _AIX */
#if 0
#ifdef __hpux /* haible@ilog.fr says this works for HPUX 9.05 and up,
		 and on HPUX 10.  Eventually we can turn this on.  */
#define YYSTACK_USE_ALLOCA
#define alloca __builtin_alloca
#endif /* __hpux */
#endif
#endif /* not _AIX */
#endif /* not MSDOS, or __TURBOC__ */
#endif /* not sparc */
#endif /* not GNU C */
#endif /* alloca not defined */
#endif /* YYSTACK_USE_ALLOCA not defined */

#ifdef YYSTACK_USE_ALLOCA
#define YYSTACK_ALLOC alloca
#else
#define YYSTACK_ALLOC malloc
#endif

/* Note: there must be only one dollar sign in this file.
   It is replaced by the list of actions, each action
   as one case of the switch.  */

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	goto yyacceptlab
#define YYABORT 	goto yyabortlab
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
#ifdef YYLEX_PARAM
#define YYLEX		yylex(&yylval, &yylloc, YYLEX_PARAM)
#else
#define YYLEX		yylex(&yylval, &yylloc)
#endif
#else /* not YYLSP_NEEDED */
#ifdef YYLEX_PARAM
#define YYLEX		yylex(&yylval, YYLEX_PARAM)
#else
#define YYLEX		yylex(&yylval)
#endif
#endif /* not YYLSP_NEEDED */
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

/* Define __yy_memcpy.  Note that the size argument
   should be passed with type unsigned int, because that is what the non-GCC
   definitions require.  With GCC, __builtin_memcpy takes an arg
   of type size_t, but it can handle unsigned int.  */

#if __GNUC__ > 1		/* GNU C and GNU C++ define this.  */
#define __yy_memcpy(TO,FROM,COUNT)	__builtin_memcpy(TO,FROM,COUNT)
#else				/* not GNU C or C++ */
#ifndef __cplusplus

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_memcpy (to, from, count)
     char *to;
     char *from;
     unsigned int count;
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
__yy_memcpy (char *to, char *from, unsigned int count)
{
  register char *t = to;
  register char *f = from;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#endif
#endif

#line 216 "/gg/share/bison.simple"

/* The user can define YYPARSE_PARAM as the name of an argument to be passed
   into yyparse.  The argument should have type void *.
   It should actually point to an object.
   Grammar actions can access the variable by casting it
   to the proper pointer type.  */

#ifdef YYPARSE_PARAM
#ifdef __cplusplus
#define YYPARSE_PARAM_ARG void *YYPARSE_PARAM
#define YYPARSE_PARAM_DECL
#else /* not __cplusplus */
#define YYPARSE_PARAM_ARG YYPARSE_PARAM
#define YYPARSE_PARAM_DECL void *YYPARSE_PARAM;
#endif /* not __cplusplus */
#else /* not YYPARSE_PARAM */
#define YYPARSE_PARAM_ARG
#define YYPARSE_PARAM_DECL
#endif /* not YYPARSE_PARAM */

/* Prevent warning if -Wstrict-prototypes.  */
#ifdef __GNUC__
#ifdef YYPARSE_PARAM
int yyparse (void *);
#else
int yyparse (void);
#endif
#endif

int
yyparse(YYPARSE_PARAM_ARG)
     YYPARSE_PARAM_DECL
{
  register int yystate;
  register int yyn;
  register short *yyssp;
  register YYSTYPE *yyvsp;
  int yyerrstatus;	/*  number of tokens to shift before error messages enabled */
  int yychar1 = 0;		/*  lookahead token as an internal (translated) token number */

  short	yyssa[YYINITDEPTH];	/*  the state stack			*/
  YYSTYPE yyvsa[YYINITDEPTH];	/*  the semantic value stack		*/

  short *yyss = yyssa;		/*  refer to the stacks thru separate pointers */
  YYSTYPE *yyvs = yyvsa;	/*  to allow yyoverflow to reallocate them elsewhere */

#ifdef YYLSP_NEEDED
  YYLTYPE yylsa[YYINITDEPTH];	/*  the location stack			*/
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;

#define YYPOPSTACK   (yyvsp--, yyssp--, yylsp--)
#else
#define YYPOPSTACK   (yyvsp--, yyssp--)
#endif

  int yystacksize = YYINITDEPTH;
  int yyfree_stacks = 0;

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
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

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
#ifdef YYLSP_NEEDED
      /* This used to be a conditional around just the two extra args,
	 but that might be undefined if yyoverflow is a macro.  */
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
		 &yyls1, size * sizeof (*yylsp),
		 &yystacksize);
#else
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
		 &yystacksize);
#endif

      yyss = yyss1; yyvs = yyvs1;
#ifdef YYLSP_NEEDED
      yyls = yyls1;
#endif
#else /* no yyoverflow */
      /* Extend the stack our own way.  */
      if (yystacksize >= YYMAXDEPTH)
	{
	  yyerror("parser stack overflow");
	  if (yyfree_stacks)
	    {
	      free (yyss);
	      free (yyvs);
#ifdef YYLSP_NEEDED
	      free (yyls);
#endif
	    }
	  return 2;
	}
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;
#ifndef YYSTACK_USE_ALLOCA
      yyfree_stacks = 1;
#endif
      yyss = (short *) YYSTACK_ALLOC (yystacksize * sizeof (*yyssp));
      __yy_memcpy ((char *)yyss, (char *)yyss1,
		   size * (unsigned int) sizeof (*yyssp));
      yyvs = (YYSTYPE *) YYSTACK_ALLOC (yystacksize * sizeof (*yyvsp));
      __yy_memcpy ((char *)yyvs, (char *)yyvs1,
		   size * (unsigned int) sizeof (*yyvsp));
#ifdef YYLSP_NEEDED
      yyls = (YYLTYPE *) YYSTACK_ALLOC (yystacksize * sizeof (*yylsp));
      __yy_memcpy ((char *)yyls, (char *)yyls1,
		   size * (unsigned int) sizeof (*yylsp));
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

  goto yybackup;
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
	{
	  fprintf (stderr, "Next token is %d (%s", yychar, yytname[yychar1]);
	  /* Give the individual parser a way to print the precise meaning
	     of a token, for further debugging info.  */
#ifdef YYPRINT
	  YYPRINT (stderr, yychar, yylval);
#endif
	  fprintf (stderr, ")\n");
	}
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
  if (yylen > 0)
    yyval = yyvsp[1-yylen]; /* implement default value of the action */

#if YYDEBUG != 0
  if (yydebug)
    {
      int i;

      fprintf (stderr, "Reducing via rule %d (line %d), ",
	       yyn, yyrline[yyn]);

      /* Print the symbols being reduced, and their result.  */
      for (i = yyprhs[yyn]; yyrhs[i] > 0; i++)
	fprintf (stderr, "%s ", yytname[yyrhs[i]]);
      fprintf (stderr, " -> %s\n", yytname[yyr1[yyn]]);
    }
#endif


  switch (yyn) {

case 5:
#line 164 "tg.y"
{ close_line( yyvsp[0].s.line, yyvsp[0].s.end ); ;
    break;}
case 6:
#line 167 "tg.y"
{          
                                    lt_set( line_table, yyvsp[0].l.line, yyvsp[0].l.cmd );
                                  ;
    break;}
case 7:
#line 170 "tg.y"
{ 
                                    add_cmd( line_table, yyvsp[0].l.line, yyvsp[0].l.cmd );
                                  ;
    break;}
case 8:
#line 176 "tg.y"
{ 
                                    yyval.l.line = yyvsp[0].s.line; 
                                    yyval.l.cmd = build_lcmd_c(0, yyvsp[0].s.start, yyvsp[0].s.end);
                                  ;
    break;}
case 9:
#line 180 "tg.y"
{ 
                                    /* dump_expression( $1.val ); */
                                    yyval.l.line = yyvsp[0].p.line; 
                                    yyval.l.cmd = build_lcmd_e(0, yyvsp[0].p.val, yyvsp[0].p.start, 
                                            yyvsp[0].p.end);
                                  ;
    break;}
case 10:
#line 186 "tg.y"
{ 
                                    yyval.l.line = yyvsp[-1].l.line;
                                    yyval.l.cmd = build_lcmd_c(yyvsp[-1].l.cmd, 
                                            yyvsp[0].s.start, yyvsp[0].s.end);
                                  ;
    break;}
case 11:
#line 191 "tg.y"
{ 
                                    /* dump_expression( $2.val ); */
                                    yyval.l.line = yyvsp[-1].l.line; 
                                    yyval.l.cmd = build_lcmd_e(yyvsp[-1].l.cmd, yyvsp[0].p.val, yyvsp[0].p.start, yyvsp[0].p.end);
                                  ;
    break;}
case 12:
#line 198 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 13:
#line 199 "tg.y"
{ yyval.s.line=yyvsp[0].f.line;yyval.s.start=yyvsp[0].f.start;yyval.s.end=yyvsp[0].f.end; ;
    break;}
case 14:
#line 200 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 15:
#line 201 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 16:
#line 202 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 17:
#line 203 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 18:
#line 204 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 19:
#line 205 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 20:
#line 206 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 21:
#line 207 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 22:
#line 208 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 23:
#line 209 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 24:
#line 210 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 25:
#line 211 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 26:
#line 212 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 27:
#line 213 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 28:
#line 214 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 29:
#line 215 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 30:
#line 216 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 31:
#line 217 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 32:
#line 218 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 33:
#line 219 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 34:
#line 220 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 35:
#line 221 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 36:
#line 222 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 37:
#line 223 "tg.y"
{ yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 38:
#line 224 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 39:
#line 225 "tg.y"
{
                            yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 40:
#line 227 "tg.y"
{ 
                            yyval.s.line=yyvsp[0].i.line;yyval.s.start=yyvsp[0].i.start;yyval.s.end=yyvsp[0].i.end; ;
    break;}
case 41:
#line 229 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 42:
#line 230 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 43:
#line 231 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 44:
#line 232 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 45:
#line 233 "tg.y"
{ yyval.s.line=yyvsp[0].s.line;yyval.s.start=yyvsp[0].s.start;yyval.s.end=yyvsp[0].s.end; ;
    break;}
case 46:
#line 236 "tg.y"
{ 
                                          yyval.p.line = yyvsp[-1].s.line;
                                          yyval.p.start = yyvsp[-1].s.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_objexp( yyvsp[0].p.val );
                                       ;
    break;}
case 47:
#line 242 "tg.y"
{
                                          yyval.p.line = yyvsp[-3].s.line;
                                          yyval.p.start = yyvsp[-3].s.start;
                                          yyval.p.end = yyvsp[0].s.end;
                                          yyval.p.val = yyvsp[-1].p.val;
                                       ;
    break;}
case 48:
#line 248 "tg.y"
{ ERR(        
                                       "'(', '$' or object expected after '$'");
                                          yyval.p.val = 0; 
                                       ;
    break;}
case 49:
#line 254 "tg.y"
{
                                          yyval.p.line = yyvsp[0].p.line;
                                          yyval.p.start = yyvsp[0].p.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_object( 0, yyvsp[0].p.val );
                                       ;
    break;}
case 50:
#line 260 "tg.y"
{ 
                                          yyval.p.line = yyvsp[-2].p.line; 
                                          yyval.p.start = yyvsp[-2].p.start;
                                          yyval.p.end = yyvsp[0].p.end; 
                                          yyval.p.val = new_object(yyvsp[-2].p.val, yyvsp[0].p.val);
                                       ;
    break;}
case 51:
#line 266 "tg.y"
{ 
                                         ERR("object expected after '.'"); 
                                         yyval.p.val = 0;
                                       ;
    break;}
case 52:
#line 272 "tg.y"
{  yyval.i.val = 'e'; ;
    break;}
case 53:
#line 273 "tg.y"
{  yyval.i.val = '='; ;
    break;}
case 54:
#line 274 "tg.y"
{  yyval.i.val = '<'; ;
    break;}
case 55:
#line 275 "tg.y"
{  yyval.i.val = '>'; ;
    break;}
case 56:
#line 276 "tg.y"
{  yyval.i.val = '!'; ;
    break;}
case 57:
#line 277 "tg.y"
{  yyval.i.val = 'l'; ;
    break;}
case 58:
#line 278 "tg.y"
{  yyval.i.val = 'g'; ;
    break;}
case 59:
#line 279 "tg.y"
{  yyval.i.val = '1'; ;
    break;}
case 60:
#line 280 "tg.y"
{  yyval.i.val = '2'; ;
    break;}
case 61:
#line 281 "tg.y"
{  yyval.i.val = '3'; ;
    break;}
case 62:
#line 282 "tg.y"
{  yyval.i.val = '4'; ;
    break;}
case 63:
#line 283 "tg.y"
{  yyval.i.val = '|'; ;
    break;}
case 64:
#line 284 "tg.y"
{  yyval.i.val = '&'; ;
    break;}
case 66:
#line 288 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].p.line;
                                          yyval.p.start = yyvsp[-2].p.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_exp(yyvsp[-2].p.val, yyvsp[-1].i.val, yyvsp[0].p.val);
                                       ;
    break;}
case 68:
#line 297 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].p.line; 
                                          yyval.p.start = yyvsp[-2].p.start;
                                          yyval.p.end = yyvsp[0].p.end; 
                                          yyval.p.val = new_exp(yyvsp[-2].p.val, '+', yyvsp[0].p.val);
                                       ;
    break;}
case 69:
#line 303 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].p.line; 
                                          yyval.p.start = yyvsp[-2].p.start;
                                          yyval.p.end = yyvsp[0].p.end; 
                                          yyval.p.val = new_exp(yyvsp[-2].p.val, '-', yyvsp[0].p.val);
                                       ;
    break;}
case 70:
#line 309 "tg.y"
{  
                                          ERR("expression expected after '+'"); 
                                          yyval.p.val = 0;
                                       ;
    break;}
case 71:
#line 313 "tg.y"
{  
                                          ERR("expression expected after '-'"); 
                                          yyval.p.val = 0;
                                       ;
    break;}
case 73:
#line 320 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].p.line; 
                                          yyval.p.start = yyvsp[-2].p.start;
                                          yyval.p.end = yyvsp[0].p.end; 
                                          yyval.p.val = new_exp(yyvsp[-2].p.val, '*', yyvsp[0].p.val);
                                       ;
    break;}
case 74:
#line 326 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].p.line; 
                                          yyval.p.start = yyvsp[-2].p.start;
                                          yyval.p.end = yyvsp[0].p.end; 
                                          yyval.p.val = new_exp(yyvsp[-2].p.val, '/', yyvsp[0].p.val);
                                       ;
    break;}
case 75:
#line 332 "tg.y"
{  ERR("expression expected after '*'");
                                          yyval.p.val = 0;
                                       ;
    break;}
case 76:
#line 335 "tg.y"
{  ERR("expression expected after '/'");
                                          yyval.p.val = 0;
                                       ;
    break;}
case 77:
#line 340 "tg.y"
{  yyval.p.line = yyvsp[0].p.line;
                                          yyval.p.start = yyvsp[0].p.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_explist( 0, yyvsp[0].p.val );
                                       ;
    break;}
case 78:
#line 345 "tg.y"
{  yyval.p.line = yyvsp[-2].p.line;
                                          yyval.p.start = yyvsp[-2].p.start;
                                          yyval.p.end = yyvsp[-2].p.end;
                                          yyval.p.val = new_explist(yyvsp[-2].p.val, yyvsp[0].p.val);
                                       ;
    break;}
case 79:
#line 352 "tg.y"
{  yyval.p.line = yyvsp[-2].s.line;
                                          yyval.p.start = yyvsp[-2].s.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_fldlist( 0, yyvsp[-2].s.val,
                                                  yyvsp[0].p.val );
                                       ;
    break;}
case 80:
#line 358 "tg.y"
{
                                          yyval.p.line = yyvsp[-4].p.line; 
                                          yyval.p.start = yyvsp[-4].p.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_fldlist( yyvsp[-4].p.val, yyvsp[-2].s.val,
                                                      yyvsp[0].p.val );
                                       ;
    break;}
case 81:
#line 367 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].s.line;
                                          yyval.p.start = yyvsp[-2].s.start;
                                          yyval.p.end = yyvsp[0].s.end;
                                          yyval.p.val = new_array( yyvsp[-1].p.val );
                                       ;
    break;}
case 82:
#line 373 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].s.line;
                                          yyval.p.start = yyvsp[-2].s.start;
                                          yyval.p.end = yyvsp[0].s.end;
                                          yyval.p.val = new_record( yyvsp[-1].p.val );
                                       ;
    break;}
case 83:
#line 379 "tg.y"
{  ERR("error in array definition");
                                          yyval.p.val = 0;
                                          yyval.p.line = yyvsp[-1].s.line;
                                       ;
    break;}
case 86:
#line 387 "tg.y"
{ 
                                          yyval.p.line = yyvsp[-1].p.line;
                                          yyval.p.start = yyvsp[-1].p.start;
                                          yyval.p.end = yyvsp[0].i.end;
                                          yyval.p.val = new_inc( yyvsp[-1].p.val, +1, 1 );
                                       ;
    break;}
case 87:
#line 393 "tg.y"
{
                                          yyval.p.line = yyvsp[-1].i.line;
                                          yyval.p.start = yyvsp[-1].i.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_inc( yyvsp[0].p.val, +1, 0 );
                                       ;
    break;}
case 88:
#line 399 "tg.y"
{
                                          yyval.p.line = yyvsp[-1].i.line;
                                          yyval.p.start = yyvsp[-1].i.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_exp( 0, 'n', yyvsp[0].p.val);
                                       ;
    break;}
case 89:
#line 405 "tg.y"
{
                                          yyval.p.line = yyvsp[-1].s.line;
                                          yyval.p.start = yyvsp[-1].s.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_exp( 0, '-', yyvsp[0].p.val);
                                       ;
    break;}
case 90:
#line 411 "tg.y"
{ 
                                          yyval.p.line = yyvsp[-1].p.line;
                                          yyval.p.start = yyvsp[-1].p.start;
                                          yyval.p.end = yyvsp[0].i.end;
                                          yyval.p.val = new_inc( yyvsp[-1].p.val, -1, 1 );
                                       ;
    break;}
case 91:
#line 417 "tg.y"
{
                                          yyval.p.line = yyvsp[-1].i.line;
                                          yyval.p.start = yyvsp[-1].i.start;
                                          yyval.p.end = yyvsp[0].p.end;
                                          yyval.p.val = new_inc( yyvsp[0].p.val, -1, 0 );
                                       ;
    break;}
case 92:
#line 423 "tg.y"
{   
                                          yyval.p.line = yyvsp[0].i.line; 
                                          yyval.p.start = yyvsp[0].i.start;
                                          yyval.p.end = yyvsp[0].i.end; 
                                          yyval.p.val = new_num(yyvsp[0].i.val);
                                       ;
    break;}
case 93:
#line 429 "tg.y"
{
                                          yyval.p.line = yyvsp[0].f.line; 
                                          yyval.p.start = yyvsp[0].f.start;
                                          yyval.p.end = yyvsp[0].f.end; 
                                          yyval.p.val = new_float(yyvsp[0].f.val);
                                       ;
    break;}
case 94:
#line 435 "tg.y"
{
                                          yyval.p.line = yyvsp[0].s.line; 
                                          yyval.p.start = yyvsp[0].s.start;
                                          yyval.p.end = yyvsp[0].s.end; 
                                          yyval.p.val = new_string(yyvsp[0].s.val);
                                          if ( yyvsp[0].s.val ) {
                                              FREE( yyvsp[0].s.val );
                                              yyvsp[0].s.val = 0;
                                          }
                                       ;
    break;}
case 95:
#line 445 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].s.line; 
                                          yyval.p.start = yyvsp[-2].s.start;
                                          yyval.p.end = yyvsp[0].s.end; 
                                          yyval.p.val = yyvsp[-1].p.val;
                                       ;
    break;}
case 96:
#line 451 "tg.y"
{  ERR("expression expected after '('");
                                          yyval.p.val = 0;
                                       ;
    break;}
case 97:
#line 456 "tg.y"
{
                                          yyval.p.line = yyvsp[0].s.line; 
                                          yyval.p.start = yyvsp[0].s.start;
                                          yyval.p.end = yyvsp[0].s.end; 
                                          yyval.p.val = new_part(yyvsp[0].s.val);
                                          if ( yyvsp[0].s.val ) {
                                              FREE( yyvsp[0].s.val );
                                              yyvsp[0].s.val = 0;
                                          }
                                       ;
    break;}
case 98:
#line 466 "tg.y"
{  yyval.p.line = yyvsp[0].p.line;
                                          yyval.p.start = yyvsp[0].p.start;
                                          yyval.p.end = yyvsp[0].p.end; 
                                          yyval.p.val = new_exppart( yyvsp[0].p.val );
                                       ;
    break;}
case 99:
#line 471 "tg.y"
{
                                          yyval.p.line = yyvsp[-3].p.line; 
                                          yyval.p.start = yyvsp[-3].p.start;
                                          yyval.p.end = yyvsp[0].s.end; 
                                          yyval.p.val = new_fun( yyvsp[-3].p.val, yyvsp[-1].p.val );
                                       ;
    break;}
case 100:
#line 477 "tg.y"
{
                                          yyval.p.line = yyvsp[-3].p.line; 
                                          yyval.p.start = yyvsp[-3].p.start;
                                          yyval.p.end = yyvsp[0].s.end; 
                                          yyval.p.val = new_tab( yyvsp[-3].p.val, yyvsp[-1].p.val );
                                       ;
    break;}
case 101:
#line 483 "tg.y"
{  ERR("bad function call argument");
                                          yyval.p.val = 0;
                                       ;
    break;}
case 102:
#line 486 "tg.y"
{ ERR("expression expected after '['");
                                          yyval.p.val = 0;
                                       ;
    break;}
case 103:
#line 492 "tg.y"
{  yyval.p.val = 0; ;
    break;}
case 105:
#line 496 "tg.y"
{
                                          yyval.p.line = yyvsp[0].p.line; 
                                          yyval.p.start = yyvsp[0].p.start;
                                          yyval.p.end = yyvsp[0].p.end; 
                                          yyval.p.val = new_explist( 0, yyvsp[0].p.val );
                                       ;
    break;}
case 106:
#line 502 "tg.y"
{
                                          yyval.p.line = yyvsp[-2].p.line; 
                                          yyval.p.start = yyvsp[-2].p.start;
                                          yyval.p.end = yyvsp[0].p.end; 
                                          yyval.p.val = new_explist(yyvsp[-2].p.val, yyvsp[0].p.val);
                                       ;
    break;}
case 122:
#line 525 "tg.y"
{  yyval.l.line = yyvsp[0].i.line;
                                          yyval.l.cmd = 0; ;
    break;}
case 123:
#line 527 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                          ERR( "bad '@' command" );
                                          yyval.l.cmd = 0;
                                       ;
    break;}
case 124:
#line 533 "tg.y"
{
                                         yyval.l.line = yyvsp[-4].i.line;
                                         yyval.l.cmd=new_if(yyvsp[-3].p.val,yyvsp[0].i.line,yyvsp[0].i.line); 
                                       ;
    break;}
case 125:
#line 537 "tg.y"
{
                                         yyval.l.line = yyvsp[-7].i.line;
                                         yyval.l.cmd=new_if(yyvsp[-6].p.val,yyvsp[-3].i.line,yyvsp[0].i.line); 
                                       ;
    break;}
case 126:
#line 541 "tg.y"
{ ERR( "@if command malformed" );
                                         yyval.l.cmd = 0;
                                       ;
    break;}
case 127:
#line 546 "tg.y"
{ yyval.p.end = yyvsp[0].i.line; ;
    break;}
case 128:
#line 547 "tg.y"
{ ERR("@function not closed");
                                         yyval.p.val = 0; ;
    break;}
case 129:
#line 552 "tg.y"
{
                                      int _regres;
                                      yyval.l.line = yyvsp[-6].i.line;
                                      yyval.l.cmd = new_function( yyvsp[-5].s.val, yyvsp[-3].p.val,
                                              yyvsp[0].p.end ); 
                                      if ( regfun( yyvsp[-5].s.val, curfilen, 
                                                  yyvsp[-6].i.line ) == 2 ) 
                                          warning( "warning: function duplicated" );
                                      if ( yyvsp[-5].s.val ) FREE( yyvsp[-5].s.val );
                                    ;
    break;}
case 130:
#line 562 "tg.y"
{
                                      ERR("bad @function header");
                                      yyval.l.cmd = 0;
                                    ;
    break;}
case 131:
#line 568 "tg.y"
{ yyval.p.val = 0; ;
    break;}
case 133:
#line 572 "tg.y"
{ yyval.p.line = yyvsp[0].s.line;
                                      yyval.p.val = new_parlist( 0, yyvsp[0].s.val ); 
                                      if ( yyvsp[0].s.val ) FREE( yyvsp[0].s.val );
                                    ;
    break;}
case 134:
#line 576 "tg.y"
{
                                      yyval.p.line = yyvsp[-2].p.line;
                                      yyval.p.val = new_parlist( yyvsp[-2].p.val, yyvsp[0].s.val ); 
                                      if ( yyvsp[0].s.val ) FREE( yyvsp[0].s.val );
                                    ;
    break;}
case 135:
#line 583 "tg.y"
{
                                      yyval.l.line = yyvsp[-4].i.line;
                                      yyval.l.cmd = new_switch(yyvsp[-3].p.val,yyvsp[-1].p.val,
                                              yyvsp[-4].i.line,yyvsp[0].i.line);
                                    ;
    break;}
case 136:
#line 588 "tg.y"
{ ERR( "@case expected" );
                                      yyval.l.cmd = 0;
                                    ;
    break;}
case 137:
#line 593 "tg.y"
{  yyval.p.line = yyvsp[0].p.line;
                                      yyval.p.val = new_caselist(0,yyvsp[0].p.val,yyvsp[0].p.line);
                                   ;
    break;}
case 138:
#line 596 "tg.y"
{ yyval.p.line = yyvsp[-1].p.line;
                                      yyval.p.val = new_caselist(yyvsp[-1].p.val, 
                                              yyvsp[0].p.val, yyvsp[0].p.line );
                                   ;
    break;}
case 139:
#line 602 "tg.y"
{
                                      yyval.p.line = yyvsp[-3].p.line;
                                      yyval.p.val = yyvsp[-3].p.val;
                                   ;
    break;}
case 140:
#line 606 "tg.y"
{  ERR("after @case expected expression and ':'");
                                      yyval.p.val = 0;
                                   ;
    break;}
case 141:
#line 611 "tg.y"
{
                                      yyval.l.line = yyvsp[-4].i.line;
                                      yyval.l.cmd = new_for(yyvsp[-3].p.val, yyvsp[-4].i.line, yyvsp[0].i.line);
                                   ;
    break;}
case 142:
#line 615 "tg.y"
{  ERR( "bad @for command syntax" );
                                      yyval.l.cmd = 0; yyval.l.line = yyvsp[-1].i.line;
                                   ;
    break;}
case 143:
#line 620 "tg.y"
{
                                      yyval.p.line = yyvsp[-6].s.line;
                                      yyval.p.val = new_forctl(yyvsp[-5].p.val,yyvsp[-3].p.val,yyvsp[-1].p.val);
                                   ;
    break;}
case 144:
#line 624 "tg.y"
{
                                      yyval.p.line = yyvsp[-4].s.line;
                                      yyval.p.start = yyvsp[-4].s.start;
                                      yyval.p.end = yyvsp[0].s.end;
                                      yyval.p.val = new_lforctl(yyvsp[-3].p.val,yyvsp[-1].p.val);  
                                   ;
    break;}
case 145:
#line 630 "tg.y"
{  ERR( "bad @for command syntax" );
                                      yyval.p.val = 0;
                                   ;
    break;}
case 146:
#line 635 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_return( yyvsp[0].p.val );
                                   ;
    break;}
case 147:
#line 638 "tg.y"
{  ERR( "@return without argument" );
                                      yyval.l.cmd = 0;
                                   ;
    break;}
case 148:
#line 643 "tg.y"
{  yyval.l.line = yyvsp[0].i.line;
                                      yyval.l.cmd = new_break( yyvsp[0].i.line );
                                   ;
    break;}
case 149:
#line 648 "tg.y"
{  yyval.l.line = yyvsp[0].i.line;
                                      yyval.l.cmd = new_push();
                                   ;
    break;}
case 150:
#line 653 "tg.y"
{  yyval.l.line = yyvsp[0].i.line;
                                      yyval.l.cmd = new_pop();
                                   ;
    break;}
case 151:
#line 658 "tg.y"
{  yyval.p.val = 0;  ;
    break;}
case 153:
#line 660 "tg.y"
{  ERR( "expression expected" );
                                      yyval.p.val = 0; 
                                   ;
    break;}
case 154:
#line 665 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_cmdexp( yyvsp[0].p.val ); ;
    break;}
case 155:
#line 669 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_embed( yyvsp[0].p.val ); ;
    break;}
case 156:
#line 673 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_emit( yyvsp[0].p.val ); ;
    break;}
case 157:
#line 677 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_output( yyvsp[0].p.val ); ;
    break;}
case 158:
#line 681 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_local( yyvsp[0].s.val ); ;
    break;}
case 159:
#line 685 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_use( yyvsp[0].s.val ); ;
    break;}
case 160:
#line 687 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_use( unquote(yyvsp[0].s.val) );
                                      if (yyvsp[0].s.val) FREE(yyvsp[0].s.val);
                                   ;
    break;}
case 161:
#line 693 "tg.y"
{  yyval.l.line = yyvsp[0].i.line;
                                      yyval.l.cmd = new_exit( 0 );
                                   ;
    break;}
case 162:
#line 696 "tg.y"
{  yyval.l.line = yyvsp[-1].i.line;
                                      yyval.l.cmd = new_exit( yyvsp[0].p.val );
                                   ;
    break;}
}
   /* the action file gets copied in in place of this dollarsign */
#line 542 "/gg/share/bison.simple"

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
	  /* Start X at -yyn if nec to avoid negative indexes in yycheck.  */
	  for (x = (yyn < 0 ? -yyn : 0);
	       x < (sizeof(yytname) / sizeof(char *)); x++)
	    if (yycheck[x + yyn] == x)
	      size += strlen(yytname[x]) + 15, count++;
	  msg = (char *) malloc(size + 15);
	  if (msg != 0)
	    {
	      strcpy(msg, "parse error");

	      if (count < 5)
		{
		  count = 0;
		  for (x = (yyn < 0 ? -yyn : 0);
		       x < (sizeof(yytname) / sizeof(char *)); x++)
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
	    yyerror ("parse error; also virtual memory exceeded");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror("parse error");
    }

  goto yyerrlab1;
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

 yyacceptlab:
  /* YYACCEPT comes here.  */
  if (yyfree_stacks)
    {
      free (yyss);
      free (yyvs);
#ifdef YYLSP_NEEDED
      free (yyls);
#endif
    }
  return 0;

 yyabortlab:
  /* YYABORT comes here.  */
  if (yyfree_stacks)
    {
      free (yyss);
      free (yyvs);
#ifdef YYLSP_NEEDED
      free (yyls);
#endif
    }
  return 1;
}
#line 701 "tg.y"
