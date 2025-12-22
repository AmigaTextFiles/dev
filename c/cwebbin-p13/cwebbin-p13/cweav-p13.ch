@x
\def\title{CWEAVE (Version 3.4)}
@y
\def\title{CWEAVE (Version 3.4 [p13])}
@z

@x
  \centerline{(Version 3.4)}
@y
  \centerline{(Version 3.4 [p13])}
@z

@x
@d banner "This is CWEAVE (Version 3.4)\n"
@y
@d banner get_string(MSG_BANNER_CW1)
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
int ac; /* argument count */
char **av; /* argument values */
@y
int main (int ac, char **av)
/* argument count and argument values */
@z

@x
@i common.h
@y
@i comm-p13.h
@z

@x
typedef struct xref_info {
  sixteen_bits num; /* section number plus zero or |def_flag| */
  struct xref_info *xlink; /* pointer to the previous cross-reference */
} xref_info;
typedef xref_info *xref_pointer;
@y
typedef struct xref_info {
  sixteen_bits num; /* section number plus zero or |def_flag| */
  struct xref_info HUGE *xlink; /* pointer to the previous cross-reference */
} xref_info;
typedef xref_info HUGE *xref_pointer;
@z

@x
xref_info xmem[max_refs]; /* contains cross-reference information */
xref_pointer xmem_end = xmem+max_refs-1;
@y
xref_pointer xmem; /* contains cross-reference information */
xref_pointer xmem_end;
@z

@x
xref_ptr=xmem; name_dir->xref=(char*)xmem; xref_switch=0; section_xref_switch=0;
@y
alloc_object(section_text,longest_name+1,char);
section_text_end = section_text + longest_name;
#ifdef __TURBOC__
xmem=(xref_pointer)allocsafe(max_refs,sizeof(*xmem));
#else
alloc_object(xmem,max_refs,xref_info);
#endif
xmem_end = xmem + max_refs - 1;
xref_ptr=xmem; name_dir->xref=(void HUGE*)xmem;
xref_switch=0; section_xref_switch=0;
@z

@x
@d append_xref(c) if (xref_ptr==xmem_end) overflow("cross-reference");
@y
@d append_xref(c) if (xref_ptr==xmem_end) overflow(get_string(MSG_OVERFLOW_CW21));
@z

@x
void
new_xref(p)
name_pointer p;
@y
static void new_xref(name_pointer p)
@z

@x
  append_xref(m); xref_ptr->xlink=q; p->xref=(char*)xref_ptr;
@y
  append_xref(m); xref_ptr->xlink=q; p->xref=(void HUGE*)xref_ptr;
@z

@x
void
new_section_xref(p)
name_pointer p;
@y
static void new_section_xref(name_pointer p)
@z

@x
  if (r==xmem) p->xref=(char*)xref_ptr;
@y
  if (r==xmem) p->xref=(void HUGE*)xref_ptr;
@z

@x
void
set_file_flag(p)
name_pointer p;
@y
static void set_file_flag(name_pointer p)
@z

@x
  p->xref = (char *)xref_ptr;
@y
  p->xref = (void HUGE*)xref_ptr;
@z

@x
typedef token *token_pointer;
typedef token_pointer *text_pointer;
@y
typedef token HUGE *token_pointer;
typedef token_pointer HUGE *text_pointer;
@z

@x
token tok_mem[max_toks]; /* tokens */
token_pointer tok_mem_end = tok_mem+max_toks-1; /* end of |tok_mem| */
token_pointer tok_start[max_texts]; /* directory into |tok_mem| */
token_pointer tok_ptr; /* first unused position in |tok_mem| */
text_pointer text_ptr; /* first unused position in |tok_start| */
text_pointer tok_start_end = tok_start+max_texts-1; /* end of |tok_start| */
@y
token_pointer tok_mem; /* tokens */
token_pointer tok_mem_end; /* end of |tok_mem| */
token_pointer tok_ptr; /* first unused position in |tok_mem| */
text_pointer tok_start; /* directory into |tok_mem| */
text_pointer tok_start_end; /* end of |tok_start| */
text_pointer text_ptr; /* first unused position in |tok_start| */
@z

@x
tok_ptr=tok_mem+1; text_ptr=tok_start+1; tok_start[0]=tok_mem+1;
@y
#ifdef __TURBOC__
tok_mem=(token_pointer)allocsafe(max_toks,sizeof(*tok_mem));
#else
alloc_object(tok_mem,max_toks,token);
#endif
@^system dependencies@>
tok_mem_end = tok_mem + max_toks - 1;
alloc_object(tok_start,max_texts,token_pointer);
tok_start_end = tok_start + max_texts - 1;
tok_ptr=tok_mem+1; text_ptr=tok_start+1; tok_start[0]=tok_mem+1;
@z

@x
int names_match(p,first,l,t)
name_pointer p; /* points to the proposed match */
char *first; /* position of first character of string */
int l; /* length of identifier */
eight_bits t; /* desired ilk */
@y
int names_match(@t\1\1@>
  name_pointer p, /* points to the proposed match */
  char *first, /* position of first character of string */
  int l, /* length of identifier */
  eight_bits t@t\2\2@>) /* desired |ilk| */
@z

@x
void
init_p(p,t)
name_pointer p;
eight_bits t;
@y
void init_p(name_pointer p,eight_bits t)
@z

@x
  p->ilk=t; p->xref=(char*)xmem;
@y
  p->ilk=t; p->xref=(void HUGE*)xmem;
@z

