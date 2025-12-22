MODULE cond;

FROM SYSTEM IMPORT ADDRESS,SETREG,CAST,ASSEMBLE,ADR;
IMPORT io:InOut;

VAR i:INTEGER;
    c:INTEGER;
    r:REAL;

(*$ RangeChk- StackChk- ReloadA4+ *)

(*$ SET TimesOne *)

(*$ IF TimesOne *)

PROCEDURE times(x,y{7}:INTEGER):INTEGER; INLINE;
VAR i:INTEGER;
BEGIN
 i:=x*y;
 RETURN i;
END times;

(*$ ELSE *)

PROCEDURE times(x,y{7}:INTEGER):INTEGER; INLINE;
BEGIN
 RETURN x+y;
END times;

(*$ ENDIF *)


BEGIN
 io.WriteInt(times(3,4),3);
END cond.
