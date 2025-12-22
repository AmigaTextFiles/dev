-> test EasyGUI

OPT OSVERSION=37
MODULE 'tools/EasyGUI', 'graphics/text'

PROC main() HANDLE
  WriteF('résultat=\d\n',easygui('test-gui',
    [ROWS,
      [BEVEL,
        [EQROWS,
          [BUTTON,{um},'Euh,...'],
          [MX,{mx},NIL,['Un','Deux','Trois',NIL],FALSE],
          [BUTTON,{pom},'PomPomPom'],
          [CHECK,{pom},'Regardez!',TRUE,FALSE],
          [STR,3,'input','bla',10,4]]],
      [EQCOLS,
        [BUTTON,1,'Sauve'],
        [BUTTON,2,'Utilise'],
        [BUTTON,0,'Arrêter']]]))
EXCEPT
  WriteF('"\s"\n',[exception,0])
ENDPROC

PROC um(x) IS WriteF('Euh!\n')
PROC pom(x) IS WriteF('Pom!\n')
PROC mx(x,y) IS WriteF('mx=\d!\n',y)
