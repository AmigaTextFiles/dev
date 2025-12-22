MODULE test;
(* This is a simple m2 source program designed to test m2pascal.
*)

FROM InOut      IMPORT  WriteString,    WriteLn,    WriteInt;

FROM Storage    IMPORT  ALLOCATE, DEALLOCATE;


CONST
        C1    =    10;


TYPE
        ConnectPtr  =  POINTER TO ConnectType;	
	ConnectType =  RECORD
			node    : INTEGER;
			next    : ConnectPtr;		
	END;

	ArrayType = ARRAY [ 1.. C1 ] OF  BOOLEAN;

VAR  
        v1int           : INTEGER;
        v2card          : CARDINAL;
        v3real          : REAL;

PROCEDURE proc1() : INTEGER;
BEGIN
    IF C1 = 10 THEN
        RETURN C1;
    ELSE
        RETURN 0;
    END;
END proc1;

BEGIN (* main *)
   v1int   :=   1;
   v2card  :=   2;
   v3real  :=   3.0;

           (* Test while loop *)
   WHILE ( v1int < 2 ) DO
        DEC ( v1int );
   END;


          (* Test repeat loop *)
   REPEAT
       v1int := 1;
   UNTIL ( v1int < 2 ) ;

   WriteString (" Simple test program written in Module-2 to \n");
   WriteString (" demonstrate m2pascal (type more test.mod to see) \n\n");
END test.

