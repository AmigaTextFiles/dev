
-> Example14a.e
-> This is Example14.e, with better structure.

MODULE 'muse/muse'

ENUM NONE, SELECTION, QUERY_VALUE
DEF labels:PTR TO LONG

/*{------------------------------- Startup Code --------------------------------}*/
PROC main()
   easy_muse(myinterface())
ENDPROC

/*{-------------------------------- The Program! --------------------------------}*/
PROC menu_selection() IS request('You selected a menu item!')

PROC display_selection()
DEF v
   v:=get_gadget_info(get_gadgethandle('message'))
   request(labels[v])
ENDPROC


/*{-------------------------- The Interface Definition --------------------------}*/
PROC myinterface()
DEF title, box, keyboard, mygadgets, mymenus, mywindow, myevents, interface
   title:=    'Hello, World!'
   box:=      [30,15,240,70]
   keyboard:= [
                 ["?", QUERY_VALUE],
                 ["q", QUIT],
                 ["k", CLOSE]
              ]

   labels:=['Hello','There','Then',0]
   mygadgets:=  [
                   ['CYCLE', [NONE,'message','Options',80,10,80,labels]],
                   ['BUTTON',[QUERY_VALUE,0,'Cycle value...',40,30,160,13]]
                ]

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

   mywindow:=[
                [TITLE,   title],
                [BOX,     box],
                [KEYS,    keyboard],
                [GADGETS, mygadgets],
                [MENUS,   mymenus]
             ]

   myevents:=[
               [QUERY_VALUE, {display_selection}],
               [SELECTION, {menu_selection}]
             ]
   interface:=[
                 [EVENTS, myevents],
                 [WINDOW, mywindow]
              ]
ENDPROC interface
