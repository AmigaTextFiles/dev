% This file is part of mCWEB.
% This program by Markus Öllinger is based on
% CWEB 3.4 by Silvio Levy and Donald E. Knuth which in turn
% is based on a program by Knuth.
% It is distributed WITHOUT ANY WARRANTY, express or implied.
% Version 1.1 --- October 1998

% Copyright (C) 1996-1998 Markus Öllinger

% Permission is granted to make and distribute verbatim copies of this
% document provided that the copyright notice and this permission notice
% are preserved on all copies.

% Permission is granted to copy and distribute modified versions of this
% document under the conditions for verbatim copying, provided that the
% entire resulting derived work is given a different name and distributed
% under the terms of a permission notice identical to this one.

% Here is TeX material that gets inserted after \input mcwebmac
\def\hang{\hangindent 3em\indent\ignorespaces}
\def\pb{$\.|\ldots\.|$} % C brackets (|...|)
\def\v{\char'174} % vertical (|) in typewriter font
\mathchardef\RA="3221 % right arrow
\mathchardef\BA="3224 % double arrow

\def\title{mCTANGLE (Version 1.1)}
\def\topofcontents{\null\vfill
  \centerline{\titlefont The {\ttitlefont mCTANGLE} processor}
  \vskip 15pt
  \centerline{(Version 1.1)}
  \vfill}
\def\botofcontents{\vfill
\noindent
Copyright \copyright\ 1996 Markus \"Ollinger %"
\bigskip\noindent
Permission is granted to make and distribute verbatim copies of this
document provided that the copyright notice and this permission notice
are preserved on all copies.

\smallskip\noindent
Permission is granted to copy and distribute modified versions of this
document under the conditions for verbatim copying, provided that the
entire resulting derived work is given a different name and distributed
under the terms of a permission notice identical to this one.
}
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iftrue

@** Introduction.
This is the \.{mCTANGLE} program which is an extension to
\.{CWEB} by Silvio Levy and Donald E. Knuth,
based on \.{TANGLE} by Knuth.
I am thankful to Thomas \"Ollinger for his constructive criticism and %"
his help with the \TeX\ macros, and everbody who has contributed to
the original \.{CWEB}: Silvio Levy, D.~E.~Knuth,
Nelson Beebe, Hans-Hermann Bode (to whom the \CPLUSPLUS/ adaptation is due),
Klaus Guntermann, Norman Ramsey, Tomas Rokicki, Joachim Schnitter,
Joachim Schrod, Lee Wittenberg, and others who have contributed improvements.

The ``banner line'' defined here should be changed whenever \.{mCTANGLE}
is modified.

@d banner "This is mCTANGLE (Version 1.1)\n"

@c
@<Include files@>@/
@h
@<Common code for \.{CWEAVE} and \.{CTANGLE}@>@/
@<Typedef declarations@>@/
@<Global variables@>@/
@<Predeclaration of procedures@>@/

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
extern char *strrchr(); /* find last occurrence of character in string */
extern char *strchr(); /* find first occurrence of character in string */

@ %modified
\.{CTANGLE} has a fairly straightforward outline.  It operates in
two phases: first it reads the source file, saving the \CEE/ code in
compressed form; then outputs the code, after shuffling it around.

Please read the documentation for \.{mcommon}, the set of routines common
to \.{CTANGLE} and \.{CWEAVE}, before proceeding further.

@c
int main (ac, av)
int ac;
char **av;
{
  argc=ac; argv=av;
  program=ctangle;

  show_banner=show_happiness=show_progress=1;
  scan_args();
  if (show_banner) printf(banner); /* print a ``banner line'' */
  argc=ac; argv=av;

  @<Check for book file@>;

  return tangle_file();  /* run in old-style \.{CWEB} mode */
}

@
@<Predecl...@>=
int tangle_file();

@ %moved
Translates a \.{WEB} file. The argument vector |argv| is scanned to find
out which file to tangle.
@c
int
tangle_file()
{
  @<Set initial values@>;
  common_init();
  @<Insert predefined identifiers into |name_dir|@>;
  @<Create file name constant@>;
  phase_one(); /* read all the user's text and compress it into |tok_mem| */
  phase_two(); /* output the contents of the compressed tables */
  return wrap_up(); /* and exit gracefully */
}

@ The following parameters were sufficient in the original \.{TANGLE} to
handle \TEX/,
so they should be sufficient for most applications of \.{CTANGLE}.
If you change |max_bytes|, |max_names| or |hash_size| you should also
change them in the file |"mcommon.w"|.

@d max_bytes 90000 /* the number of bytes in identifiers,
  index entries, and section names; used in |"mcommon.w"| */
@d max_toks 270000 /* number of bytes in compressed \CEE/ code */
@d max_names 10000 /* number of identifiers, strings, section names;
  must be less than 10240; used in |"mcommon.w"| */
@d max_texts 2500 /* number of replacement texts, must be less than 10240 */
@d hash_size 353 /* should be prime; used in |"mcommon.w"| */
@d longest_name 1000 /* section names shouldn't be longer than this */
@d stack_size 50 /* number of simultaneous levels of macro expansion */
@d buf_size 256 /* for \.{CWEAVE} and \.{CTANGLE} */

@ The next few sections contain stuff from |"mcommon.w"| that must
be included in both |"mctangle.w"| and |"mcweave.w"|. It appears in
file |"mcommon.h"|, which needs to be updated when |"mcommon.w"| changes.

@i mcommon.h

@* Data structures exclusive to {\tt CTANGLE}.
We've already seen that the |byte_mem| array holds the names of identifiers,
strings, and sections;
the |tok_mem| array holds the replacement texts
for sections. Allocation is sequential, since things are deleted only
during Phase II, and only in a last-in-first-out manner.

A \&{text} variable is a structure containing a pointer into
|tok_mem|, which tells where the corresponding text starts, and an
integer |text_link|, which, as we shall see later, is used to connect
pieces of text that have the same name.  All the \&{text}s are stored in
the array |text_info|, and we use a |text_pointer| variable to refer
to them.

The first position of |tok_mem| that is unoccupied by
replacement text is called |tok_ptr|, and the first unused location of
|text_info| is called |text_ptr|.  Thus we usually have the identity
|text_ptr->tok_start==tok_ptr|.

If your machine does not support |unsigned char| you should change
the definition of \&{eight\_bits} to |unsigned short|.
@^system dependencies@>

@<Typed...@>=
typedef struct {
  eight_bits *tok_start; /* pointer into |tok_mem| */
  sixteen_bits text_link; /* relates replacement texts */
} text;
typedef text *text_pointer;

@ @<Glob...@>=
text text_info[max_texts];
text_pointer text_info_end=text_info+max_texts-1;
text_pointer text_ptr; /* first unused position in |text_info| */
eight_bits tok_mem[max_toks];
eight_bits *tok_mem_end=tok_mem+max_toks-1;
eight_bits *tok_ptr; /* first unused position in |tok_mem| */

@ @<Set init...@>=
text_info->tok_start=tok_ptr=tok_mem;
text_ptr=text_info+1; text_ptr->tok_start=tok_mem;
  /* this makes replacement text 0 of length zero */

@ If |p| is a pointer to a section name, |p->equiv| is a pointer to its
replacement text, an element of the array |text_info|.

@d equiv equiv_or_xref /* info corresponding to names */

@ @<Set init...@>=
name_dir->equiv=(char *)text_info; /* the undefined section has no replacement text */

@ Here's the procedure that decides whether a name of length |l|
starting at position |first| equals the identifier pointed to by |p|:

@c
int names_match(p,first,l)
name_pointer p; /* points to the proposed match */
char *first; /* position of first character of string */
int l; /* length of identifier */
{
  if (length(p)!=l) return 0;
  return !strncmp(first,p->byte_start,l);
}

@ The common lookup routine refers to separate routines |init_node| and
|init_p| when the data structure grows. Actually |init_p| is called only by
\.{CWEAVE}, but we need to declare a dummy version so that
the loader won't complain of its absence.

@c
void
init_node(node)
name_pointer node;
{
    node->equiv=(char *)text_info;
}
void
init_p() {}

@ %mine
Some identifiers are used very often, so their indices in |name_dir|
are cached. This is done by inserting them at the very beginning so
that their id numbers will start with~1.
@<Glo...@>=
enum {
  id_global=1,id_export,id_shared,
  id_chapter,id_transitively,id_import,id_from,id_program,id_library,
  id_enum,id_union,id_class,id_struct,id_typedef,id_inline,
  id_extern,id_void,id_int,id_static,
  id_ifndef,id_endif,id_operator,id_mark,id_copy,id_paste
};
char *predefined_name[]={
  "global","export","shared",
  "chapter","transitively","import","from","program","library",
  "enum","union","class","struct","typedef","inline",
  "extern","void","int","static",
  "ifndef","endif","operator","mark","copy","paste"
};

@ %mine
@d Number(x) (sizeof(x)/sizeof(*(x)))
@<Insert predefined identifiers into |name_dir|@>=
{
  int i;
  for(i=0;i<Number(predefined_name);i++)
    id_lookup(predefined_name[i],predefined_name[i]+strlen(predefined_name[i]),0);
}

@* Tokens.
Replacement texts, which represent \CEE/ code in a compressed format,
appear in |tok_mem| as mentioned above. The codes in
these texts are called `tokens'; some tokens occupy two consecutive
eight-bit byte positions, and the others take just one byte.

If $p$ points to a replacement text, |p->tok_start| is the |tok_mem| position
of the first eight-bit code of that text. If |p->text_link==0|,
this is the replacement text for a macro, otherwise it is the replacement
text for a section. In the latter case |p->text_link| is either equal to
|section_flag|, which means that there is no further text for this section, or
|p->text_link| points to a continuation of this replacement text; such
links are created when several sections have \CEE/ texts with the same
name, and they also tie together all the \CEE/ texts of unnamed sections.
The replacement text pointer for the first unnamed section appears in
|text_info->text_link|, and the most recent such pointer is |last_unnamed|.

@d section_flag max_texts /* final |text_link| in section replacement texts */

@<Glob...@>=
text_pointer last_unnamed; /* most recent replacement text of unnamed section */

@ @<Set init...@>= last_unnamed=text_info; text_info->text_link=0;

@ If the first byte of a token is less than |0200|, the token occupies a
single byte. Otherwise we make a sixteen-bit token by combining two consecutive
bytes |a| and |b|. If |0200<=a<0250|, then |(a-0200)@t${}\times2^8$@>+b|
points to an identifier; if |0250<=a<0320|, then
|(a-0250)@t${}\times2^8$@>+b| points to a section name
(or, if it has the special value |output_defs_flag|,
to the area where the preprocessor definitions are stored); and if
|0320<=a<0400|, then |(a-0320)@t${}\times2^8$@>+b| is the number of the section
in which the current replacement text appears.

Codes less than |0200| are 7-bit |char| codes that represent themselves.
Some of the 7-bit codes will not be present, however, so we can
use them for special purposes. The following symbolic names are used:

\yskip \hang |join| denotes the concatenation of adjacent items with no
space or line breaks allowed between them (the \.{@@\&} operation of \.{CWEB}).

\hang |string| denotes the beginning or end of a string, verbatim
construction or numerical constant.
@^ASCII code dependencies@>

@d string 02 /* takes the place of extended ASCII \.{\char2} */
@d join 0177 /* takes the place of ASCII delete */
@d output_defs_flag (2*024000-1)

@ The following procedure is used to enter a two-byte value into
|tok_mem| when a replacement text is being generated.

@c
void
store_two_bytes(x)
sixteen_bits x;
{
  if (tok_ptr+2>tok_mem_end) overflow("token");
  *tok_ptr++=x>>8; /* store high byte */
  *tok_ptr++=x&0377; /* store low byte */
}

@** Stacks for output.  The output process uses a stack to keep track
of what is going on at different ``levels'' as the sections are being
written out.  Entries on this stack have five parts:

\yskip\hang |end_field| is the |tok_mem| location where the replacement
text of a particular level will end;

\hang |byte_field| is the |tok_mem| location from which the next token
on a particular level will be read;

\hang |name_field| points to the name corresponding to a particular level;

\hang |repl_field| points to the replacement text currently being read
at a particular level;

\hang |section_field| is the section number, or zero if this is a macro.

\yskip\noindent The current values of these five quantities are referred to
quite frequently, so they are stored in a separate place instead of in
the |stack| array. We call the current values |cur_end|, |cur_byte|,
|cur_name|, |cur_repl|, and |cur_section|.

The global variable |stack_ptr| tells how many levels of output are
currently in progress. The end of all output occurs when the stack is
empty, i.e., when |stack_ptr==stack|.

@<Typed...@>=
typedef struct {
  eight_bits *end_field; /* ending location of replacement text */
  eight_bits *byte_field; /* present location within replacement text */
  name_pointer name_field; /* |byte_start| index for text being output */
  text_pointer repl_field; /* |tok_start| index for text being output */
  sixteen_bits section_field; /* section number or zero if not a section */
} output_state;
typedef output_state *stack_pointer;

@ @d cur_end cur_state.end_field /* current ending location in |tok_mem| */
@d cur_byte cur_state.byte_field /* location of next output byte in |tok_mem|*/
@d cur_name cur_state.name_field /* pointer to current name being expanded */
@d cur_repl cur_state.repl_field /* pointer to current replacement text */
@d cur_section cur_state.section_field /* current section number being expanded */

@<Global...@>=
output_state cur_state; /* |cur_end|, |cur_byte|, |cur_name|, |cur_repl|
  and |cur_section| */
output_state stack[stack_size+1]; /* info for non-current levels */
stack_pointer stack_ptr; /* first unused location in the output state stack */
stack_pointer stack_end=stack+stack_size; /* end of |stack| */

@ To get the output process started, we will perform the following
initialization steps. We may assume that |text_info->text_link| is nonzero,
since it points to the \CEE/ text in the first unnamed section that generates
code; if there are no such sections, there is nothing to output, and an
error message will have been generated before we do any of the initialization.

@<Initialize the output stacks@>=
stack_ptr=stack+1; cur_name=name_dir; cur_repl=text_info->text_link+text_info;
cur_byte=cur_repl->tok_start; set_cur_end(); cur_section=0;

@
@<Predecl...@>=
void set_cur_end();

@ The current token list ends where the next |text| starts.
There is one exception to the rule. Since one token list can be the
content of two different consecutive |text| sections
(e.g.~a shared and an export section)
we have to find the next |text| that points to a different position in
the token list.
@c
void
set_cur_end()
{
  text_pointer tp;
  for(tp=cur_repl;++tp<=text_ptr;) {
    if(cur_repl->tok_start!=tp->tok_start) {
      cur_end=tp->tok_start;
      return;
    }
  }
  cur_end=(cur_repl+1)->tok_start;
}

@ When the replacement text for name |p| is to be inserted into the output,
the following subroutine is called to save the old level of output and get
the new one going.

We assume that the \CEE/ compiler can copy structures.
@^system dependencies@>

@c
void
push_level(p) /* suspends the current level */
name_pointer p;
{
  if (stack_ptr==stack_end) overflow("stack");
  *stack_ptr=cur_state;
  stack_ptr++;
  if (p!=NULL) { /* |p==NULL| means we are in |output_defs| */
    cur_name=p; cur_repl=(text_pointer)p->equiv;
    cur_byte=cur_repl->tok_start; set_cur_end();
    cur_section=0;
  }
}

@ When we come to the end of a replacement text, the |pop_level| subroutine
does the right thing: It either moves to the continuation of this replacement
text or returns the state to the most recently stacked level.

@c
void
pop_level(flag) /* do this when |cur_byte| reaches |cur_end| */
int flag; /* |flag==0| means we are in |output_defs| */
{
  if (flag && cur_repl->text_link<section_flag) { /* link to a continuation */
    cur_repl=cur_repl->text_link+text_info; /* stay on the same level */
    cur_byte=cur_repl->tok_start; set_cur_end();
    return;
  }
  stack_ptr--; /* go down to the previous level */
  if (stack_ptr>stack) cur_state=*stack_ptr;
}

@ The heart of the output procedure is the function |get_output|,
which produces the next token of output and sends it on to the lower-level
function |out_char|. The main purpose of |get_output| is to handle the
necessary stacking and unstacking. It sends the value |section_number|
if the next output begins or ends the replacement text of some section,
in which case |cur_val| is that section's number (if beginning) or the
negative of that value (if ending). (A section number of 0 indicates
not the beginning or ending of a section, but a \&{\#line} command.)
And it sends the value |identifier|
if the next output is an identifier, in which case
|cur_val| points to that identifier name.

@d section_number 0201 /* code returned by |get_output| for section numbers */
@d identifier 0202 /* code returned by |get_output| for identifiers */

@<Global...@>=
int cur_val; /* additional information corresponding to output token */

@ If |get_output| finds that no more output remains, it returns with
|stack_ptr==stack|.
@^high-bit character handling@>

@c
void
get_output() /* sends next token to |out_char| */
{
  sixteen_bits a; /* value of current byte */
  restart: if (stack_ptr==stack) return;
  if (cur_byte==cur_end) {
    cur_val=-((int)cur_section); /* cast needed because of sign extension */
    pop_level(1);
    if (cur_val==0) goto restart;
    out_char(section_number); return;
  }
  a=*cur_byte++;
  if (out_state==verbatim && a!=string && a!=constant && a!='\n')
    C_putc(a); /* a high-bit character can occur in a string */
  else if (a<0200) out_char(a); /* one-byte token */
  else {
    a=(a-0200)*0400+*cur_byte++;
    switch (a/024000) { /* |024000==(0250-0200)*0400| */
      case 0: cur_val=a; out_char(identifier); break;
      case 1: if (a==output_defs_flag) output_defs();
        else @<Expand section |a-024000|, |goto restart|@>;
        break;
      default: cur_val=a-050000; if (cur_val>0) cur_section=cur_val;
        out_char(section_number);
    }
  }
}

@ The user may have forgotten to give any \CEE/ text for a section name,
or the \CEE/ text may have been associated with a different name by mistake.

@<Expand section |a-...@>=
{
  a-=024000;
  if ((a+name_dir)->equiv!=(char *)text_info) push_level(a+name_dir);
  else if (a!=0) {
    printf("\n! Not present: <");
    print_section_name(a+name_dir); err_print(">");
@.Not present: <section name>@>
  }
  goto restart;
}

@* Producing the output.
The |get_output| routine above handles most of the complexity of output
generation, but there are two further considerations that have a nontrivial
effect on \.{CTANGLE}'s algorithms.

@ First,
we want to make sure that the output has spaces and line breaks in
the right places (e.g., not in the middle of a string or a constant or an
identifier, not at a `\.{@@\&}' position
where quantities are being joined together, and certainly after an \.=
because the \CEE/ compiler thinks \.{=-} is ambiguous).

The output process can be in one of following states:

\yskip\hang |num_or_id| means that the last item in the buffer is a number or
identifier, hence a blank space or line break must be inserted if the next
item is also a number or identifier.

