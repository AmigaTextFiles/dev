/* A GUI replacement for Execute */

OPT OSVERSION=37

MODULE 'ReqTools','Libraries/Reqtools'

DEF buf[255]:STRING,exe[255]:STRING,dir[255]:STRING
DEF req:PTR TO rtfilerequester

INCLUDE "getargs.e"

PROC main()
  dir:=getargs()
  IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
    IF req:=RtAllocRequestA(RT_FILEREQ,0)
      RtChangeReqAttrA(req,[RTFI_DIR,dir])
      buf[0]:=0
      IF RtFileRequestA(req,buf,'Pick a file to Execute',[RTFI_OKTEXT,'Execute!'])
        StrCopy(exe,req.dir,ALL)
        StrAdd(exe,buf,ALL)
        Execute(buf,NIL,NIL)
      ENDIF
      RtFreeRequest(req)
    ENDIF
    CloseLibrary(reqtoolsbase)
  ELSE
    WriteF('Could not open reqtools.library!\n')
  ENDIF
  CleanUp(0)
ENDPROC
