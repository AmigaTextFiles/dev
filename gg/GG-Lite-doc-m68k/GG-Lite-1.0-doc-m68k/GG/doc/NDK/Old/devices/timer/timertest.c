/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */


/* Simple Timer Example Program: 
 *
 * Includes dynamic allocation of data structures needed to communicate
 * with the timer device as well as the actual device IO
 * Lattice use lc -b1 -cfist -v -y   Link with lc.lib, amiga.lib
 */

#include <exec/types.h>         /* Some system header files we need */
#include <exec/memory.h>
#include <devices/timer.h>
#include <proto/all.h>
#include <stdio.h>

/* Our timer sub-routines */
void delete_timer  (struct timerequest *);
LONG get_sys_time  (struct timeval *);
LONG set_new_time  (LONG);
void wait_for_timer(struct timerequest *, struct timeval *);
LONG time_delay    ( struct timeval *, LONG );
struct timerequest *create_timer( ULONG );
void show_time     (ULONG);


#ifdef LATTICE
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }  /* really */
#endif


struct Library *TimerBase;      /* to get at the time comparison functions */

/* manifest constants -- "never will change" */
#define   SECSPERMIN   (60)
#define   SECSPERHOUR  (60*60)
#define   SECSPERDAY   (60*60*24)

void main(int argc,char **argv)
{
   LONG seconds;
   struct timerequest *tr;      /* IO block for timer commands */
   struct timeval oldtimeval;   /* timevals to store times     */
   struct timeval mytimeval;
   struct timeval currentval;

   printf("Timer test\n");

   /* sleep for two seconds */
   currentval.tv_secs = 2;
   currentval.tv_micro = 0;
   time_delay( &currentval, UNIT_VBLANK );
   printf( "After 2 seconds delay\n" );

   /* sleep for four seconds */
   currentval.tv_secs = 4;
   currentval.tv_micro = 0;
   time_delay( &currentval, UNIT_VBLANK );
   printf( "After 4 seconds delay\n" );

   /* sleep for 500,000 micro-seconds = 1/2 second */
   currentval.tv_secs = 0;
   currentval.tv_micro = 500000;
   time_delay( &currentval, UNIT_MICROHZ );
   printf( "After 1/2 second delay\n" );

   printf( "DOS Date command shows: " );
   (void) Execute( "date", 0, 0 );

   /* save what system thinks is the time....we'll advance it temporarily */
   get_sys_time( &oldtimeval );
   printf("Original system time is:\n");
   show_time(oldtimeval.tv_secs );

   printf("Setting a new system time\n");

   seconds = 1000 * SECSPERDAY + oldtimeval.tv_secs;

   set_new_time( seconds );
   /* (if user executes the AmigaDOS DATE command now, he will*/
   /* see that the time has advanced something over 1000 days */

   printf( "DOS Date command now shows: " );
   (void) Execute( "date", 0, 0 );

   get_sys_time( &mytimeval );
   printf( "Current system time is:\n");
   show_time(mytimeval.tv_secs);

   /* Added the microseconds part to show that time keeps */
   /* increasing even though you ask many times in a row  */
   get_sys_time( &mytimeval );
   printf("TimeA %ld.%ld\n",mytimeval.tv_secs,
                            mytimeval.tv_micro);
   get_sys_time( &mytimeval );
   printf("TimeB %ld.%ld\n",mytimeval.tv_secs,
                            mytimeval.tv_micro);
   get_sys_time( &mytimeval );
   printf("TimeC %ld.%ld\n",mytimeval.tv_secs,
                            mytimeval.tv_micro);

   printf( "\nResetting to former time\n" );
   set_new_time( oldtimeval.tv_secs );

   get_sys_time( &mytimeval );
   printf( "Current system time is:\n");
   show_time(mytimeval.tv_secs);

   /* just shows how to set up for using the timer functions, does not */
   /* demonstrate the functions themselves.  (TimerBase must have a    */
   /* legal value before AddTime, SubTime or CmpTime are performed.    */
   tr = create_timer( UNIT_MICROHZ );
   TimerBase = (struct Library *)tr->tr_node.io_Device;

   /* and how to clean up afterwards */
   TimerBase = (struct Library *)(-1);
   delete_timer( tr );
}

