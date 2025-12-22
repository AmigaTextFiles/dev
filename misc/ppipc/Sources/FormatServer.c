/************************************************************
 *                                                          *
 *         Print Formatting Server (demo) for IPC           *
 *                                                          *
 *          -- Shared Library Version --                    *
 *                                                          *
 *                Pete Goodeve 89:3:29                      *
 *                                                          *
 *  [This module has only been compiled under Lattice;      *
 *   it will need some modification for Manx/Aztec;         *
 *   ... I'd be very grateful if someone would do the       *
 *   conversion...]                                         *
 *                                                          *
 *                                                          *
 *  This is a server to handle 'printf' conversion of       *
 *  int, float, string, and char valued message items.      *
 *  This saves space in other IPC modules that have a       *
 *  need for text output.  A single message results in      *
 *  a single output string, but there can be any number     *
 *  of items in the message, converted in sequence to       *
 *  ASCII -- either under the control of format specifier   *
 *  items, or in default format if these are omitted.       *
 *                                                          *
 *  The output string will by default be displayed in       *
 *  the server's window (thus other modules need not have   *
 *  their own).  Optional message items will redirect       *
 *  the output either to a supplied file handle (FILH) or   *
 *  to be returned as an item in the reply message (RETS).  *
 *                                                          *
 *  Only one message ID (aside from QUIT) is recognized     *
 *  by this server: CNVA ("CoNVert to Ascii").  See below   *
 *  for item IDs.  The program will terminate when it       *
 *  receives a QUIT message (items ignored), or when        *
 *  the number of clients drops from non-zero to zero       *
 *  (in other words it will not exit if there are initially *
 *  no clients).  It will also quit if it is sent a         *
 *  cntrl-C break.                                          *
 *                                                          *
 *                                                          *
 *  This is currently a completely "synchronous" server;    *
 *  it processes each message completely before returning   *
 *  it, and doesn't attempt to handle more than one at a    *
 *  time.  It doesn't send out any messages of its own      *
 *  either (i.e. it isn't a "manager"), but for the         *
 *  purpose of illustration some dummy manager type code    *
 *  has been included in the main loop, so you can see      *
 *  the sort of extensions that would be needed for that.   *
 *  The procreply() procedure -- here a dummy -- would      *
 *  have to dispatch each reply message that arrived to     *
 *  a suitable close-out procedure, then dispose of the     *
 *  message and any associated memory.                      *
 *                                                          *
 ************************************************************/

#ifdef DEBUG /* set this to show messages being received and so on */
#include "stdio.h"
#endif

#ifdef LATTICE
#if LATTICE_40 | LATTICE_50
#include "IPC_proto.h"
/* ...else (not recent Lattice) will need library linkage stubs (IPC.o) */
#endif
#endif

#include "IPC.h"

#include "exec/memory.h"
#include "libraries/dos.h"

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
    /* NOTE: the total formatted length for a PATS item
       must not be longer than 255 characters, to avoid crashing! */

#define PAT1  MAKE_ID('P','A','T','1')
    /* PATtern -- 1 item */
    /* NOTE: the total formatted length for a single PAT1 item
       must not be longer than 65 characters, to avoid crashing! */

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



struct IPCPort *import=NULL; /* this is the port we serve */

struct IPCMessage *imsg=NULL; /* we only handle one message at a time,
                                 so a global pointer is useful */

struct MsgPort *report=NULL; /* reply port: not actually  used here
                                -- skeleton code is shown */

/* should really include proto.h now for system procedures (next time...) */
char * AllocMem(int, ULONG);
void FreeMem(char *, int);
struct MsgPort * CreatePort(char *, int);
struct Message * Getmsg(struct MsgPort *);

void Cleanup();
void clearmarkers();
void outputstr(char *);
void procline();
void baditem(struct IPCItem *, ULONG);


int active = TRUE, /* when this goes FALSE, it's time to quit */
    replies = 0; /* number of replies to get back (...if we got replies!) */

ULONG reportsig = 0,  /* signal masks for ports */
      importsig = 0;

