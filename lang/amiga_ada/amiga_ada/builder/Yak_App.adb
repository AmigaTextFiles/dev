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

package body Yak_App is
function MAKE_ID(a,b,c,d : Character) return Unsigned_32 is
begin
   return Character'Pos(a)* 2**24 +Character'Pos(b)* 2**16 +Character'Pos(c)* 2**8+Character'Pos(d);
end MAKE_ID;


temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;
function Create_Yak_App return Object_Ptr is
begin


ClearTagList(temp_TagList);
temp_Object( 4) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 5) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lAutoPointage"));
temp_Object( 6) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lFen?tres PopUp"));
temp_Object( 7) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lActivation au clavier"));
temp_Object( 8) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lCliquer en avant"));
temp_Object( 9) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lCliquer en arri?re"));
temp_Object( 10) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 4));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 5));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 6));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 7));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 8));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 9));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_4);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 10));
temp_Object( 3) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lActivation par MMB"));
temp_Object( 12) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lActivation par RMB"));
temp_Object( 13) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lCycler Ecrans"));
temp_Object( 14) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lActiver Ecran"));
temp_Object( 15) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lJoker AmigaDOS"));
temp_Object( 16) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddMsg(temp_Msg,Allocate_String(""& ESC &"lLecteurs Silencieux"));
temp_Object( 17) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_5);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 12));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_6);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 13));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_7);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 14));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_8);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 15));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_9);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 16));
AddTag(temp_TagList,MUIA_Group_Child ,CH_label_10);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 17));
temp_Object( 11) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Options Actives") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 3));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 11));
temp_Object( 2) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Ecran"));
temp_Object( 20) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_0 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Souris"));
temp_Object( 21) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

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
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 20));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 21));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_1);
temp_Object( 19) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Background,Unsigned_32(131));
AddTag(temp_TagList,MUIA_Text_Contents,STR_TX_label_0);
AddTag(temp_TagList,MUIA_Text_SetMax,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Text_SetMin,Unsigned_32(1));
AddTag(temp_TagList,MUIA_Frame,Unsigned_32(9));
TX_label_0 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 19));
AddTag(temp_TagList,MUIA_Group_Child ,TX_label_0);
temp_Object( 18) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Ecrans AutoPointables"));
temp_Object( 23) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_2 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Ecrans Cliquables"));
temp_Object( 24) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_10 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 25) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 26) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Fen?tres Popables"));
temp_Object( 27) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_3 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Fen?tres Cliquables"));
temp_Object( 28) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_4 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Motifs d'inclusion") );
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 23));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_2);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 24));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_10);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 25));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 26));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 27));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_3);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 28));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_4);
temp_Object( 22) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
temp_Object( 30) := MUI_NewObjectA (MUIC_Rectangle,temp_TagList );

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
temp_Object( 31) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 30));
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 31));
temp_Object( 29) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 18));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 22));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 29));
temp_Object( 1) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Yak Prefs"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('0','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 1));
WI_Main := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Masquer la souris"));
temp_Object( 34) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_0'Address);
CY_label_0 := MUI_NewObjectA (MUIC_Cycle ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Volume Clavier"));
temp_Object( 35) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Slider_Min,Unsigned_32(0));
AddTag(temp_TagList,MUIA_Slider_Max,Unsigned_32(64));
AddTag(temp_TagList,MUIA_Slider_Quiet,FALSE);
AddTag(temp_TagList,MUIA_Slider_Level,Unsigned_32(40));
AddTag(temp_TagList,MUIA_Slider_Reverse,TRUE);
SL_volume := MUI_NewObjectA (MUIC_Slider ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("D?lais d'AutoPointage"));
temp_Object( 36) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_18 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 34));
AddTag(temp_TagList,MUIA_Group_Child ,CY_label_0);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 35));
AddTag(temp_TagList,MUIA_Group_Child ,SL_volume);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 36));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_18);
temp_Object( 33) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Revenir..."));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'r');
AddTag(temp_TagList,MUIA_ControlChar,'r');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_8 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 33));
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_8);
temp_Object( 32) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Divers"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('1','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 32));
WI_divers := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 40) := MUI_NewObjectA (MUIC_List ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 40));
LV_label_0 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Actions") );
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_0);
temp_Object( 39) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_InputList );
AddTag(temp_TagList,MUIA_Listview_DoubleClick,TRUE);
temp_Object( 42) := MUI_NewObjectA (MUIC_List ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Listview_MultiSelect,MUIV_Listview_MultiSelect_Default);
AddTag(temp_TagList,MUIA_Listview_List,temp_Object( 42));
LV_label_1 := MUI_NewObjectA (MUIC_Listview ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_19 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Ajouter"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'a');
AddTag(temp_TagList,MUIA_ControlChar,'a');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_9 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String("Effacer"));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'e');
AddTag(temp_TagList,MUIA_ControlChar,'e');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_10 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_9);
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_10);
temp_Object( 43) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Group);
AddTag(temp_TagList,MUIA_FrameTitle,Allocate_String("Touches d'appel") );
AddTag(temp_TagList,MUIA_Group_Child ,LV_label_1);
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_19);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 43));
temp_Object( 41) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameWidth,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 39));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 41));
temp_Object( 38) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Param?tre"));
temp_Object( 46) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_String );
AddTag(temp_TagList,MUIA_String_MaxLen,Unsigned_32(80));
AddTag(temp_TagList,MUIA_String_Format,Unsigned_32(0));
STR_label_20 := MUI_NewObjectA (MUIC_String ,temp_TagList );

