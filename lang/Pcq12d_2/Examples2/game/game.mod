 

External;

{   Die hier folgenden Routinen sind alle für die Benutzung
    ind den Spielen gedacht.
    Nähere Informationen: siehe Dokumentation
}


{ --------------------------------------------------------------------- }
{ ---------    GraphCollision  ---------------------------------------- }
{ --------------------------------------------------------------------- }

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

Procedure Copyright();
VAR
    Copyright, Revnummer : String;
begin
    CopyRight := "7. Juni 1993 , Jörg Wach ";
    RevNummer := "Version V1.20";
end;

{ --------------------------------------------------------------------- }

Procedure GraphCollision( x1, y1, xsize, ysize : short);
{ Testet einen BitMapBereich auf vorhandene Punkte. xsize und ysize
  bestimmen das Ausmaß des zu testenden Bereiches. }
var
    dummy : integer;    { Rückgabewert von BltBitMap. Wird nicht benötigt }
begin
    ysize := ysize + 1;
    Forbid();   { Taskswitching aus, damit ist der Blitter mein }
    WaitBlit(); { Auf den Blitter warten, falls dieser noch arbeitet }
    dummy := BltBitMap(MyBitMap,x1,y1,MyBitMap,x1,y1,xsize,ysize,$c0,1,BlittiSpeicher);
    WaitBlit(); { Auf den Blitter warten, falls dieser noch arbeitet }
{$A
    btst.b  #5,$dff002          ; Diese Bit wollen wir testen
    beq.s   Collision1          ; Kollision
    move.w  #0,_blitctrl        ; keine Kollision
    bra.s   Collision2          ; 2. BitPlane abfragen
Collision1:
    move.w  #1,_blitctrl        ; Kollision. _blitctrl setzen
Collision2:
}
    if blitctrl = 0 then begin  { keine Kollision in der 1. Plane }
        dummy := BltBitMap(MyBitMap,x1,y1,MyBitMap,x1,y1,xsize,ysize,$c0,2,BlittiSpeicher);
        WaitBlit(); { Auf den Blitter warten, falls dieser noch arbeitet }
{$A
    btst.b  #5,$dff002          ; Diese Bit wollen wir testen
    beq.s   Collision3          ; Kollision
    move.w  #0,_blitctrl        ; keine Kollision
    bra.s   Collision4          ; 3. BitPlane abfragen
Collision3:
    move.w  #1,_blitctrl        ; Kollision
Collision4:
}
        if blitctrl = 0 then begin { Keine Kollision in der 2. Plane }
           dummy := BltBitMap(MyBitMap,x1,y1,MyBitMap,x1,y1,xsize,ysize,$c0,4,BlittiSpeicher);
           WaitBlit(); { Auf den Blitter warten, falls dieser noch arbeitet }
{$A
    btst.b  #5,$dff002          ; Diese Bit wollen wir testen
    beq.s   Collision5          ; Kollision
    move.w  #0,_blitctrl        ; keine Kollision
    bra.s   Collision6          ; Keine weitere BitPlane
Collision5:
    move.w  #1,_blitctrl        ; Kollision
Collision6:
                                ; Es gab keine Kollision
}
        end; { Abfrage 3. Plane }
    end; { Abfrage 2. Plane }
    Permit();   { Andere wollen auch mal arbeiten ! }
end;{GraphCollision}

{ --------------------------------------------------------------------- }
{ ---------    CollObjekt      ---------------------------------------- }
{ --------------------------------------------------------------------- }

Function CollObjekt(von, bis, x1, y1, sizex, sizey : short) : short;
{ Die Funktion ermittelt, welches Objekt in dem Rechteck x1, y1, x1+
  sizex und y1+sizey Kollidiert ist. Hierbei kann ein von / bis Bereich
  für die Objektuntersuchung angegeben werden (0 - 255 ).
  Wird als Von-Wert -1 angegeben, so werden alle Objekte untersucht und
  die erste Objektnummer, die zur Kollision führte, zurück gegeben.
  Ist der Rückgabewert -1, so gab es eine Kolision mit einem nicht
  definierten Objekt bzw. das Objekt wurde nicht gefunden.
}

begin

