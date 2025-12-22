								-*-Web-*-
This file, WMERGE.CH, is part of CWEB (Version 3.3 [patch level 11]).
It is a changefile for WMERGE.W, Version 3.3.

Authors and Contributors:
(H2B) Hans-Hermann Bode, Universität Osnabrück,
  (hhbode@@dosuni1.rz.uni-osnabrueck.de or HHBODE@@DOSUNI1.BITNET).

(KG) Klaus Guntermann, TH Darmstadt,
  (guntermann@@iti.informatik.th-darmstadt.de).

(AS) Andreas Scherer, RWTH Aachen,
  (scherer@@genesis.informatik.rwth-aachen.de).

(BS) Barry Schwartz
  (trashman@@crud.mn.org)

Caveat utilitor:  Some of the source code introduced by this change file is
made conditional to the use of specific compilers on specific systems.
This applies to places marked with `#ifdef __MSDOS__' and `#ifdef __TURBOC__',
`#ifdef _AMIGA' and `#ifdef __SASC'.

This program is distributed WITHOUT ANY WARRANTY, express or implied.

The following copyright notice extends to this changefile only, not to
the masterfile WMERGE.W.

Copyright (C) 1991-1993 Hans-Hermann Bode
Copyright (C) 1993,1994 Andreas Scherer
Copyright (C) 1994 Barry Schwartz

Permission is granted to make and distribute verbatim copies of this
document provided that the copyright notice and this permission notice
are preserved on all copies.

Permission is granted to copy and distribute modified versions of this
document under the conditions for verbatim copying, provided that the
entire resulting derived work is distributed under the terms of a
permission notice identical to this one.

Version history:

Version	Date		Author	Comment
p2	13 Feb 1992	H2B	First hack.
p3	16 Apr 1992	H2B	Change of |@@i| allowed, /dev/null in case
				replaced by nul.
p4	21 Jun 1992	H2B	Nothing changed.
p5	21 Jul 1992	H2B	Nothing changed.
p5a	30 Jul 1992	KG	remove one #include <stdio.h>,
				use strchr instead of index and
				include <string.h> for |strchr| declaration
p5b	06 Aug 1992	KG	fixed a typo
p6	06 Sep 1992	H2B	Nothing changed.
p6a     15 Mar 1993     AS      SAS/C 6.0 support
p6b     28 Jul 1993     AS      make some functions return `void'
p6c	04 Sep 1993	AS	path searching with CWEBINCLUDE
p7	09 Oct 1993	AS	Updated to CWEB 2.8
p8a	11 Mar 1993	H2B	Converted to master change file.
				[Not released.]
p8b	15 Apr 1993	H2B	Updated for wmerge.w 3.0beta (?).
				[Not released.]
p8c	22 Jun 1993	H2B	Updated for final wmerge.w 3.0 (?).
p8d	26 Oct 1993	AS	Incorporated with Amiga version 2.8 [p7].
p8e	04 Nov 1993	AS	New patch level in accordance with CWEB.
p9	18 Nov 1993	AS	Update for wmerge.w 3.1.
	26 Nov 1993	AS	Minor casting problems fixed.
p9c	18 Jan 1994	AS	Version information included.
p9d	09 Aug 1994	AS	Extend buf_size.
p10	12 Aug 1994	AS	Updated for wmerge.w 3.2.
p10a	24 Aug 1994	AS	New patch level.
p10b	11 Oct 1994	AS	Write to check_file and compare results.
	13 Oct 1994	AS	WMerge residentable.
	18 Oct 1994	AS	Some refinements for C++ compilation.
	21 Oct 1994	AS	Use _DEV_NULL instead of the multi-way
				selection for the NULL path/device.
	12 Nov 1994	AS	Use SEPARATORS instead of the multi-way
				selection for '/', ':', '\', etc.
p11	03 Dec 1994	AS	Updated for CWEB 3.3.
	13 Dec 1994	AS	Slight correction in `wrap_up()'.
