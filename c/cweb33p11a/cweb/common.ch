								-*-Web-*-
This file, COMMON.CH, is part of CWEB (Version 3.3 [patch level 11]).
It is a changefile for COMMON.W, Version 3.3.

Authors and Contributors:
(H2B) Hans-Hermann Bode, Universität Osnabrück,
  (hhbode@@dosuni1.rz.uni-osnabrueck.de or HHBODE@@DOSUNI1.BITNET).

(GG) Giuseppe Ghibò,
  (ghibo@@galileo.polito.it).

(KG) Klaus Guntermann, TH Darmstadt,
  (guntermann@@iti.informatik.th-darmstadt.de).

(AS) Andreas Scherer, RWTH Aachen,
  (scherer@@genesis.informatik.rwth-aachen.de).

(BS) Barry Schwartz,
  (trashman@@crud.mn.org).

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
the masterfile COMMON.W.

Copyright (C) 1993,1994 Andreas Scherer
Copyright (C) 1991,1993 Carsten Steger
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
a1/t1	10 Oct 1991	H2B	First attempt for COMMON.W 2.0.
p2	13 Feb 1992	H2B	Updated for COMMON.W 2.1, ANSI and Turbo
				changefiles merged together.
p3	16 Apr 1992	H2B	Updated for COMMON.W 2.2, change option for
				|@@i| completed.
p4	22 Jun 1992	H2B	Updated for COMMON.W 2.4, getting INCLUDEDIR
				from environment variable CWEBINCLUDE.
p5	19 Jul 1992	H2B	string.h included, usage message extended.
p5a	24 Jul 1992	KG	adaptions for other ANSI C compiler
p5b	28 Jul 1992	H2B	Remaining headers converted to ANSI style.
p5c	30 Jul 1992	KG	removed comments used after #endif
p6	06 Sep 1992	H2B	Updated for COMMON.W 2.7.
p6a     15 Mar 1993     AS      adaptions for SAS/C 6.0 compiler
p6b     28 Jul 1993     AS      path delimiters are `/' or `:' for AMIGA
	31 Aug 1993	AS	return codes extended to AMIGA values
p6c	04 Sep 1993	AS	path searching with CWEBINCLUDE
p6d	09 Oct 1993	AS	Updated for COMMON.W 2.8. (This was p7 for me)
p7	06 Nov 1992	H2B	Converted to master change file, updated for
				common.w 2.8. [Not released.]
p7.5	29 Nov 1992	H2B	Updated for COMMON.W 2.9beta. [Not released.]
p8	04 Dec 1992	H2B	Updated for COMMON.W 2.9++ (stuff went into
				the source file). [Not released.]
p8a	10 Mar 1993	H2B	Restructured for public release.
				[Not released.]
p8b	15 Apr 1993	H2B	Updated for COMMON.W 3.0beta. [Not released.]
p8c	21 Jun 1993	H2B	Updated for final COMMON.W 3.0.
p8d	26 Oct 1993	AS	Incorporated with AMIGA version 2.8 [p7] and
				updated to version 3.0.
p8e	04 Nov 1993	AS	Minor bugs fixed for UNIX and GNU-C.
p9	18 Nov 1993	AS	Updated for COMMON.W 3.1
p9a	30 Nov 1993	AS	Minor changes and corrections.
p9b	06 Dec 1993	AS	Multilinguality implemented.
	07 Dec 1993	AS	Fixed an obvious portability problem.
