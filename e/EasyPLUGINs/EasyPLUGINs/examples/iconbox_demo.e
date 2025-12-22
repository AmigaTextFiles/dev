
/*

    iconbox_demo: part of EasyPLUGINs package

*/

OPT PREPROCESS, OSVERSION=37

MODULE 'tools/easygui', 'easyplugins/iconbox',
       'icon', 'utility', 'utility/tagitem'

DEF iconbox:PTR TO iconbox_plugin, disabled=FALSE, selected=FALSE

PROC main() HANDLE

    IF (iconbase:=OpenLibrary('icon.library', 37))=NIL THEN Raise("iclb")
    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")

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

    IF utilitybase THEN CloseLibrary(utilitybase)
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




