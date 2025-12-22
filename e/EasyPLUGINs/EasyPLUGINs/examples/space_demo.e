
/*

*/

OPT PREPROCESS, OSVERSION=37

MODULE 'tools/easygui', 'easyplugins/space',
       'utility', 'utility/tagitem'

DEF space_1:PTR TO space_plugin,
    space_2:PTR TO space_plugin,
    space_3:PTR TO space_plugin,
    space_4:PTR TO space_plugin

PROC main() HANDLE

    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")

    NEW space_1.space([PLA_Space_Width,   32,
                       PLA_Space_Height,  16,
                       TAG_DONE])

    NEW space_2.space([PLA_Space_Width,   32,
                       PLA_Space_Height,  16,
                       PLA_Space_ResizeX, TRUE,
                       TAG_DONE])

    NEW space_3.space([PLA_Space_Width,   32,
                       PLA_Space_Height,  16,
                       PLA_Space_ResizeY, TRUE,
                       TAG_DONE])

    NEW space_4.space([PLA_Space_Width,   32,
                       PLA_Space_Height,  16,
                       PLA_Space_ResizeX, TRUE,
                       PLA_Space_ResizeY, TRUE,
                       TAG_DONE])

    easyguiA('space_plugin example', [ROWS,
                                         [COLS,
                                             [ROWS,
                                                 [TEXT, '32 x 16, No Resize', NIL, TRUE, 1],
                                                 [BEVELR, [PLUGIN, 1, space_1]],
                                                 [BAR],
                                                 [TEXT, '32 x 16, Resize X', NIL, TRUE, 1],
                                                 [BEVELR, [PLUGIN, 1, space_2]]
                                             ],
                                             [BAR],
                                             [ROWS,
                                                 [TEXT, '32 x 16, Resize Y', NIL, TRUE, 1],
                                                 [BEVELR, [PLUGIN, 1, space_3]],
                                                 [BAR],
                                                 [TEXT, '32 x 16, Resize X & Y', NIL, TRUE, 1],
                                                 [BEVELR, [PLUGIN, 1, space_4]]
                                             ]
                                         ],
                                         [SBUTTON, 0, 'Quit']
                                     ])

EXCEPT DO

    END space_1, space_2, space_3, space_4

    IF utilitybase THEN CloseLibrary(utilitybase)

ENDPROC

