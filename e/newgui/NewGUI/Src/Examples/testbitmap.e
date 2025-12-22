OPT     OSVERSION = 37

MODULE  'graphics/rastport'
MODULE  'intuition/screens'
MODULE  'newgui/newgui'
MODULE  'newgui/ng_showerror'

CONST   GUI_MAIN = 1

ENUM    ERR_WORKBENCH=100

DEF     wb:PTR TO screen,
        bfbitmap,
        bitmap1

PROC main()     HANDLE
 getbitmaps()
  newguiA([
        NG_WINDOWTITLE,         'NewGUI - Demo',        -> Titel des Fensters
        NG_BFBITMAP,            bfbitmap,               -> Backfillbitmap
        NG_BITMAPWIDTH,         200,
        NG_BITMAPHEIGHT,        200,
        NG_BITMAP1,             bitmap1,
        NG_PATTERNEXP,          1,                      -> Exponent für den Pattern
        NG_PATTERN1,            [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN1
        NG_P1BACKPEN,           0,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P1FRONTPEN,          0,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_GUIID,               GUI_MAIN,               -> Gui-ID
        NG_GUI,         
                [EQROWS,
                [DBEVELR,                               -> Recessed Double-Bevel!
                [FILLPATTERN1,                          -> Group-Filling with a Pattern (NOTE: There MUST a COLS, ROWS, EQCOLS or EQROWS present below this Element!)
                [EQROWS,  
                [SPACE],
                        [TEXT,'Pattern Filling and','BitMap-Backfilling,',FALSE,3],
                [SPACE],
                        [TEXT,'Features in NewGUI!','BitMap-Groupfilling!',FALSE,3],
                [SPACE],
                [BEVELR,
                [FILLBITMAP1,                           -> Fill this Group with a bitmap (Bitmap1)
                [EQROWS,
                        [TEXT,' ',' ',FALSE,3],
                        [SPACE],
                        [TEXT,' ',' ',FALSE,3]
                ]]],
                [SPACE],
                        [TEXT,' ',' ',FALSE,3]]]],
                [BEVELR,
                [ROWS,
                [BAR],
                        [SBUTTON,0,'Ende']]]]
        ,NIL,NIL])
EXCEPT DO
 freebitmaps()
  IF exception THEN ng_showerror(exception)             -> Print Exceptions for NewGUI
 CleanUp(exception)
ENDPROC

PROC getbitmaps()
 IF (wb:=LockPubScreen('Workbench'))=NIL THEN Raise(ERR_WORKBENCH)
  bfbitmap:=wb.rastport.bitmap
   bitmap1:=wb.rastport.bitmap
ENDPROC

PROC freebitmaps()
 IF (wb<>NIL) THEN UnlockPubScreen(NIL,wb)
ENDPROC
