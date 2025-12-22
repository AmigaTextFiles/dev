/*
 *      TIMER.C
 */

#include "BGUIPlayer.h"

/*
 *      Export symbols.
 */
Prototype BOOL SetupTimer( void );
Prototype VOID KillTimer( void );
Prototype VOID TriggerTimer( ULONG micros );
Prototype BOOL CheckTimer( void );
Prototype ULONG TimerMask;

struct MsgPort          *TimerPort = NULL;
ULONG                    TimerMask = 0L;
struct IORequest        *TimerReq = NULL;

/*
 *      Some macros.
 */
#define SET_COMMAND(r,c)          (( struct timerequest * )r )->tr_node.io_Command = c
#define SET_SECONDS(r,s)          (( struct timerequest * )r )->tr_time.tv_secs    = s
#define SET_MICROS(r,m)           (( struct timerequest * )r )->tr_time.tv_micro   = m
#define GET_ERROR(r)              (( struct timerequest * )r )->tr_node.io_Error

/*
 *      Open up the timer.device.
 */
BOOL SetupTimer( void )
{
        /*
         *      Create a port.
         */
        if ( TimerPort = CreateMsgPort()) {
                /*
                 *      Create timer request block.
                 */
                if ( TimerReq = CreateIORequest( TimerPort, sizeof( struct timerequest ))) {
                        /*
                         *      Open the device.
                         */
                        if ( ! OpenDevice( TIMERNAME, UNIT_VBLANK, TimerReq, 0L )) {
                                /*
                                 *      Set global port mask.
                                 */
                                TimerMask = ( 1L << TimerPort->mp_SigBit );
                                /*
                                 *      Initialize it.
                                 */
                                SET_COMMAND( TimerReq, TR_ADDREQUEST );
                                return( TRUE );
                        }
                        DeleteIORequest( TimerReq );
                        TimerReq = NULL;
                }
                DeleteMsgPort( TimerPort );
                TimerPort = NULL;
        }
        return( FALSE );
}

/*
 *      Close up the timer.device.
 */
VOID KillTimer( void )
{
        /*
         *      All OK?
         */
        if ( TimerReq ) {
                /*
                 *      Request pending?
                 */
                if ( ! CheckIO( TimerReq )) {
                        /*
                         *      Abort.
                         */
                        AbortIO( TimerReq );
                        /*
                         *      Pop aborted request.
                         */
                        WaitIO( TimerReq );
                }
                /*
                 *      Close device.
                 */
                CloseDevice( TimerReq );
                /*
                 *      Delete request.
                 */
                DeleteIORequest( TimerReq );
                /*
                 *      Delete port.
                 */
                DeleteMsgPort( TimerPort );
        }
}

/*
 *      Trigger a timer request.
 */
VOID TriggerTimer( ULONG micros )
{
        /*
         *      All OK?
         */
        if ( TimerReq ) {
                /*
                 *      Request pending?
                 */
                if ( ! CheckIO( TimerReq )) {
                        /*
                         *      Abort.
                         */
                        AbortIO( TimerReq );
                        /*
                         *      Pop aborted request.
                         */
                        WaitIO( TimerReq );
                }
                /*
                 *      Setup the time-delay.
                 */
                SET_MICROS( TimerReq, micros );
                SET_SECONDS( TimerReq, 0L );
                /*
                 *      Send the request.
                 */
                SendIO( TimerReq );
        }
}

/*
 *      Check if it's a valid timer message.
 */
BOOL CheckTimer( void )
{
        BOOL                    rc = TRUE;

        return( GET_ERROR( TimerReq ) ? FALSE : TRUE );
}
