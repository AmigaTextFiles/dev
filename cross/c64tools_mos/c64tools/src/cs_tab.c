
/*  A Bison parser, made from cs.y with Bison version GNU Bison version 1.24
  */

#define YYBISON 1  /* Identify Bison output.  */

#define	FLUSH	258
#define	INCLUDE	259
#define	LOADPTR	260
#define	CHUNK	261
#define	SWITCH	262
#define	CASE	263
#define	DEFAULT	264
#define	ALIAS	265
#define	ASSIGN	266
#define	ADDASSIGN	267
#define	SUBASSIGN	268
#define	MULASSIGN	269
#define	DIVASSIGN	270
#define	MODASSIGN	271
#define	ANDASSIGN	272
#define	ORASSIGN	273
#define	EORASSIGN	274
#define	SHIFTLASSIGN	275
#define	SHIFTRASSIGN	276
#define	EQ	277
#define	NE	278
#define	GTE	279
#define	LTE	280
#define	GT	281
#define	LT	282
#define	INC	283
#define	DEC	284
#define	ADD	285
#define	SUB	286
#define	MUL	287
#define	DIV	288
#define	MOD	289
#define	AND	290
#define	OR	291
#define	BOOLAND	292
#define	BOOLOR	293
#define	BOOLNOT	294
#define	EOR	295
#define	LEFT	296
#define	RIGHT	297
#define	LEFTBR	298
#define	RIGHTBR	299
#define	LEFTCOMP	300
#define	RIGHTCOMP	301
#define	SHIFTL	302
#define	SHIFTR	303
#define	COMMA	304
#define	DBLCOLON	305
#define	CONSTANT	306
#define	VAR	307
#define	EXTERN	308
#define	ENDSTAT	309
#define	IF	310
#define	ELSE	311
#define	WHILE	312
#define	DO	313
#define	FOR	314
#define	GOTO	315
#define	DATA	316
#define	STOP	317
#define	BREAK	318
#define	RETURN	319
#define	NUMBER	320
#define	NAME	321
#define	STRING	322

#line 1 "cs.y"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <ctype.h>
#include "tree.h"
#include "types.h"
#include "codegen.h"

extern int onefile;
extern int lineno;
extern FILE *yyin;
extern FILE *yyout;
extern char *filename;
extern char *outname;
char *srcname = NULL;
FILE *yyasm = NULL;
FILE *yyextern = NULL;
treenode *tree = NULL;

extern int vars, varsize, pagesize, noconstants, debug, header;

int errors = 0;

void yyerror(char *str)
{
  fprintf(stdout,"error in %s, line %d: %s.\n", filename, lineno, str);
  errors++;
}

int yywrap()
{
	return 1;
}

int main(int argc, char *argv[])
{
  int c;
  for (c = 1; c < argc; c++)
  {
    if ((argv[c][0] == '-') || ((argv[c][0] == '/') && (strlen(argv[c]) > 1)))
    {
      int ch = tolower(argv[c][1]);
      switch(ch)
      {
        case 'c':
        noconstants = 1;
        break;

        case 'd':
        debug = 1;
        break;

        case 'h':
        header = 1;
        break;

        case 'l':
        yyasm = fopen(&argv[c][2], "wt");
        break;

        case 'o':
        onefile = 1;
        yyout = fopen(&argv[c][2], "wb");
        break;

        case 'p':
        sscanf(&argv[c][2], "%x", &pagesize);
        break;

        case 'v':
        sscanf(&argv[c][2], "%x,%x", &vars, &varsize);
        break;

        case 'e':
        yyextern = fopen(&argv[c][2], "rt");
        break;
      }
    }
    else
    {
      if (!srcname) srcname = argv[c];
    }
  }

  if (!srcname)
  {
    printf("CovertScript compiler V1.0\n"
           "usage: cs <infile> [options]\n\n"
           "-c            Do not automatically import constants from extern file\n"
           "-d            Enable compiler debugging output\n"
           "-e<name>      Extern definition file name\n"
           "-h            Add chunk-header (for datafiles)\n"
           "-l<name>      Listing file name\n"
           "-o<name>      Output to one file, instead of multiple pages\n"
           "-p<val>       Bytecode page size in hex                  (default: 0400)\n"
           "-v<val>,<val> Startaddress & length for variables in hex (default: 0334,100)\n");
    return 1;
  }
  yyin = fopen(srcname, "rt");
  if (!yyin)
  {
    fprintf(stderr, "error: couldn't open input file %s\n", srcname);
    return 1;
  }
  filename = srcname;
  yyparse();
  if (errors) return 1;
  compile(tree);
  if (errors) return 1;
  else return 0;
}


#line 117 "cs.y"
typedef union
{
  int number;
  char *string;
  treenode *node;
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

#ifndef __cplusplus
#ifndef __STDC__
#define const
#endif
#endif



#define	YYFINAL		275
#define	YYFLAG		-32768
#define	YYNTBASE	68

#define YYTRANSLATE(x) ((unsigned)(x) <= 322 ? yytranslate[x] : 87)

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
    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,
    26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
    36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
    46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
    56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
    66,    67
};

