//( includes
#include <exec/types.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <string.h>
//)

// Use this program to watch the debug-output sent.

//( globals

struct MsgPort * publicPort;
struct consoleMsg
{
    struct Message msg;
    char * string;
};
//)
//( Reply(struct consoleMsg * msg)
void Reply(struct consoleMsg * msg)
{
    if(msg->msg.mn_ReplyPort)               //  possible. Otherwise sender won't be able
        ReplyMsg((struct Message*) msg);        //  to reuse that message till we're done with it !
}
//)
//( void msgLoop(void)
void msgLoop(void)
{
    ULONG pubSig = 1<<publicPort->mp_SigBit;
    ULONG userSig = SIGBREAKF_CTRL_C;
    struct consoleMsg * msg;
    ULONG signals;

    BOOL finito=FALSE;
    while(!finito)
    {
        signals = Wait(pubSig | userSig);
        //( CTRL_C
        if(signals & userSig)
        {
            PutStr("Ctrl-C\n");
            finito=TRUE;
        }
        else
        // debug-printing
        if(signals & pubSig)
        {
            while(msg=(struct consoleMsg *)GetMsg(publicPort)) // When it does we must get ALL
            {                                                  //  messages queued at that port
                if(msg->string!=NULL)
                    PutStr(msg->string);
                ReplyMsg((struct Message*)msg);                        
            }
        }
    }
}
//)
//( init
BOOL init(void)
{
    publicPort = CreatePort("debug-console",0);
    if(publicPort)
        return TRUE;
    else
        return FALSE;
}
//)
//( cleanup
void cleanup(void)
{
    if(publicPort)
        DeletePort(publicPort);
}
//)
//( main
void main(void)
{
        if(init())
        {
                PutStr("Debug-console is ready. Public portname is 'debug-console'\n");
                msgLoop();
                cleanup();
        }
}
//)

