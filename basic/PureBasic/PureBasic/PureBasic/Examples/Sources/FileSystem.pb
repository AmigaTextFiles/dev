;
; **************************************
;
; FileSystem example file for PureBasic
;
;    © 2001 - Fantaisie Software -
;
; ***************************************
;

Path$ = "Dh0:"

If ExamineDirectory(Path$, "")
  PrintN("Listing the directory content:")

  Repeat
    Type = NextDirectoryEntry()
    
    Select Type
    
      Case 1
        PrintN(DirectoryEntryName()+" "+Str(FileSize(Path$+DirectoryEntryName())))
      
      Case 2
        PrintN("(Dir) "+DirectoryEntryName())
      
    EndSelect
  Until Type = 0  
  
EndIf

PrintN("")
PrintN("Listing Finished. Click the mouse to quit.")

MouseWait()
End
; MainProcessor=0
; Optimizations=0
; CommentedSource=0
; CreateIcon=0
; NoCliOutput=0
; Executable=PureBasic:Examples/Sources/
; Debugger=1
; EnableASM=0
