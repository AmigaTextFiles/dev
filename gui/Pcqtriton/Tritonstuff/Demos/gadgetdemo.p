PROGRAM GadgetDemo;

(*
** This is a demo of tritonstuff for PCQ Pascal 1.2d.
**
** I have translated the gadgetdemo.rexx from tritonrexx
** to pcq.
**
** Nils Sjoholm    nils.sjoholm@mailbox.swipnet.se
**
** Date: May 1 1996
**
*)

{$I "Include:Libraries/Triton.i"}  (* You can also use Include:PCQUtils/triton.i *)
{$I "Include:Exec/Libraries.i"}
{$I "Include:Utils/TagUtils.i"}
{$I "Include:Utility/Utility.i"}
{$I "Include:Utils/StringLib.i"}

CONST


    NumInList   =  7;
    cyclenum    =  4;

    tempstring : String = "            ";

    mxstrings : ARRAY[0..NumInList-1] OF STRING = (
                                        "Amiga 500",
                                        "Amiga 600",
                                        "Amiga 1200",
                                        "Amiga 2000",
                                        "Amiga 3000",
                                        "Amiga 4000",
                                         NIL);

    cyclestrings : ARRAY[0..cyclenum-1] OF STRING = (
                                        "Hallo",
                                        "Moin",
                                        "Tach",
                                         NIL);
CONST

    ButtonGadID      = 1;
    CheckGadID       = 2;
    ScrollGadID      = 3;
    ScrollGadTextID  = 4;
    SlidGadID        = 5;
    SlidGadTextID    = 6;
    CycleGadID       = 7;
    CycleGadTextID   = 8;
    StringGadID      = 9;
    EntryGadID       = 10;
    PassGadID        = 11;
    MxGadID          = 12;
    MxGadTextID      = 13;
    ListGadID        = 14;

VAR
    App         : TR_AppPtr;
    Project     : TR_ProjectPtr;
    trmsg       : TR_MessagePtr;
    quit        : Boolean;
    z           : Integer;
    TagList     : ADDRESS;
    dummy       : Integer;
    Mylist      : ListPtr;
    MyNode      : NodePtr;
    i           : Integer;
    ID          : Integer;

PROCEDURE CleanExit(errstring : STRING; rc : Integer);
BEGIN
    IF Project <> NIL THEN TR_CloseProject(Project);
    IF App <> NIL THEN TR_DeleteApp(App);
    IF TritonBase <> NIL THEN CloseLibrary(TritonBase);
    IF UtilityBase <> NIL THEN CloseLibrary(UtilityBase);
    IF errstring <> NIL THEN WriteLn(errstring);
    Exit(rc)
END;

BEGIN
    UtilityBase := OpenLibrary("utility.library",0);
    IF UtilityBase = NIL THEN CleanExit("No utility.library",20);

    TritonBase := OpenLibrary(TRITONNAME,TRITON14VERSION);
    IF TritonBase = NIL THEN CleanExit("No triton.library",0);

    New(Mylist);
    NewList(Mylist);
    FOR i := 0 TO NumInList-2 DO BEGIN
        New(MyNode);
        MyNode^.ln_Name := mxstrings[i];
        AddTail(MyList,MyNode);
    END;

    TagList := CreateTagList(
                     TRCA_Name,"PCQ Pascal Demo",
                     TRCA_LongName,"PCQ Pascal Application Demo :)",
                     TRCA_Version,"0.01",
                     TRCA_Info,"Just a test OF Triton",
                     TRCA_Release,"1",
                     TRCA_Date,"01-05-1996",
                     TAG_DONE);
    App := TR_CreateApp(TagList);
    IF App = NIL THEN CleanExit("No application",20);
    FreeTagItems(TagList);

