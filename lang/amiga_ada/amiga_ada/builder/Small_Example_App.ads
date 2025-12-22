with System; use System;
with Interfaces; use Interfaces;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Text_IO; use Text_IO;

with amiga; use amiga;
with amiga_lib; use amiga_lib;
with utility_TagItem; use utility_TagItem; 
with exec_exec; use exec_exec;
with intuition_classusr; use intuition_classusr;
with intuition_Intuition; use intuition_Intuition;
with Incomplete_Type; use Incomplete_Type;

with mui; use mui;


package Small_Example_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_smallexample : Object_Ptr;
GROUP_ROOT_0 : Object_Ptr;
GR_lists : Object_Ptr;
LV_label_0 : Object_Ptr;
LV_label_1 : Object_Ptr;
GR_grp_1 : Object_Ptr;
BT_ok : Object_Ptr;
BT_cancel : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;


function Create_Small_Example_App return Object_Ptr;
procedure Dispose_Small_Example_App;

private

temp_Object : array (Positive range 1.. 2) of Object_Ptr;

end Small_Example_App;
