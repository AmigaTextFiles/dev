#ifndef PICT_IO_H
#define PICT_IO_H

#include "pictP.h"

short	pict_get_short(FILE *fp);
int		pict_get_int(FILE *fp);
fixed   pict_get_fixed(FILE *fp);
rect    pict_get_rect(FILE *fp);

void    pict_put_short(short,FILE *fp);
void    pict_put_int(int,FILE *fp);
void    pict_put_fixed(fixed,FILE *fp);
void    pict_put_rect(rect,FILE *fp);

void    pict_log_short(char*,short);
void    pict_log_xshort(char*,short);
void    pict_log_int(char*,int);
void    pict_log_xint(char*,int);
void    pict_log_fixed(char*,fixed);
void    pict_log_rect(char*,rect);

#endif /* PICT_IO_H */