{$A
    movem.l d1-d7/a0-a3,-(sp)   ; alle benutzten Register sichern
                            ; Wahnsinn, 11 Stück !!!
                            ; Die Parameter liegen deshalb auch
                            ; an der um +44 Korrigierten SP-Adresse
    lea     _Objekt,a0      ; 1. Adresse der Elemente laden
    move.l  _Objektsize,a1  ; Größe der Objekte laden


    move.w  56(sp),d1       ; bis (Urspünglich: 12(sp))

    move.w  58(sp),d2       ; von (Urspünglich: 14(sp))

    cmp.w   d2,d1           ; Sind beide richtig angegeben?
    bge.s   CollObjekt0     ; alles i.O.
    exg.l   d2,d1           ; Nicht alles O.k., also tauschen.
CollObjekt0:
    tst.w   d2              ; erstmal die Flags setzen
    beq.s   CollObjekt2A    ; Sonderfall !!! Objekt ist 0
    bmi.s   CollObjekt2     ; Dann müssen alle Objekte bearbeitet werden
    cmp.w   d2,d1           ; Ist der von/bis-Bereich gleich ?
    beq.s   CollObjekt1B    ; Sonderfall !!! müßen wir gesondert bearbeiten
    sub.w   d2,d1           ; Anzahl der Objekte - 1 (für dbra)

CollObjekt1:
    movea.w d2,a3           ; sichern für den Rückgabezähler
    move.l  a1,d4           ; Wert erstmal rüberschieben
    mulu    d2,d4           ; und multiplizieren, Wert ist in d4
    adda.l  d4,a0           ; Basisadresse in a0
    bra.s   CollObjekt3     ; Steht jetzt in a0

CollObjekt1B:               ; Jetzt gehts ans Multiplizieren.
    move.w  #0,d1           ; 1 Objekt ist zu bearbeiten
    movea.w d2,a3           ; Die zu bearbeitende Objektnummer
    move.l  a1,d4           ; Wert erstmal rüberschieben
    mulu    d2,d4           ; und multiplizieren, Wert ist in d4
    adda.l  d4,a0           ; und zu Basisadresse hinzuaddieren
    bra.s   CollObjekt3     ; Steht jetzt in a0

CollObjekt2:
    move.w  #255,d1         ; 256 Objekte sind zu bearbeiten
    move.w  #0,a3           ; 1. zu bearbeitende Objektnummer
    bra.s   CollObjekt3     ; weiter gehts

CollObjekt2A:
    move.w  #0,d1           ; 1 Objekt ist zu bearbeiten
    move.w  #0,a3           ; 1. zu bearbeitende Objektnummer

CollObjekt3:
                            ; a0 = Startadresse des 1. Objektes
                            ; a1 = Größe des Objektes
                            ; a3 = Nummer des ersten Objektes
                            ; d1 = Anzahl der Objekte -1

    move.w  48(sp),d4       ; sizey (Urspünglich: 4(sp))

    move.w  50(sp),d5       ; sizex (Urspünglich: 6(sp))

    move.w  52(sp),d6       ; y1 (Urspünglich: 8(sp))

    move.w  54(sp),d7       ; x1 (Urspünglich: 10(sp))

    add.w   d6,d4           ; addiert sizey + y1 um den unteren Eckpunkt
                            ; zu bekommen.

    add.w   d7,d5           ; addiert sizex + x1 um den unteren Eckpunkt
                            ; zu bekommen.

CollObjektLoop:
                            ; Ab hier beginnt die Fragerei immer wieder
    move.w  (a0),d2         ; Ox1-Position in D2
    bmi     CollObjektNext  ; zur Beschleunigung der Abfrage, da Objekt
                            ; tot ist.
    move.w  2(a0),d3        ; Oy1-Position in D3


    cmp.w   d7,d2           ; Ox1 >= Tx1
    bge.s   CollObjekt4     ; Ja
    bra.s   CollObjekt10    ; nein
CollObjekt4:
    cmp.w   d5,d2           ; Ox1 <= Tx2
    bls.s   CollObjekt100   ; Ja
                            ; nein, weiter bei Stufe 10
CollObjekt10:
    add.w   4(a0),d2        ; Ox1 um den x-size Wert erhöhen, um Ox2 zu bekommen
    cmp.w   d7,d2           ; Ox2 >= Tx1
    bge.s   CollObjekt11    ; Ja
    bra.s   CollObjekt20    ; nein

CollObjekt11:
    cmp.w   d5,d2           ; Ox2 <= Tx2
    bls.s   CollObjekt100   ; Ja
                            ; nein, weiter bei Stufe 20
CollObjekt20:
    move.w  (a0),d2         ; Ox1 wieder auf den alten Wert bringen
    cmp.w   d2,d7           ; Tx1 >= Ox1
    bge.s   CollObjekt21    ; Ja
    bra.s   CollObjekt30    ; nein

CollObjekt21:
    add.w   4(a0),d2        ; Ox1 um den x-size Wert erhöhen, um Ox2 zu bekommen
    cmp.w   d2,d7           ; Tx1 <= Ox2
    bls.s   CollObjekt100   ; Ja
                            ; nein, weiter bei Stufe 30
CollObjekt30:
    move.w  (a0),d2         ; Ox1 wieder auf den alten Wert bringen
    cmp.w   d2,d5           ; Tx2 >= Ox1
    bge.s   CollObjekt31    ; Ja
    bra.s   CollObjektNext  ; nein, also kein Treffer

CollObjekt31:
    add.w   4(a0),d2        ; Ox1 um den x-size Wert erhöhen, um Ox2 zu bekommen
    cmp.w   d2,d5           ; Tx1 <= Ox2
    bls.s   CollObjekt100   ; Ja
    bra.s   CollObjektNext  ; nein, also kein Treffer

CollObjekt100:
    cmp.w   d6,d3           ; Oy1 >= Ty1
    bge.s   CollObjekt101   ; Ja
    bra.s   CollObjekt110   ; nein
CollObjekt101:
    cmp.w   d4,d3           ; Oy1 <= Ty2
    bls.s   CollObjekt200   ; Ja
                            ; nein, weiter bei Stufe 110
CollObjekt110:
    add.w   6(a0),d3        ; Oy1 um den y-size Wert erhöhen, um Oy2 zu bekommen
    cmp.w   d6,d3           ; Oy2 >= Ty1
    bge.s   CollObjekt111   ; Ja
    bra.s   CollObjekt120   ; nein

CollObjekt111:
    cmp.w   d4,d3           ; Oy2 <= Ty2
    bls.s   CollObjekt200   ; Ja
                            ; nein, weiter bei Stufe 120
CollObjekt120:
    move.w  2(a0),d3        ; Oy1 wieder auf den alten Wert bringen
    cmp.w   d3,d6           ; Ty1 >= Oy1
    bge.s   CollObjekt121   ; Ja
    bra.s   CollObjekt130   ; nein

CollObjekt121:
    add.w   6(a0),d3        ; Oy1 um den y-size Wert erhöhen, um Oy2 zu bekommen
    cmp.w   d3,d6           ; Ty1 <= Oy2
    bls.s   CollObjekt200   ; Ja
                            ; nein, weiter bei Stufe 130
CollObjekt130:
    move.w  2(a0),d3        ; Oy1 wieder auf den alten Wert bringen
    cmp.w   d3,d4           ; Ty2 >= Oy1
    bge.s   CollObjekt131   ; Ja
    bra.s   CollObjektNext  ; nein, also kein Treffer

CollObjekt131:
    add.w   6(a0),d3        ; Oy1 um den y-size Wert erhöhen, um Oy2 zu bekommen
    cmp.w   d3,d4           ; Tx1 <= Ox2
    bls.s   CollObjekt200   ; Ja
    bra.s   CollObjektNext  ; nein, also kein Treffer

CollObjekt200:
                            ; Alle Bedingungen sind erfüllt worden,
                            ; also ein Treffer
    move.w  a3,d0           ; die getroffene Objektnummer in d0
    bra.s   CollObjektEnd   ; und ab dafür

CollObjektNext:
                            ; Eine oder mehrere Bedingungen wurden nicht
                            ; erfüllt. Also das nächste Objekt.
    adda.l  a1,a0           ; Nächste Objektadresse
    adda.w  #1,a3           ; Objektnummer um eins erhöhen
    dbra.s  d1,CollObjektLoop   ; und weiter geht's

    moveq   #-1,d0          ; wir haben kein passendes Objekt gefunden,
                            ; also Fehler

CollObjektEnd:

    movem.l (sp)+,d1-d7/a0-a3   ; alle benutzten Register wieder zurück
}
end;

