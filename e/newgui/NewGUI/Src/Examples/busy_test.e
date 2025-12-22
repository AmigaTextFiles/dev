OPT     OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'newgui/busy'

DEF     b1:PTR TO busy,
        b2:PTR TO busy,
        b3:PTR TO busy,
        b4:PTR TO busy,
        busyon=FALSE

PROC main() HANDLE
 newguiA([
        NG_WINDOWTITLE, 'NewGUI-BusyPlugin',     
        NG_WINDOWTYPE,  WTYPE_NOSIZE,
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  0,                                      /* Zeichenstift für den Pattern         */
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
        [BEVELR,
        [FILLPATTERN1,
        [EQROWS,
                [TEXT,'Busy-BAR Test','NewGUI',FALSE,1],
        [EQCOLS,
                [BUSY,{dummy},NEW b1.busy(7,10,2,BUSY_BOTH,4)],
                [BUSY,{dummy},NEW b2.busy(3,10,2,BUSY_BOTH,4)]],
        [EQCOLS,
                [BUSY,{dummy},NEW b3.busy(5,10,2,BUSY_STARTLEFT,8)],
                [BUSY,{dummy},NEW b4.busy(6,10,2,BUSY_STARTRIGHT,8)]]
        ]]],
        [BEVELR,
        [FILLPATTERN1,
        [EQCOLS,
                [SBUTTON,{dummy},'Dummy'],
        [SPACEH],
                [SBUTTON,{getbusy},'Busy ON/OFF']
        ]]]]
        ,NIL,NIL])
EXCEPT DO
 END b1
 END b2
 END b3
 END b4
  IF exception
   WriteF('Exception=\d\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC dummy()
 WriteF('Dummy!\n')
ENDPROC

PROC getbusy()
 IF busyon=FALSE
  b1.active(TRUE)
  b2.active(TRUE)
  b3.active(FALSE)
  b4.active(FALSE)
   busyon:=TRUE
 ELSE
  b1.active(FALSE)
  b2.active(FALSE)
  b3.active(TRUE)
  b4.active(TRUE)
   busyon:=FALSE
 ENDIF
ENDPROC
