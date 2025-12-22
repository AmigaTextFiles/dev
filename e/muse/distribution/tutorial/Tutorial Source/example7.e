
-> Example7.e
-> Let's try just having a gadget in the window!

MODULE 'muse/muse'
PROC main()
DEF mywindow, mygadgets
   mygadgets:=[
                 ['RADIO', [0,0,['Hello','There','Then',0],10,10,0]]
              ]
   mywindow:=[[GADGETS, mygadgets]]

   easy_muse([
               [WINDOW, mywindow]
             ])
ENDPROC
