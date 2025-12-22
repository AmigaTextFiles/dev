/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_signal.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_signal.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_signal.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"



/*
 * siginal_init:
 * sets up all the signals we'd like
 * to handle specially
 */
extern void 
signal_init(void) {
  struct sigaction sa_old, sa_new;
  /* signal handling */
  sa_new.sa_handler = catch_signal;
  sigemptyset(&sa_new.sa_mask);
  sa_new.sa_flags = 0;
  sigaction(SIGINT,&sa_new,&sa_old);
  sigaction(SIGHUP,&sa_new,&sa_old);
  sigaction(SIGPIPE,&sa_new,&sa_old);
  sigaction(SIGALRM,&sa_new,&sa_old);
  sigaction(SIGABRT,&sa_new,&sa_old);
  sigaction(SIGTERM,&sa_new,&sa_old);
  sigaction(SIGFPE,&sa_new,&sa_old);
  sigaction(SIGILL,&sa_new,&sa_old);
  sigaction(SIGTRAP,&sa_new,&sa_old);
}


/*
 * Main signal handling
 *
 * RETSIGTYPE is a macro defined
 * by ./configure which will be
 * set to either int or void, 
 * depending on the system.
 */
extern RETSIGTYPE 
catch_signal(int signo) {
  time_t total;
  float kbps = 0.0;
  u_long total_size;

   freebuf(buffer); /* free our buffered memory  */

   switch(signo) {

    case SIGINT: { /* Signal Interrupt */
      send_finish = time(NULL);
      total = (send_finish - send_start);
      if(packets_sent > 49) {
        /* We must do this to avoid a floating point exception */
        total_size = (packetsize*packets_sent);
        kbps  = (float)(total_size/total)/1024;
      }


      if(verbose > 0) {
        if(total_size < 1024)
          printf("%lu total bytes sent\n", total_size);
        else
          printf("%lu total kilobytes sent\n", (total_size/1024));
   
      }
 

      printf("%lu drops fell in %d minutes, %d seconds (%.1f kB/s)\n\n",
             packets_sent, (int)(total/60), (int)(total%60), kbps);


      exit(0);
    }
    case SIGALRM: { /* signal alarm (used for timeouts) */
      fprintf(stderr,"- - Operation timed out\n");
      fprintf(stderr,"    The remote port may be filtered\n");
      exit(1);
    }
    default: {
      fprintf(stderr,"- - %s; Exiting...\n", sys_siglist[signo]);
      exit(1);
    }
  }
}
