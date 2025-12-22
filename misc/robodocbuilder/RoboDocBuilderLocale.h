#ifndef RoboDocBuilderLOCALE_H
#define RoboDocBuilderLOCALE_H


/****************************************************************************/


/* This file was created automatically by CatComp.
 * Do NOT edit by hand!
 */


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifdef CATCOMP_ARRAY
#undef CATCOMP_NUMBERS
#undef CATCOMP_STRINGS
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#endif

#ifdef CATCOMP_BLOCK
#undef CATCOMP_STRINGS
#define CATCOMP_STRINGS
#endif


/****************************************************************************/


#ifdef CATCOMP_NUMBERS

#define MSG_RD_STITLE 0
#define MSG_RD_WTITLE 1
#define MSG_FMT_ABOUT 2
#define MSG_RD_TT_TOOLEDITOR 3
#define MSG_RD_TT_TABSIZE 4
#define MSG_RD_TT_BUILDCMD 5
#define MSG_RD_TT_TMPPATH 6
#define MSG_RD_TT_CMDPATH 7
#define MSG_RD_TT_STRIDCHR 8
#define MSG_RD_TT_DEFEDITOR 9
#define MSG_RD_TT_DEFLANG 10
#define MSG_RD_TT_DEFOUTPUT 11
#define MSG_ASL_RTITLE 12
#define MSG_ASL_OKAY_BT 13
#define MSG_ASL_CANCEL_BT 14
#define MSG_MENU_PROJECT 15
#define MSG_MENU_Edit 16
#define MSG_MENU_About 17
#define MSG_MENU_Help 18
#define MSG_MENU_Quit 19
#define MSG_MENU_PREFERENCES 20
#define MSG_MENU_Source 21
#define MSG_MENU_Assembly 22
#define MSG_MENU_C 23
#define MSG_MENU_BASIC 24
#define MSG_MENU_FORTRAN 25
#define MSG_MENU_LaTeX 26
#define MSG_MENU_TeX 27
#define MSG_MENU_PostScript 28
#define MSG_MENU_Output 29
#define MSG_MENU_ASCII 30
#define MSG_MENU_AmigaGuide 31
#define MSG_MENU_HTML 32
#define MSG_MENU_RTF 33
#define MSG_MENU_Sort 34
#define MSG_MENU_Add 35
#define MSG_MENU_Include 36
#define MSG_MENU_Internal 37
#define MSG_TTYPE_Main 38
#define MSG_TTYPE_Header 39
#define MSG_TTYPE_Internal 40
#define MSG_TTYPE_Full 41
#define MSG_GAD_InFileStr 42
#define MSG_GAD_InFileASL 43
#define MSG_GAD_OutputStr 44
#define MSG_GAD_OutputASL 45
#define MSG_GAD_TabSizeInt 46
#define MSG_GAD_EditSrcBt 47
#define MSG_GAD_EditTmpBt 48
#define MSG_GAD_GenerateBt 49
#define MSG_GAD_XRefStr 50
#define MSG_GAD_XRefASL 51
#define MSG_GAD_GenXRefBt 52
#define MSG_GAD_UseListBt 53
#define MSG_GAD_RDDefsLV 54
#define MSG_GAD_EditRDBt 55
#define MSG_ITXT_RD0 56
#define MSG_DONE_GENERATING 57
#define MSG_SYSTEM_PROBLEM 58
#define MSG_USER_ERROR 59
#define MSG_ABOUT 60
#define MSG_NO_INP_FILENAME 61
#define MSG_NO_OUT_FILENAME 62
#define MSG_FMT_BAD_CMD 63
#define MSG_CHK_TOOL 64
#define MSG_FMT_NO_FILEOPEN 65
#define MSG_FMT_LIB_UNOPENED 66
#define MSG_FILE_WRITE_ERR 67
#define MSG_FMT_NOGUI_ERR 68

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_RD_STITLE_STR "RoboDocBuilder ©1998-2004 by J.T. Steichen"
#define MSG_RD_WTITLE_STR "RoboDocBuilder ©1998-2004 by J.T. Steichen"
#define MSG_FMT_ABOUT_STR "%s was written by %s using the SAS-C compiler V6.58.\n\n   I can be reached at %s"
#define MSG_RD_TT_TOOLEDITOR_STR "TOOLEDITOR"
#define MSG_RD_TT_TABSIZE_STR "TABSIZE"
#define MSG_RD_TT_BUILDCMD_STR "BUILDCOMMAND"
#define MSG_RD_TT_TMPPATH_STR "TEMPLATEPATH"
#define MSG_RD_TT_CMDPATH_STR "COMMANDPATH"
#define MSG_RD_TT_STRIDCHR_STR "STRINGIDCHAR"
#define MSG_RD_TT_DEFEDITOR_STR "DEFAULTEDITOR"
#define MSG_RD_TT_DEFLANG_STR "DEFAULTLANGUAGE"
#define MSG_RD_TT_DEFOUTPUT_STR "DEFAULTOUTPUT"
#define MSG_ASL_RTITLE_STR "Enter a File Name..."
#define MSG_ASL_OKAY_BT_STR " OKAY! "
#define MSG_ASL_CANCEL_BT_STR " CANCEL! "
#define MSG_MENU_PROJECT_STR "PROJECT"
#define MSG_MENU_Edit_STR "Edit ToolTypes..."
#define MSG_MENU_About_STR "About.."
#define MSG_MENU_Help_STR "Help!"
#define MSG_MENU_Quit_STR "Quit"
#define MSG_MENU_PREFERENCES_STR "PREFERENCES"
#define MSG_MENU_Source_STR "Source Type »"
#define MSG_MENU_Assembly_STR "Assembly"
#define MSG_MENU_C_STR "C"
#define MSG_MENU_BASIC_STR "BASIC"
#define MSG_MENU_FORTRAN_STR "FORTRAN"
#define MSG_MENU_LaTeX_STR "LaTeX"
#define MSG_MENU_TeX_STR "TeX"
#define MSG_MENU_PostScript_STR "PostScript"
#define MSG_MENU_Output_STR "Output Type »"
#define MSG_MENU_ASCII_STR "ASCII"
#define MSG_MENU_AmigaGuide_STR "AmigaGuide"
#define MSG_MENU_HTML_STR "HTML"
#define MSG_MENU_RTF_STR "RTF"
#define MSG_MENU_Sort_STR "Sort Output"
#define MSG_MENU_Add_STR "Add Table of Contents"
#define MSG_MENU_Include_STR "Include Internal Docs"
#define MSG_MENU_Internal_STR "Internal Docs only!"
#define MSG_TTYPE_Main_STR "Edit Main     Template"
#define MSG_TTYPE_Header_STR "Edit Header   Template"
#define MSG_TTYPE_Internal_STR "Edit Internal Template"
#define MSG_TTYPE_Full_STR "Edit Full     Template"
#define MSG_GAD_InFileStr_STR "Input Source File:"
#define MSG_GAD_InFileASL_STR "ASL"
#define MSG_GAD_OutputStr_STR "Output File:"
#define MSG_GAD_OutputASL_STR "ASL"
#define MSG_GAD_TabSizeInt_STR "Tab Size:"
#define MSG_GAD_EditSrcBt_STR "Edit _Source File..."
#define MSG_GAD_EditTmpBt_STR "Edit _Template File..."
#define MSG_GAD_GenerateBt_STR "_Generate Document!"
#define MSG_GAD_XRefStr_STR "XRef Output:"
#define MSG_GAD_XRefASL_STR "ASL"
#define MSG_GAD_GenXRefBt_STR "Generate _XRef"
#define MSG_GAD_UseListBt_STR "Use XRef list file"
#define MSG_GAD_RDDefsLV_STR "RoboDoc.defaults:"
#define MSG_GAD_EditRDBt_STR "Edit _RoboDoc.defaults..."
#define MSG_ITXT_RD0_STR "Template Types:"
#define MSG_DONE_GENERATING_STR "Done Generating output!"
#define MSG_SYSTEM_PROBLEM_STR "System PROBLEM:"
#define MSG_USER_ERROR_STR "User ERROR:"
#define MSG_ABOUT_STR "About the program:"
#define MSG_NO_INP_FILENAME_STR "Please enter an input FileName first!"
#define MSG_NO_OUT_FILENAME_STR "Please enter an output FileName first!"
#define MSG_FMT_BAD_CMD_STR "'%s' could NOT be executed by the System!"
#define MSG_CHK_TOOL_STR "Invalid ToolType??:"
#define MSG_FMT_NO_FILEOPEN_STR "Could NOT open %s file!"
#define MSG_FMT_LIB_UNOPENED_STR "Could NOT open %s V%d library!"
#define MSG_FILE_WRITE_ERR_STR "The file did NOT get written correctly!"
#define MSG_FMT_NOGUI_ERR_STR "Could NOT open a %s GUI (error # %d)!\n"

#endif /* CATCOMP_STRINGS */


/****************************************************************************/



#endif /* RoboDocBuilderLOCALE_H */
