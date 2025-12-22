#ifndef PERROR_H
#define PERROR_H
#include <stdio.h>

void fatal_error(char *, ...);
void error_printf(char *, ...);
void info_printf(char *, ...);

FILE *infostream;

#endif
