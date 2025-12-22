
OPT OSVERSION=37

MODULE 'reqtools','icon'
MODULE 'utility/tagitem'
MODULE 'intuition/screens','graphics/modeid'
MODULE 'workbench/startup','workbench/workbench'
MODULE 'dos/dos'

ENUM ERR_NONE,ERR_NOREQTOOLS,ERR_NOICON,ERR_NOINFO,
     ERR_NOSIG,ERR_NOPUBNAME,ERR_NOSCREEN

DEF prog[80]:STRING
DEF wbmsg:PTR TO wbstartup
DEF diskobj:PTR TO diskobject

DEF taglist[80]:LIST
DEF item:PTR TO LONG

DEF scr=NIL
DEF sig=0
DEF pubname=NIL

PROC main() HANDLE
  DEF rcode

  reqtoolsbase:=OpenLibrary('reqtools.library',37)
  IF reqtoolsbase=NIL THEN Raise(ERR_NOREQTOOLS)

  iconbase:=OpenLibrary('icon.library',37)
  IF iconbase=NIL THEN Raise(ERR_NOICON)

  IF wbmessage
    wbmsg:=wbmessage
    StrCopy(prog,'PROGDIR:')
    AddPart(prog,wbmsg.arglist.name,80)
  ELSE
    GetProgramName(prog,80)
  ENDIF
  IF (diskobj:=GetDiskObject(prog))=NIL THEN Raise(ERR_NOINFO)
  IF (sig:=AllocSignal(-1))=NIL THEN Raise(ERR_NOSIG)

  item:=taglist

  long_tag (SA_LIKEWORKBENCH, 'LIKEWORKBENCH')

  long_tag (SA_DEPTH,         'DEPTH')
  long_tag (SA_DISPLAYID,     'DISPLAYID')
  pubname_tag (SA_PUBNAME,    'PUBNAME')
  name_tag (SA_TITLE,         'TITLE')
  item_tag (SA_PUBSIG,        sig)
  item_tag (SA_PUBTASK,       NIL); item[]++:=0

  long_tag (SA_LEFT,          'LEFT')
  long_tag (SA_TOP,           'TOP')
  long_tag (SA_WIDTH,         'WIDTH')
  long_tag (SA_HEIGHT,        'HEIGHT')

  long_tag (SA_DETAILPEN,     'DETAILPEN')
  long_tag (SA_BLOCKPEN,      'BLOCKPEN')
  long_tag (SA_SYSFONT,       'SYSFONT')

  long_tag (SA_OVERSCAN,      'OVERSCAN')

  long_tag (SA_SHOWTITLE,     'SHOWTITLE')
  long_tag (SA_BEHIND,        'BEHIND')
  long_tag (SA_QUIET,         'QUIET')
  long_tag (SA_AUTOSCROLL,    'AUTOSCROLL')
  long_tag (SA_FULLPALETTE,   'FULLPALETTE')
  long_tag (SA_DRAGGABLE,     'DRAGGABLE')
  long_tag (SA_SHAREPENS,     'SHAREPENS')
  long_tag (SA_INTERLEAVED,   'INTERLEAVED')
  long_tag (SA_MINIMIZEISG,   'MINIMIZEISG')

  item_tag (TAG_DONE,0)

  IF (scr:=OpenScreenTagList(0,taglist))=NIL THEN Raise(ERR_NOSCREEN)

  PubScreenStatus(scr,0)
  SetDefaultPubScreen(pubname)
  SetPubScreenModes(SHANGHAI)
  Execute(FindToolType(diskobj.tooltypes,'COMMAND'),NIL,NIL)
  SetDefaultPubScreen(NIL)
  Wait(Shl(1,sig))

EXCEPT DO

  SELECT exception
  CASE ERR_NOREQTOOLS
    WriteF('Could not open reqtools.library v37+ !\n'); rcode:=10
  CASE ERR_NOICON
    display('Could not open icon.library v37+ !'); rcode:=10
  CASE ERR_NOINFO
    display('Could not open .info file!'); rcode:=10
  CASE ERR_NOSIG
    display('No signal available!'); rcode:=10
  CASE ERR_NOPUBNAME
    display('No PUBNAME in ToolTypes!'); rcode:=10
  CASE ERR_NOSCREEN
    display('Could not open screen!'); rcode:=5
  DEFAULT
    rcode:=0
  ENDSELECT

  IF scr THEN CloseScreen(scr)
  IF sig>=0 THEN FreeSignal(sig)
  IF diskobj THEN FreeDiskObject(diskobj)
  IF iconbase THEN CloseLibrary(iconbase)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)

ENDPROC rcode

CHAR '$VER: QuickPub 1.0 (04.05.2004) Copyright © Damien Guichard',0

PROC item_tag(tag,data)
  item[]++:=tag; item[]++:=data
ENDPROC
PROC long_tag(tag,name)
  DEF data
  IF data:=FindToolType(diskobj.tooltypes,name)
    item[]++:=tag
    IF StrCmp(data,'TRUE') OR StrCmp(data,'YES')
      item[]++:=1
    ELSEIF StrCmp(data,'FALSE') OR StrCmp(data,'NO')
      item[]++:=0
    ELSE
      item[]++:=Val(data)
    ENDIF
  ENDIF
ENDPROC
PROC name_tag(tag,name)
  DEF data
  IF data:=FindToolType(diskobj.tooltypes,name)
    item[]++:=tag; item[]++:=data
  ENDIF
ENDPROC
PROC pubname_tag(tag,name)
  IF pubname:=FindToolType(diskobj.tooltypes,name)
    item[]++:=tag; item[]++:=pubname
  ELSE
    Raise(ERR_NOPUBNAME)
  ENDIF
ENDPROC

PROC display(msg)
  IF wbmessage
    RtEZRequestA(msg,'OK',0,0,0)
  ELSE
    PrintF(msg); PrintF('\n')
  ENDIF
ENDPROC

