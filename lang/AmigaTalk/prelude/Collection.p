pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " size " \
  #( #[ 16r5E 16r80 16r00 16rF2 16r50 16r71 16r20 16rE1 16r02 16r06 16r21 \
        16r51 16rC0 16rF1 16r71 16rF3 16rB3 16rF2 16r5E 16r80 16r01 \
        16rF2 16r21 16rF3 16rF5] \
    #( #tracingOff #tracingOn  )) >

<primitive 112 pTempVar 2  " shallowCopy " \
  #( #[ 16r05 16r30 16rA0 16r71 16r20 16rE1 16r02 16r05 16r21 16r22 16r0B \
        16r17 16rF3 16rB3 16rF2 16r20 16r21 16r0B 16r10 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 3  " select: " \
  #( #[ 16r20 16r20 16rA4 16rA0 16rE2 16r02 16r0B 16r21 16r23 16rB5 16rF7 \
        16r03 16r22 16r23 16rBE 16rF2 16r22 16rF3 16rD7 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 4  " remove:ifAbsent: " \
  #( #[ 16r20 16r21 16r0B 16r1F 16rF7 16r06 16r20 16r21 16r0B 16r28 16rF8 \
        16r03 16rF2 16r22 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " remove: " \
  #( #[ 16r20 16r21 16rE0 16r04 16r20 16r30 16rBD 16rF4 16rD8 16rF2 16r21 \
        16rF3 16rF5] \
    #( 'attempt to remove object not found in collection'  )) >

<primitive 112 pTempVar 6  " reject: " \
  #( #[ 16r20 16rE1 16r02 16r05 16r21 16r22 16rB5 16rAC 16rF3 16r0B 16r2D \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " printString " \
  #( #[ 16r20 16r20 16rA4 16rA9 16r30 16r0B 16r12 16rE2 16r01 16r09 16r21 \
        16r31 16r0B 16r12 16r22 16rA9 16r0B 16r12 16rF3 16rD7 16r32 \
        16r0B 16r12 16rF3 16rF5] \
    #( ' (' ' ' ' )'  )) >

<primitive 112 pTempVar 8  " occurrencesOf: " \
  #( #[ 16r20 16r50 16rE2 16r02 16r0D 16r23 16r21 16rC9 16rF7 16r05 16r22 \
        16r51 16rC0 16rF8 16r02 16rF2 16r22 16rF3 16rD7 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 9  " isEmpty " \
  #( #[ 16r20 16rA3 16r50 16rC9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " inject:into: " \
  #( #[ 16r21 16r73 16r20 16rE1 16r04 16r07 16r22 16r23 16r24 16rD3 16rF1 \
        16r73 16rF3 16rB3 16rF2 16r23 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " includes: " \
  #( #[ 16r20 16rE1 16r02 16r08 16r22 16r21 16rC9 16rF7 16r02 16r5B 16rF4 \
        16rF3 16rB3 16rF2 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " first " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'subclass should implement first'  )) >

<primitive 112 pTempVar 13  " detect:ifAbsent: " \
  #( #[ 16r20 16rE1 16r03 16r08 16r21 16r23 16rB5 16rF7 16r02 16r23 16rF4 \
        16rF3 16rB3 16rF2 16r22 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " detect: " \
  #( #[ 16r20 16r21 16rE0 16r04 16r20 16r30 16rBD 16rF3 16rDF 16rF3 16rF5 \
       ] \
    #( 'no object found matching detect'  )) >

<primitive 112 pTempVar 15  " deepCopy " \
  #( #[ 16r05 16r30 16rA0 16r71 16r20 16rE1 16r02 16r07 16r21 16r22 16r0A \
        16r15 16r0B 16r17 16rF3 16rB3 16rF2 16r20 16r21 16r0B 16r10 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " collect: " \
  #( #[ 16r20 16r20 16rA4 16rA0 16rE2 16r02 16r08 16r22 16r21 16r23 16rB5 \
        16rBE 16rF2 16r22 16rF3 16rD7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " coerce: " \
  #( #[ 16r20 16rA0 16r72 16r21 16rE1 16r03 16r04 16r22 16r23 16rBE 16rF3 \
        16rB3 16rF2 16r22 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " asString " \
  #( #[ 16r20 16rA3 16r71 16r05 16r3A 16r21 16rB0 16rF1 16r51 16r21 16r20 \
        16r83 16r00 16rF2 16rF3 16rF5] \
    #( #replaceFrom:to:with:  )) >

<primitive 112 pTempVar 19  " asList " \
  #( #[ 16r05 16r30 16rA0 16r20 16r0B 16r15 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " asSet " \
  #( #[ 16r05 16r39 16rA0 16r20 16r0B 16r14 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " asBag " \
  #( #[ 16r05 16r20 16rA0 16r20 16r0B 16r14 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " asArray " \
  #( #[ 16r20 16rA3 16r71 16r05 16r1E 16r21 16rB0 16rF1 16r51 16r21 16r20 \
        16r83 16r00 16rF2 16rF3 16rF5] \
    #( #replaceFrom:to:with:  )) >

<primitive 112 pTempVar 23  " addAll: " \
  #( #[ 16r21 16rE1 16r02 16r04 16r20 16r22 16rBE 16rF3 16rB3 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 98 #Collection \
  <primitive 97 #Collection #Object #AmigaTalk:General/Collection.st \
   #(  ) \
   #( #size #shallowCopy #select: #remove:ifAbsent: #remove: #reject:  \
       #printString #occurrencesOf: #isEmpty #inject:into: #includes: #first  \
       #detect:ifAbsent: #detect: #deepCopy #collect: #coerce: #asString #asList #asSet #asBag  \
       #asArray #addAll:  ) \
  pTempVar 5 7 > #ordinary >

