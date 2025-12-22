/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

/***
   NAME
     unix
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Aug 13, 1995: Created.
***/

#include <stdio.h>
#include <pwd.h>
#include <unistd.h>

uid_t geteuid(void)
{/*                 File 'e_delete.o'*/
#ifdef DEBUGXEMUL
  printf("geteuid\n");
#endif
  return(0);
}

char *getlogin(void)
{
  return 0;
}

int getpid(void)
{/*                  File 'f_util.o'*/
#ifdef DEBUGXEMUL
  printf("getpid\n");
#endif
  return(0);
}

struct passwd *getpwuid (uid_t id){/*                File 'fileName.o'*/
#ifdef DEBUGXEMUL
  printf("getpwuid\n");
#endif
  return(0);
}

struct passwd *getpwnam( char *name ){
  return NULL;
}

FILE *popen(const char *command, const char *type)
{/*                   File 'eps.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: popen\n");
#endif
  return(0);
}

int pclose(FILE *stream)
{/*                  File 'eps.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: pclose\n");
#endif
  return(0);
}

uid_t getuid(void){/*                  File 'fileName.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: getuid\n");
#endif
  return(0);
}
