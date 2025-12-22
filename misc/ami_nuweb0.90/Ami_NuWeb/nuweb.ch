This file, NUWEB.CH, is part of AMI-NUWEB 0.90.
It is a changefile for NUWEB.W 0.90.  The `l.XXX' numbers refer to this
specific version of the original source code and may be out of date in
future patches.

Author:
(AS) Andreas Scherer, RWTH Aachen,
  (scherer@@genesis.informatik.rwth-aachen.de).

This document is distributed WITHOUT ANY WARRANTY, express or implied.

The following copyright notice extends to this changefile only, not to the
masterfile NUWEB.W.

Copyright (c) 1994, 1995 Andreas Scherer.  All rights destroyed.

Version history:

Version	Date		Author	Comment
a1	06 Oct 1994	AS	Set up for NUWEB.W 0.87b.
a2	07 Oct 1994	AS	Fixed an Overful \hbox error.
				Upload to CTAN (ftp.dante.de).
				Upload to AmiNet (ftp.uni-passau.de).
a3	07 Oct 1994	AS	(Evening, sorry.) Numerous refinements
				after printing the source documentation.
a4	08 Oct 1994	AS	German version implemented.
				This feature works on the Amiga only, but
				for other languages as well.
a5	09 Oct 1994	AS	Fix a newly introduced bug in the file
				comparison mechanism.
a6	10 Nov 1994	AS	Suppress indentation of macros containing
				preprocessor commands.  Fix a problem with
				`rename' in DEC Ultrix 4.4 CC.
a7	16 Nov 1994	AS	Re-fix the previous fix.  Don't use tempnam
				or tmpnam, but NUWEB.TMP instead.
a8 	28 Mar 1995	AS	Updated for version 0.90.
----------------------------------------------------------------------------

@x l.1
\documentstyle{report}
@y
\documentclass{report}
\usepackage{latexsym}

@z

@x l.54
automatically generated indices and cross-references that made it much
@y
automatically generated indexes and cross-references that made it much
@z

@x l.76
perhaps suffers from being overly Unix-dependent and requiring several
@y
perhaps suffers from being overly UNIX-dependent and requiring several
@z

@x l.228
Basically, the programmer need only type enough characters to uniquely
@y
Basically, the programmer needs only type enough characters to uniquely
@z

@x l.255
  many Unix systems since they cause the compiler's error messages to
@y
  many UNIX systems since they cause the compiler's error messages to
@z

@x l.278
Finally, there are three commands used to create indices to the macro
@y
Finally, there are three commands used to create indexes to the macro
@z

@x l.282
\item[\tt @@m] Create an index of macro name.
@y
\item[\tt @@m] Create an index of macro names.
@z

@x l.286
in the \LaTeX\ document; for example, see Chapter~\ref{indices}.
@y
in the \LaTeX\ document; for example, see
Chapter~\ifshowcode\ref{indexes}\else6\fi.
@z

@x l.372
that file.  The documentations section will be jumbled, but the
@y
that file.  The documentation sections will be jumbled, but the
@z

@x l.393
  (PRE), so macros may contain one or more A, B, I, U, or P elements
@y
  (PRE), so macros may contain one or more A, B, I, U or P elements
@z

@x l.424
never have heard or nuweb (or many other tools) without the efforts of
@y
never have heard of nuweb (or many other tools) without the efforts of
@z

@x l.450
@o global.h
@y
@o global.h -i
@z

@x l.457
We'll need at least three of the standard system include files.
@y
We'll need at least four of the standard system include files.
@z

@x l.464
toupper isupper islower isgraph isspace tempnam remove malloc size_t @}
@y
toupper isupper islower isgraph isspace remove malloc size_t @}
@z

@x l.470
definitions of \verb|TRUE| and \verb|FALSE| be default.  The following
@y
definitions of \verb|TRUE| and \verb|FALSE| by default.  The following
@z

@x l.484
The code is divided into four main files (introduced here) and five
@y
The code is divided into five main files (introduced here) and five
@z

@x l.493
It handles collection of all the file names, macros names, and scraps
@y
It handles collection of all the file names, macro names, and scraps
@z

@x l.550
Finally, for best portability, I seem to need a file containing
(useless!) definitions of all the global variables.
@o global.c
@{#include "global.h"
@y
Finally, for best portability, I seem to need a file containing
(useless!) definitions of all the global variables.

System dependent parts can be introduced here as well, e.g., on the Amiga
we introduce the capability of multilinguality in both the terminal output
and the \LaTeX\ output.  To activate the necessary variables and arrays,
the value \verb|STRINGARRAY| must be set.

@o global.c -i
@{#ifdef _AMIGA
#define STRINGARRAY 1
#endif
#include "global.h"
@z

@x l.562
@o main.c
@{
@<Operating System Dependencies@>
int main(argc, argv)
     int argc;
     char **argv;
@y
@o main.c -i
@{
@<Operating System Dependencies@>
void main(int argc, char **argv)
@z

@x l.570
  @<Interpret command-line arguments@>
  @<Process the remaining arguments (file names)@>
  exit(0);
}
@| main @}
@y
#ifdef _AMIGA
  @<Use catalog translations@>
#endif
  @<Interpret command-line arguments@>
  @<Process the remaining arguments (file names)@>
  exit(EXIT_SUCCESS);
}
@| main EXIT_SUCCESS @}
@z

