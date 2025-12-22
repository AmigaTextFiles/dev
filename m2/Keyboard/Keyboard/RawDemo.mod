MODULE RawDemo;
(*******************************************************************************
Name         : RawDemo
Version      : 1.0
Purpose      : Tests access to RAWKEY events via Intuition in module
             : Keyboard
Author       : Peter Graham Evans. Translation into Modula-2 of a program
             : in the C language by Fabbian G. Dufoe, III on Fish Disk 291.
Language     : Modula-2. Uses TDI Modula-2 version 3.01a which I received
             : in the first quarter 1988 from M2S in Bristol, England.
Status       : This is a public domain program and thus can be used for
             : commercial or non commercial purposes.
Date Started : 18/MAR/90.
Date Complete: 24/MAR/90.
Modified     : 25/MAR/90.added further comments and tidied up
*******************************************************************************)

FROM ConsoleDevice IMPORT KeyMapPtr;
FROM GraphicsLibrary      IMPORT Jam1;
FROM InOut         IMPORT Write, WriteInt, WriteString, WriteLn;
FROM Intuition     IMPORT IntuitionBase, IntuiMessagePtr, WBenchScreen,
                          WindowFlags, IDCMPFlagSet, IDCMPFlags,
                          WindowPtr, IntuitionText, NewWindow,
                          ScreenFlagSet, IntuitionName, WindowFlagSet,
                          PrintIText, SmartRefresh;
FROM Keyboard      IMPORT CloseKey, OpenKey, ReadKey,
                          KUP, KDOWN, KRIGHT, KLEFT, KSUP, KSDOWN, KSRIGHT,
                          KSLEFT, KHELP, KF1, KF2, KF3, KF4, KF5, KF6, KF7,
                          KF8, KF9, KF10, KSF1, KSF2, KSF3, KSF4, KSF5,
                          KSF6, KSF7, KSF8, KSF9, KSF10;
FROM Libraries     IMPORT OpenLibrary, CloseLibrary;
FROM Ports         IMPORT WaitPort, GetMsg, ReplyMsg, MessagePtr;
FROM Rasters       IMPORT RastPortPtr;
FROM SYSTEM        IMPORT ADR, BYTE, NULL;
FROM Windows       IMPORT OpenWindow, CloseWindow;

(* [Based on the C Language source code RawDemo.c on the public domain Fish
Disk library disk 291 by Fabbian Dufoe.
   I have changed the names of the procedures to make them more readable.]

   by Fabbian G. Dufoe, III
   This is a public domain program.  You may use it any way you want.

   This program demonstrates the use of the OpenReadConsole(), ReadKey(),
   and CloseReadConsole() functions in Keyboard.c  [These names have
   been changed.]

   [If you have any problems with using these modules or have any other
comment then please contact  Mr. Peter G.Evans
                             "Erehwon"
                             37 Charles Street
                             Cheltenham
                             Victoria 3192
                             Australia
                    tele     (03) 5842765
                             +61 3 584 2765       ]
*)

