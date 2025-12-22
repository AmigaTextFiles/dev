								-*-Web-*-
This file, CTANGLE.CH, is part of CWEB (Version 3.3 [patch level 11]).
It is a changefile for CTANGLE.W, Version 3.3.

Authors and Contributors:
(H2B) Hans-Hermann Bode, Universität Osnabrück,
  (hhbode@@dosuni1.rz.uni-osnabrueck.de or HHBODE@@DOSUNI1.BITNET).

(GG) Giuseppe Ghibò,
  (ghibo@@galileo.polito.it).

(KG) Klaus Guntermann, TH Darmstadt,
  (guntermann@@iti.informatik.th-darmstadt.de).

(AS) Andreas Scherer, RWTH Aachen,
  (scherer@@genesis.informatik.rwth-aachen.de).

(CS) Carsten Steger, Universität München,
  (carsten.steger@@informatik.tu-muenchen.de).

(TW) Tomas Willis,
  (tomas@@cae.wisc.edu).

Caveat utilitor:  Some of the source code introduced by this change file is
made conditional to the use of specific compilers on specific systems.
This applies to places marked with `#ifdef __MSDOS__' and `#ifdef __TURBOC__',
`#ifdef _AMIGA' and `#ifdef __SASC'.

Some of the changes made in this document are marked by one or more
keywords to indicate that they are somehow related to each other:

     - None: These changes are necessary for the indentification
       of this port.

     - ANSI: This distribution of CWEB 3.3 not only fully supports
       the writing and documentation of ANSI-C programs, but has been
       transformed into a set of ANSI-C programs (in fact C++ programs)
       by adding function prototypes, standard header files, explicit
       casts, and other features.

     - EXTENSIONS: New flags and their effects are introduced by such
       changes.  There are no new CWEB commands (yet).

     - MEMORY ALLOCATION: All internal arrays are replaced by pointers
       that address dynamically allocated memory blocks.  Although there
       is no external configuration file or other possibility of changing
       the dimensions at runtime, this effort has the positive effect that
       all source modules can be compiled in the "NEAR" data segment, thus
       making the programs "pure" and enabling them to be made "resident"
       on the Amiga.

     - OUTPUT: All three programs of the CWEB system write into
       temporary files first, then they check if there are any
       differences between the current run and possible earlier runs
       and their results, before activating the output "for real".

     - SYSTEM DEPENDENCIES: Should be clear.  These changes are caused
       by porting CWEB to other systems than UNIX.  Care has been taken
       to make these points safe on all machines.

     - TRANSLATION: For support of the "locale.library" mechanism of the
       Commodore Amiga, all internal strings of characters have been
       replaced by references to an external array in "cweb.h".  The
       portable part of this produces the English default, but on the
       Amiga system support for other languages is given by means of
       "language catalogs".

This program is distributed WITHOUT ANY WARRANTY, express or implied.

The following copyright notice extends to this changefile only, not to
the masterfile CTANGLE.W.

Copyright (C) 1993,1994 Andreas Scherer
Copyright (C) 1991-1993 Hans-Hermann Bode

Permission is granted to make and distribute verbatim copies of this
document provided that the copyright notice and this permission notice
are preserved on all copies.

Permission is granted to copy and distribute modified versions of this
document under the conditions for verbatim copying, provided that the
entire resulting derived work is given a different name and distributed
under the terms of a permission notice identical to this one.

Version history:

Version	Date		Author	Comment
a1/t1	10 Oct 1991	H2B	First attempt for CTANGLE.W 2.0.
p2	13 Feb 1992	H2B	Updated for CTANGLE.W 2.2, ANSI and Turbo
				changefiles merged together.
p3	16 Apr 1992	H2B	Updated for CTANGLE.W 2.4.
p4	21 Jun 1992	H2B	Nothing changed.
p5	18 Jul 1992	H2B	Extensions for C++ implemented.
p5a	24 Jul 1992	KG	adaptions for other ANSI C compiler
p5b	28 Jul 1992	H2B	Remaining headers converted to ANSI style.
p6	06 Sep 1992	H2B	Updated for CTANGLE.W 2.7, |dot_dot_dot|
				added, parsing of @@'\'' fixed (due to KG),
				@@<Copy an ASCII constant@@> extended,
				(nonfatal) confusion in processing short
				comments fixed.
p6a     15 Mar 1993     AS      Re-changing some of the TC stuff to SAS/C
p6b     27 Jul 1993     AS      new patch level in accordance with CWeave
p6c	04 Sep 1993	AS	new patch level in accordance with Common
p6d	09 Oct 1993	AS	Updated for CTANGLE.W 2.8. (This was p7)
p7	13 Nov 1992	H2B	Converted to master change file, updated for
				CTANGLE.W 2.8. [Not released.]
p7.5	29 Nov 1992	H2B	Updated for CTANGLE.W 2.9beta. [Not released.]
p8	08 Dec 1992	H2B	Updated for CTANGLE.W 2.9++ (stuff went into
				the source file), ANSI bug in <Get a constant>
				fixed. [Not released.]
p8a	10 Mar 1993	H2B	Restructured for public release.
				[Not released.]
p8b	14 Apr 1993	H2B	Updated for CTANGLE.W 3.0beta. [Not released.]
p8c	21 Jun 1993	H2B	Updated for final CTANGLE.W 3.0.
p8d	25 Oct 1993	AS	Incorporated into Amiga version 2.8 [p7] and
				updated for version 3.0.
