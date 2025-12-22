MODULE 'intuition/cghooks'

TDEF Object:ULONG
TDEF ClassID:PTR TO UBYTE

OBJECT Msg
  MethodID:ULONG

#define ROOTCLASS 'rootclass'
#define IMAGECLASS 'imageclass'
#define FRAMEICLASS 'frameiclass'
#define SYSICLASS 'sysiclass'
#define FILLRECTCLASS 'fillrectclass'
#define GADGETCLASS 'gadgetclass'
#define PROPGCLASS 'propgclass'
#define STRGCLASS 'strgclass'
#define BUTTONGCLASS 'buttongclass'
#define FRBUTTONCLASS 'frbuttonclass'
#define GROUPGCLASS 'groupgclass'
#define ICCLASS 'icclass'
#define MODELCLASS 'modelclass'
#define ITEXTICLASS 'itexticlass'
#define POINTERCLASS 'pointerclass'

CONST OM_NEW=$101,
    OM_DISPOSE=$102,
    OM_SET=$103,
    OM_GET=$104,
    OM_ADDTAIL=$105,
    OM_REMOVE=$106,
    OM_NOTIFY=$107,
    OM_UPDATE=$108,
    OM_ADDMEMBER=$109,
    OM_REMMEMBER=$10A

OBJECT opNew
  MethodID:ULONG,
  AttrList:PTR TO TagItem,
  GInfo:PTR TO GadgetInfo  -> Always NIL

OBJECT opSet
  MethodID:ULONG,
  AttrList:PTR TO TagItem,
  GInfo:PTR TO GadgetInfo

OBJECT opUpdate
  MethodID:ULONG,
  AttrList:PTR TO TagItem,
  GInfo:PTR TO GadgetInfo,
  Flags:ULONG

OBJECT opNotify
  MethodID:ULONG,
  AttrList:PTR TO TagItem,
  GInfo:PTR TO GadgetInfo,
  Flags:ULONG

CONST OPUB_INTERIM=0,
    OPUF_INTERIM=1

OBJECT opGet
  MethodID:ULONG,
  AttrID:ULONG,
  Storage:PTR TO ULONG

OBJECT opAddTail
  MethodID:ULONG,
  List:PTR TO LH

OBJECT opMember
  MethodID:ULONG,
  Object:PTR TO Object

OBJECT opAddMember
  MethodID:ULONG,
  Object:PTR TO Object

OBJECT opRemMember
  MethodID:ULONG,
  Object:ULONG
