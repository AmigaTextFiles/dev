
			IFND	WIZARD_WIZARD_LIB_I
WIZARD_WIZARD_LIB_I	EQU	1
			
			include	exec/libraries.i

			LIBINIT	-30

			LIBDEF	_LVOWZ_OpenSurfaceA
			LIBDEF	_LVOWZ_CloseSurface
			LIBDEF	_LVOWZ_AllocWindowHandleA
			LIBDEF	_LVOWZ_CreateWindowObjA
			LIBDEF	_LVOWZ_OpenWindowA
			LIBDEF	_LVOWZ_CloseWindow
			LIBDEF	_LVOWZ_FreeWindowHandle	
			LIBDEF	_LVOWZ_LockWindow
			LIBDEF	_LVOWZ_UnlockWindow
			LIBDEF	_LVOWZ_LockWindows
			LIBDEF	_LVOWZ_UnlockWindows
			LIBDEF	_LVOWZ_GadgetHelp
			LIBDEF	_LVOWZ_GadgetConfig
			LIBDEF	_LVOWZ_MenuHelp
			LIBDEF	_LVOWZ_MenuConfig
			LIBDEF	_LVOWZ_InitEasyStruct
			LIBDEF	_LVOWZ_SnapShotA
			LIBDEF	_LVOWZ_GadgetKeyA
			LIBDEF	_LVOWZ_DrawVImageA
			LIBDEF	_LVOWZ_EasyRequestArgs
			LIBDEF	_LVOWZ_GetNode
			LIBDEF	_LVOWZ_ListCount
			LIBDEF	_LVOWZ_NewObjectA
			LIBDEF	_LVOWZ_GadgetHelpMsg
			LIBDEF	_LVOWZ_ObjectID
			LIBDEF	_LVOWZ_InitNodeA
			LIBDEF	_LVOWZ_InitNodeEntryA

			ENDC