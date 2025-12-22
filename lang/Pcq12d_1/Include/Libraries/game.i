{
    Game.i

      Die hier folgenden Routinen sind alle für die Benutzung
      in den Spielen gedacht.
      Nähere Informationen: siehe Dokumentation.
}

{ - Copyright und Revisionsnummer für die verwendeten Routinen -------- }

CONST
    CopyRight : string = "19. Juni 1992 , Jörg Wach ";
    RevNummer : string = "Version V1.00";


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
        Picture    : array[1..20] of Image;  { Max. 20 Bilder }

        blitctrl        : short;    { Globale Variable für Blitterergebnis }
        BlittiSpeicher  : Address;  { Wird benötigt, weil überschneidungen
                                      bei der Bearbeitung auftreten !!! }
        MyBitMap        : Address;  { Adresse der BitMap }
        MyRPort    : RastPortPtr;
{ --------------------------------------------------------------------- }


Procedure GraphCollision( x1, y1, xsize, ysize : short);
{ Testet einen BitMapBereich auf vorhandene Punkte. xsize und ysize
  bestimmen das Ausmaß des zu testenden Bereiches. }
    External;

Function CollObjekt(von, bis, x1, y1, x2, y2 : short) : short;
{ Die Funktion ermittelt, welches Objekt in dem Rechteck x1, y1, x2, y2
  Kollidiert ist. Hierbei kann ein von / bis Bereich für die Objekt-
  untersuchung angegeben werden (0 - 255 ).
  Wird als Von-Wert -1 angegeben, so werden alle Objekte untersucht und
  die erste Objektnummer, die zur Kollision führte, zurück gegeben.
  Ist der Rückgabewert -1, so gab es eine Kolision mit einem nicht
  definierten Objekt bzw. das Objekt wurde nicht gefunden.
}
    External;

Procedure DrawObjekt( VonNr, BisNr : short; MyPlanes, NotMyPlanes : byte );
{   Zeichnet die mit VonNr bis BisNr gekennzeichnete Objekte unter
    Beachtung der vorgegebenen Masken }
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
