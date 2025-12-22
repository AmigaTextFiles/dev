/*

Things which are marked with 'CHANGE' should be changed


NOTE: this object is basically based on integer, so why not inherit from it?
      In other words, it inherits technically, but not logically. So don't
      let it inherit from integer but from number?

      - make it possible for add(), multiply() etc. to take 'Integer' as
        argument, too?
*/

OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort/numbers', 'oomodules/sort/numbers/integer'


OBJECT fraction OF number
  upper:PTR TO integer
  lower:PTR TO integer
ENDOBJECT

PROC name() OF fraction IS 'Fraction'

PROC init() OF fraction
DEF up:PTR TO integer,lo:PTR TO integer

  NEW up.new()
  self.upper:=up
  NEW lo.new()
  self.lower:=lo
ENDPROC

PROC getUpper() OF fraction IS self.upper.get()
PROC getLower() OF fraction IS self.lower.get()

PROC setUpper(value) OF fraction IS self.upper.set(value)
PROC setLower(value) OF fraction IS self.lower.set(value)

/*
 * negate the fraction just by nagating the Upper
 */
PROC negate() OF fraction
  self.upper.negate()
ENDPROC

PROC add(what:PTR TO fraction) OF fraction
DEF resultingUpper:PTR TO integer,
    resultingLower:PTR TO integer,
    result_a,result_b

  NEW resultingUpper.new()
  NEW resultingLower.new()

  IF self.lower.cmp(what.lower)=0    -> nenner sind gleich
    self.setUpper(self.getUpper() + what.getUpper()) -> CHANGE when integer.add() exists
  ELSE -> nenner sind unterschiedlich
    resultingUpper.set( (self.getUpper() * what.getLower()) + (self.getLower() * what.getUpper()))  -> zähler1 * nenner2 + nenner1 * zähler2
    resultingLower.set( self.getLower() * what.getLower())  -> nenner1 * nenner2

    /* kürzen fehlt noch */

    self.upper.set( resultingUpper.get() )
    self.lower.set( resultingLower.get() )

  ENDIF

  END resultingUpper
  END resultingLower

ENDPROC

PROC substract(what:PTR TO fraction) OF fraction
/*

pure lazyness:

just negate the argument, then add it...
*/
  what.negate()
  self.add(what)
  what.negate()
ENDPROC

PROC multiply(what:PTR TO fraction) OF fraction
DEF resultingUpper:PTR TO integer,
    resultingLower:PTR TO integer

  NEW resultingUpper.new()
  NEW resultingLower.new()

  resultingUpper.set( self.getUpper() * what.getUpper() ) /* CHANGE integer.mul */
  resultingLower.set( self.getLower() * what.getLower() ) /* dto. */

  /* kürzen fehlt */

  self.upper.set( resultingUpper.get() )
  self.lower.set( resultingLower.get() )

  END resultingUpper
  END resultingLower

ENDPROC

PROC divide(bywhat:PTR TO fraction) OF fraction
DEF swapper:PTR TO integer

  NEW swapper.new() -> we need something to store

  swapper.set( bywhat.getUpper() ) -> store upper

  bywhat.setUpper( bywhat.getLower() ) -> set upper
  bywhat.setLower( swapper.get() ) -> set lower

  self.multiply( bywhat ) -> multiply

  -> now swap back

  bywhat.setLower( bywhat.getUpper() )
  bywhat.setUpper( swapper.get() )

  END swapper
ENDPROC

PROC write() OF fraction
DEF out

  out := String(30) -> think that's enough

  StringF(out, '\d/\d', self.getUpper(), self.getLower())
ENDPROC out

PROC end() OF fraction
DEF integer:PTR TO integer

  integer := self.upper
  END integer

  integer := self.lower
  END integer

ENDPROC

PROC select(optionlist,index) OF fraction
/*

  With select up to now two arguments are taken:

  "copy" - takes a fraction as argument and gets its values. Take it as  a
           simple copy.
  "set"  - takes two numbers and uses them as Upper, Lower
*/
DEF item, fraction:PTR TO fraction

  item := ListItem(optionlist, index)

  SELECT item
    CASE "copy"
      INC index
      fraction := ListItem(optionlist,index) -> typed list

      self.setUpper( fraction.getUpper() )
      self.setLower( fraction.getLower() )
    CASE "set"
      INC index
      item := ListItem(optionlist,index)
      self.setUpper( item )
      INC index
      item := ListItem(optionlist,index)
      self.setLower( item )
  ENDSELECT

ENDPROC index

-> just copies its attributes
PROC copy(to:PTR TO fraction) OF fraction
  to.setUpper( self.getUpper() )
  to.setLower( self.getLower() )
ENDPROC

PROC flt2fraction(flt) OF fraction
/*

This method sets its objects attributes to the values found in
the float.

*/
DEF index,lower=-1, gefunden=0, fltindex,
    result, out[80]:STRING,
    fltupper,upper, fltlower

  FOR index := 1 TO 1000
    fltindex := index! -> richtig
    result := !flt * fltindex  ->richtig

    ->RealF(out,result,5); WriteF('::\s\n',out)

    result := !Fceil(result)-result

    result := result < 0.0001

    IF result THEN gefunden := 1
    IF gefunden=1
      lower:= index
      index:=1000
    ENDIF
  ENDFOR

  IF lower=-1 THEN lower:=1000
-> the lower is found

  fltlower := lower!
  fltupper := !flt * fltlower
  upper := !fltupper!

  self.setUpper(upper)
  IF upper=0
    self.setLower(1)
  ELSE
    self.setLower(lower)
  ENDIF
ENDPROC

PROC fraction2flt() OF fraction -> move to Float
DEF flt,upper,lower,kleiner=0

  IF (upper := self.getUpper())<0
    upper:=upper*(-1)
    INC kleiner
  ENDIF
  IF (lower := self.getLower())<0
    lower:=lower*(-1)
    INC kleiner
  ENDIF

  flt := ! upper / lower

  IF kleiner=1 THEN flt := ! 0 - flt

ENDPROC flt
