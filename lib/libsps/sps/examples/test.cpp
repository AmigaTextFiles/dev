
#include <sps/sps_exception.h>
#include <sps/sps_thread.h>
#include <sps/sps_timer.h>
#include <sps/sps_message.h>
#include <sps/sps_hook.h>

#include <iostream>

#include <proto/exec.h>
#include <proto/utility.h>

/* make us a little bit bloated */
#include <string>
#include <iostream>

/////////////////////////////////////////////////////////////////
// threads & messages

/*! a demo message */
class MyMessage
{
public:
    MyMessage() {}

    /* create a new message */
    MyMessage( const char* msg )
        : m_Message( msg )
    {}
    /* copy the message */
    MyMessage( const MyMessage& msg )
        : m_Message( msg.m_Message.c_str() )
    {}

    /*! some message body */
    std::string m_Message;     
};

/* a demo thread */
class MyThread : public SPS_Thread
{
public:
    MyThread()
        : m_MessagePort( NULL )
        , m_Timer( NULL )
    {}
    virtual ~MyThread() {
    }

    /*! send a message to the thread */
    void SendMessage( const MyMessage* msg, bool sync = true );

protected:
    /*! set us up */
    virtual bool OnEntry();
    /*! an our main part */
    virtual void Run( );
    /*! clean us up  */
    virtual void OnExit();

protected:
    /*! message port to send thread command messages */
    struct MsgPort *m_MessagePort;
    /*! a SPS_Timer object */
    SPS_Timer      *m_Timer;
};

/* send a message to the thread */
void MyThread::SendMessage( const MyMessage* msg, bool sync /* = true */ )
{
    /* SPS_[A]SyncMessageT<BODY> have two ways to attach the data:
     * The method GetBody() returns a ref to the Body and you may modify the data directly.
     * Or, the second method is a copy c'tor which allows you to pass the body on to the
     * message c'tor. In this case, the message MUST support a copy-c'tor. */
    if ( m_MessagePort ) {
        /* we can send sync and async messages here */
        if ( sync ) {
            // a sync message can be created local on the stack. Send() will return
            // when the thread is done reading the message
            SPS_SyncMessageT<const MyMessage*> sps_msg;
            sps_msg.GetBody() = msg; // just use a pointer
            sps_msg.Send( m_MessagePort );


        } else {
            // in case of an async message, we return immediately but the thread
            // must delete the message - however, we must copy the body
            SPS_AsyncMessageT<MyMessage> *sps_msg = new SPS_AsyncMessageT<MyMessage>( *msg );
            sps_msg->Send( m_MessagePort );
        }
    }
}

/////////////////////////////////////////////////////////////////
// inside the thread context

/* we are in the thread context now! */
bool MyThread::OnEntry()
{
    bool result = false;
    try {
        m_MessagePort = static_cast<struct MsgPort*>(IExec->AllocSysObject(ASOT_PORT, NULL));
        if (!m_MessagePort) {
            throw Exc1( "Cannot create message port." );
        }

        m_Timer = new SPS_Timer;
        if ( !m_Timer ) {
            Throw1( "Bug! No SPS_Timer!" );
        }
        // if we reach that point, we have a valid thread
        result = true;

        std::cout << "MyThread::OnEntry" << std::endl;
    } catch ( SPS_Exception &ex ) {
        // the SPS_Exception is thread safe!
        ex.Warn();
    } catch ( ... ) {
        // always make sure we catch the unexpected!
    }
    return result;
}

void MyThread::OnExit()
{
    std::cout << "MyThread::OnExit()" << std::endl;

    /* we also must free the message port from within the thread */
    if ( m_MessagePort ) {
        IExec->FreeSysObject(ASOT_PORT, static_cast<void*>(m_MessagePort));
        m_MessagePort = NULL;
    }
    if ( m_Timer ) delete m_Timer;
    m_Timer = NULL;
}

void MyThread::Run()
{
    bool out = false;
    int32 sig;
    do {
        /* wait for a message to arrive. 5000 ms (5sec) timeout! Demonstrate what a timer can do */
        sig = m_Timer->WaitWithTimeout( SIGBREAKF_CTRL_E | SIGBREAKF_CTRL_C | (1 << m_MessagePort->mp_SigBit), 5000 );
        if ( (sig & SIGBREAKF_CTRL_E) == SIGBREAKF_CTRL_E ) {
            std::cout << "MyThread reveived a CTRL-E signal." << std::endl;
            IExec->SetSignal( 0, 0 );
            if ( m_Parent ) {
                /* bounce it back */
                IExec->Signal( m_Parent, SIGBREAKF_CTRL_E );
            }
        } else if ( sig & (1 << m_MessagePort->mp_SigBit) ) {
            std::cout << "MyThread reveived a message signal." << std::endl;
            // OK, that's interessting. We got an SPS_Message
            SPS_Message *_msg;
            while ( (_msg  = static_cast<SPS_Message*>( IExec->GetMsg( m_MessagePort ) )) != NULL ) {
                    
                if ( _msg->IsSync() ) { // OK, this one was synchronous ...

                    /* Now cast the message again */
                    SPS_SyncMessageT<MyMessage*> *msg = static_cast<SPS_SyncMessageT<MyMessage*>*>( _msg );
                    /* now we have to get the data from the message */
                    MyMessage *body = msg->GetBody();

                    /* do something with the body */
                    std::cout << "Synchronous Message received: " << body->m_Message << std::endl;

                    /* delay the response by 2secs */
                    m_Timer->Delay( 2000 ); 

                    /* and we can send it back */
                    msg->Reply();

                } else { // ... that one isn't

                    /* Now cast the message again */
                    SPS_AsyncMessageT<MyMessage> *msg = static_cast<SPS_AsyncMessageT<MyMessage>*>( _msg );
                    /* now we have to get the data from the message */
                    MyMessage &body = msg->GetBody(); // no need to copy, we own it!

                    /* do something with the body */
                    std::cout << "Asynchronous Message received: " << body.m_Message << std::endl;

                    /* no need to Reply, just free it */
                    delete msg;
                }
            }
        } else if ( (sig & SIGBREAKF_CTRL_C) == SIGBREAKF_CTRL_C ) {
            std::cout << "MyThread reveived a CTRL-C signal." << std::endl;
            out = true;
        } else {
            // got a timeout!
            if ( m_Parent ) {
                /* bounce it back */
                IExec->Signal( m_Parent, SIGBREAKF_CTRL_D );
            }
        }

    } while (!out) ;
}

