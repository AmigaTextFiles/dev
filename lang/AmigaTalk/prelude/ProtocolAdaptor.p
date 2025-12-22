pTempVar <- <primitive 110 42 >
<primitive 112 pTempVar 1  " valueUsingTarget: " \
  #( #[ 16r20 16r30 16r81 16r01 16rF3 16rF5] \
    #( 'valueUsingTarget:' #subclassResponsibility:  )) >

<primitive 112 pTempVar 2  " unhookFromSubject " \
  #( #[ 16r11 16rF7 16r04 16r10 16r20 16r81 16r00 16rF2 16rF5] \
    #( #removeDependent:  )) >

<primitive 112 pTempVar 3  " targetUsingSubject: " \
  #( #[ 16r21 16r72 16r20 16r80 16r00 16r73 16r51 16r23 16rA3 16rE1 16r04 \
        16r12 16r22 16r5D 16rB6 16rF7 16r02 16r5D 16rF4 16rF2 16r20 \
        16r22 16r23 16r24 16rB1 16r82 16r01 16rF1 16r72 16rF3 16r82 \
        16r02 16rF2 16r22 16rF3 16rF5] \
    #( #accessPath #access:with: #to:do:  )) >

<primitive 112 pTempVar 4  " setValueUsingTarget:to: " \
  #( #[ 16r20 16r30 16r81 16r01 16rF3 16rF5] \
    #( 'setValueUsingTarget:to:' #subclassResponsibility:  )) >

<primitive 112 pTempVar 5  " renderingValueUsingSubject: " \
  #( #[ 16r10 16r80 16r00 16rF6 16r05 16r20 16r21 16r81 16r01 16rF3 16rF2 \
        16r20 16r0A 16r15 16r73 16r05 16r1E 16r52 16rB0 16r72 16r22 \
        16r52 16r23 16rD0 16rF2 16r23 16r22 16r81 16r02 16r74 16r24 \
        16rA6 16r21 16r80 16r03 16r81 16r04 16rF2 16r24 16r0A 16r1F \
        16rA5 16rF3 16rF5] \
    #( #isProtocolAdaptor #valueUsingSubject: #makeAdaptorForRenderingStoreLeafInto: \
        #asValue #subjectChannel:  )) >

<primitive 112 pTempVar 6  " makeAdaptorForRenderingStoreLeafInto: " \
  #( #[ 16r21 16r51 16r20 16rD0 16rF2 16r20 16r5D 16r81 16r00 16rF2 16r10 \
        16r80 16r01 16rF7 16r0A 16r10 16r0A 16r15 16r60 16r10 16r21 \
        16r81 16r02 16rF8 16r02 16rF2 16r21 16rF3 16rF5] \
    #( #subjectChannel: #isProtocolAdaptor #makeAdaptorForRenderingStoreLeafInto:  )) >

<primitive 112 pTempVar 7  " hookupToSubject " \
  #( #[ 16r11 16rF7 16r08 16r10 16rA2 16rF7 16r04 16r10 16r20 16r81 16r00 \
        16rF2 16rF5] \
    #( #addDependent:  )) >

<primitive 112 pTempVar 8  " changedSubject " \
  #( #[ 16r20 16r20 16r80 16r00 16rA5 16r81 16r01 16rF2 16rF5] \
    #( #subjectChannel #setSubject:  )) >

<primitive 112 pTempVar 9  " access:with: " \
  #( #[ 16r22 16r80 16r00 16rF7 16r06 16r21 16r22 16r81 16r01 16rF8 16r0F \
        16rF2 16r22 16r80 16r02 16rF7 16r05 16r21 16r22 16rB1 16rF8 \
        16r04 16rF2 16r22 16r21 16rB5 16rF3 16rF5] \
    #( #isSymbol #perform: #isInteger  )) >

<primitive 112 pTempVar 10  " printPathOn: " \
  #( #[ 16r20 16r80 16r00 16rF1 16r72 16rA2 16rFC 16r04 16r22 16r0A 16r1C \
        16rAC 16rF7 16r1A 16r22 16rE1 16r03 16r15 16r23 16r80 16r01 \
        16rF7 16r06 16r21 16r23 16r81 16r02 16rF8 16r05 16rF2 16r23 \
        16r21 16r81 16r03 16rF2 16r21 16r80 16r04 16rF3 16rB3 16rF2 \
        16rF5] \
    #( #accessPath #isSymbol #nextPutAll: #printOn: #space  )) >