\yskip\hang |unbreakable| means that the last item in the buffer was followed
by the \.{@@\&} operation that inhibits spaces between it and the next item.

\yskip\hang |verbatim| means we're copying only character tokens, and
that they are to be output exactly as stored.  This is the case during
strings, verbatim constructions and numerical constants.

\yskip\hang |post_slash| means we've just output a slash.

\yskip\hang |normal| means none of the above.

\yskip\noindent Furthermore, if the variable |protect| is positive, newlines
are preceded by a `\.\\'.

@d normal 0 /* non-unusual state */
@d num_or_id 1 /* state associated with numbers and identifiers */
@d post_slash 2 /* state following a \./ */
@d unbreakable 3 /* state associated with \.{@@\&} */
@d verbatim 4 /* state in the middle of a string */

@<Global...@>=
eight_bits out_state; /* current status of partial output */
boolean protect; /* should newline characters be quoted? */

@ Here is a routine that is invoked when we want to output the current line.
During the output process, |cur_line| equals the number of the next line
to be output.

@c
void
flush_buffer() /* writes one line to output file */
{
  C_putc('\n');
  if (cur_line % 100 == 0 && show_progress) {
    printf(".");
    if (cur_line % 500 == 0) printf("%d",cur_line);
    update_terminal; /* progress report */
  }
  cur_line++;
}

@ Second, we have modified the original \.{TANGLE} so that it will write output
on multiple files.
If a section name is introduced in at least one place by \.{@@(}
instead of \.{@@<}, we treat it as the name of a file.
All these special sections are saved on a stack, |output_files|.
We write them out after we've done the unnamed section.

@d max_files 256
@<Glob...@>=
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

@ @<If it's not there, add |cur_section_name| to the output file stack, or
complain we're out of room@>=
{
  for (an_output_file=cur_out_file;
        an_output_file<end_output_files; an_output_file++)
            if (*an_output_file==cur_section_name) break;
  if (an_output_file==end_output_files) {
    if (cur_out_file>output_files)
        *--cur_out_file=cur_section_name;
    else {
      overflow("output files");
    }
  }
}

@* The big output switch.  Here then is the routine that does the
output.

@<Predecl...@>=
void phase_two();

@ %modified
@c
void
phase_two () {
  web_file_open=0;
  cur_line=1;
  @<Initialize the output stacks@>;
  @<Open the export files if necessary@>;
  @<Output macro definitions if appropriate@>;
  if (text_info->text_link==0 && cur_out_file==end_output_files) {
    printf("\n! No program text was specified."); mark_harmless;
@.No program text...@>
  }
  else {
    if(cur_out_file==end_output_files) {
      if(show_progress)
        printf("\nWriting the output file (%s):",C_file_name);
    }
    else {
      if (show_progress) {
        printf("\nWriting the output files:");
@.Writing the output...@>
        printf(" (%s)",C_file_name);
        update_terminal;
      }
      if (text_info->text_link==0) goto writeloop;
    }
    while (stack_ptr>stack) get_output();
    flush_buffer();
writeloop:   @<Write all the named output files@>;
    @<Output all exports@>;
    if(show_happiness) printf("\nDone.");
  }
  @<Close all opened export files@>;
}

@ %mine
As \.{mCTANGLE} now can handle multiple files, it has to export
datatypes, functions and variables to other translation units or
programs. This is done using header files named \.{Exp} for exported data
and \.{Shr} for data shared between different chapters of the same book.
@<Glo...@>=
char Exp_file_name[max_file_name_length];   /* name of |Exp_file| */
char Shr_file_name[max_file_name_length];   /* name of |Shr_file| */
FILE *Exp_file;
FILE *Shr_file;
FILE *Code_file; /* The one which really gets the code (former \CEE/ file) */

@ %mine
We only open the files, if their keywords have appeared during phase one.
This is indicated by the global variable |used_exports|.
Anyway, we only open temporary files
as we don't want to overwrite them if they haven't been changed
in order to save compilation time.
@<Open the export files...@>=
{
  char *cp,*pt,defname[max_file_name_length];
  if(used_exports & exp_export) {
    cp=exp_file_name_of(Exp_file_name,file_name[0],"._ex");
    if((Exp_file=fopen(Exp_file_name,"w"))==NULL)
      fatal("! Cannot open temporary output file for exports ",Exp_file_name);
    fprintf(Exp_file,"/* Book:\"%s\", Chapter %d */\n",book_name,chapter_no+1);
    strcpy(defname,cp);
    cp=file_name_ext(defname);
    if(cp) strcpy(cp,".exp");
    for(cp=defname;*cp;cp++) if(!isalnum(*cp)) *cp='_';
    fprintf(Exp_file,"#ifndef %s\n#define %s\n",defname,defname);
    chapter_to_book_exp();  /* |#include| goes to book export file */
  }
  else {
    exp_file_name_of(Exp_file_name,file_name[0],".exp");
    remove(Exp_file_name);  /* delete possible old export file */
  }
  strcpy(Shr_file_name,file_name[0]);
  pt=file_name_ext(Shr_file_name);
  if(pt) *pt=0;
  if(used_exports & exp_shared) {
    strcpy(pt,"._sh");
    if((Shr_file=fopen(Shr_file_name,"w"))==NULL)
      fatal("! Cannot open temporary output file for shared data ",Shr_file_name);
@.Cannot open temporary output file...@>
    fprintf(Shr_file,"/* Book:\"%s\", Chapter %d */\n",book_name,chapter_no+1);
    strcpy(defname,Shr_file_name);
    cp=file_name_ext(defname);
    if(cp) strcpy(cp,".shr");
    for(cp=defname;*cp;cp++) if(!isalnum(*cp)) *cp='_';
    fprintf(Shr_file,"#ifndef %s\n#define %s\n",defname,defname);
  }
  else {
    strcpy(pt,".shr");
    remove(Shr_file_name);
  }
  Code_file=C_file;       /* save the pointer to the \CEE/ file */
}

@ %mine
After phase two has completed, we close all opened temporary export files.
We keep those which have changed and destroy the others.
@<Close all opened export files@>=
if(Shr_file) {
  fprintf(Shr_file,"#endif\n");
  fclose(Shr_file);
  Shr_file=NULL;
  keep_exp_file_if_changed(".shr",Shr_file_name);  /* keep only if changed */
}
if(Exp_file) {
  fprintf(Exp_file,"#endif\n");
  fclose(Exp_file);
  Exp_file=NULL;
  keep_exp_file_if_changed(".exp",Exp_file_name);
}

@ %mine
@<Include...@>=
#include <sys/types.h>
#include <sys/stat.h>
#include <utime.h>
@^system dependencies@>

@ %mine
@<Predecl...@>=
boolean keep_exp_file_if_changed();

@ %mine
We only keep the temporary export file, if it has changed.
Doing so, we can reduce the turnaround time since rewriting the export
files all the time would cause \.{make} to translate the whole project
even if we only changed a single line in our \.{CWEB} file.

The following function tests, if there are any differences
between the just created temporary file |tmpname| and a possibly existing
export file with the same name as |tmpname| but with the
file extension |suffix|.

If so, it deletes the old export file and keeps the temporary export file.
If there are no differences or the files only differ in \&{\#line} statements
or comments, which have no influence on the contents of the file itself,
the temporary file gets the date of the old export file and takes its place.

All comments in the file are written by \.{mCTANGLE} itself so we know
that each comment exactly takes one line and starts at the first column.
These comments tell \.{mCWEAVE} where the various parts of the export file
came from. This is the reason why we always want to keep the new temporary
export file and only decide whether to restore the original modification
date. We want to have the comments up to date in order to have \.{mCWEAVE}
make proper references.
@^system dependencies@>
@c
boolean
keep_exp_file_if_changed(suffix,tmpname)
  char *suffix;
  char *tmpname;
{
  char expname[max_file_name_length],*cp;
  FILE *fp,*tmp;
  char *c1,*c2;
  char buffer[2][128];
  struct stat s;
  struct utimbuf u;

  strcpy(expname,tmpname);
  cp=file_name_ext(expname);
  if(cp) *cp=0;  /* remove old extension */
  strcat(expname,suffix);
  buffer[0][sizeof(buffer[0])-1]=buffer[1][sizeof(buffer[0])-1]='\0';
  if((fp=fopen(expname,"r"))!=NULL) {
    if((tmp=fopen(tmpname,"r"))==NULL) fatal("! Cannot reopen output file for input:",tmpname);
@.Cannot reopen output file...@>
    do {
      c1=fgets(buffer[0],sizeof(buffer[0])-1,tmp);
      c2=fgets(buffer[1],sizeof(buffer[1])-1,fp);
      if(c1==NULL || c2==NULL) break;		/* end of file */
    } while(strcmp(buffer[0],buffer[1])==0 ||
	    (strncmp(buffer[0],"#line",5)==0 && strncmp(buffer[1],"#line",5)==0) ||
	    (strncmp(buffer[0],"/*",2)==0 && strncmp(buffer[1],"/*",2)==0));
    fclose(tmp);
    fclose(fp);
    if(c1==NULL && c2==NULL) {	/* file did not change */
      stat(expname,&s);        /* save file date */
      remove(expname);         /* remove old file */
      rename(tmpname,expname); /* new file becomes export file */
      u.actime=s.st_atime;
      u.modtime=s.st_mtime;
      utime(expname,&u);       /* reset file date */
      return 0;
    }
    remove(expname);
  }	/* file has changed or did not exist */
  rename(tmpname,expname);
  printf("\nExport file written: %s",expname);
@.Export file written...@>
  return 1;
}

@ To write the named output files, we proceed as for unnamed
sections.
The only subtlety is that we have to open each one.

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
    set_cur_end();
    while (stack_ptr > stack) get_output();
    flush_buffer();
}

@ If a \.{@@h} was not encountered in the input,
we go through the list of replacement texts and copy the ones
that refer to macros, preceded by the \.{\#define} preprocessor command.

@<Output macro definitions if appropriate@>=
  if (!output_defs_seen)
    output_defs();

@ %modified
In shared and export files there will be a comment along with the macro
definitions that gives us the section number the macro was defined in.
This is required by \.{mCWEAVE}. Since we do not want to output the comment
every time we output a definition, we keep track of the last section number
we have written to our shared and export files in
|exp_last_def_section_comment| and |shr_last_def_section_comment|,
respectively.
@<Glob...@>=
boolean output_defs_seen=0;
int exp_last_def_section_comment;
int shr_last_def_section_comment;

@ %mine
@<Set init...@>=
output_defs_seen=0;
exp_last_def_section_comment=0;   /* no comment with section number written so far */
shr_last_def_section_comment=0;

@ @<Predecl...@>=
void output_defs();

@ %modified
The definitions may be preceded by a comment containing the section number
where they have been defined.
After this comment, we may find some export keywords
which indicate where to export the macro.

When we output the macro definitions we also append the |#include|
statements for the export files.
@c
void
output_defs()
{
  sixteen_bits where,a;
  int line_no;
  eight_bits *cp;
  char comment[20],*com;

  @<Output a constant with the same name as |C_file_name|@>;

  push_level(NULL);
  for (cur_text=text_info+1; cur_text<text_ptr; cur_text++)
    if (cur_text->text_link==0) { /* |cur_text| is the text for a macro */
      cp=cur_text->tok_start;
      *comment=0;
      if(!strncmp(cp,"\03/*",3)) { /* introduced by comment containing section number */
	com=comment;
	while(*++cp!=constant) *com++=*cp;
	*com=0;
	++cp;
      }
      where=0;           /* where to output the definitions */
      while(*cp==special_command) { /* this macro was preceded by an export command */
	if(*++cp>=0200) {
	  a=((*cp-0200)<<8)+cp[1];
	  switch(a) {
	  case id_global:
	    where|=exp_global;
	    break;
	  case id_export:
	    where|=exp_export;
	    break;
	  case id_shared:
	    where|=exp_shared;
	    break;
	  }
	  cp+=2;  /* skip export command */
	}
      }
      if(where & exp_export) {
	@<Write definitions to export file@>;
      }
      if(where & exp_shared) {
	@<Write definitions to shared file@>;
      }
      else {
	C_file=Code_file;       /* write to ordinary \CEE/ file */
	write_def(cp);
      }
      C_file=Code_file;
    }
  @<Output direct import |#include|s@>;
  @<Output include for own shared@>;
  @<Output global stuff and all variables@>;
}

@ If we saw an \&{export} command after the optional comment,
we have to write it to the |Exp_file|. If there is a comment and if
the section number contained in it is not the same as the last one written
to the export file, we also output the comment.
@<Write definitions to exp...@>=
{
  line_no=cur_line;  /* don't count lines, we will write it again (\CEE/ or shared file) */
  C_file=Exp_file;
  if(*comment) {  /* also write comment, if different from last one written */
    int sec_no;
    sscanf(comment+10,"%d",&sec_no);
    if(sec_no>exp_last_def_section_comment) {
      C_printf("%s",comment);
      flush_buffer();
      exp_last_def_section_comment=sec_no;
    }
  }
  write_def(cp);		/* write definition to export file */
  cur_line=line_no;
}

@
@<Write definitions to shared...@>=
{
  C_file=Shr_file;
  if(*comment) {
    int sec_no;
    sscanf(comment+10,"%d",&sec_no);
    if(sec_no>shr_last_def_section_comment) {
      C_printf("%s",comment);
      flush_buffer();
      shr_last_def_section_comment=sec_no;
    }
  }
  write_def(cp);    /* write it to shared file */
}

@ %mine
Every chapter automatically knows about its own shared stuff, so
we have to include our chapter's own shared file.
@<Output include for own shared@>=
{
  char expname[max_file_name_length];
  char *dot;

  if(used_exports & exp_shared) {
    strcpy(expname,Shr_file_name);
    dot=file_name_ext(expname);
    if(dot) *dot=0;
    strcat(expname,".shr");
    C_printf("#include \"%s\"",expname);
    flush_buffer();
  }
  pop_level(0);
}

@ @<Predecl...@>=
void write_def();

@ %moved
Write the definition starting at |tok| to |C_file|.
@c
void write_def(tok)
eight_bits *tok;
{
  sixteen_bits a;
  cur_byte=tok;
  cur_end=(cur_text+1)->tok_start;
  C_printf("%s","#define ");
  out_state=normal;
  protect=1; /* newlines should be preceded by |'\\'| */
  while (cur_byte<cur_end) {
    a=*cur_byte++;
    if (cur_byte==cur_end && a=='\n') break; /* disregard a final newline */
    if (out_state==verbatim && a!=string && a!=constant && a!='\n')
      C_putc(a); /* a high-bit character can occur in a string */
    @^high-bit character handling@>
    else if (a<0200) out_char(a); /* one-byte token */
    else {
      a=(a-0200)*0400+*cur_byte++;
      if (a<024000) { /* |024000==(0250-0200)*0400| */
	cur_val=a; out_char(identifier);
      }
      else if (a<050000) { confusion("macro defs have strange char");}
      else {
	cur_val=a-050000; cur_section=cur_val; out_char(section_number);
      }
      /* no other cases */
    }
  }
  protect=0;
  flush_buffer();
}

@
@<Glo...@>=
char file_name_constant[max_file_name_length];
sixteen_bits id_file_name_constant;

@ Since we don't want to have the compiler read our export files
more than once, we protect our files with preprocessor constants.
There is a constant defined at the beginning of each
export file which gets set when the file is read by the compiler and
is checked at the very beginning.\smallskip

\8\#\&{ifndef} \.{FILE\_NAME}\6
\8\#\&{define} \.{FILE\_NAME}\6
\hbox{\dots}\6
\8\#\&{endif}\par
\smallskip\noindent
In order to do so, we have to convert the |C_file_name| into a constant
|file_name_constant| with no special characters.
@<Create file name constant@>=
{
  char *cp,*fn;

  cp=C_file_name;  /* create a valid constant of the filename */
  fn=file_name_constant;
  do {
    if(isalnum(*cp)) *fn=*cp;
    else *fn='_';        /* nonalpha characters become \.{\UL} */
    cp++;
    fn++;
  } while(*cp);
  *fn='\0';
  id_file_name_constant=id_lookup(file_name_constant,fn,0)-name_dir;
}

@
@<Output a constant with ...@>=
{
  C_printf("#define %s",file_name_constant); flush_buffer(); /* define constant */
}

@ @<Include...@>=
#include <stddef.h>

@ %mine
As we will see in the section about export commands, we have a lot of
information that goes to the \CEE/ file. This includes variables,
\&{global} datatypes and \&{global} declarations.

|push_export_section| outputs this information which was gathered
during pass one. Since this is a stack, the topmost section will
appear first in the file.
We will talk about export sections in more detail when we will be
treating export commands.
@<Output global stuff and all variables@>=
{
  int i;
  push_export_section(&var_sec);
  var_sec.first_text=var_sec.last_text=NULL; /* only output variables once */
  for(i=num_export_sections-1;i>=0;i--)
    push_export_section(&glb_sec[i]);
}

@ A many-way switch is used to send the output.  Note that this function
is not called if |out_state==verbatim|, except perhaps with arguments
|'\n'| (protect the newline), |string| (end the string), or |constant|
(end the constant).

@<Predecl...@>=
static void out_char();

@ %modified
@c
static void
out_char(cur_char)
eight_bits cur_char;
{
  char *j, *k; /* pointer into |byte_mem| */
restart:
    switch (cur_char) {
      case '\n': if (protect) C_putc(' ');
        if (protect || out_state==verbatim) C_putc('\\');
        flush_buffer(); if (out_state!=verbatim) out_state=normal; break;
      @/@t\4@>@<Case of an identifier@>;
      @/@t\4@>@<Case of a section number@>;
      @/@t\4@>@<Cases like \.{!=}@>;
      case '=': C_putc('='); C_putc(' '); out_state=normal; break;
      case join: out_state=unbreakable; break;
      case constant: if (out_state==verbatim) {
          out_state=num_or_id; break;
        }
        if(out_state==num_or_id) C_putc(' '); out_state=verbatim; break;
      case string: if (out_state==verbatim) out_state=normal;
        else out_state=verbatim; break;
      case ignore: break;
      case '/': C_putc('/'); out_state=post_slash; break;
      case '*': if (out_state==post_slash) C_putc(' ');
        /* fall through */
      default: C_putc(cur_char); out_state=normal; break;
    }
}

@ @<Cases like \.{!=}@>=
case plus_plus: C_putc('+'); C_putc('+'); out_state=normal; break;
case minus_minus: C_putc('-'); C_putc('-'); out_state=normal; break;
case minus_gt: C_putc('-'); C_putc('>'); out_state=normal; break;
case gt_gt: C_putc('>'); C_putc('>'); out_state=normal; break;
case eq_eq: C_putc('='); C_putc('='); out_state=normal; break;
case lt_lt: C_putc('<'); C_putc('<'); out_state=normal; break;
case gt_eq: C_putc('>'); C_putc('='); out_state=normal; break;
case lt_eq: C_putc('<'); C_putc('='); out_state=normal; break;
case not_eq: C_putc('!'); C_putc('='); out_state=normal; break;
case and_and: C_putc('&'); C_putc('&'); out_state=normal; break;
case or_or: C_putc('|'); C_putc('|'); out_state=normal; break;
case dot_dot_dot: C_putc('.'); C_putc('.'); C_putc('.'); out_state=normal;
    break;
case colon_colon: C_putc(':'); C_putc(':'); out_state=normal; break;
case period_ast: C_putc('.'); C_putc('*'); out_state=normal; break;
case minus_gt_ast: C_putc('-'); C_putc('>'); C_putc('*'); out_state=normal;
    break;

@ When an identifier is output to the \CEE/ file, characters in the
range 128--255 must be changed into something else, so the \CEE/
compiler won't complain.  By default, \.{CTANGLE} converts the
character with code $16 x+y$ to the three characters `\.X$xy$', but
a different transliteration table can be specified.  Thus a German
might want {\it gr\"un\/} to appear as a still readable \.{gruen}.
This makes debugging a lot less confusing.

@d translit_length 10

@<Glo...@>=
char translit[128][translit_length];

@ @<Set init...@>=
{
  int i;
  for (i=0;i<128;i++) sprintf(translit[i],"X%02X",(unsigned)(128+i));
}

@ @<Case of an identifier@>=
case identifier:
  if (out_state==num_or_id) C_putc(' ');
  j=(cur_val+name_dir)->byte_start;
  k=(cur_val+name_dir+1)->byte_start;
  while (j<k) {
    if ((unsigned char)(*j)<0200) C_putc(*j);
@^high-bit character handling@>
    else C_printf("%s",translit[(unsigned char)(*j)-0200]);
    j++;
  }
  out_state=num_or_id; break;

@ @<Case of a sec...@>=
case section_number:
  if (cur_val>0) C_printf("/*%d:*/",cur_val);
  else if(cur_val<0) C_printf("/*:%d*/",-cur_val);
  else if (protect) {
    cur_byte +=4; /* skip line number and file name */
    cur_char = '\n';
    goto restart;
  } else {
    sixteen_bits a;
    a=0400* *cur_byte++;
    a+=*cur_byte++; /* gets the line number */
    C_printf("\n#line %d \"",a);
@:line}{\.{\#line}@>
    cur_val=*cur_byte++;
    cur_val=0400*(cur_val-0200)+ *cur_byte++; /* points to the file name */
    for (j=(cur_val+name_dir)->byte_start, k=(cur_val+name_dir+1)->byte_start;
         j<k; j++) C_putc(*j);
    C_printf("%s","\"\n");
  }
  break;

@** Introduction to the input phase.
We have now seen that \.{CTANGLE} will be able to output the full
\CEE/ program, if we can only get that program into the byte memory in
the proper format. The input process is something like the output process
in reverse, since we compress the text as we read it in and we expand it
as we write it out.

There are three main input routines. The most interesting is the one that gets
the next token of a \CEE/ text; the other two are used to scan rapidly past
\TEX/ text in the \.{CWEB} source code. One of the latter routines will jump to
the next token that starts with `\.{@@}', and the other skips to the end
of a \CEE/ comment.

@ Control codes in \.{CWEB} begin with `\.{@@}', and the next character
identifies the code. Some of these are of interest only to \.{CWEAVE},
so \.{CTANGLE} ignores them; the others are converted by \.{CTANGLE} into
internal code numbers by the |ccode| table below. The ordering
of these internal code numbers has been chosen to simplify the program logic;
larger numbers are given to the control codes that denote more significant
milestones.

@d ignore 0 /* control code of no interest to \.{CTANGLE} */
@d special_command 0301 /* control code for special commands introduces by '\.{@@$\_$}' */
@d ord 0302 /* control code for `\.{@@'}' */
@d control_text 0303 /* control code for `\.{@@t}', `\.{@@\^}', etc. */
@d translit_code 0304 /* control code for `\.{@@l}' */
@d output_defs_code 0305 /* control code for `\.{@@h}' */
@d format_code 0306 /* control code for `\.{@@f}' */
@d definition 0307 /* control code for `\.{@@d}' */
@d begin_C 0310 /* control code for `\.{@@c}' */
@d section_name 0311 /* control code for `\.{@@<}' */
@d new_section 0312 /* control code for `\.{@@\ }' and `\.{@@*}' */

@<Global...@>=
eight_bits ccode[256]; /* meaning of a char following \.{@@} */

@ @<Set ini...@>= {
  int c; /* must be |int| so the |for| loop will end */
  for (c=0; c<256; c++) ccode[c]=ignore;
  ccode[' ']=ccode['\t']=ccode['\n']=ccode['\v']=ccode['\r']=ccode['\f']
   =ccode['*']=new_section;
  ccode['@@']='@@'; ccode['=']=string;
  ccode['d']=ccode['D']=definition;
  ccode['f']=ccode['F']=ccode['s']=ccode['S']=format_code;
  ccode['c']=ccode['C']=ccode['p']=ccode['P']=begin_C;
  ccode['^']=ccode[':']=ccode['.']=ccode['t']=ccode['T']=
   ccode['q']=ccode['Q']=control_text;
  ccode['h']=ccode['H']=output_defs_code;
  ccode['l']=ccode['L']=translit_code;
  ccode['&']=join;
  ccode['<']=ccode['(']=section_name;
  ccode['\'']=ord;
  ccode['_']=special_command;
}

@ The |skip_ahead| procedure reads through the input at fairly high speed
until finding the next non-ignorable control code, which it returns.

@c
eight_bits
skip_ahead() /* skip to next control code */
{
  eight_bits c; /* control code found */
  while (1) {
    if (loc>limit && (get_line()==0)) return(new_section);
    *(limit+1)='@@';
    while (*loc!='@@') loc++;
    if (loc<=limit) {
      loc++; c=ccode[(eight_bits)*loc]; loc++;
      if (c!=ignore || *(loc-1)=='>') return(c);
    }
  }
}

@ The |skip_comment| procedure reads through the input at somewhat high
speed in order to pass over comments, which \.{CTANGLE} does not transmit
to the output. If the comment is introduced by \.{/*}, |skip_comment|
proceeds until finding the end-comment token \.{*/} or a newline; in the
latter case |skip_comment| will be called again by |get_next|, since the
comment is not finished.  This is done so that the each newline in the
\CEE/ part of a section is copied to the output; otherwise the \&{\#line}
commands inserted into the \CEE/ file by the output routines become useless.
On the other hand, if the comment is introduced by \.{//} (i.e., if it
is a \CPLUSPLUS/ ``short comment''), it always is simply delimited by the next
newline. The boolean argument |is_long_comment| distinguishes between
the two types of comments.

If |skip_comment| comes to the end of the section, it prints an error message.
No comment, long or short, is allowed to contain `\.{@@\ }' or `\.{@@*}'.

@<Global...@>=
boolean comment_continues=0; /* are we scanning a comment? */

@ %mine
@<Set init...@>=
comment_continues=0;

@ @c
int skip_comment(is_long_comment) /* skips over comments */
boolean is_long_comment;
{
  char c; /* current character */
  while (1) {
    if (loc>limit) {
      if (is_long_comment) {
        if(get_line()) return(comment_continues=1);
        else{
          err_print("! Input ended in mid-comment");
@.Input ended in mid-comment@>
          return(comment_continues=0);
        }
      }
      else return(comment_continues=0);
    }
    c=*(loc++);
    if (is_long_comment && c=='*' && *loc=='/') {
      loc++; return(comment_continues=0);
    }
    if (c=='@@') {
      if (ccode[(eight_bits)*loc]==new_section) {
        err_print("! Section name ended in mid-comment"); loc--;
@.Section name ended in mid-comment@>
        return(comment_continues=0);
      }
      else loc++;
    }
  }
}

@* Inputting the next token.

@d constant 03

@<Global...@>=
name_pointer cur_section_name; /* name of section just scanned */
int no_where; /* suppress |print_where|? */

@ @<Include...@>=
#include <ctype.h> /* definition of |isalpha|, |isdigit| and so on */
#include <stdlib.h> /* definition of |exit| */

@ As one might expect, |get_next| consists mostly of a big switch
that branches to the various special cases that can arise.

@d isxalpha(c) ((c)=='_') /* non-alpha character allowed in identifier */
@d ishigh(c) ((unsigned char)(c)>0177)
@^high-bit character handling@>

@c
eight_bits
get_next() /* produces the next input token */
{
  static int preprocessing=0;
  eight_bits c; /* the current character */
  while (1) {
    if (loc>limit) {
      if (preprocessing && *(limit-1)!='\\') preprocessing=0;
      if (get_line()==0) return(new_section);
      else if (print_where && !no_where) {
          print_where=0;
          @<Insert the line number into |tok_mem|@>;
        }
        else return ('\n');
    }
    c=*loc;
    if (comment_continues || (c=='/' && (*(loc+1)=='*' || *(loc+1)=='/'))) {
      skip_comment(comment_continues||*(loc+1)=='*');
          /* scan to end of comment or newline */
      if (comment_continues) return('\n');
      else continue;
    }
    loc++;
    if (xisdigit(c) || c=='\\' || c=='.') @<Get a constant@>@;
    else if (c=='\'' || c=='"' || (c=='L'&&(*loc=='\'' || *loc=='"')))
        @<Get a string@>@;
    else if (isalpha(c) || isxalpha(c) || ishigh(c))
      @<Get an identifier@>@;
    else if (c=='@@') @<Get control code and possible section name@>@;
    else if (xisspace(c)) {
        if (!preprocessing || loc>limit) continue;
          /* we don't want a blank after a final backslash */
        else return(' '); /* ignore spaces and tabs, unless preprocessing */
    }
    else if (c=='#' && loc==buffer+1) preprocessing=1;
    mistake: @<Compress two-symbol operator@>@;
    return(c);
  }
}

@ The following code assigns values to the combinations \.{++},
\.{--}, \.{->}, \.{>=}, \.{<=}, \.{==}, \.{<<}, \.{>>}, \.{!=}, \.{||} and
\.{\&\&}, and to the \CPLUSPLUS/
combinations \.{...}, \.{::}, \.{.*} and \.{->*}.
The compound assignment operators (e.g., \.{+=}) are
treated as separate tokens.

@d compress(c) if (loc++<=limit) return(c)

@<Compress tw...@>=
switch(c) {
  case '+': if (*loc=='+') compress(plus_plus); break;
  case '-': if (*loc=='-') {compress(minus_minus);}
    else if (*loc=='>') if (*(loc+1)=='*') {loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); break;
  case '.': if (*loc=='*') {compress(period_ast);}
            else if (*loc=='.' && *(loc+1)=='.') {
              loc++; compress(dot_dot_dot);
            }
            break;
  case ':': if (*loc==':') compress(colon_colon); break;
  case '=': if (*loc=='=') compress(eq_eq); break;
  case '>': if (*loc=='=') {compress(gt_eq);}
    else if (*loc=='>') compress(gt_gt); break;
  case '<': if (*loc=='=') {compress(lt_eq);}
    else if (*loc=='<') compress(lt_lt); break;
  case '&': if (*loc=='&') compress(and_and); break;
  case '|': if (*loc=='|') compress(or_or); break;
  case '!': if (*loc=='=') compress(not_eq); break;
}

@ @<Get an identifier@>= {
  id_first=--loc;
  while (isalpha(*++loc) || isdigit(*loc) || isxalpha(*loc) || ishigh(*loc));
  id_loc=loc; return(identifier);
}

@ @<Get a constant@>= {
  id_first=loc-1;
  if (*id_first=='.' && !xisdigit(*loc)) goto mistake; /* not a constant */
  if (*id_first=='\\') while (xisdigit(*loc)) loc++; /* octal constant */
  else {
    if (*id_first=='0') {
      if (*loc=='x' || *loc=='X') { /* hex constant */
        loc++; while (xisxdigit(*loc)) loc++; goto found;
      }
    }
    while (xisdigit(*loc)) loc++;
    if (*loc=='.') {
    loc++;
    while (xisdigit(*loc)) loc++;
    }
    if (*loc=='e' || *loc=='E') { /* float constant */
      if (*++loc=='+' || *loc=='-') loc++;
      while (xisdigit(*loc)) loc++;
    }
  }
  found: while (*loc=='u' || *loc=='U' || *loc=='l' || *loc=='L'
             || *loc=='f' || *loc=='F') loc++;
  id_loc=loc;
  return(constant);
}

@ \CEE/ strings and character constants, delimited by double and single
quotes, respectively, can contain newlines or instances of their own
delimiters if they are protected by a backslash.  We follow this
convention, but do not allow the string to be longer than |longest_name|.

@<Get a string@>= {
  char delim = c; /* what started the string */
  id_first = section_text+1;
  id_loc = section_text; *++id_loc=delim;
  if (delim=='L') { /* wide character constant */
    delim=*loc++; *++id_loc=delim;
  }
  while (1) {
    if (loc>=limit) {
      if(*(limit-1)!='\\') {
        err_print("! String didn't end"); loc=limit; break;
@.String didn't end@>
      }
      if(get_line()==0) {
        err_print("! Input ended in middle of string"); loc=buffer; break;
@.Input ended in middle of string@>
      }
      else if (++id_loc<=section_text_end) *id_loc='\n'; /* will print as
      \.{"\\\\\\n"} */
    }
    if ((c=*loc++)==delim) {
      if (++id_loc<=section_text_end) *id_loc=c;
      break;
    }
    if (c=='\\') {
      if (loc>=limit) continue;
      if (++id_loc<=section_text_end) *id_loc = '\\';
      c=*loc++;
    }
    if (++id_loc<=section_text_end) *id_loc=c;
  }
  if (id_loc>=section_text_end) {
    printf("\n! String too long: ");
@.String too long@>
    term_write(section_text+1,25);
    err_print("...");
  }
  id_loc++;
  return(string);
}

@ After an \.{@@} sign has been scanned, the next character tells us
whether there is more work to do.

@<Get control code and possible section name@>= {
  c=ccode[(eight_bits)*loc++];
  switch(c) {
    case ignore: continue;
    case output_defs_code: output_defs_seen=1; return(c);
    case translit_code: err_print("! Use @@l in limbo only"); continue;
@.Use @@l in limbo...@>
    case control_text: while ((c=skip_ahead())=='@@');
      /* only \.{@@@@} and \.{@@>} are expected */
      if (*(loc-1)!='>')
        err_print("! Double @@ should be used in control text");
@.Double @@ should be used...@>
      continue;
    case section_name:
      cur_section_name_char=*(loc-1);
      @<Scan the section name and make |cur_section_name| point to it@>;
    case string: @<Scan a verbatim string@>;
    case ord: @<Scan an ASCII constant@>;
    default: return(c);
  }
}

@ After scanning a valid ASCII constant that follows
\.{@@'}, this code plows ahead until it finds the next single quote.
(Special care is taken if the quote is part of the constant.)
Anything after a valid ASCII constant is ignored;
thus, \.{@@'\\nopq'} gives the same result as \.{@@'\\n'}.

@<Scan an ASCII constant@>=
  id_first=loc;
  if (*loc=='\\') {
    if (*++loc=='\'') loc++;
  }
  while (*loc!='\'') {
    if (*loc=='@@') {
      if (*(loc+1)!='@@')
        err_print("! Double @@ should be used in ASCII constant");
@.Double @@ should be used...@>
      else loc++;
    }
    loc++;
    if (loc>limit) {
        err_print("! String didn't end"); loc=limit-1; break;
@.String didn't end@>
    }
  }
  loc++;
  return(ord);

@ @<Scan the section name...@>= {
  char *k; /* pointer into |section_text| */
  @<Put section name into |section_text|@>;
  if (k-section_text>3 && strncmp(k-2,"...",3)==0)
    cur_section_name=section_lookup(section_text+1,k-3,1); /* 1 means is a prefix */
  else cur_section_name=section_lookup(section_text+1,k,0);
  if (cur_section_name_char=='(')
    @<If it's not there, add |cur_section_name| to the output file stack, or
          complain we're out of room@>;
  return(section_name);
}

@ Section names are placed into the |section_text| array with consecutive spaces,
tabs, and carriage-returns replaced by single spaces. There will be no
spaces at the beginning or the end. (We set |section_text[0]=' '| to facilitate
this, since the |section_lookup| routine uses |section_text[1]| as the first
character of the name.)

@<Set init...@>=section_text[0]=' ';

@ @<Put section name...@>=
k=section_text;
while (1) {
  if (loc>limit && get_line()==0) {
    err_print("! Input ended in section name");
@.Input ended in section name@>
    loc=buffer+1; break;
  }
  c=*loc;
  @<If end of name or erroneous nesting, |break|@>;
  loc++; if (k<section_text_end) k++;
  if (xisspace(c)) {
    c=' '; if (*(k-1)==' ') k--;
  }
*k=c;
}
if (k>=section_text_end) {
  printf("\n! Section name too long: ");
@.Section name too long@>
  term_write(section_text+1,25);
  printf("..."); mark_harmless;
}
if (*k==' ' && k>section_text) k--;

@ @<If end of name or erroneous nesting,...@>=
if (c=='@@') {
  c=*(loc+1);
  if (c=='>') {
    loc+=2; break;
  }
  if (ccode[(eight_bits)c]==new_section) {
    err_print("! Section name didn't end"); break;
@.Section name didn't end@>
  }
  if (ccode[(eight_bits)c]==section_name) {
    err_print("! Nesting of section names not allowed"); break;
@.Nesting of section names...@>
  }
  *(++k)='@@'; loc++; /* now |c==*loc| again */
}

@ At the present point in the program we
have |*(loc-1)==string|; we set |id_first| to the beginning
of the string itself, and |id_loc| to its ending-plus-one location in the
buffer.  We also set |loc| to the position just after the ending delimiter.

@<Scan a verbatim string@>= {
  id_first=loc++; *(limit+1)='@@'; *(limit+2)='>';
  while (*loc!='@@' || *(loc+1)!='>') loc++;
  if (loc>=limit) err_print("! Verbatim string didn't end");
@.Verbatim string didn't end@>
  id_loc=loc; loc+=2;
  return(string);
}

@* Scanning a macro definition.
The rules for generating the replacement texts corresponding to macros and
\CEE/ texts of a section are almost identical; the only differences are that

\yskip \item{a)}Section names are not allowed in macros;
in fact, the appearance of a section name terminates such macros and denotes
the name of the current section.

\item{b)}The symbols \.{@@d} and \.{@@f} and \.{@@c} are not allowed after
section names, while they terminate macro definitions.

\item{c)}Spaces are inserted after right parentheses in macros, because the
ANSI \CEE/ preprocessor sometimes requires it.

\yskip Therefore there is a single procedure |scan_repl| whose parameter
|t| specifies either |macro| or |section_name|. After |scan_repl| has
acted, |cur_text| will point to the replacement text just generated, and
|next_control| will contain the control code that terminated the activity.

@d macro  0
@d app_repl(c)  {if (tok_ptr==tok_mem_end) overflow("token"); *tok_ptr++=c;}

@<Global...@>=
text_pointer cur_text; /* replacement text formed by |scan_repl| */
eight_bits next_control;

@ @c
void
scan_repl(t) /* creates a replacement text */
eight_bits t;
{
  sixteen_bits a; /* the current token */
  if (t==section_name) {@<Insert the line number into |tok_mem|@>;}
  while (1) switch (a=get_next()) {
  got_next_one:
      @<In cases that |a| is a non-|char| token (|identifier|,
        |section_name|, etc.), either process it and change |a| to a byte
        that should be stored, or |continue| if |a| should be ignored,
        or |goto done| if |a| signals the end of this replacement text@>@;
      case ')': app_repl(a);
        if (t==macro) app_repl(' ');
        break;
      default: app_repl(a); /* store |a| in |tok_mem| */
    }
  done: next_control=(eight_bits) a;
  if (text_ptr>text_info_end) overflow("text");
  cur_text=text_ptr; (++text_ptr)->tok_start=tok_ptr;
}

@ Here is the code for the line number: first a |sixteen_bits| equal
to |0150000|; then the numeric line number; then a pointer to the
file name.

@<Insert the line...@>=
store_two_bytes(0150000);
if (changing) id_first=change_file_name;
else id_first=cur_file_name;
id_loc=id_first+strlen(id_first);
if (changing) store_two_bytes((sixteen_bits)change_line);
else store_two_bytes((sixteen_bits)cur_line);
{int a=id_lookup(id_first,id_loc,0)-name_dir; app_repl((a / 0400)+0200);
  app_repl(a % 0400);}

@ @<In cases that |a| is...@>=
case special_command:
  a=get_next();
  @<Special command seen in \CEE/ text@>;
  goto got_next_one;   /* already holding next token */
case identifier: a=id_lookup(id_first,id_loc,0)-name_dir;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400);
  break;
