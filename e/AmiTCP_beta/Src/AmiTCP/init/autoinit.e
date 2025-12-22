OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'bsdsocket',
       'intuition/intuition',
       'amitcp/amitcp/socketbasetags',
       'other/setprogname'

#define SOCKETNAME 'bsdsocket.library'

CONST SOCKETVERSION=4

DEF _ProgramName, h_errno, errno

RAISE "KICK" IF KickVersion()=FALSE,
      "sbtl" IF SocketBaseTagList()<>0

PROC openSockets()
  KickVersion(37)
  setprogname({_ProgramName})
  IF socketbase:=OpenLibrary(SOCKETNAME, SOCKETVERSION)
    SocketBaseTagList([SBTM_SETVAL(SBTC_ERRNOPTR(SIZEOF LONG)), {errno},
                       SBTM_SETVAL(SBTC_HERRNOLONGPTR), {h_errno},
                       SBTM_SETVAL(SBTC_HERRNOLONGPTR), _ProgramName,
                       NIL])
  ELSE
    EasyRequestArgs(NIL, [SIZEOF easystruct, 0, _ProgramName,
                          'AmiTCP/IP version 4 or later must be started first.',
                          'Exit \s']:easystruct,
                    NIL, [_ProgramName])
    Raise("LIB")
  ENDIF
ENDPROC

PROC closeSockets()
  IF socketbase
    CloseLibrary(socketbase)
    socketbase:=NIL
  ENDIF
ENDPROC
