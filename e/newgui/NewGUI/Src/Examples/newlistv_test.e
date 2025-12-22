OPT     LARGE
OPT     OSVERSION = 37

MODULE  'tools/exceptions'
MODULE  'exec/nodes'
MODULE  'exec/lists'
MODULE  'tools/constructors'
MODULE  'newgui/newlistview'
MODULE  'newgui/newgui'

CONST   GUI_MAIN=1

DEF     result=-1
DEF     n:PTR TO newlistv

PROC main() HANDLE
 DEF list, a, nodes
  list:=newlist()
   nodes:=['zero','one','two','three','four','five','six','seven',
          'eight','nine','ten','eleven','twelve','thirteen','fourteen']
    ForAll({a}, nodes, `AddTail(list, newnode(NIL, a)))
     newguiA([
        NG_WINDOWTITLE, 'NewGUI-DoubleClick-ListView-Plugin',     
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
        NG_GUIID,       GUI_MAIN,
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [FILLPATTERN1,
                [ROWS,
                [TEXT,'Double-Click ListView test...',NIL,TRUE,1],
                [SPACE],
                [NEWLISTV,{listaction},NEW n.newlistv('DoubleClick-ListView', 15,7, list,result,NIL,FALSE)]]]],
        [EQCOLS,
                [BUTTON,{okaction},'OK'],
                [BUTTON,{disabler},'Toggle Enabled']
        ]],NIL,NIL])

EXCEPT DO
 END n
  IF exception
   WriteF('Exception = \d\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC listaction(x,y,gui)
  IF n.clicked THEN okaction(x,y,gui)
  WriteF('Current Selection: \d\n',n.current)
ENDPROC

PROC okaction(x,y,gui)
  IF (result:=n.current)= -1
    WriteF('No selection made\n')
    cancelaction()
  ENDIF
  WriteF('Final Selection: \d\n',result)

ENDPROC

PROC disabler() IS n.setdisabled(n.disabled=FALSE)

PROC cancelaction()
  WriteF('Operation cancelled.\n')
ENDPROC

