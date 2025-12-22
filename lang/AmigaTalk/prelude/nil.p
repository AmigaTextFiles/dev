pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " printString " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 'nil'  )) >

<primitive 112 pTempVar 2  " ifNil: " \
  #( #[ 16r21 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " notNil " \
  #( #[ 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " isNil " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #UndefinedObject \
  <primitive 97 #UndefinedObject #Object #AmigaTalk:General/UndefinedObject.st \
   #(  ) \
   #( #printString #ifNil: #notNil #isNil  ) \
  pTempVar 2 2 > #ordinary >

