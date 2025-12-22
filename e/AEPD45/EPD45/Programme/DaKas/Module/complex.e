OPT MODULE

EXPORT OBJECT gauss PRIVATE    /* -- c = a + bi -- */
  a : LONG
  b : LONG
ENDOBJECT

PROC com_Add(gauss_ptr:PTR TO gauss) OF gauss
  self.a := !self.a + gauss_ptr.a  -> Addition des Realteils
  self.b := !self.b + gauss_ptr.b  -> Addition des Imaginärteils
ENDPROC


PROC com_Sub(gauss_ptr:PTR TO gauss) OF gauss
  self.a := !self.a - gauss_ptr.a
  self.b := !self.b - gauss_ptr.b
ENDPROC


PROC com_Mul(gauss_ptr:PTR TO gauss) OF gauss
DEF temp
  temp := !self.a * gauss_ptr.a
  temp := !temp - (!self.b * gauss_ptr.b)

  self.b := !(!self.a * gauss_ptr.b) + (!self.b * gauss_ptr.a)
  self.a := temp
ENDPROC


PROC com_Div(gauss_ptr:PTR TO gauss) OF gauss
DEF cmu_res

  cmu_res     := !(!gauss_ptr.a*gauss_ptr.a)+(!gauss_ptr.b*gauss_ptr.b)
  gauss_ptr.b := !(-1.0) * gauss_ptr.b
  self.com_Mul(gauss_ptr)

  self.a := !self.a/cmu_res
  self.b := !self.b/cmu_res

ENDPROC


PROC com_Real2Gauss(real,imaginaer) OF gauss
  self.a := real
  self.b := imaginaer
ENDPROC


PROC com_LaengeSqr() OF gauss RETURN !(!self.a * self.a) + (!self.b * self.b)


PROC com_Schreibe(a=TRUE) OF gauss
DEF ka,kb

  ka:=String(12)
  kb:=String(12)
  RealF(ka,self.a,5)
  RealF(kb,self.b,5)
  WriteF('\s + \si',ka,kb)
  IF a
    WriteF('\n')
  ENDIF
ENDPROC

CHAR '$VER: Complex.M (E-Modul) v1.0 © Copyrights by Daniel Kasmeroglu'