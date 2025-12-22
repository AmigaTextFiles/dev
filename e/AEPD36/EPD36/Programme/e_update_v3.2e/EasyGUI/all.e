-> Test GUI's gathered in one program.

OPT OSVERSION=37
MODULE 'tools/EasyGUI', 'tools/exceptions', 'libraries/gadtools'

DEF s[50]:STRING

PROC main() HANDLE
  StrCopy(s,'bla')
  easygui('EasyGUI Tests',
    [EQROWS,
      [BUTTON,{fonts},'Fonts'],
      [BUTTON,{screenmode},'ScreenMode'],
      [BUTTON,{file},'File Requester'],
      [BUTTON,{search},'Search Requester'],
      [BUTTON,{search2},'Search Requester 2'],
      [BUTTON,{amosaic},'Amosaic'],
      [BUTTON,{db},'DataBase'],
      [BUTTON,{dm},'DiskMaster'],
      [BUTTON,{tiny},'Tiny Test'],
      [BUTTON,{messy},'Messy Test']
    ]
  )
EXCEPT
  report_exception()
ENDPROC

PROC fonts(x)
  easygui('Font Preferences',
    [EQROWS,
      [TEXT,'Selected Fonts',NIL,FALSE,3],
      [BEVELR,
        [EQROWS,
          [TEXT,'xentiny 8','Workbench Icon Text:',FALSE,3],
          [TEXT,'end 10','System Default Text:',FALSE,3],
          [TEXT,'except 12','Screen text:',FALSE,3]
        ]
      ],
      [SBUTTON,0,'Select Workbench Icon Text...'],
      [SBUTTON,0,'Select System Default Text...'],
      [SBUTTON,0,'Select Screen text...'],
      [BAR],
      [COLS,
        [BUTTON,0,'Save'],
        [SPACEH],
        [BUTTON,0,'Use'],
        [SPACEH],
        [BUTTON,0,'Cancel']
      ]
    ]
  )
ENDPROC

PROC screenmode(x)
  easygui_fallback('ScreenMode Preferences',
    [EQROWS,
      [COLS,
        [EQROWS,
          [LISTV,0,'Display Mode',10,4,NIL,TRUE,0,0],
          [COLS,
            [EQROWS,[INTEGER,0,'Width:',640,5],[INTEGER,0,'Height:',512,5]],
            [ROWS,[CHECK,0,'Default',TRUE,FALSE],[CHECK,0,'Default',TRUE,FALSE]]
          ],
          [SLIDE,0,'Colors:',FALSE,1,8,3,5,''],
          [CHECK,0,'AutoScroll:',TRUE,TRUE]
        ],
        ->[BAR],
        [BEVELR,
          [EQROWS,
            [TEXT,'688x539','Visible Size:',FALSE,3],
            [TEXT,'640x200','Minimum Size:',FALSE,3],
            [TEXT,'16368x16384','Maximum Size:',FALSE,3],
            [TEXT,'256','Maximum Colors:',FALSE,3],
            [SPACE]
          ]
        ]
      ],
      [BAR],
      [COLS,
        [BUTTON,0,'Save'],
        [SPACEH],
        [BUTTON,0,'Use'],
        [SPACEH],
        [BUTTON,0,'Cancel']
      ]
    ]
  )
ENDPROC

PROC file(x)
  WriteF('result=\d\n',easygui('Select a file:',
    [EQROWS,
      [LISTV,0,NIL,1,5,NIL,0,NIL,0],
      [STR,{fr},'Pattern',s,200,5],
      [STR,{fr},'Drawer',s,200,5],
      [STR,{fr},'File',s,200,5],
      [COLS,
        [BUTTON,1,'Ok'],
        [SPACEH],
        [BUTTON,2,'Disks'],
        [SPACEH],
        [BUTTON,3,'Parent'],
        [SPACEH],
        [BUTTON,0,'Cancel']
      ]
    ]
  ))
ENDPROC

PROC fr(a,b) IS WriteF('fr: \s\n',b)

PROC search(x)
  WriteF('result=\d\n',easygui('Enter Search/Replace text:',
    [ROWS,
      [ROWS,						-> ROWS
        [EQROWS,
          [STR,{find},'Locate',s,10,10],
          [STR,{repl},'Replace',s,10,10]
        ],
        [COLS,						-> COLS
          [CHECK,{case},'Ignore case',TRUE,FALSE],
          [CHECK,{word},'Whole words only',FALSE,FALSE],
          [CHECK,{forw},'Search forward',TRUE,FALSE]
        ]
      ],
      [BAR],
      [EQCOLS,
        [BUTTON,1,'Search'],
        [SPACEH],
        [BUTTON,2,'Replace'],
        [SPACEH],
        [BUTTON,0,'Cancel']
      ]
    ]
  ))
ENDPROC

PROC find(x,y) IS WriteF('Find="\s"!\n',y)
PROC repl(x,y) IS WriteF('Repl="\s"!\n',y)
PROC case(x,y) IS WriteF('Case=\d!\n',y)
PROC word(x,y) IS WriteF('Word=\d!\n',y)
PROC forw(x,y) IS WriteF('Forw=\d!\n',y)

PROC search2(x)
  WriteF('result=\d\n',easygui('Enter Search/Replace text:',
    [ROWS,
      [COLS,						-> ROWS
        [EQROWS,
          [STR,{find},'Locate',s,10,10],
          [STR,{repl},'Replace',s,10,10]
        ],
        [EQROWS,						-> COLS
          [CHECK,{case},'Ignore case',TRUE,FALSE],
          [CHECK,{word},'Whole words only',FALSE,FALSE],
          [CHECK,{forw},'Search forward',TRUE,FALSE]
        ]
      ],
      [BAR],
      [EQCOLS,
        [BUTTON,1,'Search'],
        [SPACEH],
        [BUTTON,2,'Replace'],
        [SPACEH],
        [BUTTON,0,'Cancel']
      ]
    ]
  ))