#if YYDEBUG != 0
static const short yyprhs[] = {     0,
     0,     2,     5,     7,     9,    15,    22,    25,    27,    28,
    32,    34,    38,    41,    44,    48,    52,    56,    60,    64,
    68,    72,    76,    80,    84,    92,    94,   100,   104,   109,
   116,   121,   126,   130,   136,   143,   150,   158,   162,   167,
   174,   178,   185,   188,   192,   194,   197,   199,   202,   208,
   214,   222,   230,   236,   246,   254,   263,   272,   279,   287,
   295,   301,   305,   308,   314,   318,   321,   326,   330,   333,
   338,   341,   342,   344,   348,   350,   352,   355,   358,   360,
   365,   367,   369,   373,   377,   381,   385,   389,   393,   397,
   401,   404,   406,   411,   415,   420,   424,   428,   432,   436,
   440,   442,   446,   450,   452,   456,   460,   464,   467,   470,
   474,   476
};

static const short yyrhs[] = {    69,
     0,    69,    70,     0,    70,     0,    74,     0,    66,    41,
    72,    42,    75,     0,    66,    66,    41,    72,    42,    75,
     0,    71,    76,     0,    76,     0,     0,    72,    49,    81,
     0,    81,     0,    81,    11,    82,     0,    81,    28,     0,
    81,    29,     0,    81,    12,    82,     0,    81,    13,    82,
     0,    81,    14,    82,     0,    81,    15,    82,     0,    81,
    16,    82,     0,    81,    17,    82,     0,    81,    18,    82,
     0,    81,    19,    82,     0,    81,    20,    82,     0,    81,
    21,    82,     0,     6,    41,    82,    42,    45,    77,    46,
     0,     3,     0,    61,    41,    77,    42,    54,     0,    45,
    77,    46,     0,    66,    10,    66,    54,     0,    80,    61,
    41,    77,    42,    54,     0,    80,    45,    77,    46,     0,
    51,    66,    11,    82,     0,    51,    66,    82,     0,    66,
    41,    72,    42,    54,     0,    66,    66,    41,    72,    42,
    54,     0,    53,    66,    41,    72,    42,    54,     0,    53,
    66,    66,    41,    72,    42,    54,     0,    53,    66,    54,
     0,    53,    52,    66,    54,     0,    53,    52,    66,    43,
    44,    54,     0,    52,    66,    54,     0,    52,    66,    43,
    82,    44,    54,     0,    45,    46,     0,    45,    71,    46,
     0,    54,     0,    80,    76,     0,    75,     0,    73,    54,
     0,     5,    41,    81,    42,    54,     0,    55,    41,    82,
    42,    76,     0,    55,    41,    82,    42,    76,    56,    76,
     0,    58,    76,    57,    41,    82,    42,    54,     0,    57,
    41,    82,    42,    76,     0,    59,    41,    73,    54,    82,
    54,    73,    42,    76,     0,    59,    41,    54,    82,    54,
    42,    76,     0,    59,    41,    54,    82,    54,    73,    42,
    76,     0,    59,    41,    73,    54,    82,    54,    42,    76,
     0,    59,    41,    54,    54,    42,    76,     0,    59,    41,
    54,    54,    73,    42,    76,     0,    59,    41,    73,    54,
    54,    42,    76,     0,     7,    41,    82,    42,    76,     0,
     8,    82,    50,     0,     9,    50,     0,    66,    41,    77,
    42,    54,     0,    60,    66,    54,     0,    64,    54,     0,
    64,    41,    42,    54,     0,    64,    82,    54,     0,    62,
    54,     0,    62,    41,    42,    54,     0,    63,    54,     0,
     0,    82,     0,    77,    49,    82,     0,    67,     0,    78,
     0,    79,    78,     0,    66,    50,     0,    66,     0,    66,
    43,    82,    44,     0,    83,     0,    79,     0,    83,    22,
    83,     0,    83,    23,    83,     0,    83,    26,    83,     0,
    83,    27,    83,     0,    83,    24,    83,     0,    83,    25,
    83,     0,    83,    38,    83,     0,    83,    37,    83,     0,
    39,    83,     0,    84,     0,    61,    41,    77,    42,     0,
    45,    77,    46,     0,    66,    41,    77,    42,     0,    83,
    47,    84,     0,    83,    48,    84,     0,    83,    40,    84,
     0,    83,    36,    84,     0,    83,    35,    84,     0,    85,
     0,    84,    30,    85,     0,    84,    31,    85,     0,    86,
     0,    85,    34,    86,     0,    85,    33,    86,     0,    85,
    32,    86,     0,    30,    86,     0,    31,    86,     0,    41,
    82,    42,     0,    65,     0,    81,     0
};

#endif

#if YYDEBUG != 0
static const short yyrline[] = { 0,
   217,   224,   229,   235,   240,   246,   254,   259,   265,   270,
   274,   280,   285,   289,   293,   298,   303,   308,   313,   318,
   323,   328,   333,   338,   345,   350,   354,   358,   362,   368,
   373,   378,   383,   388,   394,   400,   406,   412,   417,   422,
   427,   432,   439,   444,   450,   455,   460,   464,   468,   472,
   476,   480,   484,   488,   492,   497,   502,   507,   512,   517,
   522,   526,   530,   534,   539,   544,   548,   552,   556,   560,
   564,   570,   575,   579,   585,   593,   598,   604,   611,   617,
   624,   629,   633,   637,   641,   645,   649,   653,   657,   661,
   665,   671,   676,   680,   684,   689,   693,   697,   701,   705,
   711,   716,   720,   726,   731,   735,   739,   745,   750,   754,
   758,   763
};

