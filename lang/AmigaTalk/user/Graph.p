pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " close " \
  #( #[ 16r11 16r80 16r00 16rF2 16r10 16r80 16r00 16rF2 16r5D 16rF3 16rF5 \
       ] \
    #( #close  )) >

<primitive 112 pTempVar 2  " domain " \
  #( #[ 16r1D 16rA6 16r0A 16r11 16r30 16r0B 16r12 16r1D 16r0A 16r1F 16r0A \
        16r11 16r0B 16r12 16rF3 16rF5] \
    #( '<->'  )) >

<primitive 112 pTempVar 3  " range " \
  #( #[ 16r1C 16rA6 16r0A 16r11 16r30 16r0B 16r12 16r1C 16r0A 16r1F 16r0A \
        16r11 16r0B 16r12 16rF3 16rF5] \
    #( '<->'  )) >

<primitive 112 pTempVar 4  " yScale " \
  #( #[ 16r5A 16r19 16rC2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " xScale " \
  #( #[ 16r18 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " tellDomain " \
  #( #[ 16r30 16r1D 16rA6 16r0A 16r11 16r0B 16r12 16r31 16r0B 16r12 16r1D \
        16r0A 16r1F 16r0A 16r11 16r0B 16r12 16rA8 16rF2 16rF5] \
    #( 'Domain is ' '<->'  )) >

<primitive 112 pTempVar 7  " tellRange " \
  #( #[ 16r30 16r1C 16rA6 16r0A 16r11 16r0B 16r12 16r31 16r0B 16r12 16r1C \
        16r0A 16r1F 16r0A 16r11 16r0B 16r12 16rA8 16rF2 16rF5] \
    #( 'Range  is ' '<->'  )) >

<primitive 112 pTempVar 8  " tellScales " \
  #( #[ 16r30 16r18 16r0B 16r12 16r31 16r0B 16r12 16r51 16r81 16r02 16r19 \
        16rC2 16rA8 16rF2 16rF5] \
    #( 'Scales are:  xscale = ' ', yscale = ' #,-  )) >

<primitive 112 pTempVar 9  " drawLabel:at: " \
  #( #[ 16r20 16r21 16r22 16r92 16r00 16rF2 16r11 16r80 16r01 16rF2 16rF5 \
       ] \
    #( #drawText:at: #refreshWindowFrame  )) >

<primitive 112 pTempVar 10  " drawYAxis:numTicks:color: " \
  #( #[ 16r1C 16r21 16r0B 16r20 16rF7 16r37 16r20 16r23 16r81 16r00 16rF2 \
        16r20 16r21 16r1D 16rA6 16r21 16r1D 16r0A 16r1F 16r84 16r01 \
        16rF2 16r22 16r50 16rCC 16rF7 16r20 16r1D 16r0A 16r1F 16r1D \
        16rA6 16rC1 16r22 16rBF 16r74 16r51 16r22 16r51 16rD4 16rE1 \
        16r06 16r0D 16r26 16r24 16rC2 16r1D 16rA6 16rC0 16r75 16r20 \
        16r21 16r25 16r82 16r02 16rF3 16rB3 16rF2 16r5D 16rF8 16r03 \
        16rF2 16r33 16rA8 16rF2 16r11 16r80 16r04 16rF2 16rF5] \
    #( #setPen: #drawLine:y1:x2:y2: #drawYTick:y: 'Y-Axis outside range!' \
        #refreshWindowFrame  )) >

<primitive 112 pTempVar 11  " drawXAxis:numTicks:color: " \
  #( #[ 16r1D 16r21 16r0B 16r20 16rF7 16r37 16r20 16r23 16r81 16r00 16rF2 \
        16r20 16r1C 16rA6 16r21 16r1C 16r0A 16r1F 16r21 16r84 16r01 \
        16rF2 16r22 16r50 16rCC 16rF7 16r20 16r1C 16r0A 16r1F 16r1C \
        16rA6 16rC1 16r22 16rBF 16r74 16r51 16r22 16r51 16rD4 16rE1 \
        16r06 16r0D 16r26 16r24 16rC2 16r1C 16rA6 16rC0 16r75 16r20 \
        16r25 16r21 16r82 16r02 16rF3 16rB3 16rF2 16r5D 16rF8 16r03 \
        16rF2 16r33 16rA8 16rF2 16r11 16r80 16r04 16rF2 16rF5] \
    #( #setPen: #drawLine:y1:x2:y2: #drawXTick:y: 'X-Axis outside domain!' \
        #refreshWindowFrame  )) >

