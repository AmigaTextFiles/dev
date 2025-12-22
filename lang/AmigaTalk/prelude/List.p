pTempVar <- <primitive 110 17 >
<primitive 112 pTempVar 1  " isEmpty " \
  #( #[ 16r10 16r5D 16rB6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " last " \
  #( #[ 16r10 16rA1 16rF7 16r02 16r5D 16rF3 16rF2 16r20 16r0A 16r19 16r0A \
        16r31 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " current " \
  #( #[ 16r11 16r0A 16r31 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " next " \
  #( #[ 16r11 16r0A 16r32 16rF1 16r61 16rA2 16rF7 16r03 16r11 16r0A 16r31 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " first " \
  #( #[ 16r10 16rF1 16r61 16rA2 16rF7 16r03 16r11 16r0A 16r31 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 6  " removeLast " \
  #( #[ 16r10 16rA1 16rF7 16r04 16r20 16r0A 16r25 16rF3 16rF2 16r20 16r20 \
        16r0A 16r1F 16rE0 16r04 16r20 16r0A 16r25 16rF3 16rD8 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " removeFirst " \
  #( #[ 16r10 16rA1 16rF7 16r04 16r20 16r0A 16r25 16rF3 16rF2 16r10 16r71 \
        16r10 16r0A 16r32 16r60 16r21 16r0A 16r31 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " removeError " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'cannot remove from an empty list'  )) >

<primitive 112 pTempVar 9  " remove:ifAbsent: " \
  #( #[ 16r10 16rA1 16rF7 16r03 16r22 16rA5 16rF3 16rF2 16r20 16r5D 16rE2 \
        16r03 16r1F 16r11 16r0A 16r31 16r21 16rB6 16rF7 16r15 16r23 \
        16rA1 16rF7 16r07 16r11 16r0A 16r32 16rF1 16r60 16rF8 16r07 \
        16rF2 16r23 16r11 16r0A 16r32 16r0B 16r34 16rF2 16r21 16rF4 \
        16rF2 16r11 16rF3 16rD7 16rF2 16r22 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " remove: " \
  #( #[ 16r20 16r21 16rE0 16r04 16r20 16r30 16rBD 16rF3 16rD8 16rF3 16rF5 \
       ] \
    #( 'cant find item'  )) >

<primitive 112 pTempVar 11  " findLast " \
  #( #[ 16r10 16rF1 16r71 16rA1 16rF7 16r02 16r5D 16rF3 16rF2 16r21 16r0A \
        16r32 16rA2 16rF7 16r08 16r21 16r0A 16r32 16rF1 16r71 16rF2 \
        16rF9 16r0E 16rF2 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " coerce: " \
  #( #[ 16r05 16r30 16rA0 16r72 16r21 16rE1 16r03 16r05 16r22 16r23 16r0B \
        16r17 16rF3 16rB3 16rF2 16r22 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " addAllLast: " \
  #( #[ 16r21 16rE1 16r02 16r05 16r20 16r22 16r0B 16r17 16rF3 16rB3 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " addAllFirst: " \
  #( #[ 16r21 16rE1 16r02 16r05 16r20 16r22 16r0B 16r16 16rF3 16rB3 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " addLast: " \
  #( #[ 16r10 16rA1 16rF7 16r05 16r20 16r21 16r0B 16r16 16rF3 16rF2 16r20 \
        16r0A 16r19 16r05 16r35 16rA0 16r21 16r0B 16r33 16r5D 16r0B \
        16r34 16r0B 16r34 16rF2 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " addFirst: " \
  #( #[ 16r05 16r35 16rA0 16r21 16r0B 16r33 16r10 16r0B 16r34 16r60 16r21 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " add: " \
  #( #[ 16r05 16r35 16rA0 16r21 16r0B 16r33 16r10 16r0B 16r34 16r60 16r21 \
        16rF3 16rF5] \
    #(  )) >

<primitive 98 #List \
  <primitive 97 #List #SequenceableCollection #AmigaTalk:General/List.st \
   #(  #first #current ) \
   #( #isEmpty #last #current #next #first #removeLast #removeFirst  \
       #removeError #remove:ifAbsent: #remove: #findLast #coerce: #addAllLast:  \
       #addAllFirst: #addLast: #addFirst: #add:  ) \
  pTempVar 5 8 > #ordinary >

