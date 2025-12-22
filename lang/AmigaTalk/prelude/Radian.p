pTempVar <- <primitive 110 8 >
<primitive 112 pTempVar 1  " printString " \
  #( #[ 16r10 16r0A 16r11 16r30 16r0B 16r12 16rF3 16rF5] \
    #( ' radians'  )) >

<primitive 112 pTempVar 2  " asFloat " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " tan " \
  #( #[ 16r10 16rFA 16r01 16r51 16r10 16rFA 16r01 16r52 16rBF 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 4  " cos " \
  #( #[ 16r10 16rFA 16r01 16r52 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " sin " \
  #( #[ 16r10 16rFA 16r01 16r51 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " = " \
  #( #[ 16r10 16r21 16r0A 16r10 16rC9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " < " \
  #( #[ 16r10 16r21 16r0A 16r10 16rC7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " new: " \
  #( #[ 16r21 16r0A 16r10 16rFA 16r01 16r50 16r60 16rF5] \
    #(  )) >

<primitive 98 #Radian \
  <primitive 97 #Radian #Magnitude #AmigaTalk:General/Radian.st \
   #(  #value ) \
   #( #printString #asFloat #tan #cos #sin #= #< #new:  ) \
  pTempVar 2 3 > #ordinary >

