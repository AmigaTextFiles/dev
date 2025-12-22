--****************************************************************
--   This file was created automatically by `FlexCat V1.3'
--   Do NOT edit by hand!
--****************************************************************/
with Interfaces; use Interfaces;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with locale; use locale;
with utility_tagitem; use utility_tagitem;

with amiga; use amiga;

package Characters_Locale is

Characters_Version : Integer := 0;
Characters_BuiltInLanguage : Chars_Ptr := Allocate_String("english");
Characters_Catalog : Catalog_Ptr := Null_Catalog;

type FC_Type is record
   ID : Integer;
   Str : Chars_Ptr;
end Record;

MSG_AppDescription : FC_Type := ( 0, Allocate_String("Just an example !!") );
MSG_WI_Characters : FC_Type := ( 1, Allocate_String("Characters") );
MSG_LA_label_0 : FC_Type := ( 2, Allocate_String("Name") );
MSG_LA_label_1 : FC_Type := ( 3, Allocate_String("Sex") );
MSG_CY_sex0 : FC_Type := ( 4, Allocate_String("female") );
MSG_CY_sex1 : FC_Type := ( 5, Allocate_String("male") );
MSG_GR_Register0 : FC_Type := ( 6, Allocate_String("Race") );
MSG_GR_Register1 : FC_Type := ( 7, Allocate_String("Class") );
MSG_GR_Register2 : FC_Type := ( 8, Allocate_String("Armor") );
MSG_GR_Register3 : FC_Type := ( 9, Allocate_String("Level") );
MSG_RA_Race : FC_Type := ( 10, Allocate_String("Race") );
MSG_RA_Race0 : FC_Type := ( 11, Allocate_String("Human") );
MSG_RA_Race1 : FC_Type := ( 12, Allocate_String("Elf") );
MSG_RA_Race2 : FC_Type := ( 13, Allocate_String("Dwarf") );
MSG_RA_Race3 : FC_Type := ( 14, Allocate_String("Hobbit") );
MSG_RA_Race4 : FC_Type := ( 15, Allocate_String("Gnome") );
MSG_RA_Class : FC_Type := ( 16, Allocate_String("Class") );
MSG_RA_Class0 : FC_Type := ( 17, Allocate_String("Warrior") );
MSG_RA_Class1 : FC_Type := ( 18, Allocate_String("Rogue") );
MSG_RA_Class2 : FC_Type := ( 19, Allocate_String("Bard") );
MSG_RA_Class3 : FC_Type := ( 20, Allocate_String("Monk") );
MSG_RA_Class4 : FC_Type := ( 21, Allocate_String("Magician") );
MSG_RA_Class5 : FC_Type := ( 22, Allocate_String("Archmage") );
MSG_GR_Armor : FC_Type := ( 23, Allocate_String("Armor") );
MSG_LA_cloak : FC_Type := ( 24, Allocate_String("Cloak") );
MSG_LA_shield : FC_Type := ( 25, Allocate_String("Shield") );
MSG_LA_gloves : FC_Type := ( 26, Allocate_String("Gloves") );
MSG_LA_helmet : FC_Type := ( 27, Allocate_String("Helmet") );
MSG_GR_Level : FC_Type := ( 28, Allocate_String("Level") );
MSG_LA_experience : FC_Type := ( 29, Allocate_String("Experience") );
MSG_LA_strength : FC_Type := ( 30, Allocate_String("Strength") );
MSG_LA_dexterity : FC_Type := ( 31, Allocate_String("Dexterity") );
MSG_LA_condition : FC_Type := ( 32, Allocate_String("Condition") );
MSG_LA_intelligence : FC_Type := ( 33, Allocate_String("Intelligence") );

procedure OpenCharactersCatalog(loc : Locale_Ptr; language : String);
procedure CloseCharactersCatalog;
function GetCharactersString(FC : FC_Type) return Chars_Ptr;

end Characters_Locale;
