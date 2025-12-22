@x
\def\title{Common code for CTANGLE and CWEAVE (Version 3.3)}
@y
\def\title{Common code for CTANGLE and CWEAVE (Version 3.3 [p13])}
@z

@x
  \centerline{(Version 3.3)}
@y
  \centerline{(Version 3.3 [p13])}
@z

@x
\let\maybe=\iftrue
@y
\let\maybe=\iftrue

@i "amiga_types.w"
@z

@x
@<Include files@>@/
@y
@<Include files@>@/
@<Macro definitions@>@/
@z

@x
void
common_init()
@y
void common_init(void)
@z

@x
  @<Initialize pointers@>;
@y
  @<Set up the event trap@>;
  @<Initialize pointers@>;
#ifdef _AMIGA
  @<Use catalog translations@>;
#endif
@z

@x
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

@x
int input_ln(fp) /* copies a line into |buffer| or returns 0 */
FILE *fp; /* what file to read from */
@y
static int input_ln(@t\1\1@> /* copies a line into |buffer| or returns 0 */
  FILE *fp@t\2\2@>) /* what file to read from */
@z

@x
      ungetc(c,fp); loc=buffer; err_print("! Input line too long");
@y
      ungetc(c,fp); loc=buffer; err_print(get_string(MSG_ERROR_CO9));
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
@d lines_dont_match (change_limit-change_buffer != limit-buffer || @|
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
static void prime_the_change_buffer(void)
@z

@x
    err_print("! Missing @@x in change file");
@y
    err_print(get_string(MSG_ERROR_CO13));
@z

@x
    err_print("! Change file ended after @@x");
@y
    err_print(get_string(MSG_ERROR_CO14));
@z

@x
  change_limit=change_buffer-buffer+limit;
  strncpy(change_buffer,buffer,limit-buffer+1);
@y
  change_limit=change_buffer+(ptrdiff_t)(limit-buffer);
  strncpy(change_buffer,buffer,(size_t)(limit-buffer+1));
@z

@x
void
check_change() /* switches to |change_file| if the buffers match */
@y
static void check_change(void)
  /* switches to |change_file| if the buffers match */
@z

@x
      err_print("! Change file ended before @@y");
@y
      err_print(get_string(MSG_ERROR_CO16_1));
@z

@x
        err_print("! CWEB file ended during a change");
@y
        err_print(get_string(MSG_ERROR_CO16_2));
@z

@x
  loc=buffer+2; err_print("! Where is the matching @@y?");
@y
  loc=buffer+2; err_print(get_string(MSG_ERROR_CO17_1));
@z

@x
    err_print("of the preceding lines failed to match");
@y
    err_print(get_string(MSG_ERROR_CO17_2));
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
       fatal("! Cannot open input file ", web_file_name);
@y
       fatal(get_string(MSG_FATAL_CO19_1), web_file_name);
@z

@x
if ((change_file=fopen(change_file_name,"r"))==NULL)
       fatal("! Cannot open change file ", change_file_name);
@y
#ifdef __SASC
@<Set up the {\mc AREXX} communication@>;
#endif
if ((change_file=fopen(change_file_name,"r"))==NULL)
       fatal(get_string(MSG_FATAL_CO19_2), change_file_name);
@z

@x
typedef unsigned short sixteen_bits;
@y
typedef unsigned char eight_bits;
typedef unsigned short sixteen_bits;
@z

@x
boolean changed_section[max_sections]; /* is the section changed? */
@y
boolean *changed_section; /* is the section changed? */
@z

@x
int get_line() /* inputs the next line */
@y
int get_line(void) /* inputs the next line */
@z

@x
      err_print("! Include file name not given");
@y
      err_print(get_string(MSG_ERROR_CO21_1));
@z

@x
      err_print("! Too many nested includes");
@y
      err_print(get_string(MSG_ERROR_CO21_2));
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
@z

@x
@d too_long() {include_depth--;
        err_print("! Include file name too long"); goto restart;}
@y
@d too_long() {include_depth--;
        err_print(get_string(MSG_ERROR_CO22)); goto restart;}
@z

@x
#include <stdlib.h> /* declaration of |getenv| and |exit| */
@y
#include <stddef.h> /* type definition of |ptrdiff_t| */
#include <signal.h> /* declaration of |signal| and |SIGINT| */
#include <stdlib.h> /* declaration of |getenv| and |exit| */
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
    if((cur_file = fopen(temp_file_name,"r"))!=NULL) {
      cur_line=0; print_where=1; goto restart; /* success */
    }
    if((next_path_prefix = strchr(path_prefix,PATH_SEPARATOR))!=NULL)
      path_prefix = next_path_prefix+1;
    else break; /* no more paths to search; no file found */
  }
