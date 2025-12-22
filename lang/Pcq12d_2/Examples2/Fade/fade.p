
{ -----------------------------------------------------------------------
  -									-
  -  Fade  -  Version 1.1,		   (C)1991  by  Bernd Künnen	-
  -							Neuringe 75	-
  -   This programm is Freeware,			44777 Twist	-
  -   coded 25.10.1991 in PCQ-Pascal(1.2b).				-
  -   Blendet Texte zeilenweise ein & aus.				-
  -   Wichtig: Jede Zeile muß mit einem RETURN		Usage :		-
  -   abgeschlossen werden - nur ASCII-Texte				-
  -   verwenden.					Fade filename	-
  -									-
  -----------------------------------------------------------------------
}

Program Fade;

{$I "include:libraries/dos.i"	   }
{$I "include:Intuition/screens.i"  }
{$I "include:intuition/intuition.i"}
{$I "include:graphics/Pens.i"	   }
{$I "include:Utils/parameters.i"   }
{$I "include:graphics/Graphics.i"  }
{$I "include:exec/exec.i"	   }
{$I "include:Utils/stringlib.i"    }


CONST
	rgb  : Integer = 0;

	MaxSize = 1000;		{##  max. Filegröße 999 Byte }

	NewWin : NewWindow  =  (0,0,640,150,0,1,0,
				BORDERLESS + BACKDROP + ACTIVATE,
				NIL,NIL,NIL,NIL,NIL,0,0,0,0,CUSTOMSCREEN_f);

	NewScr : NewScreen  =  (0,0,640,150,1,0,1,HIRES,CUSTOMSCREEN_f,
				NIL,NIL,NIL,NIL);


VAR
	MyVPort		: Address;
	MyRPort		: Address;
	Win		: WindowPtr;
	Scr		: ScreenPtr;
	MyMem		: Address;
	MyLock		: FileLock;
	MyHandle	: FileHandle;
	anzahl,
	filesize	: Integer;
	x,y,i		: Short;
	WorkPtr,stop	: Address;
	fib		: FileInfoBlockPtr;
	myfile		: String;
	buffer		: ARRAY[0..99] OF Byte;
	ok		: Boolean;


{ **** Sorgt für ein sauberes Verlassen des Programms, egal wo man  ****
  **** aussteigt :						    **** }

PROCEDURE cleanexit(why : String ; rtcode : Integer);

BEGIN
	IF Win     <> NIL THEN CloseWindow(Win);
	IF Scr     <> NIL THEN CloseScreen(Scr);
	IF MyMem   <> NIL THEN FreeMem(MyMem,MaxSize);
	IF GfxBase <> NIL THEN CloseLibrary(GfxBase);

		{ ## Ausgabe ins CLI, warum das Program verlassen }
		{ ## werden mußte, inkl.Returncode f. Batchfiles  }
	IF why<>NIL THEN writeln(why);
	exit(rtcode);
END;



{ ****  Hier die Ein- & Ausblenderoutine, beschränkt sich allerdings  ****
  ****  dato auf Schwarz/Weiß.					      **** }

PROCEDURE fade(color: Short; x : Integer);
BEGIN
	FOR i:=0 TO 12 DO BEGIN			{ 13mal wird f. Einfaden 1,}
	  rgb:=rgb+x;				{ f. Abblenden -1 addiert  }
	  SetRGB4(MyVPort,color,rgb,rgb,rgb);	{ und die Summe als Farbe  }
	  Delay(3);				{ übergeben		   }
	END;
END;



{ ****  Da PCQ-Pascal nicht die Addition einer Integer-Zahl zu einer  ****
  ****  Adresse erlaubt, muß man halt ein wenig tricksen. Diese Rou-  ****
  ****  tine übernimmt eine Adresse, addiert einen Offset und gibt    ****
  ****  die neue Adresse in d0 zurück				      **** }

Function SetPtr(XPtr: Address; add: Integer): Address;
BEGIN
{$A
	move.l	8(sp),d0	; Assemblerkenntnisse sind
	add.l	4(sp),d0	; immer wieder nützlich
}
END;



{ ****  Little bit tricky - hier wird nach einem RETURN (#$0a = 10 )  ****
  ****  im übergebenen String gesucht und die Stringlänge zurückge-   ****
  ****  geben. In PCQ zu umständlich, da strlen() nach einem NullByte ****
  ****  sucht etc.						      **** }

Function SeekRETURN(ghi: Address): Integer;
BEGIN
{$A
	move.l	4(sp),d1	; WorkPtr nach d1 und a0
	move.l	d1,a0
seek:
	cmp.b	#$0a,(a0)+
	bne.s	seek		; RETURN suchen
	subq.l	#1,a0		; a0 berichtigen
	move.l	a0,d0		; Endadr. nach d0
	sub.l	d1,d0		; Anfangsadr. abziehen
}
END;


{ **************  Hier nun endlich die Hauptschleife  ************** }

BEGIN
  myfile:=Adr(buffer);		{ ## Filename in Buffer kopieren }
  GetParam(1,myfile);
  IF strlen(myfile)=0 THEN cleanexit(" Fade 1.1,(C)1991 B.Künnen - Usage : fade filename",0);

  GfxBase:=OpenLibrary("graphics.library",0);
  IF GfxBase=NIL THEN cleanexit("Can`t open Gfx.lib.",20);

  { ##  Im nächsten Schritt werden 1000 Bytes alloziert. Dieser Bereich wird
	zunächst als Speicher für den FileInfoBlock benutzt, und dann ggf.
	als Buffer für das File benutzt. }

  MyMem:=AllocMem(MaxSize,MEMF_PUBLIC);
  IF MyMem=NIL THEN cleanexit("No Mem.",5);

  MyLock:=Lock(myfile,SHARED_LOCK);
  IF MyLock=NIL THEN cleanexit("Can`t get lock.",5);
  fib:=MyMem;
  ok:=Examine(MyLock,fib);
  Unlock(MyLock);

  IF ok=FALSE THEN cleanexit("Can`t examine file",10);
  IF fib^.fib_EntryType>0 THEN cleanexit("Need file, no Dir.",5);

  { ##	Größe des Files holen & File laden .... }

  filesize:=fib^.fib_Size;
  IF filesize=0    THEN cleanexit("File empty.",5);
  IF filesize>MaxSize-1 THEN cleanexit("File too big.",5);

  MyHandle:=DOSOpen(myfile,MODE_OLDFILE);
  IF MyHandle=NIL THEN cleanexit("Can`t open file.",5);
  anzahl:=DOSRead(MyHandle,MyMem,filesize);
  DOSClose(MyHandle);
  IF anzahl<>filesize THEN cleanexit("Error reading file.",5);

  { ##	Um den Programmabschluß abzusichern, ...	}
  WorkPtr:=SetPtr(MyMem,filesize);
  {$A
	move.l	_WorkPtr,a0	; sicherheitshalber hinter den
	move.b	#$0a,(a0)	; Text noch ein RETURN
  }

  Scr:=OpenScreen(Adr(NewScr));
  IF Scr=NIL THEN cleanexit("Can`t open Screen.",5);
  MyVPort:=Adr(Scr^.SViewPort);
  SetRGB4(MyVPort,0,0,0,0);	{ ## Screen & Window, Titlebar  }
  SetRGB4(MyVPort,1,0,0,0);	{    unsichtbar, alles schwarz, }
  ShowTitle(Scr,FALSE);

  NewWin.Screen:=Scr;
  Win:=OpenWindow(Adr(NewWin));
  IF Win=NIL THEN cleanexit("Can`t open window.",5);
  MyRPort:=Win^.RPort;
  SetDrMd(MyRPort,JAM1);

  { ##	Jetzt geht`s ans Eingemachte. Zuerst Ptr(Anfang/Ende) holen. }

  WorkPtr:=MyMem;
  stop:=SetPtr(MyMem,filesize);

  REPEAT
	anzahl:=SeekRETURN(WorkPtr);	{ Länge des 1. String holen }

	IF (anzahl<>0) AND (anzahl<70) THEN BEGIN

	  x:=320-4*anzahl;		{ x-Position ermitteln, zum }
	  SetAPen(MyRPort,1);		{ Zentrieren d. Strings,der }
	  Move(MyRPort,x,120);		{ mit Col. 1 (noch schwarz) }
	  GText(MyRPort,WorkPtr,anzahl); { gedruckt wird	    }

	  fade(1,1);			{ Aufblenden	}
	  Delay(40);			{ 0,8 sec warten}
	  fade(1,-1);			{ Abblenden	}
	  Delay(40);

	  SetAPen(MyRPort,0);			{ A-Pen auf Col.0 }
	  RectFill(MyRPort,0,100,639,140);	{  alles löschen  }

	END; { if }

	WorkPtr:=SetPtr(WorkPtr, anzahl+1);	{ nächster String }

  UNTIL WorkPtr=stop;			{ bis Ende des Buffers erreicht }

  Delay(100);				{ 2 taktvolle Sekunden ...... }
  cleanexit(NIL,0);			{ bye bye baby .... }

END.
