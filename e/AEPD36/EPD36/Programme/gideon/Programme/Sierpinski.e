/* -- Programm: Variationen des Siebes von Sierpinski                -- *
 * -- Autor   : Daniel Kasmeroglu                                    -- *
 * --                                                                -- *
 * -- Dieses Programm läßt sich auch leicht auf dem Papier nach-     -- *
 * -- vollziehen ! Als erstes muß auf einem leeren Blatt Papier      -- *
 * -- ein gleichschenkliges Dreieck gezeichnet werden. Die drei      -- *
 * -- Eckpunkte beschreibt man zum Beispiel mit A,B und C.           -- *
 * -- Dann sucht man sich einen Punkt (beliebig) aus, der sich       -- *
 * -- außerhalb (muß nicht unbedingt sein ;-) des Dreiecks           -- *
 * -- befindet. Den Augenzahlen eines Würfels schreibt man beliebige -- *
 * -- Punkte zu : Beispiel:    1,3 entsprechen A                     -- * 
 * --                          2,6 entsprechen B                     -- *
 * --                          4,5 entsprechen C .                   -- *
 * -- Diese Reihenfolge ist nicht zwingend, man kann also jede       -- *
 * -- Kombination wählen. Nun würfelt man ca. x mal. Wenn zum        -- *
 * -- Beispiel eine 2 gewürfelt wird, entspricht dies dem Punkt B    -- *
 * -- (in unserem speziellen Beispiel). Durch den letzten Punkt      -- *
 * -- und Punkt B wird ein Lineal gelegt. Die Mitte zwischen         -- *
 * -- diesen beiden Punkten, ist der neue Punkt und wird markiert.   -- *
 * -- Nach einigen Versuchen, werden geometrische Strukturen         -- *
 * -- sichtbar, die zeigen, daß im Zufall eine Systematik liegt !    -- */

MODULE 'intuition/screens',    -> eigener Bildschirm
       'graphics/view',        -> für die Darstellung
       'tools/easygui'         -> kleine Benutzeroberfläche


CONST SIE_BREITE = 640,               -> diese Konstanten erleichtern,
      SIE_HOEHE  = 512,               -> das Verändern von Parametern
      SIE_TIEFE  = 1,
      SIE_MODUS  = V_HIRES + V_LACE,
      SIE_OLDIE  = 1,
      SIE_FLOCKE = 2,
      SIE_KRONE  = 3,
      SIE_PYRA   = 4


DEF glo_user,glo_sx,glo_sy,glo_steps,glo_version


-> kleiner Requester für den User
PROC eas_RequestParameter()
DEF eas_gui:PTR TO LONG

  eas_gui := [EQROWS,
               [CYCLE,{version},'Variation.:',['Schneeflocke','Krone','Pyramide','Oldie',NIL]],
               [INTEGER,{zufall},'Zufallszahl:',glo_user,4],
               [INTEGER,{punkte},'Punktzahl..:',glo_steps,6],
               [TEXT,'Startkoordinaten:',NIL,FALSE,FALSE],
               [INTEGER,{xstart},'X.(Pixel)..:',glo_sx,3],
               [INTEGER,{ystart},'Y.(Pixel)..:',glo_sy,3],
               [BAR],
               [EQCOLS,
                 [SBUTTON,1,'Start'],
                 [SBUTTON,2,'Abbruch']]]

ENDPROC easygui('Sierpinski:',eas_gui)

-> hier werden die Eingaben des Requesters in globalen Variablen festgehalten
PROC zufall(i,x)  IS glo_user  := x
PROC punkte(i,x)  IS glo_steps := x
PROC xstart(i,x)  IS glo_sx    := x
PROC ystart(i,x)  IS glo_sy    := x
PROC version(i,x)
  SELECT x
    CASE 0 ; glo_version := SIE_FLOCKE
    CASE 1 ; glo_version := SIE_KRONE
    CASE 2 ; glo_version := SIE_PYRA
    CASE 3 ; glo_version := SIE_OLDIE
  ENDSELECT
ENDPROC


PROC inscreen(x,y)
-> damit nicht in unerforschte Speicherbereiche hineingeschrieben wird

  IF (x > -1) AND (x < (SIE_BREITE-1)) 
    IF (y > -1) AND (y < (SIE_HOEHE-1))
      RETURN TRUE
    ELSE
      RETURN FALSE
    ENDIF
  ELSE
    RETURN FALSE
  ENDIF

