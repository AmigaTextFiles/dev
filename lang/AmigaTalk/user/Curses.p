pTempVar <- <primitive 110 87 >
<primitive 112 pTempVar 1  " moveCursorFrom:to: " \
  #( #[ 16r05 16r52 16r21 16r0A 16r32 16r21 16r0A 16r31 16r22 16r0A 16r32 \
        16r22 16r0A 16r31 16rFA 16r05 16r7C 16rF2 16r20 16r80 16r00 \
        16rF3 16rF5] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 2  " flushKeys " \
  #( #[ 16r05 16r51 16rFA 16r01 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " updateWindows " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 4  " addToRefreshList: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 5  " moveWindowCursor:to: " \
  #( #[ 16r05 16r3F 16r21 16r22 16r0A 16r32 16r22 16r0A 16r31 16rFA 16r04 \
        16r7C 16rF2 16r20 16r21 16r81 16r00 16rF3 16rF5] \
    #( #refreshWindow:  )) >

<primitive 112 pTempVar 6  " moveCursorTo: " \
  #( #[ 16r05 16r3F 16r21 16r0A 16r32 16r21 16r0A 16r31 16rFA 16r03 16r7C \
        16rF2 16r20 16r80 16r00 16rF3 16rF5] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 7  " deleteWindowLine: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 \
        16rF5] \
    #( 36 #refreshWindow:  )) >

<primitive 112 pTempVar 8  " deleteLine " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 35 #refreshScreen  )) >

<primitive 112 pTempVar 9  " insertWindowLine: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 \
        16rF5] \
    #( 30 #refreshWindow:  )) >

<primitive 112 pTempVar 10  " insertLine " \
  #( #[ 16r05 16r1D 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r00 16rF3 16rF5 \
       ] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 11  " insertWindowChar:at: " \
  #( #[ 16r05 16r1C 16r21 16r22 16r0A 16r32 16r22 16r0A 16r31 16rFA 16r04 \
        16r7C 16rF2 16r20 16r21 16r81 16r00 16rF3 16rF5] \
    #( #refreshWindow:  )) >

<primitive 112 pTempVar 12  " insertCharAt: " \
  #( #[ 16r05 16r1B 16r21 16r0A 16r32 16r21 16r0A 16r31 16rFA 16r03 16r7C \
        16rF2 16r20 16r80 16r00 16rF3 16rF5] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 13  " insertWindowChar: " \
  #( #[ 16r05 16r1A 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r00 \
        16rF3 16rF5] \
    #( #refreshWindow:  )) >

<primitive 112 pTempVar 14  " insertChar " \
  #( #[ 16r05 16r19 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r00 16rF3 16rF5 \
       ] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 15  " readWindowChar:at: " \
  #( #[ 16r05 16r18 16r21 16r22 16r0A 16r32 16r22 16r0A 16r31 16rFA 16r04 \
        16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " readCharAt: " \
  #( #[ 16r05 16r17 16r21 16r0A 16r32 16r21 16r0A 16r31 16rFA 16r03 16r7C \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " readWindowChar: " \
  #( #[ 16r05 16r16 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " readChar " \
  #( #[ 16r05 16r15 16rFA 16r01 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " getWindowString:at:buffer: " \
  #( #[ 16r05 16r10 16r21 16r22 16r0A 16r32 16r22 16r0A 16r31 16r23 16rFA \
        16r05 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " getStringAt:buffer: " \
  #( #[ 16r05 16r13 16r21 16r0A 16r32 16r21 16r0A 16r31 16r22 16rFA 16r04 \
        16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " getWindowString:buffer: " \
  #( #[ 16r05 16r12 16r21 16r22 16rFA 16r03 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " getString: " \
  #( #[ 16r05 16r11 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " getWindowChar:at: " \
  #( #[ 16r05 16r10 16r21 16r22 16r0A 16r32 16r22 16r0A 16r31 16rFA 16r04 \
        16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " getCharAt: " \
  #( #[ 16r30 16r21 16r0A 16r32 16r21 16r0A 16r31 16rFA 16r03 16r7C 16rF3 \
        16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 25  " getWindowChar: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 26  " getChar " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 27  " deleteWindowChar:at: " \
  #( #[ 16r30 16r21 16r22 16r0A 16r32 16r22 16r0A 16r31 16rFA 16r04 16r7C \
        16rF2 16r20 16r21 16r81 16r01 16rF3 16rF5] \
    #( 34 #refreshWindow:  )) >

<primitive 112 pTempVar 28  " deleteCharAt: " \
  #( #[ 16r30 16r21 16r0A 16r32 16r21 16r0A 16r31 16rFA 16r03 16r7C 16rF2 \
        16r20 16r80 16r01 16rF3 16rF5] \
    #( 33 #refreshScreen  )) >