p8e	04 Nov 1993	AS	New patch level in accordance with COMMON.
p9	18 Nov 1993	AS	Updated for CTANGLE.W 3.1.
p9a	30 Nov 1993	AS	Minor changes and corrections.
p9b	06 Dec 1993	AS	Multilinguality implemented.
p9c	18 Jan 1994	AS	Version information included.
p9d	13 May 1994	AS	Dynamic memory allocation.
	02 Jul 1994	AS	Portability version.
p10	12 Aug 1994	AS	Updated for CTANGLE.W 3.2.
p10a	24 Aug 1994	AS	New patch level.
	26 Sep 1994	AS	Replace `calloc' by `malloc'.
p10b	11 Oct 1994	AS	Write to check_file and compare results.
	18 Oct 1994	AS	Some refinements for C++ compilation.
	12 Nov 1994	AS	Use SEPARATORS instead of the multi-way
				selection for '/', ':', '\', etc.
	13 Nov 1994	AS	Take care of opened system resources and
				temporary files in case of an user abort.
	25 Nov 1994	AS	CWEB 3.2 [p10b] works with Boheyland 3.1.
				Reduce `max_toks' drastically.
p11	03 Dec 1994	AS	Updated for CWEB 3.3.
------------------------------------------------------------------------------
@x l.1
% This file is part of CWEB.
% This program by Silvio Levy and Donald E. Knuth
% is based on a program by Knuth.
% It is distributed WITHOUT ANY WARRANTY, express or implied.
% Version 3.3 --- December 1994

% Copyright (C) 1987,1990,1993 Silvio Levy and Donald E. Knuth
@y
% This file, CTANGLE.W, is part of CWEB.
% This program by Silvio Levy and Donald E. Knuth
% is based on a program by Knuth.
% It is distributed WITHOUT ANY WARRANTY, express or implied.
% Version 2.4 --- Don Knuth, April 1992
% Version 2.4 [p5] --- Hans-Hermann Bode, July 1992
% Version 2.4 [p5a] --- Klaus Guntermann, July 1992
% Version 2.4 [p5b] --- Hans-Hermann Bode, July 1992
% Version 2.7 --- Don Knuth, July 1992
% Version 2.7 [p6] --- Hans-Hermann Bode, September 1992
% Version 2.7 [p6a] --- Andreas Scherer, March 1993
% Version 2.7 [p6b] --- Andreas Scherer, July 1993
% Version 2.7 [p6c] --- Andreas Scherer, September 1993
% Version 2.8 --- Don Knuth, September 1992
% Version 2.8 [p7] --- Andreas Scherer, October 1993
% Version 3.0 --- Don Knuth, June 1993
% Version 3.0 [p8c] --- Hans-Hermann Bode, June 1993
% Version 3.0 [p8d] --- Andreas Scherer, October 1993
% Version 3.0 [p8e] --- Andreas Scherer, November 1993
% Version 3.1 --- Don Knuth, November 1993
% Version 3.1 [p9] --- Andreas Scherer, November 1993
% Version 3.1 [p9a] --- Andreas Scherer, November 1993
% Version 3.1 [p9b] --- Andreas Scherer, December 1993
% Version 3.1 [p9c] --- Andreas Scherer, January 1994
% Version 3.1 [p9d] --- Andreas Scherer, July 1994
% Version 3.2 --- Don Knuth, July 1994
% Version 3.2 [p10] --- Andreas Scherer, August 1994
% Version 3.2 [p10a] --- Andreas Scherer, September 1994
% Version 3.2 [p10b] --- Andreas Scherer, October 1994
% Version 3.3 --- Don Knuth, December 1994
% Version 3.3 [p11] --- Andreas Scherer, December 1994

% Copyright (C) 1987,1990,1993 Silvio Levy and Donald E. Knuth
% Copyright (C) 1991-1993 Hans-Hermann Bode
% Copyright (C) 1993,1994 Andreas Scherer
@z
------------------------------------------------------------------------------
@x l.25
\def\title{CTANGLE (Version 3.3)}
@y
\def\title{CTANGLE (Version 3.3 [p11])}
@z
------------------------------------------------------------------------------
@x l.29
  \centerline{(Version 3.3)}
@y
  \centerline{(Version 3.3 [p11])}
@z
------------------------------------------------------------------------------
@x l.33
Copyright \copyright\ 1987, 1990, 1993 Silvio Levy and Donald E. Knuth
@y
Copyright \copyright\ 1987, 1990, 1993 Silvio Levy and Donald E. Knuth
\smallskip\noindent
Copyright \copyright\ 1991--1993 Hans-Hermann Bode
\smallskip\noindent
Copyright \copyright\ 1993, 1994 Andreas Scherer
@z
------------------------------------------------------------------------------
Activate this, if only the changed modules should be printed.
x l.46
\let\maybe=\iftrue
y
\let\maybe=\iffalse
z
------------------------------------------------------------------------------
TRANSLATION
@x l.59
@d banner "This is CTANGLE (Version 3.3)\n"
@y
@d banner get_string(MSG_BANNER_CT1)
@z
------------------------------------------------------------------------------
ANSI
@x l.69
@ We predeclare several standard system functions here instead of including
their system header files, because the names of the header files are not as
standard as the names of the functions. (For example, some \CEE/ environments
have \.{<string.h>} where others have \.{<strings.h>}.)

@<Predecl...@>=
extern int strlen(); /* length of string */
extern int strcmp(); /* compare strings lexicographically */
extern char* strcpy(); /* copy one string to another */
extern int strncmp(); /* compare up to $n$ string characters */
extern char* strncpy(); /* copy up to $n$ string characters */
@y
@ For string handling we include the {\mc ANSI C} system header file instead
of predeclaring the standard system functions |strlen|, |strcmp|, |strcpy|,
|strncmp|, and |strncpy|.
@^system dependencies@>

@<Include files@>=
#include <string.h>
@z
------------------------------------------------------------------------------
ANSI
@x l.89
int main (ac, av)
int ac;
char **av;
@y
int main (int ac, char **av)
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.95
  @<Set initial values@>;
  common_init();
@y
  common_init();
  @<Set initial values@>;
@z
==============================================================================
The following changes will effect `common.h', so the line numbers refer
to a different source file!
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.24
First comes general stuff:

