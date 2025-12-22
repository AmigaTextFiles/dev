
OPT OSVERSION=37, LARGE

MODULE  'amigalib/ports',
        'dos/dos',
        'exec/ports',
        'exec/nodes',
        'exec/lists',

        'oomodules/file/textfile/programsource/esource',
        'oomodules/resource',
        'oomodules/object',
        'oomodules/list/queuestack',
        'oomodules/library/reqtools',

        'tools/easygui',
        'tools/constructors',


        '*attribute',
        '*showObject'


ENUM ERR_NONE, ERR_PORT

DEF resourceQS:PTR TO queuestack,
    tempList,
    requester:PTR TO reqtools,
    source:PTR TO eSource,
    stringChosen,
    globalObject:PTR TO object


PROC main() HANDLE
/****** /main ******************************

    NAME
        main() --

    SYNOPSIS
        main()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO

********/
  DEF xyport=NIL:PTR TO mp,
      msg:PTR TO resourceMessage,
      portsig,
      usersig,
      signal,
      abort=FALSE,

      command,
      resource:PTR TO resource

  NEW resourceQS.new()
  NEW requester.new()
  NEW source.new()

  IF NIL=(xyport:=createPort({resourcePortName}, 0)) THEN Raise(ERR_PORT)
  portsig:=Shl(1, xyport.sigbit)
  usersig:=SIGBREAKF_CTRL_C  -> Give user a 'break' signal.

  WriteF('Start the resources now.  CTRL-C here when done.\n')
  -> port1 will wait forever and reply to messages, until the user breaks
  REPEAT
    signal:=Wait(portsig OR usersig)
    -> Since we only have one port that might get messages we have to reply
    -> to, it is not really necessary to test for the portsignal.  If there
    -> is not a message at the port, xymsg simply will be NIL.
    IF signal AND portsig
      WHILE msg:=GetMsg(xyport)

        command := msg.command

        SELECT command
          CASE RCMD_ADD
            resourceQS.addLast(msg.resource)
            WriteF('Resource \d added.\n',msg.resource)
            WriteF('There are now \d resources being tracked.\n', resourceQS.length())

          CASE RCMD_REMOVE
            removeItemFromQS(msg.resource,resourceQS)
            WriteF('Resource \d removed.\n',msg.resource)
            WriteF('There are now \d resources being tracked.\n', resourceQS.length())

          CASE RCMD_INFO
            msg.data := resourceQS.length()
            WriteF('Info sent.\n')

            showResourceList(0)

          CASE RCMD_END

           /*
            * Note that the resource to end is in the data entry so any resource
            * can END another object.
            */

            resource := msg.data

            removeItemFromQS(resource,resourceQS)
            WriteF('\n-- Just removed an item to end.\n')
            WriteF('-- There are now \d resources being tracked.\n\n', resourceQS.length())

            END resource

          CASE RCMD_GETRESOURCE

           /*
            * Try to get the resource we only know the owner entry of.
            */

->            WriteF('Trying to find the resource of object \d.\n',msg.data)

            resource := findObjectInQS(msg.data,resourceQS)

->            WriteF('Found \d (owner attribute is \d) \n', resource, IF resource THEN resource.owner ELSE NIL)

            msg.data := resource

->            WriteF('-- There are now \d resources being tracked.\n\n', resourceQS.length())

        ENDSELECT
        ReplyMsg(msg)

        IF resourceQS.length()=0
          removeResourceTracking()
          WriteF('Resource tracking removed.\n')
        ENDIF

      ENDWHILE
    ENDIF
    IF signal AND usersig  -> The user wants to abort.
      abort:=TRUE
    ENDIF
  UNTIL abort
EXCEPT DO
  IF xyport
    -> Make sure the port is empty.
    WHILE msg:=GetMsg(xyport) DO ReplyMsg(msg)
    deletePort(xyport)
  ENDIF
  SELECT exception
  CASE ERR_PORT;  WriteF('Couldn''t create message port.\n')
  ENDSELECT

  END resourceQS
ENDPROC


PROC removeItemFromQS(item,qs:PTR TO queuestack)
/****** /removeItemFromQS ******************************

    NAME
        removeItemFromQS() --

    SYNOPSIS
        removeItemFromQS(LONG, PTR TO queuestack)

        removeItemFromQS(item, qs)

    FUNCTION

    INPUTS
        item:LONG -- 

        qs:PTR TO queuestack -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO

********/
DEF len,
    index,
    i

  len := qs.length()

  IF len=0 THEN RETURN

  i := qs.getFirst()

  FOR index:=1 TO len
    IF i<>item
      qs.addLast(i)
    ENDIF

    IF (qs.length()>0) THEN i := qs.getFirst()
  ENDFOR

  IF i<>item THEN qs.addLast(i)

ENDPROC


PROC showResourceList(task=NIL) HANDLE
/****** /showResourceList ******************************

    NAME
        showResourceList() --

    SYNOPSIS
        showResourceList(LONG=NIL)

        showResourceList(task)

    FUNCTION

    INPUTS
        task:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO

********/
DEF execlist:PTR TO lh,
    execnode:PTR TO ln,
    nextNode:PTR TO ln,
    str,
    item,
    index,
    list,
    nodeString,
    object:PTR TO object,
    resource:PTR TO resource

  list := resourceQS.asList()

  tempList := list


  execlist := newlist()

  FOR index := 0 TO ListLen(list)-1

    execnode := NIL

    resource := ListItem(list,index)
    object := resource.owner

    EXIT task AND (resource.task<>task)

    nodeString := String(255)
    IF nodeString

      resource := ListItem(list,index)
      object := resource.owner

      StringF(nodeString, '\s (\d)', object.name(), resource.task)

      execnode := newnode(NIL, nodeString)
      AddTail(execlist,execnode)

    ENDIF

  ENDFOR

  easygui('Resource view',
            [EQROWS,
              [LISTV,{actionShowList},NIL,30,10,execlist,0,0,0],
              [BUTTON,NIL,'None']
            ])

->  DisposeLink(list)

EXCEPT DO

  execnode := execlist.head

  FOR index:=1 TO ListLen(list) -> list is as long as execlist

    nextNode := execnode.succ
    Dispose(execnode)
    execnode := nextNode

  ENDFOR

ENDPROC


PROC findObjectInQS(object,qs:PTR TO queuestack)

  globalObject := object

  RETURN qs.detect({testResourceOnObject})

ENDPROC

PROC testResourceOnObject(resource:PTR TO resource)
  IF resource.owner = globalObject THEN RETURN TRUE ELSE RETURN FALSE
ENDPROC
/*EE folds
1
164 52 166 92 
EE folds*/
