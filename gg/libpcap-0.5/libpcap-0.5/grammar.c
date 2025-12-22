
/*  A Bison parser, made from grammar.y
 by  GNU Bison version 1.27
  */

#define YYBISON 1  /* Identify Bison output.  */

#define yyparse pcap_parse
#define yylex pcap_lex
#define yyerror pcap_error
#define yylval pcap_lval
#define yychar pcap_char
#define yydebug pcap_debug
#define yynerrs pcap_nerrs
#define	DST	257
#define	SRC	258
#define	HOST	259
#define	GATEWAY	260
#define	NET	261
#define	MASK	262
#define	PORT	263
#define	LESS	264
#define	GREATER	265
#define	PROTO	266
#define	PROTOCHAIN	267
#define	BYTE	268
#define	ARP	269
#define	RARP	270
#define	IP	271
#define	TCP	272
#define	UDP	273
#define	ICMP	274
#define	IGMP	275
#define	IGRP	276
#define	PIM	277
#define	ATALK	278
#define	DECNET	279
#define	LAT	280
#define	SCA	281
#define	MOPRC	282
#define	MOPDL	283
#define	TK_BROADCAST	284
#define	TK_MULTICAST	285
#define	NUM	286
#define	INBOUND	287
#define	OUTBOUND	288
#define	LINK	289
#define	GEQ	290
#define	LEQ	291
#define	NEQ	292
#define	ID	293
#define	EID	294
#define	HID	295
#define	HID6	296
#define	LSH	297
#define	RSH	298
#define	LEN	299
#define	IPV6	300
#define	ICMPV6	301
#define	AH	302
#define	ESP	303
#define	OR	304
#define	AND	305
#define	UMINUS	306

#line 1 "grammar.y"

/*
 * Copyright (c) 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that: (1) source code distributions
 * retain the above copyright notice and this paragraph in its entirety, (2)
 * distributions including binary code include the above copyright notice and
 * this paragraph in its entirety in the documentation or other materials
 * provided with the distribution, and (3) all advertising materials mentioning
 * features or use of this software display the following acknowledgement:
 * ``This product includes software developed by the University of California,
 * Lawrence Berkeley Laboratory and its contributors.'' Neither the name of
 * the University nor the names of its contributors may be used to endorse
 * or promote products derived from this software without specific prior
 * written permission.
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */
#ifndef lint
static const char rcsid[] =
    "@(#) $Header: /tcpdump/master/libpcap/grammar.y,v 1.57 1999/10/19 15:18:30 itojun Exp $ (LBL)";
#endif

#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>

#if __STDC__
struct mbuf;
struct rtentry;
#endif

#include <net/if.h>

#include <netinet/in.h>
#include <netinet/if_ether.h>

#include <stdio.h>

#include "pcap-int.h"

#include "gencode.h"
#include <pcap-namedb.h>

#include "gnuc.h"
#ifdef HAVE_OS_PROTO_H
#include "os-proto.h"
#endif

#define QSET(q, p, d, a) (q).proto = (p),\
			 (q).dir = (d),\
			 (q).addr = (a)

int n_errors = 0;

static struct qual qerr = { Q_UNDEF, Q_UNDEF, Q_UNDEF, Q_UNDEF };

static void
yyerror(char *msg)
{
	++n_errors;
	bpf_error("%s", msg);
	/* NOTREACHED */
}

#ifndef YYBISON
int yyparse(void);

int
pcap_parse()
{
	return (yyparse());
}
#endif


#line 82 "grammar.y"
typedef union {
	int i;
	bpf_u_int32 h;
	u_char *e;
	char *s;
	struct stmt *stmt;
	struct arth *a;
	struct {
		struct qual q;
		struct block *b;
	} blk;
	struct block *rblk;
} YYSTYPE;
#include <stdio.h>

#ifndef __cplusplus
#ifndef __STDC__
#ifndef const
#define const
#endif
#endif
#endif



#define	YYFINAL		160
#define	YYFLAG		-32768
#define	YYNTBASE	68

#define YYTRANSLATE(x) ((unsigned)(x) <= 306 ? yytranslate[x] : 94)

static const char yytranslate[] = {     0,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,    52,     2,     2,     2,     2,    54,     2,    61,
    60,    57,    55,     2,    56,     2,    58,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,    67,     2,    64,
    63,    62,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
    65,     2,    66,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,    53,     2,     2,     2,     2,     2,     2,
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
    47,    48,    49,    50,    51,    59
};

