OPT MODULE

MODULE  'oomodules/object'

EXPORT OBJECT elist OF object
/****** elist/elist ******************************

    NAME
        elist of object

    PURPOSE
        Handles E's own lists in a more dynamic manner. When the limit of
        items is reached the list is simply expanded.

    ATTRIBUTES
        list:PTR TO LONG -- Normal E list.

        itemCount:LONG -- How many items actually are in the list. Note that
            this is NOT the length of the list. This attribute points at the
            next free slot to put a value in.

        hunkSize:LONG -- The number of items the list is expanded by if
            necessary.

    SEE ALSO
        object/object
********/
  list:PTR TO LONG
  itemCount
  hunkSize
ENDOBJECT

PROC init() OF elist
/****** elist/init ******************************

    NAME
        init() of elist -- Initialization of the object.

    SYNOPSIS
        elist.init()

    FUNCTION
        Sets the hunk size to the initial value (currently this is 16, that
        may change) and allocates a list that can holg that much items.

    SEE ALSO
        elist

********/

  self.hunkSize := 16
  self.list := List(self.hunkSize)
  SetList(self.list, self.hunkSize)

ENDPROC

PROC select(optionlist, index) OF elist
/****** elist/select ******************************

    NAME
        select() of elist -- Selection of action via tag list.

    SYNOPSIS
        elist.select(LONG, LONG)

        elist.select(optionlist, index)

    FUNCTION
        Recognized tags are:
            "list"  --  next item is a normal E list. The object is set to
                hold that list. See elist/set().

    INPUTS
        optionlist:LONG -- list of options

        index:LONG -- index of option list

    EXAMPLE
        see object/select for an example of how select() works in general.

    SEE ALSO
        elist/set()

********/
DEF item

  item:=ListItem(optionlist,index)

  SELECT item

    CASE "set"

      INC index
      self.set(ListItem(optionlist,index))

  ENDSELECT

ENDPROC index

PROC set(elist) OF elist
/****** elist/set ******************************

    NAME
        set() of elist -- Sets the contents of the list.

    SYNOPSIS
        elist.set(LONG)

        elist.set(elist)

    FUNCTION
        The object is set to point to the list that is given to the function.
        By calling this function you hand the list over to the object. That
        means that you may not free it unless you remove it from the object
        first. Note that the list is automatically freed when ENDing this
        object.

        If the object already holds a list that one is freed first. So if
        you want to remove a list from the object safely after you have passed
        it you may call this function with NIL.

    INPUTS
        elist:LONG -- normal E list. May be NIL.

    EXAMPLE

        -> First allocate it

        NEW elist.new()

        -> set it

        elist.set([1,2,3,42])

        -> now free it
        elist.set(NIL)

    NOTES
        This function is called when you provide the tag "list" in the option
        list for method new()

    SEE ALSO
        elist, new()

********/

  IF self.list THEN DisposeLink(self.list)
  self.list := elist
  IF elist THEN self.itemCount := ListLen(self.list) ELSE self.itemCount := 0

ENDPROC

PROC get() OF elist IS self.list, IF self.list THEN ListLen(self.list) ELSE -1
/****** elist/get ******************************

    NAME
        get() of elist -- Get the list and it's length.

    SYNOPSIS
        elist.get()

    FUNCTION
        Gets you the actual E list and it's length. The list may not have all
        it's items set if it was expanded.

    RESULT
        PTR TO LONG -- The E list. NIL if no list is there.

        LONG -- The length of the E list. -1 if no list is there.

    SEE ALSO
        elist

********/

PROC grow() OF elist
/****** elist/grow ******************************

    NAME
        grow() of elist -- Expand a list.

    SYNOPSIS
        elist.grow()

    FUNCTION
        Expands the list by the number of items that is put in the hunkSize
        attribute.

    RESULT
        LONG -- -1 if the list could not be expanded. The current list stays
            valid.

    EXAMPLE

        NEW list.new()

        WriteF('Actual lenght of the list is \d.\n', ListLen(list.list))
        list.grow()
        WriteF('Actual lenght of the list is \d.\n', ListLen(list.list))

    SEE ALSO
        elist, add()

********/
DEF tempList:PTR TO LONG,
    nuSize

  nuSize := ListLen(self.list)+self.hunkSize
  tempList := List(nuSize)

  IF tempList = NIL THEN RETURN -1

  ListCopy(tempList, self.list, ALL)
  DisposeLink(self.list)
  self.list := tempList
  SetList(tempList,nuSize)