static const char * const yytname[] = {   "$","error","$undefined.","FLUSH",
"INCLUDE","LOADPTR","CHUNK","SWITCH","CASE","DEFAULT","ALIAS","ASSIGN","ADDASSIGN",
"SUBASSIGN","MULASSIGN","DIVASSIGN","MODASSIGN","ANDASSIGN","ORASSIGN","EORASSIGN",
"SHIFTLASSIGN","SHIFTRASSIGN","EQ","NE","GTE","LTE","GT","LT","INC","DEC","ADD",
"SUB","MUL","DIV","MOD","AND","OR","BOOLAND","BOOLOR","BOOLNOT","EOR","LEFT",
"RIGHT","LEFTBR","RIGHTBR","LEFTCOMP","RIGHTCOMP","SHIFTL","SHIFTR","COMMA",
"DBLCOLON","CONSTANT","VAR","EXTERN","ENDSTAT","IF","ELSE","WHILE","DO","FOR",
"GOTO","DATA","STOP","BREAK","RETURN","NUMBER","NAME","STRING","program","units",
"unit","statements","identifiers","assignment","declaration","compstatement",
"statement","expressions","string","strings","label","identifier","expression",
"expr","expr2","expr3","expr4",""
};
#endif

static const short yyr1[] = {     0,
    68,    69,    69,    70,    70,    70,    71,    71,    72,    72,
    72,    73,    73,    73,    73,    73,    73,    73,    73,    73,
    73,    73,    73,    73,    74,    74,    74,    74,    74,    74,
    74,    74,    74,    74,    74,    74,    74,    74,    74,    74,
    74,    74,    75,    75,    76,    76,    76,    76,    76,    76,
    76,    76,    76,    76,    76,    76,    76,    76,    76,    76,
    76,    76,    76,    76,    76,    76,    76,    76,    76,    76,
    76,    77,    77,    77,    78,    79,    79,    80,    81,    81,
    82,    82,    82,    82,    82,    82,    82,    82,    82,    82,
    82,    83,    83,    83,    83,    83,    83,    83,    83,    83,
    84,    84,    84,    85,    85,    85,    85,    86,    86,    86,
    86,    86
};

static const short yyr2[] = {     0,
     1,     2,     1,     1,     5,     6,     2,     1,     0,     3,
     1,     3,     2,     2,     3,     3,     3,     3,     3,     3,
     3,     3,     3,     3,     7,     1,     5,     3,     4,     6,
     4,     4,     3,     5,     6,     6,     7,     3,     4,     6,
     3,     6,     2,     3,     1,     2,     1,     2,     5,     5,
     7,     7,     5,     9,     7,     8,     8,     6,     7,     7,
     5,     3,     2,     5,     3,     2,     4,     3,     2,     4,
     2,     0,     1,     3,     1,     1,     2,     2,     1,     4,
     1,     1,     3,     3,     3,     3,     3,     3,     3,     3,
     2,     1,     4,     3,     4,     3,     3,     3,     3,     3,
     1,     3,     3,     1,     3,     3,     3,     2,     2,     3,
     1,     1
};

static const short yydefact[] = {     0,
    26,     0,    72,     0,     0,     0,     0,     0,     1,     3,
     4,     0,     0,     0,     0,     0,     0,    72,     0,   111,
    79,    75,     0,    76,    82,   112,    73,    81,    92,   101,
   104,     0,     0,     0,     0,    72,     0,     9,    78,     0,
     2,    72,     0,     0,    79,   108,   109,    91,     0,     0,
    72,    72,     0,    28,     0,    77,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,    33,     0,    41,     0,     9,
    38,     0,     0,     0,     0,    11,     9,     0,    72,     0,
   110,    94,     0,     0,     0,    74,    83,    84,    87,    88,
    85,    86,   100,    99,    90,    89,    98,    96,    97,   102,
   103,   107,   106,   105,    32,     0,     0,    39,     0,     9,
     0,    29,     0,     0,     0,    31,     0,    72,    93,    95,
    80,     0,     0,     0,     0,    27,     0,    34,     5,    10,
     0,     0,     0,    42,    40,    36,     0,     0,     0,     0,
     0,    43,    45,     0,     0,     0,     0,     0,     0,     0,
     0,    79,     0,     0,    47,     8,     0,     0,    35,     6,
    30,    25,    37,     0,     0,     0,    63,     0,     0,     0,
     0,     0,     0,    69,    71,     0,    66,     0,    72,    44,
     7,    48,    46,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,    13,    14,     0,     0,    62,     0,
     0,     0,     0,     0,    65,     0,     0,    68,     0,    12,
    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
     0,     0,     0,     0,     0,     0,     0,     0,    70,    67,
     0,    49,    61,    50,    53,     0,     0,     0,     0,     0,
     0,    64,     0,     0,    58,     0,     0,     0,     0,     0,
    51,    52,    59,    55,     0,    60,     0,     0,    56,    57,
     0,    54,     0,     0,     0
};

static const short yydefgoto[] = {   273,
     9,    10,   163,    85,   164,    11,   165,   166,    23,    24,
    25,   167,    26,    27,    28,    29,    30,    31
};

