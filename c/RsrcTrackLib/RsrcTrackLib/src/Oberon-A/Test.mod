(**************************************************************************

  Test.mod

  Simple example of using the Oberon-A interface to ressourcetracking.library

  Date: 30-08-1998
  Author: BURNAND Patrick

***************************************************************************)


<*STANDARD-*>
<*MAIN+*>


MODULE Main;


IMPORT   rt := ressourcetracking,  E := Exec,  sys := SYSTEM,  d := Dos;


CONST
    n = 10240;


TYPE
    tcha = ARRAY n OF CHAR;
    tchap = POINTER TO tcha;


VAR
    chap : tchap;
    i : INTEGER;


BEGIN
    IF  rt.AddManager(2) # 0  THEN
        chap := sys.VAL (tchap, rt.AllocMem (n, {E.memClear}));
        IF  chap#NIL  THEN
            FOR  i := 0 TO n-1  DO
                chap[i] := 'A';
            END;
        END;
    END;
    rt.RemManager();
END Main.


