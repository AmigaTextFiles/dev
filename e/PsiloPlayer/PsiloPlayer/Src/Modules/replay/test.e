
MODULE  'tools/file','exec/memory','replay/jamcracker'

PROC main()
    DEF m
    m:=readfile(arg,0,MEMF_CHIP)
    IF jc_StartInt(m)
        WriteF('Playing module... press LMB to end\n')
        REPEAT
            WaitTOF()
        UNTIL Mouse()=1
        jc_StopInt()
    ELSE
        WriteF('Error!\n')
    ENDIF
ENDPROC

