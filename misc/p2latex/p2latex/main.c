/*
 *  p2LaTeX: Produce prettyprinted LaTeX files from Pascal sources.
 *  Copyright (C) 1993 Torsten Poulin
 *    Note: This program is derived from work done by others.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Torsten Poulin 
 *  Banebrinken 99, 2, 77
 *  DK-2400 Copenhagen NV
 *  DENMARK
 *
 *  e-mail: torsten@diku.dk
 *  --------------------------------------------------------------------
 *  p2latex is derived from the code for the program C++2LaTeX 2.0 which
 *  produces prettyprinted LaTeX files from C++ or C sources.
 *
 *  C++2LaTeX 2.0 is copyright (C) 1991 Joerg Heitkoetter
 *
 *     Systems Analysis Research Group
 *     University of Dortmund
 *     (heitkoet@gorbi.informatik.uni-dortmund.de).
 *
 *  The original C++2LaTeX is copyright (C) 1990 Norbert Kiesel
 *
 *      Norbert Kiesel
 *      RWTH Aachen / Institut f. Informatik III
 *      Ahornstr. 55
 *      D-5100 Aachen
 *      West Germany
 *
 *      Phone:  +49 241 80-7266
 *      EUNET:  norbert@rwthi3.uucp
 *      USENET: ...!mcvax!unido!rwthi3!norbert
 *      X.400:  norbert@rwthi3.informatik.rwth-aachen.de
 *  --------------------------------------------------------------------
 * p2latex main.c revision history.
 * $Log:	main.c,v $
 * Revision 1.5  93/12/20  14:25:10  Torsten
 * Changed the error messages to comply with the manual page.
 * 
 * Revision 1.4  93/12/09  12:14:50  Torsten
 * Moved the #include lines to get rid of a warning when using gcc.
 * Blanks are now printed with \verb*+ + inside strings.
 * The copyleft comment now refers to version 2 of the GPL.
 * The usage() function changed a bit to display more POSIX.2
 * compliant options ('--' instead of '+').
 * 
 * Revision 1.3  93/11/06  14:41:41  Torsten
 * Added a few lines to the comment at the top of the program
 * giving credit to the authors of C++2LaTeX.
 * Program name isn't hard-wired anymore.
 * ANSIfied the code a bit.
 * 
 * Revision 1.2  93/10/30  11:59:51  Torsten
 * Corrected the usage "page".
 * Changed "+piped" to "+pipe".
 * 
 * Revision 1.1  93/10/15  23:42:27  Torsten
 * Initial revision
 * 
 */

#include <stdio.h>
#include "getopt.h"
#include <string.h>
#include <fcntl.h>
#include <ctype.h>
#include <time.h>

static char RCSid[] = "$Id: main.c,v 1.5 93/12/20 14:25:10 Torsten Rel $";

extern insidestring;
extern int tabtoend, tabtotab, complete_file, piped;
extern int aligntoright, header, fancysymbols;
extern char *font_size, *indentation, *comment_font, *header_font;
extern char *string_font, *keyword_font, *ident_font;

/* Prototypes for functions defined in main.c */
void substitute(char *input);
void indent(char *blanks);
int main(int argc, char **argv);
void usage(char *name);

void substitute(char *input)
{
  while (*input) {
    switch (*input) {
    case '_':
    case '&':
    case '#':
    case '$':
    case '%':
    case '{':
    case '}':
      printf("\\%c", *input);
      break;
    case '+':
    case '=':
    case '<':
    case '>':
      printf("$%c$", *input);
      break;
    case '*':
      printf("$\\ast$");
      break;
    case '|':
      printf("$\\mid$");
      break;
    case '\\':
      printf("$\\backslash$");
      break;
    case '^':
      printf("$\\wedge$");
      break;
    case '~':
      printf("$\\sim$");
      break;
    case ' ':
      if (insidestring)
	printf("\\verb*+ +");
      else
	printf(" ");
      break;
    default:
      printf("%c", *input);
      break;
    }
    input++;
  }
}

void indent(char *blanks)
{
  int i;

  i = 0;
  while (*blanks) {
    if (*blanks == ' ') {
      i++;
    }
    else {			/* *blanks == '\t' */
      while (++i % tabtotab) ;
    }
    blanks++;
  }
  printf("\\hspace*{%d\\indentation}", i);
}

extern char *version_string;

static struct option opts[] =
{
  {"complete-file", 0, 0, 'c'},
  {"fancy", 0, 0, 'f'},
  {"font-size", 1, 0, 's'},
  {"indentation", 1, 0, 'i'},
  {"header", 0, 0, 'h'},
  {"pipe", 0, 0, 'p'},
  {"no-alignment", 0, 0, 'n'},
  {"output", 1, 0, 'o'},
  {"tabstop", 1, 0, 'T'},
  {"end-comment", 1, 0, 'e'},
  {"comment-font", 1, 0, 'C'},
  {"string-font", 1, 0, 'S'},
  {"identifier-font", 1, 0, 'I'},
  {"keyword-font", 1, 0, 'K'},
  {"header-font", 1, 0, 'H'},
  {"version", 0, 0, 'V'},
  {0, 0, 0, 0}
};

char *program_name;

