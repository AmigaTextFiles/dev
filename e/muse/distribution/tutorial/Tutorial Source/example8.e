
-> Example8.e
-> Same as Example7.e but can now query the selection!

MODULE 'muse/muse'
ENUM NONE, QUERY_VALUE        -> QUERY_VALUE is used as a user-event number which
                              -> is raised by the gadget.

DEF labels:PTR TO LONG        -> Used to hold a pointer a an array of strings
                              -> to use as the gadget's labels.


/*{-------------- ADDITIONAL PROCEDURE -------------}*/
PROC display_selection()      -> The QUERY_VALUE event handler.
DEF v
   v:=get_gadget_info(get_gadgethandle('message')) -> Get the gadget's value (integer)
   request(labels[v])                              -> Display the string relating to it
ENDPROC
/*{---------- END OF ADDITIONAL PROCEDURE ----------}*/



PROC main()
DEF mygadgets, mywindow, myevents
   labels:=['Hello','There','Then',0]
   mygadgets:= [
                ['RADIO', [QUERY_VALUE,'message', labels,10,10,0]]
               ]
   mywindow:=[
              [GADGETS, mygadgets]
             ]

/*    This line declares a pointer to a procedure to call when the event
      QUERY_VALUE is raised by the gadget */
   myevents:=[
              [QUERY_VALUE, {display_selection}]
             ]

   easy_muse([
               [EVENTS, myevents],     -> Give Muse the processing.
               [WINDOW, mywindow]      -> Give Muse the window.
             ])
ENDPROC
