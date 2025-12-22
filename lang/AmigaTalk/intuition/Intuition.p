pTempVar <- <primitive 110 8 >
<primitive 112 pTempVar 1  " drawRecessedDropBox:with: " \
  #( #[ 16r05 16r1E 16r57 16rB0 16r73 16r23 16r51 16r10 16r30 16r83 16r01 \
        16rF2 16r23 16r52 16r22 16rD0 16rF2 16r23 16r53 16r10 16r32 \
        16r83 16r01 16rF2 16r23 16r54 16r10 16r33 16r83 16r01 16rF2 \
        16r23 16r55 16r10 16r34 16r83 16r01 16rF2 16r23 16r56 16r51 \
        16rD0 16rF2 16r23 16r57 16r10 16r35 16r83 16r01 16rF2 16r52 \
        16r21 16r11 16r12 16r13 16r14 16r23 16rFA 16r07 16rEF 16rF2 \
        16r5B 16rF1 16r66 16rF3 16rF5] \
    #( #GT_VisualInfo #at:put:systemTag: #GTBB_FrameType #BBFT_ICONDROPBOX \
        #GTBB_Recessed #TAG_DONE  )) >

<primitive 112 pTempVar 2  " drawRecessedBox:with: " \
  #( #[ 16r05 16r1E 16r55 16rB0 16r73 16r23 16r51 16r10 16r30 16r83 16r01 \
        16rF2 16r23 16r52 16r22 16rD0 16rF2 16r23 16r53 16r10 16r32 \
        16r83 16r01 16rF2 16r23 16r54 16r51 16rD0 16rF2 16r23 16r55 \
        16r10 16r33 16r83 16r01 16rF2 16r52 16r21 16r11 16r12 16r13 \
        16r14 16r23 16rFA 16r07 16rEF 16rF2 16r5B 16rF1 16r66 16rF3 \
        16rF5] \
    #( #GT_VisualInfo #at:put:systemTag: #GTBB_Recessed #TAG_DONE  )) >

<primitive 112 pTempVar 3  " drawDropBox:with: " \
  #( #[ 16r05 16r1E 16r55 16rB0 16r73 16r23 16r51 16r10 16r30 16r83 16r01 \
        16rF2 16r23 16r52 16r22 16rD0 16rF2 16r23 16r53 16r10 16r32 \
        16r83 16r01 16rF2 16r23 16r54 16r10 16r33 16r83 16r01 16rF2 \
        16r23 16r55 16r10 16r34 16r83 16r01 16rF2 16r52 16r21 16r11 \
        16r12 16r13 16r14 16r23 16rFA 16r07 16rEF 16rF2 16r5B 16rF1 \
        16r66 16rF3 16rF5] \
    #( #GT_VisualInfo #at:put:systemTag: #GTBB_FrameType #BBFT_ICONDROPBOX \
        #TAG_DONE  )) >

<primitive 112 pTempVar 4  " drawNormalBox:with: " \
  #( #[ 16r05 16r1E 16r53 16rB0 16r73 16r23 16r51 16r10 16r30 16r83 16r01 \
        16rF2 16r23 16r52 16r22 16rD0 16rF2 16r23 16r53 16r10 16r32 \
        16r83 16r01 16rF2 16r52 16r21 16r11 16r12 16r13 16r14 16r23 \
        16rFA 16r07 16rEF 16rF2 16r5B 16rF1 16r66 16rF3 16rF5] \
    #( #GT_VisualInfo #at:put:systemTag: #TAG_DONE  )) >

<primitive 112 pTempVar 5  " drawBoxOn:with: " \
  #( #[ 16r15 16r30 16rC5 16r73 16r23 16r50 16rC9 16rF7 16r05 16r20 16r21 \
        16r22 16r82 16r01 16rF2 16r23 16r51 16rC9 16rF7 16r05 16r20 \
        16r21 16r22 16r82 16r02 16rF2 16r23 16r52 16rC9 16rF7 16r07 \
        16r20 16r21 16r22 16r82 16r03 16rF8 16r06 16rF2 16r20 16r21 \
        16r22 16r82 16r04 16rF2 16rF5] \
    #( 16r3 #drawNormalBox:with: #drawRecessedBox:with: #drawDropBox:with: \
        #drawRecessedDropBox:with:  )) >

<primitive 112 pTempVar 6  " glyphType " \
  #( #[ 16r30 16rF3 16rF5] \
    #( #BevelBox  )) >

<primitive 112 pTempVar 7  " isDisplayed " \
  #( #[ 16r16 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setupBoxX:y:width:height:flags: " \
  #( #[ 16r40 16rA0 16r60 16r5C 16r66 16r21 16r61 16r22 16r62 16r23 16r63 \
        16r24 16r64 16r25 16r65 16rF5] \
    #( #Intuition  )) >

<primitive 98 #BevelBox \
  <primitive 97 #BevelBox #Glyph #AmigaTalk:Intuition/BevelBox.st \
   #(  #intuition #x #y #w #h #f #displayed ) \
   #( #drawRecessedDropBox:with: #drawRecessedBox:with: #drawDropBox:with:  \
       #drawNormalBox:with: #drawBoxOn:with: #glyphType #isDisplayed  \
       #setupBoxX:y:width:height:flags:  ) \
  pTempVar 6 13 > #ordinary >

pTempVar <- <primitive 110 11 >
<primitive 112 pTempVar 1  " isCapLock " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rC9 16rFB 16r03 16r10 16r32 \
        16rC9 16rF7 16r11 16r10 16r33 16rC9 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16rA2 16rE2 16rE2  )) >

<primitive 112 pTempVar 2  " isRightAmiga " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rC9 16rFB 16r03 16r10 16r32 \
        16rC9 16rF7 16r11 16r10 16r33 16rC9 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16rA7 16rE7 16rE7  )) >

<primitive 112 pTempVar 3  " isLeftAmiga " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rC9 16rFB 16r03 16r10 16r32 \
        16rC9 16rF7 16r11 16r10 16r33 16rC9 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16rA6 16rE6 16rE6  )) >

<primitive 112 pTempVar 4  " isRightArrow " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rC9 16rFB 16r03 16r10 16r32 \
        16rC9 16rF7 16r11 16r10 16r33 16rC9 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16r8E 16rCE 16rCE  )) >

<primitive 112 pTempVar 5  " isLeftArrow " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rC9 16rFB 16r03 16r10 16r32 \
        16rC9 16rF7 16r11 16r10 16r33 16rC9 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16r8F 16rCF 16rCF  )) >

<primitive 112 pTempVar 6  " isDownArrow " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rC9 16rFB 16r03 16r10 16r32 \
        16rC9 16rF7 16r11 16r10 16r33 16rC9 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16r8D 16rCD 16rCD  )) >

<primitive 112 pTempVar 7  " isUpArrow " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rC9 16rFB 16r03 16r10 16r32 \
        16rC9 16rF7 16r11 16r10 16r33 16rC9 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16r8C 16rCC 16rCC  )) >

<primitive 112 pTempVar 8  " isFuncKey " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rCB 16rFC 16r03 16r10 16r32 \
        16rC8 16rFB 16r08 16r10 16r33 16rCB 16rFC 16r03 16r10 16r34 \
        16rC8 16rF7 16r11 16r10 16r35 16rCC 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16r90 16r99 16rD0 16rD9 16r99  )) >

<primitive 112 pTempVar 9  " isHelp " \
  #( #[ 16r20 16r80 16r00 16r60 16r10 16r31 16rC9 16rFB 16r03 16r10 16r32 \
        16rC9 16rF7 16r11 16r10 16r33 16rC9 16rF7 16r05 16r5B 16rF1 \
        16r61 16rF8 16r04 16rF2 16r5C 16rF1 16r61 16rF2 16r5B 16rF3 \
        16rF2 16r5C 16rF3 16rF5] \
    #( #asciiValue 16r9F 16rDF 16rDF  )) >

<primitive 112 pTempVar 10  " isShifted " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " keyValue " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 98 #AmigaChar \
  <primitive 97 #AmigaChar #Char #AmigaTalk:Intuition/AmigaChar.st \
   #(  #myKeyValue #shiftFlag ) \
   #( #isCapLock #isRightAmiga #isLeftAmiga #isRightArrow #isLeftArrow  \
       #isDownArrow #isUpArrow #isFuncKey #isHelp #isShifted #keyValue  ) \
  pTempVar 1 6 > #ordinary >

pTempVar <- <primitive 110 17 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r51 16r21 16rFA 16r02 16rBC 16r60 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " dispose " \
  #( #[ 16r50 16r10 16rFA 16r02 16rBC 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " setNextText: " \
  #( #[ 16r53 16r57 16r21 16r10 16rFA 16r04 16rBC 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " setText: " \
  #( #[ 16r53 16r56 16r21 16r10 16rFA 16r04 16rBC 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " setFont: " \
  #( #[ 16r53 16r55 16r21 16r10 16rFA 16r04 16rBC 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " setITextOrigin: " \
  #( #[ 16r53 16r53 16r21 16r0A 16r31 16r10 16rFA 16r04 16rBC 16rF2 16r53 \
        16r54 16r21 16r0A 16r32 16r10 16rFA 16r04 16rBC 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 7  " setDrawMode: " \
  #( #[ 16r53 16r52 16r21 16r10 16rFA 16r04 16rBC 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setPens: " \
  #( #[ 16r53 16r50 16r21 16r0A 16r31 16r10 16rFA 16r04 16rBC 16rF2 16r53 \
        16r51 16r21 16r0A 16r32 16r10 16rFA 16r04 16rBC 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 9  " getNextTextObject " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " getNextText " \
  #( #[ 16r52 16r57 16r10 16rFA 16r03 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getFontName " \
  #( #[ 16r52 16r55 16r10 16rFA 16r03 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " getITextOrigin " \
  #( #[ 16r52 16r53 16r10 16rFA 16r03 16rBC 16r52 16r54 16r10 16rFA 16r03 \
        16rBC 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 13  " getDrawMode " \
  #( #[ 16r52 16r52 16r10 16rFA 16r03 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " getTextString " \
  #( #[ 16r52 16r56 16r10 16rFA 16r03 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " textSize " \
  #( #[ 16r20 16r80 16r00 16r52 16r59 16r10 16rFA 16r03 16rBC 16r81 16r01 \
        16rF3 16rF5] \
    #( #getTextLength #@  )) >

<primitive 112 pTempVar 16  " getTextLength " \
  #( #[ 16r59 16r10 16rFA 16r02 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " getPens " \
  #( #[ 16r52 16r50 16r10 16rFA 16r03 16rBC 16r52 16r51 16r10 16rFA 16r03 \
        16rBC 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 98 #IText \
  <primitive 97 #IText #Glyph #AmigaTalk:Intuition/IText.st \
   #(  #private ) \
   #( #new: #dispose #setNextText: #setText: #setFont: #setITextOrigin:  \
       #setDrawMode: #setPens: #getNextTextObject #getNextText #getFontName #getITextOrigin  \
       #getDrawMode #getTextString #textSize #getTextLength #getPens  ) \
  pTempVar 2 6 > #ordinary >

pTempVar <- <primitive 110 13 >
<primitive 112 pTempVar 1  " xxNew: " \
  #( #[ 16r55 16r21 16rFA 16r02 16rBC 16r60 16r21 16r61 16r20 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 2  " xxxDispose " \
  #( #[ 16r54 16r10 16rFA 16r02 16rBC 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " fontFlags: " \
  #( #[ 16r57 16r53 16r21 16r10 16rFA 16r04 16rBC 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " fontFlags " \
  #( #[ 16r56 16r53 16r10 16rFA 16r03 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " fontStyle: " \
  #( #[ 16r57 16r52 16r21 16r10 16rFA 16r04 16rBC 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " fontStyle " \
  #( #[ 16r56 16r52 16r10 16rFA 16r03 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " fontYSize: " \
  #( #[ 16r57 16r51 16r21 16r10 16rFA 16r04 16rBC 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " fontYSize " \
  #( #[ 16r56 16r51 16r10 16rFA 16r03 16rBC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " fontName: " \
  #( #[ 16r57 16r50 16r21 16r10 16rFA 16r04 16rBC 16rF2 16r21 16r61 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 10  " fontName " \
  #( #[ 16r56 16r50 16r10 16rFA 16r03 16rBC 16rF1 16r61 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " fontAttributes " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " closeFont " \
  #( #[ 16r30 16r12 16rFA 16r02 16rBC 16rF2 16r20 16r80 16r01 16rF3 16rF5 \
       ] \
    #( 10 #xxxDispose  )) >

<primitive 112 pTempVar 13  " openFont:size:style: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF2 16r20 16r22 16r81 16r01 16rF2 16r20 \
        16r23 16r81 16r02 16rF2 16r58 16r10 16rFA 16r02 16rBC 16r62 \
        16r20 16rF3 16rF5] \
    #( #xxxNew: #fontYSize: #fontStyle:  )) >

<primitive 98 #Font \
  <primitive 97 #Font #Glyph #AmigaTalk:Intuition/Font.st \
   #(  #private #myFontName #diskFont ) \
   #( #xxNew: #xxxDispose #fontFlags: #fontFlags #fontStyle: #fontStyle  \
       #fontYSize: #fontYSize #fontName: #fontName #fontAttributes #closeFont  \
       #openFont:size:style:  ) \
  pTempVar 4 6 > #ordinary >

pTempVar <- <primitive 110 15 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r51 16r21 16rFA 16r02 16rBB 16r60 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " draw " \
  #( #[ 16r56 16r20 16rFA 16r02 16rBB 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " setBorderPoint:to: " \
  #( #[ 16r54 16r21 16r22 16r0A 16r31 16r22 16r0A 16r32 16r10 16rFA 16r05 \
        16rBB 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " setNextBorder: " \
  #( #[ 16r53 16r56 16r21 16r10 16rFA 16r04 16rBB 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " getNextBorder " \
  #( #[ 16r52 16r56 16r10 16rFA 16r03 16rBB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " setCount: " \
  #( #[ 16r53 16r55 16r21 16r10 16rFA 16r04 16rBB 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " getCount " \
  #( #[ 16r52 16r55 16r10 16rFA 16r03 16rBB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setDrawMode: " \
  #( #[ 16r53 16r54 16r21 16r10 16rFA 16r04 16rBB 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " getDrawMode " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rBB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " setBorderPens: " \
  #( #[ 16r53 16r52 16r21 16r0A 16r31 16r10 16rFA 16r04 16rBB 16rF2 16r53 \
        16r53 16r21 16r0A 16r32 16r10 16rFA 16r04 16rBB 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 11  " getBorderPens " \
  #( #[ 16r52 16r52 16r10 16rFA 16r03 16rBB 16r52 16r53 16r10 16rFA 16r03 \
        16rBB 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 12  " getStartPoint " \
  #( #[ 16r52 16r50 16r10 16rFA 16r03 16rBB 16r52 16r51 16r10 16rFA 16r03 \
        16rBB 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 13  " setStartPoint: " \
  #( #[ 16r53 16r50 16r21 16r0A 16r31 16r10 16rFA 16r04 16rBB 16rF2 16r53 \
        16r51 16r21 16r0A 16r32 16r10 16rFA 16r04 16rBB 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 14  " registerTo: " \
  #( #[ 16r55 16r21 16r20 16rFA 16r03 16rBB 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " dispose " \
  #( #[ 16r50 16r10 16rFA 16r02 16rBB 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Border \
  <primitive 97 #Border #Glyph #AmigaTalk:Intuition/Border.st \
   #(  #private #parent ) \
   #( #new: #draw #setBorderPoint:to: #setNextBorder: #getNextBorder  \
       #setCount: #getCount #setDrawMode: #getDrawMode #setBorderPens: #getBorderPens  \
       #getStartPoint #setStartPoint: #registerTo: #dispose  ) \
  pTempVar 3 6 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " makeLineFrom:to: " \
  #( #[ 16r51 16r52 16rFA 16r02 16rBB 16r60 16r20 16r51 16r21 16r92 16r00 \
        16rF2 16r20 16r52 16r22 16r92 16r00 16rF2 16r20 16rF3 16rF5 \
       ] \
    #( #setBorderPoint:to:  )) >

<primitive 98 #Line \
  <primitive 97 #Line #Border #AmigaTalk:Intuition/Border.st \
   #(  #private ) \
   #( #makeLineFrom:to:  ) \
  pTempVar 3 5 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " makeTriangle:vert2:vert3: " \
  #( #[ 16r51 16r54 16rFA 16r02 16rBB 16r60 16r20 16r51 16r21 16r92 16r00 \
        16rF2 16r20 16r52 16r22 16r92 16r00 16rF2 16r20 16r53 16r23 \
        16r92 16r00 16rF2 16r20 16r54 16r21 16r92 16r00 16rF2 16r20 \
        16rF3 16rF5] \
    #( #setBorderPoint:to:  )) >

<primitive 98 #Triangle \
  <primitive 97 #Triangle #Border #AmigaTalk:Intuition/Border.st \
   #(  #private ) \
   #( #makeTriangle:vert2:vert3:  ) \
  pTempVar 4 7 > #ordinary >

pTempVar <- <primitive 110 1 >
<primitive 112 pTempVar 1  " makeRectangleFrom:to: " \
  #( #[ 16r21 16r0A 16r31 16r73 16r21 16r0A 16r32 16r74 16r22 16r0A 16r31 \
        16r75 16r22 16r0A 16r32 16r76 16r51 16r55 16rFA 16r02 16rBB \
        16r60 16r20 16r51 16r23 16r24 16r81 16r00 16r92 16r01 16rF2 \
        16r20 16r52 16r25 16r24 16r81 16r00 16r92 16r01 16rF2 16r20 \
        16r53 16r25 16r26 16r81 16r00 16r92 16r01 16rF2 16r20 16r54 \
        16r23 16r26 16r81 16r00 16r92 16r01 16rF2 16r20 16r55 16r23 \
        16r24 16r81 16r00 16r92 16r01 16rF2 16r20 16rF3 16rF5] \
    #( #@ #setBorderPoint:to:  )) >

<primitive 98 #Rectangle \
  <primitive 97 #Rectangle #Border #AmigaTalk:Intuition/Border.st \
   #(  #private ) \
   #( #makeRectangleFrom:to:  ) \
  pTempVar 7 13 > #ordinary >

