
/*

    iconbox_demo: part of EasyPLUGINs package

*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/iconbox_os12','hybrid/utility'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/iconbox', 'utility'
#endif

MODULE 'icon', 'utility/tagitem'

DEF iconbox:PTR TO iconbox_plugin, disabled=FALSE, selected=FALSE

PROC main() HANDLE

    IF (iconbase:=OpenLibrary('icon.library', 0))=NIL THEN Raise("iclb")
#ifdef EASY_OS12
    openUtility()
#endif
#ifndef EASY_OS12
    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")
#endif

    NEW iconbox.iconbox([PLA_IconBox_IconName, 'Sys:Disk',
                         TAG_DONE])

    easyguiA('iconbox_plugin example',  [ROWS,
                                            [BEVELR,
                                                [PLUGIN, NIL, iconbox]
                                            ],
                                            [COLS,
                                                [CHECK, {toggle_disabled}, '_Disabled?', disabled, FALSE, -1, "d"],
                                                [CHECK, {toggle_selected}, '_Selected?', selected, FALSE, -1, "s"]
                                            ]
                                        ])

EXCEPT DO

    END iconbox

#ifdef EASY_OS12
    closeUtility()
#endif
#ifndef EASY_OS12
    IF utilitybase THEN CloseLibrary(utilitybase)
#endif
    IF iconbase THEN CloseLibrary(iconbase)

ENDPROC

PROC toggle_disabled()

    IF disabled=FALSE THEN disabled:=TRUE ELSE disabled:=FALSE

    iconbox.set(PLA_IconBox_Disabled, disabled)

ENDPROC

PROC toggle_selected()

    IF selected=FALSE THEN selected:=TRUE ELSE selected:=FALSE

    iconbox.set(PLA_IconBox_ShowSelected, selected)

ENDPROC




