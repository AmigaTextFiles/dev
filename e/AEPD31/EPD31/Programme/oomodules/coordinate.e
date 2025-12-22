/*

rotating

seems to work
*/

OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort/number/float','oomodules/object'

OBJECT coordinate OF object
  x:PTR TO float,
  y:PTR TO float,
  z:PTR TO float
ENDOBJECT

PROC name() OF coordinate IS 'Coordinate'

PROC init() OF coordinate
DEF float_x:PTR TO float,
    float_y:PTR TO float,
    float_z:PTR TO float

  NEW float_x.new()
  self.x := float_x

  NEW float_y.new()
  self.y := float_y

  NEW float_z.new()
  self.z := float_z

ENDPROC

PROC end() OF coordinate
DEF float:PTR TO float

  float := self.x
  END float

  float := self.y
  END float

  float := self.y
  END float

ENDPROC

PROC getX() OF coordinate IS self.x.get()
PROC getY() OF coordinate IS self.y.get()
PROC getZ() OF coordinate IS self.z.get()

PROC setX(v) OF coordinate IS self.x.set(v)
PROC setY(v) OF coordinate IS self.y.set(v)
PROC setZ(v) OF coordinate IS self.z.set(v)



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
DEF item, value

  item := ListItem(optionlist, index)

  SELECT item
    CASE "set"
      INC index
      self.x.set(ListItem(optionlist,index))

      INC index
      self.y.set(ListItem(optionlist,index))

      INC index
      self.z.set( ListItem(optionlist,index))

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
NOTE: only float angles, please!

*/
DEF out[80]:STRING

  IF angle<0 THEN angle := angle+360

  angle := angle/180.0
  angle := angle*3.14159265

->  RealF(out,angle,8)
->  WriteF('\s\n', out)

  RETURN angle
ENDPROC

PROC rotateZ(angle,coordinate=NIL:PTR TO coordinate) OF coordinate
/*

This method rotates the point by the given angle around the given coordinate.
If no coordinate is specified, we rotate aroung 0;0;0

*/

DEF fltangle, nux, nuy, out[80]:STRING,
    fltx,flty, resulta, resultb

 /*
  * To rotate around a point we do this: substract the coordinate's values,
  * i.e. shift it to 0;0;0, rotate it, and add the coordinate's values
  * to the result.
  */

  IF coordinate
    self.x.substract(coordinate.x)
    self.y.substract(coordinate.y)
    self.z.substract(coordinate.z)
  ENDIF


  fltangle := self.angle2radians(angle)

  fltx := self.x.get()
  flty := self.y.get()

  resulta := !fltx * Fcos(fltangle)
  resultb := !flty * Fsin(fltangle)

  nux := !resulta - resultb

  resulta := !fltx * Fsin(fltangle)
  resultb := !flty * Fcos(fltangle)

  nuy := !resulta + resultb

 /*
  * Now let's shift it back to where it came from (see above)
  */

  self.x.set(nux)
  self.y.set(nuy)

  IF coordinate
    self.x.add(coordinate.x)
    self.y.add(coordinate.y)
    self.z.add(coordinate.z)
  ENDIF

ENDPROC

PROC rotateY(angle,coordinate=NIL:PTR TO coordinate) OF coordinate
/*

  note:

  to rotate 90 degree (mathematical) one has to provide -90
  (wrong formula?)
*/

DEF fltangle, nux, nuz, out[80]:STRING,
    fltx,fltz, resulta, resultb


  IF coordinate
    self.x.substract(coordinate.x)
    self.y.substract(coordinate.y)
    self.z.substract(coordinate.z)
  ENDIF


  fltangle := self.angle2radians(angle)

  fltx := self.x.get()
  fltz := self.z.get()

  resulta := !fltz * Fcos(fltangle)
  resultb := !fltx * Fsin(fltangle)

  nuz := !resulta - resultb

  resulta := !fltz * Fsin(fltangle)
  resultb := !fltx * Fcos(fltangle)

  nux := !resulta + resultb

  self.x.set(nux)
  self.z.set(nuz)

  IF coordinate
    self.x.add(coordinate.x)
    self.y.add(coordinate.y)
    self.z.add(coordinate.z)
  ENDIF

ENDPROC

PROC rotateX(angle,coordinate=NIL:PTR TO coordinate) OF coordinate
/*

  note:

  to rotate 90 degree (mathematical) one has to provide -90
  (wrong formula?)
*/

DEF fltangle, nuy, nuz, out[80]:STRING,
    fltz,flty, resulta, resultb

  IF coordinate
    self.x.substract(coordinate.x)
    self.y.substract(coordinate.y)
    self.z.substract(coordinate.z)
  ENDIF


  fltangle := self.angle2radians(angle)

  fltz := self.z.get()
  flty := self.y.get()

  resulta := !flty * Fcos(fltangle)
  resultb := !fltz * Fsin(fltangle)

  nuy := !resulta - resultb

  resulta := !flty * Fsin(fltangle)
  resultb := !fltz * Fcos(fltangle)

  nuz := !resulta + resultb

  self.y.set(nuy)
  self.z.set(nuz)

  IF coordinate
    self.x.add(coordinate.x)
    self.y.add(coordinate.y)
    self.z.add(coordinate.z)
  ENDIF

ENDPROC

PROC neg() OF coordinate
  self.x.neg()
  self.y.neg()
  self.z.neg()
ENDPROC

