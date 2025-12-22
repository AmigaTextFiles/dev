pTempVar <- <primitive 110 9 >
<primitive 112 pTempVar 1  " max: " \
  #( #[ 16r20 16r21 16rCC 16rF7 16r03 16r20 16rF8 16r02 16rF2 16r21 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " min: " \
  #( #[ 16r20 16r21 16rC7 16rF7 16r03 16r20 16rF8 16r02 16rF2 16r21 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " between:and: " \
  #( #[ 16r20 16r21 16rCB 16rFC 16r03 16r20 16r22 16rC8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " > " \
  #( #[ 16r21 16r20 16rC7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " >= " \
  #( #[ 16r20 16r21 16rCC 16rFB 16r03 16r20 16r21 16rC9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " ~= " \
  #( #[ 16r20 16r21 16rC9 16rAC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " = " \
  #( #[ 16r20 16r21 16rCC 16rFB 16r03 16r20 16r21 16rC7 16rAC 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 8  " < " \
  #( #[ 16r21 16r20 16rCC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " <= " \
  #( #[ 16r20 16r21 16rC7 16rFB 16r03 16r20 16r21 16rC9 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Magnitude \
  <primitive 97 #Magnitude #Object #AmigaTalk:General/Magnitude.st \
   #(  ) \
   #( #max: #min: #between:and: #> #>= #~= #= #< #<=  ) \
  pTempVar 3 4 > #ordinary >

