--****************************************************************
--   This file was created automatically by `FlexCat V1.3'
--   Do NOT edit by hand!
--****************************************************************/
with Interfaces; use Interfaces;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with locale; use locale;
with utility_tagitem; use utility_tagitem;

package DviPrintGui_Locale is

Locale_Opened : Boolean := False;

type FC_Type is record
   ID : Integer;
   Str : Chars_Ptr;
end Record;

MSG_AppDescription : FC_Type;
MSG_WI_dviprint : FC_Type;
MSG_TX_label_0 : FC_Type;
MSG_GR_grp_1 : FC_Type;
MSG_LA_label_0 : FC_Type;
MSG_CY_label_00 : FC_Type;
MSG_CY_label_01 : FC_Type;
MSG_STR_label_0 : FC_Type;
MSG_STR_label_1 : FC_Type;
MSG_LA_label_1 : FC_Type;
MSG_LA_label_2 : FC_Type;
MSG_LA_label_3 : FC_Type;
MSG_CY_label_10 : FC_Type;
MSG_CY_label_11 : FC_Type;
MSG_CY_label_12 : FC_Type;
MSG_LA_label_4 : FC_Type;
MSG_CY_label_20 : FC_Type;
MSG_CY_label_21 : FC_Type;
MSG_LA_label_5 : FC_Type;
MSG_CY_label_30 : FC_Type;
MSG_CY_label_31 : FC_Type;
MSG_LA_label_6 : FC_Type;
MSG_CY_label_40 : FC_Type;
MSG_CY_label_41 : FC_Type;
MSG_GR_grp_4 : FC_Type;
MSG_TX_label_1 : FC_Type;
MSG_BT_label_0 : FC_Type;
MSG_BT_label_1 : FC_Type;
MSG_GR_grp_6 : FC_Type;
MSG_BT_label_2 : FC_Type;
MSG_BT_label_3 : FC_Type;
MSG_BT_label_4 : FC_Type;
MSG_BT_label_5 : FC_Type;
MSG_WI_drucker : FC_Type;
MSG_GR_grp_14 : FC_Type;
MSG_GR_grp_15 : FC_Type;
MSG_LA_label_7 : FC_Type;
MSG_CY_label_50 : FC_Type;
MSG_CY_label_51 : FC_Type;
MSG_LA_label_8 : FC_Type;
MSG_CY_label_60 : FC_Type;
MSG_CY_label_61 : FC_Type;
MSG_LA_label_9 : FC_Type;
MSG_CY_label_70 : FC_Type;
MSG_CY_label_71 : FC_Type;
MSG_LA_label_10 : FC_Type;
MSG_CY_label_80 : FC_Type;
MSG_CY_label_81 : FC_Type;
MSG_STR_label_5 : FC_Type;
MSG_STR_label_6 : FC_Type;
MSG_LA_label_11 : FC_Type;
MSG_CY_label_90 : FC_Type;
MSG_CY_label_91 : FC_Type;
MSG_STR_label_7 : FC_Type;
MSG_STR_label_8 : FC_Type;
MSG_BT_label_6 : FC_Type;
MSG_BT_label_7 : FC_Type;

procedure OpenDviPrintGuiCatalog(loc : Locale_Ptr; language : String);
procedure CloseDviPrintGuiCatalog;
function GetDviPrintGuiString(FC : FC_Type) return String;

end DviPrintGui_Locale;