case section_name: if (t!=section_name) goto done;
  else {
    @<Was an `@@' missed here?@>;
    a=cur_section_name-name_dir;
    app_repl((a / 0400)+0250);
    app_repl(a % 0400);
    @<Insert the line number into |tok_mem|@>; break;
  }
case output_defs_code:
  a=output_defs_flag;
  app_repl((a / 0400)+0200);
  app_repl(a % 0400);
  @<Insert the line number into |tok_mem|@>; break;
case constant: case string:
  @<Copy a string or verbatim construction or numerical constant@>;
case ord:
  @<Copy an ASCII constant@>;
case definition: case format_code: case begin_C: if (t!=section_name) goto done;
  else {
    err_print("! @@d, @@f and @@c are ignored in C text"); continue;
@.@@d, @@f and @@c are ignored in C text@>
  }
case new_section: goto done;

@ %mine
A special command introduced by \.{@@\_} was seen while scanning
the \CEE/ text of a section. If it's an export statement like \&{global},
we remember it, so that we can parse the following declaration when we
reach the end of the section.
The same applies to import commands like \&{import}.
@<Special command seen in \CEE/ text@>=
{
  if(a==identifier) {
    a=id_lookup(id_first,id_loc,0)-name_dir;
    if(id_global<=a && a<=id_shared) {
      remember_export(a);
      break;
    }
    else if(id_import==a || a==id_from) {
      remember_import();
      app_repl((a / 0400)+0200);
      app_repl(a % 0400);
      break;
    }
    else if(id_mark==a || id_paste==a) { /* ignore it and the string following */
      a=get_next();
      if(a==string) break;
    }
    if(id_copy==a) break; /* ignore it */
  }
  err_print("! Illegal special command");
}

@ @<Was an `@@'...@>= {
  char *try_loc=loc;
  while (*try_loc==' ' && try_loc<limit) try_loc++;
  if (*try_loc=='+' && try_loc<limit) try_loc++;
  while (*try_loc==' ' && try_loc<limit) try_loc++;
  if (*try_loc=='=') err_print ("! Missing `@@ ' before a named section");
@.Missing `@@ '...@>
  /* user who isn't defining a section should put newline after the name,
     as explained in the manual */
}

@ @<Copy a string...@>=
  app_repl(a); /* |string| or |constant| */
  while (id_first < id_loc) { /* simplify \.{@@@@} pairs */
    if (*id_first=='@@') {
      if (*(id_first+1)=='@@') id_first++;
      else err_print("! Double @@ should be used in string");
@.Double @@ should be used...@>
    }
    app_repl(*id_first++);
  }
  app_repl(a); break;

@ This section should be rewritten on machines that don't use ASCII
code internally.
@^ASCII code dependencies@>

@<Copy an ASCII constant@>= {
  int c=(eight_bits) *id_first;
  if (c=='\\') {
    c=*++id_first;
    if (c>='0' && c<='7') {
      c-='0';
      if (*(id_first+1)>='0' && *(id_first+1)<='7') {
        c=8*c+*(++id_first) - '0';
        if (*(id_first+1)>='0' && *(id_first+1)<='7' && c<32)
          c=8*c+*(++id_first)- '0';
      }
    }
    else switch (c) {
    case 't':c='\t';@+break;
    case 'n':c='\n';@+break;
    case 'b':c='\b';@+break;
    case 'f':c='\f';@+break;
    case 'v':c='\v';@+break;
    case 'r':c='\r';@+break;
    case 'a':c='\7';@+break;
    case '?':c='?';@+break;
    case 'x':
      if (xisdigit(*(id_first+1))) c=*(++id_first)-'0';
      else if (xisxdigit(*(id_first+1))) {
        ++id_first;
        c=toupper(*id_first)-'A'+10;
      }
      if (xisdigit(*(id_first+1))) c=16*c+*(++id_first)-'0';
      else if (xisxdigit(*(id_first+1))) {
        ++id_first;
        c=16*c+toupper(*id_first)-'A'+10;
      }
      break;
    case '\\':c='\\';@+break;
    case '\'':c='\'';@+break;
    case QUOTE:c=QUOTE;@+break;
    default: err_print("! Unrecognized escape sequence");
@.Unrecognized escape sequence@>
    }
  }@/
  /* at this point |c| should have been converted to its ASCII code number */
  app_repl(constant);
  if (c>=100) app_repl('0'+c/100);
  if (c>=10) app_repl('0'+(c/10)%10);
  app_repl('0'+c%10);
  app_repl(constant);
}
break;

@* Scanning a section.
The |scan_section| procedure starts when `\.{@@\ }' or `\.{@@*}' has been
sensed in the input, and it proceeds until the end of that section.  It
uses |section_count| to keep track of the current section number; with luck,
\.{CWEAVE} and \.{CTANGLE} will both assign the same numbers to sections.

@<Global...@>=
extern sixteen_bits section_count; /* the current section number */

@ The body of |scan_section| is a loop where we look for control codes
that are significant to \.{CTANGLE}: those
that delimit a definition, the \CEE/ part of a module, or a new module.

@c
void
scan_section()
{
  name_pointer p; /* section name for the current section */
  text_pointer q; /* text for the current section */
  sixteen_bits a; /* token for left-hand side of definition */
  section_count++; @+ no_where=1;
  if (*(loc-1)=='*' && show_progress) { /* starred section */
    printf("*%d",section_count); update_terminal;
  }
  next_control=0;
  while (1) {
    @<Skip ahead until |next_control| corresponds to \.{@@d}, \.{@@<},
      \.{@@\ } or the like@>;
    if (next_control == definition) {  /* \.{@@d} */
        @<Scan a definition@>@;
        continue;
    }
    if (next_control == begin_C) {  /* \.{@@c} or \.{@@p} */
      p=name_dir; break;
    }
    if (next_control == section_name) { /* \.{@@<} or \.{@@(} */
      p=cur_section_name;
      @<If section is not being defined, |continue| @>;
      break;
    }
    return; /* \.{@@\ } or \.{@@*} */
  }
  no_where=print_where=0;
  @<Scan the \CEE/ part of the current section@>;
}

@ At the top of this loop, if |next_control==section_name|, the
section name has already been scanned (see |@<Get control code
and...@>|).  Thus, if we encounter |next_control==section_name| in the
skip-ahead process, we should likewise scan the section name, so later
processing will be the same in both cases.

@<Skip ahead until |next_control| ...@>=
while (next_control<definition)
      /* |definition| is the lowest of the ``significant'' codes */
  if((next_control=skip_ahead())==section_name){
    loc-=2; next_control=get_next();
  }

@ @<Scan a definition@>= {
  @<Handle export commands in def...@>;
  if (next_control!=identifier) {
    err_print("! Definition flushed, must start with identifier");
@.Definition flushed...@>
    continue;
  }
  app_repl(((a=id_lookup(id_first,id_loc,0)-name_dir) / 0400)+0200);
        /* append the lhs */
  app_repl(a % 0400);
  if (*loc!='(') { /* identifier must be separated from replacement text */
    app_repl(string); app_repl(' '); app_repl(string);
  }
  scan_repl(macro);
  cur_text->text_link=0; /* |text_link==0| characterizes a macro */
}

@ %mine
When we scan a definition, we want to include the section number
|section_count| which indicates where it was defined as a comment
which will precede the actual definition in the token list we are creating.
This comment is parsed by |output_defs|. We need this comment in order
to inform \.{mCWEAVE} where the definition came from, since
\.{mCWEAVE} will be reading our export files in order to make its index.

The comment in the token memory may further be followed by one or more
export special commands like \&{export} before the actual definition starts.
@<Handle export commands in definitions@>=
{
  char comment[20],*cp;
  while ((next_control=get_next())=='\n'); /*allow newline before definition */
  sprintf(comment,"\03/*Section:%d*/\03",section_count);
  for(cp=comment;*cp;cp++) app_repl(*cp);
  while(next_control==special_command) {
    next_control=get_next();
    if(next_control==identifier) {
      a=id_lookup(id_first,id_loc,0)-name_dir;
      if(id_global<=a && a<=id_shared) {
	used_exports|=1<<a-1;	/* remember that we saw this export command */
	app_repl(special_command);
	app_repl((a>>8)+0200);    /* append the export command */
	app_repl(a&0377);
      }
      else {
	err_print("! Illegal export command");
@.Illegal export command@>
	break;
      }
      do next_control=get_next();
      while(xisspace(next_control));
    }
    else break;
  }
}

@ If the section name is not followed by \.{=} or \.{+=}, no \CEE/
code is forthcoming: the section is being cited, not being
defined.  This use is illegal after the definition part of the
current section has started, except inside a comment, but
\.{CTANGLE} does not enforce this rule: it simply ignores the offending
section name and everything following it, up to the next significant
control code.

@<If section is not being defined, |continue| @>=
while ((next_control=get_next())=='+'); /* allow optional \.{+=} */
if (next_control!='=' && next_control!=eq_eq)
  continue;

@ %modified
@<Scan the \CEE/...@>=
@<Insert the section number into |tok_mem|@>;
scan_repl(section_name); /* now |cur_text| points to the replacement text */
@<Update the data structure so that the replacement text is accessible@>;
process_imports();	/* process all import commands of this section */
process_exports();	/* process all export commands of this section */

@ @<Insert the section number...@>=
store_two_bytes((sixteen_bits)(0150000+section_count));
  /* |0150000==0320*0400| */

@ @<Update the data...@>=
if (p==name_dir||p==0) { /* unnamed section, or bad section name */
  (last_unnamed)->text_link=cur_text-text_info; last_unnamed=cur_text;
}
else if (p->equiv==(char *)text_info) p->equiv=(char *)cur_text;
  /* first section of this name */
else {
  q=(text_pointer)p->equiv;
  while (q->text_link<section_flag)
    q=q->text_link+text_info; /* find end of list */
  q->text_link=cur_text-text_info;
}
cur_text->text_link=section_flag;
  /* mark this replacement text as a nonmacro */

@ @<Predec...@>=
void phase_one();

@ @c
void
phase_one() {
  phase=1;
  section_count=0;
  reset_input();
  skip_limbo();
  while (!input_has_ended) scan_section();
  check_complete();
  phase=2;
}

@ Only a small subset of the control codes is legal in limbo, so limbo
processing is straightforward.

@<Predecl...@>=
void skip_limbo();

@ @c
void
skip_limbo()
{
  char c;
  while (1) {
    if (loc>limit && get_line()==0) return;
    *(limit+1)='@@';
    while (*loc!='@@') loc++;
    if (loc++<=limit) {
      c=*loc++;
      if (ccode[(eight_bits)c]==new_section) break;
      switch (ccode[(eight_bits)c]) {
        case translit_code: @<Read in transliteration of a character@>; break;
        case format_code: case '@@': break;
        case control_text: if (c=='q' || c=='Q') {
          while ((c=skip_ahead())=='@@');
          if (*(loc-1)!='>')
            err_print("! Double @@ should be used in control text");
@.Double @@ should be used...@>
          break;
          } /* otherwise fall through */
        default: err_print("! Double @@ should be used in limbo");
@.Double @@ should be used...@>
      }
    }
  }
}

@ @<Read in transliteration of a character@>=
  while(xisspace(*loc)&&loc<limit) loc++;
  loc+=3;
  if (loc>limit || !xisxdigit(*(loc-3)) || !xisxdigit(*(loc-2)) @|
         || (*(loc-3)>='0' && *(loc-3)<='7') || !xisspace(*(loc-1)))
    err_print("! Improper hex number following @@l");
@.Improper hex number...@>
  else {
    unsigned i;
    char *beg;
    sscanf(loc-3,"%x",&i);
    while(xisspace(*loc)&&loc<limit) loc++;
    beg=loc;
    while(loc<limit&&(xisalpha(*loc)||xisdigit(*loc)||*loc=='_')) loc++;
    if (loc-beg>=translit_length)
      err_print("! Replacement string in @@l too long");
@.Replacement string in @@l...@>
    else{
      strncpy(translit[i-0200],beg,loc-beg);
      translit[i-0200][loc-beg]='\0';
    }
  }

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

@**Multiple files.
I've tried to concentrate most of the extensions of \.{mCTANGLE}
concerning multiple file support in this section. Nevertheless,
numerous changes to the preceding sections were inevitable.
However, everything from here on is completely \.{mCWEB}-specific.

@*Export commands.
\.{mCTANGLE} has been modified so that it now can export and import
code from one \.{CWEB} file to another.
Now we want to treat all commands that are dealing with export.

@ The following constants are used in order to form a bit mask which
describes where to export our \CEE/ statements. It can be
calculated by $1<<id\_\ldots-1$. |used_exports| indicates
all export commands that have been used in this file.
@d exp_global 1
@d exp_export 2
@d exp_shared 4
@<Global var...@>=
sixteen_bits used_exports;

@
@<Set initial ...@>=
used_exports=0;

@ If we encounter an export command (e.g.~\&{global}), we store the current
|tok_ptr| in |export_ref|. The corresponding |export_type| indicates the type
of export (e.g.~|exp_global|). In addition, we remember the line and file name
where the export command was found.

But if the value of |tok_ptr| has not changed since the last export command,
we only modify |export_type| because this is an additional
export qualifier for the last command (e.g.~\&{export} \&{shared}).
All the stored export references are processed at the end of the
current section.
@d max_exports 64		/* maximum of export commands per section */
@<Global var...@>=
eight_bits *export_ref[max_exports];	/* points into |tok_mem| */
eight_bits export_type[max_exports];	/* mask of |exp_shared|, etc. */
int export_line[max_exports];		/* line number where export command was found */
char *export_file_name[max_exports];	/* pointer to source file name */
sixteen_bits export_idx;

@ This a counter for our export commands of the current section.
@<Set init...@>=
export_idx=0;

@
@<Predecl...@>=
void remember_export();

@ This is called every time |scan_repl| sees an export command like
\&{global}.
@c
void
remember_export(id)
sixteen_bits id;
{
  sixteen_bits c;

  c=1<<id-1;	/* calculate export mask ($id\_\ldots\rightarrow exp\_\ldots$) */
  used_exports|=c;
  if(export_idx && export_ref[export_idx-1]==tok_ptr)	/* same token position as last time */
    export_type[export_idx-1]|=c;	/* $\rightarrow$ additional export qualifier */
  else {
    if(export_idx>=max_exports) overflow("exports per section");
    export_ref[export_idx]=tok_ptr;
    export_type[export_idx]=c;
    export_line[export_idx]=changing?change_line:cur_line;
    export_file_name[export_idx]=changing?change_file_name:cur_file_name;
    export_idx++;
  }
}

@ When we are reading the source file, we will find some export
commands. For every command, we will analyze the following
statement. After we know what it is, we modify the
original token list and additionally insert a modified version
in an export section.

There are the following catagories of export
sections for every export type (global, export, shared):
@d forward_types 0  /* forward declarations of \CPLUSPLUS/ classes */
@d types 1   /* |typedef| and aggregates */
@d declarations 2  /* variable declarations and function prototypes */
@d num_export_sections 3	/* number of export sections per type */
@<Typed...@>=
typedef struct {
  text_pointer first_text;	/* first |text| for this export section */
  text_pointer last_text;	/* last |text| for this export section */
} export_section;

@
@<Glo...@>=
export_section glb_sec[num_export_sections];   /* export sections for \&{global} */
export_section exp_sec[num_export_sections];
export_section shr_sec[num_export_sections];
export_section var_sec;       /* where all variable definitions go */

@
@d clear_export_sections(s) memset((void *)s,0,sizeof(glb_sec))
@<Set init...@>=
clear_export_sections(glb_sec);
clear_export_sections(exp_sec);
clear_export_sections(shr_sec);
memset((void *)&var_sec,0,sizeof(var_sec));

@
@<Predecl...@>=
void
push_export_section();

@ When an export section is output, we must push its |text| on the output
stack.
@c
void
push_export_section(sec)
  export_section *sec;
{
  static char s[]="_global";
  name_pointer p=id_lookup(s,s+strlen(s),0);
  if(sec->first_text) {   /* section not empty? */
    p->equiv=(char *)sec->first_text;
    push_level(p);
  }
}

@ If we want to have a new |text_pointer| for a given
|export_section| (e.g.~|shr_sec|) and a given |type| (e.g.~|declarations|),
we may call the following function which reserves a new |text|
variable from the |text_info| pool.
@c
text_pointer
new_text_ptr(sec,type)
  export_section *sec;
  int type;
{
  text_pointer txt;
  if(text_ptr>text_info_end) overflow("text");
  if(sec[type].last_text==text_ptr-1) return text_ptr-1;  /* we were the last, keep our |text| */
  txt=text_ptr++;
  text_ptr->tok_start=tok_ptr;
  txt->tok_start=tok_ptr;
  txt->text_link=section_flag;
  if(sec[type].last_text==NULL) sec[type].first_text=txt;
  else sec[type].last_text->text_link=txt-text_info;
  sec[type].last_text=txt;
  return txt;
}

@ \.{mCTANGLE} writes the current section number as comments to
shared and export files in order to inform \.{mCWEAVE} about where
the definitions occurred.
@c
void
insert_section_comment()
{
  char comment[20],*cp;
  sprintf(comment,"\03/*Section:%d*/\03\n",section_count);
  for(cp=comment;*cp;cp++) app_repl(*cp);
}

@
@<Predecl...@>=
void process_exports();

@ After each section has been read in, all export commands have been stored in
the array |export_ref| which points to the corresponding token position
in |tok_mem|. |export_type| denotes the type of the export command
which can be a composed type (e.g.~\&{shared} and \&{export}).
There are |export_idx| export commands in the section.

For every command, we have to scan the token list in order to find
out which statement is following. After we know that, we modify the token
list and maybe create new export sections.
@f nobreak break
@d nobreak
@c
void
process_exports()
{
  eight_bits *tk;
  sixteen_bits i;
  int parenthesis,braces;
  boolean is_declaration;	/* is this a declaration? */
  boolean is_typedef;		/* is it a |typedef|? */
  boolean is_inline;            /* is it an inline function? */
  boolean func_possible;	/* can it be a function? */
  eight_bits *aggregate;	/* do we have an aggregate? */
  int aggregate_id;             /* identifier of aggregate (e.g.~|id_enum|) */
  eight_bits *aggregate_label;	/* if yes, does it have a label? */
  eight_bits *aggregate_body,*body_end;	/* if there, where is its body? */
  eight_bits *aggregate_variable;	/* are there variables after the label or body? */
  boolean is_func_new_style;	/* is it an new style \CEE/ function head? */
  boolean is_func_old_style;	/* is it an old style function head? */
  boolean is_prototype;	/* is it a prototype? */
  boolean is_preproc;   /* is it a preprocessor statement? */
  boolean is_static;   /* did we see a |static| keyword? */
  eight_bits *func_arguments;	/* points to \.{(} before first argument */
  eight_bits *arg_end;		/* points to \.{)} of arglist */
  
  for(i=0;i<export_idx;i++) {
    tk=export_ref[i];
    while(xisspace(*tk)) tk++;
    export_ref[i]=tk;
    braces=parenthesis=0;
    is_declaration=0;
    is_typedef=0;
    is_inline=0;
    aggregate=NULL;
    is_func_new_style=0;
    is_func_old_style=0;
    is_prototype=0;
    is_preproc=0;
    is_static=0;
    func_arguments=NULL;
    @<Scan the exported statement@>;
    if(aggregate) @<Examine aggregate@>;
    @<Store exported statement in export sections@>;
  }
  export_idx=0;
  text_ptr->tok_start=tok_ptr;
}

@ First of all, we make a global scan over the statement following our
export command. |tk| points to the first token. If we have seen enough,
we jump to label |done|.

When running over the token list, we inspect all identifiers searching for keywords
like |enum|, \&{class}, |struct|, |union|, |extern| and |typedef| which can
indicate the nature of the statement we are looking at.
Additionally, we look for assignments or single `\.{:}' which make us exclude
prototypes and function headers.

After having scanned the token list, we have the following variables set:
|is_declaration|, |is_typedef|, |is_inline|, |aggregate|,
|is_func_new_style|, |is_func_old_style|, |is_prototype|, |is_preproc|.
@<Scan the exported statement@>=
{
  sixteen_bits id;
  boolean aggregate_body_might_follow=0;  /* next |'{'| can be start of aggregate body */

  if(export_type[i]==exp_export) {
    if(0200<=*tk && *tk<0250) {
      id=*tk-0200<<8|tk[1];		/* don't handle exported import commands */
      if(id_import==id || id==id_from) continue;
    }
    if(*tk==ignore) continue;		/* nor removed import command */
  }
  func_possible=-1;		/* yes, but no `(' seen yet */
  while(xisspace(*tk)) tk++;	/* allow newline */
  if(*tk=='#') is_preproc=1;
  while(tk<tok_ptr) {
    switch(*tk++) {
    case '=':
      while(*tk=='\n') tk++;	/* allow newline */
      if(*tk=='{') {	/* \.{\{} after an \.{=} does not terminate statement */
	tk++;
	braces++;
      }
      if(parenthesis) break;	/* maybe \CPLUSPLUS/ default parameter */
      nobreak;
    case ':':
      if(*tk!=':')
	func_possible=0;
      break;
    case string:  /* skip them */
    case constant:
      do tk++;
      while(tk<tok_ptr && *tk!=string && *tk!=constant);
      tk++;
      break;
    case '(':
      if(func_possible<0) func_possible=1;  /* yes, it may be a function */
      parenthesis++;
      aggregate_body_might_follow=0;
      break;
    case ')':
      parenthesis--;@+ break;
    case '}':
      if(braces) {
	--braces;
	break;
      }
      nobreak;
    case ';':
      if(!braces && !parenthesis) goto done;
      aggregate_body_might_follow=0;
      break;
    case '{':
      if(!braces) goto done;
      braces++;
      break;
    default:
      if(0200<=tk[-1] && tk[-1]<0250) {	/* identifier */
	id=tk[-1]-0200<<8;
	id|=*tk++;
	switch(id) {
	case id_enum:
	case id_union:
	case id_class:
	case id_struct:
	  if(!aggregate) {
	    aggregate_id=id;
	    aggregate=tk;
	  }
	  aggregate_body_might_follow=1;
	  break;
	case id_extern:
	  is_declaration=1;@+ break;
	case id_typedef:
	  is_typedef=1;@+ break;
	case id_inline:
	  is_inline=1;@+ break;
	case id_static:
	  is_static=1;@+ break;
	}
	while(*tk=='\n') tk++;	/* allow newline */
	if(*tk=='{' && aggregate_body_might_follow) {
	  braces++;	/* `\.{\{}' following an identifier introduces aggregate body */
	  tk++;
	}
      }
      else if(tk[-1]==0320 && *tk==0) tk+=5;	/* skip \&{\#line} info */
      else if(tk[-1]>=0250) tk++;
    }
  }
 done:	if(func_possible<0) func_possible=0;	/* never saw a `(' */
 else @<Is it a function or prototype?@>;
}

@ If |func_possible!=0| the statement following our export
command may be a function head or a prototype.
But it may also be a variable definition, so we should
examine it in more detail.

In order to be a function, the last \.{(} must be preceded by an
identifier. The keyword |operator| also implies a new style function.
If the corresponding \.{)} is followed by an identifier,
we have an old-style function head. If we see a \.{\{} behind it, we
have a new-style function head. In case of a \.{,} or a \.{;} we can
treat our statement as a prototype.
According to what we find, we set the variables |is_func_new_style|,
|is_func_old_style| and |is_prototype|.

These are the basic rules for our inspection, but there are no rules
without exceptions. If we only have an identifier list in the argument
list or if there is no arglist at all, we have an old style function definition.

On the other hand, if the argument list only contains \.{void}, we have
a new style function head.
@<Is it a function...@>=
{
  eight_bits *tp,c;
  int parenthesis=0;
  boolean can_be_new_style;	/* can it possibly be a new style function head? */

  func_arguments=NULL;
  tp=export_ref[i];
  while(tp<=tk) {
    c=*tp++;
    if(c>=0200) {
      if(c==0320 && *tp==0) tp+=4;	/* skip \&{\#line} info */
      tp++;
      if(c<0250) {	/* identifier */
	id=c-0200<<8|tp[-1];
	if(id==id_operator) {
	  arg_end=tk-1;
	  if(*arg_end=='{') arg_end--;
	  is_func_new_style=1;
	  break;
	}
	if(*tp=='(' && !parenthesis) {
	  func_arguments=tp;
	  can_be_new_style=0;
	  tp++;
	  parenthesis=1;
	}
	else if(func_arguments && 0200<=*tp && *tp<0250) can_be_new_style=1;
      }
    }
    else if(c=='(') {
      parenthesis++;
      func_arguments=NULL;
    }
    else if(c==')') {
      --parenthesis;
      arg_end=tp-1;
    }
    else if(func_arguments && parenthesis) {
      if(c!=',') can_be_new_style=1;
    }
  }
  if(func_arguments && parenthesis==0) {
    if(arg_end-func_arguments==3 && 0200<=func_arguments[1] && func_arguments[1]<0250) {
      /* test for \&{void} as only parameter */
      int a=func_arguments[1]-0200<<8|func_arguments[2];
      if(a==id_void)
	can_be_new_style=1;
    }
    tp=arg_end+1;
    while(isspace(*tp)) tp++;
    if(*tp=='{') {
      if(can_be_new_style)
	is_func_new_style=1;	/* in most cases */
      else is_func_old_style=1;
    }
    else if(0200<=*tp && *tp<0250) /* identifier */
      is_func_old_style=1;
    else if(*tp==',' || *tp==';') is_prototype=1;
    else func_arguments=NULL;
  }
}

@ If |aggregate!=NULL| we know,
that we have an aggregate in our statement, but we
don't know exactly what kind. So we examine it in order to find out
if it has a label, a body or if there are variables defined.

All the results are then stored in |aggregate_label|,
|aggregate_body|, |body_end| and |aggregate_variable|.
@<Examine aggregate@>=
{
  eight_bits *tp=aggregate;
  aggregate_label=NULL;
  aggregate_body=NULL;
  aggregate_variable=NULL;
  while(*tp=='\n') tp++;
  if(0200<=*tp && *tp<0250) {	/* identifier following */
    aggregate_label=tp;
    tp+=2;
    while(*tp=='\n') tp++;
    if(*tp=='{' || *tp==':' && tp[1]!=':') aggregate_body=tp;
  }
  else if(*tp=='{') aggregate_body=tp;
  if(aggregate_body) {
    body_end=aggregate_body;
    @<|body_end| points to `\.{\{}', find corresponding `\.{\}}'@>;
  }
  else if(aggregate_label) body_end=aggregate_label+1;
  else body_end=NULL;	/* neither body nor label */
  if(body_end) {
    tp=body_end+1;
    while(*tp=='\n') tp++;
    if(*tp!=';') aggregate_variable=tp;
  }
  aggregate-=2;	/* point to |struct| or the like */
}

@ |body_end| points to an opening brace or the \.{':'} of a class
definition and
should be incremented until we find the corresponding
closing brace. But don't count braces that appear in strings.
@<|body_end| points to `\.{...@>=
{
  boolean in_verb=0;	/* are we in verbatim mode? */
  braces=0;
  body_end--;
  while(++body_end<tok_ptr) {
    switch(*body_end) {
    case '{': if(!in_verb) braces++;
      break;
    case '}': if(!in_verb && --braces==0) goto found;
      break;
    case string:
    case constant:
      in_verb=!in_verb;
      break;
    default:
      if(*body_end==0320 && body_end[1]==0) body_end+=5;  /* skip \&{\#line} info */
      else if(*body_end>=0200) body_end++;  /* skip identifier */
    }
  }
  aggregate_body=NULL;
  if(braces)
    err_print("! Cannot find corresponding } for aggregate");
@.Cannot find corresponding $\}$...@>
  else
    err_print("! Class derivation without { body };");
@.Class derivation without $\{$ body $\}$@>
 found:;
}

@ We now have analyzed our statement, now we can store it in the
export sections and we can modify our original token list so that
not necessarily everything will remain in the \CEE/ output file.

Which export command(s) we handle is stored in |export_type[i]|.
This determines where to write the exported statement.
@<Store exported statement...@>=
{
  sixteen_bits type=export_type[i];
  export_section *sec;
  eight_bits *tp;

  also_to_exp_sec=0;	/* see below */
  if(type==exp_export) {
    sec=exp_sec;                        /* we only write to export file */
    modify_original_token_list=0;	/* keep original token list unchanged */
  }
  else {
    if(type & exp_export) also_to_exp_sec=1; /* to export file and another one */
    if(type & exp_global) sec=glb_sec;
    else if(type & exp_shared) sec=shr_sec;
    modify_original_token_list=1;       /* modify original token list */
  }
  if(aggregate && aggregate_id==id_class && aggregate_label)
    @<Create forward reference for \&{class}@>@;
  if(is_preproc) {
    @<Store preprocessor command in |sec|@>;
    if(modify_original_token_list) @<Remove statement@>;
    goto stored;
  }
  if(is_typedef) {
    @<Store typedef in |sec|@>;
    if(modify_original_token_list) @<Remove statement@>;
    goto stored;
  }
  if(aggregate && (aggregate_label || aggregate_id==id_enum && !aggregate_variable) &&
     aggregate_body) {
    @<Store aggregate definition in |sec|@>;
    if(modify_original_token_list) @<Remove aggregate body@>;
    if(!aggregate_variable) {	/* nothing behind body, remove whole statement */
      if(modify_original_token_list) @<Remove statement@>;
      goto stored;
    }
  }
  if(is_declaration) {
    @<Store declaration in |sec|@>;
    if(modify_original_token_list) @<Remove statement@>;
    goto stored;
  }
  if(is_inline && tk[-1]=='{') {
    @<Move |inline| function including function body to |sec|@>;
    goto stored;
  }
  if(is_func_old_style) {
    @<Generate prototype from old style function head and store it in |sec|@>;
    goto stored;
  }
  if(is_func_new_style) {
    @<Generate prototype from new style function head and store it in |sec|@>;
    goto stored;
  }
  if(is_prototype) {
    @<Store declaration in |sec|@>;
    if(modify_original_token_list) @<Remove statement@>;
    goto stored;
  }
  if(!is_static)  /* assume variable definition */
    @<Copy variable to |sec|, preceded by |extern|, without assignments@>;
  if(modify_original_token_list)
    @<Move variable to |var_sec|@>;
 stored:
  text_ptr->tok_start=tok_ptr;   /* |text| ends here */
}

@ We have already seen the function |new_text_ptr| which reserves
a new |text_pointer| for the given export section and type.
Here we want to define a macro that automatically calls
|new_text_ptr| with the argument |exp_sec| if the boolean
variable |also_to_exp_sec| is set.
So, we can store everything that goes to, say, the |global| section
also to the |export| section without additional effort.
@d x_new_text_ptr(sec,type) {
  if(also_to_exp_sec) new_text_ptr(exp_sec,type);
  new_text_ptr(sec,type);
  insert_section_comment();
}
@<Glo...@>=
boolean also_to_exp_sec;
boolean modify_original_token_list;

@ Sometimes we have to remove the statement from the original token list
so that it does not appear in the \CEE/ file. This is done by overwriting
it in |tok_mem| with the token |ignore|.
@<Remove statement@>=
{
  for(tp=export_ref[i];tp<tk;tp++) if(*tp!='\n') *tp=ignore;
}

@ Every time we encounter a new class definition, we output a
forward declaration to the |forward_types| export section, thus
making it easy to reorder the definition of the classes without
taking in account the dependencies between them.
@<Create forward reference for \&{class}@>=
{
  x_new_text_ptr(sec,forward_types);
  remember_export_line(i);
  for(tp=aggregate;tp<aggregate_label+2;tp++)
    app_repl(*tp);
  app_repl(';');
  app_repl('\n');
  if(*tp==';') {  /* it is already only a forward declaration */
    if(modify_original_token_list) @<Remove statement@>;
    goto stored;
  }
}

@
@<Store preproc...@>=
{
  x_new_text_ptr(sec,types);
  remember_export_line(i);  /* put \&{\#line} info into token memory */
  for(tp=export_ref[i];tp<tk;tp++) {
    app_repl(*tp);
    if(*tp=='\n' && tp[-1]!='\\') {
      tk=tp+1;       /* preprocessor command ends here (for removing) */
      break;
    }
  }
  if(tp==tk) app_repl('\n');
}

@ Simply copy |typedef| statement to |sec|. The statement terminates
at |tk|.
@<Store typedef in |sec|@>=
{
  x_new_text_ptr(sec,types);      /* new |text_pointer| */
  remember_export_line(i);	/* insert line info from |export_line[i]| */
  for(tp=export_ref[i];tp<tk;tp++) app_repl(*tp);
  app_repl('\n');
}

@ If an aggregate definition occurs, we extract the aggregate definition
and store it to the |types| section.
But if the aggregate has no label, we will have to precede it with |#ifndef|
so that the chapter it is defined in does not see it.
This will be done in |@<Copy variable...@>|, where the variable declaration
will be copied to the shared/export file.
@<Store aggregate definition in |sec|@>=
{
  x_new_text_ptr(sec,aggregate_id==id_enum?forward_types:types);
  remember_export_line(i);
  for(tp=aggregate;tp<=body_end;tp++) app_repl(*tp);
  app_repl(';');
  app_repl('\n');
}

@ If we have stored the aggregate definition to the |types| section
we don't want to repeat the body in the \CEE/ file and therefore
remove it.
@<Remove aggregate body@>=
for(tp=aggregate_body;tp<=body_end;tp++) if(*tp!='\n') *tp=ignore;

@ Declarations are simply inserted into the |declarations| section.
@<Store declaration in |sec|@>=
{
  x_new_text_ptr(sec,declarations);
  remember_export_line(i);
  for(tp=export_ref[i];tp<tk;tp++) app_repl(*tp);
  app_repl('\n');
}

@ Inline functions must be treated differently from ordinary functions,
since we do not want to have a prototype in the header, but the whole function
including the function body.
@<Move |inline| function including function body to |sec|@>=
{
  int braces;
  x_new_text_ptr(sec,declarations);
  remember_export_line(i);
  braces=0;
  for(tp=tk-1;tp<tok_ptr;tp++) {   /* find end of function body */
    switch(*tp++) {
    case string:
    case constant:
      do {
	if(*tp==string || *tp==constant) {
	  tp++;
	  break;
	}
      } while(++tp<tok_ptr);
      goto have_it;
    case '{':
      braces++;
      break;
    case '}':
      braces--;
      if(!braces) goto have_it;
      break;
    }
  }
 have_it:
  tk=tp;     /* here is the new end, in case we want to remove the function */
  for(tp=export_ref[i];tp<tk;tp++) app_repl(*tp);
  app_repl('\n');
  if(modify_original_token_list) @<Remove statement@>;
}

@ This is difficult. We have a old style function head and want to
generate a prototype for it. So, we have to scan the argument declarations
following the function head in order to find out which types the arguments
have.

There are two cases which are rather easy to handle.
If the user wants only Kernighan \AM\ Ritchie prototypes (by giving
the {\tt+k} flag), i.e.~prototypes with empty arguments,
we simply omit the argument list and have a prototype.
The other simple case is if we have an empty arglist.
All other cases require a closer examination of the argument declarations.

Remember, that in old style function heads, the arglist is only an
identifier list. So, first of all, we store all argument names (their
identifiers) in the |argument| array.
@d max_args 32		/* maximum of arguments in arglist */
@<Generate prototype from old style function head and store it in |sec|@>=
{
  int num_args,a,j;
  eight_bits *cur_type_start;		/* points to first token of current declaration */
  eight_bits *cur_type_end;	/* points to last token+1 of type part of current declaration */
  eight_bits *cur_variable_start;	/* points to start of variable */
  sixteen_bits argument[max_args];
  eight_bits *type_start[max_args],*type_end[max_args];
  eight_bits *variable_start[max_args];
  
  x_new_text_ptr(sec,declarations);
  remember_export_line(i);
  @<If K \AM\ R style, simply omit arguments@>;
  @<Check for empty arglist, |goto proto_generated| if found@>;
  @<Store the argument identifiers in |argument|@>;
  cur_type_start=arg_end+1;
  while(xisspace(*cur_type_start)) cur_type_start++;
  cur_type_end=cur_variable_start=NULL;
  for(j=0;j<num_args;j++) {
    type_start[j]=NULL;  /* where does type for argument number $j$ start */
    type_end[j]=NULL;
    variable_start[j]=NULL;
  }
  @<Find declaration for each argument@>;
  @<Output the prototype for our old style function@>;
 proto_generated:;
}

@ If we have Kernighan \AM~Ritchie \CEE/, then we just omit the arguments
and have a prototype.
@<If K \AM\ R...@>=
if(flags['k']) {
  for(tp=export_ref[i];tp<=func_arguments;tp++) app_repl(*tp);
  app_repl(')');
  app_repl(';');
  app_repl('\n');
  goto proto_generated;
}

@ If we have a old style function head with an empty arglist
(e.g.~|void func()|), we simply insert a |void| between the opening and
closing parenthesis.
@<Check for empty arglist, |goto proto_generated| if found@>=
if(func_arguments==arg_end-1) {	/* empty arglist, simply insert |void| */
  for(tp=export_ref[i];tp<=func_arguments;tp++) app_repl(*tp);
  app_repl(0200+(id_void/0400));
  app_repl(id_void&0377);
  for(;tp<=arg_end;tp++) app_repl(*tp);
  app_repl(';');
  app_repl('\n');
  goto proto_generated;
}

@ We go through the argument list and store each identifier in
the array |argument|. |num_args| will contain the number of arguments found.
@<Store the argument identifiers in |argument|@>=
num_args=0;
for(tp=func_arguments+1;tp<arg_end;tp++) {
  if(*tp>=0200 && *tp<0250) {
    if(num_args==max_args) overflow("function arguments");
    argument[num_args]=*tp<<8;
    argument[num_args]+=*++tp;
    num_args++;
    ++tp;
    if(*tp!=',') break;
  }
}
if(tp<arg_end) {
  printf("! Illegal old style function head (file \"%s\", l. %d)\n",
	 export_file_name[i],export_line[i]);
@.Illegal old style function head@>
  mark_error;
  goto proto_generated;
}

@ We now have to match the argument names |argument[]| and the
declarations after the function head. Every time we find the
matching declaration for argument $j$, set the corresponding
array entries |type_start[j]|, |type_end[j]| and |variable_start[j]|
to the start and end of the type and the start of the variable
in the declaration.

Fortunately, types must not have the same name as a variable, only
aggregate labels may have the same name as a variable.
So we always skip aggregate labels and compare the rest of the identifiers
with our arguments. This way we find out, which argument belongs to which
declaration.

The variables |cur_type_start| and |cur_type_end| always contain the
start and end of the type part of the declaration we are dealing with.
|cur_variable_start| points to the start of the variable part, i.e.~the
part which is specific to the variable itself. This includes the pointer
marker \.{*}, since |int *a,b;| means that only |a| should be a pointer.
@<Find declaration...@>=
{
  for(tp=cur_type_start;tp<tok_ptr;tp++) {
    if(*tp>=0200) {
      if(*tp<0250) {		/* identifier found */
	a=*tp<<8;
	a+=*++tp;
	if(a>=id_enum && a<=id_struct) {	/* aggregate */
	  if(0200<=tp[1] && tp[1]<0250) tp+=2;	/* skip label */
	}
	else {  /* try to match with arguments */
	  for(j=0;j<num_args;j++)
	    if(a==argument[j]) {
	      if(!cur_type_end)
		cur_variable_start=cur_type_end=tp-1;
	      type_start[j]=cur_type_start;
	      type_end[j]=cur_type_end;
	      variable_start[j]=cur_variable_start;
	    }
	}
	if(tp[1]=='{') {	/* skip aggregate body */
	  int braces=0;
	  do	if(*++tp=='{') braces++;
	  else if(*tp=='}') braces--;
	  else if(*tp>=0200) tp++;
	  while(braces && tp<tok_ptr);
	  if(braces) {
	    err_print("! Can't find closing `}' of aggregate body");
