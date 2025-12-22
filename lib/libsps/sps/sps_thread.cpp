#include <sps/sps_thread.h>
#include <sps/sps_types.h>

#include <proto/exec.h>
#include <proto/dos.h>


SPS_Thread::SPS_Thread() 
    : m_Task(NULL)
    , m_Parent(IExec->FindTask(NULL))
{
    m_InternalScopeLock = static_cast<struct SignalSemaphore*>(IExec->AllocSysObject(ASOT_SEMAPHORE, NULL));
    m_InternalSignal    = IExec->AllocSignal( -1 );
}

SPS_Thread::~SPS_Thread()
{
    _D("SPS_Thread::~SPS_Thread() - Wait Semaphore.\n");

    // and wait until it is cleared (only if we have a thread!)
    if ( m_Task ) {
        IExec->ObtainSemaphore( m_InternalScopeLock );  // wait for thread to return
        IExec->ReleaseSemaphore( m_InternalScopeLock ); // and unlock us again
    }
    IExec->FreeSysObject(ASOT_SEMAPHORE, static_cast<void*>(m_InternalScopeLock));
    IExec->FreeSignal( m_InternalSignal );

    _D("SPS_Thread::~SPS_Thread() - Done.\n");
}

struct Task * SPS_Thread::Create( const char * name, int32 pri, uint32 stack )
{
    // don't create it twice!
    if (m_Task) {
        return m_Task;
    }
    // warning! m_Task is not safe within the thread function! Only used inside the creater context!
    if ( (m_Task = (Task*)IDOS->CreateNewProcTags(NP_Name,     name,
                                                  NP_Entry,    (ULONG)(&EntryStub),
                                                  NP_Priority, pri,
                                                  NP_StackSize,stack,
                                                  NP_Child,    true,
                                                  NP_UserData, this,
                                                  TAG_DONE,    TAG_DONE)) != NULL )
    {
        /* a CTRL-C interrupts the wait, but does not terminate the thread! */
        if ( IExec->Wait( (1<<m_InternalSignal) | SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_E ) & SIGBREAKF_CTRL_E ) {
            // if task init fails (OnEntry() returns false) -> we get a CTRL-E,

            // wait until the thread ran thru it's clean up code (m_Task will be set to NULL by the task)
            IExec->ObtainSemaphore( m_InternalScopeLock );
            IExec->ReleaseSemaphore( m_InternalScopeLock );
            m_Task = NULL;
        }
    }
    return m_Task;
}

void SPS_Thread::Destroy()
{
    _D("SPS_Thread::Destroy() - Enter.\n");
    if (m_Task)
    {
        //kill the thread
        this->Signal( SIGBREAKF_CTRL_C );

        // and wait until it is cleared
        IExec->ObtainSemaphore( m_InternalScopeLock );  // wait for thread to return
        IExec->ReleaseSemaphore( m_InternalScopeLock ); // and unlock us again
        /**************/
        m_Task = NULL;                          // now it's save to set the handle to NULL
        /**************/
    }
    _D("SPS_Thread::Destroy() - Out.\n");
}

void SPS_Thread::Signal( uint32 sig /* = SIGBREAKF_CTRL_C */)
{
    if (m_Task) IExec->Signal( m_Task, sig );
}

void SPS_Thread::EntryStub( void )
{
    /* Warning! Do not use m_Task here!! */
    struct Task *task = IExec->FindTask( NULL );
    /* dynamic cast is not 100% safe here and only valid if tc_UserData contains some form
     * of an C++ object (! no POD data!) */
    SPS_Thread *thread_object = dynamic_cast<SPS_Thread*>((SPS_Thread*)task->tc_UserData);
    if (thread_object) {
        thread_object->ThreadEntry();
    }
}

void SPS_Thread::ThreadEntry( void )
{
    // lock the main, so we can savely terminate
    IExec->ObtainSemaphore( m_InternalScopeLock );
    // WARNING! Do not access m_Task form within the Entry function!!! Main process might clear this while we are running!!!
    struct Task* task = IExec->FindTask( NULL ); 

    _D("SPS_Thread::ThreadEntry( [%s@%08x] ) - In.\n", task->tc_Node.ln_Name, (uint32)task );

    // allocate resource if needed. (this is also available by the DOS.lib now)
    if ( OnEntry() ) {
        // signal that we are alive
        if ( m_Parent ) {
            IExec->Signal( m_Parent, 1 << m_InternalSignal );

            // run the thread
            Run();
        }

    } else {
        // we failed. Need to wakeup the parent and terminate
        if ( m_Parent ) {
            IExec->Signal( m_Parent, SIGBREAKF_CTRL_E );
        }
    }

    // and clean it up again - even if we've failed before
    OnExit( );
    _D("SPS_Thread::ThreadEntry( [%s@%08x] ) - Out.\n", task->tc_Node.ln_Name, (uint32)task );

    // unlock after we have freed everything after Run()
    IExec->ReleaseSemaphore( m_InternalScopeLock );
}

