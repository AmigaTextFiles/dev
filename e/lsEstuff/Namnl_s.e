OPT MODULE

MODULE '*/leifoo/mythread'

OBJECT thread
   mothertask
   isrunning:INT
   proctobethread
ENDOBJECT

PROC thread(proc) OF thread
   self.proctobethread := proc
   self.mothertask := FindTask(0)
   self.isrunning := FALSE
ENDPROC

PROC start(pri=NIL, tags=NIL) OF thread
   birth(self.proctobethread, pri, tags)
ENDPROC

PROC ready() OF thread IS cutstring(self.mothertask)