@.Can't find closing '$\}$'...@>
	    goto proto_generated;
	  }
	}
      }
      else tp++;  /* skip second byte of 2-byte token */
    }
    else if(*tp==';') {  /* current type ends, new type begins */
      cur_type_start=tp+1;
      while(xisspace(*cur_type_start)) cur_type_start++;
      cur_type_end=NULL;       /* end not known yet */
      cur_variable_start=NULL;
    }
    else if(*tp==',') cur_variable_start=tp+1;  /* new variable, same type */
    else if(*tp=='{') break;	/* start of function body, done */
    else if(!cur_type_end && !isspace(*tp))  /* end of current type */
      cur_type_end=cur_variable_start=tp;
  }
}

@ When we finally know which argument has which type, we can output
the prototype. For argument $j$, |type_start[j]| and |type_end[j]| give
the start and end position in the token list for its type.
The variable name itself can be found at |variable_start[j]|, ending
with a '\.{,}' or '\.{;}'.

All variables that have |type_start[j]==NULL| default to |int|, since
they have been omitted in the declaration list.
@<Output the prototype...@>=
{
  for(tp=export_ref[i];tp<=func_arguments;tp++) app_repl(*tp);
  for(j=0;j<num_args;j++) {
    if(!type_start[j]) {	/* argument defaults to |int| */
      app_repl((id_int>>8)+0200);
      app_repl(id_int&0377);
    }
    else {
      for(tp=type_start[j];tp<type_end[j];tp++) app_repl(*tp);
      for(tp=variable_start[j];*tp!=',' && *tp!=';' && tp<tok_ptr;tp++) {
	app_repl(*tp);
	if(*tp>=0200) {
	  ++tp;
	  app_repl(*tp);
	}
      }
    }
    if(j!=num_args-1) app_repl(',');
  }
  app_repl(')');
  app_repl(';');
  app_repl('\n');
}

