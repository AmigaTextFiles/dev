/**********************************************************************

                         DoubleSupport

	(basierend auf longreal-Modul von EA van Breemen
	sollte Amiga-E stardardmäßig beiliegen
	Verzeichnis Src/tools/longreal)

-----------------------------------------------------------------------
:Beschreibung        Hilfsfunktionen für IEEE-Doubles

:EC-Version          3.2e
:Beginn              02.11.1995
:letzte Änderung     08.05.1996
:Autor				 EA van Breemen
:modifiziert von     Marcel Bennicke, Dorfstr. 32, 03130 Bohsdorf
					 marcel.bennicke@t-online.de
:Version             1.03

PREFS:               TAB = 4
************************************************************************/

OPT MODULE
OPT EXPORT

MODULE  'tools/chars','mathieeedoubbas', 'mathieeedoubtrans'


OBJECT longreal
    a,b
ENDOBJECT



/*************************************************
 Wandelt Strings in IEEE-Doubles um

 gültig  : -0.2, +23.4, -1.32E2, +7.2e-2, 34E+2
 ungültig: .5, 2., 1.0e, ...

 Eingangsparameter:
    x           ^longreal-Variable in der das
                Ergebnis gespeichert wird
    s           Zahlenstring
    beginn=0    erste zu untersuchende Position

 Ausgangsparameter:
    - x (evtl. fehlerhaft)
    - nächste Position im String nach der Zahl
    - Fehler?: bei Fehler TRUE, alles ok bei FALSE
**************************************************/
PROC str2Double(x:PTR TO longreal, s:PTR TO CHAR, beginn=0)
    DEF exp:longreal, pos, pos2,
        neg=FALSE, i, pre=0, post=0,
        h1:longreal, h2:longreal, zehn:longreal
    
    dFloat(0,x)
    dFloat(0,exp)
    dFloat(10,zehn)
    
    pos:=beginn
    -> normale Dezimalzahl
    IF s[pos]="-"
        neg:=TRUE
        INC pos
    ELSEIF s[pos]="+"
        INC pos
    ENDIF
    
    pos2:=pos           -> Vorkommateil
    WHILE isDigit(s[pos2]) DO INC pos2
    IF (pre:=pos2-pos-1)=-1 THEN RETURN x,pos,TRUE
    
    IF s[pos2]="."      -> Nachkommateil
        INC pos2
        WHILE isDigit(s[pos2]) DO INC pos2
        IF (post:=pre+pos+2-pos2)=0 THEN RETURN x,pos,TRUE
    ENDIF
    
    FOR i:=pre TO post STEP -1
        IF s[pos]="." THEN INC pos

        dFloat(s[pos++]-"0",h1)
        dFloat(i,h2)
        dPow(zehn,h2,h2)

        -> x:=x+(s[pos++]-"0")*10^i
        dAdd(x,dMul(h1,h2))
    ENDFOR
    IF neg THEN dNeg(x)
    
    -> Exponent ?
    neg:=FALSE
    IF (s[pos]="E") OR (s[pos]="e")
        INC pos
        IF s[pos]="-"
            neg:=TRUE
            INC pos
        ELSEIF s[pos]="+"
            INC pos
        ENDIF
        pos2:=pos
        WHILE isDigit(s[pos2]) DO INC pos2
        IF pos2<>pos
            pre:=pos2-pos-1
        
            FOR i:=pre TO 0 STEP -1
                dFloat(s[pos++]-"0",h1)
                dFloat(i,h2)
                dPow(zehn,h2,h2)

                -> x:=x+(s[pos++]-"0")*10^i
                dAdd(exp,dMul(h1,h2))
            ENDFOR
        
            IF neg THEN dNeg(exp)
            dMul(x,dPow(zehn,exp,h1))   -> x:=x*10^exp
        ELSE
            RETURN x,pos,TRUE
        ENDIF
    ENDIF
ENDPROC x,pos,FALSE


