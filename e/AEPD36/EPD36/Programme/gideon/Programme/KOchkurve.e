/* -- Programm : "Von Koch" - Kurve                                  -- *
 * -- Autor    : Daniel Kasmeroglu                                   -- *
 * --                                                                -- *
 * -- Dies ist eine Demonstration der Koch-Kurve in E. In diesem     -- *
 * -- Beispiel werden die Seiten eines Dreiecks "transformiert".     -- *
 * -- Auch dieses Beispiel kann auf dem Papier nachvollzogen werden: -- *
 * -- Man zeichnet eine beliebig lange Linie auf dem Papier. Dann    -- *
 * -- teilt man diese Linie in drei gleichgroße Linienstücke. Über   -- *
 * -- dem mittleren Linienstück wird ein gleichseitiges Dreieck      -- *
 * -- aufgebaut, deren Seitenlänge eine Drittel der alten Linie      -- *
 * -- entspricht. Nun nimmt man die zwei Seiten des Dreiecks als     -- *
 * -- neue Linien und verfährt wie zuvor beschrieben.                -- */


MODULE 'intuition/screens',  -> einige einfache Module
       'graphics/view',
       'tools/easygui'


CONST KOCH_BREITE = 640,              -> Parameter
      KOCH_HOEHE  = 512,
      KOCH_TIEFE  = 1,
      KOCH_MODUS  = V_HIRES + V_LACE


-> Koordinaten der Eckpunkte und die Anzahl der "Transformationen"
DEF glo_x1,glo_y1,glo_x2,glo_y2,glo_x3,glo_y3,glo_stufe


-> kleiner Requester für den User
PROC eas_RequestParameter()
DEF eas_gui : PTR TO LONG

  eas_gui := [EQROWS,
               [BEVELR,
                 [EQROWS,
                   [EQCOLS,
                     [INTEGER,{x1},'X..:',glo_x1,3], 
                     [INTEGER,{y1},'Y..:',glo_y1,3]],
                   [EQCOLS,
                     [INTEGER,{x2},'X..:',glo_x2,3],
                     [INTEGER,{y2},'Y..:',glo_y2,3]],
                   [EQCOLS,
                     [INTEGER,{x3},'X..:',glo_x3,3],
                     [INTEGER,{y3},'Y..:',glo_y3,3]],
                   [INTEGER,{st},'Stufe...:',glo_stufe,2]]],
               [EQCOLS,
                 [SBUTTON,1,'Kurve(n)'],
                 [SBUTTON,2,'Abbruch']]]

ENDPROC easygui('Von Koch Kurve:',eas_gui)

-> hier werden die Eingaben des Requesters festgehalten
PROC x1(i,x) IS glo_x1    := x
PROC y1(i,x) IS glo_y1    := x
PROC x2(i,x) IS glo_x2    := x
PROC y2(i,x) IS glo_y2    := x
PROC x3(i,x) IS glo_x3    := x
PROC y3(i,x) IS glo_y3    := x
PROC st(i,x) IS glo_stufe := x


PROC main()
DEF ma_screen : PTR TO screen
DEF ma_title,ma_rport

  -> einige Initalisierungen
  glo_x1    := 90  
  glo_y1    := 370
  glo_x2    := 510 
  glo_y2    := 420
  glo_x3    := 320
  glo_y3    := 90
  glo_stufe := 2     -> Mitsubishi-Zeichen =;-O

  -> willste weiter ?
  IF eas_RequestParameter() = 2 THEN RETURN 0

  ma_title  := String(256)
  ma_title  := 'Von Koch Kurve (c) Autor : Daniel Kasmeroglu (1995)'


  -> Öffnen des Bildschirms
  ma_screen := OpenScreenTagList(NIL,   -> Es leben die Tags 8)
  [SA_WIDTH,             KOCH_BREITE,
   SA_HEIGHT,             KOCH_HOEHE,
   SA_DEPTH,              KOCH_TIEFE,
   SA_DISPLAYID,          KOCH_MODUS,
   SA_TITLE,                ma_title,
   NIL,                          NIL])


  -> hoffentlich erfolgreich
  IF ma_screen = NIL THEN RETURN 5

  ma_rport := SetStdRast(ma_screen.rastport)

  SetAPen(stdrast,1) 
  SetBPen(stdrast,0)
  SetDrMd(stdrast,1)

  -> Aufbau der Kurve für alle drei Seiten
  kochkurve(glo_x1,glo_y1,glo_x2,glo_y2,glo_stufe)
  kochkurve(glo_x2,glo_y2,glo_x3,glo_y3,glo_stufe)
  kochkurve(glo_x3,glo_y3,glo_x1,glo_y1,glo_stufe)

  TextF(20,20,'Linke Maus-Taste drücken !')

  -> kleine Warteschleife
  WHILE Mouse() <> 1 DO Delay(0)


  -> alles rückgängig machen
  SetStdRast(ma_rport)
  CloseScreen(ma_screen)

ENDPROC


PROC kochkurve(x1,y1,x2,y2,tiefe)
DEF nx1,ny1,nx2,ny2,nx3,ny3,dx,dy

  -> Abbruchbedingung
  IF tiefe = 0 THEN RETURN

  -> kurz vor Schluß wird die Strecke gezeichnet
  IF tiefe = 1
    Move(stdrast,x1,y1)
    Draw(stdrast,x2,y2)
  ENDIF

  -> hier werden die Koordinaten der Eckpunkte bestimmt
  dx  := Div(x2-x1,3)
  dy  := Div(y2-y1,3)

  nx1 := x1 + dx
  ny1 := y1 + dy

  nx2 := x2 - dx
  ny2 := y2 - dy
                       
  nx3 := Div(nx1+nx2-ny1+ny2,2)
  ny3 := Div(nx1-nx2+ny1+ny2,2)

  -> die Punkte müssen auch im Bildschirm liegen
  nx1 := Max(0,nx1) ; nx1 := Min(KOCH_BREITE-1,nx1)
  nx2 := Max(0,nx2) ; nx2 := Min(KOCH_BREITE-1,nx2)
  nx3 := Max(0,nx3) ; nx3 := Min(KOCH_BREITE-1,nx3)

  ny1 := Max(0,ny1) ; ny1 := Min(KOCH_HOEHE-1,ny1)
  ny2 := Max(0,ny2) ; ny2 := Min(KOCH_HOEHE-1,ny2)
  ny3 := Max(0,ny3) ; ny3 := Min(KOCH_HOEHE-1,ny3)

  -> die vier Teilstrecken sollen weiterbearbeitet werden
  kochkurve(x1,y1,nx1,ny1,tiefe-1)   -> "Linke" Seite  ; alte Linie
  kochkurve(nx1,ny1,nx3,ny3,tiefe-1) -> "Linke" Seite  ; Dreieck
  kochkurve(nx3,ny3,nx2,ny2,tiefe-1) -> "Rechte" Seite ; Dreieck
  kochkurve(nx2,ny2,x2,y2,tiefe-1)   -> "Rechte" Seite ; alte Linie


/*                          /\
                           /  \ 
                          /    \
                         /      \
                 L D    /        \  R D
                       /          \
                      /            \
                     /              \
                    /                \
    --------------------------------------------------
    |    L   A     |     M  A         |  R   A       |

  L: links
  R: rechts
  D: Dreieck
  A: alte Linie    

*/

ENDPROC
