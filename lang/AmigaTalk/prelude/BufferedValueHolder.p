pTempVar <- <primitive 110 6 >
<primitive 112 pTempVar 1  " notYetAssigned: " \
  #( #[ 16r21 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " notYetAssigned " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r05 16r20 16r80 16r00 16rF1 16r60 16rF2 16r20 \
        16rF3 16rF5] \
    #( #privateNew  )) >

<primitive 112 pTempVar 4  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 5  " privateNew " \
  #( #[ 16r20 16r90 16r00 16rF3 16rF5] \
    #( #new  )) >

<primitive 112 pTempVar 6  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #BVHGlobalVar \
  <primitive 97 #BVHGlobalVar #Object #AmigaTalk:General/BufferedValueHolder.st \
   #(  #uniqueInstance ) \
   #( #notYetAssigned: #notYetAssigned #privateSetup #new #privateNew  \
       #isSingleton  ) \
  pTempVar 2 5 > #isSingleton >

pTempVar <- <primitive 110 17 >
<primitive 112 pTempVar 1  " isBuffering " \
  #( #[ 16r10 16r13 16r80 16r00 16rB7 16rF3 16rF5] \
    #( #notYetAssigned  )) >

<primitive 112 pTempVar 2  " update:with:from: " \
  #( #[ 16r23 16r12 16rB6 16rF7 16r05 16r20 16r80 16r00 16rF8 16r1E 16rF2 \
        16r23 16r11 16rB6 16rF7 16r11 16r10 16r13 16r80 16r01 16rB6 \
        16rF7 16r08 16r20 16r90 16r02 16r21 16r22 16r20 16r83 16r03 \
        16rF8 16r07 16rF2 16r20 16r21 16r22 16r23 16r93 16r03 16rF2 \
        16rF5] \
    #( #changedTrigger #notYetAssigned #dependents #update:with:from:  )) >

<primitive 112 pTempVar 3  " unhookFromSubject " \
  #( #[ 16r11 16r20 16r81 16r00 16rF2 16rF5] \
    #( #removeDependent:  )) >

<primitive 112 pTempVar 4  " renderingValueUsingSubject: " \
  #( #[ 16r11 16r21 16r81 16r00 16rF3 16rF5] \
    #( #renderingValueUsingSubject:  )) >

<primitive 112 pTempVar 5  " hookupToSubject " \
  #( #[ 16r11 16r20 16r81 16r00 16rF2 16rF5] \
    #( #addDependent:  )) >

<primitive 112 pTempVar 6  " changedTrigger " \
  #( #[ 16r20 16r80 16r00 16rA5 16rF7 16r1D 16r10 16r13 16r80 16r01 16rB6 \
        16rF7 16r02 16r20 16rF3 16rF2 16r20 16r80 16r02 16rF2 16r20 \
        16r80 16r03 16r10 16rB5 16rF2 16r13 16r80 16r01 16r60 16r20 \
        16r80 16r04 16rF8 16r0D 16rF2 16r13 16r80 16r01 16r60 16r20 \
        16r90 16r05 16r36 16r37 16r20 16r83 16r08 16rF2 16rF5] \
    #( #triggerChannel #notYetAssigned #unhookFromSubject #subject \
        #hookupToSubject #dependents #value #reset #update:with:from:  )) >

<primitive 112 pTempVar 7  " removeDependent: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF2 16r20 16r90 16r01 16r5D 16rB6 16rF7 \
        16r03 16r20 16r80 16r02 16rF2 16r21 16rF3 16rF5] \
    #( #removeDependent: #dependents #unhookFromSubject  )) >

<primitive 112 pTempVar 8  " addDependent: " \
  #( #[ 16r20 16r90 16r00 16r5D 16rB6 16rF7 16r03 16r20 16r80 16r01 16rF2 \
        16r20 16r21 16r91 16r02 16rF3 16rF5] \
    #( #dependents #hookupToSubject #addDependent:  )) >

<primitive 112 pTempVar 9  " valueUsingSubject: " \
  #( #[ 16r11 16r21 16r81 16r00 16rF3 16rF5] \
    #( #valueUsingSubject:  )) >

<primitive 112 pTempVar 10  " value " \
  #( #[ 16r10 16r13 16r80 16r00 16rB6 16rF7 16r05 16r11 16rA5 16rF3 16rF8 \
        16r03 16rF2 16r10 16rF3 16rF2 16rF5] \
    #( #notYetAssigned  )) >

<primitive 112 pTempVar 11  " triggerChannel: " \
  #( #[ 16r12 16rA2 16rF7 16r04 16r12 16r20 16r81 16r00 16rF2 16r21 16r62 \
        16r12 16rA2 16rF7 16r04 16r12 16r20 16r81 16r01 16rF2 16rF5 \
       ] \
    #( #removeDependent: #addDependent:  )) >

<primitive 112 pTempVar 12  " triggerChannel " \
  #( #[ 16r12 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " subject: " \
  #( #[ 16r11 16rA2 16rFC 16r04 16r20 16r90 16r00 16rA2 16rF7 16r03 16r20 \
        16r80 16r01 16rF2 16r21 16r61 16r20 16r13 16r80 16r02 16rB5 \
        16rF2 16r11 16rA2 16rFC 16r04 16r20 16r90 16r00 16rA2 16rF7 \
        16r03 16r20 16r80 16r03 16rF2 16rF5] \
    #( #dependents #unhookFromSubject #notYetAssigned #hookupToSubject  )) >

<primitive 112 pTempVar 14  " subject " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " releaseParts " \
  #( #[ 16r12 16rA2 16rF7 16r04 16r12 16r20 16r81 16r00 16rF2 16r20 16r90 \
        16r01 16rA2 16rF7 16r03 16r20 16r80 16r02 16rF2 16r20 16r90 \
        16r03 16rF2 16rF5] \
    #( #removeDependent: #dependents #unhookFromSubject #releaseParts  )) >

<primitive 112 pTempVar 16  " initialize " \
  #( #[ 16r40 16rA0 16r63 16r20 16r90 16r01 16rF2 16r13 16r80 16r02 16r60 \
        16rF5] \
    #( #BVHGlobalVar #initialize #notYetAssigned  )) >

<primitive 112 pTempVar 17  " subject:triggerChannel: " \
  #( #[ 16r20 16rA0 16r21 16r81 16r00 16rF1 16r22 16r81 16r01 16rF2 16rF3 \
        16rF5] \
    #( #subject: #triggerChannel:  )) >

<primitive 98 #BufferedValueHolder \
  <primitive 97 #BufferedValueHolder #ValueHolder #AmigaTalk:General/BufferedValueHolder.st \
   #(  #value #subject #triggerChannel #na ) \
   #( #isBuffering #update:with:from: #unhookFromSubject  \
       #renderingValueUsingSubject: #hookupToSubject #changedTrigger #removeDependent: #addDependent:  \
       #valueUsingSubject: #value #triggerChannel: #triggerChannel #subject: #subject  \
       #releaseParts #initialize #subject:triggerChannel:  ) \
  pTempVar 4 13 > #ordinary >