pTempVar <- <primitive 110 11 >
<primitive 112 pTempVar 1  " setGadgetUserData:to: " \
  #( #[ 16r53 16r30 16r22 16r21 16rFA 16r04 16rB7 16rF2 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 2  " getGadgetUserData: " \
  #( #[ 16r52 16r05 16r13 16r21 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getGadgetSize: " \
  #( #[ 16r52 16r52 16r21 16rFA 16r03 16rB7 16r72 16r52 16r53 16r21 16rFA \
        16r03 16rB7 16r73 16r22 16r23 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 4  " getStartPoint: " \
  #( #[ 16r52 16r50 16r21 16rFA 16r03 16rB7 16r72 16r52 16r51 16r21 16rFA \
        16r03 16rB7 16r73 16r22 16r23 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 5  " setGadgetSize:to: " \
  #( #[ 16r22 16r0A 16r31 16r73 16r22 16r0A 16r32 16r74 16r53 16r52 16r23 \
        16r21 16rFA 16r04 16rB7 16rF2 16r53 16r53 16r24 16r21 16rFA \
        16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " setStartPoint:to: " \
  #( #[ 16r22 16r0A 16r31 16r73 16r22 16r0A 16r32 16r74 16r53 16r50 16r23 \
        16r21 16rFA 16r04 16rB7 16rF2 16r53 16r51 16r24 16r21 16rFA \
        16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " dispose: " \
  #( #[ 16r50 16r21 16rFA 16r02 16rB7 16rF2 16r55 16r50 16r21 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " gadgetTypeIs: " \
  #( #[ 16r52 16r56 16r21 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " isSelected: " \
  #( #[ 16r10 16rA1 16rF7 16r04 16r40 16rA0 16rF1 16r60 16rF2 16r10 16r31 \
        16r81 16r02 16r72 16r22 16rFC 16r06 16r52 16r54 16r21 16rFA \
        16r03 16rB7 16rF7 16r02 16r5B 16rF3 16rF2 16r5C 16rF3 16rF5 \
       ] \
    #( #Intuition #GFLG_SELECTED #systemTag:  )) >

<primitive 112 pTempVar 10  " isDisabled: " \
  #( #[ 16r10 16rA1 16rF7 16r04 16r40 16rA0 16rF1 16r60 16rF2 16r10 16r31 \
        16r81 16r02 16r72 16r22 16rFC 16r06 16r52 16r54 16r21 16rFA \
        16r03 16rB7 16rF7 16r02 16r5B 16rF3 16rF2 16r5C 16rF3 16rF5 \
       ] \
    #( #Intuition #GFLG_DISABLED #systemTag:  )) >

<primitive 112 pTempVar 11  " getGadgetObject " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'getGadgetObject' #subclassResponsibility:  )) >

<primitive 98 #Gadget \
  <primitive 97 #Gadget #Glyph #AmigaTalk:Intuition/Gadget.st \
   #(  #intuition ) \
   #( #setGadgetUserData:to: #getGadgetUserData: #getGadgetSize:  \
       #getStartPoint: #setGadgetSize:to: #setStartPoint:to: #dispose: #gadgetTypeIs:  \
       #isSelected: #isDisabled: #getGadgetObject  ) \
  pTempVar 5 6 > #ordinary >

pTempVar <- <primitive 110 29 >
<primitive 112 pTempVar 1  " new " \
  #( #[ 16r51 16rFA 16r01 16rB7 16r60 16r05 16r1E 16r53 16rB0 16r61 16r20 \
        16r51 16r81 16r00 16rF2 16r20 16r20 16r11 16r92 16r01 16rF2 \
        16r20 16rF3 16rF5] \
    #( #setGadgetType: #setGadgetUserData:to:  )) >

<primitive 112 pTempVar 2  " setUserMethod: " \
  #( #[ 16r11 16r52 16r21 16rD0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getGadgetValue " \
  #( #[ 16r20 16r20 16r91 16r00 16r71 16r21 16r51 16rB1 16rF3 16rF5] \
    #( #getGadgetUserData:  )) >

<primitive 112 pTempVar 4  " getUserData " \
  #( #[ 16r20 16r20 16r91 16r00 16r71 16r21 16r52 16rB1 16rF3 16rF5] \
    #( #getGadgetUserData:  )) >

<primitive 112 pTempVar 5  " setSelect: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 6  " getSelectObject " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 7  " setRender: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 8  " getRenderObject " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 9  " setGadgetText: " \
  #( #[ 16r53 16r59 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " getGadgetText " \
  #( #[ 16r52 16r05 16r12 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getITextString " \
  #( #[ 16r52 16r59 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " setNextGadget: " \
  #( #[ 16r53 16r58 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " getNextGadget " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " setGadgetID: " \
  #( #[ 16r53 16r57 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " getGadgetID " \
  #( #[ 16r52 16r57 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " setActivation: " \
  #( #[ 16r53 16r55 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " getActivation " \
  #( #[ 16r52 16r55 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " setFlags: " \
  #( #[ 16r53 16r54 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " getFlags " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " getGadgetSize " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getGadgetSize:  )) >

<primitive 112 pTempVar 21  " getStartPoint " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getStartPoint:  )) >

<primitive 112 pTempVar 22  " setGadgetSizeTo: " \
  #( #[ 16r20 16r10 16r21 16r92 16r00 16rF2 16r21 16rF3 16rF5] \
    #( #setGadgetSize:to:  )) >

<primitive 112 pTempVar 23  " setStartPoint: " \
  #( #[ 16r20 16r10 16r21 16r92 16r00 16rF2 16r21 16rF3 16rF5] \
    #( #setStartPoint:to:  )) >

<primitive 112 pTempVar 24  " getGadgetObject " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " setGadgetType: " \
  #( #[ 16r53 16r56 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 26  " gadgetTypeIs " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #gadgetTypeIs:  )) >

<primitive 112 pTempVar 27  " isSelected " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #isSelected:  )) >

<primitive 112 pTempVar 28  " isDisabled " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #isDisabled:  )) >

<primitive 112 pTempVar 29  " dispose " \
  #( #[ 16r20 16r10 16r91 16r00 16rF2 16r5D 16rF3 16rF5] \
    #( #dispose:  )) >

<primitive 98 #BoolGadget \
  <primitive 97 #BoolGadget #Gadget #AmigaTalk:Intuition/Gadget.st \
   #(  #private #userData ) \
   #( #new #setUserMethod: #getGadgetValue #getUserData #setSelect:  \
       #getSelectObject #setRender: #getRenderObject #setGadgetText: #getGadgetText  \
       #getITextString #setNextGadget: #getNextGadget #setGadgetID: #getGadgetID  \
       #setActivation: #getActivation #setFlags: #getFlags #getGadgetSize #getStartPoint  \
       #setGadgetSizeTo: #setStartPoint: #getGadgetObject #setGadgetType: #gadgetTypeIs  \
       #isSelected #isDisabled #dispose  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 31 >
<primitive 112 pTempVar 1  " new " \
  #( #[ 16r51 16rFA 16r01 16rB7 16r60 16r05 16r1E 16r53 16rB0 16r61 16r20 \
        16r54 16r81 16r00 16rF2 16r20 16r20 16r11 16r92 16r01 16rF2 \
        16r20 16rF3 16rF5] \
    #( #setGadgetType: #setGadgetUserData:to:  )) >

<primitive 112 pTempVar 2  " setUserMethod: " \
  #( #[ 16r11 16r52 16r21 16rD0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getGadgetValue " \
  #( #[ 16r20 16r20 16r91 16r00 16r71 16r21 16r51 16rB1 16rF3 16rF5] \
    #( #getGadgetUserData:  )) >

<primitive 112 pTempVar 4  " getUserData " \
  #( #[ 16r20 16r20 16r91 16r00 16r71 16r21 16r52 16rB1 16rF3 16rF5] \
    #( #getGadgetUserData:  )) >

<primitive 112 pTempVar 5  " getGadgetObject " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " setSelect: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 7  " getSelect " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 8  " setRender: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 9  " getRender " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 10  " setGadgetText: " \
  #( #[ 16r53 16r59 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getGadgetText " \
  #( #[ 16r52 16r05 16r12 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " getITextString " \
  #( #[ 16r52 16r59 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " setNextGadget: " \
  #( #[ 16r53 16r58 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " getNextGadget " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " setGadgetID: " \
  #( #[ 16r53 16r57 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " getGadgetID " \
  #( #[ 16r52 16r57 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " setGadgetType: " \
  #( #[ 16r53 16r56 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " setActivation: " \
  #( #[ 16r53 16r55 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " getActivation " \
  #( #[ 16r52 16r55 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " setFlags: " \
  #( #[ 16r53 16r54 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " getFlags " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " getBufferSize " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 23  " setBufferSize: " \
  #( #[ 16r55 16r21 16r10 16rFA 16r03 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " getGadgetSize " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getGadgetSize:  )) >

<primitive 112 pTempVar 25  " getStartPoint " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getStartPoint:  )) >

<primitive 112 pTempVar 26  " setGadgetSizeTo: " \
  #( #[ 16r20 16r10 16r21 16r92 16r00 16rF2 16r21 16rF3 16rF5] \
    #( #setGadgetSize:to:  )) >

<primitive 112 pTempVar 27  " setStartPoint: " \
  #( #[ 16r20 16r10 16r21 16r92 16r00 16rF2 16r21 16rF3 16rF5] \
    #( #setStartPoint:to:  )) >

<primitive 112 pTempVar 28  " gadgetTypeIs " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #gadgetTypeIs:  )) >

<primitive 112 pTempVar 29  " isSelected " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #isSelected:  )) >

<primitive 112 pTempVar 30  " isDisabled " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #isDisabled:  )) >

<primitive 112 pTempVar 31  " dispose " \
  #( #[ 16r20 16r10 16r91 16r00 16rF2 16r5D 16rF3 16rF5] \
    #( #dispose:  )) >

<primitive 98 #StrGadget \
  <primitive 97 #StrGadget #Gadget #AmigaTalk:Intuition/Gadget.st \
   #(  #private #userData ) \
   #( #new #setUserMethod: #getGadgetValue #getUserData #getGadgetObject  \
       #setSelect: #getSelect #setRender: #getRender #setGadgetText: #getGadgetText  \
       #getITextString #setNextGadget: #getNextGadget #setGadgetID: #getGadgetID  \
       #setGadgetType: #setActivation: #getActivation #setFlags: #getFlags #getBufferSize  \
       #setBufferSize: #getGadgetSize #getStartPoint #setGadgetSizeTo: #setStartPoint:  \
       #gadgetTypeIs #isSelected #isDisabled #dispose  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 36 >
<primitive 112 pTempVar 1  " new " \
  #( #[ 16r51 16rFA 16r01 16rB7 16r60 16r05 16r1E 16r53 16rB0 16r61 16r20 \
        16r53 16r81 16r00 16rF2 16r20 16r20 16r11 16r92 16r01 16rF2 \
        16r20 16rF3 16rF5] \
    #( #setGadgetType: #setGadgetUserData:to:  )) >

<primitive 112 pTempVar 2  " setUserMethod: " \
  #( #[ 16r11 16r52 16r21 16rD0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getGadgetValue " \
  #( #[ 16r20 16r20 16r91 16r00 16r71 16r21 16r51 16rB1 16rF3 16rF5] \
    #( #getGadgetUserData:  )) >

<primitive 112 pTempVar 4  " getUserData " \
  #( #[ 16r20 16r20 16r91 16r00 16r71 16r21 16r52 16rB1 16rF3 16rF5] \
    #( #getGadgetUserData:  )) >

<primitive 112 pTempVar 5  " getVBody " \
  #( #[ 16r52 16r05 16r11 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " getHBody " \
  #( #[ 16r52 16r05 16r10 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " getVPot " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 8  " getHPot " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 9  " getPropFlags " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 10  " setSelect: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 11  " getSelect " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 12  " setRender: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 13  " getRender " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 14  " setGadgetText: " \
  #( #[ 16r53 16r59 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " getGadgetText " \
  #( #[ 16r52 16r05 16r12 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " getITextString " \
  #( #[ 16r52 16r59 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " setNextGadget: " \
  #( #[ 16r53 16r58 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " getNextGadget " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " setGadgetID: " \
  #( #[ 16r53 16r57 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " getGadgetID " \
  #( #[ 16r52 16r57 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " setActivation: " \
  #( #[ 16r53 16r55 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " getActivation " \
  #( #[ 16r52 16r55 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " setFlags: " \
  #( #[ 16r53 16r54 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " getFlags " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rB7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " setProps:hPot:vPot:hBody:vBody: " \
  #( #[ 16r56 16r21 16r22 16r23 16r24 16r25 16r10 16rFA 16r07 16rB7 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 26  " modifyProps:hPot:vPot:hBody:vBody:window: " \
  #( #[ 16r54 16r21 16r22 16r23 16r24 16r25 16r26 16r10 16rFA 16r08 16rB7 \
        16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " getGadgetSize " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getGadgetSize:  )) >

<primitive 112 pTempVar 28  " getStartPoint " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getStartPoint:  )) >

<primitive 112 pTempVar 29  " setGadgetSizeTo: " \
  #( #[ 16r20 16r10 16r21 16r92 16r00 16rF2 16r21 16rF3 16rF5] \
    #( #setGadgetSize:to:  )) >

<primitive 112 pTempVar 30  " setStartPoint: " \
  #( #[ 16r20 16r10 16r21 16r92 16r00 16rF2 16r21 16rF3 16rF5] \
    #( #setStartPoint:to:  )) >

<primitive 112 pTempVar 31  " getGadgetObject " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 32  " setGadgetType: " \
  #( #[ 16r53 16r56 16r21 16r10 16rFA 16r04 16rB7 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 33  " gadgetTypeIs " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #gadgetTypeIs:  )) >

<primitive 112 pTempVar 34  " isSelected " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #isSelected:  )) >

<primitive 112 pTempVar 35  " isDisabled " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #isDisabled:  )) >

<primitive 112 pTempVar 36  " dispose " \
  #( #[ 16r20 16r10 16r91 16r00 16rF2 16r5D 16rF3 16rF5] \
    #( #dispose:  )) >

<primitive 98 #PropGadget \
  <primitive 97 #PropGadget #Gadget #AmigaTalk:Intuition/Gadget.st \
   #(  #private #userData ) \
   #( #new #setUserMethod: #getGadgetValue #getUserData #getVBody #getHBody  \
       #getVPot #getHPot #getPropFlags #setSelect: #getSelect #setRender: #getRender  \
       #setGadgetText: #getGadgetText #getITextString #setNextGadget: #getNextGadget  \
       #setGadgetID: #getGadgetID #setActivation: #getActivation #setFlags: #getFlags  \
       #setProps:hPot:vPot:hBody:vBody: #modifyProps:hPot:vPot:hBody:vBody:window: #getGadgetSize  \
       #getStartPoint #setGadgetSizeTo: #setStartPoint: #getGadgetObject #setGadgetType:  \
       #gadgetTypeIs #isSelected #isDisabled #dispose  ) \
  pTempVar 7 9 > #ordinary >

pTempVar <- <primitive 110 32 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r21 16r60 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " disposeArea:y: " \
  #( #[ 16r30 16r10 16r11 16r21 16r22 16rFA 16r05 16rC8 16rF2 16rF5] \
    #( 34  )) >

<primitive 112 pTempVar 3  " outlineOn " \
  #( #[ 16r30 16r10 16rFA 16r02 16rC8 16rF2 16rF5] \
    #( 36  )) >

<primitive 112 pTempVar 4  " outlineOff " \
  #( #[ 16r30 16r10 16rFA 16r02 16rC8 16rF2 16rF5] \
    #( 35  )) >

<primitive 112 pTempVar 5  " setAreaPattern:size: " \
  #( #[ 16r30 16r10 16r21 16r22 16rFA 16r04 16rC8 16rF2 16rF5] \
    #( 32  )) >

<primitive 112 pTempVar 6  " areaEnd " \
  #( #[ 16r30 16r10 16rFA 16r02 16rC8 16rF3 16rF5] \
    #( 31  )) >

<primitive 112 pTempVar 7  " floodFill:at: " \
  #( #[ 16r30 16r10 16r21 16r22 16r0A 16r31 16r22 16r0A 16r32 16rFA 16r05 \
        16rC8 16rF3 16rF5] \
    #( 30  )) >

<primitive 112 pTempVar 8  " drawFilledBoxFrom:to: " \
  #( #[ 16r05 16r1D 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16r22 16r0A \
        16r31 16r22 16r0A 16r32 16rFA 16r06 16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " areaDrawTo: " \
  #( #[ 16r05 16r1C 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16rFA 16r04 \
        16rC8 16rF2 16r21 16r0A 16r31 16r67 16r21 16r0A 16r32 16r68 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " areaMoveTo: " \
  #( #[ 16r05 16r1B 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16rFA 16r04 \
        16rC8 16rF2 16r21 16r0A 16r31 16r67 16r21 16r0A 16r32 16r68 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " drawFilledCircle:radius: " \
  #( #[ 16r05 16r1A 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16r22 16rFA \
        16r05 16rC8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " drawFilledEllipse:minaxis:maxaxis: " \
  #( #[ 16r05 16r19 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16r22 16r23 \
        16rFA 16r06 16rC8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " initializeArea:tmpXSize:tmpYSize: " \
  #( #[ 16r30 16r10 16r21 16r22 16r23 16rFA 16r05 16rC8 16rF1 16r61 16rF3 \
        16rF5] \
    #( 33  )) >

<primitive 112 pTempVar 14  " drawText:at: " \
  #( #[ 16r05 16r13 16r10 16r21 16r22 16r0A 16r31 16r22 16r0A 16r32 16rFA \
        16r05 16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " drawPixelAt: " \
  #( #[ 16r30 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16rFA 16r04 16rC8 \
        16rF2 16r21 16r0A 16r31 16r67 16r21 16r0A 16r32 16r68 16rF5 \
       ] \
    #( 11  )) >

