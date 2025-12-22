Class Integer :Number
[
   = aNumber

      ^ <primitive 6 self aNumber>
         ifTrue:  [ <primitive 16 self aNumber> ]
         ifFalse: [ super = aNumber ]
|
   > aNumber

      ^ <primitive 6 self aNumber>
         ifTrue:  [ <primitive 13 self aNumber> ]
         ifFalse: [ super > aNumber ]
|
   < aNumber

      ^ <primitive 6 self aNumber>
         ifTrue:  [ <primitive 12 self aNumber> ]
         ifFalse: [ super < aNumber ]
|
   + aNumber

      ^ <primitive 6 self aNumber>
         ifTrue:  [ <primitive 10 self aNumber> ]
         ifFalse: [ super + aNumber ]
|
   - aNumber

      ^ <primitive 6 self aNumber>
         ifTrue:  [<primitive 11 self aNumber>]
         ifFalse: [ super - aNumber ]
|
   * aNumber

      ^ <primitive 6 self aNumber>
         ifTrue:  [<primitive 18 self aNumber>]
         ifFalse: [ super * aNumber ]
|
   / aNumber

      ^ self asFloat / aNumber
|
   allMask: anInteger

      ^ anInteger = <primitive 23 self anInteger>
|
   anyMask: anInteger

      ^ 0 ~= <primitive 23 self anInteger>
|
   asCharacter

      ^ <primitive 36 self>
|
   asFloat

      ^ <primitive 39 self >
|
   asString

      ^ <primitive 37 self>
|
   bitAnd: anInteger

      ^ <primitive 23 self anInteger>
|
   bitAt: anInteger

      ^ <primitive 21 self anInteger>
|
   bitInvert

      ^ <primitive 33 self>
|
   bitOr: anInteger

      ^ <primitive 22 self anInteger>
|
   bitShift: anInteger

      ^ <primitive 25 self anInteger>
|
   bitXor: anInteger

      ^ <primitive 24 self anInteger>
|
   even

      ^ (self rem: 2) = 0
|
   factorial

      ^ <primitive 38 self>
|
   gcd: anInteger

      ^ <primitive 6 self anInteger>
         ifTrue:  [<primitive 20 self anInteger>]
         ifFalse: [self opError]
|
   highBit

      ^ <primitive 34 self>
|
   lcm: anInteger

      ^ <primitive 6 self anInteger>
         ifTrue:  [self * anInteger quo: (self gcd: anInteger)]
         ifFalse: [self opError]
|
   noMask: anInteger

      ^ 0 = (self bitAnd: anInteger)
|
   odd

      ^ (self rem: 2) ~= 0
|
   quo: anInteger

      ^ <primitive 6 self anInteger>
         ifTrue:  [<primitive 28 self anInteger>]
         ifFalse: [self opError]
|
   // aNumber                        "see quo also"

      ^ <primitive 6 self aNumber>
         ifTrue:  [<primitive 19 self aNumber>]
         ifFalse: [self opError]
|
   radix: aNumber

      ^ <primitive 26 self aNumber true true>
|
   print
   
      (self > 255)
         ifTrue:  [ <primitive 121 (self asHex)>       ]
         ifFalse: [ <primitive 121 (self printString)> ]
|
   asHex

      ^ <primitive 26 self 16 false true>
|
   asBinary

      ^ <primitive 26 self 2 false true>
|
   asOctal

      ^ <primitive 26 self 8 false true>
|
   asSignedHex

      ^ <primitive 26 self 16 true true>
|
   asSignedBinary

      ^ <primitive 26 self 2 true true>
|
   asSignedOctal

      ^ <primitive 26 self 8 true true>
|
   asBareHex

      " The radix is NOT generated for this method "
      ^ <primitive 26 self 16 false false>
|
   asBareBinary

      " The radix is NOT generated for this method "
      ^ <primitive 26 self 2 false false>
|
   asBareOctal

      " The radix is NOT generated for this method "
      ^ <primitive 26 self 8 false false>
|
   asBareSignedHex

      " The radix is NOT generated for this method "
      ^ <primitive 26 self 16 true false>
|
   asBareSignedBinary

      " The radix is NOT generated for this method "
      ^ <primitive 26 self 2 true false>
|
   asBareSignedOctal

      " The radix is NOT generated for this method "
      ^ <primitive 26 self 8 true false>
|
   rem: anInteger

      ^ <primitive 6 self anInteger>
         ifTrue:  [<primitive 29 self anInteger>]
         ifFalse: [self opError]
|
   intNegRem: aNumber ! i !

      ^ <primitive 6 self aNumber>  "Used to be '\\', not intNegRem:"
         ifTrue:  [i <- self * ( (self < 0)
                                  ifTrue: [ -1 ] 
                                 ifFalse: [  1 ] ).
           
                   i rem: aNumber ]

        ifFalse:  [self opError]
|
   timesRepeat: aBlock ! i !

      i <- 0.

      [i < self] whileTrue: [aBlock value. i <- i + 1]
]
