/*LINTLIBRARY*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#ifndef _DCC
#include <dos.h>
#else
#include <dos/dos.h>
#endif

#ifdef _DCC
#define FESIZE FILENAME_MAX
#endif

char buf[FESIZE];

#ifdef _DCC
char *
stcgfn(char * dest, const char * src)
{
  long len;
  char *tmp;
  len = strlen(src);
  tmp = src+len-1;
  while (*tmp != '/' && *tmp != ':' && tmp != (char *)src)
    tmp--;
  if (*tmp == '/' || *tmp == ':')
    tmp++;
  strcpy(dest, tmp);
  dest[len-(tmp-src)] = '\0';
  return dest;
}

char *
stcgfp(char * dest, const char * src)
{
  long len;
  char *tmp;
  len = strlen(src);
  tmp = src+len-1;
  while (*tmp != '/' && *tmp != ':' && tmp != (char *)src)
    tmp--;
  if (*tmp == '/' || *tmp == ':')
    tmp++;
  strncpy(dest, src, tmp-src);
  dest[tmp-src] = '\0';
  return dest;
}
#endif

char *
tempnam(char *dir, char *prefix)
{
  char *tmp, *p;
  int len;

  tmp = tmpnam(NULL);           /* Get a ANSI temporary file name */

  if (dir == NULL) {
    /* no directory defined */
    if (prefix == NULL) {
      /* no prefix either : use ANSI name */
      p = malloc(strlen(tmp)+1);
      strcpy(p, tmp);
    }
    else {
      /* Add prefix to ANSI name */
      len = strlen(tmp) + strlen(prefix);
      p = malloc(len+1);
      stcgfp(buf, tmp);         /* Get path portion */
      strcpy(p, buf);
      strcat(p, prefix);
      stcgfn(buf, tmp);         /* Get filename portion */
      strcat(p, buf);
    }
  }
  else {
    /* directory is defined */
    if (prefix == NULL) {
      /* no prefix */
      stcgfn(buf, tmp);         /* Get filename portion */
      len = strlen(dir)+1+strlen(buf);
      p = malloc(len+1);
      strcpy(p, dir);
      strcat(p, "/");
      strcat(p, buf);
    }
    else {
      /* both dir and prefix */
      stcgfn(buf, tmp);         /* Get filename portion */
      len = strlen(dir)+1+strlen(prefix)+strlen(buf);
      p = malloc(len+1);
      strcpy(p, dir);
      strcat(p, "/");
      strcat(p, prefix);
      strcat(p, buf);
    }
  }

  return p;
}
