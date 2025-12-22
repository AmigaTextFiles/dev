OPT     OSVERSION = 37
OPT     PREPROCESS
OPT     LARGE

MODULE  'graphics/gfxmacros'
MODULE  'graphics/rastport'
MODULE  'intuition/screens'
MODULE  'newgui/newgui'
MODULE  'newgui/ng_fillhook'
MODULE  'newgui/ng_showerror'

CONST   GUI_MAIN = 1

ENUM    ERR_WORKBENCH=100

DEF     wb:PTR TO screen,
        bitmap

PROC main()     HANDLE
 getbitmaps()
  newguiA([
        NG_WINDOWTITLE,         'NewGUI - Demo',        -> Titel des Fensters
        NG_FILLHOOK,            {fillrect},             -> Prozedur zum Füllen einer Gruppe/Fensterhintergrund!
        NG_GUIID,               GUI_MAIN,               -> Gui-ID
        NG_GUI,         
                [EQROWS,
                [DBEVELR,
                [FILLGROUP1,                            -> Füllgruppe 1
                [EQROWS,  
                [SPACE],
                        [TEXT,'Pattern Filling and','BitMap-Backfilling,',FALSE,3],
                [SPACE],
                        [TEXT,'Features in NewGUI!','BitMap-Groupfilling!',FALSE,3],
                [SPACE],
                [BEVELR,
                [FILLGROUP2,                            -> Füllgruppe 2 (Bitmap!)
                [EQROWS,
                        [DBEVELR,
                        [EQROWS,
                                [SPACE],
                        [DBEVELR,
                        [EQROWS,
                                [SPACE]
                        ]],
                                [SPACE]
                        ]]
                ]]],
                [SPACE],
                        [TEXT,' ',' ',FALSE,3]]]],
                [BEVELR,
                [ROWS,
                        [SBUTTON,0,'Ende']]]]
        ,NIL,NIL])
EXCEPT DO
 freebitmaps()
  IF exception THEN ng_showerror(exception)             -> Print Exceptions for NewGUI
 CleanUp(exception)
ENDPROC

PROC getbitmaps()
 IF (wb:=LockPubScreen('Workbench'))=NIL THEN Raise(ERR_WORKBENCH)
  bitmap:=wb.rastport.bitmap                            -> This is really bad because a programm shouldn't
                                                        -> grab a screens bitmap if it doesn't own this screen
                                                        -> but this is only for demonstration!
ENDPROC

PROC freebitmaps()
 IF (wb<>NIL) THEN UnlockPubScreen(NIL,wb)
ENDPROC

PROC fillrect(rp,x,y,width,height,type)
 DEF    oldbpen=0,
        oldapen=1
  SELECT        type
        CASE    NG_FILL_WINDOW                          -> Window-Filling (Back)
         ng_FillBitMapPattern(rp,x,y,width,height,bitmap,100,100)       -> Patterfilling mit einer Bitmap
        CASE    FILLGROUP1                              -> Füllgruppe 1
         oldbpen:=SetBPen(rp,0)                         -> Hintergrund = schwarz
          oldapen:=SetAPen(rp,0)                        -> Vordergrund = blau
           SetAfPt(rp,[$FFFF,$FFFF]:INT,1)              -> Füllmuster setzen (ACHTUNG! Makrodefinition in "gfxmacros", PREPROCESS wird benötigt!)
            RectFill(rp,x,y,width,height)               -> Füllen ...
           SetBPen(rp,oldbpen)                          -> Hintergrundfarbe wieder auf alten Stand
          SetAPen(rp,oldapen)                           -> Vordergrundfarbe wieder auf alten Stand
        CASE    FILLGROUP2                              -> Füllgruppe 2
         ng_FillBitMapPattern(rp,x,y,width,height,bitmap,100,100)       -> Patterfilling mit einer Bitmap
/*      ...     ...
        CASE    FILLGROUP6
        ...     ...                                     */
  ENDSELECT
ENDPROC
