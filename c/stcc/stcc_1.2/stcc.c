/*
   StormC frontend with
   GCC-style options

   bf 11-15-96
*/

/// Includes
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include "stcc.h"
///

/// Global Variables
const char *version = "\0$VER: stcc 1.2 (12-8-96)\n";
List LibList;
///

#if defined (__STORM__)
/// stpcpy()
char *
stpcpy (char *at, char *s)
{
  while (*s)
   *at++ = *s++;
  *at = '\0';
  return at;
}
///
#endif

/// cleanup()
void
cleanup (void)
{
  Node *node, *next;

  for (next = node = LibList.lh_Head; next = node -> ln_Succ; node = next)
  {
    if (node -> ln_Name)
      free (node -> ln_Name);
    free (node);
  }
}
///

/// add_library_dir()
void
add_library_dir (char *path)
{
  Node *ln;

  if (!(ln = (Node *) malloc (sizeof (Node))))
    goto cleanup;

  ln -> ln_Name = NULL;
  AddHead (&LibList, ln);

  if (!(ln -> ln_Name = malloc (strlen (path) + 1)))
    goto cleanup;
  
  strcpy (ln -> ln_Name, path);
  return;  

  cleanup:

  printf ("Out of memory.\n");
  exit (20);
}
///

/// locate_library()
char *
locate_library (char *lib)
{
  static char dir[MAXPATHLEN];
  Node *node, *next;
  BPTR lock;

  for (next = node = LibList.lh_Head; next = node -> ln_Succ; node = next)
  {
    strcpy (dir, node -> ln_Name);
    AddPart (dir, lib, MAXPATHLEN);
    strcat (dir, ".lib");
    if (lock = Lock (dir, ACCESS_READ))
    {
      UnLock (lock);
      return dir;
    }
  }
  return NULL;
}
///

/// translate_path()
char *
translate_path (char *path)
{
  static char s[MAXPATHLEN];
  char *f, *t, *p, *e;
  int len, dbl_slash = 0;

  p = path-1;
  t = s;
  e = path + strlen (path);

  while (p < e)
  {
   if (p = strchr (f=p+1, '/'))
     *p = '\0';
   else
     p = e;

   if (!(len = (int) p - (int) f))
     continue;

   if (len <= 3 && *f == '.')
   {
      if (len == 1)
        continue;
      if (*(f+1) == '.')
      {
        if (t != s && *(t-1) != '/')
        {
          dbl_slash = 1;
          *t = '/';
          t++;
        }
        *t = '/';
        t++;
        continue;
      }
    }
    if (t != s && *(t-1) != '/')
    {
      *t = '/';
      t++;
    }
    t = stpcpy (t, f);
    dbl_slash = 0;
  }
  if (dbl_slash)
    *(t-1) = '\0';
  if (t == s)
    strcpy (s, "\"\"");
  return s;
}
///

/// option_argument()
char *
option_argument (int argc, char *argv[], int *i)
{
  int t = *i;
  char *arg;

  if (argv[t][2] != '\0')
    arg = &argv[t][2];
  else
  {
    if (!argv[++(*i)])
    {
      printf ("%s: Option requires argument: '-%c'.\n", argv[0], argv[t][1]);
      exit (20);
    }
    arg = argv[*i];
  }
  return arg;
}
///

/// translate_long_option()
#define TTABSIZE 2

char *
translate_long_option (int argc, char *argv[], int *i)
{
  const struct {
    const char *from;
    const char *to;
  } TransTab[TTABSIZE] =
  {
    { "Werror",			"-ew" },
    { "Wall",			"-w+" }
  };
  char *opt = &argv[*i][1];
  int t;

  for (t=0; t<TTABSIZE; t++)
  {
    if (strcmp (opt, TransTab[t].from) == 0)
      return (char *) TransTab[t].to;
  }
  return NULL;
}
///

/// object_file_of()
char *
object_file_of (char *file)
{
  int len = strlen (file);

  if (len < 2)
    return NULL;
  if (file[len-2] == '.')
  {
    if (file[len-1] == 'o')
      return file;
    if (file[len-1] == 'c')
    {
      file[len-1] = 'o';
      return file;
    }
  }
  return NULL;
}
///

