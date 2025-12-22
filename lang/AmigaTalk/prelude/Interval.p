pTempVar <- <primitive 110 18 >
<primitive 112 pTempVar 1  " shallowCopy " \
  #( #[ 16r10 16r11 16r12 16rD4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " deepCopy " \
  #( #[ 16r10 16r11 16r12 16rD4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " removeKey:ifAbsent: " \
  #( #[ 16r20 16r30 16rBD 16rF2 16r22 16rA5 16rF3 16rF5] \
    #( 'cannot remove from Interval'  )) >

<primitive 112 pTempVar 4  " add: " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'cannot store into Interval'  )) >

<primitive 112 pTempVar 5  " at:put: " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'cannot store into Interval'  )) >

<primitive 112 pTempVar 6  " coerce: " \
  #( #[ 16r21 16rAF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " printString " \
  #( #[ 16r30 16r10 16rA9 16r0B 16r12 16r31 16r0B 16r12 16r11 16rA9 16r0B \
        16r12 16r32 16r0B 16r12 16r12 16rA9 16r0B 16r12 16rF3 16rF5 \
       ] \
    #( 'Interval ' ' to ' ' by '  )) >

<primitive 112 pTempVar 8  " at:ifAbsent: " \
  #( #[ 16r10 16r12 16r21 16r51 16rC1 16rC2 16rC0 16r73 16r20 16r23 16r0B \
        16r20 16rF7 16r03 16r23 16rF8 16r03 16rF2 16r22 16rA5 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " next " \
  #( #[ 16r13 16r12 16rC0 16r63 16r20 16r13 16r0B 16r20 16rF7 16r01 16r13 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " last " \
  #( #[ 16r11 16r63 16r20 16r13 16r0B 16r20 16rF7 16r01 16r13 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 11  " first " \
  #( #[ 16r10 16r63 16r20 16r13 16r0B 16r20 16rF7 16r01 16r13 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 12  " inRange: " \
  #( #[ 16r12 16r50 16rCC 16rF7 16r0B 16r21 16r10 16rCB 16rFC 16r03 16r21 \
        16r11 16rC8 16rF3 16rF8 16r0A 16rF2 16r21 16r11 16rCB 16rFC \
        16r03 16r21 16r10 16rC8 16rF3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " size " \
  #( #[ 16r12 16rAA 16rF7 16r05 16r11 16r10 16rC7 16rF8 16r04 16rF2 16r10 \
        16r11 16rC7 16rF7 16r03 16r50 16rF8 16r09 16rF2 16r11 16r10 \
        16rC1 16r12 16r0B 16r13 16r51 16rC0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " stepSize " \
  #( #[ 16r12 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " upperBound " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " lowerBound " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " from:to: " \
  #( #[ 16r21 16rF1 16r60 16r63 16r22 16r61 16r51 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " from:to:by: " \
  #( #[ 16r21 16rF1 16r60 16r63 16r22 16r61 16r23 16r62 16rF5] \
    #(  )) >

<primitive 98 #Interval \
  <primitive 97 #Interval #SequenceableCollection #AmigaTalk:General/Interval.st \
   #(  #lower #upper #step #current ) \
   #( #shallowCopy #deepCopy #removeKey:ifAbsent: #add: #at:put: #coerce:  \
       #printString #at:ifAbsent: #next #last #first #inRange: #size #stepSize #upperBound  \
       #lowerBound #from:to: #from:to:by:  ) \
  pTempVar 4 5 > #ordinary >

