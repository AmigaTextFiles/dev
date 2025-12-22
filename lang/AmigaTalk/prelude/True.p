pTempVar <- <primitive 110 5 >
<primitive 112 pTempVar 1  " not " \
  #( #[ 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " ifFalse: " \
  #( #[ 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " ifTrue: " \
  #( #[ 16r21 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " ifFalse:ifTrue: " \
  #( #[ 16r22 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " ifTrue:ifFalse: " \
  #( #[ 16r21 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 98 #True \
  <primitive 97 #True #Boolean #AmigaTalk:General/True.st \
   #(  ) \
   #( #not #ifFalse: #ifTrue: #ifFalse:ifTrue: #ifTrue:ifFalse:  ) \
  pTempVar 3 2 > #ordinary >