@z

@x
  include_depth--; err_print("! Cannot open include file"); goto restart;
@y
  include_depth--; err_print(get_string(MSG_ERROR_CO23)); goto restart;
@z

@x
    err_print("! Change file ended without @@z");
@y
    err_print(get_string(MSG_ERROR_CO25_1));
@z

@x
        err_print("! Where is the matching @@z?");
@y
        err_print(get_string(MSG_ERROR_CO25_2));
@z

@x
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

@x
    err_print("! Change file entry did not match");
@y
    err_print(get_string(MSG_ERROR_CO26));
@z

@x
  char *byte_start; /* beginning of the name in |byte_mem| */
@y
  char HUGE *byte_start; /* beginning of the name in |byte_mem| */
@z

@x
typedef name_info *name_pointer; /* pointer into array of |name_info|s */
char byte_mem[max_bytes]; /* characters of names */
char *byte_mem_end = byte_mem+max_bytes-1; /* end of |byte_mem| */
name_info name_dir[max_names]; /* information about names */
name_pointer name_dir_end = name_dir+max_names-1; /* end of |name_dir| */
@y
typedef name_info HUGE *name_pointer; /* pointer into array of |name_info|s */
char HUGE *byte_mem; /* characters of names */
char HUGE *byte_mem_end; /* end of |byte_mem| */
name_pointer name_dir; /* information about names */
name_pointer name_dir_end; /* end of |name_dir| */
@z

@x
@d length(c) (c+1)->byte_start-(c)->byte_start /* the length of a name */
@y
@d length(c) (size_t)((c+1)->byte_start-(c)->byte_start) /* the length of a name */
@z

@x
char *byte_ptr; /* first unused position in |byte_mem| */
@y
char HUGE *byte_ptr; /* first unused position in |byte_mem| */
@z

@x
@ @<Init...@>=
name_dir->byte_start=byte_ptr=byte_mem; /* position zero in both arrays */
@y
@ @f type int /* \.{type} becomes the pseudotype \&{type} */
@#
@d alloc_object(object,size,@!type)
   if(!(object = (type *)malloc((size)*sizeof(type))))
      fatal("",get_string(MSG_FATAL_CO85))@;
@d free_object(object)
   if(object) free(object), object=NULL@;

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
@^system dependencies@>
byte_mem_end = byte_mem + max_bytes - 1;
name_dir_end = name_dir + max_names - 1;
name_dir->byte_start=byte_ptr=byte_mem; /* position zero in both arrays */
@z

@x
struct name_info *link;
@y
struct name_info HUGE *link;
@z

@x
name_pointer hash[hash_size]; /* heads of hash lists */
hash_pointer hash_end = hash+hash_size-1; /* end of |hash| */
@y
hash_pointer hash; /* heads of hash lists */
hash_pointer hash_end; /* end of |hash| */
@z

@x
extern int names_match();
@y
extern int names_match(name_pointer,char *,int,eight_bits);@/
@z

@x
for (h=hash; h<=hash_end; *h++=NULL) ;
@y
alloc_object(hash,hash_size,name_pointer);
hash_end = hash + hash_size - 1;
for (h=hash; h<=hash_end; *h++=NULL) ;
alloc_object(check_file_name,max_file_name_length,char);
alloc_object(C_file_name,max_file_name_length,char);
alloc_object(tex_file_name,max_file_name_length,char);
alloc_object(idx_file_name,max_file_name_length,char);
alloc_object(scn_file_name,max_file_name_length,char);
@z

@x
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

@x
  l=last-first; /* compute the length */
@y
  l=(int)(last-first); /* compute the length */
@z

@x
void init_p();
@y
extern void init_p(name_pointer,eight_bits);@/
@z

@x
  if (byte_ptr+l>byte_mem_end) overflow("byte memory");
  if (name_ptr>=name_dir_end) overflow("name");
@y
  if (byte_ptr+l>byte_mem_end) overflow(get_string(MSG_OVERFLOW_CO39_1));
  if (name_ptr>=name_dir_end) overflow(get_string(MSG_OVERFLOW_CO39_2));
@z

