
MODULE GLTriangle;
(*
 * Aus AmigaMagazin 5/97, S. 30
 *)
IMPORT
  y: SYSTEM, I: Intuition, e: Exec, u: Utility, 
  r: Random,
  gl: CyberGL;

CONST
  WIDTH    * = 400;
  HEIGHT   * = 400;

VAR
  window: gl.voidPtr;

PROCEDURE HandleWindowEvents (window: I.WindowPtr);
VAR
  msg : I.IntuiMessagePtr;
  done: BOOLEAN;
  ls  : LONGSET;
BEGIN
  done := FALSE;
  WHILE ~done DO
    ls := e.Wait (LONGSET{window.userPort.sigBit});
    LOOP
       msg := e.GetMsg (window.userPort); IF msg = NIL THEN EXIT END;
       IF I.closeWindow IN msg.class THEN done := TRUE END;
       e.ReplyMsg (msg);
       IF done THEN EXIT END;
    END; (* LOOP *)
  END; (* WHILE *)
END HandleWindowEvents;

BEGIN
  window  := gl.openGLWindowTags (WIDTH, HEIGHT, gl.waTitle, y.ADR("Triangle Test"),
                                             gl.waIDCMP, LONGSET{I.closeWindow, I.vanillaKey},
                                             gl.waCloseGadget, I.LTRUE,
                                             gl.waDepthGadget, I.LTRUE,
                                             gl.waDragBar,     I.LTRUE,
                                             gl.waActivate,    I.LTRUE,
                                             gl.waRGBAMode,    gl.true,
                                             u.done);

  IF window # NIL THEN
     gl.Clear (LONGSET{gl.colorBuffer,gl.depthBuffer});

     gl.Begin (gl.cTriangles);
        gl.Vertex2d (-0.9, -0.9);
        gl.Vertex2d ( 0.9, -0.7);
        gl.Vertex2d (-0.6,  0.9);
     gl.End;

     HandleWindowEvents (gl.getWindow (window));
  END;

CLOSE
  IF window # NIL THEN
     gl.closeGLWindow (window);
  END;
END GLTriangle.
