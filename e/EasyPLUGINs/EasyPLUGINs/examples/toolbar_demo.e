
/*

*/

OPT PREPROCESS, OSVERSION=37

MODULE 'tools/easygui', 'easyplugins/toolbar',
       'utility', 'utility/tagitem'

DEF toolbar_h:PTR TO toolbar_plugin,
    toolbar_v:PTR TO toolbar_plugin,
    toolbar_b:PTR TO toolbar_plugin,
    disabled=FALSE

PROC main() HANDLE

    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("util")

    NEW toolbar_h.toolbar([PLA_ToolBar_Contents, ['Horizontal,', 'not all gadgets', 'are forced', 'to appear', 'up here.'],
                           PLA_ToolBar_Function, {gadget_pressed},
                           TAG_DONE])

    NEW toolbar_v.toolbar([PLA_ToolBar_Contents, ['This is', 'a vertical', 'toolbar,',
                                                  'all gadgets', 'forced to', 'appear.'],
                           PLA_ToolBar_Function, {gadget_pressed},
                           PLA_ToolBar_Vertical, TRUE,
                           PLA_ToolBar_DisplayAll, TRUE,
                           TAG_DONE])

    NEW toolbar_b.toolbar([PLA_ToolBar_Contents, ['This is', 'a vertical', 'toolbar,',
                                                  'not all gadgets', 'are forced', 'to appear.',
                                                  'In fact', 'it\as', 'just a waste', 'of space.' ],
                           PLA_ToolBar_Function, {gadget_pressed},
                           PLA_ToolBar_Vertical, TRUE,
                           TAG_DONE])

    easyguiA('toolbar_plugin example', [ROWS,
                                           [BEVELR,
                                               [PLUGIN, NIL, toolbar_h, TRUE]
                                           ],
                                           [COLS,
                                               [ROWS,
                                                   [BEVELR,
                                                       [PLUGIN, NIL, toolbar_v, TRUE]
                                                   ],
                                                   [SPACEV]
                                               ],
                                               [BEVELR,
                                                   [PLUGIN, NIL, toolbar_b, TRUE]
                                               ],
                                               [SPACE],
                                               [CHECK, {toggle_disabled}, '_Disabled?', disabled, FALSE, -1, "d"]
                                           ]
                                       ])

EXCEPT DO

    END toolbar_h, toolbar_v, toolbar_b

    IF utilitybase THEN CloseLibrary(utilitybase)

ENDPROC

PROC toggle_disabled()

    IF disabled THEN disabled:=FALSE ELSE disabled:=TRUE

    toolbar_h.set(PLA_ToolBar_Disabled, disabled)
    toolbar_v.set(PLA_ToolBar_Disabled, disabled)
    toolbar_b.set(PLA_ToolBar_Disabled, disabled)

ENDPROC

PROC gadget_pressed(toolbar:PTR TO toolbar_plugin, gad_num)

    WriteF('You pressed gadget number \a\d\a on toolbar $\h.\n', gad_num, toolbar)

ENDPROC

