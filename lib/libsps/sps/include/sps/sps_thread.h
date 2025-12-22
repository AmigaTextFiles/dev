/*!
 *  @addtogroup <sps>
 *  @{ pointdesign DOT com
 *
 *  Copyright (c) 2006 Jürgen Schober
 *  This code herein is freeware and provided AS IS.
 *  Use at your own risk. No waranty!
 */

/*!
 *  @file sps_thead.h
 *
 *  Thread object class
 *
 *  SPS_Threads simplify the usage of DOS threads. A class derived from
 *  an SPS_Thread implements virtual OnEntry()/Run()/OnExit() methods and
 *  allows a quick and easy way to create threaded applications.
 *
 *  Local scope threads are possible (e.g. on stack threads). Syncronisation
 *  with the main application is provided. No need to manually lock the 
 *  app while destroying a thread.
 *  However, an explicit Create()/Destroy() pair is required. (Should be
 *  e.g. enough as in { MyThread thread; thread.Create(); thread.Destroy(); }
 * 
 *  Worker threads are not directly supported (e.g. freeing it's own memory),
 *  however this could be achieved thru inheritance, e.g. WorkerThread my call
 *  Destroy() in it's d'tor. But only in its top level. No further inheritance
 *  is allowed! A worker thread could also be implemented thru containment rather
 *  then inheritance.
 *  
 *  The thread is running after it has been Create()ed. Create() waits until the 
 *  OnEntry() method returns, and thus OnEntry() is safe to allocate resources
 *  in sync with the main process. If OnEntry() fails, the thread is removed
 *  again and Create() will return NULL. In that case, it is the applications
 *  responsibility to free the SPS_Thread object.
 * 
 *  Eventhough OnEntry() might fail, OnExit() will always be called. This 
 *  allows you to free resources allocated in OnEntry() even though the 
 *  thread creation failed. WARNING! This also implies, that all your 
 *  resources MUST be initialized prior to an OnExit() call (e.g. in the c'tor).
 *  
 *  @author Jürgen Schober
 *
 *  @date
 *      - 08/21/2006 initial
 *
 *  @changes
 *      - 08/28/2006 -js-
 *          - update the doc a bit
 *          - moved some internal stuff into private area
 */
#ifndef SPS_THREAD_H_
#define SPS_THREAD_H_

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/tasks.h>
#include <exec/semaphores.h>

#include <dos/dos.h>

class SPS_Thread
{
public:
    /*! c'tor */
    SPS_Thread();
    /*! This class has no virtual destructor! Never (!) overload the d'tor
     *  This is not thread save! Use Destroy() to destruct your derived class
     *  and make sure (!) you call SPS_Thread::Destroy() FIRST (!) before you
     *  delete your local resources! This waits until the thread is terminated 
     *  and it is now save to delete the resources of your derived class. */
    virtual ~SPS_Thread();

    /*! create and run the thread. This functions returns after OnEntry() has returned.
     *  If OnEntry() fails (it returns false itself), Create() will return NULL. */
    virtual struct Task* Create( const char * name,int32 pri = 0, uint32 stack = 0x2000 );

    /*! call before d'tor! Kills the thread. This cannot be called savely within the d'tor!
     *  Calling it once before a(nother) Create() or at the end of an application is safe,
     *  no additional checks necessary. It is allowed to call the method even if the thread
     *  hasn't been created! */
    virtual void Destroy();

    /* possibly kill the thread (if e.g. a CTRL-C is not sufficient). This is actualy just a Signal() */
    virtual void Signal( uint32 sig = SIGBREAKF_CTRL_C );
  
    /*! in case you need a task handle */
    struct Task* GetTask() {
        return m_Task;
    }
    
protected:

    /* called before Run(). Init what you want. Return true if init is succesfull, false if not.
     * If result is false, thread will terminate immediately. Create() will wait until OnEntry() returns
     * and will itself return NULL in case OnEntry() fails. */
    virtual bool OnEntry() {
        return true;
    }
    
    /* called before exit. Cleanup what you have initialized in OnEntry().
     * Warning! OnExit() will also be called even if OnEntry() fails! This said, make sure all
     * pointers are initialized either in the c'tor or in the OnEntry(). */
    virtual void OnExit() {
    }
    
    /*! overload this. This is your entry function. This function is run after OnEntry() is done and
     *  in parallel to Create().*/
    virtual void Run( ) = 0;

protected:    
    /* the task handle. Only valid outside the thread itself!! */
    struct Task* m_Task;
    /* a link to its creator */
    struct Task* m_Parent;

private: // internal only! Not available in derived classes
    /*! static C style thread entry function */
    static void EntryStub( void );

    /*! C++ entry point */
    void ThreadEntry( );

private: // internal only! Not available in derived classes
    /* internal signal to sync thread */
    int32 m_InternalSignal;
    /* lock to sync run/destruct */
    struct SignalSemaphore *m_InternalScopeLock;


};

#endif /*SPS_THREAD_H_*/

/*! @} sps */