@x l.578
@d Operating System Dependencies @{
#if defined(VMS)
#define PATH_SEP(c) (c==']'||c==':')
#elif defined(MSDOS)
#define PATH_SEP(c) (c=='\\')
#else
#define PATH_SEP(c) (c=='/')
#endif
@y
@d Operating System Dependencies @{
#if defined(VMS)
#define PATH_SEP(c) (c==']'||c==':')
#elif defined(MSDOS)
#define PATH_SEP(c) (c=='\\')
#elif defined(_AMIGA)
#define PATH_SEP(c) (c=='/'||c==':')
#else
#define PATH_SEP(c) (c=='/')
#endif
@z

@x l.668
      default:  fprintf(stderr, "%s: unexpected argument ignored.  ",
			command_name);
		fprintf(stderr, "Usage is: %s [-cnotv] file...\n",
			command_name);
@y
#ifdef _AMIGA
      default:  fprintf(stderr, get_string(MSG_WARNING_11B), command_name);
		fprintf(stderr, get_string(MSG_USAGE_11B), command_name);
#else
      default:  fprintf(stderr, "%s: unexpected argument ignored.  ",
			command_name);
		fprintf(stderr, "Usage is: %s [-cnotv] file...\n",
			command_name);
#endif
@z

@x l.686
    fprintf(stderr, "%s: expected a file name.  ", command_name);
    fprintf(stderr, "Usage is: %s [-cnotv] file-name...\n", command_name);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_11C), command_name);
    fprintf(stderr, get_string(MSG_USAGE_11B), command_name);
#else
    fprintf(stderr, "%s: expected a file name.  ", command_name);
    fprintf(stderr, "Usage is: %s [-cnotv] file-name...\n", command_name);
#endif
@z

@x l.688
    exit(-1);
  }
  do {
    @<Handle the file name in \verb|argv[arg]|@>
    arg++;
  } while (arg < argc);
}@}
@y
    exit(EXIT_FAILURE);
  }
  do {
    @<Handle the file name in \verb|argv[arg]|@>
    arg++;
  } while (arg < argc);
}
@| EXIT_FAILURE @}
@z