@x
  struct name_info *Rlink; /* right link in binary search tree for section
@y
  struct name_info HUGE *Rlink; /* right link in binary search tree for section
@z

@x
void
print_section_name(p)
name_pointer p;
@y
void print_section_name(name_pointer p)
@z

@x
  char *ss, *s = first_chunk(p);
@y
  char HUGE *ss;
  char HUGE *s = first_chunk(p);
@z

@x
      term_write(s,ss-s); p=q->link; q=p;
    } else {
      term_write(s,ss+1-s); p=name_dir; q=NULL;
@y
      term_write(s,(size_t)(ss-s)); p=q->link; q=p;
    } else {
      term_write(s,(size_t)(ss+1-s)); p=name_dir; q=NULL;
@z

@x
void
sprint_section_name(dest,p)
  char*dest;
  name_pointer p;
@y
void sprint_section_name(char *dest,name_pointer p)
@z

@x
  char *ss, *s = first_chunk(p);
@y
  char HUGE *ss;
  char HUGE *s = first_chunk(p);
@z

@x
    strncpy(dest,s,ss-s), dest+=ss-s;
@y
    strncpy(dest,s,(size_t)(ss-s)), dest+=ss-s;
@z

@x
void
print_prefix_name(p)
name_pointer p;
@y
void print_prefix_name(name_pointer p)
@z

@x
  char *s = first_chunk(p);
@y
  char HUGE *s = first_chunk(p);
@z

@x
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

@x
extern void init_node();
@y
extern void init_node(name_pointer);@/
@z

@x
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

@x
  char *s=first_chunk(p);
@y
  char HUGE *s=first_chunk(p);
@z

@x
  int name_len=last-first+ispref; /* length of section name */
@y
  int name_len=(int)(last-first)+ispref; /* length of section name */
@z

@x
  if (s+name_len>byte_mem_end) overflow("byte memory");
  if (name_ptr+1>=name_dir_end) overflow("name");
@y
  if (s+name_len>byte_mem_end) overflow(get_string(MSG_OVERFLOW_CO39_1));
  if (name_ptr+1>=name_dir_end) overflow(get_string(MSG_OVERFLOW_CO39_2));
@z

@x
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

@x
  char *s;
@y
  char HUGE *s;
@z

@x
  int name_len=last-first+ispref;
@y
  int name_len=(int)(last-first)+ispref;
@z

@x
  if (name_ptr>=name_dir_end) overflow("name");
@y
  if (name_ptr>=name_dir_end) overflow(get_string(MSG_OVERFLOW_CO39_2));
@z

@x
  if (s+name_len>byte_mem_end) overflow("byte memory");
@y
  if (s+name_len>byte_mem_end) overflow(get_string(MSG_OVERFLOW_CO39_1));
@z

@x
name_pointer
section_lookup(first,last,ispref) /* find or install section name in tree */
char *first, *last; /* first and last characters of new name */
int ispref; /* is the new name a prefix or a full name? */
@y
name_pointer section_lookup(@t\1\1@> /* find or install section name in tree */
  char *first,char *last, /* first and last characters of new name */
  int ispref@t\2\2@>) /* is the new name a prefix or a full name? */
@z

@x
  int name_len=last-first+1;
@y
  int name_len=(int)(last-first)+1;
@z

@x
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

@x
      printf("\n! New name is a prefix of <");
@y
      printf(get_string(MSG_ERROR_CO52_1));
@z

@x
      printf("\n! New name extends <");
@y
      printf(get_string(MSG_ERROR_CO52_2));
@z

@x
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

@x
int section_name_cmp();
@y
static int section_name_cmp(char **,int,name_pointer);@/
@z

@x
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

@x
  char *ss, *s=first_chunk(r);
@y
  char HUGE *ss;
  char HUGE *s=first_chunk(r);
@z

@x
          *pfirst=first+(ss-s);
@y
          *pfirst=first+(ptrdiff_t)(ss-s);
@z

@x
      if (q!=name_dir) {len -= ss-s; s=q->byte_start; r=q; continue;}
@y
      if (q!=name_dir) {len -= (int)(ss-s); s=q->byte_start; r=q; continue;}
@z

@x
|equiv_or_xref| as a pointer to a |char|.

@<More elements of |name...@>=
char *equiv_or_xref; /* info corresponding to names */
@y
|equiv_or_xref| as a pointer to |void|.

@<More elements of |name...@>=
void HUGE *equiv_or_xref; /* info corresponding to names */
@z

@x
void  err_print();
@y
extern void err_print(char *);@/
@z

@x
void
err_print(s) /* prints `\..' and location of error message */
char *s;
@y
void err_print(char *s) /* prints `\..' and location of error message */
@z

@x
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

#ifdef __SASC
@<Put the error message in the browser@>@;
#endif
@z

