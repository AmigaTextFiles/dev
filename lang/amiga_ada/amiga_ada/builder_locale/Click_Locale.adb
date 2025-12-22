--****************************************************************
--   This file was created automatically by `FlexCat V1.3'
--   Do NOT edit by hand!
--****************************************************************/
with Text_IO; use Text_IO;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with amiga; use amiga;
with Locale; use Locale;
with utility_tagitem; use utility_tagitem;

package body Click_Locale is

Click_Version : Integer := 0;
Click_BuiltInLanguage : Chars_Ptr := Allocate_String("english");

Click_Catalog : Catalog_Ptr := Null_Catalog;

procedure OpenClickCatalog(loc : Locale_Ptr; language : String) is

temp_taglist : TagListType := NewTagList;

begin

if Locale_Opened then
  CloseClickCatalog;

  AddTag(temp_taglist,OC_BuiltInLanguage, Click_BuiltInLanguage );

  if Click_Catalog = Null_Catalog then
    if language'Length /= 0 then
      AddTag(temp_taglist,OC_Language, Allocate_String(language));
    end if;

    AddTag(temp_taglist,OC_Version, Click_Version);

    Click_Catalog := OpenCatalogA(loc, Allocate_String("Click.catalog"), temp_taglist);
  end if;
end if;

MSG_AppDescription := ( 0, Allocate_String("just a demo !!!") );
MSG_WI_try := ( 1, Allocate_String("Click !!!") );
MSG_TX_label_0 := ( 2, Allocate_String("\0338\033cClick on buttons") );
MSG_BT_1stbutton := ( 3, Allocate_String("_1 Button 1") );
MSG_BT_2ndbutton := ( 4, Allocate_String("_2 Button 2") );
MSG_BT_3rdbutton := ( 5, Allocate_String("_3 Button 3") );

end OpenClickCatalog;

procedure CloseClickCatalog is
begin
if Locale_Opened and then Click_Catalog /= Null_Catalog then
 CloseCatalog(Click_Catalog);
 Click_Catalog := Null_Catalog;
end if;
end CloseClickCatalog;

function GetClickString(FC : FC_Type) return String is

return_str : Chars_Ptr;

begin
if Locale_Opened then
  return_str := GetCatalogStr(Click_Catalog, FC.ID, FC.Str);
  if return_str /= Null_Ptr then
     return Value(return_str);
  end if;
end if;

return Value(FC.Str);

end GetClickString;

begin
   if OpenLocaleLibrary(0) then
      Locale_Opened := True;
      OpenClickCatalog(Null_Locale,"");
      if Click_Catalog = Null_Catalog then
         Put_Line("Failed to open catalog");
      end if;
   else
      Put_Line("Failed to open Locale.library");
   end if;

end Click_Locale;
