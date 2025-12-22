program mouse;

{ -----------  Mouse.p (PCQ1.2b), 1992 by "Diesel" B. Künnen  -------------

  Nur mal, um zu zeigen, wie man seinem eigenen oder einem anderen 
  Window einen neuen Mauszeiger verpaßt. Das Programm an sich ist
  Public Domain. ( Naaaa, wer malt den schönsten Mauszeiger ??? )

  MS/PCQ-central, 26.06.1992
}


{$I "include:exec/memory.i" }
{$I "include:exec/libraries.i" }
{$I "include:intuition/intuition.i" }
{$I "include:intuition/intuitionbase.i" }
{$I "include:intuition/screens.i" }
{$I "include:graphics/view.i" }
{$I "include:libraries/dos.i" }


Const	anzShorts : Short = 24;				{ 24 Shorts = 48 bytes }

	ptrdata : ARRAY[1..anzShorts] Of Short =
	(   0,     0,
	%0000000000000000,	%0111111111110000,	{ Sprite-data f. }
	%1111111111110000,	%1111111111111000,	{ den eigenen    }
	%0111000000111000,	%0111100000111100,	{ Mauszeiger     }
	%0011000000011100,	%0011100000011110,
	%0000000000000000,	%0000000000000000,
	%1111111111111111,	%0000000000000000,
	%0000000000000000,	%0000000000000000,
	%0011000000011100,	%0011100000011110,
	%0111000000111000,	%0111100000111100,
	%1111111111110000,	%1111111111111000,
	    0,     0);

	DMemSize : Integer = 2 * Anzshorts;

Var
	GfxBase,
	DMem      : Address;
	DScreen   : ScreenPtr;
	DWindow   : WindowPtr;
	IntuiBase : IntuitionBasePtr;


{ --- Zum sauberen verlassen des Programms, egal ab wo ... --- }

Procedure CleanExit(why: String; rt : Integer);
Begin
	If DMem<>NIL then FreeMem(DMem,DMemsize);
	If GfxBase<>NIL then CloseLibrary(GfxBase);
	If IntuiBase<>NIL then CloseLibrary(LibraryPtr(IntuiBase));
End;



{ ------------- MAIN ------------- }


Begin
	{ IntuitionBasePtr holen }
	IntuiBase:=IntuitionBasePtr(Openlibrary("intuition.library",0));
	If IntuiBase=NIL then CleanExit("No intui.lib\n",10);

	{ GfxBasePtr holen, f. graphics-Routinen }
	GfxBase:=Openlibrary("graphics.library",0);
	If GfxBase=NIL then CleanExit("No gfx.lib\n",10);

	{ ein wenig ChipMem (!) f. die Daten holen & dorthin kopieren }
	DMem:=AllocMem(DMemsize,MEMF_Chip);
	If DMem=NIL then CleanExit("No ChipMem\n",5);

	CopyMem(Adr(PtrData),DMem,DMemSize);

	{ Ptr auf aktuelles Window/Screen holen }
	DScreen:=IntuiBase^.ActiveScreen;
	DWindow:=IntuiBase^.ActiveWindow;

	write("Zum Beenden Maus in linke obere Ecke führen\n");

	{ Mauszeiger ändern }
	SetPointer(DWindow, DMem, (anzShorts-4) Div 2, 16, -2, -2);

	{ warten, bis Maus links oben }
	repeat
	  Delay(10);
	until (DScreen^.MouseX=0) AND (DScreen^.MouseY=0);

	{ Mauszeiger zurücksetzen }
	ClearPointer(DWindow);

	CleanExit(NIL,0);		{ --- bye ... --- }

End.