Procedure UnDrawObjekt( VonNr, BisNr : short );
{   Löscht die mit VonNr bis BisNr gekennzeichnete Objekte. }
var
    tt1, tt2 : short;
begin

    repeat
        if Objekt[VonNr].Ox <> -1 then begin
           { * Zuerst wollen wir mal den zweiten Eckpunkt ermitteln. * }
           tt1 := Objekt[VonNr].Ox + Objekt[VonNr].Sizex;
           tt2 := Objekt[VonNr].Oy + Objekt[VonNr].Sizey;

           { * Und ...Wusch... is es wech. * }
           SetAPen(MyRPort,0);
           SetBPen(MyRPort,0);
           RectFill(MyRPort, Objekt[VonNr].Ox, Objekt[VonNr].Oy, tt1, tt2);
        end;
        { * Zähler erniedrigen. * }
        INC(VonNr);
    until VonNr > BisNr;
end; { UnDrawObjekt }

{ --------------------------------------------------------------------- }
{ ---------    GetChar                     ---------------------------- }
{ --------------------------------------------------------------------- }

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
begin
{$A
    move.b  $bfec01,d0  ; Tastaturcode in D0
}
end; {GetChar}

{ --------------------------------------------------------------------- }
{ ---------    GetJoy2                     ---------------------------- }
{ --------------------------------------------------------------------- }