//
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// hooks

class MyHook : public SPS_Hook
{
public:
    MyHook( bool sync = true )
        : m_Self( "MyHook" )
        , m_Sync( sync )
    { }
    virtual ~MyHook() {}

protected:
	/*! This is the virtual HookEntry */
	virtual int32 OnEntry(APTR object, APTR message);

    /* just some data */
    std::string m_Self;
    /* send a sync or async message ? */
    bool        m_Sync; 
};

int32 MyHook::OnEntry( APTR object, APTR message )
{
    const MyMessage *msg = static_cast<const MyMessage*>( message );
    MyThread *thread     = static_cast<MyThread*>( object );

    /* demonstrate that we have a valid this pointer here */
    std::cout << "Hook called! Hook<" << m_Self << "> with message '" << msg->m_Message << "'" << std::endl;

    thread->SendMessage( msg, m_Sync );

    return 0;
}

/////////////////////////////////////////////////////////////////
// the main code

int main( int argc, char** argv )
{
    /* a thread object - construct outside the try/catch block! */
    MyThread myThread;

    try {
        std::cout << "libsps++.a example" << std::endl;

        /* create and run the thread */
        if (myThread.Create( "SPS_ExampleThread" ) == NULL) {
            /* exit in case we couldn't start the thread */
            Throw1("Thread creation error!");
        }

        std::cout << "Press CTRL-E to send message to the thread." << std::endl;
        std::cout << "Press CTRL-F to send (forward) a signal to the thread." << std::endl;
        std::cout << "Press CTRL-C to quit." << std::endl;
        std::cout << "Press (Receive) CTRL-D from thread at timeout (5sec)." << std::endl;

        /* some local vars */
        int32 sig = 0;
        bool out  = false;
        bool send_sync = true;

        do {

            std::cout << std::flush;

            // Wait until someone terms us
            sig = IExec->Wait( SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_D | SIGBREAKF_CTRL_E | SIGBREAKF_CTRL_F );
            if ( (sig & SIGBREAKF_CTRL_C) == SIGBREAKF_CTRL_C ) {
                // our exit condition
                IExec->SetSignal( 0, 0 );
                std::cout << "Got CTRL-C. Exiting!" << std::endl;
                out = true;
            }
            else if ( (sig & SIGBREAKF_CTRL_E) == SIGBREAKF_CTRL_E ) {
                std::cout << "Got a CTRL-E signal. Send a message to the thread." << std::endl;
                /* this is nasty. But cool ;) A little bit of an overkill, I admit
                 * We let a the hook send a message to the thread. */
                MyMessage msg( "BounceBack!" );

                /* a demo hook - pretty fine to create it on a local scope */
                MyHook myHook(  send_sync );

                IUtility->CallHookPkt( static_cast<Hook*>( myHook ),   // do not de-ref myHook! Must call casting op!
                                       static_cast<APTR>( &myThread ), // the Object*
                                       static_cast<APTR>( &msg ) );    // the Msg
                send_sync = true;
            }
            else if ( (sig & SIGBREAKF_CTRL_F) == SIGBREAKF_CTRL_F ) {
               // rebound message. Let it bounce to the thread and back as a CTRL-E again
                std::cout << "Got a \"rebound\" message. Signal thread and get a CTRL-E back!" << std::endl;
                IExec->SetSignal( 0, 0 );
                /* we'll get a CTRL-E back, and switch to async message */
                send_sync = false;
                myThread.Signal( SIGBREAKF_CTRL_E  ); 
            }
            else if ( (sig & SIGBREAKF_CTRL_D) == SIGBREAKF_CTRL_D ) {
                // just a sinal from the thread
                IExec->SetSignal( 0, 0 );
                std::cout << "Got a CTRL-D signal. Most probably a timeout message from the thread!" << std::endl;
            }

        } while (!out) ;

        /* just show, that we can do exceptions ;) */
        Throw1( "Application Exiting!" );
    }
    catch ( SPS_Exception &ex ) {
        ex.Warn( "Note! We got an Exception.", "I know!" );
    }
    catch ( ... ) {
        std::cout << "Got unknown exception" << std::endl;
    }

    /* we destroy the thread - even if Create() would probably have failed. */
    myThread.Destroy();
    return 0;
}

