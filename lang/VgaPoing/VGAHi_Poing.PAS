{***************************************************************}
{ Poing... a small HiSpeed/Turbo Pascal demo of a bouncing 'o'  }
{ By Hans Luyten                                                }
{***************************************************************}
{ VGA version...                                                }
{***************************************************************}
PROGRAM Poing;

Uses  Graph,Crt;

VAR
  MaxX  : INTEGER;
  MaxY  : INTEGER;
  MinX  : INTEGER;
  MinY  : INTEGER;
  XStart:  INTEGER;
  YStart:  INTEGER;

FUNCTION VGAOpen:BOOLEAN;    
VAR
  Driver  : INTEGER;
  Mode    : INTEGER;
  
BEGIN
  Driver:=Detect;
  InitGraph(Driver,Mode,'');
  SetGraphMode(VGAHi);
  SetRGBPalette(Black   ,0 ,0 ,0 );
  SetRGBPalette(Yellow  ,63,63,0 );
  SetRGBPalette(DarkGray,15,15,15);
END;

{***************************************************************}
{ DrawBall(X,Y,Wipe);                                           }
{ Bal tekenen, indien wipe=TRUE dan wissen !!                   }
{***************************************************************}
PROCEDURE DrawBall(X,Y : INTEGER;Wipe : BOOLEAN);
BEGIN
  IF Wipe THEN
    SetColor(Black)
  ELSE
    SetColor(Yellow);
  Circle(X,Y,5);
END;
      
  
{***************************************************************}
{ ReadData(XStart,YStart,XMax,YMax);                            }
{ Vraagt kader omvang en start positie...                       }
{***************************************************************}
PROCEDURE ReadData(VAR Xs,Ys : INTEGER;VAR X,Y : INTEGER);
BEGIN
  ClrScr;
  GotoXY(5,8);
  Write('PoingPoing... a short Pascal demo.');
  REPEAT
    BEGIN
      GotoXY(5,10);
      Write('Breedte van het kader (maximaal 630): ');
      READLN(X);
    END;
  UNTIL (X>7)AND(X<631);
  REPEAT
    BEGIN
      GotoXY(5,12);
      Write('Hoogte van het kader  (Maximaal 450): ');
      READLN(Y);
    END;
  UNTIL (Y>7)AND(Y<451);
  REPEAT
    BEGIN
      GotoXY(5,14);
      Write('Start positie van X (Maximaal ',X,'): ');
      READLN(Xs);
    END;
  UNTIL (Xs>1)AND(Xs<X);
  REPEAT
    BEGIN
      GotoXY(5,16);
      Write('Start positie van Y (Maximaal ',Y,'): ');
      READLN(Ys);
    END;
  UNTIL (Ys>1)AND(Ys<Y);
END;

{***************************************************************}
{ DrawBox(X1,Y1,X2,Y2);                                         }
{ Tekent een kader van X1,Y1 tot X2,Y2.                         }
{***************************************************************}
PROCEDURE DrawBox(X1,Y1,X2,Y2 : INTEGER);
VAR
  Teller  :  INTEGER;
BEGIN
  SetFillStyle(SolidFill,Black);
  SetColor(DarkGray);
  Bar(X1,Y1,X2,Y2);
  OutTextXY(20,Y2+20,'Stoppen kan door een toets in te drukken');
END;

{***************************************************************}
{ DoPoing(XStart,YStart,XMax,YMax);                             }
{ Stuiter procedure...                                          }
{***************************************************************}
PROCEDURE DoPoing(X,Y,XMax,YMax : INTEGER);
VAR
  c      :  CHAR;
  XMode  :  BOOLEAN;
  YMode  :  BOOLEAN;
  OldX  : INTEGER;
  OldY  :  INTEGER;
  
BEGIN
  IF KeyPressed THEN
    c:=ReadKey;
  XMode:=TRUE;
  YMode:=TRUE;
  OldX:=X;
  OldY:=Y;
  XMax:=PRED(XMax);
  REPEAT
    BEGIN
      DrawBall(X,Y,FALSE);
      OldX:=X;
      OldY:=Y;
      IF X>=XMax THEN
        XMode:=FALSE
      ELSE IF X<=12 THEN
        XMode:=TRUE;
      
      IF XMode THEN
        X:=X+4
      ELSE
        X:=X-4;
              
      IF Y>=YMax THEN
        YMode:=FALSE
      ELSE IF Y<=11 THEN
        YMode:=TRUE;
        
      IF YMode THEN
        Y:=Y+4
      ELSE
        Y:=Y-4;
      
      DrawBall(OldX,OldY,TRUE);
    
    END;
  UNTIL (KeyPressed);
END;

{***************************************************************}
{ MAIN                                                          }
{***************************************************************}
BEGIN
  MinX:=1;
  MinY:=1;
  ReadData(XStart,YStart,MaxX,MaxY);  
  IF VGAOpen THEN
    BEGIN
      DrawBox(MinX,MinY,MaxX,MaxY);
      DoPoing(XStart,YStart,MaxX-10,MaxY-10);
      CloseGraph;
    END;
END.
  
  