MODULE 'workbench','workbench/workbench'


PROC main()
IF (workbenchbase:=OpenLibrary('workbench.library',44))
    wbtitlebar(FALSE)
    Delay(200)
    wbtitlebar(TRUE)
   CloseLibrary(workbenchbase)
ENDIF
ENDPROC



PROC wbtitlebar(hide)
IF (WorkbenchControlA(NIL,[WBA_RESERVED20,-1,NIL]) AND -1)<>-1
    WorkbenchControlA(NIL,[WBA_RESERVED21,hide=-1,NIL])
ENDIF
ENDPROC