<primitive 112 pTempVar 12  " drawGrid:y:color: " \
  #( #[ 16r20 16r23 16r81 16r00 16rF2 16r1C 16r0A 16r1F 16r1C 16rA6 16rC1 \
        16r21 16rBF 16r74 16r51 16r21 16r51 16rD4 16rE1 16r06 16r12 \
        16r26 16r24 16rC2 16r1C 16rA6 16rC0 16r75 16r20 16r25 16r1D \
        16r0A 16r1F 16r25 16r1D 16rA6 16r84 16r01 16rF3 16rB3 16rF2 \
        16r1D 16r0A 16r1F 16r1D 16rA6 16rC1 16r22 16rBF 16r74 16r51 \
        16r22 16r51 16rD4 16rE1 16r06 16r12 16r26 16r24 16rC2 16r1D \
        16rA6 16rC0 16r75 16r20 16r1C 16rA6 16r25 16r1C 16r0A 16r1F \
        16r25 16r84 16r01 16rF3 16rB3 16rF2 16r11 16r80 16r02 16rF2 \
        16rF5] \
    #( #setPen: #drawLine:y1:x2:y2: #refreshWindowFrame  )) >

<primitive 112 pTempVar 13  " drawYTick:y: " \
  #( #[ 16r05 16r35 16rA0 16r73 16r05 16r35 16rA0 16r74 16r23 16r16 16r53 \
        16rC0 16r18 16r21 16r1C 16r0A 16r1F 16rC1 16rC2 16rC0 16r0A \
        16r29 16r0B 16r33 16rF2 16r23 16r17 16r19 16r22 16r1D 16rA6 \
        16rC1 16rC2 16rC0 16r0A 16r29 16r0B 16r34 16rF2 16r24 16r16 \
        16r53 16rC1 16r18 16r21 16r1C 16r0A 16r1F 16rC1 16rC2 16rC0 \
        16r0A 16r29 16r0B 16r33 16rF2 16r24 16r17 16r19 16r22 16r1D \
        16rA6 16rC1 16rC2 16rC0 16r0A 16r29 16r0B 16r34 16rF2 16r20 \
        16r23 16r24 16r92 16r00 16rF2 16r11 16r80 16r01 16rF2 16rF5 \
       ] \
    #( #drawLineFrom:to: #refreshWindowFrame  )) >

<primitive 112 pTempVar 14  " drawXTick:y: " \
  #( #[ 16r05 16r35 16rA0 16r73 16r05 16r35 16rA0 16r74 16r23 16r16 16r18 \
        16r21 16r1C 16r0A 16r1F 16rC1 16rC2 16rC0 16r0A 16r29 16r0B \
        16r33 16rF2 16r23 16r17 16r53 16rC0 16r19 16r22 16r1D 16rA6 \
        16rC1 16rC2 16rC0 16r0A 16r29 16r0B 16r34 16rF2 16r24 16r16 \
        16r18 16r21 16r1C 16r0A 16r1F 16rC1 16rC2 16rC0 16r0A 16r29 \
        16r0B 16r33 16rF2 16r24 16r17 16r53 16rC1 16r19 16r22 16r1D \
        16rA6 16rC1 16rC2 16rC0 16r0A 16r29 16r0B 16r34 16rF2 16r20 \
        16r23 16r24 16r92 16r00 16rF2 16r11 16r80 16r01 16rF2 16rF5 \
       ] \
    #( #drawLineFrom:to: #refreshWindowFrame  )) >

<primitive 112 pTempVar 15  " drawLine:y1:x2:y2: " \
  #( #[ 16r05 16r35 16rA0 16r75 16r05 16r35 16rA0 16r76 16r25 16r16 16r18 \
        16r21 16r1C 16r0A 16r1F 16rC1 16rC2 16rC0 16r0A 16r29 16r0B \
        16r33 16rF2 16r25 16r17 16r19 16r22 16r1D 16rA6 16rC1 16rC2 \
        16rC0 16r0A 16r29 16r0B 16r34 16rF2 16r26 16r16 16r18 16r23 \
        16r1C 16r0A 16r1F 16rC1 16rC2 16rC0 16r0A 16r29 16r0B 16r33 \
        16rF2 16r26 16r17 16r19 16r24 16r1D 16rA6 16rC1 16rC2 16rC0 \
        16r0A 16r29 16r0B 16r34 16rF2 16r20 16r25 16r26 16r92 16r00 \
        16rF2 16r11 16r80 16r01 16rF2 16rF5] \
    #( #drawLineFrom:to: #refreshWindowFrame  )) >

