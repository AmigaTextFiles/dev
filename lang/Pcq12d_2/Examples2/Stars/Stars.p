
{ -----------------------------------------------------------------------
  -  Sternensimulation im Vorbeiflug, oder ?                            -
  -----------------------------------------------------------------------
}

Program Stars;

{$I "include:Exec/libraries.i"  }
{$I "include:Intuition/screens.i"  }
{$I "include:intuition/intuition.i"}
{$I "include:graphics/Pens.i"      } { für die WritePixel-Funktion }
{$I "include:graphics/Graphics.i"  } { für die GFXBase }
{$I "include:graphics/rastport.i"  } { für den Rastport }
{$I "include:Utils/stringlib.i"    }
{$I "Include:Utils/CRT.i"}
{$I "Include:Utils/random.i"}        { Zufall }
{$I "dh0:pcq/module/game.i"}         { Die Spiel-Routinen }




CONST

        { Wir definieren einen Screen mit 3-Bitlanes und keiner Titel-
          leiste. Hires und 640 x 200 Punkte Auflösung }

        NewScr : NewScreen  =  ( 0, 0, 640, 200, 3, 1, 0, HIRES,
                                 CUSTOMSCREEN_f + SCREENQUIET_f,
                                 NIL, NIL, NIL, NIL);

        { Und jetzt ein Rahmenloses Fenster }

        NewWin : NewWindow  =  (0,0,640,200,0,0,0,
                                BORDERLESS + ACTIVATE,
                                NIL,NIL,"",
                                NIL,NIL,0,0,0,0,
                                CUSTOMSCREEN_F);


        { Wir definieren eine Farbtabelle mit 8 Farben für LoadRGB4 }

        Farbtabelle : array[1..8] of short = (

                        $0002,   { Schwarz }
                        $0FFF,   { Weiß }
                        $000A,   { Blau }
                        $0F0F,   { Pink }
                        $00FF,   { Türkis }
                        $00F0,   { Grün }
                        $092F,   { Violett }
                        $0A00    { Rot}

                        );

VAR
        MyVPort         : Address;
        Scr             : ScreenPtr;
        Win             : WindowPtr;

PROCEDURE cleanexit(why : String ; rtcode : Integer);

BEGIN
        IF Win      <> NIL THEN CloseWindow(Win);
        IF Scr      <> NIL THEN CloseScreen(Scr);
        IF GfxBase  <> NIL THEN CloseLibrary(GfxBase);

                { ## Ausgabe ins CLI, warum das Program verlassen }
                { ## werden mußte, inkl.Returncode f. Batchfiles  }
        IF why<>NIL THEN writeln(why);
        exit(rtcode);
END;

Procedure InitScreen();
{ Initialisiert die Bildschirmdaten }
begin
  Scr:=OpenScreen(Adr(NewScr));
  IF Scr = NIL THEN cleanexit("Can`t open Screen.",5);

  NewWin.Screen:=Scr;
  Win:=OpenWindow(Adr(NewWin));
  IF Win=NIL THEN cleanexit("Can`t open window.",5);

  MyVPort:=Adr(Scr^.SViewPort);
  MyRPort:=Win^.RPort;
  MyBitMap := MyRPort^.BitMap;
  LoadRGB4(MyVPort,ADR(Farbtabelle),8);

end; { InitScreen }

Procedure InitAnything();
{ Initialisiert die sonstigen Daten }
var
    tt1 : short;
begin
  SelfSeed();
  GfxBase:=OpenLibrary("graphics.library",0);
  IF GfxBase=NIL THEN cleanexit("Can`t open Gfx.lib.",20);

    for tt1 := 0 to 255  do      { Die nicht benutzten Objekte kennzeichnen }
        Objekt[tt1].Ox := -1;

end; { InitAnything }

procedure Farbe(tt1,tt2,tt3 : byte); { tt1=Schriftart,tt2=Vordergrundfarbe,
                                       tt3 = Hintergrundfarbe }
var
    tt4, dummy : integer;
begin
    SetDrMd(MyRPort,JAM2);
    SetAPen(MyRPort,tt2);
    SetBPen(MyRPort,tt3);
    if tt1 = 0 then tt4 := 0;
    if tt1 = 1 then tt4 := 2;
    if tt1 = 3 then tt4 := 4;
    if tt1 = 4 then tt4 := 1;
    dummy := SetSoftStyle(MyRPort,tt4,$ff);
end; { Farbe}

Procedure SetStars();
{ Setzt die Sterne auf die Ausgangsposition. Die Sterne belegen die
  Objektnummern 201 - 212 }
var
    tt  : byte;
begin
    for tt := 201 to 203 do begin
        Objekt[tt].Ox := RangeRandom(640); { x - Koordinate }
        Objekt[tt].Oy := RangeRandom(200); { y - Koordinate }
        Objekt[tt].Speedx := -1; { x - Geschwindigkeit }
        Objekt[tt].Speedy := 0; { y - Geschwindigkeit }
        Objekt[tt].typ := 10; { Es ist nur ein Punkt }
    end;
    for tt := 204 to 206 do begin
        Objekt[tt].Ox := RangeRandom(640); { x - Koordinate }
        Objekt[tt].Oy := RangeRandom(200); { y - Koordinate }
        Objekt[tt].Speedx := -2; { x - Geschwindigkeit }
        Objekt[tt].Speedy := 0; { y - Geschwindigkeit }
        Objekt[tt].typ := 10; { Es ist nur ein Punkt }
    end;
    for tt := 207 to 209 do begin
        Objekt[tt].Ox := RangeRandom(640); { x - Koordinate }
        Objekt[tt].Oy := RangeRandom(200); { y - Koordinate }
        Objekt[tt].Speedx := -4; { x - Geschwindigkeit }
        Objekt[tt].Speedy := 0; { y - Geschwindigkeit }
        Objekt[tt].typ := 10; { Es ist nur ein Punkt }
    end;
    for tt := 210 to 212 do begin
        Objekt[tt].Ox := RangeRandom(640); { x - Koordinate }
        Objekt[tt].Oy := RangeRandom(200); { y - Koordinate }
        Objekt[tt].Speedx := -8; { x - Geschwindigkeit }
        Objekt[tt].Speedy := 0; { y - Geschwindigkeit }
        Objekt[tt].typ := 10; { Es ist nur ein Punkt }
    end;

end; { SetStars }


Procedure MoveStars();
{ Bewegt die Sterne }
var
    tt : byte;
begin
    for tt := 201 to 212 do begin
        Farbe(0,0,0);   { Hintergrundfarbe setzen }
        WritePixel(MyRPort,Objekt[tt].Ox,Objekt[tt].Oy); { Stern löschen }
        Farbe(0,1,0);   { Farbe auf Weiß setzen }
        Objekt[tt].Ox := Objekt[tt].Ox + Objekt[tt].Speedx; { Stern verschieben }
        if Objekt[tt].Ox < 0 then begin
            Objekt[tt].Ox := 640;  { Wenn kleiner 0 dann wieder am Ausgangspunkt}
            Objekt[tt].Oy := RangeRandom(200); { neue y - Koordinate }
        end; { if }
        WritePixel(MyRPort,Objekt[tt].Ox,Objekt[tt].Oy); { Stern zeichnen }
    end; {for}
end; { Movestars }

var
    ii, jj : integer;
    Maske1, Maske2  : byte;

BEGIN

    InitAnything(); { sonstiges Initialisieren }
    InitScreen();   { Und jetzt den Screen }

    SetStars();

    repeat

        MoveStars();

    until GetChar() = 51;

  cleanexit(NIL,0);                     { bye bye baby .... }

END.
