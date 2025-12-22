PROGRAM Main;

(*
** This is a part from Stefans demo.c
** It's the mainwindow, just to check that
** the menus and helpstuff worked ok. They did.:-)
**
** To see the quickhelp check the quickhelpmenu.
**
** Nils Sjoholm    nils.sjoholm@mailbox.swipnet.se
**
** Date May 1 1996
**
*)

{$I "Include:Libraries/Triton.i"}   (* You can also use PCQUtils/triton.i *)
{$I "Include:Exec/Libraries.i"}
{$I "Include:Utils/TagUtils.i"}
{$I "Include:Utility/Utility.i"}


VAR
    App       : TR_AppPtr;
    Project   : TR_ProjectPtr;
    trmsg     : TR_MessagePtr;
    quit      : Boolean;
    TagList   : ADDRESS;
    dummy     : Integer;

PROCEDURE CleanExit(errstring : STRING; rc : Integer);
BEGIN
    IF Project <> NIL THEN TR_CloseProject(Project);
    IF App <> NIL THEN TR_DeleteApp(App);
    IF TritonBase <> NIL THEN CloseLibrary(TritonBase);
    IF UtilityBase <> NIL THEN CloseLibrary(UtilityBase);
    IF errstring <> NIL THEN WriteLN(errstring);
    EXIT(rc)
END;

BEGIN
    UtilityBase := OpenLibrary("utility.library",0);
    IF UtilityBase = NIL THEN CleanExit("No utility.library",20);

    TritonBase := OpenLibrary(TRITONNAME,TRITON14VERSION);
    IF TritonBase = NIL THEN CleanExit("No triton.library",0);
    

    TagList := CreateTagList(
                     TRCA_Name,"Test",
                     TRCA_LongName,"Lång test",
                     TRCA_Version,"0.01",
                     TAG_DONE);
    App := TR_CreateApp(TagList);
    FreeTagItems(TagList);
    
