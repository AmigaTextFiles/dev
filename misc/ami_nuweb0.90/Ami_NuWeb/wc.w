% wc: An example of NUWEB by Andreas Scherer

\documentclass{article}
\usepackage{latexsym}

\newcommand{\CEE}{{\small C\spacefactor1000}}
\newcommand{\UNIX}{{\small U\kern-.05emNIX\spacefactor1000}}
\newcommand{\SPARC}{SPARC\-\kern.1em station}
\newcommand{\TEX}{\TeX}

\title{An example of NUWEB}

\author{Klaus Guntermann, Joachim Schrod\\
  (Original \CEE\ version)\\[2ex]
  Silvio Levy, Donald E. Knuth\\
  (\texttt{CWEB} implementation)\\[2ex]
  Andreas Scherer\\
  (\texttt{NUWEB} implementation)\\[4ex]}

\date{October 23, 1994}

\begin{document}

\maketitle

\begin{abstract}

\noindent This example, based on a program by Klaus Guntermann and
Joachim Schrod [\textsl{TUGboat}~\textbf{7} (1986), 135--137] presents
the ``word count'' program from \UNIX, rewritten in \texttt{NUWEB}
to demonstrate literate programming in~\CEE\null.  The level of detail
in this document is intentionally high, for didactic purposes; many
of the things spelled out here don't need to be explained in other
programs.

\end{abstract}

\thispagestyle{empty}

\newpage

\pagenumbering{arabic}

\section{Counting words}

The purpose of \texttt{wc} is to count lines, words, and/or characters
in a list of files. The number of lines in a file is the number of
newline characters it contains. The number of characters is the file
length in bytes.  A ``word'' is a maximal sequence of consecutive
characters other than newline, space, or tab, containing at least
one visible ASCII code.  (We assume that the standard ASCII code
is in use.)

Most \texttt{NUWEB} programs share a common structure.  It's probably
a good idea to state the overall structure explicitly at the outset,
even though the various parts could all be introduced in unnamed
sections of the code if we wanted to add them piecemeal.

Here, then, is an overview of the file \texttt{wc.c} that is defined
by this \texttt{NUWEB} program \texttt{wc.w}:

@o wc.c
@{@<Header files to include@>
@<Global defines@>
@<Global variables@>
@<Prototypes@>
@<Functions@>
@<The \verb|main| program@>
@}

We must include the standard I/O definitions, since we want to send
formatted output to \verb|stdout| and \verb|stderr|.

@d Header files...
@{#include <stdio.h>
#include <stdlib.h>
@}

\texttt{NUWEB} doesn't have a mechanism like \texttt{CWEB} for defining
global values that will appear at the beginning of the output files.
Here we must simulate this explicitly.

@d Global def...
@{#define OK 0
  /* status code for successful run */
#define usage_error 1
  /* status code for improper syntax */
#define cannot_open_file 2
  /* status code for file access error */
@| OK usage_error cannot_open_file @}

The \verb|status| variable will tell the operating system if the run
was successful or not, and \verb|prog_name| is used in case there's
an error message to be printed.

@d Global variables
@{int status = OK;
  /* exit status of command, initially OK */
char *prog_name;
  /* who we are */
@| status prog_name @}

Now we come to the general layout of the \verb|main| function.

@d The \verb|main|...
@{void main(
  int argc,
    /* the number of arguments on the UNIX command line */
  char **argv)
    /* the arguments themselves, an array of strings */
{
  @<Variables local to \verb|main|@>
  prog_name = argv[0];
  @<Set up option selection@>
  @<Process all the files@>
  @<Print the grand totals if there were multiple files @>
  exit (status);
} @| argc argv main exit @}

If the first argument begins with a `\texttt{-}', the user is choosing
the desired counts and specifying the order in which they should be
displayed.  Each selection is given by the initial character
(lines, words, or characters).  For example, `\texttt{-cl}' would cause
just the number of characters and the number of lines to be printed,
in that order.

We do not process this string now; we simply remember where it is.
It will be used to control the formatting at output time.

@d Var...
@{int file_count;
  /* how many files there are */
char *which;
  /* which counts to print */
@| file_count which @}

@d Set up o...
@{which = "lwc";
  /* if no option is given, print all three values */
if (argc > 1 && *argv[1] == '-') {
  which = argv[1]+1; argc--; argv++;
}
file_count = argc - 1;
@}

Now we scan the remaining arguments and try to open a file, if
possible.  The file is processed and its statistics are given.
We use a \texttt{do}~\dots~\texttt{while} loop because we should
read from the standard input if no file name is given.

@d Process...
@{argc--;
do {
  @<If a file is given, try to open \verb|*(++argv)|; \verb|continue| if unsuccessful@>
  @<Initialize pointers and counters@>
  @<Scan file@>
  @<Write statistics for file@>
  @<Close file@>
  @<Update grand totals@>
    /* even if there is only one file */
} while (--argc > 0);
@}

Here's the code to open the file.  A special trick allows us to
handle input from \verb|stdin| when no name is given.

@d Variabl...
@{FILE *fp = stdin;
  /* file pointer, initialized to the console */
@| fp stdin @}

