pTempVar <- <primitive 110 21 >
<primitive 112 pTempVar 1  " y: " \
  #( #[ 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " y " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " x:y: " \
  #( #[ 16r21 16r60 16r22 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " x: " \
  #( #[ 16r21 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " x " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " transpose " \
  #( #[ 16r05 16r35 16rA0 16r11 16r0B 16r33 16r10 16r0B 16r34 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 7  " printString " \
  #( #[ 16r10 16rA9 16r30 16r0B 16r12 16r11 16rA9 16r0B 16r12 16rF3 16rF5 \
       ] \
    #( ' @ '  )) >

<primitive 112 pTempVar 8  " min: " \
  #( #[ 16r05 16r35 16rA0 16r10 16r21 16r0A 16r31 16rCF 16r0B 16r33 16r11 \
        16r21 16r0A 16r32 16rCF 16r0B 16r34 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " max: " \
  #( #[ 16r05 16r35 16rA0 16r10 16r21 16r0A 16r31 16r0C 16r10 16r0B 16r33 \
        16r11 16r21 16r0A 16r32 16r0C 16r10 16r0B 16r34 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 10  " dist: " \
  #( #[ 16r10 16r21 16r0A 16r31 16rC1 16r0A 16r2C 16r11 16r21 16r0A 16r32 \
        16rC1 16r0A 16r2C 16rC0 16r0A 16r2B 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " asString " \
  #( #[ 16r10 16r0A 16r11 16r30 16r0B 16r12 16r11 16r0A 16r11 16r0B 16r12 \
        16rF3 16rF5] \
    #( ' @ '  )) >

<primitive 112 pTempVar 12  " abs " \
  #( #[ 16r05 16r35 16rA0 16r10 16rAE 16r0B 16r33 16r11 16rAE 16r0B 16r34 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " // " \
  #( #[ 16r05 16r35 16rA0 16r10 16r21 16r0B 16r13 16r0B 16r33 16r11 16r21 \
        16r0B 16r13 16r0B 16r34 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " / " \
  #( #[ 16r05 16r35 16rA0 16r10 16r21 16rBF 16r0B 16r33 16r11 16r21 16rBF \
        16r0B 16r34 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " - " \
  #( #[ 16r05 16r35 16rA0 16r10 16r21 16r0A 16r31 16rC1 16r0B 16r33 16r11 \
        16r21 16r0A 16r32 16rC1 16r0B 16r34 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " + " \
  #( #[ 16r05 16r35 16rA0 16r10 16r21 16r0A 16r31 16rC0 16r0B 16r33 16r11 \
        16r21 16r0A 16r32 16rC0 16r0B 16r34 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " * " \
  #( #[ 16r05 16r35 16rA0 16r10 16r21 16rC2 16r0B 16r33 16r11 16r21 16rC2 \
        16r0B 16r34 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " = " \
  #( #[ 16r10 16r21 16r0A 16r31 16rC9 16rFC 16r05 16r11 16r21 16r0A 16r32 \
        16rC9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " >= " \
  #( #[ 16r10 16r21 16r0A 16r31 16rCB 16rFC 16r05 16r11 16r21 16r0A 16r32 \
        16rCB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " <= " \
  #( #[ 16r10 16r21 16r0A 16r31 16rC8 16rFC 16r05 16r11 16r21 16r0A 16r32 \
        16rC7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " < " \
  #( #[ 16r10 16r21 16r0A 16r31 16rC7 16rFC 16r05 16r11 16r21 16r0A 16r32 \
        16rC7 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Point \
  <primitive 97 #Point #Magnitude #AmigaTalk:General/Point.st \
   #(  #xvalue #yvalue ) \
   #( #y: #y #x:y: #x: #x #transpose #printString #min: #max: #dist:  \
       #asString #abs #// #/ #- #+ #* #= #>= #<= #<  ) \
  pTempVar 3 4 > #ordinary >

