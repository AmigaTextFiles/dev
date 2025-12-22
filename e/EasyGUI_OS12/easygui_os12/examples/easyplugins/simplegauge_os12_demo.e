/*

   SimpleGauge Demo

   (a little bit silly demo but I think it shows how it works)

   Copyright: Ralph Wermke of Digital Innovations
   EMail    : wermke@gryps1.rz.uni-greifswald.de
   WWW      : http://www.user.fh-stralsund.de/~rwermke/di.html

*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/simplegauge_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/simplegauge'
#endif

MODULE 'tools/exceptions',
       'utility/tagitem'

DEF gh

PROC main() HANDLE
DEF mp:PTR TO simplegauge_plugin, mp2:PTR TO simplegauge_plugin

   -> create new instances
   NEW mp.simplegauge([PLA_SimpleGauge_ShowText, TRUE,
                       PLA_SimpleGauge_Max, 1500,
                       PLA_SimpleGauge_Current, 500,
                       TAG_DONE])

   NEW mp2.simplegauge([PLA_SimpleGauge_Horizontal, FALSE,
                        PLA_SimpleGauge_ShowText, TRUE,
                        PLA_SimpleGauge_Max, 1500,
                        TAG_DONE])

   -> initial settings
   mp.set(PLA_SimpleGauge_Max, 5000)
   mp.set(PLA_SimpleGauge_Current, 2500)
   mp2.set(PLA_SimpleGauge_BackgroundPen, 3)
   mp2.set(PLA_SimpleGauge_BarPen, 0)

   -> open gui
   easyguiA('SimpleGauge Test',
            [ROWS,
               [COLS,
                  [BUTTON, {ignore}, '   '],
                  [PLUGIN, {ignore}, mp]
               ],
               [BEVEL,
                  [COLS,
                     [PLUGIN, {ignore}, mp2],
                     [ROWS,
                        [SPACE],
                        [EQCOLS,
                           [SBUTTON, {setmax}, 'Max=500', [mp,mp2,500]],
                           [SBUTTON, {setmax}, 'Max=1000', [mp,mp2,1000]],
                           [SBUTTON, {setmax}, 'Max=1500', [mp,mp2,1500]],
                           [SLIDE, {scroll}, NIL, FALSE, 0, 1500, 0, 2, '', [mp,mp2]]
                        ],
                        [SBUTTON, {dis}, 'Toggle', [mp,mp2]]
                     ]
                  ]
               ]
            ],
            [EG_GHVAR,{gh}, TAG_DONE])
EXCEPT
   END mp
   report_exception()
ENDPROC

PROC ignore(info, mp:PTR TO simplegauge_plugin) IS EMPTY

-> set a new maximum
PROC setmax(l:PTR TO LONG, info)
DEF mp:PTR TO simplegauge_plugin, mp2:PTR TO simplegauge_plugin

   mp:=l[0]; mp2:=l[1]
   mp.set(PLA_SimpleGauge_Max, l[2])
   mp2.set(PLA_SimpleGauge_Max, l[2])

ENDPROC

-> set and display scroller value
PROC scroll(l:PTR TO LONG, info, x)
DEF mp:PTR TO simplegauge_plugin, mp2:PTR TO simplegauge_plugin

   mp:=l[0]; mp2:=l[1]

   ->IF (x>(mp.get(PLA_SimpleGauge_Max)*0.9))
   IF (x>Div(Mul(mp.get(PLA_SimpleGauge_Max),90),100))
      mp.set(PLA_SimpleGauge_BarPen, 1)
   ELSE
      mp.set(PLA_SimpleGauge_BarPen, 3)
   ENDIF

   mp.set(PLA_SimpleGauge_Current, x)
   mp2.set(PLA_SimpleGauge_Current, x)

   WriteF('Max=\d Current=\d Percent=\d\n', mp.get(PLA_SimpleGauge_Max),
                                            mp.get(PLA_SimpleGauge_Current),
                                            mp.get(PLA_SimpleGauge_Percent),
         )

ENDPROC

-> disables the gauges
PROC dis(l:PTR TO LONG, info)
DEF mp:PTR TO simplegauge_plugin, mp2:PTR TO simplegauge_plugin

   mp:=l[0]; mp2:=l[1]
   mp.set(PLA_SimpleGauge_Disabled, Not(mp.get(PLA_SimpleGauge_Disabled)))
   mp2.set(PLA_SimpleGauge_Disabled, Not(mp2.get(PLA_SimpleGauge_Disabled)))

ENDPROC

