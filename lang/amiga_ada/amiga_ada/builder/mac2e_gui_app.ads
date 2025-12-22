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


package Mac2E_GUI_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_main : Object_Ptr;
TX_label_0 : Object_Ptr;
STR_label_3 : Object_Ptr;
IM_label_2 : Object_Ptr;
STR_label_4 : Object_Ptr;
IM_label_3 : Object_Ptr;
STR_label_0 : Object_Ptr;
IM_label_0 : Object_Ptr;
STR_label_1 : Object_Ptr;
IM_label_1 : Object_Ptr;
BT_mac2e : Object_Ptr;
BT_E : Object_Ptr;
BT_quit : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_label_0 : constant Chars_Ptr := Allocate_String(""& ESC &"c"& ESC &"8Mac2E"& Character'VAL(8#012#) &"Graphic User Interface");


function Create_Mac2E_GUI_App return Object_Ptr;
procedure Dispose_Mac2E_GUI_App;

private

temp_Object : array (Positive range 1.. 8) of Object_Ptr;

end Mac2E_GUI_App;