ULONG outputhnd; /* file handle from message (if any) will be held here */
struct IPCItem *retitem; /* item to contain return string (if any) */

int total_length, /* length computed for output string in pre-scan */
    alloc_length; /* length of allocated block (if any)  -- acts as flag */

char *linebuf, *bufptr; /* pointers (fixed and moveable) to output string */

int mesg_bad; /* flag to prevent further processing if a bad item found */
              /* (note that extraneous items are mostly just ignored) */


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
    int clients, oldclients = 0;
                   /* keeps track of number of current clients */
    ULONG sigset;  /* set to signals that woke up Wait() */

#ifdef TRACKCLIENTS /* define this to display current number of clients */
    char clrepstr[16];
#endif

    /* Before anything else, we need the IPC Library: */
    IPCBase = (APTR)OpenLibrary("ppipc.library",0);
    if (!IPCBase) {
        outputstr(
        "Couldn't find ppipc.library!\nHave you installed it in LIBS: ?\n");
        _exit(20);
    }

    report = CreatePort(NULL,0); /* I repeat... this is just a dummy here */
    if (!report) {
        outputstr("no space!!");
        Cleanup();
        return;
    }
    import = ServeIPCPort("Print_Format");
    if (!import) {
        outputstr("Print Server already exists ... exiting");
        Cleanup();
        return;
    }
    /* Get the signal bits for each port for later convenience: */
    /* (Note that, because we did not include IPCPorts.h, IPCPorts
        are identical to MsgPorts as far as the user is concerned;
        if we DID need IPCPorts.h, these statements would have to
        be changed appropriately.) */
    reportsig = 1<<report->mp_SigBit;
    importsig = 1<<import->mp_SigBit;

#ifdef DEBUG
    setnbf(stdout); /* so we can see output! (unbuffered) */
#endif


    /*
     *  The main loop:
     *  -- first we process any outstanding messages, looping until
     *  no more are found (procreply() always fails -- there are no
     *  replies in this program!).
     *  -- then we check the number of current clients: if they have
     *  all gone, we will exit.
     */
    do {
        while ( procimsg() || procreply()) ;  /* loop to satisfy messages */

        /*
         *  look at the number of clients (optional code included to display
         *  this).  The number returned by CheckIPCPort includes the server,
         *  so for convenience we subtract 1.
         *  Note that we set IPP_NOTIFY, so the process gets woken up each
         *  time the number of clients changes.
         */
        if ((clients = CheckIPCPort(import, IPP_NOTIFY) - 1)
                   != oldclients) {
#ifdef TRACKCLIENTS /* for demonstration purposes... */
            sprintf(clrepstr,
                    (clients == 1? "1 client\n" : "%d clients\n"), clients);
            outputstr(clrepstr);
#endif
            if (!clients) {
                active = FALSE; /* quit if everyone gone */
                ShutIPCPort(import); /* note: multiple calls don't hurt! */
                continue; /* so we clear out any messages that sneak in */
            }
            oldclients = clients;
        }

        /*
         *  Now wait for further messages, unless 'active' is FALSE
         *  ('replies' is always FALSE in this program).
         */
        if (active | replies) {
            /* Note that Wait() must be used rather than WaitPort()
               if we want to wake up on IPP_NOTIFY as well as messages */
            sigset = Wait(importsig | reportsig | SIGBREAKF_CTRL_C);
            if (sigset & SIGBREAKF_CTRL_C) {
                active = FALSE;
                ShutIPCPort(import); /* note: multiple calls don't hurt! */
                continue; /* so we clear out any messages that sneak in */
            }
        }
    } while (active | replies);
    /*** end of main loop ***/

    outputstr("Pserver terminating...\n");

    Cleanup();
}
/*** end of _main ***/


void Cleanup()
{
    if (import) LeaveIPCPort(import);
    if (report) DeletePort(report);
    CloseLibrary(IPCBase);
}


int itemn;  /* global item counter */
struct IPCItem *curitem; /* global item pointer */


/*
 *  Process incoming messages
 *  -- returns FALSE if there are none, otherwise TRUE.
 *  It recognizes the message ID and invokes the appropriate
 *  handling procedures.
 */