@x
int wrap_up();
extern void print_stats();
@y
extern int wrap_up(void);@/
extern void print_stats(void);@/
@z

@x
@ Some implementations may wish to pass the |history| value to the
operating system so that it can be used to govern whether or not other
programs are started. Here, for instance, we pass the operating system
a status of 0 if and only if only harmless messages were printed.
@^system dependencies@>
@y
@ On multi-tasking systems like the {\mc AMIGA} it is very convenient to
know a little bit more about the reasons why a program failed.  The four
levels of return indicated by the |history| value are very suitable for
this purpose.  Here, for instance, we pass the operating system a status
of~0 if and only if the run was a complete success.  Any warning or error
message will result in a higher return value, so {\mc AREXX} scripts can be
made sensitive to these conditions.

|__TURBOC__| has another shitty ``feature'' that has to be fixed.
|return|ing from several |case|s is not possible.  Either always the
first case is used, or the system is crashed completely.  Really funny.
@^system dependencies@>
@^system dependencies@>

@d RETURN_OK     0 /* No problems, success */
@d RETURN_WARN   5 /* A warning only */
@d RETURN_ERROR 10 /* Something wrong */
@d RETURN_FAIL  20 /* Complete or severe failure */
@z

@x
int wrap_up() {
@y
int wrap_up(void) {
@z

@x
  @<Print the job |history|@>;
@y
  @<Print the job |history|@>;
#ifdef _AMIGA
  @<Close the language catalog@>;
#endif
@z

@x
  if (history > harmless_message) return(1);
  else return(0);
@y
  @<Remove the temporary file if not already done@>@;
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

@x
void fatal(), overflow();
@y
extern void fatal(char *,char *);
extern void overflow(char *);
@z

@x
@c void
fatal(s,t)
  char *s,*t;
@y
@c void fatal(char *s,char *t)
@z

@x
@c void
overflow(t)
  char *t;
@y
@c void overflow(char *t)
@z

@x
  printf("\n! Sorry, %s capacity exceeded",t); fatal("","");
@y
  printf(get_string(MSG_FATAL_CO65),t); fatal("","");
@z

@x
@d confusion(s) fatal("! This can't happen: ",s)
@y
@d confusion(s) fatal(get_string(MSG_FATAL_CO66),s)
@z

@x
the names of those files. Most of the 128 flags are undefined but available
for future extensions.

@d show_banner flags['b'] /* should the banner line be printed? */
@d show_progress flags['p'] /* should progress reports be printed? */
@d show_stats flags['s'] /* should statistics be printed at end of run? */
@d show_happiness flags['h'] /* should lack of errors be announced? */
@y
the names of those files. Most of the 256 flags are undefined but available
for future extensions.

@d show_banner flags['b'] /* should the banner line be printed? */
@d show_progress flags['p'] /* should progress reports be printed? */
@d show_stats flags['s'] /* should statistics be printed at end of run? */
@d send_error_messages flags['m'] /* should {\mc AREXX} communication be used? */
@d show_happiness flags['h'] /* should lack of errors be announced? */
@d indent_param_decl flags['i'] /* should formal parameter declarations be indented? */
@d order_decl_stmt flags['o'] /* should declarations and statements be separated? */
@z

@x
char C_file_name[max_file_name_length]; /* name of |C_file| */
char tex_file_name[max_file_name_length]; /* name of |tex_file| */
char idx_file_name[max_file_name_length]; /* name of |idx_file| */
char scn_file_name[max_file_name_length]; /* name of |scn_file| */
@y
char *C_file_name; /* name of |C_file| */
char *tex_file_name; /* name of |tex_file| */
char *idx_file_name; /* name of |idx_file| */
char *scn_file_name; /* name of |scn_file| */
char *check_file_name; /* name of |check_file| */
char *use_language; /* prefix of \.{cwebmac.tex} in \TEX/ output */
@z

@x
boolean flags[128]; /* an option for each 7-bit code */
@y
boolean flags[256]; /* an option for each 8-bit code */
@z

@x
@<Set the default options common to \.{CTANGLE} and \.{CWEAVE}@>=
show_banner=show_happiness=show_progress=1;
@y
@<Set the default options common to \.{CTANGLE} and \.{CWEAVE}@>=
show_banner=show_happiness=show_progress=indent_param_decl=order_decl_stmt=1;
use_language="";
@z

@x
An omitted change file argument means that |"/dev/null"| should be used,
when no changes are desired.
@y
An omitted change file argument means that |"/dev/null"| or---on non-\UNIX/
systems the contents of the compile-time variable |_DEV_NULL|---should be
used, when no changes are desired.
@z

@x
void scan_args();
@y
static void scan_args(void);@/
@z

@x
void
scan_args()
@y
static void scan_args(void)
@z

@x
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

@x
  if (found_change<=0) strcpy(change_file_name,"/dev/null");
@y
#ifdef _DEV_NULL
  if (found_change<=0) strcpy(change_file_name,_DEV_NULL);
#else
  if (found_change<=0) strcpy(change_file_name,"/dev/null");
#endif
@^system dependencies@>
@z

@x
        fatal("! Output file name should end with .tex\n",*argv);
@y
        fatal(get_string(MSG_FATAL_CO73),*argv);
@z

@x
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
@z

@x
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
#ifdef __SASC
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
@z

@x
@ @<Complain about arg...@>= fatal("! Filename too long\n", *argv);
@y
@ @<Complain about arg...@>= fatal(get_string(MSG_FATAL_CO76), *argv);
@z

@x
FILE *scn_file; /* where list of sections from \.{CWEAVE} goes */
@y
FILE *scn_file; /* where list of sections from \.{CWEAVE} goes */
FILE *check_file; /* temporary output file */
@z

@x
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
if (program==ctangle) {
  strcpy(check_file_name,C_file_name);
  if(check_file_name[0]!='\0') {
    char *dot_pos=strrchr(check_file_name,'.');
    if(dot_pos==NULL) strcat(check_file_name,".ttp");
    else strcpy(dot_pos,".ttp");
    }
  if ((C_file=fopen(check_file_name,"w"))==NULL)
    fatal(get_string(MSG_FATAL_CO78), check_file_name);
@.Cannot open output file@>
}
else {
  strcpy(check_file_name,tex_file_name);
  if(check_file_name[0]!='\0') {
    char *dot_pos=strrchr(check_file_name,'.');
    if(dot_pos==NULL) strcat(check_file_name,".wtp");
    else strcpy(dot_pos,".wtp");
    }
  if ((tex_file=fopen(check_file_name,"w"))==NULL)
    fatal(get_string(MSG_FATAL_CO78), check_file_name);
}
@z

@x
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

@<Include...@>=
#include <string.h>

@** Function declarations. Here are declarations, conforming to {\mc
ANSI~C}, of all functions in this code that appear in |"common.h"| and
thus should agree with \.{CTANGLE} and \.{CWEAVE}.

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
@z

@x
@** Index.
@y
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

@<Other...@>=
char *include_path;@/
char *p, *path_prefix, *next_path_prefix;

@ @<Init...@>=
alloc_object(include_path,max_path_length+2,char);
strcpy(include_path,"");

@** Memory allocation.  The idea of dynamic memory allocation is extended
to all internal arrays (except the |flags| field).  Especially on the {\mc
AMIGA} this is very useful, because the programs can be compiled in the
\.{NEAR} data segment and thus can be made \\{resident}.

In case of an user break we must take care of the dynamically allocated
memory and opened resources like system libraries and catalog files.
There is no warranty that in such cases the exit code automatically
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
#ifdef __SASC
#include <proto/dos.h>
#include <proto/rexxsyslib.h>
#endif

@ A list of declarations and variables is added.  Most of these are
globally defined because the initialization of the message port is done
outside these local routines.
@^system dependencies@>

@<Other...@>=
#ifdef __SASC
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
#ifdef __SASC
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
#ifdef __SASC
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
#ifdef __SASC
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
#ifdef __SASC
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
#ifdef __SASC
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
#ifdef __SASC
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

@** Temporary file output.  Before we leave the program we have to make
sure that the output files are correctly written.

@<Remove the temporary file...@>=
  if(C_file) fclose(C_file);
  if(tex_file) fclose(tex_file);
  if(check_file) fclose(check_file);
  if(check_file_name) /* Delete the temporary file in case of a break */
    remove(check_file_name);

@** DOS sucks.  Due to restrictions of most {\mc MS-DOS}-\CEE/ compilers,
large arrays will be allocated dynamically rather than statically.  In the
{\mc TURBO}-\CEE/ implementation the |farcalloc| function provides a way to
allocate more than 64~KByte of data. The |allocsafe| function tries to carry
out an allocation of |nunits| blocks of size |unitsz| by calling |farcalloc|
and takes a safe method, when this fails: the program will be aborted.

To deal with such allocated data areas |huge| pointers will be used in this
implementation.  Care has been taken that no conflicts arise on other systems
when these changes are applied.

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

@** Index.
@z
