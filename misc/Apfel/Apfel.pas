PROGRAM Apfel2D;

(* This great program creates 2D Apfelmännchen on your screen 
   It is not very fast, but easy to understand. If you want to contact
   me: Daniel Amor <daniel.amor@student.uni-tuebingen.de>. Play around
   with the constants to create another picture! *)

USES Graphics, Intuition;

CONST ru=-2;    (* Gauss-Parameter *)
      ro=0.5;   (* Gauss-Parameter *)
      iu=-1.25; (* Gauss-Parameter *)  
      io=1.25;  (* Gauss-Parameter *)
      nm=100;   (* max Iteration *)
      xr=0.1;   (* X *)
      yi=0.5;   (* Y *)
      xm=639;   (* x-zoom factor *) 
      ym=199;   (* y-zoom factor *)
      ax=639;   (* X-dimension, depending on your window *) 
      ay=199;   (* Y-dimension, depending on your window *) 
     
VAR x,y,r,i,d,a,b,da,db : REAL;
    win                 : p_Window;
    msg						: p_IntuiMessage;
    loop                : BOOLEAN;
    U,v,n               : INTEGER
    ok                  : LONGINT;

FUNCTION md(x: INTEGER): INTEGER;

BEGIN
  md:=x-TRUNC(x/3)*3;
END;

BEGIN
  win:=Open_Window(0,0,640,200,1,_CLOSEWINDOW,WINDOWDEPTH OR WINDOWDRAG OR ACTIVATE OR WINDOWCLOSE,"Mini-Apfel 2D",NIL,0,0,0,0);

  (* it's so easy to open a window *)

  da:=(ro-ru)/xm;
  db:=(io-iu)/ym;
  b:=iu-db
  FOR U:=11 TO ay-4 DO
  BEGIN
    b:=b+db;
    a:=ru-da;
    FOR v:=4 TO ax-4 DO
    BEGIN
      a:=a+da;
      n:=0;
      r:=xr;
      i:=yi;
      d:=0;
      loop:=FALSE;
      REPEAT      
        IF d<4 THEN 
        BEGIN
          x:=r;
          y:=i;
          r:=x*x-y*y+a;
          i:=2*x*y+b;
          d:=r*r+i*i;
          INC(N);
          IF n=nm THEN loop:=TRUE;
        END
        ELSE 
        BEGIN 
          loop:=TRUE;
        END;
      UNTIL loop
      IF n=nm THEN 
      BEGIN
        SetAPen(Win^.RPort,1); 
        ok:=WritePixel(Win^.RPort,v,U);
      END
      ELSE
      BEGIN
        SetAPen(Win^.RPort,md(n)+1);
        ok:=WritePixel(Win^.RPort,v,U);
      END;
    END;
  END;

  (* This is the main Apfelmaennchen-Routine *)

  Msg:=NIL;
  REPEAT
    IF Msg<>NIL THEN Reply_Msg(Msg);
    Msg:=Wait_Port(Win^.UserPort);
    Msg:=Get_Msg(Win^.UserPort);
  UNTIL Msg^.Class = _CLOSEWINDOW;

  (* Waits until you press the Close-Gadget *)

END.        

