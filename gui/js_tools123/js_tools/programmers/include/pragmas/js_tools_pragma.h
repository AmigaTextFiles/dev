/* "js_tools.library"*/
/*pragma libcall JS_ToolsBase Unused 1e 801*/
#pragma libcall JS_ToolsBase JS_LibInfo 24 101
/*pragma libcall JS_ToolsBase SetGlobalPrefs 2a 101*/
/*pragma libcall JS_ToolsBase GetGlobalPrefs 30 1802*/
/**/
/* ListView only*/
/* (less overhead if you have your own gadtools replacement)*/
/**/
#pragma libcall JS_ToolsBase LV_CreateListViewA 36 A98004
#pragma libcall JS_ToolsBase LV_FreeListView 3c 801
#pragma libcall JS_ToolsBase LV_FreeListViews 42 801
#pragma libcall JS_ToolsBase LV_SetListViewAttrsA 48 BA9804
#pragma libcall JS_ToolsBase LV_RefreshWindow 4e 9802
#pragma libcall JS_ToolsBase LV_GetIMsg 54 801
#pragma libcall JS_ToolsBase LV_ReplyIMsg 5a 901
#pragma libcall JS_ToolsBase LV_AskListViewAttrs 60 109804
#pragma libcall JS_ToolsBase LV_GetListViewAttrsA 66 BA9804
#pragma libcall JS_ToolsBase LV_CreateExtraListViewA 6c 9802
/**/
#pragma libcall JS_ToolsBase JS_Sort 72 0802
/*pragma libcall JS_ToolsBase JS_SortA 78 90803*/
#pragma libcall JS_ToolsBase LV_KeyHandler 7e A09804
/**/
