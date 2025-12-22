/* 
 *  Testing some Graphics-Rendering-Functions
 * -=========================================-
 *  __      __                   __
 *  \ \    / /___ __    __ ___  / /
 *   \ \  / // _ \\ \  / // __\/ /   - ENGINE
 *    \ \/ // /_\ \\ \/ // _/ / /__    Projekt
 *     \__/ \_____//_/\_\\__/ \___/
 * 
 * 
 * © 1998 THE DARK FRONTIER Softwareentwicklungen
 *
 * Begonnen             : Donerstag     16 Juli 1998
 * Letzte Änderung      : Freitag       17 Juli 1998
 *
 * Geplant:
 * --------
 *      - Einbeziehen des Kamera-Winkels in die Darstellung
 *      - Optimierungen (evtl. in Assembler) aber erst wenn alles Stabil läuft
 *      - Antialiasing (vertikal und Horizontal)
 *      - Tiefenunschärfe (z.B. Nebel, Helligkeitsänderung...)
 *
 * Verwirklicht:
 * -------------
 *      - MAP-Funktionen (zur erzeugung, Änderung ect... einer MAP)
 *      - Voxel-Funktionen (Zeichnen...)
 *      - Betrachter-Funktionen (Standpunkt...)
 *      - Perspektive-Korrektur (Pixel werden nach Hinten kleiner)
 *      - MAP-Modulo (wenn ein Wert auserhalb der MAP liegt wird er neu berechnet und in die MAP gelegt)
 *      - Beliebig große MAPS verwaltbar und darstellbar (vom Speicher abhängig)
 *      - 100 % System-Konform programmiert (dadurch aber ein wenig langsam...)
 *      - ...
 */

OPT     MODULE
OPT     EXPORT

MODULE  'graphics/rastport'
MODULE  'intuition/intuition'
MODULE  'intuition/screens'
MODULE  'utility/tagitem'
->MODULE  '*voxel_draw'                                   -> Assembler-Zeichen-Routine

/* 
 *  In einer Display-Struktur (Objekt) werden alle wichtigen Parameter, Variablen ect... gespeichert
 *   die für die Darstellung einer MAP auf einem Bildschirm (Screen) IN EINEM FENSTER (Window)
 *   nötig sind!
 * 
 * WICHTIG ist, daß man die Auflösung (resolution) an die Maße >width< und >height< und an die Breite und
 *  Länge der MAP anpassen muß!!!!! (sonst kanns sein, daß auf einem Großen Screen mit großem Window
 *  die gesamte MAP sichtbar ist, wird >resolution< allerdings zu groß gewählt ist die Darstellung
 *  der MAP zu Grob-Pixelig!!!)
 */

OBJECT  voxel_display                                   -> Daten für eine Bildschirmdarstellung einer MAP
 screen         :PTR TO screen                          -> eigener Bildschirm (muß vorher geöffnet werden) oder NIL (=Workbench)
 window         :PTR TO window                          -> Window das für die Darstellung benutzt wird
 rport          :LONG                                   -> Rastport in den gezeichnet werden soll!
 width          :INT                                    -> Breite die zur Darstellung benutzt werden soll (ist meistens gleich groß wie die Breite des Fensters)
 height         :INT                                    -> Höhe die zur Darstellung benutzt werden soll (meistens ca 50% der Window-Höhe, rest = Hintergrundbild, Wolken...)
 resolution     :INT                                    -> "Auflösung" (Größe eines Voxel-Punktes in Pixeln), 1 = beste Auflösung...
 backfill       :LONG                                   -> PTR auf eine Prozedur die das Füllen des Hintergrunds übernimmt (z.B. Hintergrundbild!)
 tickproc       :LONG                                   -> PTR auf eine Prozedur die bei jedem IntuiTick aufgerufen wird (z.B. nächstes Bild einer Animation des Hintergrundbildes vorbereiten (PTR))
ENDOBJECT

