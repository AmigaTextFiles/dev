pTempVar <- <primitive 110 42 >
<primitive 112 pTempVar 1  " update: " \
  #( #[ 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " update:with: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF3 16rF5] \
    #( #update:  )) >

<primitive 112 pTempVar 3  " update:with:from: " \
  #( #[ 16r20 16r21 16r22 16r82 16r00 16rF3 16rF5] \
    #( #update:with:  )) >

<primitive 112 pTempVar 4  " changed:with: " \
  #( #[ 16r20 16r80 16r00 16r21 16r22 16r20 16r83 16r01 16rF2 16rF5] \
    #( #modelDependents #update:with:from:  )) >

<primitive 112 pTempVar 5  " changed: " \
  #( #[ 16r20 16r21 16r5D 16r82 16r00 16rF2 16rF5] \
    #( #changed:with:  )) >

<primitive 112 pTempVar 6  " changed " \
  #( #[ 16r20 16r5D 16r81 16r00 16rF2 16rF5] \
    #( #changed:  )) >

<primitive 112 pTempVar 7  " okToChange " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " contentsChanged " \
  #( #[ 16r20 16r30 16r81 16r01 16rF2 16rF5] \
    #( #contentsChanged #changed:  )) >

<primitive 112 pTempVar 9  " modelWakeUpIn: " \
  #( #[ 16r20 16r80 16r00 16rF2 16rF5] \
    #( #modelWakeUp  )) >

<primitive 112 pTempVar 10  " modelWakeUp " \
  #( #[ 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " modelSleep " \
  #( #[ 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " windowIsClosing " \
  #( #[ 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " perform:orSendTo: " \
  #( #[ 16r22 16r21 16r81 16r00 16rF3 16rF5] \
    #( #perform:  )) >

<primitive 112 pTempVar 14  " new " \
  #( #[ 16r40 16rA0 16r60 16r05 16r1E 16rA0 16r61 16r05 16r2F 16rA0 16r63 \
        16r50 16r62 16rF5] \
    #( #DependentsCollection  )) >

<primitive 112 pTempVar 15  " value " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'value' #subclassResponsibility:  )) >

<primitive 112 pTempVar 16  " linkMethod: " \
  #( #[ 16r13 16rA1 16rF7 16r05 16r05 16r2F 16rA0 16rF1 16r63 16rF2 16r13 \
        16r21 16rBE 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " topController " \
  #( #[ 16r10 16rE0 16r02 16r5D 16rF4 16r81 16r00 16rF2 16r10 16rE1 16r01 \
        16r0E 16r21 16r41 16r81 16r02 16rFC 16r03 16r21 16r80 16r03 \
        16rF7 16r02 16r21 16rF4 16rF3 16rB3 16rF2 16r10 16rE1 16r01 \
        16r12 16r21 16r80 16r04 16rE0 16r0A 16r21 16r80 16r05 16r20 \
        16rB6 16rF7 16r02 16r21 16rF4 16rF3 16r81 16r00 16rF3 16rB3 \
        16rF2 16r5D 16rF3 16rF5] \
    #( #ifNil: #Controller #isKindOf: #isInWorld #superController #model  )) >

<primitive 112 pTempVar 18  " removeDependent: " \
  #( #[ 16r10 16r5D 16rB6 16rF7 16r02 16r20 16rF3 16rF2 16r10 16rE1 16r03 \
        16r05 16r23 16r21 16rB6 16rAC 16rF3 16r0B 16r2D 16r72 16r22 \
        16r0A 16r1C 16rF7 16r05 16r5D 16rF1 16r60 16rF8 16r04 16rF2 \
        16r22 16rF1 16r60 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " hasUnacceptedEdits " \
  #( #[ 16r10 16r5D 16rB6 16rF7 16r02 16r5C 16rF3 16rF2 16r12 16r51 16rCC \
        16rF7 16r02 16r5B 16rF3 16rF2 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " dependents " \
  #( #[ 16r10 16r5D 16rB6 16rF7 16r02 16r30 16rF3 16rF2 16r10 16rF3 16rF5 \
       ] \
    #( #( )  )) >

<primitive 112 pTempVar 21  " dependents: " \
  #( #[ 16r21 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " canDiscardEdits " \
  #( #[ 16r10 16r5D 16rB6 16rF7 16r02 16r5B 16rF3 16rF2 16r12 16r51 16rC7 \
        16rF7 16r02 16r5B 16rF3 16rF2 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " asDependentsWithout: " \
  #( #[ 16r21 16r20 16rB6 16rF7 16r03 16r5D 16rF8 16r02 16rF2 16r20 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " asDependentsWith: " \
  #( #[ 16r40 16r20 16r21 16r82 16r01 16rF3 16rF5] \
    #( #DependentsCollection #with:with:  )) >

<primitive 112 pTempVar 25  " asDependentsAsCollection " \
  #( #[ 16r05 16r1E 16r20 16r81 16r00 16rF3 16rF5] \
    #( #with:  )) >

<primitive 112 pTempVar 26  " retractInterestIn:for: " \
  #( #[ 16r20 16r80 16r00 16r73 16r23 16r5D 16rB6 16rF7 16r02 16r20 16rF3 \
        16rF2 16r23 16rA4 16r41 16rB6 16rFC 16r05 16r23 16r22 16r21 \
        16r82 16r02 16rF7 16r05 16r20 16r23 16r81 16r03 16rF3 16rF2 \
        16r23 16rA4 16r44 16rB6 16rF6 16r02 16r20 16rF3 16rF2 16r51 \
        16r23 16rA3 16rE1 16r04 16r19 16r23 16r24 16rB1 16rA4 16r41 \
        16rB6 16rFC 16r07 16r23 16r24 16rB1 16r22 16r21 16r82 16r02 \
        16rF7 16r07 16r20 16r23 16r24 16rB1 16r81 16r03 16rF4 16rF3 \
        16r82 16r05 16rF2 16rF5] \
    #( #myDependents #DependencyTransformer #matches:forAspect: #removeDependent: \
        #DependentsCollection #to:do:  )) >

