MODULE 'intuition/intuition'

PROC main()
DEF win,spec

win:=OpenWindowTagList(NIL,
              [WA_WIDTH, 300,
               WA_HEIGHT, 50,
               WA_FLAGS, WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
               WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY,
               WA_TITLE, 'Raw Key Example',
               NIL])

LOOP
spec:=WaitIMessage(win)

IF spec=IDCMP_RAWKEY
WriteF('\d\n',MsgCode())
ENDIF

IF spec=IDCMP_CLOSEWINDOW
CloseW(win)
JUMP x
ENDIF

ENDLOOP
x:
ENDPROC
