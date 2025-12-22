MODULE 'exec/libraries', 'intuition/intuitionbase', 'intuition/intuition', 'intuition/screens', 'utility/tagitem'

ENUM ER_NONE, ER_NOSCR, ER_NOWIN

DEF scr=NIL:PTR TO screen
DEF win=NIL:PTR TO window, mes
DEF text[60]:STRING
DEF intuitionBase:PTR TO intuitionbase, ver, rev


PROC main() HANDLE

   intuitionBase:=intuitionbase
             ver:=intuitionBase.libnode.version
             rev:=intuitionBase.libnode.revision

   IF (scr:=OpenScreenTagList(NIL,
     [SA_DEPTH,                       2,
      SA_WIDTH,                     640,
      SA_HEIGHT,                    200,
      SA_DISPLAYID,              $19000,
      SA_TYPE,             CUSTOMSCREEN,
      SA_OFFSCREENDRAGGING,        TRUE,  TAG_DONE]))=NIL THEN Raise(ER_NOSCR)

   IF (win:=OpenWindowTagList(NIL,
     [WA_LEFT,          20,
      WA_TOP,           20,
      WA_WIDTH,        500,
      WA_HEIGHT,       100,
      WA_CUSTOMSCREEN, scr,
      WA_IDCMP,        IDCMP_CLOSEWINDOW,
      WA_FLAGS,        WFLG_DEPTHGADGET OR WFLG_SMART_REFRESH OR WFLG_DRAGBAR OR
                       WFLG_CLOSEGADGET OR WFLG_NOCAREREFRESH OR WFLG_ACTIVATE, TAG_DONE]))=NIL THEN Raise(ER_NOWIN)

   StringF(text, 'Intuition.library version \d.\d found', ver, rev)
   Move(win.rport, 20,   30)
   Text(win.rport, text, StrLen(text))

   IF ver>=45
      StrCopy(text, 'it is possible to move windows out of screens! :-D', ALL)
   ELSE
      StrCopy(text, 'it is not possible to move windows out of screens! :-(', ALL)
   ENDIF

   Move(win.rport, 20,   40)
   Text(win.rport, text, StrLen(text))

   LOOP
      WaitPort(win.userport)
      IF (mes:=GetMsg(win.userport))
         ReplyMsg(mes)
         Raise(ER_NONE)
      ENDIF
   ENDLOOP

EXCEPT
   IF win THEN CloseWindow(win)
   IF scr THEN CloseScreen(scr)
ENDPROC