procimsg()
{
    if (!(imsg = (struct IPCMessage *) GetMsg(import))) return FALSE;
#ifdef DEBUG
    printf("item count = %d\n", imsg->ipc_ItemCount);
#endif
    switch (imsg->ipc_Id) {
       case CNVA:
               /*
                *   First do a scan of the message to determine how
                *   big a string space will be needed
                *   (and check for bad items):
                */
               curitem = imsg->ipc_Items; /* initialize the item pointer */
               for (itemn=imsg->ipc_ItemCount;
                    itemn && scanitem(); curitem++, itemn-- ) /* loop */;

               if (mesg_bad) break;

               /*
                *   Allocate the space needed:
                */
               if (!allocline()) break;

               /*
                *   Now actually process the items in the message:
                */
               curitem = imsg->ipc_Items; /* reset again */
               for (itemn=imsg->ipc_ItemCount;
                    itemn && procitem(); curitem++, itemn-- ) /* loop */;

               /*
                *   Finally terminate the output string and handle
                *   it as directed:
                */
               procline();
               break; /* end of CNVA processing */

       case QUIT:
               active = FALSE;
               ShutIPCPort(import);
               outputstr("Pserver got QUIT message...");
               break;

       default:
#ifdef DEBUG
               outputstr("got bad message");
#endif
               imsg->ipc_Flags |= IPC_NOTKNOWN;
               break;
    }

    if (mesg_bad)
        imsg->ipc_Flags |= IPC_NOTKNOWN | IPC_FAILED;
    ReplyMsg(imsg);
    clearmarkers(); /* reset things for the next message */
    return TRUE;
}


/*
 *  Skeleton procedure for handling replies (of which there are none
 *  in this program...).
 */
procreply()
{
    struct IPCMessage *rpmsg;
    struct IPCItem *item;

    if (!(rpmsg = (struct IPCMessage *)GetMsg(report))) return FALSE;
    if (rpmsg->ipc_Flags & IPC_NOTKNOWN) {
#ifdef DEBUG
        outputstr("\nServer didn't like this message...");
#endif
    }
    item = rpmsg->ipc_Items;
    /* message deletion and so on would go here... */
    replies--; /* This variable is incremented for each original message
                  generated by this program; the program will not exit
                  as long as it is non-zero */
    return TRUE;
}


/*
 *  Reset all global variables ready for next incoming message
 */
void clearmarkers()
{
    if (alloc_length) FreeMem(linebuf, alloc_length);
    linebuf = NULL;
    alloc_length = 0;
    total_length = 0;
    retitem = NULL;
    outputhnd = NULL;
    mesg_bad = FALSE;
}


/*
 *  Scan the current item to determine length of string it will generate.
 *  It also recognizes disposition control items (RETS, FILH) and sets up
 *  the required pointers.
 *  Subprocedures called may also check validity of item to be formatted
 *  (extraneous items not following a format specifier are simply ignored.)
 */
scanitem()
{
    char dummy[66]; /* this should be enough (!) */

#ifdef DEBUG
    debugitem(curitem,"scanitem:");
#endif

            switch (curitem->ii_Id) {
        case RETS:
                retitem = curitem;
                break;
        case FILH:
                outputhnd = (ULONG)curitem->ii_Ptr;
                break;
        case PATS:
                total_length += scanpatstring();
                return FALSE;   /* stop here */
        case PAT1:
                total_length += patternitem(dummy);
                break;
        case LINE:
        case TEXT:
        case STRG:
                total_length += strlen(curitem->ii_Ptr);
                break;
        case CHAR:
                total_length++;
                break;
        case INTG:
                total_length += cnvtitem(dummy, "%ld", curitem);
                break;
        case REAL:
                total_length += cnvtitem(dummy, "%g", curitem);
                break;

        default:
#ifdef DEBUG
                outputstr("got unknown item");
#endif
                /* ignore extraneous stuff */
                break;
            }
        return (!mesg_bad); /* stops here if message has failed */
}


