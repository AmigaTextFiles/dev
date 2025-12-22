-> rechercheun requester en EasyGUI

OPT OSVERSION=37
MODULE 'tools/EasyGUI'

PROC main() HANDLE
  WriteF('résultat=\d\n',easygui('Entrez le texte à Chercher/Remplacer:',
    [ROWS,
      [BEVEL,
        [COLS,                                          -> LIGNEs
          [EQROWS,
            [STR,{find},'Localiser','bla',10,20],
            [STR,{repl},'Remplace','burp',10,20]],
          [ROWS,                                                -> COLONNEs
            [CHECK,{case},'Ignore majuscule',TRUE,FALSE],
            [CHECK,{word},'Mots entiers seul',FALSE,FALSE],
            [CHECK,{forw},'Chercher avant',TRUE,FALSE]]]],
      [EQCOLS,
        [BUTTON,1,'Chercher'],
        [BUTTON,2,'Remplacer'],
        [BUTTON,0,'Arrêter']]]))
EXCEPT
  WriteF('"\s"\n',[exception,0])
ENDPROC

PROC find(x,y) IS WriteF('Trouve="\s"!\n',y)
PROC repl(x,y) IS WriteF('Rempl="\s"!\n',y)
PROC case(x,y) IS WriteF('Majuscule=\d!\n',y)
PROC word(x,y) IS WriteF('Mot=\d!\n',y)
PROC forw(x,y) IS WriteF('Avant=\d!\n',y)