<primitive 112 pTempVar 27  " expressInterestIn:for:sendBack: " \
  #( #[ 16r40 16rA0 16r74 16r24 16r22 16r21 16r23 16r83 16r01 16rF2 16r20 \
        16r80 16r02 16r75 16r25 16rA4 16r43 16rB6 16rF7 16r06 16r25 \
        16r24 16r0B 16r1F 16rF8 16r08 16rF2 16r25 16r24 16rC9 16rF7 \
        16r02 16r20 16rF3 16rF2 16r20 16r24 16r81 16r04 16rF2 16rF5 \
       ] \
    #( #DependencyTransformer #setReceiver:aspect:selector: #myDependents \
        #DependentsCollection #addDependent:  )) >

<primitive 112 pTempVar 28  " onChangeSend:to: " \
  #( #[ 16r20 16r30 16r22 16r21 16r83 16r01 16rF2 16rF5] \
    #( #value #expressInterestIn:for:sendBack:  )) >

<primitive 112 pTempVar 29  " breakDependents " \
  #( #[ 16r20 16r5D 16r81 16r00 16rF2 16rF5] \
    #( #myDependents:  )) >

<primitive 112 pTempVar 30  " release " \
  #( #[ 16r20 16r80 16r00 16rF2 16rF5] \
    #( #breakDependents  )) >

<primitive 112 pTempVar 31  " changeMade " \
  #( #[ 16r12 16r51 16rC0 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 32  " changeComplete " \
  #( #[ 16r12 16r50 16rCC 16rF7 16r08 16r12 16r51 16rC1 16r62 16r5C 16rF3 \
        16rF8 16r03 16rF2 16r5B 16rF3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 33  " addDependent: " \
  #( #[ 16r10 16r5D 16rB6 16rF7 16r0B 16r05 16r1E 16r51 16rB0 16r60 16r10 \
        16r51 16r21 16rD0 16rF8 16r15 16rF2 16r10 16rE1 16r02 16r08 \
        16r22 16r21 16rB6 16rF7 16r02 16r20 16rF4 16rF3 16rB3 16rF2 \
        16r10 16r21 16r81 16r00 16rF1 16r60 16rF2 16rF5] \
    #( #grow:  )) >

<primitive 112 pTempVar 34  " initialize " \
  #( #[ 16r5D 16r60 16r5D 16r61 16r50 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 35  " postCopy " \
  #( #[ 16r20 16r90 16r00 16rF2 16r20 16r80 16r01 16rF2 16rF5] \
    #( #postCopy #breakDependents  )) >

<primitive 112 pTempVar 36  " myDependents: " \
  #( #[ 16r21 16r5D 16rB6 16rF7 16r09 16r10 16r20 16rE0 16r02 16r5D 16rF3 \
        16rD9 16rF8 16r05 16rF2 16r10 16r20 16r21 16rD0 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 37  " myDependents " \
  #( #[ 16r10 16r20 16rE0 16r02 16r5D 16rF3 16rD5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 38  " broadcast:with: " \
  #( #[ 16r10 16r20 16rE0 16r02 16r5D 16rF3 16rD5 16r73 16r23 16r80 16r00 \
        16rF7 16r0B 16r23 16rE1 16r04 16r06 16r24 16r21 16r22 16r82 \
        16r01 16rF3 16rB3 16rF2 16rF5] \
    #( #isNotNil #perform:with:  )) >

<primitive 112 pTempVar 39  " broadcast: " \
  #( #[ 16r10 16r20 16rE0 16r02 16r5D 16rF3 16rD5 16r72 16r22 16r80 16r00 \
        16rF7 16r0A 16r22 16rE1 16r03 16r05 16r23 16r21 16r81 16r01 \
        16rF3 16rB3 16rF2 16rF5] \
    #( #isNotNil #perform:  )) >

<primitive 112 pTempVar 40  " dependenciesAt: " \
  #( #[ 16r10 16r21 16rE0 16r02 16r5D 16rF4 16rD5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 41  " adaptors " \
  #( #[ 16r11 16r20 16rE0 16r02 16r5D 16rF3 16rD5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 42  " myAdaptors: " \
  #( #[ 16r21 16r5D 16rB6 16rF7 16r09 16r11 16r20 16rE0 16r02 16r5D 16rF3 \
        16rD9 16rF8 16r05 16rF2 16r11 16r20 16r21 16rD0 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 98 #Model \
  <primitive 97 #Model #Object #AmigaTalk:General/Model.st \
   #(  #modelDependents #modelAdaptors #haveAChange #linkedMethods ) \
   #( #update: #update:with: #update:with:from: #changed:with: #changed:  \
       #changed #okToChange #contentsChanged #modelWakeUpIn: #modelWakeUp #modelSleep  \
       #windowIsClosing #perform:orSendTo: #new #value #linkMethod: #topController  \
       #removeDependent: #hasUnacceptedEdits #dependents #dependents: #canDiscardEdits  \
       #asDependentsWithout: #asDependentsWith: #asDependentsAsCollection #retractInterestIn:for:  \
       #expressInterestIn:for:sendBack: #onChangeSend:to: #breakDependents #release #changeMade  \
       #changeComplete #addDependent: #initialize #postCopy #myDependents: #myDependents  \
       #broadcast:with: #broadcast: #dependenciesAt: #adaptors #myAdaptors:  ) \
  pTempVar 6 12 > #ordinary >

