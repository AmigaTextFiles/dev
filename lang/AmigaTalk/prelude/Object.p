pTempVar <- <primitive 110 48 >
<primitive 112 pTempVar 1  " xxxAddress: " \
  #( #[ 16r55 16r52 16r21 16rFA 16r03 16rFA 16rF3] \
    #(  )) >

<primitive 112 pTempVar 2  " xxxReport " \
  #( #[ 16r55 16r51 16r20 16rFA 16r03 16rFA 16rF3] \
    #(  )) >

<primitive 112 pTempVar 3  " breakPoint: " \
  #( #[ 16r30 16r50 16r21 16rFA 16r03 16rD1 16rF3] \
    #( 10  )) >

<primitive 112 pTempVar 4  " performUpdate: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF2 16rF5] \
    #( #perform:  )) >

<primitive 112 pTempVar 5  " performUpdate:with: " \
  #( #[ 16r20 16r21 16r22 16r82 16r00 16rF2 16rF5] \
    #( #perform:with:  )) >

<primitive 112 pTempVar 6  " perform:with:with:with: " \
  #( #[ 16r21 16r05 16r3B 16r81 16r00 16rF6 16r04 16r20 16r31 16rBD 16rF3 \
        16rF2 16r20 16r21 16r0B 16r2A 16rF6 16r07 16r20 16r32 16r21 \
        16r0B 16r12 16rBD 16rF3 16rF2 16r05 16r1E 16r54 16rB0 16r75 \
        16r25 16r51 16r20 16rD0 16rF2 16r25 16r52 16r22 16rD0 16rF2 \
        16r25 16r53 16r23 16rD0 16rF2 16r25 16r54 16r24 16rD0 16rF2 \
        16r25 16r21 16rFA 16r02 16r8F 16rF3] \
    #( #isMemberOf: 'Selector argument must be a Symbol!' 'Does NOT respondTo:  '  )) >

<primitive 112 pTempVar 7  " perform:with:with: " \
  #( #[ 16r21 16r05 16r3B 16rE0 16r04 16r20 16r30 16rBD 16rF4 16r82 16r01 \
        16rF2 16r20 16r21 16r0B 16r2A 16rF6 16r07 16r20 16r32 16r21 \
        16r0B 16r12 16rBD 16rF3 16rF2 16r05 16r1E 16r53 16rB0 16r74 \
        16r24 16r51 16r20 16rD0 16rF2 16r24 16r52 16r22 16rD0 16rF2 \
        16r24 16r53 16r23 16rD0 16rF2 16r24 16r21 16rFA 16r02 16r8F \
        16rF3] \
    #( 'Selector argument must be a Symbol!' #isMemberOf:ifFalse: 'Does NOT respondTo:  '  )) >

<primitive 112 pTempVar 8  " perform:withArguments: " \
  #( #[ 16r22 16rA3 16r50 16rC9 16rF7 16r05 16r20 16r21 16r81 16r00 16rF3 \
        16rF2 16r22 16rA3 16r51 16rC9 16rF7 16r08 16r20 16r21 16r22 \
        16r51 16rB1 16r82 16r01 16rF3 16rF2 16r05 16r1E 16r22 16rA3 \
        16r51 16rC0 16rB0 16r73 16r21 16r05 16r3B 16r81 16r02 16rF6 \
        16r04 16r20 16r33 16rBD 16rF3 16rF2 16r21 16r80 16r04 16r22 \
        16rA3 16rC9 16rF6 16r04 16r20 16r35 16rBD 16rF3 16rF2 16r20 \
        16r21 16r0B 16r2A 16rF6 16r07 16r20 16r36 16r21 16r0B 16r12 \
        16rBD 16rF3 16rF2 16r23 16r51 16r20 16rD0 16rF2 16r52 16r23 \
        16rA3 16rB2 16rE1 16r04 16r09 16r23 16r24 16r22 16r24 16r51 \
        16rC1 16rB1 16rD0 16rF3 16rB3 16rF2 16r23 16r21 16rFA 16r02 \
        16r8F 16rF3] \
    #( #perform: #perform:with: #isMemberOf: 'Selector argument must be a Symbol!' \
        #numArgs 'Incorrect number of arguments!' 'Does NOT respondTo:  '  )) >

<primitive 112 pTempVar 9  " perform:with: " \
  #( #[ 16r21 16r05 16r3B 16r81 16r00 16rF6 16r04 16r20 16r31 16rBD 16rF3 \
        16rF2 16r20 16r21 16r0B 16r2A 16rF6 16r07 16r20 16r32 16r21 \
        16r0B 16r12 16rBD 16rF3 16rF2 16r05 16r1E 16r52 16rB0 16r73 \
        16r23 16r51 16r20 16rD0 16rF2 16r23 16r52 16r22 16rD0 16rF2 \
        16r23 16r21 16rFA 16r02 16r8F 16rF3] \
    #( #isMemberOf: 'Selector argument must be a Symbol!' 'Does NOT respondTo:  '  )) >

<primitive 112 pTempVar 10  " perform:orSendTo: " \
  #( #[ 16r22 16r21 16r81 16r00 16rF3] \
    #( #perform:  )) >