<primitive 112 pTempVar 16  " drawPolygon: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rC8 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 17  " drawEllipse:minaxis:maxaxis: " \
  #( #[ 16r59 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16r22 16r23 16rFA \
        16r06 16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " drawCircle:radius: " \
  #( #[ 16r58 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16r22 16rFA 16r05 \
        16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " drawBoxFrom:to: " \
  #( #[ 16r57 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16r22 16r0A 16r31 \
        16r22 16r0A 16r32 16rFA 16r06 16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " drawLineFrom:to: " \
  #( #[ 16r22 16r0A 16r31 16r73 16r22 16r0A 16r32 16r74 16r56 16r10 16r21 \
        16r0A 16r31 16r21 16r0A 16r32 16r23 16r24 16rFA 16r06 16rC8 \
        16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " drawTo: " \
  #( #[ 16r55 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16rFA 16r04 16rC8 \
        16rF2 16r21 16r0A 16r31 16r67 16r21 16r0A 16r32 16r68 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 22  " movePenTo: " \
  #( #[ 16r54 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16rFA 16r04 16rC8 \
        16rF2 16r21 16r0A 16r31 16r67 16r21 16r0A 16r32 16r68 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 23  " ownerIs " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " location " \
  #( #[ 16r17 16r18 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 25  " getDrawMode " \
  #( #[ 16r15 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 26  " getOPen " \
  #( #[ 16r14 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " getPens " \
  #( #[ 16r12 16r13 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 28  " setLinePattern: " \
  #( #[ 16r05 16r15 16r10 16r21 16rFA 16r03 16rC8 16rF2 16r21 16r66 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 29  " setDrawMode: " \
  #( #[ 16r53 16r10 16r21 16rFA 16r03 16rC8 16rF2 16r21 16r65 16rF5] \
    #(  )) >

<primitive 112 pTempVar 30  " setOPen: " \
  #( #[ 16r52 16r10 16r21 16rFA 16r03 16rC8 16rF2 16r21 16r64 16rF5] \
    #(  )) >

<primitive 112 pTempVar 31  " setBPen: " \
  #( #[ 16r51 16r10 16r21 16rFA 16r03 16rC8 16rF2 16r21 16r63 16rF5] \
    #(  )) >

<primitive 112 pTempVar 32  " setAPen: " \
  #( #[ 16r50 16r10 16r21 16rFA 16r03 16rC8 16rF2 16r21 16r62 16rF5] \
    #(  )) >

<primitive 98 #Painter \
  <primitive 97 #Painter #Glyph #AmigaTalk:Intuition/Painter.st \
   #(  #ownerWindow #private #fPen #bPen #oPen #drawMode #linePattern #x #y ) \
   #( #new: #disposeArea:y: #outlineOn #outlineOff #setAreaPattern:size:  \
       #areaEnd #floodFill:at: #drawFilledBoxFrom:to: #areaDrawTo: #areaMoveTo:  \
       #drawFilledCircle:radius: #drawFilledEllipse:minaxis:maxaxis: #initializeArea:tmpXSize:tmpYSize:  \
       #drawText:at: #drawPixelAt: #drawPolygon: #drawEllipse:minaxis:maxaxis:  \
       #drawCircle:radius: #drawBoxFrom:to: #drawLineFrom:to: #drawTo: #movePenTo: #ownerIs  \
       #location #getDrawMode #getOPen #getPens #setLinePattern: #setDrawMode:  \
       #setOPen: #setBPen: #setAPen:  ) \
  pTempVar 5 7 > #ordinary >

pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " disposeImage " \
  #( #[ 16r30 16r10 16rFA 16r02 16rC8 16rF2 16r5D 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 2  " eraseImageStartingAt: " \
  #( #[ 16r05 16r18 16r11 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16rFA \
        16r05 16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " addImage:height:depth: " \
  #( #[ 16r30 16r11 16r21 16r22 16r23 16rFA 16r05 16rC8 16r60 16r20 16rF3 \
        16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 4  " registerTo: " \
  #( #[ 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " pointInImage: " \
  #( #[ 16r05 16r17 16r10 16r21 16r0A 16r31 16r21 16r0A 16r32 16rFA 16r04 \
        16rC8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " grabImageFrom:startPoint:endPoint: " \
  #( #[ 16r22 16r0A 16r31 16r74 16r22 16r0A 16r32 16r75 16r23 16r0A 16r31 \
        16r76 16r23 16r0A 16r32 16r77 16r05 16r14 16r21 16r24 16r25 \
        16r26 16r27 16r10 16rFA 16r07 16rC8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " setNextImage: " \
  #( #[ 16r30 16r11 16r58 16r21 16r10 16rFA 16r05 16rC8 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 8  " setImagePlaneOnOff: " \
  #( #[ 16r30 16r11 16r57 16r21 16r10 16rFA 16r05 16rC8 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 9  " setImagePlanePick: " \
  #( #[ 16r30 16r11 16r56 16r21 16r10 16rFA 16r05 16rC8 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 10  " getNextImage " \
  #( #[ 16r30 16r11 16r58 16r10 16rFA 16r04 16rC8 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 11  " getImagePlaneOnOff " \
  #( #[ 16r30 16r11 16r57 16r10 16rFA 16r04 16rC8 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 12  " getImagePlanePick " \
  #( #[ 16r30 16r11 16r56 16r10 16rFA 16r04 16rC8 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 13  " getImageDepth " \
  #( #[ 16r30 16r11 16r54 16r10 16rFA 16r04 16rC8 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 14  " saveImageIn: " \
  #( #[ 16r05 16r12 16r11 16r21 16r10 16rFA 16r04 16rC8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " setImageDataFrom: " \
  #( #[ 16r05 16r11 16r11 16r21 16r10 16rFA 16r04 16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " drawImageAt:inState: " \
  #( #[ 16r05 16r16 16r11 16r10 16r22 16r21 16r0A 16r31 16r21 16r0A 16r32 \
        16rFA 16r06 16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " drawImageAt: " \
  #( #[ 16r05 16r10 16r11 16r21 16r0A 16r31 16r21 16r0A 16r32 16r10 16rFA \
        16r05 16rC8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " setImageDepth: " \
  #( #[ 16r30 16r11 16r54 16r21 16r10 16rFA 16r05 16rC8 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 19  " setExtent: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r30 16r11 16r52 \
        16r22 16r10 16rFA 16r05 16rC8 16rF2 16r30 16r11 16r53 16r23 \
        16r10 16rFA 16r05 16rC8 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 20  " setOrigin: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r30 16r11 16r50 \
        16r22 16r10 16rFA 16r05 16rC8 16rF2 16r30 16r11 16r51 16r23 \
        16r10 16rFA 16r05 16rC8 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 21  " getImageSize " \
  #( #[ 16r30 16r11 16r52 16r10 16rFA 16r04 16rC8 16r71 16r30 16r11 16r53 \
        16r10 16rFA 16r04 16rC8 16r72 16r21 16r22 16r81 16r01 16rF3 \
        16rF5] \
    #( 14 #@  )) >

<primitive 112 pTempVar 22  " getStartPoint " \
  #( #[ 16r30 16r11 16r50 16r10 16rFA 16r04 16rC8 16r71 16r30 16r11 16r51 \
        16r10 16rFA 16r04 16rC8 16r72 16r21 16r22 16r81 16r01 16rF3 \
        16rF5] \
    #( 14 #@  )) >

<primitive 112 pTempVar 23  " ownerIs " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Image \
  <primitive 97 #Image #Glyph #AmigaTalk:Intuition/Painter.st \
   #(  #private \
        #ownerWindow ) \
   #( #disposeImage #eraseImageStartingAt: #addImage:height:depth:  \
       #registerTo: #pointInImage: #grabImageFrom:startPoint:endPoint: #setNextImage:  \
       #setImagePlaneOnOff: #setImagePlanePick: #getNextImage #getImagePlaneOnOff  \
       #getImagePlanePick #getImageDepth #saveImageIn: #setImageDataFrom: #drawImageAt:inState:  \
       #drawImageAt: #setImageDepth: #setExtent: #setOrigin: #getImageSize #getStartPoint  \
       #ownerIs  ) \
  pTempVar 8 8 > #ordinary >

pTempVar <- <primitive 110 25 >
<primitive 112 pTempVar 1  " new " \
  #( #[ 16r51 16rFA 16r01 16rB9 16r60 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " dispose " \
  #( #[ 16r50 16r10 16rFA 16r02 16rB9 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " setReqLayer: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB9 16rF2 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 4  " setReqImage: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB9 16rF2 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 5  " setReqBitMap: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB9 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 6  " getReqLayer " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB9 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 7  " getReqImage " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB9 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 8  " getReqBitMap " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB9 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 9  " setReqGadget: " \
  #( #[ 16r53 16r59 16r21 16r10 16rFA 16r04 16rB9 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " getReqGadget " \
  #( #[ 16r52 16r59 16r10 16rFA 16r03 16rB9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " setReqBorder: " \
  #( #[ 16r53 16r30 16r21 16r10 16rFA 16r04 16rB9 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 12  " getReqBorder " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB9 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 13  " setReqText: " \
  #( #[ 16r53 16r58 16r21 16r10 16rFA 16r04 16rB9 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " getReqText " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rB9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " setBackFill: " \
  #( #[ 16r53 16r57 16r21 16r10 16rFA 16r04 16rB9 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " getBackFill " \
  #( #[ 16r52 16r57 16r10 16rFA 16r03 16rB9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " setFlags: " \
  #( #[ 16r53 16r56 16r21 16r10 16rFA 16r04 16rB9 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " getFlags " \
  #( #[ 16r52 16r56 16r10 16rFA 16r03 16rB9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " setRelativePoint: " \
  #( #[ 16r53 16r54 16r21 16r0A 16r31 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r55 16r21 16r0A 16r32 16r10 16rFA 16r04 16rB9 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 20  " getRelativePoint " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rB9 16r52 16r55 16r10 16rFA 16r03 \
        16rB9 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 21  " setReqSize: " \
  #( #[ 16r53 16r52 16r21 16r0A 16r31 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r53 16r21 16r0A 16r32 16r10 16rFA 16r04 16rB9 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 22  " getReqSize " \
  #( #[ 16r52 16r52 16r10 16rFA 16r03 16rB9 16r52 16r53 16r10 16rFA 16r03 \
        16rB9 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 23  " setStartPoint: " \
  #( #[ 16r53 16r50 16r21 16r0A 16r31 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r51 16r21 16r0A 16r32 16r10 16rFA 16r04 16rB9 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 24  " getStartPoint " \
  #( #[ 16r52 16r50 16r10 16rFA 16r03 16rB9 16r52 16r51 16r10 16rFA 16r03 \
        16rB9 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 25  " initialize: " \
  #( #[ 16r53 16r50 16r21 16r51 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r51 16r21 16r52 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r52 16r21 16r53 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r53 16r21 16r54 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r54 16r21 16r55 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r55 16r21 16r56 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r59 16r21 16r57 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r30 16r21 16r58 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r58 16r21 16r59 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r56 16r21 16r30 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r57 16r21 16r31 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r31 16r21 16r32 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r32 16r21 16r33 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r53 \
        16r33 16r21 16r34 16rB1 16r10 16rFA 16r04 16rB9 16rF2 16r20 \
        16rF3 16rF5] \
    #( 10 11 12 13 14  )) >

<primitive 98 #Requester \
  <primitive 97 #Requester #Glyph #AmigaTalk:Intuition/Requester.st \
   #(  #private ) \
   #( #new #dispose #setReqLayer: #setReqImage: #setReqBitMap: #getReqLayer  \
       #getReqImage #getReqBitMap #setReqGadget: #getReqGadget #setReqBorder:  \
       #getReqBorder #setReqText: #getReqText #setBackFill: #getBackFill #setFlags:  \
       #getFlags #setRelativePoint: #getRelativePoint #setReqSize: #getReqSize  \
       #setStartPoint: #getStartPoint #initialize:  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 15 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r51 16r50 16r21 16rFA 16r03 16rB6 16r60 16r21 16r67 16r20 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " setMenuName: " \
  #( #[ 16r53 16r30 16r21 16r50 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r67 \
        16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 3  " getMenuName " \
  #( #[ 16r52 16r30 16r50 16r10 16rFA 16r04 16rB6 16rF1 16r67 16rF3 16rF5 \
       ] \
    #( 13  )) >

<primitive 112 pTempVar 4  " setFirstItem: " \
  #( #[ 16r53 16r59 16r21 16r50 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r68 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " getFirstItem " \
  #( #[ 16r52 16r59 16r50 16r10 16rFA 16r04 16rB6 16rF1 16r68 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 6  " setNextMenu: " \
  #( #[ 16r53 16r58 16r21 16r50 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r61 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " getNextMenu " \
  #( #[ 16r52 16r58 16r50 16r10 16rFA 16r04 16rB6 16rF1 16r61 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 8  " setFlags: " \
  #( #[ 16r53 16r54 16r21 16r50 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r66 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " getFlags " \
  #( #[ 16r52 16r54 16r50 16r10 16rFA 16r04 16rB6 16rF1 16r66 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 10  " dispose " \
  #( #[ 16r50 16r50 16r10 16rFA 16r03 16rB6 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " setMenuSize: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r52 16r22 \
        16r50 16r10 16rFA 16r05 16rB6 16rF2 16r53 16r53 16r23 16r50 \
        16r10 16rFA 16r05 16rB6 16rF2 16r22 16r64 16r23 16r65 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 12  " setStartPoint: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r50 16r22 \
        16r50 16r10 16rFA 16r05 16rB6 16rF2 16r53 16r51 16r23 16r50 \
        16r10 16rFA 16r05 16rB6 16rF2 16r22 16r62 16r23 16r63 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 13  " getMenuSize " \
  #( #[ 16r52 16r52 16r50 16r10 16rFA 16r04 16rB6 16r64 16r52 16r53 16r50 \
        16r10 16rFA 16r04 16rB6 16r65 16r14 16r15 16r81 16r00 16rF3 \
        16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 14  " getStartPoint " \
  #( #[ 16r52 16r50 16r50 16r10 16rFA 16r04 16rB6 16r62 16r52 16r51 16r50 \
        16r10 16rFA 16r04 16rB6 16r63 16r12 16r13 16r81 16r00 16rF3 \
        16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 15  " getMenu " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Menu \
  <primitive 97 #Menu #Glyph #AmigaTalk:Intuition/Menu.st \
   #(  #private #nextMenu #leftEdge #topEdge #width #height #flags #menuName \
        #firstItem ) \
   #( #new: #setMenuName: #getMenuName #setFirstItem: #getFirstItem  \
       #setNextMenu: #getNextMenu #setFlags: #getFlags #dispose #setMenuSize:  \
       #setStartPoint: #getMenuSize #getStartPoint #getMenu  ) \
  pTempVar 4 6 > #ordinary >

pTempVar <- <primitive 110 21 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r51 16r51 16r21 16rFA 16r03 16rB6 16r60 16r21 16r6D 16r20 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " setSubItem: " \
  #( #[ 16r53 16r30 16r21 16r51 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r6B \
        16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 3  " getSubItem " \
  #( #[ 16r52 16r30 16r51 16r10 16rFA 16r04 16rB6 16rF1 16r6B 16rF3 16rF5 \
       ] \
    #( 12  )) >

<primitive 112 pTempVar 4  " setSelectFill: " \
  #( #[ 16r53 16r30 16r21 16r51 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r69 \
        16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 5  " getSelectFill " \
  #( #[ 16r52 16r30 16r51 16r10 16rFA 16r04 16rB6 16rF1 16r69 16rF3 16rF5 \
       ] \
    #( 11  )) >

<primitive 112 pTempVar 6  " setItemFill: " \
  #( #[ 16r53 16r30 16r21 16r51 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r68 \
        16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 7  " getItemFill " \
  #( #[ 16r52 16r30 16r51 16r10 16rFA 16r04 16rB6 16rF1 16r68 16rF3 16rF5 \
       ] \
    #( 10  )) >

<primitive 112 pTempVar 8  " setNextItem: " \
  #( #[ 16r53 16r57 16r21 16r51 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r61 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " getNextItem " \
  #( #[ 16r52 16r57 16r51 16r10 16rFA 16r04 16rB6 16rF1 16r61 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 10  " setCommand: " \
  #( #[ 16r53 16r56 16r21 16r51 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r6A \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getCommand " \
  #( #[ 16r52 16r56 16r51 16r10 16rFA 16r04 16rB6 16rF1 16r6A 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 12  " setMutualExclude: " \
  #( #[ 16r53 16r55 16r21 16r51 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r67 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " getMutualExclude " \
  #( #[ 16r52 16r55 16r51 16r10 16rFA 16r04 16rB6 16rF1 16r67 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 14  " setFlags: " \
  #( #[ 16r53 16r54 16r21 16r51 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r66 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " getFlags " \
  #( #[ 16r52 16r54 16r51 16r10 16rFA 16r04 16rB6 16rF1 16r66 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 16  " setItemSize: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r52 16r22 \
        16r51 16r10 16rFA 16r05 16rB6 16rF2 16r53 16r53 16r23 16r51 \
        16r10 16rFA 16r05 16rB6 16rF2 16r22 16r64 16r23 16r65 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 17  " setStartPoint: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r50 16r22 \
        16r51 16r10 16rFA 16r05 16rB6 16rF2 16r53 16r51 16r23 16r51 \
        16r10 16rFA 16r05 16rB6 16rF2 16r22 16r62 16r23 16r63 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 18  " getItemSize " \
  #( #[ 16r52 16r52 16r51 16r10 16rFA 16r04 16rB6 16r64 16r52 16r53 16r51 \
        16r10 16rFA 16r04 16rB6 16r65 16r14 16r15 16r81 16r00 16rF3 \
        16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 19  " getStartPoint " \
  #( #[ 16r52 16r50 16r51 16r10 16rFA 16r04 16rB6 16r62 16r52 16r51 16r51 \
        16r10 16rFA 16r04 16rB6 16r63 16r12 16r13 16r81 16r00 16rF3 \
        16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 20  " dispose " \
  #( #[ 16r50 16r51 16r10 16rFA 16r03 16rB6 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " getMenuItem " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 98 #MenuItem \
  <primitive 97 #MenuItem #Menu #AmigaTalk:Intuition/Menu.st \
   #(  #private #nextItem #leftEdge #topEdge #width #height #flags \
        #mutualExclude #itemFill #selectFill #command #subItem #nextSelect #itemName ) \
   #( #new: #setSubItem: #getSubItem #setSelectFill: #getSelectFill  \
       #setItemFill: #getItemFill #setNextItem: #getNextItem #setCommand: #getCommand  \
       #setMutualExclude: #getMutualExclude #setFlags: #getFlags #setItemSize: #setStartPoint:  \
       #getItemSize #getStartPoint #dispose #getMenuItem  ) \
  pTempVar 4 6 > #ordinary >