@x l.800
@{extern void pass1();
@y
@{extern void pass1(char *);
@z

@x l.813
@o pass1.c
@y
@o pass1.c -i
@z

@x l.814
@{void pass1(file_name)
     char *file_name;
@y
@{void pass1(char *file_name)
@z

@x l.818
    fprintf(stderr, "reading %s\n", file_name);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_VERBOSE_14B), file_name);
#else
    fprintf(stderr, "reading %s\n", file_name);
#endif
@z

@x l.862
    default:  fprintf(stderr,
		      "%s: unexpected @@ sequence ignored (%s, line %d)\n",
		      command_name, source_name, source_line);
@y
#ifdef _AMIGA
    default:  fprintf(stderr, get_string(MSG_WARNING_15A),
		      command_name, source_name, source_line);
#else
    default:  fprintf(stderr,
		      "%s: unexpected @@ sequence ignored (%s, line %d)\n",
		      command_name, source_name, source_line);
#endif
@z

@x l.921
\section{Writing the Latex File} \label{latex-file}
@y
\section{Writing the LaTeX File} \label{latex-file}
@z

@x l.929
If you don't like the format of definitions or indices or whatever,
@y
If you don't like the format of definitions or indexes or whatever,
@z

@x l.935
@{extern void write_tex();
@y
@{extern void write_tex(char *, char *);
@z

@x l.941
@o latex.c
@{static void copy_scrap();		/* formats the body of a scrap */
static void print_scrap_numbers();	/* formats a list of scrap numbers */
static void format_entry();		/* formats an index entry */
static void format_user_entry();
@y
@o latex.c -i
@{static void copy_scrap(FILE *);
  /* formats the body of a scrap */
static void print_scrap_numbers(FILE *, Scrap_Node *);
  /* formats a list of scrap numbers */
static void format_entry(Name *, FILE *, int);
  /* formats an index entry */
static void format_user_entry(Name *, FILE *);
@z

@x l.951
@o latex.c
@y
@o latex.c -i
@z

@x l.952
@{void write_tex(file_name, tex_name)
     char *file_name;
     char *tex_name;
@y
@{void write_tex(char *file_name, char *tex_name)
@z

@x l.959
      fprintf(stderr, "writing %s\n", tex_name);
@y
#ifdef _AMIGA
      fprintf(stderr, get_string(MSG_VERBOSE_17A), tex_name);
#else
      fprintf(stderr, "writing %s\n", tex_name);
#endif
@z

@x l.965
    fprintf(stderr, "%s: can't open %s\n", command_name, tex_name);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_17A), command_name, tex_name);
#else
    fprintf(stderr, "%s: can't open %s\n", command_name, tex_name);
#endif
@z

@x l.1023
$\langle$Interpret at-sequence {\footnotesize 18}$\rangle\equiv$
@y
${}\langle{}$Interpret at-sequence {\footnotesize 18}${}\rangle{}\equiv{}$
@z

@x l.1031
\mbox{}\verb@@    case 'o': @@$\langle$Write output file definition {\footnotesize 19a}$\rangle$\verb@@@@\\
@y
\mbox{}\verb@@    case 'o': @@${}\langle{}$Write output file
  definition {\footnotesize 19a}${}\rangle{}$\verb@@@@\\
@z

@x l.1066
  fputs(" }$\\equiv$\n", tex_file);
@y
  fputs(" }${}\\equiv{}$\n", tex_file);
@z

@x l.1080
  fprintf(tex_file, "$\\langle$%s {\\footnotesize ", name->spelling);
@y
  fprintf(tex_file, "${}\\langle{}$%s {\\footnotesize ", name->spelling);
@z

@x l.1082
  fputs("}$\\rangle\\equiv$\n", tex_file);
@y
  fputs("}${}\\rangle{}\\equiv{}$\n", tex_file);
@z

@x l.1139
    fputs("\\item File defined by scraps ", tex_file);
@y
#ifdef _AMIGA
    fputs(get_string(MSG_LATEX_20B), tex_file);
#else
    fputs("\\item File defined by scraps ", tex_file);
#endif
@z

@x l.1154
    fputs("\\item Macro defined by scraps ", tex_file);
@y
#ifdef _AMIGA
    fputs(get_string(MSG_LATEX_20C), tex_file);
#else
    fputs("\\item Macro defined by scraps ", tex_file);
#endif
@z

@x l.1163
      fputs("\\item Macro referenced in scraps ", tex_file);
@y
#ifdef _AMIGA
      fputs(get_string(MSG_LATEX_21A1), tex_file);
#else
      fputs("\\item Macro referenced in scraps ", tex_file);
#endif
@z

@x l.1167
      fputs("\\item Macro referenced in scrap ", tex_file);
@y
#ifdef _AMIGA
      fputs(get_string(MSG_LATEX_21A2), tex_file);
#else
      fputs("\\item Macro referenced in scrap ", tex_file);
#endif
@z

@x l.1173
    fputs("\\item Macro never referenced.\n", tex_file);
    fprintf(stderr, "%s: <%s> never referenced.\n",
@y
#ifdef _AMIGA
    fputs(get_string(MSG_LATEX_21A3), tex_file);
    fprintf(stderr, get_string(MSG_WARNING_21A),
#else
    fputs("\\item Macro never referenced.\n", tex_file);
    fprintf(stderr, "%s: <%s> never referenced.\n",
#endif
@z

@x l.1181
@o latex.c
@{static void print_scrap_numbers(tex_file, scraps)
     FILE *tex_file;
     Scrap_Node *scraps;
@y
@o latex.c -i
@{static void print_scrap_numbers(FILE *tex_file, Scrap_Node *scraps)
@z

@x l.1214
static void copy_scrap(file)
     FILE *file;
@y
static void copy_scrap(FILE *file)
@z

@x l.1293
  fprintf(file, "\\hbox{$\\langle$%s {\\footnotesize ", name->spelling);
@y
  fprintf(file, "\\hbox{${}\\langle{}$%s {\\footnotesize ", name->spelling);
@z

@x l.1298
    fprintf(stderr, "%s: scrap never defined <%s>\n",
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_23B),
#else
    fprintf(stderr, "%s: scrap never defined <%s>\n",
#endif
@z

@x l.1301
  fputs("}$\\rangle$}", file);
@y
  fputs("}${}\\rangle{}$}", file);
@z

@x l.1316
\subsection{Generating the Indices}
@y
\subsection{Generating the Indexes}
@z

@x l.1344
@o latex.c
@{static void format_entry(name, tex_file, file_flag)
     Name *name;
     FILE *tex_file;
     int file_flag;
@y
@o latex.c -i
@{static void format_entry(Name *name, FILE *tex_file, int file_flag)
@z

@x l.1367
    fprintf(tex_file, "$\\langle$%s {\\footnotesize ", name->spelling);
@y
    fprintf(tex_file, "${}\\langle{}$%s {\\footnotesize ", name->spelling);
@z

@x l.1369
    fputs("}$\\rangle$ ", tex_file);
@y
    fputs("}${}\\rangle{}$ ", tex_file);
@z

@x l.1379
  fputs("{\\footnotesize Defined by scrap", tex_file);
  if (p->next) {
    fputs("s ", tex_file);
    print_scrap_numbers(tex_file, p);
  }
  else {
    putc(' ', tex_file);
@y
#ifdef _AMIGA
  if (p->next) {
    fputs(get_string(MSG_LATEX_25A1), tex_file);
    print_scrap_numbers(tex_file, p);
  }
  else {
    fputs(get_string(MSG_LATEX_25A2), tex_file);
#else
  fputs("{\\footnotesize Defined by scrap", tex_file);
  if (p->next) {
    fputs("s ", tex_file);
    print_scrap_numbers(tex_file, p);
  }
  else {
    putc(' ', tex_file);
#endif
@z

@x l.1413
    fputs("Referenced in scrap", tex_file);
    if (p->next) {
      fputs("s ", tex_file);
      print_scrap_numbers(tex_file, p);
    }
    else {
      putc(' ', tex_file);
@y
#ifdef _AMIGA
    if (p->next) {
      fputs(get_string(MSG_LATEX_25C1), tex_file);
      print_scrap_numbers(tex_file, p);
    }
    else {
      fputs(get_string(MSG_LATEX_25C2), tex_file);
#else
    fputs("Referenced in scrap", tex_file);
    if (p->next) {
      fputs("s ", tex_file);
      print_scrap_numbers(tex_file, p);
    }
    else {
      putc(' ', tex_file);
#endif
@z

@x l.1425
    fputs("Not referenced.", tex_file);
@y
#ifdef _AMIGA
    fputs(get_string(MSG_LATEX_25C3), tex_file);
#else
    fputs("Not referenced.", tex_file);
#endif
@z

@x l.1443
@o latex.c
@{static void format_user_entry(name, tex_file)
     Name *name;
     FILE *tex_file;
@y
@o latex.c -i
@{static void format_user_entry(Name *name, FILE *tex_file)
@z

@x l.1508
@{extern void write_html();
@y
@{extern void write_html(char *, char *);
@z

@x l.1514
@o html.c
@{static void copy_scrap();               /* formats the body of a scrap */
static void display_scrap_ref();        /* formats a scrap reference */
static void display_scrap_numbers();    /* formats a list of scrap numbers */
static void print_scrap_numbers();      /* pluralizes scrap formats list */
static void format_entry();             /* formats an index entry */
static void format_user_entry();
@y
@o html.c -i
@{static void copy_scrap(FILE *);
  /* formats the body of a scrap */
static void display_scrap_ref(FILE *, int);
  /* formats a scrap reference */
static void display_scrap_numbers(FILE *, Scrap_Node *);
  /* formats a list of scrap numbers */
static void print_scrap_numbers(FILE *, Scrap_Node *);
  /* pluralizes scrap formats list */
static void format_entry(Name *name, FILE *html_file, int file_flag);
  /* formats an index entry */
static void format_user_entry(Name *, FILE *);
@z

@x l.1526
@o html.c
@y
@o html.c -i
@z

@x l.1527
@{void write_html(file_name, html_name)
     char *file_name;
     char *html_name;
@y
@{void write_html(char *file_name, char *html_name)
@z

@x l.1534
      fprintf(stderr, "writing %s\n", html_name);
@y
#ifdef _AMIGA
      fprintf(stderr, get_string(MSG_VERBOSE_17A), html_name);
#else
      fprintf(stderr, "writing %s\n", html_name);
#endif
@z

@x l.1540
    fprintf(stderr, "%s: can't open %s\n", command_name, html_name);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_17A), command_name, html_name);
#else
    fprintf(stderr, "%s: can't open %s\n", command_name, html_name);
#endif
@z

@x l.1694
    fputs("File defined by ", html_file);
@y
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_31C), html_file);
#else
    fputs("File defined by ", html_file);
#endif
@z

@x l.1703
    fputs("Macro defined by ", html_file);
@y
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_31D), html_file);
#else
    fputs("Macro defined by ", html_file);
#endif
@z

@x l.1712
    fputs("Macro referenced in ", html_file);
@y
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_31E1), html_file);
#else
    fputs("Macro referenced in ", html_file);
#endif
@z

@x l.1716
    fputs("Macro never referenced.\n", html_file);
    fprintf(stderr, "%s: <%s> never referenced.\n",
@y
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_31E2), html_file);
    fprintf(stderr, get_string(MSG_WARNING_21A),
#else
    fputs("Macro never referenced.\n", html_file);
    fprintf(stderr, "%s: <%s> never referenced.\n",
#endif
@z

@x l.1723
@o html.c
@{static void display_scrap_ref(html_file, num)
     FILE *html_file;
     int num;
@y
@o html.c -i
@{static void display_scrap_ref(FILE *html_file, int num)
@z

@x l.1736
@o html.c
@{static void display_scrap_numbers(html_file, scraps)
     FILE *html_file;
     Scrap_Node *scraps;
@y
@o html.c -i
@{static void display_scrap_numbers(FILE *html_file, Scrap_Node *scraps)
@z

@x l.1751
@o html.c
@y
@o html.c -i
@z

@x l.1752
@{static void print_scrap_numbers(html_file, scraps)
     FILE *html_file;
     Scrap_Node *scraps;
@y
@{static void print_scrap_numbers(FILE *html_file, Scrap_Node *scraps)
@z

@x l.1756
  fputs("scrap", html_file);
  if (scraps->next) fputc('s', html_file);
@y
#ifdef _AMIGA
  if (scraps->next) fputs(get_string(MSG_HTML_32C1), html_file);
  else fputs(get_string(MSG_HTML_32C2), html_file);
#else
  fputs("scrap", html_file);
  if (scraps->next) fputc('s', html_file);
#endif
@z

@x l.1769
@o html.c
@{static void copy_scrap(file)
     FILE *file;
@y
@o html.c -i
@{static void copy_scrap(FILE *file)
@z

@x l.1846
\subsection{Generating the Indices}
@y
\subsection{Generating the Indexes}
@z

@x l.1874
@o html.c
@{static void format_entry(name, html_file, file_flag)
     Name *name;
     FILE *html_file;
     int file_flag;
@y
@o html.c -i
@{static void format_entry(Name *name, FILE *html_file, int file_flag)
@z

@x l.1908
  fputs("Defined by ", html_file);
@y
#ifdef _AMIGA
  fputs(get_string(MSG_HTML_35C), html_file);
#else
  fputs("Defined by ", html_file);
#endif
@z

@x l.1924
    fputs("Referenced in ", html_file);
@y
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_35E1), html_file);
#else
    fputs("Referenced in ", html_file);
#endif
@z

@x l.1928
    fputs("Not referenced.\n", html_file);
@y
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_35E2), html_file);
#else
    fputs("Not referenced.\n", html_file);
#endif
@z

@x l.1945
@o html.c
@{static void format_user_entry(name, html_file)
     Name *name;
     FILE *html_file;
@y
@o html.c -i
@{static void format_user_entry(Name *name, FILE *html_file)
@z

@x l.1999
@{extern void write_files();
@y
@{extern void write_files(Name *);
@z

@x l.2002
@o output.c
@{void write_files(files)
     Name *files;
@y
@o output.c -i
@{void write_files(Name *files)
@z

@x l.2014
We call \verb|tempnam|, causing it to create a file name in the
current directory.  This could cause a problem for \verb|rename| if
the eventual output file will reside on a different file system.
Perhaps it would be better to examine \verb|files->spelling| to find
any directory information.
@y
We create a file in the current directory with the hopefully improbable
name ``\texttt{NUWEB.TMP}'' and make sure it is deleted before the
program ends.  Thus we don't have to care about problems with different
implementations of \verb|tempnam|,\verb|tmpnam|, or the like on different
systems.  And except for \verb|rename| this should also be portable.
@z

@x l.2028
  char *temp_name = tempnam(".", 0);
@y
  char temp_name[]="NUWEB.TMP";
  void (*old_signal_handler)(int);

  old_signal_handler=signal(SIGINT,SIG_IGN);
@z

@x l.2031
    fprintf(stderr, "%s: can't create %s for a temporary file\n",
	    command_name, temp_name);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_38),
	    command_name, temp_name);
    exit(EXIT_FAILURE);
#else
    fprintf(stderr, "%s: can't create %s for a temporary file\n",
	    command_name, temp_name);
    exit(-1);
#endif
@z

@x l.2036
    fprintf(stderr, "writing %s\n", files->spelling);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_VERBOSE_17A), files->spelling);
#else
    fprintf(stderr, "writing %s\n", files->spelling);
#endif
@z

@x l.2046
}@}
@y
  signal(SIGINT,old_signal_handler);
}@}
@z

@x l.2051
  FILE *old_file = fopen(files->spelling, "r");
  if (old_file) {
    int x, y;
    temp_file = fopen(temp_name, "r");
    do {
      x = getc(old_file);
      y = getc(temp_file);
    } while (x == y && x != EOF);
    fclose(old_file);
    fclose(temp_file);
    if (x == y)
      remove(temp_name);
    else {
      remove(files->spelling);
      rename(temp_name, files->spelling);
    }
  }
  else
    rename(temp_name, files->spelling);
@y
  FILE *old_file = fopen(files->spelling, "r");
  if (old_file) {
    char x[BUFSIZ], y[BUFSIZ];
    int x_size, y_size;
    temp_file = fopen(temp_name, "r");
    do {
      x_size = fread(x, 1, BUFSIZ, old_file);
      y_size = fread(y, 1, BUFSIZ, temp_file);
    } while ((x_size == y_size) && !memcmp(x, y, x_size) &&
             !feof(old_file) && !feof(temp_file));
    if ((x_size != y_size) || memcmp(x, y , x_size)) {
      fclose(old_file);
      fclose(temp_file);
      remove(files->spelling);
      rename(temp_name, files->spelling);
    } else {
      fclose(old_file);
      fclose(temp_file);
      remove(temp_name);
    }
  }
  else
    rename(temp_name, files->spelling);
@z

@x l.2082
@{extern void source_open(); /* pass in the name of the source file */
extern int source_get();   /* no args; returns the next char or EOF */
@y
@{extern void source_open(char *);
  /* pass in the name of the source file */
extern int source_get(void);
  /* no args; returns the next char or EOF */
@z

@x l.2103
@o input.c
@y
@o input.c -i
@z

@x l.2111
@o input.c
@y
@o input.c -i
@z

@x l.2127
are defining.
@o input.c
@{
int source_last;
int source_get()
@y
are defining.
@o input.c -i
@{
int source_last;
int source_get(void)
@z

@x l.2176
      default:  fprintf(stderr, "%s: bad @@ sequence (%s, line %d)\n",
			command_name, source_name, source_line);
		exit(-1);
@y
#ifdef _AMIGA
      default:  fprintf(stderr, get_string(MSG_ERROR_42A),
			command_name, source_name, source_line);
#else
      default:  fprintf(stderr, "%s: bad @@ sequence (%s, line %d)\n",
			command_name, source_name, source_line);
#endif
		exit(EXIT_FAILURE);
@z

@x l.2186
    fprintf(stderr, "%s: include nesting too deep (%s, %d)\n",
	    command_name, source_name, source_line);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_42B1),
	    command_name, source_name, source_line);
#else
    fprintf(stderr, "%s: include nesting too deep (%s, %d)\n",
	    command_name, source_name, source_line);
#endif
    exit(EXIT_FAILURE);
@z

@x l.2199
    fprintf(stderr, "%s: can't open include file %s\n",
     command_name, source_name);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_42B2),
     command_name, source_name);
#else
    fprintf(stderr, "%s: can't open include file %s\n",
     command_name, source_name);
#endif
    exit(EXIT_FAILURE);
@z

@x l.2219
      fprintf(stderr, "%s: unexpected characters after file name (%s, %d)\n",
	      command_name, source_name, source_line);
      exit(-1);
@y
#ifdef _AMIGA
      fprintf(stderr, get_string(MSG_ERROR_43A),
	      command_name, source_name, source_line);
#else
      fprintf(stderr, "%s: unexpected characters after file name (%s, %d)\n",
	      command_name, source_name, source_line);
#endif
      exit(EXIT_FAILURE);
@z

@x l.2247
@o input.c
@{void source_open(name)
     char *name;
@y
@o input.c -i
@{void source_open(char *name)
@z

@x l.2253
    fprintf(stderr, "%s: couldn't open %s\n", command_name, name);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_43C), command_name, name);
#else
    fprintf(stderr, "%s: couldn't open %s\n", command_name, name);
#endif
    exit(EXIT_FAILURE);
@z

@x l.2270
@o scraps.c
@y
@o scraps.c -i
@z

@x l.2280
@o scraps.c
@y
@o scraps.c -i
@z

@x l.2290
@o scraps.c
@y
@o scraps.c -i
@z

@x l.2300
@{extern void init_scraps();
extern int collect_scrap();
extern int write_scraps();
extern void write_scrap_ref();
extern void write_single_scrap_ref();
@y
@{extern void init_scraps(void);
extern int collect_scrap(void);
extern int write_scraps(FILE *, Scrap_Node *, int, char *, char, char, char);
extern void write_scrap_ref(FILE *, int, int, int *);
extern void write_single_scrap_ref(FILE *, int);
@z

@x l.2308
@o scraps.c
@{void init_scraps()
@y
@o scraps.c -i
@{void init_scraps(void)
@z

@x l.2317
@o scraps.c
@{void write_scrap_ref(file, num, first, page)
     FILE *file;
     int num;
     int first;
     int *page;
@y
@o scraps.c -i
@{void write_scrap_ref(FILE *file, int num, int first, int *page)
@z

@x l.2337
    @<Warn (only once) about needing to rerun after Latex@>
@y
    @<Warn (only once) about needing to rerun after LaTeX@>
@z

@x l.2343
@o scraps.c
@{void write_single_scrap_ref(file, num)
     FILE *file;
     int num;
@y
@o scraps.c -i
@{void write_single_scrap_ref(FILE *file, int num)
@z

@x l.2357
    fprintf(stderr, "%s: you'll need to rerun nuweb after running latex\n",
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_45C),
#else
    fprintf(stderr, "%s: you'll need to rerun nuweb after running latex\n",
#endif
@z

@x l.2371
@o scraps.c
@y
@o scraps.c -i
@z

@x l.2381
@o scraps.c
@{static void push(c, manager)
     char c;
     Manager *manager;
@y
@o scraps.c -i
@{static void push(char c, Manager *manager)
@z

@x l.2399
@o scraps.c
@{static void pushs(s, manager)
     char *s;
     Manager *manager;
@y
@o scraps.c -i
@{static void pushs(char *s, Manager *manager)
@z

@x l.2410
@o scraps.c
@{int collect_scrap()
@y
@o scraps.c -i
@{int collect_scrap(void)
@z

@x l.2439
      case EOF: fprintf(stderr, "%s: unexpect EOF in scrap (%s, %d)\n",
			command_name, scrap_array(scraps).file_name,
			scrap_array(scraps).file_line);
		exit(-1);
@y
#ifdef _AMIGA
      case EOF: fprintf(stderr, get_string(MSG_ERROR_47B),
			command_name, scrap_array(scraps).file_name,
			scrap_array(scraps).file_line);
#else
      case EOF: fprintf(stderr, "%s: unexpect EOF in scrap (%s, %d)\n",
			command_name, scrap_array(scraps).file_name,
			scrap_array(scraps).file_line);
#endif
		exit(EXIT_FAILURE);
@z

@x l.2467
    default : fprintf(stderr, "%s: unexpected @@%c in scrap (%s, %d)\n",
		      command_name, c, source_name, source_line);
	      exit(-1);
@y
#ifdef _AMIGA
    default : fprintf(stderr, get_string(MSG_ERROR_47C),
		      command_name, c, source_name, source_line);
#else
    default : fprintf(stderr, "%s: unexpected @@%c in scrap (%s, %d)\n",
		      command_name, c, source_name, source_line);
#endif
	      exit(EXIT_FAILURE);
@z

@x l.2502
    exit(-1);
@y
    exit(EXIT_FAILURE);
@z

@x l.2544
@o scraps.c
@{static char pop(manager)
     Manager *manager;
@y
@o scraps.c -i
@{static char pop(Manager *manager)
@z

@x l.2563
@o scraps.c
@{static Name *pop_scrap_name(manager)
     Manager *manager;
@y
@o scraps.c -i
@{static Name *pop_scrap_name(Manager *manager)
@z

@x l.2598
    fprintf(stderr, "%s: found an internal problem (1)\n", command_name);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_50A), command_name);
#else
    fprintf(stderr, "%s: found an internal problem (1)\n", command_name);
#endif
    exit(EXIT_FAILURE);
@z

@x l.2604
@o scraps.c
@{int write_scraps(file, defs, global_indent, indent_chars,
		   debug_flag, tab_flag, indent_flag)
     FILE *file;
     Scrap_Node *defs;
     int global_indent;
     char *indent_chars;
     char debug_flag;
     char tab_flag;
     char indent_flag;
@y
@o scraps.c -i
@{int write_scraps(FILE *file, Scrap_Node *defs, int global_indent,
  char *indent_chars, char debug_flag, char tab_flag, char indent_flag)
@z

@x l.2710
    fprintf(stderr, "%s: recursive macro discovered involving <%s>\n",
	    command_name, name->spelling);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_52C1),
	    command_name, name->spelling);
#else
    fprintf(stderr, "%s: recursive macro discovered involving <%s>\n",
	    command_name, name->spelling);
#endif
    exit(EXIT_FAILURE);
@z

@x l.2722
    fprintf(stderr, "%s: macro never defined <%s>\n",
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_52C2),
#else
    fprintf(stderr, "%s: macro never defined <%s>\n",
#endif
@z

@x l.2730
@{extern void collect_numbers();
@y
@{extern void collect_numbers(char *);
@z

@x l.2733
@o scraps.c
@{void collect_numbers(aux_name)
     char *aux_name;
@y
@o scraps.c -i
@{void collect_numbers(char *aux_name)
@z

@x l.2816
@{extern Name *collect_file_name();
extern Name *collect_macro_name();
extern Name *collect_scrap_name();
extern Name *name_add();
extern Name *prefix_add();
extern char *save_string();
extern void reverse_lists();
@y
@{extern Name *collect_file_name(void);
extern Name *collect_macro_name(void);
extern Name *collect_scrap_name(void);
extern Name *name_add(Name **, char *);
extern Name *prefix_add(Name **, char *);
extern char *save_string(char *);
extern void reverse_lists(Name *);
@z

@x l.2825
@o names.c
@y
@o names.c -i
@z

@x l.2828
static int compare(x, y)
     char *x;
     char *y;
@y
static int compare(char *x, char *y)
@z

@x l.2856
@o names.c
@{char *save_string(s)
     char *s;
@y
@o names.c -i
@{char *save_string(char *s)
@z

@x l.2866
@o names.c
@{static int ambiguous_prefix();
@y
@o names.c -i
@{static int ambiguous_prefix(Name *, char *);
@z

@x l.2869
Name *prefix_add(root, spelling)
     Name **root;
     char *spelling;
@y
Name *prefix_add(Name **root, char *spelling)
@z

@x l.2900
    fprintf(stderr,
	    "%s: ambiguous prefix @@<%s...@@> (%s, line %d)\n",
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_56B),
#else
    fprintf(stderr,
	    "%s: ambiguous prefix @@<%s...@@> (%s, line %d)\n",
#endif
@z

@x l.2905
@o names.c
@{static int ambiguous_prefix(node, spelling)
     Name *node;
     char *spelling;
@y
@o names.c -i
@{static int ambiguous_prefix(Name *node, char *spelling)
@z

@x l.2940
@o names.c
@{static int robs_strcmp(x, y)
     char *x;
     char *y;
@y
@o names.c -i
@{static int robs_strcmp(char *x, char *y)
@z

@x l.2972
@o names.c
@{Name *name_add(root, spelling)
     Name **root;
     char *spelling;
@y
@o names.c -i
@{Name *name_add(Name **root, char *spelling)
@z

@x l.3012
@o names.c
@{Name *collect_file_name()
@y
@o names.c -i
@{Name *collect_file_name(void)
@z

@x l.3027
    fprintf(stderr, "%s: expected file name (%s, %d)\n",
	    command_name, source_name, start_line);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_59A1),
	    command_name, source_name, start_line);
#else
    fprintf(stderr, "%s: expected file name (%s, %d)\n",
	    command_name, source_name, start_line);
#endif
    exit(EXIT_FAILURE);
@z

@x l.3036
    fprintf(stderr, "%s: expected @@{, @@[, or @@( after file name (%s, %d)\n",
	    command_name, source_name, start_line);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_59A2),
	    command_name, source_name, start_line);
#else
    fprintf(stderr, "%s: expected @@{, @@[, or @@( after file name (%s, %d)\n",
	    command_name, source_name, start_line);
#endif
    exit(EXIT_FAILURE);
@z

@x l.3059
	  default : fprintf(stderr, "%s: unexpected per-file flag (%s, %d)\n",
@y
#ifdef _AMIGA
	  default : fprintf(stderr, get_string(MSG_WARNING_59B),
#else
	  default : fprintf(stderr, "%s: unexpected per-file flag (%s, %d)\n",
#endif
@z

@x l.3072
Name terminated by \verb+\n+ or \verb+@@{+; but keep skipping until \verb+@@{+
@o names.c
@{Name *collect_macro_name()
@y
Name terminated by \verb+\n+ or \verb+@@{+; but keep skipping until
\verb+@@{+.
@o names.c -i
@{Name *collect_macro_name(void)
@z

@x l.3098
  fprintf(stderr, "%s: expected macro name (%s, %d)\n",
	  command_name, source_name, start_line);
  exit(-1);
@y
#ifdef _AMIGA
  fprintf(stderr, get_string(MSG_ERROR_60A),
	  command_name, source_name, start_line);
#else
  fprintf(stderr, "%s: expected macro name (%s, %d)\n",
	  command_name, source_name, start_line);
#endif
  exit(EXIT_FAILURE);
@z

@x l.3115
    default:  fprintf(stderr,
		      "%s: unexpected @@%c in macro name (%s, %d)\n",
		      command_name, c, source_name, start_line);
	      exit(-1);
@y
#ifdef _AMIGA
    default:  fprintf(stderr, get_string(MSG_ERROR_60B),
		      command_name, c, source_name, start_line);
#else
    default:  fprintf(stderr,
		      "%s: unexpected @@%c in macro name (%s, %d)\n",
		      command_name, c, source_name, start_line);
#endif
	      exit(EXIT_FAILURE);
@z

@x l.3132
    fprintf(stderr, "%s: empty scrap name (%s, %d)\n",
	    command_name, source_name, source_line);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_61A),
	    command_name, source_name, source_line);
#else
    fprintf(stderr, "%s: empty scrap name (%s, %d)\n",
	    command_name, source_name, source_line);
#endif
    exit(EXIT_FAILURE);
@z

@x l.3148
    fprintf(stderr, "%s: expected @@{ after macro name (%s, %d)\n",
	    command_name, source_name, start_line);
    exit(-1);
@y
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_61B),
	    command_name, source_name, start_line);
#else
    fprintf(stderr, "%s: expected @@{, @@[, or @@( after macro name (%s, %d)\n",
	    command_name, source_name, start_line);
#endif
    exit(EXIT_FAILURE);
@z

@x l.3156
Terminated by \verb+@@>+
@o names.c
@{Name *collect_scrap_name()
@y
Terminated by \verb+@@>+.
@o names.c -i
@{Name *collect_scrap_name(void)
@z

@x l.3176
		   fprintf(stderr,
			   "%s: unexpected character in macro name (%s, %d)\n",
			   command_name, source_name, source_line);
		   exit(-1);
@y
#ifdef _AMIGA
		   fprintf(stderr, get_string(MSG_ERROR_62A1),
			   command_name, source_name, source_line);
#else
		   fprintf(stderr,
			   "%s: unexpected character in macro name (%s, %d)\n",
			   command_name, source_name, source_line);
#endif
		   exit(EXIT_FAILURE);
@z

@x l.3186
  fprintf(stderr, "%s: unexpected end of file (%s, %d)\n",
	  command_name, source_name, source_line);
  exit(-1);
@y
#ifdef _AMIGA
  fprintf(stderr, get_string(MSG_ERROR_62A2),
	  command_name, source_name, source_line);
#else
  fprintf(stderr, "%s: unexpected end of file (%s, %d)\n",
	  command_name, source_name, source_line);
#endif
  exit(EXIT_FAILURE);
@z

@x l.3205
	      exit(-1);
@y
	      exit(EXIT_FAILURE);
@z

@x l.3210
@o names.c
@{static Scrap_Node *reverse();	/* a forward declaration */
@y
@o names.c -i
@{static Scrap_Node *reverse(Scrap_Node *); /* a forward declaration */
@z

@x l.3213
void reverse_lists(names)
     Name *names;
@y
void reverse_lists(Name *names)
@z

@x l.3228
@o names.c
@{static Scrap_Node *reverse(a)
     Scrap_Node *a;
@y
@o names.c -i
@{static Scrap_Node *reverse(Scrap_Node *a)
@z

@x l.3256
@o scraps.c
@y
@o scraps.c -i
@z

@x l.3263
@o scraps.c
@y
@o scraps.c -i
@z

@x l.3272
@o scraps.c
@y
@o scraps.c -i
@z

@x l.3280
@o scraps.c
@y
@o scraps.c -i
@z

@x l.3287
@o scraps.c
@{static Goto_Node *goto_lookup(c, g)
     char c;
     Goto_Node *g;
@y
@o scraps.c -i
@{static Goto_Node *goto_lookup(char c, Goto_Node *g)
@z

@x l.3307
@{extern void search();
@y
@{extern void search(void);
@z

@x l.3310
@o scraps.c
@{static void build_gotos();
static int reject_match();
@y
@o scraps.c -i
@{static void build_gotos(Name *);
static int reject_match(Name *, char, Manager *);
@z

@x l.3314
void search()
@y
void search(void)
@z

@x l.3331
@o scraps.c
@{static void build_gotos(tree)
     Name *tree;
@y
@o scraps.c -i
@{static void build_gotos(Name *tree)
@z

@x l.3483
static int op_char(c)
     char c;
@y
static int op_char(char c)
@z

@x l.3497
@o scraps.c
@{static int reject_match(name, post, reader)
     Name *name;
     char post;
     Manager *reader;
@y
@o scraps.c -i
@{static int reject_match(Name *name, char post, Manager *reader)
@z

@x l.3535
@{extern void *arena_getmem();
extern void arena_free();
@y
@{extern void *arena_getmem(size_t);
extern void arena_free(void);
@z

@x l.3540
@o arena.c
@y
@o arena.c -i
@z

@x l.3554
@o arena.c
@y
@o arena.c -i
@z

@x l.3568
@o arena.c
@{void *arena_getmem(n)
     size_t n;
@y
@o arena.c -i
@{void *arena_getmem(size_t n)
@z

@x l.3627
@o arena.c
@y
@o arena.c -i
@z

@x l.3670
.SH FORMAT OF NUWEB FILES
@y
@}
@o nuweb.1 @{.SH FORMAT OF NUWEB FILES
@z

@x L.3716
.SH PER FILE OPTIONS
@y
@}
@o nuweb.1 @{.SH PER FILE OPTIONS
@z

@x l.3759
\chapter{Indices} \label{indices}
@y
\chapter{Multilinguality} \label{multilinguality}

The Amiga operating system (and maybe some other operating systems as
well), starting with version~2.1, is inherently multilingual.  With the
help of system catalogs, any decent program interface can be made sensitive
to the language the user wants to be addressed with.  All terminal output
strings and \LaTeX\ output strings were located and replaced by references
to an external array \verb|AppStrings|.  The English defaults of these
strings can be overwritten by the entries of translated catalogs.  The
following include file \verb|cweb.h| contains a complete description of all
strings used in this extended \verb|NUWEB| system.

@d Include files
@{#ifdef _AMIGA
#include <proto/exec.h>
#include <proto/locale.h>

#define get_string(n) AppStrings[n].as_Str /* reference string n */

#include "catalogs/nuweb.h"

#ifndef STRINGARRAY
struct AppString
{
  LONG   as_ID;
  STRPTR as_Str;
};

extern struct AppString AppStrings[];
#endif
#endif
@| get_string AppStrings as_Str STRINGARRAY AppString as_ID @}

We need some handles to access the system library and the language catalogs.

@d Global variable definitions
@{#ifdef _AMIGA
struct Library *LocaleBase; /* pointer to the locale library */
struct Catalog *catalog; /* pointer to the external catalog, when present */
int i; /* global counter for list of strings */
#endif
@| LocaleBase catalog @}

@d Global variable declarations
@{extern struct Library *LocaleBase;
  /* pointer to the locale library */
extern struct Catalog *catalog;
  /* pointer to the external catalog, when present */
extern int i;
  /* global counter for list of strings */
@}

Version 2.1 or higher of the Amiga operating system (represented as
internal version~38) will replace the complete set of terminal output
strings by an external translation in accordance to the system default
language.

@d Use catalog translations
@{@<Set up exit trap@>
@<Set up interrupt handler@>

if(LocaleBase = OpenLibrary("locale.library", 38L)) {
  if(catalog = OpenCatalog(NULL, "nuweb.catalog", OC_BuiltInLanguage,
                           "english", TAG_DONE)) {
    for(i = MSG_WARNING_11B; i <= MSG_ERROR_62A2; i++)
      AppStrings[i].as_Str = GetCatalogStr(catalog, i, AppStrings[i].as_Str);
  }
}
@| OpenLibrary OpenCatalog @}

At the end of the program and especially in case of an user break we must
take care of the opened resources like system libraries and catalog files.
ANSI-C provides ``exit traps'' and ``exception handlers'' for this purpose.
\verb|atexit| returns \verb|NULL| if the trap is set up correctly and a code
other than \verb|NULL| in case of error.  It is very important that the
``exit traps'' {\em are\/} set up properly, so we better quit further
processing in case of an error.

@d Set up exit trap
@{if(atexit(&CloseSystemResources))
  exit(EXIT_FAILURE); /* Exit trap could not be set up */
@| atexit @}

It is essential to close the pointer references to the language catalog and
to the system library before shutting down the program itself.  This
program will only be left by calls to the \verb|exit| function, so we use
a nice feature of the C language, socalled ``exit traps.''

@d Function prototypes
@{#ifdef _AMIGA
extern void CloseSystemResources(void);
#endif
@| CloseSystemResources @}

The only purpose of \verb|CloseSystemResources| is to take care of
the opened files.

@o global.c
@{#ifdef _AMIGA
void CloseSystemResources(void) {
  if(LocaleBase) {
    CloseCatalog(catalog);
    CloseLibrary(LocaleBase);
  }
}
#endif
@| CloseCatalog CloseLibrary @}

After the ``exit trap'' is set up, it is very convenient to add another
feature of modern technology, the possibility to abort the program with
``Control-C'' or ``Control-D''.  The C standard library provides a
mechanism for this purpose with its \verb|signal| routine.

@d Set up interrupt handler
@{if(signal(SIGINT, &catch_break) == SIG_ERR)
  exit(EXIT_FAILURE); /* Interrupt handler could not be set up */
@| signal SIGINT SIG_ERR @}

The \verb|signal| function and the macros for the interrupt codes are given
in the following standard header file.

@d Include files
@{#ifdef _AMIGA
#include <signal.h>
#endif
@}

The action to be taken at the last moments of the run is quite simple,
we only call \verb|exit|, thus activating the ``exit trap'' for
resource handling.

@d Function prototypes
@{#ifdef _AMIGA
extern void catch_break(int);
#endif
@| catch_break @}

@o global.c
@{#ifdef _AMIGA
void catch_break(int dummy) {
  exit(EXIT_FAILURE);
}
#endif
@| dummy @}

\chapter{Indexes} \label{indexes}
@z

@x l.3761
Three sets of indices can be created automatically: an index of file
@y
Three sets of indexes can be created automatically: an index of file
@z

@x l.3779
Therefore, it seems better to leave it this up to the user.
@y
Therefore, it seems better to leave this up to the user.
@z