/**************************************************
 Wandelt IEEE-Doubles in Strings um
 (incl. Exponentenschreibweise)

 !!! genügend große Anzahl Bytes reservieren
 !!! (Überlauf wird zur Steigerung der Geschw.
 !!! nicht getestet)

 Eingangsparameter:
    s           ^String
    x           IEEE-Double als longreal
    post=15     Anzahl Nachkommastellen
    expmin=16   bestimmt die Anzahl der Stellen vor
                bzw. nach dem Komma, ab denen die
                Exponentenschreibweise benutzt wird

 Ausgangsparameter:
    - ^String
    - Länge des erzeugten Strings (bei Fehler Null)
***************************************************/
PROC double2Str(s, got_x:PTR TO longreal, post=15, expmin=16) HANDLE
    DEF i,power=0,power2,maxexp:longreal,exp2:longreal,
        onlyexp=FALSE,digit, pos=0:PTR TO CHAR,
        x2:longreal,post2=0, hs[25]:STRING,
        h1:longreal,h2:longreal,
        zehn:longreal, x:longreal

    dFloat(10,zehn)
    dFloat(1,maxexp)
    dCopy(x,got_x)      -> kopieren, da Inhalt verändert wird

    IF expmin<0 THEN expmin:=0
    post:=Bounds(post,0,15)

    -> Sonderfall 0
    IF dTst(x)=0
        s[pos++]:="0"
        s[pos]:=0
        RETURN s,pos
    ENDIF

    IF dTst(x)<0
        s[pos++]:="-"
        dNeg(x)
    ENDIF
    
    -> größten/kleinsten Exponenten herausfinden
    IF dCmp(x,dFloat(1,h1))=-1      -> x<1 ?

    -> Assembler ist schneller...
dblcmploop1:
        dCmp(x,dDiv(maxexp,zehn,exp2))  -> WHILE x < maxexp/10 ...=-1?
        BGE dblcmpcont1
            dCopy(maxexp,exp2)
            IF power--<-306 THEN Raise(1)
        BRA dblcmploop1                 -> ENDWHILE
dblcmpcont1:
        DEC power
        dCopy(maxexp,exp2)
        IF (-power>=expmin) OR (-power>post) THEN onlyexp:=TRUE
    ELSE
dblcmploop2:
        dCmp(x,dMul(maxexp,zehn,exp2))  -> WHILE x>=maxexp*10.0 ..=1 OR =0
        BLT dblcmpcont2
            dCopy(maxexp,exp2)
            IF power++>306 THEN Raise(1)
        BRA dblcmploop2                 -> ENDWHILE
dblcmpcont2:
        IF power>=expmin THEN onlyexp:=TRUE
    ENDIF
    
    -> normale Notation + evtl. Exponent
    IF onlyexp
        dDiv(x,maxexp)
        dFloat(1,maxexp)
        power2:=power
		power:=0
    ENDIF
/*
    -> Runden macht Probleme an der letzten Stelle
    dPow(zehn,dFloat(post,h1),exp2)
    dDiv(dFloat(5,h2),zehn)
    dDiv(dRound(dAdd(dMul(x,exp2),h2)),exp2)
*/

    -> evtl. führende Nullen erzeugen
    IF power<0
        s[pos++]:="0"
		IF power<-1
	        s[pos++]:="."
    	    FOR i:=-1 TO power+1 STEP -1 DO s[pos++]:="0"
		ENDIF
    ENDIF
    
    -> einzelne Stellen ermitteln
    FOR i:=power TO -post STEP -1
        digit:=dFix(dDiv(x,maxexp,h1))
        IF (i=-1) THEN s[pos++]:="."
        s[pos++]:=digit+"0"
        dSub(x,dMul(dRound(h1),maxexp,h1))
        dDiv(maxexp,zehn)
    ENDFOR
    
	-> nachstehende Nullen evtl. wieder löschen
	WHILE s[pos--]="0" DO s[pos]:=0
	IF s[pos]="." THEN s[pos]:=0 ELSE INC pos

    -> evtl. Exponent anfügen
    IF onlyexp
        StringF(hs,IF power2>0 THEN 'E+\d' ELSE 'E\d',power2)
        FOR i:=0 TO EstrLen(hs)-1 DO s[pos++]:=hs[i]
    ENDIF
