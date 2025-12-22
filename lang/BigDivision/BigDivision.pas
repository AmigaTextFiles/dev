PROGRAM BigDivision;

(* This program was created to show you how to program nicely.
   I have found the code in an old Basic Program, which I converted to
   Pascal to make it clearer. If you want to contact me, please write
   to Daniel Amor <daniel.amor@student.uni-tuebingen.de> *)

USES CRT;

(* The Unit CRT opens a window for us and gives us some fancy commands
   like ReadKey, WaitForKey etc. Look in your manual for further information *)

VAR Dividend, Divisor: LONGINT;
    Laenge:            LONGINT;
    what:              CHAR;
    Text:              ARRAY [1..8] OF STRING[35];

(* These variables are needed in the main program, actually only the numbers.
   The other are only here to make the program more comfortable *)

PROCEDURE Division(Dividend, Divisor: LONGINT; Laenge: LONGINT);

(* This is the division sub-routine, if you have a close look you will find
   out, that it works the way you would divide two numbers on a piece of 
   paper, like this it is very exact *)

VAR i,stellen: INTEGER;
    Komma    : BOOLEAN;

BEGIN
  Komma:=FALSE;

  IF ((Dividend<0) AND (Divisor>=0)) OR ((Dividend>=0) AND (Divisor<0)) THEN 
    WRITE("-");

  (* In case of a negative value, we have to add a minus symbol *)

  IF Dividend<0 THEN Dividend := Dividend*(-1);
  IF Divisor<0  THEN Divisor  := Divisor*(-1);

  (* Now we make them positive to easen the calculation *)

  FOR i:=1 TO Laenge DO 
  BEGIN
    Stellen:=TRUNC(Dividend/Divisor);
    WRITE(Stellen);
    Dividend:=10*(Dividend-(Stellen*Divisor));
    IF (NOT Komma) AND (i<Laenge) THEN 
    BEGIN 
      WRITE(".");
      Komma:=TRUE;
    END;
  END;
 
  (* This is the main loop, which works just as if you would do it by hand.
     Try it out yourself *)

END;

BEGIN
  WindowTitles("BigDivision V1.0","Created by Daniel Amor in 1995. Public Domain!");
  REPEAT
    REPEAT
      WRITE('(E)nglish or/oder (D)eutsch? ');
      what:=ReadKey;
      WRITELN;
    UNTIL (UPCASE(what)="E") or (UPCASE(what)="D");

    (* This program is very picky about correct inputs, so if you do enter
       a wrong key, you have another try *)

    WRITELN;
    IF UPCASE(what)="E" THEN
    BEGIN
      text[1]:="Welcome to BigDivision!";
      text[2]:="Dividend: ";
      text[3]:="Divisor: ";
      text[4]:="Length: ";
      text[5]:="Are you sure (y/n)? ";
      text[6]:="Y";
      text[7]:="N";
      text[8]:="Again? (y/n)";
    END
    ELSE
    BEGIN
      text[1]:="Willkommen zu BigDivision!";
      text[2]:="Dividend: ";
      text[3]:="Divisor: ";
      text[4]:="Länge: ";
      text[5]:="Sind Sie sicher (j/n)? ";
      text[6]:="J";
      text[7]:="N";
      text[8]:="Nochmal? (j/n)";
    END;

    (* Here is the text assigned to the strings, depending on your input,
       either English or German *)

    WRITELN(text[1]);
    REPEAT

      REPEAT
        WRITE(text[2]);
        READLN(Dividend);
      UNTIL Dividend<>0;

      (* You have to enter a value, which is not zero *)

      REPEAT
        WRITE(text[3]);
        READLN(Divisor);
      UNTIL Dividend<>0;

      (* You have to enter a value, which is not zero *)

      REPEAT
        WRITE(text[4]);
        READLN(Laenge);
      UNTIL (Laenge>0) AND (Laenge<32000);

      (* You have to enter a value, which is between 0 and 32000 *)

      WRITE(text[5]);
      what:=ReadKey;
      WRITELN;

      (* Are your inputs correct? If yes then we leave the REPEAT-loop *)

    UNTIL UPCASE(what)=text[6];
    WRITELN;
    WRITE(Dividend," : ",Divisor," = ")

    (* This outputs the entered values *)

    Division(Dividend,Divisor,Laenge);

    (* Now we jump into the sub-routine to calculate the division *) 

    WRITELN;
    WRITELN;
    WRITE(Text[8]);
    what:=ReadKey;
    WRITELN;
    WRITELN;

    (* Only some output onto the screen to make the user happy *)

  UNTIL UPCASE(what)=Text[7];

    (* We repeat this until you have enough of it *)

END.

