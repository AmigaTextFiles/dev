MODULE Mandel;

(* Mandel converted from Oberon demo *)
(* Written in Cyclone Modula-2 V0.80 by Marcel Timmermans *)

FROM SYSTEM IMPORT ADDRESS,ADR,SHIFT,TAG;
IMPORT id:IntuitionD,il:IntuitionL,ud:UtilityD,ed:ExecD,el:ExecL,gl:GraphicsL,
       ml:ModulaLib,NoGuru;


CONST
    LTRUE=1;
    COLORS=16;
    DEPTH=4;

VAR
 scr:id.ScreenPtr;
 sw,sh,x,y,i:INTEGER;
 sr,si,st,zi,zr,ar,ai,dr,di,Colors:LONGINT;

BEGIN
 scr:=il.OpenScreenTagList(NIL,[id.saLikeWorkbench,LTRUE,id.saTitle,ADR("Mandel"),id.saDepth,DEPTH,0]);
 ml.Assert(scr#NIL,ADR("Cannot open screen!!"));
 WITH scr^ DO
  sw:=width;
  sh:=height;
 END;
 x:=256 DIV (COLORS*2);
 FOR i:=0 TO COLORS-1 DO gl.SetRGB32(ADR(scr^.viewPort),i,SHIFT(i*x,26),0,SHIFT(i*x,26)); END;
 sr:=400000H DIV sw;
 si:=300000H DIV sh;
 st:=140000H *-2;
 zi:=160000H;

 FOR y:=sh-1 TO 15 BY -1 DO
     DEC(zi,si);
     zr:=st;
     FOR x:=0 TO sw-1 DO
         i:=0; ar:=zr; ai:=zi;
         REPEAT
             dr:=ar DIV 400H;
             di:=ai DIV 400H;
             ai:=2*dr*di+zi;
             dr:=dr*dr; di:=di*di;
             ar:=dr-di+zr;
             INC(i);
         UNTIL (i>COLORS) OR (dr+di>400000H);
         WITH scr^ DO
          gl.SetAPen(ADR(rastPort),i MOD COLORS);
          IF gl.WritePixel(ADR(rastPort),x,y) THEN END;
         END;
         INC(zr,sr);
     END;
 END;
 ml.TerminateRequester(ADR("That's all folks!"));
CLOSE
 IF scr#NIL THEN il.CloseScreen(scr); END;
END Mandel.
