pTempVar <- <primitive 110 16 >
<primitive 112 pTempVar 1  " printAt: " \
  #( #[ 16r21 16r0A 16r15 16r72 16r10 16rE1 16r03 16r0E 16r23 16r22 16r81 \
        16r00 16rF2 16r22 16r22 16r0A 16r31 16r51 16rC0 16r0B 16r33 \
        16rF3 16rB3 16rF2 16rF5] \
    #( #printAt:  )) >

<primitive 112 pTempVar 2  " rows " \
  #( #[ 16r10 16rA3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " row:put: " \
  #( #[ 16r21 16r10 16rA3 16rCC 16rF7 16r0F 16r10 16rA3 16r21 16rC7 16rF7 \
        16r09 16r10 16r30 16r81 16r01 16rF1 16r60 16rF2 16rF9 16r0F \
        16rF2 16r10 16r21 16r22 16rD0 16rF2 16rF5] \
    #( '' #grow:  )) >

<primitive 112 pTempVar 4  " row: " \
  #( #[ 16r10 16r21 16rE0 16r02 16r30 16rF3 16rD5 16rF3 16rF5] \
    #( ''  )) >

<primitive 112 pTempVar 5  " rotated " \
  #( #[ 16r20 16r80 16r00 16r72 16r41 16rA0 16r71 16r51 16r20 16r80 16r02 \
        16rB2 16rE1 16r04 16r24 16r05 16r3A 16r22 16rB0 16r73 16r51 \
        16r22 16rB2 16rE1 16r05 16r11 16r23 16r22 16r25 16rC1 16r51 \
        16rC0 16r10 16r25 16rB1 16r24 16rE0 16r02 16r33 16rF3 16rD5 \
        16rD0 16rF3 16rB3 16rF2 16r21 16r24 16r23 16r82 16r04 16rF3 \
        16rB3 16rF2 16r21 16rF3 16rF5] \
    #( #rows #Form #columns $  #row:put:  )) >

<primitive 112 pTempVar 6  " reversed " \
  #( #[ 16r20 16r80 16r00 16r72 16r41 16rA0 16r71 16r51 16r20 16r80 16r02 \
        16rB2 16rE1 16r04 16r17 16r10 16r24 16rB1 16r73 16r23 16r05 \
        16r3A 16r22 16r23 16rA3 16rC1 16rB0 16r0B 16r12 16r73 16r21 \
        16r24 16r23 16r80 16r03 16r82 16r04 16rF3 16rB3 16rF2 16r21 \
        16rF3 16rF5] \
    #( #columns #Form #rows #reversed #row:put:  )) >

<primitive 112 pTempVar 7  " placeForm:at: " \
  #( #[ 16r22 16r0A 16r31 16r73 16r22 16r0A 16r32 16r51 16rC1 16r75 16r21 \
        16rE1 16r07 16r2C 16r20 16r23 16r81 16r00 16r74 16r27 16rA3 \
        16r76 16r24 16r25 16r26 16rC0 16r81 16r01 16r74 16r51 16r26 \
        16rB2 16rE1 16r08 16r09 16r24 16r25 16r28 16rC0 16r27 16r28 \
        16rB1 16rD0 16rF3 16rB3 16rF2 16r20 16r23 16r24 16r82 16r02 \
        16rF2 16r23 16r51 16rC0 16rF1 16r73 16rF3 16rB3 16rF2 16rF5 \
       ] \
    #( #row: #padTo: #row:put:  )) >

<primitive 112 pTempVar 8  " overLayForm:at: " \
  #( #[ 16r22 16r0A 16r31 16r73 16r22 16r0A 16r32 16r51 16rC1 16r75 16r21 \
        16rE1 16r07 16r33 16r20 16r23 16r81 16r00 16r74 16r27 16rA3 \
        16r76 16r24 16r25 16r26 16rC0 16r81 16r01 16r74 16r51 16r26 \
        16rB2 16rE1 16r08 16r10 16r27 16r28 16rB1 16r32 16rCA 16rF7 \
        16r08 16r24 16r25 16r28 16rC0 16r27 16r28 16rB1 16rD0 16rF3 \
        16rB3 16rF2 16r20 16r23 16r24 16r82 16r03 16rF2 16r23 16r51 \
        16rC0 16rF1 16r73 16rF3 16rB3 16rF2 16rF5] \
    #( #row: #padTo: $  #row:put:  )) >

<primitive 112 pTempVar 9  " next " \
  #( #[ 16r10 16rA7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " first " \
  #( #[ 16r10 16rA6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " extent " \
  #( #[ 16r20 16r80 16r00 16r20 16r80 16r01 16r81 16r02 16rF3 16rF5] \
    #( #rows #columns #@  )) >

<primitive 112 pTempVar 12  " eraseAt: " \
  #( #[ 16r21 16r0A 16r15 16r72 16r10 16rE1 16r03 16r12 16r05 16r3A 16r23 \
        16rA3 16rB0 16r22 16r81 16r00 16rF2 16r22 16r22 16r0A 16r31 \
        16r51 16rC0 16r0B 16r33 16rF3 16rB3 16rF2 16rF5] \
    #( #printAt:  )) >

<primitive 112 pTempVar 13  " display " \
  #( #[ 16r5E 16r80 16r00 16rF2 16r20 16r51 16r51 16r81 16r01 16r81 16r02 \
        16rF2 16r33 16r05 16r14 16r50 16r81 16r01 16r81 16r02 16rF2 \
        16rF5] \
    #( #clearScreen #@ #printAt: '  '  )) >

<primitive 112 pTempVar 14  " columns " \
  #( #[ 16r10 16r50 16rE2 16r01 16r06 16r21 16r22 16rA3 16r0C 16r10 16rF3 \
        16rD7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " clipFrom:to: " \
  #( #[ 16r21 16r0A 16r32 16r51 16rC1 16r76 16r21 16r0A 16r31 16r51 16rC1 \
        16r77 16r22 16r0A 16r32 16r26 16rC1 16r75 16r40 16rA0 16r73 \
        16r21 16r0A 16r31 16r22 16r0A 16r31 16rB2 16rE1 16r09 16r27 \
        16r05 16r3A 16r25 16rB0 16r74 16r20 16r29 16r81 16r01 16r78 \
        16r51 16r25 16rB2 16rE1 16r0A 16r0D 16r24 16r2A 16r28 16r26 \
        16r2A 16rC0 16rE0 16r02 16r32 16rF3 16rD5 16rD0 16rF3 16rB3 \
        16rF2 16r23 16r29 16r27 16rC1 16r24 16r82 16r03 16rF3 16rB3 \
        16rF2 16r23 16rF3 16rF5] \
    #( #Form #row: $  #row:put:  )) >

<primitive 112 pTempVar 16  " new " \
  #( #[ 16r05 16r1E 16r50 16rB0 16r60 16rF5] \
    #(  )) >

<primitive 98 #Form \
  <primitive 97 #Form #Object #AmigaTalk:General/Form.st \
   #(  #text ) \
   #( #printAt: #rows #row:put: #row: #rotated #reversed #placeForm:at:  \
       #overLayForm:at: #next #first #extent #eraseAt: #display #columns #clipFrom:to: #new  ) \
  pTempVar 11 13 > #ordinary >

