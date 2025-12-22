
/*

*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/xygadget_os12', 'hybrid/utility'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/xygadget', 'utility'
#endif

MODULE 'utility/tagitem'

DEF xygadget_1:PTR TO xygadget_plugin,
    xygadget_2:PTR TO xygadget_plugin,
    disabled=TRUE

PROC main() HANDLE

#ifdef EASY_OS12
    openUtility()
#endif
#ifndef EASY_OS12
    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")
#endif

    NEW xygadget_1.xygadget([PLA_XYGadget_Text, 'Testing',
                             PLA_XYGadget_Disabled, disabled,
                             TAG_DONE])

    NEW xygadget_2.xygadget([PLA_XYGadget_Text, 'A second gadget',
                             PLA_XYGadget_Disabled, disabled,
                             TAG_DONE])

    easyguiA('xygadget_plugin example', [ROWS,
                                            [PLUGIN, {gadget_pressed}, xygadget_1, TRUE],
                                            [PLUGIN, {gadget_pressed}, xygadget_2, TRUE],
                                            [COLS,
                                                [CHECK, {toggle_disabled}, '_Disabled?', disabled, FALSE, -1, "d"],
                                                [SPACEH],
                                                [BUTTON, 0, 'Quit']
                                            ]
                                        ])

EXCEPT DO

    END xygadget_1, xygadget_2

#ifdef EASY_OS12
    closeUtility()
#endif
#ifndef EASY_OS12
    IF utilitybase THEN CloseLibrary(utilitybase)
#endif

ENDPROC

PROC toggle_disabled()

    IF disabled THEN disabled:=FALSE ELSE disabled:=TRUE

    xygadget_1.set(PLA_XYGadget_Disabled, disabled)
    xygadget_2.set(PLA_XYGadget_Disabled, disabled)

ENDPROC

PROC gadget_pressed(gh:PTR TO guihandle, xygadget:PTR TO xygadget_plugin)

    WriteF('You pressed the gadget with \a\s\a on it.\n\n', xygadget.get(PLA_XYGadget_Text))

ENDPROC

