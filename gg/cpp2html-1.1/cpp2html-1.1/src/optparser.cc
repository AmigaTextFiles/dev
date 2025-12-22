
/*  A Bison parser, made from optparser.yy
    by GNU Bison version 1.28  */

#define YYBISON 1  /* Identify Bison output.  */

#define	BOLD	257
#define	ITALICS	258
#define	UNDERLINE	259
#define	KEY	260
#define	COLOR	261


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

static int opsc_parse() ;
static void opsc_error( char *s ) ;

int line = 0 ;

void parseTags() ;

static FILE *openTagsFile() ;

extern int opsc_lex() ;
extern FILE *opsc_in ;


typedef union {
  int tok ; /* command */
  char * string ; /* string : id, ... */
  int flag ;
  Tag *tag ;
  Tags *tags ; 
} YYSTYPE;
#include <stdio.h>

#ifndef __cplusplus
#ifndef __STDC__
#define const
#endif
#endif



#define	YYFINAL		17
#define	YYFLAG		-32768
#define	YYNTBASE	10

#define YYTRANSLATE(x) ((unsigned)(x) <= 261 ? yytranslate[x] : 16)

static const char yytranslate[] = {     0,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     9,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     8,     2,
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
     7
};

#if YYDEBUG != 0
static const short yyprhs[] = {     0,
     0,     2,     5,     7,     8,    14,    18,    20,    21,    23,
    25
};

static const short yyrhs[] = {    11,
     0,    11,    12,     0,    12,     0,     0,     6,     7,    13,
    14,     8,     0,    14,     9,    15,     0,    15,     0,     0,
     3,     0,     4,     0,     5,     0
};

#endif

#if YYDEBUG != 0
static const short yyrline[] = { 0,
    73,    75,    76,    79,    84,    91,    92,    95,    96,    97,
    98
};
#endif


#if YYDEBUG != 0 || defined (YYERROR_VERBOSE)

static const char * const yytname[] = {   "$","error","$undefined.","BOLD","ITALICS",
"UNDERLINE","KEY","COLOR","';'","','","globaltags","options","option","@1","values",
"value", NULL
};
#endif

static const short yyr1[] = {     0,
    10,    11,    11,    13,    12,    14,    14,    15,    15,    15,
    15
};

static const short yyr2[] = {     0,
     1,     2,     1,     0,     5,     3,     1,     0,     1,     1,
     1
};

static const short opsc_defact[] = {     0,
     0,     1,     3,     4,     2,     8,     9,    10,    11,     0,
     7,     5,     8,     6,     0,     0,     0
};

static const short opsc_defgoto[] = {    15,
     2,     3,     6,    10,    11
};

static const short opsc_pact[] = {    -1,
     0,    -1,-32768,-32768,-32768,    -3,-32768,-32768,-32768,    -5,
-32768,-32768,    -3,-32768,     6,     8,-32768
};

static const short opsc_pgoto[] = {-32768,
-32768,     7,-32768,-32768,    -2
};


#define	YYLAST		11


static const short opsc_table[] = {     7,
     8,     9,    12,    13,     1,    16,     4,    17,     5,     0,
    14
};

