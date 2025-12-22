OPT MODULE
OPT EXPORT

MODULE '*/fraction'

OBJECT coordinate OF fraction
  x:PTR TO fraction,
  y:PTR TO fraction,
  z:PTR TO fraction
ENDOBJECT

PROC name() OF coordinate IS 'Coordinate'

PROC init() OF coordinate
DEF fraction_x:PTR TO fraction,
    fraction_y:PTR TO fraction,
    fraction_z:PTR TO fraction

  NEW fraction_x.new()
  self.x := fraction_x

  NEW fraction_y.new()
  self.y := fraction_y

  NEW fraction_z.new()
  self.z := fraction_z

ENDPROC

PROC end() OF coordinate
DEF fraction:PTR TO fraction

  fraction := self.x
  END fraction

  fraction := self.y
  END fraction

  fraction := self.y
  END fraction

ENDPROC

/* returns an array with a normal compare to all three dims?
PROC cmp(item:PTR TO integer) OF integer
 IF self.number < item.number THEN RETURN -1
 RETURN IF self.number > item.number THEN 1 ELSE 0
ENDPROC

*/

PROC select(optionlist,index) OF coordinate
/*

TODO: error check: len-o'-list!

*/
DEF item, upper, lower

  item := ListItem(optionlist, index)

  SELECT item
    CASE "set"
      INC index
      upper := ListItem(optionlist,index)
      INC index
      lower := ListItem(optionlist,index)
      self.x.opts(["set",upper,lower])

      INC index
      upper := ListItem(optionlist,index)
      INC index
      lower := ListItem(optionlist,index)
      self.y.opts(["set",upper,lower])

      INC index
      upper := ListItem(optionlist,index)
      INC index
      lower := ListItem(optionlist,index)
      self.z.opts(["set",upper,lower])

  ENDSELECT

ENDPROC index

PROC write() OF coordinate
DEF out

  out:=String(100)

  StrAdd(out,'[ ')
  StrAdd(out, self.x.write())
  StrAdd(out,' ; ')
  StrAdd(out, self.y.write())
  StrAdd(out,' ; ')
  StrAdd(out, self.z.write())
  StrAdd(out,' ]')

  RETURN out
ENDPROC

PROC copy(to:PTR TO coordinate) OF coordinate

  self.x.copy( to.x )
  self.y.copy( to.y )
  self.z.copy( to.z )

ENDPROC

PROC shift(by:PTR TO coordinate) OF coordinate

  self.x.add(by.x)
  self.y.add(by.y)
  self.z.add(by.z)

ENDPROC

-> turns 0-360 to 0-2*pi
PROC angle2radians(angle) OF coordinate
/*

Seems to work only with angles>0
NOTE: only integer angles, please!

*/
DEF fltangle,out[80]:STRING

  IF angle<0 THEN angle := angle+360

  fltangle := !angle/180
  fltangle := fltangle*3.14159265

  RETURN fltangle
ENDPROC


PROC rotateZ(angle) OF coordinate
/*

  note:

  to rotate 90 degree (mathematical) one has to provide -90
  (wrong formula?)
*/

DEF fltangle, nux, nuy, nuz,out[80]:STRING,
    fltx,flty,fltz, resulta, resultb

  fltangle := self.angle2radians(angle)

  fltx := self.x.fraction2flt()
  flty := self.y.fraction2flt()
  fltz := self.z.fraction2flt()

  resulta := !fltx * Fcos(fltangle)
  resultb := !flty * Fsin(fltangle)

  nux := !resulta + resultb

  resulta := !flty * Fcos(fltangle)
  resultb := !fltx * Fsin(fltangle)

  nuy := !resulta - resultb

  resulta := !flty * Fcos(fltangle)
  resultb := !fltz * Fsin(fltangle)

  nuz := !resulta + resultb

  self.x.flt2fraction(nux)
  self.y.flt2fraction(nuy)
  self.z.flt2fraction(nuz)

ENDPROC

PROC rotateY(angle) OF coordinate
-> uses rotateZ()
-> the corrdinates are rotated

/*

LINKS rum rotieren!
*/
DEF swapper:PTR TO fraction

  NEW swapper.new()

  self.x.copy( swapper )  -> rotate

  self.z.copy (self.x )
  self.y.copy (self.z )
  swapper.copy( self.y )

  ->WriteF('linksrum rotiert: \s\n', self.write())

  self.rotateZ(angle)

  self.z.copy( swapper )  -> this'll be x rotate backwards

  self.x.copy( self.z )
  self.y.copy( self.x )
  swapper.copy( self.y )

  END swapper
ENDPROC

PROC rotateX(angle) OF coordinate
-> uses rotateZ()
-> the corrdinates are rotated

/*

LINKS rum rotieren!
*/
DEF swapper:PTR TO fraction

  NEW swapper.new()

  self.x.copy( swapper )  -> rotate

  self.y.copy (self.x )
  self.z.copy (self.y )
  swapper.copy( self.z )

  WriteF('linksrum rotiert: \s\n', self.write())

  self.rotateZ(angle)

  self.z.copy( swapper )  -> this'll be x rotate backwards

  self.y.copy( self.z )
  self.x.copy( self.y )
  swapper.copy( self.x )

  END swapper
ENDPROC
