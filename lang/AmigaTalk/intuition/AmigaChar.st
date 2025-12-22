" --------------------------------------------------------------- "
" AmigaChar class is an extension of the Char class in that it    "
" allows the User to decode special RawKey codes that get         "
" returned via GadTool primitives that other Computers don't      "
" have on their keyboards, such as the Help key & the Amiga keys. " 
" --------------------------------------------------------------- "

Class AmigaChar :Char ! myKeyValue shiftFlag !
[
   keyValue
     ^ myKeyValue
|
   isShifted
     ^ shiftFlag
|
   isHelp
      myKeyValue <- self asciiValue.

      (myKeyValue = 16r9F or: [myKeyValue = 16rDF])
         ifTrue: [ (myKeyValue = 16rDF)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                   ^ true ].

      ^ false
|
   isFuncKey
      myKeyValue <- self asciiValue.
      
      ((myKeyValue >= 16r90 and: [myKeyValue <= 16r99]) 
                             or: [myKeyValue >= 16rD0 
                            and: [myKeyValue <= 16rD9]])

         ifTrue: [ (myKeyValue > 16r99)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                     ^ true ].
         
      ^ false
|
   isUpArrow
      myKeyValue <- self asciiValue.

      (myKeyValue = 16r8C or: [myKeyValue = 16rCC])
         ifTrue: [ (myKeyValue = 16rCC)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                     ^ true ].
      ^ false
|
   isDownArrow
      myKeyValue <- self asciiValue.

      (myKeyValue = 16r8D or: [myKeyValue = 16rCD])
         ifTrue: [ (myKeyValue = 16rCD)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                     ^ true ].
      ^ false
|
   isLeftArrow
      myKeyValue <- self asciiValue.

      (myKeyValue = 16r8F or: [myKeyValue = 16rCF])
         ifTrue: [ (myKeyValue = 16rCF)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                     ^ true ].
      ^ false
|
   isRightArrow
      myKeyValue <- self asciiValue.

      (myKeyValue = 16r8E or: [myKeyValue = 16rCE])
         ifTrue: [ (myKeyValue = 16rCE)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                     ^ true ].
      ^ false
|
   isLeftAmiga
      myKeyValue <- self asciiValue.

      (myKeyValue = 16rA6 or: [myKeyValue = 16rE6])
         ifTrue: [ (myKeyValue = 16rE6)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                     ^ true ].
      ^ false
|
   isRightAmiga
      myKeyValue <- self asciiValue.

      (myKeyValue = 16rA7 or: [myKeyValue = 16rE7])
         ifTrue: [ (myKeyValue = 16rE7)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                     ^ true ].
      ^ false
|
   isCapLock
      myKeyValue <- self asciiValue.

      (myKeyValue = 16rA2 or: [myKeyValue = 16rE2])
         ifTrue: [ (myKeyValue = 16rE2)
                     ifTrue:  [ shiftFlag <- true  ]
                     ifFalse: [ shiftFlag <- false ].
                     
                     ^ true ].
      ^ false
]
