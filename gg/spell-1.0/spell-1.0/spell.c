/* spell.c -- clone of Unix `spell'.

   This file is part of GNU Spell.
   Copyright (C) 1996 Free Software Foundation, Inc.
   Written by Thomas Morgan <tmorgan@pobox.com>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */

/* Local headers.  */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "getopt.h"
#include "str.h"

/* System headers.  */

#include <sys/types.h>
#include <ctype.h>
#include <errno.h>
#include <memory.h>
#include <pwd.h>
#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <unistd.h>

#ifdef HAVE_STRING_H
#include <string.h>
#else /* not HAVE_STRING_H */
#include <strings.h>
#endif /* not HAVE_STRING_H */

/* Always add at least this many bytes when extending the buffer.  */
#define MIN_CHUNK 64

#ifndef STDIN_FILENO
#define STDIN_FILENO 0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2
#endif /* STDIN_FILENO */

#ifndef SIG_ERR
#define SIG_ERR (-1)
#endif

#ifndef EXIT_SUCCESS
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1
#endif /* EXIT_SUCCESS */

/* Used for communication through a pipe.  */
struct pipe
  {
    /* File descriptors used by the parent process.  */
    int pin;			/* Input channel.  */
    int pout;			/* Output channel.  */
    int perr;			/* Error channel (for reading).  */

    /* File descriptors used by the child process.  */
    int cin;			/* Input channel.  */
    int cout;			/* Output channel.  */
    int cerr;			/* Error channel (for writing).  */

    fd_set error_set;		/* Descriptor set used to check for
				   errors (contains perr).  */
  };
typedef struct pipe pipe_t;

#ifndef HAVE_STRERROR
static char *strerror (int);
#endif

char *find_ispell ();
static char *xstrdup (const char *);
static void *xmalloc (size_t);
static void *xrealloc (void *, size_t);
static void error (int status, int errnum, const char *message,...);
static void sig_chld (int);
static void sig_pipe (int);
void new_pipe (pipe_t *);
void parent (pipe_t *, int, char **);
void read_file (pipe_t *, FILE *, char *);
void read_ispell (pipe_t *, char *, int);
void read_ispell_errors (pipe_t *);
void run_ispell_in_child (pipe_t *);

/* Version of this program.  */
const char version[] = "version " VERSION;

/* Switch information for `getopt'.  */
const struct option long_options[] =
{
  {"all-chains", no_argument, NULL, 'l'},
  {"british", no_argument, NULL, 'b'},
  {"dictionary", required_argument, NULL, 'd'},
  {"help", no_argument, NULL, 'h'},
  {"ispell", required_argument, NULL, 'i'},
  {"ispell-version", no_argument, NULL, 'I'},
  {"number", no_argument, NULL, 'n'},
  {"print-file-name", no_argument, NULL, 'o'},
  {"print-stems", no_argument, NULL, 'x'},
  {"stop-list", required_argument, NULL, 's'},
  {"verbose", no_argument, NULL, 'v'},
  {"version", no_argument, NULL, 'V'},
  {NULL, 0, NULL, 0}
};

/* The name of the executable this process comes from.  */
char *program_name = NULL;

/* Ispell's location.  */
char *ispell_prog = NULL;

/* Dictionary to use.  Just use the default if NULL.  */
char *dictionary = NULL;

/* Display Ispell's version (--ispell-version, -I). */
int show_ispell_version = 0;

/* Whether we've read from stdin already.  */
int read_stdin = 0;

/* Whether we're using the British dictionary (--british, -b).  */
int british = 0;

/* Whether we're printing out words even if they need affixes added to
   be spelled correctly (--verbose, -v).  */
int verbose = 0;

/* Whether we're prepending line numbers to the lines (--number, -n).  */
int number_lines = 0;

/* Whether we're printing the file names before the lines
   (--print-file-name, -o).  */
int print_file_names = 0;

/* Whether we're reading from the terminal.  We never will.  */
int interactive = 0;

