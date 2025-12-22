pTempVar <- <primitive 110 5 >
<primitive 112 pTempVar 1  " privateSetupDictionary " \
  #( #[ 16r20 16r30 16r31 16rD0 16rF2 16r20 16r32 16r33 16rD0 16rF2 16r20 \
        16r34 16r35 16rD0 16rF2 16r20 16r36 16r37 16rD0 16rF2 16r20 \
        16r38 16r39 16rD0 16rF2 16r20 16r3A 16r3B 16rD0 16rF2 16r20 \
        16r3C 16r3D 16rD0 16rF2 16r20 16r3E 16r3F 16rD0 16rF2 16r20 \
        16r03 16r10 16r03 16r11 16rD0 16rF2 16r20 16r03 16r12 16r03 \
        16r13 16rD0 16rF2 16r20 16r03 16r14 16r03 16r15 16rD0 16rF2 \
        16r20 16r03 16r16 16r03 16r17 16rD0 16rF2 16r20 16r03 16r18 \
        16r03 16r19 16rD0 16rF2 16r20 16r03 16r1A 16r03 16r1B 16rD0 \
        16rF2 16r20 16r03 16r1C 16r03 16r1D 16rD0 16rF2 16rF5] \
    #( #ROOTCLASS 'rootclass' #IMAGECLASS 'imageclass' #FRAMEICLASS \
        'frameiclass' #SYSICLASS 'sysiclass' #FILLRECTCLASS 'fillrectclass' \
        #GADGETCLASS 'gadgetclass' #PROPGCLASS 'propgclass' #STRGCLASS \
        'strgclass' #BUTTONGCLASS 'buttongclass' #FRBUTTONCLASS 'frbuttonclass' \
        #GROUPGCLASS 'groupgclass' #ICCLASS 'icclass' #MODELCLASS 'modelclass' \
        #ITEXTICLASS 'itexticlass' #POINTERCLASS 'pointerclass'  )) >

<primitive 112 pTempVar 2  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r09 16r20 16r80 16r00 16r60 16r20 16r80 16r01 \
        16rF2 16r5D 16rF2 16r20 16rF3] \
    #( #privateNew #privateSetupDictionary  )) >

<primitive 112 pTempVar 3  " new " \
  #( #[ 16r20 16r80 16r00 16rF3] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 4  " privateNew " \
  #( #[ 16r20 16r90 16r00 16r71 16r21 16rF3] \
    #( #new  )) >

<primitive 112 pTempVar 5  " isSingleton " \
  #( #[ 16r5B 16rF3] \
    #(  )) >

<primitive 98 #BoopsiClassNames \
  <primitive 97 #BoopsiClassNames #Dictionary #AmigaTalk:Intuition/BoopsiClassNames.st \
   #(  #uniqueInstance ) \
   #( #privateSetupDictionary #privateSetup #new #privateNew #isSingleton  ) \
  pTempVar 2 5 > #isSingleton >

