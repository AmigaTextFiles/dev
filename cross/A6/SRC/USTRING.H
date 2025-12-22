/* ------------------------------------------------------------------
    USTRING.H -- useful string stuff for A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#ifndef _USTRING_H
#define _USTRING_H

char *newstring(char *);

char *rtrim(char *);

char *stripquote(char *);

char *tohex(unsigned int);

char *trim(char *);

#endif
