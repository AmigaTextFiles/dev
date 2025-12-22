; --------------------------------------------------------------------------------------
;
; This source file is part of PureBasic
; For the latest info, see http://www.purebasic.com/
; 
; Copyright (c) 1998-2006 Fantaisie Software
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
;
; --------------------------------------------------------------------------------------
;
; Library stripper
;

InitFile(10)
InitMemoryBank(0)

Path$ = "PureBasic:PureLibraries/"


Procedure StripLibrary(FileName$)

  If ReadFile(0, FileName$)

    LibraryLength.l = Lof()

    AllocateMemoryBank(0, LibraryLength, 0)
    ReadMemory(MemoryBankAddress(0), LibraryLength)
    CloseFile(0)
    
    Structure Long
      L.l
    EndStructure
    
    *Cursor.Long = MemoryBankAddress(0)
    Length = LibraryLength
    
    If *Cursor\L = $3F3  ; An executable..
    
      While *Cursor\L <> 'PBLI' ;  And Length > 0
        *Cursor+2
        Length-2
      Wend
    
      If CreateFile(0, FileName$)
        WriteMemory(*Cursor, Length)
        CloseFile(0)
      EndIf
      
    EndIf
  EndIf

EndProcedure

  

If ExamineDirectory(Path$, "")

  Repeat
    Type = NextDirectoryEntry()
    
    If Type = 1 ; File type only
      StripLibrary(Path$+DirectoryEntryName())
    EndIf
  
  Until Type = 0

EndIf

PrintN("Finished")
MouseWait()

End
; MainProcessor=0
; Optimizations=0
; CommentedSource=0
; CreateIcon=0
; NoCliOutput=0
; Executable=Examples/Sources/
; Debugger=1
; EnableASM=0
