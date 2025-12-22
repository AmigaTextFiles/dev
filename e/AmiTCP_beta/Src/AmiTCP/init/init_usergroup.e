OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'usergroup',
       'amitcp/libraries/usergroup',
       'dos/dos',
       'dos/dosextens',
       'intuition/intuition',
       'other/setprogname'

CONST USERGROUPVERSION=1

RAISE "KICK" IF KickVersion()=FALSE,
      "LIB"  IF OpenLibrary()=NIL,
      "sct"  IF Ug_SetupContextTagList()<>0

-> May be setup by openSockets() in 'amitcp/init/autoinit'
DEF _ProgramName

DEF errno

PROC openUserGroup() HANDLE
  DEF me:PTR TO process
  setprogname({_ProgramName})
  KickVersion(37)
  usergroupbase:=OpenLibrary(USERGROUPNAME, USERGROUPVERSION)
  Ug_SetupContextTagList(_ProgramName, [UGT_INTRMASK, SIGBREAKB_CTRL_C,
                                        UGT_ERRNOPTR(SIZEOF LONG), {errno},
                                        NIL])
EXCEPT
  me:=FindTask(NIL)
  IF me.windowptr<>-1
    EasyRequestArgs(NIL, [SIZEOF easystruct, 0, _ProgramName,
                          IF exception="sct" THEN
                            'Cannot initialise context in \s.' ELSE
                            'Cannot open \s.',
                          'Exit \s']:easystruct,
                    NIL, [USERGROUPNAME, _ProgramName])
  ENDIF
  ReThrow()
ENDPROC

PROC closeUserGroup()
  IF usergroupbase
    CloseLibrary(usergroupbase)
    usergroupbase:=NIL
  ENDIF
ENDPROC