ClearMsg(temp_Msg);
AddMsg(temp_Msg,Allocate_String("Options"));
temp_Object( 47) := MUI_MakeObjectA (MUIO_Label,temp_Msg );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Cycle_Entries,STR_CY_label_1'Address);
CY_label_1 := MUI_NewObjectA (MUIC_Cycle ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Columns,Unsigned_32(2));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 46));
AddTag(temp_TagList,MUIA_Group_Child ,STR_label_20);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 47));
AddTag(temp_TagList,MUIA_Group_Child ,CY_label_1);
temp_Object( 45) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Frame,MUIV_Frame_Button );
AddTag(temp_TagList,MUIA_Text_Contents,Allocate_String(""& Character'VAL(8#012#) &"Revenir..."& Character'VAL(8#012#) &""));
AddTag(temp_TagList,MUIA_Text_PreParse,MUIX_C);
AddTag(temp_TagList,MUIA_Text_HiChar,'r');
AddTag(temp_TagList,MUIA_ControlChar,'r');
AddTag(temp_TagList,MUIA_InputMode,MUIV_InputMode_RelVerify);
AddTag(temp_TagList,MUIA_Background,MUII_ButtonBack);
BT_label_11 := MUI_NewObjectA (MUIC_Text ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Horiz,TRUE);
AddTag(temp_TagList,MUIA_Group_SameHeight,TRUE);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 45));
AddTag(temp_TagList,MUIA_Group_Child ,BT_label_11);
temp_Object( 44) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 38));
AddTag(temp_TagList,MUIA_Group_Child ,temp_Object( 44));
temp_Object( 37) := MUI_NewObjectA (MUIC_Group ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Title,Allocate_String("Touches d'appel"));
AddTag(temp_TagList,MUIA_Window_ID,Make_Id('2','W','I','N') );
AddTag(temp_TagList,MUIA_Window_RootObject ,temp_Object( 37));
WI_touches := MUI_NewObjectA (MUIC_Window ,temp_TagList );

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Application_Author,Allocate_String("Gael Marziou"));
AddTag(temp_TagList,MUIA_Application_Base,Allocate_String("YAK"));
AddTag(temp_TagList,MUIA_Application_Title,Allocate_String("Yak"));
AddTag(temp_TagList,MUIA_Application_Version,Allocate_String("$VER: Yak 1.57 (xx.xx.xx)"));
AddTag(temp_TagList,MUIA_Application_Copyright,Allocate_String("Gael Marziou 1994"));
AddTag(temp_TagList,MUIA_Application_Description,Allocate_String("Yet Another Kommodity GUI Demo"));
AddTag(temp_TagList,MUIA_Application_Window ,WI_Main);
AddTag(temp_TagList,MUIA_Application_Window ,WI_divers);
AddTag(temp_TagList,MUIA_Application_Window ,WI_touches);
App := MUI_NewObjectA (MUIC_Application ,temp_TagList );
return App;
end Create_Yak_App;

procedure Dispose_Yak_App is
begin
MUI_DisposeObject(App);
end Dispose_Yak_App;

end Yak_App;
