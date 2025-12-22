OPT OSVERSION=37
OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   Show crunchers the unpack.library can unpack
*   File            :   show.e
*   Copyright       :   © 1996 Piotr Gapinski
*   Author          :   Piotr Gapinski
*   Creation Date   :   04.01.96
*   Current version :   1.0
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   04.01.96      1.0             first release (with nice easygui.m gui)
*
*-- REV_END --*
*/

MODULE 'exec/lists','exec/nodes',
       'intuition/screens','intuition/intuition',
       'libraries/unpack','unpack',
       'tools/easygui','tools/constructors','tools/exceptions'

#define PROGRAMVERSION '$VER: show 1.0 (04.01.96)'

ENUM ERR_OK,ERR_NOLIB,ERR_STRUCT,ERR_NOMEM
DEF  listgad,
     gh=NIL:PTR TO guihandle

PROC main() HANDLE
  DEF info=NIL:PTR TO unpackinfo,name,done,
      res=-1,list=NIL:PTR TO lh,hail,
      scr:PTR TO screen

  IF (unpackbase:=OpenLibrary(UNPACKNAME,39))=NIL THEN Raise(ERR_NOLIB)
  IF (info:=UpAllocCInfo())=NIL THEN Raise(ERR_STRUCT)
  list:=newlist()

  hail:=' Crunchers the unpack.library can unpack'
  scr:=LockPubScreen(NIL)
  gh:=guiinit('Show',
    [EQROWS,
      [BEVEL,
        [TEXT,hail,NIL,FALSE,3]
      ],
      listgad:=[LISTV,{dummy},NIL,40,17,list,TRUE,0,0]
    ])
  IF gh<>NIL THEN gh.wnd.flags:=gh.wnd.flags OR WFLG_RMBTRAP

  SetWindowTitles(gh.wnd,-1,PROGRAMVERSION)
  name:=UpUnpackList(info)
  REPEAT
    MOVE.L A1,name
    addinfo(list,name)
    done:=UpUnpackListNext(info)
  UNTIL done=0

  WHILE res<0
    Wait(gh.sig)
    res:=guimessage(gh)
  ENDWHILE
EXCEPT DO
  cleangui(gh)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF info THEN UpFreeCInfo(info)
  IF unpackbase THEN CloseLibrary(unpackbase)
  IF list THEN freelist(list,TRUE)
  IF exception
    SELECT exception
    CASE ERR_NOLIB
      WriteF('You need the \s V39+\n',UNPACKNAME)
    CASE ERR_STRUCT
      WriteF('No free memory!\n')
    CASE ERR_NOMEM
      WriteF('No free memory!\n')
    DEFAULT
      report_exception()
      WriteF('LEVEL: main()\n')
    ENDSELECT
  ENDIF
ENDPROC

PROC addinfo(list:PTR TO lh,text:PTR TO CHAR)
  DEF node:PTR TO ln,str

  IF (node:=New(SIZEOF ln))=NIL THEN Raise(ERR_NOMEM)
  IF (str:=String(StrLen(text)))=NIL THEN Raise(ERR_NOMEM)
  StrCopy(str,text)
  node.name:=str
  setlistvlabels(gh,listgad,-1)
  AddTail(list,node)
  setlistvlabels(gh,listgad,list)
ENDPROC

PROC freelist(list:PTR TO lh,all=FALSE)
  IF list=NIL THEN RETURN     -> already de-allocated
  REPEAT
  UNTIL freenode(list)=FALSE
  IF all=TRUE THEN END list   -> use only with 'constructors.m' lists
ENDPROC

PROC freenode(list:PTR TO lh)
  DEF node:PTR TO ln

  node:=RemHead(list)
  IF node<>0
    DisposeLink(node.name)
    Dispose(node)
    RETURN TRUE
  ENDIF
ENDPROC FALSE

PROC dummy()
ENDPROC
CHAR PROGRAMVERSION,0
/*EE folds
-1
88 9 91 4 94 8 
EE folds*/
