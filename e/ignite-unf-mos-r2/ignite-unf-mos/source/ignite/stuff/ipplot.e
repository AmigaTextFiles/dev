OPT POWERPC

PROC main()
   DEF win=NIL, x
   DEF ofx=1.1:DOUBLE
   DEF ofy=1.1:DOUBLE
   DEF nfx:DOUBLE
   DEF nfy:DOUBLE
   DEF cx=1.1:DOUBLE
   DEF cy=1.1:DOUBLE
   DEF ft:DOUBLE
   DEF oldy
   DEF str[30]:STRING

   ->of := zabs(ofx,ofy)

   win := OpenW(40,40,600,300,NIL,NIL,'IP-Plot 0.0.1')
   IF win = NIL THEN Raise("WIN")
   SetAPen(stdrast, 1) ; TextF(30, 35,  'SX=\s', RealF(str, ofx, 3))
   SetAPen(stdrast, 2) ; TextF(130, 35, 'SY=\s', RealF(str, ofy, 3))
   SetAPen(stdrast, 3) ; TextF(230, 35, 'SZ=\s', RealF(str, zabs(ofx,ofy), 3))
   SetAPen(stdrast, 4) ; TextF(330, 35, 'XC=\s', RealF(str, cx, 3))
   SetAPen(stdrast, 4) ; TextF(430, 35, 'YC=\s', RealF(str, cy, 3))
   Line(0, 50, 550, 50, 4)
   Line(0, 100, 550, 100, 4)
   Line(0, 150, 550, 150, 4)
   Line(0, 200, 550, 200, 4)
   Line(0, 250, 550, 250, 4)
   FOR x := 10 TO 550 STEP 10
      ->nfx := !ofx*ofx-(!ofy*ofy) + cx
      ->nfy := !2.0*ofx*ofy + cy
      nfx := ! (!ofx*cx)-(!ofy*cy)+1.0-ofx
      nfy := ! (!ofx*cy)+(!ofy*cx)-ofy
      Line(x, 50, x, 250, 4)
      Line(x-10, 150-(!ofx*100.0!), x, 150-(!nfx*100.0!), 1)
      Line(x-10, 150-(!ofy*100.0!), x, 150-(!nfy*100.0!), 2)
      Line(x-10, 150-(!zabs(ofx,ofy)*100.0!), x, 150-(!zabs(nfx,nfy)*100.0!),3)
      ofx := nfx
      ofy := nfy
   ENDFOR
   WaitLeftMouse(win)
   CloseW(win)
ENDPROC

PROC zabs(x:DOUBLE,y:DOUBLE) (DOUBLE) IS Fsqrt(!x*x+(!y*y))
