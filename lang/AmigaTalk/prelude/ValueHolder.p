pTempVar <- <primitive 110 8 >
<primitive 112 pTempVar 1  " printOn: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF2 16r21 16r31 16r81 16r02 16rF1 16r20 \
        16rA5 16r81 16r03 16rF2 16rF2 16rF5] \
    #( #printOn: ' on: ' #nextPutAll: #print:  )) >

<primitive 112 pTempVar 2  " value " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " setValue: " \
  #( #[ 16r21 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " with: " \
  #( #[ 16r20 16rA0 16r21 16r81 16r00 16rF3 16rF5] \
    #( #setValue:  )) >

<primitive 112 pTempVar 5  " newString " \
  #( #[ 16r20 16r05 16r3A 16r50 16rB0 16r81 16r00 16rF3 16rF5] \
    #( #with:  )) >

<primitive 112 pTempVar 6  " newFraction " \
  #( #[ 16r20 16r30 16r81 16r01 16rF3 16rF5] \
    #( 0.0 #with:  )) >

<primitive 112 pTempVar 7  " newBoolean " \
  #( #[ 16r20 16r5C 16r81 16r00 16rF3 16rF5] \
    #( #with:  )) >

<primitive 112 pTempVar 8  " dependents " \
  #( #[ 16r20 16r90 16r00 16rF3 16rF5] \
    #( #dependents  )) >

<primitive 98 #ValueHolder \
  <primitive 97 #ValueHolder #ValueModel #AmigaTalk:General/ValueHolder.st \
   #(  #value ) \
   #( #printOn: #value #setValue: #with: #newString #newFraction #newBoolean  \
       #dependents  ) \
  pTempVar 2 6 > #ordinary >

