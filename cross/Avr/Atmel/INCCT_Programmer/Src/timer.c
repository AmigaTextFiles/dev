#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <devices/timer.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>

#include <stdio.h>

void delete_timer  (void);
void wait_for_timer(struct timeval *);
LONG time_delay    ( struct timeval *);
int create_timer( void );

struct timerequest *tr;

struct Library *TimerBase;   

void delay(int Milliseconds)
{
struct timeval currentval;

currentval.tv_secs = 0;
currentval.tv_micro = 1000*Milliseconds;

time_delay( &currentval);
}

int create_timer(void)
{
/* return a pointer to a timer request.  If any problem, return NULL */
LONG error;
ULONG unit= UNIT_MICROHZ ;
struct MsgPort *timerport;
struct timerequest *TimerIO;

timerport = CreatePort( 0, 0 );
if (timerport == NULL )
    return( 0 );

TimerIO = (struct timerequest *)
    CreateExtIO( timerport, sizeof( struct timerequest ) );
if (TimerIO == NULL )
    {
    DeletePort(timerport);   /* Delete message port */
    return( 0 );
    }
tr=TimerIO ;
error = OpenDevice( TIMERNAME, unit,(struct IORequest *) TimerIO, 0L );
if (error != 0 )
    {
    delete_timer();
    return(0);
    }
 
return 1;
}

/* more precise timer than AmigaDOS Delay() */
LONG time_delay( struct timeval *tv)
{

/* any nonzero return says timedelay routine didn't work. */
if (tr == NULL )
    return( -1L );

wait_for_timer(tv);

/* deallocate temporary structures */

return( 0L );
}

void wait_for_timer( struct timeval *tv )
{

tr->tr_node.io_Command = TR_ADDREQUEST; /* add a new timer request */

/* structure assignment */
tr->tr_time = *tv;

/* post request to the timer -- will go to sleep till done */
DoIO((struct IORequest *) tr );
}

void delete_timer(void)
{
struct MsgPort *tp;

if (tr != 0 )
    {
    tp = tr->tr_node.io_Message.mn_ReplyPort;

    if (tp != 0)
        DeletePort(tp);

    CloseDevice( (struct IORequest *) tr );
    DeleteExtIO( (struct IORequest *) tr );
    }
}

