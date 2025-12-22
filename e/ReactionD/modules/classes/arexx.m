/*
**  $VER: arexx.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  arexx.class definitions
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
MODULE 'exec/memory','dos/dos','dos/rdargs','rexx/storage','rexx/rxslib','rexx/errors','intuition/classes','intuition/classusr','utility/hooks'
/* Tags supported by the arexx class */
#define AREXX_Dummy         (REACTION_Dummy+0x30000)
#define AREXX_HostName      (AREXX_Dummy+1)
/* (STRPTR) */
#define AREXX_DefExtension    (AREXX_Dummy+2)
/* (STRPTR) */
#define AREXX_Commands      (AREXX_Dummy+3)
/* (struct ARexxCmd *) */
#define AREXX_ErrorCode       (AREXX_Dummy+4)
/* (ULONG *) */
#define AREXX_SigMask       (AREXX_Dummy+5)
/* (ULONG) */
#define AREXX_NoSlot      (AREXX_Dummy+6)
/* (BOOL) */
#define AREXX_ReplyHook       (AREXX_Dummy+7)
/* (struct Hook *) */
#define AREXX_MsgPort       (AREXX_Dummy+8)
/* (struct MsgPort *) */
/* Possible error result codes
 */
#define RXERR_NO_COMMAND_LIST      (1)
#define RXERR_NO_PORT_NAME         (2)
#define RXERR_PORT_ALREADY_EXISTS  (3)
#define RXERR_OUT_OF_MEMORY        (4)
/* I can't spell, don't use this.
 */
#define AREXX_DefExtention  AREXX_DefExtension
/*****************************************************************************/
/* Methods Supported by the ARexx Class.
 */
#define AM_HANDLEEVENT                 (0x590001)
/* ARexx class event-handler. */
#define AM_EXECUTE                     (0x590002)
/* Execute a host command. */
#define AM_FLUSH                       (0x590003)
/* Flush rexx port. */
/* AM_EXECUTE message.
 */
OBJECT apExecute
  MethodID:ULONG,                    /* AM_EXECUTE */
  ape_CommandString:PTR TO UBYTE,    /* Command string to execute */
  ape_PortName:PTR TO UBYTE,         /* Port to send to (usually RXSDIR) */
  ape_RC:PTR TO LONG,                /* RC pointer */
  ape_RC2:PTR TO LONG,               /* RC2 pointer */
  ape_Result:PTR TO UBYTE,           /* Result pointer */
  ape_IO:PTR                         /* I/O handle */

/*****************************************************************************/
/* An array of these structures must be passed at object-create time.
 */
OBJECT ARexxCmd
  Name:PTR TO UBYTE,           /* Command name */
  ID:UWORD,                    /* Unique ID */
  Func(),
  ArgTemplate:PTR TO UBYTE,    /* DOS-style argument template */
  Flags:ULONG,                 /* Unused, make NULL */
  ArgList:PTR TO ULONG,        /* Result of ReadArgs() */
  RC:LONG,                     /* Primary result */
  RC2:LONG,                    /* Secondary result */
  Result:PTR TO UBYTE          /* RESULT variable */
