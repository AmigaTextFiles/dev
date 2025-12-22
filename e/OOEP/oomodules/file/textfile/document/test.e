MODULE  'oomodules/file/textfile/document',
        'oomodules/gui/requester/standard'

PROC main()
DEF d:PTR TO document,
    r:PTR TO standardRequester,
    item:PTR TO textBlock,
    index=0,
    list

  NEW r.new()

  NEW d.new(["suck", r.getFile('Choose a file to load')])

  list := d.buildBlockList('@node', '@endnode')

  IF list

    FOR index := 0 TO ListLen(list)-1

      item := ListItem(list,index)

      WriteF('The block starts at line \d and ends at line \d.\n', item.startLine, item.endLine)

    ENDFOR

  ENDIF

ENDPROC