@y
First comes general stuff.
In {\mc TURBO} \CEE/, we use |huge| pointers instead of large arrays.
@^system dependencies@>

@f far int
@f huge int
@f HUGE int
@#
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.33
extern int phase; /* which phase are we in? */
@y
extern int phase; /* which phase are we in? */
@#
#ifdef __TURBOC__
#define HUGE huge
#else
#define HUGE
#endif
@^system dependencies@>
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, TRANSLATION
@x l.35
@ @<Include files@>=
#include <stdio.h>
@y
@ Version~2.1 of the {\mc AMIGA} operating system introduced localization
of programs and applications by means of ``language catalogs'' that contain
replacement strings for terminal texts produced by suitably prepared programs.
The complete \.{CWEB} system has been modified to accommodate this great idea
and so the \.{cweb.h} header file with the original English strings is
included in this section.  Other systems than the {\mc AMIGA} will have to do
the language conversion by different means, so a little bit of care is to be
taken with what follows.
@^system dependencies@>

@f type int /* \.{type} becomes the pseudotype \&{type} */
@#
@d alloc_object(object,size,@!type)
   if(!(object = (type *)malloc((size)*sizeof(type))))
      fatal("",get_string(MSG_FATAL_CO85));

@<Include files@>=
#include <stdio.h>
@#
#ifdef __TURBOC__
#include <io.h>
#endif
@#
#ifndef _AMIGA /* non-{\mc AMIGA} systems don't know about \.{<exec/types.h>} */
typedef long int LONG; /* excerpt from \.{<exec/types.h>} */
typedef char * STRPTR; /* ditto, but \UNIX/ says it's signed. */
#define EXEC_TYPES_H 1 /* don't include \.{<exec/types.h>} in \.{"cweb.h"} */
#endif
@#
#ifdef STRINGARRAY
#undef STRINGARRAY /* don't include the string array |AppStrings| again */
#endif
#define get_string(n) AppStrings[n].as_Str
@#
#include "cweb.h"
@#
struct AppString
{
   LONG   as_ID;
   STRPTR as_Str;
};
@#
extern struct AppString AppStrings[];
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.58
char section_text[longest_name+1]; /* name being sought for */
char *section_text_end = section_text+longest_name; /* end of |section_text| */
@y
char *section_text; /* name being sought for */
char *section_text_end; /* end of |section_text| */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.73
extern char buffer[]; /* where each line of input goes */
@y
extern char *buffer; /* where each line of input goes */
@z
------------------------------------------------------------------------------
ANSI
@x l.79
@d length(c) (c+1)->byte_start-(c)->byte_start /* the length of a name */
@y
@d length(c) (size_t)((c+1)->byte_start-(c)->byte_start) /* the length of a name */
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, MEMORY ALLOCATION
@x l.88
typedef struct name_info {
  char *byte_start; /* beginning of the name in |byte_mem| */
  struct name_info *link;
  union {
    struct name_info *Rlink; /* right link in binary search tree for section
      names */
    char Ilk; /* used by identifiers in \.{CWEAVE} only */
  } dummy;
  char *equiv_or_xref; /* info corresponding to names */
} name_info; /* contains information about an identifier or section name */
typedef name_info *name_pointer; /* pointer into array of \&{name\_info}s */
typedef name_pointer *hash_pointer;
extern char byte_mem[]; /* characters of names */
extern char *byte_mem_end; /* end of |byte_mem| */
extern name_info name_dir[]; /* information about names */
extern name_pointer name_dir_end; /* end of |name_dir| */
extern name_pointer name_ptr; /* first unused position in |byte_start| */
extern char *byte_ptr; /* first unused position in |byte_mem| */
@y
typedef struct name_info {
  char HUGE *byte_start; /* beginning of the name in |byte_mem| */
  struct name_info HUGE *link;
  union {
    struct name_info HUGE *Rlink; /* right link in binary search tree for section
      names */  
    char Ilk; /* used by identifiers in \.{WEAVE} only */
  } dummy;
  void HUGE *equiv_or_xref; /* info corresponding to names */
} name_info; /* contains information about an identifier or section name */
typedef name_info HUGE *name_pointer; /* pointer into array of |name_info|s */
typedef name_pointer *hash_pointer;
extern name_pointer name_dir; /* information about names */
extern name_pointer name_dir_end; /* end of |name_dir| */
extern name_pointer name_ptr; /* first unused position in |byte_start| */
extern char HUGE *byte_mem; /* characters of names */
extern char HUGE *byte_mem_end; /* end of |byte_mem| */
extern char HUGE *byte_ptr; /* first unused position in |byte_mem| */
#ifdef __TURBOC__
extern void far *allocsafe(unsigned long,unsigned long);
#endif
@^system dependencies@>
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.106
extern name_pointer hash[]; /* heads of hash lists */
@y
extern name_pointer *hash; /* heads of hash lists */
@z
------------------------------------------------------------------------------
ANSI
@x l.109
extern name_pointer id_lookup(); /* looks up a string in the identifier table */
extern name_pointer section_lookup(); /* finds section name */
extern void print_section_name(), sprint_section_name();
@y
extern int names_match(name_pointer,char *,int,eight_bits);@/
extern name_pointer id_lookup(char *,char *,char);
   /* looks up a string in the identifier table */
