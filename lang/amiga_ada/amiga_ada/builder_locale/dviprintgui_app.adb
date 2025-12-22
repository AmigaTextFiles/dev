with System; use System;
with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;
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
with DviPrintGui_Locale; use DviPrintGui_Locale;

package body DviPrintGui_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


function Fix_Back_Slash_String( str : in String ) return String is

function Octal_Str_to_Integer(str : in String) return integer is
begin
   return (Character'POS(str(str'First)) - Character'POS('0')) * 64 +
          (Character'POS(str(str'First + 1)) - Character'POS('0')) * 8  +
          (Character'POS(str(str'First + 2)) - Character'POS('0'));
end Octal_Str_to_Integer;

temp_string : String(1..400);
offset : integer := 0;
i :integer := str'First;

begin
while i <= str'Last loop
   if str(i) /= Character'VAL(92) then
      temp_string(i+ offset) := str(i);
   else
      if i + 1 <= str'Last and then str(i+1) = 'n' then
         temp_string(i+offset) := Character'VAL(8#012#);
         i := i + 1;
         offset := offset -1;
      elsif i + 3 <= str'Last then
         temp_string(i+offset) := Character'VAL(Octal_Str_to_Integer(str(i+1..i+3)));
         i := i + 3;
         offset := offset - 3;
      end if;
   end if;
   i := i+1;
end loop;

return temp_string(1..i+offset-1);
end Fix_Back_Slash_String;

function String_Value( Item : in Chars_Ptr ) return String is
begin
   return Value(Item);
end String_Value;

function Char_Array_Value( Item : in Chars_Ptr ) return Char_Array is
begin
   return Value(Item);
end Char_Array_Value;

temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
procedure Init_Strings is
begin
STR_TX_label_0 := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_TX_label_0)));
STR_CY_label_0( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_00)));
STR_CY_label_0( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_01)));
STR_CY_label_0( 3) := Null_Ptr;
STR_CY_label_1( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_10)));
STR_CY_label_1( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_11)));
STR_CY_label_1( 3) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_12)));
STR_CY_label_1( 4) := Null_Ptr;
STR_CY_label_2( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_20)));
STR_CY_label_2( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_21)));
STR_CY_label_2( 3) := Null_Ptr;
STR_CY_label_3( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_30)));
STR_CY_label_3( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_31)));
STR_CY_label_3( 3) := Null_Ptr;
STR_CY_label_4( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_40)));
STR_CY_label_4( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_41)));
STR_CY_label_4( 3) := Null_Ptr;
STR_TX_label_1 := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_TX_label_1)));
STR_TX_label_2 := Null_Ptr;
STR_CY_label_5( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_50)));
STR_CY_label_5( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_51)));
STR_CY_label_5( 3) := Null_Ptr;
STR_CY_label_6( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_60)));
STR_CY_label_6( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_61)));
STR_CY_label_6( 3) := Null_Ptr;
STR_CY_label_7( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_70)));
STR_CY_label_7( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_71)));
STR_CY_label_7( 3) := Null_Ptr;
STR_CY_label_8( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_80)));
STR_CY_label_8( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_81)));
STR_CY_label_8( 3) := Null_Ptr;
STR_CY_label_9( 1) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_90)));
STR_CY_label_9( 2) := Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_CY_label_91)));
STR_CY_label_9( 3) := Null_Ptr;
end Init_Strings;

