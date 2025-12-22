pTempVar <- <primitive 110 21 >
<primitive 112 pTempVar 1  " cr " \
  #( #[ 16r30 16rFA 16r01 16r60 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 2  " sameAs: " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r07 16r20 16r21 16rFA 16r02 \
        16r66 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " size " \
  #( #[ 16r20 16rFA 16r01 16r64 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " print " \
  #( #[ 16r20 16rFA 16r01 16r79 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " printString " \
  #( #[ 16r20 16rFA 16r01 16r6D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " printAt: " \
  #( #[ 16r20 16r21 16r0A 16r31 16r21 16r0A 16r32 16rFA 16r03 16r7E 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " new: " \
  #( #[ 16r21 16rFA 16r01 16r73 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " deepCopy " \
  #( #[ 16r20 16rFA 16r01 16r6B 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " copyFrom:length: " \
  #( #[ 16r20 16r21 16r22 16rFA 16r03 16r6A 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " copyFrom:to: " \
  #( #[ 16r20 16r21 16r22 16r21 16rC1 16r51 16rC0 16rFA 16r03 16r6A 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " compareError " \
  #( #[ 16r20 16r30 16rBD 16rF3 16rF5] \
    #( 'strings can only be compared to strings'  )) >

<primitive 112 pTempVar 12  " at:put: " \
  #( #[ 16r20 16r21 16r22 16rFA 16r03 16r69 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " at: " \
  #( #[ 16r20 16r21 16rFA 16r02 16r68 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " asByteArray " \
  #( #[ 16r59 16r56 16r20 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " asSymbol " \
  #( #[ 16r20 16rFA 16r01 16r6C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " > " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r09 16r20 16r21 16rFA 16r02 \
        16r65 16r50 16rCC 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " >= " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r09 16r20 16r21 16rFA 16r02 \
        16r65 16r50 16rCB 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " <= " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r09 16r20 16r21 16rFA 16r02 \
        16r65 16r50 16rC8 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " < " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r09 16r20 16r21 16rFA 16r02 \
        16r65 16r50 16rC7 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " = " \
  #( #[ 16r20 16r21 16rFA 16r02 16r06 16rF7 16r09 16r20 16r21 16rFA 16r02 \
        16r65 16r50 16rC9 16rF8 16r04 16rF2 16r20 16r0A 16r14 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " , " \
  #( #[ 16r20 16r20 16r21 16rFA 16r02 16r06 16rF7 16r03 16r21 16rF8 16r03 \
        16rF2 16r21 16rA9 16rFA 16r02 16r67 16rF3 16rF5] \
    #(  )) >

<primitive 98 #String \
  <primitive 97 #String #ArrayedCollection #AmigaTalk:General/String.st \
   #(  ) \
   #( #cr #sameAs: #size #print #printString #printAt: #new: #deepCopy  \
       #copyFrom:length: #copyFrom:to: #compareError #at:put: #at: #asByteArray #asSymbol #>  \
       #>= #<= #< #= #,  ) \
  pTempVar 3 5 > #ordinary >

