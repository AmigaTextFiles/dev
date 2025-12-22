OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'utility/date'
MODULE  'newgui/pl_calendar'

DEF     title,
        c=NIL:PTR TO calendar

PROC main() HANDLE
  newguiA([
        NG_WINDOWTITLE, 'NewGUI-CalendarPlugin',     
        NG_GUI,
        [ROWS,
        [DBEVELR,
        [ROWS,
                title:=[TEXT,'Calendar: December 1996',NIL,TRUE,5]]],
        [BEVELR,
                [CALENDAR,{calendaraction},NEW c.calendar([0,0,0,25,12,1996,0]:clockdata,TRUE)]],
        [BEVELR,
        [EQCOLS,
                [BUTTON,{reset},'Set to October'],
                [BUTTON,{toggle_enabled},'Toggle Enabled']
        ]]
        ],NIL,NIL])
EXCEPT DO
 END c
ENDPROC

PROC calendaraction()
  WriteF('You picked day \d\n', c.date.mday)
ENDPROC

PROC reset(a,gh)
  IF c.date.month<>10
    c.date.month:=10
    c.setdate()
   ng_setattrsA([NG_GUI,gh,
        NG_CHANGEGAD,TEXT,NG_GADGET,title,NG_NEWDATA,'Calendar: October 1996',NIL,NIL])
  ENDIF
ENDPROC

PROC toggle_enabled()
  c.setdisabled(c.disabled=FALSE)
ENDPROC
