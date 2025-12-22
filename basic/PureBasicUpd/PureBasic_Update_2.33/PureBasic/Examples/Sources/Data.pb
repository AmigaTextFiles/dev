;
; Data use example
;

For k=0 To 2
  Read a.w
  PrintNumberN(a)
Next


Restore StringData
For k=0 To 2
  Read a$
  PrintN(a$)
Next

MouseWait()

End


DataSection

Data.w 1, 10, 20

StringData:
Data.s "Hello", "World", " !"

; MainProcessor=0
; Optimizations=0
; CommentedSource=1
; CreateIcon=0
; NoCliOutput=0
; Executable=Ram Disk:Test.exe
; Debugger=1
; EnableASM=0
