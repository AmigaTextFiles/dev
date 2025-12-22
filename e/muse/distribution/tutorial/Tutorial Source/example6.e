
-> Example 6.e
-> As per example 5, but with a CLOSE event handler!

MODULE 'muse/muse'

PROC main()
DEF title, box, keyboard, mywindow, myevents
   title:=    [TITLE, 'Hello, World!']
   box:=      [BOX, [30,15,590,200]]
   keyboard:= [KEYS, [ ["q", QUIT], ["k", CLOSE]
                     ]
              ]
   mywindow:= [title, box,keyboard]


/*    Here we declare the pointer to the event handling procedure in the
      event definitions list */
   myevents:= [
                 [CLOSE, {mycloseprocessor}]
              ]

   easy_muse([ 
               [EVENTS, myevents], -> This is where Muse finds out!
               [WINDOW, mywindow]
             ])
ENDPROC

PROC mycloseprocessor() IS CLOSE
   -> This procedure effectively short-circuits the 'Do you really want to
   -> close this window' requester by returning CLOSE which signals `Yes'
   -> to that question to Muse.,