<primitive 112 pTempVar 29  " deleteWindowChar: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 \
        16rF5] \
    #( 32 #refreshWindow:  )) >

<primitive 112 pTempVar 30  " deleteChar " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 31 #refreshScreen  )) >

<primitive 112 pTempVar 31  " clearWindowToEOL: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 \
        16rF5] \
    #( 52 #refreshWindow:  )) >

<primitive 112 pTempVar 32  " clearScreenToEOL " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 51 #refreshScreen  )) >

<primitive 112 pTempVar 33  " clearWindowToBottom: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 \
        16rF5] \
    #( 50 #refreshWindow:  )) >

<primitive 112 pTempVar 34  " clearScreenToBottom " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 49 #refreshScreen  )) >

<primitive 112 pTempVar 35  " clearWindow: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 \
        16rF5] \
    #( 48 #refreshWindow:  )) >

<primitive 112 pTempVar 36  " clearScreen " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 47 #refreshScreen  )) >

<primitive 112 pTempVar 37  " emptyWindow: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 \
        16rF5] \
    #( 46 #refreshWindow:  )) >

<primitive 112 pTempVar 38  " emptyScreen " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 45 #refreshScreen  )) >

<primitive 112 pTempVar 39  " revertWindowColors: " \
  #( #[ 16r05 16r3E 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r00 \
        16rF3 16rF5] \
    #( #refreshWindow:  )) >

<primitive 112 pTempVar 40  " revertColors " \
  #( #[ 16r05 16r3D 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r00 16rF3 16rF5 \
       ] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 41  " invertWindowColors: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 \
        16rF5] \
    #( 60 #refreshWindow:  )) >

<primitive 112 pTempVar 42  " invertColors " \
  #( #[ 16r30 16rFA 16r01 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 59 #refreshScreen  )) >

<primitive 112 pTempVar 43  " removeWindowAttributes:attr: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16r7C 16rF2 16r20 16r21 16r81 16r01 \
        16rF3 16rF5] \
    #( 58 #refreshWindow:  )) >

<primitive 112 pTempVar 44  " removeAttributes: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5 \
       ] \
    #( 57 #refreshScreen  )) >

<primitive 112 pTempVar 45  " addWindowAttributes:attr: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16r7C 16rF2 16r20 16r21 16r81 16r01 \
        16rF3 16rF5] \
    #( 56 #refreshWindow:  )) >

<primitive 112 pTempVar 46  " addAttributes: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5 \
       ] \
    #( 55 #refreshScreen  )) >

<primitive 112 pTempVar 47  " setWindowAttributes:attr: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16r7C 16rF2 16r20 16r21 16r81 16r01 \
        16rF3 16rF5] \
    #( 54 #refreshWindow:  )) >

<primitive 112 pTempVar 48  " setAttributes: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5 \
       ] \
    #( 53 #refreshScreen  )) >

<primitive 112 pTempVar 49  " printWindowString:string:at: " \
  #( #[ 16r30 16r21 16r23 16r0A 16r32 16r23 16r0A 16r31 16r22 16rFA 16r05 \
        16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 16rF5] \
    #( 44 #refreshWindow:  )) >

<primitive 112 pTempVar 50  " printString:at: " \
  #( #[ 16r30 16r22 16r0A 16r32 16r22 16r0A 16r31 16r21 16rFA 16r04 16r7C \
        16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 43 #refreshScreen  )) >

<primitive 112 pTempVar 51  " printWindowString:string: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16r7C 16rF2 16r20 16r21 16r81 16r01 \
        16rF3 16rF5] \
    #( 42 #refreshWindow:  )) >

<primitive 112 pTempVar 52  " printString: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5 \
       ] \
    #( 41 #refreshScreen  )) >

<primitive 112 pTempVar 53  " printWindowChar:char:at: " \
  #( #[ 16r30 16r21 16r23 16r0A 16r32 16r23 16r0A 16r31 16r22 16rFA 16r05 \
        16r7C 16rF2 16r20 16r21 16r81 16r01 16rF3 16rF5] \
    #( 40 #refreshWindow:  )) >

<primitive 112 pTempVar 54  " printChar:at: " \
  #( #[ 16r30 16r22 16r0A 16r32 16r22 16r0A 16r31 16r21 16rFA 16r04 16r7C \
        16rF2 16r20 16r80 16r01 16rF3 16rF5] \
    #( 39 #refreshScreen  )) >

<primitive 112 pTempVar 55  " printWindowChar:char: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16r7C 16rF2 16r20 16r21 16r81 16r01 \
        16rF3 16rF5] \
    #( 38 #refreshWindow:  )) >

