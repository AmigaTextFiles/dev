(*---------------------------------------------------------------------------
  :Program.    Commser.mod
  :Contents.   Communicate with the serial.device
  :Author.     Stephan Splitthoff (splitti@air.gt.owl.de)
  :Copyright.  Public Domain
  :Language.   Modula-2
  :Translator. Cyclone V0.91 Beta
  :History.    V1.0, [Stephan Splitthoff]  7-Jul-96
  :History.    V1.1, [Stephan Splitthoff] 22-Jul-96
  :History.                               UnitNummer als Argument
  :History.                               VersionString
  :History.                               mehr Zeichen müssen gelesen werden,
  :History.                                 als geschrieben worden sind
  :History.    V1.2, [Stephan Splitthoff] 23-Jul-96
  :History.                               mehr Zeichen lesen als geschrieben
  :History.                               wieder ausgebaut
  :History.    V1.3  [Stephan Splitthoff] 24-Jul-96
  :History.                               Alle Variablen werden initialisiert
  :History.                               einige interne Änderungen
  :History.    V1.4  [Stephan Splitthoff] 13-Aug-96
  :History.                               Argument "w" eingebunden
  :History.                               Warten einiger ticks
  :Bugs.       Übretragungsfehler mit v34serial.device
  :Bugs.       Wenn ein anderes device anstelle von serial.device
  :Bugs.         benutzt wird, wird das letzte Zeichen doppelt
  :Bugs.         ausgegeben
---------------------------------------------------------------------------*)

MODULE CommSer;


FROM DosL	 IMPORT Delay;
FROM ExecL       IMPORT CreateMsgPort,OpenDevice,DoIO, CloseDevice,
                        DeleteIORequest,DeleteMsgPort;
FROM ExecD       IMPORT MsgPortPtr,read, write;
FROM Serial      IMPORT IOExtSer, IOTArray,SerFlagSet,SerFlags,
			query,setParams,StatusSet,Status;
FROM ExecSupport IMPORT CreateExtIO,DeleteExtIO,CreatePort;
FROM SYSTEM      IMPORT ADR,ADDRESS,LONGSET;
FROM InOut       IMPORT WriteString,WriteCard,WriteLn,WriteInt,Write;
FROM String      IMPORT Length,Copy,Delete;
FROM Arguments   IMPORT NumArgs, GetArg;
FROM ModulaLib   IMPORT Assert;
FROM Convert     IMPORT StrToInt,IntToStr;
IMPORT NoGuru;


VAR version : ARRAY [0..100] OF CHAR;


PROCEDURE ExamineArguments(VAR SendString, DeviceName : ARRAY OF CHAR;
                           VAR Unit : LONGINT; VAR wait : LONGINT);
CONST maxArgs = 4;

VAR arg          : ARRAY [1..maxArgs] OF ARRAY [1..81] OF CHAR;
    fehler       : BOOLEAN;
    i            : INTEGER;
    UnitString   : ARRAY [0..100] OF CHAR;
    waitString   : ARRAY [0..100] OF CHAR;

BEGIN

  (* Init aller Variablen *)
  FOR i:=1 TO 81 DO
    arg[1,i]:=00C;
    arg[2,i]:=00C;
    arg[3,i]:=00C;
    arg[4,i]:=00C;
  END;
  wait:=0;
  FOR i:=0 TO 100 DO
    UnitString[i]:=00C;
    waitString[i]:=00C;
  END;
  fehler:=FALSE;
  i:=0;


  Copy(SendString,"AT"+15C);
  Copy(DeviceName,"serial.device");
  Unit:=0;
  IntToStr(Unit,UnitString,1,fehler);

  fehler := FALSE;

  GetArg(1,arg[1]);
  GetArg(2,arg[2]);
  GetArg(3,arg[3]);
  GetArg(4,arg[4]);

  FOR i:=1 TO maxArgs DO
    IF NumArgs()>=i THEN
      CASE arg[i,1] OF
        "-": CASE arg[i,2] OF
               "s": Copy(SendString,arg[i]); |
               "d": Copy(DeviceName,arg[i]); |
               "u": Copy(UnitString,arg[i]); |
               "w": Copy(waitString,arg[i]); |
               ELSE fehler:=TRUE;
             END; |
        ELSE fehler:=TRUE;
      END;
    END;
  END;

  IF fehler=TRUE THEN
    WriteString("Illegal Arguments!!");WriteLn;
    WriteString("See CommSer.doc for help!");WriteLn;WriteLn;
  END;

  IF SendString[0]   ="-" THEN Delete(SendString,0,2); END;
  IF DeviceName[0]   ="-" THEN Delete(DeviceName,0,2); END;
  IF UnitString[0]   ="-" THEN Delete(UnitString,0,2);
                               StrToInt(UnitString,Unit,fehler);END;
  IF waitString[0]   ="-" THEN Delete(waitString,0,2);
                               StrToInt(waitString, wait,fehler);END;
  WriteString("Sending     : ");
  WriteString(SendString);WriteLn;
  WriteString("Used device : ");
  WriteString(DeviceName);WriteLn;
  WriteString("Unit ");WriteInt(Unit,3);WriteLn;
  WriteString("waiting ");WriteInt(wait,5);WriteString(" ticks");
  WriteLn;WriteLn;

