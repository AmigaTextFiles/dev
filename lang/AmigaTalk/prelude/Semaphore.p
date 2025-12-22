pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " wait " \
  #( #[ 16rFA 16r00 16r94 16rF2 16r10 16r50 16rC9 16rF7 16r0A 16r20 16r5F \
        16r0B 16r17 16rF2 16r5F 16r0A 16r13 16rF8 16r06 16rF2 16r10 \
        16r51 16rC1 16rF1 16r60 16rF2 16rFA 16r00 16r95 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 2  " signal " \
  #( #[ 16rFA 16r00 16r94 16rF2 16r20 16r0A 16r1C 16rF7 16r07 16r10 16r51 \
        16rC0 16rF1 16r60 16rF8 16r06 16rF2 16r20 16r0A 16r26 16r0A \
        16r30 16rF2 16rFA 16r00 16r95 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " new: " \
  #( #[ 16r21 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " new " \
  #( #[ 16r50 16r60 16rF5] \
    #(  )) >

<primitive 98 #Semaphore \
  <primitive 97 #Semaphore #List #AmigaTalk:General/Semaphore.st \
   #(  #excessSignals ) \
   #( #wait #signal #new: #new  ) \
  pTempVar 2 4 > #ordinary >

