pTempVar <- <primitive 110 14 >
<primitive 112 pTempVar 1  " write: " \
  #( #[ 16r20 16r21 16rFA 16r02 16r84 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " size " \
  #( #[ 16r20 16rFA 16r01 16r86 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " read " \
  #( #[ 16r20 16rFA 16r01 16r83 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " close " \
  #( #[ 16r20 16rFA 16r01 16r8B 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " open:for: " \
  #( #[ 16r20 16r21 16r22 16rFA 16r03 16r82 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " open: " \
  #( #[ 16r20 16r21 16r30 16rFA 16r03 16r82 16rF2 16rF5] \
    #( 'r'  )) >

<primitive 112 pTempVar 7  " next " \
  #( #[ 16r20 16r0A 16r24 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " first " \
  #( #[ 16r20 16r50 16rB1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " currentKey " \
  #( #[ 16r20 16rFA 16r01 16r88 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " at:put: " \
  #( #[ 16r20 16r21 16rFA 16r02 16r87 16rF2 16r20 16r22 16r0B 16r32 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " at: " \
  #( #[ 16r20 16r21 16rFA 16r02 16r87 16rF2 16r20 16r0A 16r24 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 12  " modeString " \
  #( #[ 16r20 16r51 16rFA 16r02 16r85 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " modeInteger " \
  #( #[ 16r20 16r52 16rFA 16r02 16r85 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " modeCharacter " \
  #( #[ 16r20 16r50 16rFA 16r02 16r85 16rF2 16rF5] \
    #(  )) >

<primitive 98 #File \
  <primitive 97 #File #SequenceableCollection #AmigaTalk:General/File.st \
   #(  ) \
   #( #write: #size #read #close #open:for: #open: #next #first #currentKey  \
       #at:put: #at: #modeString #modeInteger #modeCharacter  ) \
  pTempVar 3 4 > #ordinary >

