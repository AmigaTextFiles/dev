@x
\def\title{CTANGLE (Version 3.4)}
@y
\def\title{CTANGLE (Version 3.4 [p13])}
@z

@x
  \centerline{(Version 3.4)}
@y
  \centerline{(Version 3.4 [p13])}
@z

@x
@d banner "This is CTANGLE (Version 3.4)\n"
@y
@d banner get_string(MSG_BANNER_CT1)
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

@<Include files@>=
#include <string.h>
@z

@x
int main (ac, av)
int ac;
char **av;
@y
int main (int ac, char **av)
@z

@x
  @<Set initial values@>;
  common_init();
@y
  common_init();
  @<Set initial values@>;
@z

@x
@i common.h
@y
@i comm-p13.h
@z

@x
  eight_bits *tok_start; /* pointer into |tok_mem| */
@y
  eight_bits HUGE *tok_start; /* pointer into |tok_mem| */
@z

@x
text text_info[max_texts];
text_pointer text_info_end=text_info+max_texts-1;
@y
text_pointer text_info;
text_pointer text_info_end;
@z

@x
eight_bits tok_mem[max_toks];
eight_bits *tok_mem_end=tok_mem+max_toks-1;
eight_bits *tok_ptr; /* first unused position in |tok_mem| */
@y
eight_bits HUGE *tok_mem;
eight_bits HUGE *tok_mem_end;
eight_bits HUGE *tok_ptr; /* first unused position in |tok_mem| */
@z

@x
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
@z

@x
name_dir->equiv=(char *)text_info; /* the undefined section has no replacement text */
@y
name_dir->equiv=(void HUGE *)text_info; /* the undefined section has no replacement text */
@z

@x
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

@x
void
init_node(node)
name_pointer node;
@y
void init_node(name_pointer node)
@z

@x
    node->equiv=(char *)text_info;
@y
    node->equiv=(void HUGE *)text_info;
@z

@x
void
init_p() {}
@y
void init_p(name_pointer dummy1,eight_bits dummy2)
{}
@z

@x
void
store_two_bytes(x)
sixteen_bits x;
@y
static void store_two_bytes(sixteen_bits x)
@z

@x
  if (tok_ptr+2>tok_mem_end) overflow("token");
@y
  if (tok_ptr+2>tok_mem_end) overflow(get_string(MSG_OVERFLOW_CT26));
@z

@x
  eight_bits *end_field; /* ending location of replacement text */
  eight_bits *byte_field; /* present location within replacement text */
@y
  eight_bits HUGE *end_field; /* ending location of replacement text */
  eight_bits HUGE *byte_field; /* present location within replacement text */
@z

@x
output_state stack[stack_size+1]; /* info for non-current levels */
stack_pointer stack_ptr; /* first unused location in the output state stack */
stack_pointer stack_end=stack+stack_size; /* end of |stack| */
@y
stack_pointer stack; /* info for non-current levels */
stack_pointer stack_end; /* end of |stack| */
stack_pointer stack_ptr; /* first unused location in the output state stack */
@z

@x
void
push_level(p) /* suspends the current level */
name_pointer p;
@y
static void push_level(name_pointer p) /* suspends the current level */
@z

@x
  if (stack_ptr==stack_end) overflow("stack");
@y
  if (stack_ptr==stack_end) overflow(get_string(MSG_OVERFLOW_CT30));
@z

@x
void
pop_level(flag) /* do this when |cur_byte| reaches |cur_end| */
int flag; /* |flag==0| means we are in |output_defs| */
@y
static void pop_level(int flag) /* do this when |cur_byte| reaches |cur_end| */
@z

@x
void
get_output() /* sends next token to |out_char| */
@y
static void get_output(void) /* sends next token to |out_char| */
@z

@x
  if ((a+name_dir)->equiv!=(char *)text_info) push_level(a+name_dir);
@y
  if ((a+name_dir)->equiv!=(void HUGE *)text_info) push_level(a+name_dir);
@z

@x
    printf("\n! Not present: <");
@y
    printf(get_string(MSG_ERROR_CT34));
@z

@x
void
flush_buffer() /* writes one line to output file */
@y
static void flush_buffer(void) /* writes one line to output file */
@z

@x
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

@x
      overflow("output files");
@y
      overflow(get_string(MSG_OVERFLOW_CT40));
@z

@x
void phase_two();
@y
static void phase_two(void);
@z

