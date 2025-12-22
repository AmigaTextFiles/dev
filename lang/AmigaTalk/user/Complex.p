pTempVar <- <primitive 110 25 >
<primitive 112 pTempVar 1  " ~= " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r80 16r01 16r22 16r80 16r01 16rCA 16r20 16r80 16r02 16r22 \
        16r80 16r02 16rCA 16r81 16r03 16rF7 16r04 16r5B 16rF3 16rF8 \
        16r03 16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #realpart #imagpart #&  )) >

<primitive 112 pTempVar 2  " >= " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r80 16r01 16rF2 16r22 16r80 16r01 16rF2 16r20 16r80 16r02 \
        16r22 16r80 16r02 16rCB 16rF7 16r04 16r5B 16rF3 16rF8 16r03 \
        16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #computeMag #magpart  )) >

<primitive 112 pTempVar 3  " <= " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r80 16r01 16rF2 16r22 16r80 16r01 16rF2 16r20 16r80 16r02 \
        16r22 16r80 16r02 16rC8 16rF7 16r04 16r5B 16rF3 16rF8 16r03 \
        16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #computeMag #magpart  )) >

<primitive 112 pTempVar 4  " > " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r80 16r01 16rF2 16r22 16r80 16r01 16rF2 16r20 16r80 16r02 \
        16r22 16r80 16r02 16rCC 16rF7 16r04 16r5B 16rF3 16rF8 16r03 \
        16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #computeMag #magpart  )) >

<primitive 112 pTempVar 5  " < " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r80 16r01 16rF2 16r22 16r80 16r01 16rF2 16r20 16r80 16r02 \
        16r22 16r80 16r02 16rC7 16rF7 16r04 16r5B 16rF3 16rF8 16r03 \
        16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #computeMag #magpart  )) >

<primitive 112 pTempVar 6  " == " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r80 16r01 16r22 16r80 16r01 16rC9 16r20 16r80 16r02 16r22 \
        16r80 16r02 16rC9 16r81 16r03 16rF7 16r04 16r5B 16rF3 16rF8 \
        16r03 16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( #isKindOf: #realpart #imagpart #&  )) >

<primitive 112 pTempVar 7  " computeMagPhase " \
  #( #[ 16r20 16r80 16r00 16rF2 16r20 16r80 16r01 16r32 16rB6 16rF7 16r04 \
        16r33 16rFA 16r01 16r7B 16rF2 16r20 16r80 16r04 16r20 16r80 \
        16r01 16rBF 16r80 16r05 16r63 16rF5] \
    #( #computeMag #imagpart 0.0 'Division by Complex zero!' #realpart \
        #arcTan  )) >

<primitive 112 pTempVar 8  " computeMag " \
  #( #[ 16r20 16r80 16r00 16r20 16r80 16r00 16rC2 16r20 16r80 16r01 16r20 \
        16r80 16r01 16rC2 16r81 16r02 16rFA 16r01 16r47 16r62 16rF5 \
       ] \
    #( #realpart #imagpart #\+  )) >

<primitive 112 pTempVar 9  " printString " \
  #( #[ 16r30 16r10 16rFA 16r01 16r4E 16r0B 16r12 16r31 16r0B 16r12 16r11 \
        16rFA 16r01 16r4E 16r0B 16r12 16r32 16r0B 16r12 16rA8 16rF2 \
        16rF5] \
    #( '{' ', ' '}'  )) >

<primitive 112 pTempVar 10  " / " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r22 \
        16r80 16r01 16r32 16rB6 16r22 16r80 16r03 16r34 16rB6 16r81 \
        16r05 16rF7 16r07 16r36 16rFA 16r01 16r7B 16rF2 16r5D 16rF3 \
        16rF2 16r22 16r80 16r01 16r22 16r80 16r01 16rC2 16r22 16r80 \
        16r03 16r22 16r80 16r03 16rC2 16rC0 16r73 16r22 16r80 16r01 \
        16r20 16r80 16r01 16rC2 16r22 16r80 16r03 16r20 16r80 16r03 \
        16rC2 16rC0 16r74 16r20 16r80 16r03 16r22 16r80 16r01 16rC2 \
        16r20 16r80 16r01 16r22 16r80 16r03 16rC2 16rC1 16r75 16r24 \
        16r23 16rBF 16r60 16r25 16r23 16rBF 16r61 16r20 16rF3 16rF5 \
       ] \
    #( #isKindOf: #realpart 0.0 #imagpart 0.0 #& 'Division by Complex zero!'  )) >

<primitive 112 pTempVar 11  " * " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r80 16r01 16r22 16r80 16r01 16rC2 16r20 16r80 16r02 16r22 \
        16r80 16r02 16rC2 16rC1 16r60 16r20 16r80 16r02 16r22 16r80 \
        16r01 16rC2 16r20 16r80 16r01 16r22 16r80 16r02 16rC2 16rC0 \
        16r61 16r20 16rF3 16rF5] \
    #( #isKindOf: #realpart #imagpart  )) >

<primitive 112 pTempVar 12  " - " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r20 \
        16r80 16r01 16r22 16r80 16r01 16rC1 16r60 16r20 16r80 16r02 \
        16r22 16r80 16r02 16rC1 16r61 16r20 16rF3 16rF5] \
    #( #isKindOf: #realpart #imagpart  )) >

<primitive 112 pTempVar 13  " + " \
  #( #[ 16r21 16r20 16rA4 16r81 16r00 16rF6 16r08 16r20 16r21 16r0B 16r10 \
        16rF1 16r72 16rF8 16r04 16rF2 16r21 16rF1 16r72 16rF2 16r22 \
        16r80 16r01 16r20 16r80 16r01 16rC0 16r60 16r22 16r80 16r02 \
        16r20 16r80 16r02 16rC0 16r61 16r20 16rF3 16rF5] \
    #( #isKindOf: #realpart #imagpart  )) >

<primitive 112 pTempVar 14  " ~^ " \
  #( #[ 16r20 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " conjugate " \
  #( #[ 16r30 16r11 16rC2 16r61 16rF5] \
    #( -1.0  )) >

<primitive 112 pTempVar 16  " coerce: " \
  #( #[ 16r05 16r27 16rA0 16r72 16r22 16r21 16r81 16r00 16rF2 16r22 16r31 \
        16r81 16r02 16rF2 16r22 16rF3 16rF5] \
    #( #realpart: 0.0 #imagpart:  )) >

<primitive 112 pTempVar 17  " phasepart: " \
  #( #[ 16r21 16r63 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " magpart: " \
  #( #[ 16r21 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " imagpart: " \
  #( #[ 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " realpart: " \
  #( #[ 16r21 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " phasepart " \
  #( #[ 16r13 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " magpart " \
  #( #[ 16r12 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " imagpart " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " realpart " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " new " \
  #( #[ 16r05 16r2B 16r30 16rB0 16r60 16r05 16r2B 16r31 16rB0 16r61 16r05 \
        16r2B 16r32 16rB0 16r62 16r05 16r2B 16r33 16rB0 16r63 16rF5 \
       ] \
    #( 0.0 0.0 0.0 0.0  )) >

<primitive 98 #Complex \
  <primitive 97 #Complex #Magnitude #User/complex.st \
   #(  #real #imag #mag #phase ) \
   #( #~= #>= #<= #> #< #== #computeMagPhase #computeMag #printString #/ #*  \
       #- #+ #~^ #conjugate #coerce: #phasepart: #magpart: #imagpart: #realpart:  \
       #phasepart #magpart #imagpart #realpart #new  ) \
  pTempVar 6 18 > #ordinary >

