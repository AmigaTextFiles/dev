/* A small example of the progressbar by Daniel van Gerpen */

OPT OSVERSION=37

MODULE 'tools/EasyGUI'
MODULE '*plugin_bar'

DEF pb           : PTR TO progressbar

PROC main() HANDLE
  easygui('Easygui inplugged',
    [EQROWS,
      [TEXT,'The progressbar plugin...',NIL,TRUE,3],
      [BEVEL,[PLUGIN,0,

            NEW pb.progressbar(' \d %% ', 100, 1, 2, 1, 3)]],
            /*                        |    |   |  |  |  |
                            displaytext    |   |  |  |  emptypen
                                    maxunits   |  |  fillpen
                                            diff  textpen        */

      [BAR],
      [COLS,
        [SBUTTON,{change},'Change'],
        [SBUTTON,{clear} ,'Clear'],
        [SBUTTON,{loop}  ,'Loop']
      ]
    ]
  )
EXCEPT DO
 END pb
ENDPROC

PROC clear(info)  IS pb.set(0)

PROC change(info) IS pb.set(ListItem([10,20,33,50,67,73,88,100],Rnd(8)))

PROC loop(info)
DEF i
 FOR i:=pb.state TO 0 STEP -1 DO pb.set(i)
 FOR i:=0 TO pb.unit          DO pb.set(i)
ENDPROC

