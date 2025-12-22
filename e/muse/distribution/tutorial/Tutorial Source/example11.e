
-> Example11.e
-> This program has a simple menu, and a simple menu event handler.

MODULE 'muse/muse'

ENUM NONE, SELECTION

/* Menu event handler */
PROC menu_selection() IS request('You selected a menu item!')

PROC main()
DEF mymenus, mywindow, myevents
/* Define the menus we want and their event numbers */
   mymenus:= [
               ['HEADER','Project'],
               ['ITEM', ['New'    ,'n',SELECTION]],
               ['ITEM', ['Open...','o',SELECTION]],
               ['ITEM', ['Close',  'k',SELECTION]],
               ['ITEM', ['Quit',   'q',QUIT]]
             ]

/*    Define the window structure.
      This version lets everything else - size etc - take their default values */
   mywindow:=[
              [MENUS,    mymenus]
             ]
   myevents:=[
               [SELECTION, {menu_selection}]    -> Define the processing
             ]
   easy_muse([
               [EVENTS, myevents],     -> Tell Muse about the processing.
               [WINDOW, mywindow]      -> Tell Muse about the window.
             ])
ENDPROC
