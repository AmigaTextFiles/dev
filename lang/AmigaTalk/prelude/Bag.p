pTempVar <- <primitive 110 8 >
<primitive 112 pTempVar 1  " next " \
  #( #[ 16r11 16rA2 16rF7 16r1B 16r11 16r50 16rCC 16rF7 16r09 16r11 16r51 \
        16rC1 16r61 16r10 16rAB 16rF3 16rF8 16r0A 16rF2 16r10 16rA7 \
        16rF1 16r61 16rA1 16rF7 16r02 16r5D 16rF3 16rF2 16rF9 16r1F \
        16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " first " \
  #( #[ 16r10 16rA6 16rF1 16r61 16rA1 16rF7 16r02 16r5D 16rF3 16rF2 16r11 \
        16r51 16rC1 16r61 16r10 16rAB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " occurrencesOf: " \
  #( #[ 16r10 16r21 16rE0 16r02 16r50 16rF3 16rD5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " size " \
  #( #[ 16r10 16r50 16rE2 16r01 16r04 16r21 16r22 16rC0 16rF3 16rD7 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " remove:ifAbsent: " \
  #( #[ 16r10 16r21 16rE0 16r03 16r22 16rA5 16rF4 16rD5 16r73 16r51 16r23 \
        16rC9 16rF7 16r06 16r10 16r21 16r0B 16r29 16rF8 16r07 16rF2 \
        16r10 16r21 16r23 16r51 16rC1 16rD0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " add:withOccurrences: " \
  #( #[ 16r22 16rE0 16r04 16r20 16r21 16rBE 16rF3 16rB8 16rF2 16r21 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " add: " \
  #( #[ 16r10 16r21 16r51 16r10 16r21 16rE0 16r02 16r50 16rF3 16rD5 16rC0 \
        16rD0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " new " \
  #( #[ 16r05 16r28 16rA0 16r60 16rF5] \
    #(  )) >

<primitive 98 #Bag \
  <primitive 97 #Bag #Collection #AmigaTalk:General/Bag.st \
   #(  #dict #count ) \
   #( #next #first #occurrencesOf: #size #remove:ifAbsent:  \
       #add:withOccurrences: #add: #new  ) \
  pTempVar 4 8 > #ordinary >

