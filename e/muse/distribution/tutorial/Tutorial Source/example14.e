
-> Example14.e
-> A vaguely complex menu, cycle gadget, a button to query it,
-> a menu option to query the cycle gadget, and a keyboard shortcut to
-> query it.
-> All these methods of querying the gadget you will notice *still* use the
-> same processing code!

MODULE 'muse/muse'

ENUM NONE, SELECTION, QUERY_VALUE
DEF labels:PTR TO LONG

/* This might seem silly, but these two procedures STILL haven't changed! */
PROC menu_selection() IS request('You selected a menu item!')
PROC display_selection()
DEF v
   v:=get_gadget_info(get_gadgethandle('message'))
   request(labels[v])
ENDPROC



PROC main()
DEF title, box, keyboard, mygadgets, mymenus, mywindow, myevents, name
   name:=     'WINODW1'             -> name for window
   title:=    'Hello, World!'       -> Text to put in title bar
   box:=      [30,15,240,70]        -> Lets declare the window size
   keyboard:= [                     -> Declare a keyboard handler.
                 ["?", QUERY_VALUE],
                 ["q", QUIT],
                 ["k", CLOSE]
              ]
   labels:=['Hello','There','Then',0]     -> As before


-> The first gadget is the gadget that cycles through the options.
-> The second, when clicked, tells Muse to raise a QUERY_VALUE event.
   mygadgets:=  [
                   ['CYCLE', [NONE,'message','Options',80,10,80,labels]],
                   ['BUTTON',[QUERY_VALUE,0,'Cycle value...',40,30,160,13]]
                ]


/* The menu declaration */
   mymenus:= [
               ['HEADER','Project'],
                  ['ITEM', ['New'    ,'n',SELECTION]],
                  ['STD_IMAGE', ['OPEN','o',SELECTION]],
                  ['ITEM', ['Printer',0,0]],
                     ['SUBITEM',       ['Print','p',0]],
                     ['SUB_STD_IMAGE', ['PRINT','p',0]],
                     ['SUB_STD_IMAGE', ['PRINTSETUP','p',0]],
                  ['BAR',0],
                  ['ITEM', ['What''s the gadget value?',  '?',QUERY_VALUE]],
                  ['BAR',0],
                  ['ITEM', ['Quit',   'q',QUIT]],
               ['HEADER','Edit'],
                 ['STD_IMAGE', ['MUSE_LOGO',0,0]],
                  ['ITEM', ['Clips',0,0]],
                     ['SUB_STD_IMAGE', ['CUT',  'x',0]],
                     ['SUB_STD_IMAGE', ['COPY', 'c',0]],
                     ['SUB_STD_IMAGE', ['PASTE','v',0]]
             ]


/* Now follows a fully fledged window declaration with lots of bits in it! */
   mywindow:=[
                [TITLE,   title],
                [BOX,     box],
                [KEYS,    keyboard],
                [GADGETS, mygadgets],
                [MENUS,   mymenus]
             ]


/* The rest from here on is the same as all the other examples like this! */
   myevents:=[
               [QUERY_VALUE, {display_selection}],
               [SELECTION, {menu_selection}]
             ]
   easy_muse([
               [EVENTS, myevents],
               [WINDOW, mywindow]
             ])
ENDPROC
