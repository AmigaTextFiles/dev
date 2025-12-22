OPT MODULE
OPT EXPORT, OSVERSION=37

MODULE 'fw/wbObject','*easyWindow',
       'tools/easygui','utility/tagitem'

OBJECT myWindow OF easyWindow
ENDOBJECT

PROC open() OF myWindow HANDLE
  self.create(
    'EasyGUI Tests',
    [BEVELR,
      [EQROWS,
        [SBUTTON,{dummy},'Dummy Button'],
        [SBUTTON,{test},'Tiny Test'],
        [SBUTTON,0,'Request'],
        [BAR],
        [CYCLE,{dummy},'',['One','Two','Three',NIL],0]
      ]
    ])
  IF self.handle=NIL THEN Raise(0)
  RETURN TRUE
EXCEPT
  self.remove()
ENDPROC FALSE

PROC handleMessage(info) OF myWindow
  DEF res
  IF info=0
    res:=easygui('Request',
      [ROWS,
        [ROWS,
          [TEXT,' Koniec programu?',NIL,FALSE,12]
        ],
        [BAR],
        [EQCOLS,
          [SBUTTON,0,'Tak'],
          [SPACEH],
          [SBUTTON,1,'Nie']
        ]
      ])
    IF res=0 THEN RETURN STOPALL
  ENDIF
ENDPROC CONTINUE

PROC dummy() IS EMPTY
PROC test() IS WriteF('Tinny Test :)\n')
