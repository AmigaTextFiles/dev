OPT     OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'newgui/password'

DEF     default,
        p:PTR TO password,
        s[20]:STRING

PROC main() HANDLE
 default:='My Password!'
  StrCopy(s,default)
   newguiA([
        NG_WINDOWTITLE, 'NewGUI-Password-Plugin',     
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
                [TEXT,'Password test...',NIL,TRUE,1],
                [SPACE],
                [PASSWORD,{passaction},NEW p.password(s,'Password',TRUE,10)]]]],
        [EQCOLS,
                [SBUTTON,{show},'Show'],
                [SBUTTON,{reset},'Reset'],
                [SBUTTON,{toggle_enabled},'Toggle Enabled']
        ]],NIL,NIL])

EXCEPT DO
 END p
  IF exception
   WriteF('Exception = \d\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC passaction()
  PrintF('Action: "\s"\n',p.estr)
ENDPROC

PROC show()
  PrintF('Show: "\s"\n', p.estr)
ENDPROC

PROC reset()
  p.setpass(default)
ENDPROC

PROC toggle_enabled()
  p.setdisabled(p.disabled=FALSE)
ENDPROC