extern name_pointer prefix_lookup(char *,char *); /* finds section name given a prefix */
extern name_pointer section_lookup(char *,char *,int);@/
extern void init_node(name_pointer);@/
extern void init_p(name_pointer,eight_bits);@/
extern void print_prefix_name(name_pointer);@/
extern void print_section_name(name_pointer);@/
extern void sprint_section_name(char *,name_pointer);@/
@z
------------------------------------------------------------------------------
ANSI, TRANSLATION
@x l.117
@d fatal_message 3 /* |history| value when we had to stop prematurely */
@d mark_harmless {if (history==spotless) history=harmless_message;}
@d mark_error history=error_message
@d confusion(s) fatal("! This can't happen: ",s)

@<Common...@>=
extern history; /* indicates how bad this run was */
extern err_print(); /* print error message and context */
extern wrap_up(); /* indicate |history| and exit */
extern void fatal(); /* issue error message and die */
extern void overflow(); /* succumb because a table has overflowed */
@y
@d fatal_message 3 /* |history| value when we had to stop prematurely */
@d mark_harmless {if (history==spotless) history=harmless_message;}
@d mark_error history=error_message
@d confusion(s) fatal(get_string(MSG_FATAL_CO66),s)

@<Common...@>=
extern history; /* indicates how bad this run was */
extern int wrap_up(void); /* indicate |history| and exit */
extern void err_print(char *); /* prints error message and context */
extern void fatal(char *,char *); /* issue error message and die */
extern void overflow(char *); /* succumb because a table has overflowed */
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.131
@d max_file_name_length 60
@y
@d max_file_name_length 256
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION, OUTPUT
@x l.139
extern FILE *file[]; /* stack of non-change files */
extern FILE *change_file; /* change file */
extern char C_file_name[]; /* name of |C_file| */
extern char tex_file_name[]; /* name of |tex_file| */
extern char idx_file_name[]; /* name of |idx_file| */
extern char scn_file_name[]; /* name of |scn_file| */
extern char file_name[][max_file_name_length];
  /* stack of non-change file names */
extern char change_file_name[]; /* name of change file */
extern line[]; /* number of current line in the stacked files */
@y
extern FILE **file; /* stack of non-change files */
extern FILE *change_file; /* change file */
extern char *C_file_name; /* name of |C_file| */
extern char *tex_file_name; /* name of |tex_file| */
extern char *idx_file_name; /* name of |idx_file| */
extern char *scn_file_name; /* name of |scn_file| */
extern char *check_file_name; /* name of |check_file| */
extern char **file_name; /* stack of non-change file names */
extern char *change_file_name; /* name of change file */
extern char *use_language; /* prefix to \.{cwebmac.tex} in \TEX/ output */
extern int *line; /* number of current line in the stacked files */
@z
------------------------------------------------------------------------------
ANSI
@x l.153
extern reset_input(); /* initialize to read the web file and change file */
extern get_line(); /* inputs the next line */
extern check_complete(); /* checks that all changes were picked up */
@y
extern boolean get_line(void); /* inputs the next line */
extern void check_complete(void); /* checks that all changes were picked up */
extern void reset_input(void); /* initialize to read the web file and change file */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.161
extern boolean changed_section[]; /* is the section changed? */
@y
extern boolean *changed_section; /* is the section changed? */
@z
------------------------------------------------------------------------------
EXTENSIONS
@x l.165
@ Code related to command line arguments:
@d show_banner flags['b'] /* should the banner line be printed? */
@d show_progress flags['p'] /* should progress reports be printed? */
@d show_happiness flags['h'] /* should lack of errors be announced? */
@y
@ Code related to command line arguments:
@d show_banner flags['b'] /* should the banner line be printed? */
@d show_happiness flags['h'] /* should lack of errors be announced? */
@d show_progress flags['p'] /* should progress reports be printed? */
@d indent_param_decl flags['i'] /* should formal parameter declarations be indented? */
@d send_error_messages flags['m'] /* should {\mc AREXX} communication be used? */
@d order_decl_stmt flags['o'] /* should declarations and statements be separated? */
@z
------------------------------------------------------------------------------
@x l.173
extern boolean flags[]; /* an option for each 7-bit code */
@y
extern boolean flags[]; /* an option for each 8-bit code */
@z
------------------------------------------------------------------------------
OUTPUT
@x l.186
extern FILE *scn_file; /* where list of sections from \.{CWEAVE} goes */
@y
extern FILE *scn_file; /* where list of sections from \.{CWEAVE} goes */
extern FILE *check_file; /* temporary output file */
@z
------------------------------------------------------------------------------
ANSI
@x l.192
extern void common_init();
@y
extern void common_init(void);
extern void print_stats(void);
@z
==============================================================================
SYSTEM DEPENDENCIES
@x l.151
  eight_bits *tok_start; /* pointer into |tok_mem| */
