#ifndef TPLOCALE_H
#define TPLOCALE_H


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

#define MSG_TP_STITLE 0
#define MSG_TP_WTITLE 1
#define MSG_ASL_RTITLE 2
#define MSG_ASL_OKAY_BT 3
#define MSG_ASL_CANCEL_BT 4
#define MSG_MENU_PROJECT 5
#define MSG_MENU_New 6
#define MSG_MENU_Open 7
#define MSG_MENU_MENU2 8
#define MSG_MENU_CheckedItem1 9
#define MSG_MENU_CheckedItem2 10
#define MSG_MENU_Item3 11
#define MSG_MENU_MENU3 12
#define MSG_MENU_HaveSubs 13
#define MSG_MENU_SubItem1 14
#define MSG_MENU_SubItem2 15
#define MSG_MENU_DisabledItem 16
#define MSG_GAD_TestBt 17
#define MSG_GAD_TestStr 18
#define MSG_GAD_TestChk 19
#define MSG_GAD_Test_LV 20
#define MSG_GAD_TestInt 21
#define MSG_GAD_TestTxt 22
#define MSG_GAD_TestNum 23
#define MSG_GAD_TestPal 24
#define MSG_GAD_TestCyc 25
#define MSG_GAD_TestSlr 26
#define MSG_GAD_TestScl 27
#define MSG_GAD_TestCyc90_CYLBL 28
#define MSG_GAD_TestCyc91_CYLBL 29
#define MSG_GAD_TestCyc92_CYLBL 30
#define MSG_GAD_Test_MX110_MXLBL 31
#define MSG_GAD_Test_MX111_MXLBL 32
#define MSG_GAD_Test_MX112_MXLBL 33
#define MSG_GAD_Test_LV40_LVLBL 34
#define MSG_GAD_Test_LV41_LVLBL 35
#define MSG_GAD_Test_LV42_LVLBL 36
#define MSG_GAD_Test_LV43_LVLBL 37
#define MSG_ITXT_TP0 38
#define MSG_SYSTEM_PROBLEM 39
#define MSG_USER_ERROR 40
#define MSG_FMT_NO_FILEOPEN 41
#define MSG_FMT_LIB_UNOPENED 42
#define MSG_FILE_WRITE_ERR 43
#define MSG_FMT_NOGUI_ERR 44

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_TP_STITLE_STR "ScreenTitle Text:"
#define MSG_TP_WTITLE_STR "Test Project Window Title:"
#define MSG_ASL_RTITLE_STR "Enter a File Name..."
#define MSG_ASL_OKAY_BT_STR " OKAY! "
#define MSG_ASL_CANCEL_BT_STR " CANCEL! "
#define MSG_MENU_PROJECT_STR "PROJECT"
#define MSG_MENU_New_STR "New..."
#define MSG_MENU_Open_STR "Open..."
#define MSG_MENU_MENU2_STR "MENU2"
#define MSG_MENU_CheckedItem1_STR "CheckedItem1"
#define MSG_MENU_CheckedItem2_STR "CheckedItem2"
#define MSG_MENU_Item3_STR "Item3..."
#define MSG_MENU_MENU3_STR "MENU3"
#define MSG_MENU_HaveSubs_STR "HaveSubs »"
#define MSG_MENU_SubItem1_STR "SubItem1"
#define MSG_MENU_SubItem2_STR "SubItem2"
#define MSG_MENU_DisabledItem_STR "DisabledItem"
#define MSG_GAD_TestBt_STR "Test_Button"
#define MSG_GAD_TestStr_STR "String Gadget:"
#define MSG_GAD_TestChk_STR "Test CheckBox"
#define MSG_GAD_Test_LV_STR "Test ListView"
#define MSG_GAD_TestInt_STR "Test Integer:"
#define MSG_GAD_TestTxt_STR "Test_Text"
#define MSG_GAD_TestNum_STR "Test Number"
#define MSG_GAD_TestPal_STR "Test _Palette"
#define MSG_GAD_TestCyc_STR "Cycler"
#define MSG_GAD_TestSlr_STR "Slider"
#define MSG_GAD_TestScl_STR "Test Scroller"
#define MSG_GAD_TestCyc90_CYLBL_STR "Select1"
#define MSG_GAD_TestCyc91_CYLBL_STR "Select2"
#define MSG_GAD_TestCyc92_CYLBL_STR "Select3"
#define MSG_GAD_Test_MX110_MXLBL_STR "Choice1"
#define MSG_GAD_Test_MX111_MXLBL_STR "Choice2"
#define MSG_GAD_Test_MX112_MXLBL_STR "Choice3"
#define MSG_GAD_Test_LV40_LVLBL_STR "Item1111"
#define MSG_GAD_Test_LV41_LVLBL_STR "Item222"
#define MSG_GAD_Test_LV42_LVLBL_STR "Item33"
#define MSG_GAD_Test_LV43_LVLBL_STR "Item4"
#define MSG_ITXT_TP0_STR "Some Test IntuiText"
#define MSG_SYSTEM_PROBLEM_STR "System PROBLEM:"
#define MSG_USER_ERROR_STR "User ERROR:"
#define MSG_FMT_NO_FILEOPEN_STR "Could NOT open %s file!"
#define MSG_FMT_LIB_UNOPENED_STR "Could NOT open %s V%d library!"
#define MSG_FILE_WRITE_ERR_STR "The file did NOT get written correctly!"
#define MSG_FMT_NOGUI_ERR_STR "Could NOT open a %s GUI (error # %d)!\n"

#endif /* CATCOMP_STRINGS */


/****************************************************************************/


struct LocaleInfo
{
    APTR li_LocaleBase;
    APTR li_Catalog;
};



#endif /* TPLOCALE_H */
