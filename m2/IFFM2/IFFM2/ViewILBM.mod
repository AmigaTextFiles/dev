MODULE ViewILBM;


(*
  ===========================================================================
  ||                                                                       ||
  ||   VIEWILBM - Amiga (r) version                                        ||
  ||                                                                       ||
  ||   Original Developers:  November 20, 1988, Greg Epley                 ||
  ||                                                                       ||
  ||   Program Version:  *   1.0.0, May 30, 1989, Greg Epley               ||
  ||                         First implementation; loosely based on the    ||
  ||                         programs ShowILBM and Display; compiled with  ||
  ||                         M2AMIGA Rel. 3.1                              ||
  ||                                                                       ||
  ||                                                                       ||
  ||              Copyright (c) 1988, 1989  Second Sight (tm)              ||
  ||                                                                       ||
  ||    Amiga is a registered trademark of Commodore-Amiga, Inc.  Second   ||
  ||    Sight is a trademark of Second Sight, Lexington, North Carolina.   ||
  ||                                                                       ||
  ===========================================================================
*)


(*
=================================  IMPORTS  =================================
*)
FROM Arguments		IMPORT NumArgs, GetArg;
FROM Arts		IMPORT TermProcedure;
FROM Conversions	IMPORT StrToVal;
FROM Dos		IMPORT oldFile,
                               Delay;
FROM Exec		IMPORT GetMsg, ReplyMsg;
FROM Graphics		IMPORT LoadRGB4,
                               ViewModeSet,
                               TextAttr,
                               FontFlags, FontFlagSet,
                               FontStyles, FontStyleSet;
FROM IFFM2		IMPORT ID, IDFORM, IDILBM, IDBMHD, IDCMAP, IDBODY,
                                 IDCAMG, IDEOFX,
                               IFFFileFramePtr,
                               MaxColorRegister,
                               OpenIFF, CloseIFF,
                               PrintIFFError,
                               GetChunkHdr, GetType,
                               GetPad, GetUnknown, GetBMHD, GetCMAP,
                                 GetBODY, GetCAMG;
FROM Intuition		IMPORT OpenScreen, CloseScreen, NewScreen,
                               OpenWindow, CloseWindow, NewWindow,
                               ScreenPtr, ScreenFlags, ScreenFlagSet,
                               WindowPtr, WindowFlags, WindowFlagSet,
                               IDCMPFlags, IDCMPFlagSet, IntuiMessagePtr,
                               RemakeDisplay, SetPointer, ClearPointer,
                                 ShowTitle,
                               customScreen, selectDown;
FROM SYSTEM		IMPORT ADR, INLINE;
FROM Terminal		IMPORT WriteString, WriteLn, waitCloseGadget;


VAR
  picFrame	: IFFFileFramePtr;
  chID		: ID;
  chSize	: LONGINT;
  okay		: BOOLEAN;
  
  sP		: ScreenPtr;
  wP		: WindowPtr;
  
  (* these are for handling passed agruments *)
  picName,
  argv		: ARRAY [0..79] OF CHAR;
  picDelay,
  argc,
  argl		: INTEGER;
  l		: LONGINT;
  sign		: BOOLEAN;
  
  (* general use *)
  i		: INTEGER;
  u		: ARRAY [0..5] OF ARRAY [0..65] OF CHAR;


(*$E-*)  (* no entry/exit code since this is just data *)
PROCEDURE BlankPtrData;
  BEGIN
    INLINE (0, 0, 0, 0, 0, 0);
END BlankPtrData;


PROCEDURE Cleanup;
  BEGIN
    IF picFrame # NIL THEN CloseIFF (picFrame) END;
    IF wP # NIL THEN ClearPointer (wP); CloseWindow (wP) END;
    IF sP # NIL THEN CloseScreen (sP) END;
END Cleanup;