@y
  eight_bits HUGE *tok_start; /* pointer into |tok_mem| */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.157
text text_info[max_texts];
text_pointer text_info_end=text_info+max_texts-1;
@y
text_pointer text_info;
text_pointer text_info_end;
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION, SYSTEM DEPENDENCIES
@x l.160
eight_bits tok_mem[max_toks];
eight_bits *tok_mem_end=tok_mem+max_toks-1;
eight_bits *tok_ptr; /* first unused position in |tok_mem| */
@y
eight_bits HUGE *tok_mem;
eight_bits HUGE *tok_mem_end;
eight_bits HUGE *tok_ptr; /* first unused position in |tok_mem| */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION, SYSTEM DEPENDENCIES
@x l.165
text_info->tok_start=tok_ptr=tok_mem;
@y
alloc_object(section_text,longest_name+1,char);
section_text_end = section_text + longest_name;
alloc_object(text_info,max_texts,text);
text_info_end = text_info + max_texts - 1;
#ifdef __TURBOC__
#undef max_toks
#define max_toks 170000
tok_mem=(eight_bits HUGE *)allocsafe(max_toks,sizeof(*tok_mem));
#else
alloc_object(tok_mem,max_toks,eight_bits);
#endif
tok_mem_end = tok_mem + max_toks - 1;
text_info->tok_start=tok_ptr=tok_mem;
alloc_object(stack,stack_size+1,output_state);
stack_end = stack + stack_size;
@^system dependencies@>
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.175
name_dir->equiv=(char *)text_info; /* the undefined section has no replacement text */
@y
name_dir->equiv=(void HUGE *)text_info; /* the undefined section has no replacement text */
@z
------------------------------------------------------------------------------
ANSI
@x l.181
int names_match(p,first,l)
name_pointer p; /* points to the proposed match */
char *first; /* position of first character of string */
int l; /* length of identifier */
@y
int names_match(@t\1\1@>
  name_pointer p, /* points to the proposed match */
  char *first, /* position of first character of string */
  int l, /* length of identifier */
  eight_bits dummy@t\2\2@>) /* not used by \.{TANGLE} */
@z
------------------------------------------------------------------------------
ANSI
@x l.196
void
init_node(node)
name_pointer node;
@y
void init_node(name_pointer node)
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.200
    node->equiv=(char *)text_info;
@y
    node->equiv=(void HUGE *)text_info;
@z
------------------------------------------------------------------------------
ANSI
@x l.202
void
init_p() {}
@y
void init_p(name_pointer dummy1,eight_bits dummy2)
{}
@z
------------------------------------------------------------------------------
ANSI
@x l.258
void
store_two_bytes(x)
sixteen_bits x;
@y
static void store_two_bytes(sixteen_bits x)
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.262
  if (tok_ptr+2>tok_mem_end) overflow("token");
@y
  if (tok_ptr+2>tok_mem_end) overflow(get_string(MSG_OVERFLOW_CT26));
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.295
  eight_bits *end_field; /* ending location of replacement text */
  eight_bits *byte_field; /* present location within replacement text */
@y
  eight_bits HUGE *end_field; /* ending location of replacement text */
  eight_bits HUGE *byte_field; /* present location within replacement text */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.312
