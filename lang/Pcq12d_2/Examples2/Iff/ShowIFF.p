program ShowIFF;

{  ------------------------------------------------------------------------
	ShowIFF.p  -  ein kleines Tool zum Anzeigen von Iff-Bildern,
	basierend auf ShowIFF.c von Christian A. Weber .
	Benötigt die iff.library (im LIBS:-Ordner oder im ROM)
	Diese Programm ist PD, kann also ohne weiteres verbreitet und
	verändert werden.
	( Diese Version erkennt keine Overscan-Pics ... )
   ------------------------------------------------------------------------ }

{$I "Include:graphics/gfxbase.i"   }
{$I "Include:intuition/intuition.i"}
{$I "Include:intuition/screens.i"  }
{$I "Include:Utils/stringlib.i"    }
{$I "Include:Utils/Parameters.i"   }
{$I "Include:libraries/iff.i"      }
{$I "Include:exec/libraries.i"     }

Const
	ns : NewScreen =  (0,0,0,0,0,0,0,0,CUSTOMSCREEN_f+SCREENQUIET_f,
	NIL, "ShowIFF by Christian A. Weber(C)/B. Künnen(PCQ)", NIL, NIL);

Var
	MyIff      : IffFile;
	i,count    : Integer;
	colortable : Array[1..128] of Short;
	bmhd       : BitMapHeaderPtr;
	myscreen   : ScreenPtr;
	GfxBase    : GfxBasePtr;
	arg        : String;



Procedure CleanExit(why : String; rt : Integer);
Begin
	if myscreen<>NIL then CloseScreen(myscreen);
	if MyIff<>NIL  then CloseIFF(MyIff);

	If GfxBase<>NIL then CloseLibrary(Address(GfxBase));
	If IffBase<>NIL then CloseLibrary(IffBase);

	If why<>NIL then write(why);
	Exit(rt);
End;


{ -- Hauptprogramm -- }

BEGIN
	arg:=AllocString(80);
	GetParam(1,arg);	{ -- Parameter holen, wenn vorhanden -- }
				{ -- sonst abfragen		     -- }
	if strlen(arg)=0 then begin
	  Write("Welches Bild möchten sie sehen : ");
	  Readln(arg);
	  If strlen(arg)=0 then CleanExit("Format: ShowIFF filename\n",10);
	end;

	{ -- Libraries öffnen -- }
	GfxBase := GfxBasePtr(OpenLibrary("graphics.library",0));
	if GfxBase=NIL then CleanExit("No Gfx.lib\n",25);

	IFFBase := OpenLibrary(IFFNAME,18);	{ -- hier reicht 18 -- }
	if IFFBase = NIL then
	    cleanexit("Copy the iff.library to your LIBS: directory!\n",10);

	write("Attempt loading the file ",arg,"\n");

	{ -- IFF-Pic laden -- }
	MyIff:=OpenIFF(arg);
	if MyIff=NIL then    Cleanexit("Error opening file\n",5);

	{ -- Bitmap-Header holen -- }
	bmhd := GetBMHD(MyIff);
	if  bmhd = NIL then    CleanExit("BitMapHeader not found\n",5);

	ns.Width      := bmhd^.w;		{ -- Infos zum Pic -- }
	ns.Height     := bmhd^.h;		{ -- holen, für    -- }
	ns.Depth      := bmhd^.nPlanes;		{ -- den Screen    -- }
	ns.ViewModes  := GetViewModes(MyIff);
						{ -- Screen öffnen -- }
	myscreen := OpenScreen(Adr(ns));
	if  myscreen = NIL then  CleanExit("Can't open screen!\n",10);

						{ -- Farben setzen -- }
	count := GetColorTab(MyIff,Adr(colortable));
	if (count>32) then  count:=32;
	{ -- HAM/Halfbrite-Pictures haben 64++ Farben -- }

	LoadRGB4(Adr(myscreen^.SViewPort),Adr(colortable),count);

	{ -- Pic ggf. decodieren und in den Screen kopieren -- }
	if NOT DecodePic(MyIff,Adr(myscreen^.SBitMap)) then
		CleanExit("Can't decode picture\n",10);

	Delay(200);  { -- 4 Secs warten; ggf. auf Maus umprogr. -- }

	CleanExit(NIL,0);		{ -- Prg sauber verlassen -- }
End.