ENDPROC

PROC add(item) OF elist
/****** elist/add ******************************

    NAME
        add() of elist -- Add an item to the list.

    SYNOPSIS
        elist.add(LONG)

        elist.add(item)

    FUNCTION
        Adds an item to the list and expands the list if necessary.

    INPUTS
        item:LONG -- Item to add to the list.

    RESULT
        LONG -- -1 if expansion of the list failed. The current list stays
            valid.

    SEE ALSO
        elist, grow()

********/
DEF list:PTR TO LONG,
    res

  list := self.list

  res := Mod(self.itemCount+1, self.hunkSize)
->  WriteF('-- \d\n', res)
  IF (res = 0)

->    WriteF('hafta grow at \d\n', self.itemCount)
    IF self.grow()=-1 THEN RETURN -1
->    WriteF('grown at \n', self.itemCount)
    list := self.list
  ENDIF

  list[self.itemCount] := item
  self.itemCount := self.itemCount+1

ENDPROC

PROC putAt(item,position) OF elist HANDLE
/****** elist/putAt ******************************

    NAME
        putAt() of elist -- Puts an item at a specific position in the list.

    SYNOPSIS
        elist.putAt(LONG, LONG)

        elist.putAt(item, position)

    FUNCTION
        Puts an item in the list at a certain position. Any value that is at
        that position will be overwritten. The list is expanded if necessary.

    INPUTS
        item:LONG -- Item to put in the list.

        position:LONG -- Position to put it at.

    RESULT
        LONG -- -1 if the list could not be expanded. The current list stays
            valid.

    SEE ALSO
        elist, grow()

********/

  WHILE (position>=ListLen(self.list)) -> while position is out of range

    IF (self.grow()=-1) THEN Raise("MEM") -> exit if no memory

  ENDWHILE

  self.list[position] := item

->  WriteF('put \d at \d.\n', item, position)
EXCEPT

  RETURN -1

ENDPROC

PROC getFrom(position) OF elist
/****** elist/getFrom ******************************

    NAME
        getFrom() of elist -- Get item from a specific position.

    SYNOPSIS
        elist.getFrom(LONG)

        elist.getFrom(position)

    FUNCTION
        Gets the item that's at position in the list.

    INPUTS
        position:LONG -- Position to get the item from.

    RESULT
        LONG, LONG -- 0, "rnge" if the position was out of range, i.e. if it
            exceeded the list's length.

    SEE ALSO
        elist

********/

  IF position >= ListLen(self.list) THEN RETURN 0,"rnge"

  RETURN self.list[position]

ENDPROC

PROC end() OF elist
/****** elist/end ******************************

    NAME
        end() of elist -- Global destructor.

    SYNOPSIS
        elist.end()

    FUNCTION
        Disposes the list.

    SEE ALSO
        elist

********/

  IF self.list THEN DisposeLink(self.list)

ENDPROC

PROC kill() OF elist
/****** elist/kill ******************************

    NAME
        kill() of elist -- END all items and the object.

    SYNOPSIS
        elist.kill()

    FUNCTION
        Goes through the list and does an END on each if the item is not NIL.
        After that the object itself is ENDed.

    NOTES
        Only call this function when you really know what is in the list.

    SEE ALSO
        elist

********/
DEF index,
    item

  IF self.list = NIL THEN RETURN

  FOR index := 0 TO self.itemCount

    item := self.list[index]
    IF item THEN END item

  ENDFOR

  END self

ENDPROC


/*EE folds
-1
5 26 7 21 10 40 13 50 39 41 42 42 45 41 48 29 51 18 54 33 
EE folds*/
