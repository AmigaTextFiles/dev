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


package MUIDemo_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_main : Object_Ptr;
TX_text1 : Object_Ptr;
LV_float1 : Object_Ptr;
BT_group : Object_Ptr;
BT_frames : Object_Ptr;
BT_backfill : Object_Ptr;
BT_notify : Object_Ptr;
BT_listview : Object_Ptr;
BT_cycle : Object_Ptr;
BT_image : Object_Ptr;
BT_string : Object_Ptr;
BT_quit : Object_Ptr;
WI_groups : Object_Ptr;
LV_float2 : Object_Ptr;
GA_vert1 : Object_Ptr;
GA_vert2 : Object_Ptr;
GA_vert3 : Object_Ptr;
GA_horiz1 : Object_Ptr;
GA_horiz2 : Object_Ptr;
GA_horiz3 : Object_Ptr;
GA_array1 : Object_Ptr;
GA_array2 : Object_Ptr;
GA_array3 : Object_Ptr;
GA_array4 : Object_Ptr;
GA_array5 : Object_Ptr;
GA_array6 : Object_Ptr;
GA_array7 : Object_Ptr;
GA_array8 : Object_Ptr;
GA_array9 : Object_Ptr;
BT_25kg : Object_Ptr;
BT_50kg : Object_Ptr;
BT_75kg : Object_Ptr;
BT_100kg : Object_Ptr;
TX_label_1 : Object_Ptr;
TX_label_2 : Object_Ptr;
TX_label_3 : Object_Ptr;
TX_label_4 : Object_Ptr;
TX_label_5 : Object_Ptr;
WI_frames : Object_Ptr;
LV_float3 : Object_Ptr;
TX_button : Object_Ptr;
TX_imagebutton : Object_Ptr;
TX_text : Object_Ptr;
TX_string : Object_Ptr;
TX_readlist : Object_Ptr;
TX_inputlist : Object_Ptr;
TX_prop : Object_Ptr;
TX_group : Object_Ptr;
WI_notify : Object_Ptr;
LV_float4 : Object_Ptr;
GA_connect1 : Object_Ptr;
PR_label_0 : Object_Ptr;
PR_label_1 : Object_Ptr;
SL_label_0 : Object_Ptr;
SL_label_1 : Object_Ptr;
SL_label_2 : Object_Ptr;
GA_label_16 : Object_Ptr;
PR_label_2 : Object_Ptr;
PR_label_3 : Object_Ptr;
GA_label_17 : Object_Ptr;
WI_listviews : Object_Ptr;
LV_float5 : Object_Ptr;
LV_label_5 : Object_Ptr;
LV_label_6 : Object_Ptr;
WI_string : Object_Ptr;
LV_label_7 : Object_Ptr;
LV_label_8 : Object_Ptr;
STR_label_0 : Object_Ptr;
WI_images : Object_Ptr;
LV_label_9 : Object_Ptr;
IM_label_0 : Object_Ptr;
IM_label_1 : Object_Ptr;
IM_label_2 : Object_Ptr;
IM_label_3 : Object_Ptr;
IM_label_4 : Object_Ptr;
IM_label_5 : Object_Ptr;
IM_label_6 : Object_Ptr;
IM_label_7 : Object_Ptr;
IM_label_8 : Object_Ptr;
IM_label_9 : Object_Ptr;
IM_label_35 : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_text1 : constant Chars_Ptr := Allocate_String(""& ESC &"c"& ESC &"8MUI - MagicUserInterface"& Character'VAL(8#012#) &"written 1993 by Stefan Stuntz");
STR_LV_float1 : constant Chars_Ptr := Null_Ptr;
STR_LV_float2 : constant Chars_Ptr := Null_Ptr;
STR_TX_label_1 : constant Chars_Ptr := Allocate_String("fixed");
STR_TX_label_2 : constant Chars_Ptr := Allocate_String(""& ESC &"cfree");
STR_TX_label_3 : constant Chars_Ptr := Allocate_String("fixed");
STR_TX_label_4 : constant Chars_Ptr := Allocate_String(""& ESC &"cfree");
STR_TX_label_5 : constant Chars_Ptr := Allocate_String("fixed");
STR_LV_float3 : constant Chars_Ptr := Null_Ptr;
STR_TX_button : constant Chars_Ptr := Allocate_String(""& ESC &"cButton");
STR_TX_imagebutton : constant Chars_Ptr := Allocate_String(""& ESC &"cImageButton");
STR_TX_text : constant Chars_Ptr := Allocate_String(""& ESC &"cText");
STR_TX_string : constant Chars_Ptr := Allocate_String(""& ESC &"cString");
STR_TX_readlist : constant Chars_Ptr := Allocate_String(""& ESC &"cReadList");
STR_TX_inputlist : constant Chars_Ptr := Allocate_String(""& ESC &"cInputList");
STR_TX_prop : constant Chars_Ptr := Allocate_String(""& ESC &"cProp Gadget");
STR_TX_group : constant Chars_Ptr := Allocate_String(""& ESC &"cGroup");
STR_LV_float4 : constant Chars_Ptr := Null_Ptr;
STR_LV_float5 : constant Chars_Ptr := Null_Ptr;
STR_LV_label_7 : constant Chars_Ptr := Null_Ptr;
STR_LV_label_9 : constant Chars_Ptr := Null_Ptr;


function Create_MUIDemo_App return Object_Ptr;
procedure Dispose_MUIDemo_App;

private

temp_Object : array (Positive range 1.. 63) of Object_Ptr;

end MUIDemo_App;