END ExamineArguments;

PROCEDURE Communicate();

VAR SerialMP      : MsgPortPtr;
    SerialIO      : POINTER TO IOExtSer;
    Command2      : ARRAY[1..1000] OF CHAR;
    TermString,
    Command,
    Device,
    t1,t2         : ARRAY [1..81] OF CHAR;
    unit          : LONGINT;
    TermArray     : IOTArray;
    i             : INTEGER;
    ticks         : LONGINT;

BEGIN

  (* Init aller Variablen *)

  SerialMP:=NIL;
  SerialIO:=NIL;
  FOR i:=1 TO 1000 DO
    Command2[i]:=00C;
  END;
  FOR i:=1 TO 81 DO
    TermString[i]:=00C;
    Command[i]:=00C;
    Device[i]:=00C;
    t1[i]:=00C;
    t2[i]:=00C;
  END;
  unit:=0;
  i:=0;
  ticks:=0;


ExamineArguments(t1,t2,unit,ticks);     (* Looking for the arguments *)


TermArray.termArray0:=218959117; (* 0d 0d 0d 0d *)
TermArray.termArray1:=218959117; (* 0d 0d 0d 0d *)

  Command:= t1;
  Device := t2;
  Command[Length(Command)+1]:=15C;

(* Create some ports *)

  SerialMP:=CreatePort(0,0);
  Assert(SerialMP#NIL,ADR("Create MessagePort faild!!"));

  SerialIO:=CreateExtIO(SerialMP,SIZE(IOExtSer));
  Assert(SerialIO#NIL,ADR("Create IORequest!!"));

(* Open the device *)

  OpenDevice(ADR(Device),unit,SerialIO,LONGSET{0});
  IF SerialIO^.ioSer.error=0 THEN

  (* Change some parameters of the device *)

    SerialIO^.serFlags  := SerFlagSet{eofMode};
    SerialIO^.baud      := 38400;
    SerialIO^.readLen   := 8;
    SerialIO^.writeLen  := 8;
    SerialIO^.stopBits  := 1;
    SerialIO^.termArray := TermArray;
    SerialIO^.ioSer.command:= setParams;
    DoIO(SerialIO);


  (* Send the command to the device *)

    SerialIO^.ioSer.length:=-1;
    SerialIO^.ioSer.data := ADR(Command);
    SerialIO^.ioSer.command:=write;
    DoIO(SerialIO);
    

    Delay(ticks);

  (* Recive chars from the device until no chars in the buffer *)

    SerialIO^.ioSer.length := 1;
    SerialIO^.ioSer.data   := ADR(Command2);

    Delay(5);

    REPEAT

      Delay(1);
      SerialIO^.ioSer.command:=query;
      DoIO(SerialIO);

      IF SerialIO^.ioSer.actual > 0 THEN
        SerialIO^.ioSer.command:= read;
        SerialIO^.ioSer.length := SerialIO^.ioSer.actual;
        DoIO(SerialIO);
        Command2[SerialIO^.ioSer.actual]:=00C;
        WriteString(Command2);
      END;


    UNTIL SerialIO^.ioSer.actual=0



  (* Close the device *)

  ELSE
    WriteString("Can not open ");WriteString(Device);WriteString("  Unit ");
    WriteInt(unit,3);
    WriteString(" !!");WriteLn;
  END;

  CloseDevice(SerialIO);
  DeleteIORequest(SerialIO);
  SerialIO:=NIL;
  DeleteMsgPort(SerialMP);
  SerialMP:=NIL;
  
  WriteLn;
END Communicate;


BEGIN

  version:="$VER: CommSer V1.4 (13.8.96)";

  WriteLn;
  WriteString("CommSerV1.4 Written by Stephan Splitthoff");WriteLn;
  WriteString("                       splitti@air.gt.owl.de");WriteLn;
  WriteLn;
  
  Communicate();


END CommSer.
