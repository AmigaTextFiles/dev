/* CatProp.e
 *
 * A Categorical Proposition object.  Very scary.
 *
 */

OPT MODULE

MODULE 'oomodules/logic'

SET QUALITY,QUANTITY,NOT_SUBJECT,NOT_PREDICATE

EXPORT OBJECT catprop OF logic
 flag
 sub
 pred
ENDOBJECT

DEF tmp_catprop:PTR TO catprop,ifA1,ifA2,ifE1,ifE2,ifI1,ifI2,ifO1,ifO2,ifU1,ifU2,
    ifP1,ifP2,ifF1,ifF2,ifN1,ifN2

EXPORT PROC select(opt,i) OF catprop
 DEF item
 item := ListItem(opt,i)
 SELECT item
  CASE "beA"
   self.beA()
  CASE "beE"
   self.beE()
  CASE "beI"
   self.beI()
  CASE "beO"
   self.beO()
  CASE "sub"
   INC i
   self.subject(ListItem(opt,i))
  CASE "pred"
   INC i
   self.predicate(ListItem(opt,i))
  CASE "sp"
   INC i
   self.subpred(ListItem(opt,i++),ListItem(opt,i))
  DEFAULT
   RETURN SUPER self.select(opt,i)
 ENDSELECT
 RETURN i
ENDPROC

EXPORT PROC copy(a=0:PTR TO catprop) OF catprop
 DEF tmp:PTR TO catprop
 IF a
  a.subpred(self.sub,self.pred)
  a.flag:=self.flag
  tmp := a
 ELSE
  NEW tmp
  tmp.subpred(self.sub,self.pred)
  tmp.flag := self.flag
 ENDIF
  tmp.truth:=self.truth
ENDPROC tmp

EXPORT PROC notSubject() OF catprop
 self.flag := Eor(self.flag,NOT_SUBJECT)
ENDPROC
EXPORT PROC notPredicate() OF catprop
 self.flag := Eor(self.flag,NOT_PREDICATE)
ENDPROC

EXPORT PROC subject(a) OF catprop
 self.sub := a
ENDPROC
EXPORT PROC predicate(a) OF catprop
 self.pred := a
ENDPROC
EXPORT PROC subpred(a,b) OF catprop
 self.sub := a
 self.pred := b
ENDPROC

EXPORT PROC beUniversal() OF catprop
 self.flag := self.flag AND Eor($FFFF,QUANTITY)
ENDPROC
EXPORT PROC beParticular() OF catprop
 self.flag := self.flag OR QUANTITY
ENDPROC
EXPORT PROC beAffirmative() OF catprop
 self.flag := self.flag AND Eor($FFFF,QUALITY)
ENDPROC
EXPORT PROC beNegative() OF catprop
 self.flag := self.flag OR QUALITY
ENDPROC

EXPORT PROC isUniversal() OF catprop   IS IF self.flag AND QUANTITY THEN FALSE ELSE TRUE
EXPORT PROC isParticular() OF catprop  IS IF self.flag AND QUANTITY THEN TRUE ELSE FALSE
EXPORT PROC isAffirmative() OF catprop IS IF self.flag AND QUALITY THEN FALSE ELSE TRUE
EXPORT PROC isNegative() OF catprop    IS IF self.flag AND QUALITY THEN TRUE ELSE FALSE
EXPORT PROC ifUniversal(a=0,b=0) OF catprop
 ifU1:=a; ifU2:=b
 tmp_catprop:=self
 RETURN if(`tmp_catprop.isUniversal(),ifU1,ifU2)
ENDPROC
EXPORT PROC ifParticular(a=0,b=0) OF catprop
 ifP1:=a; ifP2:=b
 tmp_catprop:=self
 RETURN if(`tmp_catprop.isParticular(),ifP1,ifP2) 
ENDPROC
EXPORT PROC ifAffirmative(a=0,b=0) OF catprop
 ifF1:=a; ifF2:=b
 tmp_catprop:=self
 RETURN if(`tmp_catprop.isAffirmative(),ifF1,ifF2)
ENDPROC
EXPORT PROC ifNegative(a=0,b=0) OF catprop
 ifN1:=a; ifN2:=b
 tmp_catprop:=self
 RETURN if(`tmp_catprop.isNegative(),ifN1,ifN2)
ENDPROC
EXPORT PROC beContradiction() OF catprop
 tmp_catprop:=self
 tmp_catprop.ifDetermined(`tmp_catprop.ifTrue(`tmp_catprop.beFalse(),`tmp_catprop.beTrue()))
 tmp_catprop.ifNegative(`tmp_catprop.beAffirmative(),`tmp_catprop.beNegative())
 tmp_catprop.ifParticular(`tmp_catprop.beUniversal(),`tmp_catprop.beParticular())
ENDPROC
EXPORT PROC beSubalternation() OF catprop
 tmp_catprop:=self
 tmp_catprop.ifDetermined(
     `tmp_catprop.ifParticular(
        `tmp_catprop.ifTrue(
	    `tmp_catprop.beUndetermined()),
	`tmp_catprop.ifFalse(
	    `tmp_catprop.beUndetermined())))
 tmp_catprop.ifParticular(`tmp_catprop.beUniversal(),`tmp_catprop.beParticular())
