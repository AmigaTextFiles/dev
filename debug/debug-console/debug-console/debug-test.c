//( includes
#include <exec/types.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <string.h>
//)
//( BOOL printDebug(char * string)
// Use this debug-function in library code.
// It is fully reentrant IMHO.

BOOL printDebug(char * string)
{
    struct MsgPort * replyPort = CreatePort(NULL,0);
    if(replyPort)
    {
        struct consoleMsg
        {
            struct Message std;
            char * string;
        };

        struct MsgPort * port;
        struct consoleMsg msg;

        memset(&msg, 0, sizeof(struct consoleMsg));
        msg.std.mn_Length = sizeof(struct consoleMsg);
        msg.std.mn_Node.ln_Type = NT_MESSAGE;
        msg.std.mn_ReplyPort = replyPort;
        msg.string = string;

        Forbid();
        port=FindPort("debug-console");

        if(port)
        {
            PutMsg(port, (struct Message *)&msg);
            Permit();
            WaitPort(replyPort);
            GetMsg(replyPort);
            DeletePort(replyPort);
            return TRUE;
        }

        Permit();
        DeletePort(replyPort);
        return FALSE;
    }
}
//)
//( main
void main(void)
{
        printDebug("Hello?\n");
        printDebug("Does it work?\n");
        printDebug("Yes...\n");
}
//)
