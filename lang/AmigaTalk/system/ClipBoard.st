" ---------------------------------------------------------------------"
" ClipBoard Class is derived from abstract Device Class.               "
""
"  WARNING:  You should know what you're doing to the Amiga OS before  "
"            messing with this Class, or any other System Class!       "
" ---------------------------------------------------------------------"

Class ClipBoard :Device ! unitNumber !
[
   new: unitNum
      self setClipUnit: unitNum.
      ^ self
|
   new
      ^ self new: 0
|
   openHookedClipboard: clipNumber withHook: aHook ! check !
      "Read the help file about this method."
      check <- <primitive 221 5 clipNumber aHook>.

      (check == nil)
         ifTrue: [ 'Clip #',clipNumber,' did NOT open!' print.
                   ^ nil
                 ].
         
      ^ self setClipUnit: clipNumber
|      
   closeHookedClipboard
      "Read the help file about this method."
      <primitive 221 6 unitNumber>
|
   setClipUnit: unitNum
      ^ unitNumber <- unitNum
|
   writeFTXTClipToFTXTFile: fileName ! check !
      check <- <primitive 221 2 unitNumber fileName>.
      
      (check ~= 0)
         ifTrue: [ 'Clip did NOT make it to file ',fileName print.
                   <primitive 221 9 check> print
                 ]
|
   writeFTXTClipToASCIIFile: filename ! check !
      check <- <primitive 221 4 filename unitNumber>.

      (check ~= 0)
         ifTrue: [ 'Clip did NOT make it to file ',filename print.
                   <primitive 221 9 check> print.
                   ^ nil
                 ]
|
   postFTXTToClip: ftxtString ! check !
      "Experimental, DO NOT USE."
      check <- <primitive 221 13 unitNumber ftxtString>.
      
      (check ~= 0)
         ifTrue: [ 'string did NOT make it to the clipboard!' print.
                   <primitive 221 9 check> print
                 ]
|
   postAsciiFileToClip: fileName ! check !
      check <- <primitive 221 0 unitNumber fileName>.
      
      (check ~= 0)
         ifTrue: [ fileName,' did NOT make it to the clipboard!' print.
                   <primitive 221 9 check> print
                 ]
|
   update            "Send CMD_UPDATE to the device"
      (<primitive 221 12 unitNumber> ~= true)
         ifTrue: [ 'Clipboard update method failed!' print]
|
   postFTXTFileToClip: fileName ! check !
      check <- <primitive 221 7 unitNumber fileName>.
      
      (check ~= 0)
         ifTrue: [ fileName,' did NOT make it to the clipboard!' print.
                   <primitive 221 9 check> print
                 ]
|
   postILBMFileToClip: fileName ! check !
      check <- <primitive 221 8 unitNumber fileName>.
      
      (check ~= 0)
         ifTrue: [ fileName,' did NOT make it to the clipboard!' print.
                   <primitive 221 9 check> print
                 ]
|
   writeILBMClipToFile: fileName ! check !
      check <- <primitive 221 14 unitNumber fileName>.
      
      (check ~= 0)
         ifTrue: [ 'Clip did NOT make it to file ', fileName print.
                   <primitive 221 9 check> print
                 ]
|
   postAsciiStringToClip: clipString
      <primitive 221 1 clipString unitNumber>
| 
   clipTypeIs ! clipType !
      clipType <- <primitive 221 3 unitNumber>.
      
      (clipType == nil)
         ifTrue: [ ^ #CLIP_ERROR ].
      
      (clipType == true)   
         ifTrue:  [ ^ #FTXT ].
      
      ^ #ILBM
] 

"----------------------------------------------------------------------"
" IFFClipBoard Class is derived from abstract Device Class.            "
"  This class only reads & writes FTXT to clipboard.                   "
""
"  WARNING:  You should know what you're doing to the Amiga OS before  "
"            messing with this Class, or any other System Class!       "
"----------------------------------------------------------------------"

Class IFFClipBoard :Device
[
   postToClipUnit: unit fromFTXTString: ftxtString ! check !
      check <- <primitive 221 10 unit ftxtString>.

      (check ~= 0)
         ifTrue: [ 'String did NOT make it to Clipboard!' print.
                   <primitive 221 9 check> print
                 ]
|
   writeFTXTClip: unit toFTXTString: ftxtString size: numBytes ! check !
      check <- <primitive 221 11 unit numBytes ftxtString>.
      
      (check ~= 0)
         ifTrue: [ 'Clip did NOT make it to string!' print.
                   <primitive 221 9 check> print
                 ]
]
