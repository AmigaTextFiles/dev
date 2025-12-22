#ifndef INIFUNCSLOCALE_H
#define INIFUNCSLOCALE_H


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

#define MSG_IF_VIEWER_WTITLE 0
#define MSG_IF_VIEWER_STITLE 1
#define MSG_IF_SAVE_NOW_Q 2
#define MSG_IF_FMT_ERROR_RPT 3
#define MSG_IF_AMIGADOS_ERR 4
#define MSG_IF_NO_GROUP_ERR 5
#define MSG_IF_NO_ITEM_ERR 6
#define MSG_IF_GAD_FILENAME 7
#define MSG_IF_GAD_ASL 8
#define MSG_IF_GAD_LISTVIEW 9
#define MSG_IF_GAD_LOADFILE 10
#define MSG_IF_GAD_SAVEFILE 11
#define MSG_IF_GAD_ADDGROUP 12
#define MSG_IF_GAD_ADDITEM 13
#define MSG_IF_GAD_REMOVEGROUP 14
#define MSG_IF_GAD_REMOVEITEM 15
#define MSG_IF_GAD_CANCEL_BTN 16
#define MSG_IF_GAD_DONE_BTN 17
#define MSG_IF_DEF_GRP_NAME 18
#define MSG_IF_DEF_ITEM_NAME 19
#define MSG_IF_DEF_ITEM_VALUE 20
#define MSG_IF_USER_ERROR 21
#define MSG_IF_SYSTEM_PROBLEM 22
#define MSG_IF_ASLFR_TITLE 23
#define MSG_IF_ASLFR_OKAYBT 24
#define MSG_IF_ASLFR_CANCELBT 25
#define MSG_IF_ABORT_OPENFILE 26
#define MSG_IF_USING_DEFAULT 27
#define MSG_IF_DEFAULT_ITEM_VALUE 28
#define MSG_IF_ABORT_WRITE_FILE 29
#define MSG_IF_ABORT_CREATE_FILE 30
#define MSG_IF_FMT_SMALL_FILE 31
#define MSG_IF_FMT_FILE_UNOPENED 32
#define MSG_IF_FMT_GRP_NOT_FOUND 33
#define MSG_IF_FMT_GRP_TRUNCATED 34
#define MSG_IF_FMT_ITM_TRUNCATED 35
#define MSG_IF_FMT_FILE_WRT_ERROR 36
#define MSG_IF_NO_ERROR 37
#define MSG_IF_NO_FILE 38
#define MSG_IF_EMPTY_FILE 39
#define MSG_IF_NO_FILEOPEN 40
#define MSG_IF_NO_GROUP 41
#define MSG_IF_NO_ITEM 42
#define MSG_IF_NO_MEMORY 43
#define MSG_IF_AUTO_ADD 44
#define MSG_IF_USER_ERR 45
#define MSG_IF_UNK_ERROR 46
#define MSG_IF_DUP_GROUP 47
#define MSG_IF_WRONG_NUM 48

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_IF_VIEWER_WTITLE_STR "IniFuncs ©2003 Viewer/Editor:"
#define MSG_IF_VIEWER_STITLE_STR "IniFuncs.o ©2003 by J.T. Steichen"
#define MSG_IF_SAVE_NOW_Q_STR "Changes were made, do you want to save them?"
#define MSG_IF_FMT_ERROR_RPT_STR "ERROR: %s"
#define MSG_IF_AMIGADOS_ERR_STR "AmigaDOS ERROR:\n\n"
#define MSG_IF_NO_GROUP_ERR_STR "Select/highlight a Group Name first!"
#define MSG_IF_NO_ITEM_ERR_STR "Select/highlight an Item & Value first!"
#define MSG_IF_GAD_FILENAME_STR "fileName:"
#define MSG_IF_GAD_ASL_STR "ASL"
#define MSG_IF_GAD_LISTVIEW_STR "Groups/Items:"
#define MSG_IF_GAD_LOADFILE_STR "_Load File"
#define MSG_IF_GAD_SAVEFILE_STR "Save Changes"
#define MSG_IF_GAD_ADDGROUP_STR "Add _Group"
#define MSG_IF_GAD_ADDITEM_STR "Add _Item"
#define MSG_IF_GAD_REMOVEGROUP_STR "Remove Group"
#define MSG_IF_GAD_REMOVEITEM_STR "Remove Item"
#define MSG_IF_GAD_CANCEL_BTN_STR "_CANCEL!"
#define MSG_IF_GAD_DONE_BTN_STR "_DONE!"
#define MSG_IF_DEF_GRP_NAME_STR "[Default Group Name]"
#define MSG_IF_DEF_ITEM_NAME_STR "DefaultItem"
#define MSG_IF_DEF_ITEM_VALUE_STR "NULL"
#define MSG_IF_USER_ERROR_STR "User ERROR:"
#define MSG_IF_SYSTEM_PROBLEM_STR "System Problem:"
#define MSG_IF_ASLFR_TITLE_STR "Enter a .ini File Name..."
#define MSG_IF_ASLFR_OKAYBT_STR " OKAY! "
#define MSG_IF_ASLFR_CANCELBT_STR " CANCEL! "
#define MSG_IF_ABORT_OPENFILE_STR "aborting iniOpenFile()!"
#define MSG_IF_USING_DEFAULT_STR "Using default file size of 100 lines!"
#define MSG_IF_DEFAULT_ITEM_VALUE_STR "DefaultItem = NULL"
#define MSG_IF_ABORT_WRITE_FILE_STR "aborting iniWriteToFile()!"
#define MSG_IF_ABORT_CREATE_FILE_STR "aborting iniCreateNewFile()!"
#define MSG_IF_FMT_SMALL_FILE_STR "File Size smaller than %d (file lines)!"
#define MSG_IF_FMT_FILE_UNOPENED_STR "%s could NOT be opened!"
#define MSG_IF_FMT_GRP_NOT_FOUND_STR "%s group NOT found (missing '[]'?), returning zero index!"
#define MSG_IF_FMT_GRP_TRUNCATED_STR "Group Name:\n\n%s\n  was TRUNCATED!"
#define MSG_IF_FMT_ITM_TRUNCATED_STR "Item Name:\n\n%s\n  was TRUNCATED!"
#define MSG_IF_FMT_FILE_WRT_ERROR_STR "System says file write error #%d!"
#define MSG_IF_NO_ERROR_STR ".ini: NO ERROR!"
#define MSG_IF_NO_FILE_STR ".ini: File NOT found!"
#define MSG_IF_EMPTY_FILE_STR ".ini: File is EMPTY!"
#define MSG_IF_NO_FILEOPEN_STR ".ini: File did NOT open!"
#define MSG_IF_NO_GROUP_STR ".ini: No group found!"
#define MSG_IF_NO_ITEM_STR ".ini: Item NOT found!"
#define MSG_IF_NO_MEMORY_STR ".ini: Ran out of Memory!"
#define MSG_IF_AUTO_ADD_STR ".ini: Item was NOT found and Auto-added!"
#define MSG_IF_USER_ERR_STR ".ini: User/Programmer forgot/omitted something!"
#define MSG_IF_UNK_ERROR_STR ".ini: Unknown ERROR!"
#define MSG_IF_DUP_GROUP_STR ".ini: More than one group with the same name!"
#define MSG_IF_WRONG_NUM_STR ".ini: Wrong number of items in message!"

#endif /* CATCOMP_STRINGS */


/****************************************************************************/



#endif /* INIFUNCSLOCALE_H */
