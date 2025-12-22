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

#include "libx11.h"
#include "timing.h"

struct Library *TimerBase;

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

pid_t getpid(void)
{/*                  File 'f_util.o'*/
#ifdef DEBUGXEMUL
  printf("getpid\n");
#endif
  return(0);
}

struct passwd cPwd = {
  "Nope",
  "xxx",
  0,
  0,
  "a",
  "b",
  "c",
};

struct passwd *getpwuid (uid_t id){/*                File 'fileName.o'*/
#ifdef DEBUGXEMUL
  printf("getpwuid\n");
#endif
  return(&cPwd);
}

struct passwd *getpwnam( const char *name ){
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

/********************************************************************************
Name     : select()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : synchronous I/O multiplexing
Notes    : Used as a pause, and this it just what it currently does..
********************************************************************************/

int
select( int nfds,
        fd_set *readfds,
        fd_set *writefds,
        fd_set *exceptfds,
        struct timeval *timeout );

int
select( int nfds,
        fd_set *readfds,
        fd_set *writefds,
        fd_set *exceptfds,
        struct timeval *timeout )
{
#ifdef DEBUGXEMUL
#endif
  if( !timeout ){
    if( EG.fwindowsig )
      Wait(EG.fwindowsig);
  } else
    X11delayfor(timeout->tv_secs,timeout->tv_micro);

  return(0);
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void sleep( unsigned int secs )
{
  usleep(1000*secs);
}

gethostname(char *buf,int len){/*             File 'xnmr.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: gethostname\n");
#endif
  XmuGetHostname(buf,len);
  return(0);
}

ioctl(){/*                   File 'tcp.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: ioctl\n");
#endif
  return(0);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
int
gettimeofday( struct timeval *tp, struct timezone *tzp );

int
gettimeofday( struct timeval *tp, struct timezone *tzp )
{
/*  long t;*/
  unsigned int clock[2];
  int x=timer(clock);

/*  if(!TimerBase)open_timer();
  GetSysTime(tp);*/
/*
  time(&t);
  tp->tv_sec=t;
  tp->tv_usec=0;
*/
  if( !x ){
    tp->tv_sec=(ULONG)clock[0];
    tp->tv_usec=(ULONG)clock[1];
  } else {
    tp->tv_sec=0;
    tp->tv_usec=0;
  }

  return(0);
}

#if 1
double hypot(double x,double y){/*                   File 'events.o'*/
  double sq;
/*  printf("hypot %f %f\n",x,y);*/
  sq=(double)(sqrt(x*x+y*y));
/*  printf("sqrt %f\n",sq);*/
  return(sq);
}
#endif

#ifdef OFFLINE
alarm(){
  return 0;
}

inet_ntoa(){
  return 0;
}

int SocketBase;

getsockopt(){
  return 0;
}

recv(){
  return 0;
}

recvfrom(){
  return 0;
}

setsockopt(){
  return 0;
}

send(){
  return 0;
}

getpeername(){
  return 0;
}

shutdown(){
  return 0;
}

gethostbyaddr(){
  return 0;
}

sendto(){
  return 0;
}
#endif
