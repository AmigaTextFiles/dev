/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQSYS_CORE
#include "../include/libqsys.h"

/*#ifdef	VERBOSE*/
bool verbose = FALSE;
/*#endif*/
bool fatal = FALSE;

/* longjump with this on error */
jmp_buf eabort;

/* default and valid longjump init */
#if 0
staticfnc void eexit(void) { exit(0); }
staticfnc void einit(void) { setjmp(eexit); }
__asm("	.text; 	.stabs \"___CTOR_LIST__\",22,0,0,_einit");
#endif

/*
 * TODO: pushjmp/popjmp/remjmp functions for enhanced
 *       backjump-handling
 */

#ifndef	EERROR
void Error(char *error,...)
{
  va_list argptr;

  fprintf(stderr, "Error: ");
  va_start(argptr, error);
  vfprintf(stderr, error, argptr);
  va_end(argptr);
  fflush(stderr);
  longjmp(eabort, 1);
}
#endif

#ifndef	EPRINTF
void eprintf(char *text,...)
{
  va_list argptr;

  fprintf(stderr, "Warning: ");
  va_start(argptr, text);
  vfprintf(stderr, text, argptr);
  va_end(argptr);
  fflush(stderr);
  if (fatal)
    longjmp(eabort, 1);
}
#endif

#ifndef	OPRINTF
#ifdef	VERBOSE
void oprintf(char *text,...)
{
  if (verbose) {
    va_list argptr;

    va_start(argptr, text);
    vfprintf(stdout, text, argptr);
    va_end(argptr);
    fflush(stdout);
  }
}
#endif
#endif

#ifndef	MPRINTF
void mprintf(char *text,...)
{
  va_list argptr;

  va_start(argptr, text);
  vfprintf(stdout, text, argptr);
  va_end(argptr);
  fflush(stdout);
}
#endif

/*
 * platform-independent progressbar (text-based)
 */
#ifndef	MPROGRESS
void mprogress(register int max, register int current)
{
#ifdef VALID_ESCAPES
  printf("\n\eM    - %2.2f%%", (float)(current * 100) / max);
  if (current >= max)
    printf("\n\eM");
  fflush(stdout);
#else
  printf("\xD\x9B\x4B    - %2.2f%%", (float)(current * 100) / max);
  if (current >= max)
    printf("\xD\x9B\x4B");
  fflush(stdout);
#endif
}
#endif