/*
 *  Allocate space for complete output string.
 *  -- if the message has supplied a NON-NULL ii_Ptr in a RETS item,
 *  this will be used as the buffer, as long as the associated ii_Size
 *  is large enough (if it is not, the message will fail).  Otherwise
 *  space is allocated for the buffer.  If a NULL RETS item has been
 *  supplied, the buffer pointer will be returned there (otherwise the
 *  buffer will be freed again after output).
 *  It will of course also fail if there is no space for a buffer.
 *  Any failure returns FALSE, otherwise TRUE.
 */
allocline()
{
    int adj_length = total_length + 1; /* allow for terminator */
    if (retitem) { /* check for a RETS item first */
        if (retitem->ii_Ptr) { /* buffer supplied? */
            if (retitem->ii_Size > total_length) { /* big enough ? */
                linebuf = (char *)retitem->ii_Ptr; /* yes -- use it */
            }
            else { /* too small */
                baditem(retitem, IPC_FAILED);
                return FALSE;
            }
        }
        else { /* NULL pointer, so create some space */
            linebuf = AllocMem(adj_length, MEMF_PUBLIC);
            if (!linebuf) {
                baditem(retitem, IPC_FAILED);
                return FALSE;
            }
            else {
                retitem->ii_Ptr = (void *)linebuf;
                retitem->ii_Size = adj_length;
                retitem->ii_Flags = IPC_TRANSFER | IPC_MODIFIED;
                    /* flags are set to indicate client must dispose
                       of this block */
            }
        }
    }
    else { /* no RETS item, so use local buffer */
        linebuf = AllocMem(adj_length, MEMF_PUBLIC);
        if (!linebuf) {
            imsg->ipc_Flags |= IPC_NOTKNOWN | IPC_FAILED;
            return FALSE;
        }
        alloc_length = adj_length; /* used to free the message afterward */
    }
    bufptr = linebuf; /* initialize the output pointer */
    return TRUE;
}


/*
 *  Write the ASCII string for the current item to the output buffer.
 *  A suitable default format is used for items with no preceding
 *  format specifier.
 */
procitem()
{

#ifdef DEBUG
    debugitem(curitem,"procitem:");
#endif
            switch (curitem->ii_Id) {
        case RETS:
        case FILH:
                break;
        case PATS:
                bufptr +=cnvtpatstring(bufptr);
                return FALSE;  /* no further items allowed */
        case PAT1:
                bufptr += patternitem(bufptr);
                break;
        case LINE:
        case TEXT:
        case STRG:
                strcpy(bufptr, curitem->ii_Ptr);
                bufptr += strlen(curitem->ii_Ptr);
                break;
        case CHAR:
                *bufptr++ = (char) (curitem->ii_Ptr);
                    /* Lattice gives a warning here but does it OK */
                break;
        case INTG:
                bufptr += cnvtitem(bufptr, "%ld", curitem);
                break;
        case REAL:
                bufptr += cnvtitem(bufptr, "%g", curitem);
                break;

        default:
                /* ignore */
                break;
            }
        return TRUE;
}


/*
 *  Determine length (and validity) of multi-item format specifier
 */
scanpatstring()
{
    char *dummy;
    int len;
    dummy = AllocMem(256, 0L); /* temporary local storage */
    if (!dummy)
        return 256;  /* let allocline fail instead ! */
    len = cnvtpatstring(dummy);
    FreeMem(dummy, 256);
    return len;
}


/*
 *  Use the format in a PAT1 item to convert the following item.
 *  (Simply calls cnvtitem with suitable arguments.)
 */
patternitem(destptr)
char *destptr;
{
    char *fmtp;
    if (--itemn) {
        fmtp = (char *)curitem->ii_Ptr;
        return cnvtitem(destptr, fmtp, ++curitem);
    }
    else {
        baditem(curitem, IPC_FAILED);
        mesg_bad = TRUE;
        return 0;
    }
}


/*
 *  Convert a single value (in the current item) according to the
 *  format specified.  Output is to destptr; the size of the resulting
 *  string is returned.
 */
