{ Crt.i for PCQ-Pascal Copyright © 1995 by Andreas Tetzl }
{ Version 1.0 (15.04.1995) }

const   TS_Plain     = 0;
        TS_Bold      = 1;
        TS_Italics   = 3;
        TS_Underline = 4;

PROCEDURE Locate(Zeile, Spalte : Byte);
 External;

PROCEDURE ClrScr;
 External;

PROCEDURE CursorOff;
 External;

PROCEDURE CursorOn;
 External;

PROCEDURE Bell;
 External;

PROCEDURE MoveCursorUp(n : Byte);
 External;

PROCEDURE MoveCursorDown(n : Byte);
 External;

PROCEDURE MoveCursorLeft(n : Byte);
 External;

PROCEDURE MoveCursorRight(n : Byte);
 External;

PROCEDURE ResetConsole;
 External;

PROCEDURE SetTextStyle(Style, fCol, bCol : Byte);
 External;

PROCEDURE GetConSize(VAR Zeilen : Integer; VAR Spalten : Integer);
 External;

PROCEDURE HorizTxtLine(x, y, w : Integer; c : Char);
 External;

PROCEDURE TxtLine(x1, y1, x2, y2 : Integer; c : Char);
 External;

PROCEDURE TxtRectFill(x, y, w, h : Integer; c : Char);
 External;


