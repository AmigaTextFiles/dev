@x l.589
typedef name_info *name_pointer; /* pointer into array of |name_info|s */
@y
typedef name_info *name_pointer; /* pointer into array of |name_info|s */
typedef char unsigned eight_bits;
@z

@x l.641
extern int names_match();
@y
extern int names_match(name_pointer,char *,int,eight_bits);
@z

@x l.694
void init_p();
@y
extern void init_p(name_pointer,eight_bits);
@z

@x l.843
extern void init_node();
@y
extern void init_node(name_pointer);
@z

@x l.1008
int section_name_cmp();
@y
int section_name_cmp(char **,int,name_pointer);
@z

@x l.1083
void  err_print();
@y
void  err_print(char *);
@z

@x l.1131
int wrap_up();
extern void print_stats();
@y
int wrap_up(void);
extern void print_stats(void);
@z

@x l.1164
void fatal(), overflow();
@y
void fatal(char *,char *);
void overflow(char *);
@z

@x l.1235
An omitted change file argument means that |"/dev/null"| should be used,
@y
An omitted change file argument means that |"/dev/null"| --- or on Amiga
systems |"NIL:"| should be used,
@z

@x l.1242
void scan_args();
@y
void scan_args(void);
@z

@x l.1272
  if (found_change<=0) strcpy(change_file_name,"/dev/null");
@y
#ifdef _AMIGA
  if (found_change<=0) strcpy(change_file_name,"NIL:");
#else
  if (found_change<=0) strcpy(change_file_name,"/dev/null");
#endif
@z

@x l.1346
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
  fatal("! Usage: "@|
    "ctwill [options] webfile[.w] [{changefile[.ch]|-} [outfile[.tex]]]\n"@|
    "Options are (+ turns on, - turns off, default in brackets):\n"@|
    "b [+] print banner line\n"@|
    "f [+] force line breaks\n"@|
    "h [+] print happy message\n"@|
    "p [+] give progress reports\n"@|
    "s [-] show statistics\n"@|
    "P [-] use proofmac.tex\n","");
@.Usage:@>
}
@z

@x l.1400
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

@<Predecl...@>=
#include <string.h>
@z

@x l.1412
@** Index.
@y

@ Missing prototypes.

@<Predecl...@>=
void common_init(void);
int input_ln(FILE*);
void prime_the_change_buffer(void);
void check_change(void);
void reset_input(void);
int get_line(void);
void check_complete(void);
name_pointer id_lookup(char *,char*,char);
void print_section_name(name_pointer);
void sprint_section_name(char *,name_pointer);
void print_prefix_name(name_pointer);
int web_strcmp(char *,int,char *,int);
name_pointer add_section_name(name_pointer,int,char *,char *,int);
void extend_section_name(name_pointer,char *,char *,int);
name_pointer section_lookup(char *,char *,int);

@** Index.
@z
