--****************************************************************
--   This file was created automatically by `FlexCat V1.3'
--   Do NOT edit by hand!
--****************************************************************/
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Text_IO; use Text_IO;

with Locale; use Locale;
with utility_tagitem; use utility_tagitem;

package body Characters_Locale is

procedure OpenCharactersCatalog(loc : Locale_Ptr; language : String) is

temp_taglist : TagListType := NewTagList;

begin

  CloseCharactersCatalog;

  if Characters_Catalog = Null_Catalog then
    if language'Length /= 0 then
      AddTag(temp_taglist,OC_Language, Allocate_String(language));
    end if;

    AddTag(temp_taglist,OC_BuiltInLanguage, Characters_BuiltInLanguage );
    AddTag(temp_taglist,OC_Version, Characters_Version);

    Characters_Catalog := OpenCatalogA(loc, Allocate_String("Characters.catalog"), temp_taglist);
  end if;
end OpenCharactersCatalog;

procedure CloseCharactersCatalog is
begin
if Characters_Catalog /= Null_Catalog then
   CloseCatalog(Characters_Catalog);
   Characters_Catalog := Null_Catalog;
end if;
end CloseCharactersCatalog;

function GetCharactersString(FC : FC_Type) return Chars_Ptr is

return_str : Chars_Ptr;

begin
  return_str := GetCatalogStr(Characters_Catalog, FC.ID, Null_Ptr);
  if return_str /= Null_Ptr then
     Put_Line("returning catalog string -->" & Value(return_str));
     return return_str;
  end if;
put_line("returning default string -->" & Value(FC.Str));
return FC.Str;

end GetCharactersString;

begin

   if OpenLocaleLibrary(0) then
      OpenCharactersCatalog(Null_Locale,"");
      if Characters_Catalog = Null_Catalog then
         Put_Line("Failed to open catalog");
      else
         Put_Line("opened catalog");       
      end if;
   else
      Put_Line("Failed to open Locale.library");
   end if;

end Characters_Locale;
