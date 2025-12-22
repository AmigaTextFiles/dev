"----------------------------------------------------------------------"
" UnSafeDOS Class implements some of the more intrusive AmigaDOS func- "
" tions into AmigaTalk.                                                "
""
" WARNING:  You should know what you're doing to the Amiga OS before   "
"           messing with this Class, or any other System Class!        "
""
" Please read AmigaTalk:Help/ADos.guide for guidance on how to use the "
" methods of this Class -- it's really getting hard to document each   "
" AmigaTalk Class in two or more places!                               "
" ---------------------------------------------------------------------"

Class UnSafeDOS :Object
[
   addPart: fileName to: dirName ofSize: size
     ^ <primitive 247 0 dirName fileName size>
|         
   addAssignment: assignName to: bptrLock
     ^ <primitive 247 1 assignName bptrLock>
|
   addAssignmentLater: assignName to: pathFileName
     ^ <primitive 247 2 assignName pathFileName>
|         
   addAssignment: assignName toLock: bptrLock
     ^ <primitive 247 3 assignName bptrLock>
|         
   addAssignment: assignName toPath: pathName
     ^ <primitive 247 4 assignName pathName>
|         
   changeMode: bptrLockOrFH type: type to: newMode
     ^ <primitive 247 5 type bptrLockOrFH newMode>
|         
   checkForSignal: withBitMask
     ^ <primitive 247 6 withBitMask>
|         
   close: bptrFileHandle
     ^ <primitive 247 7 bptrFileHandle>
|         
   createDir: dirName
     ^ <primitive 247 8 dirName>
|
   makeDateStamp: dateStampObject
     ^ <primitive 247 9 dateStampObject>
|         
   duplicateLock: bptrLock               " Tested "
     ^ <primitive 247 10 bptrLock>
|         
   duplicateLockFromFH: bptrFileHandle
     ^ <primitive 247 11 bptrFileHandle>
|         
   examineAll: exAllControl with: bptrLock into: aBuffer ofSize: size type: t
     ^ <primitive 247 12 bptrLock aBuffer size t exAllControl>
|
   endExamine: exAllControl with: bptrLock from: aBuffer ofSize: size type: t
     <primitive 247 13 bptrLock aBuffer size t exAllControl>
|         
   examine: bptrLock into: fileInfoBlock          " Tested "
     ^ <primitive 247 14 bptrLock fileInfoBlock>
|         
   examineFileHandle: bptrFileHandle into: fileInfoBlock
     ^ <primitive 247 15 bptrFileHandle fileInfoBlock>
|         
   execute: commandString with: bptrInput and: bptrOutput
     ^ <primitive 247 16 commandString bptrInput bptrOutput>
|         
   examineNext: bptrLock into: fileInfoBlock      " Tested "
     ^ <primitive 247 17 bptrLock fileInfoBlock>
|         
   findArgumentIndex: keyword using: template
     ^ <primitive 247 18 template keyword>
|         
   findDosEntry: devName in: dosList flags: flags
     ^ <primitive 247 19 dosList devName flags>
|
   findSegment: segmentName startingAt: startSegment flag: systemOrUser
     ^ <primitive 247 20 segmentName startSegment systemOrUser>
|         
   flushFileHandle: bptrFileHandle
     ^ <primitive 247 21 bptrFileHandle>
|         
   fileRead: bptrFileHandle into: aBuffer blockSize: blkSize count: blkCount
     ^ <primitive 247 22 bptrFileHandle aBuffer blkSize blkCount>
|
   makeInfoDataObject
     ^ <primitive 247 65>         
|
   disposeInfoDataObject: infoDataObject
     ^ <primitive 247 66 infoDataObject>         
|
   diskInfo: bptrLock into: infoDataObject
     " Remember to use 'disposeInfoDataObject: infoDataObject' when you are done! "
     ^ <primitive 247 23 bptrLock infoDataObject>
|         
   getInputHandle
     ^ <primitive 247 24>
|         
   lockFile: fileName mode: accessMode         " Tested "
     ^ <primitive 247 25 fileName accessMode>
|         
   lockDosList: flags
     ^ <primitive 247 26 flags>
|         
   lockRecord: bptrFileHandle at: offset ofSize: recordLen mode: lockType expire: timeout
     ^ <primitive 247 27 bptrFileHandle offset recordLen lockType timeout>
|         
   lockRecords: recordLock expiring: timeout
     ^ <primitive 247 28 recordLock timeout>
|         
   makeDosEntry: name ofType: type
     ^ <primitive 247 29 name type>
|         
   makeLink: linkName to: destPathBPTRLock flag: softFlag
     ^ <primitive 247 30 linkName destPathBPTRLock softFlag>
|
   matchPattern: pattern in: string
     ^ <primitive 247 31 pattern string>
|         
   matchPatternNoCase: pattern in: string      " Tested "
     ^ <primitive 247 32 pattern string>
|         
   getNameFromFH: bptrFileHandle into: aBuffer ofSize: length
     ^ <primitive 247 33 bptrFileHandle aBuffer length>
|         
   getNameFromLock: bptrLock into: aBuffer ofSize: length
     ^ <primitive 247 34 bptrLock aBuffer length>
|         
   getNextDosEntry: dosList flags: flags
     ^ <primitive 247 35 dosList flags>
|         
   open: fileName mode: accessMode
     ^ <primitive 247 36 fileName accessMode>
|         
   openFileFromLock: bptrLock
     ^ <primitive 247 37 bptrLock>
|         
   getOutputHandle
     ^ <primitive 247 38>
|         
   parsePattern: source into: dest ofSize: destLength
     ^ <primitive 247 39 source dest destLength>
|         
   parsePatternNoCase: source into: dest ofSize: destLength  " Tested "
     ^ <primitive 247 40 source dest destLength>
|         
   relabel: volumeName to: newName
     ^ <primitive 247 41 volumeName newName>
|         
   rename: oldFileOrDirName to: newName
     ^ <primitive 247 42 oldFileOrDirName newName>
|         
   setCurrentDirNameTo: dirName
     ^ <primitive 247 43 dirName>
|         
   setFileMode: bptrFileHandle to: mode
     ^ <primitive 247 44 bptrFileHandle mode>
|         
   setOwnerUID: name to: ownerUID
     ^ <primitive 247 45 name ownerUID>
|         
   setProgramDirTo: bptrLock
     ^ <primitive 247 46 bptrLock>
|         
   setProgramName: newProgramName
     ^ <primitive 247 47 newProgramName>
|         
   setVar: varName from: aBuffer ofSize: size flags: flags
     ^ <primitive 247 48 varName aBuffer size flags>
|         
   startNotify: notifyRequest
     ^ <primitive 247 49 notifyRequest>
|         
   unLock: bptrLock               " Tested "
     <primitive 247 50 bptrLock>
|         
   unLockDosList: flags
     <primitive 247 51 flags>
|         
   unLockRecord: bptrFileHandle at: offset ofSize: length
     ^ <primitive 247 52 bptrFileHandle offset length>
|         
   unLockRecords: recordLockObject
     ^ <primitive 247 53 recordLockObject>
|         
   vFWritef: bptrFileHandle format: formatString args: argv
     ^ <primitive 247 54 bptrFileHandle formatString argv>
|
   writeChars: aBuffer ofSize: length
     ^ <primitive 247 55 aBuffer length>
|
   getFileNameFrom: fileInfoBlock                " Tested "  
     ^ <primitive 247 56 fileInfoBlock>
|
   getFileSizeFrom: fileInfoBlock
     ^ <primitive 247 57 fileInfoBlock>
|
   getBlockCountFrom: fileInfoBlock
     ^ <primitive 247 58 fileInfoBlock>
|
   getCommentFrom: fileInfoBlock
     ^ <primitive 247 59 fileInfoBlock>
|
   getProtectionBitsFrom: fileInfoBlock
     ^ <primitive 247 60 fileInfoBlock>
|
   getDateStampObjectFrom: fileInfoBlock
     ^ <primitive 247 61 fileInfoBlock>
|
   getOwnerUIDFrom: fileInfoBlock
     ^ <primitive 247 62 fileInfoBlock>
|
   getOwnerGIDFrom: fileInfoBlock
     ^ <primitive 247 63 fileInfoBlock>
|
   isFileIn: fileInfoBlock                       " Tested "
     " true for file, false for everything else! "
     ^ <primitive 247 64 fileInfoBlock>
] 
