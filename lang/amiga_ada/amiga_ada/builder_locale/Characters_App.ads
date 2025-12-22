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
with Characters_Locale; use Characters_Locale;


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

Locale_Opened_CA : Boolean := OpenLocaleLibrary(0);

type Chars_Ptr_Array is array ( Positive range <> ) of Chars_Ptr;
STR_CY_sex : constant Chars_Ptr_Array := (
GetCharactersString(MSG_CY_sex0),
GetCharactersString(MSG_CY_sex1),
Null_Ptr);
STR_GR_Register : constant Chars_Ptr_Array := (
GetCharactersString(MSG_GR_Register0),
GetCharactersString(MSG_GR_Register1),
GetCharactersString(MSG_GR_Register2),
GetCharactersString(MSG_GR_Register3),
Null_Ptr);
STR_RA_Race : constant Chars_Ptr_Array := (
GetCharactersString(MSG_RA_Race0),
GetCharactersString(MSG_RA_Race1),
GetCharactersString(MSG_RA_Race2),
GetCharactersString(MSG_RA_Race3),
GetCharactersString(MSG_RA_Race4),
Null_Ptr);
STR_RA_Class : constant Chars_Ptr_Array := (
GetCharactersString(MSG_RA_Class0),
GetCharactersString(MSG_RA_Class1),
GetCharactersString(MSG_RA_Class2),
GetCharactersString(MSG_RA_Class3),
GetCharactersString(MSG_RA_Class4),
GetCharactersString(MSG_RA_Class5),
Null_Ptr);


function Create_Characters_App return Object_Ptr;
procedure Dispose_Characters_App;

private

temp_Object : array (Positive range 1.. 16) of Object_Ptr;

end Characters_App;