static const short yypact[] = {     0,
-32768,    -9,   320,   -51,   -30,   -39,     3,    -2,     0,-32768,
-32768,   -28,   320,    -6,    -6,   327,   320,   320,    21,-32768,
    13,-32768,    56,-32768,     7,-32768,-32768,   372,   177,    46,
-32768,    65,    40,    31,   -20,   320,    54,    58,-32768,    96,
-32768,   320,   100,   135,   107,-32768,-32768,    37,   139,    73,
   320,   320,   320,-32768,   320,-32768,   327,   327,   327,   327,
   327,   327,    -6,    -6,   327,   327,    -6,    -6,    -6,    -6,
    -6,    -6,    -6,    -6,   320,-32768,   320,-32768,    44,    58,
-32768,   152,    86,   156,    97,-32768,    58,   113,   320,   171,
-32768,-32768,    98,   109,   153,-32768,    37,    37,    37,    37,
    37,    37,   177,   177,    37,    37,   177,   177,   177,    46,
    46,-32768,-32768,-32768,-32768,   173,   176,-32768,   123,    58,
   170,-32768,    47,    58,   129,-32768,   131,   320,-32768,-32768,
-32768,   180,   181,   182,   157,-32768,   195,-32768,-32768,-32768,
    62,   183,   130,-32768,-32768,-32768,   184,   198,   201,   320,
   175,-32768,-32768,   202,   204,   239,   210,   190,    17,   206,
   276,    50,   223,   208,-32768,-32768,   239,   410,-32768,-32768,
-32768,-32768,-32768,    58,   320,   213,-32768,   320,   320,   207,
   -36,   211,   231,-32768,-32768,   103,-32768,   220,   320,-32768,
-32768,-32768,-32768,   320,   320,   320,   320,   320,   320,   320,
   320,   320,   320,   320,-32768,-32768,   233,   234,-32768,   237,
   246,   249,   279,   238,-32768,   241,   250,-32768,   163,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
   254,   239,   239,   239,   320,   -26,   257,   308,-32768,-32768,
   258,-32768,-32768,   235,-32768,   271,   239,   272,   -16,   274,
   265,-32768,   239,   268,-32768,   239,   239,   281,   239,   -11,
-32768,-32768,-32768,-32768,   239,-32768,   239,   283,-32768,-32768,
   239,-32768,   300,   326,-32768
};

static const short yypgoto[] = {-32768,
-32768,   318,-32768,   -73,  -179,-32768,  -112,  -144,   -14,   303,
-32768,   108,   -38,   -12,    95,   203,   143,    -5
};


#define	YYLAST		439


static const short yytable[] = {    86,
    44,   214,     1,    50,    49,     2,   119,    37,    46,    47,
   139,   180,    34,   125,    32,   247,    42,   213,   191,    76,
    80,    83,   193,    14,    15,   257,    35,    88,   170,    45,
   267,    13,    43,    81,    17,    33,    93,    94,    38,    45,
    95,    86,    96,    36,     3,    82,   135,    39,    86,    45,
     4,     5,     6,    52,    45,    53,   248,   183,    20,    45,
     7,    51,   115,    40,   116,     8,   112,   113,   114,   258,
   184,    63,    64,    22,   127,    75,    67,    72,    73,    74,
   268,    86,    77,    68,    69,   140,   117,   243,   244,   245,
   189,   137,    53,    78,    14,    15,    79,   118,   168,    39,
   138,    54,   255,    16,    55,    17,   137,    12,   261,    18,
    48,   263,   264,   143,   266,   169,    12,   168,    92,    84,
   269,    55,   270,    45,   168,    19,   272,   121,   168,    20,
    21,    22,    14,    15,    55,   207,    87,   176,   123,   129,
    89,    16,   168,    17,   217,   124,    55,    18,   188,    53,
   130,    97,    98,    99,   100,   101,   102,    55,   126,   105,
   106,    55,   208,    19,   134,   210,   211,    20,    21,    22,
   141,   124,   142,    49,   219,   172,    90,   124,    55,    55,
    91,   220,   221,   222,   223,   224,   225,   226,   227,   228,
   229,   230,   120,   168,   168,   168,   131,   168,   147,   148,
   237,   149,   150,   151,   241,   124,    70,    71,   168,   122,
   168,    55,   110,   111,   168,   128,   132,   168,   168,   133,
   168,   168,   246,   136,   177,   251,   168,   148,   168,   149,
   150,   151,   168,   144,   145,   146,   171,   173,   174,   137,
   152,   175,   178,   148,   179,   149,   150,   151,   153,   154,
   181,   155,   156,   157,   158,   182,   159,   160,   161,   185,
   162,   192,   209,   212,   215,   103,   104,   137,   190,   107,
   108,   109,   216,   218,   231,   232,   153,   154,   233,   155,
   156,   157,   158,   137,   159,   160,   161,   234,   162,   235,
   253,   238,   153,   154,   239,   155,   156,   157,   158,   274,
   159,   160,   161,   240,   162,    14,    15,   242,    14,    15,
   249,   252,   254,   256,    16,   259,   186,    16,   260,    17,
    18,   262,   265,    18,   271,   275,    41,    56,     0,   187,
     0,     0,   236,     0,     0,     0,    19,    14,    15,    19,
    20,    21,    22,    20,    21,    22,    16,     0,    17,    14,
    15,     0,    18,     0,     0,     0,    14,    15,    16,     0,
    17,   250,     0,     0,    18,     0,     0,    17,    19,     0,
     0,    18,    20,    21,    22,     0,     0,     0,     0,     0,
    19,     0,     0,     0,    20,    21,    22,    19,     0,     0,
     0,    20,    21,    57,    58,    59,    60,    61,    62,     0,
     0,     0,     0,     0,     0,     0,    63,    64,    65,    66,
     0,    67,     0,     0,     0,     0,     0,     0,    68,    69,
   194,   195,   196,   197,   198,   199,   200,   201,   202,   203,
   204,     0,     0,     0,     0,     0,     0,   205,   206
};

