
/*
 *  NAMEMUNGE.C
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"

Prototype void mungecase_fiename(char *, char *);

/*
 *  Convert case-sensitive file name into case-insensitive file name.  Only
 *  handles local files (i.e. no associated path) and then only files that
 *  begin with <somechar><period>, where <somechar> is never modified.
 */

void
mungecase_filename(s, d)
char *s, *d;
{
    char *ptr;
    short c;
    static char tmp[128];

    if (strchr(s, ':') || strchr(s, '/') || s[0] == 0 || s[1] != '.') {
        strcpy(d, s);
        return;
    }
    ptr = GetConfig(MUNGECASE, "Y");
    if (ptr[0] == 'n' || ptr[0] == 'N') {
        strcpy(d, s);
        return;
    }

    ptr = tmp;
    *ptr++ = *s++;  /*  <char>  */
    *ptr++ = *s++;  /*  <dot>   */

    while (c = *s) {
        if (c >= 'A' && c <= 'Z') {
            c = c - 'A' + 'a';
            *ptr++ = c;
            *ptr++ = c;
        } else {
            *ptr++ = c;
        }
        ++s;
    }
    *ptr = 0;
    strcpy(d, tmp);
}