@ Generating a prototype from a new style function head is rather simple.
Just append a \.{;} after the parameter list and you are done.
@<Generate prototype from new style function head and store it in |sec|@>=
x_new_text_ptr(sec,declarations);
remember_export_line(i);
for(tp=export_ref[i];tp<=arg_end;tp++) app_repl(*tp);
app_repl(';');
app_repl('\n');

@ Variables are copied to |declarations|, but without any assignments.
They get an |extern| in front of the actual definition in order to
make them declarations.
@<Copy variable...@>=
{
  boolean copy_on=1;
  eight_bits c;
  boolean if_ndef;

  x_new_text_ptr(sec,declarations);
  remember_export_line(i);

  if_ndef=aggregate && aggregate_body && aggregate_label==NULL;
  if(if_ndef) {
    app_repl('#');
    app_repl((id_ifndef >> 8)+0200);
    app_repl(id_ifndef & 0377);
    app_repl((id_file_name_constant >> 8)+0200);
    app_repl(id_file_name_constant & 0377);
    app_repl('\n');
  }

  app_repl((id_extern >> 8)+0200);	/* insert |extern| into token list */
  app_repl(id_extern & 0377);
  braces=0;
  for(tp=export_ref[i];tp<tk;tp++) {
    switch(c=*tp) {
    case ignore:      /* don't copy |ignore| tokens */
      break;
    case '{':
      braces++;
      break;
    case '}':
      braces--;
      break;
    case '=':
      copy_on=0;      /* assignment, stop copying */
      break;
    case string:   /* don't copy them either */
      do tp++;
      while(*tp!=string && tp<tk);
      break;
    case ',':
    case ';':
      if(!braces) copy_on=1; /* restart copying, assignment terminated */
      break;
    default:
      if(c>=0200) {
	++tp;
	if(copy_on) {
	  app_repl(c);
	  app_repl(*tp);
	}
	if(c==0320 && *tp==0) {	/* |0150000| means \&{\#line} info */
	  if(copy_on) {
	    ++tp;
	    app_repl(*tp);
	    ++tp;
	    app_repl(*tp);
	    ++tp;
	    app_repl(*tp);
	    ++tp;
	    app_repl(*tp);
	  }
	  else tp+=4;
	}
	continue;
      }
    }
    if(copy_on && c) app_repl(c);
  }
  app_repl('\n');
  if(if_ndef) {
    app_repl('#');
    app_repl((id_endif >> 8)+0200);
    app_repl(id_endif & 0377);
    app_repl('\n');
  }
}