pTempVar <- <primitive 110 19 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r51 16r52 16r21 16rFA 16r03 16rB6 16r60 16r21 16r6C 16r20 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " setSelectFill: " \
  #( #[ 16r53 16r30 16r21 16r52 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r69 \
        16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 3  " getSelectFill " \
  #( #[ 16r52 16r30 16r52 16r10 16rFA 16r04 16rB6 16rF1 16r69 16rF3 16rF5 \
       ] \
    #( 11  )) >

<primitive 112 pTempVar 4  " setItemFill: " \
  #( #[ 16r53 16r30 16r21 16r52 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r68 \
        16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 5  " getItemFill " \
  #( #[ 16r52 16r30 16r52 16r10 16rFA 16r04 16rB6 16rF1 16r68 16rF3 16rF5 \
       ] \
    #( 10  )) >

<primitive 112 pTempVar 6  " setNextItem: " \
  #( #[ 16r53 16r57 16r21 16r52 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r61 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " getNextItem " \
  #( #[ 16r52 16r57 16r52 16r10 16rFA 16r04 16rB6 16rF1 16r61 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 8  " setCommand: " \
  #( #[ 16r53 16r56 16r21 16r52 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r6A \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " getCommand " \
  #( #[ 16r52 16r56 16r52 16r10 16rFA 16r04 16rB6 16rF1 16r6A 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 10  " setMutualExclude: " \
  #( #[ 16r53 16r55 16r21 16r52 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r67 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getMutualExclude " \
  #( #[ 16r52 16r55 16r52 16r10 16rFA 16r04 16rB6 16rF1 16r67 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 12  " setFlags: " \
  #( #[ 16r53 16r54 16r21 16r52 16r10 16rFA 16r05 16rB6 16rF2 16r21 16r66 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " getFlags " \
  #( #[ 16r52 16r54 16r52 16r10 16rFA 16r04 16rB6 16rF1 16r66 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 14  " setSubSize: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r52 16r22 \
        16r52 16r10 16rFA 16r05 16rB6 16rF2 16r53 16r53 16r23 16r52 \
        16r10 16rFA 16r05 16rB6 16rF2 16r22 16r64 16r23 16r65 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 15  " setStartPoint: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r50 16r22 \
        16r52 16r10 16rFA 16r05 16rB6 16rF2 16r53 16r51 16r23 16r52 \
        16r10 16rFA 16r05 16rB6 16rF2 16r22 16r62 16r23 16r63 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 16  " getSubSize " \
  #( #[ 16r52 16r52 16r52 16r10 16rFA 16r04 16rB6 16r64 16r52 16r53 16r52 \
        16r10 16rFA 16r04 16rB6 16r65 16r14 16r15 16r81 16r00 16rF3 \
        16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 17  " getStartPoint " \
  #( #[ 16r52 16r50 16r52 16r10 16rFA 16r04 16rB6 16r62 16r52 16r51 16r52 \
        16r10 16rFA 16r04 16rB6 16r63 16r12 16r13 16r81 16r00 16rF3 \
        16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 18  " dispose " \
  #( #[ 16r50 16r52 16r10 16rFA 16r03 16rB6 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " getSubItem " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 98 #SubItem \
  <primitive 97 #SubItem #MenuItem #AmigaTalk:Intuition/Menu.st \
   #(  \
        #private #nextItem #leftEdge #topEdge #width #height #flags #mutualExclude \
        #itemFill #selectFill #command #nextSelect #subItemName ) \
   #( #new: #setSelectFill: #getSelectFill #setItemFill: #getItemFill  \
       #setNextItem: #getNextItem #setCommand: #getCommand #setMutualExclude:  \
       #getMutualExclude #setFlags: #getFlags #setSubSize: #setStartPoint: #getSubSize  \
       #getStartPoint #dispose #getSubItem  ) \
  pTempVar 4 6 > #ordinary >

pTempVar <- <primitive 110 61 >
<primitive 112 pTempVar 1  " getWindowSignal " \
  #( #[ 16r52 16r05 16r11 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " close " \
  #( #[ 16r50 16r10 16rFA 16r02 16rB5 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " reOpen " \
  #( #[ 16r51 16r12 16r11 16rFA 16r03 16rB5 16rF1 16r60 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " openWindowWithTags: " \
  #( #[ 16r05 16r11 16r21 16rFA 16r02 16rB5 16r60 16r05 16r12 16r10 16rFA \
        16r02 16rB5 16r62 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " openOnScreen: " \
  #( #[ 16r51 16r21 16r11 16rFA 16r03 16rB5 16r60 16r21 16r62 16r10 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " new: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF2 16r20 16rF3 16rF5] \
    #( #setWindowTitle:  )) >

<primitive 112 pTempVar 7  " getScreenTitle " \
  #( #[ 16r52 16r05 16r10 16r10 16rFA 16r03 16rB5 16rF1 16r61 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 8  " setWindowTitle: " \
  #( #[ 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " changeTitle: " \
  #( #[ 16r30 16r21 16r10 16rFA 16r03 16rB5 16rF2 16r21 16r61 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 10  " getTitle " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 11  " getUserData " \
  #( #[ 16r52 16r05 16r17 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " getCheckMarkImage " \
  #( #[ 16r52 16r05 16r16 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " getBorderBottom " \
  #( #[ 16r52 16r05 16r15 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " getBorderRight " \
  #( #[ 16r52 16r05 16r14 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " getBorderTop " \
  #( #[ 16r52 16r05 16r13 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " getBorderLeft " \
  #( #[ 16r52 16r05 16r12 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " setBitMap: " \
  #( #[ 16r53 16r30 16r21 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 18  " getWindowOffset " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB5 16r52 16r31 16r10 16rFA 16r03 \
        16rB5 16r81 16r02 16rF3 16rF5] \
    #( 14 15 #@  )) >

<primitive 112 pTempVar 19  " setCheckMark: " \
  #( #[ 16r53 16r30 16r21 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 20  " getPointerSize " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB5 16r52 16r31 16r10 16rFA 16r03 \
        16rB5 16r81 16r02 16rF3 16rF5] \
    #( 12 13 #@  )) >

<primitive 112 pTempVar 21  " getReqCount " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 22  " setMaxSize: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r30 16r22 \
        16rFA 16r03 16rB5 16rF2 16r53 16r31 16r23 16rFA 16r03 16rB5 \
        16rF2 16rF5] \
    #( 10 11  )) >

<primitive 112 pTempVar 23  " setMinSize: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r58 16r22 \
        16rFA 16r03 16rB5 16rF2 16r53 16r59 16r23 16rFA 16r03 16rB5 \
        16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " setIDCMPFlags: " \
  #( #[ 16r53 16r57 16r21 16rFA 16r03 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " setFlags: " \
  #( #[ 16r53 16r56 16r21 16rFA 16r03 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 26  " setWindowPens: " \
  #( #[ 16r53 16r54 16r21 16r0A 16r31 16rFA 16r03 16rB5 16rF2 16r53 16r55 \
        16r21 16r0A 16r32 16rFA 16r03 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " setWindowSize: " \
  #( #[ 16r53 16r52 16r21 16r0A 16r31 16rFA 16r03 16rB5 16rF2 16r53 16r53 \
        16r21 16r0A 16r32 16rFA 16r03 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 28  " setWindowOrigin: " \
  #( #[ 16r53 16r50 16r21 16r0A 16r31 16rFA 16r03 16rB5 16rF2 16r53 16r51 \
        16r21 16r0A 16r32 16rFA 16r03 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 29  " rethinkDisplay " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'RethinkDisplay'  )) >

<primitive 112 pTempVar 30  " remakeDisplay " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'RemakeDisplay'  )) >

<primitive 112 pTempVar 31  " endRefresh " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'EndRefresh'  )) >

<primitive 112 pTempVar 32  " beginRefresh " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'BeginRefresh'  )) >

<primitive 112 pTempVar 33  " getIDCMPFlags " \
  #( #[ 16r52 16r57 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 34  " getFlags " \
  #( #[ 16r52 16r56 16r10 16rFA 16r03 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 35  " getWindowPens " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rB5 16r52 16r55 16r10 16rFA 16r03 \
        16rB5 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 36  " getWindowSize " \
  #( #[ 16r52 16r52 16r10 16rFA 16r03 16rB5 16r52 16r53 16r10 16rFA 16r03 \
        16rB5 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 37  " getOrigin " \
  #( #[ 16r52 16r50 16r10 16rFA 16r03 16rB5 16r52 16r51 16r10 16rFA 16r03 \
        16rB5 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 38  " changeWindowSize: " \
  #( #[ 16r56 16r30 16r21 16r0A 16r31 16r21 16r0A 16r32 16r10 16rFA 16r05 \
        16rB5 16rF2 16rF5] \
    #( 'SetWindowSize'  )) >

<primitive 112 pTempVar 39  " getUserChoice:title:choices: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rB5 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 40  " yesNoReq:title: " \
  #( #[ 16r30 16r21 16r22 16r31 16rFA 16r04 16rB5 16rF3 16rF5] \
    #( 13 'YES|NO'  )) >

<primitive 112 pTempVar 41  " infoReq:title: " \
  #( #[ 16r30 16r21 16r22 16r31 16rFA 16r04 16rB5 16rF2 16rF5] \
    #( 13 'OKAY'  )) >

<primitive 112 pTempVar 42  " moveWindow: " \
  #( #[ 16r56 16r30 16r21 16r0A 16r31 16r21 16r0A 16r32 16r10 16rFA 16r05 \
        16rB5 16rF2 16rF5] \
    #( 'MoveWindow'  )) >

<primitive 112 pTempVar 43  " removeMenuStrip " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'RemoveMenuStrip'  )) >

<primitive 112 pTempVar 44  " addMenuStrip: " \
  #( #[ 16r55 16r30 16r21 16r10 16rFA 16r04 16rB5 16rF2 16rF5] \
    #( 'AddMenuStrip'  )) >

<primitive 112 pTempVar 45  " showRequester: " \
  #( #[ 16r55 16r30 16r21 16r10 16rFA 16r04 16rB5 16rF2 16rF5] \
    #( 'ShowRequester'  )) >

<primitive 112 pTempVar 46  " windowToFront " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'WindowToFront'  )) >

<primitive 112 pTempVar 47  " windowToBack " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'WindowToBack'  )) >

<primitive 112 pTempVar 48  " handleIntuition " \
  #( #[ 16r05 16r10 16r10 16rFA 16r02 16rB5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 49  " printIText:at: " \
  #( #[ 16r30 16r21 16r22 16r0A 16r31 16r22 16r0A 16r32 16r10 16rFA 16r05 \
        16rB5 16rF2 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 50  " getMouseCoords " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rB5 16r52 16r59 16r10 16rFA 16r03 \
        16rB5 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 51  " reportMouse: " \
  #( #[ 16r21 16r5B 16rB6 16rF7 16r08 16r30 16r51 16r10 16rFA 16r03 16rB5 \
        16rF8 16r07 16rF2 16r30 16r50 16r10 16rFA 16r03 16rB5 16rF2 \
        16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 52  " removeGadget: " \
  #( #[ 16r30 16r21 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 53  " refreshWindowFrame " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'RefreshWindowFrame'  )) >

<primitive 112 pTempVar 54  " refreshGadgets " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 'RefreshGadgets'  )) >

<primitive 112 pTempVar 55  " setFirstGadget: " \
  #( #[ 16r53 16r30 16r21 16rFA 16r03 16rB5 16rF2 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 56  " addGadget: " \
  #( #[ 16r59 16r21 16r10 16rFA 16r03 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 57  " setWindowPointer: " \
  #( #[ 16r05 16r14 16r10 16r21 16rFA 16r03 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 58  " setPointer:size:offset: " \
  #( #[ 16r22 16r0A 16r31 16r74 16r22 16r0A 16r32 16r75 16r23 16r0A 16r31 \
        16r76 16r23 16r0A 16r32 16r77 16r58 16r21 16r25 16r24 16r26 \
        16r27 16r10 16rFA 16r07 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 59  " refreshYourself " \
  #( #[ 16r53 16r52 16r10 16rFA 16r03 16rEF 16rF2 16r20 16r80 16r00 16rF2 \
        16r20 16r80 16r01 16rF2 16r53 16r53 16r10 16r51 16rFA 16r04 \
        16rEF 16rF2 16rF5] \
    #( #refreshGadgets #refreshWindowFrame  )) >

<primitive 112 pTempVar 60  " screen " \
  #( #[ 16r12 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 61  " windowObject " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Window \
  <primitive 97 #Window #Glyph #AmigaTalk:Intuition/Window.st \
   #(  #private #savedTitle #parent ) \
   #( #getWindowSignal #close #reOpen #openWindowWithTags: #openOnScreen:  \
       #new: #getScreenTitle #setWindowTitle: #changeTitle: #getTitle #getUserData  \
       #getCheckMarkImage #getBorderBottom #getBorderRight #getBorderTop #getBorderLeft  \
       #setBitMap: #getWindowOffset #setCheckMark: #getPointerSize #getReqCount  \
       #setMaxSize: #setMinSize: #setIDCMPFlags: #setFlags: #setWindowPens:  \
       #setWindowSize: #setWindowOrigin: #rethinkDisplay #remakeDisplay #endRefresh  \
       #beginRefresh #getIDCMPFlags #getFlags #getWindowPens #getWindowSize #getOrigin  \
       #changeWindowSize: #getUserChoice:title:choices: #yesNoReq:title: #infoReq:title:  \
       #moveWindow: #removeMenuStrip #addMenuStrip: #showRequester: #windowToFront  \
       #windowToBack #handleIntuition #printIText:at: #getMouseCoords #reportMouse:  \
       #removeGadget: #refreshWindowFrame #refreshGadgets #setFirstGadget: #addGadget:  \
       #setWindowPointer: #setPointer:size:offset: #refreshYourself #screen #windowObject  ) \
  pTempVar 8 8 > #ordinary >

pTempVar <- <primitive 110 48 >
<primitive 112 pTempVar 1  " selectAndOpenScreen " \
  #( #[ 16r5E 16r30 16r81 16r01 16rF2 16r5E 16r32 16r81 16r03 16rF2 16r5E \
        16r80 16r04 16r71 16r5E 16r35 16r81 16r03 16rF2 16r5E 16r21 \
        16r81 16r01 16rF2 16r5E 16r80 16r06 16r72 16r20 16r22 16r21 \
        16r82 16r07 16rF3 16rF5] \
    #( 'What is the Title of the Screen?' #setIOMessage: 'Enter a Screen Title:' \
        #setIOTitle: #getString 'Available Screen Modes:' #getScreenModeID \
        #openScreen:title:  )) >

<primitive 112 pTempVar 2  " getScreenErrorString: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rB4 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 3  " unlockPublicScreen:named: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rB4 16rF2 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 4  " lockPublicScreen: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rB4 16rF1 16r60 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 5  " openScreenWithTags: " \
  #( #[ 16r59 16r21 16rFA 16r02 16rB4 16r60 16r20 16r80 16r00 16rF2 16r20 \
        16rF3 16rF5] \
    #( #getTitle  )) >

<primitive 112 pTempVar 6  " openScreen:title: " \
  #( #[ 16r22 16r61 16r20 16r21 16rB0 16rF2 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " new: " \
  #( #[ 16r11 16rA1 16rF7 16r03 16r30 16rF1 16r61 16rF2 16r51 16r21 16r11 \
        16rFA 16r03 16rB4 16r60 16r21 16r62 16r20 16rF3 16rF5] \
    #( 'Default ScreenTitle'  )) >

<primitive 112 pTempVar 8  " open: " \
  #( #[ 16r51 16r12 16r21 16rFA 16r03 16rB4 16r60 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " getScreenModeID " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 10  " setScreenModeID: " \
  #( #[ 16r21 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " thisScreen " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " close " \
  #( #[ 16r50 16r10 16rFA 16r02 16rB4 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " setScreenPens: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r53 16r54 16r22 \
        16rFA 16r03 16rB4 16rF2 16r53 16r55 16r23 16rFA 16r03 16rB4 \
        16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " disposeVisualInfo: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rB4 16rF2 16r55 16r50 16r21 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 15  " getVisualInfo: " \
  #( #[ 16r30 16r21 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 16  " getUserData " \
  #( #[ 16r52 16r05 16r17 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " getWBorBottomSize " \
  #( #[ 16r52 16r05 16r16 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " getWBorRightSize " \
  #( #[ 16r52 16r05 16r15 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " getWBorLeftSize " \
  #( #[ 16r52 16r05 16r14 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " getWBorTopSize " \
  #( #[ 16r52 16r05 16r13 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " getMenuHBorderSize " \
  #( #[ 16r52 16r05 16r12 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " getMenuVBorderSize " \
  #( #[ 16r52 16r05 16r11 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " getBarHBorderSize " \
  #( #[ 16r52 16r05 16r10 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " getBarVBorderSize " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 25  " getBarHeightSize " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 26  " getBitMap " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 27  " getFontObject " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 28  " getFontName " \
  #( #[ 16r52 16r57 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 29  " getDepth " \
  #( #[ 16r52 16r59 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 30  " getTitle " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rB4 16rF1 16r61 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 31  " getViewMode " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 32  " getType " \
  #( #[ 16r52 16r30 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 33  " getFlags " \
  #( #[ 16r52 16r56 16r10 16rFA 16r03 16rB4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 34  " getScreenPens " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rB4 16r52 16r55 16r10 16rFA 16r03 \
        16rB4 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 35  " getScreenSize " \
  #( #[ 16r52 16r52 16r10 16rFA 16r03 16rB4 16r52 16r53 16r10 16rFA 16r03 \
        16rB4 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 36  " getOrigin " \
  #( #[ 16r52 16r50 16r10 16rFA 16r03 16rB4 16r52 16r51 16r10 16rFA 16r03 \
        16rB4 16r81 16r00 16rF3 16rF5] \
    #( #@  )) >

