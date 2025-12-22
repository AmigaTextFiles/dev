/* Logic.e
 *
 * Details the implementation of logical constructs.  Tons
 * o' fun.
 */

OPT MODULE

MODULE 'oomodules/object'

EXPORT OBJECT logic OF object
 truth
ENDOBJECT

DEF tmp_logic:PTR TO logic,query,if1,if2,ifT1,ifT2,ifF1,ifF2,ifU1,ifU2

EXPORT PROC select(opt,i) OF logic
 DEF item
 item := ListItem(opt,i)
 SELECT item
  CASE "true"
   self.beTrue()
  CASE "fals"
   self.beFalse()
  CASE "?"
   self.beUndetermined()
  CASE "set"
   INC i
   self.truth := ListItem(opt,i)
 ENDSELECT
ENDPROC i

EXPORT PROC beTrue() OF logic
 self.truth := 1
ENDPROC

EXPORT PROC beFalse() OF logic
 self.truth := -1
ENDPROC

EXPORT PROC beUndetermined() OF logic
 self.truth := 0
ENDPROC

EXPORT PROC copy(a=0:PTR TO logic) OF logic
 DEF tmp:PTR TO logic
 IF a
  a.truth := self.truth
  tmp := a
 ELSE
  NEW tmp.new(["set",self.truth])
 ENDIF
ENDPROC tmp

EXPORT PROC isTrue() OF logic IS IF self.truth = 1 THEN TRUE ELSE FALSE

EXPORT PROC isFalse() OF logic IS IF self.truth = -1 THEN TRUE ELSE FALSE

EXPORT PROC isUndetermined() OF logic IS IF self.truth = 0 THEN TRUE ELSE FALSE

EXPORT PROC isDetermined() OF logic IS IF self.truth <> 0 THEN TRUE ELSE FALSE

EXPORT PROC if(q,a=0,b=0)
 query:=q
 if1:=a
 if2:=b
 IF Eval(query)
  IF if1
   RETURN Eval(if1)
  ELSE
   RETURN TRUE
  ENDIF
 ELSE
  IF if2
   RETURN Eval(if2)
  ELSE
   RETURN FALSE
  ENDIF
 ENDIF
ENDPROC

EXPORT PROC ifTrue(a=0,b=0) OF logic
 ifT1:=a; ifT2:=b
 tmp_logic := self
 if(`tmp_logic.isTrue(),ifT1,ifT2)
ENDPROC

EXPORT PROC ifFalse(a=0,b=0) OF logic
 ifF1:=a; ifF2:=b
 tmp_logic := self
 if(`tmp_logic.isFalse(),ifF1,ifF2)
ENDPROC

EXPORT PROC ifUndetermined(a=0,b=0) OF logic
 ifU1:=a; ifU2:=b
 tmp_logic := self
 if(`tmp_logic.isUndetermined(),ifU1,ifU2)
ENDPROC

EXPORT PROC ifDetermined(a=0,b=0) OF logic
 ifU1:=a; ifU2:=b
 tmp_logic := self
 if(`tmp_logic.isDetermined(),ifU1,ifU2)
ENDPROC

EXPORT PROC write() OF logic
 tmp_logic := self
 WriteF('This statement is ')
 self.ifDetermined(`tmp_logic.ifTrue(`WriteF('True'),`WriteF('False')),`WriteF('Undetermined'))
 WriteF('.\n')
ENDPROC