<primitive 112 pTempVar 11  " perform: " \
  #( #[ 16r21 16r05 16r3B 16r81 16r00 16rF6 16r04 16r20 16r31 16rBD 16rF3 \
        16rF2 16r20 16r21 16r0B 16r2A 16rF6 16r07 16r20 16r32 16r21 \
        16r0B 16r12 16rBD 16rF3 16rF2 16r05 16r1E 16r51 16rB0 16r72 \
        16r22 16r51 16r20 16rD0 16rF2 16r22 16r21 16rFA 16r02 16r8F \
        16rF3] \
    #( #isMemberOf: 'Selector argument must be a Symbol!' 'Does NOT respondTo:  '  )) >

<primitive 112 pTempVar 12  " notYetImplemented " \
  #( #[ 16r30 16r31 16r32 16r33 16rFA 16r04 16rB5 16rF3] \
    #( 13 'NOT yet implemented!' 'User ERROR:' 'OKAY'  )) >

<primitive 112 pTempVar 13  " shouldNotImplement: " \
  #( #[ 16r05 16r3A 16r30 16r21 16r0B 16r12 16r31 16r0B 16r12 16rB0 16r72 \
        16r32 16r22 16r33 16r34 16rFA 16r04 16rB5 16rF3] \
    #( 'Method ' ' should NOT BE implemented!' 13 'User ERROR:' 'OKAY'  )) >

<primitive 112 pTempVar 14  " doesNotUnderstand: " \
  #( #[ 16r05 16r3A 16r30 16r21 16r0B 16r12 16r31 16r0B 16r12 16rB0 16r72 \
        16r32 16r22 16r33 16r34 16rFA 16r04 16rB5 16rF3] \
    #( 'Method ' ' NOT understood!' 13 'User ERROR:' 'OKAY'  )) >

<primitive 112 pTempVar 15  " notImplemented: " \
  #( #[ 16r05 16r3A 16r30 16r21 16r0B 16r12 16r31 16r0B 16r12 16rB0 16r72 \
        16r32 16r22 16r33 16r34 16rFA 16r04 16rB5 16rF3] \
    #( 'Method ' ' NOT implemented!' 13 'User ERROR:' 'OKAY'  )) >

<primitive 112 pTempVar 16  " subclassResponsibility: " \
  #( #[ 16r05 16r3A 16r30 16r21 16r0B 16r12 16r31 16r0B 16r12 16rB0 16r72 \
        16r32 16r22 16r33 16r34 16rFA 16r04 16rB5 16rF3] \
    #( 'Method ' ' should be implemented in a SubClass!' 13 'User ERROR:' \
        'OKAY'  )) >

<primitive 112 pTempVar 17  " asciiToString: " \
  #( #[ 16r21 16r30 16rFA 16r02 16r17 16r72 16r22 16rFA 16r01 16r60 16rF3 \
       ] \
    #( 16rFF  )) >

<primitive 112 pTempVar 18  " shallowCopy " \
  #( #[ 16r20 16rFA 16r01 16r04 16r71 16r21 16r30 16rC5 16r50 16rCA 16rF7 \
        16r04 16r20 16rF3 16rF8 16r1A 16rF2 16r20 16rA4 16rA0 16r72 \
        16r51 16r21 16rE1 16r03 16r0B 16r22 16r23 16r20 16r23 16rFA \
        16r02 16r6F 16rFA 16r03 16r70 16rF3 16r82 16r01 16rF2 16r22 \
        16rF3 16rF2 16rF5] \
    #( 16r0F000000 #to:do:  )) >

<primitive 112 pTempVar 19  " respondsTo: " \
  #( #[ 16r20 16rA4 16r21 16r0B 16r2A 16rF3] \
    #(  )) >

<primitive 112 pTempVar 20  " printString " \
  #( #[ 16r20 16r0A 16r11 16rF3] \
    #(  )) >

<primitive 112 pTempVar 21  " printNoReturn " \
  #( #[ 16r20 16rA9 16rFA 16r01 16r78 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " print " \
  #( #[ 16r20 16rA9 16rFA 16r01 16r79 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " notNil " \
  #( #[ 16r5B 16rF3] \
    #(  )) >

<primitive 112 pTempVar 24  " next " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 112 pTempVar 25  " ifNil: " \
  #( #[ 16r20 16rF3] \
    #(  )) >

<primitive 112 pTempVar 26  " isNil " \
  #( #[ 16r5C 16rF3] \
    #(  )) >

<primitive 112 pTempVar 27  " ifKindOf:thenDo: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF7 16r03 16r22 16r20 16rB5 16rF3] \
    #( #isKindOf:  )) >

<primitive 112 pTempVar 28  " isMemberOf: " \
  #( #[ 16r21 16r20 16rA4 16rB6 16rF3] \
    #(  )) >

<primitive 112 pTempVar 29  " isKindOf: " \
  #( #[ 16r20 16rA4 16r72 16r22 16rA2 16rF7 16r10 16r22 16r21 16rB6 16rF7 \
        16r02 16r5B 16rF3 16rF2 16r22 16r0A 16r2E 16rF1 16r72 16rF2 \
        16rF9 16r14 16rF2 16r5C 16rF3] \
    #(  )) >