Function GetJoy2(): byte;
{ Gibt folgende Werte zurück:
    0 - Joystick wurde nicht berührt
    1 - Joystick nach rechts
    2 - Joystick nach links
    4 - Joystick nach hinten
    8 - Joystick nach vorne
   16 - Feuertaste gedrückt
}
begin
{$A
    movem.l d1-d2,-(sp)     ; Register sichern
    moveq   #0,d0           ; sauber machen
    moveq   #0,d1           ; sauber machen
    move.w  $DFF00C,d1      ; JOY1DAT holen
    btst.l  #1,d1           ; rechts ?
    beq.s   GetJoy201       ; nein
    bset.l  #0,d0           ; D0 setzen
GetJoy201:
    btst.l  #9,d1           ; links ?
    beq.s   GetJoy202       ; nein
    bset.l  #1,d0           ; D0 setzen
GetJoy202:
    move.w  d1,d2
    lsr.w   #1,d2
    eor.w   d1,d2
    btst    #0,d2           ; hinten ?
    beq.s   GetJoy203       ; nein
    bset.l  #2,d0           ; D0 setzen
GetJoy203:
    btst    #8,d2           ; vorne ?
    beq.s   GetJoy204       ; nein
    bset.l  #3,d0           ; D0 setzen
GetJoy204:
    move.b  $BFE001,d1      ; CIA-A, Paralellport a
    btst.l  #7,d1           ; Feuer ?
    bne.s   GetJoy205       ; nein
    bset.l  #4,d0           ; D0 setzen
GetJoy205:
    movem.l (sp)+,d1-d2     ; Register zurück

}
end; { GetJoy2 }


{ --------------------------------------------------------------------- }
{ --------- ChipCopy                       ---------------------------- }
{ --------------------------------------------------------------------- }

Function ChipCopy( Source : Address; Size : integer) : Address;
{ Allokiert ChipMem in der Größe Size und kopiert die Daten von
  der Addresse Source dort hinein. Zurückgegeben wird die ChipMem
  Adresse.
}

begin
{$A
        XREF    _GfxBase
        XREF    _LVOAllocRaster

        movem.l d1-d7/a0-a6,-(sp)   ; register sichern

        moveq   #8,d0           ; 1 Byte mal
        move.l  60(sp),d1       ; Size; ursprünglich: 4(sp)
        move.l  _GfxBase,a6
        jsr     _LVOAllocRaster(a6) ; anfordern
                                    ; d0 enthält jetzt die Adresse

        tst.l   d0              ; d0 testen
        bne.s   ChipCopy1       ; ist nicht Null, also alles O.K.
        moveq   #-1,d0          ; Returncode ist negativ
        movem.l (sp)+,d1-d7/a0-a6   ; Register wieder zurück
        rts                     ; und vorzeitiger Abbruch

ChipCopy1:
        move.l  60(sp),d1       ; Size, ursprünglich: 4(sp), in d1
        subq    #1,d1           ; um eins korrigieren
        move.l  64(sp),a0       ; Source, ursprünglich: 8(sp), in a0
        move.l  d0,a1           ; Destination in a1

Chipcopyloop:
        move.b  (a0)+,(a1)+     ; kopieren und um eins erhöhen
        dbra.s  d1,Chipcopyloop ; wenn noch nicht zuende, dann weitermachen

        movem.l (sp)+,d1-d7/a0-a6   ; Register wieder zurück
                                    ; D0 enthält jetzt die ChipMemAdresse
}

end;{ ChipCopy }

{ --------------------------------------------------------------------- }
{ --------- IntToStr6                      ---------------------------- }
{ --------------------------------------------------------------------- }

Procedure IntToStr6(s : string; i : integer);
{ Konvertiert positive Zahlen in das Stringformat mit führenden
    Nullen. Max. 6 Nullen und max. die Zahl 999999 }
begin
{$A
        movem.l d1-d2/a0,-(sp)  ; register retten

        move.l  16(sp),d0       ; d0 enthält i
        move.l  20(sp),a0       ; a0 enthält den stringpointer s
                                ; jetzt komt die Abzugstabelle
        move.l  #100000,d2
        bsr.s   1$
        move.l  #10000,d2
        bsr.s   1$
        move.l  #1000,d2
        bsr.s   1$
        move.l  #100,d2
        bsr.s   1$
        move.l  #10,d2
        bsr.s   1$
        move.l  #1,d2
        bsr.s   1$
        move.b  #0,(a0)         ; noch das Ende kennzeichnen
        movem.l (sp)+,d1-d2/a0  ; Register wieder zurückholen
        rts
1$
        moveq   #'0',d1         ; d1 mit 0 vorbelegen
2$
        sub.l   d2,d0           ; d2 von d0 abziehen
        bmi.s   4$              ; Minus? dann nach 4$
        addq    #1,d1           ; d1 ums eins erhöhen und
        bra.s   2$              ; nach 2$ zurück
3$
        move.b  d1,(a0)+        ; Zahl ablegen
        rts
4$
        add.l   d2,d0           ; d0 wieder korrigieren
        bra.s   3$              ; und zurück nach 3$
}
end; {IntToStr6}

Procedure PowerLEDOn();
{ Macht die PowerLED an }
begin
{$A
    andi.b  #253,$bfe001
}
end;

Procedure PowerLEDOff();
{ Macht die PowerLED aus }
begin
{$A
    ori.b  #2,$bfe001
}
end;

{ --------------------------------------------------------------------- }
{ ---------   DrawObjekt                   ---------------------------- }
{ --------------------------------------------------------------------- }

Procedure DrawObjekt( VonNr, BisNr : short );
{   Zeichnet die mit VonNr bis BisNr gekennzeichnete Objekte. }

