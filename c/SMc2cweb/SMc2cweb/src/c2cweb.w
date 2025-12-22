% This is the cweb file c2cweb Version 1.4  20-Aug-1994
%
% You should process this file with
%
%           cweave +ai c2cweb.w

\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iftrue
\fullpageheight=240mm
\pageheight=223mm
\pagewidth=158mm
\setpage
\frenchspacing
\def\in{\leavevmode\vrule width 0pt\nobreak\hskip 2em\hskip 0pt} % indentation
\font\sixrm=cmr6
\def\tm{$^{\hbox{\sixrm TM}}$} % trademark

\def\title{c2cweb (Version 1.4)}

\def\topofcontents{
  \null\vfill
  \centerline{\titlefont The {\ttitlefont c2cweb} program}
  \vskip 20pt
  \centerline{(Version 1.4)}
  \vfill}

\def\botofcontents{
  \vfill
  \noindent
  Copyright \copyright\ 1994 by Werner Lemberg
  \bigskip\noindent
  Permission is granted to make and distribute verbatim copies of this
  document provided that the copyright notice and this permission notice
  are preserved on all copies.

  \smallskip\noindent
  Permission is granted to copy and distribute modified versions of this
  document under the conditions for verbatim copying, provided that the
  entire resulting derived work is distributed under the terms of a
  permission notice identical to this one.}



@* Introduction.
This is the \.{c2cweb} program by Werner Lemberg
(\.{a7621gac@@awiuni11.bitnet}).

The ``banner line'' defined here should be changed whenever \.{c2cweb} is
modified.

@d banner "\nThis is c2cweb Version 1.4  (c) 1994 by Werner Lemberg\n\n"

@
\.{c2cweb} will transform ordinary \CEE/ or \CPLUSPLUS/ source code into
\.{CWEB} formatted code. Three primary functions are performed: inserting
\.{@@}--commands between code blocks, transforming comments into \TeX--text,
and replacing offending characters like \.{\\}, \.{\_}, \.{\&} etc. with
commands \TeX\ (and \.{CWEB}) can understand.

The only changes the user has to do normally is to insert `\.{/*@@@@*/}' or
`\.{/*@@*/}' \\{starting a line} outside of a comment or string (the rest of
these lines will be ignored).

\advance\leftskip by 3em

    \item{$\bullet$} \.{/*@@@@*/} starts a new section and switches
    the function block algorithm on (see below).

    \item{$\bullet$} \.{/*@@*/} starts a new section and switches the
    function block algorithm off. This is the default when \.{c2cweb} begins to
    scan a file.

\advance\leftskip by -3em

Both `commands' will be suppressed in the output (two additional commands are
described in the `Hints and Tricks'--section).