function Create_DviPrintGui_App return Object_Ptr is
begin
Init_Strings;


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(131));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_0);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_label_0 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_0))));
temp_Object( 4) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_0'Address);
CY_label_0 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 5) := MUI_NewObjectA(MUIC_Rectangle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_STR_label_0))));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 8) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_0 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 8));
AddTag(temp_TagList,MUIA_Group_Child,STR_label_0);
temp_Object( 7) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_STR_label_1))));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 10) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_1 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 10));
AddTag(temp_TagList,MUIA_Group_Child,STR_label_1);
temp_Object( 9) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 7));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 9));
temp_Object( 6) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_1))));
temp_Object( 11) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_Weight,Unsigned_32(0));
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_2 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_2))));
temp_Object( 12) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_3 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_3))));
temp_Object( 13) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_1'Address);
CY_label_1 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_4))));
temp_Object( 14) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_2'Address);
CY_label_2 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_5))));
temp_Object( 15) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_3'Address);
CY_label_3 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_6))));
temp_Object( 16) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_4'Address);
CY_label_4 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 17) := MUI_NewObjectA(MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 18) := MUI_NewObjectA(MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_GR_grp_1))));
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 4));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_0);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 5));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 6));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 11));
AddTag(temp_TagList,MUIA_Group_Child,STR_label_2);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 12));
AddTag(temp_TagList,MUIA_Group_Child,STR_label_3);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 13));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_1);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 14));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_2);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 15));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_3);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 16));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_4);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 17));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 18));
temp_Object( 3) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_1);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_label_1 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_0))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_0)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_0))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_0))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_0 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_1))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_1)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_1))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_1))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_1 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,BT_label_0);
AddTag(temp_TagList,MUIA_Group_Child,BT_label_1);
temp_Object( 21) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_GR_grp_4))));
AddTag(temp_TagList,MUIA_Group_Child,TX_label_1);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 21));
temp_Object( 20) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList);
AddTag(temp_TagList,MUIA_Dirlist_Directory,Allocate_String("progdir:"));
AddTag(temp_TagList,MUIA_Dirlist_DrawersOnly,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_FilesOnly,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_FilterDrawers,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_MultiSelDirs,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_RejectIcons,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_SortDirs,MUIV_Dirlist_SortDirs_First);
AddTag(temp_TagList,MUIA_Dirlist_SortHighLow,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_SortType,Unsigned_32(0));
temp_Object( 24) := MUI_NewObjectA(MUIC_Dirlist,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 24));
LV_label_0 := MUI_NewObjectA(MUIC_Listview,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList);
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 26) := MUI_NewObjectA(MUIC_Volumelist,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 26));
LV_label_1 := MUI_NewObjectA(MUIC_Listview,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_2))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_2)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_2))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_2))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_2 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child,LV_label_1);
AddTag(temp_TagList,MUIA_Group_Child,BT_label_2);
temp_Object( 25) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,LV_label_0);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 25));
temp_Object( 23) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_String_Contents,Allocate_String("Work:MUI/Demos"));
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_4 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
IM_label_0 := MUI_NewObjectA(MUIC_Image,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,STR_label_4);
AddTag(temp_TagList,MUIA_Group_Child,IM_label_0);
temp_Object( 27) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_GR_grp_6))));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 23));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 27));
temp_Object( 22) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 20));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 22));
temp_Object( 19) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 3));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 19));
temp_Object( 2) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_3))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_3)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_3))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_3))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_3 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 29) := MUI_NewObjectA(MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_4))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_4)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_4))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_4))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_4 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 30) := MUI_NewObjectA(MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_5))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_5)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_5))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_5))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_5 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,BT_label_3);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 29));
AddTag(temp_TagList,MUIA_Group_Child,BT_label_4);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 30));
AddTag(temp_TagList,MUIA_Group_Child,BT_label_5);
temp_Object( 28) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child,TX_label_0);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 28));
temp_Object( 1) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_WI_dviprint))));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N'));
AddTag(temp_TagList,MUIA_Window_RootObject,temp_Object( 1));
WI_dviprint := MUI_NewObjectA(MUIC_Window,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList);
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 34) := MUI_NewObjectA(MUIC_List,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 34));
LV_label_2 := MUI_NewObjectA(MUIC_Listview,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_2);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_label_2 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_GR_grp_14))));
AddTag(temp_TagList,MUIA_Group_Child,LV_label_2);
AddTag(temp_TagList,MUIA_Group_Child,TX_label_2);
temp_Object( 33) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_7))));
temp_Object( 36) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_5'Address);
CY_label_5 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_8))));
temp_Object( 37) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_6'Address);
CY_label_6 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_9))));
temp_Object( 38) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_7'Address);
CY_label_7 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_10))));
temp_Object( 39) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_8'Address);
CY_label_8 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 40) := MUI_NewObjectA(MUIC_Rectangle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_STR_label_5))));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 43) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_5 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 43));
AddTag(temp_TagList,MUIA_Group_Child,STR_label_5);
temp_Object( 42) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_STR_label_6))));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 45) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_6 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 45));
AddTag(temp_TagList,MUIA_Group_Child,STR_label_6);
temp_Object( 44) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 42));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 44));
temp_Object( 41) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_LA_label_11))));
temp_Object( 46) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_9'Address);
CY_label_9 := MUI_NewObjectA(MUIC_Cycle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 47) := MUI_NewObjectA(MUIC_Rectangle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_STR_label_7))));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 50) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_7 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 50));
AddTag(temp_TagList,MUIA_Group_Child,STR_label_7);
temp_Object( 49) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_STR_label_8))));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 52) := MUI_MakeObjectA(MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String);
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_8 := MUI_NewObjectA(MUIC_String,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 52));
AddTag(temp_TagList,MUIA_Group_Child,STR_label_8);
temp_Object( 51) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 49));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 51));
temp_Object( 48) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_GR_grp_15))));
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 36));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_5);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 37));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_6);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 38));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_7);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 39));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_8);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 40));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 41));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 46));
AddTag(temp_TagList,MUIA_Group_Child,CY_label_9);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 47));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 48));
temp_Object( 35) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 33));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 35));
temp_Object( 32) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_6))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_6)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_6))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_6))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_6 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 54) := MUI_NewObjectA(MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_7))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_7)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_7))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_BT_label_7))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_7 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,BT_label_6);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 54));
AddTag(temp_TagList,MUIA_Group_Child,BT_label_7);
temp_Object( 53) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 32));
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 53));
temp_Object( 31) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_WI_drucker))));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('1','W','I','N'));
AddTag(temp_TagList,MUIA_Window_RootObject,temp_Object( 31));
WI_drucker := MUI_NewObjectA(MUIC_Window,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Georges Hessmann"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("DVIPRINT"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("DviPrintGui"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER: DviPrintGui 1.0 (xx.xx.xx)"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Georges Hessmann"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String(Fix_Back_Slash_String(GetDviPrintGuiString(MSG_AppDescription))));
AddTag(temp_TagList,MUIA_Application_Window,WI_dviprint);
AddTag(temp_TagList,MUIA_Application_Window,WI_drucker);
App := MUI_NewObjectA(MUIC_Application,temp_TagList );
return App;
end Create_DviPrintGui_App;

procedure Dispose_DviPrintGui_App is
begin
MUI_DisposeObject(App);
end Dispose_DviPrintGui_App;

end DviPrintGui_App;
