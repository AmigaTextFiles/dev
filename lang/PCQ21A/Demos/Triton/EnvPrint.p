Program EnvPrint;

(*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1995
 *
 *  (c) 1993-1995 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 *  envprint.c - Envprint 2.0 GUI created with Triton
 *
 *  As you can see below, it is possible to mix the tag format with
 *  the C pre-processor macro format. (Actually I was just too lazy
 *  to transform the whole project definition from tags to macros ;)
 *
 *)

(*
 *  The same goes for PCQ, you can mix the procedure macros
 *  and tags, just use SetTRTag(tag, tagvalue)
 *)

{$I "Include:EasyPCQ/Triton.i"}
{$I "Include:Macros/Tritonmacros.i"}
{$I "Include:Support/Tritonsupport.i"}


PROCEDURE do_demo;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    dummy : INTEGER;
    Project : TR_ProjectPtr;

BEGIN
  ProjectStart;
  WindowID(1); WindowPosition(TRWP_CENTERDISPLAY);
  WindowTitle("EnvPrint 2.0 <THIS IS ONLY A NON-FUNCTIONAL GUI DEMO>");

  BeginMenu("Project");
    BeginSub("Load");
      SubItem("S_Load sender...",1);
      SubItem("D_Load addressee...",2);
      SubItem("C_Load comment...",3);
    BeginSub("Save");
      SubItem("O_Load sender",4);
      SubItem("E_Load addressee",5);
      SubItem("M_Load comment",6);
    BeginSub("Sace as");
      SubItem("U_Load sender as...",7);
      SubItem("T_Load addressee as...",8);
      SubItem("N_Load comment as...",9);
    MenuItem_("F_Delete file...",10);
    ItemBarlabel;
    MenuItem_("P_Print...",11);
    MenuItem_("R_Preferences...",12);
    ItemBarlabel;
    MenuItem_("?_About...",13);
    ItemBarlabel;
    MenuItem_("Q_Quit",14);

  BeginMenu("Edit");
    MenuItem_("W_Swap",15);
    MenuItem_("X_Clear",16);

  HorizGroupA;
    Space;
    VertGroupA;
      HorizGroupEAC;
        VertGroupA;

          Space;

          NamedSeparatorI("Se_nder",101);

          SetTRTag(TROB_Space,          Integer(NIL));

          HorizGroup;
            StringGadget(NIL,101);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_1",1101);
              EndGroup;
            EndGroup;

          SpaceS;

          HorizGroup;
            StringGadget(NIL,102);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_2",1102);
              EndGroup;
            EndGroup;

          SpaceS;

          HorizGroup;
            StringGadget(NIL,103);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_3",1103);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,104);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_4",1104);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,105);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_5",1105);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,106);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_6",1106);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,107);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_7",1107);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,108);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_8",1108);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          Integer(NIL));

          SetTRTag(TRGR_End,            Integer(NIL));

        SetTRTag(TROB_Space,            Integer(NIL));

        SetTRTag(TRGR_Vert,             TRGR_PROPSHARE OR TRGR_ALIGN);

          SetTRTag(TROB_Space,          Integer(NIL));

          NamedSeparatorI("Add_ressee",201);

          SetTRTag(TROB_Space,          Integer(NIL));

          HorizGroup;
            StringGadget(NIL,201);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_!",1201);
              EndGroup;
            EndGroup;

          SpaceS;

          HorizGroup;
            StringGadget(NIL,202);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_\"",1202);
              EndGroup;
            EndGroup;

          SpaceS;

          HorizGroup;
            StringGadget(NIL,203);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_§",1203);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,204);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_$",1204);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,205);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_%%",1205);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,206);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_&",1206);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,207);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_/",1207);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          TRST_SMALL);

          HorizGroup;
            StringGadget(NIL,208);
            SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
              GetEntryButtonS("_(",1208);
              EndGroup;
            EndGroup;

          SetTRTag(TROB_Space,          Integer(NIL));

          SetTRTag(TRGR_End,            Integer(NIL));

        SetTRTag(TRGR_End,              Integer(NIL));

      NamedSeparatorI("Co_mment",301);

      SetTRTag(TROB_Space,              Integer(NIL));

      HorizGroup;
        StringGadget(NIL,301);
        SetTRTag(TRGR_Horiz,0 OR TRGR_FIXHORIZ);;
          GetEntryButtonS("_0",1301);
          EndGroup;
        EndGroup;

      SetTRTag(TROB_Space,              Integer(NIL));

      SetTRTag(TRGR_End,                Integer(NIL));

    SetTRTag(TROB_Space,                Integer(NIL));
    SetTRTag(TROB_Line,                 TROF_VERT OR TROF_RAISED);

    SetTRTag(TROB_Space,                TRST_BIG);

    SetTRTag(TRGR_Vert,                 TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_FIXHORIZ);
      SetTRTag(TROB_Space,              Integer(NIL));
      SetTRTag(TRGR_Horiz,              TRGR_EQUALSHARE OR TRGR_CENTER);
        SetTRTag(TROB_Line,             TROF_HORIZ);
        SetTRTag(TROB_Space,            Integer(NIL));
        SetTRTag(TROB_Text,             Integer(NIL)); SetTRTag(TRAT_Text,  Integer("Load")); SetTRTag(TRAT_Flags, TRTX_TITLE);
        SetTRTag(TROB_Space,            Integer(NIL));
        SetTRTag(TROB_Line,             TROF_HORIZ);
        SetTRTag(TRGR_End,              Integer(NIL));
      SetTRTag(TROB_Space,              Integer(NIL));
      SetTRTag(TROB_Button,             Integer(NIL)); SetTRTag(TRAT_Text,  Integer("_Sender...")); SetTRTag(TRAT_ID, 501);
      SetTRTag(TROB_Space,              TRST_SMALL);
      SetTRTag(TROB_Button,             Integer(NIL)); SetTRTag(TRAT_Text,  Integer("_Addressee...")); SetTRTag(TRAT_ID, 502);
      SetTRTag(TROB_Space,              TRST_SMALL);
      SetTRTag(TROB_Button,             Integer(NIL)); SetTRTag(TRAT_Text,  Integer("_Comment...")); SetTRTag(TRAT_ID, 503);
      SetTRTag(TROB_Space,              Integer(NIL));
      SetTRTag(TRGR_Horiz,              TRGR_EQUALSHARE OR TRGR_CENTER);
        SetTRTag(TROB_Line,             TROF_HORIZ);
        SetTRTag(TROB_Space,            Integer(NIL));
        SetTRTag(TROB_Text,             Integer(NIL)); SetTRTag(TRAT_Text,  Integer("Save")); SetTRTag(TRAT_Flags, TRTX_TITLE);
        SetTRTag(TROB_Space,            Integer(NIL));
        SetTRTag(TROB_Line,             TROF_HORIZ);
        SetTRTag(TRGR_End,              Integer(NIL));
      SetTRTag(TROB_Space,              Integer(NIL));
      SetTRTag(TROB_Button,             Integer(NIL)); SetTRTag(TRAT_Text,  Integer("S_ender...")); SetTRTag(TRAT_ID, 504);
      SetTRTag(TROB_Space,              TRST_SMALL);
      SetTRTag(TROB_Button,             Integer(NIL)); SetTRTag(TRAT_Text,  Integer("A_ddressee...")); SetTRTag(TRAT_ID, 505);
      SetTRTag(TROB_Space,              TRST_SMALL);
      SetTRTag(TROB_Button,             Integer(NIL)); SetTRTag(TRAT_Text,  Integer("C_omment...")); SetTRTag(TRAT_ID, 506);
      SetTRTag(TROB_Space,              TRST_BIG);
      SetTRTag(TROB_Line,               TROF_HORIZ);
      SetTRTag(TROB_Space,              TRST_BIG);
      SetTRTag(TRGR_Horiz,              TRGR_EQUALSHARE);
        SetTRTag(TROB_Button,           Integer(NIL)); SetTRTag(TRAT_Text,  Integer("_Print...")); SetTRTag(TRAT_ID, 507);
        SetTRTag(TROB_Space,            TRST_SMALL);
        SetTRTag(TROB_Button,           Integer(NIL)); SetTRTag(TRAT_Text,  Integer("S_wap")); SetTRTag(TRAT_ID, 508);
        SetTRTag(TRGR_End,              Integer(NIL));
      SetTRTag(TROB_Space,              TRST_SMALL);
      SetTRTag(TRGR_Horiz,              TRGR_EQUALSHARE);
        SetTRTag(TROB_Button,           Integer(NIL)); SetTRTag(TRAT_Text,  Integer("Pre_fs...")); SetTRTag(TRAT_ID, 509);
        SetTRTag(TROB_Space,            TRST_SMALL);
        SetTRTag(TROB_Button,           Integer(NIL)); SetTRTag(TRAT_Text,  Integer("C_lear")); SetTRTag(TRAT_ID, 510);
        SetTRTag(TRGR_End,              Integer(NIL));
      SetTRTag(TROB_Space,              Integer(NIL));
    SetTRTag(TRGR_End,                  Integer(NIL));

    SetTRTag(TROB_Space,                Integer(NIL));

  SetTRTag(TRGR_End,                    Integer(NIL));

  EndProject;

  Project := TR_OpenProject(Triton_App,@tritontags);
    IF Project <> NIL THEN BEGIN
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(Triton_App,0);
        REPEAT
          trmsg := TR_GetMsg(Triton_App);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = Project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
      TR_CloseProject(Project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(Triton_App)));
END;

begin
  IF TR_OpenTriton(TRITON11VERSION,TRCA_Name,"Envprint",
     TRCA_LongName,"EnvPrint GUI demo",
     TRCA_Version,"2.0",TAG_END) then begin
     do_demo;
     TR_CloseTriton();
     Exit(0);
  END ELSE BEGIN
     WriteLN("Can't open triton.library v2+.");
     Exit(20);
  END;
END.


