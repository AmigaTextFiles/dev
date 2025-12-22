/*
 * data.c  V2.1.03
 *
 * global data
 *
 * (c) 1990-1995 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Handler process data */
const struct TagItem HandlerProcessTags[]={
                                           NP_Entry,
                                            (ULONG) HandlerEntry,
                                           NP_CurrentDir,  NULL,
                                           NP_Name,
                                            (ULONG) "ToolManager Handler",
                                           NP_Priority,    0,
                                           NP_ConsoleTask, NULL,
                                           NP_WindowPtr,   NULL,
                                           NP_HomeDir,     NULL,
                                           TAG_DONE
                                          };

/* Ports */
struct MsgPort *LibraryPort=NULL;      /* Library <-> Handler IPC */
struct MsgPort *DummyPort=NULL;        /* For use with PutMsg/WaitMsg */
struct MsgPort *IDCMPPort=NULL;        /* IDCMP events */
struct MsgPort *TimerPort=NULL;        /* Timer events */
struct MsgPort *AppMsgPort=NULL;       /* Workbench App* events */
struct MsgPort *BrokerPort=NULL;       /* Commodities events */
struct MsgPort *ScreenNotifyPort=NULL; /* Workbench Close/Open events */
struct Entity  *LocalEntity=NULL;      /* Network events */

/* Misc. */
struct timerequest *deftimereq=NULL;
struct TMHandle *PrivateTMHandle=NULL;
CxObj *Broker=NULL;
struct PathList *GlobalPath=NULL;
struct Library *IFFParseBase;
char ToolManagerName[]="ToolManager";
char PrefsFileName[]=TMPREFSUSE;
char DefaultNoName[]="";
char DefaultDirName[]="SYS:";
char DefaultOutput[]="NIL:";
char DefaultPortName[]="PLAY";