------------------------------------------------------------------------------
@x l.14
#include <stdio.h>
@y
#include <stdio.h>
#include <string.h>
#include <signal.h>
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
ANSI
@x l.20
main (ac,av)
int ac; char **av;
@y
int main (int ac, char **av)
@z
------------------------------------------------------------------------------
@x l.24
  @<Set the default options@>;
@y
  @<Set up the exit trap@>@;
  @<Initialize the memory blocks@>;
  @<Set the default options@>;
@z
------------------------------------------------------------------------------
@x l.32
  return wrap_up();
@y
  if(out_file!=stdout) {
    fclose(out_file); out_file=NULL;
    @<Update the result when it has changed@>@;
    }
  return wrap_up();
@z
------------------------------------------------------------------------------
@x l.45
@<Predecl...@>=
extern int strlen(); /* length of string */
extern char* strcpy(); /* copy one string to another */
extern int strncmp(); /* compare up to $n$ string characters */
extern char* strncpy(); /* copy up to $n$ string characters */
@y
@z
------------------------------------------------------------------------------
@x l.69
ASCII buffer[buf_size]; /* where each line of input goes */
ASCII *buffer_end=buffer+buf_size-2; /* end of |buffer| */
@y
ASCII *buffer; /* where each line of input goes */
ASCII *buffer_end; /* end of |buffer| */
@z
------------------------------------------------------------------------------
@x l.94
input_ln(fp) /* copies a line into |buffer| or returns 0 */
FILE *fp; /* what file to read from */
@y
int input_ln(@t\1\1@> /* copies a line into |buffer| or returns 0 */
  FILE *fp@t\2\2@>) /* what file to read from */
@z
------------------------------------------------------------------------------
AmigaDOS allows path names with up to 255 characters.
@x l.127
@d max_file_name_length 60
@y
@d max_file_name_length 256
@z
------------------------------------------------------------------------------
@x l.136
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
The third argument of `strncpy' should be of type `size_t' not `long'.
@x l.157
@d lines_dont_match (change_limit-change_buffer != limit-buffer ||
  strncmp(buffer, change_buffer, limit-buffer))
@y
@d lines_dont_match (change_limit-change_buffer != limit-buffer ||
  strncmp(buffer, change_buffer, (size_t)(limit-buffer)))
@z
------------------------------------------------------------------------------
@x l.161
char change_buffer[buf_size]; /* next line of |change_file| */
@y
char *change_buffer; /* next line of |change_file| */
@z
------------------------------------------------------------------------------
To avoid some nasty warnings by strict ANSI C compilers we redeclare all
functions to `void' that return no concrete values.
@x l.172
void
prime_the_change_buffer()
@y
void prime_the_change_buffer(void)
@z
------------------------------------------------------------------------------
The third argument of `strncpy' should be of type `size_t' not `long'.
@x l.215
  strncpy(change_buffer,buffer,limit-buffer+1);
@y
  strncpy(change_buffer,buffer,(size_t)(limit-buffer+1));
@z
------------------------------------------------------------------------------
Another `void' function, i.e., a procedure.
@x l.231
void
check_change() /* switches to |change_file| if the buffers match */
@y
void check_change(void) /* switches to |change_file| if the buffers match */
@z
------------------------------------------------------------------------------
Another `void function, i.e., a procedure.
@x l.283
void
reset_input()
@y
void reset_input(void)
@z
------------------------------------------------------------------------------
SAS/C defines `putchar' as a macro and reports a warning about multiple
macro expansion.  The resulting `wmerge' is definitely wrong; it leaves
every second letter out.  This has been tracked to be a bug in SAS's
<stdio.h>, but unfortunately SAS Institute has quit further development.
@x l.345
void put_line()
{
  char *ptr=buffer;
  while (ptr<limit) putc(*ptr++,out_file);
  putc('\n',out_file);
}
@y
void put_line(void)
{
  char *ptr=buffer;
  while (ptr<limit)
  {
    putc(*ptr,out_file);
    ptr++;
  }
  putc('\n',out_file);
}
@z
------------------------------------------------------------------------------
@x l.352
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
character.
@z
------------------------------------------------------------------------------
@x l.367
  char temp_file_name[max_file_name_length]; 
@y
  static char *temp_file_name; 
@z
------------------------------------------------------------------------------
@x l.372
  while (*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end) *k++=*loc++;
@y
  alloc_object(temp_file_name,max_file_name_length,char);
  while (*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end) *k++=*loc++;
@z
------------------------------------------------------------------------------
CWEB will perform a path search for `@i'nclude files along the environment
variable CWEBINPUTS in case the given file can not be opened in the current
directory or in the absolute path.  The single paths are delimited by
PATH_SEPARATORs.
@x l.380
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
      cur_line=0; 
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
    if(path_prefix && *path_prefix && *path_prefix!=PATH_SEPARATOR &&
      *--p!=DEVICE_SEPARATOR && *p!=DIR_SEPARATOR) {
      *kk++ = DIR_SEPARATOR; l++;
    }
    if(k+l+2>=cur_file_name_end) too_long(); /* emergency break */
    strcpy(kk,cur_file_name);
    if(cur_file = fopen(temp_file_name,"r")) {
      cur_line=0; goto restart; /* success */
    }
    if(next_path_prefix = strchr(path_prefix,PATH_SEPARATOR))
      path_prefix = next_path_prefix+1;
    else break; /* no more paths to search; no file found */
  }
