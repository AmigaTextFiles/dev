pTempVar <- <primitive 110 20 >
<primitive 112 pTempVar 1  " coerceMethod:message: " \
  #( #[ 16r30 16r12 16r21 16r22 16rFA 16r04 16rEE 16rF3] \
    #( 15  )) >

<primitive 112 pTempVar 2  " doSuperMethod:message: " \
  #( #[ 16r30 16r12 16r21 16r22 16rFA 16r04 16rEE 16rF3] \
    #( 14  )) >

<primitive 112 pTempVar 3  " translateBoopsiErrorNumber " \
  #( #[ 16r30 16rFA 16r01 16rEE 16rF3] \
    #( 13  )) >

<primitive 112 pTempVar 4  " doGadgetMethod:from:req:message: " \
  #( #[ 16r30 16r21 16r22 16r23 16r24 16rFA 16r05 16rEE 16rF3] \
    #( 12  )) >

<primitive 112 pTempVar 5  " nextObject: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rEE 16rF3] \
    #( 11  )) >

<primitive 112 pTempVar 6  " setGadgetAttributes:from:req:tags: " \
  #( #[ 16r30 16r21 16r22 16r23 16r24 16rFA 16r05 16rEE 16rF3] \
    #( 10  )) >

<primitive 112 pTempVar 7  " setAttributes:tags: " \
  #( #[ 16r59 16r21 16r22 16rFA 16r03 16rEE 16rF3] \
    #(  )) >

<primitive 112 pTempVar 8  " getAttribute:from:into: " \
  #( #[ 16r58 16r21 16r22 16r23 16rFA 16r04 16rEE 16rF3] \
    #(  )) >

<primitive 112 pTempVar 9  " releaseGIRPort " \
  #( #[ 16r57 16r11 16rFA 16r02 16rEE 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " obtainGIRPort: " \
  #( #[ 16r56 16r21 16rFA 16r02 16rEE 16rF1 16r61 16rF3] \
    #(  )) >

<primitive 112 pTempVar 11  " makeBoopsiClass:for:id:size:flags: " \
  #( #[ 16r55 16r21 16r23 16r22 16r24 16r25 16rFA 16r06 16rEE 16r62 16r20 \
        16r80 16r00 16rF2 16r12 16rF3] \
    #( #xxxAddBoopsiClass  )) >

<primitive 112 pTempVar 12  " freeBoopsiClass " \
  #( #[ 16r54 16r12 16rFA 16r02 16rEE 16r71 16r55 16r50 16r12 16rFA 16r03 \
        16rFA 16rF2 16r21 16rF3] \
    #(  )) >

<primitive 112 pTempVar 13  " removeBoopsiClass " \
  #( #[ 16r53 16r12 16rFA 16r02 16rEE 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " xxxAddBoopsiClass " \
  #( #[ 16r52 16r12 16rFA 16r02 16rEE 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " boopsiName: " \
  #( #[ 16r13 16r21 16rB1 16rF3] \
    #(  )) >

<primitive 112 pTempVar 16  " newBoopsiObject:in:tags: " \
  #( #[ 16r51 16r22 16r21 16r23 16rFA 16r04 16rEE 16rF1 16r60 16rF3] \
    #(  )) >

<primitive 112 pTempVar 17  " boopsiTag: " \
  #( #[ 16r14 16r21 16r81 16r00 16rF3] \
    #( #systemTag:  )) >

<primitive 112 pTempVar 18  " new " \
  #( #[ 16r13 16rA1 16rF7 16r04 16r40 16rA0 16rF1 16r63 16rF2 16r14 16rA1 \
        16rF7 16r04 16r41 16rA0 16rF1 16r64 16rF2 16r20 16rF3] \
    #( #BoopsiClassNames #BoopsiTags  )) >

<primitive 112 pTempVar 19  " disposeObject: " \
  #( #[ 16r05 16r10 16r21 16rFA 16r02 16rEE 16rF2 16r55 16r50 16r21 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3] \
    #(  )) >

<primitive 112 pTempVar 20  " dispose " \
  #( #[ 16r05 16r10 16r10 16rFA 16r02 16rEE 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3] \
    #(  )) >

