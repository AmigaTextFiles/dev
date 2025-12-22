pTempVar <- <primitive 110 6 >
<primitive 112 pTempVar 1  " xor: " \
  #( #[ 16r20 16r21 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " eqv: " \
  #( #[ 16r20 16r21 16rB6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " or: " \
  #( #[ 16r20 16rFB 16r02 16r21 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " and: " \
  #( #[ 16r20 16rFC 16r02 16r21 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " | " \
  #( #[ 16r20 16rFB 16r01 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " & " \
  #( #[ 16r20 16rFC 16r01 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Boolean \
  <primitive 97 #Boolean #Object #AmigaTalk:General/Boolean.st \
   #(  ) \
   #( #xor: #eqv: #or: #and: #| #&  ) \
  pTempVar 2 3 > #ordinary >

