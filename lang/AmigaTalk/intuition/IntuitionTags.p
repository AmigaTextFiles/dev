pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " printString " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 'Intuition'  )) >

<primitive 112 pTempVar 2  " systemTag: " \
  #( #[ 16r52 16r11 16r21 16rFA 16r03 16rCE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " close " \
  #( #[ 16r50 16r12 16r11 16rFA 16r03 16rCE 16r62 16r5D 16rF1 16r61 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r13 16r20 16r80 16r00 16r60 16r31 16r63 16r53 \
        16rFA 16r01 16rCE 16r61 16r51 16r13 16r11 16rFA 16r03 16rCE \
        16r62 16r5D 16rF2 16r20 16rF3 16rF5] \
    #( #privateNew 'AmigaTalk:prelude/listFiles/Intuition.dictionary'  )) >

<primitive 112 pTempVar 5  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 6  " privateNew " \
  #( #[ 16r51 16rFA 16r01 16r6E 16r71 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Intuition \
  <primitive 97 #Intuition #Object #AmigaTalk:Intuition/IntuitionTags.st \
   #(  #uniqueInstance #private0 #private1 #myName ) \
   #( #printString #systemTag: #close #privateSetup #new #privateNew  \
       #isSingleton  ) \
  pTempVar 2 6 > #isSingleton >