<primitive 98 #Boopsi \
  <primitive 97 #Boopsi #Object #AmigaTalk:Intuition/Boopsi.st \
   #(  #private #rastPortObj #iclassObj #boopsiNames #boopsiTags ) \
   #( #coerceMethod:message: #doSuperMethod:message:  \
       #translateBoopsiErrorNumber #doGadgetMethod:from:req:message: #nextObject:  \
       #setGadgetAttributes:from:req:tags: #setAttributes:tags: #getAttribute:from:into: #releaseGIRPort  \
       #obtainGIRPort: #makeBoopsiClass:for:id:size:flags: #freeBoopsiClass  \
       #removeBoopsiClass #xxxAddBoopsiClass #boopsiName: #newBoopsiObject:in:tags: #boopsiTag:  \
       #new #disposeObject: #dispose  ) \
  pTempVar 6 7 > #ordinary >

pTempVar <- <primitive 110 5 >
<primitive 112 pTempVar 1  " xxxSetup " \
  #( #[ 16r13 16rA1 16rF7 16r06 16r05 16r1E 16r59 16rB0 16rF1 16r63 16rF2 \
        16r10 16r12 16r81 16r00 16rF2 16r10 16r11 16r50 16r81 16r01 \
        16r81 16r02 16rF2 16r13 16r51 16r20 16r33 16r91 16r04 16rD0 \
        16rF2 16r13 16r52 16r10 16rD0 16rF2 16r13 16r53 16r20 16r35 \
        16r91 16r04 16rD0 16rF2 16r13 16r54 16r11 16rD0 16rF2 16r13 \
        16r55 16r20 16r36 16r91 16r04 16rD0 16rF2 16r13 16r56 16r12 \
        16r0A 16r31 16rD0 16rF2 16r13 16r57 16r20 16r37 16r91 16r04 \
        16rD0 16rF2 16r13 16r58 16r12 16r0A 16r32 16rD0 16rF2 16r13 \
        16r59 16r20 16r38 16r91 16r04 16rD0 16rF2 16r20 16r20 16r39 \
        16r91 16r0A 16r5D 16r13 16r93 16r0B 16rF3] \
    #( #setITextOrigin: #@ #setPens: #IA_Data #boopsiTag: #IA_FGPen \
        #IA_Left #IA_Top #TAG_DONE #ITEXTCLASS #boopsiName: #newBoopsiObject:in:tags:  )) >

<primitive 112 pTempVar 2  " initialize:at:color: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF2 16r20 16r22 16r81 16r01 16rF2 16r20 \
        16r23 16r81 16r02 16rF2 16r20 16r80 16r03 16rF3] \
    #( #itextString: #origin: #color: #xxxSetup  )) >

<primitive 112 pTempVar 3  " color: " \
  #( #[ 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " origin: " \
  #( #[ 16r21 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " itextString: " \
  #( #[ 16r40 16r21 16rB0 16r60 16rF5] \
    #( #IText  )) >

<primitive 98 #BoopsiText \
  <primitive 97 #BoopsiText #BoopsiImage #AmigaTalk:Intuition/Boopsi.st \
   #(  #itextObj #textColor \
        #textOrigin #tagArray ) \
   #( #xxxSetup #initialize:at:color: #color: #origin: #itextString:  ) \
  pTempVar 4 14 > #ordinary >

pTempVar <- <primitive 110 17 >
<primitive 112 pTempVar 1  " gadgetDisabled:index: " \
  #( #[ 16r21 16rF7 16r05 16r51 16rF1 16r73 16rF8 16r04 16rF2 16r50 16rF1 \
        16r73 16rF2 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 \
        16r11 16r22 16r51 16rC0 16r23 16rD0 16rF2 16rF5] \
    #( #GA_Disabled #boopsiTag:  )) >

<primitive 112 pTempVar 2  " gadgetSpecialInfo:index: " \
  #( #[ 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 16r11 16r22 16r51 \
        16rC0 16r21 16rD0 16rF2 16rF5] \
    #( #GA_SpecialInfo #boopsiTag:  )) >

<primitive 112 pTempVar 3  " gadgetSelectRender:index: " \
  #( #[ 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 16r11 16r22 16r51 \
        16rC0 16r21 16rD0 16rF2 16rF5] \
    #( #GA_SelectRender #boopsiTag:  )) >

<primitive 112 pTempVar 4  " gadgetBorder:index: " \
  #( #[ 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 16r11 16r22 16r51 \
        16rC0 16r21 16rD0 16rF2 16rF5] \
    #( #GA_Border #boopsiTag:  )) >

