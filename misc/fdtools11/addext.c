/* addext.c - add filename extension function */

#include <exec/types.h>

void addext(STRPTR buff,LONG len,STRPTR orig,STRPTR xt)

{
  STRPTR s;
  BOOL hasext = FALSE;

  for(s = buff;*orig && s-buff < len;*(s++) = *(orig++));
  *s = '\0';

  orig = s;

  for(--s;s != buff && *s != '/' && *s != ':';s--) {
    if(*s == '.') {
      hasext = TRUE;
      break;
    }
  }

  if(!hasext) {
    for(s = orig;*xt && s-buff <len;*(s++) = *(xt++));
    *s = '\0';
  }
}
