pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " next " \
  #( #[ 16r10 16rA7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " first " \
  #( #[ 16r10 16rA6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " occurrencesOf: " \
  #( #[ 16r10 16r21 16r0B 16r1F 16rF7 16r03 16r51 16rF8 16r02 16rF2 16r50 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " size " \
  #( #[ 16r10 16rA3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " remove:ifAbsent: " \
  #( #[ 16r10 16r21 16r22 16rD8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " add: " \
  #( #[ 16r10 16r21 16r0B 16r1F 16rF6 16r03 16r10 16r21 16rBE 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 7  " new " \
  #( #[ 16r05 16r30 16rA0 16r60 16rF5] \
    #(  )) >

<primitive 98 #Set \
  <primitive 97 #Set #Collection #AmigaTalk:General/Set.st \
   #(  #list ) \
   #( #next #first #occurrencesOf: #size #remove:ifAbsent: #add: #new  ) \
  pTempVar 3 4 > #ordinary >

