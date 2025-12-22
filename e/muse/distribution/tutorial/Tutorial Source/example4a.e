
-> Example 4a.e
-> Hello, world and Bigger Things. Done using variables to reduce brackets!

MODULE 'muse/muse'

PROC main()
DEF title, box, mywindow
   title:=    [TITLE, 'Hello, World!']
   box:=      [BOX, [30,15,590,200]]
   mywindow:= [title, box]

   easy_muse([ 
               [WINDOW, mywindow]
             ])
ENDPROC
