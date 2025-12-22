"----------------------------------------------------------------------"
" DangerousDOS Class implements some of the more intrusive AmigaDOS    "
" functions into AmigaTalk.                                            "
""
" WARNING:  You should know what you're doing to the Amiga OS before   "
"           messing with this Class, or any other System Class!        "
""
" Please read AmigaTalk:Help/ADos.guide for guidance on how to use the "
" methods of this Class -- it's really getting hard to document each   "
" AmigaTalk Class in two or more places!                               "
" ---------------------------------------------------------------------"

Class DangerousDOS :Object
[
   addDosEntry: dosListObject
      ^ <primitive 248 0 dosListObject>
|               
   allocDosObject: type tags: tagArray   " Tested "
      ^ <primitive 248 1 type tagArray>
|
   attemptLockDosList: flags
      ^ <primitive 248 2 flags>
|         
   cliInitNewCLI: dosPacketObject
      ^ <primitive 248 3 dosPacketObject>
|
   cliInitRun: dosPacketObject
      ^ <primitive 248 4 dosPacketObject>
|         
   createNewProcess: tagArray
      ^ <primitive 248 5 tagArray>
|         
   createProcess: processName priority: pri segments: bptrSegmentList stack: stackSize
      ^ <primitive 248 6 processName pri bptrSegmentList stackSize>
|         
   deleteVar: varName flags: f
      ^ <primitive 248 7 varName f>
|         
   makeDeviceProcess: deviceName
      ^ <primitive 248 8 deviceName>
|         
   exitProgram: returnCode
      <primitive 248 9 returnCode>
|         
   freeArgs: rdArgsObject
      <primitive 248 10 rdArgsObject>
|         
   freeDeviceProcess: devProcessObject
      <primitive 248 11 devProcessObject>
|         
   freeDosEntry: dosListObject
      <primitive 248 12 dosListObject>
|         
   freeDosObject: dosObject type: t    " Tested "
      <primitive 248 13 t dosObject>
|         
   fileWrite: bptrFileHandle to: aBuffer blkSize: blockLength count: blockCount
      ^ <primitive 248 14 bptrFileHandle aBuffer blockLength blockCount>
|         
   inhibit: fileSystem flags: flag
      ^ <primitive 248 15 fileSystem flag>
|         
   replyPacket: dosPacketObject primaryResult: result1 secondaryResult: result2
      <primitive 248 16 dosPacketObject result1 result2>
|         
   runCommand: bptrSegmentList args: argString count: argSize stack: stackSize
      ^ <primitive 248 17 bptrSegmentList stackSize argString argSize>
|         
   seek: bptrFileHandle to: position mode: mode
      ^ <primitive 248 18 bptrFileHandle position mode>
|         
   selectInput: bptrFileHandle
      ^ <primitive 248 19 bptrFileHandle>
|         
   selectOutput: bptrFileHandle
      ^ <primitive 248 20 bptrFileHandle>
|         
   setArgumentString: argString
      ^ <primitive 248 21 argString>
|         
   setFileSize: bptrFileHandle at: offset mode: mode
      ^ <primitive 248 22 bptrFileHandle offset mode>
|         
   setVBuf: bptrFileHandle to: aBuffer type: t bufferSize: size
      ^ <primitive 248 23 bptrFileHandle aBuffer t size>
|         
   writeFile: bptrFileHandle with: aBuffer ofSize: length
      ^ <primitive 248 24 bptrFileHandle aBuffer length>
]