<primitive 112 pTempVar 11  " printOn: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF2 16r21 16r31 16r81 16r02 16rF2 16r20 \
        16r80 16r03 16r21 16r81 16r00 16rF2 16r21 16r34 16r81 16r02 \
        16rF2 16rF5] \
    #( #printOn: $( #nextPut: #target $)  )) >

<primitive 112 pTempVar 12  " isProtocolAdaptor " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " update:with:from: " \
  #( #[ 16r23 16r12 16rB6 16rF7 16r03 16r20 16r80 16r00 16rF2 16rF5] \
    #( #changedSubject  )) >

<primitive 112 pTempVar 14  " removeDependent: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF2 16r20 16r90 16r01 16r5D 16rB6 16rF7 \
        16r03 16r20 16r80 16r02 16rF2 16r21 16rF3 16rF5] \
    #( #removeDependent: #dependents #unhookFromSubject  )) >

<primitive 112 pTempVar 15  " addDependent: " \
  #( #[ 16r20 16r90 16r00 16r5D 16rB6 16rF7 16r03 16r20 16r80 16r01 16rF2 \
        16r20 16r21 16r91 16r02 16rF3 16rF5] \
    #( #dependents #hookupToSubject #addDependent:  )) >

<primitive 112 pTempVar 16  " valueUsingSubject: " \
  #( #[ 16r20 16r20 16r21 16r81 16r00 16r81 16r01 16rF3 16rF5] \
    #( #targetUsingSubject: #valueUsingTarget:  )) >

<primitive 112 pTempVar 17  " value: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF2 16r11 16r5B 16rC9 16rF6 16r04 16r20 \
        16r31 16r81 16r02 16rF2 16rF5] \
    #( #setValue: #value #changed:  )) >

<primitive 112 pTempVar 18  " value " \
  #( #[ 16r20 16r10 16r81 16r00 16rF3 16rF5] \
    #( #valueUsingSubject:  )) >

<primitive 112 pTempVar 19  " target " \
  #( #[ 16r20 16r10 16r81 16r00 16rF3 16rF5] \
    #( #targetUsingSubject:  )) >

<primitive 112 pTempVar 20  " setValue: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r82 16r01 16rF2 16rF5] \
    #( #target #setValueUsingTarget:to:  )) >

<primitive 112 pTempVar 21  " setAccessPath: " \
  #( #[ 16r21 16r63 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " accessPath " \
  #( #[ 16r13 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " subjectSendsUpdates: " \
  #( #[ 16r10 16rA2 16rFC 16r04 16r20 16r90 16r00 16rA2 16rF7 16r03 16r20 \
        16r80 16r01 16rF2 16r21 16r61 16r10 16rA2 16rFC 16r04 16r20 \
        16r90 16r00 16rA2 16rF7 16r03 16r20 16r80 16r02 16rF2 16rF5 \
       ] \
    #( #dependents #unhookFromSubject #hookupToSubject  )) >

<primitive 112 pTempVar 24  " subjectSendsUpdates " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " setSubjectChannel: " \
  #( #[ 16r12 16rA2 16rF7 16r04 16r12 16r20 16r81 16r00 16rF2 16r21 16r62 \
        16r12 16rA2 16rF7 16r04 16r12 16r20 16r81 16r01 16rF2 16r20 \
        16r80 16r02 16rF2 16rF5] \
    #( #removeDependent: #addDependent: #changedSubject  )) >

<primitive 112 pTempVar 26  " subjectChannel " \
  #( #[ 16r12 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " setSubject: " \
  #( #[ 16r10 16rA2 16rFC 16r04 16r20 16r90 16r00 16rA2 16rF7 16r03 16r20 \
        16r80 16r01 16rF2 16r21 16r60 16r10 16rA2 16rFC 16r04 16r20 \
        16r90 16r00 16rA2 16rF7 16r03 16r20 16r80 16r02 16rF2 16r20 \
        16r90 16r00 16r33 16r5D 16r20 16r83 16r04 16rF2 16rF5] \
    #( #dependents #unhookFromSubject #hookupToSubject #value #update:with:from:  )) >

<primitive 112 pTempVar 28  " setASubject: " \
  #( #[ 16r20 16r80 16r00 16rF1 16r72 16rA2 16rF7 16r05 16r22 16r21 16rB5 \
        16rF8 16r05 16rF2 16r20 16r21 16r81 16r01 16rF2 16rF5] \
    #( #subjectChannel #setSubject:  )) >