output_state stack[stack_size+1]; /* info for non-current levels */
stack_pointer stack_ptr; /* first unused location in the output state stack */
stack_pointer stack_end=stack+stack_size; /* end of |stack| */
@y
stack_pointer stack; /* info for non-current levels */
stack_pointer stack_end; /* end of |stack| */
stack_pointer stack_ptr; /* first unused location in the output state stack */
@z
------------------------------------------------------------------------------
ANSI, TRANSLATION
@x l.334
void
push_level(p) /* suspends the current level */
name_pointer p;
{
  if (stack_ptr==stack_end) overflow("stack");
@y
static void push_level(name_pointer p) /* suspends the current level */
{
  if (stack_ptr==stack_end) overflow(get_string(MSG_OVERFLOW_CT30));
@z
------------------------------------------------------------------------------
ANSI
@x l.353
void
pop_level(flag) /* do this when |cur_byte| reaches |cur_end| */
int flag; /* |flag==0| means we are in |output_defs| */
@y
static void pop_level(int flag) /* do this when |cur_byte| reaches |cur_end| */
@z
------------------------------------------------------------------------------
ANSI
@x l.389
void
get_output() /* sends next token to |out_char| */
@y
static void get_output(void) /* sends next token to |out_char| */
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, TRANSLATION
@x l.423
  if ((a+name_dir)->equiv!=(char *)text_info) push_level(a+name_dir);
  else if (a!=0) {
    printf("\n! Not present: <");
@y
  if ((a+name_dir)->equiv!=(void HUGE *)text_info) push_level(a+name_dir);
  else if (a!=0) {
    printf(get_string(MSG_ERROR_CT34));
@z
------------------------------------------------------------------------------
ANSI
@x l.476
void
flush_buffer() /* writes one line to output file */
@y
static void flush_buffer(void) /* writes one line to output file */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.497
name_pointer output_files[max_files];
name_pointer *cur_out_file, *end_output_files, *an_output_file;
char cur_section_name_char; /* is it |'<'| or |'('| */
char output_file_name[longest_name]; /* name of the file */

@ We make |end_output_files| point just beyond the end of
|output_files|. The stack pointer
|cur_out_file| starts out there. Every time we see a new file, we
decrement |cur_out_file| and then write it in.
@<Set initial...@>=
cur_out_file=end_output_files=output_files+max_files;
@y
name_pointer *output_files;
name_pointer *cur_out_file, *end_output_files, *an_output_file;
char cur_section_name_char; /* is it |'<'| or |'('| */
char *output_file_name; /* name of the file */

@ We make |end_output_files| point just beyond the end of
|output_files|. The stack pointer
|cur_out_file| starts out there. Every time we see a new file, we
decrement |cur_out_file| and then write it in.

@<Set initial...@>=
alloc_object(output_files,max_files,name_pointer);
alloc_object(output_file_name,longest_name,char);
cur_out_file=end_output_files=output_files+max_files;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.519
      overflow("output files");
@y
      overflow(get_string(MSG_OVERFLOW_CT40));
@z
------------------------------------------------------------------------------
ANSI
@x l.527
@<Predecl...@>=
void phase_two();

@ @c
void
phase_two () {
@y
@<Predecl...@>=
static void phase_two(void);

@ @c
static void phase_two (void) {
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.538
    printf("\n! No program text was specified."); mark_harmless;
@y
    printf(get_string(MSG_WARNING_CT42)); mark_harmless;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.544
        printf("\nWriting the output file (%s):",C_file_name);
@y
        printf(get_string(MSG_PROGRESS_CT42_1),C_file_name);
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.548
        printf("\nWriting the output files:");
@y
        printf(get_string(MSG_PROGRESS_CT42_2));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.558
    if(show_happiness) printf("\nDone.");
@y
    if(show_happiness) printf(get_string(MSG_PROGRESS_CT42_3));
@z
------------------------------------------------------------------------------
TRANSLATION, OUTPUT
@x l.566
@<Write all the named output files@>=
for (an_output_file=end_output_files; an_output_file>cur_out_file;) {
    an_output_file--;
    sprint_section_name(output_file_name,*an_output_file);
    fclose(C_file);
    C_file=fopen(output_file_name,"w");
    if (C_file ==0) fatal("! Cannot open output file:",output_file_name);
@.Cannot open output file@>
    printf("\n(%s)",output_file_name); update_terminal;
    cur_line=1;
    stack_ptr=stack+1;
    cur_name= (*an_output_file);
    cur_repl= (text_pointer)cur_name->equiv;
    cur_byte=cur_repl->tok_start;
    cur_end=(cur_repl+1)->tok_start;
    while (stack_ptr > stack) get_output();
    flush_buffer();
}
@y
@<Write all the named output files@>=
fclose(C_file); C_file=NULL;
@<Update the primary result when it has changed@>@;
for (an_output_file=end_output_files; an_output_file>cur_out_file;) {
    an_output_file--;
    sprint_section_name(output_file_name,*an_output_file);
    C_file=fopen(check_file_name,"w");
    if (C_file ==0) fatal(get_string(MSG_FATAL_CO78),check_file_name);
@.Cannot open output file@>
    printf("\n(%s)",output_file_name); update_terminal;
    cur_line=1;
    stack_ptr=stack+1;
    cur_name= (*an_output_file);
    cur_repl= (text_pointer)cur_name->equiv;
    cur_byte=cur_repl->tok_start;
    cur_end=(cur_repl+1)->tok_start;
    while (stack_ptr > stack) get_output();
    flush_buffer(); fclose(C_file); C_file=NULL;
    @<Update the secondary results when they have changed@>@;
}
check_file_name=NULL; /* We want to get rid of the temporary file */
@z
------------------------------------------------------------------------------
ANSI
@x l.596
@ @<Predecl...@>=
void output_defs();

@ @c
void
output_defs()
@y
@ @<Predecl...@>=
static void output_defs(void);

@ @c
static void output_defs(void)
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.623
          else if (a<050000) { confusion("macro defs have strange char");}
@y
          else if (a<050000) { confusion(get_string(MSG_CONFUSION_CT47));}
@z
------------------------------------------------------------------------------
ANSI, SYSTEM DEPENDENCIES
@x l.642
@<Predecl...@>=
static void out_char();

@ @c
static void
out_char(cur_char)
eight_bits cur_char;
{
  char *j, *k; /* pointer into |byte_mem| */
@y
@<Predecl...@>=
static void out_char(eight_bits);

@ @c
static void out_char(eight_bits cur_char)
{
  char HUGE *j;
  char HUGE *k; /* pointer into |byte_mem| */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.701
char translit[128][translit_length];

@ @<Set init...@>=
{
  int i;
  for (i=0;i<128;i++) sprintf(translit[i],"X%02X",(unsigned)(128+i));
}
@y
char **translit;

@ @<Set init...@>=
{
  int i;
  alloc_object(translit,128,char *);
  for(i=0; i<128; i++)
    alloc_object(translit[i],translit_length,char);
  for (i=0;i<128;i++)
    sprintf(translit[i],"X%02X",(unsigned)(128+i));
}
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.777
eight_bits ccode[256]; /* meaning of a char following \.{@@} */

@ @<Set ini...@>= {
  int c; /* must be |int| so the |for| loop will end */
@y
eight_bits *ccode; /* meaning of a char following \.{@@} */

@ @<Set ini...@>= {
  int c; /* must be |int| so the |for| loop will end */
  alloc_object(ccode,256,eight_bits);
@z
------------------------------------------------------------------------------
ANSI
@x l.801
eight_bits
skip_ahead() /* skip to next control code */
@y
static eight_bits skip_ahead(void) /* skip to next control code */
@z
------------------------------------------------------------------------------
ANSI
@x l.836
int skip_comment(is_long_comment) /* skips over comments */
boolean is_long_comment;
@y
static int skip_comment(boolean is_long_comment) /* skips over comments */
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.845
          err_print("! Input ended in mid-comment");
@y
          err_print(get_string(MSG_ERROR_CT60_1));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.858
        err_print("! Section name ended in mid-comment"); loc--;
@y
        err_print(get_string(MSG_ERROR_CT60_2)); loc--;
@z
------------------------------------------------------------------------------
ANSI
@x l.887
eight_bits
get_next() /* produces the next input token */
@y
static eight_bits get_next(void) /* produces the next input token */
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1005
        err_print("! String didn't end"); loc=limit; break;
@y
        err_print(get_string(MSG_ERROR_CT67_1)); loc=limit; break;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1009
        err_print("! Input ended in middle of string"); loc=buffer; break;
@y
        err_print(get_string(MSG_ERROR_CT67_2)); loc=buffer; break;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1027
    printf("\n! String too long: ");
@y
    printf(get_string(MSG_ERROR_CT67_3));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1044
    case translit_code: err_print("! Use @@l in limbo only"); continue;
@y
    case translit_code: err_print(get_string(MSG_ERROR_CT68_1)); continue;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1049
        err_print("! Double @@ should be used in control text");
@y
        err_print(get_string(MSG_ERROR_CT68_2));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1075
        err_print("! Double @@ should be used in ASCII constant");
@y
        err_print(get_string(MSG_ERROR_CT69));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1081
        err_print("! String didn't end"); loc=limit-1; break;
@y
        err_print(get_string(MSG_ERROR_CT67_1)); loc=limit-1; break;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1112
    err_print("! Input ended in section name");
@y
    err_print(get_string(MSG_ERROR_CT72_1));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1125
  printf("\n! Section name too long: ");
@y
  printf(get_string(MSG_ERROR_CT72_2));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1139
    err_print("! Section name didn't end"); break;
@y
    err_print(get_string(MSG_ERROR_CT73_1)); break;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1143
    err_print("! Nesting of section names not allowed"); break;
@y
    err_print(get_string(MSG_ERROR_CT73_2)); break;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1157
  if (loc>=limit) err_print("! Verbatim string didn't end");
@y
  if (loc>=limit) err_print(get_string(MSG_ERROR_CT74));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1183
@d app_repl(c)  {if (tok_ptr==tok_mem_end) overflow("token"); *tok_ptr++=c;}
@y
@d app_repl(c)
  {if (tok_ptr==tok_mem_end)
     overflow(get_string(MSG_OVERFLOW_CT26));
   *tok_ptr++=c;}
@z
------------------------------------------------------------------------------
ANSI
@x l.1190
void
scan_repl(t) /* creates a replacement text */
eight_bits t;
@y
static void scan_repl(eight_bits t) /* creates a replacement text */
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1207
  if (text_ptr>text_info_end) overflow("text");
@y
  if (text_ptr>text_info_end) overflow(get_string(MSG_OVERFLOW_CT76));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1248
    err_print("! @@d, @@f and @@c are ignored in C text"); continue;
@y
    err_print(get_string(MSG_ERROR_CT78)); continue;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1258
  if (*try_loc=='=') err_print ("! Missing `@@ ' before a named section");
@y
  if (*try_loc=='=') err_print (get_string(MSG_ERROR_CT79));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1269
      else err_print("! Double @@ should be used in string");
@y
      else err_print(get_string(MSG_ERROR_CT80));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1316
    default: err_print("! Unrecognized escape sequence");
@y
    default: err_print(get_string(MSG_ERROR_CT81));
@z
------------------------------------------------------------------------------
ANSI
@x l.1343
void
scan_section()
@y
static void scan_section(void)
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1391
    err_print("! Definition flushed, must start with identifier");
@y
    err_print(get_string(MSG_ERROR_CT85));
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.1431
else if (p->equiv==(char *)text_info) p->equiv=(char *)cur_text;
@y
else if (p->equiv==(void HUGE *)text_info) p->equiv=(void HUGE *)cur_text;
@z
------------------------------------------------------------------------------
ANSI
@x l.1442
@ @<Predec...@>=
void phase_one();

@ @c
void
phase_one() {
@y
@ @<Predec...@>=
static void phase_one(void);

@ @c
static void phase_one(void) {
@z
------------------------------------------------------------------------------
ANSI
@x l.1460
@<Predecl...@>=
void skip_limbo();

@ @c
void
skip_limbo()
@y
@<Predecl...@>=
static void skip_limbo(void);

@ @c
static void skip_limbo(void)
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1481
            err_print("! Double @@ should be used in control text");
@y
            err_print(get_string(MSG_ERROR_CT68_2));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1485
        default: err_print("! Double @@ should be used in limbo");
@y
        default: err_print(get_string(MSG_ERROR_CT93));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1497
    err_print("! Improper hex number following @@l");
@y
    err_print(get_string(MSG_ERROR_CT94_1));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1507
      err_print("! Replacement string in @@l too long");
@y
      err_print(get_string(MSG_ERROR_CT94_2));
@z
------------------------------------------------------------------------------
ANSI
@x l.1510
      strncpy(translit[i-0200],beg,loc-beg);
@y
      strncpy(translit[i-0200],beg,(size_t)(loc-beg));
@z
------------------------------------------------------------------------------
ANSI, TRANSLATION
@x l.1515
@ Because on some systems the difference between two pointers is a |long|
but not an |int|, we use \.{\%ld} to print these quantities.

@c
void
print_stats() {
  printf("\nMemory usage statistics:\n");
  printf("%ld names (out of %ld)\n",
          (long)(name_ptr-name_dir),(long)max_names);
  printf("%ld replacement texts (out of %ld)\n",
          (long)(text_ptr-text_info),(long)max_texts);
  printf("%ld bytes (out of %ld)\n",
          (long)(byte_ptr-byte_mem),(long)max_bytes);
  printf("%ld tokens (out of %ld)\n",
          (long)(tok_ptr-tok_mem),(long)max_toks);
}
@y
@ {\mc ANSI C} declares the difference between two pointers to be of type
|ptrdiff_t| which equals |long| on (almost) all systems instead of |int|,
so we use \.{\%ld} to print these quantities and cast them to |long|
explicitly.

@c
void print_stats(void) {
  printf(get_string(MSG_STATS_CT95_1));
  printf(get_string(MSG_STATS_CT95_2),
          (long)(name_ptr-name_dir),(long)max_names);
  printf(get_string(MSG_STATS_CT95_3),
          (long)(text_ptr-text_info),(long)max_texts);
  printf(get_string(MSG_STATS_CT95_4),
          (long)(byte_ptr-byte_mem),(long)max_bytes);
  printf(get_string(MSG_STATS_CT95_5),
          (long)(tok_ptr-tok_mem),(long)max_toks);
}
@z
------------------------------------------------------------------------------
ANSI, SYSTEM DEPENDENCIES, OUTPUT
@x l.1532
@** Index.
@y
@** Function declarations.  Here are declarations---conforming to
{\mc ANSI~C}---of all functions in this code, as far as they are
not already in |"common.h"|.  These are private to \.{CTANGLE}.

@<Predecl...@>=
static eight_bits get_next(void);@/
static eight_bits skip_ahead(void);@/
static int skip_comment(boolean);@/
static void flush_buffer(void);@/
static void get_output(void);@/
static void pop_level(int);@/
static void push_level(name_pointer);@/
static void scan_repl(eight_bits);@/
static void scan_section(void);@/
static void store_two_bytes(sixteen_bits);

@* Version information.  The {\mc AMIGA} operating system provides the
`version' command and good programs answer with some informations about
their creation date and their current version.
@^system dependencies@>

@<Glob...@>=
#ifdef __SASC
const char Version[] = "$VER: CTangle 3.3 [p11] ("__DATE__", "__TIME__")\n";
#endif

@* Output file update.  Most \CEE/ projects are controlled by a
\.{makefile} which automatically takes care of the temporal dependecies
between the different source modules.  It is suitable that \.{CWEB} doesn't
create new output for all existing files, when there are only changes to
some of them. Thus the \.{make} process will only recompile those modules
where necessary. The idea and basic implementation of this mechanism can
be found in the program \.{NUWEB} by Preston Briggs, to whom credit is due.

@d free_object(object)
   if(object) {
      free(object);
      object=NULL;
      }

@<Update the primary result...@>=
if(C_file=fopen(C_file_name,"r")) {
  char *x,*y;
  int x_size,y_size;

  if(!(check_file=fopen(check_file_name,"r")))
    fatal(get_string(MSG_FATAL_CO78),check_file_name);

  alloc_object(x,BUFSIZ,char);
  alloc_object(y,BUFSIZ,char);

  @<Compare the temporary output to the previous output@>@;

  fclose(C_file); C_file=NULL;
  fclose(check_file); check_file=NULL;

  @<Create the primary output depending on the comparison@>@;

  free_object(y);
  free_object(x);
  }
else
  rename(check_file_name,C_file_name); /* This was the first run */

@ We hope that this runs fast on most systems.

@<Compare the temp...@>=
do {
  x_size = fread(x,1,BUFSIZ,C_file);
  y_size = fread(y,1,BUFSIZ,check_file);
  } while((x_size == y_size) && !memcmp(x,y,x_size) &&
          !feof(C_file) && !feof(check_file));

@ Note the superfluous call to |remove| before |rename|.  We're using it to
get around a bug in some implementations of |rename|.

@<Create the primary output...@>=
if((x_size != y_size) || memcmp(x,y,x_size)) {
  remove(C_file_name);
  rename(check_file_name,C_file_name);
  }
else
  remove(check_file_name);

@ @<Update the secondary results...@>=
if(C_file=fopen(output_file_name,"r")) {
  char *x,*y;
  int x_size,y_size;

  if(!(check_file=fopen(check_file_name,"r")))
    fatal(get_string(MSG_FATAL_CO78),check_file_name);

  alloc_object(x,BUFSIZ,char);
  alloc_object(y,BUFSIZ,char);

  @<Compare the temp...@>@;

  fclose(C_file); C_file=NULL;
  fclose(check_file); check_file=NULL;

  @<Create the secondary output depending on the comparison@>@;

  free_object(y);
  free_object(x);
  }
else
  rename(check_file_name,output_file_name); /* This was the first run */

@ Again, we use a call to |remove| before |rename|.

@<Create the secondary output...@>=
  if((x_size != y_size) || memcmp(x,y,x_size)) {
    remove(output_file_name);
    rename(check_file_name,output_file_name);
    }
  else
    remove(check_file_name); /* The output remains untouched */

@** Index.
@z
------------------------------------------------------------------------------
