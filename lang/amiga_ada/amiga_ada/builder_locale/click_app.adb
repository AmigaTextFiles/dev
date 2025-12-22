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
with Click_Locale; use Click_Locale;

package body Click_App is
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
STR_TX_label_0 := Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_TX_label_0)));
end Init_Strings;

function Create_Click_App return Object_Ptr is
begin
Init_Strings;


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(131));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_0);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_label_0 := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_1stbutton))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_1stbutton)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_1stbutton))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_1stbutton))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_1stbutton := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_2ndbutton))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_2ndbutton)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_2ndbutton))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_2ndbutton))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_2ndbutton := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(String_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_3rdbutton))))(4..StrLen(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_3rdbutton)))))));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_3rdbutton))))(1));
AddTag(temp_TagList,MUIA_ControlChar,Char_Array_Value(Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_BT_3rdbutton))))(1));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_3rdbutton := MUI_NewObjectA(MUIC_Text,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child,BT_1stbutton);
AddTag(temp_TagList,MUIA_Group_Child,BT_2ndbutton);
AddTag(temp_TagList,MUIA_Group_Child,BT_3rdbutton);
temp_Object( 2) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child,TX_label_0);
AddTag(temp_TagList,MUIA_Group_Child,temp_Object( 2));
temp_Object( 1) := MUI_NewObjectA(MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_WI_try))));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N'));
AddTag(temp_TagList,MUIA_Window_RootObject,temp_Object( 1));
WI_try := MUI_NewObjectA(MUIC_Window,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("CLICK"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("Click"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER : Click 1.0"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Eric Totel 1994"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String(Fix_Back_Slash_String(GetClickString(MSG_AppDescription))));
AddTag(temp_TagList,MUIA_Application_Window,WI_try);
App := MUI_NewObjectA(MUIC_Application,temp_TagList );
return App;
end Create_Click_App;

procedure Dispose_Click_App is
begin
MUI_DisposeObject(App);
end Dispose_Click_App;

end Click_App;
