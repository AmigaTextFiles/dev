
-> Example9.e
-> As per Example8.e, but now queries via a key press! ('?' key)
-> You will note the query procedure, and the event declaration has NOT changed.

MODULE 'muse/muse'
ENUM NONE, QUERY_VALUES        -> QUERY_VALUE is used as a user-event number which
                               -> is raised by the gadget.

DEF labels:PTR TO LONG        -> Used to hold a pointer a an array of strings
                              -> to use as the gadget's labels.

PROC display_selection()      -> The QUERY_VALUE event handler.
DEF v
   v:=get_gadget_info(get_gadgethandle('message')) -> Get the gadget's value (integer)
   request(labels[v])                              -> Display the string relating to it
ENDPROC

PROC main()
DEF mykeys, mygadgets, mywindow, myevents    -> Variable mykeys added
   mykeys:=    [["?", QUERY_VALUES]          -> Extra line.
               ]
   labels:=    ['Hello','There','Then',0]
   mygadgets:= [
                  ['RADIO', [NONE,'message',labels,10,10,0]] -> disable querying
               ]                                             -> when gadget clicked.
   mywindow:=[
                [KEYS,    mykeys],           -> Extra line.
                [GADGETS, mygadgets]
             ]
/* No changes from here on! */
   myevents:=[
               [QUERY_VALUES, {display_selection}]
             ]

   easy_muse([
               [EVENTS, myevents],
               [WINDOW, mywindow]
             ])
ENDPROC
