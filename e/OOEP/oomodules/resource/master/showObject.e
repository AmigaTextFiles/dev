OPT MODULE

MODULE  'exec/ports',
        'exec/nodes',
        'exec/lists',

        'oomodules/file/textfile/programsource/eSource/eVar',
        'oomodules/file/textfile/programsource/esource',
        'oomodules/file/textfile/programsource/esource/eObject',
        'oomodules/resource',
        'oomodules/object',
        'oomodules/library/reqtools',

        'tools/easygui',    
        'tools/constructors',

        '*attribute'

EXPORT DEF  requester:PTR TO reqtools,
            tempList:PTR TO LONG,
            currentObject:PTR TO eObject, -> holds the object we display
            stringChosen

EXPORT PROC showObject(name:PTR TO CHAR)
DEF file[255]:STRING,
    eObject:PTR TO eObject,
    eVar:PTR TO eVar,
    varList,
    tempList,
    index,
    objectName[255]:STRING,
    parentObject:PTR TO eObject,
    inFile:PTR TO eObject

  IF name=NIL THEN RETURN
  IF StrLen(name)=0 THEN RETURN

  StrCopy(objectName,name)
  LowerStr(objectName)

  requester.file('Where is the object defined?')

  StrCopy(file,requester.dirbuf)
  AddPart(file,requester.filebuf,255)

  IF file[0]=0 THEN RETURN


  varList,eObject := getAttributeList(objectName,file)

  currentObject := eObject -> global var

  IF varList = NIL THEN RETURN

  showAttributeList(varList,objectName)


  FOR index := 0 TO ListLen(varList)-1 DO DisposeLink(ListItem(varList, index))

  DisposeLink(varList)

ENDPROC

EXPORT PROC showList(list, title) HANDLE
DEF execlist:PTR TO lh,
    execnode:PTR TO ln,
    nextNode:PTR TO ln,
    str,
    item,
    index

  WriteF('ShowList is here.\n')

  tempList := list

  execlist := newlist()

  FOR index := 0 TO ListLen(list)-1

    execnode := NIL
    execnode := newnode(NIL, ListItem(list,index))
    AddTail(execlist,execnode)

  ENDFOR

  stringChosen := -1

  easygui(title,
            [EQROWS,
              [LISTV,{actionShowList},NIL,30,10,execlist,0,0,0],
              [BUTTON,NIL,'None']
            ])

EXCEPT DO

  execnode := execlist.head

  FOR index:=1 TO ListLen(list)

    nextNode := execnode.succ
    Dispose(execnode)
    execnode := nextNode

  ENDFOR

  IF stringChosen<>-1 THEN RETURN stringChosen ELSE RETURN NIL

ENDPROC

EXPORT PROC actionShowList(info,number)
DEF resource:PTR TO resource,
    object:PTR TO object

  IF number>=0
    resource := ListItem(tempList,number)
    object := resource.owner
->    WriteF('+\s+ -- ', object.name())
    showObject(object.name())
  ENDIF



  Raise("quit")
ENDPROC


EXPORT PROC showAttributeList(list, title) HANDLE
DEF execlist:PTR TO lh,
    execnode:PTR TO ln,
    nextNode:PTR TO ln,
    str,
    eVar:PTR TO eVar,
    index

 /*
  * set module global variable to the eVar list
  */

  tempList := list

  execlist := newlist()

  FOR index := 0 TO ListLen(list)-1

    execnode := NIL
    eVar := ListItem(list,index)
    execnode := newnode(NIL, eVar.identifier)
    AddTail(execlist,execnode)

  ENDFOR

  stringChosen := -1

  easygui(title,
            [EQROWS,
              [LISTV,{actionShowAttributeList},NIL,30,10,execlist,0,0,0],
              [BUTTON,NIL,'None']
            ])

EXCEPT DO

 /*
  * here only the exec nodes and the list are freed. The eVar list is
  * still valid!
  */

  execnode := execlist.head

  FOR index:=1 TO ListLen(list)

    nextNode := execnode.succ
    Dispose(execnode)
    execnode := nextNode

  ENDFOR

  IF stringChosen<>-1 THEN RETURN stringChosen ELSE RETURN NIL

ENDPROC


EXPORT PROC actionShowAttributeList(info,number)

  IF number>=0

    WriteF('of object \s\n.', currentObject.identifier)
WriteF('offsetlist:\d\n',currentObject.offsetList)
    WriteF('attribute offset: \d\n', ListItem(currentObject.offsetList,number))

  ENDIF

  Raise("quit")
ENDPROC
/*EE folds
-1
64 43 67 13 
EE folds*/
