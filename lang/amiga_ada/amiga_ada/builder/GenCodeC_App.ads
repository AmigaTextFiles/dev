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


package GenCodeC_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_GenCodeC : Object_Ptr;
TX_Text : Object_Ptr;
CH_normal : Object_Ptr;
CH_modular : Object_Ptr;
CH_indentation : Object_Ptr;
LV_includes : Object_Ptr;
STR_include : Object_Ptr;
IM_getfile : Object_Ptr;
STR_filename : Object_Ptr;
STR_procedurename : Object_Ptr;
STR_tab : Object_Ptr;
BT_ok : Object_Ptr;
BT_Cancel : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_Text : constant Chars_Ptr := Allocate_String(""& ESC &"c"& ESC &"8MUIBuilder C-Code Generation"& Character'VAL(8#012#) &"Written by Eric Totel");


function Create_GenCodeC_App return Object_Ptr;
procedure Dispose_GenCodeC_App;

private

temp_Object : array (Positive range 1.. 16) of Object_Ptr;

end GenCodeC_App;
