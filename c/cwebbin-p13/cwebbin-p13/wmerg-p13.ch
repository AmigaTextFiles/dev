@x
#include <stdio.h>
@y
#include <string.h>
#include <signal.h>
#include <stdio.h>
@#
#ifdef SEPARATORS
char separators[]=SEPARATORS;
#else
char separators[]="://"; /* UNIX set up */
#endif
@#
#define PATH_SEPARATOR   separators[0]
#define DIR_SEPARATOR    separators[1]
#define DEVICE_SEPARATOR separators[2]
@z

@x
main (ac,av)
int ac; char **av;
@y
int main (int ac, char **av)
@z

@x
  @<Set the default options@>;
@y
  @<Set up the exit trap@>@;
  @<Initialize the memory blocks@>;
  @<Set the default options@>;
@z

@x
  return wrap_up();
@y
  if(out_file!=stdout) {
    fclose(out_file); out_file=NULL;
    @<Update the result when it has changed@>@;
    }
  return wrap_up();
@z

@x
@ We predeclare some standard string-handling functions here instead of
including their system header files, because the names of the header files
are not as standard as the names of the functions. (There's confusion
between \.{<string.h>} and \.{<strings.h>}.)

@<Predecl...@>=
extern int strlen(); /* length of string */
extern char* strcpy(); /* copy one string to another */
extern int strncmp(); /* compare up to $n$ string characters */
extern char* strncpy(); /* copy up to $n$ string characters */
@y
@ For string handling we include the {\mc ANSI C} system header file
instead of predeclaring the standard system functions |strlen|, |strcmp|,
|strcpy|, and |strncpy|.  This is done in the main section.
@^system dependencies@>
@z

@x
ASCII buffer[buf_size]; /* where each line of input goes */
ASCII *buffer_end=buffer+buf_size-2; /* end of |buffer| */
@y
ASCII *buffer; /* where each line of input goes */
ASCII *buffer_end; /* end of |buffer| */
@z

@x
input_ln(fp) /* copies a line into |buffer| or returns 0 */
FILE *fp; /* what file to read from */
@y
int input_ln(@t\1\1@> /* copies a line into |buffer| or returns 0 */
  FILE *fp@t\2\2@>) /* what file to read from */
@z

@x
@d max_file_name_length 60
@y
@d max_file_name_length 255
@z

@x
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

@x
@d lines_dont_match (change_limit-change_buffer != limit-buffer ||
  strncmp(buffer, change_buffer, limit-buffer))
@y
@d lines_dont_match (change_limit-change_buffer != limit-buffer ||
  strncmp(buffer, change_buffer, (size_t)(limit-buffer)))
@z

@x
char change_buffer[buf_size]; /* next line of |change_file| */
@y
char *change_buffer; /* next line of |change_file| */
@z

@x
void
prime_the_change_buffer()
@y
void prime_the_change_buffer(void)
@z

@x
  strncpy(change_buffer,buffer,limit-buffer+1);
@y
  strncpy(change_buffer,buffer,(size_t)(limit-buffer+1));
@z

@x
void
check_change() /* switches to |change_file| if the buffers match */
@y
void check_change(void) /* switches to |change_file| if the buffers match */
@z

@x
void
reset_input()
@y
void reset_input(void)
@z

@x
  @<Open input files@>;
  include_depth=0; cur_line=0; change_line=0;
@y
  include_depth=0; cur_line=0; change_line=0;
  @<Open input files@>;
@z

@x
void put_line()
@y
void put_line(void)
@z

@x
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
\.{@@i} line should give a complete file name with or without double
quotes.  The remainder of the \.{@@i} line after the file name is ignored.
\.{CWEB} will look for include files in standard directories specified in
the environment variable \.{CWEBINPUTS}. Multiple search paths can be
specified by delimiting them with \.{PATH\_SEPARATOR}s.  The given file is
searched for in the current directory first.  You also may include device
names; these must have a \.{DEVICE\_SEPARATOR} as their rightmost character.
@z

@x
  char temp_file_name[max_file_name_length];
@y
  static char *temp_file_name;
@z

@x
  while (*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end) *k++=*loc++;
@y
  alloc_object(temp_file_name,max_file_name_length,char);
  while (*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end) *k++=*loc++;
@z