p9c	18 Jan 1994	AS	Version information included.
	25 Mar 1994	AS	Special `wrap_up' for Borland C.
p9d	13 May 1994	AS	Dynamic memory allocation.
	24 Jun 1994	AS	ARexx support for error-handling
	02 Jul 1994	AS	Portability version.
p9e	09 Aug 1994	AS	Fix a memory bug.
p10	12 Aug 1994	AS	Updated for CWEB 3.2.
p10a	24 Aug 1994	AS	New option flag list.
	11 Sep 1994	AS	Default values of CWEBINPUTS searched last.
	20 Sep 1994	AS	String argument to `-l' option.
	26 Sep 1994	AS	Replace `calloc' by `malloc'.
				Fix a bug in the `language switch'.
p10b	11 Oct 1994	AS	Write to check_file and compare results.
	18 Oct 1994	AS	Some refinements for C++ compilation.
	21 Oct 1994	AS	Use _DEV_NULL instead of the multi-way
				selection for the NULL path/device.
	29 Oct 1994	AS	Several Amiga #includes removed.
	12 Nov 1994	AS	Use SEPARATORS instead of the multi-way
				selection for '/', ':', '\', etc.
	13 Nov 1994	AS	Take care of opened system resources and
				temporary files in case of an user abort.
p11	03 Dec 1994	AS	Updated for CWEB 3.3.
	13 Dec 1994	AS	There have been corrections in Stanford.
------------------------------------------------------------------------------
@x l.1
% This file is part of CWEB.
% This program by Silvio Levy and Donald E. Knuth
% is based on a program by Knuth.
% It is distributed WITHOUT ANY WARRANTY, express or implied.
% Version 3.3 --- December 1994 (works with later versions too)

% Copyright (C) 1987,1990,1993 Silvio Levy and Donald E. Knuth
@y
% This file, common.w, is part of CWEB.
% This program by Silvio Levy and Donald E. Knuth
% is based on a program by Knuth.
% It is distributed WITHOUT ANY WARRANTY, express or implied.
% Version 2.4 --- Don Knuth, June 1992
% Version 2.4 [p5] --- Hans-Hermann Bode, July 1992
% Version 2.4 [p5a] --- Klaus Guntermann, July 1992
% Version 2.4 [p5b] --- Hans-Hermann Bode, July 1992
% Version 2.4 [p5c] --- Klaus Guntermann, July 1992
% Version 2.7 [p6] --- Hans-Hermann Bode, September 1992
% Version 2.7 [p6a] --- Andreas Scherer, March 1993
% Version 2.7 [p6b] --- Andreas Scherer, August 1993
% Version 2.7 [p6c] --- Andreas Scherer, September 1993
% Version 2.8 --- Don Knuth, June 1992
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
% Version 3.2 [p10] --- Andreas Scherer, August 1994
% Version 3.2 [p10a] --- Andreas Scherer, September 1994
% Version 3.2 [p10b] --- Andreas Scherer, October 1994
% Version 3.3 --- Don Knuth, December 1994
% Version 3.3 [p11] --- Andreas Scherer, December 1994

% Copyright (C) 1987,1990,1993 Silvio Levy and Donald E. Knuth
% Copyright (C) 1991-1993 Hans-Hermann Bode
% Copyright (C) 1991,1993 Carsten Steger
% Copyright (C) 1993,1994 Andreas Scherer
@z
------------------------------------------------------------------------------
@x l.20
\def\title{Common code for CTANGLE and CWEAVE (Version 3.3)}
@y
\def\title{Common code for CTANGLE and CWEAVE (Version 3.3 [p11])}
@z
------------------------------------------------------------------------------
@x l.25
  \centerline{(Version 3.3)}
@y
  \centerline{(Version 3.3 [p11])}
@z
------------------------------------------------------------------------------
@x l.29
Copyright \copyright\ 1987, 1990, 1993 Silvio Levy and Donald E. Knuth
@y
Copyright \copyright\ 1987, 1990, 1993 Silvio Levy and Donald E. Knuth
\smallskip\noindent
Copyright \copyright\ 1991--1993 Hans-Hermann Bode
\smallskip\noindent
Copyright \copyright\ 1991, 1993 Carsten Steger
\smallskip\noindent
Copyright \copyright\ 1993, 1994 Andreas Scherer

@i "amiga_types.w"
@z
------------------------------------------------------------------------------
Activate this, if only the changed modules should be printed.
x l.43
\let\maybe=\iftrue
y
\let\maybe=\iffalse
z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.58
@<Include files@>@/
@y
@<Include files@>@/
@<Macro definitions@>@/
@z
------------------------------------------------------------------------------
ANSI, TRANSLATION, OUTPUT
@x l.89
void
common_init()
{
  @<Initialize pointers@>;
  @<Set the default options common to \.{CTANGLE} and \.{CWEAVE}@>;
  @<Scan arguments and open output files@>;
}
@y
void common_init(void)
{
  @<Set up the event trap@>;
  @<Initialize pointers@>;
#ifdef _AMIGA
  @<Use catalog translations@>;
#endif
  @<Set the default options common to \.{CTANGLE} and \.{CWEAVE}@>;
  @<Scan arguments and open output files@>;
}
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.159
char buffer[long_buf_size]; /* where each line of input goes */
char *buffer_end=buffer+buf_size-2; /* end of |buffer| */
char *limit=buffer; /* points to the last character in the buffer */
char *loc=buffer; /* points to the next character to be read from the buffer */
@y
char *buffer; /* where each line of input goes */
char *buffer_end; /* end of |buffer| */
char *limit; /* points to the last character in the buffer */
char *loc; /* points to the next character to be read from the buffer */
@z
------------------------------------------------------------------------------
ANSI
@x l.172
int input_ln(fp) /* copies a line into |buffer| or returns 0 */
FILE *fp; /* what file to read from */
@y
static int input_ln(@t\1\1@> /* copies a line into |buffer| or returns 0 */
  FILE *fp@t\2\2@>) /* what file to read from */
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.183
      ungetc(c,fp); loc=buffer; err_print("! Input line too long");
@y
      ungetc(c,fp); loc=buffer; err_print(get_string(MSG_ERROR_CO9));
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.206
@d max_file_name_length 60
@y
@d max_file_name_length 256
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.215
FILE *file[max_include_depth]; /* stack of non-change files */
FILE *change_file; /* change file */
char file_name[max_include_depth][max_file_name_length];
  /* stack of non-change file names */
char change_file_name[max_file_name_length]; /* name of change file */
char alt_web_file_name[max_file_name_length]; /* alternate name to try */
int line[max_include_depth]; /* number of current line in the stacked files */
@y
FILE **file; /* stack of non-change files */
FILE *change_file; /* change file */
char **file_name; /* stack of non-change file names */
char *change_file_name; /* name of change file */
char *alt_web_file_name; /* alternate name to try */
int *line; /* number of current line in the stacked files */
@z
------------------------------------------------------------------------------
ANSI
@x l.236
@d lines_dont_match (change_limit-change_buffer != limit-buffer ||
  strncmp(buffer, change_buffer, limit-buffer))
@y
@d lines_dont_match (change_limit-change_buffer != limit-buffer || @|
  strncmp(buffer, change_buffer, (size_t)(limit-buffer)))
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.240
char change_buffer[buf_size]; /* next line of |change_file| */
@y
char *change_buffer; /* next line of |change_file| */
@z
------------------------------------------------------------------------------
ANSI
@x l.251
void
prime_the_change_buffer()
@y
static void prime_the_change_buffer(void)
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.274
    err_print("! Missing @@x in change file");
@y
    err_print(get_string(MSG_ERROR_CO13));
@z
------------------------------------------------------------------------------
TRANLSATION
@x l.285
    err_print("! Change file ended after @@x");
@y
    err_print(get_string(MSG_ERROR_CO14));
@z
------------------------------------------------------------------------------
ANSI
@x l.293
  change_limit=change_buffer-buffer+limit;
  strncpy(change_buffer,buffer,limit-buffer+1);
@y
  change_limit=change_buffer+(ptrdiff_t)(limit-buffer);
  strncpy(change_buffer,buffer,(size_t)(limit-buffer+1));
@z
------------------------------------------------------------------------------
ANSI
@x l.320
void
check_change() /* switches to |change_file| if the buffers match */
@y
static void check_change(void) /* switches to |change_file| if the buffers match */
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.333
      err_print("! Change file ended before @@y");
@y
      err_print(get_string(MSG_ERROR_CO16_1));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.347
        err_print("! CWEB file ended during a change");
@y
        err_print(get_string(MSG_ERROR_CO16_2));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.359
  loc=buffer+2; err_print("! Where is the matching @@y?");
@y
  loc=buffer+2; err_print(get_string(MSG_ERROR_CO17_1));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.366
    err_print("of the preceding lines failed to match");
@y
    err_print(get_string(MSG_ERROR_CO17_2));
@z
------------------------------------------------------------------------------
ANSI
@x l.378
void
reset_input()
@y
void reset_input(void)
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.396
       fatal("! Cannot open input file ", web_file_name);
@y
       fatal(get_string(MSG_FATAL_CO19_1), web_file_name);
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, TRANSLATION
Right after the web file was opened we set up communication with the AREXX
port of the SAS/C++ 6.x message browser.  If `scmsg' is not yet running we
start it in `rexxonly' mode (no window will appear) and initialize the
compilation run with the (full) name of the web file.
@x l.401
if ((change_file=fopen(change_file_name,"r"))==NULL)
       fatal("! Cannot open change file ", change_file_name);
@y
#ifdef _AMIGA
@<Set up the {\mc AREXX} communication@>;
#endif
if ((change_file=fopen(change_file_name,"r"))==NULL)
       fatal(get_string(MSG_FATAL_CO19_2), change_file_name);
@z
------------------------------------------------------------------------------
ANSI
@x l.418
typedef unsigned short sixteen_bits;
@y
typedef unsigned char eight_bits;
typedef unsigned short sixteen_bits;
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.420
boolean changed_section[max_sections]; /* is the section changed? */
@y
boolean *changed_section; /* is the section changed? */
@z
------------------------------------------------------------------------------
ANSI
@x l.426
int get_line() /* inputs the next line */
@y
int get_line(void) /* inputs the next line */
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.440
      err_print("! Include file name not given");
@y
      err_print(get_string(MSG_ERROR_CO21_1));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.445
      err_print("! Too many nested includes");
@y
      err_print(get_string(MSG_ERROR_CO21_2));
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, TRANSLATION
We provide a multiple search path algorithm much like the C preprocessor.
@x l.455
@ When an \.{@@i} line is found in the |cur_file|, we must temporarily
stop reading it and start reading from the named include file.  The
\.{@@i} line should give a complete file name with or without
double quotes.
If the environment variable \.{CWEBINPUTS} is set, or if the compiler flag
of the same name was defined at compile time,
\.{CWEB} will look for include files in the directory thus named, if
it cannot find them in the current directory.
(Colon-separated paths are not supported.)
The remainder of the \.{@@i} line after the file name is ignored.

@d too_long() {include_depth--;
        err_print("! Include file name too long"); goto restart;}

@<Include...@>=
#include <stdlib.h> /* declaration of |getenv| and |exit| */
@y
@ When an \.{@@i} line is found in the |cur_file|, we must temporarily
stop reading it and start reading from the named include file.  The
\.{@@i} line should give a complete file name with or without
double quotes.  The remainder of the \.{@@i} line after the file name
is ignored.  \.{CWEB} will look for include files in standard directories
specified in the environment variable \.{CWEBINPUTS}. Multiple search paths
can be specified by delimiting them with \.{PATH\_SEPARATOR}s.  The given
file is searched for in the current directory first.  You also may include
device names; these must have a \.{DEVICE\_SEPARATOR} as their rightmost
character.  For other systems than the {\mc AMIGA} different settings may
be needed.
@^system dependencies@>

@d too_long() {include_depth--;
        err_print(get_string(MSG_ERROR_CO22)); goto restart;}

@<Include...@>=
#include <stdlib.h> /* declaration of |getenv| and |exit| */
#include <stddef.h> /* type definition of |ptrdiff_t| */
#include <signal.h> /* declaration of |signal| and |SIGINT| */
@#
#ifdef SEPARATORS
char separators[]=SEPARATORS;
#else
char separators[]="://";
#endif
@#
#define PATH_SEPARATOR   separators[0]
#define DIR_SEPARATOR    separators[1]
#define DEVICE_SEPARATOR separators[2]
@z
------------------------------------------------------------------------------
EXTENSIONS, SYSTEM DEPENDENCIES
CWEB will perform a path search for `@i'nclude files along the environment
variable CWEBINPUTS in case the given file can not be opened in the current
directory or in the absolute path.  The single paths are delimited by
PATH_SEPARATORs.  The default string defined in this change file is
appended to any environment variable CWEBINPUTS, so you don't have to
repeat its entries.  The current directory always is searched first.
@x l.486
  kk=getenv("CWEBINPUTS");
  if (kk!=NULL) {
    if ((l=strlen(kk))>max_file_name_length-2) too_long();
    strcpy(temp_file_name,kk);
  }
  else {
#ifdef CWEBINPUTS
    if ((l=strlen(CWEBINPUTS))>max_file_name_length-2) too_long();
    strcpy(temp_file_name,CWEBINPUTS);
#else
    l=0;
#endif /* |CWEBINPUTS| */
  }
  if (l>0) {
    if (k+l+2>=cur_file_name_end)  too_long();
@.Include file name ...@>
    for (; k>= cur_file_name; k--) *(k+l+1)=*k;
    strcpy(cur_file_name,temp_file_name);
    cur_file_name[l]='/'; /* \UNIX/ pathname separator */
    if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
      cur_line=0; print_where=1;
      goto restart; /* success */
    }
  }
