-> tag1.e

->>> Header (globals)
MODULE 'utility',
       'intuition/intuition',
       'utility/tagitem'

ENUM ERR_NONE, ERR_LIB, ERR_TAG, ERR_WIN

RAISE ERR_LIB IF OpenLibrary()=NIL,
      ERR_TAG IF AllocateTagItems()=NIL,
      ERR_WIN IF OpenWindowTagList()=NIL
->>>

->>> PROC main()
PROC main() HANDLE
  DEF tags=NIL:PTR TO tagitem, win=NIL
  KickVersion(37)
  -> We need the utility library for this example
  utilitybase:=OpenLibrary('utility.library', 37)

  -> *********************************************************************
  -> This section allocates a tag array, fills it in with values, and then
  -> uses it.
  -> *********************************************************************

  -> Allocate a tag array
  tags:=AllocateTagItems(7)
  -> Fill in our tag array
  tags[0].tag:=WA_WIDTH
  tags[0].data:=320
  tags[1].tag:=WA_HEIGHT
  tags[1].data:=50
  tags[2].tag:=WA_TITLE
  tags[2].data:='RKM Tag Example 1'
  tags[3].tag:=WA_IDCMP
  tags[3].data:=IDCMP_CLOSEWINDOW
  tags[4].tag:=WA_CLOSEGADGET
  tags[4].data:=TRUE
  tags[5].tag:=WA_DRAGBAR
  tags[5].data:=TRUE
  tags[6].tag:=TAG_DONE

  -> Open the window, using the tag attributes as the only description.
  win:=OpenWindowTagList(NIL, tags)
  -> Wait for an event to occur
  WaitIMessage(win)

  -> Close the window now that we're done with it
  CloseWindow(win)
  win:=NIL  -> E-Note: help with error trapping

  -> *********************************************************************
  -> This section builds a static tag list, and passes it to the function.
  -> *********************************************************************

  win:=OpenWindowTagList(NIL,
                        [WA_WIDTH, 320,
                         WA_HEIGHT, 50,
                         WA_TITLE, 'RKM Tag Example 1',
                         WA_IDCMP, IDCMP_CLOSEWINDOW,
                         WA_CLOSEGADGET, TRUE,
                         WA_DRAGBAR, TRUE,
                         TAG_DONE])
  -> Wait for an event to occur
  WaitIMessage(win)
EXCEPT DO
  IF win THEN CloseWindow(win)
  IF tags THEN FreeTagItems(tags)
  IF utilitybase THEN CloseLibrary(utilitybase)
ENDPROC
->>>


