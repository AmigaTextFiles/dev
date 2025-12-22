MODULE CFunc;

IMPORT
  d   := Dos,
  e   := Exec,
  y   := SYSTEM;

(*///-------------- time.c / time.h ---------------------- *)

TYPE
  timeTPtr  = UNTRACED POINTER TO timeT;
  timeT     = LONGINT;
  clockTPtr = UNTRACED POINTER TO clockT;
  clockT    = LONGINT;

(*
extern long __gmtoffset;
*)
  PROCEDURE DiffTime*( a, b : timeT ): LONGINT;
    BEGIN
      RETURN( y.VAL( LONGINT, a - b ));
    END DiffTime;

  PROCEDURE Time*( tloc : timeTPtr ) : timeT;
  (*
   * 2922 is the number of days between 1.1.1970 and 1.1.1978 (2 leap years and 6 normal)
   * 1440 is the number of minutes per day
   *   60 is the number of seconds per minute
   *)
    VAR
      ti : timeT;
      t  : d.DateTime;
    BEGIN
      d.DateStamp(t.stamp); (* Get timestamp *)
      ti:= y.VAL( timeT, (( t.stamp.days + 2922 ) * 1440 + t.stamp.minute (*+ __gmtoffset*) )
                         * 60 + ( t.stamp.tick / d.ticksPerSecond ));
      IF tloc # NIL THEN tloc^:= ti END;
      RETURN ti;
    END Time;

(*//------------- stdlib.h / stdlib.c ----------------------*)

(* Compare strings - case insensitive *)

  PROCEDURE StriCmp*( s, d : ARRAY OF CHAR ) : LONGINT;
  (* $CopyArrays- *)
  VAR
    i : LONGINT;
  BEGIN
    WHILE CAP(s[i]) = CAP(d[i]) DO
      IF s[i] = "\o" THEN RETURN 0 END;
      INC( i );
    END;
    IF CAP(s[i]) < CAP(d[i]) THEN RETURN -1 ELSE RETURN 1 END;
  END StriCmp;


PROCEDURE MemSet*( s : e.APTR; c : INTEGER; n : LONGINT );
  VAR ptr : e.LSTRPTR;
  BEGIN
    ptr:= s;
    WHILE n # 0 DO
      ptr[n-1]:= CHR(c);
      DEC( n )
    END;
  END MemSet;
(*
void *memset(void *s,int c,size_t n)
{
    char *p=(char * )s;
    while(n) {n--;*p++=c;}
    return(s);
*)
END CFunc.