ENDPROC


PROC main()
DEF ma_screen : PTR TO screen
DEF ma_ax,ma_ay,ma_bx,ma_by,ma_cx,ma_cy
DEF ma_lauf,ma_zx,ma_zy,ma_val,ma_dx,ma_dy
DEF ma_title,ma_rport
 
  -> einige Initialisierungen
  glo_version := SIE_OLDIE
  glo_user    := 345
  glo_sx      := 60
  glo_sy      := 30
  glo_steps   := 10000

  -> was will der User, oder will er gar nichts ;-?
  IF eas_RequestParameter() = 2 THEN RETURN 0

  ma_title  := String(256)
  ma_title  := 'Das Sieb von Sierpinski (c) Autor : Daniel Kasmeroglu (1995)'


  -> Öffnen des Bildschirms
  ma_screen := OpenScreenTagList(NIL,   -> hier wird die Erstellung eines
  [SA_WIDTH,              SIE_BREITE,   -> Bildschirms mit Hilfe einer
   SA_HEIGHT,              SIE_HOEHE,   -> Tag-Liste durchgeführt ;-)))
   SA_DEPTH,               SIE_TIEFE,
   SA_DISPLAYID,           SIE_MODUS,
   SA_TITLE,                ma_title,
   NIL,                          NIL])


  -> Falls kein Bildschirm geöffnet werden konnte
  IF ma_screen = NIL THEN RETURN 5

  -> aktuellen Raster-Port setzen
  ma_rport := SetStdRast(ma_screen.rastport)

  -> Zwei "Farben" : schwarz und weiß
  LoadRGB4(ma_screen.viewport,[$000,$FFF]:INT,2)

  SetAPen(stdrast,1) 
  SetBPen(stdrast,0)
  SetDrMd(stdrast,1)


  -> Koordinaten der Eckpunkte, können auch variiert werden
  ma_ax := 90  ; ma_ay := 450
  ma_bx := 550 ; ma_by := 450
  ma_cx := 320 ; ma_cy := 60


  -> "zufällig" ausgewählter Startpunkt
  glo_sx := Rnd(SIE_BREITE-50)+10
  glo_sy := Rnd(SIE_HOEHE-50)+10


  -> x Mal "würfeln"
  FOR ma_lauf := 1 TO glo_steps

    -> den Zufall muß ich hier leider mit `Rnd()' simulieren,
    -> wobei man nach Möglichkeit besser variierende Zufallsalgorithmen
    -> benutzen sollte.
    ma_val := Mod(Rnd(glo_user),3)  -> ma_val = [0,1,2]


    -> der gewählte Punkt wird gespeichert um  den Mittelpunkt zu berechnen
    SELECT ma_val
      CASE 0 ; ma_zx := ma_ax ; ma_zy := ma_ay ;
      CASE 1 ; ma_zx := ma_bx ; ma_zy := ma_by ;
      CASE 2 ; ma_zx := ma_cx ; ma_zy := ma_cy ;
    ENDSELECT

    ma_dx := ma_zx-glo_sx
    ma_dy := ma_zy-glo_sy


    -> der nächste Schritt wird für einige nicht mehr nachvollziehbar sein,
    -> da es sich hierbei um die Vereinfachung einer komplexeren IF-ELSE-
    -> Struktur handelt
    IF (glo_version = SIE_OLDIE) OR (glo_version = SIE_KRONE)
      glo_sx := ma_zx - Div(ma_dx,2) 
    ELSE
      glo_sx := ma_zx + Div(ma_dx,2)
    ENDIF

    IF (glo_version = SIE_OLDIE) OR (glo_version = SIE_PYRA)
      glo_sy := ma_zy - Div(ma_dy,2)
    ELSE
      glo_sy := ma_zy + Div(ma_dy,2)
    ENDIF

    -> Falls der Punkt im Bildschirm liegt, dann zeichnen (sicherheitshalber)
    IF inscreen(glo_sx,glo_sy) THEN WritePixel(stdrast,glo_sx,glo_sy)

  ENDFOR    


  -> warten bis die Maus gedrückt wird
  TextF(20,20,'Maus-Taste drücken !')
  WHILE Mouse() <> 1 DO Delay(0)

  -> Bildschirm schließen
  SetStdRast(ma_rport)
  CloseScreen(ma_screen)

ENDPROC