#if YYDEBUG != 0
static const short yyprhs[] = {     0,
     0,     3,     5,     6,     8,    12,    16,    20,    24,    26,
    28,    30,    32,    36,    38,    42,    46,    48,    52,    54,
    56,    59,    61,    63,    65,    69,    73,    75,    77,    79,
    82,    86,    89,    92,    95,    98,   101,   104,   108,   110,
   114,   118,   120,   122,   123,   125,   127,   131,   135,   139,
   143,   145,   147,   149,   151,   153,   155,   157,   159,   161,
   163,   165,   167,   169,   171,   173,   175,   177,   179,   181,
   183,   185,   187,   189,   191,   194,   197,   200,   203,   208,
   210,   212,   214,   216,   218,   220,   222,   224,   226,   228,
   233,   240,   244,   248,   252,   256,   260,   264,   268,   272,
   275,   279,   281,   283,   285,   287,   289,   291,   293
};

static const short yyrhs[] = {    69,
    70,     0,    69,     0,     0,    79,     0,    70,    71,    79,
     0,    70,    71,    73,     0,    70,    72,    79,     0,    70,
    72,    73,     0,    51,     0,    50,     0,    74,     0,    93,
     0,    76,    77,    60,     0,    39,     0,    41,    58,    32,
     0,    41,     8,    41,     0,    41,     0,    42,    58,    32,
     0,    42,     0,    40,     0,    75,    73,     0,    52,     0,
    61,     0,    74,     0,    78,    71,    73,     0,    78,    72,
    73,     0,    93,     0,    77,     0,    81,     0,    75,    79,
     0,    82,    83,    84,     0,    82,    83,     0,    82,    84,
     0,    82,    12,     0,    82,    13,     0,    82,    85,     0,
    80,    73,     0,    76,    70,    60,     0,    86,     0,    90,
    88,    90,     0,    90,    89,    90,     0,    87,     0,    86,
     0,     0,     4,     0,     3,     0,     4,    50,     3,     0,
     3,    50,     4,     0,     4,    51,     3,     0,     3,    51,
     4,     0,     5,     0,     7,     0,     9,     0,     6,     0,
    35,     0,    17,     0,    15,     0,    16,     0,    18,     0,
    19,     0,    20,     0,    21,     0,    22,     0,    23,     0,
    24,     0,    25,     0,    26,     0,    27,     0,    29,     0,
    28,     0,    46,     0,    47,     0,    48,     0,    49,     0,
    82,    30,     0,    82,    31,     0,    10,    32,     0,    11,
    32,     0,    14,    32,    92,    32,     0,    33,     0,    34,
     0,    62,     0,    36,     0,    63,     0,    37,     0,    64,
     0,    38,     0,    93,     0,    91,     0,    86,    65,    90,
    66,     0,    86,    65,    90,    67,    32,    66,     0,    90,
    55,    90,     0,    90,    56,    90,     0,    90,    57,    90,
     0,    90,    58,    90,     0,    90,    54,    90,     0,    90,
    53,    90,     0,    90,    43,    90,     0,    90,    44,    90,
     0,    56,    90,     0,    76,    91,    60,     0,    45,     0,
    54,     0,    53,     0,    64,     0,    62,     0,    63,     0,
    32,     0,    76,    93,    60,     0
};

#endif

#if YYDEBUG != 0
static const short yyrline[] = { 0,
   131,   135,   137,   139,   140,   141,   142,   143,   145,   147,
   149,   150,   152,   154,   155,   157,   159,   171,   180,   189,
   190,   192,   194,   196,   197,   198,   200,   202,   204,   205,
   207,   208,   209,   210,   211,   212,   214,   215,   216,   217,
   219,   221,   224,   225,   228,   229,   230,   231,   232,   233,
   236,   237,   238,   241,   243,   244,   245,   246,   247,   248,
   249,   250,   251,   252,   253,   254,   255,   256,   257,   258,
   259,   260,   261,   262,   264,   265,   266,   267,   268,   269,
   270,   272,   273,   274,   276,   277,   278,   280,   281,   283,
   284,   285,   286,   287,   288,   289,   290,   291,   292,   293,
   294,   295,   297,   298,   299,   300,   301,   303,   304
};
#endif


#if YYDEBUG != 0 || defined (YYERROR_VERBOSE)

