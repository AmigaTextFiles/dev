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

package body Virtual_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_Virtual_App return Object_Ptr is
begin


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 6) := MUI_NewObjectA (MUIC_List ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 6));
LV_label_2 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_2);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_label_2 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Drucker") );
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_2);
temp_Object( 5) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("FormFeed"));
temp_Object( 8) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_5'Address);
CY_label_5 := MUI_NewObjectA (MUIC_Cycle ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Druck Richtung"));
temp_Object( 9) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_6'Address);
CY_label_6 := MUI_NewObjectA (MUIC_Cycle ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Device Nodus"));
temp_Object( 10) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_7'Address);
CY_label_7 := MUI_NewObjectA (MUIC_Cycle ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Seitengr??e"));
temp_Object( 11) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_8'Address);
CY_label_8 := MUI_NewObjectA (MUIC_Cycle ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 12) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("H:"));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 15) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_5 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2) );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 15));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_5);
temp_Object( 14) := MUI_NewObjectA (MUIC_Group,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("V:"));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 17) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_6 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2) );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 17));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_6);
temp_Object( 16) := MUI_NewObjectA (MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 14));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 16));
temp_Object( 13) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Aufl?sung"));
temp_Object( 18) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_9'Address);
CY_label_9 := MUI_NewObjectA (MUIC_Cycle ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 19) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("H:"));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 22) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_7 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2) );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 22));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_7);
temp_Object( 21) := MUI_NewObjectA (MUIC_Group,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("V:"));
AddMsg(temp_Msg,MUIO_Label_DoubleFrame);
temp_Object( 24) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_8 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2) );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 24));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_8);
temp_Object( 23) := MUI_NewObjectA (MUIC_Group,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 21));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 23));
temp_Object( 20) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Sonstiges Parameter") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 8));
AddTag(temp_TagList,MUIA_Group_Child ,CY_label_5);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 9));
AddTag(temp_TagList,MUIA_Group_Child ,CY_label_6);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 10));
AddTag(temp_TagList,MUIA_Group_Child ,CY_label_7);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 11));
AddTag(temp_TagList,MUIA_Group_Child ,CY_label_8);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 12));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 13));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 18));
AddTag(temp_TagList,MUIA_Group_Child ,CY_label_9);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 19));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 20));
temp_Object( 7) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 5));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 7));
temp_Object( 4) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Benutzen"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'u');
AddTag(temp_TagList,MUIA_ControlChar,'u');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_6 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 26) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Abbrechen"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'a');
AddTag(temp_TagList,MUIA_ControlChar,'a');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_7 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_6);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 26));
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_7);
temp_Object( 25) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Virtual );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 4));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 25));
temp_Object( 3) := MUI_NewObjectA (MUIC_Virtgroup ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Scrollgroup_Contents,temp_Object( 3));
temp_Object( 2) := MUI_NewObjectA (MUIC_Scrollgroup ,temp_TagList );

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
temp_Object( 30) := MUI_NewObjectA (MUIC_Dirlist ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 30));
LV_label_0 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 31) := MUI_NewObjectA (MUIC_Volumelist ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 31));
LV_label_1 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_1);
temp_Object( 29) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

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
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_ok);
AddTag(temp_TagList,MUIA_Group_Child ,BT_cancel);
temp_Object( 32) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Virtual );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 29));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 32));
temp_Object( 28) := MUI_NewObjectA (MUIC_Virtgroup ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Scrollgroup_Contents,temp_Object( 28));
temp_Object( 27) := MUI_NewObjectA (MUIC_Scrollgroup ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 37) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 38) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_0 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lAutoPointage"));
temp_Object( 39) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_1 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lFen?tres PopUp"));
temp_Object( 40) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_2 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lActivation au clavier"));
temp_Object( 41) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_3 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lCliquer en avant"));
temp_Object( 42) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_4 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lCliquer en arri?re"));
temp_Object( 43) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 37));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 38));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 39));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 40));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 41));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 42));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_4);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 43));
temp_Object( 36) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_5 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lActivation par MMB"));
temp_Object( 45) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_6 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lActivation par RMB"));
temp_Object( 46) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_7 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lCycler Ecrans"));
temp_Object( 47) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_8 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lActiver Ecran"));
temp_Object( 48) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_9 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lJoker AmigaDOS"));
temp_Object( 49) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ImageButton);
AddTag(temp_TagList,MUIA_InputMode ,MUIV_InputMode_Toggle);
AddTag(temp_TagList,MUIA_Image_Spec ,MUII_CheckMark);
AddTag(temp_TagList,MUIA_Image_FreeVert ,TRUE);
AddTag(temp_TagList,MUIA_Selected ,FALSE);
AddTag(temp_TagList,MUIA_Background ,MUII_ButtonBack);
AddTag(temp_TagList,MUIA_ShowSelState ,FALSE);
CH_label_10 := MUI_NewObjectA (MUIC_Image,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String(""& Character'VAL(8#033#) &"lLecteurs Silencieux"));
temp_Object( 50) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_5);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 45));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_6);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 46));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_7);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 47));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_8);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 48));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_9);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 49));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_10);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 50));
temp_Object( 44) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Options Actives") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 36));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 44));
temp_Object( 35) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Ecran"));
temp_Object( 53) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_0 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Souris"));
temp_Object( 54) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_1 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("D?lais d'extinction") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 53));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 54));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_1);
temp_Object( 52) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(131));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_0);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_label_0 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 52));
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_0);
temp_Object( 51) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Ecrans AutoPointables"));
temp_Object( 56) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_2 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Ecrans Cliquables"));
temp_Object( 57) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_10 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 58) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 59) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Fen?tres Popables"));
temp_Object( 60) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_3 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Fen?tres Cliquables"));
temp_Object( 61) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_4 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Motifs d'inclusion") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 56));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 57));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_10);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 58));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 59));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 60));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 61));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_4);
temp_Object( 55) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 63) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(""& Character'VAL(8#012#) &"Divers"& Character'VAL(8#012#) &""));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'d');
AddTag(temp_TagList,MUIA_ControlChar,'d');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_0 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(""& Character'VAL(8#012#) &"Touches d'appel"& Character'VAL(8#012#) &""));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'t');
AddTag(temp_TagList,MUIA_ControlChar,'t');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_1 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Cacher"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'c');
AddTag(temp_TagList,MUIA_ControlChar,'c');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_2 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Quitter"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'q');
AddTag(temp_TagList,MUIA_ControlChar,'q');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_3 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_3);
temp_Object( 64) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 63));
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 64));
temp_Object( 62) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Virtual );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 35));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 51));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 55));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 62));
temp_Object( 34) := MUI_NewObjectA (MUIC_Virtgroup ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Scrollgroup_Contents,temp_Object( 34));
temp_Object( 33) := MUI_NewObjectA (MUIC_Scrollgroup ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(131));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_0);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_label_0 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Mac2E : "));
temp_Object( 68) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
temp_Object( 69) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 68));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 69));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_4);
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_3);
temp_Object( 67) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Source : "));
temp_Object( 71) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
temp_Object( 72) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 71));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 72));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_1);
temp_Object( 70) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

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
temp_Object( 73) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Virtual );
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 67));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 70));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 73));
temp_Object( 66) := MUI_NewObjectA (MUIC_Virtgroup ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Scrollgroup_Contents,temp_Object( 66));
temp_Object( 65) := MUI_NewObjectA (MUIC_Scrollgroup ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Virtual Groups") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_SameSize,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 27));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 33));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 65));
temp_Object( 1) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Virtual Groups"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 1));
WI_Virtual := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_3);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_label_3 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_3);
temp_Object( 74) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Read Me"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('1','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 74));
WI_readme := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Eric Totel"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("VIRTUAL"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("Virtual"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER: VIRTUAL 1.0 (1.12.94)"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Eric Totel 1994"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String("just a demo !!!"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_Virtual);
AddTag(temp_TagList,MUIA_Application_Window ,WI_readme);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_Virtual_App;

procedure Dispose_Virtual_App is
begin
MUI_DisposeObject(App);
end Dispose_Virtual_App;

end Virtual_App;