int
main (int argc, char **argv)
{
  char opt = 0;			/* Current option.  */
  int opt_error = 0;		/* Whether an option error occurred.  */
  int show_help = 0;		/* Display help (--help, -h).  */
  int show_version = 0;		/* Display the version (--version, -V).  */
  pid_t pid = 0;		/* Child's pid.  */
  pipe_t ispell_pipe;		/* The descriptors for our pipe.  */

  program_name = argv[0];

  /* Option processing loop.  */
  while (1)
    {
      opt = getopt_long (argc, argv, "IVbdhilnosvx", long_options,
			 (int *) 0);

      if (opt == EOF)
	break;

      switch (opt)
	{
	case 'I':
	  show_ispell_version = 1;
	  break;
	case 'V':
	  show_version = 1;
	  break;
	case 'b':
	  british = 1;
	  break;
	case 'd':
	  if (optarg != NULL)
	    dictionary = xstrdup (optarg);
	  else
	    error (0, 0, "option argument not given");
	  break;
	case 'h':
	  show_help = 1;
	  break;
	case 'i':
	  if (optarg != NULL)
	    ispell_prog = xstrdup (optarg);
	  else
	    error (0, 0, "option argument not given");
	  break;
	case 'l':
	  break;
	case 'n':
	  number_lines = 1;
	  break;
	case 'o':
	  print_file_names = 1;
	  break;
	case 's':
	  break;
	case 'v':
	  verbose = 1;
	  break;
	case 'x':
	  break;
	default:
	  opt_error = 1;
	  break;
	}
    }

  if (opt_error)
    {
      printf ("Try `%s --help' for more information.\n", program_name);
      exit (EXIT_FAILURE);
    }

  if (show_version)
    {
      error (0, 0, version);

      if (!show_help)
	exit (EXIT_SUCCESS);
    }

  if (show_help)
    {
      printf ("Usage: %s [OPTION]... [FILE]...\n", program_name);
      fputs ("This is GNU Spell, a Unix spell emulator.\n\n"
	     "  -I, --ispell-version\t\tPrint Ispell's version.\n"
	     "  -V, --version\t\t\tPrint the version number.\n"
	     "  -b, --british\t\t\tUse the British dictionary.\n"
	     "  -d, --dictionary=FILE\t\tUse FILE to look up words.\n"
	     "  -h, --help\t\t\tPrint a summary of the options.\n"
	     "  -i, --ispell=PROGRAM\t\tCalls PROGRAM as Ispell.\n"
	     "  -l, --all-chains\t\tIgnored; for compatibility.\n"
	     "  -n, --number\t\t\tPrint line numbers before lines.\n"
	     "  -o, --print-file-name\t\tPrint file names before lines.\n"
	     "  -s, --stop-list=FILE\t\tIgnored; for compatibility.\n"
	     "  -v, --verbose\t\t\tPrint words not literally found.\n"
	     "  -x, --print-stems\t\tIgnored; for compatibility.\n\n"
	     "Please use Info to read more (type `info spell').\n", stderr);
      exit (EXIT_SUCCESS);
    }

  if (!ispell_prog)
    ispell_prog = find_ispell ();

  new_pipe (&ispell_pipe);

  pid = fork ();

  if (pid < 0)
    error (EXIT_FAILURE, errno, "error forking to run Ispell");
  else if (pid > 0)
    parent (&ispell_pipe, argc, argv);
  else
    run_ispell_in_child (&ispell_pipe);

  exit (EXIT_SUCCESS);
}

/* Return the location of Ispell through the string *ISPELL (created
   by `str_make'), or find it in the `PATH' environmental variable,
   or exit with an error if it is not found.  */

char *
find_ispell ()
{
  char *ispell = NULL;
  char *path = NULL;
  int path_len = 0;
  int pos = 0;
  str_t *file = str_make (0);
  struct stat stat_buf;

  path = xstrdup (getenv ("PATH"));
  path_len = strlen (path);

  while (1)
    {
      file = str_make (file);

      if (!pos && path[pos] == ':')
	/* A `:' right at the beginning means the current
	   directory is the first directory to search.  */
	str_add_char (file, '.');
      else
	for (; pos < path_len && path[pos] != ':'; pos++)
	  str_add_char (file, path[pos]);

      if (file->str[file->len - 1] != '/')
	str_add_char (file, '/');
      str_add_str (file, nstr_to_str ("ispell"));

      if (stat (str_to_nstr (file), &stat_buf) != -1)
	return xstrdup (str_to_nstr (file));

      if (pos >= path_len)
	error (EXIT_FAILURE, 0, "unable to locate Ispell");
      pos++;
    }

  /* We should never reach this.  */
  abort ();
}

