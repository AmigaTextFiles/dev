pTempVar <- <primitive 110 8 >
<primitive 112 pTempVar 1  " hash " \
  #( #[ 16r10 16r80 16r00 16r13 16r80 16r00 16r81 16r01 16r11 16r80 16r00 \
        16r81 16r01 16rF3 16rF5] \
    #( #identityHash #bitXor:  )) >

<primitive 112 pTempVar 2  " = " \
  #( #[ 16r20 16rA4 16r21 16rA4 16rB6 16rFC 16r13 16r10 16r21 16r80 16r00 \
        16rB6 16rFC 16r0C 16r13 16r21 16r80 16r01 16rB6 16rFC 16r05 \
        16r11 16r21 16r80 16r02 16rB6 16rF3 16rF5] \
    #( #receiver #aspect #selector  )) >

<primitive 112 pTempVar 3  " update:with:from: " \
  #( #[ 16r13 16r21 16rB6 16rF6 16r02 16r20 16rF3 16rF2 16r12 16r50 16rB6 \
        16rF7 16r05 16r10 16r11 16r81 16r00 16rF3 16rF2 16r12 16r51 \
        16rB6 16rF7 16r06 16r10 16r11 16r22 16r82 16r01 16rF3 16rF2 \
        16r12 16r52 16rB6 16rF7 16r07 16r10 16r11 16r22 16r23 16r83 \
        16r02 16rF3 16rF2 16rF5] \
    #( #perform: #perform:with: #perform:with:with:  )) >

<primitive 112 pTempVar 4  " matches:forAspect: " \
  #( #[ 16r10 16r21 16rB6 16rFC 16r03 16r13 16r22 16rB6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " selector " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " receiver " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " aspect " \
  #( #[ 16r13 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setReceiver:aspect:selector: " \
  #( #[ 16r21 16r60 16r22 16r63 16r23 16r61 16r11 16r80 16r00 16r62 16r12 \
        16r52 16rCC 16rF7 16r03 16r20 16r31 16rBD 16rF2 16rF5] \
    #( #numArgs 'selector expects too many arguments'  )) >

<primitive 98 #DependencyTransformer \
  <primitive 97 #DependencyTransformer #Object #AmigaTalk:General/DependencyTransformer.st \
   #(  #receiver #selector #numArguments #aspect ) \
   #( #hash #= #update:with:from: #matches:forAspect: #selector #receiver  \
       #aspect #setReceiver:aspect:selector:  ) \
  pTempVar 4 8 > #ordinary >

