 

{
    Game.i

      Die hier folgenden Routinen sind alle für die Benutzung
      in den Spielen gedacht.
      Nähere Informationen: siehe Dokumentation.
}

{ - Copyright und Revisionsnummer für die verwendeten Routinen -------- }

CONST
    CopyRight : string = "7. Juni 1993 , Jörg Wach ";
    RevNummer : string = "Version V1.20";

{$I "include:Exec/libraries.i"  }
{$I "include:exec/interrupts.i"  }  { für Permit/Forbid und VB-Server }
{$I "Include:Exec/Memory.i"}        { * für den VB-Server * }
{$I "Include:Exec/nodes.i"}         { * Für den VB-Server * }

{$I "include:intuition/intuition.i"}

{$I "include:graphics/Pens.i"      }
{$I "include:graphics/Text.i"      }
{$I "include:graphics/Graphics.i"  }
{$I "include:graphics/rastport.i"  } { für den Rastport }
{$I "include:graphics/blitter.i"  }  { für die Blitter-Funktionen }

{$I "Include:Hardware/intbits.i"} { Für den VBServer. }
{$I "Include:Libraries/DOS.i"}      { * Für die Sample-Routinen. * }
{$I "Include:Utils/StringLib.i"}    { * Für die Sample-Routinen. * }


{ - Die verwendeten Typen, Constanten und Variablen. ------------------ }


TYPE
        ObjektDef = record  { die Definition meiner Spielobjekte }
            Ox      :   short;  { x-Position linke obere Ecke }
            Oy      :   short;  { y-Position linke obere Ecke }
            Sizex   :   short;  { x-size }
            Sizey   :   short;  { y-size }
            Speedx  :   short;  { x-Geschwindigkeit }
            Speedy  :   short;  { y-Geschwindigkeit }
            Phase1  :   short;  { Bewegungsphasenzähler1 }
            Phase2  :   short;  { Bewegungsphasenzähler2 }
            typ     :   short;  { Objekttyp }
        end;

CONST
        Objektsize : integer = sizeof(ObjektDef); { Größe eines Objektes }

VAR
        Objekt     : array[0..255] of ObjektDef;  { Max. Anzahl der Objekte }
        Picture    : array[1..100] of Imageptr;  { Max. 100 Bilder. Daten
                                                  nur als Pointer ( um
                                                  schneller Bilder
                                                  zuzuordnen) }

        blitctrl        : short;    { Globale Variable für Blitterergebnis }
        BlittiSpeicher  : Address;  { Wird benötigt, weil überschneidungen
                                      bei der Bearbeitung auftreten !!! }
        MyBitMap        : Address;  { Adresse der BitMap }
        MyRPort         : RastPortPtr;
{ --------------------------------------------------------------------- }
{ - Die verwendeten Typen, Variablen und Konstanten für den VB-Server - }
{ --------------------------------------------------------------------- }

        vbint : InterruptPtr;
        VBcounter : integer;

{ --------------------------------------------------------------------- }
{ - Die verwendeten Typen, Konstanten und Variablen für die Playsample  }
{ - Routinen. --------------------------------------------------------- }
{ --------------------------------------------------------------------- }
type
    Voice8Header = record
        oneShotHiSamples,
        repeatHiSamples,
        samplesPreHiCycle : Integer;
        samplesPerSec : Short;
        ctOctave        : Byte;
        sCompression    : Byte;
        volume : Integer;
    end;

    Sampletabdef = record
        dbuf    : Address;      { * Enthält die Adresse des Samplebuffers. * }
        dlen    : integer;      { * Länge des Samples. * }
        dhz     : short;        { * Tonhöhe. * }
    end;

    FibTable = Array [0..15] of Byte;

const
    FP          : FileHandle = Nil;
    codeToDelta : FibTable = (-34, -21, -13, -8, -5, -3, -2, -1, 0,
                                1, 2, 3, 5, 8, 13, 21);
    Sampletab   : array[1..10] of Sampletabdef = (
                  ( Nil, 0, 0),
                  ( Nil, 0, 0),
                  ( Nil, 0, 0),
                  ( Nil, 0, 0),
                  ( Nil, 0, 0),
                  ( Nil, 0, 0),
                  ( Nil, 0, 0),
                  ( Nil, 0, 0),
                  ( Nil, 0, 0),
                  ( Nil, 0, 0)                    );

    Sampletabsize : integer = sizeof(Sampletabdef);
    Channel : byte = 0;     { * Enthält die Nummer des neu zu belegenden
                                Kanals. * }