/* Read the file *FILE, opened in the file stream *STREAM.  Send
   output, line by line, through *THE_PIPE (created by `new_pipe').  */

void
read_file (pipe_t * the_pipe, FILE * stream, char *file)
{
  str_t *str = str_make (0);
  enum add_line_return add_line_ret = 0;
  int line = 0;

  while (1)
    {
      str = str_make (str);

      str_add_char (str, '^');
      add_line_ret = str_add_line (str, stream);
      line++;

      if (add_line_ret == ADD_LINE_ERR)
	error (EXIT_FAILURE, errno, "%s: error reading line", file);
      if (add_line_ret == ADD_LINE_EOF && !str->len)
	return;

      /* In case there was no newline at the end of the file.  */
      if (str->str[str->len - 1] != '\n')
	str_add_char (str, '\n');

      if (write (the_pipe->pout, str_to_nstr (str), str->len) != str->len)
	error (EXIT_FAILURE, errno, "error writing to Ispell");

      read_ispell_errors (the_pipe);
      read_ispell (the_pipe, file, line);
      read_ispell_errors (the_pipe);

      if (add_line_ret == ADD_LINE_EOF)
	return;
    }

  if (fclose (stream) == EOF)
    error (0, errno, "%s: close error", file);
}

/* Read all of Ispell's corrections for a line of text (already
   submitted) from the open pipe *ISPELL_PIPE (created by `new_pipe').
   Must be called from the parent process communicating with Ispell.
   Print out the misspelled words, processing until seeing a blank
   line.  */

void
read_ispell (pipe_t * ispell_pipe, char *file, int line)
{
  str_t *str = str_make (0);

  while (1)
    {
      str = str_make (str);

      if (str_add_line_from_desc (str, ispell_pipe->pin) == ADD_LINE_EOF)
	exit (EXIT_SUCCESS);

      /* Ispell gives us a blank line when it's finished processing
         the line we just gave it.  */
      if (str->len == 1 && str->str[0] == '\n')
	return;

      /* There was no problem with this word.  */
      if (str->str[0] == '*' || str->str[0] == '+'
	  || str->str[0] == '-')
	continue;

      /* The word appears to have been misspelled.  */
      if (str->str[0] == '&' || str->str[0] == '#'
	  || (str->str[0] == '?' && verbose))
	{
	  int pos;

	  if (print_file_names)
	    {
	      printf ("%s:", file);
	      if (!number_lines)
		putchar (' ');
	    }
	  if (number_lines)
	    printf ("%d: ", line);

	  for (pos = 2; str->str[pos] != ' '; pos++)
	    putchar (str->str[pos]);
	  putchar ('\n');

	  continue;
	}

      if (str->str[0] == '?' && !verbose)
	continue;

      error (0, 0, "unrecognized Ispell line `%s'", str_to_nstr (str));
    }
}

/* Read from the stderr of the connected process as long as there
   remains data in the channel, and print each error.  Must be called
   from the parent process connected with Ispell by *THE_PIPE (created
   by `new_pipe').  */

void
read_ispell_errors (pipe_t * the_pipe)
{
  struct timeval time_out;
  str_t *str = str_make (0);

  time_out.tv_sec = time_out.tv_usec = 0;

  while (select (FD_SETSIZE, &(the_pipe->error_set), NULL, NULL,
		 &time_out) == 1)
    {
      str = str_make (str);

      if (str_add_line_from_desc (str, the_pipe->perr) == ADD_LINE_EOF)
	/* Ispell closed its stderr.  */
	error (EXIT_FAILURE, 0, "premature EOF from Ispell's stderr");

      /* Strip the crlf.  */
      str->len -= 2;
      str->str[str->len - 1] = 0;

      if (!memcmp (str->str, "Can't open ", strlen ("Can't open ")))
	error (EXIT_FAILURE, 0, "%s: cannot open",
	       str->str + strlen ("Can't open "));

      fprintf (stderr, "%s: %s\n", ispell_prog, str->str);
    }
}