main(int argc, char **argv)
{
  int c;
  int index;
  int i;
  int has_filename;
  char *input_name;
  char *output_name;
  long now;
  char *today;
  char *malloc();

  input_name = "Standard Input";
  output_name = 0;

  now = time(0);
  today = ctime(&now);

  program_name = argv[0];

  if (argc == 1)
    usage(program_name);

  while ((c = getopt_long(argc, argv,
			  "cfpno:s:i:e:hT:C:H:S:I:K:V", opts, &index))
	 != EOF) {
    if (c == 0) {
      /* Long option */
      c = opts[index].val;
    }
    switch (c) {
    case 'c':
      complete_file = 1;
      break;
    case 'f':
      fancysymbols = 1;
      break;
    case 'o':
      if (piped) {
	fprintf(stderr,
		"%s: Can't use {-p,--pipe} and {-o,--output} together\n",
		program_name);
	exit(5);
      }
      output_name = optarg;
      break;
    case 'n':
      aligntoright = 0;
      break;
    case 's':
      font_size = optarg;
      break;
    case 'i':
      indentation = optarg;
      break;
    case 'e':
      tabtoend = atoi(optarg);
      break;
    case 'T':
      tabtotab = atoi(optarg);
      break;
    case 'p':
      if (output_name != 0) {
	fprintf(stderr,
		"%s: Can't use {-p,--pipe} and {-o,--output} together\n",
		program_name);
	exit(5);
      }
      piped = 1;
      break;
    case 'h':
      header = 1;
      complete_file = 1;	/* header implies complete-file */
      break;
    case 'C':
      comment_font = optarg;
      break;
    case 'H':
      header_font = optarg;
      break;
    case 'S':
      string_font = optarg;
      break;
    case 'I':
      ident_font = optarg;
      break;
    case 'K':
      keyword_font = optarg;
      break;
    case 'V':
      fprintf(stderr, "%s\n", version_string);
      break;
    default:
      usage(program_name);
    }
  }
  has_filename = (argc - optind == 1);
  if (has_filename) {
    /* last argument is input file name */
    input_name = argv[optind];
    if (freopen(input_name, "r", stdin) == NULL) {
      fprintf(stderr, "%s: Can't open `%s' for reading\n",
	      program_name, input_name);
      exit(2);
    }
  }
  if ((output_name == 0) && !piped) {
    char *tmp;

    if (has_filename) {
      tmp = strrchr(input_name, '/');
      if (tmp == 0) {
	/* plain filename */
	tmp = input_name;
      }
      else {
	tmp++;
      }
    }
    else {
      tmp = program_name;
    }

    output_name = malloc(strlen(tmp) + 4);

    if (output_name == 0) {
      fprintf(stderr, "%s: Virtual memory exhausted\n", program_name);
      exit(3);
    }
    strcpy(output_name, tmp);
    strcat(output_name, ".tex");
  }
  if (!piped) {
    if (freopen(output_name, "w", stdout) == NULL) {
      fprintf(stderr, "%s: Can't open `%s' for writing\n",
	      program_name, output_name);
      exit(3);
    }
  }
  printf("\
%%\n\
%% This file was automatically produced at %.24s by\n\
%% %s", today, program_name);
  for (i = 1; i < argc; i++) {
    printf(" %s", argv[i]);
  }
  if (!has_filename) {
    printf(" (from Standard Input)");
  }
  printf("\n%%\n");
  if (complete_file) {
    if (header) {
      if (strcmp(font_size, "10") == 0) {
	printf("\\documentstyle[fancyheadings]{article}\n");
      } else {
	printf("\\documentstyle[%spt,fancyheadings]{article}\n",
	       font_size);
      }
    }
    else {
      if (strcmp(font_size, "10") == 0) {
	printf("\\documentstyle{article}\n");
      }
      else {
	printf("\\documentstyle[%spt]{article}\n", font_size);
      }
    }

    printf("\\setlength{\\textwidth}{16cm}\n");
    printf("\\setlength{\\textheight}{23cm}\n");
    printf("\\setlength{\\hoffset}{-2cm}\n");
    printf("\\setlength{\\voffset}{-2cm}\n");

    if (header) {
      printf("\\lhead{\\%s ", header_font);
      substitute(input_name);
      printf("}");
      printf("\\rhead{\\rm\\thepage}\n");
      printf("\\cfoot{}\n");
      printf("\\addtolength{\\headheight}{14pt}\n");
      printf("\\pagestyle{fancy}\n");
    }
    printf("\\begin{document}\n");
  }

  printf("\\expandafter\\ifx\\csname indentation\\endcsname\\relax%\n");
  printf("\\newlength{\\indentation}\\fi\n");
  printf("\\setlength{\\indentation}{%s}\n", indentation);

  printf("\\begin{flushleft}\n");
  yylex();
  printf("\\end{flushleft}\n");

  if (complete_file) {
    printf("\\end{document}\n");
  }
  exit(0);
}

void usage(char *name)
{
  fprintf(stderr, "%s\n", version_string);
  fprintf(stderr, "\
Usage: %s [options] [file]\n\n\
Short options:\n\
	[-c]			[-e distance]\n\
	[-f]			[-h]\n\
	[-i length]		[-n]\n\
	[-o file]		[-p]\n\
	[-s fontsize]		[-C font]\n\
	[-H font]		[-I font]\n\
	[-K font]		[-S font]\n\
	[-T tabulatorwidth]	[-V]\n\
\n\
Long options:\n\
	[--complete-file]	[--end-comment distance]\n\
	[--fancy]		[--header]\n\
	[--indentation length]	[--no-alignment]\n\
	[--output file]		[--pipe]\n\
	[--font-size size]	[--comment-font font]\n\
	[--header-font font]	[--identifier-font font]\n\
	[--keyword-font font]	[--string-font font]\n\
	[--tabstop width]	[--version]\n", name);
  exit(1);
}