@
Normal \CEE/ code consists of two parts: the code before function blocks
(\.{\#include} and \.{\#define} statements, prototypes, structure definitions,
global variables, etc.) and the function blocks (i.e. \.{foo()\{ ... \}})
itselves (possibly mixed with global definitions of variables, structures
etc.). The main reason to separate them are memory constraints of
\.{CWEAVE}, and after \.{/*@@@@*/} each function block is written into an own
section.

In header files, nothing is to do because there are no function blocks. In
\CEE/ code files, it's usually sufficient to insert \.{/*@@@@*/} once, but
you can structure your code further by inserting \.{/*@@*/} (and \.{/*@@@@*/}
if necessary). See also the example file delivered with this package.

You will need a special \.{CWEAVE} executable (change files for \.{cweave.w}
and \.{common.w} are included in this package) which has an enhanced
preprocessor command handling, two additional control codes and can produce two
different output formats.

See also the section `Hints and Tricks'.


@* The program.
The use of |_response()|, |_wildcard()|, and |_getname()| is compiler
specific. If you don't use emx--gcc, it's likely that you have to use
different functions. If you use this program under DOS, consider the 
\UNIX/--like behavior of the ``|*|''--wildcard character.

After processing the options, the global variable |optind| (defined in
\.{getopt.h}) is the index to the first file name.

@d FALSE 0
@d TRUE  1
@d DONE  2
@d WAIT  3

@c
@<Include files@>;
@<Prototypes@>;
@<Global variables@>;@#

void main(argc, argv)
  int argc;
  char *argv[];

   {int i;
    char buffer[DIR_LENGTH + FILE_NAME_LENGTH + 1];
    char *p, *q;


    printf(banner);@#

#ifdef __EMX__
    _response(&argc, &argv); /* to expand response files */
    _wildcard(&argc, &argv); /* to expand wildcards */
#endif@#

    @<Get command switches@>;@#

    if(optind == argc)
        usage();@#

    for(i = optind; i < argc - 1; i++)
       {printf("  processing %s\n", argv[i]);@#

        open_files(argv[i]);
        q = protect_underlines(_getname(argv[i]));
        if((p = strrchr(q, '.')) != NULL)
                         /* the macro \.{\\ZZZ} suppresses the final dot after
                            the section title if the filename contains a dot */
            fprintf(out,@/
            "@@*{%s\\ZZZ{\\setbox0=\\hbox{%s}\\hskip-\\wd0}}.\n"@/
            "\\ind=2\n\n", q, p);
        else
            fprintf(out, "@@*{%s}.\n"@/
            "\\ind=2\n\n", q);@#

        handle_input();
        fclose(in);
        fclose(out);
       }@#

    printf("  processing %s\n", argv[i]);@#

    open_files(argv[i]); /* the `master' file */
    @<Write limbo@>;
    q = protect_underlines(_getname(argv[i]));
    if((p = strrchr(q, '.')) != NULL)
        fprintf(out,@/
        "@@*{%s\\ZZZ{\\setbox0=\\hbox{%s}\\hskip-\\wd0}}.\n"@/
        "\\ind=2\n\n", q, p);
    else
        fprintf(out, "@@*{%s}.\n"@/
        "\\ind=2\n\n", q);@#

    handle_input();
    @<Write index section@>;@#

    strcpy(buffer, argv[argc - 1]);
    modify_filename(buffer);@#

    printf(@/
    "\n You must now call CWEAVE with %s%s\n"@/
    " as the argument to get a TeX output", outdir, _getname(buffer));
    if(optind < argc - 1)
        printf(" of all processed files");
    printf("\n");@#

    fclose(in);
    fclose(out);
   }

@
\.{getopt.h} contains the \UNIX/--specific |getopt()|. If your system doesn't
support this function, get the GNU \CEE/--library for an implementation.

@<Include files@>=
#include <ctype.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


@*1 The input switches.
If the switch \.{-v} is set, all comments are written in typewriter type;
comments starting a line will also start a line in the output.

All tabs will be expanded, and the \.{-t} switch defines the tab length
(default value is 4).

The switch \.{-l} causes all linefeeds inside of \CEE/--text to be output
explicitly by inserting a \.{@@/} command at the end of each code line.

The output directory will be set with the \.{-o} option; this directory must
already exist. Probably you have to adjust |PATH_SEPARATOR| and
|pathsepchar[]| to your operating system.

To get a title, use the \.{-b} switch with the titlestring enclosed in double
quotes; this string will be passed directly to \TeX.

One--sided output is enabled with the option \.{-1} set.

The global variable |optarg| (defined in \.{getopt.h}) points to the option
argument; the string |optswchar[]| is modified to allow |'-'| and |'/'| as
characters which start options (not under \UNIX/).

@d DIR_LENGTH 80
@d TITLE_LENGTH 100
@d PATH_SEPARATOR '/'

@<Global...@>=
int tab_length = 4;
int verbatim = FALSE;
int user_linefeed = FALSE;
int one_side = FALSE;
char outdir[DIR_LENGTH + 1];
char title[TITLE_LENGTH + 1];@#

#ifdef __EMX__
char optchar[] = "-/";
char pathsepchar[] = "\\/";
#else
char optchar[] = "-";
char pathsepchar[] = "/";
#endif

@
@<Get command switches@>=
   {char c;
    int i;


    outdir[0] = '\0';
#ifdef __EMX__
    optswchar = optchar;
#endif@#

    strcpy(title, "c2cweb output"); /* the default title */@#

    while((c = getopt(argc, argv, "b:lo:t:v1")) != EOF)
       {switch(c)
           {case 'b':
                if(strchr(optchar, optarg[0]))
                                           /* check if argument is an option */
                    usage();@#

                if(strlen(optarg) >= TITLE_LENGTH)
                    fprintf(stderr,@/
                    "\nTitle too long. Will use \"c2cweb output\".\n");
                else
                    strcpy(title, optarg);
                break;
            case 'l':
                user_linefeed = TRUE;
                break;
            case 'o':
                if(strchr(optchar, optarg[0]))
                    usage();@#

                if((i = strlen(optarg)) >= DIR_LENGTH)
                    fprintf(stderr,@/
                    "\nOutput directory name too long. Will be ignored.\n");
                else
                   {strcpy(outdir, optarg);
                    if(!strchr(pathsepchar, outdir[i - 1]))
                              /* check if last character is a path separator */
                       {outdir[i] = PATH_SEPARATOR;
                        outdir[i + 1] = '\0';
                       }
                   }
                break;
            case 't':
                if(strchr(optchar, optarg[0]))
                    usage();@#

                tab_length = atoi(optarg);
                if(tab_length == 0 || tab_length > 8)
                    tab_length = 4; /* default value */
                break;
            case 'v':
                verbatim = TRUE;
                break;
            case '1':
                one_side = TRUE;
                break;
            default:
                usage();
                break;
           }
       }
   }