/// is_c_source()
int
is_c_source (char *file)
{
  int len = strlen (file);

  if (len < 2)
    return 0;
  if (file[len-2] == '.' && file[len-1] == 'c')
    return 1;
  return 0;
}
///

/// is_object_module()
int
is_object_module (char *file)
{
  int len = strlen (file);

  if (len < 2)
    return 0;
  if (file[len-2] == '.' && file[len-1] == 'o')
    return 1;
  return 0;
}
///

/// main()
int
main (int argc, char *argv[])
{
  char *p, s[LBUFSIZE], *pl, sl[LBUFSIZE], *t, *l;
  int dont_link = 0, i, source_count = 0, verbose = 0;

  NewList (&LibList);
  atexit (cleanup);
                     /* GCC has 18 versions of [__](amiga[os]|mc68000)[__] */
  p = stpcpy (s, "StormC:StormSYS/StormC -pc -e10 -d __mc68000__=1 -d __amigaos__=1 -d __AMIGA__=1 ");
  pl = stpcpy (sl, "StormC:StormSYS/StormLINK OOP StormC:StormSYS/startup.o ");

  for (i=1; i<argc; i++)
  {
    if (argv[i][0] == '-')
    {
      switch (argv[i][1])
      {
        case '?':
          printf ("StormC frontend with gcc-style options.\n"
                  "Usage: %s [-vgDOocILl][(-Werror|-Wall)] <files>\n", argv[0]);
          exit (0);

        case 'v':
          verbose = 1;        
          continue;

        case 'g':
          p = stpcpy (p, "-bf -bs");
          pl = stpcpy (pl, "DEBUG ");
          break;

        case 'D':
          p = stpcpy (p, "-d ");
          p = stpcpy (p, option_argument (argc, argv, &i));
          break;

        case 'O':
          p = stpcpy (p, "-O");
          break;

        case 'o':
          if (is_object_module (t = translate_path (option_argument (argc, argv, &i))))
            dont_link = 1;
          else
          {
            pl = stpcpy (pl, "TO ");
            pl = stpcpy (pl, t);
            pl = stpcpy (pl, " ");
          }
          continue;

        case 'c':
          dont_link = 1;
          continue;

        case 'I':
          p = stpcpy (p, "-i ");
          p = stpcpy (p, translate_path (option_argument (argc, argv, &i)));
          break;

        case 'L':
          add_library_dir (translate_path (option_argument (argc, argv, &i)));
          continue;

        case 'l':
          l = translate_path (option_argument (argc, argv, &i));
          if (!(t = locate_library (l)))
          {
            printf ("%s: Library not found: %s.lib.\n", argv[0], l);
            exit (20);
          }
          pl = stpcpy (pl, t);
          pl = stpcpy (pl, " ");
          continue;

        default:
          if (t = translate_long_option (argc, argv, &i))
          {
            p = stpcpy (p, t);
            break;
          }
          printf ("Option ignored: %s.\n", argv[i]);
          continue;
      }
    }
    else if (argv[i][0] == '+')
    {
      argv[i][0] = '-'; /* real StormC options can be specified with "+<option>" */
      p = stpcpy (p, argv[i]);
    }
    else
    {
      if (is_c_source (argv[i]))
      {
        p  = stpcpy (p, argv[i]);
        source_count ++;
      }
      if (t = object_file_of (argv[i]))
      {
        pl = stpcpy (pl, t);
        pl = stpcpy (pl, " ");
      }
      else
      {
        printf ("%s: Unknown paramater: %s.\n", argv[0], argv[i]);
        exit (20);
      }  
    }
    p = stpcpy (p, " ");
  }
  if (*(--p) == ' ')
  {
    *p = '\0';
  }
  if (verbose)
  {
    pl = stpcpy (pl, "VERBOSE ");
  }
  pl = stpcpy (pl, "StormC:lib/storm.lib StormC:lib/amiga.lib");

  if (source_count > 0)
  {
    if (verbose)
      printf ("%s.\n", s);
    if (i = system (s))
    {
      printf ("%s: StormC compiler returned %d.\n", argv[0], i);
      exit (i);
    }
  }
  if (!dont_link)
  {
    if (verbose)
      printf ("%s.\n", sl);
    if (i = system (sl))
      printf ("%s: StormC linker returned %d.\n", argv[0], i);
  }
  exit (i);
}
///
