// to convert any files into PowerD compatible files
// 1.0 (21.11.2001) initial release
// 1.1 (29.4.2002) DMX: added Delay(1) to free some cpu time, recompiled
// 1.2 (03.08.2002) DMX: Added support for pragma & fd files.
// 1.3 (09.08.2002) DMX: module files will be compiled now :)

MODULE 'exec/memory','reqtools','libraries/reqtools','intuition/intuition'

OPT OSVERSION=37,OPTIMIZE
ENUM SOURCE

DEF ReqToolsBase=NIL,break=FALSE

PROC main()
  DEF myargs:PTR TO LONG,rdargs=NIL,str[256]=NIL:STRING
  DEF vers='$VER: x2d v1.3 by MarK and DMX (\x4d)'
  myargs:=[NIL,NIL]
  IFN ReqToolsBase:=OpenLibrary('reqtools.library',37) THEN Raise("RTLI")
  IFN rdargs:=ReadArgs('SOURCE',myargs,NIL) THEN Raise("DOS")
  EStrCopy(str,IF myargs[0] THEN myargs[0] ELSE FileReq(str))

  DEF filetype
  IF StrCmp(str+EStrLen(str)-3,'.fd')
    filetype:="fd"
  ELSEIF StrCmp(str+EStrLen(str)-6,'_lib.h')
    filetype:="pr"
  ELSEIF StrCmp(str+EStrLen(str)-10,'_pragmas.h')
    filetype:="spr"
  ELSEIF StrCmp(str+EStrLen(str)-2,'.h')
    filetype:="h"
  ELSEIF StrCmp(str+EStrLen(str)-2,'.c')
    filetype:="c"
  ELSE
    filetype:=NIL
  ENDIF

  SELECT filetype
    CASE "fd"; PrintF('FileType: \s\n','FD File')
      convert2lib(str,3)
    CASE "spr"; PrintF('FileType: \s\n','SAS/C Pragma File')
      convert2lib(str,10)
    CASE "pr"; PrintF('FileType: \s\n','Pragma File')
      convert2lib(str,6)
    CASE "h"; PrintF('FileType: \s\n','C-Header File')
      converth2m(str)
    CASE "c"; PrintF('FileType: \s\n','C-Source File. I can''t handle this one. Better use a C-Compiler ;)')
    DEFAULT; PrintF('FileType: \s\n','Unknown')
  ENDSELECT
  IF break=TRUE THEN PrintF('Break.   \n') ELSE PrintF('Done.   \n')

EXCEPTDO
  IF rdargs THEN FreeArgs(rdargs)
  IF ReqToolsBase THEN CloseLibrary(ReqToolsBase)
ENDPROC

PROC FileReq(nm:PTR TO CHAR)(PTR)
  DEF name[256]:STRING,
      requestedname[256]:STRING,
      r:PTR TO rtFileRequester
  IF r:=rtAllocRequestA(RTPREF_FILEREQ,NIL)
    rtChangeReqAttr(r,
      RTFI_MatchPat,'#?',
      TAG_END)
    IF rtFileRequest(r,name,'Select a file:',
        RT_ReqPos,REQPOS_CENTERSCR,
        RTFI_Flags,FREQF_PATGAD,
        RTFI_OKText,'_Load',
        RT_Underscore,"_",
        TAG_END)
      EStrCopy(requestedname,r.Dir)
      AddPart(requestedname,name,255)
      ReEStr(requestedname)
      EStrCopy(nm,requestedname)
    ENDIF
    rtFreeRequest(r)
  ENDIF
ENDPROC nm

MODULE 'dos/dos'

