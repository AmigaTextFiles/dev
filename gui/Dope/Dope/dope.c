//
// Set DCCOPTS
//
// Use
//
// dcc -v -mRR -mi -proto -ms -lmui -lc -lamiga30s dope.c
//
// to compile
//
//
// This little hack is only a MUI-GUI for a program which sets the environment
// variable DCCOPTS.
//
// I've written it to play around with MUIs macro-language.
//
// If anyone will make a useful program from it, please inform me!
//
// Engelbert Roidl
// e-mail: engelbert.roidl@extern.uni-regensburg.de
//

#include "dope.h"

enum pg {
    PG_Misc, PG_Cpp, PG_Code, PG_Link, PG_Debug
    };

enum id {
    ID_DUMMY,
    ID_REGISTER,

    // Window
    ID_CANCEL, ID_USE, ID_SAVE,

    // Misc-Id
    ID_TIMESTAMP, ID_UNIX, ID_CPP, ID_TMPDIR, ID_OUTDIR, ID_STDERR, ID_OUTTYPE,
    ID_RESIDENT, ID_STMPDIR, ID_SOUTDIR, ID_SSTDERR,

    // CPP
    ID_REMDEFIP, ID_UDEF, ID_PROTO, ID_ADDDEF, ID_REMDEF, ID_ADDIP, ID_REMIP, ID_UPIP, ID_DOWNIP,
    ID_DEFLV, ID_IPLV,

    // Codegeneration
    ID_PROC, ID_COPROC, ID_CODE, ID_DATA, ID_CONST, ID_REG, ID_INLINE, ID_DYNSTACK,

    // Linker
    ID_DEFLIB, ID_DEFLIBP, ID_SECNAM, ID_COMBHUNK, ID_CHIP, ID_FFP,
    ID_ADDLIB, ID_REMLIB, ID_UPLIB, ID_DOWNLIB,
    ID_ADDLP, ID_REMLP, ID_UPLP, ID_DOWNLP,
    ID_LINKLV, ID_PATHLV,

    // Debug
    ID_PROF, ID_SYM, ID_DEBUG, ID_LEVEL

    };