static const char * const yytname[] = {   "$","error","$undefined.","DST","SRC",
"HOST","GATEWAY","NET","MASK","PORT","LESS","GREATER","PROTO","PROTOCHAIN","BYTE",
"ARP","RARP","IP","TCP","UDP","ICMP","IGMP","IGRP","PIM","ATALK","DECNET","LAT",
"SCA","MOPRC","MOPDL","TK_BROADCAST","TK_MULTICAST","NUM","INBOUND","OUTBOUND",
"LINK","GEQ","LEQ","NEQ","ID","EID","HID","HID6","LSH","RSH","LEN","IPV6","ICMPV6",
"AH","ESP","OR","AND","'!'","'|'","'&'","'+'","'-'","'*'","'/'","UMINUS","')'",
"'('","'>'","'='","'<'","'['","']'","':'","prog","null","expr","and","or","id",
"nid","not","paren","pid","qid","term","head","rterm","pqual","dqual","aqual",
"ndaqual","pname","other","relop","irelop","arth","narth","byteop","pnum", NULL
};
#endif

static const short yyr1[] = {     0,
    68,    68,    69,    70,    70,    70,    70,    70,    71,    72,
    73,    73,    73,    74,    74,    74,    74,    74,    74,    74,
    74,    75,    76,    77,    77,    77,    78,    78,    79,    79,
    80,    80,    80,    80,    80,    80,    81,    81,    81,    81,
    81,    81,    82,    82,    83,    83,    83,    83,    83,    83,
    84,    84,    84,    85,    86,    86,    86,    86,    86,    86,
    86,    86,    86,    86,    86,    86,    86,    86,    86,    86,
    86,    86,    86,    86,    87,    87,    87,    87,    87,    87,
    87,    88,    88,    88,    89,    89,    89,    90,    90,    91,
    91,    91,    91,    91,    91,    91,    91,    91,    91,    91,
    91,    91,    92,    92,    92,    92,    92,    93,    93
};

static const short yyr2[] = {     0,
     2,     1,     0,     1,     3,     3,     3,     3,     1,     1,
     1,     1,     3,     1,     3,     3,     1,     3,     1,     1,
     2,     1,     1,     1,     3,     3,     1,     1,     1,     2,
     3,     2,     2,     2,     2,     2,     2,     3,     1,     3,
     3,     1,     1,     0,     1,     1,     3,     3,     3,     3,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     2,     2,     2,     2,     4,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     4,
     6,     3,     3,     3,     3,     3,     3,     3,     3,     2,
     3,     1,     1,     1,     1,     1,     1,     1,     3
};

static const short yydefact[] = {     3,
    44,     0,     0,     0,    57,    58,    56,    59,    60,    61,
    62,    63,    64,    65,    66,    67,    68,    70,    69,   108,
    80,    81,    55,   102,    71,    72,    73,    74,    22,     0,
    23,     1,    44,    44,     4,     0,    29,     0,    43,    42,
     0,    89,    88,    77,    78,     0,     0,     0,   100,    10,
     9,    44,    44,    30,     0,    89,    88,    14,    20,    17,
    19,    37,    11,     0,     0,    12,    46,    45,    51,    54,
    52,    53,    34,    35,    75,    76,    32,    33,    36,     0,
    83,    85,    87,     0,     0,     0,     0,     0,     0,     0,
     0,    82,    84,    86,     0,     0,   104,   103,   106,   107,
   105,     0,     0,     6,    44,    44,     5,    88,     8,     7,
    38,   101,   109,     0,     0,     0,    21,    24,     0,    28,
     0,    27,     0,     0,     0,     0,    31,     0,    98,    99,
    97,    96,    92,    93,    94,    95,    40,    41,    79,    88,
    16,    15,    18,     0,    13,     0,     0,    48,    50,    47,
    49,    90,     0,    25,    26,     0,    91,     0,     0,     0
};

static const short yydefgoto[] = {   158,
     1,    55,    52,    53,   117,    63,    64,    47,   120,   121,
    35,    36,    37,    38,    77,    78,    79,    48,    40,    95,
    96,    41,    42,   102,    43
};

