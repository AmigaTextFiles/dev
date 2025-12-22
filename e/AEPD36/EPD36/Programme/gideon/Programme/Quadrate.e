/* -- Programm: Quadrate                                              -- *
 * -- Autor   : Daniel Kasmeroglu                                     -- *
 * --                                                                 -- *
 * -- Dieses Programm ist eine Version des Programms _Plasma2.AMOS    -- *
 * -- geschrieben von "Mike Stevens". Dabei wird eines meiner Module  -- *
 * -- benutzt, um die Farbrotationen durchzuführen.                   -- */


MODULE 'intuition/screens', 
       'nukes/colora'         -> spezielles Modul


-> Funktionen um mittels "colora" Farben zu setzen
PROC fun_r(index) IS index
PROC fun_g(index) IS IF index > 15 THEN 31-index ELSE index
PROC fun_b(index) IS $8


PROC main()
DEF ma_screen : PTR TO screen  
DEF ma_colora : PTR TO colora  -> "colora" ist ein Objekt
DEF ma_rport

  ma_screen := OpenScreenTagList(NIL,
  [SA_WIDTH,                     320,   -> Normaler Low-Resolution-Screen
   SA_HEIGHT,                    256,   -> mit 32 Farben
   SA_DEPTH,                       5,
   SA_DISPLAYID,                  $0,
   NIL,                          NIL])

  IF ma_screen = NIL THEN RETURN 5      -> Pech gehabt
  ma_rport := SetStdRast(ma_screen.rastport)

  SetRast(stdrast,0)  -> Titelbalken löschen
 
  -> Initialisierung unde Erzeugung des Objektes, wobei der Bildschirm
  -> der Parameter ist ( probierts mal mit der Workbench )
  NEW ma_colora.col_InitColora(ma_screen) 

  -> Farben setzen mit Hilfe von Funktionen
  ma_colora.col_SetCols({fun_r},{fun_g},{fun_b}) -> Farben setzen

  -> Zellen konstruieren
  zellstarter(20,00,200,200,7,1,31)

  -> 10 Farb-Zyklen werden komplett durchlaufen wobei zwischen den
  -> Zyklen 1/50 s lang gewartet wird.
  ma_colora.col_Shift(10,COL_ZYKLUS,1)

  END ma_colora               -> "col_FreeCols()" wird von "end()" aufgerufen

  -> alles rückgängig machen
  SetStdRast(ma_rport)   
  CloseScreen(ma_screen)

ENDPROC


PROC zellstarter(left,top,width,height,iterations,col_min,col_max)

/* -- Diese Prozedur tut nichts weiter als die Berechnung der ersten  -- *
 * -- "Oberzelle", die dann durch den rekursiven Aufruf gefüllt wird. -- */

DEF awidth,aheight,fwidth,fheight,rate

  -> in diesem Abschnitt werden die Ausmaße der "Oberzelle" festgelegt
  awidth  := 2
  aheight := 2
  fwidth  := 1
  fheight := 1

  REPEAT
    fwidth := fwidth * awidth
  UNTIL fwidth >= width

  REPEAT
    fheight := fheight * aheight
  UNTIL fheight >= height

  rate := Div(col_max-col_min,iterations)

  -> Die Show kann beginnen
  zelle(left,top,fwidth,fheight,awidth,aheight,iterations,col_min,col_max,rate)

ENDPROC


PROC zelle(left,top,fwid,fhgt,awid,ahgt,iter,mincl,maxcl,rate)
DEF cwid,chgt,y,x,pls_cellclr,ex,ey,cx,cy

  IF iter < 1 THEN RETURN   -> Abbruchbedingung

  cwid := Max(1,fwid/awid)  -> Ausmaße einer "Zelle" berechnen
  chgt := Max(1,fhgt/ahgt)  

  -> Größe einer Zelle entspricht einem Pixel (oder Strich), was
  -> bedeutet, daß weitere Iterationen keinen Sinn machen
  IF (cwid = 1) OR (chgt = 1) THEN iter := 1

  ey := ahgt-1  -> muß nicht sein, vereinfacht und beschleunigt die
  ex := awid-1  -> Berechnungen etwas

  FOR y:=0 TO ey

    cy := top + (y*chgt) -> Berechnung der Y-Koordinate

    FOR x:=0 TO ex

      cx := left + (x*cwid) -> Berechnung der X-Koordinate

      -> Farbe dieser Zelle wird gelesen und verändert
      pls_cellclr := ReadPixel(stdrast,cx,cy)
      pls_cellclr := pls_cellclr + Rnd(rate * 2) - rate

      -> die Farbe muß im erlaubten Farbbereich liegen und eine
      -> "Rotation" durchführen
      IF pls_cellclr < mincl THEN pls_cellclr := maxcl
      IF pls_cellclr > maxcl THEN pls_cellclr := mincl
   
      -> Farbe setzen und Zelle zeichnen
      SetAPen(stdrast,pls_cellclr)
      RectFill(stdrast,cx,cy,cx+cwid-1,cy+chgt-1)

      -> Aufruf der gleichen Prozedur, wobei die "Zelle" zur "Oberzelle"
      -> wird und in dieser "Oberzelle" neue Zellen gezeichnet werden
      zelle(cx,cy,cwid,chgt,awid,ahgt,iter-1,mincl,maxcl,rate)

    ENDFOR
  ENDFOR

ENDPROC
