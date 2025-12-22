
->MODULE '*popasl',
MODULE 'easyplugins/popasl',
       'tools/exceptions','tools/easygui',
       'utility/tagitem'


PROC main() HANDLE
DEF mp:PTR TO popasl_plugin,mp2:PTR TO popasl_plugin,mp3:PTR TO popasl_plugin

NEW mp.popasl([PLA_PopAsl_Contents, 'PROGDIR:',
               PLA_PopAsl_GadgetID, 10,
               PLA_PopAsl_Type, PLV_PopAsl_Type_Drawer,
               PLA_PopAsl_ButtonOnRight, TRUE,
               TAG_DONE])

NEW mp2.popasl([PLA_PopAsl_Contents, 'SYS:Daten/',
               PLA_PopAsl_GadgetID, 12,
               PLA_PopAsl_Type, PLV_PopAsl_Type_File,
               TAG_DONE])

NEW mp3.popasl([PLA_PopAsl_Contents, 'topaz.font/8',
               PLA_PopAsl_GadgetID, 14,
               PLA_PopAsl_Type, PLV_PopAsl_Type_Font,
               PLA_PopAsl_NoFontExtension, TRUE,
               TAG_DONE])

easyguiA('PopAsl Test',
         [ROWS,
            [COLS,
               [PLUGIN, {getstring2}, mp, TRUE],
               [BUTTON, {toggle}, 'T', mp],
               [BUTTON, {clear}, 'C', mp],
               [BUTTON, {getstring}, 'G', mp]
            ],
            [COLS,
               [PLUGIN, {getstring2}, mp2, TRUE],
               [BUTTON, {toggle}, 'T', mp2],
               [BUTTON, {clear}, 'C', mp2],
               [BUTTON, {getstring}, 'G', mp2]
            ],
            [COLS,
               [PLUGIN, {getstring2}, mp3, TRUE],
               [BUTTON, {toggle}, 'T', mp3],
               [BUTTON, {clear}, 'C', mp3],
               [BUTTON, {getstring}, 'G', mp3]
            ],
            [EQCOLS,
               [SBUTTON, {toggleall}, 'Toggle All', [mp,mp2,mp3]],
               [SBUTTON, {resetall}, 'Reset All', [mp,mp2,mp3]],
               [SBUTTON, {getstrings}, 'Get Strings', [mp,mp2,mp3]]
            ]
         ]
        )

EXCEPT
   END mp
   report_exception()
ENDPROC

PROC toggle(mp:PTR TO popasl_plugin, info)
   mp.set(PLA_PopAsl_Disabled,Not(mp.get(PLA_PopAsl_Disabled)))
ENDPROC

PROC toggleall(l:PTR TO LONG,info)
DEF mp:PTR TO popasl_plugin, mp2:PTR TO popasl_plugin, mp3:PTR TO popasl_plugin

   mp:=l[0]; mp2:=l[1]; mp3:=l[2]

   mp.set (PLA_PopAsl_Disabled,Not(mp.get(PLA_PopAsl_Disabled)))
   mp2.set(PLA_PopAsl_Disabled,Not(mp2.get(PLA_PopAsl_Disabled)))
   mp3.set(PLA_PopAsl_Disabled,Not(mp3.get(PLA_PopAsl_Disabled)))

ENDPROC

PROC clear(mp:PTR TO popasl_plugin, info)
   mp.set(PLA_PopAsl_Contents, '')
ENDPROC

PROC resetall(l:PTR TO LONG,info)
DEF mp:PTR TO popasl_plugin, mp2:PTR TO popasl_plugin, mp3:PTR TO popasl_plugin

   mp:=l[0]; mp2:=l[1]; mp3:=l[2]

   mp.set (PLA_PopAsl_Contents, 'PROGDIR:')
   mp2.set(PLA_PopAsl_Contents, 'SYS:Daten/')
   mp3.set(PLA_PopAsl_Contents, 'topaz.font/8')

ENDPROC

PROC getstring(mp:PTR TO popasl_plugin, info)
   PrintF('Contents=''\s''\n', mp.get(PLA_PopAsl_Contents))
ENDPROC

PROC getstrings(l:PTR TO LONG,info)
DEF mp:PTR TO popasl_plugin, mp2:PTR TO popasl_plugin, mp3:PTR TO popasl_plugin

   mp:=l[0]; mp2:=l[1]; mp3:=l[2]

   PrintF('\n+-----------------------------------------------\n')
   PrintF('| Drawer=''\s''\n', mp.get(PLA_PopAsl_Contents))
   PrintF('| File  =''\s''\n', mp2.get(PLA_PopAsl_Contents))
   PrintF('| Font  =''\s''\n', mp3.get(PLA_PopAsl_Contents))
   PrintF('+-----------------------------------------------\n')

ENDPROC

PROC getstring2(info, mp:PTR TO popasl_plugin)
   PrintF('Contents=''\s''\n', mp.get(PLA_PopAsl_Contents))
ENDPROC

