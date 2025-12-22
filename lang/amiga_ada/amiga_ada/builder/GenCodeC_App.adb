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

package body GenCodeC_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_GenCodeC_App return Object_Ptr is
begin


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(131));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_Text);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_Text := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Normal Generation"));
temp_Object( 4) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_normal := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Modular generation"));
temp_Object( 5) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_modular := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Indentation"));
temp_Object( 6) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_indentation := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 7) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 8) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Options") );
AddTag(temp_TagList,MUIA_Weight,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 4));
AddTag(temp_TagList,MUIA_Group_Child ,CH_normal);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 5));
AddTag(temp_TagList,MUIA_Group_Child ,CH_modular);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 6));
AddTag(temp_TagList,MUIA_Group_Child ,CH_indentation);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 7));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 8));
temp_Object( 3) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 10) := MUI_NewObjectA (MUIC_List ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 10));
LV_includes := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_include := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button);
IM_getfile := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,STR_include);
AddTag(temp_TagList,MUIA_Group_Child ,IM_getfile);
temp_Object( 11) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("includes") );
AddTag(temp_TagList,MUIA_Group_Child ,LV_includes);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 11));
temp_Object( 9) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameSize,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 3));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 9));
temp_Object( 2) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("File Name:"));
temp_Object( 13) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_filename := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Procedure Name:"));
temp_Object( 14) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_procedurename := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Indentation:"));
temp_Object( 15) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_tab := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Code Infos") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 13));
AddTag(temp_TagList,MUIA_Group_Child ,STR_filename);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 14));
AddTag(temp_TagList,MUIA_Group_Child ,STR_procedurename);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 15));
AddTag(temp_TagList,MUIA_Group_Child ,STR_tab);
temp_Object( 12) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("OK"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'o');
AddTag(temp_TagList,MUIA_ControlChar,'o');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_ok := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Cancel"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'c');
AddTag(temp_TagList,MUIA_ControlChar,'c');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_Cancel := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_ok);
AddTag(temp_TagList,MUIA_Group_Child ,BT_Cancel);
temp_Object( 16) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,TX_Text);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 12));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 16));
temp_Object( 1) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("GenCode C"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 1));
WI_GenCodeC := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("GENCODEC"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("GenCodeC"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER: GenCodeC 2.0 (15.02.94)"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("1994 Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String("MUIBuilder external module"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_GenCodeC);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_GenCodeC_App;

procedure Dispose_GenCodeC_App is
begin
MUI_DisposeObject(App);
end Dispose_GenCodeC_App;

end GenCodeC_App;