@
The output file has the same name as the input file but a different extension:
it will append a \.{w} or, if the extension is three characters long,
substitute the third character with a \.{w}, i.e. \.{.c} becomes \.{.cw},
\.{.h} becomes \.{.hw}, \.{.cpp} will be replaced by \.{.cpw} and so on
(notice that for example \.{.cppp} also becomes \.{.cpw}). If the character to
be changed is a \.{w}, an \.{x} is used instead of. This will be done by the
function |modify_filename()|.

@d FILE_NAME_LENGTH 80

@<Global...@>=
    FILE *in, *out;

@
@<Prototypes@>=
void open_files(char *);

@
@c
void open_files(filename)
  char *filename;
   {char buffer[DIR_LENGTH + FILE_NAME_LENGTH + 1];


    if(strlen(filename) > FILE_NAME_LENGTH - 2)
       {fprintf(stderr, "\n  File name too long.\n");
        exit(-1);
       }@#

    if((in = fopen(filename, "rt")) == NULL)
       {fprintf(stderr, "\n  Can't open input file %s\n", filename);
        exit(-1);
       }@#

    strcpy(buffer, outdir);
    strcat(buffer, filename);
    modify_filename(buffer);@#

    if((out = fopen(buffer, "wt")) == NULL)
       {fprintf(stderr, "\n  Can't open output file %s\n", buffer);
        exit(-1);
       }
   }


@*1 The output header.
This is the header of the last output file. You must call \.{CWEAVE} with this
file as an argument --- all other processed files will be included.

