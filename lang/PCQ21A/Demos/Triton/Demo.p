PROGRAM Main;

(*
** This is a part from Stefans demo.c
** It's the mainwindow, just to check that
** the menus and helpstuff worked ok. They did.:-)
**
** To see the quickhelp check the quickhelpmenu.
** ( Quickhelp is now on as default )
**
** Nils Sjoholm    nils.sjoholm@mailbox.swipnet.se
**
** Date May 1 1996
**
*)

{$I "Include:Libraries/Triton.i"}
{$I "Include:Macros/tritonmacros.i"}
{$I "Include:PCQUtils/Cstrings.i"}

VAR
    App            : TR_AppPtr;
    Main_Project   : TR_ProjectPtr;

PROCEDURE CleanUp(errstring : STRING; rc : Integer);
BEGIN
    IF App <> NIL THEN TR_DeleteApp(App);
    IF TritonBase <> NIL THEN CloseLibrary(TritonBase);
    IF errstring <> NIL THEN WriteLN(errstring);
    EXIT(rc)
END;

PROCEDURE do_text;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    text_project : TR_ProjectPtr;
    dummy : INTEGER;

BEGIN
    ProjectStart;
    WindowID(5); WindowTitle("Text"); WindowPosition(TRWP_CENTERDISPLAY);
    VertGroupA;
    Space; CenteredText("Normal text");
    Space; CenteredTextH("Highlighted text");
    Space; CenteredText3("3-dimensional text");
    Space; CenteredTextB("Bold text");
    Space; CenteredText("A _shortcut");
    Space; CenteredInteger(42);
    Space; HorizGroupAC;
             Space;
             ClippedText("This is a very long text which is truncated to fit with TRTX_CLIPPED.");
             Space; EndGroup;
    Space; EndGroup; EndProject;

    text_project := TR_OpenProject(App,@tritontags);
    IF text_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = text_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(text_project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;



PROCEDURE do_groups;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    groups_project : TR_ProjectPtr;
    dummy : INTEGER;

BEGIN
    ProjectStart;
    WindowTitle("Groups"); WindowPosition(TRWP_CENTERDISPLAY); WindowUnderscore("~"); WindowID(1);

    HorizGroupA; Space; VertGroupA;
    Space;

    NamedFrameBox("TRGR_PROPSHARE (default)"); ObjectBackfillWin; VertGroupA; Space; HorizGroupC;
      Space;
      Button("Short",1);
      Space;
      Button("And much, much longer...",2);
      Space;
      EndGroup; Space; EndGroup;

    Space;

    NamedFrameBox("TRGR_EQUALSHARE"); ObjectBackfillWin; VertGroupA; Space; HorizGroupEC;
      Space;
      Button("Short",3);
      Space;
      Button("And much, much longer...",4);
      Space;
      EndGroup; Space; EndGroup;

    Space;

    NamedFrameBox("TRGR_PROPSPACES"); ObjectBackfillWin; VertGroupA; Space; HorizGroupSC;
      Space;
      Button("Short",5);
      Space;
      Button("And much, much longer...",6);
      Space;
      EndGroup; Space; EndGroup;

    Space;

    NamedFrameBox("TRGR_ARRAY"); ObjectBackfillWin; VertGroupA; Space; LineArray;
      BeginLine;
        Space;
        Button("Short",7);
        Space;
        Button("And much, much longer...",8);
        Space;
        EndLine;
      Space;
      BeginLine;
        Space;
        Button("Not so short",9);
        Space;
        Button("And a bit longer...",10);
        Space;
        EndLine;
      Space;
      BeginLineI;
        NamedSeparator("An independent line");
        EndLine;
      Space;
      BeginLine;
        Space;
        Button("foo bar",12);
        Space;
        Button("42",13);
        Space;
        EndLine;
      EndArray; Space; EndGroup;

    Space;
    EndGroup; Space; EndGroup;
    EndProject;

    groups_project := TR_OpenProject(App,@tritontags);
    IF groups_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = groups_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                  TRMS_CLOSEWINDOW : close_me := True;
                  TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(groups_project);
      END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;

PROCEDURE do_menus;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    menus_project : TR_ProjectPtr;
    dummy : INTEGER;
    charbuffer : ARRAY [0..255] OF Char;
    buffer : STRING;

BEGIN
    buffer := @charbuffer;

    menus_project := TR_OpenProjectTags(App,
       TRWI_ID,                 2,
       TRWI_Title,              "Menus",
       TRMN_Title,              "A menu",
        TRMN_Item,              "A simple item", TRAT_ID, 1,
        TRMN_Item,              "Another item", TRAT_ID, 2,
        TRMN_Item,              "And now... a barlabel", TRAT_ID, 3,
        TRMN_Item,              TRMN_BARLABEL,
        TRMN_Item,              "1_An item with a shortcut", TRAT_ID, 4,
        TRMN_Item,              "2_Another one", TRAT_ID, 5,
        TRMN_Item,              "3_And number 3", TRAT_ID, 6,
        TRMN_Item,              TRMN_BARLABEL,
        TRMN_Item,              "_F1_And under OS3.0: Extended command keys", TRAT_ID, 6,
        TRMN_Item,              "_F2_Another one", TRAT_ID, 7,
        TRMN_Item,              TRMN_BARLABEL,
        TRMN_Item,              "How do you like submenus?",
         TRMN_Sub,              "G_Great!", TRAT_ID, 8,
         TRMN_Sub,              "F_Fine", TRAT_ID, 9,
         TRMN_Sub,              "D_Don't know", TRAT_ID, 10,
         TRMN_Sub,              "N_Not so fine", TRAT_ID, 11,
         TRMN_Sub,              "P_Puke!", TRAT_ID, 12,

       TRMN_Title,              "Another menu",
        TRMN_Item,              "This item is ghosted", TRMN_Flags, TRMF_DISABLED, TRAT_ID, 100,
        TRMN_Item,              TRMN_BARLABEL,
        TRMN_Item,              "Item 1 is checked", TRMN_Flags, TRMF_CHECKED, TRAT_ID, 13,
        TRMN_Item,              "Item 2 can be checked, too", TRMN_Flags, TRMF_CHECKIT, TRAT_ID, 14,

       TRMN_Title,              "Ghosted menu",
       TRMN_Flags,              TRMF_DISABLED,
        TRMN_Item,              "Item 1", TRAT_ID, 101,
        TRMN_Item,              "Item 2", TRAT_ID, 102,

       TAG_END);

    IF menus_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = menus_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
                 TRMS_NEWVALUE: BEGIN
                                  sprintf(buffer,"The new value of object %ld is %ld.\n",trmsg^.trm_ID,trmsg^.trm_Data);
                                  WriteLN(buffer);
                                END;
                 TRMS_ACTION:   BEGIN
                                  sprintf(buffer,"Object %ld has triggered an action.\n",trmsg^.trm_ID);
                                  WriteLN(buffer);
                                END;
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(menus_project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;

PROCEDURE do_gadgets;
CONST
  cycle_entries : ARRAY [0..10] OF STRING = (
                  "Entry 0",
                  "1",
                  "2",
                  "3",
                  "4",
                  "5",
                  "6",
                  "7",
                  "8",
                  "9",
                  NIL);


  mx_entries : ARRAY [0..3] OF STRING = (
                  "Choice 0",
                  "Choice 1",
                  "Choice 2",
                  NIL);
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    gadgets_project : TR_ProjectPtr;
    dummy : INTEGER;

BEGIN

  gadgets_project := TR_OpenProjectTags(App,
    TRWI_ID,  3,
    TRWI_Title,"Gadgets",
    TRWI_Position,TRWP_CENTERDISPLAY,

  TRGR_Vert,                   TRGR_PROPSHARE OR TRGR_ALIGN,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_CENTER,
      TROB_Space,              NIL,
      TROB_Line,               TROF_HORIZ,
      TROB_Space,              NIL,
      TROB_Text,               NIL, TRAT_Text,  "GadTools", TRAT_Flags,  TRTX_TITLE,
      TROB_Space,              NIL,
      TROB_Line,               TROF_HORIZ,
      TROB_Space,              NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_CheckBox,         NIL,
          TRAT_ID,             1,
          TRAT_Value,          TRUE,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "_Checkbox",
          TRAT_ID,             1,
        TROB_Space,            NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_Slider,           NIL,
          TRAT_ID,             4,
          TRSL_Min,            1,
          TRSL_Max,            3,
          TRAT_Value,          1,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "_Slider: ",
          TRAT_ID,             4,
        TROB_Text,             NIL,
          TRAT_Value,          1,
          TRAT_ID,             4,
          TRAT_MinWidth,       3,
      TROB_Space,              NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_Scroller,         NIL,
          TRAT_ID,             5,
          TRAT_Value,          2,
          TRSC_Total,          7,
          TRSC_Visible,        3,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "Sc_roller: ",
          TRAT_ID,             5,
        TROB_Text,             NIL,
          TRAT_Value,          2,
          TRAT_ID,             5,
          TRAT_MinWidth,       3,
      TROB_Space,              NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_Palette,          NIL,
          TRAT_ID,             3,
          TRAT_Value,          1,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "_Palette: ",
          TRAT_ID,             3,
        TROB_Text,             NIL,
          TRAT_Value,          1,
          TRAT_ID,             3,
          TRAT_MinWidth,       3,
      TROB_Space,              NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_Cycle,            @cycle_entries,
          TRAT_ID,             6,
          TRAT_Value,          4,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "C_ycle: ",
          TRAT_ID,             6,
        TROB_Text,             NIL,
          TRAT_Value,          4,
          TRAT_ID,             6,
          TRAT_MinWidth,       3,
      TROB_Space,              NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_Cycle,            @mx_entries,
          TRAT_ID,             13,
          TRAT_Value,          1,
          TRAT_Flags,          TRCY_MX,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "_MX: ",
          TRAT_ID,             13,
        TROB_Text,             NIL,
          TRAT_Value,          1,
          TRAT_ID,             13,
          TRAT_MinWidth,       3,
        TROB_Space,            NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_String,           "foo bar",
          TRAT_ID,             7,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "S_tring",
          TRAT_ID,             7,
      TROB_Space,              NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_String,           "",
          TRAT_Flags,          TRST_INVISIBLE,
          TRAT_ID,             15,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "Pass_word",
          TRAT_ID,             15,
      TROB_Space,              NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TRGR_Horiz,              TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Space,            NIL,
        TROB_String,           "0.42",
          TRAT_Flags,          TRST_FLOAT,
          TRST_Filter,         "01234567.,",
          TRAT_ID,             16,
      TRGR_End,                NIL,
      TROB_Space,              NIL,
      TRGR_Horiz,              TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_Text,             NIL,
          TRAT_Text,           "_Octal float",
          TRAT_ID,             16,
      TROB_Space,              NIL,
      TRGR_End,                NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_CENTER,
      TROB_Space,              NIL,
      TROB_Line,               TROF_HORIZ,
      TROB_Space,              NIL,
      TROB_Text,               NIL, TRAT_Text,  "BOOPSI", TRAT_Flags,  TRTX_TITLE,
      TROB_Space,              NIL,
      TROB_Line,               TROF_HORIZ,
      TROB_Space,              NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TROB_Space,              NIL,
      TROB_Button,             NIL, TRAT_ID, 2, TRAT_Text,  "_Button",
      TROB_Space,              NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER,
      TROB_Space,              NIL,
      TROB_Text,               NIL, TRAT_Text,  "_File:", TRAT_ID, 10,
      TROB_Space,              NIL,
      TROB_Button,             TRBT_GETFILE, TRAT_ID, 10, TRAT_Text,  "",
      TROB_Space,              NIL,
      TROB_Text,               NIL, TRAT_Text,  "_Drawer:", TRAT_ID, 11,
      TROB_Space,              NIL,
      TROB_Button,             TRBT_GETDRAWER, TRAT_ID, 11, TRAT_Text,  "",
      TROB_Space,              NIL,
      TROB_Text,               NIL, TRAT_Text,  "_Entry:", TRAT_ID, 12,
      TROB_Space,              NIL,
      TROB_Button,             TRBT_GETENTRY, TRAT_ID, 12, TRAT_Text,  "",
      TROB_Space,              NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_End,                  NIL,

  TAG_END);

    IF gadgets_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = gadgets_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(gadgets_project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;


PROCEDURE do_backfill;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    backfill_project : TR_ProjectPtr;
    dummy : INTEGER;

BEGIN
ProjectStart;
  WindowID(7); WindowTitle("Backfill"); WindowPosition(TRWP_CENTERDISPLAY);
  VertGroupA;
    Space;  CenteredText("Each window and");
    SpaceS; CenteredText("FrameBox can have");
    SpaceS; CenteredText("one of the following");
    SpaceS; CenteredText("backfill patterns");
    Space;  HorizGroupA;
              Space; GroupBox; ObjectBackfillS; SpaceB;
              Space; GroupBox; ObjectBackfillSA; SpaceB;
              Space; GroupBox; ObjectBackfillSF; SpaceB;
              Space; EndGroup;
    Space;  HorizGroupA;
              Space; GroupBox; ObjectBackfillSB; SpaceB;
              Space; GroupBox; ObjectBackfillA; SpaceB;
              Space; GroupBox; ObjectBackfillAF; SpaceB;
              Space; EndGroup;
    Space;  HorizGroupA;
              Space; GroupBox; ObjectBackfillAB; SpaceB;
              Space; GroupBox; ObjectBackfillF; SpaceB;
              Space; GroupBox; ObjectBackfillFB; SpaceB;
              Space; EndGroup;
    Space; EndGroup; EndProject;

    backfill_project := TR_OpenProject(App,@tritontags);
    IF backfill_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = backfill_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(backfill_project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;


PROCEDURE do_disabling;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    disabling_project : TR_ProjectPtr;
    dummy : INTEGER;

BEGIN
disabling_project := TR_OpenProjectTags(App,
  TRWI_ID,4, TRWI_Title,"Disabling", TRWI_Position,TRWP_CENTERDISPLAY,
  TRGR_Vert,                   TRGR_PROPSHARE OR TRGR_ALIGN,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TROB_Space,              NIL,
      TROB_CheckBox,           NIL, TRAT_ID, 1, TRAT_Value, TRUE,
      TROB_Space,              NIL,
      TROB_Text,               NIL, TRAT_Text,  "_Disabled", TRAT_ID, 1,
      TRGR_Horiz,              TRGR_PROPSPACES,
        TROB_Space,            NIL,
        TRGR_End,              NIL,
      TRGR_End,                NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_EQUALSHARE OR TRGR_CENTER,
      TROB_Space,              NIL,
      TROB_Line,               TROF_HORIZ,
      TROB_Space,              NIL,
      TRGR_End,                NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TROB_Space,              NIL,
      TROB_CheckBox,           NIL, TRAT_Value, TRUE, TRAT_ID, 2, TRAT_Disabled, TRUE,
      TROB_Space,              NIL,
      TROB_Text,               NIL, TRAT_Text,  "_Checkbox", TRAT_ID, 2,
      TROB_Space,              NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

    TRGR_Horiz,                TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
      TROB_Space,              NIL,
      TROB_Button,             NIL, TRAT_Text,  "_Button", TRAT_ID, 3, TRAT_Disabled, TRUE,
      TROB_Space,              NIL,
    TRGR_End,                  NIL,

    TROB_Space,                NIL,

  TRGR_End,                    NIL,

  TAG_END);

    IF disabling_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = disabling_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
                 TRMS_NEWVALUE: BEGIN
                                  IF trmsg^.trm_ID =1 THEN BEGIN
                                    TR_SetAttribute(disabling_project,2,TRAT_Disabled,trmsg^.trm_Data);
                                    TR_SetAttribute(disabling_project,3,TRAT_Disabled,trmsg^.trm_Data);
                                  END;
                                END;
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(disabling_project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;


PROCEDURE do_notification;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    notification_project : TR_ProjectPtr;
    dummy : INTEGER;

BEGIN
ProjectStart;
  WindowID(6); WindowTitle("Notification"); WindowPosition(TRWP_CENTERDISPLAY);
  VertGroupA;
    Space;
    NamedSeparatorI("_Checkmarks",1);
    Space;

    HorizGroupSAC;
      Space; CheckBox(1);
      Space; CheckBox(1);
      Space; CheckBox(1);
      Space; EndGroup;

    Space;

    HorizGroupSAC;
      Space; CheckBox(1);
      Space; CheckBox(1);
      Space; CheckBox(1);
      Space; EndGroup;

    Space;
    HorizGroupSAC;
      Space; CheckBox(1);
      Space; CheckBox(1);
      Space; CheckBox(1);
      Space; EndGroup;

    Space;
    NamedSeparatorI("_Slider and Progress indicator",2);
    Space;

    HorizGroupAC;
      Space;
      SliderGadget(0,10,8,2);
      Space;
      Integer3(8);SetTRTag(TRAT_ID,2);SetTRTag(TRAT_MinWidth,3);
      Space;
      EndGroup;

    Space;

    HorizGroupAC;
      Space;
      TextN("0%");
      Space;
      Progress(10,8,2);
      Space;
      TextN("100%");
      Space;
      EndGroup;

    Space;
  EndGroup; EndProject;

    notification_project := TR_OpenProject(App,@tritontags);
    IF notification_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = notification_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(notification_project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;


PROCEDURE do_lists;
CONST

    LVList1Strings : ARRAY[0..18] OF STRING = (
                       "This is a" ,
                       "READ ONLY" ,
                       "Listview" ,
                       "gadget using" ,
                       "the fixed-" ,
                       "width font." ,
                       "" ,
                       "This window" ,
                       "will remember" ,
                       "its position" ,
                       "even without" ,
                       "the Preferences" ,
                       "system, when" ,
                       "you reopen it," ,
                       "because it has" ,
                       "got a dimension" ,
                       "structure" ,
                       "attached" ,
                       "to it.");



    LVList2Strings : ARRAY [0..8] OF STRING = (
                       "This is a" ,
                       "SELECT" ,
                       "Listview" ,
                       "gadget." ,
                       "Use the" ,
                       "numeric" ,
                       "key pad to" ,
                       "move" ,
                       "around.");



    LVList3Strings : ARRAY [0..12] OF STRING = (
                       "This is a" ,
                       "SHOW" ,
                       "SELECTED" ,
                       "Listview" ,
                       "gadget." ,
                       "This list" ,
                       "is a bit" ,
                       "longer, so" ,
                       "that you" ,
                       "can try the" ,
                       "other" ,
                       "keyboard" ,
                       "shortcuts.");

VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    lists_project : TR_ProjectPtr;
    dummy,i : INTEGER;
    LVList1,
    LVList2,
    LVList3 : ListPtr;
    MyNode : NodePtr;

BEGIN

    New(LVList1);
    NewList(LVList1);
    FOR i := 0 TO 18 DO BEGIN
        New(MyNode);
        MyNode^.ln_Name := LVList1Strings[i];
        AddTail(LVList1,MyNode);
    END;

    New(LVList2);
    NewList(LVList2);
    FOR i := 0 TO 8 DO BEGIN
        New(MyNode);
        MyNode^.ln_Name := LVList2Strings[i];
        AddTail(LVList2,MyNode);
    END;

    New(LVList3);
    NewList(LVList3);
    FOR i := 0 TO 12 DO BEGIN
        New(MyNode);
        MyNode^.ln_Name := LVList3Strings[i];
        AddTail(LVList3,MyNode);
    END;

ProjectStart;
  WindowID(9); WindowTitle("Lists"); WindowPosition(TRWP_CENTERDISPLAY);
  HorizGroupA; Space; VertGroupA;
    Space;
    NamedSeparatorIN("_Read only",1);
    Space;
    FWListROCN(LVList1,1,0);
    Space;
    NamedSeparatorIN("_Select",2);
    Space;
    ListSelC(LVList2,2,0);
    Space;
    NamedSeparatorIN("S_how selected",3);
    Space;
    ListSSN(LVList3,3,0,1);
    Space;
  EndGroup; Space; EndGroup;
  EndProject;

    lists_project := TR_OpenProject(App,@tritontags);
    IF lists_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = lists_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(lists_project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;

PROCEDURE do_appwindow;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    appwindow_project : TR_ProjectPtr;
    dummy : INTEGER;
    chararray : ARRAY [0..100] OF Char;
    dirname : STRING;
    temp : BOOLEAN;
    reqbuffer : ARRAY [0..200] OF Char;
    reqstr : STRING;
BEGIN
    dirname := @chararray;
    reqstr := @reqbuffer;
ProjectStart;
  WindowID(8); WindowTitle("AppWindow"); WindowPosition(TRWP_CENTERDISPLAY);
  VertGroupA;
    Space;  CenteredText("This window is an application window.");
    SpaceS; CenteredText("Drop icons into the window or into");
    SpaceS; CenteredText("the icon drop boxes below and see");
    SpaceS; CenteredText("what will happen...");
    Space;  HorizGroupA;
              Space; DropBox(1);
              Space; DropBox(2);
              Space; EndGroup;
    Space; EndGroup; EndProject;

  appwindow_project := TR_OpenProject(App,@tritontags);
    IF appwindow_project <> NIL THEN BEGIN
      TR_LockProject(Main_Project);
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = appwindow_project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
                 TRMS_ICONDROPPED:  BEGIN
                                      dirname[0] := '\0';
                                      temp := NameFromLock(AppMessagePtr(trmsg^.trm_Data)^.am_ArgList^[1].wa_Lock,dirname,100);
                                      temp := AddPart(dirname,(AppMessagePtr(trmsg^.trm_Data)^.am_ArgList^[1].wa_Name),100);
                                      case trmsg^.trm_ID of
                                         1: sprintf(reqstr,"Icon(s) dropped into the left box.\tName of first dropped icon:\n%%3%s",dirname);
                                         2: sprintf(reqstr,"Icon(s) dropped into the right box.\tName of first dropped icon:\n%%3%s",dirname);
                                         ELSE sprintf(reqstr,"Icon(s) dropped into the window.\tName of first dropped icon:\n%%3%s",dirname);
                                      END;
                                      dummy := TR_EasyRequestTags(App,reqstr,"_Ok",
                                      TREZ_LockProject,appwindow_project,TREZ_Title,"AppWindow report",TREZ_Activate,True,TAG_END);
                                    END;
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_UnlockProject(Main_Project);
      TR_CloseProject(appwindow_project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;

PROCEDURE Do_Main;
VAR
    trmsg     : TR_MessagePtr;
    quit      : BOOLEAN;
    dummy     : INTEGER;
    charbuffer : ARRAY [0..255] OF Char;
    reqstr : STRING;
    helpstring : STRING;
    abouttags : ADDRESS;
BEGIN
    reqstr := @charbuffer;

    ProjectStart;
    BeginRequester("About...",TRWP_CENTERDISPLAY);

    VertGroupA; Space;  CenteredText3("Triton Demo 2.0");
              SpaceS; CenteredText("� 1993-1996 by Stefan Zeiger");
              Space;  HorizSeparator;
              Space;  CenteredText("This program is using the");
              SpaceS; CenteredText("Triton GUI creation system");
              SpaceS; CenteredText("which is � by Stefan Zeiger");
              Space;  EndGroup;

    BeginRequesterGads;
    CenteredButtonRE("_Ok",1);
    EndRequester;

    abouttags := CloneTagItems(@tritontags);

    ProjectStart;
    WindowID(10); WindowTitle("Triton Demo");
    WindowPosition(TRWP_CENTERDISPLAY);
    WindowFlags(TRWF_HELP);
    QuickHelpOn(1);
    BeginMenu("Project");
      MenuItem_("?_About...",101);
      ItemBarlabel;
      MenuItem_("H_Help",102);
      MenuItemCC("I_QuickHelp",104);
      ItemBarlabel;
      MenuItem_("Q_Quit",103);
    VertGroupA;
      Space;  CenteredText3("T � r � i � t � o � n");
      Space;  CenteredText3("The object oriented GUI creation system");
      Space;  CenteredText("Demo program for release 2.0");
      Space;  CenteredText("Written and � 1993-1997 by Stefan Zeiger");
      Space;  CenteredText("This demo made in PCQ Pascal");
      Space;  HorizSeparator;
      Space;  HorizGroupEA;
              Space; Button("_Gadgets",1); QuickHelp("Show some fancy gadgets");
              Space; Button("G_roups",2); QuickHelp("Groupies?\nHuh huh...");
              Space; Button("_Text",3); QuickHelp("You know what \'text\' means, huh?");
              Space; EndGroup;
      Space; HorizGroupEA;
              Space; Button("_Connections",4); QuickHelp("So you're super-connected now...");
              Space; Button("_Backfill",5); QuickHelp("United colors of Triton");
              Space; Button("_Disabling",6); QuickHelp("To be or not to be");
              Space; EndGroup;
      Space; HorizGroupEA;
              Space; Button("_AppWindow",7); QuickHelp("Demonstrate AppWindow feature");
              Space; Button("_Menus",8); QuickHelp("A fancy pull-down menu");
              Space; Button("_Lists",9); QuickHelp("� 4 eggs\n� 1/2lbs bread\n� 1l milk\t%3PS: Don't be late");
              Space; EndGroup;
      Space; EndGroup; EndProject;

    Main_Project := TR_OpenProject(App,@tritontags);
    IF Main_Project <> NIL THEN BEGIN
      quit := FALSE;
      WHILE NOT quit DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
          trmsg := TR_GetMsg(app);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = Main_Project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : quit := True;
                 TRMS_NEWVALUE    : IF (trmsg^.trm_ID=104) THEN TR_SetAttribute(Main_Project,0,TRWI_QuickHelp,trmsg^.trm_Data);
                 TRMS_ACTION      : BEGIN
                                      CASE trmsg^.trm_ID OF
                                          1: do_gadgets;
                                          2: do_groups;
                                          3: do_text;
                                          4: do_notification;
                                          5: do_backfill;
                                          6: do_disabling;
                                          7: do_appwindow;
                                          8: do_menus;
                                          9: do_lists;
                                        101: dummy := TR_AutoRequest(App,Main_Project,abouttags);
                                        102: dummy := TR_EasyRequestTags(App,"TO get help, move the mouse pointer over\nany gadget OR menu item AND press <Help>\nor turn on QuickHelp before.","_Ok",TREZ_LockProject,Main_Project,TREZ_Title,"Triton help",TAG_END);
                                        103: quit := True;
                                       END;
                                    END;
                 TRMS_HELP        : BEGIN
                                      helpstring := STRING(TR_GetAttribute(Main_Project,trmsg^.trm_ID,TRDO_QuickHelpString));
                                      IF helpstring <> NIL THEN BEGIN
                                         sprintf(reqstr,"Help FOR object %ld:\n%%h%s",trmsg^.trm_ID,helpstring);
                                      END ELSE BEGIN
                                         sprintf(reqstr,"No help available FOR object %ld.",trmsg^.trm_ID);
                                      END;
                                      dummy := TR_EasyRequestTags(App,reqstr,"_Ok",TREZ_LockProject,Main_Project,TREZ_Title,"Triton help",TAG_END);
                                    END;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
                 ELSE
                 END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL quit OR (trmsg = NIL);
      END;
      TR_CloseProject(Main_Project);
      FreeTagItems(abouttags);
      END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(App)));
END;

BEGIN

    TritonBase := OpenLibrary(TRITONNAME,TRITON14VERSION);
    IF TritonBase = NIL THEN CleanUp("Can't open triton.library v6+.",20);

    App := TR_CreateAppTags(
           TRCA_Name,"TritonDemo",
           TRCA_LongName,"Triton Demo",
           TRCA_Version,"2.0",
           TAG_DONE);
    
    Do_Main;
    CleanUp(NIL,0);
END.





