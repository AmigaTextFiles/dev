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
     timing
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Dec 17, 1994: Created.
**/

#include <exec/io.h>
#include <devices/timer.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>

#include <stdio.h>

#include "libX11.h"

#include <X11/X.h>
#include <X11/Xlib.h>

#include "amigax_proto.h"
#include "amiga_x.h"

extern struct DosLibrary *DOSBase;
struct Library *TimerBase=NULL;

void wait_for_timer(struct timerequest *, struct timeval *);

void delete_timer(struct timerequest *tr ){
  struct MsgPort *tp;
  
  if (tr != 0 ){
    tp = tr->tr_node.io_Message.mn_ReplyPort;
    if (tp != 0) DeletePort(tp);

    CloseDevice( (struct IORequest *) tr );
    DeleteExtIO( (struct IORequest *) tr );
  }
}

struct timerequest *create_timer( ULONG unit ){
  /* return a pointer to a timer request.  If any problem, return NULL */
  LONG error;
  struct MsgPort *timerport;
  struct timerequest *TimerIO;
  
  timerport = CreatePort( 0, 0 );
  if (timerport == NULL ) return( NULL );

  TimerIO = (struct timerequest *)
    CreateExtIO( timerport, sizeof( struct timerequest ) );
  if (TimerIO == NULL ){
    DeletePort(timerport);   /* Delete message port */
    return( NULL );
  }
  
  error = OpenDevice( TIMERNAME, unit,(struct IORequest *) TimerIO, 0L );
  if (error != 0 ){
    delete_timer( TimerIO );
    return( NULL );
  }
  return( TimerIO );
}

/* more precise timer than AmigaDOS Delay() */
LONG time_delay( struct timeval *tv, LONG unit ){
  struct timerequest *tr;
  /* get a pointer to an initialized timer request block */
  tr = create_timer( unit );

  /* any nonzero return says timedelay routine didn't work. */
  if (tr == NULL ) return( -1L );

  wait_for_timer( tr, tv );

  /* deallocate temporary structures */
  delete_timer( tr );
  return( 0L );
}

void wait_for_timer(struct timerequest *tr, struct timeval *tv ){

  tr->tr_node.io_Command = TR_ADDREQUEST; /* add a new timer request */

  /* structure assignment */
  tr->tr_time = *tv;

  /* post request to the timer -- will go to sleep till done */
  DoIO((struct IORequest *) tr );
}


struct MsgPort *replymp;
struct timerequest *tr;
BOOL not_opened = TRUE;

int open_timer(){
  struct timerequest *xtr;
  if(TimerBase)return;
  replymp = (struct MsgPort *) CreatePort( NULL, 0 );
  if( !replymp ){
    return(0);
  }
  tr = (struct timerequest *)
    CreateExtIO( replymp, sizeof( struct timerequest) );
  if( !tr ){
    return(0);
  }

  not_opened = OpenDevice( TIMERNAME, UNIT_ECLOCK, (struct IORequest *)tr ,0L);
  if( not_opened ){
    return(0);
  }
  /* get a pointer to an initialized timer request block */
  xtr = create_timer( UNIT_MICROHZ );
  TimerBase = (struct Library *)xtr->tr_node.io_Device;
  delete_timer( xtr );
  return(1);
}

void close_timer(){
  if( tr ){
    if( !not_opened ) CloseDevice( (struct IORequest *)tr );
    DeleteExtIO( (struct IORequest*)tr /*, sizeof( struct timerequest)*/ );
    tr=NULL;
  }
  if( replymp ) DeletePort( replymp);
  replymp=NULL;
}

#define CLK_TCK 1000

long clock_ticks(){
  tr->tr_node.io_Command = TR_GETSYSTIME;
  DoIO( (struct IORequest *)tr );
  return((long)(tr->tr_time.tv_secs*CLK_TCK+(long)(tr->tr_time.tv_micro/1000)));
}

void X11delayfor( int sec, int micro ){
  struct timeval currentval;
  currentval.tv_secs = sec;
  currentval.tv_micro = micro;
  time_delay( &currentval, UNIT_MICROHZ );
}

usleep(usecs){
  struct timeval currentval;
  currentval.tv_secs = 0;
  currentval.tv_micro = usecs;
  time_delay( &currentval, UNIT_MICROHZ );
}

sleep(secs){
  usleep(1000*secs);
}
