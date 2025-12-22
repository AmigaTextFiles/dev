pTempVar <- <primitive 110 15 >
<primitive 112 pTempVar 1  " remainderIs " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " quotientIs " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " unsigned64BitMultiply:times: " \
  #( #[ 16r53 16r05 16r18 16r21 16r22 16rFA 16r04 16rD1 16r73 16r53 16r30 \
        16r23 16rFA 16r03 16rD1 16r60 16r53 16r31 16r23 16rFA 16r03 \
        16rD1 16r61 16r23 16rF3 16rF5] \
    #( 39 38  )) >

<primitive 112 pTempVar 4  " signed64BitMultiply:times: " \
  #( #[ 16r53 16r05 16r17 16r21 16r22 16rFA 16r04 16rD1 16r73 16r53 16r30 \
        16r23 16rFA 16r03 16rD1 16r60 16r53 16r31 16r23 16rFA 16r03 \
        16rD1 16r61 16r23 16rF3 16rF5] \
    #( 39 38  )) >

<primitive 112 pTempVar 5  " unsigned32BitDivide:by: " \
  #( #[ 16r53 16r05 16r16 16r21 16r22 16rFA 16r04 16rD1 16r73 16r53 16r30 \
        16r23 16rFA 16r03 16rD1 16r60 16r53 16r31 16r23 16rFA 16r03 \
        16rD1 16r61 16r23 16rF3 16rF5] \
    #( 39 38  )) >

<primitive 112 pTempVar 6  " signed32BitDivide:by: " \
  #( #[ 16r53 16r05 16r15 16r21 16r22 16rFA 16r04 16rD1 16r73 16r53 16r30 \
        16r23 16rFA 16r03 16rD1 16r60 16r53 16r31 16r23 16rFA 16r03 \
        16rD1 16r61 16r23 16rF3 16rF5] \
    #( 39 38  )) >

<primitive 112 pTempVar 7  " getUpper32Bits " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " getLower32Bits " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " odd " \
  #( #[ 16r20 16r20 16r52 16r82 16r00 16r71 16r21 16r50 16rCA 16rF3 16rF5 \
       ] \
    #( #signed32BitDivide:by:  )) >

<primitive 112 pTempVar 10  " even " \
  #( #[ 16r20 16r20 16r52 16r82 16r00 16r71 16r21 16r50 16rC9 16rF3 16rF5 \
       ] \
    #( #signed32BitDivide:by:  )) >

<primitive 112 pTempVar 11  " asFloat " \
  #( #[ 16r20 16r80 16r00 16rFA 16r01 16r27 16r71 16r20 16r80 16r01 16rFA \
        16r01 16r27 16r72 16r21 16r22 16rC0 16rF3 16rF5] \
    #( #getUpper32Bits #getLower32Bits  )) >

<primitive 112 pTempVar 12  " asString " \
  #( #[ 16r20 16r80 16r00 16rFA 16r01 16r25 16r71 16r21 16r20 16r80 16r01 \
        16rFA 16r01 16r25 16r0B 16r12 16rF3 16rF5] \
    #( #getUpper32Bits #getLower32Bits  )) >

<primitive 112 pTempVar 13  " < " \
  #( #[ 16r21 16r40 16r81 16r01 16rF6 16r02 16r5C 16rF3 16rF2 16r20 16r80 \
        16r02 16r21 16r80 16r02 16rFA 16r02 16r0C 16r72 16r22 16r5B \
        16rCA 16rF7 16r04 16r5C 16rF3 16rF8 16r0B 16rF2 16r20 16r80 \
        16r03 16r21 16r80 16r03 16rFA 16r02 16r0C 16rF3 16rF2 16rF5 \
       ] \
    #( #LongInteger #isMemberOf: #getLower32Bits #getUpper32Bits  )) >

<primitive 112 pTempVar 14  " > " \
  #( #[ 16r21 16r40 16r81 16r01 16rF6 16r02 16r5C 16rF3 16rF2 16r20 16r80 \
        16r02 16r21 16r80 16r02 16rFA 16r02 16r0D 16r72 16r22 16r5B \
        16rCA 16rF7 16r04 16r5C 16rF3 16rF8 16r0B 16rF2 16r20 16r80 \
        16r03 16r21 16r80 16r03 16rFA 16r02 16r0D 16rF3 16rF2 16rF5 \
       ] \
    #( #LongInteger #isMemberOf: #getLower32Bits #getUpper32Bits  )) >

<primitive 112 pTempVar 15  " = " \
  #( #[ 16r21 16r40 16r81 16r01 16rF6 16r02 16r5C 16rF3 16rF2 16r20 16r80 \
        16r02 16r21 16r80 16r02 16rFA 16r02 16r10 16r72 16r22 16r5B \
        16rCA 16rF7 16r02 16r5C 16rF3 16rF2 16r20 16r80 16r03 16r21 \
        16r80 16r03 16rFA 16r02 16r10 16rF3 16rF5] \
    #( #LongInteger #isMemberOf: #getLower32Bits #getUpper32Bits  )) >

<primitive 98 #LongInteger \
  <primitive 97 #LongInteger #Number #AmigaTalk:General/LongInteger.st \
   #(  #upper32Bits #lower32Bits ) \
   #( #remainderIs #quotientIs #unsigned64BitMultiply:times:  \
       #signed64BitMultiply:times: #unsigned32BitDivide:by: #signed32BitDivide:by: #getUpper32Bits  \
       #getLower32Bits #odd #even #asFloat #asString #< #> #=  ) \
  pTempVar 4 7 > #ordinary >