/* Create *THE_PIPE, setting up the file descriptors and streams, and
   activating the SIGPIPE handler.  */

void
new_pipe (pipe_t * the_pipe)
{
  int ifd[2];
  int ofd[2];
  int efd[2];

  if (signal (SIGPIPE, sig_pipe) == SIG_ERR)
    error (EXIT_FAILURE, errno, "error creating SIGPIPE handler");
  if (signal (SIGCHLD, sig_chld) == SIG_ERR)
    error (EXIT_FAILURE, errno, "error creating SIGCHLD handler");

  if (pipe (ifd) < 0)
    error (EXIT_FAILURE, errno, "error creating pipe to Ispell");
  the_pipe->pin = ifd[0];
  the_pipe->cout = ifd[1];

  if (pipe (ofd) < 0)
    error (EXIT_FAILURE, errno, "error creating pipe to Ispell");
  the_pipe->cin = ofd[0];
  the_pipe->pout = ofd[1];

  if (pipe (efd) < 0)
    error (EXIT_FAILURE, errno, "error creating pipe to Ispell");
  the_pipe->perr = efd[0];
  the_pipe->cerr = efd[1];

  FD_ZERO (&(the_pipe->error_set));
  FD_SET (the_pipe->perr, &(the_pipe->error_set));
}

/* Handle the SIGPIPE signal.  */

static void
sig_pipe (int signo)
{
  error (EXIT_FAILURE, 0, "broken pipe");
}

/* Handle the SIGCHLD signal.  */

static void
sig_chld (int signo)
{
  error (EXIT_FAILURE, 0, "Ispell died");
}

/* Send lines to and retrieve lines from *THE_PIPE (created by
   `new_pipe').  Accept `argc' (the number of arguments) and `argv'
   (the array of arguments), so we can search for the files we are to
   read.  Handle all communication with Ispell at a managerial level;
   must be called by the parent process.  */

void
parent (pipe_t * the_pipe, int argc, char **argv)
{
  FILE *stream;
  char *file = NULL;
  int arg_error = 0;
  int arg_index = optind;

  /* Close the child's end of the pipes.  This is very important, as I
     found out the hard way.  */
  close (the_pipe->cin);
  close (the_pipe->cout);
  close (the_pipe->cerr);

  read_ispell_errors (the_pipe);

  /* This block parses Ispell's banner and grabs its version.  It then
     prints it if the flag `--ispell-version' or `-I' was used.
     FIXME: check that the version is high enough that it is going to
     be able to interact with GNU Spell sucessfully.  */

  {
    int pos = 0;
    str_t *ispell_version = str_make (0);
    str_t *str = str_make (0);

    if (str_add_line_from_desc (str, the_pipe->pin) == ADD_LINE_EOF)
      error (EXIT_FAILURE, 0, "premature EOF from Ispell's stdout");

    for (; !isdigit (str->str[pos]) && pos <= str->len; pos++);
    for (; str->str[pos] != ' ' && pos <= str->len; pos++)
      str_add_char (ispell_version, str->str[pos]);

    if (show_ispell_version)
      {
	printf ("%s: Ispell version %s\n", program_name,
		str_to_nstr (ispell_version));
	exit (EXIT_SUCCESS);
      }
  }

  file = xstrdup ("-");

  if (argc == 1)
    read_file (the_pipe, stdin, "-");

  while (arg_index < argc)
    {
      arg_error = 0;

      file = argv[arg_index];

      if (file[0] == '-' && file[1] == 0)
	{
	  if (!read_stdin)
	    {
	      read_stdin = 1;
	      stream = stdin;
	    }
	}
      else
	{
	  struct stat stat_buf;

	  if (stat (file, &stat_buf) == -1)
	    {
	      error (0, errno, "%s: stat error", file);
	      arg_index++;
	      continue;
	    }
	  if (S_ISDIR (stat_buf.st_mode))
	    {
	      error (0, 0, "%s: is a directory", file);
	      arg_index++;
	      continue;
	    }

	  stream = fopen (file, "r");
	  if (!stream)
	    {
	      error (0, errno, "%s: open error", file);
	      arg_error = 1;
	    }
	}

      if (!arg_error)
	read_file (the_pipe, stream, file);

      arg_index++;
    }
}