struct timerequest *create_timer( ULONG unit )
{
   /* return a pointer to a timer request.  If any problem, return NULL */
   LONG error;
   struct MsgPort *timerport;
   struct timerequest *timermsg;

   timerport = CreatePort( 0, 0 );
   if( timerport == NULL )
   {
      return( NULL );
   }
   timermsg = (struct timerequest *)
       CreateExtIO( timerport, sizeof( struct timerequest ) );
   if( timermsg == NULL )
   {
      return( NULL );
   }
   error = OpenDevice( TIMERNAME, unit,(struct IORequest *) timermsg, 0L );
   if( error != 0 )
   {
      delete_timer( timermsg );
      return( NULL );
   }
   return( timermsg );
}

/* more precise timer than AmigaDOS Delay() */
LONG time_delay( struct timeval *tv, LONG unit )
{
   struct timerequest *tr;
   /* get a pointer to an initialized timer request block */
   tr = create_timer( unit );

   /* any nonzero return says timedelay routine didn't work. */
   if( tr == NULL ) return( -1L );

   wait_for_timer( tr, tv );

   /* deallocate temporary structures */
   delete_timer( tr );
   return( 0L );
}

void wait_for_timer(struct timerequest *tr, struct timeval *tv )
{
   /*--------------------------------------------*/
   /* With the UNIT_MICROHZ timer, it is illegal */
   /* to wait for 0 or 1 microseconds!           */
   /*--------------------------------------------*/
   if(tv->tv_secs==0L && tv->tv_micro < 2L) return;

   tr->tr_node.io_Command = TR_ADDREQUEST; /* add a new timer request */

   /* structure assignment */
   tr->tr_time = *tv;

   /* post request to the timer -- will go to sleep till done */
   DoIO((struct IORequest *) tr );
}

LONG set_new_time(LONG secs)
{
   struct timerequest *tr;
   tr = create_timer( UNIT_MICROHZ );

   /* non zero return says error */ 
   if( tr == 0 ) return( -1 );

   tr->tr_node.io_Command = TR_SETSYSTIME;
   tr->tr_time.tv_secs = secs;
   tr->tr_time.tv_micro = 0;
   DoIO((struct IORequest *) tr );

   delete_timer(tr);
   return(0);
}

LONG get_sys_time(struct timeval *tv)
{
   struct timerequest *tr;
   tr = create_timer( UNIT_MICROHZ );

   /* non zero return says error */
   if( tr == 0 ) return( -1 );
 
   tr->tr_node.io_Command = TR_GETSYSTIME;
   DoIO((struct IORequest *) tr );

   /* structure assignment */
   *tv = tr->tr_time;

   delete_timer( tr );
   return( 0 );
}

void delete_timer(struct timerequest *tr )
{
   struct MsgPort *tp;
   if( tr != 0 )
   {
       tp = tr->tr_node.io_Message.mn_ReplyPort;
       if(tp != 0)
       {
          DeletePort(tp);
       }
       CloseDevice( (struct IORequest *) tr );
       DeleteExtIO( (struct IORequest *) tr );
   }
}

void show_time(ULONG secs)
{
   ULONG days,hrs,mins;

   /* Compute days, hours, etc. */
   mins=secs/60;
   hrs=mins/60;
   days=hrs/24;
   secs=secs%60;
   mins=mins%60;
   hrs=hrs%24;

   /* Display the time */
   printf("*   Hour Minute Second  (Days since Jan.1,1978)\n");
   printf("*%5ld:%5ld:%5ld      (%6ld )\n\n",hrs,mins,secs,days);
}      /* end of main */

