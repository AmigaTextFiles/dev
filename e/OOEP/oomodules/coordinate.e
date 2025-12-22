/*

rotating

seems to work
*/

OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort/numbers/float','oomodules/object'

OBJECT coordinate OF object
/****** coordinate/--coordinate-- ******************************************

    NAME 
      coordinate of object

    PURPOSE
      Unfinished object for three dimensional coordinates.

******************************************************************************

History


*/
  x:PTR TO float,
  y:PTR TO float,
  z:PTR TO float
ENDOBJECT

PROC name() OF coordinate IS 'coordinate'
/****** coordinate/name ******************************************

    NAME 
        name() -- Get name of object.

    SYNOPSIS
        coordinate.name()

    FUNCTION
        Returns 'Coordinate'

    RESULTS
        see above
******************************************************************************

History


*/

PROC init() OF coordinate
/****** coordinate/init ******************************************

    NAME 
        init() -- Initialization of the object.

    SYNOPSIS
        coordinate.init()

    FUNCTION
        Initializes the floats in the object.

    SEE ALSO
        float/new()
******************************************************************************

History


*/
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
/****** coordinate/end ******************************************

    NAME 
        end() -- Destructor.

    SYNOPSIS
        coordinate.end()

    FUNCTION
        ENDs the Floats.

    SEE ALSO
        float/end()
******************************************************************************

History


*/
DEF float:PTR TO float

  float := self.x
  END float

  float := self.y
  END float

  float := self.y
  END float

ENDPROC


PROC getX() OF coordinate IS self.x.get()
/****** coordinate/getX ******************************************

    NAME 
        getX() -- Get x part of coordinate.

    SYNOPSIS
        coordinate.getX()

    FUNCTION
        Returns the value of the x Float of the coordinate.

    RESULT
        see float/get()
******************************************************************************

History


*/
PROC getY() OF coordinate IS self.y.get()
/****** coordinate/getY ******************************************

    NAME 
        getY() -- Get y part of coordinate.

    SYNOPSIS
        coordinate.getY()

    FUNCTION
        Returns the value of the y Float of the coordinate.

    RESULT
        see float/get()
****************************************************************************
History


*/
PROC getZ() OF coordinate IS self.z.get()
/****** coordinate/getZ ******************************************

    NAME 
        getZ() -- Get z part of coordinate.

    SYNOPSIS
        coordinate.getZ()

    FUNCTION
        Returns the value of the z Float of the coordinate.

    RESULT
        see float/get()
******************************************************************************

History


*/

PROC setX(v) OF coordinate IS self.x.set(v)
/****** coordinate/setX ******************************************

    NAME 
        setX() -- Set x part of coordinate.

    SYNOPSIS
        coordinate.setX(v)

    FUNCTION
        Sets the value of the x Float of the coordinate.

    INPUTS
        parameter for float/set()
******************************************************************************

History


*/

PROC setY(v) OF coordinate IS self.y.set(v)
/****** coordinate/setY ******************************************

    NAME 
        setY() -- Set y part of coordinate.

    SYNOPSIS
        coordinate.setY(v)

    FUNCTION
        Sets the value of the y Float of the coordinate.

    INPUTS
        parameter for float/set()
******************************************************************************

History


*/
PROC setZ(v) OF coordinate IS self.z.set(v)
/****** coordinate/setZ ******************************************

    NAME 
        setZ() -- Set z part of coordinate.

    SYNOPSIS
        coordinate.setZ(v)

    FUNCTION
        Sets the value of the z Float of the coordinate.

    INPUTS
        parameter for float/set()
******************************************************************************

History


*/



/* returns an array with a normal compare to all three dims?
PROC cmp(item:PTR TO integer) OF integer
 IF self.number < item.number THEN RETURN -1
 RETURN IF self.number > item.number THEN 1 ELSE 0
ENDPROC

*/

PROC select(optionlist,index) OF coordinate
/****** coordinate/select ******************************************

    NAME 
        select() -- Selection of action on initialization.

    SYNOPSIS
        coordinate.select(optionlist, index)

    FUNCTION
        Recognizes the following items:
            "set" -- The following three items have to be of the type
                that set() expects.

    INPUTS
        optionlist -- The optionlist

        index -- the index of the optionlist

    SEE ALSO
        object/select()
******************************************************************************

History


*/
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
/****** coordinate/write ******************************************

    NAME
        write() -- Get string with printable coordinate.

    SYNOPSIS
        coordinate.write()

    FUNCTION
        Returns a string with the printable coordinate. It looks like this:

        [ <x> ; <y> ; <z> ]

    RESULT
        String above.

    NOTES
        The string has a maximum legth of 100 characters.

******************************************************************************

History


*/
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