@y
  if(0==set_path(include_path,getenv("CWEBINPUTS"))) {
    include_depth--; goto restart; /* internal error */
  }
  path_prefix = include_path;
  while(path_prefix) {
    for(kk=temp_file_name, p=path_prefix, l=0;
      p && *p && *p!=PATH_SEPARATOR;
      *kk++ = *p++, l++);
    if(path_prefix && *path_prefix && *path_prefix!=PATH_SEPARATOR && @|
      *--p!=DEVICE_SEPARATOR && *p!=DIR_SEPARATOR) {
      *kk++ = DIR_SEPARATOR; l++;
    }
    if(k+l+2>=cur_file_name_end) too_long(); /* emergency break */
    strcpy(kk,cur_file_name);
    if(cur_file = fopen(temp_file_name,"r")) {
      cur_line=0; print_where=1; goto restart; /* success */
    }
    if(next_path_prefix = strchr(path_prefix,PATH_SEPARATOR))
      path_prefix = next_path_prefix+1;
    else break; /* no more paths to search; no file found */
  }
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.510
  include_depth--; err_print("! Cannot open include file"); goto restart;
@y
  include_depth--; err_print(get_string(MSG_ERROR_CO23)); goto restart;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.533
    err_print("! Change file ended without @@z");
@y
    err_print(get_string(MSG_ERROR_CO25_1));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.549
        err_print("! Where is the matching @@z?");
@y
        err_print(get_string(MSG_ERROR_CO25_2));
