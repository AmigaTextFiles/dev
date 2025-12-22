pTempVar <- <primitive 110 18 >
<primitive 112 pTempVar 1  " isBuffering " \
  #( #[ 16r5C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " with:with:compute: " \
  #( #[ 16r40 16r23 16r05 16r1E 16r20 16r21 16r22 16r83 16r01 16r82 16r02 \
        16rF3 16rF5] \
    #( #BlockValue #with:with:with: #block:arguments:  )) >

<primitive 112 pTempVar 3  " with:compute: " \
  #( #[ 16r40 16r22 16r05 16r1E 16r20 16r21 16r82 16r01 16r82 16r02 16rF3 \
        16rF5] \
    #( #BlockValue #with:with: #block:arguments:  )) >

<primitive 112 pTempVar 4  " receive:with: " \
  #( #[ 16r40 16rE2 16r03 16r06 16r23 16r21 16r24 16r82 16r01 16rF3 16r05 \
        16r1E 16r20 16r22 16r82 16r02 16r82 16r03 16rF3 16rF5] \
    #( #BlockValue #perform:with: #with:with: #block:arguments:  )) >

<primitive 112 pTempVar 5  " receive: " \
  #( #[ 16r40 16rE1 16r02 16r05 16r22 16r21 16r81 16r01 16rF3 16r05 16r1E \
        16r20 16r81 16r02 16r82 16r03 16rF3 16rF5] \
    #( #BlockValue #perform: #with: #block:arguments:  )) >

<primitive 112 pTempVar 6  " compute: " \
  #( #[ 16r40 16r21 16r05 16r1E 16r20 16r81 16r01 16r82 16r02 16rF3 16rF5 \
       ] \
    #( #BlockValue #with: #block:arguments:  )) >

<primitive 112 pTempVar 7  " retractInterestsFor: " \
  #( #[ 16r20 16r30 16r21 16r82 16r01 16rF2 16rF5] \
    #( #value #retractInterestIn:for:  )) >

<primitive 112 pTempVar 8  " onChangeSend:to: " \
  #( #[ 16r20 16r30 16r22 16r21 16r83 16r01 16rF2 16rF5] \
    #( #value #expressInterestIn:for:sendBack:  )) >

<primitive 112 pTempVar 9  " asValue " \
  #( #[ 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " valueUsingSubject: " \
  #( #[ 16r21 16rA5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " value: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF2 16r20 16r31 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #setValue: #value #changed:  )) >

<primitive 112 pTempVar 12  " value " \
  #( #[ 16r20 16r30 16r81 16r01 16rF3 16rF5] \
    #( 'value' #subclassResponsibility:  )) >

<primitive 112 pTempVar 13  " setValue: " \
  #( #[ 16r20 16r30 16r81 16r01 16rF2 16rF5] \
    #( 'setValue:' #subclassResponsibility:  )) >

<primitive 112 pTempVar 14  " releaseParts " \
  #( #[ 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " release " \
  #( #[ 16r20 16r80 16r00 16rF2 16r20 16r90 16r01 16rF2 16rF5] \
    #( #releaseParts #release  )) >

<primitive 112 pTempVar 16  " dependents " \
  #( #[ 16r20 16r90 16r00 16rF3 16rF5] \
    #( #dependents  )) >

<primitive 112 pTempVar 17  " initialize " \
  #( #[ 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " new " \
  #( #[ 16r20 16r90 16r00 16r80 16r01 16rF3 16rF5] \
    #( #new #initialize  )) >

<primitive 98 #ValueModel \
  <primitive 97 #ValueModel #Model #AmigaTalk:General/ValueModel.st \
   #(  ) \
   #( #isBuffering #with:with:compute: #with:compute: #receive:with:  \
       #receive: #compute: #retractInterestsFor: #onChangeSend:to: #asValue  \
       #valueUsingSubject: #value: #value #setValue: #releaseParts #release #dependents  \
       #initialize #new  ) \
  pTempVar 5 7 > #ordinary >