static const short yycheck[] = {    38,
    13,   181,     3,    18,    17,     6,    80,    10,    14,    15,
   123,   156,    52,    87,    66,    42,    45,    54,   163,    32,
    41,    36,   167,    30,    31,    42,    66,    42,   141,    66,
    42,    41,    61,    54,    41,    66,    51,    52,    41,    66,
    53,    80,    55,    41,    45,    66,   120,    50,    87,    66,
    51,    52,    53,    41,    66,    43,   236,    41,    65,    66,
    61,    41,    75,    66,    77,    66,    72,    73,    74,   249,
    54,    35,    36,    67,    89,    11,    40,    32,    33,    34,
   260,   120,    43,    47,    48,   124,    43,   232,   233,   234,
    41,    45,    43,    54,    30,    31,    66,    54,   137,    50,
    54,    46,   247,    39,    49,    41,    45,     0,   253,    45,
    16,   256,   257,   128,   259,    54,     9,   156,    46,    66,
   265,    49,   267,    66,   163,    61,   271,    42,   167,    65,
    66,    67,    30,    31,    49,   174,    41,   150,    42,    42,
    41,    39,   181,    41,    42,    49,    49,    45,   161,    43,
    42,    57,    58,    59,    60,    61,    62,    49,    46,    65,
    66,    49,   175,    61,    42,   178,   179,    65,    66,    67,
    42,    49,    42,   186,   189,    46,    42,    49,    49,    49,
    42,   194,   195,   196,   197,   198,   199,   200,   201,   202,
   203,   204,    41,   232,   233,   234,    44,   236,    42,     5,
   213,     7,     8,     9,    42,    49,    30,    31,   247,    54,
   249,    49,    70,    71,   253,    45,    44,   256,   257,    44,
   259,   260,   235,    54,    50,   238,   265,     5,   267,     7,
     8,     9,   271,    54,    54,    54,    54,    54,    41,    45,
    46,    41,    41,     5,    41,     7,     8,     9,    54,    55,
    41,    57,    58,    59,    60,    66,    62,    63,    64,    54,
    66,    54,    50,    57,    54,    63,    64,    45,    46,    67,
    68,    69,    42,    54,    42,    42,    54,    55,    42,    57,
    58,    59,    60,    45,    62,    63,    64,    42,    66,    41,
    56,    54,    54,    55,    54,    57,    58,    59,    60,     0,
    62,    63,    64,    54,    66,    30,    31,    54,    30,    31,
    54,    54,    42,    42,    39,    42,    41,    39,    54,    41,
    45,    54,    42,    45,    42,     0,     9,    25,    -1,    54,
    -1,    -1,    54,    -1,    -1,    -1,    61,    30,    31,    61,
    65,    66,    67,    65,    66,    67,    39,    -1,    41,    30,
    31,    -1,    45,    -1,    -1,    -1,    30,    31,    39,    -1,
    41,    54,    -1,    -1,    45,    -1,    -1,    41,    61,    -1,
    -1,    45,    65,    66,    67,    -1,    -1,    -1,    -1,    -1,
    61,    -1,    -1,    -1,    65,    66,    67,    61,    -1,    -1,
    -1,    65,    66,    22,    23,    24,    25,    26,    27,    -1,
    -1,    -1,    -1,    -1,    -1,    -1,    35,    36,    37,    38,
    -1,    40,    -1,    -1,    -1,    -1,    -1,    -1,    47,    48,
    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
    21,    -1,    -1,    -1,    -1,    -1,    -1,    28,    29
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "bison.simple"

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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

#ifndef alloca
#ifdef __GNUC__
#define alloca __builtin_alloca
#else /* not GNU C.  */
#if (!defined (__STDC__) && defined (sparc)) || defined (__sparc__) || defined (__sparc) || defined (__sgi)
#include <alloca.h>
#else /* not sparc */
#if defined (MSDOS) && !defined (__TURBOC__)
#include <malloc.h>
#else /* not MSDOS, or __TURBOC__ */
#if defined(_AIX)
#include <malloc.h>
 #pragma alloca
#else /* not MSDOS, __TURBOC__, or _AIX */
#ifdef __hpux
#ifdef __cplusplus
extern "C" {
void *alloca (unsigned int);
};
#else /* not __cplusplus */
void *alloca ();
#endif /* not __cplusplus */
#endif /* __hpux */
#endif /* not _AIX */
#endif /* not MSDOS, or __TURBOC__ */
#endif /* not sparc.  */
#endif /* not GNU C.  */
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

/* Prevent warning if -Wstrict-prototypes.  */
#ifdef __GNUC__
int yyparse (void);
#endif

#if __GNUC__ > 1		/* GNU C and GNU C++ define this.  */
#define __yy_memcpy(FROM,TO,COUNT)	__builtin_memcpy(TO,FROM,COUNT)
#else				/* not GNU C or C++ */
#ifndef __cplusplus

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_memcpy (from, to, count)
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
__yy_memcpy (char *from, char *to, int count)
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#endif
#endif

#line 192 "bison.simple"

/* The user can define YYPARSE_PARAM as the name of an argument to be passed
   into yyparse.  The argument should have type void *.
   It should actually point to an object.
   Grammar actions can access the variable by casting it
   to the proper pointer type.  */

#ifdef YYPARSE_PARAM
#define YYPARSE_PARAM_DECL void *YYPARSE_PARAM;
#else
#define YYPARSE_PARAM
#define YYPARSE_PARAM_DECL
#endif

int
yyparse(YYPARSE_PARAM)
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
	  return 2;
	}
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;
      yyss = (short *) alloca (yystacksize * sizeof (*yyssp));
      __yy_memcpy ((char *)yyss1, (char *)yyss, size * sizeof (*yyssp));
      yyvs = (YYSTYPE *) alloca (yystacksize * sizeof (*yyvsp));
      __yy_memcpy ((char *)yyvs1, (char *)yyvs, size * sizeof (*yyvsp));