@x
void
phase_two () {
@y
static void phase_two (void) {
@z

@x
    printf("\n! No program text was specified."); mark_harmless;
@y
    printf(get_string(MSG_WARNING_CT42)); mark_harmless;
@z

@x
        printf("\nWriting the output file (%s):",C_file_name);
@y
        printf(get_string(MSG_PROGRESS_CT42_1),C_file_name);
@z

@x
        printf("\nWriting the output files:");
@y
        printf(get_string(MSG_PROGRESS_CT42_2));
@z

@x
    if(show_happiness) printf("\nDone.");
@y
    if(show_happiness) printf(get_string(MSG_PROGRESS_CT42_3));
@z

@x
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
    if((C_file=fopen(check_file_name,"w"))==NULL)
      fatal(get_string(MSG_FATAL_CO78),check_file_name);
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

@x
void output_defs();
@y
static void output_defs(void);
@z

@x
void
output_defs()
@y
static void output_defs(void)
@z

@x
          else if (a<050000) { confusion("macro defs have strange char");}
@y
          else if (a<050000) { confusion(get_string(MSG_CONFUSION_CT47));}
@z

@x
static void out_char();
@y
static void out_char(eight_bits);
@z

@x
static void
out_char(cur_char)
eight_bits cur_char;
@y
static void out_char(eight_bits cur_char)
@z

@x
  char *j, *k; /* pointer into |byte_mem| */
@y
  char HUGE *j;
  char HUGE *k; /* pointer into |byte_mem| */
@z

@x
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

@x
eight_bits ccode[256]; /* meaning of a char following \.{@@} */

@ @<Set ini...@>= {
  int c; /* must be |int| so the |for| loop will end */
@y
eight_bits *ccode; /* meaning of a char following \.{@@} */

@ @<Set ini...@>= {
  int c; /* must be |int| so the |for| loop will end */
  alloc_object(ccode,256,eight_bits);
@z

@x
eight_bits
skip_ahead() /* skip to next control code */
@y
static eight_bits skip_ahead(void) /* skip to next control code */
@z

@x
int skip_comment(is_long_comment) /* skips over comments */
boolean is_long_comment;
@y
static int skip_comment(boolean is_long_comment) /* skips over comments */
@z

@x
          err_print("! Input ended in mid-comment");
@y
          err_print(get_string(MSG_ERROR_CT60_1));
@z

@x
        err_print("! Section name ended in mid-comment"); loc--;
@y
        err_print(get_string(MSG_ERROR_CT60_2)); loc--;
@z

@x
eight_bits
get_next() /* produces the next input token */
@y
static eight_bits get_next(void) /* produces the next input token */
@z

@x
        err_print("! String didn't end"); loc=limit; break;
@y
        err_print(get_string(MSG_ERROR_CT67_1)); loc=limit; break;
@z

@x
        err_print("! Input ended in middle of string"); loc=buffer; break;
@y
        err_print(get_string(MSG_ERROR_CT67_2)); loc=buffer; break;
@z

@x
    printf("\n! String too long: ");
@y
    printf(get_string(MSG_ERROR_CT67_3));
@z

@x
    case translit_code: err_print("! Use @@l in limbo only"); continue;
@y
    case translit_code: err_print(get_string(MSG_ERROR_CT68_1)); continue;
@z

@x
        err_print("! Double @@ should be used in control text");
@y
        err_print(get_string(MSG_ERROR_CT68_2));
@z

@x
        err_print("! Double @@ should be used in ASCII constant");
@y
        err_print(get_string(MSG_ERROR_CT69));
@z

@x
        err_print("! String didn't end"); loc=limit-1; break;
@y
        err_print(get_string(MSG_ERROR_CT67_1)); loc=limit-1; break;
@z

@x
    err_print("! Input ended in section name");
@y
    err_print(get_string(MSG_ERROR_CT72_1));
@z

@x
  printf("\n! Section name too long: ");
@y
  printf(get_string(MSG_ERROR_CT72_2));
@z

@x
    err_print("! Section name didn't end"); break;
@y
    err_print(get_string(MSG_ERROR_CT73_1)); break;
@z

@x
    err_print("! Nesting of section names not allowed"); break;
@y
    err_print(get_string(MSG_ERROR_CT73_2)); break;
@z

@x
  if (loc>=limit) err_print("! Verbatim string didn't end");
@y
  if (loc>=limit) err_print(get_string(MSG_ERROR_CT74));
@z

@x
@d app_repl(c)  {if (tok_ptr==tok_mem_end) overflow("token"); *tok_ptr++=c;}
@y
@d app_repl(c)
  {if (tok_ptr==tok_mem_end) overflow(get_string(MSG_OVERFLOW_CT26));
   *tok_ptr++=c;}
@z

@x
void
scan_repl(t) /* creates a replacement text */
eight_bits t;
@y
static void scan_repl(eight_bits t) /* creates a replacement text */
@z

@x
  if (text_ptr>text_info_end) overflow("text");
@y
  if (text_ptr>text_info_end) overflow(get_string(MSG_OVERFLOW_CT76));
@z

@x
    err_print("! @@d, @@f and @@c are ignored in C text"); continue;
@y
    err_print(get_string(MSG_ERROR_CT78)); continue;
@z

@x
  if (*try_loc=='=') err_print ("! Missing `@@ ' before a named section");
@y
  if (*try_loc=='=') err_print (get_string(MSG_ERROR_CT79));
@z

@x
      else err_print("! Double @@ should be used in string");
@y
      else err_print(get_string(MSG_ERROR_CT80));
@z

@x
    default: err_print("! Unrecognized escape sequence");
@y
    default: err_print(get_string(MSG_ERROR_CT81));
@z

@x
void
scan_section()
@y
static void scan_section(void)
@z

@x
    err_print("! Definition flushed, must start with identifier");
@y
    err_print(get_string(MSG_ERROR_CT85));
@z

@x
else if (p->equiv==(char *)text_info) p->equiv=(char *)cur_text;
@y
else if (p->equiv==(void HUGE *)text_info) p->equiv=(void HUGE *)cur_text;
@z

@x
void phase_one();
@y
static void phase_one(void);
@z

@x
void
phase_one() {
@y
static void phase_one(void) {
@z

@x
void skip_limbo();
@y
static void skip_limbo(void);
@z

@x
void
skip_limbo()
@y
static void skip_limbo(void)
@z

@x
            err_print("! Double @@ should be used in control text");
@y
            err_print(get_string(MSG_ERROR_CT68_2));
@z

@x
        default: err_print("! Double @@ should be used in limbo");
@y
        default: err_print(get_string(MSG_ERROR_CT93));
@z

@x
    err_print("! Improper hex number following @@l");
@y
    err_print(get_string(MSG_ERROR_CT94_1));
@z

@x
      err_print("! Replacement string in @@l too long");
@y
      err_print(get_string(MSG_ERROR_CT94_2));
@z

@x
      strncpy(translit[i-0200],beg,loc-beg);
@y
      strncpy(translit[i-0200],beg,(size_t)(loc-beg));
@z

@x
@ Because on some systems the difference between two pointers is a |long|
but not an |int|, we use \.{\%ld} to print these quantities.

@c
void
print_stats() {
@y
@ {\mc ANSI C} declares the difference between two pointers to be of type
|ptrdiff_t| which equals |long| on (almost) all systems instead of |int|,
so we use \.{\%ld} to print these quantities and cast them to |long|
explicitly.

@c
void print_stats(void) {
@z

@x
  printf("\nMemory usage statistics:\n");
  printf("%ld names (out of %ld)\n",
          (long)(name_ptr-name_dir),(long)max_names);
  printf("%ld replacement texts (out of %ld)\n",
          (long)(text_ptr-text_info),(long)max_texts);
  printf("%ld bytes (out of %ld)\n",
          (long)(byte_ptr-byte_mem),(long)max_bytes);
  printf("%ld tokens (out of %ld)\n",
          (long)(tok_ptr-tok_mem),(long)max_toks);
@y
  printf(get_string(MSG_STATS_CT95_1));
  printf(get_string(MSG_STATS_CT95_2),
          (long)(name_ptr-name_dir),(long)max_names);
  printf(get_string(MSG_STATS_CT95_3),
          (long)(text_ptr-text_info),(long)max_texts);
  printf(get_string(MSG_STATS_CT95_4),
          (long)(byte_ptr-byte_mem),(long)max_bytes);
  printf(get_string(MSG_STATS_CT95_5),
          (long)(tok_ptr-tok_mem),(long)max_toks);
@z

@x
@** Index.
@y
@** Version information.  The {\mc AMIGA} operating system provides the
`version' command and good programs answer with some informations about
their creation date and their current version.  This might be useful for
other operating systems as well.

@<Glob...@>=
const char Version[] = "$VER: CTangle 3.4 [p13] ("__DATE__", "__TIME__")\n";

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

@** Output file update.  Most \CEE/ projects are controlled by a
\.{makefile} which automatically takes care of the temporal dependecies
between the different source modules.  It is suitable that \.{CWEB} doesn't
create new output for all existing files, when there are only changes to
some of them. Thus the \.{make} process will only recompile those modules
where necessary. The idea and basic implementation of this mechanism can
be found in the program \.{NUWEB} by Preston Briggs, to whom credit is due.

@<Update the primary result...@>=
if((C_file=fopen(C_file_name,"r"))!=NULL) {
  char *x,*y;
  int x_size,y_size,comparison;

  if((check_file=fopen(check_file_name,"r"))==NULL)
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
  comparison = (x_size == y_size); /* Do not merge these statements! */
  if(comparison) comparison = !memcmp(x,y,x_size);
  } while(comparison && !feof(C_file) && !feof(check_file));

@ Note the superfluous call to |remove| before |rename|.  We're using it to
get around a bug in some implementations of |rename|.

@<Create the primary output...@>=
if(comparison)
  remove(check_file_name); /* The output remains untouched */
else {
  remove(C_file_name);
  rename(check_file_name,C_file_name);
  }

@ @<Update the secondary results...@>=
if((C_file=fopen(output_file_name,"r"))!=NULL) {
  char *x,*y;
  int x_size,y_size,comparison;

  if((check_file=fopen(check_file_name,"r"))==NULL)
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
  if(comparison)
    remove(check_file_name); /* The output remains untouched */
else {
    remove(output_file_name);
    rename(check_file_name,output_file_name);
    }

@** Index.
@z

