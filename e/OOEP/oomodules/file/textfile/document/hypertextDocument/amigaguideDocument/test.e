OPT LARGE

MODULE  'oomodules/file/textfile/document/hyperTextDocument/amigaguideDocument',
        'oomodules/gui/requester/standard',
        'oomodules/list/execlist',
        'tools/easygui'


PROC main()
DEF agd:PTR TO amigaguideDocument,
    r:PTR TO standardRequester,
    index,
    n:PTR TO amigaguideNode,
    el:PTR TO execlist,
    list:PTR TO LONG

  NEW r.new()

  NEW agd.new(["suck",r.getFile('Choose a file to load')])

  agd.nodeList := agd.buildNodeList()

  dumpNodeList(agd.nodeList)

  showNodes(agd)
ENDPROC

PROC showNodes(agd:PTR TO amigaguideDocument)
DEF list:PTR TO LONG,
    index,
    agn:PTR TO amigaguideNode,
    execlist:PTR TO execlist

  list := List(ListLen(agd.nodeList))
  SetList(list,ListLen(agd.nodeList))

  FOR index := 0 TO ListLen(list)

    agn := ListItem(agd.nodeList,index)
    list[index] := agn.identifier

  ENDFOR

  showList(list,'hi')

ENDPROC

PROC showList(list, title)
DEF execlist:PTR TO execlist

  NEW execlist.new(["list", list])

  easygui(title,
            [EQROWS,
              [LISTV,NIL,NIL,30,10,execlist.list,0,0,0],
              [BUTTON,NIL,'None']
            ])

  END execlist

ENDPROC
