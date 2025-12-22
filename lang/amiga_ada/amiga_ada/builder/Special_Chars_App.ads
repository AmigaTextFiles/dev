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


package Special_Chars_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_SpecialChars : Object_Ptr;
BT_label_0 : Object_Ptr;
BT_label_1 : Object_Ptr;
BT_label_2 : Object_Ptr;
BT_label_3 : Object_Ptr;
TX_label_0 : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_label_0 : constant Chars_Ptr := Allocate_String(""& ESC &"c"& ESC &"iwith the special characters"& Character'VAL(8#012#) &""& ESC &"byou will be able"& Character'VAL(8#012#) &""& ESC &"8"& ESC &"n"& ESC &"bto do what you want !!!");


function Create_Special_Chars_App return Object_Ptr;
procedure Dispose_Special_Chars_App;

private

temp_Object : array (Positive range 1.. 2) of Object_Ptr;

end Special_Chars_App;
