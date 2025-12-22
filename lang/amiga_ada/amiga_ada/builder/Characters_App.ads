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


package Characters_App is

ESC : constant Character := Character'VAL(8#033#);

App : Object_Ptr;
WI_Characters : Object_Ptr;
STR_name : Object_Ptr;
CY_sex : Object_Ptr;
RA_Race : Object_Ptr;
RA_Class : Object_Ptr;
CH_cloak : Object_Ptr;
CH_shield : Object_Ptr;
CH_gloves : Object_Ptr;
CH_helmet : Object_Ptr;
SL_experience : Object_Ptr;
SL_strength : Object_Ptr;
SL_dexterity : Object_Ptr;
SL_condition : Object_Ptr;
SL_intelligence : Object_Ptr;

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_CY_sex : constant Chars_Ptr_Array := (
Allocate_String("female"),
Allocate_String("male"),
Null_Ptr);
STR_GR_Register : constant Chars_Ptr_Array := (
Allocate_String("Race"),
Allocate_String("Class"),
Allocate_String("Armor"),
Allocate_String("Level"),
Null_Ptr);
STR_RA_Race : constant Chars_Ptr_Array := (
Allocate_String("Human"),
Allocate_String("Elf"),
Allocate_String("Dwarf"),
Allocate_String("Hobbit"),
Allocate_String("Gnome"),
Null_Ptr);
STR_RA_Class : constant Chars_Ptr_Array := (
Allocate_String("Warrior"),
Allocate_String("Rogue"),
Allocate_String("Bard"),
Allocate_String("Monk"),
Allocate_String("Magician"),
Allocate_String("Archmage"),
Null_Ptr);


function Create_Characters_App return Object_Ptr;
procedure Dispose_Characters_App;

private

temp_Object : array (Positive range 1.. 16) of Object_Ptr;

end Characters_App;
