"----------------------------------------------------------------------"
" VeryDangerousDOS Class implements some of the most destructive       "
" AmigaDOS functions into AmigaTalk.                                   "
""
" WARNING:  You should know what you're doing to the Amiga OS before   "
"           messing with this Class, or any other System Class!        "
""
" Please read AmigaTalk:Help/ADos.guide for guidance on how to use the "
" methods of this Class -- it's really getting hard to document each   "
" AmigaTalk Class in two or more places!                               "
" ---------------------------------------------------------------------"

Class VeryDangerousDOS :Object
[
   addSegment: bptrSegList named: segmentName useCount: count

      ^ <primitive 249 0 segmentName bptrSegList count>
|         
   deleteFile: fileOrDirName

      " WARNING!  WARNING!  Danger, Will Robinson! "

      ^ <primitive 249 1 fileOrDirName>
|         
   doPacket: action onPort: msgPort arguments: argArray ! a1 a2 a3 a4 a5 !

      a1 <- argArray at: 1.
      a2 <- argArray at: 2.
      a3 <- argArray at: 3.
      a4 <- argArray at: 4.
      a5 <- argArray at: 5.

      ^ <primitive 249 2 msgPort action a1 a2 a3 a4 a5>
|         
   formatDisk: diskName on: volumeName type: dosType

      " WARNING!  WARNING!  Danger, Will Robinson! "

      ^ <primitive 249 3 diskName volumeName dosType>
|         
   internalLoadSegment: bptrFileHandle ovlyTable: bptrTable funcArray: fArray stackPtr: stack

      ^ <primitive 249 4 bptrFileHandle bptrTable fArray stack>
|         
   internalUnLoadSegment: bptrSegList freeFuncPtr: freeFunc

      ^ <primitive 249 5 bptrSegList freeFunc>
|         
   loadSegment: segmentName

      ^ <primitive 249 6 segmentName>
|         
   newLoadSegment: fileName tags: tagArray

      ^ <primitive 249 7 fileName tagArray>
|
   removeAssignList: assignmentName from: bptrLock

      ^ <primitive 249 8 assignmentName bptrLock>
|         
   removeDosEntry: dosList

      ^ <primitive 249 9 dosList>
|         
   removeSegment: segmentObject

      ^ <primitive 249 10 segmentObject>
|         
   sendPacket: dosPacket to: msgPort replyTo: replyPort

      <primitive 249 11 dosPacket msgPort replyPort>
|         
   setConsoleTask: msgPort

      ^ <primitive 249 12 msgPort>
|         
   setFileSystemTask: msgPort

      ^ <primitive 249 13 msgPort>
|         
   systemCommandTagList: commandString tags: tagArray

      ^ <primitive 249 14 commandString tagArray>
|         
   unLoadSegment: bptrSegList

      ^ <primitive 249 15 bptrSegList>
|         
   waitForPacket

      ^ <primitive 249 16>
]
