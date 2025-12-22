/* tailor.c -- target dependent functions
 * Copyright (C) 1993 Carsten Steger (carsten.steger@informatik.tu-muenchen.de)
 * This is free software; you can redistribute it and/or modify it under the
 * terms of the GNU General Public License, see the file COPYING.
 */

/*
 * This file contains Amiga specific functions for gzip.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <exec/types.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/dosasl.h>
#include <clib/dos_protos.h>
#include <pragmas/dos_pragmas.h>

#define MAXPATH 1024
#define MAXARGS 512

extern struct DosLibrary *DOSBase;

extern void *xmalloc(unsigned int size);

static char *expand_next_file (char *pattern);
static int in_prev_args (char *arg, char **argv, int argc);
extern void _expand_args (int *oargc, char ***oargv);


static char *expand_next_file (pattern)
     char *pattern;
{
  long err;
  char *pathname;
  static struct AnchorPath *an = NULL;

  pathname = NULL;
  if (pattern == NULL)
    err = -1;
  else
    do
      {
        if (an == NULL)
          {
            an = xmalloc (sizeof (struct AnchorPath) + MAXPATH);
            memset (an, 0, sizeof (struct AnchorPath) + MAXPATH);
            an->ap_BreakBits = SIGBREAKF_CTRL_C;
            an->ap_Strlen = MAXPATH;
            an->ap_Flags = APF_DOWILD;
            err = MatchFirst (pattern, an);
          }
        else
          err = MatchNext (an);

        pathname = an->ap_Buf;
      } while (err == 0 && pathname == NULL);

  if (err)
    {
      MatchEnd (an);
      free (an);
      an = NULL;
      return NULL;
    }
  else
    return pathname;
}


static int in_prev_args (arg, argv, argc)
     char *arg, **argv;
     int argc;
{
  int i, is_in_args;

  is_in_args = 0;
  for (i = 1; i < argc - 1; i++)
    if (stricmp (arg, argv[i]) == 0)
      is_in_args = 1;
  return is_in_args;
}


void _expand_args (oargc, oargv)
     int *oargc;
     char ***oargv;
{
  int i;
  char *str, **argv;
  static char buf[MAXPATH];
  int argc, no_match_at_all, num_matches, contains_wildcards;

  /* With Kickstart 1.3 wildcards can't be expanded. */
  if (DOSBase->dl_lib.lib_Version < 37) return;

  no_match_at_all = 1;
  contains_wildcards = 0;
  argc = 0;
  argv = xmalloc (MAXARGS * sizeof (char *));

  argv[argc++] = (*oargv)[0];
  for (i = 1; i < *oargc; i++)
    {
      if (ParsePattern ((*oargv)[i], buf, MAXPATH))
        {
          contains_wildcards = 1;
          num_matches = 0;
          while (str = expand_next_file ((*oargv)[i]))
            if (argc >= MAXARGS)
              {
                expand_next_file (NULL);
                fprintf (stderr,"Too many files.\n");
                exit (20);
              }
            else
              {
                /* Avoid duplicate entries */
                if (!in_prev_args (str, argv, argc))
                  {
                    argv[argc++] = strdup (str);
                    num_matches++;
                  }
              }
          if (num_matches != 0)
            no_match_at_all = 0;
        }
      else
        if (argc >= MAXARGS)
          {
            fprintf (stderr,"Too many files.\n");
            exit (20);
          }
        else
          {
            if (!in_prev_args ((*oargv)[i], argv, argc))
              argv[argc++] = (*oargv)[i];
          }
    }
  *oargc = argc;
  *oargv = argv;
  if (no_match_at_all && contains_wildcards) {
    fprintf (stderr,"No match.\n");
    exit (20);
  }
}
