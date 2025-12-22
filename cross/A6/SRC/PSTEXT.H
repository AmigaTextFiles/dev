/* ------------------------------------------------------------------
    PSTEXT.H -- header file for text converter for A6 cross-assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#ifndef _PSTEXT_H
#define _PSTEXT_H

#define CSET_ASCII (0)
#define CSET_PETSCII (1)
#define CSET_SCRU (2)
#define CSET_SCRL (3)

unsigned char pstext_convchar(unsigned char);
char *parsetext(char *,int);
int pstext_getcset(void);
void pstext_setcset(int);

#endif
