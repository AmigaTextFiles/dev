/* 
 *  Bitmap-Plugin
 * -=============-
 * 
 * Zeigt eine Bitmap in einem NewGUI-Fenster an!
 * 
 * 
 */

OPT OSVERSION=37
OPT     LARGE

MODULE  'graphics/rastport'
MODULE  'intuition/screens'
MODULE  'newgui/newgui'
MODULE  'newgui/pl_bitmap'
MODULE  'newgui/ng_showerror'

DEF     wb:PTR TO screen,
        bmp:PTR TO bmp,
        x=100,
        y=100

PROC main()     HANDLE
 DEF    res=0
  IF (wb:=LockPubScreen('Workbench'))
   res:=newguiA([
        NG_WINDOWTITLE, 'NewGUI-VirtualPlugin',     
        NG_GUI,
        [ROWS,
                [DBEVELR,
        [ROWS,
        [COLS,
                [BITMAP,{dummy},NEW bmp.bmp(200,100,wb.rastport.bitmap,FALSE)],
                [SLIDE,{scrolly},NIL,TRUE,0,wb.height-200,0,10,3,NIL]],
        [ROWS,
                [SLIDE,{scrollx},NIL,FALSE,0,wb.width-100,10,3,NIL]
        ]]],
        [BAR],
        [COLS,
                [BUTTON,{dummy},'Jump around']]],
        NIL,NIL])

  ENDIF
EXCEPT DO
 IF (wb<>NIL)
   END bmp
  IF wb THEN UnlockPubScreen(NIL,wb)
 ELSE
  WriteF('Kann Workbench-Schirm nicht finden!\n')
 ENDIF
 IF exception THEN ng_showerror(exception)
CleanUp(exception)
ENDPROC

PROC dummy()                                                    /* Ein Dummy...                         */
 DEF    oldx=0,
        oldy=0
  oldx,oldy:=bmp.jump(x,y)
   x:=oldx
    y:=oldy
ENDPROC                                                         /* Ende der Prozedur                    */

PROC scrollx(v,w)       IS bmp.jump(w,-1)

PROC scrolly(v,w)       IS bmp.jump(-1,w)
