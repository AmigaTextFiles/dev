pTempVar <- <primitive 110 8 >
<primitive 112 pTempVar 1  " printOn: " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF2 16r21 16r31 16r81 16r02 16rF2 \
        16r20 16r80 16r03 16r21 16r81 16r04 16rF2 16r21 16r80 16r05 \
        16rF2 16r20 16r21 16r81 16r06 16rF2 16r21 16r10 16rA9 16r81 \
        16r07 16rF2 16r21 16r38 16r81 16r02 16rF2 16rF5] \
    #( #print: $( #nextPut: #target #printOn: #space #printPathOn: \
        #nextPutAll: $)  )) >

<primitive 112 pTempVar 2  " update:with:from: " \
  #( #[ 16r23 16r20 16r90 16r00 16rB6 16rF7 16r14 16r21 16r31 16rB6 16rFC \
        16r03 16r22 16r10 16rC9 16rF7 16r08 16r20 16r90 16r02 16r33 \
        16r5D 16r20 16r83 16r04 16rF8 16r07 16rF2 16r20 16r21 16r22 \
        16r23 16r93 16r04 16rF2 16rF5] \
    #( #subject #at: #dependents #value #update:with:from:  )) >

<primitive 112 pTempVar 3  " valueUsingTarget: " \
  #( #[ 16r21 16r5D 16rB6 16rF6 16r06 16r21 16r10 16rB1 16rF3 16rF8 16r03 \
        16rF2 16r5D 16rF3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " setValueUsingTarget:to: " \
  #( #[ 16r21 16r5D 16rB6 16rF6 16r04 16r21 16r10 16r22 16rD0 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 5  " setIndex: " \
  #( #[ 16r21 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " forIndex " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " forIndex:accessPath: " \
  #( #[ 16r20 16r22 16r81 16r00 16r21 16r81 16r01 16rF3 16rF5] \
    #( #accessPath: #forIndex:  )) >

<primitive 112 pTempVar 8  " forIndex: " \
  #( #[ 16r20 16rA0 16r21 16r81 16r00 16rF3 16rF5] \
    #( #setIndex:  )) >

<primitive 98 #IndexedAdaptor \
  <primitive 97 #IndexedAdaptor #ProtocolAdaptor #AmigaTalk:General/IndexedAdaptor.st \
   #(  #index ) \
   #( #printOn: #update:with:from: #valueUsingTarget:  \
       #setValueUsingTarget:to: #setIndex: #forIndex #forIndex:accessPath: #forIndex:  ) \
  pTempVar 4 10 > #ordinary >