Additionally this `master' file will include the file \.{compiler.w}, which
should contain all system dependent definitions (like \.{va\_decl} or
\.{va\_arg}) not contained in the \.{CWEAVE} program. The syntax of
\.{compiler.w} is \.{CWEB} syntax; please read the documentation if you have
questions. You should set the global variable |CWEBINPUTS| used by \.{CWEAVE}
(and \.{CTANGLE}) to the directory where \.{compiler.w} resides.

The function |_getname()| will accept forward and backward slashes as path
separators if you compile under emx. However, options can be introduced with
|'-'| and |'/'|, therefore paths starting with a forward slash must be enclosed
in double quotes (not under \UNIX/).

@<Write limbo@>=
    fprintf(out,@/
        "\\font\\symb=cmsy10\n"@/
        "\\font\\math=cmmi10\n"@/
        "\\def\\ob"@/
            "{\\parskip=0pt\\parindent=0pt%%\n"@/
            "\\let\\\\=\\BS\\let\\{=\\LB\\let\\}=\\RB\\let\\~=\\TL%%\n"@/
            "\\let\\ =\\SP\\let\\_=\\UL\\let\\&=\\AM\\let\\^=\\CF%%\n"@/
            "\\obeyspaces\\frenchspacing\\tt}\n"@/
        "\n"@/
        "\\def\\e{\\hfill\\break\\hbox{}}\n"@/
        "\\def\\{{\\relax\\ifmmode\\lbrace\\else$\\lbrace$\\fi}\n"@/
        "\\def\\}{\\relax\\ifmmode\\rbrace\\else$\\rbrace$\\fi}\n"@/
        "\\def\\takenone#1{\\hskip-0.1em}\n"@/
        "\\let\\ZZZ=\\relax\n"@/
        "\n"@/
        "%s"@/
        "\n"@/
        "\\pageno=\\contentspagenumber \\advance\\pageno by 1\n"@/
        "\\let\\maybe=\\iftrue\n"@/
        "\n"@/
        "\\def\\title{%s}\n"@/
        "\n"@/
        "@@i compiler.w\n"@/
        "\n", one_side ? "\\let\\lheader=\\rheader\n" : "", title);@#

    for(i = optind; i < argc - 1; i++)
       {strcpy(buffer, argv[i]);
        modify_filename(buffer);@#

        fprintf(out, "@@i %s\n", _getname(buffer));
       }@#

    fputc('\n', out);@#


@*1 Input Handling.

@d BUFFER_LENGTH 500

@<Prototypes@>=
void handle_input(void);

@
This is a wild hack. Perhaps in a future version I will improve it.

@<Global...@>=
char buffer[BUFFER_LENGTH + 1];

@
@d xisspace(c) (isspace(c) && ((unsigned char)c < 0200))

@c
void handle_input(void)
   {char *buf_p;
    char ch;@#

    int any_input = FALSE;
                 /* set after the first non blank character in a new section */
    int brace_count = 0;
    int blank_count = 0;@#

    int in_comment = FALSE;
    int in_C = FALSE;
    int in_string = FALSE;
    int short_comment = FALSE;
    int leading_blanks = TRUE;
    int double_linefeed = FALSE; /* set if last character was a linefeed */
    int linefeed_comment = FALSE;
                          /* set if a comment follows a linefeed immediately */
    int comment_slash = FALSE; /* set if last character was a slash */
    int comment_star = FALSE; /* set if last character was a star */
    int escape_state = FALSE;
   /* needed to check whether in string or at the end of a preprocessor line */
    int before_TeX_text = FALSE;@#

    int function_blocks = FALSE; /* set if function block algorithm is on */@#


    line_number = 0;

    while(get_line())
       {buf_p = buffer;@#

        do
           {ch = *buf_p;@#

            @<Special cases@>;@#

            switch(ch)
               {case ' ':
                    if(leading_blanks)
                       {blank_count++;
                        goto end;
                       }
                    break;@#

                case '\t':
                       {int i = tab_length - (column % tab_length);

                        column += i - 1; /* we'll say later |column++| */@#

                        if(leading_blanks)
                           {blank_count += i;
                            goto end;
                           }@#

                        while(i--)
                            fputc(' ', out);
                        goto end;
                       }
                    break;@#

                case '{':
                    @<Cases for |'{'|@>;
                    break;@#

                case '}':
                    @<Cases for |'}'|@>;
                    break;@#

                case '/':
                    @<Cases for |'/'|@>;
                    break;@#

                case '*':
                    @<Cases for |'*'|@>;
                    break;@#

                case '\n':
                    @<Cases for |'\n'|@>;
                    break;@#

                case '@@':
                    @<Cases for |'@@'|@>;
                    break;@#

                case '\'':
                    @<Cases for |'\''|@>;
                    break;@#

                case '\"':
                    @<Cases for |'\"'|@>;
                    break;@#

                case '\\':
                    @<Cases for |'\\'|@>;
                    break;@#

                default:
                    @<Cases for |default|@>;
                    break;
               }@#

            fputc(ch, out);@#

end:
            buf_p++;
            column++;
           } while(ch != '\n');
       }
   }

@
Here comes a bunch of |if|--statements.

@<Special cases@>=
        if(buf_p == buffer) /* start of a line */
           {if(!(in_comment || in_string))
               {if(!strncmp(buf_p, "/""*@@@@*""/", 6))
                   {in_C = FALSE;
                    before_TeX_text = TRUE;
                    function_blocks = WAIT; /* switch on the algorithm */
                    brace_count = 0;@#

                    if(any_input)
                        fputs("\n@@\n"@/
                              "\\ind=2\n\n", out); /* start a new section */@#

                    any_input = FALSE;
                    *(buf_p--) = '\n';
                                     /* the rest of the line will be ignored */
                    goto end;
                   }
                else if(!strncmp(buf_p, "/""*@@*""/", 5))
                   {in_C = FALSE;
                    before_TeX_text = TRUE;
                    function_blocks = FALSE; /* switch off the algorithm */@#

                    if(any_input)
                        fputs("\n@@\n"@/
                              "\\ind=2\n\n", out);@#

                    any_input = FALSE;
                    *(buf_p--) = '\n';
                    goto end;
                   }
                else if(!strncmp(buf_p, "/""*{*""/", 5))
                   {brace_count++; /* a dummy opening brace */
                    fputs("@@{\n", out);@#

                    ch = '\n'; /* an end of line is simulated */
                    goto end;
                   }
                else if(!strncmp(buf_p, "/""*}*""/", 5))
                   {brace_count--; /* a dummy closing brace */
                    fputs("@@}\n", out);@#

                    if(!brace_count && function_blocks)
                                          /* end of function block reached ? */
                       {in_C = FALSE;
                        before_TeX_text = TRUE;@#

                        break;
                       }@#

                    ch = '\n';
                    goto end;
                   }
               }
           }@#

        if(double_linefeed && ch == '/')
            linefeed_comment = TRUE;@#

        if(double_linefeed && (ch == ' ' || ch == '\t'))
            leading_blanks = TRUE;@#

        if(ch != '\n') /* multiple linefeed ? */
            double_linefeed = FALSE;@#

        if(!xisspace(ch)) /* whitespaces ? */
           {any_input = TRUE;@#

            if(before_TeX_text && function_blocks)
               {before_TeX_text = FALSE;@#

                if(function_blocks == WAIT)
                    function_blocks = TRUE;
                                           /* start at the second occurrence */
                else
                   {fputs("@@\n"@/
                          "\\ind=2\n\n", out); /* start a new text section */@#

                    if(leading_blanks)
                       {leading_blanks = FALSE;@#

                        while(blank_count--)
                            fputc(' ', out);
                        blank_count = 0;
                       }
                   }
               }@#

            if(in_comment && leading_blanks)
               {leading_blanks = FALSE;@#

                while(blank_count--)
                    fputc(' ', out);
                blank_count = 0;
               }
           }@#

        if(!(ch == '/' || xisspace(ch)))
                                /* whitespace or possible start of comment ? */
           {if(!(in_comment || in_C || comment_slash))  /* outside of code ? */
               {in_C = TRUE;@#

                fputs("@@c\n", out); /* start of a new code section */@#

                if(leading_blanks)
                   {leading_blanks = FALSE;@#

                    while(blank_count--)
                        fputc(' ', out);
                    blank_count = 0;
                   }
               }@#

            if(!(in_comment || comment_slash) && leading_blanks)
               {leading_blanks = FALSE;@#

                while(blank_count--)
                    fputc(' ', out);
                blank_count = 0;
               }
           }@#

        if(comment_slash && !(ch == '*' || ch == '/'))
                                                     /* start of a comment ? */
           {comment_slash = FALSE;
            if(!in_comment)
                linefeed_comment = FALSE;@#

            fputc('/', out);
           }@#

        if(comment_star && ch != '/') /* end of a comment ? */
           {comment_star = FALSE;@#

            fputc('*', out);
           }@#

        if(escape_state && !(ch == '\"' || ch == '\n' || ch == '\\'))
          /* end of string or end of preprocessor line or backslash itself ? */
            escape_state = FALSE;@#

@
@<Cases for |'{'|@>=
                if(in_comment)
                    fputc('\\', out);
                else if(in_string)
                    break;
                else if(function_blocks)
                   {brace_count++;
                    in_C = TRUE;
                   }

@
@<Cases for |'@@'|@>=
                if(in_comment)
                   {fputs("{\\char64}", out);
                    goto end;
                   }
                else /* \.{CWEB} needs \.{@@@@} to output \.{@@} */
                    fputc('@@', out);

@
@<Cases for |'\''|@>=
                if(!in_comment)
                   {if(*(buf_p + 1) == '\"' && *(buf_p + 2) == '\'')
                        escape_state = TRUE;           /* this catches |'"'| */
                   }

@
@<Cases for |'\"'|@>=
                if(!in_comment) /* start or end of a string ? */
                   {if(escape_state)
                        escape_state = FALSE;
                    else
                        in_string = TRUE - in_string;
                   }

@
@<Cases for |'\\'|@>=
                if(in_comment)
                   {fputs("{\\symb\\char110}", out);
                    goto end;
                   }
                else
                    escape_state = TRUE - escape_state;
                 /* continuation of preprocessor line or an escape character */

@
@<Cases for |'}'|@>=
                if(in_comment)
                    fputc('\\', out);
                else if(in_string)
                    break;
                else if(function_blocks)
                   {brace_count--;
                    if(!brace_count) /* end of function block reached ? */
                       {in_C = FALSE;@#

                        before_TeX_text = TRUE;
                        break;
                       }
                   }

@
@<Cases for |'/'|@>=
                if(comment_star)
                   {comment_star = FALSE;
                    leading_blanks = FALSE;@#

                    if(!short_comment)
                       {in_comment = FALSE; /* end of comment */@#

                        if(!in_C)
                           {linefeed_comment = FALSE;@#

                            if(verbatim)
                                fputs("*""/}", out);@#

                            if(*(buf_p + 1) == '\n') /* end of line ? */
                                fputs("\\e{}%", out);@#

                            goto end;
                           }

                        if(in_C && verbatim)
                           {if(linefeed_comment)
                               {linefeed_comment = FALSE;@#

                                fputs("*""/@@>", out);
                                if(*(buf_p + 1) == '\n' && !user_linefeed)
                                    fputs("@@/", out);
                                goto end;
                               }
                            else
                                fputc('}', out);@#
                           }@#

                        linefeed_comment = FALSE;@#

                        if(in_C || verbatim)
                            fputc('*', out);
                        else
                            goto end;
                       }
                    else
                        fputc('*', out);
                   }
                else if(comment_slash)
                   {comment_slash = FALSE;@#

                    if(!short_comment)
                       {in_comment = TRUE;
                        short_comment = TRUE; /* start of a short comment */@#

                        if(!in_C && verbatim)
                           {fputs("{\\ob{}", out);
                            if(leading_blanks)
                               {leading_blanks = FALSE;@#

                                while(blank_count--)
                                    fputc(' ', out);
                                blank_count = 0;
                               }
                            fputs("//", out);@#

                            goto end;
                           }@#

                        if(in_C && verbatim)
                           {if(leading_blanks || linefeed_comment)
                               {linefeed_comment = TRUE;@#

                                if(!user_linefeed)
                                    fputs("@@/", out);
                                fputs("@@t}\\8{\\ob{}", out);
                                         /* this cryptic command starts a
                                            comment line without indentation */
                                if(leading_blanks)
                                   {leading_blanks = FALSE;@#

                                    while(blank_count--)
                                        fputc(' ', out);
                                    blank_count = 0;
                                   }
                                fputs("//", out);
                               }
                            else
                                fputs("//{\\ob{}", out);@#

                            goto end;
                           }@#

                        if(in_C || verbatim)
                            fputc('/', out);
                        else
                            goto end;
                       }
                    else
                        fputc('/', out);
                   }
                else
                   {comment_slash = TRUE;@#

                    goto end;
                   }

@
@<Cases for |'*'|@>=
                if(comment_slash)
                   {comment_slash = FALSE;@#

                    if(in_comment && !short_comment)
                                    /* aah, uuh, for people who `comment out'
                                       code with comments instead of using
                                       \.{\#if 0==1} and \.{\#endif} for
                                       example --- this non--ANSI behaviour
                                       would cause bad formatted code and is
                                       therefore not supported; the program
                                       exits */
                       {fprintf(stderr,
                        "    Error line %d: Nested comments not supported\n",
                        line_number);
                        exit(-1);
                       }@#

                    if(!short_comment)
                       {in_comment = TRUE; /* start of comment */@#

                        if(!in_C && verbatim)
                           {fputs("{\\ob{}", out);
                            if(leading_blanks)
                               {leading_blanks = FALSE;@#

                                while(blank_count--)
                                    fputc(' ', out);
                                blank_count = 0;
                               }
                            fputs("/""*", out);@#

                            goto end;
                           }@#

                        if(in_C && verbatim)
                           {if(leading_blanks || linefeed_comment)
                               {linefeed_comment = TRUE;

                                if(!user_linefeed)
                                    fputs("@@/", out);
                                fputs("@@t}\\8{\\ob{}", out);
                                if(leading_blanks)
                                   {leading_blanks = FALSE;@#

                                    while(blank_count--)
                                        fputc(' ', out);
                                    blank_count = 0;
                                   }
                                fputs("/""*", out);
                               }
                            else
                                fputs("/""*{\\ob{}", out);@#

                            goto end;
                           }@#

                        if(in_C || verbatim)
                            fputc('/', out);
                        else
                           {fputs("  ", out);@#

                            goto end;
                           }
                       }
                    else
                        fputc('/', out);
                   }
                else
                   {comment_star = TRUE;@#

                    goto end;
                   }