PROC copy(to=NIL:PTR TO coordinate) OF coordinate
/****** coordinate/copy ******************************************

    NAME 
        copy() -- Copy a coordinate

    SYNOPSIS
        coordinate.copy(destination=NIL)

    FUNCTION
        Copies a coordinate.

    INPUTS
        destination=NIL:PTR TO coordinate -- Coordinate that is the
            destination of the copy. IF NIL, a new coordinate will be
            created.

    RESULT
        PTR TO coordinate -- If the incoming coordinate object was
            NIL a freshly created coordinated will be returned.

    NOTES
        May raise extension on NEWing the coordinate when the incoming object
        is NIL.

******************************************************************************

History


*/
DEF destination:PTR TO coordinate

  IF to=NIL THEN NEW destination.new() ELSE destination := to

  self.x.copy( destination.x )
  self.y.copy( destination.y )
  self.z.copy( destination.z )

ENDPROC destination


PROC shift(by:PTR TO coordinate) OF coordinate
/****** coordinate/shift ******************************************

    NAME 
        shift() -- Shift a coordinate.

    SYNOPSIS
        coordinate.shift(PTR TO coordinate)

    FUNCTION
        Shifts a coordinate by another.

    INPUTS
        PTR TO coordinate -- Coordinate to shift by.

    EXAMPLE
        Be baseCoordinate [ 1.0 ; 0.0 ; 2.0 ]
        Be secondCoordinate [ 0.0 ; 1.0 ; 1.0 ]

        baseCoordinate.shift(secondCoordinate) would result in
        baseCoordinate being [ 1.0 ; 1.0 ; 3.0 ]

******************************************************************************

History


*/

  self.x.add(by.x)
  self.y.add(by.y)
  self.z.add(by.z)

ENDPROC


-> turns 0-360 to 0-2*pi
PROC angle2radians(angle) OF coordinate
/****** coordinate/angle2radians ******************************************

    NAME 
        angle2radians() -- Turn angle to radians.

    SYNOPSIS
        coordinate.angle2radians(angle)

    FUNCTION
        Turns an angle into it's radians equivalent. 360 degree would result
        in 2*PI.

    INPUTS
        angle -- Normal angle between 0 and 360 degree. HAS to be an e-float!

    RESULT
        radians -- The according radians

******************************************************************************

History


*/
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
/****** coordinate/rotateZ ******************************************

    NAME 
        rotateZ() -- Rotate around the z axis.

    SYNOPSIS
        coordinate.rotateZ(e-float,PTR TO coordinate)

    FUNCTION
        If the second parameter is NIL the coordinate is rotated around the
        z axis by the given angle. If a coordinate is specified, however,
        the object will be rotated around the z axis that goes through that
        point.

    INPUTS
        angle -- Angle to rotate by. HAS to be an e-float!

        coordinate=NIL:PTR TO coordinate -- If provided the object won't be
            rotated around [ 0.0 ; 0.0 ; 0.0 ] but around this coordinate.

    SEE ALSO
        rotateY(), rotateX()
******************************************************************************

History


*/
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
/****** coordinate/rotateY ******************************************

    NAME 
        rotateY() -- Rotate around the y axis.

    SYNOPSIS
        coordinate.rotateY(e-float,PTR TO coordinate)

    FUNCTION
        If the second parameter is NIL the coordinate is rotated around the
        y axis by the given angle. If a coordinate is specified, however,
        the object will be rotated around the y axis that goes through that
        point.

    INPUTS
        angle -- Angle to rotate by. HAS to be an e-float!

        coordinate=NIL:PTR TO coordinate -- If provided the object won't be
            rotated around [ 0.0 ; 0.0 ; 0.0 ] but around this coordinate.

    SEE ALSO
        rotateZ(), rotateX()
******************************************************************************

History


*/
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
/****** coordinate/rotateX ******************************************

    NAME 
        rotateX() -- Rotate around the x axis.

    SYNOPSIS
        coordinate.rotateX(e-float,PTR TO coordinate)

    FUNCTION
        If the second parameter is NIL the coordinate is rotated around the
        x axis by the given angle. If a coordinate is specified, however,
        the object will be rotated around the x axis that goes through that
        point.

    INPUTS
        angle -- Angle to rotate by. HAS to be an e-float!

        coordinate=NIL:PTR TO coordinate -- If provided the object won't be
            rotated around [ 0.0 ; 0.0 ; 0.0 ] but around this coordinate.

    SEE ALSO
        rotateY(), rotateZ()
******************************************************************************

History


*/
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
/****** cordinate/neg ******************************************

    NAME 
        neg() -- Negate cordinate.

    SYNOPSIS
        coordinate.neg()

    FUNCTION
        Negates the x, y and z value of the coordinate.

    SEE ALSO
        float/neg()
******************************************************************************

History


*/
  self.x.neg()
  self.y.neg()
  self.z.neg()
ENDPROC

/*EE folds
1
54 34 56 32 190 50 192 40 194 40 196 34 199 43 201 81 203 73 205 72 207 24 
EE folds*/
