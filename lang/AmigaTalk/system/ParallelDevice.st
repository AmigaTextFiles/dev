" ----------------------------------------------------------------------"
" ParallelDevice Class is derived from abstract Device Class.           "

"  WARNING:  You should know what you're doing to the Amiga OS before   "
"            messing with this Class, or any other System Class!        " 

" This class is a Singleton Class.  In the future, this class will be   "
" modified to allow more than one Parallel port to be open at a time    "
" (for those of us fortunate enough to have more than one Parallel Port."

" NOTES

  newParms & parallelFlags can have any of the following values:

    2r00000010 PARF_EOFMODE  - check I/O against the TermChars array.
    2r00000100 PARF_ACKMODE  - use ACK handshaking.
    2r00001000 PARF_FASTMODE - Send out data as long as BUSY is low. 
    2r00010000 PARF_SLOWMODE - For transfers to slow printers.
    2r00100000 PARF_SHARED   - Allow sharing of the parallel device.    "
""
" ALL singleton classes MUST contain the following:                     "
"" 
"   the methods:  isSingleton AND privateSetup     AND                  "
"                 uniqueInstance Class instance variable.               "
" ----------------------------------------------------------------------"

Class ParallelDevice :Device ! uniqueInstance flagDictionary !
[
   isSingleton
     ^ true
| 
   status
     "  The returned status has the following meaning:
     *
     *  BIT:  ACTIVE:  FUNCTION:
     *
     *  0      HIGH   Printer Busy toggle (offline).
     *  1      HIGH   Paper out.
     *  2      HIGH   Printer Select.
     *  3      ----   Read = 0, Write = 1
     *  4-7    ----   Reserved.
     "
      ^ <primitive 224 3>
|
   resetPort
      ^ <primitive 224 4>
|                  
   flushPort
      ^ <primitive 224 5>
|                  
   stopPort
      ^ <primitive 224 6>
|                  
   startPort
      ^ <primitive 224 7>
|                  
   setPortParametersTo: newParms
      ^ <primitive 224 8 newParms>
|                  
   readThisMany: numChars
      ^ <primitive 224 9 numChars>
|
   writeToPort: aString thisLong: numChars ! check !
      check <- <primitive 224 10 numChars aString>.
      
      (check ~= numChars)
         ifTrue: [ 'Parallel Port write error!' print]
|                  
   setTerminatorsTo: aString
      "Only the first 4 characters of the string are used."
      ^ <primitive 224 11 aString>
|                  
   setPortDirectionAtomic: rwFlag
      " Not needed for reading & writing to the Parallel Port."
      ^ <primitive 224 12 rwFlag>
|                  
   sendPortControlBits: newBits
      " Only the 3 least-significant bits will be written to the hardware.
        This is to prevent your code from interfering with the Serial
        device.
      "
      ^ <primitive 224 13 newBits>
|                  
   readControlBitsMaskedBy: ctrlMask
      " Only the 3 least-significant bits have any meaning 
        for the Parallel Port.  Use ctrlMask of seven (7).
      "
      ^ <primitive 224 14 ctrlMask>
|
   open: parallelFlags ! check !
   
      check <- <primitive 224 1 parallelFlags>.

      (check ~= 0)
         ifTrue: [ 'Error open Parallel device:' print.
                   <primitive 224 2 check> print.
                   ^ nil
                 ].
      ^ self
|
   close
      <primitive 224 0>
|
   privateNew ! newinstance !
     newinstance <- super new.

     ^ newinstance
|
   new
     ^ self privateSetup
|
   privateInitializeDictionary
     
     flagDictionary at: #PARF_EOFMODE  put: 2r00000010. "check I/O against the TermChars array"
     flagDictionary at: #PARF_ACKMODE  put: 2r00000100. " use ACK handshaking "
     flagDictionary at: #PARF_FASTMODE put: 2r00001000. " Send out data as long as BUSY is low"
     flagDictionary at: #PARF_SLOWMODE put: 2r00010000. " For transfers to slow printers"
     
     " Allow sharing of the parallel device.  This flag is required
     * at all times:
     "
     flagDictionary at: #PARF_SHARED   put: 2r00100000. 
|
   getParFlag: aKey
     ^ flagDictionary at: aKey
|
   privateSetup
     (uniqueInstance isNil)
       ifTrue: [uniqueInstance <- self privateNew.
                flagDictionary <- Dictionary new.
                
                self privateInitializeDictionary.
               ].
               
     ^ self    "or ^ uniqueInstance??"
|
   current
     ^ self privateSetup
|
   current: parallelFlags
     (uniqueInstance isNil)
        ifTrue: [ uniqueInstance <- self privateNew.
                  flagDictionary <- Dictionary new.
                
                  self privateInitializeDictionary.
                  self open: parallelFlags
                ].
      
     ^ uniqueInstance
|
   new: parallelFlags
     ^ (self current: parallelFlags)
]
