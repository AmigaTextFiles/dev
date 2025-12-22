-> Programme style DiskMaster

OPT OSVERSION=37
MODULE 'tools/EasyGUI'

PROC main() HANDLE
  easygui('E FileManager v0.1',
    [ROWS,
      [COLS,
        [ROWS,
          [LISTV,0,NIL,1,5,NIL,0,NIL],
          [STR,0,'','',200,5]
        ],
        [EQROWS,
          [BUTTON,1,'DF0:'],
          [BUTTON,1,'DF1:'],
          [BUTTON,1,'Ram:'],
          [BUTTON,1,'System:'],
          [BUTTON,1,'Work:'],
          [BUTTON,1,'E:']
        ],
        [ROWS,
          [LISTV,0,NIL,1,5,NIL,0,NIL],
          [STR,0,'','',200,5]
        ]
      ],
      [COLS,
        [EQROWS,[SBUTTON,1,'Parent'],[SBUTTON,1,'All']],
        [EQROWS,[SBUTTON,1,'Copy'],[SBUTTON,1,'Clear']],
        [EQROWS,[SBUTTON,1,'Move'],[SBUTTON,1,'Toggle']],
        [EQROWS,[SBUTTON,1,'Rename'],[SBUTTON,1,'Size']],
        [EQROWS,[SBUTTON,1,'Delete'],[SBUTTON,1,'View']],
        [EQROWS,[SBUTTON,1,'MakeDir'],[SBUTTON,{config},'Config']]
      ]
    ],
    0,0,ROWS_UP)
EXCEPT
  WriteF('"\s"\n',[exception,0])
ENDPROC

PROC config(i)
/*  easygui('Configuration',
    [
    ]
  )*/
ENDPROC