static const short yypact[] = {-32768,
   133,   -26,   -19,    -8,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,   276,
-32768,   -23,   229,   229,-32768,    61,-32768,   352,     5,-32768,
   290,-32768,-32768,-32768,-32768,    44,   276,   -36,-32768,-32768,
-32768,   181,   181,-32768,    16,   -29,   -24,-32768,-32768,    11,
   -17,-32768,-32768,    61,    61,-32768,    -2,    31,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,     7,-32768,-32768,   276,
-32768,-32768,-32768,   276,   276,   276,   276,   276,   276,   276,
   276,-32768,-32768,-32768,   276,   276,-32768,-32768,-32768,-32768,
-32768,     2,    84,-32768,   181,   181,-32768,     8,-32768,-32768,
-32768,-32768,-32768,     3,    14,    18,-32768,-32768,   -21,    -3,
   -23,   -24,    35,    56,    68,    80,-32768,   319,    74,    74,
   335,   344,    52,    52,-32768,-32768,    84,    84,-32768,   113,
-32768,-32768,-32768,   -24,-32768,    61,    61,-32768,-32768,-32768,
-32768,-32768,    45,-32768,-32768,    28,-32768,    99,   116,-32768
};

static const short yypgoto[] = {-32768,
-32768,   120,    -4,    13,   -35,   -61,     9,    -1,-32768,-32768,
   -30,-32768,-32768,-32768,-32768,    46,-32768,    20,-32768,-32768,
-32768,     0,   -32,-32768,   -27
};


#define	YYLAST		402


static const short yytable[] = {    34,
    62,    56,    54,   118,   -39,    44,    57,   -12,    66,    33,
    20,    69,    45,    71,    56,    72,   104,   109,   114,    57,
    39,   107,   110,    46,   108,   108,    50,    51,    80,    49,
   112,    34,    34,   139,    65,   113,    66,   122,   148,    31,
   116,    33,    33,   141,   118,   142,   103,   123,   124,   143,
   106,   106,    39,    39,   -39,   -39,   145,   -12,   -12,   149,
   105,   105,    65,   119,   -39,    50,    51,   -12,   115,    80,
   150,    39,    39,    56,    54,   111,   156,   108,   140,   128,
   125,   126,   151,   129,   130,   131,   132,   133,   134,   135,
   136,   144,    20,   157,   137,   138,    97,    98,   159,    58,
    59,    60,    61,   106,    34,    99,   100,   101,    90,    91,
   154,   155,    29,   105,   105,   160,   146,   119,    66,    66,
    32,    31,   127,     0,    39,    39,    84,    85,    88,    89,
    90,    91,    -2,   147,     0,     0,    86,    87,    88,    89,
    90,    91,     2,     3,    65,    65,     4,     5,     6,     7,
     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
    18,    19,   -27,   -27,    20,    21,    22,    23,     0,     0,
     0,     0,   113,     0,     0,     0,     0,    24,    25,    26,
    27,    28,     0,     0,    29,     0,     0,     0,    30,     0,
     2,     3,     0,    31,     4,     5,     6,     7,     8,     9,
    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
     0,     0,    20,    21,    22,    23,     0,     0,     0,    58,
    59,    60,    61,     0,     0,    24,    25,    26,    27,    28,
     0,     0,    29,     0,     0,     0,    30,     0,     2,     3,
     0,    31,     4,     5,     6,     7,     8,     9,    10,    11,
    12,    13,    14,    15,    16,    17,    18,    19,     0,     0,
    20,    21,    22,    23,     0,     0,     0,     0,     0,     0,
     0,     0,     0,    24,    25,    26,    27,    28,     0,     0,
    29,     0,     0,     0,    30,     0,     0,     0,     0,    31,
     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
    15,    16,    17,    18,    19,     0,     0,    20,     0,     0,
    23,     0,     0,     0,     0,     0,     0,     0,     0,     0,
    24,    25,    26,    27,    28,    81,    82,    83,     0,     0,
     0,    30,    84,    85,     0,     0,    31,     0,     0,     0,
     0,     0,    86,    87,    88,    89,    90,    91,     0,     0,
     0,    92,    93,    94,    67,    68,    69,    70,    71,     0,
    72,    84,    85,    73,    74,     0,     0,     0,     0,     0,
     0,    86,    87,    88,    89,    90,    91,    84,    85,     0,
     0,    75,    76,     0,   152,   153,    84,    85,    87,    88,
    89,    90,    91,     0,     0,     0,     0,     0,    88,    89,
    90,    91
};