(*
** This are the macros for Main.p
**

#include "pcq:macros/triton.macros"

ProjectDefinition(TagList)
  WindowID(10), WindowTitle("Triton Demo"),
  WindowPosition(TRWP_CENTERDISPLAY),
  WindowFlags(TRWF_HELP),
  BeginMenu("Project"),
    MenuItem("?_About...",101),
    ItemBarlabel,
    MenuItem("H_Help",102),
    MenuItemC("I_QuickHelp",104),
    ItemBarlabel,
    MenuItem("Q_Quit",103),
  VertGroupA,
    Space,  CenteredText3("T · r · i · t · o · n"),
    Space,  CenteredText3("The object oriented GUI creation system"),
    Space,  CenteredText("Demo program for release 1.4"),
    Space,  CenteredText("Written and © 1993-1995 BY Stefan Zeiger"),
    Space,  CenteredText("This demo made in PCQ Pascal"),
    Space,  HorizSeparator,
    Space,  HorizGroupEA,
              Space, Button("_Gadgets",1), QuickHelp("Show some gadget types"),
              Space, Button("G_roups",2), QuickHelp("Show group types"),
              Space, Button("_Text",3), QuickHelp("Show text types"),
              Space, EndGroup,
    Space, HorizGroupEA,
              Space, Button("_Connections",4), QuickHelp("Demonstrate object notification"),
              Space, Button("_Backfill",5), QuickHelp("Show basic backfill types"),
              Space, Button("_Disabling",6), QuickHelp("Show disabled objects"),
              Space, EndGroup,
    Space, HorizGroupEA,
              Space, Button("_AppWindow",7), QuickHelp("Demonstrate AppWindow feature"),
              Space, Button("_Menus",8), QuickHelp("Show a sample menu"),
              Space, Button("_Lists",9), QuickHelp("Show listview gadgets"),
              Space, EndGroup,
    Space, EndGroup, EndProject

** end of macros
**
** To get a taglist from this macros
** Save the macros as xxxxx.macros or what ever.
** Let MakePCQTags.rexx translate them.
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
**       There were 238 commas in the file
**       So you need a taglist with a value of at least 119 tags
**
*)

     TagList := CreateTagList(
          TRWI_ID,(10),
          TRWI_Title,("Triton Demo"),
          TRWI_Position,(TRWP_CENTERDISPLAY),
          TRWI_Flags,(TRWF_HELP),
          TRMN_Title,("Project"),
          TRMN_Item,("?_About..."),
          TRAT_ID,101,
          TRMN_Item,TRMN_BARLABEL,
          TRMN_Item,("H_Help"),
          TRAT_ID,102,
          TRMN_Item,("I_QuickHelp"),
          TRMN_Flags,TRMF_CHECKIT,
          TRAT_ID,104,
          TRMN_Item,TRMN_BARLABEL,
          TRMN_Item,("Q_Quit"),
          TRAT_ID,103,
          TRGR_Vert,TRGR_ALIGN,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSPACES + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"T · r · i · t · o · n",
          TRAT_Flags,TRTX_3D,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSPACES + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"The object oriented GUI creation system",
          TRAT_Flags,TRTX_3D,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSPACES + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"Demo program for release 1.4",
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSPACES + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"Written and © 1993-1995 BY Stefan Zeiger",
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_PROPSPACES + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Text,0,
          TRAT_Text,"This demo made in PCQ Pascal",
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_CENTER,
          TROB_Space,TRST_NORMAL,
          TROB_Line,TROF_HORIZ,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_ALIGN,
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_Gadgets"),
          TRAT_ID,(1),
          TRDO_QuickHelpString,(("Show some gadget types")),
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("G_roups"),
          TRAT_ID,(2),
          TRDO_QuickHelpString,(("Show group types")),
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_Text"),
          TRAT_ID,(3),
          TRDO_QuickHelpString,(("Show text types")),
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_ALIGN,
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_Connections"),
          TRAT_ID,(4),
          TRDO_QuickHelpString,(("Demonstrate object notification")),
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_Backfill"),
          TRAT_ID,(5),
          TRDO_QuickHelpString,(("Show basic backfill types")),
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_Disabling"),
          TRAT_ID,(6),
          TRDO_QuickHelpString,(("Show disabled objects")),
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_Horiz,TRGR_EQUALSHARE + TRGR_ALIGN,
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_AppWindow"),
          TRAT_ID,(7),
          TRDO_QuickHelpString,(("Demonstrate AppWindow feature")),
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_Menus"),
          TRAT_ID,(8),
          TRDO_QuickHelpString,(("Show a sample menu")),
          TROB_Space,TRST_NORMAL,
          TROB_Button,0,
          TRAT_Text,("_Lists"),
          TRAT_ID,(9),
          TRDO_QuickHelpString,(("Show listview gadgets")),
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TROB_Space,TRST_NORMAL,
          TRGR_End,0,
          TAG_END);

   
    Project := TR_OpenProject(App,TagList);
    FreeTagItems(TagList);

    quit := False;
    WHILE NOT quit DO BEGIN
        dummy := TR_Wait(app,0);
        REPEAT
             trmsg := TR_GetMsg(app);
             IF (trmsg^.trm_Project = Project) THEN BEGIN
                 CASE trmsg^.trm_Class OF
                    TRMS_CLOSEWINDOW : quit := True;
                    TRMS_NEWVALUE    : IF (trmsg^.trm_ID=104) THEN TR_SetAttribute(project,0,TRWI_QuickHelp,trmsg^.trm_Data);
                    TRMS_ACTION      : IF (trmsg^.trm_ID=103) THEN quit := True;
                 ELSE
                 END;
             END;
             TR_ReplyMsg(trmsg);
        UNTIL quit OR (trmsg = NIL);
    END;
    CleanExit(NIL,0);
END.





