OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/nodes',
       'intuition/classusr',
       'utility/hooks'

OBJECT iclass
  dispatcher:hook
  reserved:LONG
  super:PTR TO iclass
  id:LONG
  instoffset:INT -> This is unsigned
  instsize:INT   -> This is unsigned
  userdata:LONG
  subclasscount:LONG
  objectcount:LONG
  flags:LONG
ENDOBJECT     /* SIZEOF=NONE !!! */

CONST CLB_INLIST=0,
      CLF_INLIST=1

-> instoffset and instsize are unsigned so AND with $FFFF
#define INST_DATA(cl, o) (o+(cl.instoffset AND $FFFF))
#define SIZEOF_INSTANCE(cl) ((cl.instoffset AND $FFFF)+(cl.instsize AND $FFFF)+SIZEOF object_)

OBJECT object_
  node:mln
  class:PTR TO iclass
ENDOBJECT     /* SIZEOF=12 */

#define OBJ_(o) (o)
#define BASEOBJECT(obj_) ((obj_)+SIZEOF object_)
#define OBJECT_(o) ((o)-SIZEOF object_)
-> Offset of class in object_ is 8
#define OCLASS(o) (Long(OBJECT_(o)+8))
