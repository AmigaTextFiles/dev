OPT OSVERSION=37
OPT PREPROCESS,REG=5

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   Crunchery które unpack.library moûe rozpakowaê
*   File            :   show.e
*   Copyright       :   © 1996 Piotr Gapiïski
*   Author          :   Piotr Gapiïski
*   Creation Date   :   13.07.96
*   Current version :   2.0
*   Translator      :   AmigaE v3.2e
*
*   REVISION HISTORY
*
*   Date       Version  Comment
*   ---------  -------  ----------------------------------------------------
*   04.01.96   1.0      first release (with nice easygui.m gui)
*   25.04.96   1.0.1    lepsze zarzâdzanie pamiëciâ
*   13.07.96   2.0      poprawione zarzâdzanie pamiëciâ (mempools)
*
*-- REV_END --*
*/

MODULE 'exec/lists','exec/nodes','exec/memory',
       'intuition/screens','intuition/intuition',
       'utility/tagitem',
       'libraries/unpack','unpack',
       'tools/easygui','tools/constructors'
MODULE 'tools/mempools'

#define PROGRAMVERSION '$VER: show 2.0 (13.07.96)'

#define MSG_CLI_WRONGKICK     'Require OS v37+ !\n'
#define MSG_CLI_NOUNPACKERLIB 'Couldn\at open unpacker.library v39+ !\n'
#define MSG_CLI_NOMEM         'No free memory!\n'
#define MSG_TITLE_HAIL        'Crunchers the unpack.library can unpack'
#define MSG_TITLE_WINDOW      'unpack.library'

CONST PUDDLESIZE = 1024 * 20
CONST TRESHSIZE  = PUDDLESIZE

PROC main() HANDLE
  DEF pool=NIL:PTR TO pool,
      info=NIL:PTR TO unpackinfo
  DEF gh=NIL:PTR TO guihandle,listgad,res=-1
  DEF list=NIL:PTR TO lh,node:PTR TO ln,name,str:PTR TO CHAR
  DEF done,scr=NIL:PTR TO screen

  IF KickVersion(37)=FALSE THEN Raise(MSG_CLI_WRONGKICK)
  IF (unpackbase:=OpenLibrary(UNPACKNAME,39))=NIL THEN Raise (MSG_CLI_NOUNPACKERLIB)
  IF (info:=UpAllocCInfo())=NIL THEN Raise(MSG_CLI_NOMEM)
  IF (pool:=libCreatePool(MEMF_ANY OR MEMF_CLEAR,PUDDLESIZE,
                          TRESHSIZE))=NIL THEN Raise(MSG_CLI_NOMEM)

  scr:=LockPubScreen(NIL)
  gh:=guiinit(MSG_TITLE_WINDOW,
    [EQROWS,
      [BEVEL,
        [TEXT,MSG_TITLE_HAIL,NIL,FALSE,3]
      ],
      listgad:=[LISTV,{dummy},NIL,20,17,list,TRUE,0,0]
    ])
  IF gh<>NIL THEN gh.wnd.flags:=gh.wnd.flags OR WFLG_RMBTRAP
  SetWindowPointerA(gh.wnd,[WA_BUSYPOINTER,TRUE,TAG_DONE])
  SetWindowTitles(gh.wnd,-1,PROGRAMVERSION)
  list:=newlist()
  name:=UpUnpackList(info)
  REPEAT
    done:=UpUnpackListNext(info)
    MOVE.L A1,name
    IF name
      node:=libAllocPooled(pool,SIZEOF ln)
      str:=libAllocPooled(pool,StrLen(name)+1)
      IF node=NIL OR str=NIL THEN Raise(MSG_CLI_NOMEM)
      AstrCopy(str,name)
      node.name:=str
      setlistvlabels(gh,listgad,-1)
      AddTail(list,node)
      setlistvlabels(gh,listgad,list)
    ENDIF
  UNTIL done=0
  SetWindowPointerA(gh.wnd,[TAG_DONE])

  WHILE res<0
    Wait(gh.sig)
    res:=guimessage(gh)
  ENDWHILE
EXCEPT DO
  IF exception THEN WriteF(exception,
                    IF exceptioninfo THEN exceptioninfo ELSE NIL)
  IF gh THEN cleangui(gh)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF info THEN UpFreeCInfo(info)
  IF pool THEN libDeletePool(pool)
  END list
  IF unpackbase THEN CloseLibrary(unpackbase)
ENDPROC

PROC dummy() IS EMPTY
CHAR PROGRAMVERSION,0
