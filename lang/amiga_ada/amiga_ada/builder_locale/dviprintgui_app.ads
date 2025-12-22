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

with Locale; use Locale;
with DviPrintGui_Locale; use DviPrintGui_Locale;


package DviPrintGui_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_dviprint : Object_Ptr;
TX_label_0 : Object_Ptr;
CY_label_0 : Object_Ptr;
STR_label_0 : Object_Ptr;
STR_label_1 : Object_Ptr;
STR_label_2 : Object_Ptr;
STR_label_3 : Object_Ptr;
CY_label_1 : Object_Ptr;
CY_label_2 : Object_Ptr;
CY_label_3 : Object_Ptr;
CY_label_4 : Object_Ptr;
TX_label_1 : Object_Ptr;
BT_label_0 : Object_Ptr;
BT_label_1 : Object_Ptr;
LV_label_0 : Object_Ptr;
LV_label_1 : Object_Ptr;
BT_label_2 : Object_Ptr;
STR_label_4 : Object_Ptr;
IM_label_0 : Object_Ptr;
BT_label_3 : Object_Ptr;
BT_label_4 : Object_Ptr;
BT_label_5 : Object_Ptr;
WI_drucker : Object_Ptr;
LV_label_2 : Object_Ptr;
TX_label_2 : Object_Ptr;
CY_label_5 : Object_Ptr;
CY_label_6 : Object_Ptr;
CY_label_7 : Object_Ptr;
CY_label_8 : Object_Ptr;
STR_label_5 : Object_Ptr;
STR_label_6 : Object_Ptr;
CY_label_9 : Object_Ptr;
STR_label_7 : Object_Ptr;
STR_label_8 : Object_Ptr;
BT_label_6 : Object_Ptr;
BT_label_7 : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_label_0 : Chars_Ptr;
STR_CY_label_0 :  Chars_Ptr_Array(1..         3);
STR_CY_label_1 :  Chars_Ptr_Array(1..         4);
STR_CY_label_2 :  Chars_Ptr_Array(1..         3);
STR_CY_label_3 :  Chars_Ptr_Array(1..         3);
STR_CY_label_4 :  Chars_Ptr_Array(1..         3);
STR_TX_label_1 : Chars_Ptr;
STR_TX_label_2 : Chars_Ptr;
STR_CY_label_5 :  Chars_Ptr_Array(1..         3);
STR_CY_label_6 :  Chars_Ptr_Array(1..         3);
STR_CY_label_7 :  Chars_Ptr_Array(1..         3);
STR_CY_label_8 :  Chars_Ptr_Array(1..         3);
STR_CY_label_9 :  Chars_Ptr_Array(1..         3);

function Create_DviPrintGui_App return Object_Ptr;
procedure Dispose_DviPrintGui_App;

private

temp_Object : array (Positive range 1.. 54) of Object_Ptr;

end DviPrintGui_App;
