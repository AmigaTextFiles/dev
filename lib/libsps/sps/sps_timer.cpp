#include <sps/sps_timer.h>
#include <sps/sps_types.h>
#include <sps/sps_exception.h>

#include <proto/exec.h>
#include <proto/timer.h>

SPS_Timer::SPS_Timer() 
    : m_TimerPort(NULL)
    , m_TimerRequest(NULL)
    , ITimer(NULL)   
{
    try {
        m_TimerPort = reinterpret_cast<struct MsgPort*>(IExec->AllocSysObject(ASOT_PORT, NULL));
        if ( !m_TimerPort ) {
            Throw1( "Cannot allocate timer port " );
        }
        m_TimerRequest = reinterpret_cast<struct timerequest*>(
                                IExec->AllocSysObjectTags(ASOT_IOREQUEST,
                                                          ASOIOR_ReplyPort, m_TimerPort,
                                                          ASOIOR_Size,      sizeof(struct timerequest),
                                                          TAG_DONE));
        if (!m_TimerRequest) {
            Throw1( "Cannot creater time request" );
        }
        if ( IExec->OpenDevice("timer.device", UNIT_WAITUNTIL, reinterpret_cast<struct IORequest*>(m_TimerRequest), 0)) {
            Throw1( "Cannot open timer.device" );
        }
        
        struct Library *TimerBase = &m_TimerRequest->tr_node.io_Device->dd_Library;
        if (!TimerBase) {
            Throw1( "No TimerBase (huh?)" );
        }
        ITimer = (struct TimerIFace *)IExec->GetInterface( TimerBase, "main", 1, 0 );
        if ( !ITimer ) {
            Throw1( "No Timer Interface." );
        }
    } catch ( ... ) {
        // make sure we clean us up on error
        this->~SPS_Timer();
        // and pass it on to our creator
        throw;
    }
}

SPS_Timer::~SPS_Timer()
{
    if ( m_TimerRequest )  {
        // we have to use at least one IO Request, or WaitIO() will crash. 
        this->Delay( 1 );
        // clean up the device
        if (!IExec->CheckIO(reinterpret_cast<struct IORequest*>(m_TimerRequest))) {
            IExec->AbortIO(reinterpret_cast<struct IORequest*>(m_TimerRequest));
        }
        IExec->WaitIO(reinterpret_cast<struct IORequest*>(m_TimerRequest));
        
        IExec->CloseDevice( reinterpret_cast<struct IORequest*>(m_TimerRequest) );
        IExec->FreeSysObject(ASOT_IOREQUEST, static_cast<void*>(m_TimerRequest));
        m_TimerRequest = NULL;
    }
    if ( m_TimerPort ) {
        IExec->FreeSysObject(ASOT_PORT, static_cast<void*>(m_TimerPort));
        m_TimerPort = NULL;
    }
    ITimer = NULL; // local timer iface!    
}

/* wait for given time in ms */    
void SPS_Timer::Delay( uint32 ms )
{
    WaitWithTimeout( 0, ms );
}

void SPS_Timer::MicroDelay( double ticks )
{
    uint32 tv_secs   = static_cast<uint32>(ticks / 1000.0);
    uint32 tv_micro  = static_cast<uint32>((ticks * 1000.0) - (tv_secs * 1000 * 1000));

    m_TimerRequest->tr_node.io_Command = TR_ADDREQUEST;
    m_TimerRequest->tr_time.tv_secs    = tv_secs;
    m_TimerRequest->tr_time.tv_micro   = tv_micro;

    // the new time is the current time + the wait time
    struct timeval current_time;
    ITimer->GetSysTime(&current_time);
    ITimer->AddTime(&m_TimerRequest->tr_time, &current_time );

    // clear signal
    IExec->SetSignal( 0, 1L << m_TimerPort->mp_SigBit );
    // request a timeout
    IExec->SendIO(reinterpret_cast<struct IORequest*>(m_TimerRequest));

    // wait for timer & other sigs
    IExec->Wait( 1L << m_TimerPort->mp_SigBit );
}

uint32 SPS_Timer::WaitWithTimeout( uint32 sigs, uint32 ms )
{  
    if ( ms > 0 && m_TimerPort && m_TimerRequest ) {

        uint32 tv_secs   = (ms / 1000);
        uint32 tv_micro  = (ms * 1000) - (tv_secs * 1000 * 1000);

        m_TimerRequest->tr_node.io_Command = TR_ADDREQUEST;
        m_TimerRequest->tr_time.tv_secs    = tv_secs;
        m_TimerRequest->tr_time.tv_micro   = tv_micro;

        // the new time is the current time + the wait time
        struct timeval current_time;
        ITimer->GetSysTime(&current_time);
        ITimer->AddTime(&m_TimerRequest->tr_time, &current_time );

        // clear signal
        IExec->SetSignal(0, 1L << m_TimerPort->mp_SigBit );
        // request a timeout
        IExec->SendIO(reinterpret_cast<struct IORequest*>(m_TimerRequest));

        // wait for timer & other sigs
        sigs = IExec->Wait( 1L << m_TimerPort->mp_SigBit | sigs );
    } else if ( sigs ) {
        sigs = IExec->Wait( sigs );
    }
    return sigs;
}

