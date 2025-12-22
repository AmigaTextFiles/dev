struct {
    LONG id;
    STRPTR node;
    LONG line;
} HelpTable[] = {
    { WINDOW_MAIN_ID,			  "4.",     0 },
    { WINDOW_REF_ID,			  "5.",     0 },
    { WINDOW_OPTIONS_ID,		  "6.",     0 },

    { MAIN_MENU_PROJECT_CLEAR,		  "4.2.1.", 0 },
    { MAIN_MENU_PROJECT_LOAD,		  "4.2.2.", 0 },
    { MAIN_MENU_PROJECT_SAVE,		  "4.2.3.", 0 },
    { MAIN_MENU_PROJECT_ABOUT,		  "4.2.4.", 0 },
    { MAIN_MENU_PROJECT_QUIT,		  "4.2.5.", 0 },

    { MAIN_LIST_ID,			  "4.",     0 },
    { MAIN_REFERENCES_ID,		  "4.",     0 },
    { MAIN_OPENREFWINDOW_ID,		  "4.",     0 },
    { MAIN_SCAN_ID,			  "4.1.1.", 0 },
    { MAIN_DELETE_ID,			  "4.1.2.", 0 },
    { MAIN_OPTIONS_ID,			  "4.1.3.", 0 },
    { MAIN_RESCAN_ID,			  "4.1.4.", 0 },
    { MAIN_RESCANALL_ID,		  "4.1.5.", 0 },

    { REF_LIST_ID,			  "5.",     0 },
    { REF_FILE_ID,			  "5.",     10 },
    { REF_OFFSET_ID,			  "5.",     10 },
    { REF_LENGTH_ID,			  "5.",     10 },
    { REF_GOTO_ID,			  "5.",     10 },
    { REF_DELETE_ID,			  "5.",     31 },

    { OPTIONS_MENU_PROJECT_OPEN_ID,	  "6.",     0 },
    { OPTIONS_MENU_PROJECT_SAVEAS_ID,	  "6.",     0 },

    { OPTIONS_AUTODOC_ID,		  "3.1.",   0 },

    { OPTIONS_C_ID,			  "3.1.",   0 },
    { OPTIONS_C_DEFINE_ID,		  "3.2.",   0 },
    { OPTIONS_C_STRUCT_ID,		  "3.2.",   0 },
    { OPTIONS_C_TYPEDEF_ID,		  "3.2.",   0 },

    { OPTIONS_E_ID,			  "3.1.",   0 },
    { OPTIONS_E_CONST_ID,		  "3.2.",   0 },
    { OPTIONS_E_OBJECT_ID,		  "3.2.",   0 },
    { OPTIONS_E_PROC_ID,		  "3.2.",   0 },

    { OPTIONS_ASM_ID,			  "3.1.",   0 },
    { OPTIONS_ASM_EQU_ID,		  "3.2.",   0 },
    { OPTIONS_ASM_STRUCTURE_ID, 	  "3.2.",   0 },
    { OPTIONS_ASM_MACRO_ID,		  "3.2.",   0 },

    { OPTIONS_RECURSIVELY_ID,		  "3.3.1.", 0 },
    { OPTIONS_KEEPEMPTY_ID,		  "3.3.2.", 0 },
    { OPTIONS_UNKNOWNASAUTODOC_ID,	  "3.3.3.", 0 },

    { OPTIONS_SAVE_ID,			  "6.",     0 },
    { OPTIONS_USE_ID,			  "6.",     0 },
    { OPTIONS_CANCEL_ID,		  "6.",     0 },

    { 0,				  "main",   0 }
};

