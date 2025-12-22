

MODULE 'grio/larray','grio/getnumber'

    
 CONST MAX_WIER=10,
       MAX_KOL=10;


PROC main()

 DEF x,y,wier,kol,x_max,y_max,el_max,a:PTR TO larray,el


   NEW a
	
   WriteF('\n')

   WriteF('Podaj ilosc wierszy : ')

   IF (wier:=getNumber(stdin)) > MAX_WIER
      WriteF('maxsymalna wartosc to \d\n',MAX_WIER)
      wier:=MAX_WIER
   ELSE
      IF wier <= 0
	 WriteF('zla wartosc\n')
	 JUMP exit
      ENDIF
   ENDIF
   WriteF('Podaj ilosc kolumn : ')

   IF (kol:=getNumber(stdin)) > MAX_KOL
      WriteF('maxsymalna wartosc to \d\n',MAX_KOL)
      kol:=MAX_KOL
   ELSE
      IF kol <= 0
	 WriteF('zla wartosc\n')
	 JUMP exit
      ENDIF
   ENDIF

   WriteF('\n')

   IF a.make([wier,kol])
	
      DEC wier  ;  DEC kol

      FOR x:=0 TO wier
	FOR y:=0 TO kol
	  WriteF('Element (\d,\d) = ',x,y)
	  a.set([x,y],getNumber(stdin))
	  IF CtrlC() THEN JUMP exit
	ENDFOR
      ENDFOR
    
      a.get([0,0],{el_max})
      x_max:=y_max:=0
      
      FOR x:=0 TO wier
	FOR y:=0 TO kol
	    a.get([x,y],{el})
	    IF el > el_max
	       el_max:=el
	       x_max:=x
	       y_max:=y
	    ENDIF
	    IF CtrlC() THEN JUMP exit
	ENDFOR
      ENDFOR
  
      WriteF('\nElement (\d,\d) ma najwieksza wartosc = \d\n\n',
                                            x_max,y_max,el_max)

   ENDIF

exit:

   END a

ENDPROC

