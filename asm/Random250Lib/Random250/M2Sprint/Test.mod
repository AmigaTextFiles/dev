MODULE Test;

IMPORT Debug;

FROM Libraries IMPORT CloseLibrary, OpenLibrary;

FROM Memory IMPORT AllocMem, FreeMem, MEMF_ANY, MEMF_CLEAR;

FROM Random250 IMPORT Random250Array, Random250Base, Random250Long, Random250Name;

FROM SYSTEM IMPORT ADR, TERMPROC;

FROM TermInOut IMPORT Read, WriteCard, WriteLn, WriteString, WriteLongHex,
WriteLongInt, Write, WriteInt, WriteLongCard;


CONST

  NUMBEROFBINS = 16;
  BINSIZE = 40000000H DIV (NUMBEROFBINS DIV 4); (* Avoid overflow problems *)
  BATCHSIZE = 6400;
  EXPECTEDCOUNT = BATCHSIZE DIV NUMBEROFBINS;


VAR

  ANumber : LONGCARD;
  Bins : ARRAY [0..NUMBEROFBINS] OF CARDINAL;
  Count : CARDINAL;
  ErrorAmount : INTEGER;
  ErrorHappened : BOOLEAN;
  ErrorSquaredAmount : LONGCARD;
  I, J : CARDINAL;
  NumberArray : POINTER TO LONGCARD;
  NumberPntr : POINTER TO LONGCARD;
  TotalError : INTEGER;
  TotalErrorSquared : LONGCARD;


PROCEDURE CleanUp;

(* Termination procedure.  Close open windows, files, etc. *)

VAR

  JunkBool : BOOLEAN;

BEGIN
  IF Random250Base <> NIL THEN
    CloseLibrary (Random250Base);
    Random250Base := NIL;
  END;

  IF NumberArray <> NIL THEN
    FreeMem (NumberArray, BATCHSIZE * SIZE (NumberArray ^));
    NumberArray := NIL;
  END;
END CleanUp;


BEGIN
  NumberArray := NIL;
  Random250Base := NIL;
  ErrorHappened := FALSE;

  TERMPROC (CleanUp);

  Random250Base := OpenLibrary (ADR (Random250Name), 0);
  IF Random250Base = NIL THEN
    WriteString ("Error while opening random number library.\n");
    ErrorHappened := TRUE;
  END;

  IF NOT ErrorHappened THEN
    NumberArray := AllocMem (BATCHSIZE * SIZE (NumberArray ^),
    MEMF_CLEAR + MEMF_ANY);
    IF NumberArray = NIL THEN
      WriteString ("Can't allocate memory for random number storage.\n");
      ErrorHappened := TRUE;
    END;
  END;

  IF NOT ErrorHappened THEN
    FOR I := 1 TO 10 DO
      WriteString ("Random number ");
      WriteCard (I, 3);
      WriteString (" is ");
      WriteLongHex (Random250Long (), 8);
      WriteLn;
    END;

    FOR I := 0 TO NUMBEROFBINS DO
      Bins [I] := 0;
    END;

    WriteString ("Generating ");
    WriteLongInt (BATCHSIZE, 1);
    WriteString (" random numbers... ");

    Random250Array (BATCHSIZE, NumberArray);

    WriteString ("Done.\n");

    NumberPntr := NumberArray;
    FOR I := 0 TO BATCHSIZE-1 DO
      ANumber := NumberPntr ^;
      J := ANumber DIV BINSIZE;
      INC (Bins [J]);
      INC (NumberPntr, SIZE (NumberPntr ^));
    END;

    WriteString ("Each bin should have ");
    WriteCard (EXPECTEDCOUNT, 1);
    WriteString (" counts in it on the average.\n");

    Count := 0;
    TotalError := 0;
    TotalErrorSquared := 0;
    FOR I := 0 TO NUMBEROFBINS-1 DO
      INC (Count, Bins [I]);
      ErrorAmount := Bins [I] - EXPECTEDCOUNT;
      INC (TotalError, ErrorAmount);
      ErrorSquaredAmount := ErrorAmount * ErrorAmount;
      INC (TotalErrorSquared, ErrorSquaredAmount);

      WriteString ("Bin ");
      WriteCard (I, 3);
      WriteString (" count is ");
      WriteCard (Bins [I], 4);
      WriteString (", error is ");
      WriteInt (ErrorAmount, 3);
      WriteString (", error squared is ");
      WriteLongCard (ErrorSquaredAmount, 4);
      WriteLn;
    END;

    WriteString ("Count of bins is ");
    WriteCard (Count, 1);
    WriteString (" of ");
    WriteCard (BATCHSIZE, 1);
    WriteString (".\n");

    WriteString ("Total error is ");
    WriteInt (TotalError, 1);
    WriteString (".\n");

    WriteString ("Total error squared is ");
    WriteLongCard (TotalErrorSquared, 1);
    WriteString (".\n");

  END;
END Test.
