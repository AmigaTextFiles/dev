
/*

*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/corners_os12', 'hybrid/utility'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/corners', 'utility'
#endif

MODULE 'utility/tagitem'

DEF corner_blank:PTR TO corners_plugin,
    corner_noblank:PTR TO corners_plugin,
    disabled=FALSE

PROC main() HANDLE

#ifdef EASY_OS12
    openUtility()
#endif
#ifndef EASY_OS12
    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")
#endif

    NEW corner_blank.corners([PLA_Corners_ActiveCorner,   PLV_Corners_CornerTopLeft,
                              TAG_DONE]),
        corner_noblank.corners([PLA_Corners_ActiveCorner, PLV_Corners_CornerLowerRight,
                                TAG_DONE])

    easyguiA('corners_plugin example', [ROWS,
                                            [EQCOLS,
                                                [ROWS,
                                                    [TEXT, 'Never blank:', NIL, FALSE, 1],
                                                    [BEVELR,
                                                        [PLUGIN, {plugin_used}, corner_noblank]
                                                    ]
                                                ],
                                                [ROWS,
                                                    [TEXT, 'Blank immediately:', NIL, FALSE, 1],
                                                    [BEVELR,
                                                        [PLUGIN, {plugin_used}, corner_blank]
                                                    ]
                                                ]
                                            ],
                                            [SPACEV],
                                            [COLS,
                                                [CHECK, {toggle_disabled}, '_Disabled?', FALSE, FALSE, -1, "d"],
                                                [SPACEH],
                                                [BUTTON, 0, 'Quit']
                                            ]
                                        ])

EXCEPT DO

    END corner_blank, corner_noblank

#ifdef EASY_OS12
    closeUtility()
#endif
#ifndef EASY_OS12
    IF utilitybase THEN CloseLibrary(utilitybase)
#endif

ENDPROC

PROC toggle_disabled()

    IF disabled THEN disabled:=FALSE ELSE disabled:=TRUE

    corner_blank.set(PLA_Corners_Disabled, disabled)
    corner_noblank.set(PLA_Corners_Disabled, disabled)

ENDPROC

PROC plugin_used(gh:PTR TO guihandle, corners:PTR TO corners_plugin)

    IF corners=corner_noblank

        IF corner_noblank.get(PLA_Corners_ActiveCorner)=corner_blank.get(PLA_Corners_ActiveCorner)

            corner_blank.set(PLA_Corners_ActiveCorner, PLV_Corners_CornerNone)

        ENDIF

    ELSEIF corners=corner_blank

        IF corner_blank.get(PLA_Corners_ActiveCorner)=corner_noblank.get(PLA_Corners_ActiveCorner)

            corner_noblank.set(PLA_Corners_ActiveCorner, PLV_Corners_CornerNone)

        ENDIF

    ENDIF

ENDPROC