<primitive 112 pTempVar 29  " subject " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 30  " releaseParts " \
  #( #[ 16r10 16rA2 16rFC 16r04 16r20 16r90 16r00 16rA2 16rF7 16r03 16r20 \
        16r80 16r01 16rF2 16r12 16rA2 16rF7 16r04 16r12 16r20 16r81 \
        16r02 16rF2 16rF5] \
    #( #dependents #unhookFromSubject #removeDependent:  )) >

<primitive 112 pTempVar 31  " initialize " \
  #( #[ 16r20 16r90 16r00 16rF2 16r5C 16r61 16rF5] \
    #( #initialize  )) >

<primitive 112 pTempVar 32  " subjectChannel:sendsUpdates:accessPath: " \
  #( #[ 16r20 16r23 16r81 16r00 16r22 16r81 16r01 16rF1 16r21 16r81 16r02 \
        16rF2 16rF3 16rF5] \
    #( #accessPath: #subjectSendsUpdates: #subjectChannel:  )) >

<primitive 112 pTempVar 33  " subjectChannel:sendsUpdates: " \
  #( #[ 16r20 16rA0 16r22 16r81 16r00 16rF1 16r21 16r81 16r01 16rF2 16rF3 \
        16rF5] \
    #( #subjectSendsUpdates: #subjectChannel:  )) >

<primitive 112 pTempVar 34  " subjectChannel:accessPath: " \
  #( #[ 16r20 16r22 16r81 16r00 16r21 16r81 16r01 16rF3 16rF5] \
    #( #accessPath: #subjectChannel:  )) >

<primitive 112 pTempVar 35  " subjectChannel: " \
  #( #[ 16r20 16r21 16r5C 16r82 16r00 16rF3 16rF5] \
    #( #subjectChannel:sendsUpdates:  )) >

<primitive 112 pTempVar 36  " subject:sendsUpdates:accessPath: " \
  #( #[ 16r20 16r23 16r81 16r00 16r21 16r81 16r01 16rF1 16r22 16r81 16r02 \
        16rF2 16rF3 16rF5] \
    #( #accessPath: #subject: #subjectSendsUpdates:  )) >

<primitive 112 pTempVar 37  " subject:sendsUpdates: " \
  #( #[ 16r20 16rA0 16r21 16r81 16r00 16rF1 16r22 16r81 16r01 16rF2 16rF3 \
        16rF5] \
    #( #setASubject: #subjectSendsUpdates:  )) >

<primitive 112 pTempVar 38  " subject:accessPath: " \
  #( #[ 16r20 16r22 16r81 16r00 16r21 16r81 16r01 16rF3 16rF5] \
    #( #accessPath: #subject:  )) >

<primitive 112 pTempVar 39  " subject: " \
  #( #[ 16r20 16r21 16r5C 16r82 16r00 16rF3 16rF5] \
    #( #subject:sendsUpdates:  )) >

<primitive 112 pTempVar 40  " new " \
  #( #[ 16r20 16r90 16r00 16r80 16r01 16rF3 16rF5] \
    #( #new #initialize  )) >

<primitive 112 pTempVar 41  " accessPath: " \
  #( #[ 16r20 16rA0 16r21 16r81 16r00 16rF3 16rF5] \
    #( #setAccessPath:  )) >

<primitive 112 pTempVar 42  " dependents " \
  #( #[ 16r20 16r90 16r00 16rF3 16rF5] \
    #( #dependents  )) >

<primitive 98 #ProtocolAdaptor \
  <primitive 97 #ProtocolAdaptor #ValueModel #AmigaTalk:General/ProtocolAdaptor.st \
   #(  #subject #subjectSendsUpdates #subjectChannel #accessPath ) \
   #( #valueUsingTarget: #unhookFromSubject #targetUsingSubject:  \
       #setValueUsingTarget:to: #renderingValueUsingSubject: #makeAdaptorForRenderingStoreLeafInto:  \
       #hookupToSubject #changedSubject #access:with: #printPathOn: #printOn:  \
       #isProtocolAdaptor #update:with:from: #removeDependent: #addDependent:  \
       #valueUsingSubject: #value: #value #target #setValue: #setAccessPath: #accessPath  \
       #subjectSendsUpdates: #subjectSendsUpdates #setSubjectChannel: #subjectChannel #setSubject:  \
       #setASubject: #subject #releaseParts #initialize  \
       #subjectChannel:sendsUpdates:accessPath: #subjectChannel:sendsUpdates: #subjectChannel:accessPath:  \
       #subjectChannel: #subject:sendsUpdates:accessPath: #subject:sendsUpdates:  \
       #subject:accessPath: #subject: #new #accessPath: #dependents  ) \
  pTempVar 5 10 > #ordinary >

