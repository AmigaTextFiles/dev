pTempVar <- <primitive 110 13 >
<primitive 112 pTempVar 1  " printOn: " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF2 16r21 16r31 16r81 16r02 16rF2 \
        16r20 16r80 16r03 16r21 16r81 16r04 16rF2 16r21 16r80 16r05 \
        16rF2 16r20 16r21 16r81 16r06 16rF2 16r21 16r10 16r81 16r07 \
        16rF2 16r21 16r38 16r81 16r02 16rF2 16rF5] \
    #( #print: $( #nextPut: #target #printOn: #space #printPathOn: \
        #nextPutAll: $)  )) >

<primitive 112 pTempVar 2  " update:with:from: " \
  #( #[ 16r23 16r20 16r90 16r00 16rB6 16rFC 16r05 16r21 16r20 16r80 16r01 \
        16rB6 16rF7 16r0A 16r20 16r90 16r02 16r33 16r22 16r20 16r83 \
        16r04 16rF8 16r07 16rF2 16r20 16r21 16r22 16r23 16r93 16r04 \
        16rF2 16rF5] \
    #( #subject #forAspect #dependents #value #update:with:from:  )) >

<primitive 112 pTempVar 3  " valueUsingTarget: " \
  #( #[ 16r21 16r5D 16rB6 16rF6 16r07 16r21 16r10 16r81 16r00 16rF3 16rF8 \
        16r03 16rF2 16r5D 16rF3 16rF2 16rF5] \
    #( #perform:  )) >

<primitive 112 pTempVar 4  " setValueUsingTarget:to: " \
  #( #[ 16r21 16r5D 16rB6 16rF6 16r05 16r21 16r11 16r22 16r82 16r00 16rF2 \
        16rF5] \
    #( #perform:with:  )) >

<primitive 112 pTempVar 5  " initialize " \
  #( #[ 16r20 16r90 16r00 16rF2 16r20 16r31 16r32 16r82 16r03 16rF2 16rF5 \
       ] \
    #( #initialize #value #value: #accessWith:assignWith:  )) >

<primitive 112 pTempVar 6  " setAspect: " \
  #( #[ 16r20 16r21 16r21 16r30 16r0B 16r12 16r0A 16r12 16r82 16r01 16rF2 \
        16rF5] \
    #( ':' #accessWith:assignWith:  )) >

<primitive 112 pTempVar 7  " forAspect " \
  #( #[ 16r12 16r5D 16rB6 16rF7 16r03 16r10 16rF8 16r02 16rF2 16r12 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " accessWith:assignWith:aspect: " \
  #( #[ 16r21 16r60 16r22 16r61 16r23 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " assignAccessWith:assignWith: " \
  #( #[ 16r20 16r21 16r22 16r5D 16r83 16r00 16rF2 16rF5] \
    #( #accessWith:assignWith:aspect:  )) >

<primitive 112 pTempVar 10  " forAspect:accessPath: " \
  #( #[ 16r20 16r22 16r81 16r00 16r21 16r81 16r01 16rF3 16rF5] \
    #( #accessPath: #forAspect:  )) >

<primitive 112 pTempVar 11  " forAspect: " \
  #( #[ 16r20 16rA0 16r21 16r81 16r00 16rF3 16rF5] \
    #( #setAspect:  )) >

<primitive 112 pTempVar 12  " accessWith:assignWith:accessPath: " \
  #( #[ 16r20 16r23 16r81 16r00 16r21 16r22 16r82 16r01 16rF3 16rF5] \
    #( #accessPath: #accessWith:assignWith:  )) >

<primitive 112 pTempVar 13  " accessWith:assignWith: " \
  #( #[ 16r20 16rA0 16r21 16r22 16r82 16r00 16rF3 16rF5] \
    #( #assignAccessWith:assignWith:  )) >

<primitive 98 #AspectAdaptor \
  <primitive 97 #AspectAdaptor #ProtocolAdaptor #AmigaTalk:General/AspectAdaptor.st \
   #(  #getSelector #putSelector #aspect ) \
   #( #printOn: #update:with:from: #valueUsingTarget:  \
       #setValueUsingTarget:to: #initialize #setAspect: #forAspect #accessWith:assignWith:aspect:  \
       #assignAccessWith:assignWith: #forAspect:accessPath: #forAspect: #accessWith:assignWith:accessPath:  \
       #accessWith:assignWith:  ) \
  pTempVar 4 10 > #ordinary >

