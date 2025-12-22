#ifndef LIBRARIES_DEBUG_H
#define LIBRARIES_DEBUG_H 1
/****************************************************************************

$Source: MASTER:include/libraries/debug.h,v $
$Revision: 3.1 $
$Date: 1997/02/02 09:49:41 $

Public include for debug.library and it's clients.  DebugBase is currently
public because debug.library needs to be extensible.  Since the mechanisms
for that are not yet in place, we just expose the internals.  What needs to
be private, and what needs to be public hasn't been decided yet.

In other words, anything you write relying on this information will
probably break in the future.

****************************************************************************/
#ifndef  EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif
#ifndef  EXT_ASCII_H
#include <ext/ascii.h>
#endif
#ifndef  RESOURCES_SERIAL_H
#include <resources/serial.h>
#endif


/* The History struct is used to store previously entered Commands. */

#define DBG_CMDLEN      80                   /* max length of a command line */
#define DBG_HISTLEN     8                    /* length of history array */

struct History
   {
   WORD   size;                              /* number of  commands in history */
   WORD   next;                              /* index to put next command */
   WORD   current;                           /* index of current command */
   char   lines[DBG_HISTLEN][DBG_CMDLEN];    /* storage for command lines */
   };


/* The Command structure is simply a name/code ptr pair. */

struct Command
   {
   char *name;                            /* name of command */
   void (*code)(int argc, char *argv[]);  /* entry point */
   };


/* DebugBase is debug.library's extended library structure. */

struct DebugBase
   {
   struct Library lib;           /* base library structure */
   LONG   seglist;               /* our loaded self */
   struct History history;       /* command history */
   struct Context *context;      /* user context when entering Crash() or Debug() */
   BOOL   deadend;               /* TRUE if Crash(), FALSE if Debug() */
   char   *entry;                /* message on entry */
   char   *prompt;               /* command line prompt */
   BYTE   port;                  /* current port number for terminal I/O */
   BYTE   auxport;               /* current port number for auxiliary output */
   struct List       commands;   /* list of ANodes pting to Command arrays */
   struct BootTable *bootTable;  /* debug.library uses some BootTable info */
   BOOL   tagstep;               /* TRUE means pause at BootMsg() */
   UWORD  bpvector;              /* vector (TRAP n) used to service breakpoints */
   UWORD  bpcode;                /* value poked in for a breakpoint (TRAP n) */
   UWORD  itnestcnt;                  /* InitTerminal nest count */
   struct SerialSettings ss_context;  /* storage for context's serial settings */
   };


/* Keycodes used. */

#define DKC_RETURN      ASCII_CR
#define DKC_BACKSPACE   ASCII_BS
#define DKC_UP          0x0C           
#define DKC_DOWN        0x0A
#define DKC_ESC         ASCII_ESC
#define DKC_BREAK       ASCII_ETX

#define DKC_ENTER       ASCII_CR


#endif
