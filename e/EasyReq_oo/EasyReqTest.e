MODULE 'oomodules/easyreq_oo'

PROC main() HANDLE
 DEF x, er:PTR TO easyreq
 NEW er.easyreq('TestMenu!','Yes|No')
 FOR x:=0 TO 2
  WriteF('Tryck Yes/No: \d\n',er.req('Tryck..'))
  WriteF('Test test: \d\n',er.req('Det andra testet..','test'))
  WriteF('Megatest : \d\n',er.req('Ett megamatiskt upptryck\n' +
                                  'som det är meningen att det\n' +
                                  'ska bli väldiggt många rader\n' +
                                  'långt, vi får väl se hur det blir\n' +
                                  'med det nu då..',
                                  'Med|egendefinierade|gads|här :)'))
  IF x=0 THEN er.chgmenugads('En ny meny!!')
  IF x=1 THEN er.chgmenugads('den sista menyn..',
                             'Med..|..mer..|..gads!')
 ENDFOR
 END er
 WriteF('\nout..\n')
EXCEPT
 WriteF('Exception: \s\n',[exception,0])
ENDPROC
