
/*

*/

OPT PREPROCESS, OSVERSION=37

MODULE 'tools/easygui', 'easyplugins/bar',
       'utility', 'utility/tagitem'

DEF bar_1:PTR TO bar_plugin,
    bar_2:PTR TO bar_plugin,
    bar_3:PTR TO bar_plugin,
    bar_4:PTR TO bar_plugin,
    work[64]:STRING,
    t1:PTR TO LONG, t2:PTR TO LONG,
    t3:PTR TO LONG, t4:PTR TO LONG

PROC main() HANDLE

    IF (utilitybase:=OpenLibrary('utility.library', 37))=NIL THEN Raise("utlb")

    Rnd(-VbeamPos())

    NEW bar_1.bar([PLA_Bar_Percent,   100,
                   TAG_DONE]),
        bar_2.bar([PLA_Bar_Percent,   30,
                   TAG_DONE]),
        bar_3.bar([PLA_Bar_Percent,   100,
                   PLA_Bar_Vertical,  TRUE,
                   TAG_DONE]),
        bar_4.bar([PLA_Bar_Percent,   65,
                   PLA_Bar_Vertical,  TRUE,
                   TAG_DONE])

    easyguiA('bar_plugin example', [ROWS,
                                       [SPACEV], [PLUGIN, 1, bar_1], [SPACEV], t1:=[TEXT, '100%', NIL, TRUE, 1],
                                       [SPACEV], [PLUGIN, 1, bar_2], [SPACEV], t2:=[TEXT, '30%', NIL, TRUE, 1],
                                       [SPACEV],
                                       [EQCOLS,
                                            [ROWS, [PLUGIN, 1, bar_3], t3:=[TEXT, '100%', NIL, TRUE, 1]],
                                            [ROWS, [PLUGIN, 1, bar_4], t4:=[TEXT, '65%', NIL, TRUE, 1]]
                                       ],
                                       [SPACEV],
                                       [EQCOLS,
                                           [SBUTTON, {random}, 'Random'],
                                           [SPACEH],
                                           [SBUTTON, NIL, 'Quit']
                                       ]
                                   ])

EXCEPT DO

    END bar_1, bar_2, bar_3, bar_4

    IF utilitybase THEN CloseLibrary(utilitybase)

ENDPROC

PROC random(gh:PTR TO guihandle)

    DEF r

    r:=Rnd(101)

    bar_1.set(PLA_Bar_Percent, r)

    settext(gh, t1, StringF(work, '\d%', r))

    r:=Rnd(101)

    bar_2.set(PLA_Bar_Percent, r)

    settext(gh, t2, StringF(work, '\d%', r))

    r:=Rnd(101)

    bar_3.set(PLA_Bar_Percent, r)

    settext(gh, t3, StringF(work, '\d%', r))

    r:=Rnd(101)

    bar_4.set(PLA_Bar_Percent, r)

    settext(gh, t4, StringF(work, '\d%', r))

ENDPROC