<primitive 112 pTempVar 5  " gadgetID:index: " \
  #( #[ 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 16r11 16r22 16r51 \
        16rC0 16r21 16rD0 16rF2 16rF5] \
    #( #GA_ID #boopsiTag:  )) >

<primitive 112 pTempVar 6  " gadgetImage:index: " \
  #( #[ 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 16r11 16r22 16r51 \
        16rC0 16r21 16rD0 16rF2 16rF5] \
    #( #GA_Image #boopsiTag:  )) >

<primitive 112 pTempVar 7  " gadgetLabelImage:index: " \
  #( #[ 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 16r11 16r22 16r51 \
        16rC0 16r21 16rD0 16rF2 16rF5] \
    #( #GA_LabelImage #boopsiTag:  )) >

<primitive 112 pTempVar 8  " gadgetText:index: " \
  #( #[ 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 16r11 16r22 16r51 \
        16rC0 16r21 16rD0 16rF2 16rF5] \
    #( #GA_Text #boopsiTag:  )) >

<primitive 112 pTempVar 9  " gadgetIntuiText:index: " \
  #( #[ 16r11 16r22 16r20 16r30 16r91 16r01 16rD0 16rF2 16r11 16r22 16r51 \
        16rC0 16r21 16rD0 16rF2 16rF5] \
    #( #GA_IntuiText #boopsiTag:  )) >

<primitive 112 pTempVar 10  " userData: " \
  #( #[ 16r21 16rA3 16r73 16r05 16r1E 16r23 16rB0 16r72 16r51 16r23 16rB2 \
        16rE1 16r04 16r07 16r22 16r24 16r21 16r24 16rB1 16rD0 16rF3 \
        16rB3 16rF2 16r11 16r30 16r22 16rD0 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 11  " extent: " \
  #( #[ 16r11 16r56 16r21 16r0A 16r31 16rD0 16rF2 16r11 16r58 16r21 16r0A \
        16r32 16rD0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " origin: " \
  #( #[ 16r11 16r52 16r21 16r0A 16r31 16rD0 16rF2 16r11 16r54 16r21 16r0A \
        16r32 16rD0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " tagArray " \
  #( #[ 16r11 16rF3] \
    #(  )) >

<primitive 112 pTempVar 14  " setTagArray: " \
  #( #[ 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " newBoopsiObject: " \
  #( #[ 16r20 16r21 16r5D 16r11 16r93 16r00 16rF3] \
    #( #newBoopsiObject:in:tags:  )) >

<primitive 112 pTempVar 16  " initialize " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3] \
    #( 'initialize' #subclassResponsibility:  )) >

<primitive 112 pTempVar 17  " new: " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3] \
    #( 'new:' #subclassResponsibility:  )) >

<primitive 98 #BoopsiGadget \
  <primitive 97 #BoopsiGadget #Boopsi #AmigaTalk:Intuition/Boopsi.st \
   #(  #gadObj #tagArray ) \
   #( #gadgetDisabled:index: #gadgetSpecialInfo:index:  \
       #gadgetSelectRender:index: #gadgetBorder:index: #gadgetID:index: #gadgetImage:index:  \
       #gadgetLabelImage:index: #gadgetText:index: #gadgetIntuiText:index: #userData: #extent:  \
       #origin: #tagArray #setTagArray: #newBoopsiObject: #initialize #new:  ) \
  pTempVar 5 7 > #ordinary >

pTempVar <- <primitive 110 2 >
<primitive 112 pTempVar 1  " initialize " \
  #( #[ 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF3] \
    #( #BUTTONGCLASS #boopsiName: #newBoopsiObject:  )) >

<primitive 112 pTempVar 2  " new: " \
  #( #[ 16r21 16r30 16rC7 16rF7 16r08 16r05 16r1E 16r30 16rB0 16rF1 16r72 \
        16rF8 16r07 16rF2 16r05 16r1E 16r21 16rB0 16rF1 16r72 16rF2 \
        16r22 16r51 16r20 16r31 16r91 16r02 16rD0 16rF2 16r22 16r52 \
        16r50 16rD0 16rF2 16r22 16r53 16r20 16r33 16r91 16r02 16rD0 \
        16rF2 16r22 16r54 16r50 16rD0 16rF2 16r22 16r55 16r20 16r34 \
        16r91 16r02 16rD0 16rF2 16r22 16r56 16r35 16rD0 16rF2 16r22 \
        16r57 16r20 16r36 16r91 16r02 16rD0 16rF2 16r22 16r58 16r05 \
        16r14 16rD0 16rF2 16r22 16r59 16r20 16r37 16r91 16r02 16rD0 \
        16rF2 16r22 16r38 16r5D 16rD0 16rF2 16r22 16r30 16r20 16r39 \
        16r91 16r02 16rD0 16rF2 16r20 16r22 16r20 16r0B 16r11 16r91 \
        16r0A 16rF2 16rF5] \
    #( 11 #GA_Left #boopsiTag: #GA_Top #GA_Width 50 #GA_Height #GA_UserData \
        10 #TAG_DONE #setTagArray:  )) >

