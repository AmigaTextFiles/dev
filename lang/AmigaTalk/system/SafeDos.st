"----------------------------------------------------------------------"
" SafeDOS Class implements some of the less intrusive AmigaDOS func-   "
" tions into AmigaTalk.                                                "
""
" WARNING:  You should know what you're doing to the Amiga OS before   "
"           messing with this Class, or any other System Class!        "
""
" Please read AmigaTalk:Help/ADos.guide for guidance on how to use the "
" methods of this Class -- it's really getting hard to document each   "
" AmigaTalk Class in two or more places!                               "
" ---------------------------------------------------------------------"

Class SafeDOS :Object
[
   abortPacket: dosPacket onMsgPort: msgPort
      <primitive 246 0 msgPort dosPacket>
|
   addBuffers: howMany toFileDevice: diskDrive     
      ^ <primitive 246 1 diskDrive howMany>
|
   getCLIObject
      ^ <primitive 246 2>
|
   compareDates: dateStamp1 and: dateStamp2
      ^ <primitive 246 3 dateStamp1 dateStamp2>
|
   currentDir: fromBPTRLock
      ^ <primitive 246 4 fromBPTRLock>
|
   dateToStr: dateTime
      ^ <primitive 246 5 dateTime>
|
   delay: ticks
      <primitive 246 6 ticks>
|
   endNotify: notifyRequest
      <primitive 246 7 notifyRequest>
|
   errorReport: code type: t arg1: a1 fromDevicePort: msgPort
      ^ <primitive 246 8 code t a1 msgPort>
|
   fault: header code: c into: aBuffer ofSize: length
      ^ <primitive 246 9 c header aBuffer length>
|
   fGetC: fromBPTRFileHandle
      ^ <primitive 246 10 fromBPTRFileHandle>
|
   fGets: fromBPTRFileHandle into: aBuffer ofSize: length using: flag
      " If flag is 0, then a newline will be left on the end of the
      * returned String, a value of 1 will replace the last newline
      * with a value of 0.
      "
      ^ <primitive 246 11 fromBPTRFileHandle aBuffer length flag>
|
   findCliProc: numbered
      ^ <primitive 246 12 numbered>
|
   findVar: varName ofType: type
      ^ <primitive 246 13 varName type>
|
   fPutC: theChar to: bptrFileHandle
      ^ <primitive 246 14 bptrFileHandle theChar>
|
   fPutS: aString to: bptrFileHandle
      ^ <primitive 246 15 bptrFileHandle aString>
|
   getArgStr
      ^ <primitive 246 16>
|
   getConsoleTask
      ^ <primitive 246 17>
|
   getCurrentDirNameInto: aBuffer ofSize: length
      ^ <primitive 246 18 aBuffer length>
|
   getDeviceProc: name auxDevProc: devProc
      ^ <primitive 246 19 name devProc>
|               
   getFileSysTask
      ^ <primitive 246 20>
|
   getProgramDir
      ^ <primitive 246 21>
|
   getProgramNameInto: aBuffer ofSize: length
      ^ <primitive 246 22 aBuffer length>
|
   getPromptInto: aBuffer ofSize: length
      ^ <primitive 246 aBuffer length>
|
   getVarNamed: name into: aBuffer ofSize: size flags: flags
      <primitive 246 24 name aBuffer size flags>
|
   getIoErr                  " Tested "
      ^ <primitive 246 25>
|         
   isFileSystem: name
      ^ <primitive 246 26 name>
|
   isInteractive: bptrFileHandle
      ^ <primitive 246 27 bptrFileHandle>
|               
   matchEnd: anchorPath
      <primitive 246 28 anchorPath>
|
   matchFirst: pattern fromAnchor: anchorPath
      ^ <primitive 246 29 pattern anchorPath>
|
   matchNext: anchorPath
      ^ <primitive 246 30 anchorPath>
|
   getMaxCli
      ^ <primitive 246 31>
|
   getParentDirLock: fromBPTRLock
      ^ <primitive 246 33 fromBPTRLock>
|
   getParentLockFromFH: fromBPTRFileHandle
      ^ <primitive 246 33 fromBPTRFileHandle>
|
   getPathPart: pathAndFile               " Tested "           
      " AmigaDOS implementation: "
      ^ <primitive 246 34 pathAndFile>
|
   getRealPathPart: pathAndFile           " Tested "
      " My (less non-sensical) implementation: "
      ^ <primitive 246 56 pathAndFile>
|
   getFilePart: pathAndFile               " Tested " 
      ^ <primitive 246 55 pathAndFile>               
|
   printFault: header code: c
      ^ <primitive 246 35 c header>
|
   putStr: aString
      ^ <primitive 246 36 aString>
|               
   read: bptrFileHandle into: aBuffer ofSize: length
      ^ <primitive 246 37 bptrFileHandle aBuffer length>
|
   readArgs: template into: stringPointerArray auxRDArgs: rdArgs
      ^ <primitive 246 38 template stringPointerArray rdArgs>
|               
   readItemInto: aBuffer ofSize: maxChars with: csourceInput
      ^ <primitive 246 39 aBuffer maxChars csourceInput>
|
   readLinkInto: aBuffer ofSize: length onPort: msgPort using: bptrLock and: pathName
      ^ <primitive 246 40 msgPort bptrLock pathName aBuffer length>
|
   areSameDevice: bptrLock1 and: bptrLock2
      ^ <primitive 246 41 bptrLock1 bptrLock2>
|
   areSameLock: bptrLock1 and: bptrLock2
      ^ <primitive 246 42 bptrLock1 bptrLock2>
|               
   setCommentFieldOf: fileOrDirName to: comment   " Tested "
      ^ <primitive 246 43 fileOrDirName comment>
|
   setFileDateOf: fileOrDirName to: dateStampObject
      ^ <primitive 246 44 fileOrDirName dateStampObject>
|               
   setIoErrTo: errorCode
      ^ <primitive 246 45 errorCode>
|
   translateIoErrToString: errorCode
      ^ <primitive 246 58 errorCode>
|
   setPromptTo: newPromptString
      ^ <primitive 246 46 newPromptString>
|
   stringToProtectionMask: protectionString            " Tested with +HPRW-SAED "
      " Change a more readable (& memorable) string of protection
      * bit specifiers into a protection mask for
      * 'setProtectionOf:to:' below.
      *
      * format is: '+HPSA-RWED' or '+RWED' or '-hpsa' or '-rwed'
      * or '+rwed-hpsa'  The string is NOT case sensitive.
      * every flag after a + gets set, every flag after a - 
      * gets cleared.  All bit specifiers do NOT have to be present.
      "
      ^ <primitive 246 57 protectionString>               
|
   setProtectionOf: filename to: protectionMask    " Tested. "
      ^ <primitive 246 47 filename protectionMask>
|
   splitName: name by: sep into: aBuffer ofSize: size at: oldpos
      ^ <primitive 246 48 name sep aBuffer oldpos size>
|               
   strToDate: dateTimeObject
      ^ <primitive 246 49 dateTimeObject>
|               
   strToLong: aString
      ^ <primitive 246 50 aString>
|
   unGetC: chr to: bptrFileHandle
      ^ <primitive 246 51 bptrFileHandle chr>
|
   vFPrintfTo: bptrFileHandle format: fmtString withArgs: argv
      ^ <primitive 246 52 bptrFileHandle fmtString argv>
|
   vPrintf: formatString withArgs: argv
      ^ <primitive 246 53 formatString argv>
|
   waitForCharAt: bptrFileHandle for: timeout
      ^ <primitive 246 54 bptrFileHandle timeout>
] 
