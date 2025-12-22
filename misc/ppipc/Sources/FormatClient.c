/************************************************************
 *                                                          *
 *        Minimal Print server Client Demo for IPC          *
 *                                                          *
 *          -- Shared Library Version --                    *
 *                                                          *
 *                Pete Goodeve 89:11:27                     *
 *                                                          *
 *  [This module has only been compiled under Lattice;      *
 *   it will need some modification for Manx/Aztec;         *
 *   ... I'd be very grateful if someone would do the       *
 *   conversion...]                                         *
 *                                                          *
 *                                                          *
 *  This is a simple test module for the "Print Format"     *
 *  server.  When you type the return key, it generates     *
 *  a message with a set of items in various formats,       *
 *  and sends it to the print server. (For test purposes    *
 *  the items are fixed.)  If you simply type a return,     *
 *  the formatted string generated from the message is      *
 *  displayed in the print server's own window; if you      *
 *  type an 'F' before the return, a file handle to this    *
 *  Client program's console window is passed in the        *
 *  message and the string will be output to this instead;  *
 *  if you type an 'M' before the return, the string will   *
 *  be passed back in the reply message and again shown     *
 *  in the Client's console window.                         *
 *                                                          *
 *  Typing 'Q' will send a 'QUIT' message to the server     *
 *  instead of a print request.  To exit the client         *
 *  program type an 'end-of-file' (cntrl-'\'); the          *
 *  print server is currently programmed to exit also       *
 *  when there are no running clients left.                 *
 *                                                          *
 *  It is a simple "synchronous" client: when it sends a    *
 *  message it waits for the reply before continuing        *
 *  (unlike others that may continue with other activities  *
 *  while the server is processing a message).  The main    *
 *  loop is simple:                                         *
 *                                                          *
 *          Wait for keyboard command                       *
 *          Send message                                    *
 *          Wait for reply                                  *
 *          Display string from reply if supplied           *
 *          Loop to wait for keyboard again.                *
 *                                                          *
 *                                                          *
 ************************************************************/

#ifdef LATTICE
#if LATTICE_40 | LATTICE_50
#include "IPC_proto.h"
/* ...else (not recent Lattice) will need library linkage stubs (IPC.o) */
#endif
#endif

#include "IPC.h"
#include "exec/memory.h"

#define LINESZ 120
#define SHOWREAL 1

/*
 *  Define the ID codes recognized by the print format server
 *
 *  (MAKE_ID is defined in IPC.h)
 */

/* Message IDs: */
#define CNVA  MAKE_ID('C','N','V','A')
    /* CoNVert to Ascii */
#define QUIT  MAKE_ID('Q','U','I','T')

/* Item IDs: */
#define RETS  MAKE_ID('R','E','T','S')
    /* RETurn String */

#define FILH  MAKE_ID('F','I','L','H')
    /* FILe Handle */


#define PATS  MAKE_ID('P','A','T','S')
    /* PATtern String */

#define PAT1  MAKE_ID('P','A','T','1')
    /* PATtern -- 1 item */

#define LINE  MAKE_ID('L','I','N','E')
    /* indicates a complete line of text -- omitting newline */

#define TEXT  MAKE_ID('T','E','X','T')
    /* Text block -- may include newlines */

#define STRG  MAKE_ID('S','T','R','G')
    /* general non-specific ASCII STRinG */

    /* The above three categories are treated identically by Pserver
       -- they may have distinct meanings to other servers */

#define CHAR  MAKE_ID('C','H','A','R')
    /* A single character in L.S byte of ii_Ptr */

#define INTG  MAKE_ID('I','N','T','G')
    /* A 32-bit INTeGer in ii_Ptr */

#define REAL  MAKE_ID('R','E','A','L')
    /* A 32-bit floating point value in ii_Ptr (care in conversion!) */


/*******************
rather than the above if you prefer, with Lattice 4.0 you can simply
use 4-character constants as in the following (compile with the -cm option):

#define CNVA 'CNVA'
#define QUIT 'QUIT'

#define RETS 'RETS'
#define FILH 'FILH'

#define PATS 'PATS'
#define PAT1 'PAT1'
#define LINE 'LINE'
#define TEXT 'TEXT'
#define STRG 'STRG'
#define CHAR 'CHAR'
#define INTG 'INTG'
#define REAL 'REAL'
*********************/

APTR IPCBase = NULL;

struct IPCPort *port=NULL; /* will point to server port */
struct MsgPort *rport=NULL; /* where we get our replies */
struct IPCMessage *imsg=NULL; /* this one message is used repeatedly */

struct MsgPort * CreatePort(char *, int);
ULONG Output();

void Cleanup();
void outputstr(char *);


/***************************
 *
 *  Main program entry point:
 *
 *  -- Note that to save overhead we use '_main'; you should also compile
 *  (under Lattice) using the -v switch, to suppress stack checking and
 *  the associated baggage.
 *
 *  We avoid using any C level I/O also -- just AmigaDOS calls, so we
 *  dont need <stdio.h>.
 */

