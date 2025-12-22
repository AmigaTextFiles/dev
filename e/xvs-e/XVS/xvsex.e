MODULE 'xvs', 'libraries/xvs', 'utility/tagitem'

DEF xvsobj:LONG
DEF virii_found:LONG

PROC main()

IF xvsbase:=OpenLibrary('xvs.library',0)
  xvsobj:=XvsAllocObject(XVSOBJ_MEMORYINFO)

  IF xvsobj=0
    WriteF('couldnt allocate object\n')
  ENDIF

  virii_found:=XvsSurveyMemory(xvsobj)
  
  WriteF('\d virii found\n',virii_found)
  
  XvsFreeObject(xvsobj)
  CloseLibrary(xvsbase)
ELSE
  WriteF('couldnt open library\n')
ENDIF

ENDPROC

