/* ------------------------------------------------------------------
    ASMFILE.H -- header file for the asmfile handler for A6
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#ifndef _ASMFILE_H
#define _ASMFILE_H

void af_open(char *,/*@null@*/FILE *);
int af_close(void);
int af_number(void);
char *af_name(void);
unsigned int af_line(void);
char *af_getline(void);
int af_linehaschanged(void);
void af_printforerror(void);
void af_cleanup(void);

#endif
