OPT     OSVERSION = 37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'utility/date'
MODULE  'newgui/calendar'

DEF     title,
        c=NIL:PTR TO calendar

PROC main() HANDLE
  newguiA([
        NG_WINDOWTITLE, 'NewGUI-CalendarPlugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  2,                                      /* Zeichenstift für den Pattern         */
        NG_PATTERNEXP,  1,                                      /* Exponent für den Pattern             */
        NG_PATTERN1,    [$AAAA,$5555]:INT,                      /* Muster (Pattern) für FILLPATTERN1    */
        NG_P1BACKPEN,   0,                                      /* Hintergrundstift für das Patternfilling (Muster)             */
        NG_P1FRONTPEN,  0,                                      /* Zeichenstift für das Muster (Patternfilling)                 */
/*                                                              /* ARexx-Port hinzufügen!               */
        NG_REXXNAME,    'NEWGUI',                               /* Name für einen ARexx-Port            */
        NG_REXXPROC,    {rexxmsg},                              /* Prozedur die ARexx-Messages auswertet*/
*/                                                              /* Durch den Port wird das EXE nicht größer!    */
        NG_GUI,
        [ROWS,
        [DBEVELR,
        [FILLPATTERN1,
        [ROWS,
                title:=[TEXT,'Calendar: December 1996',NIL,TRUE,5]]]],
        [BEVELR,
        [FILLPATTERN1,
                [CALENDAR,{calendaraction},NEW c.calendar([0,0,0,25,12,1996,0]:clockdata,TRUE)]]],
        [BEVELR,
        [FILLPATTERN1,
        [EQCOLS,
                [BUTTON,{reset},'Set to October'],
                [BUTTON,{toggle_enabled},'Toggle Enabled']
        ]]]
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