static const short yycheck[] = {     1,
    36,    34,    33,    65,     0,    32,    34,     0,    36,     1,
    32,     5,    32,     7,    47,     9,    52,    53,     8,    47,
     1,    52,    53,    32,    52,    53,    50,    51,    65,    30,
    60,    33,    34,    32,    36,    60,    64,    65,     4,    61,
    58,    33,    34,    41,   106,    32,    47,    50,    51,    32,
    52,    53,    33,    34,    50,    51,    60,    50,    51,     4,
    52,    53,    64,    65,    60,    50,    51,    60,    58,    65,
     3,    52,    53,   106,   105,    60,    32,   105,   106,    80,
    50,    51,     3,    84,    85,    86,    87,    88,    89,    90,
    91,   119,    32,    66,    95,    96,    53,    54,     0,    39,
    40,    41,    42,   105,   106,    62,    63,    64,    57,    58,
   146,   147,    52,   105,   106,     0,   121,   119,   146,   147,
     1,    61,    77,    -1,   105,   106,    43,    44,    55,    56,
    57,    58,     0,   121,    -1,    -1,    53,    54,    55,    56,
    57,    58,    10,    11,   146,   147,    14,    15,    16,    17,
    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
    28,    29,    50,    51,    32,    33,    34,    35,    -1,    -1,
    -1,    -1,    60,    -1,    -1,    -1,    -1,    45,    46,    47,
    48,    49,    -1,    -1,    52,    -1,    -1,    -1,    56,    -1,
    10,    11,    -1,    61,    14,    15,    16,    17,    18,    19,
    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
    -1,    -1,    32,    33,    34,    35,    -1,    -1,    -1,    39,
    40,    41,    42,    -1,    -1,    45,    46,    47,    48,    49,
    -1,    -1,    52,    -1,    -1,    -1,    56,    -1,    10,    11,
    -1,    61,    14,    15,    16,    17,    18,    19,    20,    21,
    22,    23,    24,    25,    26,    27,    28,    29,    -1,    -1,
    32,    33,    34,    35,    -1,    -1,    -1,    -1,    -1,    -1,
    -1,    -1,    -1,    45,    46,    47,    48,    49,    -1,    -1,
    52,    -1,    -1,    -1,    56,    -1,    -1,    -1,    -1,    61,
    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
    25,    26,    27,    28,    29,    -1,    -1,    32,    -1,    -1,
    35,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
    45,    46,    47,    48,    49,    36,    37,    38,    -1,    -1,
    -1,    56,    43,    44,    -1,    -1,    61,    -1,    -1,    -1,
    -1,    -1,    53,    54,    55,    56,    57,    58,    -1,    -1,
    -1,    62,    63,    64,     3,     4,     5,     6,     7,    -1,
     9,    43,    44,    12,    13,    -1,    -1,    -1,    -1,    -1,
    -1,    53,    54,    55,    56,    57,    58,    43,    44,    -1,
    -1,    30,    31,    -1,    66,    67,    43,    44,    54,    55,
    56,    57,    58,    -1,    -1,    -1,    -1,    -1,    55,    56,
    57,    58
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

case 1:
#line 132 "grammar.y"
{
	finish_parse(yyvsp[0].blk.b);
;
    break;}
case 3:
#line 137 "grammar.y"
{ yyval.blk.q = qerr; ;
    break;}
case 5:
#line 140 "grammar.y"
{ gen_and(yyvsp[-2].blk.b, yyvsp[0].blk.b); yyval.blk = yyvsp[0].blk; ;
    break;}
case 6:
#line 141 "grammar.y"
{ gen_and(yyvsp[-2].blk.b, yyvsp[0].blk.b); yyval.blk = yyvsp[0].blk; ;
    break;}
case 7:
#line 142 "grammar.y"
{ gen_or(yyvsp[-2].blk.b, yyvsp[0].blk.b); yyval.blk = yyvsp[0].blk; ;
    break;}
case 8:
#line 143 "grammar.y"
{ gen_or(yyvsp[-2].blk.b, yyvsp[0].blk.b); yyval.blk = yyvsp[0].blk; ;
    break;}
case 9:
#line 145 "grammar.y"
{ yyval.blk = yyvsp[-1].blk; ;
    break;}
case 10:
#line 147 "grammar.y"
{ yyval.blk = yyvsp[-1].blk; ;
    break;}
case 12:
#line 150 "grammar.y"
{ yyval.blk.b = gen_ncode(NULL, (bpf_u_int32)yyvsp[0].i,
						   yyval.blk.q = yyvsp[-1].blk.q); ;
    break;}
case 13:
#line 152 "grammar.y"
{ yyval.blk = yyvsp[-1].blk; ;
    break;}
case 14:
#line 154 "grammar.y"
{ yyval.blk.b = gen_scode(yyvsp[0].s, yyval.blk.q = yyvsp[-1].blk.q); ;
    break;}
case 15:
#line 155 "grammar.y"
{ yyval.blk.b = gen_mcode(yyvsp[-2].s, NULL, yyvsp[0].i,
				    yyval.blk.q = yyvsp[-3].blk.q); ;
    break;}
case 16:
#line 157 "grammar.y"
{ yyval.blk.b = gen_mcode(yyvsp[-2].s, yyvsp[0].s, 0,
				    yyval.blk.q = yyvsp[-3].blk.q); ;
    break;}
case 17:
#line 159 "grammar.y"
{
				  /* Decide how to parse HID based on proto */
				  yyval.blk.q = yyvsp[-1].blk.q;
				  switch (yyval.blk.q.proto) {
				  case Q_DECNET:
					yyval.blk.b = gen_ncode(yyvsp[0].s, 0, yyval.blk.q);
					break;
				  default:
					yyval.blk.b = gen_ncode(yyvsp[0].s, 0, yyval.blk.q);
					break;
				  }
				;
    break;}
case 18:
#line 171 "grammar.y"
{
#ifdef INET6
				  yyval.blk.b = gen_mcode6(yyvsp[-2].s, NULL, yyvsp[0].i,
				    yyval.blk.q = yyvsp[-3].blk.q);
#else
				  bpf_error("'ip6addr/prefixlen' not supported "
					"in this configuration");
#endif /*INET6*/
				;
    break;}
case 19:
#line 180 "grammar.y"
{
#ifdef INET6
				  yyval.blk.b = gen_mcode6(yyvsp[0].s, 0, 128,
				    yyval.blk.q = yyvsp[-1].blk.q);
#else
				  bpf_error("'ip6addr' not supported "
					"in this configuration");
#endif /*INET6*/
				;
    break;}
case 20:
#line 189 "grammar.y"
{ yyval.blk.b = gen_ecode(yyvsp[0].e, yyval.blk.q = yyvsp[-1].blk.q); ;
    break;}
case 21:
#line 190 "grammar.y"
{ gen_not(yyvsp[0].blk.b); yyval.blk = yyvsp[0].blk; ;
    break;}
case 22:
#line 192 "grammar.y"
{ yyval.blk = yyvsp[-1].blk; ;
    break;}
case 23:
#line 194 "grammar.y"
{ yyval.blk = yyvsp[-1].blk; ;
    break;}
case 25:
#line 197 "grammar.y"
{ gen_and(yyvsp[-2].blk.b, yyvsp[0].blk.b); yyval.blk = yyvsp[0].blk; ;
    break;}
case 26:
#line 198 "grammar.y"
{ gen_or(yyvsp[-2].blk.b, yyvsp[0].blk.b); yyval.blk = yyvsp[0].blk; ;
    break;}
case 27:
#line 200 "grammar.y"
{ yyval.blk.b = gen_ncode(NULL, (bpf_u_int32)yyvsp[0].i,
						   yyval.blk.q = yyvsp[-1].blk.q); ;
    break;}
case 30:
#line 205 "grammar.y"
{ gen_not(yyvsp[0].blk.b); yyval.blk = yyvsp[0].blk; ;
    break;}
case 31:
#line 207 "grammar.y"
{ QSET(yyval.blk.q, yyvsp[-2].i, yyvsp[-1].i, yyvsp[0].i); ;
    break;}
case 32:
#line 208 "grammar.y"
{ QSET(yyval.blk.q, yyvsp[-1].i, yyvsp[0].i, Q_DEFAULT); ;
    break;}
case 33:
#line 209 "grammar.y"
{ QSET(yyval.blk.q, yyvsp[-1].i, Q_DEFAULT, yyvsp[0].i); ;
    break;}
case 34:
#line 210 "grammar.y"
{ QSET(yyval.blk.q, yyvsp[-1].i, Q_DEFAULT, Q_PROTO); ;
    break;}
case 35:
#line 211 "grammar.y"
{ QSET(yyval.blk.q, yyvsp[-1].i, Q_DEFAULT, Q_PROTOCHAIN); ;
    break;}
case 36:
#line 212 "grammar.y"
{ QSET(yyval.blk.q, yyvsp[-1].i, Q_DEFAULT, yyvsp[0].i); ;
    break;}
case 37:
#line 214 "grammar.y"
{ yyval.blk = yyvsp[0].blk; ;
    break;}
case 38:
#line 215 "grammar.y"
{ yyval.blk.b = yyvsp[-1].blk.b; yyval.blk.q = yyvsp[-2].blk.q; ;
    break;}
case 39:
#line 216 "grammar.y"
{ yyval.blk.b = gen_proto_abbrev(yyvsp[0].i); yyval.blk.q = qerr; ;
    break;}
case 40:
#line 217 "grammar.y"
{ yyval.blk.b = gen_relation(yyvsp[-1].i, yyvsp[-2].a, yyvsp[0].a, 0);
				  yyval.blk.q = qerr; ;
    break;}
case 41:
#line 219 "grammar.y"
{ yyval.blk.b = gen_relation(yyvsp[-1].i, yyvsp[-2].a, yyvsp[0].a, 1);
				  yyval.blk.q = qerr; ;
    break;}
case 42:
#line 221 "grammar.y"
{ yyval.blk.b = yyvsp[0].rblk; yyval.blk.q = qerr; ;
    break;}
case 44:
#line 225 "grammar.y"
{ yyval.i = Q_DEFAULT; ;
    break;}
case 45:
#line 228 "grammar.y"
{ yyval.i = Q_SRC; ;
    break;}
case 46:
#line 229 "grammar.y"
{ yyval.i = Q_DST; ;
    break;}
case 47:
#line 230 "grammar.y"
{ yyval.i = Q_OR; ;
    break;}
case 48:
#line 231 "grammar.y"
{ yyval.i = Q_OR; ;
    break;}
case 49:
#line 232 "grammar.y"
{ yyval.i = Q_AND; ;
    break;}
case 50:
#line 233 "grammar.y"
{ yyval.i = Q_AND; ;
    break;}
case 51:
#line 236 "grammar.y"
{ yyval.i = Q_HOST; ;
    break;}
case 52:
#line 237 "grammar.y"
{ yyval.i = Q_NET; ;
    break;}
case 53:
#line 238 "grammar.y"
{ yyval.i = Q_PORT; ;
    break;}
case 54:
#line 241 "grammar.y"
{ yyval.i = Q_GATEWAY; ;
    break;}
case 55:
#line 243 "grammar.y"
{ yyval.i = Q_LINK; ;
    break;}
case 56:
#line 244 "grammar.y"
{ yyval.i = Q_IP; ;
    break;}
case 57:
#line 245 "grammar.y"
{ yyval.i = Q_ARP; ;
    break;}
case 58:
#line 246 "grammar.y"
{ yyval.i = Q_RARP; ;
    break;}
case 59:
#line 247 "grammar.y"
{ yyval.i = Q_TCP; ;
    break;}
case 60:
#line 248 "grammar.y"
{ yyval.i = Q_UDP; ;
    break;}
case 61:
#line 249 "grammar.y"
{ yyval.i = Q_ICMP; ;
    break;}
case 62:
#line 250 "grammar.y"
{ yyval.i = Q_IGMP; ;
    break;}
case 63:
#line 251 "grammar.y"
{ yyval.i = Q_IGRP; ;
    break;}
case 64:
#line 252 "grammar.y"
{ yyval.i = Q_PIM; ;
    break;}
case 65:
#line 253 "grammar.y"
{ yyval.i = Q_ATALK; ;
    break;}
case 66:
#line 254 "grammar.y"
{ yyval.i = Q_DECNET; ;
    break;}
case 67:
#line 255 "grammar.y"
{ yyval.i = Q_LAT; ;
    break;}
case 68:
#line 256 "grammar.y"
{ yyval.i = Q_SCA; ;
    break;}
case 69:
#line 257 "grammar.y"
{ yyval.i = Q_MOPDL; ;
    break;}
case 70:
#line 258 "grammar.y"
{ yyval.i = Q_MOPRC; ;
    break;}
case 71:
#line 259 "grammar.y"
{ yyval.i = Q_IPV6; ;
    break;}
case 72:
#line 260 "grammar.y"
{ yyval.i = Q_ICMPV6; ;
    break;}
case 73:
#line 261 "grammar.y"
{ yyval.i = Q_AH; ;
    break;}
case 74:
#line 262 "grammar.y"
{ yyval.i = Q_ESP; ;
    break;}
case 75:
#line 264 "grammar.y"
{ yyval.rblk = gen_broadcast(yyvsp[-1].i); ;
    break;}
case 76:
#line 265 "grammar.y"
{ yyval.rblk = gen_multicast(yyvsp[-1].i); ;
    break;}
case 77:
#line 266 "grammar.y"
{ yyval.rblk = gen_less(yyvsp[0].i); ;
    break;}
case 78:
#line 267 "grammar.y"
{ yyval.rblk = gen_greater(yyvsp[0].i); ;
    break;}
case 79:
#line 268 "grammar.y"
{ yyval.rblk = gen_byteop(yyvsp[-1].i, yyvsp[-2].i, yyvsp[0].i); ;
    break;}
case 80:
#line 269 "grammar.y"
{ yyval.rblk = gen_inbound(0); ;
    break;}
case 81:
#line 270 "grammar.y"
{ yyval.rblk = gen_inbound(1); ;
    break;}
case 82:
#line 272 "grammar.y"
{ yyval.i = BPF_JGT; ;
    break;}
case 83:
#line 273 "grammar.y"
{ yyval.i = BPF_JGE; ;
    break;}
case 84:
#line 274 "grammar.y"
{ yyval.i = BPF_JEQ; ;
    break;}
case 85:
#line 276 "grammar.y"
{ yyval.i = BPF_JGT; ;
    break;}
case 86:
#line 277 "grammar.y"
{ yyval.i = BPF_JGE; ;
    break;}
case 87:
#line 278 "grammar.y"
{ yyval.i = BPF_JEQ; ;
    break;}
case 88:
#line 280 "grammar.y"
{ yyval.a = gen_loadi(yyvsp[0].i); ;
    break;}
case 90:
#line 283 "grammar.y"
{ yyval.a = gen_load(yyvsp[-3].i, yyvsp[-1].a, 1); ;
    break;}
case 91:
#line 284 "grammar.y"
{ yyval.a = gen_load(yyvsp[-5].i, yyvsp[-3].a, yyvsp[-1].i); ;
    break;}
case 92:
#line 285 "grammar.y"
{ yyval.a = gen_arth(BPF_ADD, yyvsp[-2].a, yyvsp[0].a); ;
    break;}
case 93:
#line 286 "grammar.y"
{ yyval.a = gen_arth(BPF_SUB, yyvsp[-2].a, yyvsp[0].a); ;
    break;}
case 94:
#line 287 "grammar.y"
{ yyval.a = gen_arth(BPF_MUL, yyvsp[-2].a, yyvsp[0].a); ;
    break;}
case 95:
#line 288 "grammar.y"
{ yyval.a = gen_arth(BPF_DIV, yyvsp[-2].a, yyvsp[0].a); ;
    break;}
case 96:
#line 289 "grammar.y"
{ yyval.a = gen_arth(BPF_AND, yyvsp[-2].a, yyvsp[0].a); ;
    break;}
case 97:
#line 290 "grammar.y"
{ yyval.a = gen_arth(BPF_OR, yyvsp[-2].a, yyvsp[0].a); ;
    break;}
case 98:
#line 291 "grammar.y"
{ yyval.a = gen_arth(BPF_LSH, yyvsp[-2].a, yyvsp[0].a); ;
    break;}
case 99:
#line 292 "grammar.y"
{ yyval.a = gen_arth(BPF_RSH, yyvsp[-2].a, yyvsp[0].a); ;
    break;}
case 100:
#line 293 "grammar.y"
{ yyval.a = gen_neg(yyvsp[0].a); ;
    break;}
case 101:
#line 294 "grammar.y"
{ yyval.a = yyvsp[-1].a; ;
    break;}
case 102:
#line 295 "grammar.y"
{ yyval.a = gen_loadlen(); ;
    break;}
case 103:
#line 297 "grammar.y"
{ yyval.i = '&'; ;
    break;}
case 104:
#line 298 "grammar.y"
{ yyval.i = '|'; ;
    break;}
case 105:
#line 299 "grammar.y"
{ yyval.i = '<'; ;
    break;}
case 106:
#line 300 "grammar.y"
{ yyval.i = '>'; ;
    break;}
case 107:
#line 301 "grammar.y"
{ yyval.i = '='; ;
    break;}
case 109:
#line 304 "grammar.y"
{ yyval.i = yyvsp[-1].i; ;
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
#line 306 "grammar.y"