(*
** This are the macros for GadgetDemo.p
**

#include "pcq:macros/triton.macros"

ProjectDefinition(TagList)
    WindowID(1),
    WindowPosition(TRWP_CENTERDISPLAY),
    WindowTitle("Gadgets"),
       HorizGroupAC,
          Space,
          VertGroupA,
             Space,
             NamedSeparator("Gadget deactivate"),
             Space,
             Button("_Button",ButtonGadID),
             Space,
             HorizGroupSC,
                Space,
                HorizGroup,
                   TextID("_Gadget activ?",CheckGadID),
                   Space,
                   CheckBoxCLEFT(CheckGadID),
                EndGroup,
                Space,
             EndGroup,
             SpaceB,
             NamedSeparator("Pick value"),
             Space,
             LineArray,
                BeginLine,
                   TextID("Sc_roller",ScrollGadID),
                   TRAT_Flags,TROF_RIGHTALIGN,
                   Space,
                   TROB_Scroller,TROF_HORIZ,
                   TRSC_Total,40,
                   TRSC_Visible,10,
                   TRAT_Value,5,
                   TRAT_ID,ScrollGadID,
                   Space,
                   ClippedTextBoxMW("5",ScrollGadTextID,2),
                EndLine,
                Space,
                BeginLine,
                   TextID("S_lider",SlidGadID),
                   TRAT_Flags,TROF_RIGHTALIGN,
                   Space,
                   SliderGadget(1,50,25,SlidGadID),
                   Space,
                   ClippedTextBoxMW("25",SlidGadTextID,2),
                EndLine,
                Space,
                BeginLine,
                   TextID("C_ycle",CycleGadID),
                   TRAT_Flags,TROF_RIGHTALIGN,
                   Space,
                   CycleGadget(@cyclestrings,0,CycleGadID),
                   Space,
                   ClippedTextBoxMW(cyclestrings[0],CycleGadTextID,5),
                EndLine,
             EndArray,
             SpaceB,
              NamedSeparator("Type some Text"),
             Space,
             LineArray,
                BeginLine,
                   TextID("_String",StringGadID),
                   TRAT_Flags,TROF_RIGHTALIGN,
                   Space,
                   StringGadget("Please change",StringGadID),
                   GetEntryButton(EntryGadID),
                EndLine,
                Space,
                BeginLine,
                   TextID("_Password",PassGadID),
                   TRAT_Flags,TROF_RIGHTALIGN,
                   Space,
                   PasswordGadget("",PassGadID),
                EndLine,
             EndArray,
             Space,
          EndGroup,
          Space,
          VertSeparator,
          Space,
          VertGroupAC,
             Space,
             NamedSeparatorI("C_hoose",MxGadID),
             Space,
             MXGadget(@mxstrings,4,MxGadID),
             Space,
             ClippedTextBox(mxstrings[4],MxGadTextID),
             SpaceB,
             NamedSeparatorI("D_oubleclick!",ListGadID),
             Space,
             ListSS(Mylist,ListGadID,0,0),
          EndGroup,
          Space,
       EndGroup,
    EndProject

** End of macros
**
** To get a taglist from this macros
** Save the macros as xxxxx.macros or what ever.
** Let MakePCQTags.rexx translate them and then insert the new taglist.
**
** rx MakePCQTags xxxxx.macros   (That's all. :-) have fun! )
*)


(*
**
** Note: TagList created by MakePCQTags.rexx
**
**       @ MapMead SoftWare, Nils Sjoholm
**       nils.sjoholm@mailbox.swipnet.se
**
** Date: 01 May 1996
**
**       There were 484 commas in the list,
**       so you need a taglist with a value of at least 242 tags.
**
*)

     TagList := CreateTagList(
          TRWI_ID,(1),
          TRWI_Position,(TRWP_CENTERDISPLAY),
          TRWI_Title,("Gadgets"),
          TRGR_Horiz,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TRGR_Vert,TRGR_ALIGN,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"Gadget deactivate",
          TRAT_Flags,TRTX_TITLE,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_Button"),
          TRAT_ID,(ButtonGadID),
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSPACES + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,0,
          TROB_Text,0,
          TRAT_Text,"_Gadget activ?",
          TRAT_ID,CheckGadID,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSPACES,
          TROB_CheckBox,0,
          TRAT_ID,CheckGadID,
          TRAT_Value,True,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_BIG,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"Pick value",
          TRAT_Flags,TRTX_TITLE,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Vert,TRGR_ARRAY + TRGR_ALIGN + TRGR_CENTER,
          TRGR_Horiz,TRGR_PROPSHARE + TRGR_ALIGN + TRGR_CENTER,
          TROB_Text,0,
          TRAT_Text,"Sc_roller",
          TRAT_ID,ScrollGadID,
          TRAT_Flags,TROF_RIGHTALIGN,
          TROB_Space,TRST_NORMAL,
          TROB_Scroller,TROF_HORIZ,
          TRSC_Total,40,
          TRSC_Visible,10,
          TRAT_Value,5,
          TRAT_ID,ScrollGadID,
          TROB_Space,TRST_NORMAL,
          TROB_FrameBox,TRFB_TEXT,
          TRAT_Backfill,TRBF_NONE,
          TRGR_Vert,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_SMALL,
          TRGR_Horiz,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"5",
          TRAT_Flags,TRTX_CLIPPED + TRTX_NOUNDERSCORE,
          TRAT_ID,ScrollGadTextID,
          TRAT_MinWidth,2,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_SMALL,
          TRGR_End,0,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSHARE + TRGR_ALIGN + TRGR_CENTER,
          TROB_Text,0,
          TRAT_Text,"S_lider",
          TRAT_ID,SlidGadID,
          TRAT_Flags,TROF_RIGHTALIGN,
          TROB_Space,TRST_NORMAL,
          TROB_Slider,0,
          TRSL_Min,(1),
          TRSL_Max,(50),
          TRAT_ID,(SlidGadID),
          TRAT_Value,(25),
          TROB_Space,TRST_NORMAL,
          TROB_FrameBox,TRFB_TEXT,
          TRAT_Backfill,TRBF_NONE,
          TRGR_Vert,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_SMALL,
          TRGR_Horiz,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"25",
          TRAT_Flags,TRTX_CLIPPED + TRTX_NOUNDERSCORE,
          TRAT_ID,SlidGadTextID,
          TRAT_MinWidth,2,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_SMALL,
          TRGR_End,0,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSHARE + TRGR_ALIGN + TRGR_CENTER,
          TROB_Text,0,
          TRAT_Text,"C_ycle",
          TRAT_ID,CycleGadID,
          TRAT_Flags,TROF_RIGHTALIGN,
          TROB_Space,TRST_NORMAL,
          TROB_Cycle,@cyclestrings,
          TRAT_ID,(CycleGadID),
          TRAT_Value,(0),
          TROB_Space,TRST_NORMAL,
          TROB_FrameBox,TRFB_TEXT,
          TRAT_Backfill,TRBF_NONE,
          TRGR_Vert,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_SMALL,
          TRGR_Horiz,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,cyclestrings[0],
          TRAT_Flags,TRTX_CLIPPED + TRTX_NOUNDERSCORE,
          TRAT_ID,CycleGadTextID,
          TRAT_MinWidth,5,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_SMALL,
          TRGR_End,0,
          TRGR_End,0,
          TRGR_End,0,
          TROB_Space,TRST_BIG,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"Type some Text",
          TRAT_Flags,TRTX_TITLE,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Vert,TRGR_ARRAY + TRGR_ALIGN + TRGR_CENTER,
          TRGR_Horiz,TRGR_PROPSHARE + TRGR_ALIGN + TRGR_CENTER,
          TROB_Text,0,
          TRAT_Text,"_String",
          TRAT_ID,StringGadID,
          TRAT_Flags,TROF_RIGHTALIGN,
          TROB_Space,TRST_NORMAL,
          TROB_String,"Please change",
          TRAT_ID,(StringGadID),
          TROB_Button,TRBT_GETENTRY,
          TRAT_Text,"",
          TRAT_ID,(EntryGadID),
          TRAT_Flags,TRBU_YRESIZE,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSHARE + TRGR_ALIGN + TRGR_CENTER,
          TROB_Text,0,
          TRAT_Text,"_Password",
          TRAT_ID,PassGadID,
          TRAT_Flags,TROF_RIGHTALIGN,
          TROB_Space,TRST_NORMAL,
          TROB_String,"",
          TRAT_ID,(PassGadID),
          TRAT_Flags,TRST_INVISIBLE,
          TRGR_End,0,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Vert,TRGR_EQUALSHARE + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_VERT,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Vert,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"C_hoose",
          TRAT_Flags,TRTX_TITLE,
          TRAT_ID,MxGadID,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TROB_Cycle,@mxstrings,
          TRAT_ID,(MxGadID),
          TRAT_Value,(4),
          TRAT_Flags,TRCY_MX,
          TROB_Space,TRST_NORMAL,
          TROB_FrameBox,TRFB_TEXT,
          TRAT_Backfill,TRBF_NONE,
          TRGR_Vert,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_SMALL,
          TRGR_Horiz,TRGR_ALIGN + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,mxstrings[4],
          TRAT_Flags,TRTX_CLIPPED + TRTX_NOUNDERSCORE,
          TRAT_ID,MxGadTextID,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_SMALL,
          TRGR_End,0,
          TROB_Space,TRST_BIG,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"D_oubleclick!",
          TRAT_Flags,TRTX_TITLE,
          TRAT_ID,ListGadID,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TROB_Listview,(Mylist),
          TRAT_Flags,TRLV_NOGAP + TRLV_SHOWSELECTED,
          TRAT_ID,ListGadID,
          TRAT_Value,4,
          TRLV_Top,0,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TAG_END);



    Project := TR_OpenProject(App,TagList);
    IF Project = NIL THEN CleanExit("No project",20);
    FreeTagItems(TagList);

    quit := False;
    WHILE NOT quit DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
             trmsg := TR_GetMsg(app);
             IF (trmsg^.trm_Project = Project) THEN BEGIN
                 CASE trmsg^.trm_Class OF
                    TRMS_CLOSEWINDOW : BEGIN
                                          TR_LockProject(project);
                                          dummy := TR_EasyRequest(App,"%3Sure you want to end this demo?","Yes|No",NIL);
                                          TR_UnlockProject(project);
                                          IF dummy = 1 THEN quit := True;
                                       END;
                    TRMS_NEWVALUE    : BEGIN
                                       ID := trmsg^.trm_ID;
                                          CASE ID OF
                                              CheckGadID   : BEGIN
                                                                dummy := trmsg^.trm_Data;
                                                                IF dummy = 1 THEN BEGIN
                                                                    TR_SetAttribute(project,ButtonGadID,TRAT_Disabled,0);
                                                                END ELSE BEGIN
                                                                     TR_SetAttribute(project,ButtonGadID,TRAT_Disabled,1);
                                                                END;
                                                             END;
                                              ScrollGadID  : BEGIN
                                                                dummy := IntToStr(tempstring,trmsg^.trm_Data);
                                                                TR_SetAttribute(project,ScrollGadTextID,TRAT_Text,Integer(tempstring));
                                                             END;
                                              SlidGadID    : BEGIN
                                                                dummy := IntToStr(tempstring,trmsg^.trm_Data);
                                                                TR_SetAttribute(project,SlidGadTextID,TRAT_Text,Integer(tempstring));
                                                             END;
                                              CycleGadID   : TR_SetAttribute(project,CycleGadTextID,TRAT_Text,Integer(cyclestrings[trmsg^.trm_Data]));
                                              StringGadID  : ;
                                              EntryGadID   : ;
                                              PassGadID    : ;
                                              MxGadID      : BEGIN
                                                                TR_SetAttribute(project,MxGadTextID,TRAT_Text,Integer(mxstrings[trmsg^.trm_Data]));
                                                                TR_SetAttribute(project,ListGadID,TRAT_Value,Integer(trmsg^.trm_Data));
                                                             END;
                                              ListGadID    : BEGIN
                                                                TR_SetAttribute(project,MxGadID,TRAT_Value,Integer(trmsg^.trm_Data));
                                                                TR_SetAttribute(project,MxGadTextID,TRAT_Text,Integer(mxstrings[trmsg^.trm_Data]));
                                                             END;
                                          END;
                                       END;
                     TRMS_ACTION     : BEGIN
                                          ID := trmsg^.trm_ID;
                                          CASE ID OF
                                              ButtonGadID : ;
                                              EntryGadID  : BEGIN
                                                               dummy := TR_GetAttribute(project,StringGadID,TROB_String);
                                                               TR_LockProject(project);
                                                               z := TR_EasyRequest(App,ADDRESS(dummy),"OK",NIL);
                                                               TR_UnlockProject(Project);
                                                            END;
                                          END;
                                       END;
                 ELSE
                 END;
             END;
             TR_ReplyMsg(trmsg);
        UNTIL quit OR (trmsg = NIL);
    END;
    CleanExit(NIL,0);
END.


