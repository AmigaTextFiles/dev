MODULE 'tools/easygui', 'tools/exceptions',
       'graphics/text',
       'plugins/led'

DEF going=FALSE, title

PROC main() HANDLE
  DEF l=NIL:PTR TO led
  NEW l.led(2,[0,0]:INT,TRUE)
  easyguiA('BOOPSI in EasyGUI!',
    [ROWS,
      title:=[TEXT,'LED Boopsi image tester...',NIL,TRUE,1],
      [COLS,
         [EQROWS,
           [BUTTON,{runaction},'Run',l],
           [BUTTON,{stopaction},'Stop']
         ],
         [PLUGIN,0,l]
      ]
    ])
EXCEPT DO
  END l
  report_exception()
ENDPROC

PROC runaction(l:PTR TO led,gh) HANDLE
  DEF h,m
  IF going
    settext(gh,title,'I''m busy counting!')
  ELSE
    going:=TRUE
    settext(gh,title,'Started counting...')
    Delay(10)
    FOR h:=0 TO 12
      FOR m:=0 TO 59
        l.values:=[h,m]:INT
        l.redisplay()
        l.colon:=(l.colon=FALSE)
        checkgui(gh)
        Delay(10)
        settext(gh,title,'Counting...')
      ENDFOR
    ENDFOR
    settext(gh,title,'Finished!')
    going:=FALSE
  ENDIF
EXCEPT
  going:=FALSE
  settext(gh,title,'You stopped me!')
  IF exception<>"STOP" THEN ReThrow()
ENDPROC

PROC stopaction(i)
  IF going THEN Raise("STOP")
ENDPROC
