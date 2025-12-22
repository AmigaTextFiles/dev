@x l.64
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

----------------------------------------------------------------------------
l.281 Changes to common.h

@x l.102
extern name_pointer id_lookup(); /* looks up a string in the identifier table */
extern name_pointer section_lookup(); /* finds section name */
extern void print_section_name(), sprint_section_name();
@y
extern name_pointer id_lookup(char *,char *,char);
  /* looks up a string in the identifier table */
extern name_pointer section_lookup(char *,char *,int);
  /* finds section name */
extern void print_section_name(name_pointer);
extern void sprint_section_name(char *,name_pointer);
@z

@x l.117
extern err_print(); /* print error message and context */
extern wrap_up(); /* indicate |history| and exit */
extern void fatal(); /* issue error message and die */
extern void overflow(); /* succumb because a table has overflowed */
@y
extern void err_print(char *);
  /* print error message and context */
extern int wrap_up(void);
  /* indicate |history| and exit */
extern void fatal(char *,char *);
  /* issue error message and die */
extern void overflow(char *);
  /* succumb because a table has overflowed */
@z

@x l.146
extern reset_input(); /* initialize to read the web file and change file */
extern get_line(); /* inputs the next line */
extern check_complete(); /* checks that all changes were picked up */
@y
extern void reset_input(void);
  /* initialize to read the web file and change file */
extern get_line(void);
  /* inputs the next line */
extern void check_complete(void);
  /* checks that all changes were picked up */
@z

@x l.185
extern void common_init();
@y
extern void common_init(void);
@z
----------------------------------------------------------------------------

@x l.436
  return p-title_code;
@y
  return((sixteen_bits)(p-title_code));
@z

@x l.831
void   skip_limbo();
@y
void skip_limbo(void);
@z

@x l.928
eight_bits get_next();
@y
eight_bits get_next(void);
@z

@x l.1070
    *id_loc++='$'; *id_loc++=toupper(*loc++);
@y
    *id_loc++='$'; *id_loc++=toupper(*loc); loc++;
@z

@x l.1209
void skip_restricted();
@y
void skip_restricted(void);
@z

@x l.1314
void phase_one();
@y
void phase_one(void);
@z

@x l.1361
void C_xref();
@y
void C_xref(eight_bits);
@z

@x l.1389
void outer_xref();
@y
void outer_xref(void);
@z

@x l.1551
void section_check();
@y
void section_check(name_pointer);
@z

@x l.1684
  while (*s) out(*s++);
@y
  while (*s) { out(*s); *s++; }
@z

@x l.1699
void break_out();
@y
void break_out(void);
@z

@x l.1782
    while (*loc!='@@') out(*(loc++));
@y
    while (*loc!='@@') { out(*loc); *(loc++); }
@z

@x l.1840
int copy_comment();
@y
int copy_comment(boolean,int);
@z

@x l.2727
void  underline_xref();
@y
void  underline_xref(name_pointer);
@z

@x l.3211
@ @<Cases for |lproc|@>=
if (cat1==define_like) { /* \.{\#define} is analogous to \&{extern} */
  make_underlined(pp+2);
  if (tok_loc!=no_ident_found) {
    struct perm_meaning *q=((*tok_loc)%id_flag)+cur_meaning;
  }
@y
@ @<Cases for |lproc|@>=
if (cat1==define_like) { /* \.{\#define} is analogous to \&{extern} */
  make_underlined(pp+2);
#ifdef DEAD_CODE
  if (tok_loc!=no_ident_found) {
    struct perm_meaning *q=((*tok_loc)%id_flag)+cur_meaning;
  }
#endif
@z

@x l.3759
void app_cur_id();
@y
void app_cur_id(boolean);
@z

@x l.3971
  return(a);
@y
  return((eight_bits)a);
@z

@x l.4016
void make_output();
@y
void make_output(void);
@z

@x l.4056
      case quoted_char: out(*(cur_tok++)); break;
@y
      case quoted_char: out(*cur_tok); cur_tok++; break;
@z

@x l.4274
void phase_two();
@y
void phase_two(void);
@z

@x l.4452
void finish_C();
@y
void finish_C(boolean);
@z

@x l.4644
void footnote();
@y
void footnote(sixteen_bits);
@z

@x l.4720
void   out_mini();
@y
void out_mini(meaning_struct *);
@z

@x l.4781
void phase_three();
@y
void phase_three(void);
@z

@x l.4929
void  unbucket();
@y
void  unbucket(eight_bits);
@z

@x l.5051
void section_print();
@y
void section_print(name_pointer);
@z

@x l.5105
@** Index.
@y
@ Missing prototypes.

@<Pre...@>=
sixteen_bits title_lookup(void);
void new_meaning(name_pointer);
void new_xref(name_pointer);
void new_section_xref(name_pointer);
void set_file_flag(name_pointer);
int names_match(name_pointer,char *,int,eight_bits);
void init_p(name_pointer,eight_bits);
void init_node(name_pointer);
unsigned int skip_TeX(void);
void flush_buffer(char *,boolean,boolean);
void finish_line(void);
void out_str(char *);
void out_section(sixteen_bits);
void out_name(name_pointer);
void copy_limbo(void);
eight_bits copy_TeX(void);
void print_cat(eight_bits);
void print_text(text_pointer);
void pr_txt(int);
void app_str(char *);
void big_app(token);
void big_app1(scrap_pointer);
token_pointer find_first_ident(text_pointer);
void make_reserved(scrap_pointer);
void make_underlined(scrap_pointer);
boolean app_supp(text_pointer);
void make_ministring(int);
void reduce(scrap_pointer,short,eight_bits,short,short);
void squash(scrap_pointer,short,eight_bits,short,short);
text_pointer translate(void);
void C_parse(eight_bits);
text_pointer C_translate(void);
void outer_parse(void);
void push_level(text_pointer);
void pop_level(void);
eight_bits get_output(void);
void output_C(void);
void print_stats(void);

@** Index.
@z