begin
    Forbid();   { * Multitasking aus * }
{$A

    movem.l d0-d7/a0-a6,-(sp)   ; alle benutzten Register sichern
                                ; Als erstes löschen wir den BlittiSpeicher

                            ; Und jetzt suchen wir die Objektadresse
    lea.l   _Objekt,a0      ; 1. Adresse der Elemente laden
    move.l  _Objektsize,a1  ; Größe der Objekte laden
    lea.l   _Picture,a2     ; Startadresse Picturedaten

    move.w  64(sp),d1       ; bis (Urspünglich: 4(sp))

    move.w  66(sp),d2       ; von (Urspünglich: 6(sp))

    cmp.w   d2,d1           ; Sind beide richtig angegeben?
    bge.s   DrawObjekt1     ; alles i.O.
    exg.l   d2,d1           ; Nicht alles O.k., also tauschen.

DrawObjekt1:                ; Jetzt die Adresse ermitteln
    move.l  a1,d3           ; Größe erstmal rüberschieben
    mulu.w  d2,d3           ; und mit "von" multiplizieren, Wert in d3
    adda.l  d3,a0           ; und mit der Basisadresse in a0 addieren
                            ; jetzt haben wir die Startadresse

DrawObjekt2:                ; x und y-Werte holen und umrechnen
    moveq   #0,d3           ; erstmal sauber machen
    moveq   #0,d4           ; erstmal sauber machen
    move.w  (a0),d3         ; x-Position in d3
    bmi     DrawObjektNext  ; Objekt tot? Dann das nächste
    move.w  2(a0),d4        ; y-Position in d4

                            ; ******************************************
DrawObjekt30:               ; zuerst müssen wir die Bilderdaten anpassen,
                            ; da durch das verschieben der Bilderdaten
                            ; unerwünschte Effekte auftreten können.
                            ; ******************************************

    lea     _BlittiSpeicher,a3
    move.l  (a3),a4         ; Adresse holen

DrawObjekt31:               ; Wir warten auf den Blitter
    btst    #6,$dff002      ; wie siehts aus?
    bne.s   DrawObjekt31    ; is noch nich fertich
    move.w  #$0100,$dff040  ; BLTCON0 wird auf Null gesetzt + Ziel D
    clr.w   $dff042         ; BLTCON1 auf 0
    clr.w   $dff066         ; BLTDMOD auf 0 (kein Modulo)
    move.l  #$ffffffff,$dff044 ; Keine Maskierung
    move.l  a4,$dff054      ; Zieladresse nach BLTDP
    move.w  #%0001100100001010,$dff058  ; Blitter startet (100 * 20)

DrawObjekt32:               ; Jetzt holen wir uns die entsprechenden
                            ; Image-Daten
    moveq   #0,d5           ; erstmal sauber machen
    move.w  16(a0),d5       ; Typ-holen
    subq    #1,d5           ; Und korigieren
    lsl.w   #2,d5           ; Offset errechnen ( mal 4 )
    move.l  d5,a5           ; sichern
    adda.l   a2,a5          ; und mit Startadresse Picturedaten addieren
    move.l  (a5),a3         ; Jetzt Adresse-Imagedaten holen
    moveq   #0,d5           ; sauber machen
    moveq   #0,d6           ; sauber machen
    moveq   #0,d7           ; sauber machen
    move.w  4(a0),d5        ; Breite holen  *CHANGE*
    move.w  6(a0),d6        ; Höhe holen    *CHANGE*
    move.w  8(a3),d7        ; BitPlanes holen

                            ; Jetzt müssen wir die Bilddaten erstmal
                            ; modifizieren, da der Blitter durch das
                            ; verschieben die Bilder falsch rausbringt.
                            ; Deshalb muß jeder Bild-Plane ein Word an
                            ; gehängt werden.

DrawObjekt34:                ; Jetzt wollen wir die Anzahl der zu
                            ; kopierenden Bytes errechen
    add.w   #15,d5          ; Plus 15
    lsr.w   #4,d5           ; durch 16 teilen = Anzahl Words Breite
    move.w  d6,d0           ; Höhe Zwischenspeichern
    mulu.w  d7,d0           ; mal Anzahl der Bitplanes
    lsl.w   #6,d0           ; verschieben
    add.w   d5,d0           ; addiert mit der breite in Words =
                            ; Blitterwert der zu kopierenden Bytes. Uff!!

DrawObjekt35:               ; Wir warten auf den Blitter
    btst    #6,$dff002      ; wie siehts aus?
    bne.s   DrawObjekt35    ; is noch nich fertich
    move.l  10(a3),$dff050  ; Startadresse für A
    move.l  a4,$dff054      ; Zieladresse für D
    move.w  #2,$dff066      ; BLTDMOD = 2 wg. anhängen
    clr.w   $dff064         ; BLTAMOD = 0
    move.w  #%0000100111110000,$dff040   ; Minterms und A + D anschalten
    clr.w   $dff042         ; BLTCON1 auf 0
    move.w  d0,$dff058      ; Blitter startet. Unsere Bilderdaten stehen
                            ; jetzt also im BlittiSpeicher
                            ; Jetzt müssen wir noch die urspünglichen
                            ; Daten korrigieren. d6 (höhe) und d7(Bit-
                            ; planes) bleiben.
                            ; Die neuen Bilddaten stehen jetzt in der
                            ; Adresse Register a4
    addq    #1,d5           ; Breite um ein Word erhöhen

DrawObjekt4:                ; Jetzt die Byteposition ausrechnen
    mulu.w  #80,d4          ; y * 80 Byte für 640*200 Schirm
    move.w  d3,d0           ; Wert sichern
    lsr.w   #3,d3           ; durch 8 = Anzahl Words
    add.w   d4,d3           ; Bytepostion auf Wordgrenze gerechnet
    andi.w  #$000f,d0       ; Ausmaskieren

                            ; Wert für BLTCON0 vorbereiten

    ror.w   #4,d0           ; Smoothwert schieben
    add.w   #%0000110111111100,d0   ; Minterms und A,B + D anschalten

DrawObjekt41:               ; Wir warten auf den Blitter
    btst    #6,$dff002      ; wie siehts aus?
    bne.s   DrawObjekt41    ; is noch nich fertich
    move.w  d0,$dff040      ; in BLTCON0
    clr.w   $dff042         ; BLTCON1 löschen

DrawObjekt5:                ; Jetzt wollen wir die Anzahl der zu
                            ; kopierenden Bytes errechen
    move.w  d6,d0           ; Höhe Zwischenspeichern
    lsl.w   #6,d0           ; verschieben
    add.w   d5,d0           ; addiert mit der breite in Words =
                            ; Blitterwert der zu kopierenden Bytes. Uff!!

DrawObjekt51:               ; Jetzt die Modulowerte errechnen
    lsl.w   #1,d5           ; auf Bytes bringen
    moveq   #80,d4          ; Bytes Zielwert
    sub.w   d5,d4           ; und Breite Bilder abziehen = Modulo-Wert
    clr.w   $dff064         ; A hat keinen Modulo-Wert
    move.w  d4,$dff066      ; Aber Ziel D
    move.w  d4,$dff062      ; und Quelle B

                            ; Errechnen der Offset Bilddaten
    mulu.w  d5,d6           ; Höhe in Bytes mal Breite in Bytes


                            ; Die Register enthalten jetzt folgende
                            ; Werte: - a0 : Startadresse Objektdaten
                            ;        - a1 : Größe eines Objekteintrages
                            ;        - a2 : Startadresse Picturedaten
                            ;        - a4 : Startadresse Bilderdaten
                            ;        - d0 : Anzahl der Blitter-Bytes
                            ;        - d1 : BisNr.
                            ;        - d2 : VonNr.
                            ;        - d3 : Offset Bildschirmadresse
                            ;        - d6 : Offset Bilderdaten
                            ;        - d7 : Anzahl Bild-Bitplanes

DrawObjekt6:                ; BitPlanedaten festhalten
    lea.l   _MyBitMap,a3    ; Basisadresse laden
    move.l  (a3),a6         ; Jetzt die richtige Adresse holen
    move.l  a6,a3           ; wieder zurück
    move.l  8(a3),a5        ; Adresse erste BitPlane
    adda.l  d3,a5           ; und mit Offset addieren
    move.l  a5,$dff054      ; Adresse Ziel
    move.l  a5,$dff04c      ; Adresse Quelle B
    move.l  a4,$dff050      ; Adresse Quelle A
    move.w  d0,$dff058      ; und Blitter starten

DrawObjekt7:                ; Wir warten auf den Blitter
    btst    #6,$dff002      ; wie siehts aus?
    bne.s   DrawObjekt7
    subq    #1,d7           ; eine weniger
    beq.s   DrawObjektNext  ; wenn keine mehr da ist, ab dafür
    adda.l  d6,a4           ; Offset dazu
    move.l  12(a3),a5       ; Adresse zweite BitPlane
    adda.l  d3,a5           ; und mit Offset addieren
    move.l  a5,$dff054      ; Adresse Ziel
    move.l  a5,$dff04c      ; Adresse Quelle B
    move.l  a4,$dff050      ; Adresse Quelle A
    move.w  d0,$dff058      ; und Blitter starten

DrawObjekt8:                ; Wir warten auf den Blitter
    btst    #6,$dff002      ; wie siehts aus?
    bne.s   DrawObjekt8
    subq    #1,d7           ; eine weniger
    beq.s   DrawObjektNext  ; wenn keine mehr da ist, ab dafür
    adda.l  d6,a4           ; Offset dazu
    move.l  16(a3),a5       ; Adresse dritte BitPlane
    adda.l  d3,a5           ; und mit Offset addieren
    move.l  a5,$dff054      ; Adresse Ziel
    move.l  a5,$dff04c      ; Adresse Quelle B
    move.l  a4,$dff050      ; Adresse Quelle A
    move.w  d0,$dff058      ; und Blitter starten
                            ; das wars
DrawObjektNext:
    addq    #1,d2           ; von nummer um eins erhöhen
    cmp.w   d2,d1           ; größer als bis nummer?
    bmi.s   DrawObjektEnd   ; nö, also ende
    add.l   a1,a0           ; neue Adresse
    bra     DrawObjekt2     ; Also machen wirs nochmal

DrawObjektEnd:
    movem.l (sp)+,d0-d7/a0-a6 ; alle benutzten Register zurück
}
    Permit();
