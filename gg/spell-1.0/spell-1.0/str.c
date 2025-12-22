/* str.c -- operations on strings.

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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

   Although this file is small enough to fit easily inside others, it
   seems to be useful for any program so I find it convenient for it
   to be seperate.  It was written because I became fed up with:

   * All string-handling code needing to worry about memory
   allocation.

   * Not being able to deal with NUL characters.

   * Sending three variables from function to function just for one
   string.  (They are now contained in a `str_t' type.)  */

/* Local headers.  */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "str.h"

/* System headers.  */

#include <sys/types.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef HAVE_STRING_H
#include <string.h>
#else /* not HAVE_STRING_H */
#include <strings.h>
#endif /* not HAVE_STRING_H */

#ifndef EXIT_FAILURE
#define EXIT_FAILURE 1
#endif

#ifndef HAVE_STRERROR
static char *strerror (int);
#endif

static void *xmalloc (size_t);
static void *xrealloc (void *, size_t);
static void error (int, int, const char *,...);
static int safe_read (int, char *, int);

/* The name of the executable this process comes from.  This should be
   set by the caller.  */
extern char *program_name;

/* Whether we're reading from the terminal.  This should be set by the
   caller.  */
extern int interactive;

/* Initialize (or reinitialize) the string *STR for use.  STR may be
   NULL; it will be changed.  Return the (sometimes new) pointer.  */

str_t *
str_make (str_t * str)
{
  if (!str)
    {
      str = xmalloc (sizeof *str);
      str->str = xmalloc (str->mem = CHUNK);
    }
  else
    str->str = xrealloc (str->str, str->mem = CHUNK);
  str->len = 0;

  return str;
}

/* Append the character C to the string *STR (create `*str' with
   `str_make').  */

void
str_add_char (str_t * str, char c)
{
  if (!str || !str->str)
    str = str_make (str);

  if (++(str->len) > str->mem)
    str->str = xrealloc (str->str, str->mem += CHUNK);

  str->str[str->len - 1] = c;
}

/* Append the string *STR2 to the string *STR1.  Both should be
   created with `str_make'.  */

void
str_add_str (str_t * str1, str_t * str2)
{
  int pos = 0;

  if (!str2 || !str2->str)
    return;
  if (!str1 || !str1->str)
    str1 = str_make (str1);

  for (; pos < str2->len; pos++)
    str_add_char (str1, str2->str[pos]);
}

/* Copy a newline-terminated line from STREAM to the string *STR
   (create `*str' with `str_make').  Return `ADD_LINE_OK' if
   successful, `ADD_LINE_EOF' if an EOF was gotten, or `ADD_LINE_ERR'
   in event of an error.  */

int
str_add_line (str_t * str, FILE * stream)
{
  if (!str || !str->str)
    str = str_make (str);
  if (!stream)
    return ADD_LINE_ERR;

  while (1)
    {
      register char c = getc (stream);

      if (c == EOF || ferror (stream))
	return ADD_LINE_EOF;
      str_add_char (str, c);
      if (c == '\n')
	break;
    }

  return ADD_LINE_OK;
}

/* Copy a newline-terminated line from FILE_DESC to the string *STR
   (create `*str' with `str_make').  Return `ADD_LINE_OK' if
   successful, `ADD_LINE_EOF' if an EOF was gotten, or `ADD_LINE_ERR'
   in event of an error.  FIXME: should not read only one character at
   a time.  */

int
str_add_line_from_desc (str_t * str, int file_desc)
{
  int nchars = 0;
  char c = 0;

  if (!str || !str->str)
    str = str_make (str);

  while (1)
    {
      nchars = safe_read (file_desc, &c, 1);

      if (!nchars)
	return ADD_LINE_EOF;
      if (nchars < 0)
	return ADD_LINE_ERR;

      str_add_char (str, c);
      if (c == '\n')
	break;
    }

  return ADD_LINE_OK;
}

/* Convert the NUL-terminated character array *NSTR to a string
   structure and return it.  */

str_t *
nstr_to_str (char *nstr)
{
  str_t *str = 0;
  int pos = 0;

  str = str_make (str);

  if (!nstr)
    return str;
  for (; nstr[pos]; pos++)
    str_add_char (str, nstr[pos]);

  return str;
}

/* Convert the string *STR (create `*str' with `str_make') to a
   NUL-terminated character array and return it.  */

char *
str_to_nstr (str_t * str)
{
  char *nstr = xmalloc (str->len + 1);
  int pos = 0;

  if (!str || !str->str)
    return nstr;

  for (; pos < str->len; pos++)
    {
      if (!str->str[pos])
	/* NUL-terminated strings dislike having NULs in their
	   content.  I suppose the best thing is to give them a space
	   instead.  */
	str->str[pos] = ' ';

      nstr[pos] = str->str[pos];
    }

  nstr[pos + 1] = 0;
  return nstr;
}

/* Convert the whole number NUM to a string structure and return it.
   I'd just as soon use `sprintf', but it requires the space to be
   allocated *before* it's called.  How should I know how many
   characters it's going to write?  This is my solution, which calls
   `sprintf' only one character at a time (and thus does some work
   that `sprintf' already knows perfectly well how to do).  */

str_t *
int_to_str (int num)
{
  char c[2];			/* Array for the `sprintf' output.  */
  int pos = 0;			/* Position in `*rstr'.  */
  int rem = 0;			/* Remainder.  */
  str_t *rstr = str_make (0);	/* String reversed.  */
  str_t *str = str_make (0);	/* Final string.  */

  /* Get the digits one at a time in reverse order, putting them in
     `*rstr'.  */
  while (num > 0)
    {
      rem = num % 10;
      num /= 10;
      sprintf (c, "%d", rem);
      str_add_char (rstr, *c);
    }

  /* Reverse `*rstr', putting it in `*str'.  */
  for (pos = rstr->len - 1; pos >= 0; pos--)
    str_add_char (str, rstr->str[pos]);

  return str;
}

/* Return a NUL-terminated character array: the meaning of the error
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
   status STATUS if it is nonzero.  This function originally written
   by David MacKenzie <djm@gnu.ai.mit.edu>.  */

static void
error (int status, int errnum, const char *message,...)
{
  va_list args;

  if (!interactive)
    {
      fflush (stdout);
      fprintf (stderr, "%s: ", program_name);
    }

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

/* Change the size of an allocated block of memory PTR to SIZE bytes,
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

/* Read LEN bytes at PTR from descriptor DESC, retrying if interrupted.
   Return the actual number of bytes read, zero for EOF, or negative
   for an error.  Written by the Free Software Foundation.  */

static int
safe_read (int desc, char *ptr, int len)
{
  int n_chars;

  if (len <= 0)
    return len;

#ifdef EINTR
  do
    {
      n_chars = read (desc, ptr, len);
    }
  while (n_chars < 0 && errno == EINTR);
#else
  n_chars = read (desc, ptr, len);
#endif

  return n_chars;
}
