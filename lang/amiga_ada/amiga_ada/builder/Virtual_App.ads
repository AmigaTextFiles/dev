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


package Virtual_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_Virtual : Object_Ptr;
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
LV_label_0 : Object_Ptr;
LV_label_1 : Object_Ptr;
BT_ok : Object_Ptr;
BT_cancel : Object_Ptr;
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
WI_readme : Object_Ptr;
TX_label_3 : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_label_2 : constant Chars_Ptr := Null_Ptr;
STR_CY_label_5 : constant Chars_Ptr_Array := (
Allocate_String("ausf?hren"),
Allocate_String("unterdr?cken"),
Null_Ptr);
STR_CY_label_6 : constant Chars_Ptr_Array := (
Allocate_String("Hin und her"),
Allocate_String("nur hin"),
Null_Ptr);
STR_CY_label_7 : constant Chars_Ptr_Array := (
Allocate_String("normal"),
Allocate_String("schnell"),
Null_Ptr);
STR_CY_label_8 : constant Chars_Ptr_Array := (
Allocate_String("des DVI-Files"),
Allocate_String("Vorab Definition"),
Null_Ptr);
STR_CY_label_9 : constant Chars_Ptr_Array := (
Allocate_String("des Druckers"),
Allocate_String("Spezielle"),
Null_Ptr);
STR_TX_label_0 : constant Chars_Ptr := Allocate_String(""& ESC &"0"& ESC &"c"& ESC &""& Character'VAL(8#012#) &""& Character'VAL(8#012#) &""& Character'VAL(8#033#) &"8Auteur:"& Character'VAL(8#012#) &""& Character'VAL(8#012#) &""& Character'VAL(8#033#) &"bGael Marziou"& Character'VAL(8#033#) &"n");
STR_TX_label_0 : constant Chars_Ptr := Allocate_String(""& Character'VAL(8#033#) &"c"& Character'VAL(8#033#) &"8Mac2E"& Character'VAL(8#012#) &"Graphic User Interface");
STR_TX_label_3 : constant Chars_Ptr := Allocate_String(""& Character'VAL(8#033#) &"cThis example was designed to show :"& Character'VAL(8#012#) &"Virtual groups"& Character'VAL(8#012#) &"the 'power' of tmp-list"& Character'VAL(8#012#) &"the multiply defined error"& Character'VAL(8#012#) &"( press code in the main window)"& Character'VAL(8#012#) &""& Character'VAL(8#012#) &""& Character'VAL(8#033#) &"bEric Totel");


function Create_Virtual_App return Object_Ptr;
procedure Dispose_Virtual_App;

private

temp_Object : array (Positive range 1.. 74) of Object_Ptr;

end Virtual_App;