VAR
  window : WindowPtr;
  rastp  : RastPortPtr;
  IText1 : IntuitionText;
  message: IntuiMessagePtr;
  Text1  : ARRAY [0..14] OF CHAR;
  Title1 : ARRAY [0..19] OF CHAR; (* The text for the window title must be
                                  outside the procedure InitWindow because
                                  local variables disappear when the
                                  procedure exits. If you put it inside
                                  InitWindow the title will disappear when
                                  you move the window or click in another
                                  window then go back to this window.
                                  Page 6 AmiProject # 6 Jan/Feb 1987
                                  was the clue in article 'Using Menus With
                                  Intuition' by Richie Bielak. *)

PROCEDURE InitWindow () : WindowPtr;
(* Open a window and return a pointer to it *)

VAR
  neww   : NewWindow;

BEGIN
  Title1:="RawDemo in Modula-2";
  WITH neww DO
    LeftEdge   := 0;
    TopEdge    := 10;
    Width      := 550;
    Height     := 190;
    DetailPen  := BYTE(0);
    BlockPen   := BYTE(1);
    IDCMPFlags := IDCMPFlagSet{CloseWindowFlag,RawKey,MouseButtons};
    Flags      := WindowFlagSet{WindowDrag,WindowDepth,WindowClose,
                              WindowSizing,Activate} + SmartRefresh;
    FirstGadget:= NULL;
    CheckMark  := NULL;
    Title      := ADR(Title1);
    Screen     := NULL;
    BitMap     := NULL;
    MinWidth   := 10;
    MinHeight  := 10;
    MaxWidth   := 640;
    MaxHeight  := 400;
    Type       := ScreenFlagSet{WBenchScreen};
  END; (* WITH *)
  RETURN OpenWindow(neww);
END InitWindow;

PROCEDURE PrintKey (VAR KeyMessage : IntuiMessagePtr);
VAR
  KeyID : INTEGER;
  Key   : INTEGER;
  KeyMap: KeyMapPtr;
BEGIN
   KeyMap:=NULL;
   Key:=ReadKey(KeyMessage, KeyID, KeyMap);
   IF (Key = -1) OR (Key = -2) THEN
     RETURN
   END;
   IF Key <> 0 THEN
     WriteString("Key: ");
     Write(CHAR(Key)); WriteLn;
   ELSE (* Key = 0 *)
     CASE KeyID OF
       KUP:     WriteString("K_UP");       |
       KDOWN:   WriteString("K_DOWN");     |
       KRIGHT:  WriteString("K_RIGHT");    |
       KLEFT:   WriteString("K_LEFT");     |
       KSUP:    WriteString("K_S_UP");     |
       KSDOWN:  WriteString("K_S_DOWN");   |
       KSRIGHT: WriteString("K_S_RIGHT");  |
       KSLEFT:  WriteString("K_S_LEFT");   |
       KHELP:   WriteString("K_HELP");     |
       KF1:     WriteString("K_F1");       |
       KF2:     WriteString("K_F2");       |
       KF3:     WriteString("K_F3");       |
       KF4:     WriteString("K_F4");       |
       KF5:     WriteString("K_F5");       |
       KF6:     WriteString("K_F6");       |
       KF7:     WriteString("K_F7");       |
       KF8:     WriteString("K_F8");       |
       KF9:     WriteString("K_F9");       |
       KF10:    WriteString("K_F10");      |
       KSF1:    WriteString("K_S_F1");     |
       KSF2:    WriteString("K_S_F2");     |
       KSF3:    WriteString("K_S_F3");     |
       KSF4:    WriteString("K_S_F4");     |
       KSF5:    WriteString("K_S_F5");     |
       KSF6:    WriteString("K_S_F6");     |
       KSF7:    WriteString("K_S_F7");     |
       KSF8:    WriteString("K_S_F8");     |
       KSF9:    WriteString("K_S_F9");     |
       KSF10:   WriteString("K_S_F10");
     ELSE
     END; (* CASE *)
     WriteLn;
   END; (* IF *)
END PrintKey;

BEGIN
  IntuitionBase:=OpenLibrary(IntuitionName, 0);
  IF IntuitionBase <> NULL THEN
    IF OpenKey() = 0 THEN
      window:=InitWindow();
      IF window <> NULL THEN
        rastp:=window^.RPort;
        Text1:="Type some keys.";
        WITH IText1 DO
          FrontPen := BYTE(1);
          BackPen  := BYTE(0);
          DrawMode := BYTE(Jam1);
          LeftEdge := 4;
          TopEdge  := 12;
          ITextFont:= NULL;
          IText    := ADR(Text1);
          NextText := NULL;
        END; (* WITH *)
        PrintIText(rastp, IText1, 0, 0);
        REPEAT
          message:=IntuiMessagePtr(WaitPort(window^.UserPort));
          LOOP
            message:=IntuiMessagePtr(GetMsg(window^.UserPort));
            IF message = NULL THEN EXIT END;
            IF message^.Class = IDCMPFlagSet{CloseWindowFlag} THEN
            ELSIF message^.Class = IDCMPFlagSet{RawKey} THEN
                          PrintKey(message);
            ELSIF message^.Class = IDCMPFlagSet{MouseButtons} THEN
                          WriteString("Mouse X: ");
                          WriteInt(message^.MouseX, 3);
                          WriteString("    Y: ");
                          WriteInt(message^.MouseY, 3);
                          WriteLn;
            END; (* IF *)
            ReplyMsg(MessagePtr(message)); (* ReplyMsg must be AFTER doing
                                           our ReadKey stuff *)
            EXIT;
          END; (* LOOP *)
        UNTIL message^.Class = IDCMPFlagSet{CloseWindowFlag};
        CloseWindow(window);
      ELSE
        WriteString("OpenWindow failed"); WriteLn;
      END;
      CloseKey;
    ELSE
      WriteString("OpenKey failed."); WriteLn;
    END;
    CloseLibrary(IntuitionBase);
  ELSE
    WriteString("OpenLibrary failed for intuition.library."); WriteLn;
  END;
END RawDemo.