CONST   DISPLAY_IDCMP           =                       -> IDCMP-Flags des VOXEL-Windows
        IDCMP_RAWKEY            OR                      -> Cursor-Tasten ect...
        IDCMP_VANILLAKEY        OR                      -> Sonstige Tasten
        IDCMP_MOUSEBUTTONS      OR                      -> Mausbuttons
        IDCMP_MOUSEMOVE         OR                      -> Mausbewegungen
        IDCMP_INTUITICKS                                -> Intuiticks (1/25 sekunde) z.B. für Bewegungen im Hintergrundbild (z.B. Wolken im Himmel...)

/* 
 *  Zur VOXEL-Darstellung wird eine MAP benötigt, diese besteht aus einem 2D-Array,
 *   dessen Größe sich folgendermaßen zusammensetzt:
 * 
 *      BREITE * LÄNGE * (SIZEOF voxelpoint)
 * 
 *  BREITE = Breite der MAP (in Punkten)
 *  LÄNGE  = Länge des MAP (in Punkten)
 *
 */

/* Schematischer MAP-Aufbau: (Nur zur veranschaulichung!)
   -------------------------

OBJECT  voxel_map
 length         :LONG
 width          :LONG
   [BREITE*HÖHE]:ARRAY OF voxel_point
ENDOBJECT

*/

/*
 *  Die MAP besteht aus vielen Punkten (voxel_point), ein punkt hat als Daten
 *   nur seine Höhe und eine Farbe (Zahl eines Stiftes...)
 * 
 *  height = Höhe des Voxels in Pixeln (!), es ist zu beachten, daß es eine Mindest
 *           höhe gibt, diese ist abhängig von der Auflösung (>resolution<) in >voxel_display< 
 *           und muß mindestens 2 * resolution sein,da es sonst zu Lücken zwischen den einzelnen
 *           Voxeln in den Zeilen kommen kann!!
 *  color  = Nummer des Stiftes der zum Zeichnen des Voxels benutzt werden soll!
 *
 */

OBJECT  voxel_point                                     -> Punkt für eine Voxel-Darstellung (nur für Landschaften geeignet!)
 height         :INT                                    -> Höhe des Punktes
 color          :INT                                    -> Farbe des Punktes
ENDOBJECT

/*
 *  Außerdem wird EIN Punkt benötigt, der als Bezugspunkt dient und die Blickrichtung
 *   eines Betrachters (z.B. Kamera, Person...) repräsentiert
 *
 *  x      = X-Position des Betrachters (relativ zum Ursprung [1:1])
 *  y      = Y-Position des Betrachters (relativ zum Ursprung [1:1])
 *  height = Höhe des Betrachters (muß MINDESTENS die Höhe des Voxelpoints an dieser Stelle+1 sein!)
 *  camera = Blickwinkel des Betrachters (relativ zum Ursprung [1:1]), ACHTUNG, Angabe = in Grad! (0-360)
 *
 */

OBJECT  voxel_position                                  -> Position eines Betrachters
 x              :INT                                    -> X-Coordinate (relativ zum ersten Punkt [1:1])
 y              :INT                                    -> Y-Coordinate (relativ zum Ursprung [1:1])
 height         :INT                                    -> Höhe (in VOXEL-Einheiten) in der der Betracher steht/schwebt...
 camera         :LONG                                   -> Blickwinkel (Ursprung = 45°! Blick nach "vorne" = 90°)
ENDOBJECT

/* 
 *  DISPLAY Support-Funktionen
 * -==========================-
 * 
 * 
 */

