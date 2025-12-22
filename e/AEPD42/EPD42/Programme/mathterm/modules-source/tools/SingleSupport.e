/**********************************************************************

                             SingleSupport

-----------------------------------------------------------------------
:description         functions supporting IEEE-singles

:ec                  3.2e
:begin               05.10.1995
:last modified       16.06.1996
:author              Marcel Bennicke, Dorfstr. 32, 03130 Bohsdorf
:EMail               marcel.bennicke@t-online.de
:version             1.03

PREFS:               TAB = 4

compiling with Blizzard 060 -> "internal Errors":
    [2,11,38,0,$0]
    [2,11,40,0,$0]
    [2,11,41,0,$0]
    [2,11,42,0,$0]
    [2,11,43,0,$0]
    [2,11,44,0,$0]
    [2,11,45,0,$0]

Apollo 1240:
    [2,11,52,0,$0]
    [2,11,53,0,$0]

Please don't report, Wouter already knows!
************************************************************************/

OPT MODULE
OPT EXPORT, PREPROCESS

MODULE  'tools/chars'

-> #define DEBUG


/*************************************************
 converts Strings into IEEE-Singles

 valid  : -0.2, +23.4, -1.32E2, +7.2e-2, 34E+2
 invalid: .5, 2., 1.0e, ...

 Inputs:
    s           string
    beginn=0    first position to investigate

 Outputs:
    - IEEE-Single (may be incorrect)
    - position following the extracted number in string
    - error?: TRUE or FALSE
**************************************************/
PROC str2Single(s:PTR TO CHAR, beginn=0)
    DEF x=0.0, exp=0.0, pos, pos2,
        neg=FALSE, i, pre=0, post=0

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
        x:=!((s[pos++]-"0")!)*Fpow(i!,10.0)+x
    ENDFOR
    IF neg THEN x:=!-x
    
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
            FOR i:=pre TO 0 STEP -1 DO exp:=!((s[pos++]-"0")!)*Fpow(i!,10.0)+exp
            IF neg THEN exp:=!-exp
            x:=!x*Fpow(exp,10.0)
        ELSE
            RETURN x,pos,TRUE
        ENDIF
    ENDIF
ENDPROC x,pos,FALSE


/**************************************************
 converts IEEE-Singles into strings (not EStrings)
 including scientific representation

 !!! does not handle overflows in string,
 !!! so allocate enough memory

 Inputs:
    s           ^string
    x           IEEE-Single ( represented in a LONG )
    post=6      digits
    expmin=7    when to use scientific representation

 Outputs:
    - ^string
    - length of string (in case of errors 0)
***************************************************/
PROC single2Str(s, x, post=6, expmin=7) HANDLE
    DEF i,power=0,power2,maxexp=1.0,exp2,
        onlyexp=FALSE,digit, pos=0:PTR TO CHAR,
        x2,post2=0,

        hs[50]:STRING
    
    IF expmin<0 THEN expmin:=0
    post:=Bounds(post,0,6)

    -> Sonderfall 0
    IF !x=0.0
        s[pos++]:="0"
        s[pos]:=0
        RETURN s,pos
    ENDIF

    IF !x<0
        s[pos++]:="-"
        x:=!-x
    ENDIF

/*
   -> Runden macht Probleme mit der letzten Stelle
    exp2:=Fpow(post!,10.0)
    x:=!Ffloor(!x*exp2+0.5)/exp2
*/

    -> größten/kleinsten Exponenten herausfinden
    IF !x>=1.0
        WHILE !x>=(exp2:=!maxexp*10.0)
            maxexp:=exp2
            IF power++>36 THEN Raise(1)
        ENDWHILE
        IF power>=expmin THEN onlyexp:=TRUE
    ELSE
        WHILE !x<(exp2:=!maxexp/10.0)
            maxexp:=exp2
            IF power--<-36 THEN Raise(1)
        ENDWHILE
        DEC power
        maxexp:=!maxexp/10.0
        IF (-power>=expmin) OR (-power>post) THEN onlyexp:=TRUE
    ENDIF
    
    -> normale Notation + evtl. Exponent
    IF onlyexp
        x:=!x/maxexp
        maxexp:=1.0
        power2:=power
        power:=0
    ENDIF

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
        digit:=!Ffloor(!x/maxexp)!
        IF i=-1 THEN s[pos++]:="."
        s[pos++]:=digit+"0"
        x:=!x-(!(digit!)*maxexp)
        maxexp:=!maxexp/10.0
#ifdef DEBUG
    WriteF('maxexp = \s\ndigit = \d\n',RealF(hs,maxexp,6),digit)
#endif
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
    s[pos]:=0           -> abschließende Null
ENDPROC s,pos


/*********************************************
 !! Use this one for EStrings !!
**********************************************/
PROC single2Estr(s,x,post=6, expmin=7)
    DEF len:REG

    s,len:=single2Str(s,x,post,expmin)
    SetStr(s,len)
ENDPROC s,len
