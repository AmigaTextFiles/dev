MODULE Bad;
 
  FROM Windows IMPORT OpenWindow;
  FROM Views IMPORT ModeSet, Modes;
  FROM SYSTEM IMPORT NULL, ADR, BYTE;
  FROM InOut IMPORT WriteString, WriteLn;
  FROM Screens IMPORT OpenScreen, NewScreen;
  FROM Libraries IMPORT OpenLibrary, CloseLibrary;
  FROM Intuition IMPORT WindowPtr, ScreenFlags, ScreenFlagSet, NewWindow,
		IntuitionName, IntuitionBase, ScreenPtr, CustomScreen,
		WindowFlags, WindowFlagSet;
 
  VAR
    myNS: NewScreen;
    myScreen: ScreenPtr;
    myNW1, myNW2: NewWindow;
    myWin1, myWin2: WindowPtr;
    title: ARRAY[0..15] OF CHAR;
    scrTitle: ARRAY[0..15] OF CHAR;
 
  BEGIN
    title := 'Bad Window';
    scrTitle := 'Bad Screen';
    IntuitionBase := OpenLibrary(IntuitionName, 0);
    WITH myNS
      DO
	LeftEdge := 0; TopEdge:= 0; Width := 640; Height := 400;
	Depth := 2;
	DetailPen := BYTE(1); BlockPen := BYTE(0);
	ViewModes := ModeSet {Hires, Lace}; Type := CustomScreen;
	Font := NULL; DefaultTitle := ADR(scrTitle); Gadgets := NULL;
	CustomBitMap := NULL;
      END; (* IF *)
    myScreen := OpenScreen(ADR(myNS));
    WriteString('Screen Open'); WriteLn;
    WITH myNW1
      DO
	LeftEdge := 0; TopEdge := 100; Width := 600; Height := 50;
	DetailPen := BYTE(1); BlockPen := BYTE(0);
	FirstGadget := NULL; CheckMark := NULL; Title := ADR(title);
	Screen := myScreen; BitMap := NULL; Type:= CustomScreen;
	Flags := WindowFlagSet {WindowDrag, WindowDepth};
      END; (* WITH *)
    WITH myNW2
      DO
	LeftEdge := 0; TopEdge := 0; Width := 640; Height := 50;
	DetailPen := BYTE(1); BlockPen := BYTE(0);
	FirstGadget := NULL; CheckMark := NULL; Title := ADR(title);
	Screen := myScreen; BitMap := NULL; Type:= CustomScreen;
	Flags := WindowFlagSet {WindowDrag, WindowDepth};
      END; (* WITH *)
    myWin1 := OpenWindow(myNW1); WriteString('Window1 OK'); WriteLn;
    myWin2 := OpenWindow(myNW2); WriteString('Window2 OK'); WriteLn;
    CloseLibrary(IntuitionBase);
    WriteString('All done!'); WriteLn;
  END Bad.
