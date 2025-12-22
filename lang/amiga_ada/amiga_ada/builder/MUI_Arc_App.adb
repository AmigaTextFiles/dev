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

package body MUI_Arc_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_MUI_Arc_App return Object_Ptr is
begin


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(136));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_Title);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_Title := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 4) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Archivers") );
AddTag(temp_TagList,MUIA_Radio_Entries,STR_RA_label_0'Address);
RA_label_0 := MUI_NewObjectA (MUIC_Radio ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 5) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 4));
AddTag(temp_TagList,MUIA_Group_Child ,RA_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 5));
temp_Object( 3) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 8) := MUI_NewObjectA (MUIC_Volumelist ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 8));
LV_volumes := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Dirlist_Directory,Allocate_String("progdir:"));
AddTag(temp_TagList,MUIA_Dirlist_DrawersOnly,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_FilesOnly,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_FilterDrawers,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_MultiSelDirs,TRUE);
AddTag(temp_TagList,MUIA_Dirlist_RejectIcons,TRUE);
AddTag(temp_TagList,MUIA_Dirlist_SortDirs,MUIV_Dirlist_SortDirs_First);
AddTag(temp_TagList,MUIA_Dirlist_SortHighLow,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_SortType,Unsigned_32(0));
temp_Object( 9) := MUI_NewObjectA (MUIC_Dirlist ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 9));
LV_files := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,LV_volumes);
AddTag(temp_TagList,MUIA_Group_Child ,LV_files);
temp_Object( 7) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("File"));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 11) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_filename := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2) );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 11));
AddTag(temp_TagList,MUIA_Group_Child ,STR_filename);
temp_Object( 10) := MUI_NewObjectA (MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Unarchive"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'u');
AddTag(temp_TagList,MUIA_ControlChar,'u');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_Unarchive := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Archive"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'a');
AddTag(temp_TagList,MUIA_ControlChar,'a');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_Archive := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_Unarchive);
AddTag(temp_TagList,MUIA_Group_Child ,BT_Archive);
temp_Object( 12) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 7));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 10));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 12));
temp_Object( 6) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Register_Titles,STR_GR_grp_0'Address );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 3));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 6));
temp_Object( 2) := MUI_NewObjectA (MUIC_Register,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,TX_Title);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 2));
temp_Object( 1) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("MUI_Arc"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 1));
WI_Main := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("MUIARC"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("MUI_Arc"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER: MUI_Arc 1.0 (26.02.94)"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Eric Totel (c) 1994"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String("Just an Example !!"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_Main);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_MUI_Arc_App;

procedure Dispose_MUI_Arc_App is
begin
MUI_DisposeObject(App);
end Dispose_MUI_Arc_App;

end MUI_Arc_App;
