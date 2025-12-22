/****************************************************************
   This file was created automatically by `FlexCat 2.6'
   from "AMD_CatStrings.cd".

   Do NOT edit by hand!
****************************************************************/

#ifndef AMD_CatStrings_CAT_H
#define AMD_CatStrings_CAT_H


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif


#define CAT_NB_ENTRIES 35

/*
**  Prototypes
*/
#ifdef __cplusplus
extern "C"
{
#endif
extern VOID OpenAMD_CatStringsCatalog(VOID);
extern VOID CloseAMD_CatStringsCatalog(VOID);
#ifdef __cplusplus
}
#endif


struct FC_String {
    const UBYTE *msg;
    LONG id;
};

extern struct FC_String AMD_CatStrings_Strings[CAT_NB_ENTRIES];

#define AMD_AppDescription (AMD_CatStrings_Strings[0].msg)
#define _AMD_AppDescription (AMD_CatStrings_Strings+0)
#define AMD_CycleHelp (AMD_CatStrings_Strings[1].msg)
#define _AMD_CycleHelp (AMD_CatStrings_Strings+1)
#define AMD_ButtonFile (AMD_CatStrings_Strings[2].msg)
#define _AMD_ButtonFile (AMD_CatStrings_Strings+2)
#define AMD_LabelDiffInit (AMD_CatStrings_Strings[3].msg)
#define _AMD_LabelDiffInit (AMD_CatStrings_Strings+3)
#define AMD_LabelDiffMULTI (AMD_CatStrings_Strings[4].msg)
#define _AMD_LabelDiffMULTI (AMD_CatStrings_Strings+4)
#define AMD_LabelDiffSINGLE (AMD_CatStrings_Strings[5].msg)
#define _AMD_LabelDiffSINGLE (AMD_CatStrings_Strings+5)
#define AMD_LabelAdded (AMD_CatStrings_Strings[6].msg)
#define _AMD_LabelAdded (AMD_CatStrings_Strings+6)
#define AMD_LabelRemoved (AMD_CatStrings_Strings[7].msg)
#define _AMD_LabelRemoved (AMD_CatStrings_Strings+7)
#define AMD_LabelChanged (AMD_CatStrings_Strings[8].msg)
#define _AMD_LabelChanged (AMD_CatStrings_Strings+8)
#define AMD_MenuProject (AMD_CatStrings_Strings[9].msg)
#define _AMD_MenuProject (AMD_CatStrings_Strings+9)
#define AMD_MenuOpenFile1 (AMD_CatStrings_Strings[10].msg)
#define _AMD_MenuOpenFile1 (AMD_CatStrings_Strings+10)
#define AMD_MenuOpenFile2 (AMD_CatStrings_Strings[11].msg)
#define _AMD_MenuOpenFile2 (AMD_CatStrings_Strings+11)
#define AMD_MenuAbout (AMD_CatStrings_Strings[12].msg)
#define _AMD_MenuAbout (AMD_CatStrings_Strings+12)
#define AMD_MenuExit (AMD_CatStrings_Strings[13].msg)
#define _AMD_MenuExit (AMD_CatStrings_Strings+13)
#define AMD_ButtonDiff (AMD_CatStrings_Strings[14].msg)
#define _AMD_ButtonDiff (AMD_CatStrings_Strings+14)
#define AMD_AboutWinTitle (AMD_CatStrings_Strings[15].msg)
#define _AMD_AboutWinTitle (AMD_CatStrings_Strings+15)
#define AMD_AboutToolsIntroduction (AMD_CatStrings_Strings[16].msg)
#define _AMD_AboutToolsIntroduction (AMD_CatStrings_Strings+16)
#define AMD_CycleAdded (AMD_CatStrings_Strings[17].msg)
#define _AMD_CycleAdded (AMD_CatStrings_Strings+17)
#define AMD_CycleChanged (AMD_CatStrings_Strings[18].msg)
#define _AMD_CycleChanged (AMD_CatStrings_Strings+18)
#define AMD_CycleRemoved (AMD_CatStrings_Strings[19].msg)
#define _AMD_CycleRemoved (AMD_CatStrings_Strings+19)
#define AMD_DiffCmdError (AMD_CatStrings_Strings[20].msg)
#define _AMD_DiffCmdError (AMD_CatStrings_Strings+20)
#define AMD_Author (AMD_CatStrings_Strings[21].msg)
#define _AMD_Author (AMD_CatStrings_Strings+21)
#define AMD_Version (AMD_CatStrings_Strings[22].msg)
#define _AMD_Version (AMD_CatStrings_Strings+22)
#define AMD_CompilationDate (AMD_CatStrings_Strings[23].msg)
#define _AMD_CompilationDate (AMD_CatStrings_Strings+23)
#define AMD_StartState (AMD_CatStrings_Strings[24].msg)
#define _AMD_StartState (AMD_CatStrings_Strings+24)
#define AMD_ReqChoose (AMD_CatStrings_Strings[25].msg)
#define _AMD_ReqChoose (AMD_CatStrings_Strings+25)
#define AMD_AboutDiffPart (AMD_CatStrings_Strings[26].msg)
#define _AMD_AboutDiffPart (AMD_CatStrings_Strings+26)
#define AMD_ToolBarOpen (AMD_CatStrings_Strings[27].msg)
#define _AMD_ToolBarOpen (AMD_CatStrings_Strings+27)
#define AMD_ToolBarEdit (AMD_CatStrings_Strings[28].msg)
#define _AMD_ToolBarEdit (AMD_CatStrings_Strings+28)
#define AMD_ToolBarSave (AMD_CatStrings_Strings[29].msg)
#define _AMD_ToolBarSave (AMD_CatStrings_Strings+29)
#define AMD_ToolBarReload (AMD_CatStrings_Strings[30].msg)
#define _AMD_ToolBarReload (AMD_CatStrings_Strings+30)
#define AMD_MenuReloadFile1 (AMD_CatStrings_Strings[31].msg)
#define _AMD_MenuReloadFile1 (AMD_CatStrings_Strings+31)
#define AMD_MenuReloadFile2 (AMD_CatStrings_Strings[32].msg)
#define _AMD_MenuReloadFile2 (AMD_CatStrings_Strings+32)
#define AMD_MenuEditFile1 (AMD_CatStrings_Strings[33].msg)
#define _AMD_MenuEditFile1 (AMD_CatStrings_Strings+33)
#define AMD_MenuEditFile2 (AMD_CatStrings_Strings[34].msg)
#define _AMD_MenuEditFile2 (AMD_CatStrings_Strings+34)

#endif       
