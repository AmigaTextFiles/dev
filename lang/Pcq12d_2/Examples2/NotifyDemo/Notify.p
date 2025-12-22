Program Notify;

{ Mit der Notify-Funktion der DOS-Library kann man Dateien oder
  ganze Verzeichnisse auf Schreibzugriffe überwachen. So kann
  z.B. ein Programm sich sofort anpassen wenn seine Konfigurations-
  Datei verändert wurde. (so macht es z.B. IPrefs)

  Dieses Programm zeigt die Benutzung der NotifyRequest-Struktur.
  Diese wurde aufgrund von Problemen bei der Umsetzung der Includes
  von C nach Pascal etwas verändert.

  In der NotifyRequest-Struktur befindet sich das 8 Byte große Feld
  nr_Stuff (Offset 16). Dieses muß je nach nr_Flags mit den ausgefüllten
  Strukturen nr_Msg oder nr_Signal über CopyMem gefüllt werden (siehe Programm).


  -Autor: Andreas Tetzl
  -Datum: 21.12.1994
}


{$I "Include:DOS/DOS.i"}
{$I "Include:DOS/Notify.i"}
{$I "Include:Exec/ports.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Utils/Break.i"}
{$I "Include:Utils/StringLib.i"}

Const nr_Stuff_Offset = 16;

VAR nr : NotifyRequestPtr;
    nr_Message : nr_Msg;
    MyPort : MsgPortPtr;
    Msg : NotifyMessagePtr;
    Name : String;

Begin
 { NotifyRequest-Struktur initialisieren }
 New(nr);
 
 Name:=AllocString(100);
 Writeln("NotifyDemo 1994 by Andreas Tetzl\n");
 Writeln("Bitte geben Sie den Namen der Datei oder des Verzeichnisses an, welche(s) Sie");
 Write("überprüfen möchten: ");
 Readln(Name);
 Writeln;

 { MsgPort erstellen }
 MyPort:=CreateMsgPort();
 If MyPort=NIL then
  Begin
   Writeln("Kann MessagePort nicht erstellen.");
   FreeString(Name);
   Dispose(nr);
   Exit(10);
  end;

 { Adresse des Ports in nr_Msg-Struktur }
 nr_Message.nr_Port:=MyPort;

 nr^.nr_Name:=Name;    { Zu überprüfende(s) Datei/Verzeichnis }
 nr^.nr_Flags:=NRF_SEND_MESSAGE;   { nr_Stuff enthält eine nr_Msg-Struktur }
 { nr Msg in nr_Stuff kopieren }
 CopyMem(adr(nr_Message),address(Integer(nr)+nr_Stuff_Offset),4);
           { Quelle }                { Ziel }             { Länge (8 bei nr_Signal) }

 { Notify starten }
 If StartNotify(nr) then
  Begin
   Writeln("Überprüfe ",nr^.nr_FullName);
   Writeln("Bitte versuchen Sie einen Schreibzugriff auf diese(s) Datei/Verzeichnis");
   Writeln;
   Writeln("Ende mit CTRL-C");
   
   Repeat
    Delay(25);  { Wegen Prozessorauslastung }
    Msg:=NotifyMessagePtr(GetMsg(MyPort));  { Message abholen }
    If Msg<>NIL then  { Nachicht erhalten }
     Begin
      ReplyMsg(MessagePtr(Msg));  { beantworten }
      Writeln("Schreibzugriff auf ",nr^.nr_FullName," ausgeführt.");
     end;
   Until CheckBreak;
   { Notify beenden }
   EndNotify(nr);
  end;

 Dispose(nr);
 { MsgPort schließen }
 DeleteMsgPort(MyPort);
end.
