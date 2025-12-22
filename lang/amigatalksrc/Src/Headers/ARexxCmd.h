/****h* AmigaTalk/ARexxCmd.h [1.5] ***************************************
*
* NAME
*    ARexxCmd.h
*
* DESCRIPTION
*    Contains the Global Definitions or Declarations,
*    Depending on how ALLOC_CMDS is #defined.
*
* VISIBILITY:  Only ATBrowser.c & ARexxFuncs.c need this header.
**************************************************************************
*
*/

/*
 * $Log$
*/

#ifndef  AREXXCOMMANDS_H
#define  AREXXCOMMANDS_H   1

# ifdef   ALLOC_CMDS
#  define  GLOBAL_
# else
#  define  GLOBAL_   extern
# endif

/* ----------------------- */
/* ATBrowser.c Section:    */
/* Misc. Global variables: */
/* ----------------------- */

int                   outstanding_rexx_commands = 0;

BPTR                  window_file_handle  = NULL;
struct MsgPort        *dos_reply_port     = NULL;
struct StandardPacket *dos_message        = NULL;
struct MsgPort        *rexx_port          = NULL;


/* First referenced by GetArguments(): */
# ifdef   ALLOC_CMDS

char           Arguments[MAX_ARGS * ARG_SIZE];

char   *arg0 = &Arguments[0];
char   *arg1 = &Arguments[ARG_SIZE];

char   *arg2 = &Arguments[2  * ARG_SIZE];
char   *arg3 = &Arguments[3  * ARG_SIZE];
char   *arg4 = &Arguments[4  * ARG_SIZE];
char   *arg5 = &Arguments[5  * ARG_SIZE];
char   *arg6 = &Arguments[6  * ARG_SIZE];
char   *arg7 = &Arguments[7  * ARG_SIZE];
char   *arg8 = &Arguments[8  * ARG_SIZE];
char   *arg9 = &Arguments[9  * ARG_SIZE];
char   *argA = &Arguments[10 * ARG_SIZE];
char   *argB = &Arguments[11 * ARG_SIZE];
char   *argC = &Arguments[12 * ARG_SIZE];
char   *argD = &Arguments[13 * ARG_SIZE];
char   *argE = &Arguments[14 * ARG_SIZE];

# else

GLOBAL_ char    Arguments[MAX_ARGS * ARG_SIZE];

GLOBAL_ char   *arg0;
GLOBAL_ char   *arg1;
GLOBAL_ char   *arg2;
GLOBAL_ char   *arg3;
GLOBAL_ char   *arg4;
GLOBAL_ char   *arg5;
GLOBAL_ char   *arg6;
GLOBAL_ char   *arg7;
GLOBAL_ char   *arg8;
GLOBAL_ char   *arg9;
GLOBAL_ char   *argA;
GLOBAL_ char   *argB;
GLOBAL_ char   *argC;
GLOBAL_ char   *argD;
GLOBAL_ char   *argE;

# endif

/* First Referenced by execute_command():  */

# ifdef   ALLOC_CMDS

char cmd1[]  = "PLACECODESINFILE";
char cmd2[]  = "PURGECLASS";
char cmd3[]  = "RELOADCLASS";
char cmd4[]  = "GETCLASSLISTTYPE";
char cmd5[]  = "RELOADMETHOD";
char cmd6[]  = "ADDCLASS";
char cmd7[]  = "ADDMETHOD";
char cmd8[]  = "QUIT";
char cmd9[]  = "REPORTSTATUS";
char cmd10[] = "GETERROR";
char cmd11[] = "GETCLASSFILENAME";

# else

GLOBAL_ char cmd1[];
GLOBAL_ char cmd2[];
GLOBAL_ char cmd3[];
GLOBAL_ char cmd4[];
GLOBAL_ char cmd5[];
GLOBAL_ char cmd6[];
GLOBAL_ char cmd7[];
GLOBAL_ char cmd8[];
GLOBAL_ char cmd9[];
GLOBAL_ char cmd10[];
GLOBAL_ char cmd11[];

# endif

#endif   /* AREXXCOMMANDS_H */

/* ----------- END of ARexxCmd.h file! -------------------------- */
