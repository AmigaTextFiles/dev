OPT MODULE

MODULE  'oomodules/file/textfile/document/hyperTextDocument',
        'oomodules/file/textfile/document'

EXPORT OBJECT amigaguideDocument OF hyperTextDocument
ENDOBJECT

EXPORT OBJECT amigaguideNode OF hyperTextNode
ENDOBJECT

PROC display() OF amigaguideDocument IS EMPTY

PROC edit() OF amigaguideDocument IS EMPTY

PROC buildNodeList() OF amigaguideDocument
DEF list1=NIL,
    list2=NIL,
    list3=NIL,
    finalList,
    len=0

  list1 := self.buildBlockList('@node', '@endnode', 0, "FrFr", {workOnNode})
  list2 := self.buildBlockList('@Node', '@EndNode', 0, "FrFr", {workOnNode})
  list3 := self.buildBlockList('@NODE', '@ENDNODE', 0, "FrFr", {workOnNode})


  len := IF list1 THEN ListLen(list1) ELSE 0
  len := len + IF list2 THEN ListLen(list2) ELSE 0
  len := len + IF list3 THEN ListLen(list3) ELSE 0


  finalList := List(len)

  IF list1 THEN ListCopy(finalList, list1)
  IF list2 THEN ListAdd(finalList, list2)
  IF list3 THEN ListAdd(finalList, list3)

  SetList(finalList,len)

  IF list1 THEN Dispose(list1)
  IF list2 THEN Dispose(list2)
  IF list3 THEN Dispose(list3)

  RETURN finalList

ENDPROC

/*
EXPORT PROC workOnNode(node:PTR TO amigaguideNode)
DEF line,
    position,
    str

  IF node.startLine = -1 THEN RETURN

  line := node.document.getLine(node.startLine)

  WriteF('line:\s\n', line)

  position := InStr(line, ' ', 6)

  IF position>-1 -> we found the name, extract it

    str := String(position-6)

    node.identifier := str
    StrCopy(node.identifier, line+6, position-6)

    str := String(StrLen(line)-position)
    node.title := str
    StrCopy(node.title, line+position+1)

  ENDIF

  RETURN node

ENDPROC
*/

EXPORT PROC workOnNode(n:PTR TO amigaguideNode)
DEF node:PTR TO amigaguideNode

  NEW node
  n.copyTo(node)
  END n

  IF node.startLine = -1 THEN RETURN

  node.getIdentifier()
  node.getTitle()

  RETURN node

ENDPROC

PROC getIdentifier() OF amigaguideNode
DEF line:PTR TO CHAR,
    position

  IF self.startLine = -1 THEN RETURN

  line := self.document.getLine(self.startLine)

  IF line[6]="\q"

    position := InStr(line, '\q', 7)

    self.identifier := String(position-7)
    StrCopy(self.identifier, line+7, position-7)

  ELSE

    position := InStr(line, ' ', 6)

    self.identifier := String(position-6)
    StrCopy(self.identifier, line+6, position-6)

  ENDIF

  RETURN self.identifier

ENDPROC

PROC getTitle() OF amigaguideNode
DEF line:PTR TO CHAR,
    position,
    len

  IF self.startLine = -1 THEN RETURN

  line := self.document.getLine(self.startLine)

  IF line[6]="\q"

    position := InStr(line, '\q', 7)
    INC position

  ELSE

    position := InStr(line, ' ', 6)

  ENDIF


  IF line[position+1] = "\q"

    len := StrLen(line)-position-3
    self.title := String(len)
    StrCopy(self.title, line+position+2, len)

  ELSE

    len := StrLen(line)-position-1
    self.title := String(len)
    StrCopy(self.title, line+position+1, len)

  ENDIF

  RETURN self.title

ENDPROC

EXPORT PROC dumpNodeList(list)
DEF item:PTR TO amigaguideNode,
    index

  IF list
    WriteF('The list contains \d nodes.\n', ListLen(list))

    FOR index := 0 TO ListLen(list)-1

      item := ListItem(list,index)

      dumpNodeInfo(item)

    ENDFOR

  ENDIF

ENDPROC

EXPORT PROC dumpNodeInfo(n:PTR TO amigaguideNode)

  IF n.startLine = -1 THEN RETURN

  WriteF('The node starts at line \d and ends at line \d.\n', n.startLine, n.endLine)
  WriteF('It\as name is \s and it\as title \s.\n', n.identifier, n.title)


ENDPROC
/*EE folds
-1
50 27 54 13 57 25 60 36 63 16 66 7 
EE folds*/