@
@<Cases for |'\n'|@>=
                blank_count = 0;@#

                if(!in_comment && in_C)
                   {if(double_linefeed == FALSE)
                       {double_linefeed = TRUE;
                        if(escape_state)
                           {escape_state = FALSE;
                                      /* continuation of a preprocessor line */
                            leading_blanks = TRUE;@#

                            if(in_string)
                                fputc('\n', out);
                            else
                                fputs("\n@@/", out);
                            goto end;
                           }@#

                        if(!leading_blanks && user_linefeed)
                            fputs("@@/", out);
                       }
                    else if(double_linefeed == TRUE)
                       {double_linefeed = DONE;
                                  /* blank lines in the input will be output as
                                     little white space between code lines */@#
                        fputs("@@#", out);
                       }
                   }@#

                leading_blanks = TRUE;@#

                if(short_comment)
                   {short_comment = FALSE;
                    in_comment = FALSE;
                    double_linefeed = TRUE;@#

                    if(verbatim)
                       {if(linefeed_comment && in_C)
                            fputs("@@>", out);
                        else
                            fputc('}', out);
                       }@#

                    if(!in_C)
                        fputs("\\e{}%", out);
                    else if(linefeed_comment && verbatim)
                        fputs("@@/", out);@#

                    linefeed_comment = FALSE;
                   }@#

                if(in_comment && in_C && verbatim && linefeed_comment)
                   {fputs("@@>@@/\n@@t}\\8{\\ob{}", out);
                       /* continuation of a comment line without indentation */
                    goto end;
                   }@#

                if(in_comment && verbatim)
     /* Both \.{CWEAVE} and \TeX\ need an input at the beginning of a line
        to prevent leading blanks be swallowed while in verbatim mode;
        this will be the macro \.{\\e} which causes a linebreak */
                   {fputs("\n\\e{}", out);
                    goto end;
                   }