@x
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
    if((cur_file = fopen(temp_file_name,"r"))!=NULL) {
      cur_line=0; goto restart; /* success */
    }
    if((next_path_prefix = strchr(path_prefix,PATH_SEPARATOR))!=NULL)
      path_prefix = next_path_prefix+1;
    else break; /* no more paths to search; no file found */
  }
@z

@x
void
check_complete(){
@y
void check_complete(void) {
@z

@x
    strncpy(buffer,change_buffer,change_limit-change_buffer+1);
@y
    strncpy(buffer,change_buffer,(size_t)(change_limit-change_buffer+1));
@z

@x
void  err_print();
@y
void  err_print(char *);
@z

@x
void
err_print(s) /* prints `\..' and location of error message */
char *s;
@y
void err_print(char *s) /* prints `\..' and location of error message */
@z

@x
@ Some implementations may wish to pass the |history| value to the
operating system so that it can be used to govern whether or not other
programs are started. Here, for instance, we pass the operating system
a status of 0 if and only if only harmless messages were printed.
@^system dependencies@>
@y
@ On multi-tasking systems like the Amiga it is very convenient to know
a little bit more about the reasons why a program failed.  The four levels
of return indicated by the |history| value are very suitable for this
purpose.  Here, for instance, we pass the operating system a status of~0
if and only if the run was a complete success.  Any warning or error
message will result in a higher return value, so ARexx scripts can be
made sensitive to these conditions.

|__TURBOC__| has another shitty ``feature'' that has to be fixed.
|return|ing from several |case|s crashes the system.  Either always the
first case is used, or the system is crashed completely.  Really funny.
@^system dependencies@>

@d RETURN_OK     0 /* No problems, success */
@d RETURN_WARN   5 /* A warning only */
@d RETURN_ERROR 10 /* Something wrong */
@d RETURN_FAIL  20 /* Complete or severe failure */
@z

@x
wrap_up() {
@y
int wrap_up(void) {
@z

@x
  @<Print the job |history|@>;
@y
  if(history>spotless) putchar('\n');
  @<Remove the temporary file if not already done@>@;
  @<Print the job |history|@>;
@z

@x
  if (history > harmless_message) return(1);
  else return(0);
@y
#ifdef __TURBOC__
  {
  int return_val;

  switch(history) {
  case harmless_message: return_val=RETURN_WARN; break;
  case error_message: return_val=RETURN_ERROR; break;
  case fatal_message: return_val=RETURN_FAIL; break;
  default: return_val=RETURN_OK;
    }
  return(return_val);
  }
#else
  switch(history) {
  case harmless_message: return(RETURN_WARN); break;
  case error_message: return(RETURN_ERROR); break;
  case fatal_message: return(RETURN_FAIL); break;
  default: return(RETURN_OK);
    }
#endif
@z

@x
the names of those files. Most of the 128 flags are undefined but available
@y
the names of those files. Most of the 256 flags are undefined but available
@z

@x
char out_file_name[max_file_name_length]; /* name of |out_file| */
boolean flags[128]; /* an option for each 7-bit code */
@y
char *check_file_name; /* name of |check_file| */
char *out_file_name; /* name of |out_file| */
boolean *flags; /* an option for each 8-bit code */
@z

@x
An omitted change file argument means that |'/dev/null'| should be used,
when no changes are desired.
@y
An omitted change file argument means that |'/dev/null'| or---on non-\UNIX/
systems the contents of the compile-time variable |_DEV_NULL|---should
be used, when no changes are desired.
@z

@x
void scan_args();
@y
void scan_args(void);
@z

@x
void
scan_args()
@y
void scan_args(void)
@z

@x
        else if (*s=='/') dot_pos=NULL,++s;
@y
        else if (*s==DIR_SEPARATOR || *s==DEVICE_SEPARATOR || *s=='/')
          dot_pos=NULL,++s;
@z

@x
  if (!found_change) strcpy(change_file_name,"/dev/null");
@y
#ifdef _DEV_NULL
  if (!found_change) strcpy(change_file_name,_DEV_NULL);
#else
  if (!found_change) strcpy(change_file_name,"/dev/null");
#endif
@z

@x
FILE *out_file; /* where output goes */
@y
FILE *check_file; /* where the temporary output goes */
FILE *out_file; /* where output goes */
@z

@x
if (out_file_name[0]=='\0') out_file=stdout;
else if ((out_file=fopen(out_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", out_file_name);
@y
strcpy(check_file_name,out_file_name);
if(check_file_name[0]!='\0') {
  char *dot_pos=strrchr(check_file_name,'.');
  if(dot_pos==NULL) strcat(check_file_name,".mtp");
  else strcpy(dot_pos,".mtp");
  }
if (out_file_name[0]=='\0') out_file=stdout;
else if ((out_file=fopen(check_file_name,"w"))==NULL)
    fatal("! Cannot open output file ", check_file_name);
@z

@x
@* Index.
@y
@* Version information.  The {\mc AMIGA} operating system provides the
`version' command and good programs answer with some informations about
their creation date and their current version.  This might be useful for
other operating systems as well.

@<Defi...@>=
const char Version[] = "$VER: WMerge 3.4 [p13] ("__DATE__", "__TIME__")\n";

@* Function declarations.  To satisfy all the {\mc ANSI} compilers out
there, here are the prototypes of all internal functions.

@<Predecl...@>=
int get_line(void);@/
int input_ln(FILE *);@/
int main(int,char **);@/
int wrap_up(void);@/
void check_change(void);@/
void check_complete(void);@/
void prime_the_change_buffer(void);@/
void put_line(void);@/
void reset_input(void);

@ The following function is private to |"wmerge.w"|.

@<Predecl...@>=
static boolean set_path(char *,char *);

@** Path searching.  By default, \.{CTANGLE} and \.{CWEAVE} are looking
for include files along the path |CWEBINPUTS|.  By setting the environment
variable of the same name to a different search path you can suit your
personal needs.  If this variable is empty, some decent defaults are used
internally.  The following procedure takes care that these internal entries
are appended to any setting of the environmnt variable, so you don't have
to repeat the defaults.
@^system dependencies@>

@c
static boolean set_path(char *include_path,char *environment)
{
  char *string;

  alloc_object(string,max_path_length+2,char);

#ifdef CWEBINPUTS
  strcpy(include_path,CWEBINPUTS);
#endif

  if(environment) {
    if(strlen(environment)+strlen(include_path) >= max_path_length) {
      err_print("! Include path too long");
      free_object(string); return(0);
@.Include path too long@>
    }
    else {
      sprintf(string,"%s%c%s",environment,PATH_SEPARATOR,include_path);
      strcpy(include_path,string);
    }
  }
  free_object(string); return(1);
}

@ The path search algorithm defined in section |@<Try to open...@>|
needs a few extra variables.

@d max_path_length (BUFSIZ-2)

@<Definitions...@>=
char *include_path;@/
char *p, *path_prefix, *next_path_prefix;

@* Dynamic memory allocation.  Just as \.{CTANGLE} and \.{CWEAVE} before,
\.{WMERGE} allocates all its internal arrays dynamically, so the resulting
program can be compiled in the \.{NEAR} data segment and made resident on
the Amiga.  We do all the global allocations here.

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
alloc_object(check_file_name,max_file_name_length,char);
alloc_object(out_file_name,max_file_name_length,char);
alloc_object(flags,256,boolean);
alloc_object(include_path,max_path_length+2,char);
strcpy(include_path,"");

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

@* Output file update.  Most \CEE/ projects are controlled by a
\.{makefile} which automatically takes care of the temporal dependencies
between the different source modules.  It is suitable that \.{CWEB} doesn't
create new output for all existing files, when there are only changes to
some of them.  Thus the \.{make} process will only recompile those modules
where necessary.  The idea and basic implementation of this mechanism can
be found in the program \.{NUWEB} by Preston Briggs, to whom credit is due.

@<Update the result...@>=
if((out_file=fopen(out_file_name,"r"))!=NULL) {
  char *x,*y;
  int x_size,y_size,comparison;

  if((check_file=fopen(check_file_name,"r"))==NULL)
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
  comparison = (x_size == y_size); /* Do not merge these statements! */
  if(comparison) comparison = !memcmp(x,y,x_size);
  } while(comparison && !feof(out_file) && !feof(check_file));

@ Note the superfluous call to |remove| before |rename|.  We're using it to
get around a bug in some implementations of |rename|.

@<Take appropriate action...@>=
if(comparison)
  remove(check_file_name); /* The output remains untouched */
else {
  remove(out_file_name);
  rename(check_file_name,out_file_name);
  }

@ @<Remove the temporary file...@>=
  if(out_file)
    fclose(out_file);
  if(check_file)
    fclose(check_file);
  if(check_file_name)
    remove(check_file_name);

@* Index.
@z