PROC voxel_InitDisplay(screen:PTR TO screen,win_width,win_height,use_width,use_height,resolution,backfillproc,tickproc) -> Voxel-Display allokieren und anlegen
 DEF    voxeldisplay=NIL:PTR TO voxel_display           -> PTR auf eine Display-Struktur die initialisiert werden soll
  NEW voxeldisplay                                      -> Voxel-display-Struktur allokieren (Speicher holen)
   IF (voxeldisplay<>NIL)                               -> Folgenden Code nur ausführen, wenn die Struktur korrekt allokiert wurde
    voxeldisplay.screen:=screen                         -> Übergebenen Screen-PTR setzen
     voxeldisplay.window:=OpenWindowTagList(NIL,        -> Window für die Grafik-Ausgabe öffnen
               [WA_LEFT,        0,                      -> Linke Ecke des Fensters
                WA_TOP,         0,                      -> Obere Ecke des Fensters
                WA_WIDTH,       win_width,                              -> Breite des Fensters auf die übergebenen Werte setzen
                WA_HEIGHT,      win_height,                             -> Höhe des Fensters auf die übergebenen Werte setzen
                WA_IDCMP,       DISPLAY_IDCMP,                          -> IDCMP-Flags setzen (DISPLAY_IDCMP = Konstante!!)
                WA_FLAGS,       WFLG_BORDERLESS OR WFLG_ACTIVATE,       -> Das Fenster soll KEINEN Rahmen besitzen und hinter allen anderen Fenstern erscheinen
                IF (screen=NIL) THEN TAG_IGNORE ELSE WA_CUSTOMSCREEN,screen,    -> Falls ein Screen übergeben wurde, diesen eintragen
                NIL,            NIL])                                   -> TAG-Liste abschließen
      IF (voxeldisplay.window=NIL)                      -> Wenn das Fenster NICHT geöffnet werden konnte
       END voxeldisplay                                 -> Speicher für Voxel-Display wieder freigeben
        voxeldisplay:=NIL                               -> Vorsichtshalber den PTR auf NIL setzen
       RETURN NIL                                       -> Und NIL zurückliefern!
      ENDIF
       voxeldisplay.width:=use_width                    -> Darstellungsbreite für die Voxel-MAP eintragen
      voxeldisplay.height:=use_height                   -> Darstellungshöhe für die Voxel-MAP eintragen
     voxeldisplay.tickproc:=tickproc                    -> PTR auf eine Prozedur die bei jedem IDCMP_INTUITICK ausgeführt werden soll (= 1/25 sek)
    voxeldisplay.backfill:=backfillproc                 -> PTR auf eine Prozedur die den Hintergrung füllen soll (ggf. hier noch andere Sachen einfügen...)
   voxeldisplay.resolution:=resolution                  -> Auflösung einfügen
   ELSE                                                 -> Wenn das Voxel-Display nicht gültig ist / nicht existiert
    RETURN NIL                                          -> Dann NIL (=Fehler) zurückliefern!
   ENDIF
ENDPROC voxeldisplay                                    -> PTR auf die Voxel-Display-Struktur zurückliefern!

PROC voxel_FreeDisplay(voxeldisplay:PTR TO voxel_display)       -> Voxel-Display freigeben
 IF (voxeldisplay<>NIL)                                         -> Nur wenn auch ein Voxel-Display existiert
  IF (voxeldisplay.window<>NIL) THEN CloseWindow(voxeldisplay.window)   -> Wenn ein Fenster offen war, dann dieses Schließen

  END voxeldisplay                                              -> Speicher für das Voxel-Display freigeben
 ELSE                                                           -> Wenn kein Voxel-Display existiert, dann
  RETURN FALSE                                                  -> Fehlermeldung
 ENDIF
ENDPROC TRUE

PROC voxel_DrawDisplay(voxeldisplay:PTR TO voxel_display,voxelmap:PTR TO LONG,position:PTR TO voxel_position)    -> MAP ins DISPLAY zeichnen!
 DEF    proc=NIL,                                       -> Prozedur-PTR
        rport=NIL,                                      -> Rastport zum Zeichnen
        height=0,                                       -> Reelle Höhe des aktuellen Voxel-Pixel
        map_x=0:REG,                                    -> Koordinate des zu zeichnenden Voxels in der MAP (X)
        map_y=0:REG,                                    -> Koordinate des zu zeichnenden Voxels in der MAP (Y)
        x=1:REG,                                        -> Nummer des Voxels der in der Zeile gezeichnet werden soll
        y=0,                                            -> zu zeichnende Voxel-Zeile
        voxels=0,                                       -> Anzahl an zu zeichnenden Voxels in X-Richtung
        voxel_width=0:REG,                              -> Breite eines Voxel-Pixels
        voxel_color=0,                                  -> Farbe des Voxel-Pixels
        voxel_height=0:REG                              -> Höhe des Voxels
  IF (voxeldisplay<>NIL) AND (voxelmap<>NIL) AND (position<>NIL)-> Code nur ausführen, wenn alle Parameter gültig sind/existieren!
   IF (proc:=voxeldisplay.backfill) THEN proc(voxeldisplay,voxelmap,position)           -> Wenn eine Füllprozedur vorhanden ist, dann diese aufrufen
    rport:=voxeldisplay.rport                           -> PTR auf den Rastport zum Zeichnen (des Fensters) holen
     height:=voxeldisplay.height                        -> Höhe auf die Höhe des Horizonts setzen
