with System;
with Interfaces; use Interfaces;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with unchecked_conversion;

with Incomplete_Type; use Incomplete_type;

with utility_TagItem; use utility_TagItem;
with exec_lists; use exec_lists;

package intuition_classusr is
--#ifndef UTILITY_HOOKS_H
--#include <utility/hooks.h>
--#endif

type MsgData_Type is array (Positive range <>) of Unsigned_32;
type MsgData_Ptr is access MsgData_Type;
type Msg is record
    MsgAddress : System.Address;
    MsgData : MsgData_Ptr;
    Size     : Positive;
end record;

function NewMsg return Msg;

generic
    type MsgDataType is private;
    with function to_Unsigned_32(MsgData : MsgDataType) return Unsigned_32;

    procedure NewAddMsg ( A_Msg : in out Msg; data : in MsgDataType );


procedure AddMsg( A_Msg : in out Msg; data : Unsigned_32);
procedure AddMsg( A_Msg : in out Msg; data : Unsigned_32_Ptr);
procedure AddMsg( A_Msg : in out Msg; data : System.Address);
procedure AddMsg( A_Msg : in out Msg; data : Integer);
procedure AddMsg( A_Msg : in out Msg; data : Boolean);
procedure AddMsg( A_Msg : in out Msg; data : Character);
procedure AddMsg( A_Msg : in out Msg; data : Chars_Ptr);

procedure ClearMsg( A_Msg : in out Msg );

type Object is new Unsigned_32;
type Object_Ptr is access Object;
function to_Unsigned_32 is new Unchecked_Conversion(Object_Ptr,Unsigned_32);
procedure AddTag is new NewAddTag(Object_Ptr,to_Unsigned_32);

type Object_Ptr_Array is array (Natural range <>) of Object_Ptr;
procedure AddMsg is new NewAddMsg(Object_Ptr,to_Unsigned_32);

type ClassID is new Unsigned_8_Ptr;

ROOTCLASS : constant String := "rootclass";
IMAGECLASS : constant String := "imageclass";
FRAMEICLASS : constant String := "frameiclass";
SYSICLASS : constant String := "sysiclass";
FILLRECTCLASS : constant String := "fillrectclass";
GADGETCLASS : constant String := "gadgetclass";
PROPGCLASS : constant String := "propgclass";
STRGCLASS : constant String := "strgclass";
BUTTONGCLASS : constant String := "buttongclass";
FRBUTTONCLASS : constant String := "frbuttonclass";
GROUPGCLASS : constant String := "groupgclass";
ICCLASS : constant String := "icclass";
MODELCLASS : constant String := "modelclass";
OM_Dummy : constant Integer_16 := (16#100#);
OM_NEW : constant Integer_16 := (16#101#);
OM_DISPOSE : constant Integer_16 := (16#102#);
OM_SET : constant Integer_16 := (16#103#);
OM_GET : constant Integer_16 := (16#104#);
OM_ADDTAIL : constant Integer_16 := (16#105#);
OM_REMOVE : constant Integer_16 := (16#106#);
OM_NOTIFY : constant Integer_16 := (16#107#);
OM_UPDATE : constant Integer_16 := (16#108#);
OM_ADDMEMBER : constant Integer_16 := (16#109#);
OM_REMMEMBER : constant Integer_16 := (16#10A#);

type opSet;
type opSet_Ptr is access opSet;
type opSet is record
MethodID : Unsigned_32;
ops_AttrList : TagItem_Ptr;
end record;

type opUpdate;
type opUpdate_Ptr is access opUpdate;
type opUpdate is record
MethodID : Unsigned_32;
opu_AttrList : TagItem_Ptr;
opu_Flags : Unsigned_32;
end record;

OPUF_INTERIM : constant Integer_16 := (2**0);

type opGet;
type opGet_Ptr is access opGet;
type opGet is record
MethodID : Unsigned_32;
opg_AttrID : Unsigned_32;
end record;

type opAddTail;
type opAddTail_Ptr is access opAddTail;
type opAddTail is record
MethodID : Unsigned_32;
opat_List : List_Ptr;
end record;

--opAddMember : constant Integer := opMember;

type opMember;
type opMember_Ptr is access opMember;
type opMember is record
MethodID : Unsigned_32;
opam_Object : Object_Ptr;
end record;

end intuition_classusr;