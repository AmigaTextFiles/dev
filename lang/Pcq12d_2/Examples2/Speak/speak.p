Program Speak;

{ * Coded 1993 by Diesel - this piece of cake is public domain * }

{$I "Include:Exec/Memory.i"          }
{$I "Include:Exec/Devices.i"         }
{$I "Include:devices/Narrator.i"     }
{$I "Include:libraries/Translator.i" }
{$I "Include:utils/IOutils.i"        }
{$I "Include:utils/Stringlib.i"      }

VAR
	txt	: String;
	i, OpDv,
	error	: Integer;
	Sport	: MsgPortPtr;
	Sreq	: Narrator_rbPtr;
	Xbuf	: ARRAY[0..500] OF CHAR;
	channels: ARRAY[0..3]   OF Byte;



Function CreateExtIO( iop : MsgPortPtr; iosize : Integer) : Address;
Var
  ExtIO : IOStdReqPtr;

Begin
  If iop = NIl then CreateExtIO := NIL;
  ExtIO := AllocMem( iosize, Memf_Public+Memf_Clear );
  If ExtIO = NIL then CreateExtIO := NIL;

  With ExtIO^.io_message do begin
    mn_node.ln_Type := NTMessage;
    mn_Length := iosize;
    mn_ReplyPort := iop;
  End;
  CreateExtIO := ExtIO;
End;


Procedure DeleteExtIO( iorp : IOStdReqPtr );
Begin
  With iorp^ do begin
    io_Message.mn_node.ln_Type := $ff;
    io_Device := Address( -1 );		{ * Verstümmeln *}
    io_Unit   := Address( -1 );
  End;
  FreeMem( iorp, iorp^.io_Message.mn_Length );	{ * Speicher freigeben * }
End;



Procedure CleanExit( why : String; rt : Integer);
Begin
  If  TranslatorBase <> NIL then CloseLibrary(TranslatorBase);
  If  OpDv  <> 0   then CloseDevice( Sreq );
  If  Sreq  <> NIL then DeleteExtIO( IOStdReqPtr(Sreq) );
  If  Sport <> NIL then DeletePort( Sport );
  If  txt   <> NIL then FreeString ( txt );

  If why <> NIL then WriteLn( why );
  Exit( rt );
End;




BEGIN
  txt := AllocString( 80 );

  Write("\n Speak V1.0 by Diesel, made in PCQ-Pascal.\n\n RETURN = quit\n");

  { * Translator.library öffnen * }
  TranslatorBase := OpenLibrary("translator.library", 32 );
  If TranslatorBase = NIL then CleanExit("Kann translator.lib nicht öffnen",20);

  { * Ausgabekanäle definieren * }
  channels[0]:=3; channels[1]:=5; channels[2]:=10; channels[3]:=12;
  
  { * Port einrichten * }
  Sport:=CreatePort(NIL,0);
  If Sport = NIL then CleanExit("Kann MsgPort nicht einrichten.",5);

  { * Request einrichten * }
  Sreq:=CreateExtIO(Sport,SizeOf(Narrator_rb));
  If Sreq = NIL then CleanExit("Kann ExtIOReq nicht einrichten.",5);

  { * Device öffnen * }
  OpDv :=OpenDevice( "narrator.device", 0, Sreq, 0 );
  If OpDv <> 0 then CleanExit("Kann narrator.device nicht öffnen",10);

  { * Hauptschleife * }
  Repeat
    for i := 0 to 500 do begin		{ * Clear transl.puffer * }
      xbuf[i] := chr(0);
    End;

    Write("Zu sprechender Text: ");	{ * Text eingeben * }
    Readln( txt );
    If strlen( txt )>0 then begin

      { * Text übersetzen (in Phonem-Codes) * }
      error := Translate( txt, strlen(txt), ADR(Xbuf), 500);

      If error=0 Then begin

        With Sreq^ Do begin
          message.io_command:=CMD_write;{ * Kommando: ausgeben       * }
          message.io_data   :=ADR(Xbuf);{ * Adresse des Phonem-Puf.  * }
          message.io_length :=500;	{ * Länge des Puffers        * }
          rate     := 120;		{ * 100 Wörter pro Minute    * }
          pitch    := 80;		{ * Stimmlage 230            * }
          sex      := male;		{ * weibliche Stimme         * }
          mode     := naturalF0;	{ * natürlich betont         * }
          ch_Masks := ADR(channels[0]);	{ * Adresse des Kanal-Arrays * }
          nm_Masks := 4;		{ * alle 4 Kanäle            * }
          volume   := 64;		{ * Lautstärke 64            * }
          sampFreq := 22200;		{ * Samplingfrequenz 28000   * }
        End;

        error := DoIO( Sreq );		{ *          GO !!           * }
        If (error <> 0) then Writeln("Error on DoIO()");
      End;
    End;

  Until strlen( txt ) = 0;

  { * Arbeit beendet, hinterlasse geordneten Zustand ! * }
  CleanExit( NIL, 0 );

END.
