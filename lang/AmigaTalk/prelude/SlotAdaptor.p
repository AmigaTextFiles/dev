pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " printOn: " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF2 16r21 16r31 16r81 16r02 16rF2 \
        16r20 16r80 16r03 16r21 16r81 16r04 16rF2 16r21 16r80 16r05 \
        16rF2 16r20 16r21 16r81 16r06 16rF2 16r21 16r37 16r81 16r08 \
        16rF2 16r21 16r20 16r90 16r09 16rA9 16r81 16r08 16rF2 16r21 \
        16r3A 16r81 16r02 16rF2 16rF5] \
    #( #print: $( #nextPut: #target #printOn: #space #printPathOn: \
        'instVarAt: ' #nextPutAll: #forIndex $)  )) >

<primitive 112 pTempVar 2  " valueUsingTarget: " \
  #( #[ 16r21 16r5D 16rB6 16rF6 16r09 16r21 16r20 16r90 16r00 16r81 16r01 \
        16rF3 16rF8 16r03 16rF2 16r5D 16rF3 16rF2 16rF5] \
    #( #forIndex #instVarAt:  )) >

<primitive 112 pTempVar 3  " setValueUsingTarget:to: " \
  #( #[ 16r21 16r5D 16rB6 16rF6 16r07 16r21 16r20 16r90 16r00 16r22 16r82 \
        16r01 16rF2 16rF5] \
    #( #forIndex #instVarAt:put:  )) >

<primitive 112 pTempVar 4  " forIndex: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF2 16rF5] \
    #( #setIndex:  )) >

<primitive 98 #SlotAdaptor \
  <primitive 97 #SlotAdaptor #IndexedAdaptor #AmigaTalk:General/SlotAdaptor.st \
   #(  ) \
   #( #printOn: #valueUsingTarget: #setValueUsingTarget:to: #forIndex:  ) \
  pTempVar 3 12 > #ordinary >

