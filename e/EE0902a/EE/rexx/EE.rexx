/*  EE Rx Test Suite v0.9.2a
    REQUIREMENTS:
      - AddLib('rexxsupport.library',-30) for Delay()
      - Executable 'E:bin/EE'
      - No running EE's
      - Textfile 'E:README'
*/

ADDRESS COMMAND
OPTIONS FAILAT 10

/* Start EE and/or wait for it's port to become registered. */
IF ~Show(PORTS, 'EE.0') THEN 'Run E:bin/EE'
DO WHILE ~Show(PORTS, 'EE.0')
  CALL Delay(50)
END

ADDRESS 'EE.0'
OPTIONS RESULTS

LockWindow

/*CALL start*/

SAY 'Open E:README'
Open 'E:README'
CALL Delay(150)

SAY 'Clear'
Clear
CALL Delay(50)

SAY 'OpenNew E:README'
OpenNew 'E:README'
CALL Delay(150)

SAY 'NextWindow'
NextWindow
CALL Delay(100)

SAY 'Quit'
Quit
CALL Delay(150)

SAY 'NewWindow'
NewWindow
CALL Delay(50)

SAY 'Close old window'
NextWindow; Quit
CALL Delay(50)

SAY 'PutChar a, b, c'
PutChar 'a'
PutChar 'b'
PutChar c   /* note ARexx capitalizes */
CALL Delay(100)

SAY 'BackSpace*3'
BackSpace 'REP=3'
CALL Delay(100)

SAY "PutLine 'PutLine()'"
PutLine 'PutLine()'
CALL Delay(100)

SAY "PutString 'Hoohah!'"
PutString 'Hoohah!'
CALL Delay(100)

SAY 'BeginningOfLine'
BeginningOfLine
CALL Delay(100)

SAY 'OpenLine'
OpenLine
CALL Delay(100)

SAY 'CursorUp; SplitLine'
CursorUp
SplitLine
CALL Delay(100)

SAY 'GetChar until NL'
DO FOREVER
  GetChar
  IF C2D(RESULT)=10 THEN LEAVE
  SAY 'GetChar('RESULT')'
  CursorRight
END
CALL Delay(100)

SAY 'BeginningOfLine'
BeginningOfLine
CALL Delay(100)

GetString  5; SAY 'GetString  5('RESULT')'
GetString 10; SAY 'GetString 10('RESULT')'
GetWord;      SAY 'GetWord('RESULT')'
CALL Delay(150)

SAY "SaveAs 'T:dummy'"
SaveAs 'T:dummy'
CALL Delay(100)

SAY 'SetCmd5 "Echo blahblahblah IT WORKS!"'
SetCmd5 '"Echo blahblahblah IT WORKS!"'  /* NOTE double quotes necessary! */
CALL Delay(100)

SAY 'Cmd5'
Cmd5
CALL Delay(150)

start:

SAY 'Zip and Unzip window'
ZipWindow; CALL Delay(50)
ZipWindow; CALL Delay(100)

SAY 'SizeWindow 400 50'
SizeWindow 400 50
CALL Delay(100)

SAY 'MoveWindow 100 50'
MoveWindow 100 50
CALL Delay(100)

SAY 'GotoLine 1'
GotoLine 1
CALL Delay(100)

SAY 'MarkBlock; CursorDown 2; CursorRight 2'
MarkBlock
CursorDown 'REP=2'
CursorRight 'REP=2'
CALL Delay(100)

?BlockDimensions;      SAY 'BlockDimensions     ='RESULT
PARSE VALUE RESULT WITH sl sc el ec .
SAY 'StartLine='sl 'StartColumn='sc 'EndLine='el 'EndColumn='ec
CALL Delay(300)

?Column;               SAY 'Column              ='RESULT
?DefaultPublicScreen;  SAY 'DefaultPublicScreen ='RESULT
?Filename;             SAY 'Filename            ='RESULT
?FindCase;             SAY 'FindCase            ='RESULT
?FoldExtraLines;       SAY 'FoldExtraLines      ='RESULT
?IndentWidth;          SAY 'IndentWidth         ='RESULT
?InsertMode;           SAY 'InsertMode          ='RESULT
?Justify;              SAY 'Justify             ='RESULT
?Length;               SAY 'Length              ='RESULT
?Line;                 SAY 'Line                ='RESULT
?NoFoldWhenLoading;    SAY 'NoFoldWhenLoading   ='RESULT
?PathAndFilename;      SAY 'PathAndFileName     ='RESULT
?PubScreenName;        SAY 'PubScreenName       ='RESULT
?ShanghaiPublicScreen; SAY 'ShanghaiPublicScreen='RESULT
?TabWidth;             SAY 'TabWidth            ='RESULT
?TallWindow;           SAY 'TallWindow          ='RESULT
?WindowDimensions;     SAY 'WindowDimensions    ='RESULT

UnlockWindow

EXIT 0