@d Global def...
@{#define READ_ONLY "r"
  /* read access code for system fopen routine */
@| READ_ONLY @}

@d If a file...
@{if (file_count > 0 && (fp = fopen (*(++argv), READ_ONLY)) == 0) {
  fprintf (stderr, "%s: cannot open file %s\n", prog_name, *argv);
  status |= cannot_open_file;
  file_count--;
  continue;
} @| fprintf stderr @}

@d Close file
@{fclose (fp);
@| fclose @}

\verb|stdio.h|'s \verb|BUFSIZ| is chosen for efficiency.

@d Global def...
@{#define buf_size BUFSIZ
@| buf_size BUFSIZ @}

We will do some homemade buffering in order to speed things up:
Characters will be read into the \verb|buffer| array before we
process them.  To do this we set up appropriate pointers and counters.

@d Var...
@{char buffer[buf_size];
  /* we read the input into this array */
register char *ptr;
  /* the first unprocessed character in buffer */
register char *buf_end;
  /* the first unused position in buffer */
register int c;
  /* current character, or number of characters just read */
int in_word;
  /* are we within a word? */
long word_count, line_count, char_count;
  /* number of words, lines, and characters
     found in the file so far */
@| buffer ptr buf_end c in_word word_count line_count char_count @}

@d Init...
@{ptr = buf_end = buffer;
line_count = word_count = char_count = in_word = 0;
@}

The grand totals must be initialized to zero at the beginning of the
program. If we made these variables local to \verb|main|, we would
have to do this initialization explicitly; however, \CEE's globals
are automatically zeroed. (Or rather, ``statically zeroed.'') (Get it?)

@d Global var...
@{long tot_word_count, tot_line_count, tot_char_count;
  /* total number of words, lines, and chars */
@| tot_word_count tot_line_count tot_char_count @}

The present section, which does the counting that is \texttt{wc}'s
\textit{raison d'\^etre}, was actually one of the simplest to write.
We look at each character and change state if it begins or ends a word.

@d Scan...
@{while (1) {
  @<Fill \verb|buffer| if it is empty; \verb|break| at end of file@>;
  c = *ptr++;
  if (c>' ' && c<0177) { /* visible ASCII codes */
    if (!in_word) { word_count++; in_word = 1; }
    continue;
  }
  if (c == '\n') line_count++;
  else if (c != ' ' && c != '\t') continue;
  in_word = 0; /* c is newline, space, or tab */
}@}

Buffered I/O allows us to count the number of characters almost for free.

@d Fill \verb|buff...
@{if (ptr >= buf_end) {
  ptr = buffer; c = fread (ptr, 1, buf_size, fp);
  if (c <= 0) break;
  char_count += c; buf_end = buffer + c;
} @| fread @}

It's convenient to output the statistics by defining a new function
\verb|wc_print|; then the same function can be used for the totals.
Additionally we must decide here if we know the name of the file
we have processed or if it was just \verb|stdin|.

@d Write...
@{wc_print (which, char_count, word_count, line_count);
if (file_count) /* not stdin */
  printf (" %s\n", *argv);
else /* stdin */
  printf ("\n");
@| printf @}

@d Upda...
@{tot_line_count += line_count;
tot_word_count += word_count;
tot_char_count += char_count;
@}

We might as well improve a bit on \UNIX's \texttt{wc} by displaying
the number of files too.

@d Print the...
@{if (file_count > 1) {
  wc_print (which, tot_char_count, tot_word_count, tot_line_count);
  printf (" total in %d files\n", file_count);
}@}

@d Global def...
@{#define print_count(n) printf("%8ld",n)
@| print_count @}

Here now is the function that prints the values according to the
specified options.  The calling routine is supposed to supply a
newline. If an invalid option character is found we inform
the user about proper usage of the command. Counts are printed in
8-digit fields so that they will line up in columns.

@d Fun...
@{void wc_print(
  char *which, /* which counts to print */
  long char_count,
  long word_count,
  long line_count) /* given totals */
{
  while (*which)
    switch (*which++) {
    case 'l': print_count (line_count); break;
    case 'w': print_count (word_count); break;
    case 'c': print_count (char_count); break;
    default: if ((status & usage_error) == 0) {
        fprintf (stderr,
          "\nUsage: %s [-lwc] [filename ...]\n", prog_name);
        status |= usage_error;
      }
    }
} @| wc_print which char_count word_count line_count @}

Incidentally, a test of this program against the system \texttt{wc}
command on a \SPARC\ showed that the ``official'' \texttt{wc} was
slightly slower. Furthermore, although that \texttt{wc} gave an
appropriate error message for the options `\texttt{-abc}', it made
no complaints about the options `\texttt{-labc}'! Dare we suggest
that the system routine might have been better if its programmer
had used a more literate approach?

We declare the prototypes of the internal functions.

@d Prototypes
@{void wc_print (char *, long, long, long);
void main (int, char **);
@| wc_print main @}

\section{Index}
Here is a list of the identifiers used, and where they appear. Underlined
entries indicate the place of definition. Error messages are also shown.

@u

\section{Section names}

@m

@f

\end{document}