cnvtitem(destptr, fmtstr, item)
char *destptr, *fmtstr;
struct IPCItem *item;
{
    double doubleval;
    int len;

#ifdef DEBUG
    debugitem(item,"cnvtitem:");
#endif

            switch (item->ii_Id) { /* handle according to type */
        case LINE:
        case TEXT:
        case STRG:
                len = sprintf(destptr, fmtstr, item->ii_Ptr);
                break;
        case CHAR:
                len = sprintf(destptr, fmtstr, item->ii_Ptr);
                break;
        case INTG:
                len = sprintf(destptr, fmtstr, item->ii_Ptr);
                break;
        case REAL:
                doubleval = *(float *) &item->ii_Ptr;
                len = sprintf(destptr, fmtstr, doubleval);
                break;

        default:
                baditem(item, IPC_FAILED);
                mesg_bad = TRUE;
            }
        return len;
}


/*
 *  Convert items to ASCII according to format pattern in the current item.
 *  All the remaining items in the message must be values to satisfy the
 *  pattern.  (Note that REAL items aren't allowed, because they can't be
 *  passed to sprintf as 32-bit values).  Up to 10 items can be handled.
 *  The total length of the formatted string is returned.
 */
cnvtpatstring(destptr)
char *destptr; /* destination string buffer */
{
    char *fmtp;
    int i;
     ULONG p[10]; /* Storage for 10 values */

    fmtp = (char *)curitem->ii_Ptr; /* hold pointer to pattern string */
    for (i=0; i<10 && --itemn; i++ ) { /* process all the remaining items */
        ++curitem;
#ifdef DEBUG
    debugitem(curitem,"patstring:");
#endif
        switch (curitem->ii_Id) { /* everything the same except REAL */
        case LINE:
        case TEXT:
        case STRG:
        case CHAR:
        case INTG:
                p[i] = (ULONG)curitem->ii_Ptr; /* local copy */
                break;
        case REAL: /* can't pass a double this way!! */
        default:
                baditem(curitem, IPC_FAILED);
                mesg_bad = TRUE; /* can't continue */
                return 0;
        }
    }
    if (itemn) { /* more than 10 items found */
        baditem(++curitem, IPC_FAILED);
        mesg_bad = TRUE;
        return 0;
    }
    while (i<10) p[i++] = (ULONG) "\0"; /* not very adequate protection */

    /* Fortunately C allows us to pass unused arguments: */
    return sprintf(destptr, fmtp,
           p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
}


/*
 *  Process the assembled output string
 *  -- if the output handle has been supplied, the string will be sent there;
 *  if neither handle nor return slot has been supplied, the string will
 *  be output to the server's window.
 *  (If a return slot is present in the message, the string will be returned
 *  there in any case.)
 */
void procline()
{
    *bufptr = '\0'; /* Terminate the string first */
    if (outputhnd) Write(outputhnd, linebuf, total_length);
    else if (!retitem)
         Write(Output(), linebuf, total_length);
}


/*
 * Set error flags in an item and the message
 * (Note that this doesn't abort processing -- if this is needed,
 * the mesg_bad flag should also be set)
 */
void baditem(item, extraflags)
    struct IPCItem *item;
    ULONG extraflags;
{
    imsg->ipc_Flags |= IPC_CHECKITEM;
    item->ii_Flags |= IPC_NOTKNOWN | extraflags;
#ifdef DEBUG
    debugitem(item, "BAD:");
#endif
}


/* procedure to display string in window (avoids C I/O overhead) */

void outputstr(str) char *str;
{
    Write(Output(), str, strlen(str));
}

/************************************************************?

/* the following is only included if you want debugging output: */
#ifdef DEBUG
debugitem(item, str)
    struct IPCItem *item;
    char *str;
{
    ULONG icode[2];
    icode[0] = item->ii_Id;
    icode[1] = 0;
    printf("%s item %d code %s [%x] ptr %x flagged %x\n",
           str, item - imsg->ipc_Items,
           icode, *icode,
           item->ii_Ptr, item->ii_Flags);
}
#endif