<primitive 112 pTempVar 37  " setBitMap: " \
  #( #[ 16r53 16r30 16r21 16rFA 16r03 16rB4 16rF2 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 38  " setFont: " \
  #( #[ 16r53 16r57 16r21 16rFA 16r03 16rB4 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 39  " setTitle: " \
  #( #[ 16r53 16r58 16r21 16rFA 16r03 16rB4 16rF2 16r21 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 40  " showTitle " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB4 16rF2 16rF5] \
    #( 'ShowTitle'  )) >

<primitive 112 pTempVar 41  " turnOffTitle " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB4 16rF2 16rF5] \
    #( 'TurnOffTitle'  )) >

<primitive 112 pTempVar 42  " screenToFront " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB4 16rF2 16rF5] \
    #( 'ScreenToFront'  )) >

<primitive 112 pTempVar 43  " screenToBack " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB4 16rF2 16rF5] \
    #( 'ScreenToBack'  )) >

<primitive 112 pTempVar 44  " displayBeep " \
  #( #[ 16r54 16r30 16r10 16rFA 16r03 16rB4 16rF2 16rF5] \
    #( 'DisplayBeep'  )) >

<primitive 112 pTempVar 45  " reOpenScreen " \
  #( #[ 16r58 16r11 16rFA 16r02 16rB4 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 46  " redrawScreen " \
  #( #[ 16r57 16r10 16rFA 16r02 16rB4 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 47  " pushScreenDown: " \
  #( #[ 16r56 16r21 16r10 16rFA 16r03 16rB4 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 48  " pullScreenUp: " \
  #( #[ 16r55 16r21 16r10 16rFA 16r03 16rB4 16rF2 16rF5] \
    #(  )) >

<primitive 98 #Screen \
  <primitive 97 #Screen #Glyph #AmigaTalk:Intuition/Screen.st \
   #(  #private #savedTitle #screenModeID ) \
   #( #selectAndOpenScreen #getScreenErrorString: #unlockPublicScreen:named:  \
       #lockPublicScreen: #openScreenWithTags: #openScreen:title: #new: #open: #getScreenModeID  \
       #setScreenModeID: #thisScreen #close #setScreenPens: #disposeVisualInfo: #getVisualInfo:  \
       #getUserData #getWBorBottomSize #getWBorRightSize #getWBorLeftSize #getWBorTopSize  \
       #getMenuHBorderSize #getMenuVBorderSize #getBarHBorderSize #getBarVBorderSize  \
       #getBarHeightSize #getBitMap #getFontObject #getFontName #getDepth #getTitle  \
       #getViewMode #getType #getFlags #getScreenPens #getScreenSize #getOrigin  \
       #setBitMap: #setFont: #setTitle: #showTitle #turnOffTitle #screenToFront  \
       #screenToBack #displayBeep #reOpenScreen #redrawScreen #pushScreenDown:  \
       #pullScreenUp:  ) \
  pTempVar 4 10 > #ordinary >

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

pTempVar <- <primitive 110 2 >
<primitive 112 pTempVar 1  " isDisplayed " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16rF5] \
    #( 'isDisplayed' #subclassResponsibility:  )) >

<primitive 112 pTempVar 2  " glyphType " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16rF5] \
    #( 'glyphType' #subclassResponsibility:  )) >

<primitive 98 #Glyph \
  <primitive 97 #Glyph #Object #AmigaTalk:Intuition/Glyph.st \
   #(  ) \
   #( #isDisplayed #glyphType  ) \
  pTempVar 1 3 > #ordinary >

pTempVar <- <primitive 110 9 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r21 16r61 16r5D 16r60 16r20 16rF3] \
    #(  )) >

<primitive 112 pTempVar 2  " makeColorMap: " \
  #( #[ 16r51 16r10 16r21 16rFA 16r03 16rB8 16r60 16r21 16r62 16r20 16rF3 \
       ] \
    #(  )) >

<primitive 112 pTempVar 3  " saveColorsTo: " \
  #( #[ 16r57 16r11 16r21 16rFA 16r03 16rB8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " copyMap:to:sourceType: " \
  #( #[ 16r56 16r21 16r22 16r23 16rFA 16r04 16rB8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " setMapValue:from:num:red:green:blue: " \
  #( #[ 16r55 16r21 16r22 16r23 16r24 16r25 16r26 16rFA 16r07 16rB8 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " setColorReg:red:green:blue: " \
  #( #[ 16r54 16r11 16r21 16r22 16r23 16r24 16rFA 16r06 16rB8 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 7  " getColor:from:which: " \
  #( #[ 16r53 16r21 16r22 16r23 16rFA 16r04 16rB8 16rF3] \
    #(  )) >

<primitive 112 pTempVar 8  " loadColors:from: " \
  #( #[ 16r52 16r11 16r21 16r22 16rFA 16r04 16rB8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " dispose " \
  #( #[ 16r50 16r10 16rFA 16r02 16rB8 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3] \
    #(  )) >

<primitive 98 #Colors \
  <primitive 97 #Colors #Glyph #AmigaTalk:Intuition/Colors.st \
   #(  #private #parentObj #numberOfColors ) \
   #( #new: #makeColorMap: #saveColorsTo: #copyMap:to:sourceType:  \
       #setMapValue:from:num:red:green:blue: #setColorReg:red:green:blue: #getColor:from:which: #loadColors:from:  \
       #dispose  ) \
  pTempVar 7 8 > #ordinary >

pTempVar <- <primitive 110 13 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r21 16r62 16r5D 16r60 16r5D 16r61 16r20 16rF3] \
    #(  )) >

<primitive 112 pTempVar 2  " makeColorMap: " \
  #( #[ 16r51 16r10 16r21 16rFA 16r03 16rB8 16r60 16r21 16r63 16r20 16rF3 \
       ] \
    #(  )) >

<primitive 112 pTempVar 3  " attachExtraPaletteInfo " \
  #( #[ 16r30 16r10 16r12 16rFA 16r03 16rB8 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 4  " loadRGB32 " \
  #( #[ 16r30 16r12 16r11 16rFA 16r03 16rB8 16rF2 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 5  " makeColorTable:howMany:with: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rB8 16rF1 16r61 16rF3] \
    #( 12  )) >

<primitive 112 pTempVar 6  " getRGB32:howMany:into: " \
  #( #[ 16r30 16r21 16r22 16r23 16r10 16rFA 16r05 16rB8 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 7  " releasePen: " \
  #( #[ 16r30 16r21 16r10 16rFA 16r03 16rB8 16rF2 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 8  " obtainPen:green:blue:flags: " \
  #( #[ 16r30 16r21 16r22 16r23 16r24 16r10 16rFA 16r06 16rB8 16rF3] \
    #( 10  )) >

<primitive 112 pTempVar 9  " obtainBestPenMatch:green:blue:tags: " \
  #( #[ 16r59 16r21 16r22 16r23 16r24 16r10 16rFA 16r06 16rB8 16rF3] \
    #(  )) >

<primitive 112 pTempVar 10  " findColorMatch:green:blue: " \
  #( #[ 16r58 16r21 16r22 16r23 16r10 16rFA 16r05 16rB8 16rF3] \
    #(  )) >

<primitive 112 pTempVar 11  " saveColorsTo: " \
  #( #[ 16r57 16r12 16r21 16rFA 16r03 16rB8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " copyMap:to:sourceType: " \
  #( #[ 16r56 16r21 16r22 16r23 16rFA 16r04 16rB8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " dispose " \
  #( #[ 16r50 16r10 16rFA 16r02 16rB8 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r11 16rA2 16rF7 16r06 16r55 16r50 16r11 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3] \
    #(  )) >

<primitive 98 #LargeColors \
  <primitive 97 #LargeColors #Glyph #AmigaTalk:Intuition/Colors.st \
   #(  #private #private2 #parentObj \
        #numberOfColors ) \
   #( #new: #makeColorMap: #attachExtraPaletteInfo #loadRGB32  \
       #makeColorTable:howMany:with: #getRGB32:howMany:into: #releasePen: #obtainPen:green:blue:flags:  \
       #obtainBestPenMatch:green:blue:tags: #findColorMatch:green:blue: #saveColorsTo: #copyMap:to:sourceType:  \
       #dispose  ) \
  pTempVar 5 7 > #ordinary >

pTempVar <- <primitive 110 55 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF3 16rF5] \
    #( #openIcon:  )) >

<primitive 112 pTempVar 2  " getIcon:tags: " \
  #( #[ 16r30 16r11 16r22 16rFA 16r03 16rDB 16rF1 16r60 16rF3 16rF5] \
    #( 49  )) >

<primitive 112 pTempVar 3  " openIcon: " \
  #( #[ 16r21 16r61 16r51 16r21 16rFA 16r02 16rDB 16rF1 16r60 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 4  " storeIcon:named:tags: " \
  #( #[ 16r30 16r11 16r21 16r23 16rFA 16r04 16rDB 16rF3 16rF5] \
    #( 50  )) >

<primitive 112 pTempVar 5  " closeIcon " \
  #( #[ 16r50 16r10 16r11 16rFA 16r03 16rDB 16r71 16r21 16r5D 16rCA 16rF7 \
        16r02 16r30 16rA8 16rF2 16rF5] \
    #( 'Icon Object was NOT written out!'  )) >

<primitive 112 pTempVar 6  " deleteDiskObject: " \
  #( #[ 16r30 16r11 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 39  )) >

<primitive 112 pTempVar 7  " add:toFreeList:size: " \
  #( #[ 16r30 16r22 16r21 16r23 16rFA 16r04 16rDB 16rF3 16rF5] \
    #( 52  )) >

<primitive 112 pTempVar 8  " disposeFreeList: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rDB 16rF2 16r55 16r50 16r21 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #( 51  )) >

<primitive 112 pTempVar 9  " changeColorToSelectedIconColor: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rDB 16rF2 16rF5] \
    #( 53  )) >

<primitive 112 pTempVar 10  " bumpRevision:to: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rDB 16rF3 16rF5] \
    #( 47  )) >

<primitive 112 pTempVar 11  " layoutIcon:on:tags: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rDB 16rF3 16rF5] \
    #( 44  )) >

<primitive 112 pTempVar 12  " drawIcon:on:label:at:inState:tags: " \
  #( #[ 16r24 16r0A 16r31 16r77 16r24 16r0A 16r32 16r78 16r30 16r22 16r21 \
        16r23 16r27 16r28 16r25 16r26 16rFA 16r08 16rDB 16rF2 16rF5 \
       ] \
    #( 43  )) >

<primitive 112 pTempVar 13  " duplicateDiskObject:tags: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rDB 16rF3 16rF5] \
    #( 40  )) >

<primitive 112 pTempVar 14  " storeDefaultIcon: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 37  )) >

<primitive 112 pTempVar 15  " matchTool:to: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rDB 16rF3 16rF5] \
    #( 46  )) >

<primitive 112 pTempVar 16  " findToolType:in: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rDB 16rF3 16rF5] \
    #( 45  )) >

<primitive 112 pTempVar 17  " iconControl:tags: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rDB 16rF3 16rF5] \
    #( 42  )) >

<primitive 112 pTempVar 18  " writeAsciiImage: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rDB 16r5B 16rCA 16rF7 16r08 16r31 \
        16r21 16r0B 16r12 16r32 16rA8 16r0B 16r12 16rF2 16rF5] \
    #( 35 'Method writeAsciiImage: ' ' failed!'  )) >

<primitive 112 pTempVar 19  " readInAsciiImage: " \
  #( #[ 16r30 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 16r08 \
        16r31 16r21 16r0B 16r12 16r32 16rA8 16r0B 16r12 16rF2 16rF5 \
       ] \
    #( 34 'Method readInAsciiImage: ' ' failed!'  )) >

<primitive 112 pTempVar 20  " setWindowLeftEdge: " \
  #( #[ 16r30 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 16r08 \
        16r31 16r21 16r0B 16r12 16r32 16rA8 16r0B 16r12 16rF2 16rF5 \
       ] \
    #( 33 'Method setWindowLeftEdge: ' ' failed!'  )) >

<primitive 112 pTempVar 21  " setWindowTopEdge: " \
  #( #[ 16r30 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 16r08 \
        16r31 16r21 16r0B 16r12 16r32 16rA8 16r0B 16r12 16rF2 16rF5 \
       ] \
    #( 32 'Method setWindowTopEdge: ' ' failed!'  )) >

<primitive 112 pTempVar 22  " setWindowHeight: " \
  #( #[ 16r30 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 16r08 \
        16r31 16r21 16r0B 16r12 16r32 16rA8 16r0B 16r12 16rF2 16rF5 \
       ] \
    #( 31 'Method setWindowHeight: ' ' failed!'  )) >

<primitive 112 pTempVar 23  " setWindowWidth: " \
  #( #[ 16r30 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 16r08 \
        16r31 16r21 16r0B 16r12 16r32 16rA8 16r0B 16r12 16rF2 16rF5 \
       ] \
    #( 30 'Method setWindowWidth: ' ' failed!'  )) >

<primitive 112 pTempVar 24  " setStackSize: " \
  #( #[ 16r05 16r1D 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 \
        16r08 16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 \
        16rF5] \
    #( 'Method setStackSize: ' ' failed!'  )) >

<primitive 112 pTempVar 25  " setDefaultTool: " \
  #( #[ 16r05 16r1C 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 \
        16r08 16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 \
        16rF5] \
    #( 'Method setDefaultTool: ' ' failed!'  )) >

<primitive 112 pTempVar 26  " setIconType: " \
  #( #[ 16r05 16r1B 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 \
        16r08 16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 \
        16rF5] \
    #( 'Method setIconType: ' ' failed!'  )) >

<primitive 112 pTempVar 27  " setIconAlternateImage: " \
  #( #[ 16r05 16r1A 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 \
        16r02 16r30 16rA8 16rF2 16rF5] \
    #( 'Method setIconAlternateImage: failed!'  )) >

<primitive 112 pTempVar 28  " setIconImage: " \
  #( #[ 16r05 16r19 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 \
        16r02 16r30 16rA8 16rF2 16rF5] \
    #( 'Method setIconImage: failed!'  )) >

<primitive 112 pTempVar 29  " setIconFlags: " \
  #( #[ 16r05 16r18 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 \
        16r08 16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 \
        16rF5] \
    #( 'Method setIconFlags: ' ' failed!'  )) >

<primitive 112 pTempVar 30  " setIconHeight: " \
  #( #[ 16r05 16r17 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 \
        16r08 16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 \
        16rF5] \
    #( 'Method setIconHeight: ' ' failed!'  )) >

<primitive 112 pTempVar 31  " setIconWidth: " \
  #( #[ 16r05 16r16 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5B 16rCA 16rF7 \
        16r08 16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 \
        16rF5] \
    #( 'Method setIconWidth: ' ' failed!'  )) >

<primitive 112 pTempVar 32  " getIconBounds:for:from:label:tags: " \
  #( #[ 16r30 16r23 16r21 16r24 16r22 16r25 16rFA 16r06 16rDB 16rF3 16rF5 \
       ] \
    #( 48  )) >

<primitive 112 pTempVar 33  " getWindowLeftEdge " \
  #( #[ 16r05 16r15 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 34  " getWindowTopEdge " \
  #( #[ 16r05 16r14 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 35  " getWindowHeight " \
  #( #[ 16r05 16r13 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 36  " getWindowWidth " \
  #( #[ 16r05 16r12 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 37  " getStackSize " \
  #( #[ 16r05 16r11 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 38  " getDefaultTool " \
  #( #[ 16r05 16r10 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 39  " getNewDiskObject: " \
  #( #[ 16r30 16r11 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 38  )) >

<primitive 112 pTempVar 40  " newDiskObject: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 41  )) >

<primitive 112 pTempVar 41  " getDefaultIcon: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 36  )) >

<primitive 112 pTempVar 42  " getIconType " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 43  " getIconAlternateImageObject " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 44  " getIconImageObject " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 45  " getIconFlags " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 46  " getIconHeight " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 47  " getIconWidth " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDB 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 48  " deleteToolType: " \
  #( #[ 16r59 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5C 16rB6 16rF7 16r08 \
        16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 16rF5 \
       ] \
    #( 'ToolType ' 'NOT deleted!'  )) >

<primitive 112 pTempVar 49  " addToolType: " \
  #( #[ 16r58 16r10 16r11 16r21 16rFA 16r04 16rDB 16r5C 16rB6 16rF7 16r08 \
        16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 16rF5 \
       ] \
    #( 'ToolType ' 'NOT added!'  )) >

<primitive 112 pTempVar 50  " editIcon: " \
  #( #[ 16r57 16r11 16r21 16rFA 16r03 16rDB 16r5B 16rCA 16rF7 16r08 16r30 \
        16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 16rF5] \
    #( 'Method editIcon: ' 'did NOT run!'  )) >

<primitive 112 pTempVar 51  " moveIcon: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r56 16r10 16r11 \
        16r22 16r23 16rFA 16r05 16rDB 16r74 16r24 16r5D 16rCA 16rF7 \
        16r05 16r30 16r24 16rA8 16r0B 16r12 16rF2 16rF5] \
    #( 'Method moveIcon returned '  )) >

<primitive 112 pTempVar 52  " setIconPosition: " \
  #( #[ 16r21 16r0A 16r31 16r72 16r21 16r0A 16r32 16r73 16r55 16r10 16r11 \
        16r22 16r23 16rFA 16r05 16rDB 16r74 16r24 16r5D 16rCA 16rF7 \
        16r05 16r30 16r24 16rA8 16r0B 16r12 16rF2 16rF5] \
    #( 'Method setIconPosition returned '  )) >

<primitive 112 pTempVar 53  " displayIconImages " \
  #( #[ 16r54 16r10 16r11 16rFA 16r03 16rDB 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 54  " displayIconInfo " \
  #( #[ 16r53 16r10 16r11 16rFA 16r03 16rDB 16r71 16r21 16r5D 16rCA 16rF7 \
        16r05 16r30 16r21 16rA8 16r0B 16r12 16rF2 16rF5] \
    #( 'Method displayIconInfo returned'  )) >

<primitive 112 pTempVar 55  " editToolTypes " \
  #( #[ 16r52 16r11 16rFA 16r02 16rDB 16r71 16r21 16r5B 16rCA 16rF7 16r02 \
        16r30 16rA8 16rF2 16rF5] \
    #( 'ToolTypesEditor NOT found!'  )) >

