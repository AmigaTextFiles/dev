--****************************************************************
--   This file was created automatically by `FlexCat V1.3'
--   Do NOT edit by hand!
--****************************************************************/
with Text_IO; use Text_IO;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with amiga; use amiga;
with Locale; use Locale;
with utility_tagitem; use utility_tagitem;

package body DviPrintGui_Locale is

DviPrintGui_Version : Integer := 0;
DviPrintGui_BuiltInLanguage : Chars_Ptr := Allocate_String("english");

DviPrintGui_Catalog : Catalog_Ptr := Null_Catalog;

procedure OpenDviPrintGuiCatalog(loc : Locale_Ptr; language : String) is

temp_taglist : TagListType := NewTagList;

begin

if Locale_Opened then
  CloseDviPrintGuiCatalog;

  AddTag(temp_taglist,OC_BuiltInLanguage, DviPrintGui_BuiltInLanguage );

  if DviPrintGui_Catalog = Null_Catalog then
    if language'Length /= 0 then
      AddTag(temp_taglist,OC_Language, Allocate_String(language));
    end if;

    AddTag(temp_taglist,OC_Version, DviPrintGui_Version);

    DviPrintGui_Catalog := OpenCatalogA(loc, Allocate_String("DviPrintGui.catalog"), temp_taglist);
  end if;
end if;

MSG_AppDescription := ( 0, Allocate_String("Just a demo !!!") );
MSG_WI_dviprint := ( 1, Allocate_String("DVIprint MUI-Demo") );
MSG_TX_label_0 := ( 2, Allocate_String("\033c\033b\0338DVIprint - Pastex\033n\nwritten 1993 by Georg Heßmann\n(non functionnal, only a MUI demo)") );
MSG_GR_grp_1 := ( 3, Allocate_String("Ausdruck") );
MSG_LA_label_0 := ( 4, Allocate_String("Drucke Seiten") );
MSG_CY_label_00 := ( 5, Allocate_String("Alle") );
MSG_CY_label_01 := ( 6, Allocate_String("Von/Bis") );
MSG_STR_label_0 := ( 7, Allocate_String("von:") );
MSG_STR_label_1 := ( 8, Allocate_String("bis") );
MSG_LA_label_1 := ( 9, Allocate_String("Anzahl Seiten:") );
MSG_LA_label_2 := ( 10, Allocate_String("Anzahl Kopien:") );
MSG_LA_label_3 := ( 11, Allocate_String("Seiten drucken") );
MSG_CY_label_10 := ( 12, Allocate_String("durchgehend") );
MSG_CY_label_11 := ( 13, Allocate_String("gerade Seiten") );
MSG_CY_label_12 := ( 14, Allocate_String("ungerade Seiten") );
MSG_LA_label_4 := ( 15, Allocate_String("Reihenfolge") );
MSG_CY_label_20 := ( 16, Allocate_String("vorwärts") );
MSG_CY_label_21 := ( 17, Allocate_String("ruckwärts") );
MSG_LA_label_5 := ( 18, Allocate_String("Seitenmodus") );
MSG_CY_label_30 := ( 19, Allocate_String("logisch") );
MSG_CY_label_31 := ( 20, Allocate_String("physicalisch") );
MSG_LA_label_6 := ( 21, Allocate_String("Orientierung") );
MSG_CY_label_40 := ( 22, Allocate_String("Hochformat") );
MSG_CY_label_41 := ( 23, Allocate_String("Querformat") );
MSG_GR_grp_4 := ( 24, Allocate_String("Einstellung") );
MSG_TX_label_1 := ( 25, Allocate_String("\033c\033bDeskjet 300 DPI\033n") );
MSG_BT_label_0 := ( 26, Allocate_String("_e Drucker") );
MSG_BT_label_1 := ( 27, Allocate_String("_g Sonstiges") );
MSG_GR_grp_6 := ( 28, Allocate_String("DVI-File") );
MSG_BT_label_2 := ( 29, Allocate_String("_m Mutter") );
MSG_BT_label_3 := ( 30, Allocate_String("_s Speichern") );
MSG_BT_label_4 := ( 31, Allocate_String("_d Drucken") );
MSG_BT_label_5 := ( 32, Allocate_String("_a Abbrechen") );
MSG_WI_drucker := ( 33, Allocate_String("drucker") );
MSG_GR_grp_14 := ( 34, Allocate_String("Drucker") );
MSG_GR_grp_15 := ( 35, Allocate_String("Sonstiges Parameter") );
MSG_LA_label_7 := ( 36, Allocate_String("FormFeed") );
MSG_CY_label_50 := ( 37, Allocate_String("ausführen") );
MSG_CY_label_51 := ( 38, Allocate_String("unterdrücken") );
MSG_LA_label_8 := ( 39, Allocate_String("Druck Richtung") );
MSG_CY_label_60 := ( 40, Allocate_String("Hin und her") );
MSG_CY_label_61 := ( 41, Allocate_String("nur hin") );
MSG_LA_label_9 := ( 42, Allocate_String("Device Nodus") );
MSG_CY_label_70 := ( 43, Allocate_String("normal") );
MSG_CY_label_71 := ( 44, Allocate_String("schnell") );
MSG_LA_label_10 := ( 45, Allocate_String("Seitengröße") );
MSG_CY_label_80 := ( 46, Allocate_String("des DVI-Files") );
MSG_CY_label_81 := ( 47, Allocate_String("Vorab Definition") );
MSG_STR_label_5 := ( 48, Allocate_String("H:") );
MSG_STR_label_6 := ( 49, Allocate_String("V:") );
MSG_LA_label_11 := ( 50, Allocate_String("Auflösung") );
MSG_CY_label_90 := ( 51, Allocate_String("des Druckers") );
MSG_CY_label_91 := ( 52, Allocate_String("Spezielle") );
MSG_STR_label_7 := ( 53, Allocate_String("H:") );
MSG_STR_label_8 := ( 54, Allocate_String("V:") );
MSG_BT_label_6 := ( 55, Allocate_String("_u Benutzen") );
MSG_BT_label_7 := ( 56, Allocate_String("_a Abbrechen") );

end OpenDviPrintGuiCatalog;

procedure CloseDviPrintGuiCatalog is
begin
if Locale_Opened and then DviPrintGui_Catalog /= Null_Catalog then
 CloseCatalog(DviPrintGui_Catalog);
 DviPrintGui_Catalog := Null_Catalog;
end if;
end CloseDviPrintGuiCatalog;

function GetDviPrintGuiString(FC : FC_Type) return String is

return_str : Chars_Ptr;

begin
if Locale_Opened then
  return_str := GetCatalogStr(DviPrintGui_Catalog, FC.ID, FC.Str);
  if return_str /= Null_Ptr then
     return Value(return_str);
  end if;
end if;

return Value(FC.Str);

end GetDviPrintGuiString;

begin
   if OpenLocaleLibrary(0) then
      Locale_Opened := True;
      OpenDviPrintGuiCatalog(Null_Locale,"");
      if DviPrintGui_Catalog = Null_Catalog then
         Put_Line("Failed to open catalog");
      end if;
   else
      Put_Line("Failed to open Locale.library");
   end if;

end DviPrintGui_Locale;
