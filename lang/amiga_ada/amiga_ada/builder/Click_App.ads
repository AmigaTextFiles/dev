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


package Click_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_try : Object_Ptr;
TX_label_0 : Object_Ptr;
BT_1stbutton : Object_Ptr;
BT_2ndbutton : Object_Ptr;
BT_3rdbutton : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_label_0 : constant Chars_Ptr := Allocate_String(""& ESC &"8"& ESC &"cClick on buttons");


function Create_Click_App return Object_Ptr;
procedure Dispose_Click_App;

private

temp_Object : array (Positive range 1.. 2) of Object_Ptr;

end Click_App;