/* Execute the Ispell program after the fork.  Must be in the child
   process connected to the parent by *THE_PIPE (created by
   `new_pipe').  */

void
run_ispell_in_child (pipe_t * the_pipe)
{
  /* Close the parent side of the pipe.  */
  close (the_pipe->pin);
  close (the_pipe->pout);
  close (the_pipe->perr);

  if (the_pipe->cin != STDIN_FILENO)
    if (dup2 (the_pipe->cin, STDIN_FILENO) != STDIN_FILENO)
      error (EXIT_FAILURE, errno, "error duping to stdin");

  if (the_pipe->cout != STDOUT_FILENO)
    if (dup2 (the_pipe->cout, STDOUT_FILENO) != STDOUT_FILENO)
      error (EXIT_FAILURE, errno, "error duping to stdout");

  if (the_pipe->cerr != STDERR_FILENO)
    if (dup2 (the_pipe->cerr, STDERR_FILENO) != STDERR_FILENO)
      error (EXIT_FAILURE, errno, "error duping to stderr");

  if (dictionary != NULL)
    if (execl (ispell_prog, "ispell", "-a", "-p", dictionary, NULL)
	< 0)
      error (EXIT_FAILURE, errno, "error executing %s", ispell_prog);

  if (british)
    if (execl (ispell_prog, "ispell", "-a", "-d", "british", NULL)
	< 0)
      error (EXIT_FAILURE, errno, "error executing %s", ispell_prog);

  if (execl (ispell_prog, "ispell", "-a", NULL) < 0)
    error (EXIT_FAILURE, errno, "error executing %s", ispell_prog);
}

/* Return a NUL-terminated character string, the meaning of the error
   ERRNUM.  */

#ifndef HAVE_STRERROR
static char *
strerror (int errnum)
{
  extern char *sys_errlist[];
  extern int sys_nerr;

  if (errnum > 0 && errnum <= sys_nerr)
    return sys_errlist[errnum];
  return "Unknown system error";
}
#endif /* HAVE_STRERROR */

/* Print the program name and error message MESSAGE, which is a
   printf-style format string with optional args.  If ERRNUM is
   nonzero, print its corresponding system error message.  Exit with
   status STATUS if it is nonzero.  This function was written by David
   MacKenzie <djm@gnu.ai.mit.edu>.  */

static void
error (int status, int errnum, const char *message,...)
{
  va_list args;

  fflush (stdout);
  fprintf (stderr, "%s: ", program_name);

  va_start (args, message);
  vfprintf (stderr, message, args);
  va_end (args);

  if (errnum)
    fprintf (stderr, ": %s", strerror (errnum));
  putc ('\n', stderr);
  fflush (stderr);
  if (status)
    exit (status);
}

/* Allocate SIZE bytes of memory dynamically, with error checking,
   returning a pointer to that memory.  */

static void *
xmalloc (size_t size)
{
  void *ptr = malloc (size);

  if (!ptr)
    error (EXIT_FAILURE, 0, "virtual memory exhausted");
  return ptr;
}

/* Change the size of an allocated block of memory *PTR to SIZE bytes,
   with error checking, returning the new pointer.  If PTR is NULL,
   run `xmalloc'.  */

static void *
xrealloc (void *ptr, size_t size)
{
  if (!ptr)
    return xmalloc (size);
  ptr = realloc (ptr, size);
  if (!ptr)
    error (EXIT_FAILURE, 0, "virtual memory exhausted");
  return ptr;
}

/* Duplicate STR, returning an identical malloc'd string.  I first
   just did this for error checking, calling `strdup', but the task is
   so simple I decided to just do it here--it saves a call.  */

static char *
xstrdup (const char *str)
{
  size_t len = strlen (str) + 1;
  void *new = xmalloc (len);

  memcpy (new, (void *) str, len);

  return (char *) new;
}