int main(int argc, char *argv[])
{
    ULONG act,wert;
    char *line;

    APTR app, window;
    ULONG signals;
    BOOL running = TRUE;

    Object *reg;

    Object *CM_UseTimestamp, *CM_UseUNIX, *CM_UseCpp;
    Object *PD_TmpDir, *PD_OutDir, *PF_STDERR;
    Object *PS_TmpDir, *PS_OutDir, *PS_STDERR;
    Object *CY_Outputtype, *CY_Resident;

    Object *CM_RemDefIPath, *CM_UnDef, *CM_ProtCheckAndOpt;
    Object *BT_AddIncP, *BT_RemIncP, *BT_UpIncP, *BT_DownIncP;
    Object *BT_AddDef, *BT_RemDef;
    Object *LV_Defines, *LV_DefPath;

    Object *CY_Proc, *CY_CoProc, *CY_Code, *CY_Data, *CY_Con;
    Object *CM_Reg, *CM_In, *CM_Dyn;

    Object *BT_AddLib, *BT_RemLib, *BT_UpLib, *BT_DownLib;
    Object *BT_AddLibP, *BT_RemLibP, *BT_UpLibP, *BT_DownLibP;
    Object *LV_LibSP, *LV_AddLib;
    Object *CM_LinkDefLib, *CM_RemDefLP, *CM_AltSName, *CM_CombHunk, *CM_Chip, *CM_Ffp;

    Object *CY_Prof, *CM_Sym, *CM_Debug, *ST_DebugLevel;

    Object *BT_Save, *BT_Use, *BT_Cancel;

    char *Pages[] = { "Misc", "CPP" , "Codegeneration" , "Linker" , "Debug" , NULL };
    char *Outputtype[] = { "Executable" , "do not link" , "do not assemble" , NULL };
    char *Resident[] = { "Nonresident",
                         "Resident with seperate CODE & DATA hunks",
                         "Resident with no RELOC hunks",
                         "Nonresident with no RELOC hunks",
                         NULL
                       };

    char *Proc[] = { "680x0", "68020", "68030", NULL };
    char *CoProc[] = { "None", "68881", "68882", NULL };
    char *Code[] = {"small code", "large code", NULL};
    char *Data[] = {"small data", "large data", NULL};
    char *Con[] = {"Default const handling",
                   "const objects into CODE hunk",
                   "string constants into read-only code hunk",
                   "string const into read-only code hunks AND NEAR adr. for all ext. const refs",
                   NULL
                  };

    char *Prof[] = { "No profiling",
                     "Enable profiling for source modules",
                     "Enable profiling for source modules and c*.lib",
                     "Enable profiling for source modules, c*.lib and amiga*.lib",
                     NULL
                   };


    app=ApplicationObject,
            MUIA_Application_Author, "Engelbert Roidl",
            MUIA_Application_Base, "DOPE",
            MUIA_Application_Title, "DopE ",
            MUIA_Application_Version, "$VER: DopE 1.001 (28 Feb 1994)",
            MUIA_Application_Copyright, "© 1994 by Engelbert Roidl",
            MUIA_Application_Description, "Sets Diceoptions (DCCOPTS)",
            MUIA_HelpFile, "HELP:Dope.guide",

            SubWindow, window = WindowObject,
                MUIA_Window_Title,  "DopE V1.0 ©1994 Engelbert Roidl",
                MUIA_Window_ID,     MAKE_ID('D','O','P','E'),

                WindowContents, VGroup,

                    Child, RegisterGroup(Pages),
                        GroupFrame,
                        MUIA_Register_Frame, TRUE,

                        // Page 1 : Misc
                        Child, VGroup,
                                // GroupFrameT("Misc"),
                                // GroupFrame,
                                //MUIA_Register_Frame, TRUE,

                                Child, HGroup,
                                    Child, Label1("Check timestamps"), Child, CM_UseTimestamp = CheckMark(FALSE),
                                    Child, Label1("Use UNIX names"), Child, CM_UseUNIX = CheckMark(FALSE),
                                    Child, Label1("Use C++ style comments"), Child, CM_UseCpp = CheckMark(FALSE),
                                End,

                                Child, ColGroup(2),
                                    Child, Label2("Temporary directory"),
                                    Child, PD_TmpDir = PopaslObject,
                                            MUIA_Popstring_String, PS_TmpDir = KeyString(0,256,'t'),
                                            MUIA_Popstring_Button, PopButton(MUII_PopDrawer),
                                            ASLFR_TitleText  , "Please select a directory for temporary files",
                                            ASLFR_DrawersOnly, TRUE,
                                    End,
                                    Child, Label2("Output directory"),
                                    Child, PD_OutDir = PopaslObject,
                                            MUIA_Popstring_String, PS_OutDir = KeyString(0,256,'o'),
                                            MUIA_Popstring_Button, PopButton(MUII_PopDrawer),
                                            ASLFR_TitleText  , "Please select a drawer...",
                                            ASLFR_DrawersOnly, TRUE,
                                    End,
                                    Child, Label2("STDERR file"),
                                    Child, PF_STDERR = PopaslObject,
                                            MUIA_Popstring_String, PS_STDERR = KeyString(0,256,'e'),
                                            MUIA_Popstring_Button, PopButton(MUII_PopFile),
                                            ASLFR_TitleText, "Please select a file...",
                                    End,
                                End,

                                Child, HGroup,
                                    Child, CY_Outputtype = Cycle(Outputtype),
                                    Child, CY_Resident = Cycle(Resident),
                                End,

                        End,

                        // Page 2 : CPP
                        Child, VGroup,
                            // GroupFrameT("CPP"),
                            // GroupFrame,
                            MUIA_Register_Frame, TRUE,

                            Child, ColGroup(2),
                                Child, Label1("Remove default include path"),
                                Child, CM_RemDefIPath = CheckMark(FALSE),
                                Child, Label1("Undefine __STDC__, mc68000, _DCC, AMIGA"),
                                Child, CM_UnDef = CheckMark(FALSE),
                                Child, Label1("Prototype checking and optimizations"),
                                Child, CM_ProtCheckAndOpt= CheckMark(FALSE),
                            End,

                            Child, HGroup,
                                Child, VGroup,
                                    GroupSpacing(0),
                                    GroupFrameT("Defines"),
                                    MUIA_HorizWeight, 150,
                                    Child, LV_Defines = ListviewObject,
                                        MUIA_Listview_Input, TRUE,
                                        MUIA_Listview_List,
                                        ListObject,
                                            InputListFrame,
                                            MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
                                            MUIA_List_DestructHook, MUIV_List_DestructHook_String,
                                        End,
                                    End,
                                    Child, HGroup,
                                        GroupSpacing(0),
                                        Child, BT_AddDef = KeyButton("Add",'d'), MUIA_Weight, 150,
                                        Child, BT_RemDef = KeyButton("Remove",'e'), MUIA_Weight, 200,
                                    End,
                                End,

                                Child, VGroup,
                                    GroupSpacing(0),
                                    GroupFrameT("Include Path"),
                                    MUIA_HorizWeight, 50,
                                    Child, LV_DefPath = ListviewObject,
                                        MUIA_Listview_Input, TRUE,
                                        MUIA_Listview_List,
                                        ListObject,
                                            InputListFrame,
                                            MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
                                            MUIA_List_DestructHook, MUIV_List_DestructHook_String,
                                        End,
                                    End,
                                    Child, HGroup,
                                        GroupSpacing(0),
                                        Child, BT_AddIncP = KeyButton("Add",'a'),
                                        Child, BT_RemIncP = KeyButton("Remove",'r'),
                                        Child, BT_UpIncP  = KeyButton("Up",'u'),
                                        Child, BT_DownIncP= KeyButton("Down",'d'),
                                    End,
                                End,
                            End,
                        End,
                        // Page 3 : CodeGeneration
                        Child, VGroup,
                                // GroupFrameT("Codegeneration"),
                                // GroupFrame,
                                MUIA_Register_Frame, TRUE,
                                Child, HGroup,
                                    Child, CY_Proc = Cycle(Proc),
                                    Child, CY_CoProc = Cycle(CoProc),
                                    Child, CY_Code = Cycle(Code),
                                    Child, CY_Data = Cycle(Data),
                                End,
                                Child, CY_Con = Cycle(Con),

                                Child, HGroup,
                                    Child, Label1("Use registered arguments"), Child, CM_Reg = CheckMark(FALSE),
                                    Child, Label1("Use inline library calls"), Child, CM_In = CheckMark(FALSE),
                                    Child, Label1("Dynamic stack code"), Child, CM_Dyn = CheckMark(FALSE),
                                End,
                        End,
                        // Page 4 : Linker
                        Child, VGroup,
                                // GroupFrameT("Linker"),
                                // GroupFrame,
                                MUIA_Register_Frame, TRUE,

                                Child, ColGroup(4),
                                        Child, Label1("Do not link default libraries"),
                                        Child, CM_LinkDefLib = CheckMark(FALSE),
                                        Child, Label1("Remove default library search path"),
                                        Child, CM_RemDefLP = CheckMark(FALSE),
                                        Child, Label1("Alternate section naming"),
                                        Child, CM_AltSName = CheckMark(FALSE),
                                        Child, Label1("Do not combine all code hunks"),
                                        Child, CM_CombHunk = CheckMark(FALSE),
                                        Child, Label1("Force all hunks into CHIP Mem"),
                                        Child, CM_Chip = CheckMark(FALSE),
                                        Child, Label1("Use fp library for floats"),
                                        Child, CM_Ffp = CheckMark(FALSE),
                                End,

                                Child, HGroup,
                                    Child, VGroup,
                                        GroupSpacing(0),
                                        GroupFrameT("Link additional Libraries"),
                                        MUIA_HorizWeight, 50,
                                        Child, LV_AddLib = ListviewObject,
                                            MUIA_Listview_Input, TRUE,
                                            MUIA_Listview_List,
                                            ListObject,
                                                InputListFrame,
                                                MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
                                                MUIA_List_DestructHook, MUIV_List_DestructHook_String,
                                            End,
                                        End,
                                        Child, HGroup,
                                            GroupSpacing(0),
                                            Child, BT_AddLib = KeyButton("Add",'a'),
                                            Child, BT_RemLib = KeyButton("Remove",'r'),
                                            Child, BT_UpLib  = KeyButton("Up",'u'),
                                            Child, BT_DownLib= KeyButton("Down",'d'),
                                        End,
                                    End,
                                    Child, VGroup,
                                        GroupSpacing(0),
                                        GroupFrameT("Library searchpath"),
                                        MUIA_HorizWeight, 100,
                                        Child, LV_LibSP = ListviewObject,
                                            MUIA_Listview_Input, TRUE,
                                            MUIA_Listview_List,
                                            ListObject,
                                                InputListFrame,
                                                MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
                                                MUIA_List_DestructHook, MUIV_List_DestructHook_String,
                                            End,
                                        End,
                                        Child, HGroup,
                                            GroupSpacing(0),
                                            Child, BT_AddLibP = KeyButton("Add",'d'),
                                            Child, BT_RemLibP = KeyButton("Remove",'e'),
                                            Child, BT_UpLibP  = KeyButton("Up",'p'),
                                            Child, BT_DownLibP= KeyButton("Down",'o'),
                                        End,
                                    End,
                                End,
                        End,
                        // Page 5 : Debug
                        Child, VGroup,
                                // GroupFrameT("Debug"),
                                // GroupFrame,
                                MUIA_Register_Frame, TRUE,
                                Child, CY_Prof = Cycle(Prof),
                                Child, HGroup,
                                    Child, Label1("Include symbolic debugging information in the executable"),
                                    Child, CM_Sym = CheckMark(FALSE),
                                End,

                                Child, HGroup,
                                    Child, CM_Debug = CheckMark(FALSE),
                                    Child, Label2("Debug Level"),
                                    Child, ST_DebugLevel = String("",2), MUIA_Weight, 5,
                                End,
                        End,
                    End,

                    Child, HGroup, MUIA_Group_SameSize, TRUE,
                            Child, BT_Save   = KeyButton("Save",'s'),
                            Child, HSpace(0),
                            Child, BT_Use    = KeyButton("Use",'u'),
                            Child, HSpace(0),
                            Child, BT_Cancel = KeyButton("Cancel",'c'),
                    End,
                End,
            End,
        End;

            if(!app)
                fail(app,"Failed to create Application.");

        // Window
        DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE, app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
        DoMethod(BT_Cancel, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_CANCEL);
        DoMethod(BT_Use, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_USE);
        DoMethod(BT_Save, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_SAVE);

        // Register
        // DoMethod(reg, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_REGISTER);

        // Misc Methods
        DoMethod(CM_UseTimestamp, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_TIMESTAMP);
        DoMethod(CM_UseUNIX, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_UNIX);
        DoMethod(CM_UseCpp, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_CPP);

        DoMethod(PD_TmpDir, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_TMPDIR);
        DoMethod(PD_OutDir, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_OUTDIR);
        DoMethod(PF_STDERR, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_STDERR);

        DoMethod(PS_TmpDir, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_STMPDIR);
        DoMethod(PS_OutDir, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_SOUTDIR);
        DoMethod(PS_STDERR, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_SSTDERR);

        DoMethod(CY_Outputtype, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_OUTTYPE);
        DoMethod(CY_Resident, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_RESIDENT);

        // CPP
        DoMethod(CM_RemDefIPath, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_REMDEFIP);
        DoMethod(CM_UnDef, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_UDEF);
        DoMethod(CM_ProtCheckAndOpt, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_PROTO);

        DoMethod(LV_Defines, MUIM_Notify, MUIA_List_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_DEFLV);

        DoMethod(BT_AddDef, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_ADDDEF);
        DoMethod(BT_RemDef, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_REMDEF);

        DoMethod(LV_DefPath, MUIM_Notify, MUIA_List_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_IPLV);

        DoMethod(BT_AddIncP, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_ADDIP);
        DoMethod(BT_RemIncP, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_REMIP);
        DoMethod(BT_UpIncP, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_UPIP);
        DoMethod(BT_DownIncP, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_DOWNIP);


        // Codegeneration
        DoMethod(CY_Proc, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_PROC);
        DoMethod(CY_CoProc, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_COPROC);
        DoMethod(CY_Code, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_CODE);
        DoMethod(CY_Data, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_DATA);
        DoMethod(CY_Con, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_CONST);

        DoMethod(CM_Reg, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_REG);
        DoMethod(CM_In, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_INLINE);
        DoMethod(CM_Dyn, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_DYNSTACK);

        // Linker
        DoMethod(CM_LinkDefLib, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_DEFLIB);
        DoMethod(CM_RemDefLP, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_DEFLIBP);
        DoMethod(CM_AltSName, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_SECNAM);
        DoMethod(CM_CombHunk, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_COMBHUNK);
        DoMethod(CM_Chip, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_CHIP);
        DoMethod(CM_Ffp, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_FFP);

        DoMethod(LV_AddLib, MUIM_Notify, MUIA_List_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_LINKLV);

        DoMethod(BT_AddLib, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_ADDLIB);
        DoMethod(BT_RemLib, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_REMLIB);
        DoMethod(BT_UpLib, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_UPLIB);
        DoMethod(BT_DownLib, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_DOWNLIB);

        DoMethod(LV_LibSP, MUIM_Notify, MUIA_List_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_PATHLV);

        DoMethod(BT_AddLibP, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_ADDLP);
        DoMethod(BT_RemLibP, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_REMLP);
        DoMethod(BT_UpLibP, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_UPLP);
        DoMethod(BT_DownLibP, MUIM_Notify, MUIA_Pressed, FALSE, app, 2, MUIM_Application_ReturnID, ID_DOWNLP);

        // Debug
        DoMethod(CY_Prof, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_PROF);

        DoMethod(CM_Sym, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_SYM);
        DoMethod(CM_Debug, MUIM_Notify, MUIA_Pressed, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_DEBUG);

        DoMethod(ST_DebugLevel, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, app, 2, MUIM_Application_ReturnID, ID_LEVEL);


        set(window,MUIA_Window_Open,TRUE);

        while (running)
        {
                switch (DoMethod(app,MUIM_Application_Input,&signals))
                {
                        case MUIV_Application_ReturnID_Quit:
                        case ID_CANCEL:
                                printf("Cancel\n");
                                running = FALSE;
                                break;
                        case ID_USE:
                                printf("Use\n");
                                running = FALSE;
                                break;
                        case ID_SAVE:
                                printf("Save\n");
                                running = FALSE;
                                break;
                        case ID_REGISTER:
                                printf("Reg\n");
                                break;

                        // Misc
                        case ID_TIMESTAMP:
                        case ID_UNIX:
                        case ID_CPP:
                        case ID_TMPDIR:
                        case ID_OUTDIR:
                        case ID_STDERR:
                        case ID_OUTTYPE:
                        case ID_RESIDENT:
                        case ID_STMPDIR:
                        case ID_SOUTDIR:
                        case ID_SSTDERR:
                            break;

                        // CPP
                        case ID_REMDEFIP:
                        case ID_UDEF:
                        case ID_PROTO:
                        case ID_ADDDEF:
                        case ID_REMDEF:
                        case ID_ADDIP:
                        case ID_REMIP:
                        case ID_UPIP:
                        case ID_DOWNIP:
                        case ID_DEFLV:
                        case ID_IPLV:
                            break;

                        // Codegeneration
                        case ID_PROC:
                        case ID_COPROC:
                        case ID_CODE:
                        case ID_DATA:
                        case ID_CONST:
                        case ID_REG:
                        case ID_INLINE:
                        case ID_DYNSTACK:
                            break;

                        // Linker
                        case ID_DEFLIB:
                        case ID_DEFLIBP:
                        case ID_SECNAM:
                        case ID_COMBHUNK:
                        case ID_CHIP:
                        case ID_FFP:
                        case ID_ADDLIB:
                        case ID_REMLIB:
                        case ID_UPLIB:
                        case ID_DOWNLIB:
                        case ID_ADDLP:
                        case ID_REMLP:
                        case ID_UPLP:
                        case ID_DOWNLP:
                        case ID_LINKLV:
                        case ID_PATHLV:
                            break;

                        // Debug
                        case ID_PROF:
                        case ID_SYM:
                        case ID_DEBUG:
                        case ID_LEVEL:
                            break;
                }
                if (signals)
                {
                    Wait(signals);
                }
        }

        set(window,MUIA_Window_Open,FALSE);


/*
** Shut down...
*/

        fail(app,NULL);
 }