end; { DrawObjekt }

{ --------------------------------------------------------------------- }
{ ---------   VB-Server                    ---------------------------- }
{ --------------------------------------------------------------------- }

{ * Hier kommt der Assemblercode für den Zähler. * }
Procedure Initvb0();
begin
{$A
initvb0:
        ADDI.L  #1,(A1)          ;* increments counter is_Data points to
        MOVEQ.L #0,D0            ;* set Z flag to continue to process other vb-servers
        RTS                      ;* return to exec
}
end; { * Initvb0 * }

Procedure InitVB();
{ * Initialisiert den VB-Server. * }
begin
    vbcounter := 0;
    vbint := AllocMem(SIZEOF(Interrupt), MEMF_PUBLIC+MEMF_CLEAR);   { *  interrupt node. * }

    vbint^.is_node.ln_type := NTINTERRUPT;         { * Initialize the node. * }
    vbint^.is_node.ln_succ := Nil;
    vbint^.is_node.ln_pred := Nil;
    vbint^.is_node.ln_pri  := -60;
    vbint^.is_node.ln_name := "VB-Server";
    vbint^.is_data := ADR(VBCounter);
    vbint^.is_code := ADR(Initvb0);
    AddIntServer(INTB_VERTB, vbint); { * Kick this interrupt server to life. * }