PROCEDURE MakeDisplay () : BOOLEAN;
  VAR
    ns	: NewScreen;
    nw	: NewWindow;
    ta	: TextAttr;
  BEGIN
    (* force topaz 8 font *)
    ta.name := ADR("topaz.font");  ta.flags := FontFlagSet {romFont};
    ta.style := FontStyleSet {};  ta.ySize := 8;
    
    WITH ns DO
      leftEdge := picFrame^.bmhd^.x;  topEdge := picFrame^.bmhd^.y;
      width := picFrame^.bmhd^.w;  height := picFrame^.bmhd^.h;
      depth := picFrame^.bmhd^.nPlanes;  viewModes := picFrame^.camg;
      detailPen := 1;  blockPen := 0;  type := customScreen;
      font := ADR(ta);  gadgets := NIL;
      defaultTitle := ADR(" <- Close here after clicking below");
    END;
    sP := OpenScreen (ns);
    IF sP = NIL THEN RETURN FALSE END;
    LoadRGB4 (ADR(sP^.viewPort), ADR(picFrame^.cmap[0]), MaxColorRegister);
    WITH nw DO
      leftEdge := 0;  topEdge := 0;  width := sP^.width;  detailPen := 0;
      height := sP^.height;  idcmpFlags := IDCMPFlagSet {mouseButtons};
      flags := WindowFlagSet {borderless, backDrop, activate};
      blockPen := 0;  firstGadget := NIL;  title := NIL;  screen := sP;
      type := customScreen;
    END;
    wP := OpenWindow (nw);
    IF wP = NIL THEN RETURN FALSE END;
    
    (* set display offsets [only applies if overscan] *)
    sP^.viewPort.dxOffset :=
      -(ABS(INTEGER(picFrame^.bmhd^.w)-picFrame^.bmhd^.pageWidth) DIV 2);
    sP^.viewPort.dyOffset :=
      -(ABS(INTEGER(picFrame^.bmhd^.h)-picFrame^.bmhd^.pageHeight) DIV 2);
    picFrame^.bitmap := ADR(sP^.bitMap);
    
    (* makes the changes take effect and clears the title bar *)
    RemakeDisplay();  ShowTitle (sP, FALSE);  RETURN TRUE;
END MakeDisplay;


PROCEDURE GetPicture () : BOOLEAN;
  BEGIN
    (* Use this as a general use reading parser, making changes only in the
     * way that the display, color map, and viewmodes are handled for the
     * display you would like; I preferred Intuition in this case. *)
    picFrame := OpenIFF (picName, oldFile);
    IF picFrame = NIL THEN
      PrintIFFError();  RETURN FALSE;
    ELSE  (* must have opened the file OK *)
      chID := GetChunkHdr (picFrame, chSize);
      IF chID = IDEOFX THEN
        PrintIFFError();  RETURN FALSE;
      ELSIF chID = IDFORM THEN  (* found FORM okay *)
        chID := GetType (picFrame);
        (* now find out what type of file this is *)
        IF chID = IDEOFX THEN
          PrintIFFError();  RETURN FALSE;
        ELSIF chID = IDILBM THEN
          LOOP  (* start of chunk parsing loop *)
            chID := GetChunkHdr (picFrame, chSize);
            IF chID = IDEOFX THEN
              EXIT;  (* found EOF *)
            ELSIF chID = IDBMHD THEN
              okay := GetBMHD (picFrame, chSize);
            ELSIF chID = IDCMAP THEN
              okay := GetCMAP (picFrame, chSize);
            ELSIF chID = IDBODY THEN
              okay := GetBODY (picFrame, chSize);
            ELSIF chID = IDCAMG THEN
              okay := GetCAMG (picFrame, chSize);
            ELSE  (* unrecognized file chunk *)
              okay := GetUnknown (picFrame, chSize);
            END;  (* end of chunk type parsing *)
            IF NOT okay THEN PrintIFFError(); EXIT; END;
            IF ODD(chSize) THEN
              okay := GetPad (picFrame);
              IF NOT okay THEN PrintIFFError(); EXIT; END;
            END;  (* end of pad handling on weird chunks *)
            IF chID = IDBMHD THEN
              okay := MakeDisplay();
              IF NOT okay THEN EXIT END;
            ELSIF chID = IDCMAP THEN
              LoadRGB4 (ADR(sP^.viewPort), ADR(picFrame^.cmap[0]),
                picFrame^.nColors);
            ELSIF chID = IDCAMG THEN
              sP^.viewPort.modes := picFrame^.camg;  RemakeDisplay();
            END;
          END;  (* end of chunk parsing loop *)
          IF NOT okay THEN RETURN FALSE END;
        ELSE  (* unrecognized file type chunk *)
          PrintIFFError();  RETURN FALSE;
        END;  (* end of file type chunk parsing *)
      END;  (* end of FORM check *)
    END;  (* end of file opening *)
    RETURN TRUE;