@z
------------------------------------------------------------------------------
Another `void' function, i.e., a procedure.
@x l.450
void
check_complete(){
@y
void check_complete(void) {
@z
------------------------------------------------------------------------------
The third argument of `strncpy' should be of type `size_t' not `long'.
@x l.453
    strncpy(buffer,change_buffer,change_limit-change_buffer+1);
@y
    strncpy(buffer,change_buffer,(size_t)(change_limit-change_buffer+1));
@z
------------------------------------------------------------------------------
Another `void' function, i.e., a procedure.
@x l.490
@<Predecl...@>=
void  err_print();

@
@<Functions...@>=
void
err_print(s) /* prints `\..' and location of error message */
char *s;
@y
@<Predecl...@>=
void  err_print(char *);

@
@<Functions...@>=
void err_print(char *s) /* prints `\..' and location of error message */
@z
------------------------------------------------------------------------------
On the AMIGA it is very convenient to know a little bit more about the
reasons why a program failed.  There are four levels of return for this
purpose.  Let CWeb be so kind to use them, so scripts can be made better.
@x l.540
@ Some implementations may wish to pass the |history| value to the
operating system so that it can be used to govern whether or not other
programs are started. Here, for instance, we pass the operating system
a status of 0 if and only if only harmless messages were printed.
@^system dependencies@>

@<Func...@>=
wrap_up() {
  @<Print the job |history|@>;
  if (history > harmless_message) return(1);
  else return(0);
}
@y
@ On multi-tasking systems like the Amiga it is very convenient to know
a little bit more about the reasons why a program failed.  The four levels
of return indicated by the |history| value are very suitable for this
purpose.  Here, for instance, we pass the operating system a status of~0
if and only if the run was a complete success.  Any warning or error
message will result in a higher return value, so ARexx scripts can be
made sensitive to these conditions.

|__TURBOC__| has another shitty ``feature'' that has to be fixed.
|return|ing from several |case|s crashes the system.  Really funny.
@^system dependencies@>

@d RETURN_OK     0 /* No problems, success */
@d RETURN_WARN   5 /* A warning only */
@d RETURN_ERROR 10 /* Something wrong */
@d RETURN_FAIL  20 /* Complete or severe failure */

