pTempVar <- <primitive 110 11 >
<primitive 112 pTempVar 1  " resetValue " \
  #( #[ 16r11 16r5B 16rC9 16rF6 16r05 16r12 16rF1 16r60 16rF8 16r06 16rF2 \
        16r20 16r80 16r00 16rF1 16r60 16rF2 16r20 16r31 16r81 16r02 \
        16rF2 16rF5] \
    #( #computeValue #value #changed:  )) >

<primitive 112 pTempVar 2  " computeValue " \
  #( #[ 16r20 16r30 16r81 16r01 16rF3 16rF5] \
    #( 'computeValue' #subclassResponsibility:  )) >

<primitive 112 pTempVar 3  " printOn: " \
  #( #[ 16r10 16r12 16rB6 16rF6 16r05 16r20 16r21 16r91 16r00 16rF3 16rF2 \
        16r21 16r20 16rA4 16r81 16r01 16rF2 16r21 16r32 16r81 16r03 \
        16rF2 16rF5] \
    #( #printOn: #print: ' with: TheUnassignedValue' #nextPutAll:  )) >

<primitive 112 pTempVar 4  " update:with:from: " \
  #( #[ 16r20 16r80 16r00 16rF2 16rF5] \
    #( #resetValue  )) >

<primitive 112 pTempVar 5  " value: " \
  #( #[ 16r20 16r80 16r00 16rF2 16rF5] \
    #( #shouldNotImplement  )) >

<primitive 112 pTempVar 6  " value " \
  #( #[ 16r10 16r12 16rB6 16rF7 16r05 16r20 16r80 16r00 16rF1 16r60 16rF2 \
        16r10 16rF3 16rF5] \
    #( #computeValue  )) >

<primitive 112 pTempVar 7  " parts " \
  #( #[ 16r20 16r30 16r81 16r01 16rF3 16rF5] \
    #( 'parts' #subclassResponsibility:  )) >

<primitive 112 pTempVar 8  " eagerEvaluation: " \
  #( #[ 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " releaseParts " \
  #( #[ 16r20 16r80 16r00 16rE1 16r01 16r05 16r21 16r20 16r81 16r01 16rF3 \
        16rB3 16rF2 16rF5] \
    #( #parts #removeDependent:  )) >

<primitive 112 pTempVar 10  " resetCache " \
  #( #[ 16r12 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " initialize " \
  #( #[ 16r05 16r33 16rA0 16r62 16r12 16r60 16r5B 16r61 16rF5] \
    #(  )) >

<primitive 98 #ComputedValue \
  <primitive 97 #ComputedValue #ValueModel #AmigaTalk:General/ComputedValue.st \
   #(  #cachedValue #eagerEvaluation #unassignedValue ) \
   #( #resetValue #computeValue #printOn: #update:with:from: #value: #value  \
       #parts #eagerEvaluation: #releaseParts #resetCache #initialize  ) \
  pTempVar 4 6 > #ordinary >