ENDPROC
EXPORT PROC beContrary() OF catprop
 tmp_catprop:=self
 tmp_catprop.ifDetermined(
    `tmp_catprop.ifUniversal(
       `tmp_catprop.ifTrue(
          `tmp_catprop.beFalse(),
	  `tmp_catprop.beUndetermined()),
       `tmp_catprop.beUndetermined()))
 tmp_catprop.ifNegative(`tmp_catprop.beAffirmative(),`tmp_catprop.beNegative())
ENDPROC
EXPORT PROC beSubcontrary() OF catprop
 tmp_catprop:=self
 tmp_catprop.ifDetermined(
   `tmp_catprop.ifParticular(
     `tmp_catprop.ifFalse(
       `tmp_catprop.beTrue(),
       `tmp_catprop.beUndetermined()),
     `tmp_catprop.beUndetermined()))
 tmp_catprop.ifNegative(`tmp_catprop.beAffirmative(),`tmp_catprop.beNegative())
ENDPROC

EXPORT PROC asConversion() OF catprop
 DEF tmp:PTR TO catprop,test
 tmp := self.copy()
 test := tmp.beConversion()
 RETURN tmp, test
ENDPROC
EXPORT PROC asObversion() OF catprop
 DEF tmp:PTR TO catprop,test
 tmp := self.copy()
 test := tmp.beObversion()
 RETURN tmp, test
ENDPROC
EXPORT PROC asContraposition() OF catprop
 DEF tmp:PTR TO catprop,test
 tmp := self.copy()
 test := tmp.beContraposition()
 RETURN tmp, test
ENDPROC

EXPORT PROC beConversion() OF catprop
 DEF tmp
 IF self.ifA() OR self.ifO()
  self.beUndetermined()
 ENDIF
 tmp := self.pred
 self.pred := self.sub
 self.sub := tmp
 RETURN self.isDetermined()
ENDPROC
EXPORT PROC beObversion() OF catprop
 self.flag := Eor(self.flag,QUALITY)
 self.notPredicate()
 RETURN self.isDetermined()
ENDPROC
EXPORT PROC beContraposition() OF catprop
 DEF tmp
 IF self.ifE() OR self.ifI()
  self.beUndetermined()
 ENDIF
 tmp := self.pred
 self.pred := self.sub
 self.sub := tmp
 self.notSubject()
 self.notPredicate()
 RETURN self.isDetermined()
ENDPROC

EXPORT PROC beA() OF catprop
 IF self.ifA() THEN RETURN
 tmp_catprop:=self
 tmp_catprop.ifE(`tmp_catprop.beContrary(),
   `tmp_catprop.ifI(`tmp_catprop.beSubalternation(),`tmp_catprop.beContradiction()))
ENDPROC
EXPORT PROC beE() OF catprop
 tmp_catprop:=self
 IF self.ifE() THEN RETURN
 tmp_catprop.ifA(`tmp_catprop.beContrary(),
  `tmp_catprop.ifI(`tmp_catprop.beContradiction(),`tmp_catprop.beSubalternation()))
ENDPROC
EXPORT PROC beI() OF catprop
 tmp_catprop:=self
 IF self.ifI() THEN RETURN
 tmp_catprop.ifA(`tmp_catprop.beSubalternation(),
  `tmp_catprop.ifE(`tmp_catprop.beContradiction(),`tmp_catprop.beSubcontrary()))
ENDPROC
EXPORT PROC beO() OF catprop
 tmp_catprop:=self
 IF self.ifO() THEN RETURN
 tmp_catprop.ifA(`tmp_catprop.beContradiction(),
  `tmp_catprop.ifE(`tmp_catprop.beSubalternation(),`tmp_catprop.beSubcontrary()))
ENDPROC

EXPORT PROC ifA(a=0,b=0) OF catprop
 ifA1:=a; ifA2:=b
 tmp_catprop:=self
 RETURN tmp_catprop.ifAffirmative(`tmp_catprop.ifUniversal(ifA1,ifA2),ifA2)
ENDPROC
EXPORT PROC ifE(a=0,b=0) OF catprop
 ifE1:=a; ifE2:=b
 tmp_catprop:=self
 RETURN tmp_catprop.ifUniversal(`tmp_catprop.ifNegative(ifE1,ifE2),ifE2)
ENDPROC
EXPORT PROC ifI(a=0,b=0) OF catprop
 ifI1:=a; ifI2:=b
 tmp_catprop:=self
 RETURN tmp_catprop.ifParticular(`tmp_catprop.ifAffirmative(ifI1,ifI2),ifI2)
ENDPROC
EXPORT PROC ifO(a=0,b=0) OF catprop
 ifO1:=a; ifO2:=b
 tmp_catprop:=self
 RETURN tmp_catprop.ifParticular(`tmp_catprop.ifNegative(ifO1,ifO2),ifO2)
ENDPROC

EXPORT PROC asA() OF catprop
 tmp_catprop := self.copy()
 tmp_catprop.beA()
ENDPROC tmp_catprop
EXPORT PROC asE() OF catprop
 tmp_catprop := self.copy()
 tmp_catprop.beE()
ENDPROC tmp_catprop
EXPORT PROC asI() OF catprop
 tmp_catprop := self.copy()
 tmp_catprop.beI()
ENDPROC tmp_catprop
EXPORT PROC asO() OF catprop
 tmp_catprop := self.copy()
 tmp_catprop.beO()
ENDPROC tmp_catprop

EXPORT PROC write() OF catprop
 tmp_catprop:=self
 tmp_catprop.ifUniversal(`tmp_catprop.ifNegative(`WriteF('No '),`WriteF('All ')),`WriteF('Some '))
 WriteF(self.sub)
 self.ifO(`WriteF(' are not '),`WriteF(' are '))
 WriteF('\s.\n',self.pred)
 SUPER self.write()
ENDPROC
