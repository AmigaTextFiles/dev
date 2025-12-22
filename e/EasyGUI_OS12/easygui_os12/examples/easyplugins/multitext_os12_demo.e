
/*

    multitext_demo.e

*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/multitext_os12', 'hybrid/utility'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/multitext', 'utility'
#endif

MODULE 'graphics/text',
       'utility/tagitem', 'diskfont'

DEF multitext_a:PTR TO multitext_plugin,
    multitext_b:PTR TO multitext_plugin,
    multitext_c:PTR TO multitext_plugin,
    disabled=FALSE, bars=FALSE,
    courier=NIL, font1_ta:PTR TO textattr,
    times=NIL, font2_ta:PTR TO textattr

PROC main() HANDLE

#ifdef EASY_OS12
    openUtility()
#endif
#ifndef EASY_OS12
    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")
#endif
    IF (diskfontbase:=OpenLibrary('diskfont.library', 33))=NIL THEN Raise("dflb")

    font1_ta:=['topaz.font', 11, FSF_BOLD, NIL]:textattr
    font2_ta:=['diamond.font', 12, FS_NORMAL, NIL]:textattr

    courier:=OpenDiskFont(font1_ta)
    times:=OpenDiskFont(font2_ta)

    NEW multitext_a.multitext([PLA_MultiText_Text, ['First test:', 'multitext_plugin', 'with many lines'],
                               TAG_DONE]),
        multitext_b.multitext([PLA_MultiText_Text, ['Second test:', 'multitext_plugin', 'with many lines'],
                               PLA_MultiText_Font, font1_ta,
                               PLA_MultiText_Justification, PLV_MultiText_JustifyLeft,
                               TAG_DONE]),
        multitext_c.multitext([PLA_MultiText_Text, ['Third test:', 'multitext_plugin', 'with many lines'],
                               PLA_MultiText_Font, font2_ta,
                               PLA_MultiText_Justification, PLV_MultiText_JustifyRight,
                               TAG_DONE])

    easyguiA('multitext_plugin example',
             [ROWS,
                 [PLUGIN, 1, multitext_a],
                 [PLUGIN, 1, multitext_b],
                 [PLUGIN, 1, multitext_c],
                 [COLS,
                    [CHECK, {toggle_disabled}, '_Disabled?', disabled, FALSE, -1, "d"],
                    [CHECK, {toggle_bars}, '_Bars?', bars, FALSE, -1, "b"],
                    [SPACEH],
                    [BUTTON, 0, 'Quit']
                 ]
             ])

EXCEPT DO

    END multitext_a, multitext_b, multitext_c

    IF courier THEN CloseFont(courier)
    IF times THEN CloseFont(times)

    IF diskfontbase THEN CloseLibrary(diskfontbase)
#ifdef EASY_OS12
    closeUtility()
#endif
#ifndef EASY_OS12
    IF utilitybase THEN CloseLibrary(utilitybase)
#endif

ENDPROC

PROC toggle_disabled()

    IF disabled THEN disabled:=FALSE ELSE disabled:=TRUE

    multitext_a.set(PLA_MultiText_Disabled, disabled)
    multitext_b.set(PLA_MultiText_Disabled, disabled)
    multitext_c.set(PLA_MultiText_Disabled, disabled)

ENDPROC

PROC toggle_bars()

    IF bars THEN bars:=FALSE ELSE bars:=TRUE

    multitext_a.set(PLA_MultiText_DrawBar, bars)
    multitext_b.set(PLA_MultiText_DrawBar, bars)
    multitext_c.set(PLA_MultiText_DrawBar, bars)

ENDPROC

