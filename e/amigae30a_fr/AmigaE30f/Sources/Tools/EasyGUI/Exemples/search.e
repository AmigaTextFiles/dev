-> search requester in EasyGUI

OPT OSVERSION=37
MODULE 'tools/EasyGUI'

PROC main() HANDLE
  WriteF('résultat=\d\n',easygui('Entrer le texte à chercher/remplacer:',
    [ROWS,
      [BEVEL,
        [ROWS,                                          -> LIGNEs
          [EQROWS,
            [STR,{find},'Localiser','bla',10,20],
            [STR,{repl},'Remplacer','burp',10,20]],
          [COLS,                                                -> COLONNEs
            [CHECK,{case},'Ignorer Majuscule',TRUE,FALSE],
            [CHECK,{word},'Mots entier seul',FALSE,FALSE],
            [CHECK,{forw},'Recherche avant',TRUE,FALSE]]]],
      [EQCOLS,
        [BUTTON,1,'Chercher'],
        [BUTTON,2,'Remplacer'],
        [BUTTON,0,'Arrêter']]]))
EXCEPT
  WriteF('"\s"\n',[exception,0])
ENDPROC

PROC find(x,y) IS WriteF('Trouve="\s"!\n',y)
PROC repl(x,y) IS WriteF('Rempl="\s"!\n',y)
PROC case(x,y) IS WriteF('Majus=\d!\n',y)
PROC word(x,y) IS WriteF('Mot=\d!\n',y)
PROC forw(x,y) IS WriteF('Avant=\d!\n',y)