<primitive 112 pTempVar 56  " printChar: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r80 16r01 16rF3 16rF5 \
       ] \
    #( 37 #refreshScreen  )) >

<primitive 112 pTempVar 57  " windowNeedsRefresh: " \
  #( #[ 16r05 16r50 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 58  " setWindowScrollRegion:top:Bottom: " \
  #( #[ 16r05 16r4F 16r21 16r22 16r23 16rFA 16r04 16r7C 16rF2 16r20 16r21 \
        16r81 16r00 16rF3 16rF5] \
    #( #refreshWindow:  )) >

<primitive 112 pTempVar 59  " setScrollRegion:Bottom: " \
  #( #[ 16r05 16r4E 16r21 16r22 16rFA 16r03 16r7C 16rF2 16r20 16r80 16r00 \
        16rF3 16rF5] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 60  " scrollWindow: " \
  #( #[ 16r05 16r4D 16r21 16rFA 16r02 16r7C 16rF2 16r20 16r21 16r81 16r00 \
        16rF3 16rF5] \
    #( #refreshWindow:  )) >

<primitive 112 pTempVar 61  " enableKeyPad:status: " \
  #( #[ 16r22 16r5B 16rB6 16rF7 16r0A 16r05 16r4B 16r21 16r51 16rFA 16r03 \
        16r7C 16rF3 16rF8 16r09 16rF2 16r05 16r4B 16r21 16r50 16rFA \
        16r03 16r7C 16rF3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 62  " enableScroll:status: " \
  #( #[ 16r22 16r5B 16rB6 16rF7 16r0A 16r05 16r4C 16r21 16r51 16rFA 16r03 \
        16r7C 16rF3 16rF8 16r09 16rF2 16r05 16r4C 16r21 16r50 16rFA \
        16r03 16r7C 16rF3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 63  " setDrawMode: " \
  #( #[ 16r05 16r57 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 64  " setBackPenColor: " \
  #( #[ 16r05 16r56 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 65  " setTextPenColor: " \
  #( #[ 16r05 16r55 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 66  " setColor:red:green:blue: " \
  #( #[ 16r58 16r21 16r22 16r23 16r24 16rFA 16r05 16r7C 16rF2 16r20 16r80 \
        16r00 16rF3 16rF5] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 67  " hasColors " \
  #( #[ 16r56 16rFA 16r01 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 68  " enableDelay:status: " \
  #( #[ 16r22 16r5B 16rB6 16rF7 16r0A 16r05 16r49 16r21 16r50 16rFA 16r03 \
        16r7C 16rF3 16rF8 16r09 16rF2 16r05 16r49 16r21 16r51 16rFA \
        16r03 16r7C 16rF3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 69  " echo: " \
  #( #[ 16r21 16r5B 16rB6 16rF7 16r08 16r05 16r45 16rFA 16r01 16r7C 16rF3 \
        16rF8 16r07 16rF2 16r05 16r46 16rFA 16r01 16r7C 16rF3 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 70  " newlineMap: " \
  #( #[ 16r21 16r5B 16rB6 16rF7 16r08 16r05 16r43 16rFA 16r01 16r7C 16rF3 \
        16rF8 16r07 16rF2 16r05 16r44 16rFA 16r01 16r7C 16rF3 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 71  " enableCursor:status: " \
  #( #[ 16r22 16r5B 16rB6 16rF7 16r0A 16r05 16r48 16r21 16r51 16rFA 16r03 \
        16r7C 16rF3 16rF8 16r09 16rF2 16r05 16r48 16r21 16r50 16rFA \
        16r03 16r7C 16rF3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 72  " enableClear:status: " \
  #( #[ 16r22 16r5B 16rB6 16rF7 16r0A 16r05 16r47 16r21 16r51 16rFA 16r03 \
        16r7C 16rF3 16rF8 16r09 16rF2 16r05 16r47 16r21 16r50 16rFA \
        16r03 16r7C 16rF3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 73  " cBreak: " \
  #( #[ 16r21 16r5B 16rB6 16rF7 16r08 16r05 16r41 16rFA 16r01 16r7C 16rF3 \
        16rF8 16r07 16rF2 16r05 16r42 16rFA 16r01 16r7C 16rF3 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 74  " flash " \
  #( #[ 16r05 16r54 16rFA 16r01 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 75  " beep " \
  #( #[ 16r05 16r53 16rFA 16r01 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 76  " moveWindow:x:y: " \
  #( #[ 16r05 16r4A 16r21 16r23 16r22 16rFA 16r04 16r7C 16rF2 16r20 16r21 \
        16r81 16r00 16rF3 16rF5] \
    #( #refreshWindow:  )) >

