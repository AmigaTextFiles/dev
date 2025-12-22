
-> Example10.e

-> As per Example9.e, but has a completely different appearnce!
-> Only one line changed...

MODULE 'muse/muse'
ENUM NONE, QUERY_VALUES      -> NO CHANGE!

DEF labels:PTR TO LONG       -> NO CHANGE!

PROC display_selection()     -> NO CHANGE!
DEF v
   v:=get_gadget_info(get_gadgethandle('message'))
   request(labels[v])
ENDPROC

PROC main()
DEF mykeys, mygadgets, mywindow, myevents    -> NO CHANGE!
   mykeys:=     [["?", QUERY_VALUES]
                ]
   labels:=['Hello','There','Then',0]

/* THIS LINE HAS THE CHANGE!!! */
   mygadgets:=  [
                   ['CYCLE', [NONE,'message','Options',80,10,80,labels]]
                ]
   mywindow:=[
                [KEYS,    mykeys],
                [GADGETS, mygadgets]
             ]
   myevents:=[
               [QUERY_VALUES, {display_selection}]
             ]

   easy_muse([
               [EVENTS, myevents],
               [WINDOW, mywindow]
             ])
ENDPROC
