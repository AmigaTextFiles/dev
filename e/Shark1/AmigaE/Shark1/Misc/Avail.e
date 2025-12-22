MODULE 'exec/memory'

PROC main()
WriteF('\e[2mAvailMem v1.4b By Shark\e[0m\n\n')
WriteF('CHIP:   \t\d FAST: \t\d\n',AvailMem(MEMF_CHIP),AvailMem(MEMF_FAST))
WriteF('PUBLIC: \t\d TOTAL:\t\d\n',AvailMem(MEMF_PUBLIC),AvailMem(MEMF_TOTAL))
WriteF('LARGEST:\t\d CLEAR:\t\d\n',AvailMem(MEMF_LARGEST),AvailMem(MEMF_CLEAR))
ENDPROC