<primitive 112 pTempVar 77  " drawBorder:hChar:vChar: " \
  #( #[ 16r55 16r21 16r23 16r22 16rFA 16r04 16r7C 16rF2 16r20 16r21 16r81 \
        16r00 16rF3 16rF5] \
    #( #refreshWindow:  )) >

<primitive 112 pTempVar 78  " closeWindow: " \
  #( #[ 16r53 16r21 16rFA 16r02 16r7C 16r72 16r10 16r51 16rC1 16r60 16r20 \
        16r80 16r00 16rF2 16r22 16rF3 16rF5] \
    #( #refreshScreen  )) >

<primitive 112 pTempVar 79  " refreshWindow: " \
  #( #[ 16r30 16r21 16rFA 16r02 16r7C 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 80  " refreshScreen " \
  #( #[ 16r59 16rFA 16r01 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 81  " openSubWindow:xStart:yStart:width:height: " \
  #( #[ 16r10 16r30 16rC7 16rF7 16r10 16r54 16r21 16r25 16r24 16r23 16r22 \
        16rFA 16r06 16r7C 16r76 16r10 16r51 16rC0 16r60 16r26 16rF3 \
        16rF2 16rF5] \
    #( 50  )) >

<primitive 112 pTempVar 82  " openWindow:yStart:width:height: " \
  #( #[ 16r10 16r30 16rC7 16rF7 16r0F 16r52 16r24 16r23 16r22 16r21 16rFA \
        16r05 16r7C 16r75 16r10 16r51 16rC0 16r60 16r25 16rF3 16rF2 \
        16rF5] \
    #( 50  )) >

<primitive 112 pTempVar 83  " initWithStdColors " \
  #( #[ 16r57 16rFA 16r01 16r7C 16rF2 16r51 16rFA 16r01 16r7C 16rF2 16r20 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 84  " initializeWithColors: " \
  #( #[ 16r57 16r21 16rFA 16r02 16r7C 16rF2 16r51 16rFA 16r01 16r7C 16rF2 \
        16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 85  " closeDown " \
  #( #[ 16r50 16rFA 16r01 16r7C 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 86  " initialize " \
  #( #[ 16r51 16rFA 16r01 16r7C 16rF2 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 87  " new " \
  #( #[ 16r50 16r60 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Curses \
  <primitive 97 #Curses #Object #User/curses.st \
   #(  #windowCount ) \
   #( #moveCursorFrom:to: #flushKeys #updateWindows #addToRefreshList:  \
       #moveWindowCursor:to: #moveCursorTo: #deleteWindowLine: #deleteLine #insertWindowLine:  \
       #insertLine #insertWindowChar:at: #insertCharAt: #insertWindowChar: #insertChar  \
       #readWindowChar:at: #readCharAt: #readWindowChar: #readChar #getWindowString:at:buffer:  \
       #getStringAt:buffer: #getWindowString:buffer: #getString: #getWindowChar:at: #getCharAt:  \
       #getWindowChar: #getChar #deleteWindowChar:at: #deleteCharAt: #deleteWindowChar:  \
       #deleteChar #clearWindowToEOL: #clearScreenToEOL #clearWindowToBottom:  \
       #clearScreenToBottom #clearWindow: #clearScreen #emptyWindow: #emptyScreen  \
       #revertWindowColors: #revertColors #invertWindowColors: #invertColors  \
       #removeWindowAttributes:attr: #removeAttributes: #addWindowAttributes:attr: #addAttributes:  \
       #setWindowAttributes:attr: #setAttributes: #printWindowString:string:at: #printString:at:  \
       #printWindowString:string: #printString: #printWindowChar:char:at: #printChar:at:  \
       #printWindowChar:char: #printChar: #windowNeedsRefresh: #setWindowScrollRegion:top:Bottom:  \
       #setScrollRegion:Bottom: #scrollWindow: #enableKeyPad:status: #enableScroll:status:  \
       #setDrawMode: #setBackPenColor: #setTextPenColor: #setColor:red:green:blue:  \
       #hasColors #enableDelay:status: #echo: #newlineMap: #enableCursor:status:  \
       #enableClear:status: #cBreak: #flash #beep #moveWindow:x:y: #drawBorder:hChar:vChar:  \
       #closeWindow: #refreshWindow: #refreshScreen  \
       #openSubWindow:xStart:yStart:width:height: #openWindow:yStart:width:height: #initWithStdColors  \
       #initializeWithColors: #closeDown #initialize #new  ) \
  pTempVar 7 8 > #ordinary >

