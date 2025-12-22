pTempVar <- <primitive 110 21 >
<primitive 112 pTempVar 1  " >= " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r10 \
        16r22 16r80 16r01 16rCB 16rF7 16r04 16r5B 16rF3 16rF8 16r03 \
        16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #fraction  )) >

<primitive 112 pTempVar 2  " <= " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r10 \
        16r22 16r80 16r01 16rC8 16rF7 16r04 16r5B 16rF3 16rF8 16r03 \
        16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #fraction  )) >

<primitive 112 pTempVar 3  " > " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r10 \
        16r22 16r80 16r01 16rCC 16rF7 16r04 16r5B 16rF3 16rF8 16r03 \
        16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #fraction  )) >

<primitive 112 pTempVar 4  " < " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r10 \
        16r22 16r80 16r01 16rC7 16rF7 16r04 16r5B 16rF3 16rF8 16r03 \
        16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #fraction  )) >

<primitive 112 pTempVar 5  " ~= " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r11 \
        16r22 16r80 16r01 16rCA 16r12 16r22 16r80 16r02 16rCA 16r81 \
        16r03 16rF7 16r04 16r5B 16rF3 16rF8 16r03 16rF2 16r5C 16rF3 \
        16rF2 16rF5] \
    #( #isKindOf: #numerator #denominator #&  )) >

<primitive 112 pTempVar 6  " == " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r11 \
        16r22 16r80 16r01 16rB6 16r12 16r22 16r80 16r02 16rB6 16r81 \
        16r03 16rF7 16r04 16r5B 16rF3 16rF8 16r03 16rF2 16r5C 16rF3 \
        16rF2 16rF5] \
    #( #isKindOf: #numerator #denominator #&  )) >

<primitive 112 pTempVar 7  " printString " \
  #( #[ 16r11 16rFA 16r01 16r4E 16r30 16r0B 16r12 16r12 16rFA 16r01 16r4E \
        16r0B 16r12 16rA8 16rF2 16rF5] \
    #( ' / '  )) >

<primitive 112 pTempVar 8  " / " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r22 16r80 16r01 16rC2 16rF3 16rF5] \
    #( #isKindOf: #reciprocal  )) >

<primitive 112 pTempVar 9  " * " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r11 \
        16r22 16r80 16r01 16rC2 16r61 16r12 16r22 16r80 16r02 16rC2 \
        16r62 16r11 16r12 16rBF 16rF1 16r60 16rF3 16rF5] \
    #( #isKindOf: #numerator #denominator  )) >

<primitive 112 pTempVar 10  " - " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r74 16rF8 16r04 16rF2 16r21 16rF1 16r74 16rF2 16r12 \
        16r24 16r80 16r01 16rC2 16r73 16r11 16r24 16r80 16r01 16rC2 \
        16r72 16r21 16r12 16r24 16r80 16r02 16rC2 16r81 16r03 16rF2 \
        16r22 16r24 16r80 16r02 16rC1 16r61 16r23 16r62 16r11 16r12 \
        16rBF 16rF1 16r60 16rF3 16rF5] \
    #( #isKindOf: #denominator #numerator #numerator:  )) >

<primitive 112 pTempVar 11  " + " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r74 16rF8 16r04 16rF2 16r21 16rF1 16r74 16rF2 16r12 \
        16r24 16r80 16r01 16rC2 16r73 16r11 16r24 16r80 16r01 16rC2 \
        16r72 16r24 16r12 16r24 16r80 16r02 16rC2 16r81 16r03 16rF2 \
        16r22 16r24 16r80 16r02 16rC0 16r61 16r23 16r62 16r11 16r12 \
        16rBF 16rF1 16r60 16rF3 16rF5] \
    #( #isKindOf: #denominator #numerator #numerator:  )) >

<primitive 112 pTempVar 12  " reciprocal " \
  #( #[ 16r11 16r30 16rB6 16rF7 16r07 16r31 16rFA 16r01 16r7B 16rF2 16r5D \
        16rF3 16rF2 16r11 16r71 16r12 16r61 16r21 16r62 16r11 16r12 \
        16rBF 16rF1 16r60 16rF3 16rF5] \
    #( 0.0 'Reciprocal: Improper fraction (x / 0.0)!'  )) >

<primitive 112 pTempVar 13  " fraction: " \
  #( #[ 16r21 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " denominator: " \
  #( #[ 16r21 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " numerator: " \
  #( #[ 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " coerce: " \
  #( #[ 16r40 16rA0 16r72 16r22 16r21 16r81 16r01 16rF2 16r22 16r32 16r81 \
        16r03 16rF2 16r22 16r21 16r81 16r04 16rF2 16r22 16rF3 16rF5 \
       ] \
    #( #Fraction #numerator: 1.0 #denominator: #fraction:  )) >

<primitive 112 pTempVar 17  " asFloat " \
  #( #[ 16r12 16r30 16rB6 16rF7 16r07 16r31 16rFA 16r01 16r7B 16rF2 16r5D \
        16rF3 16rF2 16r11 16r12 16rBF 16rF1 16r60 16rF3 16rF5] \
    #( 0.0 'Improper fraction (x / 0.0)!'  )) >

<primitive 112 pTempVar 18  " fraction " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " denominator " \
  #( #[ 16r12 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " numerator " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " new " \
  #( #[ 16r05 16r2B 16r30 16rB0 16r61 16r05 16r2B 16r31 16rB0 16r62 16r05 \
        16r2B 16r32 16rB0 16r60 16rF5] \
    #( 0.0 1.0 0.0  )) >

<primitive 98 #Fraction \
  <primitive 97 #Fraction #Magnitude #User/fraction.st \
   #(  #ratio #n #d ) \
   #( #>= #<= #> #< #~= #== #printString #/ #* #- #+ #reciprocal #fraction:  \
       #denominator: #numerator: #coerce: #asFloat #fraction #denominator #numerator #new  ) \
  pTempVar 5 8 > #ordinary >

