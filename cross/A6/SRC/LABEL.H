/* ------------------------------------------------------------------
    LABEL.H -- header file for the label processing module
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#ifndef _LABEL_H
#define _LABEL_H

#define LBL_NONE (0)
#define LBL_SYNCPC (1)
#define LBL_VARIABLE (2)

struct label {
	struct label* next;
	char *name;
	char *filename;
	unsigned int value;
	unsigned int line;
	unsigned int locale;
};

void lbl_init(void);
int lbl_define(char *,unsigned int,unsigned int);
long lbl_getval(char *);
/*@null@*/struct label *lbl_getptr(char *,unsigned int);
int lbl_enterlocal(void);
long lbl_exitlocal(void);
unsigned int lbl_getlocale(void);
void lbl_dumpsym(void);
void lbl_destroy(void);
void lbl_reset(void);

#endif
