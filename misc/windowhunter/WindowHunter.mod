MODULE WindowHunter;
 
  FROM Screens IMPORT CloseScreen;
  FROM SYSTEM IMPORT NULL, BYTE, ADDRESS, ADR;
  FROM Windows IMPORT OpenWindow, CloseWindow;
  FROM Libraries IMPORT OpenLibrary, CloseLibrary;
  FROM InOut IMPORT WriteString, WriteLn, ReadCard, WriteCard, Read;
  FROM Intuition IMPORT IntuitionName, IntuitionBase, NewWindow, WindowPtr,
		IDCMPFlags, IDCMPFlagSet, WindowFlags, WindowFlagSet,
		ScreenFlags, ScreenFlagSet, ScreenPtr;
 
  TYPE
    CHARSET = SET OF CHAR;
 
  CONST
    NOSET = CHARSET {'N', 'n'};
    YESSET = CHARSET {'Y', 'y'};
    YESNOSET = CHARSET {'Y', 'y', 'N', 'n'};
 
  VAR
    myNW: NewWindow;
    delScreenYesNo: CHAR;
    huntScreen: ScreenPtr;
    myWin, hunter: WindowPtr;
    hunting: ARRAY[0..10] OF CHAR;
    screenList: ARRAY[0..64] OF ScreenPtr;
    windowList: ARRAY[0..64] OF WindowPtr;
    deleteMe, counter, counter2, whichScreen: CARDINAL;
    prey: ARRAY[0..40] OF POINTER TO ARRAY[0..40] OF CHAR;
 
  BEGIN
    counter := 0;
    hunting := 'Hunting...';
    IntuitionBase := OpenLibrary(IntuitionName, 0);
    WITH myNW
      DO
	LeftEdge := 0; TopEdge := 0; Width := 100; Height := 20;
	FirstGadget := NULL; CheckMark := NULL; Title := ADR(hunting);
	Screen := NULL; BitMap := NULL; Type := ScreenFlagSet {WBenchScreen};
      END; (* WITH *)
    myWin := OpenWindow(myNW);
    huntScreen := myWin^.WScreen;
    REPEAT
	prey[counter] := ADDRESS(huntScreen^.Title);
	screenList[counter] := huntScreen;
	huntScreen := huntScreen^.NextScreen;
	INC(counter);
    UNTIL (huntScreen = myWin^.WScreen) OR (huntScreen = NULL) OR
						(counter > 64);
    FOR counter2 := 0 TO (counter - 1)
      DO
	WriteCard(counter2, 5); WriteString('> ');
	WriteString(prey[counter2]^); WriteLn;
      END; (* FOR *)
    WriteString('Which screen? '); ReadCard(whichScreen);
    hunter := screenList[whichScreen]^.FirstWindow;
    IF whichScreen < counter
      THEN
      IF hunter # NULL
        THEN
      REPEAT
        WriteString('Delete entire screen? (Y/N) ');
        Read(delScreenYesNo);
      UNTIL delScreenYesNo IN YESNOSET;
      counter := 0;
      REPEAT
	IF (hunter^.WScreen = screenList[whichScreen]) AND (hunter # NULL)
		AND (hunter # windowList[0])
	  THEN
	    prey[counter] := ADDRESS(hunter^.Title);
            windowList[counter] := hunter;
	    INC(counter);
	  END; (* IF *)
	  hunter := hunter^.Parent;
      UNTIL (hunter = myWin) OR (hunter = NULL) OR (counter > 64)
		OR (hunter^.WScreen # screenList[whichScreen]);
    hunter := myWin^.Descendant;
    REPEAT
	IF (hunter^.WScreen = screenList[whichScreen]) AND (hunter # NULL)
		AND (hunter # windowList[0])
	  THEN
	    prey[counter] := ADDRESS(hunter^.Title);
            windowList[counter] := hunter;
	    INC(counter);
	  END; (* IF *)
	hunter := hunter^.Descendant;
    UNTIL (hunter = myWin) OR (hunter = NULL) OR (counter > 64)
		OR (hunter^.WScreen # screenList[whichScreen]);
    FOR counter2 := 0 TO (counter - 1)
      DO
	IF delScreenYesNo IN NOSET
	  THEN
	    WriteCard(counter2, 5); WriteString('> ');
	    WriteString(prey[counter2]^); WriteLn;
	  ELSE
	    CloseWindow(windowList[counter2]);
	  END; (* IF *)
      END; (* FOR *)
    IF delScreenYesNo IN NOSET
      THEN
	WriteString('Which window do you want to delete? ');
	ReadCard(deleteMe);
	IF deleteMe < counter
	  THEN
	    CloseWindow(windowList[deleteMe]);
	  END; (* IF *)
      ELSE
	CloseScreen(screenList[whichScreen]);
      END; (* IF *)
      ELSE
	CloseScreen(screenList[whichScreen]); (* No windows on scrn *)
      END; (* IF *)
    END; (* IF whichScreen < counter *)
    CloseWindow(myWin);
    CloseLibrary(IntuitionBase);
  END WindowHunter.