Forbid()
     WHILE (height<=(voxeldisplay.window.height+position.height))       -> Schleife solange durchlaufen, bis die vorgegebene Höhe mindestens von allen Voxels erreicht ist
      voxels:=(voxeldisplay.width/(voxeldisplay.resolution+(y/2)))                      -> Anzahl der Voxels in der Reihe (nach hinten werden es mehr Voxel, damit sie kleiner werden!)
       map_y:=position.y-((voxeldisplay.height/(voxeldisplay.resolution*2))/2)+y        -> Position des Punktes der MAP (Zeile) berechnen 
        x:=0
         voxel_width:=voxeldisplay.width/voxels         -> Breite eines Voxels anhand der Anzahl der Voxels berechnen
        WHILE (voxels>0)                                -> Für jeden Voxel in der Zeile durchlaufen
         map_x:=position.x-(voxels/2)+x                 -> X-Position des Voxels in der MAP berechnen
          voxel_height,voxel_color:=voxel_fastGetMap(voxelmap,map_x,map_y)              -> Höhe und Farbe des Voxels aus der MAP lesen

           SetAPen(rport,voxel_color)                   -> Farbe für den Voxel setzen
           RectFill(rport,voxel_width*x,height-voxel_height,voxel_width*(x+1),height)   -> Und Voxel zeichnen

          voxels:=voxels-1                              -> Anzahl der noch zu zeichnenden Voxels herabsetzen
         x:=x+1                                         -> Nummer des zu zeichnenden Voxels +1
        ENDWHILE
       y:=y+1                                           -> Nummer der zu zeichnenden Zeile +1
      height:=height+(voxeldisplay.resolution)        -> Anfang des Voxels berechnen    -> 
     ENDWHILE
Permit()
  ELSE                                                  -> Wenn ein Parameter nicht existiert, dann
   RETURN FALSE                                         -> Fehlermeldung zurückliefern
  ENDIF
ENDPROC TRUE

/* 
 *  MAP Support-Funktionen
 * -======================-
 * 
 * 
 */

PROC voxel_InitMap(width,length)                        -> Speicher für eine Map allokieren
 DEF    voxelmap=NIL:PTR TO LONG                        -> PTR auf die MAP, auf NIL setzen
  voxelmap:=New((width*length*SIZEOF voxel_point)+8)    -> Speicher anfordern (Größe = (BREITE * LÄNGE * SIZEOF voxel_point) + 8 Bytes) = 8 Bytes = für speicherung der länge/breite!
   IF (voxelmap<>NIL)                                   -> Nur wenn die MAP angelegt wurde!
    voxelmap[0]:=length                                 -> Länge in die MAP speichern
     voxelmap[1]:=width                                 -> Breite in die MAP speichern
   ENDIF
ENDPROC voxelmap                                        -> PTR auf die MAP zurückliefern

PROC voxel_FreeMap(voxelmap:PTR TO LONG)                -> Speicher für die MAP wieder freigeben
 IF (voxelmap<>NIL)                                     -> Nur wenn die MAP auch wirklich existent war
  Dispose(voxelmap)                                     -> Speicher freigeben
 ELSE                                                   -> wenn die MAP nicht existiert hat...
  RETURN FALSE                                          -> Fehlermeldung zurück...
 ENDIF
ENDPROC TRUE

