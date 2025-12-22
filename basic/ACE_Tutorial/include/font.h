{ change font for the current window/screen. }
         
SUB FontSet(FontName$,FontHeight%)
dim tAttr&(2)

DECLARE FUNCTION OpenDiskFont& LIBRARY diskfont
DECLARE FUNCTION CloseFont LIBRARY graphics
DECLARE FUNCTION OpenFont& LIBRARY graphics
DECLARE FUNCTION SetFont LIBRARY graphics

CONST Font=52
CONST TxWidth=60

LIBRARY diskfont
LIBRARY graphics

  f.old&     = *&(WINDOW(8)+Font)
  f.pref%    = 0
  FontName0$ = FontName$ + ".font"
  tAttr&(0)  = SADD(FontName0$)
  tAttr&(1)  = FontHeight%*2^16 + f.pref%
  f.new&     = OpenFont&(@tAttr&)  '..ROM font?
  f.check%   = *%(WINDOW(8)+TxWidth)
  
  '..disk font -> open it
  IF f.new& = 0& THEN
    f.new& = OpenDiskFont&(@tAttr&)
  ELSE
   IF f.check% <> FontHeight% THEN
    CloseFont(f.new&)
    f.new& = OpenDiskFont&(@tAttr&)
   END IF
  END IF
  
  '..font OK -> set it for current rastport.
  IF f.new& <> 0& THEN
    CloseFont(f.old&)
    SetFont(WINDOW(8),f.new&)
  ELSE
    IF UCASE$(FontName$) = "UNDO" THEN
      CloseFont(f.old&)
      SetFont(WINDOW(8),original&)
    END IF
  END IF

  LIBRARY CLOSE graphics
  LIBRARY CLOSE diskfont
END SUB
