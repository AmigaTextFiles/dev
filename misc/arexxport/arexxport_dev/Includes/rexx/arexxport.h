#ifndef REXX_AREXXPORT_LIBRARY_H
#define REXX_AREXXPORT_LIBRARY_H

/*************************************************************************/
/*                    ArexxPort.library header file                      */
/*                Andrew Cook     Copyright (c)1995-1996                 */
/*                                                                       */
/*           $ver: arexxport.library (header) 37.21 (02.5.96)            */
/*************************************************************************/

#include <exec/types.h>
#include <exec/lists.h>
#include <exec/libraries.h>
#include <utility/tagitem.h>

/*
** Some constants
*/

#define REXX_PORT_LEN   10
#define REXX_MAX_ARGS   16

/*
** Macro to return the sigbit used by a
** given port.
*/

#define AREXX_SIGBIT( x )  (x)->Port->mp_SigBit

/*
** Macro that returns TRUE if a macro has been
** launched by the port and not yet returned.
*/

#define MACROPENDING( x ) ( (x)->Invocations.mlh_TailPred != (struct MinNode *)(&(x)->Invocations) )

/*
** Struct for list of arexx functions.
** Name is a pointer to the command name,
** Userdata is the value returned in the ArexxMsg structure.
** args is a standard AmigaDos arguement template. Used to parse
** the command line and values returned in the ArexxMsg again. The
** max number of arguements per command is REXX_MAX_ARGS (16). *   eg.
**  const struct ArexxFunction[] = {
**          {"Open", &MyOpen, "FILENAME"},         \* Your open command *\
**          ...
**          {NULL, NULL, NULL}                     \* Mark end of table *\
**  };
*/

struct ArexxFunction {
    STRPTR Name;
    ULONG UserData;
    STRPTR args;
};

/*
**   The ArexxPort Structure
*/
struct ArexxPort {
    /* These can be read and set */
    ULONG                   User_Data;
    BOOL                    Abort;

    /* Private - Read only */
    char                    PortName[REXX_PORT_LEN + 10];
    STRPTR                  Console,
                            Extension;

    /* Private Data - Do not touch */
    struct ArexxPort        *prev,
                            *succ;
    struct MsgPort          *Port;
    struct MinList          Invocations;
    struct ArexxFunction    *commandtable;
    BOOL                    Debug;      /* This does nothing */
    /* New For v37 - Read Only */
    STRPTR                  LastError;
    /* New For v37 - Private */
    ULONG                   Flags;
};


/*
** The ArexxMsg Structure
**
** This is returned by CheckPort() and freed by ReplyPort.
** All data is read only. The only interesting fields for
** Type, arg, User_Data, Port, Abort and msg.
**
** Type = AREXX_COMMAND if message is the result of a command being
** recieved at the port. In that case the arg[] block contains the
** output of the line parsing. User_Data contains the user_data from the
** relevant ArexxFunction struct. Abort will be true if the Abort field of
** the port structure is true. NB this will go. Use amsg->port->Abort
** instead. msg field is a pointer to rexxmsg for this command. Use this
** oin SetRexxVar() and GetRexxVar() functions.
**
** Type = AREXX_MESSAGE when the message is recieved is the return values of
** a command launched by this port. In which case, User_Data will have the
** data from the Invocation struct User_data in it.
** The first three arg[] will be filed as follows
**   arg[0] = MacroName
**
**   There are four possible return states:
**   Result1    Result2           Meaning
**   -------    -------       ----------------
**      0            0        Normal execution, no result requested.
**                            arg[1] = NULL, arg[2] = NULL
**      0           !=0       Normal execution, with result string.
**                            arg[1] = "Returned this string", arg[2] = Result2
**     !=0           0        Error.  Result1 is code from EXIT n.
**                            arg[1] = "Returned with a %ld", rm_Result1, arg[2] = NULL
**     !=0          !=0       Error.  Result2 is Arexx error code.
**                            arg[1] = "Returned with error level %ld", result1
**                            arg[2] = Arexx error text for that level, as returned
**                            by ArexxFunction ErrorText()
**
*/

struct ArexxMsg {
    /* Private - Read only */
    BOOL                Abort;      /* Redunant do not use. Use 'port->Abort' instead. */
    UWORD               Type;
    ULONG               arg[ REXX_MAX_ARGS ];
    ULONG               User_Data;
    struct ArexxPort    *port;
    struct RexxMsg      *msg;

    /* Private - Do not touch */
    struct RDArgs       *args;
    STRPTR              storage;
};
#define AREXX_COMMAND   1
#define AREXX_MESSAGE   2

/*
**   List of macros lauched contains these
**   structures and are read only. When macro returns then
**   ArexxMsg User_Data is filled with User_Data.
*/
struct ArexxInvocation {
    struct MinNode  Node;
    BOOL            console;
    struct RexxMsg  *rexxmsg;
    struct RexxMsg  *parent;
    ULONG           User_Data;
};

/*
**   Tags for OpenArexxPort()
*/
#define ARLT_NOINSTANCE        TAG_USER | 1L
#define ARLT_COMMANDS          TAG_USER | 2L
#define ARLT_CONSOLE           TAG_USER | 3L
#define ARLT_CHAIN             TAG_USER | 4L
#define ARLT_EXTENSION         TAG_USER | 5L
#define ARLT_USER              TAG_USER | 6L
#define ARLT_LASTERROR         TAG_USER | 7L

#endif  /* REXX_AREXXPORT_LIBRARY_H */


