MODULE 'exec/libraries', 'exec/nodes', 'utility/hooks', 'intuition/classusr'

OBJECT IClass
  Dispatcher:Hook,
  Reserved:ULONG,
  Super:PTR TO IClass,
  ID:ClassID,
  InstOffset:UWORD,
  InstSize:UWORD,
  UserData:ULONG,
  SubClassCount:ULONG,
  ObjectCount:ULONG,
  Flags:ULONG

CONST CLB_INLIST=0,
    CLF_INLIST=1

#define INST_DATA(cl,o) ((o)+(cl::IClass.InstOffset))
#define SIZEOF_INSTANCE(cl) ((cl::IClass.InstOffset)+(cl::IClass.InstSize)+SIZEOF__Object)

CONST OJ_CLASS=8

OBJECT _Object
  Node:MLN,
  Class:PTR TO IClass

#define _OBJ(o) (o)
#define BASEOBJECT(_obj) ((_obj)+SIZEOF__Object)
#define _OBJECT(o) ((o)-SIZEOF__Object)
#define OCLASS(o) (_OBJECT(o)+OJ_CLASS)

OBJECT ClassLibrary
  Lib:Lib,
  Pad:UWORD,
  Class:PTR TO IClass
