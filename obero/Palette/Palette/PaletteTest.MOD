(*---------------------------------------------------------------------------
    :Program.    PaletteTest.mod
    :Author.     Daniel Amor
    :Address.    Ludwigstr. 124, D-70197 Stuttgart, Germany
    :Version.    1.01
    :Date.       31-May-94
    :Copyright.  PD
    :Language.   Oberon-2
    :Translator. Amiga Oberon 3.0
    :Imports.    Palette [da].
    :Contents.   Testet Palette-Fenster.
---------------------------------------------------------------------------*)

MODULE PaletteTest;

IMPORT I:   Intuition,
       gt:  GadTools,
       e:   Exec,
       u:   Utility,
       pal: Palette,
       req: Requests;

VAR Scr        : I.ScreenPtr;
    VisualInfo : e.APTR;
    ColRec     : pal.colourRecord;

PROCEDURE SetupScreen (): INTEGER;

BEGIN
  Scr := I.LockPubScreen (NIL);  IF Scr = NIL THEN RETURN 1 END;

  VisualInfo := gt.GetVisualInfo (Scr, u.done);
  IF VisualInfo = NIL THEN RETURN 2 END;

  RETURN 0;
END SetupScreen;

PROCEDURE CloseDownScreen;

BEGIN
  IF VisualInfo # NIL THEN
    gt.FreeVisualInfo (VisualInfo);
    VisualInfo := NIL;
  END;
  IF Scr # NIL THEN
    I.UnlockPubScreen (NIL, Scr);
    Scr := NIL;
  END;
END CloseDownScreen;

BEGIN
  IF SetupScreen()=0 THEN pal.ShowPalette(Scr,ColRec,3); END;
CLOSE
  CloseDownScreen;
END PaletteTest.
