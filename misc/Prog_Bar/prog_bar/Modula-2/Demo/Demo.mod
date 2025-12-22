MODULE Demo;

IMPORT
   P := prog_bar,
   I := Intuition,
   E := Exec,
   GT := GadTools,
   G := Graphics,
   U := Utility,
   D := Dos;

VAR
      p_bar : P.PBarPtr;
      win : I.WindowPtr;
      scr : I.ScreenPtr;
      vi : GT.VisualInfoPtr;
      done : BOOLEAN;
      valu, delta, size : INTEGER;

BEGIN

   scr := I.LockPubScreen(NIL);
   IF scr <> NIL THEN
      vi := GT.GetVisualInfo(scr, NIL);
      IF vi <> NIL THEN
         win := I.OpenWindowTags(NIL,
                  I.WA_Title, " Prog_Bar Demo Program from Modula-2",
                  I.WA_Width,          500,     I.WA_Height,         100,
                  I.WA_CloseGadget,    FALSE,   I.WA_DepthGadget,    TRUE,
                  I.WA_DragBar,        TRUE,    I.WA_Activate,       TRUE,
                  I.WA_IDCMP,          {},
                  U.TAG_DONE);
         IF win <> NIL THEN

            size := 200;
            delta := 1;

            p_bar := P.CreateProgBar( win, 50, 40, 400, 25, size,
                     P.PB_BorderType,     P.PBBT_RIDGE,
                     P.PB_TextMode,       P.PBTM_VALUE,
                     P.PB_TextPosition,   P.PBTP_CENTRE,
                     U.TAG_DONE);
            IF p_bar <> NIL THEN

               done := FALSE;
               valu := 1;

               WHILE done = FALSE DO
                  D.Delay(5);
                  P.UpdateProgBar(p_bar, valu );
                  valu := valu + delta;
                  IF valu > size THEN
                     IF delta = 1 THEN
                        delta := 5;
                        valu := 0;
                        D.Delay(100);
                        P.SetProgBarAttrs(p_bar, P.PB_BorderType, P.PBBT_RECESSED,
                                                 P.PB_Direction,  P.PBDE_LEFT,
                                                 P.PB_TextMode,   P.PBTM_PERCENT,
                                                 U.TAG_DONE);
                     ELSE
                        done := TRUE;
                     END;
                  END;
               END;

               P.FreeProgBar(p_bar);
            END;

            I.CloseWindow(win);
         END;

         GT.FreeVisualInfo(vi);
      END;

      I.UnlockPubScreen(NIL, scr);
   END;

END Demo.