@ In order to make exported variables always global, they are collected
in the |var_sec| section and inserted after the declarations.
Since the statement is now in this section, it is removed from the original
token list.
@<Move variable to |var_sec|@>=
{
  int j;
  sec=&var_sec;
  new_text_ptr(sec,0);
  remember_export_line(i);
  for(tp=export_ref[i];tp<tk;tp++) {
    if(*tp>=0200) {
      app_repl(*tp);
      if(*tp++==0320 && *tp==0)	/* |0150000| means \&{\#line} info */
	for(j=0;j<4;j++,tp++) app_repl(*tp);
      app_repl(*tp);
    }
    else if(*tp!=ignore) app_repl(*tp);
  }
  app_repl('\n');
  @<Remove statement@>;
}

@
@<Predecl...@>=
void remember_export_line();

@ The source file name and the line number the of |export_ref[i]| are
stored in |export_file_name[i]| and |export_line[i]|, respectively.
They should be inserted into the token memory in order to get reasonable
error messages from the compiler.

These information starts with two bytes making up the octal number
|0150000| followed by two bytes of line number and an identifier token
that gives the name of the file. During output phase, these tokens will
be converted into a \&{\#line} \CEE/ preprocessor command.
@c
void
remember_export_line(i)
int i;
{
  int a;
  char *id;
  store_two_bytes(0150000);
  store_two_bytes(export_line[i]);
  id=export_file_name[i];
  a=id_lookup(id,id+strlen(id),0)-name_dir;
  app_repl((a >> 8) + 0200);
  app_repl(a & 0377);
}

@ While the preceding routines all work during the input phase,
the following routine is called at the end of phase two. It outputs
the sections collected before.
@<Output all exports@>=
output_export_section(exp_sec,Exp_file,"export");
output_export_section(shr_sec,Shr_file,"shared");

@
@<Predecl...@>=
void output_export_section();

@ This seems to be almost the same as |@<Write all the named output files@>|.
But note that we have to take into account that two consecutive
elements of |text_info| can point to the same location in |tok_mem| because
the first one is that of |exp_sec| and the second one is that of
|shr_sec|.
Therefore, we have to be careful when setting the |cur_end| pointer.
@c
void
output_export_section(sec,file,sec_name)
export_section *sec;
FILE *file;
char *sec_name;
{
  int i;
  name_pointer name;
  FILE *old_C_file;
  static char *comments[]={
    NULL,
    "typedefs & aggregates",
    "prototypes & declarations"
  };

  if(!file) return;
  old_C_file=C_file;
  C_file=file;
  cur_line=1;
  name=id_lookup(sec_name,sec_name+strlen(sec_name),0);
  for(i=0;i<num_export_sections;i++) {
    if(sec[i].first_text) {
      name->equiv=(char *)sec[i].first_text;
      stack_ptr=stack+1;
      cur_name=name;
      cur_repl=(text_pointer)cur_name->equiv;
      cur_byte=cur_repl->tok_start;
      set_cur_end();
      cur_section=0;
      if(comments[i]) {
	C_printf("/*%s*/",comments[i]);
	flush_buffer();
      }
      while(stack_ptr>stack) get_output();
      flush_buffer();
    }
    if(!i)
      @<Output transitive import |#include|s@>@;
  }
  C_file=old_C_file;
}

@*Dependency file.
The dependency file contains all the other chapters our
current chapter depends on. All dependency files are stored
relative to the environment variable |DEPDIR| in a subdirectory
with the same name as the book.
@<Global...@>=
char dep_dir[max_file_name_length]; /* environment variable {\tt DEPDIR} */

@ The dependencies of our current chapter are stored in a dependency list
|dep_head|
with nodes of type |dependency_node|. Every node contains the name of the
imported chapter/book, whether it should be transitively passed on to users
of our chapter and a type field which can have one of the following values.
@d dep_import_chapter 1	      /* chapter name of same book */
@d dep_from_program_import 2  /* import from which program */
@d dep_from_library_import 3  /* import from which library */
@d dep_book_chapter 4	      /* which chapters of a foreign book we import */
@d dep_import_program 5       /* we import the whole program */
@d dep_import_library 6       /* we import the whole library */

@<Predecl...@>=
struct dependency_node {
  struct dependency_node *next;
  sixteen_bits dep_type;
  boolean exported;     /* transitive? */
  eight_bits name[2];	/* may grow depending on the real name length */
};

@ The root of the dependency list is stored in |dep_head|.
@<Global...@>=
struct dependency_node *dep_head;

@
@<Set init...@>=
dep_head=NULL;

@
@<Predecl...@>=
static void directly_depending_on();

@ All chapters and books we are directly depending on, are stored in the
dependency list.
Each entry in the list is unique.
Memory for dependency nodes is allocated dynamically.
@c
static void
directly_depending_on(name,type,exported)
  char *name;
  sixteen_bits type;
  boolean exported;
{
  struct dependency_node *d_node,*tail;

  if(dep_head)
    for(tail=dep_head;tail->next;tail=tail->next)
      if(type==tail->dep_type && strcmp(name,tail->name)==0) {
	tail->exported|=exported;
	return;
      }
  d_node=(struct dependency_node *)malloc(sizeof(struct dependency_node)+strlen(name)-1);
  if(!d_node) fatal("! No memory for dependency node:",name);
@.No memory for dependency node@>
  strcpy(d_node->name,name);
  d_node->dep_type=type;
  d_node->exported=exported;
  d_node->next=NULL;
  if(dep_head==NULL) dep_head=d_node;
  else tail->next=d_node;
}

@ If we depend on certain other chapters or books, and we want to pass
these dependencies on to users of our chapter (transitive imports),
we insert |#include|s for what we use in our export/shared file.

References to other chapters in our book are only inserted in shared files,
since we do not want to pass shared information on to other books.
@<Output transitive import |#include|s@>=
{
  struct dependency_node *d_node;
  char *ext;

  if(dep_head) {
    C_printf("%s","/* transitive import includes */");
    flush_buffer();
  }
  for(d_node=dep_head;d_node;d_node=d_node->next)
    if(d_node->exported) {
      if(d_node->dep_type==dep_from_program_import ||
	 d_node->dep_type==dep_from_library_import) continue;
      if(d_node->dep_type==dep_import_chapter) {
	ext="shr";
	if(file==Exp_file)  /* don't include shared files in export files */
	  continue;
      }
      else ext="exp";
      C_printf("#include \"%s",d_node->name);
      C_printf(".%s\"",ext);
      flush_buffer();
    }
}

@ Write includes for files we are directly depending on.
@<Output direct import |#include|s@>=
{
  struct dependency_node *d_node;

  if(dep_head) {
    C_printf("%s","/* direct import includes */");
    flush_buffer();
  }
  for(d_node=dep_head;d_node;d_node=d_node->next)
    if(d_node->dep_type!=dep_from_program_import && d_node->dep_type!=dep_from_library_import)
      if(d_node->exported==0 || (used_exports & exp_shared)==0) {
	C_printf("#include \"%s",d_node->name);
	C_printf(".%s\"",d_node->dep_type==dep_import_chapter?"shr":"exp");
	flush_buffer();
      }
}

@ In order to keep track of dependencies, \.{mCTANGLE} creates so called
dependency files in the directory
\.{\$(DEPDIR)/$\langle\hbox{\it bookname}\rangle$}, one for the book
and each chapter.
@<Glo...@>=
FILE *book_dep_file;
char dep_file_name[max_file_name_length];

@ The dependency file for the book only states the chapters the book
consists of.
@<Open dependency file for book@>=
{
  exp_file_name_of(dep_file_name,file_name[0],".dep");
  book_dep_file=fopen(dep_file_name,"w");
  if(!book_dep_file)
    fatal("! Cannot create dependency file for book:",dep_file_name);
@.Cannot create dependency file...@>
}

@ The dependency file for a chapter contains a list of all files
the chapter directly depends on. Each entry is on a line of its own.
It starts either with a space or an asterisk '\.{*}', the latter
is indicating that this dependency is exported to other books using
this chapter. Following this, the dependency type as a number is written.
This can be |dep_book_chapter|, |dep_from_library_import| and so on.

The rest of the line contains the name of the book or chapter we
depend on.
@<Write dependency file for chapter@>=
{
  FILE *chapter_dep_file;
  struct dependency_node *d_node;

  exp_file_name_of(dep_file_name,chapter_name,".dep");
  chapter_dep_file=fopen(dep_file_name,"w");
  if(!chapter_dep_file)
    fatal("! Cannot create dependency file for chapter:",dep_file_name);
@.Cannot create dependency file...@>
@#
  for(d_node=dep_head;d_node;d_node=d_node->next)
    fprintf(chapter_dep_file,"%c%d %s\n",d_node->exported?'*':' ',
	    d_node->dep_type,d_node->name);
@#
  fclose(chapter_dep_file);
  chapter_dep_head[chapter_no]=dep_head; /* dependency list for our chapter */
}

@ In case a retranslation of the current chapter is not necessary,
we read the old dependency file in order to know which files we are
directly depending on.
@<Read dependency file of chapter@>=
{
  FILE *chapter_dep_file;
  int type;
  char *cp,exp;

  dep_head=NULL;     /* reset dependency list */
  exp_file_name_of(dep_file_name,chapter_name,".dep");
  chapter_dep_file=fopen(dep_file_name,"r");
  if(!chapter_dep_file)
    err_print("! No dependency file\n");
@.No dependency file@>
  else {
    while(fgets(buffer,sizeof(buffer),chapter_dep_file)) {
      cp=strchr(buffer,'\n');
      if(cp) *cp=0;
      sscanf(buffer,"%c%d",&exp,&type);
      cp=strchr(buffer+1,' ');
      if(!cp) continue;
      cp++;
      directly_depending_on(cp,type,exp!=' ');
    }
    fclose(chapter_dep_file);
  }
}

@*1Full dependencies of all chapters.
Up to now, we only have the direct dependencies of all chapters,
i.e.~the dependencies we know as a result of import commands.
We now want to use the dependency files to find all parts
each chapter depends on. This is done after we have translated all
chapters.

The dependency list |dep_head| for chapter $i$
with all direct dependencies lies in |chapter_dep_head[i]|.

@
@<Predecl...@>=
void create_dependencies();
void add_transitive_deps();
void add_chapter_to_dep();
void add_book_to_dep();

@ For our \.{makefile}
we also have to know indirect dependencies. All those together form
the make dependencies. They are collected in a separate list for each chapter.
@<Type...@>=
struct make_dep {
  struct make_dep *next;
  char name[2];
};

@ Dependencies for each chapter.
@<Glo...@>=
struct make_dep *ch_make_dep[max_chapters];

@ Let chapter |ch| depend on |name|.
@c
struct make_dep *
add_make_dep(ch,name)
  char *name;
{
  struct make_dep *md,*last_md;
  for(md=ch_make_dep[ch];md;md=md->next) {
    if(!strcmp(md->name,name)) return NULL;
    last_md=md;
  }
  md=(struct make_dep *)malloc(sizeof(struct make_dep)+strlen(name)-1);
  if(!md) fatal("! No memory"," for make dependency name");
@.No memory@>
  md->next=NULL;
  strcpy(md->name,name);
  if(ch_make_dep[ch]) last_md->next=md;
  else ch_make_dep[ch]=md;
  return md;
}

@ Since \CEE/ programs are also linked together, we need to keep track of
all books our current book is depending on. Books can either be other
programs related to our book or libraries. If it's a program or a library
is stored in the |type| member of the following structure.
@<Type...@>=
struct book_node {
  struct book_node *next;
  int type;
  char name[2];
};

@ We keep a linked list of all books we are related to.
@<Glo...@>=
struct book_node *books_head;

@ Let us depend on book |name| which is of type |type|.
@c
struct book_node *
add_book_dep(type,name)
  char *name;
{
  struct book_node *bn,*last_bn=NULL,*found=NULL,*last_found;
  for(bn=books_head;bn;bn=bn->next) {
    if(!strcmp(bn->name,name)) {  /* book already in list */
      found=bn;
      last_found=last_bn;
    }
    last_bn=bn;
  }
  if(found) {    /* the book is not new, but already part of the list */
#ifdef MOVE_TO_TAIL
    if(found!=last_bn) { /* if not already there, move |found| to tail of list */
      if(last_found) last_found->next=found->next;
      else books_head=found->next;
      last_bn->next=found;
      found->next=NULL;
    }
#endif
    return NULL;
  }
  bn=(struct book_node *)malloc(sizeof(struct book_node)+strlen(name)-1);
  if(!bn) fatal("! No memory"," for book dependency name");
@.No memory@>
  bn->next=NULL;
  bn->type=type;
  strcpy(bn->name,name);
  if(books_head) last_bn->next=bn;
  else books_head=bn;
  return bn;
}

@ For each chapter $0\le ch<chapter\_no$ we have to collect all dependencies,
so that we know which files our chapters depends on. This information is
useful in order to create \.{makefile}-dependency constants.
@c
void
create_dependencies(ch)
{
  struct dependency_node *dep;
  char *cp;

  ch_make_dep[ch]=NULL;
  for(dep=chapter_dep_head[ch];dep;dep=dep->next)
    if(dep->dep_type==dep_import_chapter) {
      strcpy(dep_file_name,dep->name);
      cp=file_name_ext(dep_file_name);
      if(cp) *cp=0;
      strcat(dep_file_name,".shr");
      add_make_dep(ch,dep_file_name);
      exp_file_name_of(dep_file_name,dep->name,".dep");
      add_chapter_to_dep(ch,dep_import_chapter);
    }
  for(dep=chapter_dep_head[ch];dep;dep=dep->next)
    add_transitive_deps(ch,dep->dep_type,dep->name);
}

@ Each dependency node can have dependencies on its own. We call such
dependencies {\it transitive}. The following function recursivly
adds all transitive dependencies of the given dependency (|type| and
|name| stated) to the dependency list of chapter |ch|.
@c
void
add_transitive_deps(ch,type,name)
  char *name;
{
  char *cp;

  strcpy(dep_file_name,dep_dir);
  strcat(dep_file_name,name);
  cp=file_name_ext(dep_file_name);
  if(cp) *cp=0;
  strcat(dep_file_name,".dep");
  switch(type) {
  case dep_from_program_import:
  case dep_from_library_import:
    add_book_dep(type==dep_from_program_import?book_program:book_library,name);
    break;
  case dep_book_chapter:
    add_chapter_to_dep(ch,type);
    break;
  case dep_import_program:
  case dep_import_library:
    add_book_dep(type==dep_import_program?book_program:book_library,name);
    add_book_to_dep(ch);
    break;
  }
}

@ After a |dep_from_program_import| or a |dep_from_library_import| there
are a couple of |dep_book_chapter| nodes that indicate the chapters of
the given book we are depending on. Each chapter's dependencies are
added to our dependency list.

The file name of the dependency file can already be found in |dep_file_name|.
@c
void
add_chapter_to_dep(ch,type)
{
  FILE *f;
  char *cp,exp,*buf,*depname;

  if(type==dep_book_chapter) {  /* add export file to make dependency list */
    cp=dep_file_name+strlen(dep_file_name)-3;
    strcpy(cp,"exp");
    if(!add_make_dep(ch,dep_file_name))   /* add it */
      return;   /* was already there */
    strcpy(cp,"dep");
  }
  f=fopen(dep_file_name,"r");
  if(!f) {
    printf("\n! Cannot open chapter dependency file %s\n",dep_file_name);
@.Cannot open chapter dependency file@>
    mark_error;
    return;
  }
  while(fgets(buffer,sizeof(buffer),f)) {
    cp=strrchr(buffer,'\n');
    if(cp) *cp=0;     /* remove newline */
    sscanf(buffer,"%c%d",&exp,&type);
    if(exp==' ') continue;      /* no transitive dependency */
    cp=buffer+1;
    while(isdigit(*cp)) cp++;
    while(isspace(*cp)) cp++;
    buf=strmem(cp);
    depname=strmem(dep_file_name);
    add_transitive_deps(ch,type,buf);
    strcpy(dep_file_name,depname);
    free(depname);
    free(buf);
  }
  fclose(f);
}

@ This adds the whole book to the dependency list of chapter |ch|.
The book's dependency file only gives the various chapters.
@c
void
add_book_to_dep(ch)
{
  FILE *f;
  char *cp;

  f=fopen(dep_file_name,"r");
  if(!f) {
    printf("\n! Cannot open book dependency file %s\n",dep_file_name);
@.Cannot open book dependency file@>
    mark_error;
    return;
  }
  while(fgets(buffer,sizeof(buffer),f)) {
    cp=strrchr(buffer,'\n');
    if(cp) *cp=0;
    cp=file_name_part(dep_file_name);
    strcpy(cp,buffer);
    strcat(cp,".dep");
    add_chapter_to_dep(ch,dep_book_chapter);
  }
  fclose(f);
}

@*Import commands.
Of course, if we can export something we also have to have the
possibility of importing data. In the following sections we will
deal with import. There are three different sources where we can
import from. First of all we can import data from another chapter
of the same book, or we can import data from another book, which
can either be a library or another program.

Chapters from the same book are imported using \&{import chapter} $\langle$\.{chapter}%
$\rangle$ $\{,\langle$\.{chapter}$\rangle\}$.
If we want to import someting from a library,
we either write \&{import} \&{library} $\langle$\.{book}$\rangle$ $\{,\langle$%
\.{book}$\rangle\}$ in order
to import all chapters of that book, or we write
\&{from} \&{library} $\langle$\.{book}$\rangle$ \&{import}
$\langle$\.{chapter}$\rangle$ $\{,\langle$\.{chapter}$\rangle\}$
if we only want to import some chapters of a library. If we want to
import from another program rather than from a library we simply exchange
the keyword \&{library} by \&{program}.

Like export commands, import commands are handled during phase one, since
we need them before we start with phase two. When we encounter an import
command, we store a reference to the corresponding token in the array
|import_ref|. After we have read a full section, we make a closer look
on these commands. This ensures, that all commands have been properly
tokenized when we are parsing them.

Import commands can also be transitive, which means, that
this import command should be automatically
exported to another \.{CWEB} file, that imports the current one.
Transitive import commands are written into the dependency file, so other
programs will automatically depend on them.
@d max_imports 64
@<Glob...@>=
eight_bits *import_ref[max_imports];
sixteen_bits import_idx;	/* last unused |import_ref| */

@
@<Set init...@>=
import_idx=0;

@
@<Predecl...@>=
void remember_import();

@ This is called whenever |scan_repl| sees an import command like \&{import}.
@c
void
remember_import()
{
  if(import_idx>=max_imports) overflow("imports per section");
  import_ref[import_idx]=tok_ptr;
  import_idx++;
}

@
@<Predecl...@>=
void process_imports();

@ Now we have read in a section and it contains |import_idx| import
commands. Now we will handle them.
@c
void process_imports()
{
  int i,j;
  eight_bits *tk;
  sixteen_bits a;
  boolean exported;	      /* should current import command be exported? */
  char name[max_quoted_name];

  for(i=j=0;i<import_idx;i++) {
    tk=import_ref[i];
    exported=0;  /* default: not transitive */
    if(0200<=*tk && *tk<0250) {	/* import keyword is an identifier */
      a=(tk[0]-0200) << 8 | tk[1];
      tk+=2;	/* skip the keyword */
      if(a==id_from)
	@<we encountered {\bf from} at |tk|@>
      else if(a==id_import)
	@<we encountered {\bf import} at |tk|@>
    }
    if(exported) used_exports|=exp_export;
  }
  import_idx=0;
}

@
@<Predecl...@>=
static eight_bits *get_quoted_name();

@ If |tk| points to the beginning of a |string|, we get the string into
|buffer| up to a maximum number of |max_quoted_name-1| characters.
@d max_quoted_name 60
@c
static eight_bits *
get_quoted_name(tk,buffer)
eight_bits *tk,*buffer;
{
  int i=0;
  if(*tk==string) tk+=2;
  do {
    if(i>=max_quoted_name-1) {
      buffer[max_quoted_name-1]=0;
      fatal("! Name too long:",buffer);
@.Name too long@>
    }
    buffer[i++]=*tk;
  } while(*++tk!=string);
  buffer[i-1]=0;
  return ++tk;
}

@ If we have encountered an import statement like
$$\hbox{\#\&{from library} \.{"libdir/mylib"} \&{import} [\&{transitively}]
|"chapter_one"|, |"chapter_three"|}$$
\noindent
then we must insert a dependency node for the book (type |dep_from_import|)
and for every stated chapter (type |dep_book_chapter|).

All chapter names are relative to the book directory.
@<we encountered {\bf from...@>=
{
  eight_bits *cp=tk-2;
  char *ch_name;
  int dep_type;

  if(0200<=*tk && *tk<0250) {	/* import keyword followed by another identifier */
    a=(tk[0]-0200) << 8 | tk[1];
    tk+=2;
    if(a==id_program || a==id_library) {
      if(*tk==string) {  /* a string should follow */
	tk=get_quoted_name(tk,name);
	@<|name|$\leftarrow$|name|\.{/}|name|@>;
	dep_type=a==id_program?dep_from_program_import:dep_from_library_import;
	ch_name=file_name_part(name); /* all chapters are relative to book directory */

	if(0200<=*tk && *tk<0250) {
	  a=(tk[0]-0200) << 8 | tk[1];
	  tk+=2;
	  if(a==id_import) {  /* might be follow by transitively */
	    if(0200<=*tk && *tk<0250 && (tk[0]-0200) << 8 | tk[1]==id_transitively) {
	      exported=1;
	      tk+=2;
	    }
	    directly_depending_on(name,dep_type,exported);
	    while(*tk==string) {
	      tk=get_quoted_name(tk,ch_name);
	      directly_depending_on(name,dep_book_chapter,exported);
	      if(*tk==',') tk++;
	    }
	  }
	  else err_print("! 'import' expected after book name");
@.'import' expected after book name@>
	}
	else err_print("! 'import' expected after book name");
      }
      else err_print("! Import from where?");
@.Import from where...@>
    }
    else err_print("! Import source must be program or library");
@.Import source must be...@>
  }
  else err_print("! Import from where (program or library)?");
  do *cp++=ignore;while(cp<tk);   /* remove import command from token list */
}

@ In |name| we can find the name of the book we import from.
Since the name of the export file is
\.{\$(DEPDIR)/{\it bookname}/{\it bookname}.exp}, we double |name|,
which means that for a string |"mybook"| we create a string
|"mybook/mybook"|.
@<|name|$\leftarrow$|name|\.{/}|name|@>=
{
  if(!strchr(name,file_name_separator)) {
    int len=strlen(name);
    strcpy(name+len+1,name);
    name[len]=file_name_separator;
  }
}


@ If we see a statement like
$$\hbox{\#\&{import chapter} |"chapter_two"|}$$
\noindent
we must insert a dependency node of type |dep_import_chapter| for each chapter.
In case of a program or library like
$$\hbox{\#\&{import program} |"book_two/book_two"|, |"book_three/book_three"|}$$
\noindent we must create a dependency node of type |dep_import_program| for
each book.
\&{import} might be followed by \&{transitively}.
@<we encountered {\bf import...@>=
{
  eight_bits *cp=tk-2;
  int type;

  if(0200<=*tk && *tk<0250 && (tk[0]-0200)<<8|tk[1]==id_transitively) {
    tk+=2;
    exported=1;   /* import transitively */
  }
  if(0200<=*tk && *tk<0250) {	/* import keyword followed by another identifier */
    a=(tk[0]-0200) << 8 | tk[1];
    tk+=2;
    if(a==id_chapter || a==id_program || a==id_library) {
      if(*tk==string) {  /* a string should follow */
	while(*tk==string) {
	  tk=get_quoted_name(tk,name);
	  if(a==id_chapter)
	    type=dep_import_chapter;
	  else {
	    @<|name|$\leftarrow$|name|\.{/}|name|@>;
	    if(a==id_program) type=dep_import_program;
	    else type=dep_import_library;
	  }
	  directly_depending_on(name,type,exported);
	  if(*tk==',') tk++;
	}
      }
      else err_print("! Import what?");
@.Import what?@>
    }
    else err_print("! Import source must be chapter, program or library");
@.Import source must be...@>
  }
  else err_print("! Import from where (chapter, program or library)?");
@.Import from where...@>
  do *cp++=ignore;while(cp<tk);   /* remove import command from token list */
}

@**Book file.
Since we want to support both, the book and the non-book style, we have to
look at the given file if it is a book file or an ordinary \.{CWEB} file.
In the latter case, we tangle it as usual. If we find a book file,
we have to do more than the original \.{CTANGLE} did.

@ References to \.{mcommon.w}.
@d longest_name 1000
@d long_buf_size (buf_size+longest_name)
@d max_include_depth 10
@<Pred...@>=
extern char buffer[long_buf_size];
extern char file_name[max_include_depth][max_file_name_length];
extern char alt_web_file_name[max_file_name_length];
extern char **argv_web,**argv_change,**argv_out;

@
@d no_book 0
@d book_program 1  /* book type */
@d book_library 2
@<Glob...@>=
char book_file_name[max_file_name_length];/* name of book file */
char book_name[max_file_name_length];     /* name of book (no path) */
char chapter_name[max_file_name_length];  /* name of current chapter */
extern char change_file_name[max_file_name_length];
char out_file_name[max_file_name_length]; /* name of \CEE/ file */
char makefile_name[max_file_name_length]; /* name of makefile */
char book_dir[max_file_name_length];  /* directory of current book */

@ Each book can have up to |max_chapters| chapters.
For each chapter, we have a couple of dependencies and the name of the
\CEE/ file.
@d max_chapters 64
@<Glob...@>=
int chapter_no;  /* current chapter number */
struct dependency_node *chapter_dep_head[max_chapters];
char *ch_C_name[max_chapters];  /* \CEE/ file name for each chapter */

@ \.{mCTANGLE} supports both, new \lq book\rq-style
files and the original \.{CWEB} input files. The following section
checks, if the given file is a book or not.

Book files have the file extension \.{prg} or \.{lib}, or the \.{+m} flag set.
If it's a book,
read it to find out which chapters it consists of,
translate all its chapters, create the makefile and |return|.
If it is an old style \.{CWEB} program, just continue and it
will be translated the same way as \.{CTANGLE} did.
@^system dependencies@>
@<Check for book...@>=
{
  int ret_val=0,len,ch;
  char *e,*cp;

  e=getenv("DEPDIR");
  if(e) {
    strcpy(dep_dir,e);
    strcat(dep_dir,file_name_sep_str);    /* ready to add filename */
  }
  else fatal("! Environment variable not set:","DEPDIR");
@.Environment variable DEPDIR not set@>

  @<Check if we should append \.{.prg} to |file_name[0]|@>;
  len=strlen(file_name[0]);
  if(!strcmp(file_name[0]+len-4,".prg") || flags['m']) {
    change_file=NULL;
    reset_input();
    strcpy(book_file_name,file_name[0]);
    @<Get book directory@>;
    @<Construct |book_name| out of |book_file_name|@>;
    @<Open the book export file@>;
    @<Open dependency file for book@>;
    if(show_progress) printf("Book '%s'\n",book_name);
    @<Read book file@>;
    fclose(file[0]);
    if(change_file) {
      fclose(change_file);
      change_file=NULL;
    }
    @<Translate all chapters@>;
    if(*makefile_name) {
      if(show_progress) printf("\nMakefile:%s\n",makefile_name);
      for(ch=0;ch<chapter_no;ch++)
	create_dependencies(ch);
      @<Create Makefile@>;
    }
    if(history>harmless_message) ret_val|=1;
    fclose(book_dep_file);
    @<Close the book export file@>;
    if(ret_val) printf("\n(Book not successfully translated.)\n");
    else if(show_happiness) printf("\n(Book successfully translated.)\n");
    return ret_val;
  }
}

@ If the web file argument is a file without a file extension, we try
give it \.{.prg}. If this files exists,
|file_name[0]| gets the \.{.prg} extension appended.
@<Check if we should append \.{.prg} to |file_name[0]|@>=
{
  char *cp;
  FILE *f;
  strcpy(a_file_name,*argv_web);
  if(!file_name_ext(a_file_name)) {   /* if no file extension */
    cp=a_file_name+strlen(a_file_name);
    strcpy(cp,".prg");
    if((f=fopen(a_file_name,"r"))!=NULL) {   /* \.{.prg} file exists */
      fclose(f);
      strcpy(file_name[0],a_file_name);
    }
  }
}

@ Now we read the book file line by line. We skip everything but commands
introduced by '\.{@@}'. All chapters are remembered for later processing.
@<Read book file@>=
while(get_line()) {
  while(loc<limit) {
    if(*loc++=='@@') {
      switch(*loc++) {
      case '@@':break;
      case 'c': @<Remember chapter@>;@+break;
      case 'm': @<Copy Makefile@>;@+break;
      default: err_print("! Illegal @@ command in book");
@.Illegal @@ command in book@>
      }
    }
  }
}

@ When we first scan the book file, we only remember the chapters we have
seen together with optional change and output file names.
@<Glob...@>=
  char *ch_web_name[max_chapters];
  char *ch_change_name[max_chapters];
  char *ch_out_name[max_chapters];
  int n_chapters_remembered;

@ This is called if we encounter a \.{@@c} in a book file.
It stores the chapter name in the arrays defined above.
@<Remember chapter@>=
{
  char *cp;
  if(n_chapters_remembered>=max_chapters)
    overflow("chapters");
  *limit=0;
  cp=get_name(loc,a_file_name);
  if(cp) {
    loc=cp;
    ch_web_name[n_chapters_remembered]=strmem(a_file_name);
    ch_change_name[n_chapters_remembered]=NULL;
    ch_out_name[n_chapters_remembered]=NULL;
    cp=get_name(loc,a_file_name);
    if(cp) {
      loc=cp;
      ch_change_name[n_chapters_remembered]=strmem(a_file_name);
      cp=get_name(loc,a_file_name);
      if(cp) {
	loc=cp;
	ch_out_name[n_chapters_remembered]=strmem(a_file_name);
      }
    }
    n_chapters_remembered++;
  }
  else err_print("! Chapter name expected");
@.Chapter name expected@>
}

@ At the end of the book, we translate all chapters we have seen
during the scan.
@<Translate all chapters@>=
{
  char *change_exists,*out_exists;
  for(chapter_no=0;chapter_no<n_chapters_remembered;chapter_no++) {
    if(show_progress) printf("\nChapter %d:",chapter_no+1);
    strcpy(chapter_name,book_dir);  /* relative to book directory */
    strcat(chapter_name,ch_web_name[chapter_no]);
    change_exists=ch_change_name[chapter_no];
    if(change_exists) strcpy(change_file_name,change_exists);
    out_exists=ch_out_name[chapter_no];
    if(out_exists) strcpy(out_file_name,out_exists);
    if(show_progress) printf("%s\n",chapter_name);
    @<Tangle chapter@>;
  }
}

@ The makefile part of the book is copied to a temporary file.
We have to process it after we have tangled all chapters, because
only then we will know all relations and dependencies between them.
While copying the makefile part to a temporary file we automatically
take care of an optional change file.
@<Copy Makefile@>=
{
  *limit=0;
  if(!get_name(loc,makefile_name))
    strcpy(makefile_name,"Makefile");
  tmp_makefile=tmpfile();
  if(!tmp_makefile) fatal("! Cannot create temporary file ","for makefile");
@.Cannot create temporary file...@>
  while(get_line()) {
    *limit=0;
    fprintf(tmp_makefile,"%s\n",buffer);
  }
  rewind(tmp_makefile);
}

@
@<Predecl...@>=
char *strmem();

@ The following function copies the given string |s| to allocated memory.
@c
char *strmem(s)
  char *s;
{
  char *cp=malloc(strlen(s)+1);
  if(!cp) fatal("! No memory for string ",s);
@.No memory@>
  return strcpy(cp,s);
}

@ We store the directory part of the book name because we need it
later, since all chapters are searched relative to that.
@<Get book directory@>=
strcpy(book_dir,book_file_name);
cp=file_name_part(book_dir);
*cp=0;

@ |book_name| is |book_file_name| without |book_dir| and without
file extension.
@<Construct |book_name| out of |book_file_name|@>=
cp=file_name_part(file_name[0]);
strcpy(book_name,cp);
cp=file_name_ext(book_name);
if(cp) *cp=0;

@
@<Predecl...@>=
char *file_name_ext();
char *file_name_part();
void to_parent();

@ Returns the file name part of path |s|. Never returns |NULL|.
Please change the |file_name_separator| for non-\UNIX/ systems.
@^system dependencies@>
@d file_name_separator '/'
@d file_name_sep_str "/"
@c
char *
file_name_part(s)
  char *s;
{
  char *slash_pos;
  slash_pos=strrchr(s,file_name_separator);
  if(slash_pos) slash_pos++;
  else slash_pos=s;
  return slash_pos;
}

@ Strips the filename from a full path.
@c
void to_parent(s)
  char *s;
{
  char *cp=file_name_part(s);
  if(cp==s) *cp=0;
  else cp[-1]=0;
}

@ Returns a pointer to the file name extension (e.g.~to |".exp"|) or |NULL|.
@c
char *
file_name_ext(s)
  char *s;
{
  return strrchr(file_name_part(s),'.');
}

@
@<Predecl...@>=
char *get_name();

@ Copies a name from |cp| to |buffer|. The name maybe be optionally quoted
and preceded by white space.
@c
char *
get_name(cp,buffer)
  char *cp,*buffer;
{
  int i;

  while(isspace(*cp)) cp++;
  if(*cp==QUOTE) {
    cp++;
    for(i=0;i<max_file_name_length;i++)
      if(*cp==QUOTE) {
	*buffer=0;
	return ++cp;
      }
      else *buffer++=*cp++;
  }
  else {
    for(i=0;i<max_file_name_length;i++)
      if(!*cp || isspace(*cp)) {
        *buffer=0;
        if(!i) return 0;
        return cp;
      }
      else *buffer++=*cp++;
  }
  *buffer=0;
  return 0;
}

@ Invokes \.{CTANGLE} on one of its chapters. The name of the chapter to
translate is |chapter_name|, its change file is stored in |change_file_name|
if |change_exists!=NULL|, and the corresponding output file can be found in
|out_file_name| if |out_exists!=NULL|.

We create a new |argv| with these names and call |tangle_file| to start
the original version of \.{CTANGLE}.
@<Tangle chapter@>=
{
  int i;
  char **new_argv,**argv_ptr,*cp;
  boolean retranslate;
  boolean has_exp_file=0;

  argc=ac;
  new_argv=argv=(char **)malloc((argc+3)*sizeof(char *));
  if(!argv) fatal("! No memory, cannot tangle ",chapter_name);
  for(i=0;i<argc;i++) argv[i]=av[i];

  argv_ptr=argv+(argv_web-av);
  *argv_ptr=chapter_name;
  if(argv_change) *argv_change="-";
  cp=file_name_part(chapter_name);  /* make \CEE/ file name from chapter name */
  if(argv_out) *argv_out=cp;
  ch_C_name[chapter_no]=malloc(strlen(cp)+1);
  if(!ch_C_name[chapter_no]) fatal("! No memory"," for C file name");
@.No memory@>
  strcpy(ch_C_name[chapter_no],cp);
  if(change_exists) {
    if(argv_change) argv_ptr=argv+(argv_change-av);
    else argv_ptr=&argv[argc++];
    *argv_ptr=change_file_name;
    if(out_exists) {
      if(argv_out) argv_ptr=argv+(argv_out-av);
      else argv_ptr=&argv[argc++];
      *argv_ptr=out_file_name;
      ch_C_name[chapter_no]=realloc(ch_C_name[chapter_no],strlen(out_file_name)+1);
      if(!ch_C_name[chapter_no]) fatal("! No memory"," for C file name");
      strcpy(ch_C_name[chapter_no],out_file_name); /* override \CEE/ file name */
    }
  }

  fprintf(book_dep_file,"%s\n",chapter_name);

  @<Retranslation of chapter necessary? $\rightarrow$ |retranslate|@>;

  history=0;
  if(retranslate) {
    @<Open representation file for writing and write change file name@>@;
    ret_val|=tangle_file();  /* tangle it with these arguments */
    @<Close rep...@>;
  }
  else {
    if(has_exp_file) {    /* it has an export file, include it in book export file */
      char *cp=exp_file_name_of(a_file_name,chapter_name,".exp");
      fprintf(book_exp_file,"#include \"%s\"\n",cp);
    }
    rep_file=NULL;
    printf("(Skipped.)\n");
    @<Read dependency file of chapter@>;
  }

  @<Write dependency file for chapter@>;

  free(new_argv);
}

@
@<Include...@>=
#include <sys/stat.h>

@
@<Glo...@>=
extern FILE *rep_file;
char rep_file_name[max_file_name_length];

@ A chapter only is retranslated if it is really necessary, because otherwise
the compiler will also recompile the resulting \CEE/ file. This would result
in very bad turnaround times and therefore is unacceptable.

In order to be able to check if we must retranslate our current chapter,
we store the name of its change file and all files included by means of
\.{@@i} in a separate file called the representation file.

Our chapter must only be retranslated, if the resulting \CEE/ file is older
than either the corresponding \.{WEB} file, a possibly existing change file
or one of the included files.
If the name of the change file has changed since last retranslation or if
the representation file does not exist yet, we also have to translate the
chapter.
@^represention file@>
@<Retranslation of chapter necessary? $\rightarrow$ |retranslate|@>=
{
  char *cp;
  struct stat s_C,s;

  retranslate=0;    /* assume no retranslation */
  strcpy(buffer,ch_C_name[chapter_no]);
  cp=file_name_ext(buffer);
  if(!cp) strcat(buffer,".c");
  if(stat(buffer,&s_C)) retranslate=1;
  strcpy(buffer,chapter_name);
  cp=file_name_ext(buffer);
  if(!cp) {
    cp=buffer+strlen(buffer);
    strcat(buffer,".w");
  }
  if(stat(buffer,&s)) { /* check if \.{CWEB} file is newer than \CEE/ file */
    sprintf(buffer,"%s.web",chapter_name);
    if(stat(buffer,&s))
      fatal("! Cannot find chapter: %s\n",chapter_name);
@.Cannot find chapter@>
  }
  if(s_C.st_mtime<s.st_mtime) retranslate=1;
  if(cp) *cp=0;
  strcat(buffer,".rep");
  cp=file_name_part(buffer);
  strcpy(rep_file_name,cp);
  rep_file=fopen(rep_file_name,"r");      /* open the representation file */
  if(rep_file) {
    fgets(buffer,sizeof(buffer),rep_file);
    cp=strrchr(buffer,'\n');
    if(cp) *cp=0;
    if(strcmp(buffer,change_file_name)) /* same change file? */
      retranslate=1;      /* no */
    if(*buffer && strcmp(buffer,"-") && strcmp(buffer,"/dev/null")) {
      /* if given, check if change file is newer */
      if(stat(buffer,&s)) retranslate=1;
      if(s_C.st_mtime<s.st_mtime) retranslate=1;
    }
    while(fgets(buffer,sizeof(buffer),rep_file)) {  /* check if included files are newer */
      cp=strrchr(buffer,'\n');
      if(cp) *cp=0;
      if(!strcmp(buffer,"*")) {   /* asterisk in a single line means chapter has export file */
	has_exp_file=1;
	continue;
      }
      if(stat(buffer,&s)) retranslate=1;
      if(s_C.st_mtime<s.st_mtime) retranslate=1;
    }
    fclose(rep_file);
  }
  else retranslate=1;   /* no representation file */
}

@ If we have decided to retranslate the current chapter, we open the
representation file for writing and already write its first line, which
always contains the change file name. Other lines containing the names of all
files included by means of \.{@@i} may follow during translation.
@<Open representation file for writing and write change file name@>=
{
  rep_file=fopen(rep_file_name,"w");
  if(!rep_file) fatal("! Cannot open representation file: ",rep_file_name);
@.Cannot open representation file@>
  fprintf(rep_file,"%s\n",change_file_name);
}

@
@<Close representation file@>=
if(rep_file) {
  if(used_exports & exp_export)    /* if chapter has an export file */
    fprintf(rep_file,"*\n");       /* write an asterisk in representation file */
  fclose(rep_file);
  rep_file=NULL;
}

@
@<Predecl...@>=
char *exp_file_name_of();

@ Dependency files and export files go to a directory which is composed of
the environment variable \.{DEPDIR}, the |book_name| (not |book_file_name|)
and the file part of |basename| who gets another |suffix|.
This file name is returned in |expname|.

|exp_file_name_of| returns a pointer to the file name part
after \.{DEPDIR} in |expname|, thus including the book name and the
file name itself.
@^system dependencies@>
@c
char *
exp_file_name_of(expname,basename,suffix)
  char *expname,*basename,*suffix;
{
  char *dot,*ret,*cp;

  strcpy(expname,dep_dir);
  ret=expname+strlen(expname);
  strcat(expname,book_name);
  strcat(expname,file_name_sep_str);
  cp=file_name_part(basename);
  strcat(expname,cp);
  dot=file_name_ext(expname);
  if(dot) *dot=0;
  strcat(expname,suffix);
  return ret;
}

@
@<Glob...@>=
FILE *book_exp_file;
char book_exp_file_name[max_file_name_length];
char a_file_name[max_file_name_length];

@ The book's export file only contains |#include| statements for all
export files created by a chapter of the book.
This makes it possible for other books to import all exported stuff from
this book.
@<Open the book exp...@>=
{
  char *cp;

  cp=exp_file_name_of(book_exp_file_name,book_file_name,"._ex");
  strcpy(a_file_name,book_exp_file_name);
  to_parent(a_file_name);
  if(!mkdir(a_file_name,S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH))
    printf("New dependency directory created: %s\n",a_file_name);
@.New dependency directory created@>
  book_exp_file=fopen(book_exp_file_name,"w"); /* and open it */
  if(!book_exp_file)
    fatal("! Cannot create export file for book:",book_exp_file_name);
@.Cannot create export file...@>
  strcpy(a_file_name,cp);
  cp=file_name_ext(a_file_name);
  if(cp) strcpy(cp,".exp");
  for(cp=a_file_name;*cp;cp++)
    if(!xisalpha(*cp)) *cp++='_';
  fprintf(book_exp_file,"#ifndef %s\n#define %s\n",a_file_name,a_file_name);
}

@
@<Close the book exp...@>=
{
  fprintf(book_exp_file,"#endif\n");
  fclose(book_exp_file);
  keep_exp_file_if_changed(".exp",book_exp_file_name);
}

@
@<Predecl...@>=
void chapter_to_book_exp();

@ The book export file contains |#include|s for all export files created
by one of the book's chapters. The following function outputs the |#include|
for the export file of the current chapter |file_name[0]|.
@c
void
chapter_to_book_exp()
{
  char *cp=exp_file_name_of(a_file_name,file_name[0],".exp");
  fprintf(book_exp_file,"#include \"%s\"\n",cp); /* write the |#include| */
}

@*1Makefile.
The last part of the book file is the \.{makefile}.
It is copied literally from the book file to |makefile_name|.
In order to support dependencies between the current book and other books
and inside the book inself, we insert some constants in the header of
the \.{makefile}.
\bigskip
\item{$\bullet$}|CHAPTERS| contains all chapters of the current book
with the extension \.{".o"}.
\item{$\bullet$}|LIBRARIES| contains all libraries our book imports from.
Each library is preceded by |LIBPREFIX| which you can define in the
makefile part.
\item{$\bullet$}For each chapter a similar named constant
(all characters that are not allowed are replaced by |'_'|)
which contains all files this particular chapter depends on.

@
@d max_col 78
@<Glo...@>=
FILE *make_file,*tmp_makefile;
int make_col;  /* column in makefile */

@
@<Predecl...@>=
void mf_print();

@ We write these constants into the \.{makefile} until we read the
|max_col| column. The following function writes a string |s| which
is preceded by |prefix| and whose extension is replaced by |ext|.
If it doesn't fit on the current line, a backslash and a newline
are output and we restart on column~1 of the next line.
@c
void
mf_print(prefix,s,ext)
  char *prefix,*s,*ext;
{
  int slen;
  char *cp;

  if(prefix) strcpy(buffer,prefix);
  else *buffer=0;
  strcat(buffer,s);
  if(ext) {
    cp=file_name_ext(buffer);
    if(cp) *cp=0;
    strcat(buffer,ext);
  }
  slen=strlen(buffer);
  make_col+=slen;
  if(make_col>=max_col) {
    fprintf(make_file,"\\\n%s",buffer);
    make_col=slen;
  }
  else fprintf(make_file,buffer);
}

@ Ok, now we create the \.{makefile}. First we open it, then we
write some helpful constants and finally we append the rest of the
book file.
@<Create Makefile@>=
{
  int i;

  make_col=0;
  make_file=fopen(makefile_name,"w");
  if(!make_file) fatal("! Cannot create makefile ",makefile_name);
@.Cannot create makefile@>
  @<Output \.{CHAPTERS}...@>;
  if(books_head)
    @<Output \.{LIBRARIES} makefile constant@>;
  @<Output makefile constant for each chapter@>;
  while(fgets(buffer,sizeof(buffer),tmp_makefile))
    fprintf(make_file,"%s",buffer);
  fclose(make_file);
  fclose(tmp_makefile);
}

@ All chapters get an |".o"| extension.
@<Output \.{CHAPTERS} makefile constant@>=
{
  mf_print(NULL,"CHAPTERS=",NULL);
  for(i=0;i<chapter_no;i++)
    mf_print(" ",ch_C_name[i],".o");
  fprintf(make_file,"\n");
  make_col=0;
}

@ Libraries get their path stripped off and are preceded by \.{\$(LIBPREFIX)}.
@<Output \.{LIBRARIES} makefile constant@>=
{
  struct book_node *bn;
  char *cp;

  mf_print(NULL,"LIBRARIES=",NULL);
  for(bn=books_head;bn;bn=bn->next)
    if(bn->type==book_library) {
      cp=file_name_part(bn->name);
      mf_print(" $(LIBPREFIX)",cp,"");
    }
  fprintf(make_file,"\n");
  make_col=0;
}

@ The dependencies of each chapter have already been collected at the
end of phase two (by a call to |create_dependencies|). The dependencies for
chapter $i$ can be found in |ch_make_dep[i]|.
@<Output makefile constant for each chapter@>=
{
  struct make_dep *md;
  char *cp;

  for(i=0;i<chapter_no;i++) {
    strcpy(buffer,ch_web_name[i]);  /* convert to makefile constant */
    for(cp=buffer;*cp;cp++)
      if(!isalnum(*cp)) *cp='_';
      else if(islower(*cp)) *cp=toupper(*cp);
    mf_print(buffer,"=",NULL);
    if(strchr(ch_C_name[i],'.')) mf_print(NULL,ch_C_name[i],NULL);
    else mf_print(NULL,ch_C_name[i],".c");
    for(md=ch_make_dep[i];md;md=md->next)
      mf_print(" ",md->name,NULL);
    fprintf(make_file,"\n");
    make_col=0;
  }
}

@
@d QUOTE '\"'

@** Index.
Here is a cross-reference table for \.{mCTANGLE}.
All sections in which an identifier is
used are listed with that identifier, except that reserved words are
indexed only when they appear in format definitions, and the appearances
of identifiers in section names are not indexed. Underlined entries
correspond to where the identifier was declared. Error messages and
a few other things like ``ASCII code dependencies'' are indexed here too.
