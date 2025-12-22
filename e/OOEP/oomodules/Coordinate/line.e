/*

This is a 'reducing' way to implement the Line: the attributes x, y and z
are used as starting values, they may be used. Therefore, start is removed

Look at the rotate procs and see the powerful way of coding oo :)
*/

OPT MODULE
OPT EXPORT

MODULE 'oomodules/coordinate','oomodules/sort/numbers/float'

OBJECT line OF coordinate
  end:PTR TO coordinate
ENDOBJECT

PROC name() OF line IS 'Line'

PROC init() OF line
DEF coo:PTR TO coordinate,
    float_x:PTR TO float,
    float_y:PTR TO float,
    float_z:PTR TO float

  NEW float_x.new()
  self.x := float_x

  NEW float_y.new()
  self.y := float_y

  NEW float_z.new()
  self.z := float_z

  NEW coo.new()
  self.end := coo

ENDPROC

PROC end() OF line
DEF coo:PTR TO coordinate,flt:PTR TO float

  flt := self.x
  END flt

  flt := self.y
  END flt

  flt := self.z
  END flt

  coo := self.end
  END coo

ENDPROC


PROC select(optionlist,index) OF line
/*

TODO: error check: len-o'-list!


DEF item, value

  item := ListItem(optionlist, index)

  SELECT item
    CASE "set"

    INC index
  ENDSELECT
*/
ENDPROC index


PROC setStart(coo:PTR TO coordinate) OF line

  self.setX( coo.getX() )
  self.setY( coo.getY() )
  self.setZ( coo.getZ() )

ENDPROC

PROC setEnd(coo:PTR TO coordinate) OF line IS coo.copy(self.end)

PROC rotateZ(angle, at=NIL:PTR TO coordinate) OF line
  self.end.rotateZ(angle,at)
  SUPER self.rotateZ(angle,at)
ENDPROC

PROC rotateY(angle, at=NIL:PTR TO coordinate) OF line
  self.end.rotateY(angle,at)
  SUPER self.rotateY(angle,at)
ENDPROC

PROC rotateX(angle, at=NIL:PTR TO coordinate) OF line
  self.end.rotateX(angle,at)
  SUPER self.rotateX(angle,at)
ENDPROC
