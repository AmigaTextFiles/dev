MODULE '*msgport','rexxsyslib'
PROC main() HANDLE
    DEF portclass:PTR TO msgport,rc,result
    NEW portclass.create('TEST_PORT',0)
    IF ((rexxsysbase:=OpenLibrary('rexxsyslib.library',0))=NIL) THEN Raise ('YO')
    rc,result:=portclass.putrxcmd(FUNC,'REQUEST TITLE="POZDRAV" BODY="Hallo!!!" BUTTON="OK|CANCEL|BO|YO"','GOLDED.1')
    ->StringF(result,'\d',result)
    WriteF('RC=\d,RESULT=\s\n',rc,result)
    END portclass
EXCEPT
    END portclass
    ENDPROC