@x
void
init_node(p)
name_pointer p;
@y
void init_node(name_pointer p)
@z

@x
  p->xref=(char*)xmem;
@y
  p->xref=(void HUGE*)xmem;
@z

@x
eight_bits ccode[256]; /* meaning of a char following \.{@@} */

@ @<Set ini...@>=
{int c; for (c=0; c<256; c++) ccode[c]=0;}
@y
eight_bits *ccode; /* meaning of a char following \.{@@} */

@ @<Set ini...@>=
{int c;
alloc_object(ccode,256,eight_bits);
for (c=0; c<256; c++) ccode[c]=0;}
@z

@x
void   skip_limbo();
@y
static void skip_limbo(void);
@z

@x
void
skip_limbo() {
@y
static void skip_limbo(void) {
@z

@x
unsigned
skip_TeX() /* skip past pure \TEX/ code */
@y
static unsigned skip_TeX(void) /* skip past pure \TEX/ code */
@z

@x
#include <stdlib.h> /* definition of |exit| */
@y
#include <stddef.h> /* type definition of |ptrdiff_t| */
#include <stdlib.h> /* definition of |exit| */
@z

@x
eight_bits get_next();
@y
static eight_bits get_next(void);
@z

@x
eight_bits
get_next() /* produces the next input token */
{@+eight_bits c; /* the current character */
@y
static eight_bits get_next(void) /* produces the next input token */
{
  eight_bits c; /* the current character */
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
    err_print("! Control codes are forbidden in section name"); break;
@y
    err_print(get_string(MSG_ERROR_CW54)); break;
@z

@x
void skip_restricted();
@y
void skip_restricted(void);
@z

@x
void
skip_restricted()
@y
void skip_restricted(void)
@z

@x
    err_print("! Control text didn't end"); loc=limit;
@y
    err_print(get_string(MSG_ERROR_CW56_1)); loc=limit;
@z

@x
      err_print("! Control codes are forbidden in control text");
@y
      err_print(get_string(MSG_ERROR_CW56_2));
@z

@x
  if (loc>=limit) err_print("! Verbatim string didn't end");
@y
  if (loc>=limit) err_print(get_string(MSG_ERROR_CT74));
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
  if (++section_count==max_sections) overflow("section number");
@y
  if (++section_count==max_sections) overflow(get_string(MSG_OVERFLOW_CW61));
@z

@x
void C_xref();
@y
static void C_xref(eight_bits);
@z

@x
void
C_xref( spec_ctrl ) /* makes cross-references for \CEE/ identifiers */
  eight_bits spec_ctrl;
@y
static void C_xref( eight_bits spec_ctrl )
   /* makes cross-references for \CEE/ identifiers */
@z

@x
void outer_xref();
@y
static void outer_xref(void);
@z

@x
void
outer_xref() /* extension of |C_xref| */
@y
static void outer_xref(void) /* extension of |C_xref| */
@z

@x
    case translit_code: err_print("! Use @@l in limbo only"); continue;
@y
    case translit_code: err_print(get_string(MSG_ERROR_CT68_1)); continue;
@z

@x
            else lhs->xref=(char*)q->xlink;
@y
            else lhs->xref=(void HUGE*)q->xlink;
@z

@x
    err_print("! Missing left identifier of @@s");
@y
    err_print(get_string(MSG_ERROR_CW71_1));
@z

@x
      err_print("! Missing right identifier of @@s");
@y
      err_print(get_string(MSG_ERROR_CW71_2));
@z

@x
void section_check();
@y
static void section_check(name_pointer);
@z

@x
void
section_check(p)
name_pointer p; /* print anomalies in subtree |p| */
@y
static void section_check(name_pointer p)
   /* print anomalies in subtree |p| */
@z

@x
      printf("\n! Never defined: <"); print_section_name(p); putchar('>'); mark_harmless;
@y
      printf(get_string(MSG_WARNING_CW75_1));
      print_section_name(p); putchar('>'); mark_harmless;
@z

@x
      printf("\n! Never used: <"); print_section_name(p); putchar('>'); mark_harmless;
@y
      printf(get_string(MSG_WARNING_CW75_2));
      print_section_name(p); putchar('>'); mark_harmless;
@z

@x
char out_buf[line_length+1]; /* assembled characters */
char *out_ptr; /* just after last character in |out_buf| */
char *out_buf_end = out_buf+line_length; /* end of |out_buf| */
@y
char *out_buf; /* assembled characters */
char *out_buf_end; /* end of |out_buf| */
char *out_ptr; /* just after last character in |out_buf| */
@z

@x
void
flush_buffer(b,per_cent,carryover)
char *b;  /* outputs from |out_buf+1| to |b|,where |b<=out_ptr| */
boolean per_cent,carryover;
@y
static void flush_buffer(char *b,boolean per_cent,boolean carryover)
   /* outputs from |out_buf+1| to |b|, where |b<=out_ptr| */
@z

@x
  if (b<out_ptr) strncpy(out_buf+1,b+1,out_ptr-b);
@y
  if (b<out_ptr) strncpy(out_buf+1,b+1,(size_t)(out_ptr-b));
@z

@x
void
finish_line() /* do this at the end of a line */
@y
static void finish_line(void) /* do this at the end of a line */
@z

@x
@ In particular, the |finish_line| procedure is called near the very
beginning of phase two. We initialize the output variables in a slightly
tricky way so that the first line of the output file will be
`\.{\\input cwebmac}'.

@<Set init...@>=
out_ptr=out_buf+1; out_line=1; active_file=tex_file;
*out_ptr='c'; tex_printf("\\input cwebma");
@y
@ In particular, the |finish_line| procedure is called near the very
beginning of phase two. We initialize the output variables in a slightly
tricky way so that the first line of the output file will be dependent of
the user language set by the `\.{+l}' option and its argument.  If you call
\.{CWEAVE} with `\.{+lX}' (or `\.{-lX} as well), where `\.X' is the
(possibly empty) string of characters to the right of~`\.l', `\.X'~will be
prepended to `\.{cwebmac.tex}', e.g., if you call \.{CWEAVE} with
`\.{+ldeutsch}', you will receive the line `\.{\\input deutschcwebmac}'.

@<Set init...@>=
alloc_object(out_buf,line_length+1,char);
out_buf_end = out_buf + line_length;
out_ptr=out_buf+1; out_line=1; active_file=tex_file; *out_ptr='c';
tex_printf("\\input ");
fprintf(active_file,"%s",use_language);
tex_printf("cwebma");
@z

@x
void
out_str(s) /* output characters from |s| to end of string */
char *s;
@y
static void out_str(char*s) /* output characters from |s| to end of string */
@z

@x
void break_out();
@y
static void break_out(void);
@z

@x
void
break_out() /* finds a way to break the output line */
@y
static void break_out(void) /* finds a way to break the output line */
@z

@x
  printf("\n! Line had to be broken (output l. %d):\n",out_line);
@y
  printf(get_string(MSG_WARNING_CW85),out_line);
@z

@x
void
out_section(n)
sixteen_bits n;
@y
static void out_section(sixteen_bits n)
@z

@x
void
out_name(p)
name_pointer p;
@y
void out_name(name_pointer p)
@z

@x
  char *k, *k_end=(p+1)->byte_start; /* pointers into |byte_mem| */
@y
  char HUGE *k;
  char HUGE *k_end=(p+1)->byte_start; /* pointers into |byte_mem| */
@z

@x
void
copy_limbo()
@y
static void copy_limbo(void)
@z

@x
        default: err_print("! Double @@ should be used in limbo");
@y
        default: err_print(get_string(MSG_ERROR_CT93));
@z

@x
eight_bits
copy_TeX()
@y
static eight_bits copy_TeX(void)
@z

@x
@d app_tok(c) {if (tok_ptr+2>tok_mem_end) overflow("token"); *(tok_ptr++)=c;}
@y
@d app_tok(c) {if (tok_ptr+2>tok_mem_end)
    overflow(get_string(MSG_OVERFLOW_CT26));
  *(tok_ptr++)=c;}
@z

@x
int copy_comment();
@y
static int copy_comment(boolean,int);
@z

@x
int copy_comment(is_long_comment,bal) /* copies \TEX/ code in comments */
boolean is_long_comment; /* is this a traditional \CEE/ comment? */
int bal; /* brace balance */
@y
static copy_comment(@t\1\1@> /* copies \TeX\ code in comments */
  boolean is_long_comment, /* is this a traditional \CEE/ comment? */
  int bal@t\2\2@>) /* brace balance */
@z

@x
          err_print("! Input ended in mid-comment");
@y
          err_print(get_string(MSG_ERROR_CT60_1));
@z

@x
        if (bal>1) err_print("! Missing } in comment");
@y
        if (bal>1) err_print(get_string(MSG_ERROR_CW92_1));
@z

@x
      else {err_print("! Extra } in comment");
@y
      else {err_print(get_string(MSG_ERROR_CW92_2));
@z

@x
  if (bal>1) err_print("! Missing } in comment");
@y
  if (bal>1) err_print(get_string(MSG_ERROR_CW92_1));
@z

@x
    err_print("! Illegal use of @@ in comment");
@y
    err_print(get_string(MSG_ERROR_CW94));
@z

@x
char cat_name[256][12];
eight_bits cat_index;

@ @<Set in...@>=
@y
char **cat_name;
eight_bits cat_index;

@ @<Set in...@>=
alloc_object(cat_name,256,char *);
for(cat_index=0; cat_index<255; cat_index++)
  alloc_object(cat_name[cat_index],12,char);
@z

@x
void
print_cat(c) /* symbolic printout of a category */
eight_bits c;
@y
static void print_cat(eight_bits c) /* symbolic printout of a category */
@z

@x
scrap scrap_info[max_scraps]; /* memory array for scraps */
scrap_pointer scrap_info_end=scrap_info+max_scraps -1; /* end of |scrap_info| */
@y
scrap_pointer scrap_info; /* memory array for scraps */
scrap_pointer scrap_info_end; /* end of |scrap_info| */
@z

@x
scrap_base=scrap_info+1;
max_scr_ptr=scrap_ptr=scrap_info;
@y
alloc_object(scrap_info,max_scraps,scrap);
scrap_info_end = scrap_info + max_scraps - 1;
scrap_base=scrap_info+1;
max_scr_ptr=scrap_ptr=scrap_info;
@z

@x
void
print_text(p) /* prints a token list for debugging; not used in |main| */
text_pointer p;
@y
static void print_text(text_pointer p)
   /* prints a token list for debugging; not used in |main| */
@z

@x
@d app(a) *(tok_ptr++)=a
@d app1(a) *(tok_ptr++)=tok_flag+(int)((a)->trans-tok_start)
@y
@d app(a) *(tok_ptr++)=(token)(a)
@d app1(a) *(tok_ptr++)=(token)(tok_flag+(int)((a)->trans-tok_start))
@z

@x
void
app_str(s)
char *s;
@y
static void app_str(char *s)
@z

@x
void
big_app(a)
token a;
@y
static void big_app(token a)
@z

@x
void
big_app1(a)
scrap_pointer a;
@y
static void big_app1(scrap_pointer a)
@z

@x
token_pointer
find_first_ident(p)
text_pointer p;
@y
static token_pointer find_first_ident(text_pointer p)
@z

@x
void
make_reserved(p) /* make the first identifier in |p->trans| like |int| */
scrap_pointer p;
@y
static void make_reserved(scrap_pointer p)
/* make the first identifier in |p->trans| like |int| */
@z

@x
  (name_dir+(sixteen_bits)(tok_value%id_flag))->ilk=raw_int;
@y
  (name_dir+(ptrdiff_t)(tok_value%id_flag))->ilk=raw_int;
@z

@x
void
make_underlined(p)
/* underline the entry for the first identifier in |p->trans| */
scrap_pointer p;
@y
static void make_underlined(scrap_pointer p)
/* underline the entry for the first identifier in |p->trans| */
@z

@x
void  underline_xref();
@y
static void underline_xref(name_pointer);
@z

@x
void
underline_xref(p)
name_pointer p;
@y
static void underline_xref(name_pointer p)
@z

@x
  p->xref=(char*)xref_ptr;
@y
  p->xref=(void HUGE*)xref_ptr;
@z

@x
@<Cases for |exp|@>=
if (cat1==lbrace || cat1==int_like || cat1==decl) {
  make_underlined(pp); big_app1(pp); big_app(indent); app(indent);
  reduce(pp,1,fn_decl,0,1);
}
@y
@<Cases for |exp|@>=
if(cat1==lbrace || cat1==int_like || cat1==decl) {
  make_underlined(pp); big_app1(pp);
  if (indent_param_decl) {
    big_app(indent); app(indent);
  }
  reduce(pp,1,fn_decl,0,1);
}
@z

@x
@ @<Cases for |decl_head|@>=
if (cat1==comma) {
  big_app2(pp); big_app(' '); reduce(pp,2,decl_head,-1,33);
}
else if (cat1==unorbinop) {
  big_app1(pp); big_app('{'); big_app1(pp+1); big_app('}');
  reduce(pp,2,decl_head,-1,34);
}
else if (cat1==exp && cat2!=lpar && cat2!=exp) {
  make_underlined(pp+1); squash(pp,2,decl_head,-1,35);
}
else if ((cat1==binop||cat1==colon) && cat2==exp && (cat3==comma ||
    cat3==semi || cat3==rpar))
  squash(pp,3,decl_head,-1,36);
else if (cat1==cast) squash(pp,2,decl_head,-1,37);
else if (cat1==lbrace || (cat1==int_like&&cat2!=colcol) || cat1==decl) {
  big_app1(pp); big_app(indent); app(indent); reduce(pp,1,fn_decl,0,38);
}
else if (cat1==semi) squash(pp,2,decl,-1,39);
@y
@ @<Cases for |decl_head|@>=
if (cat1==comma) {
  big_app2(pp); big_app(' '); reduce(pp,2,decl_head,-1,33);
}
else if (cat1==unorbinop) {
  big_app1(pp); big_app('{'); big_app1(pp+1); big_app('}');
  reduce(pp,2,decl_head,-1,34);
}
else if (cat1==exp && cat2!=lpar && cat2!=exp) {
  make_underlined(pp+1); squash(pp,2,decl_head,-1,35);
}
else if ((cat1==binop||cat1==colon) && cat2==exp && (cat3==comma ||
    cat3==semi || cat3==rpar))
  squash(pp,3,decl_head,-1,36);
else if (cat1==cast) squash(pp,2,decl_head,-1,37);
else if (cat1==lbrace || (cat1==int_like&&cat2!=colcol) || cat1==decl) {
  big_app1(pp);
  if (indent_param_decl) {
    big_app(indent); app(indent);
  }
  reduce(pp,1,fn_decl,0,38);
}
else if (cat1==semi) squash(pp,2,decl,-1,39);
@z

@x
else if (cat1==stmt || cat1==function) {
  big_app1(pp); big_app(big_force);
  big_app1(pp+1); reduce(pp,2,cat1,-1,41);
}
@y
else if (cat1==stmt || cat1==function) {
  big_app1(pp);
  if(order_decl_stmt) big_app(big_force);
  else big_app(force);
  big_app1(pp+1); reduce(pp,2,cat1,-1,41);
}
@z

@x
@ @<Cases for |fn_decl|@>=
if (cat1==decl) {
  big_app1(pp); big_app(force); big_app1(pp+1); reduce(pp,2,fn_decl,0,51);
}
else if (cat1==stmt) {
  big_app1(pp); app(outdent); app(outdent); big_app(force);
  big_app1(pp+1); reduce(pp,2,function,-1,52);
}
@y
@ @<Cases for |fn_decl|@>=
if (cat1==decl) {
  big_app1(pp); big_app(force); big_app1(pp+1); reduce(pp,2,fn_decl,0,51);
}
else if (cat1==stmt) {
  big_app1(pp);
  if (indent_param_decl) {
    app(outdent); app(outdent);
  }
  big_app(force);
  big_app1(pp+1); reduce(pp,2,function,-1,52);
}
@z

@x
void
reduce(j,k,c,d,n)
scrap_pointer j;
eight_bits c;
short k, d, n;
@y
static void reduce(scrap_pointer j, short k, eight_bits c, short d, short n)
@z

@x
@ @<Change |pp| to $\max...@>=
@y
@ @<Change |pp| to $\max...@>=
#ifdef __TURBOC__
if (d<0 && pp+d>pp) pp=scrap_base; /* segmented architecture caused wrap */
else
#endif
@z

@x
void
squash(j,k,c,d,n)
scrap_pointer j;
eight_bits c;
short k, d, n;
@y
static void squash(scrap_pointer j, short k, eight_bits c, short d, short n)
@z

@x
    overflow("token");
@y
    overflow(get_string(MSG_OVERFLOW_CT30));
@z

@x
    overflow("text");
@y
    overflow(get_string(MSG_OVERFLOW_CT76));
@z

@x
text_pointer
translate() /* converts a sequence of scraps */
@y
static text_pointer translate(void) /* converts a sequence of scraps */
@z

@x
    if (tok_ptr+6>tok_mem_end) overflow("token");
@y
    if (tok_ptr+6>tok_mem_end) overflow(get_string(MSG_OVERFLOW_CT26));
@z

@x
  printf("\nIrreducible scrap sequence in section %d:",section_count);
@y
  printf(get_string(MSG_WARNING_CW171),section_count);
@z

@x
  printf("\nTracing after l. %d:\n",cur_line); mark_harmless;
@y
  printf(get_string(MSG_WARNING_CW172),cur_line); mark_harmless;
@z

@x
void
C_parse(spec_ctrl) /* creates scraps from \CEE/ tokens */
  eight_bits spec_ctrl;
@y
static void C_parse(eight_bits spec_ctrl)
  /* creates scraps from \CEE/ tokens */
@z

@x
  overflow("scrap/token/text");
@y
  overflow(get_string(MSG_OVERFLOW_CW176));
@z

@x
        else err_print("! Double @@ should be used in strings");
@y
        else err_print(get_string(MSG_ERROR_CT80));
@z

@x
void app_cur_id();
@y
void app_cur_id(boolean);
@z

@x
void
app_cur_id(scrapping)
boolean scrapping; /* are we making this into a scrap? */
@y
void app_cur_id(boolean scrapping) /* are we making this into a scrap? */
@z

@x
text_pointer
C_translate()
@y
static text_pointer C_translate(void)
@z

@x
  if (next_control!='|') err_print("! Missing '|' after C text");
@y
  if (next_control!='|') err_print(get_string(MSG_ERROR_CW182));
@z

@x
void
outer_parse() /* makes scraps from \CEE/ tokens and comments */
@y
static void outer_parse(void) /* makes scraps from \CEE/ tokens and comments */
@z

@x
output_state stack[stack_size]; /* info for non-current levels */
stack_pointer stack_ptr; /* first unused location in the output state stack */
stack_pointer stack_end=stack+stack_size-1; /* end of |stack| */
@y
stack_pointer stack; /* info for non-current levels */
stack_pointer stack_end; /* end of |stack| */
stack_pointer stack_ptr; /* first unused location in the output state stack */
@z

@x
max_stack_ptr=stack;
@y
alloc_object(stack,stack_size,output_state);
stack_end = stack + stack_size - 1;
max_stack_ptr=stack;
@z

@x
void
push_level(p) /* suspends the current level */
text_pointer p;
@y
static void push_level(text_pointer p) /* suspends the current level */
@z

@x
  if (stack_ptr==stack_end) overflow("stack");
@y
  if (stack_ptr==stack_end) overflow(get_string(MSG_OVERFLOW_CT30));
@z

@x
void
pop_level()
@y
static void pop_level(void)
@z

@x
eight_bits
get_output() /* returns the next token of output */
@y
static eight_bits get_output(void) /* returns the next token of output */
@z

@x
  return(a);
@y
  return((eight_bits)a);
@z

@x
void
output_C() /* outputs the current token list */
@y
static void output_C(void) /* outputs the current token list */
@z

@x
void make_output();
@y
static void make_output(void);
@z

@x
void
make_output() /* outputs the equivalents of tokens */
@y
static void make_output(void) /* outputs the equivalents of tokens */
@z

@x
  char *k, *k_limit; /* indices into |scratch| */
@y
  char HUGE *k;
  char HUGE *k_limit; /* indices into |scratch| */
@z

@x
    for (p=cur_name->byte_start;p<(cur_name+1)->byte_start;p++)
      out(isxalpha(*p)? 'x':*p);
@y
#ifdef __TURBOC__
    for (k=cur_name->byte_start;k<(cur_name+1)->byte_start;k++)
      out(isxalpha(*k)? 'x':*k);
#else
    for (p=cur_name->byte_start;p<(cur_name+1)->byte_start;p++)
      out(isxalpha(*p)? 'x':*p);
#endif
@^system dependencies@>
@z

@x
    for (p=cur_name->byte_start;p<(cur_name+1)->byte_start;p++)
      if (xislower(*p)) { /* not entirely uppercase */
@y
#ifdef __TURBOC__
    for (k=cur_name->byte_start;k<(cur_name+1)->byte_start;k++)
      if (xislower(*k)) { /* not entirely uppercase */
#else
    for (p=cur_name->byte_start;p<(cur_name+1)->byte_start;p++)
      if (xislower(*p)) { /* not entirely uppercase */
#endif
@^system dependencies@>
@z

@x
  printf("\n! Illegal control code in section name: <");
@y
  printf(get_string(MSG_ERROR_CW201));
@z

@x
    printf("\n! C text in section name didn't end: <");
@y
    printf(get_string(MSG_ERROR_CW202));
@z

@x
      if (j>buffer+long_buf_size-3) overflow("buffer");
@y
      if (j>buffer+long_buf_size-3) overflow(get_string(MSG_OVERFLOW_CW202));
@z

@x
  if (j>buffer+long_buf_size-4) overflow("buffer");
@y
  if (j>buffer+long_buf_size-4) overflow(get_string(MSG_OVERFLOW_CW202));
@z

@x
void phase_two();
@y
static void phase_two(void);
@z

@x
void
phase_two() {
@y
static void phase_two(void) {
@z

@x
reset_input(); if (show_progress) printf("\nWriting the output file...");
@y
reset_input(); if (show_progress) printf(get_string(MSG_PROGRESS_CW204));
@z

@x
        err_print("! TeX string should be in C text only"); break;
@y
        err_print(get_string(MSG_ERROR_CW209_1)); break;
@z

@x
        err_print("! You can't do that in TeX text"); break;
@y
        err_print(get_string(MSG_ERROR_CW209_2)); break;
@z

@x
void finish_C();
@y
static void finish_C(boolean);
@z

@x
void
finish_C(visible) /* finishes a definition or a \CEE/ part */
  boolean visible; /* nonzero if we should produce \TEX/ output */
@y
static void finish_C(@t\1\1@> /* finishes a definition or a \Cee\ part */
  boolean visible@t\2\2@>) /* nonzero if we should produce \TeX\ output */
@z

@x
    err_print("! Improper macro definition");
@y
    err_print(get_string(MSG_ERROR_CW213));
@z

@x
      default: err_print("! Improper macro definition"); break;
@y
      default: err_print(get_string(MSG_ERROR_CW213)); break;
@z

@x
  if (scrap_ptr!=scrap_info+2) err_print("! Improper format definition");
@y
  if (scrap_ptr!=scrap_info+2) err_print(get_string(MSG_ERROR_CW214));
@z

@x
  err_print("! You need an = sign after the section name");
@y
  err_print(get_string(MSG_ERROR_CW217));
@z

@x
  err_print("! You can't do that in C text");
@y
  err_print(get_string(MSG_ERROR_CW218));
@z

@x
void footnote();
@y
static void footnote(sixteen_bits);
@z

@x
void
footnote(flag) /* outputs section cross-references */
sixteen_bits flag;
@y
static void footnote(sixteen_bits flag) /* outputs section cross-references */
@z

@x
void phase_three();
@y
static void phase_three(void);
@z

@x
void
phase_three() {
@y
static void phase_three(void) {
@z

@x
if (no_xref) {
  finish_line();
  out_str("\\end");
@.\\end@>
  finish_line();
}
else {
  phase=3; if (show_progress) printf("\nWriting the index...");
@.Writing the index...@>
  finish_line();
  if ((idx_file=fopen(idx_file_name,"w"))==NULL)
    fatal("! Cannot open index file ",idx_file_name);
@.Cannot open index file@>
  if (change_exists) {
    @<Tell about changed sections@>; finish_line(); finish_line();
  }
  out_str("\\inx"); finish_line();
@.\\inx@>
  active_file=idx_file; /* change active file to the index file */
  @<Do the first pass of sorting@>;
  @<Sort and output the index@>;
  finish_line(); fclose(active_file); /* finished with |idx_file| */
  active_file=tex_file; /* switch back to |tex_file| for a tic */
  out_str("\\fin"); finish_line();
@.\\fin@>
  if ((scn_file=fopen(scn_file_name,"w"))==NULL)
    fatal("! Cannot open section file ",scn_file_name);
@.Cannot open section file@>
  active_file=scn_file; /* change active file to section listing file */
  @<Output all the section names@>;
  finish_line(); fclose(active_file); /* finished with |scn_file| */
  active_file=tex_file;
  if (group_found) out_str("\\con");@+else out_str("\\end");
@.\\con@>
@.\\end@>
  finish_line();
  fclose(active_file);
}
if (show_happiness) printf("\nDone.");
@y
if (no_xref) {
  finish_line();
  out_str("\\end");
@.\\end@>
  active_file=tex_file;
}
else {
  phase=3;
  if (show_progress) {
    printf(get_string(MSG_PROGRESS_CW225)); fflush(stdout);
  }
@.Writing the index...@>
  finish_line();
  if ((idx_file=fopen(idx_file_name,"w"))==NULL)
    fatal(get_string(MSG_FATAL_CW225_1),idx_file_name);
@.Cannot open index file@>
  if (change_exists) {
    @<Tell about changed sections@>; finish_line(); finish_line();
  }
  out_str("\\inx"); finish_line();
@.\\inx@>
  active_file=idx_file; /* change active file to the index file */
  @<Do the first pass of sorting@>;
  @<Sort and output the index@>;
  finish_line(); fclose(active_file); /* finished with |idx_file| */
  active_file=tex_file; /* switch back to |tex_file| for a tic */
  out_str("\\fin"); finish_line();
@.\\fin@>
  if ((scn_file=fopen(scn_file_name,"w"))==NULL)
    fatal(get_string(MSG_FATAL_CW225_2),scn_file_name);
@.Cannot open section file@>
  active_file=scn_file; /* change active file to section listing file */
  @<Output all the section names@>;
  finish_line(); fclose(active_file); /* finished with |scn_file| */
  active_file=tex_file;
  if (group_found) out_str("\\con");@+else out_str("\\end");
@.\\con@>
@.\\end@>
}
finish_line(); fclose(active_file); active_file=NULL;
@<Update the result when it has changed@>@;
if (show_happiness) printf(get_string(MSG_PROGRESS_CT42_3));
@z

@x
name_pointer bucket[256];
name_pointer next_name; /* successor of |cur_name| when sorting */
name_pointer blink[max_names]; /* links in the buckets */
@y
name_pointer *bucket;
name_pointer next_name; /* successor of |cur_name| when sorting */
name_pointer *blink; /* links in the buckets */
@z

@x
    if (cur_name->xref!=(char*)xmem) {
@y
    if (cur_name->xref!=(void HUGE*)xmem) {
@z

@x
char *cur_byte; /* index into |byte_mem| */
@y
char HUGE *cur_byte; /* index into |byte_mem| */
@z

@x
max_sort_ptr=scrap_info;
@y
alloc_object(bucket,256,name_pointer);
alloc_object(blink,max_names,name_pointer);
max_sort_ptr=scrap_info;
@z

@x
eight_bits collate[102+128]; /* collation order */
@y
eight_bits *collate; /* collation order */
@z

@x
collate[0]=0;
strcpy(collate+1," \1\2\3\4\5\6\7\10\11\12\13\14\15\16\17");
/* 16 characters + 1 = 17 */
strcpy(collate+17,"\20\21\22\23\24\25\26\27\30\31\32\33\34\35\36\37");
/* 16 characters + 17 = 33 */
strcpy(collate+33,"!\42#$%&'()*+,-./:;<=>?@@[\\]^`{|}~_");
/* 32 characters + 33 = 65 */
strcpy(collate+65,"abcdefghijklmnopqrstuvwxyz0123456789");
/* (26 + 10) characters + 65 = 101 */
strcpy(collate+101,"\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217");
/* 16 characters + 101 = 117 */
strcpy(collate+117,"\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237");
/* 16 characters + 117 = 133 */
strcpy(collate+133,"\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257");
/* 16 characters + 133 = 149 */
strcpy(collate+149,"\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277");
/* 16 characters + 149 = 165 */
strcpy(collate+165,"\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317");
/* 16 characters + 165 = 181 */
strcpy(collate+181,"\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337");
/* 16 characters + 181 = 197 */
strcpy(collate+197,"\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357");
/* 16 characters + 197 = 213 */
strcpy(collate+213,"\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377");
/* 16 characters + 213 = 229 */
@y
alloc_object(collate,102+128,eight_bits);
collate[0]=0;
strcpy((char *)collate+1,
  " \1\2\3\4\5\6\7\10\11\12\13\14\15\16\17");
/* 16 characters + 1 = 17 */
strcpy((char *)collate+17,
  "\20\21\22\23\24\25\26\27\30\31\32\33\34\35\36\37");
/* 16 characters + 17 = 33 */
strcpy((char *)collate+33,
  "!\42#$%&'()*+,-./:;<=>?@@[\\]^`{|}~_");
/* 32 characters + 33 = 65 */
strcpy((char *)collate+65,
  "abcdefghijklmnopqrstuvwxyz0123456789");
/* (26 + 10) characters + 65 = 101 */
strcpy((char *)collate+101,
  "\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217");
/* 16 characters + 101 = 117 */
strcpy((char *)collate+117,
  "\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237");
/* 16 characters + 117 = 133 */
strcpy((char *)collate+133,
  "\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257");
/* 16 characters + 133 = 149 */
strcpy((char *)collate+149,
  "\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277");
/* 16 characters + 149 = 165 */
strcpy((char *)collate+165,
  "\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317");
/* 16 characters + 165 = 181 */
strcpy((char *)collate+181,
  "\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337");
/* 16 characters + 181 = 197 */
strcpy((char *)collate+197,
  "\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357");
/* 16 characters + 197 = 213 */
strcpy((char *)collate+213,
  "\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377");
/* 16 characters + 213 = 229 */
@z

@x
void  unbucket();
@y
static void unbucket(eight_bits);
@z

@x
void
unbucket(d) /* empties buckets having depth |d| */
eight_bits d;
@y
static void unbucket(eight_bits d) /* empties buckets having depth |d| */
@z

@x
    if (sort_ptr>=scrap_info_end) overflow("sorting");
@y
    if (sort_ptr>=scrap_info_end) overflow(get_string(MSG_OVERFLOW_CW237));
@z

@x
    else {char *j;
@y
    else {char HUGE *j;
@z

@x
  case custom: case quoted: {char *j; out_str("$\\");
@y
  case custom: case quoted: {char HUGE *j; out_str("$\\");
@z

@x
void section_print();
@y
static void section_print(name_pointer);
@z

@x
void
section_print(p) /* print all section names in subtree |p| */
name_pointer p;
@y
static void section_print(name_pointer p) /* print all section names in subtree |p| */
@z

@x
@ Because on some systems the difference between two pointers is a |long|
rather than an |int|, we use \.{\%ld} to print these quantities.

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
@.Memory usage statistics:@>
  printf("%ld names (out of %ld)\n",
            (long)(name_ptr-name_dir),(long)max_names);
  printf("%ld cross-references (out of %ld)\n",
            (long)(xref_ptr-xmem),(long)max_refs);
  printf("%ld bytes (out of %ld)\n",
            (long)(byte_ptr-byte_mem),(long)max_bytes);
  printf("Parsing:\n");
  printf("%ld scraps (out of %ld)\n",
            (long)(max_scr_ptr-scrap_info),(long)max_scraps);
  printf("%ld texts (out of %ld)\n",
            (long)(max_text_ptr-tok_start),(long)max_texts);
  printf("%ld tokens (out of %ld)\n",
            (long)(max_tok_ptr-tok_mem),(long)max_toks);
  printf("%ld levels (out of %ld)\n",
            (long)(max_stack_ptr-stack),(long)stack_size);
  printf("Sorting:\n");
  printf("%ld levels (out of %ld)\n",
            (long)(max_sort_ptr-scrap_info),(long)max_scraps);
}
@y
  printf(get_string(MSG_STATS_CT95_1));
@.Memory usage statistics:@>
  printf(get_string(MSG_STATS_CT95_2),
            (long)(name_ptr-name_dir),(long)max_names);
  printf(get_string(MSG_STATS_CW248_1),
            (long)(xref_ptr-xmem),(long)max_refs);
  printf(get_string(MSG_STATS_CT95_4),
            (long)(byte_ptr-byte_mem),(long)max_bytes);
  printf(get_string(MSG_STATS_CW248_2));
  printf(get_string(MSG_STATS_CW248_3),
            (long)(max_scr_ptr-scrap_info),(long)max_scraps);
  printf(get_string(MSG_STATS_CW248_4),
            (long)(max_text_ptr-tok_start),(long)max_texts);
  printf(get_string(MSG_STATS_CT95_5),
            (long)(max_tok_ptr-tok_mem),(long)max_toks);
  printf(get_string(MSG_STATS_CW248_5),
            (long)(max_stack_ptr-stack),(long)stack_size);
  printf(get_string(MSG_STATS_CW248_6));
  printf(get_string(MSG_STATS_CW248_5),
            (long)(max_sort_ptr-scrap_info),(long)max_scraps);
}
@z

@x
@** Index.
@y
@** Version information.  The {\mc AMIGA} operating system provides the
`version' command and good programs answer with some informations about
their creation date and their current version.  This might be useful for
other operating systems as well.

@<Glob...@>=
const char Version[] = "$VER: CWeave 3.4 [p13] ("__DATE__", "__TIME__")\n";

@** Function declarations.  Here are declarations---conforming to
{\mc ANSI~C}---of all functions in this code, as far as they are
not already in |"common.h"|.  These are private to \.{CWEAVE}.

@<Predecl...@>=
static eight_bits copy_TeX(void);@/
static eight_bits get_output(void);@/
static text_pointer C_translate(void);@/
static text_pointer translate(void);@/
static token_pointer find_first_ident(text_pointer);@/
static unsigned skip_TeX(void);@/
static void app_str(char *);@/
static void big_app(token);@/
static void big_app1(scrap_pointer);@/
static void copy_limbo(void);@/
static void C_parse(eight_bits);@/
static void finish_line(void);@/
static void flush_buffer(char *,boolean,boolean);@/
static void make_reserved(scrap_pointer);@/
static void make_underlined(scrap_pointer);@/
static void new_section_xref(name_pointer);@/
static void new_xref(name_pointer);@/
static void outer_parse(void);@/
static void output_C(void);@/
static void out_name(name_pointer);@/
static void out_section(sixteen_bits);@/
static void out_str(char *);@/
static void pop_level(void);@/
static void print_cat(eight_bits);@/
static void print_text(text_pointer p);@/
static void push_level(text_pointer);@/
static void reduce(scrap_pointer,short,eight_bits,short,short);@/
static void set_file_flag(name_pointer);@/
static void skip_limbo(void);@/
static void squash(scrap_pointer,short,eight_bits,short,short);@/
#ifdef DEAD_CODE
static void out_str_del(char *,char *);@/
#endif

@** Output file update.  Most \CEE/ projects are controlled by a
\.{makefile} which automatically takes care of the temporal dependecies
between the different source modules.  It is suitable that \.{CWEB} doesn't
create new output for all existing files, when there are only changes to
some of them.  Thus the \.{make} process will only recompile those modules
where necessary. The idea and basic implementation of this mechanism can
be found in the program \.{NUWEB} by Preston Briggs, to whom credit is due.

@<Update the result...@>=
if((tex_file=fopen(tex_file_name,"r"))!=NULL) {
  char *x,*y;
  int x_size,y_size,comparison;

  if((check_file=fopen(check_file_name,"r"))==NULL)
    fatal(get_string(MSG_FATAL_CO78),check_file_name);

  alloc_object(x,BUFSIZ,char);
  alloc_object(y,BUFSIZ,char);

  @<Compare the temporary output to the previous output@>@;

  fclose(tex_file); tex_file=NULL;
  fclose(check_file); check_file=NULL;

  @<Take appropriate action depending on the comparison@>@;

  free_object(y);
  free_object(x);
  }
else
  rename(check_file_name,tex_file_name); /* This was the first run */

check_file_name=NULL; /* We want to get rid of the temporary file */

@ We hope that this runs fast on most systems.

@<Compare the temp...@>=
do {
  x_size = fread(x,1,BUFSIZ,tex_file);
  y_size = fread(y,1,BUFSIZ,check_file);
  comparison = (x_size == y_size); /* Do not merge these statements! */
  if(comparison) comparison = !memcmp(x,y,x_size);
  } while(comparison && !feof(tex_file) && !feof(check_file));

@ Note the superfluous call to |remove| before |rename|.  We're using it to
get around a bug in some implementations of |rename|.

@<Take appropriate action...@>=
if(comparison)
  remove(check_file_name); /* The output remains untouched */
else {
  remove(tex_file_name);
  rename(check_file_name,tex_file_name);
  }

@** Index.
@z