END GetPicture;


PROCEDURE Monitor ();
  VAR
    msg		: IntuiMessagePtr;
    class	: IDCMPFlagSet;
    code	: CARDINAL;
    mouseX,
    mouseY	: INTEGER;
    TBToggle,
    Done	: BOOLEAN;
  BEGIN
    (* Message checking/handling and time delay operations specific to
     * this program. *)
    SetPointer (wP, ADR(BlankPtrData), 0, 0, 1, 1);
    Done := FALSE;  TBToggle := FALSE;
    
    LOOP
      msg := GetMsg (wP^.userPort);
      IF msg # NIL THEN
        class := msg^.class;  code := msg^.code;
        mouseX := msg^.mouseX;  mouseY := msg^.mouseY;
        ReplyMsg (msg);
        IF (mouseButtons IN class) & (code = selectDown) THEN
          IF (mouseX < 10) & (mouseY < 10) THEN
            Done := TRUE;
          ELSIF ((mouseY > 10) OR (mouseX > 10)) & NOT TBToggle THEN
            TBToggle := TRUE;  ShowTitle (sP, TRUE);  ClearPointer (wP);
          ELSIF (mouseY > 10) & TBToggle THEN
            TBToggle := FALSE;  ShowTitle (sP, FALSE);
            SetPointer (wP, ADR(BlankPtrData), 0, 0, 1, 1);
          END;
        END;
      END;
      IF picDelay # -1 THEN  (* if <delay> passed in *)
        Delay (45);
        IF picDelay > 0 THEN DEC(picDelay) ELSE Done := TRUE END;
      END;
      IF Done THEN EXIT END;
    END;
END Monitor;



(*=========================================================================
  |                    _    _       __           _                        |
  |                   | \  / |     /__\     ||  | \  ||                   |
  |                   ||\\//||    //  \\    ||  ||\\ ||                   |
  |                   || \/ ||   //====\\   ||  || \\||                   |
  |                   ||    ||  //      \\  ||  ||  \_|                   |
  |                                                                       |
  =========================================================================*)

BEGIN
  TermProcedure (Cleanup);  waitCloseGadget := FALSE;
  
  u[0] := "CLI Usage: ViewILBM <file> [<delay>]";
  u[1] := "WB Usage:  Click ViewILBM, hold <SHIFT> key, and double-click";
  u[2] := "           picture.";
  u[3] := "The optional CLI <delay> is the number of seconds to display.";
  u[4] := "Click below title bar to toggle drag bar.";
  u[5] := "Click in upper left corner to close.";
  
  argc := NumArgs();
  IF (argc < 1) OR (argc > 2) THEN  (* no args or more than 2 max. *)
    FOR i := 0 TO 5 DO WriteString (u[i]); WriteLn; END;
    waitCloseGadget := TRUE;
  ELSE
    FOR i := 1 TO argc DO
      CASE i OF
        1 : GetArg (1, picName, argl);  picDelay := -1;
      | 2 : GetArg (2, argv, argl);
            StrToVal (argv, l, sign, 10, okay);
            picDelay := INTEGER(l);
      END;
    END;
    okay := GetPicture();
    IF okay THEN Monitor() END;
  END;

END ViewILBM.
