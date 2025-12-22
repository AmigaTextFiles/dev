pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " next: " \
  #( #[ 16r05 16r1E 16r21 16rB0 16r72 16r51 16r21 16rB2 16rE1 16r03 16r06 \
        16r22 16r23 16r20 16rA7 16rD0 16rF3 16rB3 16rF2 16r22 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " randInteger: " \
  #( #[ 16r20 16rA7 16r21 16rC2 16r0A 16r2F 16r51 16rC0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " between:and: " \
  #( #[ 16r20 16rA7 16r22 16r21 16rC1 16rC2 16r21 16rC0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " next " \
  #( #[ 16r10 16rFA 16r01 16r23 16rF1 16r60 16rFA 16r01 16r20 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 5  " first " \
  #( #[ 16r10 16rFA 16r01 16r23 16rF1 16r60 16rFA 16r01 16r20 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 6  " randomize " \
  #( #[ 16rFA 16r00 16rA1 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " new " \
  #( #[ 16r51 16r60 16rF5] \
    #(  )) >

<primitive 98 #Random \
  <primitive 97 #Random #Object #AmigaTalk:General/Random.st \
   #(  #seed ) \
   #( #next: #randInteger: #between:and: #next #first #randomize #new  ) \
  pTempVar 4 6 > #ordinary >

