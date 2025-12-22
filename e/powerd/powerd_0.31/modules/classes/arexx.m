#define AREXX_Dummy         (REACTION_Dummy+$30000)
#define AREXX_HostName      (AREXX_Dummy+1)
#define AREXX_DefExtension    (AREXX_Dummy+2)
#define AREXX_Commands      (AREXX_Dummy+3)
#define AREXX_ErrorCode       (AREXX_Dummy+4)
#define AREXX_SigMask       (AREXX_Dummy+5)
#define AREXX_NoSlot      (AREXX_Dummy+6)
#define AREXX_ReplyHook       (AREXX_Dummy+7)
#define AREXX_MsgPort       (AREXX_Dummy+8)
#define RXERR_NO_COMMAND_LIST      (1)
#define RXERR_NO_PORT_NAME         (2)
#define RXERR_PORT_ALREADY_EXISTS  (3)
#define RXERR_OUT_OF_MEMORY        (4)
#define AREXX_DefExtention  AREXX_DefExtension
#define AM_HANDLEEVENT                 ($590001)
#define AM_EXECUTE                     ($590002)
#define AM_FLUSH                       ($590003)

OBJECT apExecute
  MethodID:ULONG,
  CommandString:PTR TO UBYTE,
  PortName:PTR TO UBYTE,
  RC:PTR TO LONG,
  RC2:PTR TO LONG,
  Result:PTR TO UBYTE,
  IO:BPTR

OBJECT ARexxCmd
  Name:PTR TO UBYTE,
  ID:UWORD,
  Func:LONG,
  ArgTemplate:PTR TO UBYTE,
  Flags:ULONG,
  ArgList:PTR TO ULONG,
  RC:LONG,
  RC2:LONG,
  Result:PTR TO UBYTE