<primitive 98 #BoopsiButtonGadget \
  <primitive 97 #BoopsiButtonGadget #BoopsiGadget #AmigaTalk:Intuition/Boopsi.st \
   #(  #imageObj ) \
   #( #initialize #new:  ) \
  pTempVar 3 9 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiFramedButton \
  <primitive 97 #BoopsiFramedButton #BoopsiButtonGadget #AmigaTalk:Intuition/Boopsi.st \
   #(  #frameType ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiPropGadget \
  <primitive 97 #BoopsiPropGadget #BoopsiGadget #AmigaTalk:Intuition/Boopsi.st \
   #(  #totalSize \
        #visibleSize #currentValue #orientation ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiStringGadget \
  <primitive 97 #BoopsiStringGadget #BoopsiGadget #AmigaTalk:Intuition/Boopsi.st \
   #(  #font #pens #maxLength #mode \
        #justification ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiImage \
  <primitive 97 #BoopsiImage #Boopsi #AmigaTalk:Intuition/Boopsi.st \
   #(  #origin #extent #pens #imageData ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiFillRect \
  <primitive 97 #BoopsiFillRect #BoopsiImage #AmigaTalk:Intuition/Boopsi.st \
   #(  #fillPattern #drawMode \
        #patternSize ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiFrame \
  <primitive 97 #BoopsiFrame #BoopsiImage #AmigaTalk:Intuition/Boopsi.st \
   #(  ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiSystemImage \
  <primitive 97 #BoopsiSystemImage #BoopsiImage #AmigaTalk:Intuition/Boopsi.st \
   #(  #whichImage #drawInfo #imageSize ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " xxxBoopsiTag: " \
  #( #[ 16r12 16r21 16r81 16r00 16rF3] \
    #( #systemTag:  )) >

<primitive 112 pTempVar 2  " setTagValue:value: " \
  #( #[ 16r20 16r20 16r21 16r81 16r00 16r22 16r92 16r01 16rF2 16rF5] \
    #( #xxxBoopsiTag: #setTagValue:value:  )) >

<primitive 112 pTempVar 3  " setTag:index: " \
  #( #[ 16r20 16r20 16r21 16r81 16r00 16r22 16r92 16r01 16rF3] \
    #( #xxxBoopsiTag: #setTag:index:  )) >

<primitive 112 pTempVar 4  " new: " \
  #( #[ 16r22 16rA1 16rF7 16r04 16r40 16rA0 16rF1 16r72 16rF2 16r12 16rA1 \
        16rF7 16r04 16r41 16rA0 16rF1 16r62 16rF2 16r21 16r60 16r20 \
        16r10 16r91 16r02 16r61 16r11 16r10 16r22 16r33 16r81 16r04 \
        16rD0 16rF2 16r20 16rF3] \
    #( #Intuition #BoopsiTags #new: #TAG_DONE #systemTag:  )) >

<primitive 98 #BoopsiMap \
  <primitive 97 #BoopsiMap #TagList #AmigaTalk:Intuition/Boopsi.st \
   #(  #numTags #tagArray #boopsiTags ) \
   #( #xxxBoopsiTag: #setTagValue:value: #setTag:index: #new:  ) \
  pTempVar 3 6 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiIC \
  <primitive 97 #BoopsiIC #Boopsi #AmigaTalk:Intuition/Boopsi.st \
   #(  \
        #target #map #specialCode ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " junk " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 98 #BoopsiModel \
  <primitive 97 #BoopsiModel #BoopsiIC #AmigaTalk:Intuition/Boopsi.st \
   #(  ) \
   #( #junk  ) \
  pTempVar 1 2 > #ordinary >

