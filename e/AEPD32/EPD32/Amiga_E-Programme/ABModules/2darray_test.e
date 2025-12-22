MODULE 'oomodules/2darray'

PROC main() HANDLE
    DEF myarray:PTR TO dd_array
    DEF i,j,val=1,sx,sy
    NEW myarray.create(4,5,CHARS)
    sx,sy:=myarray.size()
    FOR i:=0 TO sx
        FOR j:=0 TO sy
            myarray.set(i,j,val++)
            ENDFOR
        ENDFOR
    FOR i:=0 TO sx
        FOR j:=0 TO sy
            WriteF('myarray [\d,\d]=\d\n',i,j,myarray.get(i,j))
            ENDFOR
        ENDFOR
    END myarray
EXCEPT
    IF exceptioninfo THEN WriteF('\d\n',exceptioninfo)
    CleanUp(exceptioninfo)
ENDPROC