ENDPROC

PROC amosaic(x)
  easygui('AMosaic',
    [EQROWS,
      [TEXT,'Wouter''s WWW page','Title:',TRUE,3],
      [TEXT,'file://localhost/...','URL:',TRUE,3],
      [COLS,
        [SBUTTON,0,'Back'],
        [SBUTTON,0,'Forward'],
        [SBUTTON,0,'Home'],
        [SBUTTON,0,'Open'],
        [SBUTTON,0,'Reload'],
        [SBUTTON,0,'Quit']
      ],
      [COLS,
        [BEVELR,
          [SPACE]
        ],
        [SCROLL,0,TRUE,10,0,2,10]
      ],
      [TEXT,'file://localhost/...',NIL,FALSE,3]
    ]
  )
ENDPROC

PROC db(x)
  easygui('EasyBase v0.1',
    [ROWS,
      [LISTV,0,NIL,5,4,NIL,0,NIL,0],
      [COLS,
        [BUTTON,0,'New'],
        [BUTTON,{fields},'Fields'],
        [BUTTON,0,'Load'],
        [BUTTON,0,'Save']]])
ENDPROC

PROC fields(i)
  easygui('Edit Fields',
    [ROWS,
      [LISTV,0,NIL,5,3,NIL,0,NIL,0],
      [COLS,
        [BUTTON,{addfield},'Add'],
        [BUTTON,0,'Delete'],
        [BUTTON,0,'Change']]])
ENDPROC

PROC editfield(i)
  easygui('Field Characteristics',
    [ROWS,
      [EQROWS,
        [STR,0,'fieldname',s,200,10],
        [INTEGER,0,'fieldlength',40,10]],
      [BUTTON,0,'Ok']])
ENDPROC

PROC addfield(i) IS editfield(i)

PROC dm(x)
  easygui('E FileManager v0.1',
    [ROWS,
      [COLS,
        [ROWS,
          [LISTV,0,NIL,1,10,NIL,0,NIL,0],
          [STR,0,'',s,200,5]
        ],
        [EQROWS,
          [BUTTON,1,'DF0:'],
          [BUTTON,1,'DF1:'],
          [BUTTON,1,'Ram:'],
          [BUTTON,1,'System:'],
          [BUTTON,1,'Work:'],
          [BUTTON,1,'E:'],
          [SPACEV]
        ],
        [ROWS,
          [LISTV,0,NIL,1,5,NIL,0,NIL,0],
          [STR,0,'',s,200,5]
        ]
      ],
      [COLS,
        [EQROWS,[SBUTTON,1,'Parent'],[SBUTTON,1,'All']],
        [EQROWS,[SBUTTON,1,'Copy'],[SBUTTON,1,'Clear']],
        [EQROWS,[SBUTTON,1,'Move'],[SBUTTON,1,'Toggle']],
        [EQROWS,[SBUTTON,1,'Rename'],[SBUTTON,1,'Size']],
        [EQROWS,[SBUTTON,1,'Delete'],[SBUTTON,1,'View']],
        [EQROWS,[SBUTTON,1,'MakeDir'],[SBUTTON,0,'Config']]
      ]
    ]
  )
ENDPROC

PROC tiny(x)
  easygui('um..',[BUTTON,0,'blerk'])
ENDPROC

PROC messy(x)
  easygui('test-gui',
    [ROWS,
      [COLS,
        [BEVEL,
          [ROWS,
            [BUTTON,{um},'Um,...'],
            [MX,{v},NIL,['One','Two','Three',NIL],FALSE,1],
            [BUTTON,{pom},'PomPomPom'],
            [CHECK,{v},'check this out!',TRUE,FALSE],
            [STR,{v},'input',s,50,3],
            [LISTV,{v},NIL,2,5,NIL,FALSE,0,0]
          ]
        ],
        [BEVEL,
          [EQROWS,
            [STR,{v},'input',s,50,4],
            [INTEGER,{v},'int:',5,3],
            [SLIDE,{v},'tata:     ',FALSE,0,999,20,2,'%3ld'],
            [TEXT,'bla','text:',FALSE,5],
            [NUM,123,'num:',TRUE,5],
            [PALETTE,{v},'kleur:',3,5,2],
            [CYCLE,{v},'choose:',['Yep','Nope',NIL],1],
            [SCROLL,{v},FALSE,10,0,2,2]
          ]
        ]
      ],
      [BAR],
      [EQCOLS,
        [BUTTON,1,'Save'],
        [BUTTON,2,'Use'],
        [BUTTON,0,'Cancel']
      ]
    ],'bla',NIL,NIL,
    [1,0,'Project',0,  0,0,0,
     2,0,'Load',   'l',0,0,{um},
     2,0,'Save',   's',0,0,{um},
     2,0,'Bla ->', 0,  0,0,0,
     3,0,'aaargh', 'a',0,0,1,
     3,0,'hmmm',   'h',0,0,2,
     2,0,'Quit',   'q',0,0,0,
     0,0,0,0,0,0,0]:newmenu
  )
ENDPROC

PROC um(x) IS WriteF('um! \s\n',x)
PROC pom(x) IS WriteF('pom!\n')
PROC v(x,y) IS WriteF('v=\d!\n',y)