void _main()
{
    struct IPCItem *item, *item0; /* pointers to access message items */

    int count=0; /* dummy value used to stuff into message */
    float realcount=0.0; /* -- ditto */

    char tbuf[22]; /* keyboard input dumped in here */

    /* Before anything else, we need the IPC Library: */
    IPCBase = (APTR)OpenLibrary("ppipc.library",0);
    if (!IPCBase) {
        outputstr(
        "Couldn't find ppipc.library!\nHave you installed it in LIBS: ?\n");
        _exit(20);
    }

    /* First we set up our ports: */

    port = LoadIPCPort("Print_Format"); /* try the Port Broker first */
    if (!port)  /* gimmicked so it can be used with or without Broker */
        port = GetIPCPort("Print_Format");
    if (!port) {Cleanup(); _exit(21);}

    rport = CreatePort(NULL,0);
    if (!rport) {Cleanup(); _exit(21);}

    /* ... then make a message block */
    imsg = CreateIPCMsg(20,0,rport); /* large enough for playing with... */
    if (!imsg) {Cleanup(); _exit(22);}

    item0 = &imsg->ipc_Items[0]; /* a convenient permanent reference */


    /* The main program loop:
     * -- continues until told to quit by end-of-file (ctrl-\)
     */
    while (1) {
        item = item0; /* reset item pointer */
        imsg->ipc_Id = CNVA; /* only message ID needed (except QUIT) */
            /*
             * Initially we assume that the first item will be a slot
             * in which the server will return the formatted string.
             * This will be overwritten if another option is chosen
             */
        item->ii_Id = RETS;
        item->ii_Ptr = NULL; /* The server will provide the data block */
        item->ii_Size = 0;
        item->ii_Flags = imsg->ipc_Flags = 0;

        /* get keyboard input (terminated by return): */
        /* E-O-F returns a length of zero, causing break from loop */
        if (Read(Input(), tbuf, 21) <= 0) break;

        /*
         * decode first character of input to decide action
         *  (sorry about the crudity... but it suffices)
         */
        switch(*tbuf) {
        case 'Q':   /* Send a QUIT message */
        case 'q':
        case '.':   imsg->ipc_Id = QUIT; /* all items are ignored */
                    break;

        case 'm':   /* Request string in reply Message */
        case 'M':
        case '?':   item++; /* leave default RETS in place */
                    item->ii_Id = STRG; /* Add in a string item to
                                           distinguish displayed line */
                    item->ii_Ptr = (void *)("Returned: ");
                    item++;
                    break;

        case 'F':   /* Pass File handle to this console */
        case 'f':
        case '^':   item->ii_Id = FILH; /* overwrites RETS */
                    item++->ii_Ptr = (void *)Output(); /* the file handle */
                    break;

        default:    /* anything else just overwrites RETS with output
                       items, so string appears on Pserver window */
                    break;
        }

        /*
         * The rest of the setup code simply stuffs a few values of
         * different types into successive items -- rearrange to your
         * own satisfaction...
         * NOTE that we haven't bothered to put the strings into public
         * memory, contrary to the suggestions of the IPC standard
         *  [For shame, Peter!] but this is really only a restriction
         * that needs to be observed for general messages that may have
         * a destination outside the ken of the sender (or for a future
         * machine that has process-private memory).  This isn't relevant
         * to such a simple test program, so we've simplified things.
         * At the same time, the ii_Size field for the string items is
         * set to ZERO, indicating that the "data block" is Read-Only
         * as far as the server is concerned.
         */
        item->ii_Id = STRG; /* A short string to start out with */
        item->ii_Ptr = (void *)("Test line...");
        item++;
        item->ii_Id = PAT1; /* then a format specifier for a value */
        item->ii_Ptr = (void *)(" #%3d");
        item++;
        item->ii_Id = INTG; /* the integer value to be formatted */
        item->ii_Ptr = (void *)(count++); /* (just a sequential count...) */
        item++;
        item->ii_Id = STRG; /* another string... */
        item->ii_Ptr = (void *)("... value=");
        item++;
        item->ii_Id = REAL; /* A float value in default format */
            /* note the messy conversion to get it into the ii_Ptr field */
        *(float *) &item->ii_Ptr = (realcount += 1.234);
        item++;
        item->ii_Id = CHAR; /* and a newline character to end the section */
        item->ii_Ptr = (void *)('\n');
        item++;
        item->ii_Id = PATS; /* Multi item format specifier */
        item->ii_Ptr = (void *)("formatted line #%2d %s\n");
        item++;
        item->ii_Id = INTG;
        item->ii_Ptr = (void *)(count++);
        item++;
        item->ii_Id = STRG;
        item->ii_Ptr = (void *)((count & 3) ? "..." : "tick...");
        /* no more items allowed after PATS is satisfied */

        /* set actual ItemCount into message: */
        imsg->ipc_ItemCount = item - item0 + 1;

        /* Send the message (if possible) */
        if (!PutIPCMsg(port, imsg)) {
                outputstr("No server!\n");
                continue; /* don't wait for a reply that won't come! */
        }
        /* Wait at the reply port: */
        WaitPort(rport);
        GetMsg(rport);  /* we assume we know what's there! */
        if (imsg->ipc_Flags & IPC_NOTKNOWN)
            outputstr("Server barfed\n");
        /*
         * If we asked for a return string, display it in our
         * window, then dispose of the block of memory passed to us
         * by the server:
         */
        if (item0->ii_Id == RETS) {
            Write(Output(), item0->ii_Ptr, strlen(item0->ii_Ptr));
            /* note that we DON'T use the ii_Size value above!
               There is no guarantee that it is exactly the size of
               the string. */
            FreeMem(item0->ii_Ptr, item0->ii_Size);
        }
    }
    /*** end of main loop ***/

    Cleanup();
}


void Cleanup()
{
    if (port) DropIPCPort(port);
    if (rport) DeletePort(rport);
    if (imsg) DeleteIPCMsg(imsg);
    CloseLibrary(IPCBase);
}


void outputstr(str) char *str;
{
    Write(Output(), str, strlen(str));
}