@z
------------------------------------------------------------------------------
ANSI
@x l.563
void
check_complete(){
  if (change_limit!=change_buffer) { /* |changing| is 0 */
    strncpy(buffer,change_buffer,change_limit-change_buffer+1);
    limit=buffer+(int)(change_limit-change_buffer);
@y
void check_complete(void) {
  if (change_limit!=change_buffer) { /* |changing| is 0 */
    strncpy(buffer,change_buffer,(size_t)(change_limit-change_buffer+1));
    limit=buffer+(ptrdiff_t)(change_limit-change_buffer);
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.569
    err_print("! Change file entry did not match");
@y
    err_print(get_string(MSG_ERROR_CO26));
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.589
  char *byte_start; /* beginning of the name in |byte_mem| */
@y
  char HUGE *byte_start; /* beginning of the name in |byte_mem| */
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, MEMORY ALLOCATION
@x l.592
typedef name_info *name_pointer; /* pointer into array of |name_info|s */
char byte_mem[max_bytes]; /* characters of names */
char *byte_mem_end = byte_mem+max_bytes-1; /* end of |byte_mem| */
name_info name_dir[max_names]; /* information about names */
name_pointer name_dir_end = name_dir+max_names-1; /* end of |name_dir| */
@y
typedef name_info HUGE *name_pointer; /* pointer into array of |name_info|s */
name_pointer name_dir; /* information about names */
name_pointer name_dir_end; /* end of |name_dir| */
char HUGE *byte_mem; /* characters of names */
char HUGE *byte_mem_end; /* end of |byte_mem| */
@z
------------------------------------------------------------------------------
ANSI
@x l.602
@d length(c) (c+1)->byte_start-(c)->byte_start /* the length of a name */
@y
@d length(c) (size_t)((c+1)->byte_start-(c)->byte_start) /* the length of a name */
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.612
char *byte_ptr; /* first unused position in |byte_mem| */
@y
char HUGE *byte_ptr; /* first unused position in |byte_mem| */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION, SYSTEM DEPENDENCIES, TRANSLATION
@x l.614
@ @<Init...@>=
name_dir->byte_start=byte_ptr=byte_mem; /* position zero in both arrays */
@y
@ @f type int /* \.{type} becomes the pseudotype \&{type} */
@#
@d alloc_object(object,size,@!type)
   if(!(object = (type *)malloc((size)*sizeof(type))))
      fatal("",get_string(MSG_FATAL_CO85));

@<Init...@>=
alloc_object(buffer,long_buf_size,char);
buffer_end = buffer + buf_size - 2;
limit = loc = buffer;
alloc_object(file,max_include_depth,FILE *);
alloc_object(file_name,max_include_depth,char *);
for(phase=0; phase<max_include_depth; phase++)
  alloc_object(file_name[phase],max_file_name_length,char);
alloc_object(change_file_name,max_file_name_length,char);
alloc_object(alt_web_file_name,max_file_name_length,char);
alloc_object(line,max_include_depth,int);
alloc_object(change_buffer,buf_size,char);
alloc_object(changed_section,max_sections,boolean);
#ifdef __TURBOC__
byte_mem=(char HUGE *)allocsafe(max_bytes,sizeof(*byte_mem));
name_dir=(name_pointer)allocsafe(max_names,sizeof(*name_dir));
#else
alloc_object(byte_mem,max_bytes,char);
alloc_object(name_dir,max_names,name_info);
#endif
byte_mem_end = byte_mem + max_bytes - 1;
name_dir_end = name_dir + max_names - 1;
name_dir->byte_start=byte_ptr=byte_mem; /* position zero in both arrays */
@^system dependencies@>
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.625
struct name_info *link;
@y
struct name_info HUGE *link;
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION
@x l.639
name_pointer hash[hash_size]; /* heads of hash lists */
hash_pointer hash_end = hash+hash_size-1; /* end of |hash| */
@y
hash_pointer hash; /* heads of hash lists */
hash_pointer hash_end; /* end of |hash| */
@z
------------------------------------------------------------------------------
ANSI
@x l.643
@ @<Predec...@>=
extern int names_match();
@y
@ @<Predec...@>=
extern int names_match(name_pointer,char *,int,eight_bits);@/
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION, OUTPUT
@x l.648
@<Init...@>=
for (h=hash; h<=hash_end; *h++=NULL) ;
@y
@<Init...@>=
alloc_object(hash,hash_size,name_pointer);
hash_end = hash + hash_size - 1;
for (h=hash; h<=hash_end; *h++=NULL) ;
alloc_object(C_file_name,max_file_name_length,char);
alloc_object(tex_file_name,max_file_name_length,char);
alloc_object(idx_file_name,max_file_name_length,char);
alloc_object(scn_file_name,max_file_name_length,char);
alloc_object(check_file_name,L_tmpnam,char);
@z
------------------------------------------------------------------------------
ANSI
@x l.654
name_pointer
id_lookup(first,last,t) /* looks up a string in the identifier table */
char *first; /* first character of string */
char *last; /* last character of string plus one */
char t; /* the |ilk|; used by \.{CWEAVE} only */
@y
name_pointer id_lookup(@t\1\1@> /* looks up a string in the identifier table */
  char *first, /* first character of string */
  char *last, /* last character of string plus one */
  char t@t\2\2@>) /* the |ilk|; used by \.{CWEAVE} only */
@z
------------------------------------------------------------------------------
ANSI
@x l.665
  l=last-first; /* compute the length */
@y
  l=(int)(last-first); /* compute the length */
@z
------------------------------------------------------------------------------
ANSI
@x l.696
@<Pred...@>=
void init_p();
@y
@<Pred...@>=
extern void init_p(name_pointer,eight_bits);@/
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.700
  if (byte_ptr+l>byte_mem_end) overflow("byte memory");
  if (name_ptr>=name_dir_end) overflow("name");
@y
  if (byte_ptr+l>byte_mem_end) overflow(get_string(MSG_OVERFLOW_CO39_1));
  if (name_ptr>=name_dir_end) overflow(get_string(MSG_OVERFLOW_CO39_2));
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.725
  struct name_info *Rlink; /* right link in binary search tree for section
@y
  struct name_info HUGE *Rlink; /* right link in binary search tree for section
@z
------------------------------------------------------------------------------
ANSI
@x l.758
void
print_section_name(p)
name_pointer p;
@y
void print_section_name(name_pointer p)
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.762
  char *ss, *s = first_chunk(p);
@y
  char HUGE *ss;
  char HUGE *s = first_chunk(p);
@z
------------------------------------------------------------------------------
ANSI
@x l.767
      term_write(s,ss-s); p=q->link; q=p;
    } else {
      term_write(s,ss+1-s); p=name_dir; q=NULL;
@y
      term_write(s,(size_t)(ss-s)); p=q->link; q=p;
    } else {
      term_write(s,(size_t)(ss+1-s)); p=name_dir; q=NULL;
@z
------------------------------------------------------------------------------
ANSI
@x l.777
void
sprint_section_name(dest,p)
  char*dest;
  name_pointer p;
@y
void sprint_section_name(char *dest,name_pointer p)
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.782
  char *ss, *s = first_chunk(p);
@y
  char HUGE *ss;
  char HUGE *s = first_chunk(p);
@z
------------------------------------------------------------------------------
ANSI
@x l.791
    strncpy(dest,s,ss-s), dest+=ss-s;
@y
    strncpy(dest,s,(size_t)(ss-s)), dest+=ss-s;
@z
------------------------------------------------------------------------------
ANSI
@x l.798
void
print_prefix_name(p)
name_pointer p;
@y
void print_prefix_name(name_pointer p)
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.802
  char *s = first_chunk(p);
@y
  char HUGE *s = first_chunk(p);
@z
------------------------------------------------------------------------------
ANSI, SYSTEM DEPENDENCIES
@x l.819
int web_strcmp(j,j_len,k,k_len) /* fuller comparison than |strcmp| */
  char *j, *k; /* beginning of first and second strings */
  int j_len, k_len; /* length of strings */
{
  char *j1=j+j_len, *k1=k+k_len;
@y
static int web_strcmp(@t\1\1@> /* fuller comparison than |strcmp| */
  char HUGE *j, /* beginning of first string */
  int j_len, /* length of first string */
  char HUGE *k, /* beginning of second string */
  int k_len@t\2\2@>) /* length of second string */
{
  char HUGE *j1=j+j_len;
  char HUGE *k1=k+k_len;
@z
------------------------------------------------------------------------------
ANSI
@x l.845
@<Prede...@>=
extern void init_node();
@y
@<Prede...@>=
extern void init_node(name_pointer);@/
@z
------------------------------------------------------------------------------
ANSI
@x l.849
name_pointer
add_section_name(par,c,first,last,ispref) /* install a new node in the tree */
name_pointer par; /* parent of new node */
int c; /* right or left? */
char *first; /* first character of section name */
char *last; /* last character of section name, plus one */
int ispref; /* are we adding a prefix or a full name? */
@y
name_pointer add_section_name(@t\1\1@> /* install a new node in the tree */
  name_pointer par, /* parent of new node */
  int c, /* right or left? */
  char *first, /* first character of section name */
  char *last, /* last character of section name, plus one */
  int ispref@t\2\2@>) /* are we adding a prefix or a full name? */
@z
------------------------------------------------------------------------------
ANSI, TRANSLATION
@x l.858
  char *s=first_chunk(p);
  int name_len=last-first+ispref; /* length of section name */
  if (s+name_len>byte_mem_end) overflow("byte memory");
  if (name_ptr+1>=name_dir_end) overflow("name");
@y
  char HUGE *s=first_chunk(p);
  int name_len=(int)(last-first)+ispref; /* length of section name */
  if (s+name_len>byte_mem_end) overflow(get_string(MSG_OVERFLOW_CO39_1));
  if (name_ptr+1>=name_dir_end) overflow(get_string(MSG_OVERFLOW_CO39_2));
@z
------------------------------------------------------------------------------
ANSI
@x l.878
void
extend_section_name(p,first,last,ispref)
name_pointer p; /* name to be extended */
char *first; /* beginning of extension text */
char *last; /* one beyond end of extension text */
int ispref; /* are we adding a prefix or a full name? */
@y
void extend_section_name(@t\1\1@>
  name_pointer p, /* name to be extended */
  char *first, /* beginning of extension text */
  char *last, /* one beyond end of extension text */
  int ispref@t\2\2@>) /* are we adding a prefix or a full name? */
@z
------------------------------------------------------------------------------
ANSI, SYSTEM DEPENDENCIES, TRANSLATION
@x l.885
  char *s;
  name_pointer q=p+1;
  int name_len=last-first+ispref;
  if (name_ptr>=name_dir_end) overflow("name");
@y
  char HUGE *s;
  name_pointer q=p+1;
  int name_len=(int)(last-first)+ispref;
  if (name_ptr>=name_dir_end) overflow(get_string(MSG_OVERFLOW_CO39_2));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.893
  if (s+name_len>byte_mem_end) overflow("byte memory");
@y
  if (s+name_len>byte_mem_end) overflow(get_string(MSG_OVERFLOW_CO39_1));
@z
------------------------------------------------------------------------------
ANSI
@x l.906
name_pointer
section_lookup(first,last,ispref) /* find or install section name in tree */
char *first, *last; /* first and last characters of new name */
int ispref; /* is the new name a prefix or a full name? */
@y
name_pointer section_lookup(@t\1\1@> /* find or install section name in tree */
  char *first,char *last, /* first and last characters of new name */
  int ispref@t\2\2@>) /* is the new name a prefix or a full name? */
@z
------------------------------------------------------------------------------
ANSI
@x l.917
  int name_len=last-first+1;
@y
  int name_len=(int)(last-first)+1;
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.938
      printf("\n! Ambiguous prefix: matches <");
@.Ambiguous prefix ... @>
      print_prefix_name(p);
      printf(">\n and <");
@y
      printf(get_string(MSG_ERROR_CO50_1));
@.Ambiguous prefix ... @>
      print_prefix_name(p);
      printf(get_string(MSG_ERROR_CO50_2));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.967
      printf("\n! New name is a prefix of <");
@y
      printf(get_string(MSG_ERROR_CO52_1));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.979
      printf("\n! New name extends <");
@y
      printf(get_string(MSG_ERROR_CO52_2));
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.985
    printf("\n! Section name incompatible with <");
@.Section name incompatible...@>
    print_prefix_name(r);
    printf(">,\n which abbreviates <");
@y
    printf(get_string(MSG_ERROR_CO52_3));
@.Section name incompatible...@>
    print_prefix_name(r);
    printf(get_string(MSG_ERROR_CO52_4));
@z
------------------------------------------------------------------------------
ANSI
@x l.1010
@<Predec...@>=
int section_name_cmp();
@y
@<Predec...@>=
static int section_name_cmp(char **,int,name_pointer);@/
@z
------------------------------------------------------------------------------
ANSI
@x l.1014
int section_name_cmp(pfirst,len,r)
char **pfirst; /* pointer to beginning of comparison string */
int len; /* length of string */
name_pointer r; /* section name being compared */
@y
static int section_name_cmp(@t\1\1@>
  char **pfirst, /* pointer to beginning of comparison string */
  int len, /* length of string */
  name_pointer r@t\2\2@>) /* section name being compared */
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.1021
  char *ss, *s=first_chunk(r);
@y
  char HUGE *ss;
  char HUGE *s=first_chunk(r);
@z
------------------------------------------------------------------------------
ANSI
@x l.1031
          *pfirst=first+(ss-s);
@y
          *pfirst=first+(ptrdiff_t)(ss-s);
@z
------------------------------------------------------------------------------
ANSI
@x l.1038
      if (q!=name_dir) {len -= ss-s; s=q->byte_start; r=q; continue;}
@y
      if (q!=name_dir) {len -= (int)(ss-s); s=q->byte_start; r=q; continue;}
@z
------------------------------------------------------------------------------
ANSI, SYSTEM DEPENDENCIES
@x l.1053
|equiv_or_xref| as a pointer to a |char|.

@<More elements of |name...@>=
char *equiv_or_xref; /* info corresponding to names */
@y
|equiv_or_xref| as a pointer to |void|.

@<More elements of |name...@>=
void HUGE *equiv_or_xref; /* info corresponding to names */
@z
------------------------------------------------------------------------------
ANSI
@x l.1086
void  err_print();

@ @c
void
err_print(s) /* prints `\..' and location of error message */
char *s;
@y
extern void err_print(char *);@/

@ @c
void err_print(char *s) /* prints `\..' and location of error message */
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, TRANSLATION
@x l.1109
{if (changing && include_depth==change_depth)
  printf(". (l. %d of change file)\n", change_line);
else if (include_depth==0) printf(". (l. %d)\n", cur_line);
  else printf(". (l. %d of include file %s)\n", cur_line, cur_file_name);
@y
{if (changing && include_depth==change_depth)
  @<Report an error in the change file@>@;
else if (include_depth==0)
  @<Report an error in the web file@>@;
else
  @<Report an error in an include file@>@;

#ifdef _AMIGA
@<Put the error message in the browser@>@;
#endif
@z
------------------------------------------------------------------------------
ANSI
@x l.1133
@<Prede...@>=
int wrap_up();
extern void print_stats();
@y
@<Prede...@>=
extern int wrap_up(void);@/
extern void print_stats(void);@/
@z
------------------------------------------------------------------------------
OUTPUT, SYSTEM DEPENDENCIES, TRANSLATION
@x l.1137
@ Some implementations may wish to pass the |history| value to the
operating system so that it can be used to govern whether or not other
programs are started. Here, for instance, we pass the operating system
a status of 0 if and only if only harmless messages were printed.
@^system dependencies@>

@c
int wrap_up() {
  putchar('\n');
  if (show_stats)
    print_stats(); /* print statistics about memory usage */
  @<Print the job |history|@>;
  if (history > harmless_message) return(1);
  else return(0);
}
@y
@ On multi-tasking systems like the {\mc AMIGA} it is very convenient to know
a little bit more about the reasons why a program failed.  The four levels
of return indicated by the |history| value are very suitable for this
purpose.  Here, for instance, we pass the operating system a status of~0
if and only if the run was a complete success.  Any warning or error
message will result in a higher return value, so {\mc AREXX} scripts can be
made sensitive to these conditions.

|__TURBOC__| has another shitty ``feature'' that has to be fixed.
|return|ing from several |case|s is not possible.  Either always the first
case is used, or the system is crashed completely.  Really funny.
@^system dependencies@>

@d RETURN_OK     0 /* No problems, success */
@d RETURN_WARN   5 /* A warning only */
@d RETURN_ERROR 10 /* Something wrong */
@d RETURN_FAIL  20 /* Complete or severe failure */

@c
#ifdef __TURBOC__
int wrap_up(void) {
  int return_val;

  putchar('\n');
  if (show_stats) print_stats(); /* print statistics about memory usage */
  @<Print the job |history|@>;
  @<Remove the temporary file if not already done@>@;
  switch(history) {
  case harmless_message: return_val=RETURN_WARN; break;
  case error_message: return_val=RETURN_ERROR; break;
  case fatal_message: return_val=RETURN_FAIL; break;
  default: return_val=RETURN_OK;
    }
  return(return_val);
  }
#else
int wrap_up(void) {
  putchar('\n');
  if (show_stats) print_stats(); /* print statistics about memory usage */
  @<Print the job |history|@>;
#ifdef _AMIGA
  @<Close the language catalog@>;
#endif
  @<Remove the temporary file if not already done@>@;
  switch(history) {
  case harmless_message: return(RETURN_WARN); break;
  case error_message: return(RETURN_ERROR); break;
  case fatal_message: return(RETURN_FAIL); break;
  default: return(RETURN_OK);
    }
  }
#endif
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1155
case spotless: if (show_happiness) printf("(No errors were found.)\n"); break;
case harmless_message:
  printf("(Did you see the warning message above?)\n"); break;
case error_message:
  printf("(Pardon me, but I think I spotted something wrong.)\n"); break;
case fatal_message: printf("(That was a fatal error, my friend.)\n");
@y
case spotless:
  if (show_happiness) printf(get_string(MSG_HAPPINESS_CO62)); break;
case harmless_message:
  printf(get_string(MSG_WARNING_CO62)); break;
case error_message:
  printf(get_string(MSG_ERROR_CO62)); break;
case fatal_message:
  printf(get_string(MSG_FATAL_CO62));
@z
------------------------------------------------------------------------------
ANSI
@x l.1166
@<Predec...@>=
void fatal(), overflow();
@y
@<Predec...@>=
extern void fatal(char *,char *);
extern void overflow(char *);
@z
------------------------------------------------------------------------------
ANSI
@x l.1172
@c void
fatal(s,t)
  char *s,*t;
@y
@c void fatal(char *s,char *t)
@z
------------------------------------------------------------------------------
ANSI
@x l.1183
@c void
overflow(t)
  char *t;
@y
@c void overflow(char *t)
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1187
  printf("\n! Sorry, %s capacity exceeded",t); fatal("","");
@y
  printf(get_string(MSG_FATAL_CO65),t); fatal("","");
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1196
@d confusion(s) fatal("! This can't happen: ",s)
@y
@d confusion(s) fatal(get_string(MSG_FATAL_CO66),s)
@z
------------------------------------------------------------------------------
EXTENSIONS, SYSTEM DEPENDENCIES
C and CWEB are `international' languages, so non-English speaking users may
want to write program documentations in their native language instead of in
English.  With the \.{+lX} (or \.{-lX} as well) option CWEAVE includes TeX
macros `Xcwebmac.tex'.  This option works differently than all the others,
because it takes the rest of the command line argument and prepends it to
the string ``cwebmac'' in the first line of the TeX output, so you can call
CWEAVE with the option ``+ldeutsch'' to yield ``\input deutschcwebmac'' in
the first line.

The original CWEAVE indents parameter declarations in old-style function
heads.  If you don't like this, you can typeset them flush left with \.{-i}.

The original CWEAVE puts extra white space after variable declarations and
before the first statement in a function block.  If you don't like this,
you can use the \.{-o} option.  This feature was already mentioned in the
original documentation, but it was not implemented.

These changes by Andreas Scherer are based on ideas by Carsten Steger
provided in his `CWeb 2.0' port from ><> 551 and his `CWeb 2.8' port
from the electronic nets and on suggestions by Giuseppe Ghibò.  The string
argument to the `-l' option was suggested by Carsten Steger in a private
communication in 1994.  Originally this was to be the single character
following `l', but there would have been collisions between ``dansk''
and ``deutsch,'' ``espanol'' and ``english,'' and many others.
@x l.1202
or flags to be turned on (beginning with |"+"|.
The following globals are for communicating the user's desires to the rest
of the program. The various file name variables contain strings with
the names of those files. Most of the 128 flags are undefined but available
for future extensions.

@d show_banner flags['b'] /* should the banner line be printed? */
@d show_progress flags['p'] /* should progress reports be printed? */
@d show_stats flags['s'] /* should statistics be printed at end of run? */
@d show_happiness flags['h'] /* should lack of errors be announced? */
@y
or flags to be turned on (beginning with |"+"|).
The following globals are for communicating the user's desires to the rest
of the program. The various file name variables contain strings with
the names of those files. Most of the 256 flags are undefined but available
for future extensions.

@d show_banner flags['b'] /* should the banner line be printed? */
@d show_progress flags['p'] /* should progress reports be printed? */
@d show_stats flags['s'] /* should statistics be printed at end of run? */
@d show_happiness flags['h'] /* should lack of errors be announced? */
@d indent_param_decl flags['i'] /* should formal parameter declarations be indented? */
@d send_error_messages flags['m'] /* should {\mc AREXX} communication be used? */
@d order_decl_stmt flags['o'] /* should declarations and statements be separated? */
@z
------------------------------------------------------------------------------
MEMORY ALLOCATION, OUTPUT
@x l.1216
char C_file_name[max_file_name_length]; /* name of |C_file| */
char tex_file_name[max_file_name_length]; /* name of |tex_file| */
char idx_file_name[max_file_name_length]; /* name of |idx_file| */
char scn_file_name[max_file_name_length]; /* name of |scn_file| */
boolean flags[128]; /* an option for each 7-bit code */
@y
char *C_file_name; /* name of |C_file| */
char *tex_file_name; /* name of |tex_file| */
char *idx_file_name; /* name of |idx_file| */
char *scn_file_name; /* name of |scn_file| */
char *check_file_name; /* name of |check_file| */
char *use_language; /* prefix of \.{cwebmac.tex} in \TEX/ output */
boolean flags[256]; /* an option for each 8-bit code */
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.1226
@<Set the default options common to \.{CTANGLE} and \.{CWEAVE}@>=
show_banner=show_happiness=show_progress=1;
@y
@<Set the default options common to \.{CTANGLE} and \.{CWEAVE}@>=
show_banner=show_happiness=show_progress=indent_param_decl=order_decl_stmt=1;
use_language="";
@^system dependencies@>
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.1238
An omitted change file argument means that |"/dev/null"| should be used,
when no changes are desired.
@y
An omitted change file argument means that |"/dev/null"| or---on non-\UNIX/
systems the contents of the compile-time variable |_DEV_NULL|---should be
used, when no changes are desired.
@z
------------------------------------------------------------------------------
ANSI
@x l.1244
@<Pred...@>=
void scan_args();
@y
@<Pred...@>=
static void scan_args(void);@/
@z
------------------------------------------------------------------------------
ANSI
@x l.1248
void
scan_args()
@y
static void scan_args(void)
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.1262
      while (*s) {
        if (*s=='.') dot_pos=s++;
        else if (*s=='/') dot_pos=NULL,name_pos=++s;
        else s++;
      }
@y
      while (*s) {
        if (*s=='.') dot_pos=s++;
        else if (*s==DIR_SEPARATOR || *s==DEVICE_SEPARATOR || *s=='/')
          dot_pos=NULL,name_pos=++s;
        else s++;
      }
@^system dependencies@>
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES
@x l.1275
  if (found_change<=0) strcpy(change_file_name,"/dev/null");
@y
#ifdef _DEV_NULL
  if (found_change<=0) strcpy(change_file_name,_DEV_NULL);
#else
  if (found_change<=0) strcpy(change_file_name,"/dev/null");
#endif
@^system dependencies@>
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1329
        fatal("! Output file name should end with .tex\n",*argv);
@y
        fatal(get_string(MSG_FATAL_CO73),*argv);
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, TRANSLATION
@x l.1345
  for(dot_pos=*argv+1;*dot_pos>'\0';dot_pos++)
    flags[*dot_pos]=flag_change;
@y
  for(dot_pos=*argv+1;*dot_pos>'\0';dot_pos++)
    if(*dot_pos=='l') {
       use_language=++dot_pos;
       break;
       }
    else
      flags[*dot_pos]=flag_change;
@^system dependencies@>
@z
------------------------------------------------------------------------------
SYSTEM DEPENDENCIES, TRANSLATION
When called with no arguments CTANGLE and CWEAVE provide a list of options.
@x l.1349
@ @<Print usage error message and quit@>=
{
if (program==ctangle)
  fatal(
"! Usage: ctangle [options] webfile[.w] [{changefile[.ch]|-} [outfile[.c]]]\n"
   ,"");
@.Usage:@>
else fatal(
"! Usage: cweave [options] webfile[.w] [{changefile[.ch]|-} [outfile[.tex]]]\n"
   ,"");
}
@y
@ @<Print usage error message and quit@>=
{
#ifdef _AMIGA
if (program==ctangle)
  fatal(get_string(MSG_FATAL_CO75_1),"");
else fatal(get_string(MSG_FATAL_CO75_3),"");
#else
if (program==ctangle)
  fatal(get_string(MSG_FATAL_CO75_2),"");
else fatal(get_string(MSG_FATAL_CO75_4),"");
#endif
}
@.Usage:@>
@^system dependencies@>
@z
------------------------------------------------------------------------------
TRANSLATION
@x l.1361
@ @<Complain about arg...@>= fatal("! Filename too long\n", *argv);
@y
@ @<Complain about arg...@>= fatal(get_string(MSG_FATAL_CO76), *argv);
@z
------------------------------------------------------------------------------
OUTPUT
@x l.1371
FILE *scn_file; /* where list of sections from \.{CWEAVE} goes */
@y
FILE *scn_file; /* where list of sections from \.{CWEAVE} goes */
FILE *check_file; /* temporary output file */
@z
------------------------------------------------------------------------------
TRANSLATION, OUTPUT
@x l.1374
@ @<Scan arguments and open output files@>=
scan_args();
if (program==ctangle) {
  if ((C_file=fopen(C_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", C_file_name);
@.Cannot open output file@>
}
else {
  if ((tex_file=fopen(tex_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", tex_file_name);
}
@y
@ @<Scan arguments and open output files@>=
scan_args();
tmpnam(check_file_name);
if(strrchr(check_file_name,DEVICE_SEPARATOR))
  check_file_name=strrchr(check_file_name,DEVICE_SEPARATOR)+1;
if (program==ctangle) {
  if ((C_file=fopen(check_file_name,"w"))==NULL)
    fatal(get_string(MSG_FATAL_CO78), check_file_name);
@.Cannot open output file@>
}
else {
  if ((tex_file=fopen(check_file_name,"w"))==NULL)
    fatal(get_string(MSG_FATAL_CO78), check_file_name);
}
@z
------------------------------------------------------------------------------
ANSI, OUTPUT, SYSTEM DEPENDENCIES, TRANSLATION
The `standard' header files are.  Any compiler ignoring them is not.
@x l.1403
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

@** Index.
@y
@ For string handling we include the {\mc ANSI C} system header file instead
of predeclaring the standard system functions |strlen|, |strcmp|, |strcpy|,
|strncmp|, and |strncpy|.
@^system dependencies@>

@<Include...@>=
#include <string.h>

@** Path searching.  By default, \.{CTANGLE} and \.{CWEAVE} are looking
for include files along the path |CWEBINPUTS|.  By setting the environment
variable of the same name to a different search path you can suit your
personal needs.  The |default_path| defined in the Makefile always is
appended to any setting of the environment variable, so you don't have
to repeat the default entries.  The following procedure copies the value
of the |environment| variable (if any) to the variable |include_path| used
for path searching and appends the |default_path| string.

@c
static boolean set_path(char *default_path,char *environment)
{
  char string[max_path_length+2];

  if(environment) {
    if(strlen(environment)+strlen(default_path) >= max_path_length) {
      err_print("! Include path too long"); return(0);
@.Include path too long@>
    }
    else {
      sprintf(string,"%s%c%s",environment,PATH_SEPARATOR,default_path);
      strcpy(default_path,string);
    }
  }
  return(1);
}

@ The path search algorithm defined in section |@<Try to open...@>|
needs a few extra variables.  If no string is given in this variable,
the |define| variable |CWEBINPUTS| (if given in the Makefile) is used
instead, which holds some sensible paths.
@^system dependencies@>

@d max_path_length 4094

@<Other...@>=
char *include_path;@/
char *p, *path_prefix, *next_path_prefix;@/

@ @<Init...@>=
alloc_object(include_path,max_path_length+2,char);
#ifdef CWEBINPUTS
strcpy(include_path,CWEBINPUTS);
#endif

@** Memory allocation. Due to restrictions of most {\mc MS-DOS}-\CEE/ compilers,
large arrays will be allocated dynamically rather than statically. In the {\mc
TURBO}-\CEE/ implementation the |farcalloc| function provides a way to allocate
more than 64~KByte of data. The |allocsafe| function tries to carry out an
allocation of |nunits| blocks of size |unitsz| by calling |farcalloc| and takes
a safe method, when this fails: the program will be aborted.

To deal with such allocated data areas |huge| pointers will be used in this
implementation.

The idea of dynamical memory allocation is extended to all internal arrays
(except the |flags| field) for other operating systems as well.  Especially
on the {\mc AMIGA} this use very useful in that the programs can be
compiled in the \.{NEAR} data segment and thus can be made \\{resident}.

@f far int
@f huge int
@f HUGE int

@<Pred...@>=
#ifdef __TURBOC__
void far *allocsafe(unsigned long,unsigned long);
#endif
@^system dependencies@>

@ @c
#ifdef __TURBOC__
void far *allocsafe (unsigned long nunits,unsigned long unitsz)
{
  void far *p = farcalloc(nunits,unitsz);
  if (p==NULL) fatal("",get_string(MSG_FATAL_CO85));
@.Memory allocation failure@>
  return p;
}
#endif
@^system dependencies@>

@ @<Include...@>=
#ifdef __TURBOC__
#include <alloc.h> /* import |farcalloc| */
#include <io.h> /* import |write| */
#endif
@^system dependencies@>

@ @<Macro...@>=
#ifdef __TURBOC__
#define HUGE huge
#else
#define HUGE
#endif
@^system dependencies@>

@ In case of an user break we must take care of the dynamically allocated
and opened resources like memory segments and system libraries and catalog
files.  There is no warranty that in such cases the exit code automatically
frees these resources.  |exit| is not necessarily called after a break.
{\mc ANSI-C} provides ``interrupt handlers'' for this purpose.
|catch_break| simply calls |wrap_up| before |exit|ing the aborted program.
@^system dependencies@>

@<Set up the event trap@>=
  if(signal(SIGINT,&catch_break) == SIG_ERR)
    exit(EXIT_FAILURE); /* Interrupt handler could not be set up. */

@ The only purpose of the interrupt handler |catch_break| in case of an
user abort is to call the cleanup routine that takes care of any opened
system resources.

@c
void catch_break(int dummy)
   {
   history=fatal_message;
   exit(wrap_up());
   }

@ @<Predec...@>=
void catch_break(int);

@ @<Remove the temporary file...@>=
  if(C_file) fclose(C_file);
  if(tex_file) fclose(tex_file);
  if(check_file) fclose(check_file);
  if(check_file_name) /* Delete the temporary file in case of a break */
    remove(check_file_name);

@** Multilinguality.  The {\mc AMIGA} operating system (and maybe some
other operating systems as well), starting with version~2.1, is inherently
multilingual.  With the help of system catalogs, any decent program
interface can be made sensitive to the language the user wants to be
addressed with.  All terminal output strings were located and replaced by
references to an external array |AppStrings|.  The English defaults of
these strings can be overwritten by the entries of translated catalogs.
The following include file \.{cweb.h} contains a complete description of
all strings used in this extended \.{CWEB} system.
@^system dependencies@>

@<Include files@>=
#ifdef _AMIGA
#include <proto/exec.h>
#include <proto/locale.h>
@#
struct Library *LocaleBase=NULL; /* pointer to the locale library */
struct Catalog *catalog=NULL; /* pointer to the external catalog */
int i; /* global counter for list of strings */
#else /* non-{\mc AMIGA} systems don't know about \.{<exec/types.h>} */
typedef long int LONG; /* excerpt from \.{<exec/types.h>} */
typedef char * STRPTR; /* ditto, but \UNIX/ says it's signed. */
#define EXEC_TYPES_H 1 /* don't include \.{<exec/types.h>} in \.{"cweb.h"} */
#endif
@#
#define STRINGARRAY 1 /* include the string array |AppStrings| for real */
#define get_string(n) AppStrings[n].as_Str /* reference string $n$ */
@#
#include "cweb.h"

@ Version~2.1 or higher of the {\mc AMIGA} operating system (represented as
internal version~38) will replace the complete set of terminal output strings
by an external translation in accordance to the system default language.

@<Use catalog translations@>=
  if(LocaleBase=(struct Library *)OpenLibrary(
    (unsigned char *)"locale.library",38L)) {
    if(catalog=OpenCatalog(NULL,"cweb.catalog",
      OC_BuiltInLanguage,"english",TAG_DONE)) {
      for(i=MSG_ERROR_CO9; i<=MSG_STATS_CW248_6; ++i)
        AppStrings[i].as_Str=GetCatalogStr(catalog,i,AppStrings[i].as_Str);
      }
    }

@ It is essential to close the pointer references to the language catalog
and to the system library before shutting down the program itself.
@^system dependencies@>

@<Close the language catalog@>=
  if(LocaleBase) {
    CloseCatalog(catalog);
    CloseLibrary(LocaleBase);
    }

@** AREXX communication.  In case of an error we want to have a common
interface used by \.{CWEB} and the \CEE/ compiler in the same way.  For
the {\mc AMIGA} this is \.{SCMSG}, the message browser of the {\mc SAS/C}
development system.  This program has an {\mc AREXX} port and can be
addressed by other applications like \.{CTANGLE} and \.{CWEAVE} with
the help of the routines described in this part of the program.
(I admit to have shamelessly borrowed code from the Pas\TEX/
implementation of \.{dvips}~5.47 by Georg He{\ss}mann.)
To make use of this feature it is necessary (besides having an
{\mc AMIGA}) to include a few system dependent header files.
@^system dependencies@>

@<Include files@>=
#ifdef _AMIGA
#include <proto/dos.h>
#include <proto/rexxsyslib.h>
#endif

@ A list of declarations and variables is added.  Most of these are
globally defined because the initialization of the message port is done
outside these local routines.
@^system dependencies@>

@<Other...@>=
#ifdef _AMIGA
long result = RETURN_FAIL;
char msg_string[BUFSIZ];
char pth_buffer[BUFSIZ];
char cur_buffer[BUFSIZ];
@#
struct RexxMsg *rm;
struct MsgPort *rp;
@#
#define MSGPORT  "SC_SCMSG"
#define PORTNAME "CWEBPORT"
#define RXEXTENS "rexx"
#endif

@ This function addresses the message browser of the {\mc SAS/C} system by
means of its {\mc AREXX} communication port.
@^system dependencies@>

@c
#ifdef _AMIGA
static int PutRexxMsg(struct MsgPort *mp, long action,@|
  STRPTR arg0, struct RexxMsg *arg1)
  {
  if ((rm = CreateRexxMsg(mp, (unsigned char *)RXEXTENS, @|
      (unsigned char *)mp->mp_Node.ln_Name)) != NULL) {
    rm->rm_Action  = action;
    rm->rm_Args[0] = arg0;
    rm->rm_Args[1] = (STRPTR)arg1;

    Forbid(); /* Disable multitasking. */
    if ((rp = FindPort((unsigned char *)MSGPORT)) != NULL)
      PutMsg(rp, (struct Message *)rm);
    Permit(); /* Enable multitasking. */

    if (rp == NULL) /* Sorry, message browser not found. */
      DeleteRexxMsg(rm);
  }
  return(rm != NULL && rp != NULL);
}
#endif

@ This function is the ``interface'' between \.{CWEB} and {\mc AREXX}\null.
The first argument is a string containing a full line of text to be sent to
the browser.  The second argument returns the transmission result.
@^system dependencies@>

@c
#ifdef _AMIGA
int __stdargs call_rexx(char *str, long *result)
{
  char *arg;
  struct MsgPort *mp;
  struct RexxMsg *rm, *rm2;
  int ret = FALSE;
  int pend;

  if (!(RexxSysBase = OpenLibrary((unsigned char *)RXSNAME, 0L)))
    return(ret);

  Forbid(); /* Disable multitasking. */
  if (FindPort((unsigned char *)PORTNAME) == NULL)
    mp = CreatePort(PORTNAME, 0L);
  Permit(); /* Enable multitasking. */

  if (mp != NULL) {
    if ((arg = (char *)CreateArgstring(
        (unsigned char *)str, strlen(str))) != NULL) {
      if (PutRexxMsg(mp, RXCOMM | RXFF_STRING, arg, NULL)) {
        for (pend = 1; pend != 0; )
          if (WaitPort(mp) != NULL)
            while ((rm = (struct RexxMsg *)GetMsg(mp)) != NULL)
              if (rm->rm_Node.mn_Node.ln_Type == NT_REPLYMSG) {
                ret = TRUE;
                *result = rm->rm_Result1;
                if ((rm2 = (struct RexxMsg *)rm->rm_Args[1]) != NULL) {
                  rm2->rm_Result1 = rm->rm_Result1;
                  rm2->rm_Result2 = 0;
                  ReplyMsg((struct Message *)rm2);
                }
                DeleteRexxMsg(rm);
                pend--;
              }
              else {
                rm->rm_Result2 = 0;
                if (PutRexxMsg(mp, rm->rm_Action, rm->rm_Args[0], rm))
                  pend++;
                else {
                  rm->rm_Result1 = RETURN_FAIL;
                  ReplyMsg((struct Message *)rm);
                }
              }
      }
      DeleteArgstring((unsigned char *)arg);
    }
    DeletePort(mp);
  }

  CloseLibrary((struct Library *)RexxSysBase);

  return(ret);
}
#endif

@ The prototypes for these two new functions are added to the common list.
@^system dependencies@>

@<Predecl...@>=
#ifdef _AMIGA
static int PutRexxMsg(struct MsgPort *,long,STRPTR,struct RexxMsg *);
int __stdargs call_rexx(char *,long *);
#endif

@ Before we can send any signal to the message browser we have to make sure
that the receiving port is active.  Possibly a call to \.{scmsg} will
suffice.  If it is not there, any attempt to send a message will fail.

You can control the behaviour of \.{scmsg} via the external environment
variable \.{SCMSGOPT} which may contain any legal command line options as
described in the documentation provided by {\mc SAS}~Institute.
The display window with the error messages will not appear if you supply
\.{scmsg} with its \.{rexxonly} option.  If you want to see every message
on your screen, replace this option with \.{hidden}.  The first error
message received by \.{scmsg} will open the output window.  The very first
message for the browser initializes its database for the current web file.
Any pending entries will be destroyed before new ones are added.
@^system dependencies@>

@<Set up the {\mc AREXX} communication@>=
if(send_error_messages) {
  Forbid(); /* Disable multitasking. */
  if ((rp = FindPort((unsigned char *)MSGPORT)) != NULL);
    /* Check for browser port. */
  Permit(); /* Enable multitasking. */

  if(!rp) { /* Make sure, the browser is active. */
    strcpy(msg_string,"run <nil: >nil: scmsg ");
    strcat(msg_string,getenv("SCMSGOPT")); /* Add browser options. */
    system(msg_string);
    }

  if(GetCurrentDirName(cur_buffer,BUFSIZ) && @|
    AddPart(cur_buffer,web_file_name,BUFSIZ)) {
    sprintf(msg_string,"newbld \"%s\"",cur_buffer);
    call_rexx(msg_string,&result); /* Ignore the results. */
    }
  }

@ There are three types of \.{CWEB} errors reported to the message browser.
For completeness we give them the numbers~997 to~999.  The first one refers
to errors in the active change file.  If you click on the error line in the
browser window, your system editor will take you to the offending line in
the change file (given the communication between the browser and your
editor is properly set up).  There is a slight difficulty when entering
file names into the error message; the browser expects complete path names
and we have to add them more or less by~hand.
@^system dependencies@>

@<Report an error in the change file@>={
  printf(get_string(MSG_ERROR_CO59_1), change_line);
#ifdef _AMIGA
  if(send_error_messages) {

    if(GetCurrentDirName(cur_buffer,BUFSIZ) && @|
      AddPart(cur_buffer,web_file_name,BUFSIZ) && @|

      GetCurrentDirName(pth_buffer,BUFSIZ) && @|
      AddPart(pth_buffer,change_file_name,BUFSIZ))

      sprintf(msg_string,"newmsg \"%s\" \"%s\" %d 0 \"\" 0 Error 997 %s",@|
        cur_buffer,pth_buffer,change_line,s);

    else strcpy(msg_string,"\0");
    }
#endif
  }

@ The next type of error occurs in the web file itself, so the current file
is the same as the offending file.  We have to create the full name only once.
@^system dependencies@>

@<Report an error in the web file@>={
  printf(get_string(MSG_ERROR_CO59_2), cur_line);
#ifdef _AMIGA
  if(send_error_messages) {

    if(GetCurrentDirName(cur_buffer,BUFSIZ) && @|
      AddPart(cur_buffer,cur_file_name,BUFSIZ))

      sprintf(msg_string,"newmsg \"%s\" \"%s\" %d 0 \"\" 0 Error 998 %s",@|
        cur_buffer,cur_buffer,cur_line,s);

    else strcpy(msg_string,"\0");
    }
#endif
  }

@ The error with the highest number is also the most subtle type.  It
occurs inside an include file, so we have to distinguish between the web
file and the offending file.
@^system dependencies@>

@<Report an error in an include file@>={
  printf(get_string(MSG_ERROR_CO59_3), cur_line, cur_file_name);
#ifdef _AMIGA
  if(send_error_messages) {

    if(GetCurrentDirName(cur_buffer,BUFSIZ) && @|
      AddPart(cur_buffer,cur_file_name,BUFSIZ) && @|

      GetCurrentDirName(pth_buffer,BUFSIZ) && @|
      AddPart(pth_buffer,web_file_name,BUFSIZ))

      sprintf(msg_string,"newmsg \"%s\" \"%s\" %d 0 \"\" 0 Error 999 %s",@|
        pth_buffer,cur_buffer,cur_line,s);

    else strcpy(msg_string,"\0");
    }
#endif
  }

@ In the three sections above we simply created a string holding the full
entry line which is handed over to the message browser by calling our
|call_rexx| routine.  The boolean return value is ignored.
@^system dependencies@>

@<Put the error message in the browser@>=
  if(send_error_messages && msg_string)
    call_rexx(msg_string,&result); /* Ignore the results. */

@** Function declarations. Here are declarations, conforming to {\mc ANSI~C},
of all functions in this code that appear in |"common.h"| and thus should
agree with \.{CTANGLE} and \.{CWEAVE}.

@<Predecl...@>=
int get_line(void);@/
name_pointer add_section_name(name_pointer,int,char *,char *,int);@/
name_pointer id_lookup(char *,char *,char);@/
name_pointer section_lookup(char *,char *,int);
void check_complete(void);@/
void common_init(void);@/
void extend_section_name(name_pointer,char *,char *,int);@/
void print_prefix_name(name_pointer);@/
void print_section_name(name_pointer);@/
void reset_input(void);@/
void sprint_section_name(char *,name_pointer);

@ The following functions are private to |"common.w"|.

@<Predecl...@>=
static boolean set_path(char *,char *);@/
static int input_ln(FILE *);@/
static int web_strcmp(char HUGE *,int,char HUGE *,int);@/
static void check_change(void);@/
static void prime_the_change_buffer(void);

@** Index.
@z
------------------------------------------------------------------------------