PROC CompileAll(dir:PTR TO UBYTE)(BOOL)
  DEF info:FileInfoBlock,lock,count=0,command[256]:STRING,n=0
  IF lock:=Lock(dir,-2)
    IF Examine(lock,info)
      IF info.DirEntryType>0
        WHILE ExNext(lock,info) DO count++
      ELSE PrintFault(IOErr(),'ddir')
    ELSE PrintFault(IOErr(),'ddir')
    IF Examine(lock,info)
      IF info.DirEntryType>0
        WHILE ExNext(lock,info)
          StringF(command,'pasm -F 2 "\s/\s"',dir,info.FileName)
          Execute(command,NIL,NIL)
          Delay(1)
          n++
          PrintF(' \d/\d\b',n,count)
          IF CtrlC()
            break:=TRUE
            JUMP brk
          ENDIF
        ENDWHILE
      ELSE PrintFault(IOErr(),'ddir')
    ELSE PrintFault(IOErr(),'ddir')
brk:
    UnLock(lock)
  ELSE PrintFault(IOErr(),'ddir')
ENDPROC

PROC request(body,gadgets=NIL,args=NIL)(LONG)
  IF gadgets=NIL THEN gadgets:='_Continue'
  IFN ReqToolsBase
    RETURN EasyRequestArgs(0,[SIZEOF_EasyStruct,0,'RayDream message:',body,gadgets]:EasyStruct,0,args)
  ELSE
    RETURN rtEZRequest(body,gadgets,NIL,args,
      RT_Underscore,"_",
      RT_ReqPos,REQPOS_CENTERSCR,
      RTEZ_ReqTitle,'Message:',
      TAG_END)
  ENDIF
ENDPROC

PROC convert2lib(str[]:STRING,number:INT)
  DEF command[256]=NIL:STRING,tmp[256]=NIL:STRING
  PrintF('Converting to PowerD compatible module...\n')
  EStrCopy(tmp,str, EStrLen(str)-number)
  IF number=3
    StringF(command,'fd2m "\s"',str)
  ELSEIF number=6
    StringF(command,'pr2m "\s"',tmp)
  ELSEIF number=10
    StringF(command,'pr2m SASC "\s"',tmp)
  ENDIF
  Execute(command,NIL,NIL)
  PrintF('Compiling the ascii module and generating ppc interface...\n')
  str[StrLen(str)-number]:="\0"
  IF StrCmp(str+StrLen(str)-4,'_lib')
    str[StrLen(str)-4]:="\0"
    StrAdd(str,'.m')
  ENDIF
  StringF(command,'dc "\s" >nil: lg t:library',str)
  Execute(command,NIL,NIL)
  PrintF('Generating linklib file...\n')
  CompileAll('t:library')
  str[StrLen(str)-2]:="\0"
  IF number=3
    StringF(command,'join t:library/#?.o as "\sbase.lib"',str)
  ELSE
    StringF(command,'join t:library/#?.o as "\sbase.lib"',tmp)
  ENDIF
  Execute(command,NIL,NIL)
  Execute('delete t:library all quiet force',NIL,NIL)
  IFN break
    IF 1=request('Copy generated files into the PowerD subdirectories?','_Yes|_No')
      StringF(command,'copy "\s.m" "\s.b" to dmodules: quiet',str,str)
      Execute(command,NIL,NIL)
      IF number=3
        StringF(command,'copy "\sbase.lib" to d:lib/modules quiet',str)
      ELSE
        StringF(command,'copy "\sbase.lib" to d:lib/modules quiet',tmp)
      ENDIF
      Execute(command,NIL,NIL)
    ENDIF
  ENDIF
ENDPROC

PROC converth2m(str[]:STRING)
  DEF command[256]=NIL:STRING
  PrintF('Converting C-Header to PowerD compatible module...\n')
  StringF(command,'h2m "\s"',str)
  Execute(command,NIL,NIL)

  IF StrCmp(str+EStrLen(str)-2,'.h')
    str[EStrLen(str)-2]:="\0"
    StrAdd(str,'.m')
  ENDIF

  StringF(command,'dc "\s" >nil:',str)
  Execute(command,NIL,NIL)

ENDPROC
