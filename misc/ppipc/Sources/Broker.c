/* Initial cut at a "Port Broker" for the LoadIPCPort function */
/* version 89:11:26 */

/*************************************************************
 *
 *  This is a simple broker program that determines which
 *  program should be loaded to service a requested IPCPort
 *  name.  When running, it is sent a message whenever a
 *  LoadIPCPort call in another program cannot find a served
 *  port of that name already active.  The broker looks the
 *  name up in its list (created at startup time for now);
 *  if it is found, there will be a CLI command associated
 *  with it, which the broker executes.  At the same time,
 *  the port is marked as "LOADING", so that it can accept
 *  messages.
 *
 *  The list pairing port names with commands is created
 *  from a file read when the broker starts.  (This simple
 *  version has no mechanism for adding or changing entries
 *  later, but such wouldn't be hard to add.)
 *  If the broker is run from the CLI, you can specify the
 *  file as an argument; if it is started from the WorkBench,
 *  you can put a tooltype 'FILE=filename' in the icon.
 *  If no file at all is specified, it will look for
 *  "IPC_Port_List" in 'S:'.  If it can't find a file, or it
 *  is empty, the broker will abort.
 *
 *  The file format is simply a series of single-line entries,
 *  each beginning with a port name ENCLOSED IN QUOTES, followed
 *  by a space and then the CLI command to be executed that will
 *  result in that port being served. (A full command pathname is
 *  generally required -- unless the command is in 'C:'; full
 *  paths are always required for argument files.) Any line
 *  that doesn't begin with a quote (") is simply skipped,
 *  so you can include comments if you want.
 *  [This format was chosen simply  because it was easy to
 *  implement -- other brokers might define quite a different
 *  one.  Multiple line commands, or wild card matching, might
 *  be allowed, for instance.]
 *
 *  Note that -- because of Execute()'s limitations -- there
 *  is NO way for the broker to know if the command has actually
 *  been successfully launched or not.  So it is possible that
 *  a LOADING port might never actually do so!
 *
 *  Note also that -- for similar reasons -- all command output
 *  is directed to NIL: when the broker is started from an icon.
 *  It should be possible to direct it to the window Lattice
 *  kindly opens for us, but this is not straightforward.
 *  (To terminate the broker, type ctrl-C to its window.)
 *
 *                         * * * *
 *
 *  [This program has only been compiled under Lattice 5.04]
 *
 *************************************************************/

#include "IPCPorts.h"
#include "IPC_proto.h"
#include "IPC.h"

#include <proto/exec.h>
#include <proto/dos.h>

#include <exec/types.h>
#include <exec/exec.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>
#include <workbench/icon.h>

#include <stdio.h>

#include <exec/memory.h>
#include <exec/tasks.h>
#include <libraries/DOS.h>

#define  SOL(s)  ((LONG)sizeof(s))

#define IPPL MAKE_ID('I','P','P','L')
#define PORT MAKE_ID('P','O','R','T')

ULONG IPCBase = NULL;

struct IPCPort *brokerport;
struct IPCMessage *imsg=NULL;

void baditem(struct IPCItem *, ULONG);
void outputstr(char *);

struct Task * FindTask(char *);

void Cleanup();

struct portref {
    struct portref * next;
    int flags;
    char * portname;
    char * command;
} * portlist, * endlist;

ULONG bportsig = 0;  /* signal masks for port */

int active = TRUE;

char * bfilename = "S:IPC_Port_List";


int newportref(char * line)
{
    char * cp;
    struct portref * ref;
    if (*line != '"') return TRUE; /* required for now (just skip if not)*/
    for (cp=line+1; *cp && *cp != '"'; cp++) {/* loop*/};
    if (!*cp) return TRUE; /* just skip a bad line... */
    *cp = '\0'; /* cut the line in two */
    while (*++cp == ' ' || *cp == '\t') {/*loop*/};
    if (!(ref = calloc(1, sizeof(struct portref)))) return FALSE;
    if (!(ref->portname = malloc(strlen(line+1)+1))) return FALSE;
    if (!(ref->command = malloc(strlen(cp)+1))) return FALSE;
    strcpy(ref->portname, line+1);
    strcpy(ref->command, cp);
    if (endlist) endlist->next = ref;
    else portlist = ref;
    endlist = ref;
    return TRUE;
}


int getportlist(char * filename)
{
    FILE * bfile;
    char line[256];
    line[255] = '\0';   /* just in case...*/
    bfile = fopen(filename, "r");
    if (!bfile) return FALSE;
    while (fgets(line, 255, bfile) && newportref(line)) {/*loop*/};
    fclose(bfile);
    return portlist ? TRUE : FALSE; /* reading nothing regarded as error */
}

