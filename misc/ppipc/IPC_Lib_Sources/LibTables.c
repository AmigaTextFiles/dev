/* IPC Library Initialization tables in C format 89:4:17 */
/* should be compiled with the -b0 option to avoid merging */

#include <exec/types.h>
#include <exec/libraries.h>

#define LIBPOSSIZE (sizeof(struct Library))
/*      ^^^ adjust to take into account any reserved data area */
/*          (none at the moment -- data kept in global storage) */

char libName[] = "ppipc.library";
char libId[] = "PPIPC version 2.2 89:04:17\n";

/* These can be used by libInitFunc to reset values in Node: */
UWORD   libVersion = 2;
UWORD   libRev = 2;

/*** Note that it may not be possible to keep libVersion/libRev in sync with
    the "release" version (in e.g. libId and IPC.h), as libVersion must be
    incremented each time a new function is added to a release, for example.
    (As far as I know, libRev is not accessed by the system.) ***/

extern libOpen(), libClose(), libExpunge(), libExtFunc();

extern  FindIPCPort(),
        GetIPCPort(),
        UseIPCPort(),
        DropIPCPort(),
        ServeIPCPort(),
        ShutIPCPort(),
        LeaveIPCPort(),
        CheckIPCPort(),
        PutIPCMsg(),
        CreateIPCMsg(),
        DeleteIPCMsg(),
        LoadIPCPort();
        MakeIPCId();
        FindIPCItem();




ULONG * FuncTable[] = {
        ((ULONG *)&libOpen),
        ((ULONG *)&libClose),
        ((ULONG *)&libExpunge),
        ((ULONG *)&libExtFunc),

        ((ULONG *)&FindIPCPort),
        ((ULONG *)&GetIPCPort),
        ((ULONG *)&UseIPCPort),
        ((ULONG *)&DropIPCPort),
        ((ULONG *)&ServeIPCPort),
        ((ULONG *)&ShutIPCPort),
        ((ULONG *)&LeaveIPCPort),
        ((ULONG *)&CheckIPCPort),
        ((ULONG *)&PutIPCMsg),
        ((ULONG *)&CreateIPCMsg),
        ((ULONG *)&DeleteIPCMsg),
        ((ULONG *)&LoadIPCPort),
        ((ULONG *)&MakeIPCId),
        ((ULONG *)&FindIPCItem),
    /* Spare slots kept open to avoid accidents: */
        ((ULONG *)&libExtFunc),
        ((ULONG *)&libExtFunc),
        ((ULONG *)&libExtFunc),
        ((ULONG *)&libExtFunc),
        (ULONG *)0xFFFFFFFF
    };

extern DataTable[];     /* in LibTag.a -- Assembly is more convenient here */
extern libInitFunc();

ULONG * libInitTable[] = {
        (ULONG *)LIBPOSSIZE,
        (ULONG *)&FuncTable,
        (ULONG *)&DataTable,
        (ULONG *)&libInitFunc
    };


ULONG libSize = LIBPOSSIZE; /* for testing convenience */


