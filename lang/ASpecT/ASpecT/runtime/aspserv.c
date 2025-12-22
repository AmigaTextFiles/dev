/*
 *    A server for the ASpecT make utility
 */


 
/* Services */

#define  s_are_you_alive "0"
#define  s_execute_this  "1"
#define  s_finish_up     "2"
#define  s_return_status "3"
#define  s_output_line   "4"


#include <stdio.h>
#ifdef AIX
#include <sys/select.h>
#endif
#include <rpc/rpc.h>
#include <sys/types.h>
#include <sys/time.h>
#include <errno.h>
#include <sys/signal.h>
#include <sys/resource.h>

#ifdef MAC

/* the MacIntosch has a slightly different select routine using int
 * instead of fd_set as file descriptors
 */

#define fd_set int
#define svc_fdset svc_fds
#define svc_getreqset svc_getreq

/* the MacIntosh does not support getrusage
 * it uses sar (which is not supported here)
 */

#define NO_TIMER_AVAIL

#endif





#ifndef NO_TIMER_AVAIL
#define sec(x) x.ru_utime.tv_sec
struct rusage STARTTIME;
#endif

void
start_timer() {
#ifndef NO_TIMER_AVAIL
  getrusage(RUSAGE_SELF,&STARTTIME);
#endif
}

int
time_to_stop() { /* five minutes delay iff timer available!! */
#ifndef NO_TIMER_AVAIL
  struct rusage ENDTIME;
  getrusage(RUSAGE_SELF,&ENDTIME);
  if((sec(ENDTIME)-sec(STARTTIME))>300) return 1;
#endif
  return 0;
}

SVCXPRT *xprt;
int address;     /* communication program number */


int busy_mode = 0;     /* is 1 if working on a job   */
char *command = NULL;  /* contains current jobstring */
int exitnow   = 0;     /* is 1 if termination is requested */
int worker    = 0;     /* process number of worker process */
int retstat   = 0;     /* return status of last job        */
int lastjob   = 0;     /* pid of last job */

FILE *stdout_stream;
#define mk_buffer (char *) malloc(512)

void
doing_the_work() { 
  char *cmd=mk_buffer;
  sprintf(cmd,"%s > /tmp/%d.out",command,worker);
  fprintf(stderr,"execute: %s\n",cmd);
  retstat=system(cmd);
  fprintf(stderr,"done: %i\n",retstat);
  free(cmd);
  free(command);
  command=NULL;
}