ULONG dosout;

/**************************/

LONG IconBase;

extern struct WBStartup *WBenchMsg;
struct DiskObject *iconobj, *GetDiskObject();

int readWB()
{
    char **toolarray, *FindToolType();
    char * portliststring;
    struct WBArg *argptr;

    dosout = Open("NIL:", MODE_OLDFILE);    /* redirect to black hole */

    if (!WBenchMsg)
      return FALSE;

    IconBase = OpenLibrary(ICONNAME,1);
    if (!IconBase)
      return FALSE; /* just soldier on...*/

    argptr = WBenchMsg->sm_ArgList;

    if (!(iconobj = GetDiskObject(argptr->wa_Name)))
      return FALSE;

    toolarray = iconobj->do_ToolTypes;

    if (portliststring = FindToolType(toolarray,"FILE"))
        bfilename = portliststring;

    return TRUE;
}

/**************************/




void main(int argc, char ** argv)
{
    ULONG sigset;

    dosout = Output(); /* unless WorkBench */

    if (!argc) readWB();
    else if (argc > 1)  /* use passed filename */
        bfilename = argv[1];

    IPCBase = OpenLibrary("ppipc.library",0);
    if (!IPCBase) {
        outputstr("couldn't find IPC Library -- TTFN...\n");
        exit(20);
    }

    if (!getportlist(bfilename)) {
        outputstr("couldn't read the port list\n");
        Cleanup();
        exit(20);
    }

    brokerport = ServeIPCPort("PortBrokerPort");
    if (!brokerport) {Cleanup(); _exit(11);}
    bportsig = 1<<brokerport->ipp_Port.mp_SigBit;
    outputstr("Opened 'PortBrokerPort'\n");


    do {
        while ( procimsg() ) ;    /* loop */
        if (active) {
            sigset = Wait(bportsig | SIGBREAKF_CTRL_C);
            if (sigset & SIGBREAKF_CTRL_C) {
                active = FALSE;
                ShutIPCPort(brokerport);
                continue; /* so we clear out any messages that sneak in */
            }
        }
    } while (active);
    outputstr("Broker terminating...\n");

    Cleanup();
}


void cleanportlist()
{
    struct portref * ref;
    while (portlist) {
        ref = portlist;
        portlist = ref->next;
        free(ref->portname);
        free(ref->command);
        free(ref);
    }
    portlist = endlist = NULL;  /* in case of future developments */
}

void Cleanup()
{
    cleanportlist();
    if (brokerport) LeaveIPCPort(brokerport);
    if (iconobj) FreeDiskObject(iconobj);
    if (IconBase) CloseLibrary(IconBase);
    CloseLibrary(IPCBase);
    if (dosout && dosout != Output()) Close(dosout);
}


procimsg()
{
    struct IPCItem *item;
    if (!(imsg = (struct IPCMessage *) GetMsg(brokerport))) return FALSE;
    item = imsg->ipc_Items;
    if (imsg->ipc_Id == IPPL && item->ii_Id == PORT
        && loadport(item->ii_Ptr)) /* everything OK */;
    else imsg->ipc_Flags |= IPC_NOTKNOWN;
    ReplyMsg(imsg);
    return TRUE;
}


void baditem(item, extraflags)
    struct IPCItem *item;
    ULONG extraflags;
{
    imsg->ipc_Flags |= IPC_CHECKITEM;
    item->ii_Flags |= IPC_NOTKNOWN | extraflags;
}

void outputstr(str) char *str;
{
    Write(dosout, str, strlen(str));
}


/*
 *  loadport(portptr)
 *
 *  -- actually initiates the loading procedure.
 *      returns TRUE if successful, otherwise FALSE.
 */

loadport(port) struct IPCPort *port;
{
    struct portref * pr = portlist;
    char * pname = port->ipp_Name;
    outputstr("Looking up server for port '");
    outputstr(pname);
    for (pr=portlist; pr && strcmp(pr->portname, pname); pr = pr->next)
         {/*loop*/};
    if (pr) {   /* we have a match */
        port->ipp_Flags |= IPP_LOADING;
        Execute(pr->command, 0, dosout);    /* out to NIL: if WB */
        outputstr(" -- OK\n");
        return TRUE;
    }
    else {
        outputstr(" -- Not Found!\n");
        return FALSE;
    }
}


/****************************************************************/


