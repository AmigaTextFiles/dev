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

with Locale; use Locale;
with Characters_Locale; use Characters_Locale;

package body Characters_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_Characters_App return Object_Ptr is
begin


ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_label_0));
temp_Object( 3) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("STR_name"));
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_name := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_label_1));
temp_Object( 4) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("CY_sex"));
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_sex'Address);
CY_sex := MUI_NewObjectA (MUIC_Cycle ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("GR_Global"));
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 3));
AddTag(temp_TagList,MUIA_Group_Child ,STR_name);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 4));
AddTag(temp_TagList,MUIA_Group_Child ,CY_sex);
temp_Object( 2) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,GetCharactersString(MSG_RA_Race) );
AddTag(temp_TagList,MUIA_Radio_Entries,STR_RA_Race'Address);
RA_Race := MUI_NewObjectA (MUIC_Radio ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,GetCharactersString(MSG_RA_Class) );
AddTag(temp_TagList,MUIA_Radio_Entries,STR_RA_Class'Address);
RA_Class := MUI_NewObjectA (MUIC_Radio ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_cloak));
temp_Object( 7) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_cloak := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_shield));
temp_Object( 8) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_shield := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_gloves));
temp_Object( 9) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_gloves := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_helmet));
temp_Object( 10) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_helmet := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,GetCharactersString(MSG_GR_Armor) );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 7));
AddTag(temp_TagList,MUIA_Group_Child ,CH_cloak);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 8));
AddTag(temp_TagList,MUIA_Group_Child ,CH_shield);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 9));
AddTag(temp_TagList,MUIA_Group_Child ,CH_gloves);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 10));
AddTag(temp_TagList,MUIA_Group_Child ,CH_helmet);
temp_Object( 6) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_experience));
temp_Object( 12) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Slider_Quiet,FALSE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(3));
AddTag(temp_TagList,MUIA_Slider_Reverse,FALSE);
SL_experience := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_strength));
temp_Object( 13) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Slider_Quiet,FALSE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Slider_Reverse,FALSE);
SL_strength := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_dexterity));
temp_Object( 14) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Slider_Quiet,FALSE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(24));
AddTag(temp_TagList,MUIA_Slider_Reverse,FALSE);
SL_dexterity := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_condition));
temp_Object( 15) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Slider_Quiet,FALSE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(39));
AddTag(temp_TagList,MUIA_Slider_Reverse,FALSE);
SL_condition := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,GetCharactersString(MSG_LA_intelligence));
temp_Object( 16) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Slider_Quiet,FALSE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(74));
AddTag(temp_TagList,MUIA_Slider_Reverse,FALSE);
SL_intelligence := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,GetCharactersString(MSG_GR_Level) );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 12));
AddTag(temp_TagList,MUIA_Group_Child ,SL_experience);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 13));
AddTag(temp_TagList,MUIA_Group_Child ,SL_strength);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 14));
AddTag(temp_TagList,MUIA_Group_Child ,SL_dexterity);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 15));
AddTag(temp_TagList,MUIA_Group_Child ,SL_condition);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 16));
AddTag(temp_TagList,MUIA_Group_Child ,SL_intelligence);
temp_Object( 11) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Register_Titles,STR_GR_Register'Address );
AddTag(temp_TagList,MUIA_Group_Child ,RA_Race);
AddTag(temp_TagList,MUIA_Group_Child ,RA_Class);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 6));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 11));
temp_Object( 5) := MUI_NewObjectA (MUIC_Register,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 5));
temp_Object( 1) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,GetCharactersString(MSG_WI_Characters));
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("WI_Characters"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 1));
WI_Characters := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Stefan Stuntz"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("CHARACTER"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("Characters"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER: Characters 1.1 (xx.xx.xx)"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Stefan Stuntz"));
AddTag(temp_TagList,MUIA_Application_Description,GetCharactersString(MSG_AppDescription));
AddTag(temp_TagList,MUIA_Application_HelpFile ,Allocate_String("character.guide"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_Characters);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_Characters_App;

procedure Dispose_Characters_App is
begin
MUI_DisposeObject(App);
end Dispose_Characters_App;

end Characters_App;
