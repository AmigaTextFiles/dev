pTempVar <- <primitive 110 3 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16rA0 16r21 16r81 16r00 16rF3 16rF5] \
    #( #nextLink:  )) >

<primitive 112 pTempVar 2  " nextLink: " \
  #( #[ 16r21 16rF1 16r60 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " nextLink " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Link \
  <primitive 97 #Link #Collection #AmigaTalk:General/Link.st \
   #(  #nextLink ) \
   #( #new: #nextLink: #nextLink  ) \
  pTempVar 2 3 > #ordinary >

