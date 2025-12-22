
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <proto/dos.h>
#include <proto/exec.h>


#include "xref_gen.h"
#include "Main.h"

/***********************************************/

char *TypeNameArray[TYPEMAX] =
{
  "INCF",
  "ADFL",
  "ADOC",
  "ADFN",
  "DEFI",
  "TDEF",
  "TDST",
  "STRU"
};

char Buffer[MAX_LEN];

/***********************************************/

BOOL Break(void)
{
  if (SetSignal(0, SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C)
    return (TRUE);
  return (FALSE);
}

/***********************************************/

char *stpcpy(char *to,const char *from)
{
  while (*from)
    *to++ = *from++;
  *to = '\0';
  return (to);
}

