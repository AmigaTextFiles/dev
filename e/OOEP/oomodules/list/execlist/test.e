MODULE  'oomodules/list/execlist',

        'tools/easygui'

PROC main() HANDLE

  showList(NIL,'huhu')

EXCEPT
  WriteF('exception raised\n')
ENDPROC

PROC showList(list, title)
DEF execlist:PTR TO execlist

  NEW execlist.new(["list", ['1','two','tres','vier']])

  easygui(title,
            [EQROWS,
              [LISTV,NIL,NIL,30,10,execlist.list,0,0,0],
              [BUTTON,NIL,'None']
            ])

  END execlist

ENDPROC
