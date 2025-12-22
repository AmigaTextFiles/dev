
PROC main()
   wakeUp({little_thread}, 'little thread')
   WriteF(' little thread is playing in the garden!\n')
ENDPROC

PROC little_thread(mama) -> we keep mama with us a while
  ->do initiations...    -> mama is kept on hold ..
  imReady(mama)      -> let mama go do better things..
  ->rest of program.. -> concour the world on our own..
ENDPROC