<primitive 112 pTempVar 30  " error: " \
  #( #[ 16r21 16r20 16rFA 16r02 16r7A 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 31  " do:without: " \
  #( #[ 16r22 16r5D 16rB6 16rF6 16r1A 16r20 16rA6 16r73 16r23 16rA2 16rF7 \
        16r10 16r23 16r22 16rB7 16rF7 16r03 16r21 16r23 16rB5 16rF2 \
        16r20 16rA7 16rF1 16r73 16rF2 16rF9 16r14 16rF3 16rF8 16r04 \
        16rF2 16r20 16r21 16rB3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 32  " do: " \
  #( #[ 16r20 16rA6 16r72 16r22 16rA2 16rF7 16r0B 16r21 16r22 16rB5 16rF2 \
        16r20 16rA7 16rF1 16r72 16rF2 16rF9 16r0F 16rF3] \
    #(  )) >

<primitive 112 pTempVar 33  " first " \
  #( #[ 16r20 16rF3] \
    #(  )) >

<primitive 112 pTempVar 34  " deepCopy " \
  #( #[ 16r20 16rFA 16r01 16r04 16r71 16r21 16r30 16rC5 16r50 16rCA 16rF7 \
        16r04 16r20 16rF3 16rF8 16r1C 16rF2 16r20 16rA4 16rA0 16r72 \
        16r51 16r21 16rE1 16r03 16r0D 16r22 16r23 16r20 16r23 16rFA \
        16r02 16r6F 16r0A 16r15 16rFA 16r03 16r70 16rF3 16r82 16r01 \
        16rF2 16r22 16rF3 16rF2 16rF5] \
    #( 16r0F000000 #to:do:  )) >

<primitive 112 pTempVar 35  " postCopy " \
  #( #[ 16r20 16rF3] \
    #(  )) >

<primitive 112 pTempVar 36  " asValue " \
  #( #[ 16r40 16r20 16r81 16r01 16rF3] \
    #( #ValueHolder #with:  )) >

<primitive 112 pTempVar 37  " copy " \
  #( #[ 16r20 16r0A 16r2A 16r80 16r00 16rF3] \
    #( #postCopy  )) >

<primitive 112 pTempVar 38  " class " \
  #( #[ 16r20 16rFA 16r01 16r01 16rF3] \
    #(  )) >

<primitive 112 pTempVar 39  " yourself " \
  #( #[ 16r20 16rF3] \
    #(  )) >

<primitive 112 pTempVar 40  " asSymbol " \
  #( #[ 16r20 16r0A 16r11 16r0A 16r12 16rF3] \
    #(  )) >

<primitive 112 pTempVar 41  " asString " \
  #( #[ 16r20 16rA4 16rFA 16r01 16r98 16rF3] \
    #(  )) >

<primitive 112 pTempVar 42  " ~= " \
  #( #[ 16r20 16r21 16rC9 16rAC 16rF3] \
    #(  )) >

<primitive 112 pTempVar 43  " = " \
  #( #[ 16r20 16r21 16rB6 16rF3] \
    #(  )) >

<primitive 112 pTempVar 44  " ~~ " \
  #( #[ 16r20 16r21 16rB6 16rAC 16rF3] \
    #(  )) >

<primitive 112 pTempVar 45  " == " \
  #( #[ 16r20 16r21 16rFA 16r02 16r07 16rF3] \
    #(  )) >

<primitive 112 pTempVar 46  " identityHash " \
  #( #[ 16r20 16rFA 16r01 16r05 16rF3] \
    #(  )) >

<primitive 112 pTempVar 47  " instVarAt:put: " \
  #( #[ 16r51 16r21 16r22 16r20 16rFA 16r04 16r5F 16rF3] \
    #(  )) >

<primitive 112 pTempVar 48  " instVarAt: " \
  #( #[ 16r50 16r21 16r20 16rFA 16r03 16r5F 16rF3] \
    #(  )) >

<primitive 98 #Object \
  <primitive 97 #Object #Object #AmigaTalk:General/Object.st \
   #(  ) \
   #( #xxxAddress: #xxxReport #breakPoint: #performUpdate:  \
       #performUpdate:with: #perform:with:with:with: #perform:with:with: #perform:withArguments:  \
       #perform:with: #perform:orSendTo: #perform: #notYetImplemented #shouldNotImplement:  \
       #doesNotUnderstand: #notImplemented: #subclassResponsibility: #asciiToString: #shallowCopy  \
       #respondsTo: #printString #printNoReturn #print #notNil #next #ifNil: #isNil  \
       #ifKindOf:thenDo: #isMemberOf: #isKindOf: #error: #do:without: #do: #first #deepCopy  \
       #postCopy #asValue #copy #class #yourself #asSymbol #asString #~= #= #~~ #==  \
       #identityHash #instVarAt:put: #instVarAt:  ) \
  pTempVar 6 12 > #ordinary >