@
All other special characters will be substituted with proper sequences \TeX\
can understand.

@<Cases for |default|@>=
                if(in_comment)
                   {switch(ch)
                       {case '#':
                            fputs("{\\#}", out);
                            break;@#

                        case '$':
                            fputs("{\\$}", out);
                            break;@#

                        case '%':
                            fputs("{\\%}", out);
                            break;@#

                        case '&':
                            fputs("{\\AM}", out);
                            break;@#

                        case '_':
                            fputs("{\\_}", out);
                            break;@#

                        case '^':
                            fputs("{\\^{}}", out);
                            break;@#

                        case '\\':
                            fputs("{\\symb\\char110}", out);
                            break;@#

                        case '~':
                            fputs("{\\~{}}", out);
                            break;@#

                        case '|':
                            fputs("{\\symb\\char106}", out);
                            break;@#

                        case '<':
                            fputs("{\\math\\char60}", out);
                            break;@#

                        case '>':
                            fputs("{\\math\\char62}", out);
                            break;@#

                        default:
                            fputc(ch, out);
                            break;
                       }@#

                    goto end;
                   }

@
Because the index macros defined in \.{cwebmac.tex} don't append a dot, we have
to redefine \.{\\ZZZ}.

@<Write index section@>=
    fprintf(out,@/
            "\n"@/
            "@@*Index.\n"@/
            "\\let\\ZZZ=\\takenone\n");