#ifdef YYLSP_NEEDED
      yyls = (YYLTYPE *) alloca (yystacksize * sizeof (*yylsp));
      __yy_memcpy ((char *)yyls1, (char *)yyls, size * sizeof (*yylsp));
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

case 1:
#line 219 "cs.y"
{
    tree = yyvsp[0].node;
  ;
    break;}
case 2:
#line 226 "cs.y"
{
    yyval.node = node2(UNIT_SEQ, yyvsp[-1].node, yyvsp[0].node);
  ;
    break;}
case 3:
#line 230 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 4:
#line 237 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 5:
#line 241 "cs.y"
{
    yyval.node = node2(FUNCT_BODY, yyvsp[-2].node, yyvsp[0].node);
    yyval.node->label = yyvsp[-4].string;
    yyval.node->index = NULL;
  ;
    break;}
case 6:
#line 247 "cs.y"
{
    yyval.node = node2(FUNCT_BODY, yyvsp[-2].node, yyvsp[0].node);
    yyval.node->label = yyvsp[-5].string;
    yyval.node->index = yyvsp[-4].string;
  ;
    break;}
case 7:
#line 256 "cs.y"
{
    yyval.node = node2(STMT_SEQ, yyvsp[-1].node, yyvsp[0].node);
  ;
    break;}
case 8:
#line 260 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 9:
#line 267 "cs.y"
{
    yyval.node = node(EMPTY_STMT);
  ;
    break;}