PROC voxel_SetMap(voxelmap:PTR TO LONG,x,y,color,height)-> Farbe und Höhe eines Punktes in die MAP schreiben
 DEF    width=0,                                        -> gesamte Breite der MAP
        length=0,                                       -> gesamte Länge der MAP
        realpos=0,                                      -> tatsächliche Position des Punktes in der MAP
        point:voxel_point                               -> Speicher für einen Voxel-Punkt, statisch angelegt
  IF (voxelmap<>NIL)                                    -> Nur wenn die MAP auch wirklich existiert!
   length:=voxelmap[0]                                  -> Länge aus der MAP auslesen
    width:=voxelmap[1]                                  -> Breite aus der MAP auslesen
     IF (x<=width) AND (y<=length)                      -> Nur wenn die Werte zulässig sind
      realpos:=((y*width)+x+2)                          -> -1 = Position des Punktes, 0 = nächster Punkt!!!!
       point.height:=height                             -> Höhe des Punktes in das PUNKT Objekt einfügen
        point.color:=color                              -> Farbe des Punktes in die PUNKT-Struktur schreiben
         voxelmap[realpos]:=^point                      -> Punkt in die MAP schreiben
     ELSE
      RETURN FALSE                                      -> Fehler, wenn der Punkt nicht in der MAP liegt!
     ENDIF
  ELSE
   RETURN FALSE                                         -> Fehler zurückmelden, wenn die MAP nicht existiert!
  ENDIF
ENDPROC TRUE

PROC voxel_GetMap(voxelmap:PTR TO LONG,x,y)             -> Farbe und Höhe eines Punktes aus der MAP auslesen
 DEF    point:voxel_point,                              -> Statischer Speicher für einen Voxel-Punkt
        width=0:REG,                                    -> Breite der MAP
        length=0:REG                                    -> Höhe der MAP
  IF (voxelmap<>NIL)                                    -> Nur wenn die Map existiert!
   length:=voxelmap[0]                                  -> Länge aus der MAP lesen
    width:=voxelmap[1]                                  -> Breite aus der MAP lesen
     IF (x>width) THEN WHILE (x>width) DO x:=x-width    -> Wenn der Pixel außerhalb der MAP liegt, dann wird er in die MAP berechnet
      IF (y>length) THEN WHILE (y>length) DO y:=y-length-> Länge anpassen (in die MAP)
    ^point:=voxelmap[(width*y)+x+2]                     -> Punkt aus der MAP holen
  ELSE                                                  -> Wenn die MAP nicht existiert!
   RETURN 0,0                                           -> Fehler zurückmelden!
  ENDIF
ENDPROC point.height, point.color                       -> Höhe und Farbe des Punktes zurückliefern!

PROC voxel_fastGetMap(voxelmap:PTR TO LONG,x,y)
 DEF    point:voxel_point,                              -> Statischer Speicher für einen Voxel-Punkt
        width:REG
  width:=voxelmap[1]                                    -> Breite aus der MAP lesen
   ^point:=voxelmap[(width*y)+x+2]                      -> Punkt aus der MAP holen
ENDPROC point.height, point.color
/* 
 *  POSITION Support-Funktionen
 * -===========================-
 * 
 */

PROC voxel_InitPosition(voxelmap:PTR TO LONG,x,y,height,camera) -> Speicher für >voxel_position< holen und Position setzen
 DEF    voxelposition=NIL:PTR TO voxel_position,        -> PTR auf eine voxel_position-Struktur für die Daten des Betrachers/Kamera
        width=0,                                        -> Breite der Bezugs-Map
        length=0,                                       -> Länge der Bezugs-Map
        map_height=0,                                   -> Höhe des Punktes an der Betracher-Position
        map_color=0                                     -> Farbe des Punktes an der Betrachter-Position
  IF (voxelmap<>NIL)                                    -> Nur ausführen, wenn eine Voxelmap bereits erstellt wurde und allokiert ist
   length:=voxelmap[0]                                  -> Länge der MAP auslesen
    width:=voxelmap[1]                                  -> Breite der MAP auslesen
     IF (x<=width) AND (y<=length)                      -> Nur wenn die Coordinaten des Betrachterpunktes innerhalb der MAP liegen
      map_height,map_color:=voxel_GetMap(voxelmap,x,y)  -> Höhe und Farbe des Punktes an der Betrachter-Position aus der MAP holen
       IF (height<map_height) THEN height:=map_height   -> Wenn die höhe des Betrachters kleiner als die des Punktes ist, dann die höhe anpassen!
        IF (camera>=0) AND (camera<=360)                -> Wenn der Kamera-Winkel im erlaubten Bereich liegt
         NEW voxelposition                              -> Speicher für die Voxel-Position allokieren
          IF (voxelposition<>NIL)                       -> Wenn die Speicheranforderung erfolgreich war
           voxelposition.x:=x                           -> Position des Betrachters speichern (X)
            voxelposition.y:=y                          -> Position des Betrachters speichern (Y)
           voxelposition.height:=height                 -> Höhe des Betrachters ins Objekt schreiben
          voxelposition.camera:=camera                  -> Kamera-Winkel ebenfalls eintragen
         ELSE                                           -> Wenn ein Fehler aufgetreten ist
          RETURN NIL                                    -> Fehlermeldung zurückliefern    
         ENDIF
        ELSE                                            -> Wenn ein Fehler aufgetreten ist
         RETURN NIL                                     -> Fehlermeldung zurückliefern    
        ENDIF
     ELSE                                               -> Wenn ein Fehler aufgetreten ist
      RETURN NIL                                        -> Fehlermeldung zurückliefern    
     ENDIF
  ELSE                                                  -> Wenn ein Fehler aufgetreten ist
   RETURN NIL                                           -> Fehlermeldung zurückliefern    
  ENDIF
