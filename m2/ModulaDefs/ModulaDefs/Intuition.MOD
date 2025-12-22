(************************************
 * Name : Intuition.MOD             *
 * Function : interface to intuition*
 *            lib. functions        *
 ************************************)

IMPLEMENTATION MODULE Intuition;

FROM SYSTEM    IMPORT ADDRESS,ADR,BYTE,LONG;
FROM AMIGABase IMPORT ExecBase,ExecOpenLib,LibCall,Regs;

CONST openwindow   = -204D;
      closewindow  = -72D;
      openscreen   = -198D;
      closescreen  = -66D;
      viewpad      = -300D;

VAR
    intuibase : LONGINT;
    r: Regs;

PROCEDURE OpenWindow(VAR nw: NewWindow): WindowPtr;

BEGIN
   r.a[0] := ADR(nw);
   LibCall(intuibase,openwindow,r);
   RETURN WindowPtr(r.d[0]);
END OpenWindow;

PROCEDURE CloseWindow(w: WindowPtr);

BEGIN
   r.a[0] := LONGINT(w);
   LibCall(intuibase,closewindow,r);
END CloseWindow;

PROCEDURE OpenScreen(VAR ns: NewScreen):LONGINT;

BEGIN
   r.a[0] := ADR(ns);
   LibCall(intuibase,openscreen,r);
   RETURN r.d[0];
END OpenScreen;

PROCEDURE CloseScreen(s : LONGINT);

BEGIN
  r.a[0] := s;
  LibCall(intuibase,closescreen,r);
END CloseScreen;

PROCEDURE ViewPortAddress(w: WindowPtr) : ADDRESS;

BEGIN
  r.a[0] := ADDRESS(w);
  LibCall(intuibase,viewpad,r);
  RETURN ADDRESS(r.d[0]);
END ViewPortAddress;

PROCEDURE ShowTitle(scrn:LONGINT;OnOff:BOOLEAN);

BEGIN
  r.a[0] := scrn;
  r.d[0] := 0;
  IF OnOff THEN r.d[0] := -1 END;
  LibCall(intuibase,-282D,r);
END ShowTitle;


VAR st : ARRAY[0..30] OF CHAR;

BEGIN
   st := 'intuition.library';
   r.a[1] := ADR(st);
   r.d[0] := 0D;
   LibCall(ExecBase(),ExecOpenLib(),r);
   intuibase := r.d[0];
END Intuition.


