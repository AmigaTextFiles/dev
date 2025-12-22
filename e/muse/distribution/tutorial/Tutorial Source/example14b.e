
-> Example14b.e

-> This is Example 14/14a with an alternative, possibly horrendous structure!
-> It does however illustrate very graphically the declarative nature of Muse.
-> It also illustrates the heirarchy involved in defining an interface.
-> One typing mistake though can be a nightmare to find...
MODULE 'muse/muse'

ENUM NONE, SELECTION, QUERY_VALUE
DEF labels:PTR TO LONG

/*{------------------------------- Startup Code --------------------------------}*/
PROC main()
   labels:=['Hello','There','Then',0]
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
PROC myinterface() IS [
   [EVENTS, [
               [QUERY_VALUE, {display_selection}],
               [SELECTION, {menu_selection}]
            ]],
   [WINDOW,
            [
               [TITLE,   'Hello, World!'], -> end of title
               [BOX,     [30,15,240,70]],  -> end of box
               [KEYS,    [
                            ["?", QUERY_VALUE],
                            ["q", QUIT],
                            ["k", CLOSE]
                         ]],  -> end of keys
               [GADGETS, [
                            ['CYCLE', [NONE,'message','Options',80,10,80,labels]],
                            ['BUTTON',[QUERY_VALUE,0,'Cycle value...',40,30,160,13]]
                         ]], -> end of gadgets
               [MENUS,   [
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
                         ]] -> end of menus
            ]] -> end of window
] -> end of interface definition declaration!
