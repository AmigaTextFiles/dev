--****************************************************************
--   This file was created automatically by `FlexCat V1.3'
--   Do NOT edit by hand!
--****************************************************************/
with Interfaces; use Interfaces;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with locale; use locale;
with utility_tagitem; use utility_tagitem;

package Click_Locale is

Locale_Opened : Boolean := False;

type FC_Type is record
   ID : Integer;
   Str : Chars_Ptr;
end Record;

MSG_AppDescription : FC_Type;
MSG_WI_try : FC_Type;
MSG_TX_label_0 : FC_Type;
MSG_BT_1stbutton : FC_Type;
MSG_BT_2ndbutton : FC_Type;
MSG_BT_3rdbutton : FC_Type;

procedure OpenClickCatalog(loc : Locale_Ptr; language : String);
procedure CloseClickCatalog;
function GetClickString(FC : FC_Type) return String;

end Click_Locale;