@
@<Prototypes@>=
void usage(void);

@
@c
void usage(void)
   {fprintf(stderr,@/
    "Usage: c2cweb [switches] csourcefile(s) | @@responsefile(s)"@/
    "\n"@/
    "\n  possible switches:"@/
    "\n"@/
    "\n    -b \"title\"    set title"@/
    "\n    -l            use input linefeeds"@/
    "\n    -o dirname    set output directory (must already exist)"@/
    "\n    -t tablength  set tabulator length (default 4)"@/
    "\n    -v            verbatim mode"@/
    "\n    -1            one-sided output"@/
    "\n"@/
    "\n");@#

    exit(-1);
   }

@
@<Prototypes@>=
void modify_filename(char *);

@
If a response file is expanded, trailing blanks can occur which will be ignored
here. The same happens if a filename with trailing blanks is enclosed in
quotes.

@c
void modify_filename(name)
  char *name;
   {char *p;


    if((p = strrchr(name, '.')) != NULL)
       {p++;
        if(*p && *p != ' ')
            p++;
        if(*p && *p != ' ')
            p++;
        if(*p != 'w')
            *p = 'w';
        else
            *p = 'x';
        p++;
        *p = '\0';
       }
    else
        strcat(name, ".w");
   }

@
@<Global...@>=
int line_number = 0;
int column;

@
@<Prototypes@>=
char *get_line(void);

