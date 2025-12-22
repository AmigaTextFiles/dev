" ------------------------------------------------------------------------ "
" LongInteger Class is for 64-Bit integer representation.  Since there are "
" four functions in utility.library that produce 64-bit quantities, I felt "
" that a separate Class should make use of them.                           "
""
" signed32BitDivide     is really the SDivMod32() function.                "
" unsigned32BitDivide   is really the UDivMod32() function.                "
" signed64BitMultiply   is really the SMult64()   function.                "
" unsigned64BitMultiply is really the UMult64()   function.                "
""
" NOTE: "
" Primitives for addition & subtraction will be added later.               "
" ------------------------------------------------------------------------ "

Class LongInteger :Number ! upper32Bits lower32Bits !
[
   = aNumber ! chk !

      (aNumber isMemberOf: LongInteger)
         ifFalse: [ ^ false ].  "Only valid response for unequal Object Classes"

      chk <- <primitive 16 (self getLower32Bits) (aNumber getLower32Bits)>.

      (chk ~= true)
         ifTrue: [ ^ false ].
                       
      ^ <primitive 16 (self getUpper32Bits) (aNumber getUpper32Bits)>
|
   > aNumber ! chk !

      (aNumber isMemberOf: LongInteger)
         ifFalse: [ ^ false ].   " I might allow comparing to Float later. "
         
      chk <- <primitive 13 (self getLower32Bits) (aNumber getLower32Bits)>.

      (chk ~= true)
         ifTrue:  [ ^ false ]
         ifFalse: [ ^ <primitive 13 (self getUpper32Bits) (aNumber getUpper32Bits)> ]
|
   < aNumber ! chk !

      (aNumber isMemberOf: LongInteger)
         ifFalse: [ ^ false ].   " I might allow comparing to Float later. "
         
      chk <- <primitive 12 (self getLower32Bits) (aNumber getLower32Bits)>.

      (chk ~= true)
         ifTrue:  [ ^ false ]
         ifFalse: [ ^ <primitive 12 (self getUpper32Bits) (aNumber getUpper32Bits)> ]
|
   asString ! highBits !

      highBits <- <primitive 37 (self getUpper32Bits)>.

      " Concatenate the lower 32-Bits onto the upper 32-Bits: "

      ^ (highBits, <primitive 37 (self getLower32Bits)>)
|
   asFloat ! fl1 fl2 !

      fl1 <- <primitive 39 (self getUpper32Bits)>.
      fl2 <- <primitive 39 (self getLower32Bits)>.
      
      ^ (fl1 + fl2)
|
   even ! chk !

      chk <- self signed32BitDivide: self by: 2. " Or should this be unsigned? "
      
      ^ chk = 0
|
   odd ! chk !

      chk <- self signed32BitDivide: self by: 2. " Or should this be unsigned? "
      
      ^ chk ~= 0
|
   getLower32Bits

      ^ lower32Bits
|
   getUpper32Bits

      ^ upper32Bits         
|
   signed32BitDivide: dividend by: divisor ! result !

      " dividend & divisor are 32-Bit Integers: "
      result      <- <primitive 209 3 21 dividend divisor>.

      " upper32Bits is really the Quotient: "
      upper32Bits <- <primitive 209 3 39 result>.

      " lower32Bits is really the Remainder: "
      lower32Bits <- <primitive 209 3 38 result>.
      
      ^ result
|
   unsigned32BitDivide: dividend by: divisor ! result !

      " dividend & divisor are 32-Bit Integers: "
      result      <- <primitive 209 3 22 dividend divisor>.

      " upper32Bits is really the Quotient: "
      upper32Bits <- <primitive 209 3 39 result>.

      " lower32Bits is really the Remainder: "
      lower32Bits <- <primitive 209 3 38 result>.
      
      ^ result
|
   signed64BitMultiply: arg1 times: arg2 ! result !

      " arg1 & arg2 are NOT necessarily 64-bit Integers: "

      result      <- <primitive 209 3 23 arg1 arg2>.

      upper32Bits <- <primitive 209 3 39 result>.

      lower32Bits <- <primitive 209 3 38 result>.
      
      ^ result
|
   unsigned64BitMultiply: arg1 times: arg2 ! result !

      " arg1 & arg2 are NOT necessarily 64-bit Integers: "

      result      <- <primitive 209 3 24 arg1 arg2>.

      upper32Bits <- <primitive 209 3 39 result>.

      lower32Bits <- <primitive 209 3 38 result>.
      
      ^ result
|
   quotientIs

      ^ upper32Bits
|
   remainderIs

      ^ lower32Bits
]
