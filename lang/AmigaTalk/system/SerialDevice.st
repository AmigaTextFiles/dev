" ---------------------------------------------------------------------"
" SerialDevice Class is derived from abstract Device Class.            "
""
"  WARNING:  You should know what you're doing to the Amiga OS before  "
"            messing with this Class, or any other System Class!       "
" ---------------------------------------------------------------------"

Class SerialDevice :Device ! private bufferSize !
[
   initializeWithTerm: charValString
      <primitive 227 2 charValString private>
|
   readSerial: syncValue       " syncValue = 0 (SYNC_OFF) or 1 (SYNC_ON) "
      ^ <primitive 227 3 private syncValue>
|
   writeThis: writeString
      <primitive 227 4 writeString private>
|
   reset
      <primitive 227 5 private>
|
   pause
      <primitive 227 6 private>
|
   restart
      <primitive 227 7 private>
|
   sendBreakOfDuration: usecs
      <primitive 227 8 usecs private>
|
   getStatus
      ^ <primitive 227 9 private>
|
   flush
      <primitive 227 10 private>
|
   clearReadBuffer
      <primitive 227 11 private>
|
   setSyncType: newSync
      ^ <primitive 227 12 newSync>
|
   setBaud: newBaud
      ^ <primitive 227 13 0 newBaud private>
|
   setParity: newParity status: onOrOff 

      " newParity: 0 = Space, 1 = Mark, 2 = Even & 3 = Odd: "
      <primitive 227 15 newParity onOrOff private>
|
   setDataSize: newSize
      ^ <primitive 227 13 1 newSize private>
|
   setStops: newStops
      ^ <primitive 227 13 2 newStops private>
|
   setBreakLen: duration
      ^ <primitive 227 13 3 duration private>
|
   setRBufSize: size
      ^ <primitive 227 13 4 size private>
|
   setFlags: newFlags
      ^ <primitive 227 13 5 newFlags private>
|
   setTerminators: termCharString
      ^ <primitive 227 14 termCharString private>
|
   open: portName size: newBufferSize
      private <- <primitive 227 1 newBufferSize>.

      bufferSize <- newBufferSize.

      ^ self
|
   close

      <primitive 227 0 private>.

      <primitive 250 5 0 private>.
      
      ^ nil
|
   new: portName
      self open: portName size: 8192.
      ^ self
] 