<primitive 98 #Icon \
  <primitive 97 #Icon #Glyph #AmigaTalk:Intuition/Icon.st \
   #(  #private #iconName ) \
   #( #new: #getIcon:tags: #openIcon: #storeIcon:named:tags: #closeIcon  \
       #deleteDiskObject: #add:toFreeList:size: #disposeFreeList:  \
       #changeColorToSelectedIconColor: #bumpRevision:to: #layoutIcon:on:tags:  \
       #drawIcon:on:label:at:inState:tags: #duplicateDiskObject:tags: #storeDefaultIcon: #matchTool:to:  \
       #findToolType:in: #iconControl:tags: #writeAsciiImage: #readInAsciiImage:  \
       #setWindowLeftEdge: #setWindowTopEdge: #setWindowHeight: #setWindowWidth: #setStackSize:  \
       #setDefaultTool: #setIconType: #setIconAlternateImage: #setIconImage: #setIconFlags:  \
       #setIconHeight: #setIconWidth: #getIconBounds:for:from:label:tags: #getWindowLeftEdge  \
       #getWindowTopEdge #getWindowHeight #getWindowWidth #getStackSize #getDefaultTool  \
       #getNewDiskObject: #newDiskObject: #getDefaultIcon: #getIconType  \
       #getIconAlternateImageObject #getIconImageObject #getIconFlags #getIconHeight #getIconWidth  \
       #deleteToolType: #addToolType: #editIcon: #moveIcon: #setIconPosition:  \
       #displayIconImages #displayIconInfo #editToolTypes  ) \
  pTempVar 9 9 > #ordinary >

pTempVar <- <primitive 110 41 >
<primitive 112 pTempVar 1  " getCollectionData: " \
  #( #[ 16r58 16r51 16r21 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " getCollectionSize: " \
  #( #[ 16r58 16r50 16r21 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getPropertyData: " \
  #( #[ 16r57 16r51 16r21 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " getPropertySize: " \
  #( #[ 16r57 16r50 16r21 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " idToString: " \
  #( #[ 16r56 16r21 16rFA 16r02 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " getErrorString: " \
  #( #[ 16r55 16r21 16rFA 16r02 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " setLocalItemPurge: " \
  #( #[ 16r54 16r57 16r10 16r21 16rFA 16r04 16rF0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " freeLocalItem " \
  #( #[ 16r54 16r56 16r10 16rFA 16r03 16rF0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " findLocalItem:type:id: " \
  #( #[ 16r54 16r55 16r10 16r22 16r23 16r21 16rFA 16r06 16rF0 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 10  " findPropertyContext " \
  #( #[ 16r54 16r54 16r10 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " storeItemInContext " \
  #( #[ 16r54 16r53 16r10 16rFA 16r03 16rF0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " storeLocalItem: " \
  #( #[ 16r54 16r52 16r10 16r21 16rFA 16r04 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " getLocalItemData " \
  #( #[ 16r54 16r51 16r10 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " allocateLocalItem:type:id:size: " \
  #( #[ 16r54 16r50 16r10 16r22 16r23 16r21 16r24 16rFA 16r07 16rF0 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " parentChunk " \
  #( #[ 16r53 16r52 16r10 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " popChunk " \
  #( #[ 16r53 16r51 16r10 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " pushChunk:id:size: " \
  #( #[ 16r53 16r50 16r10 16r21 16r22 16r23 16rFA 16r06 16rF0 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 18  " addExitHandlerHook:for:type:id:position: " \
  #( #[ 16r52 16r30 16r10 16r21 16r22 16r23 16r24 16r25 16rFA 16r08 16rF0 \
        16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 19  " addEntryHandlerHook:for:type:id:position: " \
  #( #[ 16r52 16r30 16r10 16r21 16r22 16r23 16r24 16r25 16rFA 16r08 16rF0 \
        16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 20  " stopOnExit:id: " \
  #( #[ 16r52 16r30 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 21  " findCollection:id: " \
  #( #[ 16r52 16r30 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 22  " collectionChunksWith:size: " \
  #( #[ 16r52 16r05 16r12 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 23  " collectionChunk:id: " \
  #( #[ 16r52 16r30 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 24  " findProperty:id: " \
  #( #[ 16r52 16r30 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 25  " propertyChunksWith:size: " \
  #( #[ 16r52 16r05 16r11 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 26  " propertyChunk:id: " \
  #( #[ 16r52 16r59 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " currentChunk " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 28  " stopChunksWith:size: " \
  #( #[ 16r52 16r05 16r10 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 29  " stopChunk:id: " \
  #( #[ 16r52 16r57 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 30  " writeChunkRecords:size:number: " \
  #( #[ 16r52 16r56 16r10 16r21 16r22 16r23 16rFA 16r06 16rF0 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 31  " writeChunkBytes:size: " \
  #( #[ 16r52 16r55 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 32  " readChunkRecords:size:number: " \
  #( #[ 16r52 16r54 16r10 16r21 16r22 16r23 16rFA 16r06 16rF0 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 33  " readChunkBytes:size: " \
  #( #[ 16r52 16r53 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 34  " parseIFF: " \
  #( #[ 16r52 16r52 16r10 16r21 16rFA 16r04 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 35  " openClipboard: " \
  #( #[ 16r52 16r51 16r10 16r21 16rFA 16r04 16rF0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 36  " closeClipboard " \
  #( #[ 16r52 16r50 16r10 16rFA 16r03 16rF0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 37  " initIFFAsClip " \
  #( #[ 16r51 16r52 16r10 16rFA 16r03 16rF0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 38  " initIFFAsDOS " \
  #( #[ 16r51 16r51 16r10 16rFA 16r03 16rF0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 39  " initIFFHook:flags: " \
  #( #[ 16r51 16r50 16r10 16r21 16r22 16rFA 16r05 16rF0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 40  " openIFF:type:mode: " \
  #( #[ 16r50 16r51 16r21 16r22 16r23 16rFA 16r05 16rF0 16r74 16r24 16rA1 \
        16rF7 16r05 16r30 16rA8 16rF2 16r5D 16rF3 16rF2 16r24 16rF1 \
        16r60 16rF3 16rF5] \
    #( 'Did NOT openIFF (nil returned!).'  )) >

<primitive 112 pTempVar 41  " closeIFF " \
  #( #[ 16r50 16r50 16r10 16rFA 16r03 16rF0 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 98 #BasicIFF \
  <primitive 97 #BasicIFF #Object #AmigaTalk:Intuition/IFF.st \
   #(  #private ) \
   #( #getCollectionData: #getCollectionSize: #getPropertyData:  \
       #getPropertySize: #idToString: #getErrorString: #setLocalItemPurge: #freeLocalItem  \
       #findLocalItem:type:id: #findPropertyContext #storeItemInContext #storeLocalItem:  \
       #getLocalItemData #allocateLocalItem:type:id:size: #parentChunk #popChunk  \
       #pushChunk:id:size: #addExitHandlerHook:for:type:id:position:  \
       #addEntryHandlerHook:for:type:id:position: #stopOnExit:id: #findCollection:id: #collectionChunksWith:size:  \
       #collectionChunk:id: #findProperty:id: #propertyChunksWith:size: #propertyChunk:id:  \
       #currentChunk #stopChunksWith:size: #stopChunk:id: #writeChunkRecords:size:number:  \
       #writeChunkBytes:size: #readChunkRecords:size:number: #readChunkBytes:size: #parseIFF:  \
       #openClipboard: #closeClipboard #initIFFAsClip #initIFFAsDOS #initIFFHook:flags:  \
       #openIFF:type:mode: #closeIFF  ) \
  pTempVar 6 9 > #ordinary >

pTempVar <- <primitive 110 9 >
<primitive 112 pTempVar 1  " obtainVoiceData: " \
  #( #[ 16r10 16r30 16r81 16r01 16r72 16r20 16r22 16r21 16r14 16r13 16r84 \
        16r02 16rF3 16rF5] \
    #( #ID_8SVX #systemTag: #privateObtainChunk:from:id:parent:  )) >

<primitive 112 pTempVar 2  " obtainVHDR: " \
  #( #[ 16r10 16r30 16r81 16r01 16r73 16r10 16r32 16r81 16r01 16r72 16r20 \
        16r23 16r21 16r22 16r13 16r84 16r03 16rF3 16rF5] \
    #( #ID_8SVX #systemTag: #ID_VHDR #privateObtainChunk:from:id:parent:  )) >

<primitive 112 pTempVar 3  " obtainCHRS: " \
  #( #[ 16r10 16r30 16r81 16r01 16r72 16r20 16r15 16r21 16r22 16r13 16r84 \
        16r02 16rF3 16rF5] \
    #( #ID_CHRS #systemTag: #privateObtainChunk:from:id:parent:  )) >

<primitive 112 pTempVar 4  " obtainPixelData: " \
  #( #[ 16r20 16r11 16r21 16r14 16r13 16r84 16r00 16rF3 16rF5] \
    #( #privateObtainChunk:from:id:parent:  )) >

<primitive 112 pTempVar 5  " obtainCAMG: " \
  #( #[ 16r10 16r30 16r81 16r01 16r72 16r20 16r11 16r21 16r22 16r14 16r84 \
        16r02 16rF3 16rF5] \
    #( #ID_CAMG #systemTag: #privateObtainChunk:from:id:parent:  )) >

<primitive 112 pTempVar 6  " obtainCMAP: " \
  #( #[ 16r10 16r30 16r81 16r01 16r72 16r20 16r11 16r21 16r22 16r14 16r84 \
        16r02 16rF3 16rF5] \
    #( #ID_CMAP #systemTag: #privateObtainChunk:from:id:parent:  )) >

<primitive 112 pTempVar 7  " obtainBMHD: " \
  #( #[ 16r10 16r30 16r81 16r01 16r72 16r20 16r11 16r21 16r22 16r14 16r84 \
        16r02 16rF3 16rF5] \
    #( #ID_BMHD #systemTag: #privateObtainChunk:from:id:parent:  )) >

<primitive 112 pTempVar 8  " privateObtainChunk:from:id:parent: " \
  #( #[ 16r20 16r22 16r51 16r12 16r93 16r00 16r75 16r25 16r80 16r01 16rF2 \
        16r25 16r21 16r23 16r82 16r02 16r76 16r26 16r50 16rCA 16rFB \
        16r02 16r26 16rA1 16rF7 16r0C 16r25 16r26 16r81 16r03 16rA8 \
        16rF2 16r25 16r80 16r04 16rF2 16r5D 16rF3 16rF2 16r25 16r21 \
        16r24 16r82 16r05 16r76 16r26 16r50 16rCA 16rFB 16r02 16r26 \
        16rA1 16rF7 16r0C 16r25 16r26 16r81 16r03 16rA8 16rF2 16r25 \
        16r80 16r04 16rF2 16r5D 16rF3 16rF2 16r25 16r10 16r36 16r81 \
        16r07 16r81 16r08 16r76 16r26 16r50 16rCA 16rFB 16r02 16r26 \
        16rA1 16rF7 16r0C 16r25 16r26 16r81 16r03 16rA8 16rF2 16r25 \
        16r80 16r04 16rF2 16r5D 16rF3 16rF2 16r25 16r21 16r23 16r82 \
        16r09 16r77 16r27 16rA1 16rF7 16r09 16r3A 16rA8 16rF2 16r25 \
        16r80 16r04 16rF2 16r5D 16rF3 16rF2 16r25 16r80 16r04 16rF2 \
        16r27 16rF3 16rF5] \
    #( #openIFF:type:mode: #initIFFAsDOS #propertyChunk:id: #getErrorString: \
        #closeIFF #stopChunk:id: #IFFPARSE_SCAN #systemTag: #parseIFF: \
        #findProperty:id: 'NO bitmap header found!'  )) >

<primitive 112 pTempVar 9  " initialize " \
  #( #[ 16r40 16rA0 16r60 16r10 16r31 16r81 16r02 16r64 16r10 16r33 16r81 \
        16r02 16r63 16r10 16r34 16r81 16r02 16r61 16r10 16r35 16r81 \
        16r02 16r65 16r10 16r36 16r81 16r02 16r62 16r20 16rF3 16rF5 \
       ] \
    #( #DataTypeTags #ID_BODY #systemTag: #ID_FORM #ID_ILBM #ID_FTXT \
        #IFFF_READ  )) >

<primitive 98 #ExamineIFF \
  <primitive 97 #ExamineIFF #BasicIFF #AmigaTalk:Intuition/IFF.st \
   #(  #dataTypeTags #ilbm #rmode #form #body #ftxt ) \
   #( #obtainVoiceData: #obtainVHDR: #obtainCHRS: #obtainPixelData:  \
       #obtainCAMG: #obtainCMAP: #obtainBMHD: #privateObtainChunk:from:id:parent:  \
       #initialize  ) \
  pTempVar 8 17 > #ordinary >

pTempVar <- <primitive 110 5 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r21 16r62 16r05 16r1E 16r21 16rB0 16r60 16r20 16rF3] \
    #(  )) >

<primitive 112 pTempVar 2  " append: " \
  #( #[ 16r51 16r12 16rB2 16rE1 16r02 16r0E 16r10 16r22 16rB1 16rA1 16rF7 \
        16r07 16r10 16r22 16r21 16rD0 16rF2 16r20 16rF4 16rF3 16rB3 \
        16rF2 16r20 16rF3] \
    #(  )) >

<primitive 112 pTempVar 3  " hide " \
  #( #[ 16r05 16r16 16r11 16rFA 16r02 16rB5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " attachTo: " \
  #( #[ 16r21 16r80 16r00 16r61 16r05 16r15 16r10 16r11 16rFA 16r03 16rB5 \
        16r72 16r22 16r5B 16rCA 16rF7 16r06 16r31 16rA8 16rF2 16r5D \
        16rF1 16r61 16rF2 16rF5] \
    #( #windowObject 'Menu Strip NOT Attached!!'  )) >

<primitive 112 pTempVar 5  " attachedTo " \
  #( #[ 16r11 16rF3] \
    #(  )) >

<primitive 98 #MenuStrip \
  <primitive 97 #MenuStrip #Object #AmigaTalk:Intuition/NewMenu.st \
   #(  #mStrip #parentWindow #menuSize ) \
   #( #new: #append: #hide #attachTo: #attachedTo  ) \
  pTempVar 3 7 > #ordinary >

pTempVar <- <primitive 110 21 >
<primitive 112 pTempVar 1  " xxxMakeArray:k:f:data: " \
  #( #[ 16r13 16r52 16r21 16rD0 16rF2 16r13 16r53 16r22 16rD0 16rF2 16r13 \
        16r54 16r23 16rD0 16rF2 16r13 16r55 16r50 16rD0 16rF2 16r13 \
        16r56 16r24 16rD0 16rF2 16r13 16rF3] \
    #(  )) >

<primitive 112 pTempVar 2  " subImageArray:key:flags:data: " \
  #( #[ 16r20 16r21 16r22 16r23 16r24 16r84 16r00 16r75 16r25 16r51 16r11 \
        16r31 16r81 16r02 16rD0 16rF2 16r20 16r25 16r81 16r03 16rF2 \
        16r25 16rF3] \
    #( #xxxMakeArray:k:f:data: #IM_SUB #systemTag: #fillNewMenuItemWith:  )) >

<primitive 112 pTempVar 3  " menuImageArray:key:flags:data: " \
  #( #[ 16r20 16r21 16r22 16r23 16r24 16r84 16r00 16r75 16r25 16r51 16r11 \
        16r31 16r81 16r02 16rD0 16rF2 16r20 16r25 16r81 16r03 16rF2 \
        16r25 16rF3] \
    #( #xxxMakeArray:k:f:data: #IM_ITEM #systemTag: #fillNewMenuItemWith:  )) >

<primitive 112 pTempVar 4  " menuItemSpace " \
  #( #[ 16r20 16r5D 16r5D 16r50 16r5D 16r84 16r00 16r71 16r21 16r51 16r11 \
        16r31 16r81 16r02 16rD0 16rF2 16r20 16r21 16r81 16r03 16rF2 \
        16r21 16rF3] \
    #( #xxxMakeArray:k:f:data: #NM_IGNORE #systemTag: #fillNewMenuItemWith:  )) >

<primitive 112 pTempVar 5  " subItemArray:key:flags:data: " \
  #( #[ 16r20 16r21 16r22 16r23 16r24 16r84 16r00 16r75 16r25 16r51 16r11 \
        16r31 16r81 16r02 16rD0 16rF2 16r20 16r25 16r81 16r03 16rF2 \
        16r25 16rF3] \
    #( #xxxMakeArray:k:f:data: #NM_SUB #systemTag: #fillNewMenuItemWith:  )) >

<primitive 112 pTempVar 6  " menuItemArray:key:flags:data: " \
  #( #[ 16r20 16r21 16r22 16r23 16r24 16r84 16r00 16r75 16r25 16r51 16r11 \
        16r31 16r81 16r02 16rD0 16rF2 16r20 16r25 16r81 16r03 16rF2 \
        16r25 16rF3] \
    #( #xxxMakeArray:k:f:data: #NM_ITEM #systemTag: #fillNewMenuItemWith:  )) >

<primitive 112 pTempVar 7  " barLabel " \
  #( #[ 16r20 16r5D 16r5D 16r50 16r5D 16r84 16r00 16r71 16r21 16r51 16r11 \
        16r31 16r81 16r02 16rD0 16rF2 16r20 16r21 16r81 16r03 16rF2 \
        16r21 16rF3] \
    #( #xxxMakeArray:k:f:data: #NM_BARLABEL #systemTag: #fillNewMenuItemWith:  )) >

<primitive 112 pTempVar 8  " titleMenuArray: " \
  #( #[ 16r20 16r21 16r5D 16r50 16r5D 16r84 16r00 16r72 16r22 16r51 16r11 \
        16r31 16r81 16r02 16rD0 16rF2 16r20 16r22 16r81 16r03 16rF2 \
        16r22 16rF3] \
    #( #xxxMakeArray:k:f:data: #NM_TITLE #systemTag: #fillNewMenuItemWith:  )) >

<primitive 112 pTempVar 9  " endOfMenuArray " \
  #( #[ 16r20 16r5D 16r5D 16r50 16r50 16r84 16r00 16r71 16r21 16r51 16r11 \
        16r31 16r81 16r02 16rD0 16rF2 16r21 16rF3] \
    #( #xxxMakeArray:k:f:data: #NM_END #systemTag:  )) >

