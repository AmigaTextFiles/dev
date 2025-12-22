/*
**   ((( frumSPlugs )))
** ©1996 Stephen Sinclair
**
** This source may be copied or edited in any
** way you wish.
**
** This file is part of the frumSPlugs package,
** and may only be distributed with it.
*/

/* Test for 100% Gauge */
-> $VER: GaugeTest.e V1.1 Stephen Sinclair (96.07.15)

OPT OSVERSION=37
MODULE 'Tools/EasyGUI','Plugins/Gauge','Intuition/Screens'

DEF gp:PTR TO gaugeplugin

PROC main()
  easygui('Gauge Test',
    [EQROWS,
      [TEXT,'Gauge:',NIL,TRUE,STRLEN],
      [COLS,

/* create a gauge that has a range of 0 to 100, starts at 50, resizes in **
** the y direction, has a beveled box, and is white.                     */
        [PLUGIN,0,NEW gp.gaugeplugin(100,50,RESIZEY,BEVEL,SHINEPEN,0,0,NIL,TRUE)],
        [EQROWS,
          [BUTTON,{topgauge},'Up'],
          [BUTTON,{addgauge},'More'],
          [BUTTON,{subgauge},'Less'],
          [BUTTON,{botgauge},'Down']
        ]
      ],
      [BUTTON,0,'Okay']
    ],10)
ENDPROC

CHAR '$VER: GaugeTest V1.1 Stephen Sinclair (96.07.15)',0

/* Add 10 onto the gauge */
PROC addgauge(x)
  gp.addgauge(x)
ENDPROC

/* Take 10 from the gauge */
PROC subgauge(x)
  gp.addgauge(-x)
ENDPROC

/* Put gauge at max value */
PROC topgauge(x)
  gp.setgauge(gp.top)
ENDPROC

/* Put gauge at 0 */
PROC botgauge(x)
  gp.setgauge(0)
ENDPROC
