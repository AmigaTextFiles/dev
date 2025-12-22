
-> Example13.e
-> As per Example12.e and also Example8.e because we've merged the two examples.
-> We can now query the gadget's value by a menu selection instead, but you may
-> notice our procedure to process the QUERY_VALUE event, still hasn't changed!
MODULE 'muse/muse'

ENUM NONE, SELECTION, QUERY_VALUE
DEF labels:PTR TO LONG

-> As before.. Ex 12
PROC menu_selection() IS request('You selected a menu item!')

-> As before.. Ex 8
PROC display_selection()
DEF v
   v:=get_gadget_info(get_gadgethandle('message'))
   request(labels[v])
ENDPROC

PROC main()
DEF mygadgets, mymenus, mywindow, myevents
   labels:=['Hello','There','Then',0]     -> Ex 8
   mygadgets:=  [
                   ['CYCLE', [NONE,'message','Options',80,10,80,labels]]   -> Ex 8
                ]
   mymenus:= [                                                 -> EX 12
               ['HEADER','Project'],
                  ['ITEM', ['New'    ,'n',SELECTION]],
                  ['STD_IMAGE', ['OPEN','o',SELECTION]],
                  ['ITEM', ['Printer',0,0]],
                     ['SUBITEM',       ['Print','p',0]],
                     ['SUB_STD_IMAGE', ['PRINT','p',0]],
                     ['SUB_STD_IMAGE', ['PRINTSETUP','p',0]],
                  ['BAR',0],

/* New option!! */
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
                [GADGETS, mygadgets],
                [MENUS,   mymenus]
             ]

/* NOTE how you delcare extra procressing - you just do it! */
   myevents:=[
               [QUERY_VALUE, {display_selection}],
               [SELECTION, {menu_selection}]
             ]
   easy_muse([
               [EVENTS, myevents],
               [WINDOW, mywindow]
             ])
ENDPROC
