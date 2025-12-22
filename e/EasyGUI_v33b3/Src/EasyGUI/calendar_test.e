MODULE 'tools/EasyGUI', 'tools/exceptions',
       'utility/date',
       'plugins/calendar'

DEF title

PROC main() HANDLE
  DEF c=NIL:PTR TO calendar
  NEW c.calendar([0,0,0,25,12,1996,0]:clockdata,TRUE)
  easyguiA('BOOPSI in EasyGUI!',
    [ROWS,
      title:=[TEXT,'Calendar: December 1996',NIL,TRUE,5],
      [PLUGIN,{calendaraction},c],
      [EQCOLS,
        [BUTTON,{reset},'Set to October',c],
        [BUTTON,{toggle_enabled},'Toggle Enabled',c]
      ]
    ])
EXCEPT DO
  END c
  report_exception()
ENDPROC

PROC calendaraction(i,c:PTR TO calendar)
  WriteF('You picked day \d\n', c.date.mday)
ENDPROC

PROC reset(c:PTR TO calendar,gh)
  IF c.date.month<>10
    c.date.month:=10
    c.setdate()
    settext(gh,title,'Calendar: October 1996')
  ENDIF
ENDPROC

PROC toggle_enabled(c:PTR TO calendar,i)
  c.setdisabled(c.disabled=FALSE)
ENDPROC