EXCEPT DO
	IF exception THEN pos:=0
    s[pos]:=0            -> abschließende Null
ENDPROC s,pos


/*********************************************
 Diese Funktion für EStrings benutzen,
 !! Auch auf Größe achten !!
**********************************************/
PROC double2Estr(s, x,post=15, expmin=16)
    DEF len:REG

    s,len:=double2Str(s,x,post,expmin)
    SetStr(s,len)
ENDPROC s,len


PROC dFloat(int,longreal:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPFlt(int)
  longreal.a:=a
  longreal.b:=b
ENDPROC longreal

PROC dFix(longreal:PTR TO longreal) IS IeeeDPFix(longreal.a,longreal.b)

PROC dInteger(x:PTR TO longreal) -> richtig gerundete Integers
    dAdd(x,[$3FE00000,0]:longreal) -> +0.5
ENDPROC dFix(x)

/*  x>0 ->  1
    x=0 ->  0
    x<0 -> -1 */
PROC dTst(x:PTR TO longreal) IS IeeeDPTst(x.a,x.b)

/*  x>y ->  1
    x=y ->  0
    x<y -> -1 */
PROC dCmp(x:PTR TO longreal,y:PTR TO longreal) IS IeeeDPCmp(x.a,x.b,y.a,y.b)

PROC dAdd(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAdd(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

-> x-y
PROC dSub(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSub(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

PROC dMul(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPMul(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

-> x/y
PROC dDiv(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPDiv(x.a,x.b,y.a,y.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

PROC dRound(x:PTR TO longreal, to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPFloor(x.a,x.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

PROC dRoundUp(x:PTR TO longreal, to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPCeil(x.a,x.b)
  IF to
    to.a:=a; to.b:=b
    RETURN to
  ELSE
    x.a:=a; x.b:=b
  ENDIF
ENDPROC x

PROC dNeg(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPNeg(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

PROC dAbs(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAbs(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC x

PROC dCopy(x:PTR TO longreal,y:PTR TO longreal)
  x.a:=y.a
  x.b:=y.b
ENDPROC x



-> IEEE-Single -> longreal
PROC dDouble(x,to:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPFieee(x)
  to.a:=a
  to.b:=b
ENDPROC

-> longreal -> IEEE-Single
PROC dSingle(x:PTR TO longreal) IS IeeeDPTieee(x.a,x.b)
  

PROC dSqrt(x:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSqrt(x.a,x.b)
  x.a:=a; x.b:=b
ENDPROC


-> =PI
PROC dPi(x:PTR TO longreal)
 x.a:=$400921FB            /* Dirty but quick 8-) */
 x.b:=$54442D18
ENDPROC x

PROC dRad(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF s:longreal,t:longreal
   
  dPi(t)
  dFloat(180,s)

  dDiv(t,s)
  dMul(t,x)
  IF to
    to.a:=t.a
    to.b:=t.b
    RETURN to
  ELSE
    x.a:=t.a
    x.b:=t.b
    RETURN x
  ENDIF
ENDPROC

PROC dSin(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSin(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

PROC dCos(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPCos(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

PROC dTan(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPTan(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

PROC dASin(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAsin(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC


PROC dACos(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAcos(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC


PROC dATan(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPAtan(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

PROC dSinh(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPSinh(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

PROC dCosh(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPCosh(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

PROC dTanh(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPTanh(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC


PROC dExp(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPExp(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

PROC dLn(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPLog(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

PROC dLog(x:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPLog10(x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC

-> x^y
PROC dPow(x:PTR TO longreal,y:PTR TO longreal,to=NIL:PTR TO longreal)
  DEF a,b
  a,b:=IeeeDPPow(y.a,y.b,x.a,x.b)
  IF to
    to.a:=a
    to.b:=b
    RETURN to
  ELSE
    x.a:=a
    x.b:=b
    RETURN x
  ENDIF
ENDPROC
