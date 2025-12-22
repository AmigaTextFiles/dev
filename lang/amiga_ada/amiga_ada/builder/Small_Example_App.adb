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

package body Small_Example_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_Small_Example_App return Object_Ptr is
begin


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Dirlist_Directory,Allocate_String("progdir:"));
AddTag(temp_TagList,MUIA_Dirlist_DrawersOnly,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_FilesOnly,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_FilterDrawers,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_MultiSelDirs,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_RejectIcons,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_SortDirs,MUIV_Dirlist_SortDirs_First);
AddTag(temp_TagList,MUIA_Dirlist_SortHighLow,FALSE);
AddTag(temp_TagList,MUIA_Dirlist_SortType,Unsigned_32(0));
temp_Object( 1) := MUI_NewObjectA (MUIC_Dirlist ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("LV_label_0"));
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 1));
LV_label_0 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 2) := MUI_NewObjectA (MUIC_Volumelist ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("LV_label_1"));
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 2));
LV_label_1 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("two lists") );
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("GR_lists"));
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_1);
GR_lists := MUI_NewObjectA (MUIC_Group ,temp_TagList );

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
BT_cancel := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("GR_grp_1"));
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_ok);
AddTag(temp_TagList,MUIA_Group_Child ,BT_cancel);
GR_grp_1 := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,GR_lists);
AddTag(temp_TagList,MUIA_Group_Child ,GR_grp_1);
GROUP_ROOT_0 := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Small example"));
AddTag(temp_TagList,MUIA_HelpNode,Allocate_String("WI_smallexample"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,GROUP_ROOT_0);
WI_smallexample := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("SMALL"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("Small_Example"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER : Small 1.0"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("(c) 1993 Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String("Here is a small example of MUI-Builder"));
AddTag(temp_TagList,MUIA_Application_HelpFile ,Allocate_String("small.guide"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_smallexample);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_Small_Example_App;

procedure Dispose_Small_Example_App is
begin
MUI_DisposeObject(App);
end Dispose_Small_Example_App;

end Small_Example_App;
