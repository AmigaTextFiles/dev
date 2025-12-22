include "inc/utility/hooks.inc";

struct Msg is
  MethodID:ulong;
;

def ROOTCLASS = "rootclass";
def IMAGECLASS = "imageclass";
def FRAMEICLASS = "frameiclass";
def SYSICLASS = "sysiclass";
def FILLRECTCLASS = "fillrectclass";
def GADGETCLASS = "gadgetclass";
def PROPGCLASS = "propgclass";
def STRGCLASS = "strgclass";
def BUTTONGCLASS = "buttongclass";
def FRBUTTONCLASS = "frbuttonclass";
def GROUPGCLASS = "groupgclass";
def ICCLASS = "icclass";
def MODELCLASS = "modelclass";
def ITEXTICLASS = "itexticlass";
def POINTERCLASS = "pointerclass";

def OM_Dummy = ($100);
def OM_NEW = ($101);
def OM_DISPOSE = ($102);
def OM_SET = ($103);
def OM_GET = ($104);
def OM_ADDTAIL = ($105);
def OM_REMOVE = ($106);
def OM_NOTIFY = ($107);
def OM_UPDATE = ($108);
def OM_ADDMEMBER = ($109);
def OM_REMMEMBER = ($10a);

struct opSet is
  MethodID:ulong;
  ops_AttrList:ulong;
  ops_GInfo:ulong;
;

struct opUpdate is
  MethodID:ulong;
  opu_AttrList:ulong;
  opu_GInfo:ulong;
  opu_Flags:ulong;
;

def OPUF_INTERIM = (1<<0);

struct opGet is
  MethodID:ulong;
  opg_AttrID:ulong;
  opg_Storage:ulong;
;

struct opAddTail is
  MethodID:ulong;
  opat_List:ulong;
;

def opAddMember = opMember;

struct opMember is
  MethodID:ulong;
  opam_Object:ulong;
;

