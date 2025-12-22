pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r21 16rFA 16r01 16r72 16rF3] \
    #(  )) >

<primitive 112 pTempVar 2  " size " \
  #( #[ 16r20 16rFA 16r01 16r04 16rF3] \
    #(  )) >

<primitive 112 pTempVar 3  " printString " \
  #( #[ 16r5E 16r80 16r00 16rF2 16r31 16r71 16r20 16rFA 16r01 16r04 16r72 \
        16r22 16r50 16rCC 16rF7 16r2E 16r20 16r22 16rFA 16r02 16r6F \
        16r73 16r23 16r05 16r2C 16r81 16r02 16rF7 16r0D 16r23 16r80 \
        16r03 16r34 16r0B 16r12 16r21 16r0B 16r12 16r71 16r5D 16rF8 \
        16r0B 16rF2 16r23 16rA9 16r34 16r0B 16r12 16r21 16r0B 16r12 \
        16r71 16r5D 16rF2 16r22 16r51 16rC1 16rF1 16r72 16rF2 16rF9 \
        16r33 16rF2 16r5E 16r80 16r05 16rF2 16r36 16r21 16r0B 16r12 \
        16rF3] \
    #( #tracingOff ')' #isKindOf: #asHex ' ' #tracingOn '#('  )) >

<primitive 112 pTempVar 4  " grow: " \
  #( #[ 16r20 16r21 16rFA 16r02 16r71 16rF3] \
    #(  )) >

<primitive 112 pTempVar 5  " at:put: " \
  #( #[ 16r20 16r21 16r22 16rFA 16r03 16r70 16rF3] \
    #(  )) >

<primitive 112 pTempVar 6  " at: " \
  #( #[ 16r20 16r21 16rFA 16r02 16r6F 16rF3] \
    #(  )) >

<primitive 112 pTempVar 7  " new " \
  #( #[ 16r51 16rFA 16r01 16r72 16rF3] \
    #(  )) >

<primitive 98 #Array \
  <primitive 97 #Array #ArrayedCollection #AmigaTalk:General/Array.st \
   #(  ) \
   #( #new: #size #printString #grow: #at:put: #at: #new  ) \
  pTempVar 4 7 > #ordinary >

