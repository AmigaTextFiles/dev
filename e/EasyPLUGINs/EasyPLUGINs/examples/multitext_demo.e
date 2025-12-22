
/*

    multitext_demo.e

*/

OPT PREPROCESS, OSVERSION=37

MODULE 'tools/easygui', 'easyplugins/multitext', 'graphics/text',
       'utility', 'utility/tagitem', 'diskfont'

DEF multitext_a:PTR TO multitext_plugin,
    multitext_b:PTR TO multitext_plugin,
    multitext_c:PTR TO multitext_plugin,
    disabled=FALSE, bars=FALSE,
    courier=NIL, courier_ta:PTR TO textattr,
    times=NIL, times_ta:PTR TO textattr

PROC main() HANDLE

    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")
    IF (diskfontbase:=OpenLibrary('diskfont.library', 37))=NIL THEN Raise("dflb")

    courier_ta:=['times.font', 15, FSF_BOLD, NIL]:textattr
    times_ta:=['courier.font', 13, FS_NORMAL, NIL]:textattr

    courier:=OpenDiskFont(courier_ta)
    times:=OpenDiskFont(times_ta)

    NEW multitext_a.multitext([PLA_MultiText_Text, ['First test:', 'multitext_plugin', 'with many lines'],
                               TAG_DONE]),
        multitext_b.multitext([PLA_MultiText_Text, ['Second test:', 'multitext_plugin', 'with many lines'],
                               PLA_MultiText_Font, courier_ta,
                               PLA_MultiText_Justification, PLV_MultiText_JustifyLeft,
                               TAG_DONE]),
        multitext_c.multitext([PLA_MultiText_Text, ['Third test:', 'multitext_plugin', 'with many lines'],
                               PLA_MultiText_Font, times_ta,
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
    IF utilitybase THEN CloseLibrary(utilitybase)

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

