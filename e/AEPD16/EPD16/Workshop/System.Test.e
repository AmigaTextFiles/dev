MODULE '*cpu'


PROC main()
DEF t1, t2, t3
    t1,t2,t3 := systeminfo()
    WriteF('\d \d \d',t1, t2, t3)

ENDPROC


