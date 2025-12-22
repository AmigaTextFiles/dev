
/*** $VER DT_FindAllMem 1.0 (28.02.94) ***/

Options Results

Address DT.1

IF ~open('console','RAW:0/100/508/202/DTFindAll/CLOSE/SCREENDTSCREEN.1','W') THEN EXIT 20

t=0

GETEX '?Search string:'

tofind=Result

again:

Do Forever
    xx='SEG'||t
    xx2='END'||t

    Calc xx
     IF RC~=0 THEN
	DO
	CALL WriteLN('console','Number of Segments: '||t)

	ADDRESS Command Wait 3;

	EXIT;
	END;

    seg.t=X2D(Result)
    Calc xx2
    end.t=X2D(Result)

    CALL WriteLN('console','Search seg '||t||': $'||D2X(seg.t)||' to '||D2X(seg.t))

    finddsm seg.t end.t tofind

 IF RC=7 THEN
   DO
    Call WriteLn('console','Found in seg '||t);
   END
   ELSE 
     DO
      IF RC=8 then
       DO
        CALL WriteLN('console','Userbreak')
	CALL WriteLN('console','Number of Segments: '||t)

	ADDRESS Command Wait 3;

	Exit
	END 
   END;

 t=t+1
End

exit;
