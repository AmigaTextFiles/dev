/*!
 *  @addtogroup <sps>
 *  @{ pointdesign DOT com
 *
 *  Copyright (c) 2006 Jürgen Schober
 *  This code herein is freeware and provided AS IS.
 *  Use at your own risk. No waranty!
 */

/*!
 *  @file sps_message.h
 *
 *  exec message wrapper.
 *
 *  SPS_Messages allow you to simplify the usage of exec messages.
 *  - Asynchronous and synchronous messages are supported.
 *  - Two type of messages (T stands for Template): 
 *       - SPS_SyncMessageT<Body> and SPS_ASyncMesssageT<Body>
 *       - SPS_ExecMessageT<Body>
 *    The first type send the whole SPS_Message across a message port,
 *    while the second only sends the body. 
 *    In case of an SPS_ExecMessageT the body must be derived from a
 *    exec struct Message!
 *    Both provide a Send() method which allows you to send the message
 *    to a given port.
 *    SPS_Messages do not handle message ports, though! You application
 *    still needs to take care of those.
 * 
 *    SPS_Messages can be send sync or asyncronously. A sync message 
 *    can be send to an async port and vice versa.
 * 
 *    If an async message is send, the receiver must take care of
 *    deleting the message, a reply message is not necessary!
 * 
 *    A reply can be called uppon sync and async messages, however.
 *    The object itself makes sure the Reply is handled properly. 
 *
 *    A receiver can check if a message is sync or asyn thru the common
 *    interface method IsSync().  It is valid to cast a sync message into
 *    a async message, however, this is not recommended. 
 *    Both share the same interface.
 *  
 *  @author Jürgen Schober
 *
 *  @date
 *      - 08/21/2006 initial
 *
 *  @changes
 *      - 08/21/2006 -js-
 */
#ifndef SPS_MESSAGE_H_
#define SPS_MESSAGE_H_

#include <stdio.h>
#include <stdlib.h>

#include <proto/exec.h>
#include <proto/utility.h>

#include <exec/types.h>
#include <exec/ports.h>

#include <dos/dos.h>

/* a message object */
class SPS_Message : public Message
{
public:
    SPS_Message() 
    {
        IUtility->ClearMem( &mn_Node, sizeof(struct Node) );
        mn_Node.ln_Type = NT_MESSAGE;
        mn_Length       = sizeof( class SPS_Message );
        mn_ReplyPort    = NULL;
    }
    virtual ~SPS_Message() {}
           
    /*! send an SPS_Message to a given port. Called outside thread */    
    virtual void Send( struct MsgPort* port )
    {
        // an async message does not have reply port
        IExec->SetSignal( 0, 0 );
        IExec->PutMsg( port, this );
        // if sync message, wait until we get reply (a CTRL-F flushes the wait)
        if ( mn_ReplyPort ) {
            IExec->Wait( 1 << mn_ReplyPort->mp_SigBit | SIGBREAKF_CTRL_F );
        }
    }
    
    /* default message is async */
    virtual void Reply()
    {
        IExec->ReplyMsg( this );
    }

    bool IsSync() { return mn_ReplyPort != NULL; }
};

/* same as above, but a template which adds a reply and an abstract message body */
template< class BODY >
class SPS_SyncMessageT : public SPS_Message
{
protected:
    BODY m_Body;

public:

    SPS_SyncMessageT( BODY body )
        : SPS_Message()
        , m_Body(body)
    {
        // sync message adds a reply port
        mn_ReplyPort = static_cast<struct MsgPort*>(IExec->AllocSysObject(ASOT_PORT, NULL));
        // correct size
        mn_Length    = sizeof(class SPS_SyncMessageT<BODY>);
    }
    SPS_SyncMessageT() : SPS_Message()
    {
        // sync message adds a reply port
        mn_ReplyPort = static_cast<struct MsgPort*>(IExec->AllocSysObject(ASOT_PORT, NULL));
        // correct size
        mn_Length    = sizeof(class SPS_SyncMessageT<BODY>);
    }
    
    ~SPS_SyncMessageT()
    {
        if (mn_ReplyPort) {
            IExec->FreeSysObject(ASOT_PORT, static_cast<void*>(mn_ReplyPort));
        }
    }

     /*! get the message body and set/get values from it */
    inline BODY& GetBody() { return m_Body; }   
};

template< class BODY >
class SPS_AsyncMessageT : public SPS_Message
{
protected:
    BODY m_Body;

public:
    SPS_AsyncMessageT( BODY body )
        : SPS_Message()
        , m_Body( body )
    {
        // correct size
        mn_Length    = sizeof(class SPS_AsyncMessageT<BODY>);
    }

    SPS_AsyncMessageT() : SPS_Message()
    {
        // correct size
        mn_Length    = sizeof(class SPS_AsyncMessageT<BODY>);
    }
    
    /*! get the message body and set/get values from it */
    inline BODY& GetBody() { return m_Body; }   
};

template<class MESSAGE>
class SPS_ExecMessageT
{
public:
    MESSAGE m_Message; // must be struct Message++

    SPS_ExecMessageT()
    {
        IUtility->ClearMem( &m_Message, sizeof( MESSAGE ) );
        struct Message *msg = reinterpret_cast<struct Message*>(&m_Message);
        msg->mn_Node.ln_Type = NT_MESSAGE;
        msg->mn_Length       = sizeof( class SPS_Message );
        msg->mn_ReplyPort    = static_cast<struct MsgPort*>(IExec->AllocSysObject(ASOT_PORT, NULL));;
    }

    ~SPS_ExecMessageT()
    {
        struct Message *msg = reinterpret_cast<struct Message*>(&m_Message);
        if ( msg->mn_ReplyPort ) {
            IExec->FreeSysObject(ASOT_PORT, static_cast<void*>(msg->mn_ReplyPort));
        }
    }
    virtual void Send( struct MsgPort* port )
    {
        struct Message *msg = reinterpret_cast<struct Message*>(&m_Message);

        IExec->PutMsg( port, msg );
        if ( msg->mn_ReplyPort ) {
            IExec->Wait( 1 << msg->mn_ReplyPort->mp_SigBit );
        }
    }
};

#endif

