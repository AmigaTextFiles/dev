pTempVar <- <primitive 110 8 >
<primitive 112 pTempVar 1  " yield " \
  #( #[ 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " unblock " \
  #( #[ 16r20 16r0A 16r2D 16r30 16rB6 16rF7 16r07 16r20 16r31 16r0B 16r30 \
        16rF2 16r5D 16rF3 16rF2 16r20 16r53 16rFA 16r02 16r91 16rF2 \
        16r20 16r0A 16r2D 16rF3 16rF5] \
    #( #TERMINATED 'unblock'  )) >

<primitive 112 pTempVar 3  " termErr: " \
  #( #[ 16r30 16r21 16r0B 16r12 16r31 16r0B 16r12 16rA8 16rF2 16rF5] \
    #( 'Cannot ' ' a terminated process.'  )) >

<primitive 112 pTempVar 4  " terminate " \
  #( #[ 16r20 16rFA 16r01 16r8E 16rF2 16r20 16r0A 16r2D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " state " \
  #( #[ 16r20 16rFA 16r01 16r92 16r71 16r21 16r50 16rC9 16rF7 16r04 16r30 \
        16r71 16r21 16rF3 16rF2 16r21 16r51 16rC9 16rF7 16r04 16r31 \
        16r71 16r21 16rF3 16rF2 16r21 16r52 16rC9 16rF7 16r04 16r32 \
        16r71 16r21 16rF3 16rF2 16r21 16r53 16rC9 16rF7 16r04 16r32 \
        16r71 16r21 16rF3 16rF2 16r21 16r54 16rCB 16rF7 16r04 16r33 \
        16r71 16r21 16rF3 16rF2 16rF5] \
    #( #READY #SUSPENDED #BLOCKED #TERMINATED  )) >

<primitive 112 pTempVar 6  " suspend " \
  #( #[ 16r20 16r0A 16r2D 16r30 16rB6 16rF7 16r07 16r20 16r31 16r0B 16r30 \
        16rF2 16r5D 16rF3 16rF2 16r20 16r51 16rFA 16r02 16r91 16rF2 \
        16r20 16r0A 16r2D 16rF3 16rF5] \
    #( #TERMINATED 'suspend'  )) >

<primitive 112 pTempVar 7  " resume " \
  #( #[ 16r20 16r0A 16r2D 16r30 16rB6 16rF7 16r07 16r20 16r31 16r0B 16r30 \
        16rF2 16r5D 16rF3 16rF2 16r20 16r50 16rFA 16r02 16r91 16rF2 \
        16r20 16r0A 16r2D 16rF3 16rF5] \
    #( #TERMINATED 'resume'  )) >

<primitive 112 pTempVar 8  " block " \
  #( #[ 16r20 16r0A 16r2D 16r30 16rB6 16rF7 16r07 16r20 16r31 16r0B 16r30 \
        16rF2 16r5D 16rF3 16rF2 16r20 16r52 16rFA 16r02 16r91 16rF2 \
        16r20 16r0A 16r2D 16rF3 16rF5] \
    #( #TERMINATED 'block'  )) >

<primitive 98 #Process \
  <primitive 97 #Process #Object #AmigaTalk:General/Process.st \
   #(  ) \
   #( #yield #unblock #termErr: #terminate #state #suspend #resume #block  ) \
  pTempVar 2 4 > #ordinary >