<primitive 112 pTempVar 16  " plotPoint:y: " \
  #( #[ 16r05 16r35 16rA0 16r73 16r23 16r16 16r18 16r21 16r1C 16r0A 16r1F \
        16rC1 16rC2 16rC0 16r0A 16r29 16r0B 16r33 16rF2 16r23 16r17 \
        16r19 16r22 16r1D 16rA6 16rC1 16rC2 16rC0 16r0A 16r29 16r0B \
        16r34 16rF2 16r20 16r23 16r91 16r00 16rF2 16rF5] \
    #( #drawPixelAt:  )) >

<primitive 112 pTempVar 17  " setYAxisFrom:to:by: " \
  #( #[ 16r1D 16r21 16r22 16r23 16r83 16r00 16rF2 16r23 16r6B 16r17 16r15 \
        16rC1 16r21 16r22 16rC1 16rBF 16r69 16rF5] \
    #( #from:to:by:  )) >

<primitive 112 pTempVar 18  " setXAxisFrom:to:by: " \
  #( #[ 16r1C 16r21 16r22 16r23 16r83 16r00 16rF2 16r23 16r6A 16r16 16r14 \
        16rC1 16r22 16r21 16rC1 16rBF 16r68 16rF5] \
    #( #from:to:by:  )) >

<primitive 112 pTempVar 19  " setPen: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF2 16rF5] \
    #( #setAPen:  )) >

<primitive 112 pTempVar 20  " refreshGraphPaper " \
  #( #[ 16r11 16r80 16r00 16rF2 16rF5] \
    #( #refreshWindowFrame  )) >

<primitive 112 pTempVar 21  " open:from:to: " \
  #( #[ 16r40 16r12 16rB0 16r60 16r41 16r13 16rB0 16r61 16r10 16r21 16r81 \
        16r02 16rF2 16r20 16r22 16r23 16r82 16r03 16rF2 16r10 16r54 \
        16r81 16r04 16rF2 16r10 16r80 16r05 16rF2 16r11 16r36 16r81 \
        16r07 16rF2 16r11 16r12 16r81 16r08 16rF2 16rF5] \
    #( #Screen #Window #setScreenModeID: #setSizeFrom:to: #setDepth: #open \
        16r11800 #setFlags: #openOnScreen:  )) >

<primitive 112 pTempVar 22  " setSizeFrom:to: " \
  #( #[ 16r10 16r21 16r81 16r00 16rF2 16r10 16r22 16r81 16r01 16rF2 16r11 \
        16r21 16r81 16r02 16rF2 16r11 16r22 16r81 16r03 16rF2 16r21 \
        16r0A 16r31 16r64 16r21 16r0A 16r32 16r65 16r22 16r0A 16r31 \
        16r66 16r22 16r0A 16r32 16r67 16rF5] \
    #( #setOrigin: #setScreenSize: #setWindowOrigin: #setWindowSize:  )) >

<primitive 112 pTempVar 23  " initialize:winTitle: " \
  #( #[ 16r21 16r62 16r22 16r63 16r20 16r13 16r91 16r00 16rF2 16r05 16r2E \
        16rA0 16r6C 16r05 16r2E 16rA0 16r6D 16r31 16r6A 16r32 16r6B \
        16r33 16r68 16r34 16r69 16rF5] \
    #( #new: 0.0 0.0 1.0 1.0  )) >

<primitive 98 #Graph \
  <primitive 97 #Graph #Painter #User/graph.st \
   #(  #scr #win #ts #tw #x #y #w #h #xscale #yscale #xinc #yinc #range #domain ) \
   #( #close #domain #range #yScale #xScale #tellDomain #tellRange  \
       #tellScales #drawLabel:at: #drawYAxis:numTicks:color: #drawXAxis:numTicks:color:  \
       #drawGrid:y:color: #drawYTick:y: #drawXTick:y: #drawLine:y1:x2:y2: #plotPoint:y:  \
       #setYAxisFrom:to:by: #setXAxisFrom:to:by: #setPen: #refreshGraphPaper #open:from:to:  \
       #setSizeFrom:to: #initialize:winTitle:  ) \
  pTempVar 7 10 > #ordinary >

