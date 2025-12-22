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


package Yak_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_Main : Object_Ptr;
CH_label_0 : Object_Ptr;
CH_label_1 : Object_Ptr;
CH_label_2 : Object_Ptr;
CH_label_3 : Object_Ptr;
CH_label_4 : Object_Ptr;
CH_label_5 : Object_Ptr;
CH_label_6 : Object_Ptr;
CH_label_7 : Object_Ptr;
CH_label_8 : Object_Ptr;
CH_label_9 : Object_Ptr;
CH_label_10 : Object_Ptr;
STR_label_0 : Object_Ptr;
STR_label_1 : Object_Ptr;
TX_label_0 : Object_Ptr;
STR_label_2 : Object_Ptr;
STR_label_10 : Object_Ptr;
STR_label_3 : Object_Ptr;
STR_label_4 : Object_Ptr;
BT_label_0 : Object_Ptr;
BT_label_1 : Object_Ptr;
BT_label_2 : Object_Ptr;
BT_label_3 : Object_Ptr;
WI_divers : Object_Ptr;
CY_label_0 : Object_Ptr;
SL_volume : Object_Ptr;
STR_label_18 : Object_Ptr;
BT_label_8 : Object_Ptr;
WI_touches : Object_Ptr;
LV_label_0 : Object_Ptr;
LV_label_1 : Object_Ptr;
STR_label_19 : Object_Ptr;
BT_label_9 : Object_Ptr;
BT_label_10 : Object_Ptr;
STR_label_20 : Object_Ptr;
CY_label_1 : Object_Ptr;
BT_label_11 : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_label_0 : constant Chars_Ptr := Allocate_String(""& ESC &"0"& ESC &"cYAK"& Character'VAL(8#012#) &""& Character'VAL(8#012#) &""& Character'VAL(8#033#) &"8Auteur:"& Character'VAL(8#012#) &""& Character'VAL(8#012#) &""& Character'VAL(8#033#) &"bGael Marziou"& Character'VAL(8#033#) &"n");
STR_CY_label_0 : constant Chars_Ptr_Array := (
Allocate_String("Par les Sprites"),
Allocate_String("Par le copper"),
Allocate_String("Non"),
Null_Ptr);
STR_CY_label_1 : constant Chars_Ptr_Array := (
Allocate_String("Ne pas changer d'?cran"),
Allocate_String("Changer d'?cran"),
Null_Ptr);


function Create_Yak_App return Object_Ptr;
procedure Dispose_Yak_App;

private

temp_Object : array (Positive range 1.. 47) of Object_Ptr;

end Yak_App;
