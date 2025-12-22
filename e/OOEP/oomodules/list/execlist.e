OPT MODULE

MODULE  'oomodules/object',

        'tools/constructors',

        'exec/lists',
        'exec/nodes'

EXPORT OBJECT execlist OF object
/****** object/execlist ******************************

    NAME
        execlist of object -- List as used in the exec.library

    PURPOSE
        Just a quick and small implementation of exec's list. Only useable
        for converting from an elist (for listviews etc.)

    ATTRIBUTES
        list:PTR TO lh -- exec's list header

        len:LONG -- number of nodes in the list

    SEE ALSO
        object, exec

********/
  list:PTR TO lh,
  len
ENDOBJECT

PROC init() OF execlist IS EMPTY
/****** execlist/init ******************************

    NAME
        init() of execlist -- Initialization of the object.

    SYNOPSIS
        execlist.init()

    FUNCTION
        Empty by now.

    SEE ALSO
        execlist

********/

PROC select(optionlist, index) OF execlist
/****** execlist/select ******************************

    NAME
        select() of execlist -- Selection of action.

    SYNOPSIS
        execlist.select(LONG, LONG)

        execlist.select(optionlist, index)

    FUNCTION
        Recognized tags are:
            "list" -- take items as node names. See fromList().
    INPUTS
        optionlist:LONG -- list of options

        index:LONG -- index of option list

    SEE ALSO
        execlist, fromList()

********/
DEF item

  item:=ListItem(optionlist,index)

  SELECT item

    CASE "list"

      INC index
      self.fromList(ListItem(optionlist,index))

  ENDSELECT

ENDPROC index

PROC fromList(list:PTR TO LONG) OF execlist
/****** execlist/fromList ******************************

    NAME
        fromList() of execlist -- Take items of elist as node names.

    SYNOPSIS
        execlist.fromList(LONG)

        execlist.fromList(list)

    FUNCTION
        Creates a list. The items of the passed elist are taken as names of
        the nodes. Therefore you may free the elist but not the items.

    INPUTS
        list:LONG -- E list of strings.

    SEE ALSO
        execlist

********/
DEF execlist:PTR TO lh,
    execnode:PTR TO ln,
    nextNode:PTR TO ln,
    str,
    item,
    index

  IF list=NIL THEN RETURN

  self.list := newlist()

  FOR index := 0 TO ListLen(list)-1

    execnode := newnode(NIL, ListItem(list,index))
    AddTail(self.list,execnode)

  ENDFOR

  self.len := ListLen(list)

ENDPROC

PROC end() OF execlist
/****** execlist/end ******************************

    NAME
        end() of execlist -- Global destructor.

    SYNOPSIS
        execlist.end()

    FUNCTION
        Disposes all nodes and the list. If the nodes have names you have to
        dispose them.

    SEE ALSO
        execlist

********/
DEF execnode:PTR TO ln,
    index,
    nextNode:PTR TO ln

  execnode := self.list.head

  FOR index:=1 TO self.len

    nextNode := execnode.succ
    Dispose(execnode)
    execnode := nextNode

  ENDFOR

  DisposeLink(self.list)

ENDPROC

/*EE folds
-1
10 21 29 35 32 41 35 32 
EE folds*/