var
    VHeader     : Voice8Header;

{ --------------------------------------------------------------------- }


Procedure GraphCollision( x1, y1, xsize, ysize : short);
{ Testet einen BitMapBereich auf vorhandene Punkte. xsize und ysize
  bestimmen das Ausmaß des zu testenden Bereiches. }
    External;

Function CollObjekt(von, bis, x1, y1, sizex, sizey : short) : short;
{ Die Funktion ermittelt, welches Objekt in dem Rechteck x1, y1,
  x1+sizex und y1+sizey Kollidiert ist. Hierbei kann ein von / bis
  Bereich für die Objektuntersuchung angegeben werden (0 - 255 ).
  Wird als Von-Wert -1 angegeben, so werden alle Objekte untersucht und
  die erste Objektnummer, die zur Kollision führte, zurück gegeben.
  Ist der Rückgabewert -1, so gab es eine Kolision mit einem nicht
  definierten Objekt bzw. das Objekt wurde nicht gefunden.
}
    External;

Procedure DrawObjekt( VonNr, BisNr : short );
{   Zeichnet die mit VonNr bis BisNr gekennzeichnete Objekte. }
    External;

Procedure UnDrawObjekt( VonNr, BisNr : short );
{   Löscht die mit VonNr bis BisNr gekennzeichnete Objekte. }
    External;

Function GetChar() : byte;
{ Liefert den RAW-Wert einer Taste zurück.
  Ein paar Tastencodes:     AMIGA-links   : $33
                            AMIGA-rechts  : $31
                            DEL           : $73
                            Cursor hoch   : 103
                            Cursor runter : 101
                            Cursor rechts :  99
                            Cursor links  :  97
}
    External;

Function GetJoy2(): byte;
{ Gibt folgende Werte zurück:
    0 - Joystick wurde nicht berührt
    1 - Joystick nach rechts
    2 - Joystick nach links
    4 - Joystick nach hinten
    8 - Joystick nach vorne
   16 - Feuertaste gedrückt
}
    External;

Function ChipCopy( Source : Address; Size : integer) : Address;
{ Allokiert ChipMem in der Größe Size und kopiert die Daten von
  der Addresse Source dort hinein. Zurückgegeben wird die ChipMem
  Adresse.
}
    External;

Procedure IntToStr6(s : string; i : integer);
{ Konvertiert positive Zahlen in das Stringformat mit führenden
    Nullen. Max. 6 Nullen und max. die Zahl 999999 }

    External;

Procedure PowerLEDON();
{ Macht die PowerLed an. }
    External;

Procedure PowerLEDOFF();
{ Macht die PowerLed aus. }
    External;

{ --------------------------------------------------------------------- }
{ ---------   VB-Server                    ---------------------------- }
{ --------------------------------------------------------------------- }

Procedure InitVB();
{ * Initialisiert den VB-Server. * }
    External;

Procedure Exitvb();
{ * Gibt den VB-Server wieder frei. * }
    External;

Procedure Settime();
{ * Setzt den VB-Server-Wert uf 0. * }
    External;

Function Gettime(): integer;
{ * Liefert den Wert des VBServer zurück. * }
    External;

Procedure WaitVB(ticks : short);
{ * Wartet ticks Ticks vom VB. * }
    External;

{ --------------------------------------------------------------------- }
{ ---------   Playsample                   ---------------------------- }
{ --------------------------------------------------------------------- }

Procedure FreeSample(Nummer: byte);
{ * Gibt das Sample mit der Nummer nummer aus der Sampletab wieder
    frei inkl. aller belegter Speicherbereiche. * }
    External;

Procedure PlaySample(nummer : short);
{ * Spielt den in der Sampletab abgelegten Sound ab. * }
    External;

Function LoadSample(Nummer : byte; name : String): short;
{ Lädt ein IFF-8SVX Sample und weißt diesem alle erforderlichen Werte
  zu.
  Returncodes :  0 ---> Sample konnte O.K. initialisiert werden.
                -1 ---> File konnte nicht geöffnet werden.
                -2 ---> Kein Filename.
                -3 ---> Sampleplatz schon belegt.
                -4 ---> Kein IFF-8SVX-File.
                -7 ---> Kein Speicher für Sample.
                -9 ---> Kein Speicher für Dekompression.
               -10 ---> Unbekannter Kompression-Type.
}
    External;


