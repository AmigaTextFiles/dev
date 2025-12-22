
-> Example 5.e
-> As example 4a, but now with keyboard processing.

MODULE 'muse/muse'
PROC main()
DEF title, box, keyboard, mywindow
   title:=    [TITLE, 'Hello, World!']
   box:=      [BOX, [30,15,590,200]]
   keyboard:= [KEYS, [  ["q", QUIT], ["k", CLOSE]
                     ]
              ]
   mywindow:= [title, box,keyboard]

   easy_muse([ 
               [WINDOW, mywindow]
             ])
ENDPROC
