	IFND JS_TOOLS_JS_TOOLS_LIB_I
JS_TOOLS_JS_TOOLS_LIB_I SET 1

**
**
**  JS_TOOLS.library   -   (c) 1994, 1995 by J.Schmitz - free to copy & use
**
**  written in C with SAS/C
**
**  new and better listview gadget and some helping tools
**  (may be more in future!)
**
**

	LIBINIT

	LIBDEF _LVOUnused
	LIBDEF _LVOJS_LibInfo
	LIBDEF _LVOSetGlobalPrefs       ; private!
	LIBDEF _LVOGetGlobalPrefs       ; private!
	LIBDEF _LVO
        LIBDEF _LVOLV_CreateListViewA
        LIBDEF _LVOLV_FreeListView
        LIBDEF _LVOLV_FreeListViews
        LIBDEF _LVOLV_SetListViewAttrsA
        LIBDEF _LVOLV_RefreshWindow
        LIBDEF _LVOLV_GetIMsg
        LIBDEF _LVOLV_ReplyIMsg
        LIBDEF _LVOLV_AskListViewAttrs
        LIBDEF _LVOLV_GetListViewAttrsA
        LIBDEF _LVOLV_CreateExtraListViewA
        LIBDEF _LVOJS_Sort
        LIBDEF _LVOJS_SortA             ; not implemented!
        LIBDEF _LVOLV_KeyHandler

	ENDC
