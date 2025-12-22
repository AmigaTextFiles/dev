{
  +---------------------------------------------------------------------+
  |									|
  |      AskX - (C) 1993 by "Diesel" B. K¸nnen, written 4 my special	|
  |      friend Invisible Power - hi J¸rgen, die InfoX wird immer	|
  |      besser !   C U !						|
  |									|
  |      AskX ist ein Ersatz f¸r C=`s ask-Befehl. Er bietet genau wie   |
  |      das ARP-Ask eine Otpion zur Auszeit, d.h. es wartet nur eine   |
  |      vom User definierte Zeit auf einen Tastendruck. [ ARP l‰uft    |
  |      ja leider unter OS 2.0 nicht einwandfrei. ]			|
  |									|
  +---------------------------------------------------------------------+
}

Program AskX;

{$I "Include:utils/Parameters.i"}
{$I "Include:utils/stringlib.i"}
{$I "Include:libraries/dos.i"}

Const
	loop : Short = 0;

Var
	buf1,
	buf2,
	buf3  : String;
	hdl   : FileHandle;
	max,
	len,
	val,
	ten,
	i    : Integer;


Function Taste : Boolean;		{ ‹berpf¸fen, ob Taste gedr¸ckt }
Begin

						{ buf 2 konvertieren }
	for i := 0 to strlen( buf2 )-1 do
	    buf2[i] := toupper( buf2[i] );
						{ = TIMEOUT ? }
	if strcmp( buf2, "TIMEOUT" )=0 then begin

{ buf 3 }
	  max := strlen( buf3 );		{ Anzahl Ziffern }
	  If max>5 then max :=5;		{ max. 99999	 }
	  ten :=  1;
	  val :=  0;
						{ Ziffer -> Integer }
	  for i := max-1 downto 0 do Begin
	    If IsDigit( buf3[i] ) then Begin
		val := val + ( Byte(buf3[i]) - Byte('0') ) * ten;
		ten := ten * 10
	    End Else  i := 0;			{ Ziffer f¸r Ziffer }
	  End;

	 hdl := DosOutput;			{ Testen, ob ¸berhaupt	}
	  If IsInterActive( hdl ) then Begin	{ CLI-Fenster & keine	}
	    If WaitForChar( hdl, val*1000000)	{ Datei, ggf. warten	}
	    Then Taste := True			{ Taste -> OK		}
	    Else Taste := False;		{ Keine Taste -> KO	}
	  End;
	End;
	Taste:=True;
End;





Begin
	buf1 := AllocString( 100 );	{ Puffer f¸r die Strings holen }
	buf2 := AllocString( 100 );
	buf3 := AllocString( 100 );

	GetParam(1, buf1);		{ CLI-Parameter holen,	}
	GetParam(2, buf2);		{ Sofern vorhanden	}
	GetParam(3, buf3);
					{ Wenn keine Parameter: }
	If strlen(buf1)=0 then Begin
	  writeln("\nAskX 1.0, (C)1993 by Diesel\nUsage : AskX AskString [ timeout secs ]\ny/Y -> OK, n/N -> WARN\n\n");
	  Exit(0);
	End;

{ buf 1 }

	If buf1[1]='"' then Begin	{ Wenn der Ask-String in }
					{ Anf.Zeichen steht, muﬂ }
					{ das Ende gesucht werden}
	  i := 2;
	  len := strlen(buf1);

	  while  i< len do Begin
	    if buf1[i] = '"' then Begin { Wenn Ende gefunden, als }
	       buf1[i] := chr(0);	{ solches mit 0-Byte	  }
	       i := len;		{ terminieren		  }
	    End;
	  End;
	End;

	Repeat
	  inc(loop);			{ Schleifenz‰hler   }
	  Write( buf1 );		{ Ask-String setzen }

	  IF  (loop=1)			{ Nur beim 1. Durchgang  }
	  AND (strlen(buf2)>0)		{ ggf. die Zeit abwarten }
	  AND (strlen(buf3)>0)
	  THEN BEGIN
	    If Not Taste then Begin	{ -Taste- wartet die angegebene   }
	      Writeln;			{ Zeit auf eine Meldung des Users }
	      Exit(0);			{ Nix ? Dann Exit(0)		  }
	    End;
	  END;

	  Readln(buf2);			{ buf2 kann jetzt zum Einlesen	  }
	  buf2[0]:=toUpper(buf2[0]);	{ verwendet werden : y oder n ?	  }
	until (buf2[0]='Y') OR (buf2[0]='N');	{ Bis y oder n !!!!	  }

	If    buf2[0] = 'Y'
	then  Exit(0)		{ Y }
	else  Exit(5);		{ N }

End.