case 10:
#line 271 "cs.y"
{
    yyval.node = node2(IDENT_SEQ, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 11:
#line 275 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 12:
#line 282 "cs.y"
{
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 13:
#line 286 "cs.y"
{
    yyval.node = node1(INCASSIGN_STMT, yyvsp[-1].node);
  ;
    break;}
case 14:
#line 290 "cs.y"
{
    yyval.node = node1(DECASSIGN_STMT, yyvsp[-1].node);
  ;
    break;}
case 15:
#line 294 "cs.y"
{
    treenode *temp = node2(ADD_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 16:
#line 299 "cs.y"
{
    treenode *temp = node2(SUB_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 17:
#line 304 "cs.y"
{
    treenode *temp = node2(MUL_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 18:
#line 309 "cs.y"
{
    treenode *temp = node2(DIV_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 19:
#line 314 "cs.y"
{
    treenode *temp = node2(MOD_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 20:
#line 319 "cs.y"
{
    treenode *temp = node2(AND_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 21:
#line 324 "cs.y"
{
    treenode *temp = node2(OR_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 22:
#line 329 "cs.y"
{
    treenode *temp = node2(EOR_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 23:
#line 334 "cs.y"
{
    treenode *temp = node2(SHIFTL_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 24:
#line 339 "cs.y"
{
    treenode *temp = node2(SHIFTR_EXPR, yyvsp[-2].node, yyvsp[0].node);
    yyval.node = node2(ASSIGN_STMT, yyvsp[-2].node, temp);
  ;
    break;}
case 25:
#line 347 "cs.y"
{
    yyval.node = node2(CHUNK_STMT, yyvsp[-4].node, yyvsp[-1].node);
  ;
    break;}
case 26:
#line 351 "cs.y"
{
    yyval.node = node(FLUSH_STMT);
  ;
    break;}
case 27:
#line 355 "cs.y"
{
    yyval.node = node1(DATA_STMT, yyvsp[-2].node);
  ;
    break;}
case 28:
#line 359 "cs.y"
{
    yyval.node = node1(DATA_STMT, yyvsp[-1].node);
  ;
    break;}
case 29:
#line 363 "cs.y"
{
    yyval.node = node(ALIAS_STMT);
    yyval.node->name = yyvsp[-3].string;
    yyval.node->index = yyvsp[-1].string;
   ;
    break;}
case 30:
#line 369 "cs.y"
{
    yyval.node = node1(DATA_STMT, yyvsp[-2].node);
    yyval.node->label = yyvsp[-5].string;
  ;
    break;}
case 31:
#line 374 "cs.y"
{
    yyval.node = node1(DATA_STMT, yyvsp[-1].node);
    yyval.node->label = yyvsp[-3].string;
  ;
    break;}
case 32:
#line 379 "cs.y"
{
    yyval.node = node1(CONSTANT_DEF, yyvsp[0].node);
    yyval.node->name = yyvsp[-2].string;
  ;
    break;}
case 33:
#line 384 "cs.y"
{
    yyval.node = node1(CONSTANT_DEF, yyvsp[0].node);
    yyval.node->name = yyvsp[-1].string;
  ;
    break;}
case 34:
#line 389 "cs.y"
{
    yyval.node = node1(FUNCT_DEF, yyvsp[-2].node);
    yyval.node->name = yyvsp[-4].string;
    yyval.node->index = NULL;
  ;
    break;}
case 35:
#line 395 "cs.y"
{
    yyval.node = node1(FUNCT_DEF, yyvsp[-2].node);
    yyval.node->name = yyvsp[-5].string;
    yyval.node->index = yyvsp[-4].string;
  ;
    break;}
case 36:
#line 401 "cs.y"
{
    yyval.node = node1(EXTFUNCT_DEF, yyvsp[-2].node);
    yyval.node->name = yyvsp[-4].string;
    yyval.node->index = NULL;
  ;
    break;}
case 37:
#line 407 "cs.y"
{
    yyval.node = node1(EXTFUNCT_DEF, yyvsp[-2].node);
    yyval.node->name = yyvsp[-5].string;
    yyval.node->index = yyvsp[-4].string;
  ;
    break;}
case 38:
#line 413 "cs.y"
{
    yyval.node = node(EXTERN_DEF);
    yyval.node->name = yyvsp[-1].string;
  ;
    break;}
case 39:
#line 418 "cs.y"
{
    yyval.node = node(EXTERN_DEF);
    yyval.node->name = yyvsp[-1].string;
  ;
    break;}
case 40:
#line 423 "cs.y"
{
    yyval.node = node(EXTERN_DEF);
    yyval.node->name = yyvsp[-3].string;
  ;
    break;}
case 41:
#line 428 "cs.y"
{
    yyval.node = node(GLOBAL_DEF);
    yyval.node->name = yyvsp[-1].string;
  ;
    break;}
case 42:
#line 433 "cs.y"
{
    yyval.node = node1(GLOBALARRAY_DEF, yyvsp[-2].node);
    yyval.node->name = yyvsp[-4].string;
  ;
    break;}
case 43:
#line 441 "cs.y"
{
    yyval.node = node(EMPTY_STMT);
  ;
    break;}
case 44:
#line 445 "cs.y"
{
    yyval.node = yyvsp[-1].node;
  ;
    break;}
case 45:
#line 452 "cs.y"
{
    yyval.node = node(EMPTY_STMT);
  ;
    break;}
case 46:
#line 456 "cs.y"
{
    yyval.node = yyvsp[0].node;
    yyval.node->label = yyvsp[-1].string;
  ;
    break;}
case 47:
#line 461 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 48:
#line 465 "cs.y"
{
    yyval.node = yyvsp[-1].node;
  ;
    break;}
case 49:
#line 469 "cs.y"
{
    yyval.node = node1(LOADPTR_STMT, yyvsp[-2].node);
  ;
    break;}
case 50:
#line 473 "cs.y"
{
    yyval.node = node2(IF_STMT, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 51:
#line 477 "cs.y"
{
    yyval.node = node3(IFELSE_STMT, yyvsp[-4].node, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 52:
#line 481 "cs.y"
{
    yyval.node = node2(REPWHILE_STMT, yyvsp[-5].node, yyvsp[-2].node);
  ;
    break;}
case 53:
#line 485 "cs.y"
{
    yyval.node = node2(WHILE_STMT, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 54:
#line 489 "cs.y"
{
    yyval.node = node4(FORNEXT_STMT, yyvsp[-6].node, yyvsp[-4].node, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 55:
#line 493 "cs.y"
{
    treenode *temp = node(EMPTY_STMT);
    yyval.node = node4(FORNEXT_STMT, temp, yyvsp[-3].node, temp, yyvsp[0].node);
  ;
    break;}
case 56:
#line 498 "cs.y"
{
    treenode *temp = node(EMPTY_STMT);
    yyval.node = node4(FORNEXT_STMT, temp, yyvsp[-4].node, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 57:
#line 503 "cs.y"
{
    treenode *temp = node(EMPTY_STMT);
    yyval.node = node4(FORNEXT_STMT, yyvsp[-5].node, yyvsp[-3].node, temp, yyvsp[0].node);
  ;
    break;}
case 58:
#line 508 "cs.y"
{
    treenode *temp = node(EMPTY_STMT);
    yyval.node = node4(FORNEXT_STMT, temp, temp, temp, yyvsp[0].node);
  ;
    break;}
case 59:
#line 513 "cs.y"
{
    treenode *temp = node(EMPTY_STMT);
    yyval.node = node4(FORNEXT_STMT, temp, temp, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 60:
#line 518 "cs.y"
{
    treenode *temp = node(EMPTY_STMT);
    yyval.node = node4(FORNEXT_STMT, yyvsp[-4].node, temp, temp, yyvsp[0].node);
  ;
    break;}
case 61:
#line 523 "cs.y"
{
    yyval.node = node2(SWITCH_STMT, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 62:
#line 527 "cs.y"
{
    yyval.node = node1(CASE_STMT, yyvsp[-1].node);
  ;
    break;}
case 63:
#line 531 "cs.y"
{
    yyval.node = node(DEFAULTCASE_STMT);
  ;
    break;}
case 64:
#line 535 "cs.y"
{
    yyval.node = node1(FUNCT_STMT, yyvsp[-2].node);
    yyval.node->name = yyvsp[-4].string;
  ;
    break;}
case 65:
#line 540 "cs.y"
{
    yyval.node = node(GOTO_STMT);
    yyval.node->name = yyvsp[-1].string;
  ;
    break;}
case 66:
#line 545 "cs.y"
{
    yyval.node = node(RETURN_STMT);
  ;
    break;}
case 67:
#line 549 "cs.y"
{
    yyval.node = node(RETURN_STMT);
  ;
    break;}
case 68:
#line 553 "cs.y"
{
    yyval.node = node1(RETURNEXPR_STMT, yyvsp[-1].node);
  ;
    break;}
case 69:
#line 557 "cs.y"
{
    yyval.node = node(STOP_STMT);
  ;
    break;}
case 70:
#line 561 "cs.y"
{
    yyval.node = node(STOP_STMT);
  ;
    break;}
case 71:
#line 565 "cs.y"
{
    yyval.node = node(BREAK_STMT);
  ;
    break;}
case 72:
#line 572 "cs.y"
{
    yyval.node = node(EMPTY_STMT);
  ;
    break;}
case 73:
#line 576 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 74:
#line 580 "cs.y"
{
    yyval.node = node2(EXPR_SEQ, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 75:
#line 587 "cs.y"
{
    yyval.node = node(STRINGDEF);
    yyval.node->name = yyvsp[0].string;
  ;
    break;}
case 76:
#line 595 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 77:
#line 599 "cs.y"
{
    yyval.node = node2(STRINGDEF_SEQ, yyvsp[-1].node, yyvsp[0].node);
  ;
    break;}
case 78:
#line 606 "cs.y"
{
    yyval.string = yyvsp[-1].string;
  ;
    break;}
case 79:
#line 613 "cs.y"
{
    yyval.node = node(ABS_IDENT);
    yyval.node->name = yyvsp[0].string;
  ;
    break;}
case 80:
#line 618 "cs.y"
{
    yyval.node = node1(SUB_IDENT, yyvsp[-1].node);
    yyval.node->name = yyvsp[-3].string;
  ;
    break;}
case 81:
#line 626 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 82:
#line 630 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 83:
#line 634 "cs.y"
{
    yyval.node = node2(EQ_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 84:
#line 638 "cs.y"
{
    yyval.node = node2(NE_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 85:
#line 642 "cs.y"
{
    yyval.node = node2(GT_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 86:
#line 646 "cs.y"
{
    yyval.node = node2(LT_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 87:
#line 650 "cs.y"
{
    yyval.node = node2(GTE_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 88:
#line 654 "cs.y"
{
    yyval.node = node2(LTE_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 89:
#line 658 "cs.y"
{
    yyval.node = node2(OR_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 90:
#line 662 "cs.y"
{
    yyval.node = node2(AND_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 91:
#line 666 "cs.y"
{
    yyval.node = node1(NOT_EXPR, yyvsp[0].node);
  ;
    break;}
case 92:
#line 673 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 93:
#line 677 "cs.y"
{
    yyval.node = node1(DATA_STMT, yyvsp[-1].node);
  ;
    break;}
case 94:
#line 681 "cs.y"
{
    yyval.node = node1(DATA_STMT, yyvsp[-1].node);
  ;
    break;}
case 95:
#line 685 "cs.y"
{
    yyval.node = node1(FUNCT_EXPR, yyvsp[-1].node);
    yyval.node->name = yyvsp[-3].string;
  ;
    break;}
case 96:
#line 690 "cs.y"
{
    yyval.node = node2(SHIFTL_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 97:
#line 694 "cs.y"
{
    yyval.node = node2(SHIFTR_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 98:
#line 698 "cs.y"
{
    yyval.node = node2(EOR_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 99:
#line 702 "cs.y"
{
    yyval.node = node2(OR_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 100:
#line 706 "cs.y"
{
    yyval.node = node2(AND_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 101:
#line 713 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 102:
#line 717 "cs.y"
{
    yyval.node = node2(ADD_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 103:
#line 721 "cs.y"
{
    yyval.node = node2(SUB_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 104:
#line 728 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 105:
#line 732 "cs.y"
{
    yyval.node = node2(MOD_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 106:
#line 736 "cs.y"
{
    yyval.node = node2(DIV_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 107:
#line 740 "cs.y"
{
    yyval.node = node2(MUL_EXPR, yyvsp[-2].node, yyvsp[0].node);
  ;
    break;}
case 108:
#line 747 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
case 109:
#line 751 "cs.y"
{
    yyval.node = node1(NEG_EXPR, yyvsp[0].node);
  ;
    break;}
case 110:
#line 755 "cs.y"
{
    yyval.node = yyvsp[-1].node;
  ;
    break;}
case 111:
#line 759 "cs.y"
{
    yyval.node = node(IMM_EXPR);
    yyval.node->number = yyvsp[0].number;
  ;
    break;}
case 112:
#line 764 "cs.y"
{
    yyval.node = yyvsp[0].node;
  ;
    break;}
}
   /* the action file gets copied in in place of this dollarsign */
#line 487 "bison.simple"

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
}
#line 769 "cs.y"