end; { * InitVB * }

Procedure Exitvb();
{ * Gibt den VB-Server wieder frei. * }

BEGIN
     RemIntServer(INTB_VERTB, vbint);
     FreeMem(vbint, SIZEOF(Interrupt));
end; { ExitVB }

Procedure Settime();
{ * Setzt den VB-Server-Wert uf 0. * }

BEGIN
     vbcounter := 0;
end; { ExitVb }

Function Gettime(): integer;
{ * Liefert den Wert des VBServer zurück. * }
BEGIN
    Gettime := vbcounter;
end; { * Gettime * }

Procedure WaitVB(ticks : short);
{ * Wartet ticks Ticks vom VB. * }
VAR

    tt  : integer;
    tt1 : integer;
BEGIN
    If ticks = 0 Then Return;
    tt1 := ticks + Gettime();
    Repeat
        tt := Gettime();
    Until tt >= tt1;
end; { * WaitVB. * }

{ --------------------------------------------------------------------- }
{ ---------   Playsample                   ---------------------------- }
{ --------------------------------------------------------------------- }
{
        Playsample sind verschiedene Routinen für das Laden,
        abspielen und wieder freigeben von 8-SVX-Sounds.

        Modifiziert und erstellt anhand des zum PCQ1.2b beigelegten
        Beispieles 'Play8SVX'.

        Nähere Informatinen siehe Dokumentation.
}


Function D1Unpack(source : String; n : Integer; dest : String; x : Byte) : Byte;
var
    d : Byte;
    i, lim : Integer;
begin
    lim := n shl 1;
    for i := 0 to lim - 1 do begin
        d := Ord(Source[i shr 1]);
        if Odd(i) then
            d := d and 15
        else
            d := d shr 4;
        x := x + codeToDelta[d];
        dest[i] := Chr(x);
    end;
    D1Unpack := x;
end;

Procedure DUnpack(source : String; n : Integer; dest : Address);
var
    x : Byte;
begin
    x := D1Unpack(Adr(source[1]), n - 2, dest, Ord(source[0]));
end;

Procedure FreeSample(Nummer: byte);
{ * Gibt das Sample mit der Nummer nummer aus der Sampletab wieder
    frei inkl. aller belegter Speicherbereiche. * }
begin
    if Sampletab[nummer].dbuf <> Nil then
        FreeMem(Sampletab[nummer].dbuf, Sampletab[nummer].dlen);
    Sampletab[nummer].dbuf := Nil;
end;

Procedure DoRead(Buffer : Address; Length : Integer);
var
    ReadResult : Integer;
begin
    ReadResult := DOSRead(FP, Buffer, Length);
    If ReadResult <> Length then begin
       Writeln("Abbruch DoRead.");
       Exit(10);
    end;
end;

{***********************************************************************+}

