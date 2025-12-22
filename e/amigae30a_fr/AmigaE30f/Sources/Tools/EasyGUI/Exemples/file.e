-> filereq

OPT OSVERSION=37
MODULE 'tools/EasyGUI'

PROC main() HANDLE
  WriteF('résultat=\d\n',easygui('Select a file:',
    [EQROWS,
      [LISTV,0,NIL,1,5,NIL,0,NIL],
      [STR,0,'Pattern','#?.e',200,10],
      [STR,0,'répertoire','E:',200,10],
      [STR,0,'Fichier','',200,10],
      [COLS,
        [SBUTTON,1,'Ok'],
        [SBUTTON,2,'Disque'],
        [SBUTTON,3,'Parent'],
        [SBUTTON,0,'Arrêter']
      ]
    ],
    0,0,0))
EXCEPT
  WriteF('"\s"\n',[exception,0])
ENDPROC