<primitive 112 pTempVar 10  " fillNewMenuItemWith: " \
  #( #[ 16r51 16r56 16rB2 16rE1 16r02 16r07 16r13 16r22 16r21 16r22 16rB1 \
        16rD0 16rF3 16rB3 16rF2 16r51 16r52 16r51 16r13 16r10 16rFA \
        16r05 16rEF 16r5B 16rCA 16rF7 16r09 16r20 16r80 16r00 16rF2 \
        16r31 16rA8 16rF2 16r5D 16rF3 16rF2 16rF5] \
    #( #xxxDisposeMenu 'ERROR:  Could NOT fill a NewMenu entry!'  )) >

<primitive 112 pTempVar 11  " menuUserData: " \
  #( #[ 16r13 16r56 16r21 16rD0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " testMenu " \
  #( #[ 16r5E 16r30 16r81 16r01 16rF2 16r5E 16r32 16r13 16r52 16rB1 16r0A \
        16r11 16r0B 16r12 16r33 16r0B 16r12 16r81 16r04 16r71 16r21 \
        16r50 16rC9 16rF7 16r04 16r5B 16rF3 16rF8 16r03 16rF2 16r5C \
        16rF3 16rF2 16rF5] \
    #( 'Menu Test Action:' #setIOTitle: 'You selected: "' '" Do you want to continue?' \
        #getUserResponse:  )) >

<primitive 112 pTempVar 13  " initializeControl " \
  #( #[ 16r5D 16rF3] \
    #(  )) >

<primitive 112 pTempVar 14  " value " \
  #( #[ 16r14 16rF3] \
    #(  )) >

<primitive 112 pTempVar 15  " value: " \
  #( #[ 16r21 16rF1 16r64 16rF3] \
    #(  )) >

<primitive 112 pTempVar 16  " xxxMenu " \
  #( #[ 16r10 16r51 16rB1 16rF3] \
    #(  )) >

<primitive 112 pTempVar 17  " registerTo: " \
  #( #[ 16r21 16rA1 16rF7 16r05 16r30 16rA8 16rF2 16r5D 16rF3 16rF2 16r21 \
        16rF1 16r62 16rF3] \
    #( 'NewMenu Object given a nil Window object!'  )) >

<primitive 112 pTempVar 18  " addedTo: " \
  #( #[ 16r21 16r20 16r80 16r00 16r81 16r01 16rF3] \
    #( #xxxMenu #append:  )) >

<primitive 112 pTempVar 19  " new: " \
  #( #[ 16r40 16rA0 16r61 16r05 16r1E 16r56 16rB0 16r63 16r51 16r51 16r51 \
        16rFA 16r03 16rEF 16r60 16r20 16r21 16rB5 16rF2 16r20 16rF3 \
       ] \
    #( #Intuition  )) >

<primitive 112 pTempVar 20  " dispose " \
  #( #[ 16r20 16r80 16r00 16rF2 16r5D 16rF3] \
    #( #xxxDisposeMenu  )) >

<primitive 112 pTempVar 21  " xxxDisposeMenu " \
  #( #[ 16r51 16r50 16r20 16r80 16r00 16rFA 16r03 16rEF 16rF2 16r55 16r50 \
        16r10 16rFA 16r03 16rFA 16rF2 16rF5] \
    #( #xxxMenu  )) >

<primitive 98 #NewMenu \
  <primitive 97 #NewMenu #Object #AmigaTalk:Intuition/NewMenu.st \
   #(  #private #intuition #windowObj #structArray \
        #myAction ) \
   #( #xxxMakeArray:k:f:data: #subImageArray:key:flags:data:  \
       #menuImageArray:key:flags:data: #menuItemSpace #subItemArray:key:flags:data:  \
       #menuItemArray:key:flags:data: #barLabel #titleMenuArray: #endOfMenuArray #fillNewMenuItemWith:  \
       #menuUserData: #testMenu #initializeControl #value #value: #xxxMenu #registerTo:  \
       #addedTo: #new: #dispose #xxxDisposeMenu  ) \
  pTempVar 6 7 > #ordinary >

pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " addGadgetToList:at:type:tags: " \
  #( #[ 16r50 16r54 16r22 16r21 16r23 16r24 16rFA 16r06 16rEF 16r75 16r25 \
        16rA1 16rF7 16r07 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 \
        16rF2 16r20 16r25 16r81 16r02 16rF2 16r25 16rF3] \
    #( 'Ran out of memory for GadTools Gadgets!' #error: #grow:  )) >

<primitive 112 pTempVar 2  " textAttributes " \
  #( #[ 16r14 16rF3] \
    #(  )) >

<primitive 112 pTempVar 3  " visualInfo " \
  #( #[ 16r13 16rF3] \
    #(  )) >

<primitive 112 pTempVar 4  " gadgetContext " \
  #( #[ 16r11 16rF3] \
    #(  )) >

<primitive 112 pTempVar 5  " dispose " \
  #( #[ 16r50 16r50 16r10 16rFA 16r03 16rEF 16rF2 16r5D 16r61 16r5D 16r60 \
        16r12 16rA2 16rF7 16r09 16r50 16r12 16rFA 16r02 16rBE 16rF2 \
        16r5D 16rF1 16r62 16rF2 16r5D 16rF3] \
    #(  )) >

<primitive 112 pTempVar 6  " gadgetList " \
  #( #[ 16r10 16rF3] \
    #(  )) >

<primitive 112 pTempVar 7  " new: " \
  #( #[ 16r12 16rA1 16rF7 16r08 16r51 16r30 16r31 16rFA 16r03 16rBE 16rF1 \
        16r62 16rF2 16r21 16r80 16r02 16r64 16r21 16r80 16r03 16r63 \
        16r50 16r51 16rFA 16r02 16rEF 16r60 16r50 16r52 16r10 16rFA \
        16r03 16rEF 16r61 16r20 16rF3] \
    #( 'gadtools.library' 39 #textAttributes #visualInfo  )) >

<primitive 98 #GadgetSystem \
  <primitive 97 #GadgetSystem #Array #AmigaTalk:Intuition/NewGadget.st \
   #(  #private0 #private1 #library #viObj #textAttr ) \
   #( #addGadgetToList:at:type:tags: #textAttributes #visualInfo  \
       #gadgetContext #dispose #gadgetList #new:  ) \
  pTempVar 6 7 > #ordinary >

pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " xxxSetup: " \
  #( #[ 16r21 16r64 16r5D 16r62 16r5D 16r63 16r5D 16r65 16r5D 16r60 16r05 \
        16r1E 16r30 16rB0 16r61 16r11 16r31 16r21 16rD0 16rF2 16r20 \
        16rF3] \
    #( 12 11  )) >

<primitive 112 pTempVar 2  " xxxSetupStruct:with: " \
  #( #[ 16r20 16r22 16r21 16r82 16r00 16rF2 16r20 16r21 16r81 16r01 16rF3 \
       ] \
    #( #xxxCopy:to: #xxxMakeGadgetWith:  )) >

<primitive 112 pTempVar 3  " xxxCopy:to: " \
  #( #[ 16r51 16r21 16rA3 16rB2 16rE1 16r03 16r07 16r22 16r23 16r21 16r23 \
        16rB1 16rD0 16rF3 16rB3 16rF2 16r22 16rF3] \
    #(  )) >

<primitive 112 pTempVar 4  " xxxMakeGadgetWith: " \
  #( #[ 16r50 16r53 16r21 16r21 16rA3 16rFA 16r04 16rEF 16rF1 16r60 16rF3 \
       ] \
    #(  )) >

<primitive 112 pTempVar 5  " initializeValue: " \
  #( #[ 16r21 16rF1 16r62 16rF3] \
    #(  )) >

<primitive 112 pTempVar 6  " newGadget: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF3] \
    #( #xxxSetup:  )) >

<primitive 112 pTempVar 7  " initializeControl " \
  #( #[ 16r5B 16rF3] \
    #(  )) >

<primitive 112 pTempVar 8  " setValue " \
  #( #[ 16r20 16r50 16r30 16r13 16r15 16r14 16rFA 16r05 16rEF 16rB5 16rF3 \
       ] \
    #( 13  )) >

<primitive 112 pTempVar 9  " addToGList:at:with: " \
  #( #[ 16r21 16r10 16r22 16r11 16r30 16rB1 16r23 16r84 16r01 16r63 16r13 \
        16rF3] \
    #( 11 #addGadgetToList:at:type:tags:  )) >

<primitive 112 pTempVar 10  " setup: " \
  #( #[ 16r20 16r11 16r21 16r82 16r00 16rF3] \
    #( #xxxSetupStruct:with:  )) >

<primitive 112 pTempVar 11  " value " \
  #( #[ 16r12 16rF3] \
    #(  )) >

<primitive 112 pTempVar 12  " value: " \
  #( #[ 16r50 16r30 16r13 16r15 16r21 16rFA 16r05 16rEF 16rF2 16r21 16rF1 \
        16r62 16rF3] \
    #( 14  )) >

<primitive 112 pTempVar 13  " gadgetName " \
  #( #[ 16r14 16r20 16r30 16r81 16r01 16rC9 16rF6 16r06 16r11 16r55 16rB1 \
        16rF3 16rF8 16r05 16rF2 16r11 16r57 16rB1 16rF3 16rF2 16rF5 \
       ] \
    #( #GENERIC_KIND #gadgetTypeFor:  )) >

<primitive 112 pTempVar 14  " gadget " \
  #( #[ 16r13 16rF3] \
    #(  )) >

<primitive 112 pTempVar 15  " gadgetType " \
  #( #[ 16r14 16rF3] \
    #(  )) >

<primitive 112 pTempVar 16  " test: " \
  #( #[ 16r5E 16r30 16r81 16r01 16rF2 16r5E 16r32 16r21 16r0B 16r12 16r33 \
        16r0B 16r12 16r81 16r04 16r72 16r22 16r50 16rC9 16rF7 16r04 \
        16r5B 16rF3 16rF8 16r03 16rF2 16r5C 16rF3 16rF2 16rF5] \
    #( 'Test NewGadget Action:' #setIOTitle: 'You pressed: ' ' Do you want to continue?' \
        #getUserResponse:  )) >

<primitive 112 pTempVar 17  " defaultOrientationFor: " \
  #( #[ 16r16 16rA1 16rF7 16r04 16r40 16rA0 16rF1 16r66 16rF2 16r21 16r31 \
        16rC9 16rF7 16r05 16r16 16r32 16r81 16r03 16rF3 16rF2 16r21 \
        16r34 16rC9 16rF7 16r07 16r16 16r32 16r81 16r03 16rF3 16rF8 \
        16r06 16rF2 16r16 16r35 16r81 16r03 16rF3 16rF2 16rF5] \
    #( #Intuition #SCROLLER_KIND #LORIENT_HORIZ #systemTag: #SLIDER_KIND \
        #LORIENT_NONE  )) >

<primitive 112 pTempVar 18  " gadgetTypeFor: " \
  #( #[ 16r16 16rA1 16rF7 16r04 16r40 16rA0 16rF1 16r66 16rF2 16r16 16r21 \
        16r81 16r01 16rF1 16r64 16rF3] \
    #( #Intuition #systemTag:  )) >

<primitive 112 pTempVar 19  " dispose " \
  #( #[ 16r50 16r57 16r10 16rFA 16r03 16rEF 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3] \
    #(  )) >

<primitive 112 pTempVar 20  " registerTo: " \
  #( #[ 16r21 16rA1 16rF7 16r05 16r30 16rA8 16rF2 16r5D 16rF3 16rF2 16r21 \
        16rF1 16r65 16rF3] \
    #( 'NewGadget Object given a nil Window object!'  )) >

<primitive 112 pTempVar 21  " window " \
  #( #[ 16r15 16rF3] \
    #(  )) >

<primitive 112 pTempVar 22  " isDisplayed " \
  #( #[ 16r15 16rA2 16rF3] \
    #(  )) >

<primitive 112 pTempVar 23  " glyphType " \
  #( #[ 16r14 16rF3] \
    #(  )) >

<primitive 98 #CommonGadget \
  <primitive 97 #CommonGadget #Glyph #AmigaTalk:Intuition/NewGadget.st \
   #(  #nGadStruct #structArray \
        #myAspect #myGadget #gType #windowObj #intuition ) \
   #( #xxxSetup: #xxxSetupStruct:with: #xxxCopy:to: #xxxMakeGadgetWith:  \
       #initializeValue: #newGadget: #initializeControl #setValue #addToGList:at:with: #setup:  \
       #value #value: #gadgetName #gadget #gadgetType #test: #defaultOrientationFor:  \
       #gadgetTypeFor: #dispose #registerTo: #window #isDisplayed #glyphType  ) \
  pTempVar 4 7 > #ordinary >

pTempVar <- <primitive 110 6 >
<primitive 112 pTempVar 1  " testGetFileGadget " \
  #( #[ 16r5E 16r30 16r31 16r82 16r02 16rF2 16r5E 16r80 16r03 16r71 16r34 \
        16r21 16r0B 16r12 16r35 16r0B 16r12 16rA8 16rF2 16r5B 16rF3 \
       ] \
    #( 'Select a file Name...' 'Testing GetFileGadget Class:' #newIO:title: \
        #getFileName '   You selected: "' '" in testing GetFileGadget Class.'  )) >

<primitive 112 pTempVar 2  " buttonPressed " \
  #( #[ 16r20 16rA5 16rF3] \
    #(  )) >

<primitive 112 pTempVar 3  " new: " \
  #( #[ 16r20 16r30 16r91 16r01 16r61 16r20 16r11 16r91 16r02 16rF2 16r20 \
        16r21 16r91 16r03 16rF2 16r20 16rF3] \
    #( #GENERIC_KIND #gadgetTypeFor: #newGadget: #initializeValue:  )) >

<primitive 112 pTempVar 4  " addToGList:at:with: " \
  #( #[ 16r21 16r10 16r22 16r11 16r23 16r84 16r00 16r75 16r50 16r05 16r13 \
        16r25 16r13 16rFA 16r04 16rEF 16r74 16r24 16rA1 16rF7 16r05 \
        16r31 16rA8 16rF2 16r5D 16rF3 16rF2 16r25 16rF3] \
    #( #addGadgetToList:at:type:tags: 'Bad parameter for GetFileGadget setup: method!'  )) >

<primitive 112 pTempVar 5  " setup: " \
  #( #[ 16r21 16r55 16r5D 16rD0 16rF2 16r21 16r56 16r5D 16rD0 16rF2 16r21 \
        16r30 16r5D 16rD0 16rF2 16r20 16r21 16r91 16r01 16r60 16r50 \
        16r32 16rFA 16r02 16rEF 16r62 16r50 16r05 16r10 16r12 16r21 \
        16r59 16rB1 16rFA 16r04 16rEF 16r63 16r10 16rF3] \
    #( 12 #xxxMakeGadgetWith: 15  )) >

<primitive 112 pTempVar 6  " dispose " \
  #( #[ 16r20 16r90 16r00 16rF2 16r50 16r05 16r12 16r13 16rFA 16r03 16rEF \
        16rF2 16r50 16r05 16r11 16r12 16rFA 16r03 16rEF 16rF2 16r5D \
        16r62 16r5D 16r63 16r5D 16rF3] \
    #( #dispose  )) >

<primitive 98 #GetFileGadget \
  <primitive 97 #GetFileGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #private #myType #gClass \
        #gImage ) \
   #( #testGetFileGadget #buttonPressed #new: #addToGList:at:with: #setup:  \
       #dispose  ) \
  pTempVar 6 7 > #ordinary >

pTempVar <- <primitive 110 3 >
<primitive 112 pTempVar 1  " testButtonGadget " \
  #( #[ 16r20 16r20 16r90 16r00 16r91 16r01 16rF3] \
    #( #gadgetName #test:  )) >

<primitive 112 pTempVar 2  " buttonPressed " \
  #( #[ 16r20 16rA5 16rF3] \
    #(  )) >

<primitive 112 pTempVar 3  " new: " \
  #( #[ 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r20 16r21 16r91 \
        16r03 16rF2 16r20 16rF3] \
    #( #BUTTON_KIND #gadgetTypeFor: #newGadget: #initializeValue:  )) >

<primitive 98 #ButtonGadget \
  <primitive 97 #ButtonGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  ) \
   #( #testButtonGadget #buttonPressed #new:  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 3 >
<primitive 112 pTempVar 1  " testCheckBoxGadget " \
  #( #[ 16r20 16r20 16r80 16r00 16r91 16r01 16rF3] \
    #( #gadgetName #test:  )) >

<primitive 112 pTempVar 2  " buttonPressed " \
  #( #[ 16r20 16rA5 16rF3] \
    #(  )) >

<primitive 112 pTempVar 3  " new: " \
  #( #[ 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r20 16r21 16r91 \
        16r03 16rF2 16r20 16rF3] \
    #( #CHECKBOX_KIND #gadgetTypeFor: #newGadget: #initializeValue:  )) >

<primitive 98 #CheckBoxGadget \
  <primitive 97 #CheckBoxGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  ) \
   #( #testCheckBoxGadget #buttonPressed #new:  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " testIntegerGadget " \
  #( #[ 16r20 16rA5 16rF2 16r30 16r10 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16rA8 16rF2 16r5B 16rF3] \
    #( '   User entered: "' '"'  )) >

<primitive 112 pTempVar 2  " value " \
  #( #[ 16r20 16r90 16r00 16rF1 16r60 16rF3] \
    #( #setValue  )) >

<primitive 112 pTempVar 3  " value: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF1 16r60 16rF3] \
    #( #value:  )) >

<primitive 112 pTempVar 4  " new: " \
  #( #[ 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r20 16r21 16r91 \
        16r03 16rF2 16r21 16r60 16r20 16rF3] \
    #( #INTEGER_KIND #gadgetTypeFor: #newGadget: #initializeValue:  )) >

<primitive 98 #IntegerGadget \
  <primitive 97 #IntegerGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #myInteger ) \
   #( #testIntegerGadget #value #value: #new:  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 10 >
<primitive 112 pTempVar 1  " testListViewGadget " \
  #( #[ 16r20 16r80 16r00 16rF2 16r20 16rA5 16r71 16r31 16r21 16r0B 16r12 \
        16rA8 16rF2 16r5B 16rF3] \
    #( #setValue '   You selected list item '  )) >

