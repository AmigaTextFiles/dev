pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r21 16rFA 16r01 16r74 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " size " \
  #( #[ 16r20 16rFA 16r01 16r75 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " printAsChars " \
  #( #[ 16r59 16r30 16r20 16rFA 16r03 16rD1 16rA8 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 4  " displayBytes: " \
  #( #[ 16r05 16r16 16r20 16r21 16rFA 16r03 16rE5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " printString " \
  #( #[ 16r30 16r71 16r51 16r20 16rA3 16rB2 16rE1 16r02 16r0D 16r21 16r20 \
        16r22 16rB1 16rA9 16r0B 16r12 16r31 16r0B 16r12 16rF1 16r71 \
        16rF3 16rB3 16rF2 16r21 16r32 16r0B 16r12 16rF3 16rF5] \
    #( '#[ ' ' ' ']'  )) >

<primitive 112 pTempVar 6  " at:put: " \
  #( #[ 16r20 16r21 16r22 16rFA 16r03 16r77 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " at: " \
  #( #[ 16r20 16r21 16rFA 16r02 16r76 16rF3 16rF5] \
    #(  )) >

<primitive 98 #ByteArray \
  <primitive 97 #ByteArray #ArrayedCollection #AmigaTalk:General/ByteArray.st \
   #(  ) \
   #( #new: #size #printAsChars #displayBytes: #printString #at:put: #at:  ) \
  pTempVar 3 6 > #ordinary >