@
|get_line()| gets the next line and removes all trailing blanks or tabs.

@c
char *get_line(void)
   {char *p;
    int i = BUFFER_LENGTH;


    if((p = fgets(buffer, BUFFER_LENGTH + 1, in)) != NULL)
       {while(i--)
           {if(*(p++) == '\n')
                break;
           }@#

        p--;
        p--;
        while((*p == ' ' || *p == '\t') && p >= buffer)
            p--;
        *(p + 1) = '\n';
        *(p + 2) = '\0';@#

        line_number++;
        column = 0;
       }
    return(p);
   }

@
@<Global...@>=
char tempbuf[2 * FILE_NAME_LENGTH + 1];

@
@<Prototypes@>=
char *protect_underlines(char *);

@
This function is needed for the names of named sections, i.e. file names.

@c
char *protect_underlines(p)
  char *p;
   {char *q;


    q = tempbuf;@#

    do
       {if(*p == '_')
            *(q++) = '\\';
        *(q++) = *p;
       } while(*(p++));@#

    return tempbuf;
   }

@
@<Prototypes@>=
#ifndef __EMX__
char *_getname(char *);
#endif

@
For Linux and other \UNIX/--systems the function |_getname()| must be
defined.

@c
#ifndef __EMX__
char *_getname(char *path)
   {char *p;

    p = strrchr(path, '/');
    return p == NULL ? path : (p + 1);
   }
#endif


@* Hints and Tricks.
Some words are reserved by \.{CWEAVE} you would like to use. Here is a small
list of them (see the manual for a complete one):

    \in \.{error}, \.{line}, \.{try}, $\ldots$

To make a word unreserved write a line

    \in \.{@@s} \\{ident} \\{x}

into \.{compiler.w} where \\{ident} is the reserved word.

Some words you would expect \.{CWEAVE} knows actually are not in its memory:

    \in \.{va\_arg}, \.{va\_end}, \.{va\_start}, $\ldots$

To make a word \\{ident1} reserved you should write

    \in \.{@@s} \\{ident1} \\{ident2}

into \.{compiler.w}. Now \\{ident1} will behave as \\{ident2}; for example

    \in \.{@@s va\_decl va\_dcl}

causes \.{CWEAVE} to treat \.{va\_decl} as it treats \.{va\_dcl}.

Bear always in mind that \.{CWEAVE} has been developed for use with \UNIX/ and
not for DOS or OS/2. Weird non-ANSI constructions like

    \in \&{void \_FAR} |*| \&{\_FARFUNC \_Cdecl} \\{memcpy} $\ldots$

will cause some, hmmm, troubles if you use the original \.{CWEAVE} program.
Until now it's also a bit difficult to program for Windows\tm\ or the
Presentation Manager\tm, because you have to include every structure and
constant you use in your program manually, which can be a tedious work.

Do not use the same name for a structure and an instance of it. This means that
you must avoid things like this:

    \in \&{struct foo} \\{foo;}

\.{CWEAVE} would be confused totally. The same applies to all identifiers
which will be used as reserved and as unreserved words at the same time (This
usually will not affect identical names of variables and functions. But in
this case the reader of your program will get confused).

Most of the \CEE/ constants are written in upper case, and \.{CWEAVE} writes
them in typewriter type. But some constants like \.{\_Windows} or
\.{\_\_cplusplus} are mixed or lower case, and \.{CWEAVE} will use italic type
instead of. Look at \.{compiler.w} again to see a workaround how to get a
correct output (Note: underline characters are converted to `x' in the
\TeX\ control string).

Nested comments are not supported; the program aborts with an error message.

If you have unbalanced braces due to \.{\#ifdef foo} $\ldots$ \.{\#endif}
constructions, you can keep \.{c2cweb} and your editor happy if you write a
\.{/*\{*/} or \.{/*\}*/} command where needed; otherwise memory of \.{CWEAVE}
can overflow. \.{c2cweb} replaces these commands with the equal \.{CWEB}
constructions (only defined in this package's modified \.{CWEAVE} version!).

Another trick with preprocessor conditionals:

    \in \.{/*@@*/}

    \in \&{\#ifdef} \.{foo}

        \in\in \&{int} \\{func1} $\{\,\ldots\,\}$
 
    \in \&{\#endif}

    \in \.{/*@@@@*/}

Without \.{/*@@*/} the \&{\#endif} instruction would be written into the next
section.


@* Index.
