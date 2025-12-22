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

package body Special_Chars_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_Special_Chars_App return Object_Ptr is
begin


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(""& ESC &"8button_title"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'b');
AddTag(temp_TagList,MUIA_ControlChar,'b');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_0 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(""& ESC &"8b"& ESC &"0"& ESC &"button_title"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'b');
AddTag(temp_TagList,MUIA_ControlChar,'b');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_1 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(""& ESC &"i"& ESC &"8b"& ESC &"i"& ESC &"0utton_title"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'b');
AddTag(temp_TagList,MUIA_ControlChar,'b');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_2 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(""& ESC &"bbutton_title"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'b');
AddTag(temp_TagList,MUIA_ControlChar,'b');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_3 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Buttons") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_3);
temp_Object( 2) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(131));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_0);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_label_0 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 2));
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_0);
temp_Object( 1) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Special Chars"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 1));
WI_SpecialChars := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("SPECCHARS"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("Special Chars"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER: SpecialChars 1.0"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Eric Totel (c) 1994"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String("just a demo !!!"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_SpecialChars);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_Special_Chars_App;

procedure Dispose_Special_Chars_App is
begin
MUI_DisposeObject(App);
end Dispose_Special_Chars_App;

end Special_Chars_App;
