/*
**      prototypes for gateway.library
**
**      (C) Copyright 1998,1999 Michaela Prüß
**      All Rights Reserved.
*/

#ifndef CLIB_GATEWAY_PROTOS_H
#define CLIB_GATEWAY_PROTOS_H

#ifndef GATEWAY_GATEWAY_H
#include "gateway.h"
#endif /* GATEWAY_GATEWAY_H */

#include <exec/types.h>

/* -- start functions -- */

ULONG GateRequest(UBYTE *title_d1,UBYTE *body,UBYTE *gadgets);
char *ltofa(char *tx_d1,ULONG l);
void trim(UBYTE *trptr);
void rtrim(UBYTE *trptr);
void lset(UBYTE *lbuff, int slen);
void lsetmin(UBYTE *lbuff, int slen);
void string(UBYTE *spstr, int num, int ch);
int instr(UBYTE *sa, UBYTE *sb);
void upstr(UBYTE *trptr);
void lowstr(UBYTE *trptr);
void set(UBYTE *lbuff, int slen);
void midstr(UBYTE *mstr, int pos, long laenge);
ULONG date_to_day(ULONG date);
ULONG date_to_zahl(UBYTE *da);
ULONG time_to_zahl(UBYTE *ti);
void kill_ansi(UBYTE *buffer);
BOOL newer(UBYTE *d1, UBYTE *t1, UBYTE *d2, UBYTE *t2);
void swapmem(char *src, char *dst, int n);
int memncmp(char *a, char *b, int length);
int StrCaseCmp(char *s1, char *s2);
void trim_include(UBYTE *trptr);
void mail_trim(UBYTE *trptr, int fkt);
char *strdup(const char *s);
void addval(UBYTE *str,  ULONG n);
void newstr(UBYTE *istr, UBYTE *nstr, int pos, int len);
int wordwrp(UBYTE *line, UBYTE *rest, int len);
char *fn_spiltt(char *src,char *drive,char *path,char *file,char *ext);
char *fn_build(char *dst,char *drive,char *path,char *file,char *ext);
char *index(char *dst, int c);

/* -- end functions -- */

#endif /* CLIB_GATEWAY_PROTOS_H */