int
dispatcher(rqstp,transp)
  register struct svc_req *rqstp;
  register SVCXPRT *transp;
{ 
  static char *service, *tmp;
  static int res;

  switch (rqstp->rq_proc) {
   case 0:
    if(!svc_sendreply(transp,xdr_void,0)) {
      fprintf(stderr,"dispatcher failed to send reply {1}\n");
      return 1;
    }
    return 0;

   case 1:
    if(!svc_getargs(transp,xdr_wrapstring,&service)) {
      fprintf(stderr,"dispatcher failed to receive service\n");
      svcerr_decode(transp);
      return 1;
    }

     if(service[0]== s_are_you_alive[0]){
      res = busy_mode;
      if(!svc_sendreply(transp,xdr_int,&res)) {
        fprintf(stderr,"dispatcher failed to send reply\n");
        return 1;
      }
      return 0;
     }

     if(service[0]== s_return_status[0]){
      res = retstat;
      if(!svc_sendreply(transp,xdr_int,&res)) {
        fprintf(stderr,"dispatcher failed to send reply {2}\n");
        return 1;
      }
      return 0;
     }

     
     if(service[0]==s_finish_up[0]){
      res = busy_mode;
      if(!svc_sendreply(transp,xdr_int,&res)) {
        fprintf(stderr,"dispatcher failed to send reply {3}\n");
        return 1;
      }
      if(busy_mode==0) exitnow=1;
      return 0;
     }

     if(service[0]==s_output_line[0]){
       if((lastjob!=0) && (stdout_stream!=NULL)) {
        tmp=mk_buffer;
        if(fgets(tmp,256,stdout_stream)==NULL)
          tmp="\001";
       } else
          tmp="\001";
      
      res = busy_mode;
      if(!svc_sendreply(transp,xdr_wrapstring,&tmp)) {
        fprintf(stderr,"dispatcher failed to send reply {3}\n");
        free(tmp);
        return 1;
      }
      free(tmp);
      return 0;
     }


     if(service[0]==s_execute_this[0]){
       res = busy_mode;
       if(!svc_sendreply(transp,xdr_int,&res)) {
         fprintf(stderr,"dispatcher failed to send reply {4}\n");
         return 1;
       }
       if(busy_mode==0) {
         tmp=(char *) malloc(strlen(service));
         strcpy(tmp,&(service[1]));
         command=tmp;
         worker = fork();
         if(worker== -1) {
           fprintf(stderr,"cannot fork worker process\n");
           exit(1);
         } else if(worker>0) {
           doing_the_work();
           kill(worker,9);
           wait(NULL);
           start_timer(); /* reset timer */
           finishup_outfile();
           tmp=mk_buffer;
           sprintf(tmp,"/tmp/%d.out",worker);
           stdout_stream = fopen(tmp,"r");
           free(tmp);
           lastjob=worker;
         } else
           busy_mode = 1;
       }
       return 0;
     }
    
    if(!svc_sendreply(transp,xdr_void,0)) {
      fprintf(stderr,"dispatcher failed to send reply {5}\n");
      return 1;
    }
    return 0;
  }
  return 0;
}


void
setup_rpc() {
   if((xprt = svcudp_create(RPC_ANYSOCK)) == NULL) {
     fprintf(stderr,"svcudp_create failed\n");
     exit(1);
   }
   if(!pmap_set(address,(u_long)1,(int)IPPROTO_UDP,(u_short)xprt->xp_port)) {
     fprintf(stderr,"pmap_set failed\n");
     exit(1);
   }
   if(!svc_register(xprt,address,1,dispatcher,0)) {
     fprintf(stderr,"svc_register failed\n");
     pmap_unset(address,1);
     exit(1);
   }
}


void
finishup_rpc() {
   svc_unregister(address,1);
   pmap_unset(address,1);
}

finishup_outfile() {
  char *tmp;
  if(lastjob!=0) {
    tmp = mk_buffer;
    fclose(stdout_stream);
    sprintf(tmp,"rm /tmp/%d.out > /dev/null",lastjob);
    system(tmp);
    free(tmp);
  }
}

void
listen_to_rpc() {
  fd_set readfds;
  int dtbsz = getdtablesize();
  struct timeval tv;
  for(;;) {
    readfds = svc_fdset;
    if((busy_mode==0) && (time_to_stop()==1)) {
      finishup_rpc();
      finishup_outfile();
      exit(0);
    }
    if(exitnow==1) {
      finishup_rpc();
      finishup_outfile();
      exit(0);
    }
    tv.tv_sec=0;
    tv.tv_usec=0;
    switch(select(dtbsz,
                  &readfds,(fd_set*)NULL,(fd_set*)NULL,
                  &tv)) {
      case -1:
        if (errno!=EBADF) continue;
        perror("select");
        return;
      case 0:
        continue;
      default:
        svc_getreqset(&readfds);
    }
  }
}

void
main(argc,argv)
   int argc;
   char *argv[];
{
   if(argc!=2) {
     fprintf(stderr,"usage: %s address\n", argv[0]);
     exit(1);
   }

   if(sscanf(argv[1],"%d",&address)!=1) {
     fprintf(stderr,"address must be a number\n");
     exit(1);
   }

   if((address<0x40000000) ||
      (address>0x5fffffff)) {
     fprintf(stderr,"address must be in transient range\n");
     exit(1);
   } 
  
   setup_rpc();

   start_timer();
   listen_to_rpc();
   fprintf(stderr,"Server terminates abnormally!\n");
}