ENDPROC voxelposition                                   -> PTR auf die Voxel-Position-Struktur zurückliefern!

PROC voxel_FreePosition(voxelposition:PTR TO voxel_position)    -> Speicher für >voxel_position< freigeben
 IF (voxelposition<>NIL)                                -> Prüfen, ob die >Voxel-Position< Struktur gültig ist
  END voxelposition                                     -> Wenn ja, dann speicher freigeben
   voxelposition:=NIL                                   -> Und sicherheitshalber den PTR auf NIL setzen
 ELSE                                                   -> Wenn >Voxelposition< nicht existent ist (war)
  RETURN FALSE                                          -> Fehlermeldung zurückliefern
 ENDIF
ENDPROC TRUE

PROC voxel_SetPosition(voxelmap:PTR TO LONG,voxelposition:PTR TO voxel_position,x,y,height)  -> Position in >voxel_position< setzen
 DEF    buf=0
 IF (voxelposition<>NIL)                                -> Nur ausführen, wenn >voxelposition< gültig ist
  IF (voxelmap<>NIL)
   IF (voxelmap[0]<y) OR (voxelmap[1]<x) OR (y<1) OR (x<1) THEN RETURN FALSE
    voxelposition.x:=x                                  -> X Setzen
     voxelposition.y:=y                                 -> Y Setzen
    IF height=0
     height,buf:=voxel_fastGetMap(voxelmap,x,y)
    ENDIF
     voxelposition.height:=height                       -> Höhe setzen
  ENDIF
 ELSE                                                   -> Wenn das >voxelposition< objekt nicht angelegt/gültig war
  RETURN FALSE                                          -> Fehler zurückliefern
 ENDIF
ENDPROC TRUE

PROC voxel_GetPosition(voxelposition:PTR TO voxel_position)     -> Position von >voxel_position< holen
 IF (voxelposition=NIL)                                 -> Wenn Die Position (das objekt) ungültig ist
  RETURN 0,0,0                                          -> Fehler zurückliefern!
 ENDIF
ENDPROC voxelposition.x,voxelposition.y,voxelposition.height    -> Sonst die Werte zurückliefern!

PROC voxel_RotatePosition(voxelposition:PTR TO voxel_position,camera)   -> Kamera-winkel (Blickwinkel) neu setzen
 IF (voxelposition<>NIL)                                -> Nur wenn voxelposition auch gültig ist
  IF (camera>=0) AND (camera<=360)                      -> Wenn der Kamera-Winkel gültig ist
   voxelposition.camera:=camera                         -> Kamerawinkel setzen
  ELSE                                                  -> Wenn ein Fehler aufgetreten ist
   RETURN FALSE                                         -> Fehlermeldung zurückliefern     
  ENDIF
 ELSE                                                   -> Wenn ein Fehler aufgetreten ist
  RETURN FALSE                                          -> Fehlermeldung zurückliefern    
 ENDIF
ENDPROC TRUE

