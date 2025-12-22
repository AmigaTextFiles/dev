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

package body Mac2E_GUI_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_Mac2E_GUI_App return Object_Ptr is
begin


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(131));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_0);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_label_0 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Mac2E : "));
temp_Object( 3) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_3 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(20));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
IM_label_2 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("E : "));
temp_Object( 4) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_4 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(20));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
IM_label_3 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Paths") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(3));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 3));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 4));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_4);
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_3);
temp_Object( 2) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Source : "));
temp_Object( 6) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_0 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
IM_label_0 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Destination : "));
temp_Object( 7) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_1 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
IM_label_1 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Files") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(3));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 6));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 7));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_1);
temp_Object( 5) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Mac2E"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'m');
AddTag(temp_TagList,MUIA_ControlChar,'m');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_mac2e := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("E Compile"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'c');
AddTag(temp_TagList,MUIA_ControlChar,'c');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_E := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Quit"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'q');
AddTag(temp_TagList,MUIA_ControlChar,'q');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_quit := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_mac2e);
AddTag(temp_TagList,MUIA_Group_Child ,BT_E);
AddTag(temp_TagList,MUIA_Group_Child ,BT_quit);
temp_Object( 8) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 5));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 8));
temp_Object( 1) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Mac2E GUI"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 1));
WI_main := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("Mac2E"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("Mac2E_GUI"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER:Mac2EGui 1.0 (xx.xx.xx)"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String("Just a demo !!!"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_main);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_Mac2E_GUI_App;

procedure Dispose_Mac2E_GUI_App is
begin
MUI_DisposeObject(App);
end Dispose_Mac2E_GUI_App;

end Mac2E_GUI_App;
