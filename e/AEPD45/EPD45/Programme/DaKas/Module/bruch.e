OPT MODULE

MODULE 'nukes/math'

EXPORT OBJECT bruch PRIVATE   
  z : LONG
  n : LONG
ENDOBJECT /* -- 8 Bytes -- */


->--------------------------------------------------------------
-> Konstanten:

PROC bru_Pi(bru_faktor=1) OF bruch
  self.z := 3927 * bru_faktor    /* -- x * PI als Bruch -- */
  self.n := 1250                 /* -- PI = Kreiszahl   -- */
  self.bru_Kuerze()
ENDPROC

PROC bru_E(bru_faktor=1) OF bruch
  self.z := 1359 * bru_faktor    /* -- x * E als Bruch    -- */
  self.n := 500                  /* -- E = Eulersche Zahl -- */
  self.bru_Kuerze()
ENDPROC

->--------------------------------------------------------------
-> Vergleichs(Boolesche)-Operatoren:

PROC bru_Negativ() OF bruch

/* -- TRUE, wenn "self" kleiner 0 -- */

  IF (self.z < 0) AND (self.n > 0)
    RETURN TRUE
  ELSEIF (self.z > 0) AND (self.n < 0)
    RETURN TRUE
  ENDIF
ENDPROC FALSE

PROC bru_Groesser(bru_bruch:PTR TO bruch) OF bruch

/* -- (self > bru_bruch) = TRUE -- */

DEF bool_i,bool_j,bru_a,bru_b

  bool_i := self.n > 0
  bool_j := bru_bruch.n > 0

  bru_a  := self.z * bru_bruch.n
  bru_b  := self.n * bru_bruch.z

  IF bool_i = bool_j
    bool_i := bru_a > bru_b
  ELSE
    bool_i := bru_b > bru_a
  ENDIF

ENDPROC bool_i


PROC bru_Gleich(bru_bruch:PTR TO bruch) OF bruch

/* -- (self = bru_bruch) = TRUE -- */

DEF bru_a,bru_b

  bru_a := self.z * bru_bruch.n
  bru_b := self.n * bru_bruch.z

  IF bru_a = bru_b
    RETURN TRUE
  ELSE
    RETURN FALSE
  ENDIF

ENDPROC

PROC bru_Kleiner(bru_bruch:PTR TO bruch) OF bruch

/* -- (self < bru_bruch) = TRUE -- */

  RETURN bru_bruch.bru_Groesser(self)
ENDPROC

->--------------------------------------------------------------
-> Mathematische Operatoren:

PROC bru_Negiere() OF bruch

/* -- self := -self -- */

  self.z := - self.z
  IF (self.z < 0) AND (self.n < 0)
     self.z := - self.z
     self.n := - self.n
  ENDIF
ENDPROC


PROC bru_Sqr() OF bruch

/* -- self := self * self -- */

  self.bru_Kuerze()
  self.z := Mul(self.z,self.z)
  self.n := Mul(self.n,self.n)
ENDPROC


PROC bru_Potenz(exponent=1) OF bruch

/* -- self := self ^ exponent -- */

DEF exp_bruch : PTR TO bruch
DEF exp_lauf,exp_even

  NEW exp_bruch
  exp_bruch.bru_Zahl2Bruch(1,1)
 
  exp_even := Mod(exponent,2)
  exponent := exponent - exp_even
  exponent := Div(exponent,2)
  IF exponent = 1
    exp_bruch.bru_Mul(self)
  ENDIF
  self.bru_Sqr()
  FOR exp_lauf := 1 TO exponent
    exp_bruch.bru_Mul(self)
  ENDFOR    
  self.bru_Bruch(exp_bruch)
  END exp_bruch
  
ENDPROC


PROC bru_Kuerze() OF bruch

/* -- Kürzt den Bruch so, daß die Zahlen den kleinstmöglichen Wert haben -- */

DEF bru_gt

  bru_gt := mat_GGT(self.z,self.n)
  self.z := Div(self.z,bru_gt)
  self.n := Div(self.n,bru_gt)

ENDPROC


PROC bru_Add(bru_toadd:PTR TO bruch) OF bruch

/* -- self := self + bru_toadd -- */

  IF self.n <> bru_toadd.n
    self.n := Mul(self.n,bru_toadd.n)
    self.z := Mul(self.z,bru_toadd.n) + bru_toadd.z
  ELSE
    self.z := self.z + bru_toadd.z
  ENDIF
  self.bru_Kuerze()

ENDPROC


PROC bru_Sub(bru_toadd:PTR TO bruch) OF bruch

/* -- self := self - bru_toadd -- */

  IF self.n <> bru_toadd.n
    self.n := Mul(self.n,bru_toadd.n)
    self.z := Mul(self.z,bru_toadd.n) - bru_toadd.z
  ELSE
    self.z := self.z - bru_toadd.z
  ENDIF
  self.bru_Kuerze()

ENDPROC


PROC bru_Mul(bru_sec:PTR TO bruch) OF bruch

/* -- self := self * bru_sec -- */

  self.z := Mul(self.z,bru_sec.z)
  self.n := Mul(self.n,bru_sec.n)
  self.bru_Kuerze()

ENDPROC


PROC bru_KehrWert() OF bruch

/* -- self := 1 / self -- */

DEF bru_a

  bru_a  := self.z
  self.z := self.n
  self.n := bru_a

ENDPROC


PROC bru_Div(bru_sec:PTR TO bruch) OF bruch

/* -- self := self / bru_sec -- */

  bru_sec.bru_KehrWert()
  self.bru_Mul(bru_sec)
  bru_sec.bru_KehrWert()

ENDPROC

 
->--------------------------------------------------------------
-> Umformungsfunktionen:

PROC bru_Bruch(bru_z:PTR TO bruch) OF bruch

/* -- self := bru_z -- */

  self.z := bru_z.z
  self.n := bru_z.n
ENDPROC

PROC bru_Zahl2Bruch(zaehler=1,nenner=1) OF bruch

/* -- self := [zaehler,nenner]:bruch -- */

  self.z := zaehler
  self.n := nenner
  self.bru_Kuerze()
ENDPROC


PROC bru_Real2Bruch(bru_fl,bru_prec=10000) OF bruch

/* -- self := SingleIEEE -- */

DEF bru_zaehler

  bru_zaehler := !bru_fl * (bru_prec!)
  bru_zaehler := !bru_zaehler!
  self.z   := bru_zaehler
  self.n   := bru_prec

ENDPROC

CHAR '$VER: Bruch.M (E-Modul) v1.0 © Copyrights by Daniel Kasmeroglu'