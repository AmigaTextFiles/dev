pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " setBlock:arguments: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF2 16r22 16r61 16r51 16r11 16rA3 16rE1 \
        16r03 16r07 16r11 16r23 16rB1 16r20 16r81 16r01 16rF3 16r82 \
        16r02 16rF2 16rF5] \
    #( #setBlock: #addDependent: #to:do:  )) >

<primitive 112 pTempVar 2  " setBlock: " \
  #( #[ 16r21 16r60 16r10 16r80 16r00 16r62 16r20 16r90 16r01 16rF2 16r32 \
        16r61 16rF5] \
    #( #numArgs #resetCache #( )  )) >

<primitive 112 pTempVar 3  " computeValue " \
  #( #[ 16r50 16r12 16rC9 16rF7 16r03 16r10 16rA5 16rF3 16rF2 16r51 16r12 \
        16rC9 16rF7 16r07 16r10 16r11 16r51 16rB1 16rA5 16rB5 16rF3 \
        16rF2 16r52 16r12 16rC9 16rF7 16r0B 16r10 16r11 16r51 16rB1 \
        16rA5 16r11 16r52 16rB1 16rA5 16rD3 16rF3 16rF2 16r53 16r12 \
        16rC9 16rF7 16r10 16r10 16r11 16r51 16rB1 16rA5 16r11 16r52 \
        16rB1 16rA5 16r11 16r53 16rB1 16rA5 16r83 16r00 16rF3 16rF2 \
        16r05 16r1E 16r12 16r11 16rA3 16rCF 16rB0 16r71 16r51 16r21 \
        16rA3 16rE1 16r02 16r08 16r21 16r22 16r11 16r22 16rB1 16rA5 \
        16rD0 16rF3 16r82 16r01 16rF2 16r10 16r21 16r81 16r02 16rF3 \
        16rF5] \
    #( #value:value:value: #to:do: #valueWithArguments:  )) >

<primitive 112 pTempVar 4  " parts " \
  #( #[ 16r11 16r5D 16rB6 16rF7 16r05 16r05 16r1E 16rA0 16rF1 16r61 16rF2 \
        16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " dependOn: " \
  #( #[ 16r21 16r20 16r81 16r00 16rF2 16r20 16r80 16r01 16r21 16r81 16r02 \
        16r61 16rF5] \
    #( #addDependent: #parts #copyWith:  )) >

<primitive 112 pTempVar 6  " with: " \
  #( #[ 16r20 16rA0 16r21 16r05 16r38 16rA0 16r82 16r00 16rF3 16rF5] \
    #( #setBlock:arguments:  )) >

<primitive 112 pTempVar 7  " block:arguments: " \
  #( #[ 16r20 16rA0 16r21 16r22 16r82 16r00 16rF3 16rF5] \
    #( #setBlock:arguments:  )) >

<primitive 98 #BlockValue \
  <primitive 97 #BlockValue #ComputedValue #AmigaTalk:General/BlockValue.st \
   #(  #myBlock #arguments #numArgs ) \
   #( #setBlock:arguments: #setBlock: #computeValue #parts #dependOn: #with:  \
       #block:arguments:  ) \
  pTempVar 4 9 > #ordinary >

