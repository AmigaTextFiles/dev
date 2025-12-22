/* ------------------------------------------------------------------
    OUTF.H -- header file for output section of A6
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#ifndef _OUTF_H
#define _OUTF_H

#define OUTF_BIN (0)
#define OUTF_PRG (1)
#define OUTF_P00 (2)
#define OUTF_MHX (3)
#define OUTF_IHX (4)

void outf_open(char *);
void outf_close(void);
void outf_wbyte(unsigned int);
void outf_wword(unsigned int);

unsigned int outf_getpc(void);
void outf_setpc(unsigned int);

#endif
