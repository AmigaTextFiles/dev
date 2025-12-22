pTempVar <- <primitive 110 12 >
<primitive 112 pTempVar 1  " checkBucket: " \
  #( #[ 16r10 16r21 16rF1 16r61 16rB1 16rF1 16r62 16rA1 16rF7 16r02 16r5D \
        16rF3 16rF2 16r12 16rA6 16rF3] \
    #(  )) >

<primitive 112 pTempVar 2  " currentKey " \
  #( #[ 16r12 16rA2 16rF7 16r0B 16r12 16r0A 16r16 16r71 16r21 16rA2 16rF7 \
        16r03 16r21 16r0A 16r31 16rF3] \
    #(  )) >

<primitive 112 pTempVar 3  " printString " \
  #( #[ 16r20 16r20 16rA4 16rA9 16r30 16r0B 16r12 16rE2 16r01 16r11 16r21 \
        16r20 16rAB 16rA9 16r0B 16r12 16r31 16r0B 16r12 16r22 16rA9 \
        16r0B 16r12 16r32 16r0B 16r12 16rF3 16rD7 16r33 16r0B 16r12 \
        16rF3] \
    #( ' ( ' ' @ ' ' ' ')'  )) >

<primitive 112 pTempVar 4  " next " \
  #( #[ 16r5E 16r80 16r00 16rF2 16r12 16rA7 16rF1 16r71 16rA2 16rF7 16r04 \
        16r21 16r0A 16r32 16rF3 16rF2 16r11 16r05 16r11 16rC7 16rF7 \
        16r14 16r11 16r51 16rC0 16r61 16r20 16r11 16r0B 16r19 16rF1 \
        16r71 16rA2 16rF7 16r04 16r21 16r0A 16r32 16rF3 16rF2 16rF9 \
        16r1A 16rF2 16r5D 16rF3] \
    #( #tracingOff  )) >

<primitive 112 pTempVar 5  " first " \
  #( #[ 16r51 16r05 16r11 16rB2 16rE1 16r02 16r0E 16r20 16r22 16r0B 16r19 \
        16rF1 16r71 16rA2 16rF7 16r04 16r21 16r0A 16r32 16rF4 16rF3 \
        16rB3 16rF2 16r5D 16rF3] \
    #(  )) >

<primitive 112 pTempVar 6  " findAssociation:inList: " \
  #( #[ 16r5E 16r80 16r00 16rF2 16r22 16rE1 16r03 16r0A 16r23 16r0A 16r31 \
        16r21 16rC9 16rF7 16r02 16r23 16rF4 16rF3 16rB3 16rF2 16r5D \
        16rF3] \
    #( #tracingOff  )) >

<primitive 112 pTempVar 7  " removeKey:ifAbsent: " \
  #( #[ 16r20 16r21 16r0B 16r1D 16r73 16r20 16r21 16r23 16rDE 16r74 16r24 \
        16rA1 16rF7 16r03 16r22 16rA5 16rF3 16rF2 16r23 16r24 16rE0 \
        16r03 16r22 16rA5 16rF4 16rD8 16r0A 16r32 16rF3] \
    #(  )) >

<primitive 112 pTempVar 8  " at:ifAbsent: " \
  #( #[ 16r5E 16r80 16r00 16rF2 16r20 16r21 16r0B 16r1D 16r73 16r20 16r21 \
        16r23 16rDE 16r74 16r24 16rA1 16rF7 16r03 16r22 16rA5 16rF3 \
        16rF2 16r5E 16r80 16r01 16rF2 16r24 16r0A 16r32 16rF3] \
    #( #tracingOff #tracingOn  )) >

<primitive 112 pTempVar 9  " at:put: " \
  #( #[ 16r5E 16r80 16r00 16rF2 16r20 16r21 16r0B 16r1D 16r73 16r20 16r21 \
        16r23 16rDE 16r74 16r24 16rA1 16rF7 16r0F 16r05 16r35 16rA0 \
        16r21 16r0B 16r33 16r22 16r0B 16r34 16r74 16r23 16r24 16rBE \
        16rF8 16r05 16rF2 16r24 16r22 16r0B 16r34 16rF2 16r5E 16r80 \
        16r01 16rF2 16r22 16rF3] \
    #( #tracingOff #tracingOn  )) >

<primitive 112 pTempVar 10  " getList: " \
  #( #[ 16r20 16r21 16r0B 16r1E 16r73 16r10 16r23 16rB1 16r72 16r22 16rA1 \
        16rF7 16r08 16r05 16r30 16rA0 16r72 16r10 16r23 16r22 16rD0 \
        16rF2 16r22 16rF3] \
    #(  )) >

<primitive 112 pTempVar 11  " hashNumber: " \
  #( #[ 16r21 16rFA 16r01 16r05 16r10 16rA3 16rC3 16r51 16rC0 16rF3] \
    #(  )) >

<primitive 112 pTempVar 12  " new " \
  #( #[ 16r05 16r1E 16r05 16r11 16rB0 16r60 16rF5] \
    #(  )) >

<primitive 98 #Dictionary \
  <primitive 97 #Dictionary #KeyedCollection #AmigaTalk:General/Dictionary.st \
   #(  #hashTable #currentBucket #currentList ) \
   #( #checkBucket: #currentKey #printString #next #first  \
       #findAssociation:inList: #removeKey:ifAbsent: #at:ifAbsent: #at:put: #getList: #hashNumber:  \
       #new  ) \
  pTempVar 5 6 > #ordinary >

