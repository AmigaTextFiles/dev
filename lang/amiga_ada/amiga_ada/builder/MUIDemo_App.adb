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

package body MUIDemo_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_MUIDemo_App return Object_Ptr is
begin


ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(133));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_text1);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_text1 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Floattext_Text,STR_LV_float1);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ReadList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 2) := MUI_NewObjectA (MUIC_Floattext ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 2));
LV_float1 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Groups"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'g');
AddTag(temp_TagList,MUIA_ControlChar,'g');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_group := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Frames"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'f');
AddTag(temp_TagList,MUIA_ControlChar,'f');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_frames := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Backfill"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'b');
AddTag(temp_TagList,MUIA_ControlChar,'b');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_backfill := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Notify"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'n');
AddTag(temp_TagList,MUIA_ControlChar,'n');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_notify := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Listviews"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'l');
AddTag(temp_TagList,MUIA_ControlChar,'l');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_listview := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Cycle"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'c');
AddTag(temp_TagList,MUIA_ControlChar,'c');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_cycle := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Images"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'i');
AddTag(temp_TagList,MUIA_ControlChar,'i');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_image := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Strings"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'s');
AddTag(temp_TagList,MUIA_ControlChar,'s');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_string := MUI_NewObjectA (MUIC_Text ,temp_TagList );

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
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Available Demos") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(3));
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_group);
AddTag(temp_TagList,MUIA_Group_Child ,BT_frames);
AddTag(temp_TagList,MUIA_Group_Child ,BT_backfill);
AddTag(temp_TagList,MUIA_Group_Child ,BT_notify);
AddTag(temp_TagList,MUIA_Group_Child ,BT_listview);
AddTag(temp_TagList,MUIA_Group_Child ,BT_cycle);
AddTag(temp_TagList,MUIA_Group_Child ,BT_image);
AddTag(temp_TagList,MUIA_Group_Child ,BT_string);
AddTag(temp_TagList,MUIA_Group_Child ,BT_quit);
temp_Object( 3) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,TX_text1);
AddTag(temp_TagList,MUIA_Group_Child ,LV_float1);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 3));
temp_Object( 1) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("MUI-Demo"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 1));
WI_main := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Floattext_Text,STR_LV_float2);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ReadList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 5) := MUI_NewObjectA (MUIC_Floattext ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 5));
LV_float2 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_Gauge_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_vert1 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_Gauge_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_vert2 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_Gauge_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_vert3 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Horizontal") );
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,GA_vert1);
AddTag(temp_TagList,MUIA_Group_Child ,GA_vert2);
AddTag(temp_TagList,MUIA_Group_Child ,GA_vert3);
temp_Object( 7) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_horiz1 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_horiz2 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_horiz3 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Vertical") );
AddTag(temp_TagList,MUIA_Group_Child ,GA_horiz1);
AddTag(temp_TagList,MUIA_Group_Child ,GA_horiz2);
AddTag(temp_TagList,MUIA_Group_Child ,GA_horiz3);
temp_Object( 8) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array1 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array2 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array3 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array4 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array5 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array6 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array7 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array8 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_array9 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Array") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(3));
AddTag(temp_TagList,MUIA_Group_Child ,GA_array1);
AddTag(temp_TagList,MUIA_Group_Child ,GA_array2);
AddTag(temp_TagList,MUIA_Group_Child ,GA_array3);
AddTag(temp_TagList,MUIA_Group_Child ,GA_array4);
AddTag(temp_TagList,MUIA_Group_Child ,GA_array5);
AddTag(temp_TagList,MUIA_Group_Child ,GA_array6);
AddTag(temp_TagList,MUIA_Group_Child ,GA_array7);
AddTag(temp_TagList,MUIA_Group_Child ,GA_array8);
AddTag(temp_TagList,MUIA_Group_Child ,GA_array9);
temp_Object( 9) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Group Types") );
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 7));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 8));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 9));
temp_Object( 6) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("25 kg"));
AddTag(temp_TagList,MUIA_Text_PreParse,Allocate_String(""& ESC &"c"));
AddTag(temp_TagList,MUIA_InputMode,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Background,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Weight,Unsigned_32(25));
BT_25kg := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("50 kg"));
AddTag(temp_TagList,MUIA_Text_PreParse,Allocate_String(""& ESC &"c"));
AddTag(temp_TagList,MUIA_InputMode,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Background,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Weight,Unsigned_32(50));
BT_50kg := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("75 kg"));
BT_75kg := MUI_MakeObjectA (MUIO_Button,temp_Msg );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("100 kg"));
BT_100kg := MUI_MakeObjectA (MUIO_Button,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Different Weights") );
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_25kg);
AddTag(temp_TagList,MUIA_Group_Child ,BT_50kg);
AddTag(temp_TagList,MUIA_Group_Child ,BT_75kg);
AddTag(temp_TagList,MUIA_Group_Child ,BT_100kg);
temp_Object( 10) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_1);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_label_1 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_2);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_label_2 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_3);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_label_3 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_4);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_label_4 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_5);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_label_5 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Fixed & Variable Sizes") );
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_4);
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_5);
temp_Object( 11) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,LV_float2);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 6));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 10));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 11));
temp_Object( 4) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Groups"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('1','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 4));
WI_groups := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Floattext_Text,STR_LV_float3);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ReadList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 13) := MUI_NewObjectA (MUIC_Floattext ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 13));
LV_float3 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_button);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(1));
TX_button := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_imagebutton);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(2));
TX_imagebutton := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_text);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(3));
TX_text := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_string);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(4));
TX_string := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_readlist);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(5));
TX_readlist := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_inputlist);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(6));
TX_inputlist := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_prop);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(7));
TX_prop := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(128));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_group);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_group := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,TX_button);
AddTag(temp_TagList,MUIA_Group_Child ,TX_imagebutton);
AddTag(temp_TagList,MUIA_Group_Child ,TX_text);
AddTag(temp_TagList,MUIA_Group_Child ,TX_string);
AddTag(temp_TagList,MUIA_Group_Child ,TX_readlist);
AddTag(temp_TagList,MUIA_Group_Child ,TX_inputlist);
AddTag(temp_TagList,MUIA_Group_Child ,TX_prop);
AddTag(temp_TagList,MUIA_Group_Child ,TX_group);
temp_Object( 14) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,LV_float3);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 14));
temp_Object( 12) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Frames"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('2','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 12));
WI_frames := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Floattext_Text,STR_LV_float4);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ReadList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 16) := MUI_NewObjectA (MUIC_Floattext ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 16));
LV_float4 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_Gauge_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_connect1 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Prop );
AddTag(temp_TagList,MUIA_Prop_Entries,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Prop_First,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Prop_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Prop_Visible,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
PR_label_0 := MUI_NewObjectA (MUIC_Prop ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Prop );
AddTag(temp_TagList,MUIA_Prop_Entries,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Prop_First,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Prop_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Prop_Visible,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
PR_label_1 := MUI_NewObjectA (MUIC_Prop ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,GA_connect1);
AddTag(temp_TagList,MUIA_Group_Child ,PR_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,PR_label_1);
temp_Object( 18) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 20) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Slider_Quiet,TRUE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Reverse,FALSE);
SL_label_0 := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Slider_Quiet,TRUE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Reverse,FALSE);
SL_label_1 := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Slider_Quiet,TRUE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Reverse,FALSE);
SL_label_2 := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,SL_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,SL_label_2);
temp_Object( 21) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 22) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_Gauge_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_label_16 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Scale_Horiz,Unsigned_32(1));
temp_Object( 23) := MUI_NewObjectA (MUIC_Scale ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 24) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 20));
AddTag(temp_TagList,MUIA_Group_Child ,SL_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 21));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 22));
AddTag(temp_TagList,MUIA_Group_Child ,GA_label_16);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 23));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 24));
temp_Object( 19) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Prop );
AddTag(temp_TagList,MUIA_Prop_Entries,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Prop_First,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Prop_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Prop_Visible,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
PR_label_2 := MUI_NewObjectA (MUIC_Prop ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Prop );
AddTag(temp_TagList,MUIA_Prop_Entries,Unsigned_32(100));
AddTag(temp_TagList,MUIA_Prop_First,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Prop_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Prop_Visible,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
PR_label_3 := MUI_NewObjectA (MUIC_Prop ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Gauge );
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(15));
AddTag(temp_TagList,MUIA_Gauge_Horiz,FALSE);
AddTag(temp_TagList,MUIA_Gauge_Max,Unsigned_32(100));
GA_label_17 := MUI_NewObjectA (MUIC_Gauge ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,PR_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,PR_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,GA_label_17);
temp_Object( 25) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Connections") );
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 18));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 19));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 25));
temp_Object( 17) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,LV_float4);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 17));
temp_Object( 15) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Notifying"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('3','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 15));
WI_notify := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Floattext_Text,STR_LV_float5);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ReadList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 27) := MUI_NewObjectA (MUIC_Floattext ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 27));
LV_float5 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

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
temp_Object( 29) := MUI_NewObjectA (MUIC_Dirlist ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 29));
LV_label_5 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 30) := MUI_NewObjectA (MUIC_Volumelist ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 30));
LV_label_6 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Dir & Volume List") );
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_5);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_6);
temp_Object( 28) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,LV_float5);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 28));
temp_Object( 26) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("ListViews"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('4','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 26));
WI_listviews := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Floattext_Text,STR_LV_label_7);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ReadList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 32) := MUI_NewObjectA (MUIC_Floattext ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 32));
LV_label_7 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 33) := MUI_NewObjectA (MUIC_List ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 33));
LV_label_8 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_0 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_7);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_8);
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_0);
temp_Object( 31) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("String"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('5','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 31));
WI_string := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Floattext_Text,STR_LV_label_9);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_ReadList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 35) := MUI_NewObjectA (MUIC_Floattext ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 35));
LV_label_9 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("ArrowUp:"));
temp_Object( 38) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(11));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_0 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("ArrowDown"));
temp_Object( 39) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(12));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_1 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("ArrowLeft:"));
temp_Object( 40) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(14));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_2 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("ArrowRight:"));
temp_Object( 41) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(14));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_3 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("RadioButton"));
temp_Object( 42) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(16));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_4 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("File:"));
temp_Object( 43) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_5 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("HardDisk:"));
temp_Object( 44) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(23));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_6 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Disk"));
temp_Object( 45) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(24));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_7 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Chip:"));
temp_Object( 46) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(25));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_8 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Drawer:"));
temp_Object( 47) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(22));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
IM_label_9 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Some Images") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 38));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 39));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 40));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 41));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 42));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_4);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 43));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_5);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 44));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_6);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 45));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_7);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 46));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_8);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 47));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_9);
temp_Object( 37) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 49) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(16));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
temp_Object( 51) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(16));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(14));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(12));
temp_Object( 52) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(16));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(18));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(22));
temp_Object( 53) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(16));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(20));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(26));
temp_Object( 54) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(16));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(22));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(34));
temp_Object( 55) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 51));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 52));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 53));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 54));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 55));
temp_Object( 50) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 56) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(10));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(8));
temp_Object( 58) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(12));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(12));
temp_Object( 59) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(14));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(16));
IM_label_35 := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(16));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(20));
temp_Object( 60) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(18));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(24));
temp_Object( 61) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Image_Spec,Unsigned_32(19));
AddTag(temp_TagList,MUIA_Image_FreeVert,TRUE);
AddTag(temp_TagList,MUIA_Image_FreeHoriz,TRUE);
AddTag(temp_TagList,MUIA_FixHeight,Unsigned_32(20));
AddTag(temp_TagList,MUIA_FixWidth,Unsigned_32(28));
temp_Object( 62) := MUI_NewObjectA (MUIC_Image ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 58));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 59));
AddTag(temp_TagList,MUIA_Group_Child ,IM_label_35);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 60));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 61));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 62));
temp_Object( 57) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 63) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Scale Engine") );
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 49));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 50));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 56));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 57));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 63));
temp_Object( 48) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameHeight,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 37));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 48));
temp_Object( 36) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_9);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 36));
temp_Object( 34) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Images"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('6','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 34));
WI_images := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Stefan Stuntz"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("MUIDEMO"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("MUIDemo"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER: MUI-Demo 1.0 (xx.xx.xx)"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Stefan Stuntz"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String("Just a demo !!!"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_main);
AddTag(temp_TagList,MUIA_Application_Window ,WI_groups);
AddTag(temp_TagList,MUIA_Application_Window ,WI_frames);
AddTag(temp_TagList,MUIA_Application_Window ,WI_notify);
AddTag(temp_TagList,MUIA_Application_Window ,WI_listviews);
AddTag(temp_TagList,MUIA_Application_Window ,WI_string);
AddTag(temp_TagList,MUIA_Application_Window ,WI_images);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_MUIDemo_App;

procedure Dispose_MUIDemo_App is
begin
MUI_DisposeObject(App);
end Dispose_MUIDemo_App;

end MUIDemo_App;
