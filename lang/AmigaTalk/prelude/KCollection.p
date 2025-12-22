pTempVar <- <primitive 110 18 >
<primitive 112 pTempVar 1  " values " \
  #( #[ 16r05 16r20 16rA0 16r71 16r20 16rE1 16r02 16r04 16r21 16r22 16rBE \
        16rF3 16rB3 16rF2 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " select: " \
  #( #[ 16r20 16r20 16r05 16r28 16rE2 16r02 16r0D 16r21 16r23 16rB5 16rF7 \
        16r05 16r22 16r20 16rAB 16r23 16rD0 16rF2 16r22 16rF3 16rD7 \
        16r0B 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " removeKey:ifAbsent: " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'subclass should implement RemoveKey:ifAbsent:'  )) >

<primitive 112 pTempVar 4  " removeKey: " \
  #( #[ 16r20 16r21 16rE0 16r06 16r20 16r30 16rBD 16rF2 16r21 16rF4 16rD9 \
        16rF3 16rF5] \
    #( 'no element associated with key'  )) >

<primitive 112 pTempVar 5  " remove: " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'object must be removed with explicit key'  )) >

<primitive 112 pTempVar 6  " keysSelect: " \
  #( #[ 16r20 16r20 16r05 16r28 16rA0 16rE2 16r02 16r0E 16r21 16r23 16rAB \
        16rB5 16rF7 16r05 16r22 16r20 16rAB 16r23 16rD0 16rF2 16r22 \
        16rF3 16rD7 16r0B 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " keysDo: " \
  #( #[ 16r20 16rE1 16r02 16r05 16r21 16r20 16rAB 16rB5 16rF3 16rB3 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " keys " \
  #( #[ 16r05 16r39 16rA0 16r71 16r20 16rE1 16r02 16r04 16r21 16r22 16rBE \
        16rF3 16r0B 16r21 16rF2 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " indexOf:ifAbsent: " \
  #( #[ 16r20 16rE1 16r03 16r09 16r23 16r21 16rC9 16rF7 16r03 16r20 16rAB \
        16rF4 16rF3 16rB3 16rF2 16r22 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " indexOf: " \
  #( #[ 16r20 16r21 16rE0 16r04 16r20 16r30 16rBD 16rF3 16rD6 16rF3 16rF5 \
       ] \
    #( 'indexOf element not found'  )) >

<primitive 112 pTempVar 11  " includesKey: " \
  #( #[ 16r20 16r21 16rE0 16r02 16r5C 16rF4 16rD5 16rF2 16r5B 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 12  " collect: " \
  #( #[ 16r20 16r20 16r05 16r28 16rA0 16rE2 16r02 16r0A 16r22 16r20 16rAB \
        16r21 16r23 16rB5 16rD0 16rF2 16r22 16rF3 16rD7 16r0B 16r10 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " binaryDo: " \
  #( #[ 16r20 16rE1 16r03 16r06 16r21 16r20 16rAB 16r23 16rD3 16rF3 16rB3 \
        16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " atAll:put: " \
  #( #[ 16r21 16rE1 16r03 16r05 16r20 16r23 16r22 16rD0 16rF3 16rB3 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " at: " \
  #( #[ 16r20 16r21 16rE0 16r0A 16r20 16r21 16rA9 16r30 16r0B 16r12 16rBD \
        16rF2 16r21 16rF4 16rD5 16rF3 16rF5] \
    #( ': association not found'  )) >

<primitive 112 pTempVar 16  " asDictionary " \
  #( #[ 16r05 16r28 16rA0 16r71 16r20 16rE2 16r02 16r05 16r21 16r22 16r23 \
        16rD0 16rF3 16r0B 16r18 16rF2 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " addAll: " \
  #( #[ 16r21 16rE2 16r02 16r05 16r20 16r22 16r23 16rD0 16rF3 16r0B 16r18 \
        16rF2 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " add: " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'Must add with explicit key'  )) >

<primitive 98 #KeyedCollection \
  <primitive 97 #KeyedCollection #Collection #AmigaTalk:General/KeyedCollection.st \
   #(  ) \
   #( #values #select: #removeKey:ifAbsent: #removeKey: #remove:  \
       #keysSelect: #keysDo: #keys #indexOf:ifAbsent: #indexOf: #includesKey: #collect:  \
       #binaryDo: #atAll:put: #at: #asDictionary #addAll: #add:  ) \
  pTempVar 4 9 > #ordinary >

