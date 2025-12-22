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


package MUI_Arc_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_Main : Object_Ptr;
TX_Title : Object_Ptr;
RA_label_0 : Object_Ptr;
LV_volumes : Object_Ptr;
LV_files : Object_Ptr;
STR_filename : Object_Ptr;
BT_Unarchive : Object_Ptr;
BT_Archive : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_TX_Title : constant Chars_Ptr := Allocate_String(""& ESC &"cMUI_Arc");
STR_GR_grp_0 : constant Chars_Ptr_Array := (
Allocate_String("Archiver"),
Allocate_String("Actions"),
Null_Ptr);
STR_RA_label_0 : constant Chars_Ptr_Array := (
Allocate_String("Lha Archiver"),
Allocate_String("Zip Archiver"),
Allocate_String("Zoo Archiver"),
Allocate_String("Dms Archiver"),
Allocate_String("Tar Archiver"),
Null_Ptr);


function Create_MUI_Arc_App return Object_Ptr;
procedure Dispose_MUI_Arc_App;

private

temp_Object : array (Positive range 1.. 12) of Object_Ptr;

end MUI_Arc_App;
