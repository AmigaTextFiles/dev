pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " numArgs " \
  #( #[ 16r50 16r20 16rFA 16r02 16r5A 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " asString " \
  #( #[ 16r20 16rFA 16r01 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " printString " \
  #( #[ 16r20 16rFA 16r01 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " == " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r07 16r20 16r21 16rFA 16r02 \
        16r5B 16rF8 16r02 16rF2 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Symbol \
  <primitive 97 #Symbol #Object #AmigaTalk:General/Symbol.st \
   #(  ) \
   #( #numArgs #asString #printString #==  ) \
  pTempVar 2 4 > #ordinary >

