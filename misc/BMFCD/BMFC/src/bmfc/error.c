/**************************************/
/* error.c                            */
/* for BMFC 0.00                      */
/* Copyright 1992 by Adam M. Costello */
/**************************************/


#include "error.h"  /* Makes sure we're consistent with the prototypes. */
#include "parse.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>


const char *const outofmem = "Out of memory.\n";


void warnf(const char *format, ...)
{
  va_list ap;

  va_start(ap,format);
  vfprintf(stderr,format,ap);
  va_end(ap);
  fflush(stderr);
}


void failf(const char *format, ...)
{
  va_list ap;

  va_start(ap,format);
  fputs("Error: ", stderr);
  vfprintf(stderr,format,ap);
  va_end(ap);
  exit(EXIT_FAILURE);
}


void parsefailf(const char *format, ...)
{
  va_list ap;

  va_start(ap,format);
  fprintf(stderr, "Error in line %4lu pos %3lu: ", linenum(), position());
  vfprintf(stderr,format,ap);
  va_end(ap);
  exit(EXIT_FAILURE);
}
