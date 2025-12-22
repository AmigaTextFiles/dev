#include <proto/dos.h>
#include <proto/exec.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "macro.h"

static void
path_strncat(char *ospath, const char *str, const int len)
{
  char *p = ospath + strlen(ospath);

  if (p > ospath && p[-1] != ':' && p[-1] != '/') *p++ = '/';
  strncpy(p, str, len);
}

static int
is_component(const char *str, const char *ixpath)
{
  const int l = strlen(str);

  if (strncmp(ixpath, str, l)) return 0;
  return ixpath[l] == '/' || ixpath[l] == '\0';
}

static char *
next_component(char *ixpath)
{
  char *p = strchr(ixpath, '/');

  return p ? (p + 1) : (ixpath + strlen(ixpath));
}

static void
cat_component(char *ospath, const char *ixpath)
{
  const char *p = strchr(ixpath, '/');

  path_strncat(ospath, ixpath, p ? (p - ixpath) : strlen(ixpath));
}

static int
is_ospath(const char *path) { return strchr(path, ':') ? 1 : 0; }

static const int bufsize = 1024;

static char *
make_ospath(char *ixpath)
{
  /*
   *  using AllocVec() to have IoErr set upon failure
   */

  char *ospath = AllocVec(bufsize, MEMF_ANY|MEMF_CLEAR);

  if (!ospath) return NULL;
  if (is_ospath(ixpath)) strcpy(ospath, ixpath);
  else
  {
    if (ixpath[0] == '/')
    {
      cat_component(ospath, ixpath + 1);
      strcat(ospath, ":");
      ixpath = next_component(ixpath + 1);
    }
    else NameFromLock(((struct Process *)
           FindTask(NULL))->pr_CurrentDir, ospath, bufsize);

    while (ixpath[0])
    {
      if (is_component("..", ixpath)) path_strncat(ospath, "/", 1);
      else if (!is_component(".", ixpath)) cat_component(ospath, ixpath);
      ixpath = next_component(ixpath);
    }
  }
  return ospath;
}

/*
 *  Since converting an os-path to an ix-path can fail, only functions
 *  indicating success/failure are patchable.
 *
 *  Functions taken from packet actions with exception of:
 *
 *    - LoadSeg()
 *    - MakeLink()
 *    - MatchFirst()
 *    - MatchPattern()
 *    - ReadLink()
 */

DEF_PATCH1(osCreateDir,     ixCreateDir,      0, d1)
DEF_PATCH1(osDeleteFile,    ixDeleteFile,     0, d1)
DEF_PATCH1(osLoadSeg,       ixLoadSeg,        0, d1)
DEF_PATCH1(osLock,          ixLock,           0, d1)
DEF_PATCH1(osMatchFirst,    ixMatchFirst,    -1, d1)
DEF_PATCH2(osMatchPattern,  ixMatchPattern,   0, d1, d2)
DEF_PATCH1(osOpen,          ixOpen,           0, d1)
DEF_PATCH2(osRename,        ixRename,         0, d1, d2)
DEF_PATCH1(osSetComment,    ixSetComment,     0, d1)
DEF_PATCH1(osSetProtection, ixSetProtection,  0, d1)

static struct patchdata
{
  int     offset;
  void  (*ixfun)(void);
  void (**osfun)(void);
  char   *name;
} patchtab[] =
{
  { -0x078, ixCreateDir,     &osCreateDir,     "CreateDir"     },
  { -0x048, ixDeleteFile,    &osDeleteFile,    "DeleteFile"    },
  { -0x096, ixLoadSeg,       &osLoadSeg,       "LoadSeg"       },
  { -0x054, ixLock,          &osLock,          "Lock"          },
  { -0x336, ixMatchFirst,    &osMatchFirst,    "MatchFirst"    },
  { -0x34e, ixMatchPattern,  &osMatchPattern,  "MatchPattern"  },
  { -0x01e, ixOpen,          &osOpen,          "Open"          },
  { -0x04e, ixRename,        &osRename,        "Rename"        },
  { -0x0b4, ixSetComment,    &osSetComment,    "SetComment"    },
  { -0x0ba, ixSetProtection, &osSetProtection, "SetProtection" },
  {      0, NULL,            NULL,             NULL            }
};

static void
exit_handler(void)
{
  struct patchdata *pd;

  for (pd = patchtab; pd->offset; pd++)
  {
    if (*(pd->osfun))
      SetFunction((struct Library *) DOSBase, pd->offset,
        (void *) *(pd->osfun));
  }
}

int
main(int argc, char **argv)
{
  const int req_exec_version = 36,
            req_dos_version  = 36;
  struct patchdata *pd;

  if (argc != 1)
  {
    const char *verstag = "\0$VER:ixpath 1.36 (" __DATE__ ")";

    printf("%s\n"
           "copyright (c) 1995 by Eric Schmeddes (Erix)\n"
           "send bug reports to erix@telebyte.nl\n\n"
           "patched functions (all dos.library):\n" , verstag + 6);
    for (pd = patchtab; pd->offset; pd++)
    {
      printf("  %s()\n", pd->name);
    }
    exit(EXIT_SUCCESS);
  }

  if (((struct Library *) SysBase)->lib_Version >= req_exec_version)
  {
    if (((struct Library *) DOSBase)->lib_Version >= req_dos_version)
    {
      if (!atexit(exit_handler))
      {
        for (pd = patchtab; pd->offset; pd++)
        {
          *(pd->osfun) = SetFunction((struct Library *) DOSBase,
                           pd->offset, (void *) pd->ixfun);
        }
        puts("patch installed");
        Wait(SIGBREAKF_CTRL_C);
        exit(EXIT_SUCCESS);
      }
      else perror(argv[0]);
    }
    else fprintf(stderr, "%s: dos.library v%d+ required\n", argv[0],
                   req_dos_version);
  }
  else fprintf(stderr, "%s: exec.library v%d+ required\n", argv[0],
                 req_exec_version);

  exit(EXIT_FAILURE);
}

