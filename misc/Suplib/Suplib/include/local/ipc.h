
#ifndef LOCAL_IPC_H
#define LOCAL_IPC_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_PORTS_H
#include <exec/ports.h>
#endif

typedef struct MinNode	MNODE;
typedef struct MsgPort	PORT;

#define IPCMSG	struct _IPCMSG
#define IPCPORT struct _IPCPORT

IPCPORT {
    PORT    Port;
    long    Flags;	/*  Open flags for port */
};

IPCMSG {
    struct Message   Msg;	 /*  EXEC message header */
    MNODE   ANode;	/*  Application node	*/
    long    Error;	/*  optional error code */
    IPCPORT *ToPort;
    void    (*Confirm)();

    APTR    TBuf;	/*  Sender Command	*/
    long    TLen;
    long    TFlags;

    APTR    RBuf;	/*  Receiver Reply	*/
    long    RLen;
    long    RFlags;
};

#define IF_NOCOPY   0x0001	/*  Do allocate a copy of the buffer	  */
#define IF_ALLOC    0x0002	/*  Message was allocated		  */
#define IF_NOTFND   0x0004	/*  Command not found	       (+IF_ERROR)*/
#define IF_ERROR    0x0008	/*  Error occured			  */

#define IF_NOAPP    0x0020	/*  Req. Application not found (+IF_ERROR)*/
#define IF_GLOBAL   0x0040	/*  global message... sent to all servers */
#define IF_ALLOCMSG 0x8000	/*  IPCMSG structure was allocated	  */

#define PERR_NOMEM  1		/*  Ran out of memory parsing command	  */
#define PERR_NOVAR  2		/*  Could not find string variable	  */

extern __stdargs int	ParseCmd	ARGS((char *, char **, char *((*)()), char *((*)()), long *, long));
extern __stdargs void	FreeParseCmd	ARGS((char **));
extern __stdargs IPCPORT *OpenIPC   ARGS((char *, long));
extern __stdargs void	CloseIPC    ARGS((IPCPORT *));
extern __stdargs IPCMSG *SendIPC    ARGS((char *, APTR, long, long));
extern __stdargs IPCMSG *SendIPC2   ARGS((char *, IPCMSG *));
extern __stdargs void	DoIPC2	    ARGS((char *, IPCMSG *, void (*)(), PORT *));
extern __stdargs void	ReplyIPC    ARGS((IPCMSG *, APTR, long, long));
extern __stdargs void	FreeIPC     ARGS((IPCMSG *));
extern __stdargs APTR	Duplicate   ARGS((APTR, long));


#endif