@<Func...@>=
#ifdef __TURBOC__
int wrap_up(void) {
  int return_val;

  putchar('\n');
  @<Remove the temporary file if not already done@>@;
  @<Print the job |history|@>;
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
  @<Remove the temporary file if not already done@>@;
  @<Print the job |history|@>;
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
@x l.569
the names of those files. Most of the 128 flags are undefined but available
@y
the names of those files. Most of the 256 flags are undefined but available
@z
------------------------------------------------------------------------------
@x l.578
char out_file_name[max_file_name_length]; /* name of |out_file| */
boolean flags[128]; /* an option for each 7-bit code */
@y
char *out_file_name; /* name of |out_file| */
char *check_file_name; /* name of |check_file| */
boolean *flags; /* an option for each 8-bit code */
@z
------------------------------------------------------------------------------
@x l.593
An omitted change file argument means that |'/dev/null'| should be used,
when no changes are desired.
@y
An omitted change file argument means that |'/dev/null'| or---on non-\UNIX/
systems the contents of the compile-time variable |_DEV_NULL|---should
be used, when no changes are desired.
@z
------------------------------------------------------------------------------
Another `void' function, i.e., a procedure.
@x l.599
@<Pred...@>=
void scan_args();

@
@<Function...@>=
void
scan_args()
@y
@<Pred...@>=
void scan_args(void);

@
@<Function...@>=
void scan_args(void)
@z
------------------------------------------------------------------------------
@x l.608
  char *name_pos; /* file name beginning, sans directory */
@y
@z
------------------------------------------------------------------------------
@x l.617
      s=name_pos=*argv;@+dot_pos=NULL;
      while (*s) {
        if (*s=='.') dot_pos=s++;
        else if (*s=='/') dot_pos=NULL,name_pos=++s;
        else s++;
      }
@y
      s=*argv;@+dot_pos=NULL;
      while (*s) {
        if (*s=='.') dot_pos=s++;
        else if (*s==DIR_SEPARATOR || *s==DEVICE_SEPARATOR || *s=='/')
          dot_pos=NULL,++s;
        else s++;
      }
@z
------------------------------------------------------------------------------
@x l.630
  if (!found_change) strcpy(change_file_name,"/dev/null");
@y
#ifdef _DEV_NULL
  if (!found_change) strcpy(change_file_name,_DEV_NULL);
#else
  if (!found_change) strcpy(change_file_name,"/dev/null");
#endif
@z
------------------------------------------------------------------------------
@x l.693
FILE *out_file; /* where output goes */
@y
FILE *out_file; /* where output goes */
FILE *check_file; /* where the temporary output goes */
@z
------------------------------------------------------------------------------
@x l.696
scan_args();
if (out_file_name[0]=='\0') out_file=stdout;
else if ((out_file=fopen(out_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", out_file_name);
@.Cannot open output file@>
@y
scan_args();
tmpnam(check_file_name);
if(strrchr(check_file_name,DEVICE_SEPARATOR))
  check_file_name=strrchr(check_file_name,DEVICE_SEPARATOR)+1;
if (out_file_name[0]=='\0') out_file=stdout;
else if (!(out_file=fopen(check_file_name,"w")))
    fatal("! Cannot open output file ", check_file_name);
@.Cannot open output file@>
@z
------------------------------------------------------------------------------
@x l.709
@* Index.
@y
@* Path searching.  By default, \.{CTANGLE} and \.{CWEAVE} are looking
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
  static char *string;

  alloc_object(string,max_path_length+2,char);
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
needs a few extra variables.  The search path given in the environment
variable |CWEBINPUTS| must not be longer than |max_path_length|.  If no
string is given in this variable, the internal default |CWEBINPUTS| is
used instead, which holds some sensible paths.

@d max_path_length 4094

@<Definitions...@>=
char *include_path;
char *p, *path_prefix, *next_path_prefix;

@ To satisfy all the {\mc ANSI} compilers out there, here are the
prototypes of all internal functions.

@<Predecl...@>=
int get_line(void);@/
int input_ln(FILE *);@/
int main(int,char **);
int wrap_up(void);@/
void check_change(void);@/
void check_complete(void);@/
void err_print(char *);@/
void prime_the_change_buffer(void);@/
void put_line(void);@/
void reset_input(void);@/
void scan_args(void);@/
static boolean set_path(char *,char *);@/

@ Version information.  The {\mc AMIGA} operating system provides the
`version' command and good programs answer with some informations about
their creation date and their current version.

@<Defi...@>=
#ifdef __SASC
const char Version[] = "$VER: WMerge 3.3 [p11] ("__DATE__", "__TIME__")\n";
#endif

@* Output file update.  Most \CEE/ projects are controlled by a
\.{makefile} which automatically takes care of the temporal dependencies
between the different source modules.  It is suitable that \.{CWEB} doesn't
create new output for all existing files, when there are only changes to
some of them.  Thus the \.{make} process will only recompile those modules
where necessary.  The idea and basic implementation of this mechanism can
be found in the program \.{NUWEB} by Preston Briggs, to whom credit is due.

@f type int /* \.{type} becomes the pseudotype \&{type} */
@#
@d alloc_object(object,size,@!type)
   if(!(object = (type *)malloc((size)*sizeof(type))))
      fatal("","! Memory allocation failure");
@d free_object(object)
   if(object) {
      free(object);
      object=NULL;
      }

@<Update the result...@>=
if(out_file=fopen(out_file_name,"r")) {
  char *x,*y;
  int x_size,y_size;

  if(!(check_file=fopen(check_file_name,"r")))
    fatal("! Cannot open output file",check_file_name);

  alloc_object(x,BUFSIZ,char);
  alloc_object(y,BUFSIZ,char);

  @<Compare the temporary output to the previous output@>@;

  fclose(out_file); out_file=NULL;
  fclose(check_file); check_file=NULL;

  @<Take appropriate action depending on the comparison@>@;

  free_object(y);
  free_object(x);
  }
else
  rename(check_file_name,out_file_name); /* This was the first run */

check_file_name=NULL; /* We want to get rid of the temporary file */

@ We hope that this runs fast on most systems.

@<Compare the temp...@>=
do {
  x_size = fread(x,1,BUFSIZ,out_file);
  y_size = fread(y,1,BUFSIZ,check_file);
  } while((x_size == y_size) && !memcmp(x,y,x_size) &&
          !feof(out_file) && !feof(check_file));

@ Note the superfluous call to |remove| before |rename|.  We're using it to
get around a bug in some implementations of |rename|.

@<Take appropriate action...@>=
if((x_size != y_size) || memcmp(x,y,x_size)) {
  remove(out_file_name);
  rename(check_file_name,out_file_name);
  }
else
  remove(check_file_name); /* The output remains untouched */

@* Dynamic memory allocation.  Just as \.{CTANGLE} and \.{CWEAVE} before,
\.{WMERGE} allocates all its internal arrays dynamically, so the resulting
program can be compiled in the \.{NEAR} data segment and made resident on
the Amiga.  We do all the global allocations here.

@<Init...@>=
alloc_object(buffer,buf_size,ASCII);
buffer_end=buffer+buf_size-2;
alloc_object(file,max_include_depth,FILE*);
alloc_object(file_name,max_include_depth,char *);
for(i=0; i<max_include_depth; i++)
  alloc_object(file_name[i],max_file_name_length,char);
alloc_object(change_file_name,max_file_name_length,char);
alloc_object(alt_web_file_name,max_file_name_length,char);
alloc_object(line,max_include_depth,int);
alloc_object(change_buffer,buf_size,char);
alloc_object(out_file_name,max_file_name_length,char);
alloc_object(check_file_name,max_file_name_length,char);
alloc_object(flags,256,boolean);
alloc_object(include_path,max_path_length+2,char);
#ifdef CWEBINPUTS
strcpy(include_path,CWEBINPUTS);
#endif

@ @<Definitions@>=
int i; /* index variable for initializing matrices */

@ In case of an user break we must take care of the dynamically allocated
and opened resources like memory segments.  There is no warranty that in
such cases the exit code automatically frees these resources.  |exit| is
not necessarily called after a break.  {\mc ANSI-C} provides ``interrupt
handlers'' for this purpose.  |catch_break| simply calls |wrap_up| before
|exit|ing the aborted program.
@^system dependencies@>

@<Set up the exit trap@>=
  if(signal(SIGINT,&catch_break) == SIG_ERR)
    exit(1); /* Interrupt handler could not be set up. */

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
  if(out_file)
    fclose(out_file);
  if(check_file)
    fclose(check_file);
  if(check_file_name)
    remove(check_file_name);

@* Index.
@z
------------------------------------------------------------------------------