Procedure PlaySample(nummer : short);
{ * Spielt den in der Sampletab abgelegten Sound ab. * }
begin
{$A
    movem.l d0-d3/a0-a3,-(sp)   ; alle benutzten Register sichern.
                            ; Die Parameter liegen deshalb auch
                            ; an der um +32 Korrigierten SP-Adresse
    moveq   #0,d0
    moveq   #1,d3           ; für den DMA Wert

    move.w  36(sp),d0       ; nummer des Samples holen
    subq.w  #1,d0           ; und korrigieren
    lea     _Sampletab,a0   ; Adresse der Tabelle laden
    move.l  _Sampletabsize,d1   ; Länge der Tabelle laden
    mulu.w  d1,d0           ; und Multiplizieren
    add.l   d0,a0           ; jetzt haben wir den Tabplatz

    lea     $dff0A0,a1      ; Beginn der Audio-Hardware holen
    lea     $dff000,a2      ; Beginn der Hardware holen

    moveq   #0,d1
    move.b  _Channel,d1     ; enthält den neu zu spielenden Kanal
    cmp.b   #4,d1           ; Schon mehr als den 4. Kanal?
    bne.s   Playsample1     ; Nein
    moveq   #0,d1           ; Ja, also korrigieren

Playsample1:
    lsl.w   d1,d3           ; DMA-Kanal ermitteln
    moveq   #$10,d2
    mulu.w  d1,d2           ; Wert errechnen
    add.l   d2,a1           ; Beginn des entsprechenden Kanals
    move.l  a1,d2           ; und sichern

    move.l  (a0)+,(a1)+     ; Samplebeginn übertragen
    move.l  (a0)+,d0        ; Samplelänge  holen
    lsr.l   #1,d0           ; und auf Word bringen
    move.w  d0,(a1)+        ; Samplelänge  übertragen
    move.w  (a0),(a1)+      ; Frequenz übertragen
    move.w  #63,(a1)        ; Lautstärke auf max.

    move.w  d3,$96(a2)      ; DMA STOP
    or.w    #$8000,d3       ; d3 auf DMA-an setzen
    move.w  d3,$96(a2)      ; DMA Start

    addq.b  #1,d1           ; neuen Kanal errechnen.
    move.b  d1,_Channel     ; und ablegen.
    move.l  #1000,d1        ; Ein paar Buszyklen warten
playsampleloop:
    dbra.s  d1,playsampleloop

    move.l  d2,a1           ; aus der Sicherung zurückholen
    moveq   #0,d2           ; und löschen
    move.l  d2,(a1)+        ; Samplebeginn löschen
    addq    #1,d2
    move.w  d2,(a1)         ; Samplelänge löschen. Das wars.

    movem.l (sp)+,d0-d3/a0-a3   ; alle benutzten Register zurückholen.
    rts
}
end;    { * Playsample * }


{***********************************************************************+}

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
VAR
    ckbuffer    : Array [0..2] of Short;
    t           : Address;
    oerr        : integer;
    ckname      : String;
Begin
    If Sampletab[Nummer].dbuf <> Nil then LoadSample := -3;

    ckname := Adr(ckbuffer);
    ckname[4] := '\0';

    if strlen(Name) = 0 then LoadSample := -2;
    FP := DOSOpen(Name, MODE_OLDFILE);
    if FP = Nil then LoadSample := -1;
    DoRead(ckname, 4);
    if streq(ckname, "FORM") then begin
        DoRead(ckname,4);       { Get size out of the way. }
        DoRead(ckname,4);
        if streq(ckname,"8SVX") then begin
           DoRead(ckname,4);
           while not streq(ckname,"BODY") do begin
                 DoRead(Adr(Sampletab[nummer].dlen), 4);
                 if streq(ckname,"VHDR") then
                    DoRead(Adr(VHeader), SizeOf(Voice8Header));
                 DoRead(ckname,4);
           end;
           DoRead(Adr(Sampletab[nummer].dlen), 4);
        end else
            LoadSample := -4;
    end else
        LoadSample := -4;

    Sampletab[nummer].dbuf := AllocMem(Sampletab[nummer].dlen, MEMF_PUBLIC + MEMF_CHIP);
    if Sampletab[nummer].dbuf = Nil then LoadSample := -7;

    if Sampletab[nummer].dlen > 131000 then begin  { Supposed hardware limitation. }
        Sampletab[nummer].dlen := 131000;
    end else if Odd(Sampletab[nummer].dlen) then
        Sampletab[nummer].dlen := Pred(Sampletab[nummer].dlen);
    DoRead(Sampletab[nummer].dbuf, Sampletab[nummer].dlen);          { * Sample einlesen. * }

    if VHeader.sCompression = 1 then begin
        t := AllocMem(Sampletab[nummer].dlen shl 1, MEMF_CHIP + MEMF_PUBLIC);
        if t = Nil then LoadSample  := -9;
        DUnpack(Sampletab[nummer].dbuf, Sampletab[nummer].dlen, t);
        FreeMem(Sampletab[nummer].dbuf, Sampletab[nummer].dlen);
        Sampletab[nummer].dbuf := t;
        Sampletab[nummer].dlen := Sampletab[nummer].dlen shl 1;
    end else if VHeader.sCompression > 1 then LoadSample := -10;

    Sampletab[nummer].dhz := 3579546 div VHeader.samplesPerSec; { * Tonhöhe. * }
    DOSClose(FP);
    LoadSample := nummer;
end; { * LoadSample * }