<primitive 112 pTempVar 2  " setValue " \
  #( #[ 16r20 16r90 16r00 16r72 16r20 16r90 16r01 16r73 16r20 16r90 16r02 \
        16r74 16r50 16r33 16r22 16r24 16r23 16rFA 16r05 16rEF 16r71 \
        16r20 16r21 16r91 16r04 16rF3] \
    #( #gadget #gadgetType #window 13 #value:  )) >

<primitive 112 pTempVar 3  " selectionMade " \
  #( #[ 16r20 16rA5 16rF3] \
    #(  )) >

<primitive 112 pTempVar 4  " listContents " \
  #( #[ 16r13 16rF3] \
    #(  )) >

<primitive 112 pTempVar 5  " initializeControl " \
  #( #[ 16r30 16rA8 16rF2 16r50 16r05 16r19 16r11 16r20 16r90 16r01 16r20 \
        16r90 16r02 16r5D 16rFA 16r06 16rEF 16rF2 16r5B 16rF3] \
    #( 'initializeControl ListView Gadget...' #gadget #window  )) >

<primitive 112 pTempVar 6  " choicesTag " \
  #( #[ 16r11 16rF3] \
    #(  )) >

<primitive 112 pTempVar 7  " value " \
  #( #[ 16r20 16r90 16r00 16r71 16r13 16r21 16rB1 16rF3] \
    #( #value  )) >

<primitive 112 pTempVar 8  " new: " \
  #( #[ 16r21 16r63 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r21 \
        16rA3 16r50 16rCC 16rF7 16r0B 16r21 16rA3 16r60 16r20 16r21 \
        16r81 16r03 16rF2 16r5D 16rF8 16r0D 16rF2 16r53 16r60 16r34 \
        16r72 16r22 16r63 16r20 16r22 16r81 16r03 16rF2 16r5D 16rF2 \
        16r20 16rF3] \
    #( #LISTVIEW_KIND #gadgetTypeFor: #newGadget: #xxxMakePrivateStrings: \
        #( '        ' '        ' '        ' )  )) >

<primitive 112 pTempVar 9  " xxxMakePrivateStrings: " \
  #( #[ 16r50 16r05 16r16 16r21 16rFA 16r03 16rEF 16r62 16r50 16r05 16r17 \
        16r12 16rFA 16r03 16rEF 16rF1 16r61 16rF3] \
    #(  )) >

<primitive 112 pTempVar 10  " dispose " \
  #( #[ 16r50 16r05 16r18 16r11 16r12 16rFA 16r04 16rEF 16rF2 16r20 16r90 \
        16r00 16rF2 16r55 16r50 16r11 16rFA 16r03 16rFA 16rF2 16r55 \
        16r50 16r12 16rFA 16r03 16rFA 16rF2 16r5D 16rF3] \
    #( #dispose  )) >

<primitive 98 #ListViewGadget \
  <primitive 97 #ListViewGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #listSize #listStruct #lvmStruct #listArray ) \
   #( #testListViewGadget #setValue #selectionMade #listContents  \
       #initializeControl #choicesTag #value #new: #xxxMakePrivateStrings: #dispose  ) \
  pTempVar 5 9 > #ordinary >

pTempVar <- <primitive 110 9 >
<primitive 112 pTempVar 1  " testMXGadget " \
  #( #[ 16r20 16r80 16r00 16rF2 16r20 16rA5 16r71 16r31 16r21 16r0B 16r12 \
        16rA8 16rF2 16r5B 16rF3] \
    #( #setValue '   You selected mx item '  )) >

<primitive 112 pTempVar 2  " setValue " \
  #( #[ 16r20 16r90 16r00 16r72 16r20 16r90 16r01 16r73 16r20 16r90 16r02 \
        16r74 16r50 16r33 16r22 16r24 16r23 16rFA 16r05 16rEF 16r71 \
        16r20 16r21 16r91 16r04 16rF3] \
    #( #gadget #gadgetType #window 13 #value:  )) >

<primitive 112 pTempVar 3  " value " \
  #( #[ 16r20 16r90 16r00 16r71 16r12 16r21 16rB1 16rF3] \
    #( #value  )) >

<primitive 112 pTempVar 4  " selectionMade " \
  #( #[ 16r20 16rA5 16rF3] \
    #(  )) >

<primitive 112 pTempVar 5  " choices " \
  #( #[ 16r12 16rF3] \
    #(  )) >

<primitive 112 pTempVar 6  " choicesTag " \
  #( #[ 16r11 16rF3] \
    #(  )) >

<primitive 112 pTempVar 7  " new: " \
  #( #[ 16r21 16r62 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r21 \
        16rA3 16r50 16rCC 16rF7 16r0B 16r21 16rA3 16r60 16r20 16r21 \
        16r81 16r03 16r61 16r5D 16rF8 16r09 16rF2 16r53 16r60 16r20 \
        16r34 16r81 16r03 16r61 16r5D 16rF2 16r20 16rF3] \
    #( #MX_KIND #gadgetTypeFor: #newGadget: #xxxMakePrivStrings: #( '            ' '            ' '            ' )  )) >

<primitive 112 pTempVar 8  " xxxMakePrivStrings: " \
  #( #[ 16r51 16r72 16r51 16r21 16rA3 16rB2 16rE1 16r03 16r0F 16r21 16r23 \
        16rB1 16rA3 16r22 16rCC 16rF7 16r06 16r21 16r23 16rB1 16rA3 \
        16rF1 16r72 16rF3 16rB3 16rF2 16r50 16r05 16r14 16r20 16r90 \
        16r00 16r22 16r21 16rFA 16r05 16rEF 16rF3] \
    #( #gadgetType  )) >

<primitive 112 pTempVar 9  " dispose " \
  #( #[ 16r50 16r05 16r15 16r11 16r20 16r90 16r00 16rFA 16r04 16rEF 16rF2 \
        16r20 16r90 16r01 16rF2 16r55 16r50 16r11 16rFA 16r03 16rFA \
        16rF2 16r5D 16rF3] \
    #( #gadgetType #dispose  )) >

<primitive 98 #MXGadget \
  <primitive 97 #MXGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #listSize \
        #private2 #choiceArray ) \
   #( #testMXGadget #setValue #value #selectionMade #choices #choicesTag  \
       #new: #xxxMakePrivStrings: #dispose  ) \
  pTempVar 5 9 > #ordinary >

pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " testNumberGadget " \
  #( #[ 16r30 16r20 16r90 16r01 16r0A 16r11 16r0B 16r12 16r32 16r0B 16r12 \
        16rA8 16rF2 16r5B 16rF3] \
    #( '   User sees: "' #value '"'  )) >

<primitive 112 pTempVar 2  " value " \
  #( #[ 16r20 16r90 16r00 16rF1 16r60 16rF3] \
    #( #setValue  )) >

<primitive 112 pTempVar 3  " value: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF1 16r60 16rF3] \
    #( #value:  )) >

<primitive 112 pTempVar 4  " new: " \
  #( #[ 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r20 16r21 16r91 \
        16r03 16rF2 16r21 16r60 16r20 16rF3] \
    #( #NUMBER_KIND #gadgetTypeFor: #newGadget: #initializeValue:  )) >

<primitive 98 #NumberGadget \
  <primitive 97 #NumberGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #myNumber ) \
   #( #testNumberGadget #value #value: #new:  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 9 >
<primitive 112 pTempVar 1  " testCycleGadget " \
  #( #[ 16r20 16r80 16r00 16rF2 16r20 16rA5 16r71 16r31 16r21 16r0B 16r12 \
        16rA8 16rF2 16r5B 16rF3] \
    #( #setValue '   You selected item '  )) >

<primitive 112 pTempVar 2  " setValue " \
  #( #[ 16r20 16r90 16r00 16r72 16r20 16r90 16r01 16r73 16r20 16r90 16r02 \
        16r74 16r50 16r33 16r22 16r24 16r23 16rFA 16r05 16rEF 16r71 \
        16r20 16r21 16r91 16r04 16rF3] \
    #( #gadget #gadgetType #window 13 #value:  )) >

<primitive 112 pTempVar 3  " value " \
  #( #[ 16r20 16r90 16r00 16r71 16r12 16r21 16rB1 16rF3] \
    #( #value  )) >

<primitive 112 pTempVar 4  " selectionMade " \
  #( #[ 16r20 16rA5 16rF3] \
    #(  )) >

<primitive 112 pTempVar 5  " choices " \
  #( #[ 16r12 16rF3] \
    #(  )) >

<primitive 112 pTempVar 6  " choicesTag " \
  #( #[ 16r11 16rF3] \
    #(  )) >

<primitive 112 pTempVar 7  " new: " \
  #( #[ 16r21 16r62 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r21 \
        16rA3 16r50 16rCC 16rF7 16r0B 16r21 16rA3 16r60 16r20 16r21 \
        16r81 16r03 16r61 16r5D 16rF8 16r09 16rF2 16r53 16r60 16r20 \
        16r34 16r81 16r03 16r61 16r5D 16rF2 16r20 16rF3] \
    #( #CYCLE_KIND #gadgetTypeFor: #newGadget: #xxxMakePrivStrings: \
        #( '            ' '            ' '            ' )  )) >

<primitive 112 pTempVar 8  " xxxMakePrivStrings: " \
  #( #[ 16r51 16r72 16r51 16r21 16rA3 16rB2 16rE1 16r03 16r0F 16r21 16r23 \
        16rB1 16rA3 16r22 16rCC 16rF7 16r06 16r21 16r23 16rB1 16rA3 \
        16rF1 16r72 16rF3 16rB3 16rF2 16r50 16r05 16r14 16r20 16r90 \
        16r00 16r22 16r21 16rFA 16r05 16rEF 16rF3] \
    #( #gadgetType  )) >

<primitive 112 pTempVar 9  " dispose " \
  #( #[ 16r50 16r05 16r15 16r11 16r20 16r90 16r00 16rFA 16r04 16rEF 16rF2 \
        16r20 16r90 16r01 16rF2 16r55 16r50 16r11 16rFA 16r03 16rFA \
        16rF2 16r5D 16rF3] \
    #( #gadgetType #dispose  )) >

<primitive 98 #CycleGadget \
  <primitive 97 #CycleGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #listSize #private2 #choiceArray ) \
   #( #testCycleGadget #setValue #value #selectionMade #choices #choicesTag  \
       #new: #xxxMakePrivStrings: #dispose  ) \
  pTempVar 5 9 > #ordinary >

pTempVar <- <primitive 110 3 >
<primitive 112 pTempVar 1  " testPaletteGadget " \
  #( #[ 16r20 16r90 16r00 16rF2 16r20 16r90 16r01 16r71 16r32 16r21 16r0A \
        16r11 16r0B 16r12 16rA8 16rF2 16r5B 16rF3] \
    #( #setValue #value '   You selected color number '  )) >

<primitive 112 pTempVar 2  " selectionMade " \
  #( #[ 16r20 16r90 16r00 16rF3] \
    #( #value  )) >

<primitive 112 pTempVar 3  " new: " \
  #( #[ 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r21 16r51 16rCC \
        16rF7 16r03 16r21 16rF1 16r60 16rF2 16r20 16rF3] \
    #( #PALETTE_KIND #gadgetTypeFor: #newGadget:  )) >

<primitive 98 #PaletteGadget \
  <primitive 97 #PaletteGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #numColors ) \
   #( #testPaletteGadget #selectionMade #new:  ) \
  pTempVar 2 6 > #ordinary >

pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " testScrollerGadget " \
  #( #[ 16r30 16r20 16rA5 16r0A 16r11 16r0B 16r12 16r31 16r0B 16r12 16rA8 \
        16rF2 16r5B 16rF3] \
    #( '   User is at: "' '"'  )) >

<primitive 112 pTempVar 2  " value " \
  #( #[ 16r20 16r90 16r00 16rF3] \
    #( #setValue  )) >

<primitive 112 pTempVar 3  " value: " \
  #( #[ 16r21 16r11 16rCC 16rF7 16r03 16r11 16rF1 16r71 16rF2 16r21 16r10 \
        16rC7 16rF7 16r03 16r10 16rF1 16r71 16rF2 16r20 16r21 16r91 \
        16r00 16rF3] \
    #( #value:  )) >

<primitive 112 pTempVar 4  " orientation " \
  #( #[ 16r12 16rF3] \
    #(  )) >

<primitive 112 pTempVar 5  " orientation: " \
  #( #[ 16r21 16rF1 16r62 16rF3] \
    #(  )) >

<primitive 112 pTempVar 6  " setMin:max: " \
  #( #[ 16r21 16r60 16r22 16r61 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " new: " \
  #( #[ 16r21 16r62 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r20 \
        16rF3] \
    #( #SCROLLER_KIND #gadgetTypeFor: #newGadget:  )) >

<primitive 98 #ScrollerGadget \
  <primitive 97 #ScrollerGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  \
        #myMin #myMax #myOrientation ) \
   #( #testScrollerGadget #value #value: #orientation #orientation:  \
       #setMin:max: #new:  ) \
  pTempVar 3 4 > #ordinary >

pTempVar <- <primitive 110 6 >
<primitive 112 pTempVar 1  " testSliderGadget " \
  #( #[ 16r30 16r20 16rA5 16r0A 16r11 16r0B 16r12 16r31 16r0B 16r12 16rA8 \
        16rF2 16r5B 16rF3] \
    #( '   User is at: "' '"'  )) >

<primitive 112 pTempVar 2  " value " \
  #( #[ 16r20 16r90 16r00 16rF3] \
    #( #setValue  )) >

<primitive 112 pTempVar 3  " value: " \
  #( #[ 16r21 16r10 16rCC 16rF7 16r03 16r10 16rF1 16r71 16rF2 16r21 16r11 \
        16rC7 16rF7 16r03 16r11 16rF1 16r71 16rF2 16r20 16r21 16r91 \
        16r00 16rF3] \
    #( #value:  )) >

<primitive 112 pTempVar 4  " initializeControl " \
  #( #[ 16r20 16r90 16r00 16r71 16r20 16r11 16rB5 16rF2 16r21 16r80 16r01 \
        16rF2 16rF5] \
    #( #window #refreshYourself  )) >

<primitive 112 pTempVar 5  " setMin:max: " \
  #( #[ 16r21 16r61 16r22 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " new: " \
  #( #[ 16r21 16r62 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r20 \
        16rF3] \
    #( #SLIDER_KIND #gadgetTypeFor: #newGadget:  )) >

<primitive 98 #SliderGadget \
  <primitive 97 #SliderGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #myMax #myMin #myOrientation ) \
   #( #testSliderGadget #value #value: #initializeControl #setMin:max: #new:  ) \
  pTempVar 3 4 > #ordinary >

pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " testStringGadget " \
  #( #[ 16r20 16r80 16r00 16rF2 16r31 16r10 16r0B 16r12 16r32 16r0B 16r12 \
        16rA8 16rF2 16r5B 16rF3] \
    #( #setValue '   User entered: "' '"'  )) >

<primitive 112 pTempVar 2  " value " \
  #( #[ 16r20 16r90 16r00 16rF1 16r60 16rF3] \
    #( #setValue  )) >

<primitive 112 pTempVar 3  " value: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF1 16r60 16rF3] \
    #( #value:  )) >

<primitive 112 pTempVar 4  " new: " \
  #( #[ 16r21 16r60 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r20 \
        16r21 16r91 16r03 16rF2 16r20 16rF3] \
    #( #STRING_KIND #gadgetTypeFor: #newGadget: #initializeValue:  )) >

<primitive 98 #StringGadget \
  <primitive 97 #StringGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #myString ) \
   #( #testStringGadget #value #value: #new:  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 4 >
<primitive 112 pTempVar 1  " testTextGadget " \
  #( #[ 16r30 16r20 16rA5 16r0B 16r12 16r31 16r0B 16r12 16rA8 16rF2 16r5B \
        16rF3] \
    #( '   User sees: "' '"'  )) >

<primitive 112 pTempVar 2  " value " \
  #( #[ 16r20 16r90 16r00 16rF1 16r60 16rF3] \
    #( #setValue  )) >

<primitive 112 pTempVar 3  " value: " \
  #( #[ 16r20 16r21 16r91 16r00 16rF1 16r60 16rF3] \
    #( #value:  )) >

<primitive 112 pTempVar 4  " new: " \
  #( #[ 16r21 16r60 16r20 16r20 16r30 16r91 16r01 16r91 16r02 16rF2 16r20 \
        16r21 16r91 16r03 16rF2 16r20 16rF3] \
    #( #TEXT_KIND #gadgetTypeFor: #newGadget: #initializeValue:  )) >

<primitive 98 #TextGadget \
  <primitive 97 #TextGadget #CommonGadget #AmigaTalk:Intuition/NewGadget.st \
   #(  #myText ) \
   #( #testTextGadget #value #value: #new:  ) \
  pTempVar 2 5 > #ordinary >

pTempVar <- <primitive 110 18 >
<primitive 112 pTempVar 1  " makeWorkbenchObjectVisible:tags: " \
  #( #[ 16r51 16r30 16r10 16r21 16r22 16rFA 16r05 16rD1 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 2  " changeWorkbenchSelection:hook:tags: " \
  #( #[ 16r51 16r30 16r10 16r21 16r22 16r23 16rFA 16r06 16rD1 16rF3 16rF5 \
       ] \
    #( 12  )) >

<primitive 112 pTempVar 3  " removeAppWindowDropZone:dropZone: " \
  #( #[ 16r51 16r30 16r10 16r21 16r22 16rFA 16r05 16rD1 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 4  " addAppWindowDropZone:id:data:tags: " \
  #( #[ 16r51 16r30 16r10 16r21 16r22 16r23 16r24 16rFA 16r07 16rD1 16rF3 \
        16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 5  " workbenchControl:tags: " \
  #( #[ 16r51 16r59 16r10 16r21 16r22 16rFA 16r05 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " closeWorkbenchObject:tags: " \
  #( #[ 16r51 16r50 16r10 16r21 16r22 16rFA 16r05 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " openWorkbenchObject:tags: " \
  #( #[ 16r51 16r51 16r10 16r21 16r22 16rFA 16r05 16rD1 16rF3 16rF5] \
    #(  )) >
