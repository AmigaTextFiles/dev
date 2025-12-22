pTempVar <- <primitive 110 18 >
<primitive 112 pTempVar 1  " printString " \
  #( #[ 16r30 16r20 16rFA 16r01 16r3A 16r0B 16r12 16rF3 16rF5] \
    #( '$'  )) >

<primitive 112 pTempVar 2  " isVowel " \
  #( #[ 16r20 16rFA 16r01 16r33 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " isUppercase " \
  #( #[ 16r20 16r30 16r31 16r82 16r02 16rF3 16rF5] \
    #( $A $Z #between:and:  )) >

<primitive 112 pTempVar 4  " isSeparator " \
  #( #[ 16r20 16rFA 16r01 16r37 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " isLowercase " \
  #( #[ 16r20 16r30 16r31 16r82 16r02 16rF3 16rF5] \
    #( $a $z #between:and:  )) >

<primitive 112 pTempVar 6  " isLetter " \
  #( #[ 16r20 16r80 16r00 16rFB 16r03 16r20 16r80 16r01 16rF3 16rF5] \
    #( #isLowercase #isUppercase  )) >

<primitive 112 pTempVar 7  " isDigit " \
  #( #[ 16r20 16r30 16r31 16r82 16r02 16rF3 16rF5] \
    #( $0 $9 #between:and:  )) >

<primitive 112 pTempVar 8  " isAlphaNumeric " \
  #( #[ 16r20 16rFA 16r01 16r38 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " digitValue " \
  #( #[ 16r20 16rFA 16r01 16r32 16rF1 16r71 16rA1 16rF7 16r03 16r20 16r30 \
        16rBD 16rF2 16r21 16rF3 16rF5] \
    #( 'digitValue on nondigit char'  )) >

<primitive 112 pTempVar 10  " compareError " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'char cannot be compared to non char'  )) >

<primitive 112 pTempVar 11  " asString " \
  #( #[ 16r20 16rFA 16r01 16r3A 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " asUppercase " \
  #( #[ 16r20 16rFA 16r01 16r35 16rF7 16r06 16r20 16rFA 16r01 16r39 16rF8 \
        16r02 16rF2 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " asLowercase " \
  #( #[ 16r20 16rFA 16r01 16r36 16rF7 16r06 16r20 16rFA 16r01 16r39 16rF8 \
        16r02 16rF2 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " asciiValue " \
  #( #[ 16r20 16rFA 16r01 16r3B 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " > " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r07 16r20 16r21 16rFA 16r02 \
        16r2B 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " = " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r07 16r20 16r21 16rFA 16r02 \
        16r2E 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " < " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r07 16r20 16r21 16rFA 16r02 \
        16r2A 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " == " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r07 16r20 16r21 16rFA 16r02 \
        16r2E 16rF8 16r02 16rF2 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Char \
  <primitive 97 #Char #Magnitude #AmigaTalk:General/Char.st \
   #(  ) \
   #( #printString #isVowel #isUppercase #isSeparator #isLowercase #isLetter  \
       #isDigit #isAlphaNumeric #digitValue #compareError #asString #asUppercase  \
       #asLowercase #asciiValue #> #= #< #==  ) \
  pTempVar 2 4 > #ordinary >