static const short opsc_check[] = {     3,
     4,     5,     8,     9,     6,     0,     7,     0,     2,    -1,
    13
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */

/* This file comes from bison-1.28.  */

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
#define yyclearin	(opsc_char = YYEMPTY)
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	goto yyacceptlab
#define YYABORT 	goto yyabortlab
#define YYERROR		goto yyerrlab1
/* Like YYERROR except do call opsc_error.
   This remains here temporarily to ease the
   transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */
#define YYFAIL		goto yyerrlab
#define YYRECOVERING()  (!!yyerrstatus)
#define YYBACKUP(token, value) \
do								\
  if (opsc_char == YYEMPTY && opsc_len == 1)				\
    { opsc_char = (token), opsc_lval = (value);			\
      opsc_char1 = YYTRANSLATE (opsc_char);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { opsc_error ("syntax error: cannot back up"); YYERROR; }	\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

#ifndef YYPURE
#define YYLEX		opsc_lex()
#endif

#ifdef YYPURE
#ifdef YYLSP_NEEDED
#ifdef YYLEX_PARAM
#define YYLEX		opsc_lex(&opsc_lval, &opsc_lloc, YYLEX_PARAM)
#else
#define YYLEX		opsc_lex(&opsc_lval, &opsc_lloc)
#endif
#else /* not YYLSP_NEEDED */
#ifdef YYLEX_PARAM
#define YYLEX		opsc_lex(&opsc_lval, YYLEX_PARAM)
#else
#define YYLEX		opsc_lex(&opsc_lval)
#endif
#endif /* not YYLSP_NEEDED */
#endif

/* If nonreentrant, generate the variables here */

#ifndef YYPURE

int	opsc_char;			/*  the lookahead symbol		*/
YYSTYPE	opsc_lval;			/*  the semantic value of the		*/
				/*  lookahead symbol			*/

#ifdef YYLSP_NEEDED
YYLTYPE opsc_lloc;			/*  location data for the lookahead	*/
				/*  symbol				*/
#endif

int opsc_nerrs;			/*  number of parse errors so far       */
#endif  /* not YYPURE */

#if YYDEBUG != 0
int opsc_debug;			/*  nonzero means print parse trace	*/
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



/* The user can define YYPARSE_PARAM as the name of an argument to be passed
   into opsc_parse.  The argument should have type void *.
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
int opsc_parse (void *);
#else
int opsc_parse (void);
#endif
#endif

int
opsc_parse(YYPARSE_PARAM_ARG)
     YYPARSE_PARAM_DECL
{
  register int opsc_state;
  register int yyn;
  register short *opsc_ssp;
  register YYSTYPE *opsc_vsp;
  int yyerrstatus;	/*  number of tokens to shift before error messages enabled */
  int opsc_char1 = 0;		/*  lookahead token as an internal (translated) token number */

  short	opsc_ssa[YYINITDEPTH];	/*  the state stack			*/
  YYSTYPE opsc_vsa[YYINITDEPTH];	/*  the semantic value stack		*/

  short *opsc_ss = opsc_ssa;		/*  refer to the stacks thru separate pointers */
  YYSTYPE *opsc_vs = opsc_vsa;	/*  to allow yyoverflow to reallocate them elsewhere */

#ifdef YYLSP_NEEDED
  YYLTYPE yylsa[YYINITDEPTH];	/*  the location stack			*/
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;

#define YYPOPSTACK   (opsc_vsp--, opsc_ssp--, yylsp--)
#else
#define YYPOPSTACK   (opsc_vsp--, opsc_ssp--)
#endif

  int opsc_stacksize = YYINITDEPTH;
  int yyfree_stacks = 0;

#ifdef YYPURE
  int opsc_char;
  YYSTYPE opsc_lval;
  int opsc_nerrs;
#ifdef YYLSP_NEEDED
  YYLTYPE opsc_lloc;
#endif
#endif

  YYSTYPE opsc_val;		/*  the variable used to return		*/
				/*  semantic values from the action	*/
				/*  routines				*/

  int opsc_len;

#if YYDEBUG != 0
  if (opsc_debug)
    fprintf(stderr, "Starting parse\n");
#endif

  opsc_state = 0;
  yyerrstatus = 0;
  opsc_nerrs = 0;
  opsc_char = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  opsc_ssp = opsc_ss - 1;
  opsc_vsp = opsc_vs;
#ifdef YYLSP_NEEDED
  yylsp = yyls;
#endif

/* Push a new state, which is found in  opsc_state  .  */
/* In all cases, when you get here, the value and location stacks
   have just been pushed. so pushing a state here evens the stacks.  */
yynewstate:

  *++opsc_ssp = opsc_state;

  if (opsc_ssp >= opsc_ss + opsc_stacksize - 1)
    {
      /* Give user a chance to reallocate the stack */
      /* Use copies of these so that the &'s don't force the real ones into memory. */
      YYSTYPE *opsc_vs1 = opsc_vs;
      short *opsc_ss1 = opsc_ss;
#ifdef YYLSP_NEEDED
      YYLTYPE *yyls1 = yyls;
#endif

      /* Get the current used size of the three stacks, in elements.  */
      int size = opsc_ssp - opsc_ss + 1;

#ifdef yyoverflow
      /* Each stack pointer address is followed by the size of
	 the data in use in that stack, in bytes.  */
#ifdef YYLSP_NEEDED
      /* This used to be a conditional around just the two extra args,
	 but that might be undefined if yyoverflow is a macro.  */
      yyoverflow("parser stack overflow",
		 &opsc_ss1, size * sizeof (*opsc_ssp),
		 &opsc_vs1, size * sizeof (*opsc_vsp),
		 &yyls1, size * sizeof (*yylsp),
		 &opsc_stacksize);
#else
      yyoverflow("parser stack overflow",
		 &opsc_ss1, size * sizeof (*opsc_ssp),
		 &opsc_vs1, size * sizeof (*opsc_vsp),
		 &opsc_stacksize);
#endif

      opsc_ss = opsc_ss1; opsc_vs = opsc_vs1;
#ifdef YYLSP_NEEDED
      yyls = yyls1;
#endif
#else /* no yyoverflow */
      /* Extend the stack our own way.  */
      if (opsc_stacksize >= YYMAXDEPTH)
	{
	  opsc_error("parser stack overflow");
	  if (yyfree_stacks)
	    {
	      free (opsc_ss);
	      free (opsc_vs);
#ifdef YYLSP_NEEDED
	      free (yyls);
#endif
	    }
	  return 2;
	}
      opsc_stacksize *= 2;
      if (opsc_stacksize > YYMAXDEPTH)
	opsc_stacksize = YYMAXDEPTH;
#ifndef YYSTACK_USE_ALLOCA
      yyfree_stacks = 1;
#endif
      opsc_ss = (short *) YYSTACK_ALLOC (opsc_stacksize * sizeof (*opsc_ssp));
      __yy_memcpy ((char *)opsc_ss, (char *)opsc_ss1,
		   size * (unsigned int) sizeof (*opsc_ssp));
      opsc_vs = (YYSTYPE *) YYSTACK_ALLOC (opsc_stacksize * sizeof (*opsc_vsp));
      __yy_memcpy ((char *)opsc_vs, (char *)opsc_vs1,
		   size * (unsigned int) sizeof (*opsc_vsp));
#ifdef YYLSP_NEEDED
      yyls = (YYLTYPE *) YYSTACK_ALLOC (opsc_stacksize * sizeof (*yylsp));
      __yy_memcpy ((char *)yyls, (char *)yyls1,
		   size * (unsigned int) sizeof (*yylsp));
#endif
#endif /* no yyoverflow */

      opsc_ssp = opsc_ss + size - 1;
      opsc_vsp = opsc_vs + size - 1;
#ifdef YYLSP_NEEDED
      yylsp = yyls + size - 1;
#endif

#if YYDEBUG != 0
      if (opsc_debug)
	fprintf(stderr, "Stack size increased to %d\n", opsc_stacksize);
#endif

      if (opsc_ssp >= opsc_ss + opsc_stacksize - 1)
	YYABORT;
    }

#if YYDEBUG != 0
  if (opsc_debug)
    fprintf(stderr, "Entering state %d\n", opsc_state);
#endif

  goto yybackup;
 yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = opsc_pact[opsc_state];
  if (yyn == YYFLAG)
    goto opsc_default;

  /* Not known => get a lookahead token if don't already have one.  */

  /* opsc_char is either YYEMPTY or YYEOF
     or a valid token in external form.  */

  if (opsc_char == YYEMPTY)
    {
#if YYDEBUG != 0
      if (opsc_debug)
	fprintf(stderr, "Reading a token: ");
#endif
      opsc_char = YYLEX;
    }

  /* Convert token to internal form (in opsc_char1) for indexing tables with */

  if (opsc_char <= 0)		/* This means end of input. */
    {
      opsc_char1 = 0;
      opsc_char = YYEOF;		/* Don't call YYLEX any more */

#if YYDEBUG != 0
      if (opsc_debug)
	fprintf(stderr, "Now at end of input.\n");
#endif
    }
  else
    {
      opsc_char1 = YYTRANSLATE(opsc_char);

#if YYDEBUG != 0
      if (opsc_debug)
	{
	  fprintf (stderr, "Next token is %d (%s", opsc_char, yytname[opsc_char1]);
	  /* Give the individual parser a way to print the precise meaning
	     of a token, for further debugging info.  */
#ifdef YYPRINT
	  YYPRINT (stderr, opsc_char, opsc_lval);
#endif
	  fprintf (stderr, ")\n");
	}
#endif
    }

  yyn += opsc_char1;
  if (yyn < 0 || yyn > YYLAST || opsc_check[yyn] != opsc_char1)
    goto opsc_default;

  yyn = opsc_table[yyn];

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
  if (opsc_debug)
    fprintf(stderr, "Shifting token %d (%s), ", opsc_char, yytname[opsc_char1]);
#endif

  /* Discard the token being shifted unless it is eof.  */
  if (opsc_char != YYEOF)
    opsc_char = YYEMPTY;

  *++opsc_vsp = opsc_lval;
#ifdef YYLSP_NEEDED
  *++yylsp = opsc_lloc;
#endif

  /* count tokens shifted since error; after three, turn off error status.  */
  if (yyerrstatus) yyerrstatus--;

  opsc_state = yyn;
  goto yynewstate;

/* Do the default action for the current state.  */
opsc_default:

  yyn = opsc_defact[opsc_state];
  if (yyn == 0)
    goto yyerrlab;

/* Do a reduction.  yyn is the number of a rule to reduce with.  */
yyreduce:
  opsc_len = yyr2[yyn];
  if (opsc_len > 0)
    opsc_val = opsc_vsp[1-opsc_len]; /* implement default value of the action */

#if YYDEBUG != 0
  if (opsc_debug)
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
{ setTags( opsc_vsp[0].tags ) ; ;
    break;}
case 2:
{ opsc_vsp[-1].tags->AddTag( opsc_vsp[0].tag ) ; ;
    break;}
case 3:
{ opsc_val.tags = new Tags() ; opsc_val.tags->AddTag( opsc_vsp[0].tag ) ;  ;
    break;}
case 4:
{ 
                 printMessage( opsc_vsp[-1].string ) ;
                 printMessage( opsc_vsp[0].string ) ;
             ;
    break;}
case 5:
{ 
	       opsc_val.tag = new Tag( strdup(opsc_vsp[-4].string), strdup(opsc_vsp[-3].string) ) ;
               opsc_val.tag->SetFlags(opsc_vsp[-1].flag) ; 
	     ;
    break;}
case 6:
{ opsc_val.flag = opsc_vsp[-2].flag | opsc_vsp[0].flag ; ;
    break;}
case 8:
{ opsc_val.flag = 0 ; printMessage( " (no options) " ) ; ;
    break;}
case 9:
{ printMessage( " - bold" ) ; opsc_val.flag = ISBOLD ; ;
    break;}
case 10:
{ printMessage( " - italics" ) ; opsc_val.flag = ISITALIC ; ;
    break;}
case 11:
{ printMessage( " - underline" ) ; opsc_val.flag = ISUNDERLINE ; ;
    break;}
}
   /* the action file gets copied in in place of this dollarsign */


  opsc_vsp -= opsc_len;
  opsc_ssp -= opsc_len;
#ifdef YYLSP_NEEDED
  yylsp -= opsc_len;
#endif

#if YYDEBUG != 0
  if (opsc_debug)
    {
      short *ssp1 = opsc_ss - 1;
      fprintf (stderr, "state stack now");
      while (ssp1 != opsc_ssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

  *++opsc_vsp = opsc_val;

#ifdef YYLSP_NEEDED
  yylsp++;
  if (opsc_len == 0)
    {
      yylsp->first_line = opsc_lloc.first_line;
      yylsp->first_column = opsc_lloc.first_column;
      yylsp->last_line = (yylsp-1)->last_line;
      yylsp->last_column = (yylsp-1)->last_column;
      yylsp->text = 0;
    }
  else
    {
      yylsp->last_line = (yylsp+opsc_len-1)->last_line;
      yylsp->last_column = (yylsp+opsc_len-1)->last_column;
    }
#endif

  /* Now "shift" the result of the reduction.
     Determine what state that goes to,
     based on the state we popped back to
     and the rule number reduced by.  */

  yyn = yyr1[yyn];

  opsc_state = opsc_pgoto[yyn - YYNTBASE] + *opsc_ssp;
  if (opsc_state >= 0 && opsc_state <= YYLAST && opsc_check[opsc_state] == *opsc_ssp)
    opsc_state = opsc_table[opsc_state];
  else
    opsc_state = opsc_defgoto[yyn - YYNTBASE];

  goto yynewstate;

yyerrlab:   /* here on detecting error */

  if (! yyerrstatus)
    /* If not already recovering from an error, report this error.  */
    {
      ++opsc_nerrs;

#ifdef YYERROR_VERBOSE
      yyn = opsc_pact[opsc_state];

      if (yyn > YYFLAG && yyn < YYLAST)
	{
	  int size = 0;
	  char *msg;
	  int x, count;

	  count = 0;
	  /* Start X at -yyn if nec to avoid negative indexes in opsc_check.  */
	  for (x = (yyn < 0 ? -yyn : 0);
	       x < (sizeof(yytname) / sizeof(char *)); x++)
	    if (opsc_check[x + yyn] == x)
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
		    if (opsc_check[x + yyn] == x)
		      {
			strcat(msg, count == 0 ? ", expecting `" : " or `");
			strcat(msg, yytname[x]);
			strcat(msg, "'");
			count++;
		      }
		}
	      opsc_error(msg);
	      free(msg);
	    }
	  else
	    opsc_error ("parse error; also virtual memory exceeded");
	}
      else
#endif /* YYERROR_VERBOSE */
	opsc_error("parse error");
    }

  goto yyerrlab1;
yyerrlab1:   /* here on error raised explicitly by an action */

  if (yyerrstatus == 3)
    {
      /* if just tried and failed to reuse lookahead token after an error, discard it.  */

      /* return failure if at end of input */
      if (opsc_char == YYEOF)
	YYABORT;

#if YYDEBUG != 0
      if (opsc_debug)
	fprintf(stderr, "Discarding token %d (%s).\n", opsc_char, yytname[opsc_char1]);
#endif

      opsc_char = YYEMPTY;
    }

  /* Else will try to reuse lookahead token
     after shifting the error token.  */

  yyerrstatus = 3;		/* Each real token shifted decrements this */

  goto yyerrhandle;

yyerrdefault:  /* current state does not do anything special for the error token. */

#if 0
  /* This is wrong; only states that explicitly want error tokens
     should shift them.  */
  yyn = opsc_defact[opsc_state];  /* If its default is to accept any token, ok.  Otherwise pop it.*/
  if (yyn) goto opsc_default;
#endif

yyerrpop:   /* pop the current state because it cannot handle the error token */

  if (opsc_ssp == opsc_ss) YYABORT;
  opsc_vsp--;
  opsc_state = *--opsc_ssp;
#ifdef YYLSP_NEEDED
  yylsp--;
#endif

#if YYDEBUG != 0
  if (opsc_debug)
    {
      short *ssp1 = opsc_ss - 1;
      fprintf (stderr, "Error: state stack now");
      while (ssp1 != opsc_ssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

yyerrhandle:

  yyn = opsc_pact[opsc_state];
  if (yyn == YYFLAG)
    goto yyerrdefault;

  yyn += YYTERROR;
  if (yyn < 0 || yyn > YYLAST || opsc_check[yyn] != YYTERROR)
    goto yyerrdefault;

  yyn = opsc_table[yyn];
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
  if (opsc_debug)
    fprintf(stderr, "Shifting error token, ");
#endif

  *++opsc_vsp = opsc_lval;
#ifdef YYLSP_NEEDED
  *++yylsp = opsc_lloc;
#endif

  opsc_state = yyn;
  goto yynewstate;

 yyacceptlab:
  /* YYACCEPT comes here.  */
  if (yyfree_stacks)
    {
      free (opsc_ss);
      free (opsc_vs);
#ifdef YYLSP_NEEDED
      free (yyls);
#endif
    }
  return 0;

 yyabortlab:
  /* YYABORT comes here.  */
  if (yyfree_stacks)
    {
      free (opsc_ss);
      free (opsc_vs);
#ifdef YYLSP_NEEDED
      free (yyls);
#endif
    }
  return 1;
}


// this should be passed by the compiler
#ifndef CPP2HTML_DATA_DIR
#define CPP2HTML_DATA_DIR "."
#endif

#define TAGS_FILE "tags.j2h"

void parseTags() {

  // opens the file for opsc_lex
  opsc_in = openTagsFile() ;
  if (! opsc_in) {
    printWarning( "No tags.j2h file, using defaults ...", cerr ) ;
    setTags( NULL ) ;
    return ;
  }

  printMessage( "Parsing tags.j2h file ...", cerr ) ;
  opsc_parse() ;
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

void opsc_error( char *s ) {
  strstream str ;
  str << "*** " << s << " on option # " << line << ends ;
  printError( str.str(), cerr ) ;
  printError( "Using default tags...", cerr ) ;
}
