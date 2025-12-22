/*!
 *  @addtogroup <sps>
 *  @{ pointdesign DOT com
 *
 *  Copyright (c) 2006 Jürgen Schober
 *  This code herein is freeware and provided AS IS.
 *  Use at your own risk. No waranty!
 */

/*!
 *  @file sps_timer.h
 *
 *  Generic timer class.
 * 
 *  This is a generic timer class witch lets you create a timer object
 *  without worrying about IO requests, timer device etc. A timer object
 *  can be used as many times as you want. I offers three usefull methods:
 * 
 *  Delay() - a simple delay in micro seconds
 *  MicroDelay() - another delay which can handle sub-microsecs as well (e.g. 0.15ms)
 *  WaitSignal() - a IExec->Wait() with timeout function. You can replace the
 *                 IExec->Wait( sigs ) against (e.g.) MyTimer->WaitWithTimeout( sigs, 5000 ); 
 *                 to wait (e.g.) max 5000ms (== 5secs) for a message to arrive.
 *               - A timeout of 0 will fallback to IExec->Wait( sigs );
 *               - A signalmaks of 0 will be effective be handled as a Delay()
 *               - You can interrupt a pending wait with a CTRL-D signal
 *
 *  This class is not thread safe! However, you can create as many objects as
 *  you like and for example the main and a thread can have its very own 
 *  SPS_Timer object.
 * 
 *  Creating a SPS_Timer on the stack is legal but will add some performance
 *  overhead (which is usually below 1ms).
 *  
 *  @author Jürgen Schober
 *
 *  @date
 *      - 08/21/2006 initial
 *
 *  @changes
 *      - 08/21/2006 -js-
 */

#ifndef SPS_TIMER_H_
#define SPS_TIMER_H_

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/tasks.h>
#include <exec/semaphores.h>

#include <dos/dos.h>

class SPS_Timer
{   
public:
    SPS_Timer();
    virtual ~SPS_Timer();

    /* wait for given time in ms */    
    void Delay( uint32 ms );
    /* */
    void MicroDelay( double time );
    /* */
    uint32 WaitWithTimeout( uint32 sigmask, uint32 ms );

    int32 GetSigMask() { return (1L << m_TimerPort->mp_SigBit); }
protected:
    /*! WaitWithTimeout() */
    struct MsgPort     *m_TimerPort;
    struct timerequest *m_TimerRequest;

    struct TimerIFace  *ITimer;        
};

#endif /*SPS_TIMER_H_*/

/*! @} sps */
