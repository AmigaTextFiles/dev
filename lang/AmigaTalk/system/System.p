pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " printString " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 'PrinterFlags'  )) >

<primitive 112 pTempVar 2  " systemTag: " \
  #( #[ 16r52 16r11 16r21 16rFA 16r03 16rCE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " close " \
  #( #[ 16r50 16r12 16r11 16rFA 16r03 16rCE 16r62 16r5D 16rF1 16r61 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r13 16r20 16r80 16r00 16r60 16r31 16r63 16r53 \
        16rFA 16r01 16rCE 16r61 16r51 16r13 16r11 16rFA 16r03 16rCE \
        16r62 16r5D 16rF2 16r20 16rF3 16rF5] \
    #( #privateNew 'AmigaTalk:prelude/listFiles/Printer.dictionary'  )) >

<primitive 112 pTempVar 5  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 6  " privateNew " \
  #( #[ 16r51 16rFA 16r01 16r6E 16r71 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #PrinterFlags \
  <primitive 97 #PrinterFlags #Object #AmigaTalk:System/PrinterFlags.st \
   #(  #uniqueInstance #private0 #private1 #myName ) \
   #( #printString #systemTag: #close #privateSetup #new #privateNew  \
       #isSingleton  ) \
  pTempVar 2 6 > #isSingleton >

pTempVar <- <primitive 110 29 >
<primitive 112 pTempVar 1  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 2  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r1F 16r20 16r80 16r00 16r71 16r21 16r50 16rC9 \
        16rF7 16r06 16r31 16r60 16r20 16rF3 16rF8 16r10 16rF2 16r32 \
        16rA8 16rF2 16r05 16r15 16r21 16rFA 16r02 16rE6 16rA8 16rF2 \
        16r5D 16rF1 16r60 16rF3 16rF2 16rF5] \
    #( #privateOpen 'MyNarrator' 'Problem opening Narrator:'  )) >

<primitive 112 pTempVar 3  " new: " \
  #( #[ 16r30 16rA8 16rF2 16r5D 16rF3 16rF5] \
    #( 'Cannot use new: method on Narrator class!'  )) >

<primitive 112 pTempVar 4  " translateText: " \
  #( #[ 16r05 16r14 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " speakPhonetics: " \
  #( #[ 16r05 16r13 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " speak: " \
  #( #[ 16r05 16r12 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " setFricationAmplitude: " \
  #( #[ 16r05 16r11 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setVoicingAmplitude: " \
  #( #[ 16r05 16r10 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " setFlags: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 10  " setCentralizeValue: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 11  " setPhoneme: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 12  " setArticulation: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 13  " setPitchModulation: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 14  " setPriority: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 15  " setEnthusiasm: " \
  #( #[ 16r59 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " setFormant3Amplitude: " \
  #( #[ 16r58 16r53 16r21 16rFA 16r03 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " setFormant2Amplitude: " \
  #( #[ 16r58 16r52 16r21 16rFA 16r03 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " setFormant1Amplitude: " \
  #( #[ 16r58 16r51 16r21 16rFA 16r03 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " setFormant3: " \
  #( #[ 16r57 16r53 16r21 16rFA 16r03 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " setFormant2: " \
  #( #[ 16r57 16r52 16r21 16rFA 16r03 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " setFormant1: " \
  #( #[ 16r57 16r51 16r21 16rFA 16r03 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " setRate: " \
  #( #[ 16r56 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " setMode: " \
  #( #[ 16r55 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " setPitch: " \
  #( #[ 16r54 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " setSex: " \
  #( #[ 16r53 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 26  " setVolume: " \
  #( #[ 16r52 16r21 16rFA 16r02 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " privateOpen " \
  #( #[ 16r51 16rFA 16r01 16rE6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 28  " close " \
  #( #[ 16r50 16r20 16rFA 16r02 16rE6 16rF2 16r55 16r50 16r20 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 29  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Narrator \
  <primitive 97 #Narrator #Device #AmigaTalk:System/Narrator.st \
   #(  #uniqueInstance ) \
   #( #new #privateSetup #new: #translateText: #speakPhonetics: #speak:  \
       #setFricationAmplitude: #setVoicingAmplitude: #setFlags: #setCentralizeValue: #setPhoneme:  \
       #setArticulation: #setPitchModulation: #setPriority: #setEnthusiasm:  \
       #setFormant3Amplitude: #setFormant2Amplitude: #setFormant1Amplitude: #setFormant3:  \
       #setFormant2: #setFormant1: #setRate: #setMode: #setPitch: #setSex: #setVolume:  \
       #privateOpen #close #isSingleton  ) \
  pTempVar 2 5 > #isSingleton >

pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF3 16rF5] \
    #( #current:  )) >

<primitive 112 pTempVar 2  " current: " \
  #( #[ 16r10 16rA1 16rF7 16r10 16r20 16r80 16r00 16r60 16r05 16r28 16rA0 \
        16r61 16r20 16r80 16r01 16rF2 16r20 16r21 16r81 16r02 16rF2 \
        16r10 16rF3 16rF5] \
    #( #privateNew #privateInitializeDictionary #open:  )) >

<primitive 112 pTempVar 3  " current " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 4  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r0D 16r20 16r80 16r00 16r60 16r05 16r28 16rA0 \
        16r61 16r20 16r80 16r01 16rF2 16r5D 16rF2 16r20 16rF3 16rF5 \
       ] \
    #( #privateNew #privateInitializeDictionary  )) >

<primitive 112 pTempVar 5  " getParFlag: " \
  #( #[ 16r11 16r21 16rB1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " privateInitializeDictionary " \
  #( #[ 16r11 16r30 16r31 16rD0 16rF2 16r11 16r32 16r33 16rD0 16rF2 16r11 \
        16r34 16r35 16rD0 16rF2 16r11 16r36 16r37 16rD0 16rF2 16r11 \
        16r38 16r39 16rD0 16rF2 16rF5] \
    #( #PARF_EOFMODE 2r00000010 #PARF_ACKMODE 2r00000100 #PARF_FASTMODE \
        2r00001000 #PARF_SLOWMODE 2r00010000 #PARF_SHARED 2r00100000  )) >

<primitive 112 pTempVar 7  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 8  " privateNew " \
  #( #[ 16r20 16r90 16r00 16r71 16r21 16rF3 16rF5] \
    #( #new  )) >

<primitive 112 pTempVar 9  " close " \
  #( #[ 16r50 16rFA 16r01 16rE0 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " open: " \
  #( #[ 16r51 16r21 16rFA 16r02 16rE0 16r72 16r22 16r50 16rCA 16rF7 16r0C \
        16r30 16rA8 16rF2 16r52 16r22 16rFA 16r02 16rE0 16rA8 16rF2 \
        16r5D 16rF3 16rF2 16r20 16rF3 16rF5] \
    #( 'Error open Parallel device:'  )) >

<primitive 112 pTempVar 11  " readControlBitsMaskedBy: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE0 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 12  " sendPortControlBits: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE0 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 13  " setPortDirectionAtomic: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE0 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 14  " setTerminatorsTo: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE0 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 15  " writeToPort:thisLong: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rE0 16r73 16r23 16r22 16rCA 16rF7 \
        16r02 16r31 16rA8 16rF2 16rF5] \
    #( 10 'Parallel Port write error!'  )) >

<primitive 112 pTempVar 16  " readThisMany: " \
  #( #[ 16r59 16r21 16rFA 16r02 16rE0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " setPortParametersTo: " \
  #( #[ 16r58 16r21 16rFA 16r02 16rE0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " startPort " \
  #( #[ 16r57 16rFA 16r01 16rE0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " stopPort " \
  #( #[ 16r56 16rFA 16r01 16rE0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " flushPort " \
  #( #[ 16r55 16rFA 16r01 16rE0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " resetPort " \
  #( #[ 16r54 16rFA 16r01 16rE0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " status " \
  #( #[ 16r53 16rFA 16r01 16rE0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #ParallelDevice \
  <primitive 97 #ParallelDevice #Device #AmigaTalk:System/ParallelDevice.st \
   #(  #uniqueInstance #flagDictionary ) \
   #( #new: #current: #current #privateSetup #getParFlag:  \
       #privateInitializeDictionary #new #privateNew #close #open: #readControlBitsMaskedBy:  \
       #sendPortControlBits: #setPortDirectionAtomic: #setTerminatorsTo: #writeToPort:thisLong:  \
       #readThisMany: #setPortParametersTo: #startPort #stopPort #flushPort #resetPort  \
       #status #isSingleton  ) \
  pTempVar 4 6 > #isSingleton >

pTempVar <- <primitive 110 15 >
<primitive 112 pTempVar 1  " clipTypeIs " \
  #( #[ 16r53 16r10 16rFA 16r02 16rDD 16r71 16r21 16r5D 16rB6 16rF7 16r02 \
        16r30 16rF3 16rF2 16r21 16r5B 16rB6 16rF7 16r02 16r31 16rF3 \
        16rF2 16r32 16rF3 16rF5] \
    #( #CLIP_ERROR #FTXT #ILBM  )) >

<primitive 112 pTempVar 2  " postAsciiStringToClip: " \
  #( #[ 16r51 16r21 16r10 16rFA 16r03 16rDD 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " writeILBMClipToFile: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rDD 16r72 16r22 16r50 16rCA 16rF7 \
        16r0C 16r31 16r21 16rA8 16r0B 16r12 16rF2 16r59 16r22 16rFA \
        16r02 16rDD 16rA8 16rF2 16rF5] \
    #( 14 'Clip did NOT make it to file '  )) >

<primitive 112 pTempVar 4  " postILBMFileToClip: " \
  #( #[ 16r58 16r10 16r21 16rFA 16r03 16rDD 16r72 16r22 16r50 16rCA 16rF7 \
        16r0C 16r21 16r30 16rA8 16r0B 16r12 16rF2 16r59 16r22 16rFA \
        16r02 16rDD 16rA8 16rF2 16rF5] \
    #( ' did NOT make it to the clipboard!'  )) >

<primitive 112 pTempVar 5  " postFTXTFileToClip: " \
  #( #[ 16r57 16r10 16r21 16rFA 16r03 16rDD 16r72 16r22 16r50 16rCA 16rF7 \
        16r0C 16r21 16r30 16rA8 16r0B 16r12 16rF2 16r59 16r22 16rFA \
        16r02 16rDD 16rA8 16rF2 16rF5] \
    #( ' did NOT make it to the clipboard!'  )) >

<primitive 112 pTempVar 6  " update " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDD 16r5B 16rCA 16rF7 16r02 16r31 16rA8 \
        16rF2 16rF5] \
    #( 12 'Clipboard update method failed!'  )) >

<primitive 112 pTempVar 7  " postAsciiFileToClip: " \
  #( #[ 16r50 16r10 16r21 16rFA 16r03 16rDD 16r72 16r22 16r50 16rCA 16rF7 \
        16r0C 16r21 16r30 16rA8 16r0B 16r12 16rF2 16r59 16r22 16rFA \
        16r02 16rDD 16rA8 16rF2 16rF5] \
    #( ' did NOT make it to the clipboard!'  )) >

<primitive 112 pTempVar 8  " postFTXTToClip: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rDD 16r72 16r22 16r50 16rCA 16rF7 \
        16r09 16r31 16rA8 16rF2 16r59 16r22 16rFA 16r02 16rDD 16rA8 \
        16rF2 16rF5] \
    #( 13 'string did NOT make it to the clipboard!'  )) >

<primitive 112 pTempVar 9  " writeFTXTClipToASCIIFile: " \
  #( #[ 16r54 16r21 16r10 16rFA 16r03 16rDD 16r72 16r22 16r50 16rCA 16rF7 \
        16r0F 16r30 16r21 16rA8 16r0B 16r12 16rF2 16r59 16r22 16rFA \
        16r02 16rDD 16rA8 16rF2 16r5D 16rF3 16rF2 16rF5] \
    #( 'Clip did NOT make it to file '  )) >

<primitive 112 pTempVar 10  " writeFTXTClipToFTXTFile: " \
  #( #[ 16r52 16r10 16r21 16rFA 16r03 16rDD 16r72 16r22 16r50 16rCA 16rF7 \
        16r0C 16r30 16r21 16rA8 16r0B 16r12 16rF2 16r59 16r22 16rFA \
        16r02 16rDD 16rA8 16rF2 16rF5] \
    #( 'Clip did NOT make it to file '  )) >

<primitive 112 pTempVar 11  " setClipUnit: " \
  #( #[ 16r21 16rF1 16r60 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " closeHookedClipboard " \
  #( #[ 16r56 16r10 16rFA 16r02 16rDD 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " openHookedClipboard:withHook: " \
  #( #[ 16r55 16r21 16r22 16rFA 16r03 16rDD 16r73 16r23 16r5D 16rB6 16rF7 \
        16r0B 16r30 16r21 16r0B 16r12 16r31 16rA8 16r0B 16r12 16rF2 \
        16r5D 16rF3 16rF2 16r20 16r21 16r81 16r02 16rF3 16rF5] \
    #( 'Clip #' ' did NOT open!' #setClipUnit:  )) >

<primitive 112 pTempVar 14  " new " \
  #( #[ 16r20 16r50 16rB0 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " new: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF2 16r20 16rF3 16rF5] \
    #( #setClipUnit:  )) >

<primitive 98 #ClipBoard \
  <primitive 97 #ClipBoard #Device #AmigaTalk:System/ClipBoard.st \
   #(  #unitNumber ) \
   #( #clipTypeIs #postAsciiStringToClip: #writeILBMClipToFile:  \
       #postILBMFileToClip: #postFTXTFileToClip: #update #postAsciiFileToClip: #postFTXTToClip:  \
       #writeFTXTClipToASCIIFile: #writeFTXTClipToFTXTFile: #setClipUnit: #closeHookedClipboard  \
       #openHookedClipboard:withHook: #new #new:  ) \
  pTempVar 4 4 > #ordinary >

pTempVar <- <primitive 110 2 >
<primitive 112 pTempVar 1  " writeFTXTClip:toFTXTString:size: " \
  #( #[ 16r30 16r21 16r23 16r22 16rFA 16r04 16rDD 16r74 16r24 16r50 16rCA \
        16rF7 16r09 16r31 16rA8 16rF2 16r59 16r24 16rFA 16r02 16rDD \
        16rA8 16rF2 16rF5] \
    #( 11 'Clip did NOT make it to string!'  )) >

<primitive 112 pTempVar 2  " postToClipUnit:fromFTXTString: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rDD 16r73 16r23 16r50 16rCA 16rF7 \
        16r09 16r31 16rA8 16rF2 16r59 16r23 16rFA 16r02 16rDD 16rA8 \
        16rF2 16rF5] \
    #( 10 'String did NOT make it to Clipboard!'  )) >

<primitive 98 #IFFClipBoard \
  <primitive 97 #IFFClipBoard #Device #AmigaTalk:System/ClipBoard.st \
   #(  ) \
   #( #writeFTXTClip:toFTXTString:size: #postToClipUnit:fromFTXTString:  ) \
  pTempVar 5 5 > #ordinary >

pTempVar <- <primitive 110 24 >
<primitive 112 pTempVar 1  " close " \
  #( #[ 16r50 16r10 16rFA 16r02 16rE5 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " open: " \
  #( #[ 16r51 16r21 16r10 16rFA 16r03 16rE5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " new: " \
  #( #[ 16r05 16r17 16r21 16rFA 16r02 16rE5 16r60 16r21 16r61 16r20 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " displayBytes: " \
  #( #[ 16r20 16r80 16r00 16r72 16r05 16r3A 16rA0 16r73 16r31 16r22 16r0A \
        16r11 16r0B 16r12 16r32 16r0B 16r12 16r12 16r0A 16r11 16r0B \
        16r12 16r73 16r05 16r16 16r21 16r23 16rFA 16r03 16rE5 16rF2 \
        16rF5] \
    #( #getTrackSize 'displayBytes - size = ' ' Track #: '  )) >

<primitive 112 pTempVar 5  " writeTrack:track: " \
  #( #[ 16r22 16r62 16r53 16r21 16r22 16r10 16rFA 16r04 16rE5 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 6  " readTrack: " \
  #( #[ 16r21 16r62 16r52 16r21 16r10 16rFA 16r03 16rE5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " isWriteProtected " \
  #( #[ 16r57 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " isDiskPresent " \
  #( #[ 16r56 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " seekTrack: " \
  #( #[ 16r21 16r62 16r30 16r21 16r10 16rFA 16r03 16rE5 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 10  " getTotalSize " \
  #( #[ 16r20 16r80 16r00 16r72 16r20 16r80 16r01 16r71 16r22 16r21 16rC2 \
        16rF3 16rF5] \
    #( #getTotalSectors #getSectorSize  )) >

<primitive 112 pTempVar 11  " getTotalSectors " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 12  " getNumberOfTracks " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 13  " displayDriveType " \
  #( #[ 16r20 16r80 16r00 16r71 16r21 16r51 16rB6 16rF7 16r04 16r31 16rA8 \
        16rF8 16r0D 16rF2 16r21 16r52 16rB6 16rF7 16r04 16r32 16rA8 \
        16rF8 16r03 16rF2 16r33 16rA8 16rF2 16rF5] \
    #( #getDriveType '3-1/2" Floppy Disk.' '5-1/4" Floppy Disk.' '3-1/2" Floppy spinning at 150 RPM'  )) >

<primitive 112 pTempVar 14  " getDriveType " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 15  " getDeviceType " \
  #( #[ 16r59 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " getTrackSize " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 17  " getSectorSize " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 18  " getErrorString " \
  #( #[ 16r58 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " setSyncType: " \
  #( #[ 16r55 16r21 16r10 16rFA 16r03 16rE5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " clearReadBuffer " \
  #( #[ 16r54 16r10 16rFA 16r02 16rE5 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " writeRawData:track: " \
  #( #[ 16r22 16r62 16r05 16r15 16r21 16r22 16r10 16rFA 16r04 16rE5 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " readRawData: " \
  #( #[ 16r21 16r62 16r05 16r14 16r21 16r10 16rFA 16r03 16rE5 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 23  " formatTrack:data: " \
  #( #[ 16r21 16r62 16r05 16r13 16r22 16r21 16r10 16rFA 16r04 16rE5 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " ejectDisk " \
  #( #[ 16r05 16r10 16r10 16rFA 16r02 16rE5 16rF3 16rF5] \
    #(  )) >

<primitive 98 #TrackDisk \
  <primitive 97 #TrackDisk #Device #AmigaTalk:System/TrackDisk.st \
   #(  #private #diskName #trkNumber ) \
   #( #close #open: #new: #displayBytes: #writeTrack:track: #readTrack:  \
       #isWriteProtected #isDiskPresent #seekTrack: #getTotalSize #getTotalSectors  \
       #getNumberOfTracks #displayDriveType #getDriveType #getDeviceType #getTrackSize  \
       #getSectorSize #getErrorString #setSyncType: #clearReadBuffer #writeRawData:track:  \
       #readRawData: #formatTrack:data: #ejectDisk  ) \
  pTempVar 4 5 > #ordinary >

pTempVar <- <primitive 110 13 >
<primitive 112 pTempVar 1  " close " \
  #( #[ 16r50 16r10 16rFA 16r02 16rE4 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " openTimer:type:seconds:micros: " \
  #( #[ 16r51 16r22 16r23 16r24 16r21 16rFA 16r05 16rE4 16r60 16r22 16r61 \
        16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getEClockLow " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE4 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 4  " getEClockHigh " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE4 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 5  " compare:micros:toSeconds:micros: " \
  #( #[ 16r59 16r21 16r22 16r23 16r24 16rFA 16r05 16rE4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " setSeconds:micros: " \
  #( #[ 16r58 16r10 16r21 16r22 16rFA 16r04 16rE4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " getMicros " \
  #( #[ 16r57 16r10 16rFA 16r02 16rE4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " getSeconds " \
  #( #[ 16r56 16r10 16rFA 16r02 16rE4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " getTimerType " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " test " \
  #( #[ 16r55 16r10 16rFA 16r02 16rE4 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " delaySeconds:micros: " \
  #( #[ 16r54 16r10 16r21 16r22 16rFA 16r04 16rE4 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " startWithSecs:withMicros: " \
  #( #[ 16r53 16r10 16r21 16r22 16rFA 16r04 16rE4 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " stop " \
  #( #[ 16r52 16r10 16rFA 16r02 16rE4 16rF2 16rF5] \
    #(  )) >

<primitive 98 #TimerDevice \
  <primitive 97 #TimerDevice #Device #AmigaTalk:System/Timer.st \
   #(  #private #timerType ) \
   #( #close #openTimer:type:seconds:micros: #getEClockLow #getEClockHigh  \
       #compare:micros:toSeconds:micros: #setSeconds:micros: #getMicros #getSeconds #getTimerType #test  \
       #delaySeconds:micros: #startWithSecs:withMicros: #stop  ) \
  pTempVar 5 6 > #ordinary >

pTempVar <- <primitive 110 22 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16r21 16r30 16r82 16r01 16rF2 16r20 16rF3 16rF5] \
    #( 8192 #open:size:  )) >

<primitive 112 pTempVar 2  " close " \
  #( #[ 16r50 16r10 16rFA 16r02 16rE3 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " open:size: " \
  #( #[ 16r51 16r22 16rFA 16r02 16rE3 16r60 16r22 16r61 16r20 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 4  " setTerminators: " \
  #( #[ 16r30 16r21 16r10 16rFA 16r03 16rE3 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 5  " setFlags: " \
  #( #[ 16r30 16r55 16r21 16r10 16rFA 16r04 16rE3 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 6  " setRBufSize: " \
  #( #[ 16r30 16r54 16r21 16r10 16rFA 16r04 16rE3 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 7  " setBreakLen: " \
  #( #[ 16r30 16r53 16r21 16r10 16rFA 16r04 16rE3 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 8  " setStops: " \
  #( #[ 16r30 16r52 16r21 16r10 16rFA 16r04 16rE3 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 9  " setDataSize: " \
  #( #[ 16r30 16r51 16r21 16r10 16rFA 16r04 16rE3 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 10  " setParity:status: " \
  #( #[ 16r30 16r21 16r22 16r10 16rFA 16r04 16rE3 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 11  " setBaud: " \
  #( #[ 16r30 16r50 16r21 16r10 16rFA 16r04 16rE3 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 12  " setSyncType: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rE3 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 13  " clearReadBuffer " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE3 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 14  " flush " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE3 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 15  " getStatus " \
  #( #[ 16r59 16r10 16rFA 16r02 16rE3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " sendBreakOfDuration: " \
  #( #[ 16r58 16r21 16r10 16rFA 16r03 16rE3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " restart " \
  #( #[ 16r57 16r10 16rFA 16r02 16rE3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " pause " \
  #( #[ 16r56 16r10 16rFA 16r02 16rE3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " reset " \
  #( #[ 16r55 16r10 16rFA 16r02 16rE3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " writeThis: " \
  #( #[ 16r54 16r21 16r10 16rFA 16r03 16rE3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " readSerial: " \
  #( #[ 16r53 16r10 16r21 16rFA 16r03 16rE3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " initializeWithTerm: " \
  #( #[ 16r52 16r21 16r10 16rFA 16r03 16rE3 16rF2 16rF5] \
    #(  )) >

<primitive 98 #SerialDevice \
  <primitive 97 #SerialDevice #Device #AmigaTalk:System/SerialDevice.st \
   #(  #private #bufferSize ) \
   #( #new: #close #open:size: #setTerminators: #setFlags: #setRBufSize:  \
       #setBreakLen: #setStops: #setDataSize: #setParity:status: #setBaud: #setSyncType:  \
       #clearReadBuffer #flush #getStatus #sendBreakOfDuration: #restart #pause #reset  \
       #writeThis: #readSerial: #initializeWithTerm:  ) \
  pTempVar 3 5 > #ordinary >

pTempVar <- <primitive 110 12 >
<primitive 112 pTempVar 1  " write:this: " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'write: devName this: string' #subClassResponsibility:  )) >

<primitive 112 pTempVar 2  " getDeviceAddressList " \
  #( #[ 16r52 16r54 16rFA 16r02 16rFA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " update " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'update' #notImplemented:  )) >

<primitive 112 pTempVar 4  " start " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'start' #notImplemented:  )) >

<primitive 112 pTempVar 5  " stop " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'stop' #notImplemented:  )) >

<primitive 112 pTempVar 6  " query " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'query' #subClassResponsibility:  )) >

<primitive 112 pTempVar 7  " reset: " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'reset: devName' #subClassResponsibility:  )) >

<primitive 112 pTempVar 8  " read: " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'read: devName' #notImplemented:  )) >

<primitive 112 pTempVar 9  " invalid " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'invalid' #notImplemented:  )) >

<primitive 112 pTempVar 10  " flush: " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'flush: devName' #subClassResponsibility:  )) >

<primitive 112 pTempVar 11  " clear " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'clear' #notImplemented:  )) >

<primitive 112 pTempVar 12  " initialize: " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'initialize: initString' #subClassResponsibility:  )) >

<primitive 98 #Device \
  <primitive 97 #Device #Object #AmigaTalk:System/Device.st \
   #(  ) \
   #( #write:this: #getDeviceAddressList #update #start #stop #query #reset:  \
       #read: #invalid #flush: #clear #initialize:  ) \
  pTempVar 3 3 > #ordinary >

pTempVar <- <primitive 110 17 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16r21 16r50 16r82 16r00 16rF2 16r20 16rF3 16rF5] \
    #( #openLibrary:version:  )) >

<primitive 112 pTempVar 2  " getOpenCount " \
  #( #[ 16r52 16r57 16r10 16rFA 16r03 16rBE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getCheckSum " \
  #( #[ 16r52 16r56 16r10 16rFA 16r03 16rBE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " getRevision " \
  #( #[ 16r52 16r55 16r10 16rFA 16r03 16rBE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " getFlags " \
  #( #[ 16r52 16r53 16r10 16rFA 16r03 16rBE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " getPosSize " \
  #( #[ 16r52 16r52 16r10 16rFA 16r03 16rBE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " getNegSize " \
  #( #[ 16r52 16r51 16r10 16rFA 16r03 16rBE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " getVersion " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rBE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " getIDString " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " close " \
  #( #[ 16r50 16r10 16rFA 16r02 16rBE 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " openLibrary:version: " \
  #( #[ 16r51 16r21 16r22 16rFA 16r03 16rBE 16r60 16r21 16r61 16r20 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " getLibraryObject " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " sumLibrary: " \
  #( #[ 16r54 16r05 16r18 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " setFunctionIn:at:to: " \
  #( #[ 16r54 16r05 16r17 16r21 16r22 16r23 16rFA 16r05 16rD1 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 15  " removeLibrary: " \
  #( #[ 16r54 16r05 16r16 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " addLibrary: " \
  #( #[ 16r54 16r05 16r15 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " makeLibrary:struct:init:size:segments: " \
  #( #[ 16r54 16r05 16r1B 16r21 16r22 16r23 16r24 16r25 16rFA 16r07 16rD1 \
        16rF3 16rF5] \
    #(  )) >

<primitive 98 #Library \
  <primitive 97 #Library #Object #AmigaTalk:System/Library.st \
   #(  #private #libName ) \
   #( #new: #getOpenCount #getCheckSum #getRevision #getFlags #getPosSize  \
       #getNegSize #getVersion #getIDString #close #openLibrary:version:  \
       #getLibraryObject #sumLibrary: #setFunctionIn:at:to: #removeLibrary: #addLibrary:  \
       #makeLibrary:struct:init:size:segments:  ) \
  pTempVar 6 8 > #ordinary >

pTempVar <- <primitive 110 3 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16r30 16r91 16r01 16rF3 16rF5] \
    #( 'new:' #doesNotUnderstand:  )) >

<primitive 112 pTempVar 2  " getControllerType: " \
  #( #[ 16r57 16r21 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " openGamePort: " \
  #( #[ 16r20 16r30 16r91 16r01 16rF3 16rF5] \
    #( 'openGamePort:' #subclassResponsibility:  )) >

<primitive 98 #GamePort \
  <primitive 97 #GamePort #Device #AmigaTalk:System/GamePort.st \
   #(  ) \
   #( #new: #getControllerType: #openGamePort:  ) \
  pTempVar 2 3 > #ordinary >

pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF3 16rF5] \
    #( #openMousePort:  )) >

<primitive 112 pTempVar 2  " waitForYPos: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getYPos  )) >

<primitive 112 pTempVar 3  " waitForXPos: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getXPos  )) >

<primitive 112 pTempVar 4  " waitForQualifier: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getQualifiers  )) >

<primitive 112 pTempVar 5  " waitForButton: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getButtonCode  )) >

<primitive 112 pTempVar 6  " setYDeltaTransition: " \
  #( #[ 16r55 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " setXDeltaTransition: " \
  #( #[ 16r54 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setTimeTransition: " \
  #( #[ 16r21 16r50 16rC7 16rF7 16r05 16r30 16rA8 16rF2 16r5D 16rF3 16rF2 \
        16r53 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #( 'timeOutValue out of range (S/B >= 0).'  )) >

<primitive 112 pTempVar 9  " setKeyTransition: " \
  #( #[ 16r21 16r51 16rCB 16r21 16r81 16r00 16r53 16rC8 16rF7 16r08 16r52 \
        16r10 16r21 16rFA 16r03 16rDF 16rF8 16r03 16rF2 16r31 16rA8 \
        16rF2 16rF5] \
    #( #& 'transType parameter out of range (1 to 3 only)!'  )) >

<primitive 112 pTempVar 10  " getTriggerYDelta " \
  #( #[ 16r05 16r13 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getTriggerXDelta " \
  #( #[ 16r05 16r12 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " getTriggerTime " \
  #( #[ 16r05 16r11 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " getTriggerKeys " \
  #( #[ 16r05 16r10 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " getTimeStamp " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 15  " getIEAddress " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 16  " getYPos " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 17  " getXPos " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 18  " getQualifiers " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 19  " getButtonCode " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 20  " clearMousePortBuffer " \
  #( #[ 16r56 16r10 16rFA 16r02 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " closeMousePort " \
  #( #[ 16r50 16r10 16rFA 16r02 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " openMousePort: " \
  #( #[ 16r51 16r21 16rFA 16r02 16rDF 16r60 16r57 16r10 16rFA 16r02 16rDF \
        16r72 16r22 16r50 16rB6 16rF7 16r0B 16r58 16r10 16r51 16rFA \
        16r03 16rDF 16rF2 16r20 16rF3 16rF8 16r0D 16rF2 16r20 16r30 \
        16r21 16r0B 16r12 16r31 16r0B 16r12 16rBD 16rF2 16r5D 16rF3 \
        16rF2 16rF5] \
    #( 'Mouse port ' ' already in use!'  )) >

<primitive 112 pTempVar 23  " getControllerType " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getControllerType:  )) >

<primitive 98 #Mouse \
  <primitive 97 #Mouse #GamePort #AmigaTalk:System/GamePort.st \
   #(  #private ) \
   #( #new: #waitForYPos: #waitForXPos: #waitForQualifier: #waitForButton:  \
       #setYDeltaTransition: #setXDeltaTransition: #setTimeTransition: #setKeyTransition:  \
       #getTriggerYDelta #getTriggerXDelta #getTriggerTime #getTriggerKeys #getTimeStamp  \
       #getIEAddress #getYPos #getXPos #getQualifiers #getButtonCode #clearMousePortBuffer  \
       #closeMousePort #openMousePort: #getControllerType  ) \
  pTempVar 3 6 > #ordinary >

pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF3 16rF5] \
    #( #openGamePort:  )) >

<primitive 112 pTempVar 2  " waitForYPos: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getYPos  )) >

<primitive 112 pTempVar 3  " waitForXPos: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getXPos  )) >

<primitive 112 pTempVar 4  " waitForQualifier: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getQualifiers  )) >

<primitive 112 pTempVar 5  " waitForButton: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getButtonCode  )) >

<primitive 112 pTempVar 6  " setYDeltaTransition: " \
  #( #[ 16r55 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " setXDeltaTransition: " \
  #( #[ 16r54 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setTimeTransition: " \
  #( #[ 16r21 16r50 16rC7 16rF7 16r05 16r30 16rA8 16rF2 16r5D 16rF3 16rF2 \
        16r53 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #( 'timeOutValue out of range (S/B >= 0).'  )) >

<primitive 112 pTempVar 9  " setKeyTransition: " \
  #( #[ 16r21 16r51 16rCB 16r21 16r81 16r00 16r53 16rC8 16rF7 16r08 16r52 \
        16r10 16r21 16rFA 16r03 16rDF 16rF8 16r03 16rF2 16r31 16rA8 \
        16rF2 16rF5] \
    #( #& 'transType parameter out of range (1 to 3 only)!'  )) >

<primitive 112 pTempVar 10  " getTriggerYDelta " \
  #( #[ 16r05 16r13 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getTriggerXDelta " \
  #( #[ 16r05 16r12 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " getTriggerTime " \
  #( #[ 16r05 16r11 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " getTriggerKeys " \
  #( #[ 16r05 16r10 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " getTimeStamp " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 15  " getIEAddress " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 16  " getYPos " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 17  " getXPos " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 18  " getQualifiers " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 19  " getButtonCode " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 20  " clearGamePortBuffer " \
  #( #[ 16r56 16r10 16rFA 16r02 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " closeGamePort " \
  #( #[ 16r50 16r10 16rFA 16r02 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " openGamePort: " \
  #( #[ 16r51 16r21 16rFA 16r02 16rDF 16r60 16r57 16r10 16rFA 16r02 16rDF \
        16r72 16r22 16r50 16rB6 16rF7 16r0B 16r58 16r10 16r53 16rFA \
        16r03 16rDF 16rF2 16r20 16rF3 16rF8 16r0D 16rF2 16r20 16r30 \
        16r21 16r0B 16r12 16r31 16r0B 16r12 16rBD 16rF2 16r5D 16rF3 \
        16rF2 16rF5] \
    #( 'Game port ' ' already in use!'  )) >

<primitive 112 pTempVar 23  " getControllerType " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getControllerType:  )) >

<primitive 98 #AbsJoyStick \
  <primitive 97 #AbsJoyStick #GamePort #AmigaTalk:System/GamePort.st \
   #(  #private ) \
   #( #new: #waitForYPos: #waitForXPos: #waitForQualifier: #waitForButton:  \
       #setYDeltaTransition: #setXDeltaTransition: #setTimeTransition: #setKeyTransition:  \
       #getTriggerYDelta #getTriggerXDelta #getTriggerTime #getTriggerKeys #getTimeStamp  \
       #getIEAddress #getYPos #getXPos #getQualifiers #getButtonCode #clearGamePortBuffer  \
       #closeGamePort #openGamePort: #getControllerType  ) \
  pTempVar 3 6 > #ordinary >

pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " new: " \
  #( #[ 16r20 16r21 16r81 16r00 16rF3 16rF5] \
    #( #openGamePort:  )) >

<primitive 112 pTempVar 2  " waitForYPos: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getYPos  )) >

<primitive 112 pTempVar 3  " waitForXPos: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getXPos  )) >

<primitive 112 pTempVar 4  " waitForQualifier: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getQualifiers  )) >

<primitive 112 pTempVar 5  " waitForButton: " \
  #( #[ 16r20 16r80 16r00 16r72 16r22 16r21 16rC9 16rF6 16r08 16r20 16r80 \
        16r00 16rF1 16r72 16rF2 16rF9 16r0D 16rF2 16rF5] \
    #( #getButtonCode  )) >

<primitive 112 pTempVar 6  " setYDeltaTransition: " \
  #( #[ 16r55 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " setXDeltaTransition: " \
  #( #[ 16r54 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setTimeTransition: " \
  #( #[ 16r21 16r50 16rC7 16rF7 16r05 16r30 16rA8 16rF2 16r5D 16rF3 16rF2 \
        16r53 16r10 16r21 16rFA 16r03 16rDF 16rF2 16rF5] \
    #( 'timeOutValue out of range (S/B >= 0).'  )) >

<primitive 112 pTempVar 9  " setKeyTransition: " \
  #( #[ 16r21 16r51 16rCB 16r21 16r81 16r00 16r53 16rC8 16rF7 16r08 16r52 \
        16r10 16r21 16rFA 16r03 16rDF 16rF8 16r03 16rF2 16r31 16rA8 \
        16rF2 16rF5] \
    #( #& 'transType parameter out of range (1 to 3 only)!'  )) >

<primitive 112 pTempVar 10  " getTriggerYDelta " \
  #( #[ 16r05 16r13 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getTriggerXDelta " \
  #( #[ 16r05 16r12 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " getTriggerTime " \
  #( #[ 16r05 16r11 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " getTriggerKeys " \
  #( #[ 16r05 16r10 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " getTimeStamp " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 15  " getIEAddress " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 16  " getYPos " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 17  " getXPos " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 18  " getQualifiers " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 19  " getButtonCode " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDF 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 20  " clearGamePortBuffer " \
  #( #[ 16r56 16r10 16rFA 16r02 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " closeGamePort " \
  #( #[ 16r50 16r10 16rFA 16r02 16rDF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " openGamePort: " \
  #( #[ 16r51 16r21 16rFA 16r02 16rDF 16r60 16r57 16r10 16rFA 16r02 16rDF \
        16r72 16r22 16r50 16rB6 16rF7 16r0B 16r58 16r10 16r52 16rFA \
        16r03 16rDF 16rF2 16r20 16rF3 16rF8 16r0D 16rF2 16r20 16r30 \
        16r21 16r0B 16r12 16r31 16r0B 16r12 16rBD 16rF2 16r5D 16rF3 \
        16rF2 16rF5] \
    #( 'Game port ' ' already in use!'  )) >

<primitive 112 pTempVar 23  " getControllerType " \
  #( #[ 16r20 16r10 16r91 16r00 16rF3 16rF5] \
    #( #getControllerType:  )) >

<primitive 98 #RelJoyStick \
  <primitive 97 #RelJoyStick #GamePort #AmigaTalk:System/GamePort.st \
   #(  #private ) \
   #( #new: #waitForYPos: #waitForXPos: #waitForQualifier: #waitForButton:  \
       #setYDeltaTransition: #setXDeltaTransition: #setTimeTransition: #setKeyTransition:  \
       #getTriggerYDelta #getTriggerXDelta #getTriggerTime #getTriggerKeys #getTimeStamp  \
       #getIEAddress #getYPos #getXPos #getQualifiers #getButtonCode #clearGamePortBuffer  \
       #closeGamePort #openGamePort: #getControllerType  ) \
  pTempVar 3 6 > #ordinary >

pTempVar <- <primitive 110 67 >
<primitive 112 pTempVar 1  " sendFormFeed " \
  #( #[ 16r30 16rFA 16r01 16r60 16r71 16r20 16r21 16r51 16r82 16r01 16rF2 \
        16rF5] \
    #( 12 #asyncWrite:ofLength:  )) >

<primitive 112 pTempVar 2  " clearTabs " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aTBC3  )) >

<primitive 112 pTempVar 3  " setTab: " \
  #( #[ 16r40 16rA0 16r72 16r22 16r31 16rB1 16r73 16r56 16r10 16r23 16r21 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aHTS  )) >

<primitive 112 pTempVar 4  " setTabs:t2:t3:t4: " \
  #( #[ 16r40 16rA0 16r75 16r25 16r31 16rB1 16r76 16r56 16r10 16r26 16r21 \
        16r22 16r23 16r24 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aHTS  )) >

<primitive 112 pTempVar 5  " clearMargins " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aCAM  )) >

<primitive 112 pTempVar 6  " setLeftAndRightMargins:right: " \
  #( #[ 16r40 16rA0 16r73 16r23 16r31 16rB1 16r74 16r56 16r10 16r24 16r21 \
        16r22 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSLRM  )) >

<primitive 112 pTempVar 7  " setTopAndBottomMargins:bottom: " \
  #( #[ 16r40 16rA0 16r73 16r23 16r31 16rB1 16r74 16r56 16r10 16r24 16r21 \
        16r22 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSTBM  )) >

<primitive 112 pTempVar 8  " setBottomMargin: " \
  #( #[ 16r40 16rA0 16r72 16r22 16r31 16rB1 16r73 16r56 16r10 16r23 16r21 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aBMS  )) >

<primitive 112 pTempVar 9  " setTopMargin: " \
  #( #[ 16r40 16rA0 16r72 16r22 16r31 16rB1 16r73 16r56 16r10 16r23 16r21 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aTMS  )) >

<primitive 112 pTempVar 10  " setRightMargin: " \
  #( #[ 16r40 16rA0 16r72 16r22 16r31 16rB1 16r73 16r56 16r10 16r23 16r21 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aRMS  )) >

<primitive 112 pTempVar 11  " setLeftMargin: " \
  #( #[ 16r40 16rA0 16r72 16r22 16r31 16rB1 16r73 16r56 16r10 16r23 16r21 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aLMS  )) >

<primitive 112 pTempVar 12  " perfSkipOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aPERF0  )) >

<primitive 112 pTempVar 13  " setPerfSkip: " \
  #( #[ 16r21 16r50 16rC8 16rF7 16r02 16r5D 16rF3 16rF2 16r40 16rA0 16r72 \
        16r22 16r31 16rB1 16r73 16r56 16r10 16r23 16r21 16r50 16r50 \
        16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aPERF  )) >

<primitive 112 pTempVar 14  " setFormLength: " \
  #( #[ 16r40 16rA0 16r72 16r22 16r31 16rB1 16r73 16r56 16r10 16r23 16r21 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSLPP  )) >

<primitive 112 pTempVar 15  " partialLineDown " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aPLD  )) >

<primitive 112 pTempVar 16  " partialLineUp " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aPLU  )) >

<primitive 112 pTempVar 17  " normalizeLine " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSUS0  )) >

<primitive 112 pTempVar 18  " subScriptOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSUS3  )) >

<primitive 112 pTempVar 19  " subScriptOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSUS4  )) >

<primitive 112 pTempVar 20  " superScriptOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSUS1  )) >

<primitive 112 pTempVar 21  " superScriptOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSUS2  )) >

<primitive 112 pTempVar 22  " enlargedPitchOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSHORP5  )) >

<primitive 112 pTempVar 23  " enlargedPitchOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSHORP6  )) >

<primitive 112 pTempVar 24  " condensedPitchOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSHORP3  )) >

<primitive 112 pTempVar 25  " condensedPitchOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSHORP4  )) >

<primitive 112 pTempVar 26  " elitePitchOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSHORP1  )) >

<primitive 112 pTempVar 27  " elitePitchOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSHORP2  )) >

<primitive 112 pTempVar 28  " normalPitch " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSHORP0  )) >

<primitive 112 pTempVar 29  " boldOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSGR22  )) >

<primitive 112 pTempVar 30  " boldOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSGR1  )) >

<primitive 112 pTempVar 31  " underlineOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSGR24  )) >

<primitive 112 pTempVar 32  " underlineOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSGR4  )) >

<primitive 112 pTempVar 33  " italicsOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSGR23  )) >

<primitive 112 pTempVar 34  " italicsOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSGR3  )) >

<primitive 112 pTempVar 35  " normalCharSet " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aSGR0  )) >

<primitive 112 pTempVar 36  " nlqOff " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aDEN1  )) >

<primitive 112 pTempVar 37  " nlqOn " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aDEN2  )) >

<primitive 112 pTempVar 38  " crlf " \
  #( #[ 16r40 16rA0 16r71 16r21 16r31 16rB1 16r72 16r56 16r10 16r22 16r50 \
        16r50 16r50 16r50 16rFA 16r07 16rE1 16rF2 16rF5] \
    #( #PrtCommands #aNEL  )) >

<primitive 112 pTempVar 39  " asyncWrite:ofLength: " \
  #( #[ 16r54 16r10 16r21 16r22 16rFA 16r04 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 40  " write:ofLength: " \
  #( #[ 16r53 16r10 16r21 16r22 16rFA 16r04 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 41  " sendRawWrite:ofLength: " \
  #( #[ 16r57 16r10 16r21 16r22 16rFA 16r04 16rE1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 42  " open: " \
  #( #[ 16r51 16r21 16rFA 16r02 16rE1 16r60 16rF5] \
    #(  )) >

<primitive 112 pTempVar 43  " close " \
  #( #[ 16r50 16r10 16rFA 16r02 16rE1 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 44  " getPrinterErrorString " \
  #( #[ 16r05 16r12 16r10 16rFA 16r02 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 45  " dumpTaggedGraphics: " \
  #( #[ 16r21 16r51 16rB1 16r72 16r21 16r52 16rB1 16r73 16r21 16r53 16rB1 \
        16r74 16r21 16r54 16rB1 16r75 16r21 16r55 16rB1 16r76 16r21 \
        16r56 16rB1 16r77 16r21 16r57 16rB1 16r78 16r21 16r58 16rB1 \
        16r79 16r21 16r59 16rB1 16r7A 16r21 16r30 16rB1 16r7B 16r21 \
        16r31 16rB1 16r7C 16r32 16r10 16r22 16r23 16r24 16r25 16r26 \
        16r27 16r28 16r29 16r2A 16r2B 16r2C 16rFA 16r0D 16rE1 16rF2 \
        16rF5] \
    #( 10 11 13  )) >

<primitive 112 pTempVar 46  " setPrinterErrorHook: " \
  #( #[ 16r05 16r11 16r10 16r21 16rFA 16r03 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 47  " editPrinterPrefs: " \
  #( #[ 16r05 16r10 16r10 16r21 16rFA 16r03 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 48  " writePrinterPrefsFrom:ofSize: " \
  #( #[ 16r30 16r10 16r21 16r22 16rFA 16r04 16rE1 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 49  " readPrinterPrefsInto:ofSize: " \
  #( #[ 16r30 16r10 16r21 16r22 16rFA 16r04 16rE1 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 50  " dumpGraphics: " \
  #( #[ 16r21 16r51 16rB1 16r72 16r21 16r52 16rB1 16r73 16r21 16r53 16rB1 \
        16r74 16r21 16r54 16rB1 16r75 16r21 16r55 16rB1 16r76 16r21 \
        16r56 16rB1 16r77 16r21 16r57 16rB1 16r78 16r21 16r58 16rB1 \
        16r79 16r21 16r59 16rB1 16r7A 16r21 16r30 16rB1 16r7B 16r31 \
        16r10 16r22 16r23 16r24 16r25 16r26 16r27 16r28 16r29 16r2A \
        16r2B 16rFA 16r0C 16rE1 16rF2 16rF5] \
    #( 10 12  )) >

<primitive 112 pTempVar 51  " query " \
  #( #[ 16r55 16r10 16rFA 16r02 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 52  " flush " \
  #( #[ 16r58 16r10 16rFA 16r02 16rE1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 53  " stop " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE1 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 54  " restart " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE1 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 55  " sendExtendedCmd:parm1:parm2:parm3:parm4: " \
  #( #[ 16r56 16r10 16r21 16r22 16r23 16r24 16r25 16rFA 16r07 16rE1 16rF2 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 56  " reset " \
  #( #[ 16r59 16r10 16rFA 16r02 16rE1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 57  " getMaxYRasterDump " \
  #( #[ 16r05 16r1C 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 58  " getMaxXRasterDump " \
  #( #[ 16r05 16r1B 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 59  " getNumberOfHeadPins " \
  #( #[ 16r05 16r1A 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 60  " getNumberOfPrintColumns " \
  #( #[ 16r05 16r19 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 61  " getVerticalDPI " \
  #( #[ 16r05 16r18 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 62  " getHorizontalDPI " \
  #( #[ 16r05 16r17 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 63  " getNumberOfCharSets " \
  #( #[ 16r05 16r16 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 64  " getPrinterName " \
  #( #[ 16r05 16r15 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 65  " getPrinterColorClassString " \
  #( #[ 16r05 16r14 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 66  " getPrinterClassString " \
  #( #[ 16r05 16r13 16rFA 16r01 16rE1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 67  " initialize: " \
  #( #[ 16r52 16r10 16r21 16rFA 16r03 16rE1 16rF2 16rF5] \
    #(  )) >

<primitive 98 #PrinterDevice \
  <primitive 97 #PrinterDevice #Device #AmigaTalk:System/PrinterDevice.st \
   #(  #private ) \
   #( #sendFormFeed #clearTabs #setTab: #setTabs:t2:t3:t4: #clearMargins  \
       #setLeftAndRightMargins:right: #setTopAndBottomMargins:bottom: #setBottomMargin: #setTopMargin:  \
       #setRightMargin: #setLeftMargin: #perfSkipOff #setPerfSkip: #setFormLength:  \
       #partialLineDown #partialLineUp #normalizeLine #subScriptOff #subScriptOn  \
       #superScriptOff #superScriptOn #enlargedPitchOff #enlargedPitchOn #condensedPitchOff  \
       #condensedPitchOn #elitePitchOff #elitePitchOn #normalPitch #boldOff #boldOn  \
       #underlineOff #underlineOn #italicsOff #italicsOn #normalCharSet #nlqOff #nlqOn  \
       #crlf #asyncWrite:ofLength: #write:ofLength: #sendRawWrite:ofLength: #open:  \
       #close #getPrinterErrorString #dumpTaggedGraphics: #setPrinterErrorHook:  \
       #editPrinterPrefs: #writePrinterPrefsFrom:ofSize: #readPrinterPrefsInto:ofSize:  \
       #dumpGraphics: #query #flush #stop #restart #sendExtendedCmd:parm1:parm2:parm3:parm4:  \
       #reset #getMaxYRasterDump #getMaxXRasterDump #getNumberOfHeadPins  \
       #getNumberOfPrintColumns #getVerticalDPI #getHorizontalDPI #getNumberOfCharSets #getPrinterName  \
       #getPrinterColorClassString #getPrinterClassString #initialize:  ) \
  pTempVar 13 14 > #ordinary >

pTempVar <- <primitive 110 59 >
<primitive 112 pTempVar 1  " waitForCharAt:for: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 54  )) >

<primitive 112 pTempVar 2  " vPrintf:withArgs: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 53  )) >

<primitive 112 pTempVar 3  " vFPrintfTo:format:withArgs: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF6 16rF3 16rF5] \
    #( 52  )) >

<primitive 112 pTempVar 4  " unGetC:to: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 51  )) >

<primitive 112 pTempVar 5  " strToLong: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 50  )) >

<primitive 112 pTempVar 6  " strToDate: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 49  )) >

<primitive 112 pTempVar 7  " splitName:by:into:ofSize:at: " \
  #( #[ 16r30 16r21 16r22 16r23 16r25 16r24 16rFA 16r06 16rF6 16rF3 16rF5 \
       ] \
    #( 48  )) >

<primitive 112 pTempVar 8  " setProtectionOf:to: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 47  )) >

<primitive 112 pTempVar 9  " stringToProtectionMask: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 57  )) >

<primitive 112 pTempVar 10  " setPromptTo: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 46  )) >

<primitive 112 pTempVar 11  " translateIoErrToString: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 58  )) >

<primitive 112 pTempVar 12  " setIoErrTo: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 45  )) >

<primitive 112 pTempVar 13  " setFileDateOf:to: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 44  )) >

<primitive 112 pTempVar 14  " setCommentFieldOf:to: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 43  )) >

<primitive 112 pTempVar 15  " areSameLock:and: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 42  )) >

<primitive 112 pTempVar 16  " areSameDevice:and: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 41  )) >

<primitive 112 pTempVar 17  " readLinkInto:ofSize:onPort:using:and: " \
  #( #[ 16r30 16r23 16r24 16r25 16r21 16r22 16rFA 16r06 16rF6 16rF3 16rF5 \
       ] \
    #( 40  )) >

<primitive 112 pTempVar 18  " readItemInto:ofSize:with: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF6 16rF3 16rF5] \
    #( 39  )) >

<primitive 112 pTempVar 19  " readArgs:into:auxRDArgs: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF6 16rF3 16rF5] \
    #( 38  )) >

<primitive 112 pTempVar 20  " read:into:ofSize: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF6 16rF3 16rF5] \
    #( 37  )) >

<primitive 112 pTempVar 21  " putStr: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 36  )) >

<primitive 112 pTempVar 22  " printFault:code: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 35  )) >

<primitive 112 pTempVar 23  " getFilePart: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 55  )) >

<primitive 112 pTempVar 24  " getRealPathPart: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 56  )) >

<primitive 112 pTempVar 25  " getPathPart: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 34  )) >

<primitive 112 pTempVar 26  " getParentLockFromFH: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 33  )) >

<primitive 112 pTempVar 27  " getParentDirLock: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 33  )) >

<primitive 112 pTempVar 28  " getMaxCli " \
  #( #[ 16r30 16rFA 16r01 16rF6 16rF3 16rF5] \
    #( 31  )) >

<primitive 112 pTempVar 29  " matchNext: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 30  )) >

<primitive 112 pTempVar 30  " matchFirst:fromAnchor: " \
  #( #[ 16r05 16r1D 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 31  " matchEnd: " \
  #( #[ 16r05 16r1C 16r21 16rFA 16r02 16rF6 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 32  " isInteractive: " \
  #( #[ 16r05 16r1B 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 33  " isFileSystem: " \
  #( #[ 16r05 16r1A 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 34  " getIoErr " \
  #( #[ 16r05 16r19 16rFA 16r01 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 35  " getVarNamed:into:ofSize:flags: " \
  #( #[ 16r05 16r18 16r21 16r22 16r23 16r24 16rFA 16r05 16rF6 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 36  " getPromptInto:ofSize: " \
  #( #[ 16r21 16r22 16rFA 16r02 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 37  " getProgramNameInto:ofSize: " \
  #( #[ 16r05 16r16 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 38  " getProgramDir " \
  #( #[ 16r05 16r15 16rFA 16r01 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 39  " getFileSysTask " \
  #( #[ 16r05 16r14 16rFA 16r01 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 40  " getDeviceProc:auxDevProc: " \
  #( #[ 16r05 16r13 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 41  " getCurrentDirNameInto:ofSize: " \
  #( #[ 16r05 16r12 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 42  " getConsoleTask " \
  #( #[ 16r05 16r11 16rFA 16r01 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 43  " getArgStr " \
  #( #[ 16r05 16r10 16rFA 16r01 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 44  " fPutS:to: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 45  " fPutC:to: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 46  " findVar:ofType: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 47  " findCliProc: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 48  " fGets:into:ofSize:using: " \
  #( #[ 16r30 16r21 16r22 16r23 16r24 16rFA 16r05 16rF6 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 49  " fGetC: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 50  " fault:code:into:ofSize: " \
  #( #[ 16r59 16r22 16r21 16r23 16r24 16rFA 16r05 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 51  " errorReport:type:arg1:fromDevicePort: " \
  #( #[ 16r58 16r21 16r22 16r23 16r24 16rFA 16r05 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 52  " endNotify: " \
  #( #[ 16r57 16r21 16rFA 16r02 16rF6 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 53  " delay: " \
  #( #[ 16r56 16r21 16rFA 16r02 16rF6 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 54  " dateToStr: " \
  #( #[ 16r55 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 55  " currentDir: " \
  #( #[ 16r54 16r21 16rFA 16r02 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 56  " compareDates:and: " \
  #( #[ 16r53 16r21 16r22 16rFA 16r03 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 57  " getCLIObject " \
  #( #[ 16r52 16rFA 16r01 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 58  " addBuffers:toFileDevice: " \
  #( #[ 16r51 16r22 16r21 16rFA 16r03 16rF6 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 59  " abortPacket:onMsgPort: " \
  #( #[ 16r50 16r22 16r21 16rFA 16r03 16rF6 16rF2 16rF5] \
    #(  )) >

<primitive 98 #SafeDOS \
  <primitive 97 #SafeDOS #Object #AmigaTalk:System/SafeDos.st \
   #(  ) \
   #( #waitForCharAt:for: #vPrintf:withArgs: #vFPrintfTo:format:withArgs:  \
       #unGetC:to: #strToLong: #strToDate: #splitName:by:into:ofSize:at:  \
       #setProtectionOf:to: #stringToProtectionMask: #setPromptTo: #translateIoErrToString:  \
       #setIoErrTo: #setFileDateOf:to: #setCommentFieldOf:to: #areSameLock:and:  \
       #areSameDevice:and: #readLinkInto:ofSize:onPort:using:and: #readItemInto:ofSize:with:  \
       #readArgs:into:auxRDArgs: #read:into:ofSize: #putStr: #printFault:code: #getFilePart:  \
       #getRealPathPart: #getPathPart: #getParentLockFromFH: #getParentDirLock: #getMaxCli  \
       #matchNext: #matchFirst:fromAnchor: #matchEnd: #isInteractive: #isFileSystem:  \
       #getIoErr #getVarNamed:into:ofSize:flags: #getPromptInto:ofSize:  \
       #getProgramNameInto:ofSize: #getProgramDir #getFileSysTask #getDeviceProc:auxDevProc:  \
       #getCurrentDirNameInto:ofSize: #getConsoleTask #getArgStr #fPutS:to: #fPutC:to: #findVar:ofType:  \
       #findCliProc: #fGets:into:ofSize:using: #fGetC: #fault:code:into:ofSize:  \
       #errorReport:type:arg1:fromDevicePort: #endNotify: #delay: #dateToStr: #currentDir: #compareDates:and:  \
       #getCLIObject #addBuffers:toFileDevice: #abortPacket:onMsgPort:  ) \
  pTempVar 6 7 > #ordinary >

pTempVar <- <primitive 110 67 >
<primitive 112 pTempVar 1  " isFileIn: " \
  #( #[ 16r05 16r40 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " getOwnerGIDFrom: " \
  #( #[ 16r05 16r3F 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getOwnerUIDFrom: " \
  #( #[ 16r05 16r3E 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " getDateStampObjectFrom: " \
  #( #[ 16r05 16r3D 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " getProtectionBitsFrom: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 60  )) >

<primitive 112 pTempVar 6  " getCommentFrom: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 59  )) >

<primitive 112 pTempVar 7  " getBlockCountFrom: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 58  )) >

<primitive 112 pTempVar 8  " getFileSizeFrom: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 57  )) >

<primitive 112 pTempVar 9  " getFileNameFrom: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 56  )) >

<primitive 112 pTempVar 10  " writeChars:ofSize: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 55  )) >

<primitive 112 pTempVar 11  " vFWritef:format:args: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #( 54  )) >

<primitive 112 pTempVar 12  " unLockRecords: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 53  )) >

<primitive 112 pTempVar 13  " unLockRecord:at:ofSize: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #( 52  )) >

<primitive 112 pTempVar 14  " unLockDosList: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF2 16rF5] \
    #( 51  )) >

<primitive 112 pTempVar 15  " unLock: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF2 16rF5] \
    #( 50  )) >

<primitive 112 pTempVar 16  " startNotify: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 49  )) >

<primitive 112 pTempVar 17  " setVar:from:ofSize:flags: " \
  #( #[ 16r30 16r21 16r22 16r23 16r24 16rFA 16r05 16rF7 16rF3 16rF5] \
    #( 48  )) >

<primitive 112 pTempVar 18  " setProgramName: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 47  )) >

<primitive 112 pTempVar 19  " setProgramDirTo: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 46  )) >

<primitive 112 pTempVar 20  " setOwnerUID:to: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 45  )) >

<primitive 112 pTempVar 21  " setFileMode:to: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 44  )) >

<primitive 112 pTempVar 22  " setCurrentDirNameTo: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 43  )) >

<primitive 112 pTempVar 23  " rename:to: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 42  )) >

<primitive 112 pTempVar 24  " relabel:to: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 41  )) >

<primitive 112 pTempVar 25  " parsePatternNoCase:into:ofSize: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #( 40  )) >

<primitive 112 pTempVar 26  " parsePattern:into:ofSize: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #( 39  )) >

<primitive 112 pTempVar 27  " getOutputHandle " \
  #( #[ 16r30 16rFA 16r01 16rF7 16rF3 16rF5] \
    #( 38  )) >

<primitive 112 pTempVar 28  " openFileFromLock: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 37  )) >

<primitive 112 pTempVar 29  " open:mode: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 36  )) >

<primitive 112 pTempVar 30  " getNextDosEntry:flags: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 35  )) >

<primitive 112 pTempVar 31  " getNameFromLock:into:ofSize: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #( 34  )) >

<primitive 112 pTempVar 32  " getNameFromFH:into:ofSize: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #( 33  )) >

<primitive 112 pTempVar 33  " matchPatternNoCase:in: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 32  )) >

<primitive 112 pTempVar 34  " matchPattern:in: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 31  )) >

<primitive 112 pTempVar 35  " makeLink:to:flag: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #( 30  )) >

<primitive 112 pTempVar 36  " makeDosEntry:ofType: " \
  #( #[ 16r05 16r1D 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 37  " lockRecords:expiring: " \
  #( #[ 16r05 16r1C 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 38  " lockRecord:at:ofSize:mode:expire: " \
  #( #[ 16r05 16r1B 16r21 16r22 16r23 16r24 16r25 16rFA 16r06 16rF7 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 39  " lockDosList: " \
  #( #[ 16r05 16r1A 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 40  " lockFile:mode: " \
  #( #[ 16r05 16r19 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 41  " getInputHandle " \
  #( #[ 16r05 16r18 16rFA 16r01 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 42  " diskInfo:into: " \
  #( #[ 16r05 16r17 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 43  " disposeInfoDataObject: " \
  #( #[ 16r05 16r42 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 44  " makeInfoDataObject " \
  #( #[ 16r05 16r41 16rFA 16r01 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 45  " fileRead:into:blockSize:count: " \
  #( #[ 16r05 16r16 16r21 16r22 16r23 16r24 16rFA 16r05 16rF7 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 46  " flushFileHandle: " \
  #( #[ 16r05 16r15 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 47  " findSegment:startingAt:flag: " \
  #( #[ 16r05 16r14 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 48  " findDosEntry:in:flags: " \
  #( #[ 16r05 16r13 16r22 16r21 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 49  " findArgumentIndex:using: " \
  #( #[ 16r05 16r12 16r22 16r21 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 50  " examineNext:into: " \
  #( #[ 16r05 16r11 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 51  " execute:with:and: " \
  #( #[ 16r05 16r10 16r21 16r22 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 52  " examineFileHandle:into: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 53  " examine:into: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 54  " endExamine:with:from:ofSize:type: " \
  #( #[ 16r30 16r22 16r23 16r24 16r25 16r21 16rFA 16r06 16rF7 16rF2 16rF5 \
       ] \
    #( 13  )) >

<primitive 112 pTempVar 55  " examineAll:with:into:ofSize:type: " \
  #( #[ 16r30 16r22 16r23 16r24 16r25 16r21 16rFA 16r06 16rF7 16rF3 16rF5 \
       ] \
    #( 12  )) >

<primitive 112 pTempVar 56  " duplicateLockFromFH: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 57  " duplicateLock: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 58  " makeDateStamp: " \
  #( #[ 16r59 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 59  " createDir: " \
  #( #[ 16r58 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 60  " close: " \
  #( #[ 16r57 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 61  " checkForSignal: " \
  #( #[ 16r56 16r21 16rFA 16r02 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 62  " changeMode:type:to: " \
  #( #[ 16r55 16r22 16r21 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 63  " addAssignment:toPath: " \
  #( #[ 16r54 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 64  " addAssignment:toLock: " \
  #( #[ 16r53 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 65  " addAssignmentLater:to: " \
  #( #[ 16r52 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 66  " addAssignment:to: " \
  #( #[ 16r51 16r21 16r22 16rFA 16r03 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 67  " addPart:to:ofSize: " \
  #( #[ 16r50 16r22 16r21 16r23 16rFA 16r04 16rF7 16rF3 16rF5] \
    #(  )) >

<primitive 98 #UnSafeDOS \
  <primitive 97 #UnSafeDOS #Object #AmigaTalk:System/UnSafeDos.st \
   #(  ) \
   #( #isFileIn: #getOwnerGIDFrom: #getOwnerUIDFrom:  \
       #getDateStampObjectFrom: #getProtectionBitsFrom: #getCommentFrom: #getBlockCountFrom:  \
       #getFileSizeFrom: #getFileNameFrom: #writeChars:ofSize: #vFWritef:format:args:  \
       #unLockRecords: #unLockRecord:at:ofSize: #unLockDosList: #unLock: #startNotify:  \
       #setVar:from:ofSize:flags: #setProgramName: #setProgramDirTo: #setOwnerUID:to: #setFileMode:to:  \
       #setCurrentDirNameTo: #rename:to: #relabel:to: #parsePatternNoCase:into:ofSize:  \
       #parsePattern:into:ofSize: #getOutputHandle #openFileFromLock: #open:mode:  \
       #getNextDosEntry:flags: #getNameFromLock:into:ofSize: #getNameFromFH:into:ofSize:  \
       #matchPatternNoCase:in: #matchPattern:in: #makeLink:to:flag: #makeDosEntry:ofType:  \
       #lockRecords:expiring: #lockRecord:at:ofSize:mode:expire: #lockDosList: #lockFile:mode:  \
       #getInputHandle #diskInfo:into: #disposeInfoDataObject: #makeInfoDataObject  \
       #fileRead:into:blockSize:count: #flushFileHandle: #findSegment:startingAt:flag:  \
       #findDosEntry:in:flags: #findArgumentIndex:using: #examineNext:into: #execute:with:and:  \
       #examineFileHandle:into: #examine:into: #endExamine:with:from:ofSize:type:  \
       #examineAll:with:into:ofSize:type: #duplicateLockFromFH: #duplicateLock: #makeDateStamp: #createDir:  \
       #close: #checkForSignal: #changeMode:type:to: #addAssignment:toPath:  \
       #addAssignment:toLock: #addAssignmentLater:to: #addAssignment:to: #addPart:to:ofSize:  ) \
  pTempVar 6 7 > #ordinary >

pTempVar <- <primitive 110 25 >
<primitive 112 pTempVar 1  " writeFile:with:ofSize: " \
  #( #[ 16r05 16r18 16r21 16r22 16r23 16rFA 16r04 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " setVBuf:to:type:bufferSize: " \
  #( #[ 16r05 16r17 16r21 16r22 16r23 16r24 16rFA 16r05 16rF8 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 3  " setFileSize:at:mode: " \
  #( #[ 16r05 16r16 16r21 16r22 16r23 16rFA 16r04 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " setArgumentString: " \
  #( #[ 16r05 16r15 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " selectOutput: " \
  #( #[ 16r05 16r14 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " selectInput: " \
  #( #[ 16r05 16r13 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " seek:to:mode: " \
  #( #[ 16r05 16r12 16r21 16r22 16r23 16rFA 16r04 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " runCommand:args:count:stack: " \
  #( #[ 16r05 16r11 16r21 16r24 16r22 16r23 16rFA 16r05 16rF8 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 9  " replyPacket:primaryResult:secondaryResult: " \
  #( #[ 16r05 16r10 16r21 16r22 16r23 16rFA 16r04 16rF8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " inhibit:flags: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF8 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 11  " fileWrite:to:blkSize:count: " \
  #( #[ 16r30 16r21 16r22 16r23 16r24 16rFA 16r05 16rF8 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 12  " freeDosObject:type: " \
  #( #[ 16r30 16r22 16r21 16rFA 16r03 16rF8 16rF2 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 13  " freeDosEntry: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF8 16rF2 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 14  " freeDeviceProcess: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF8 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 15  " freeArgs: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF8 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 16  " exitProgram: " \
  #( #[ 16r59 16r21 16rFA 16r02 16rF8 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " makeDeviceProcess: " \
  #( #[ 16r58 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " deleteVar:flags: " \
  #( #[ 16r57 16r21 16r22 16rFA 16r03 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " createProcess:priority:segments:stack: " \
  #( #[ 16r56 16r21 16r22 16r23 16r24 16rFA 16r05 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " createNewProcess: " \
  #( #[ 16r55 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " cliInitRun: " \
  #( #[ 16r54 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " cliInitNewCLI: " \
  #( #[ 16r53 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " attemptLockDosList: " \
  #( #[ 16r52 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " allocDosObject:tags: " \
  #( #[ 16r51 16r21 16r22 16rFA 16r03 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " addDosEntry: " \
  #( #[ 16r50 16r21 16rFA 16r02 16rF8 16rF3 16rF5] \
    #(  )) >

<primitive 98 #DangerousDOS \
  <primitive 97 #DangerousDOS #Object #AmigaTalk:System/DangerousDos.st \
   #(  ) \
   #( #writeFile:with:ofSize: #setVBuf:to:type:bufferSize:  \
       #setFileSize:at:mode: #setArgumentString: #selectOutput: #selectInput: #seek:to:mode:  \
       #runCommand:args:count:stack: #replyPacket:primaryResult:secondaryResult: #inhibit:flags:  \
       #fileWrite:to:blkSize:count: #freeDosObject:type: #freeDosEntry: #freeDeviceProcess: #freeArgs:  \
       #exitProgram: #makeDeviceProcess: #deleteVar:flags:  \
       #createProcess:priority:segments:stack: #createNewProcess: #cliInitRun: #cliInitNewCLI: #attemptLockDosList:  \
       #allocDosObject:tags: #addDosEntry:  ) \
  pTempVar 5 6 > #ordinary >

pTempVar <- <primitive 110 17 >
<primitive 112 pTempVar 1  " waitForPacket " \
  #( #[ 16r05 16r10 16rFA 16r01 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " unLoadSegment: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF9 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 3  " systemCommandTagList:tags: " \
  #( #[ 16r30 16r21 16r22 16rFA 16r03 16rF9 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 4  " setFileSystemTask: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF9 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 5  " setConsoleTask: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF9 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 6  " sendPacket:to:replyTo: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rF9 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 7  " removeSegment: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rF9 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 8  " removeDosEntry: " \
  #( #[ 16r59 16r21 16rFA 16r02 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " removeAssignList:from: " \
  #( #[ 16r58 16r21 16r22 16rFA 16r03 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " newLoadSegment:tags: " \
  #( #[ 16r57 16r21 16r22 16rFA 16r03 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " loadSegment: " \
  #( #[ 16r56 16r21 16rFA 16r02 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " internalUnLoadSegment:freeFuncPtr: " \
  #( #[ 16r55 16r21 16r22 16rFA 16r03 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " internalLoadSegment:ovlyTable:funcArray:stackPtr: " \
  #( #[ 16r54 16r21 16r22 16r23 16r24 16rFA 16r05 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " formatDisk:on:type: " \
  #( #[ 16r53 16r21 16r22 16r23 16rFA 16r04 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 15  " doPacket:onPort:arguments: " \
  #( #[ 16r23 16r51 16rB1 16r74 16r23 16r52 16rB1 16r75 16r23 16r53 16rB1 \
        16r76 16r23 16r54 16rB1 16r77 16r23 16r55 16rB1 16r78 16r52 \
        16r22 16r21 16r24 16r25 16r26 16r27 16r28 16rFA 16r08 16rF9 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " deleteFile: " \
  #( #[ 16r51 16r21 16rFA 16r02 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " addSegment:named:useCount: " \
  #( #[ 16r50 16r22 16r21 16r23 16rFA 16r04 16rF9 16rF3 16rF5] \
    #(  )) >

<primitive 98 #VeryDangerousDOS \
  <primitive 97 #VeryDangerousDOS #Object #AmigaTalk:System/VeryDangerousDos.st \
   #(  ) \
   #( #waitForPacket #unLoadSegment: #systemCommandTagList:tags:  \
       #setFileSystemTask: #setConsoleTask: #sendPacket:to:replyTo: #removeSegment:  \
       #removeDosEntry: #removeAssignList:from: #newLoadSegment:tags: #loadSegment:  \
       #internalUnLoadSegment:freeFuncPtr: #internalLoadSegment:ovlyTable:funcArray:stackPtr:  \
       #formatDisk:on:type: #doPacket:onPort:arguments: #deleteFile: #addSegment:named:useCount:  ) \
  pTempVar 9 9 > #ordinary >

pTempVar <- <primitive 110 7 >
<primitive 112 pTempVar 1  " printString " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 'DosFlags'  )) >

<primitive 112 pTempVar 2  " systemTag: " \
  #( #[ 16r52 16r11 16r21 16rFA 16r03 16rCE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " close " \
  #( #[ 16r50 16r12 16r11 16rFA 16r03 16rCE 16r62 16r5D 16rF1 16r61 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r13 16r20 16r80 16r00 16r60 16r31 16r63 16r53 \
        16rFA 16r01 16rCE 16r61 16r51 16r13 16r11 16rFA 16r03 16rCE \
        16r62 16r5D 16rF2 16r20 16rF3 16rF5] \
    #( #privateNew 'AmigaTalk:prelude/listFiles/DosFlags.dictionary'  )) >

<primitive 112 pTempVar 5  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 6  " privateNew " \
  #( #[ 16r51 16rFA 16r01 16r6E 16r71 16r21 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #DosFlags \
  <primitive 97 #DosFlags #Object #AmigaTalk:System/DosFlags.st \
   #(  #uniqueInstance #private0 #private1 #myName ) \
   #( #printString #systemTag: #close #privateSetup #new #privateNew  \
       #isSingleton  ) \
  pTempVar 2 6 > #isSingleton >

pTempVar <- <primitive 110 38 >
<primitive 112 pTempVar 1  " setNAGBaseName: " \
  #( #[ 16r52 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 37  )) >

<primitive 112 pTempVar 2  " setNAGTags: " \
  #( #[ 16r52 16r05 16r1D 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " setNAGStartLine: " \
  #( #[ 16r52 16r05 16r1C 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " setNAGStartNode: " \
  #( #[ 16r52 16r05 16r1B 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " disposeContext " \
  #( #[ 16r52 16r30 16r12 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 30  )) >

<primitive 112 pTempVar 6  " setNAGContextStrings: " \
  #( #[ 16r52 16r05 16r1A 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " setNAGFlags: " \
  #( #[ 16r52 16r05 16r19 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setNAGARexxClientPort: " \
  #( #[ 16r52 16r05 16r18 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " setNAGPulicScreen: " \
  #( #[ 16r52 16r05 16r17 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " setNAGScreen: " \
  #( #[ 16r52 16r05 16r16 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " setNAGName: " \
  #( #[ 16r52 16r05 16r15 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " setNAGDirectoryLock: " \
  #( #[ 16r52 16r05 16r14 16r12 16r21 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " disposeNAG " \
  #( #[ 16r50 16r52 16r12 16rFA 16r03 16rD1 16rF2 16r55 16r50 16r12 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " createNewAmigaGuideObject " \
  #( #[ 16r50 16r51 16r05 16rFA 16rFA 16r03 16rD1 16rF1 16r62 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 15  " expungeCrossReferences " \
  #( #[ 16r52 16r05 16r13 16rFA 16r02 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " loadCrossReferencesFrom:in: " \
  #( #[ 16r52 16r05 16r12 16r22 16r21 16rFA 16r04 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " setAmigaGuideContext:tags: " \
  #( #[ 16r52 16r30 16r10 16r21 16r22 16rFA 16r05 16rD1 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 18  " setAmigaGuideAttributes: " \
  #( #[ 16r52 16r30 16r10 16r21 16rFA 16r04 16rD1 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 19  " sendAmigaGuideContext: " \
  #( #[ 16r52 16r30 16r10 16r21 16rFA 16r04 16rD1 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 20  " sendAmigaGuideCommand:tags: " \
  #( #[ 16r52 16r30 16r10 16r21 16r22 16rFA 16r05 16rD1 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 21  " replyAmigaGuideMsg: " \
  #( #[ 16r52 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 22  " openAmigaGuideASync: " \
  #( #[ 16r52 16r30 16r12 16r21 16rFA 16r04 16rD1 16rF1 16r60 16rF3 16rF5 \
       ] \
    #( 10  )) >

<primitive 112 pTempVar 23  " openAmigaGuide: " \
  #( #[ 16r52 16r51 16r12 16r21 16rFA 16r04 16rD1 16rF1 16r60 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 24  " unlockAmigaGuideBase: " \
  #( #[ 16r52 16r59 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " lockAmigaGuideBase " \
  #( #[ 16r52 16r58 16r10 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 26  " getAmigaGuideString: " \
  #( #[ 16r52 16r57 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " getAGMsgReturnSecondaryValue: " \
  #( #[ 16r52 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 36  )) >

<primitive 112 pTempVar 28  " getAGMsgReturnPrimaryValue: " \
  #( #[ 16r52 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 35  )) >

<primitive 112 pTempVar 29  " getAGMsgDataSize: " \
  #( #[ 16r52 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 34  )) >

<primitive 112 pTempVar 30  " getAGMsgDataType: " \
  #( #[ 16r52 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 33  )) >

<primitive 112 pTempVar 31  " getAGMsgData: " \
  #( #[ 16r52 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 32  )) >

<primitive 112 pTempVar 32  " getAGMsgType: " \
  #( #[ 16r52 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 31  )) >

<primitive 112 pTempVar 33  " getAmigaGuideMsg " \
  #( #[ 16r52 16r56 16r10 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 34  " getAmigaGuideAttribute:into: " \
  #( #[ 16r52 16r55 16r21 16r10 16r22 16rFA 16r05 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 35  " closeAmigaGuide " \
  #( #[ 16r52 16r50 16r10 16rFA 16r03 16rD1 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 36  " getAmigaGuideSignal " \
  #( #[ 16r52 16r54 16r10 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 37  " removeAmigaGuideHost: " \
  #( #[ 16r11 16r80 16r00 16rF7 16r08 16r52 16r53 16r11 16r21 16rFA 16r04 \
        16rD1 16rF3 16rF2 16rF5] \
    #( #isNotNil  )) >

<primitive 112 pTempVar 38  " addAmigaGuideHost:hook:tags: " \
  #( #[ 16r52 16r52 16r22 16r21 16r23 16rFA 16r05 16rD1 16r61 16rF5] \
    #(  )) >

<primitive 98 #AmigaGuide \
  <primitive 97 #AmigaGuide #Object #AmigaTalk:System/AmigaGuide.st \
   #(  #private #private2 #private3 ) \
   #( #setNAGBaseName: #setNAGTags: #setNAGStartLine: #setNAGStartNode:  \
       #disposeContext #setNAGContextStrings: #setNAGFlags: #setNAGARexxClientPort:  \
       #setNAGPulicScreen: #setNAGScreen: #setNAGName: #setNAGDirectoryLock: #disposeNAG  \
       #createNewAmigaGuideObject #expungeCrossReferences #loadCrossReferencesFrom:in:  \
       #setAmigaGuideContext:tags: #setAmigaGuideAttributes: #sendAmigaGuideContext:  \
       #sendAmigaGuideCommand:tags: #replyAmigaGuideMsg: #openAmigaGuideASync: #openAmigaGuide:  \
       #unlockAmigaGuideBase: #lockAmigaGuideBase #getAmigaGuideString:  \
       #getAGMsgReturnSecondaryValue: #getAGMsgReturnPrimaryValue: #getAGMsgDataSize: #getAGMsgDataType:  \
       #getAGMsgData: #getAGMsgType: #getAmigaGuideMsg #getAmigaGuideAttribute:into:  \
       #closeAmigaGuide #getAmigaGuideSignal #removeAmigaGuideHost:  \
       #addAmigaGuideHost:hook:tags:  ) \
  pTempVar 4 7 > #ordinary >

pTempVar <- <primitive 110 5 >
<primitive 112 pTempVar 1  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r07 16r20 16r80 16r00 16r60 16r20 16r80 16r01 \
        16rF2 16r20 16rF3 16rF5] \
    #( #privateNew #privateInitializeDictionary  )) >

<primitive 112 pTempVar 2  " privateInitializeDictionary " \
  #( #[ 16r20 16r30 16r31 16rD0 16rF2 16r20 16r32 16r33 16rD0 16rF2 16r20 \
        16r34 16r35 16rD0 16rF2 16r20 16r36 16r37 16rD0 16rF2 16r20 \
        16r38 16r39 16rD0 16rF2 16r20 16r3A 16r3B 16rD0 16rF2 16r20 \
        16r3C 16r3D 16rD0 16rF2 16r20 16r3E 16r3F 16rD0 16rF2 16r20 \
        16r03 16r10 16r03 16r11 16rD0 16rF2 16r20 16r03 16r12 16r03 \
        16r13 16rD0 16rF2 16r20 16r03 16r14 16r03 16r15 16rD0 16rF2 \
        16r20 16r03 16r16 16r03 16r17 16rD0 16rF2 16r20 16r03 16r18 \
        16r03 16r19 16rD0 16rF2 16r20 16r03 16r1A 16r03 16r1B 16rD0 \
        16rF2 16r20 16r03 16r1C 16r03 16r1D 16rD0 16rF2 16r20 16r03 \
        16r1E 16r03 16r1F 16rD0 16rF2 16r20 16r03 16r20 16r03 16r21 \
        16rD0 16rF2 16r20 16r03 16r22 16r03 16r23 16rD0 16rF2 16r20 \
        16r03 16r24 16r03 16r25 16rD0 16rF2 16r20 16r03 16r26 16r03 \
        16r27 16rD0 16rF2 16r20 16r03 16r28 16r03 16r29 16rD0 16rF2 \
        16r20 16r03 16r2A 16r03 16r2B 16rD0 16rF2 16r20 16r03 16r2C \
        16r03 16r2D 16rD0 16rF2 16r20 16r03 16r2E 16r51 16rD0 16rF2 \
        16r20 16r03 16r2F 16r52 16rD0 16rF2 16r20 16r03 16r30 16r54 \
        16rD0 16rF2 16r20 16r03 16r31 16r58 16rD0 16rF2 16r20 16r03 \
        16r32 16r03 16r33 16rD0 16rF2 16r20 16r03 16r34 16r03 16r35 \
        16rD0 16rF2 16r20 16r03 16r36 16r03 16r37 16rD0 16rF2 16r20 \
        16r03 16r38 16r50 16rD0 16rF2 16r20 16r03 16r39 16r51 16rD0 \
        16rF2 16r20 16r03 16r3A 16r05 16r64 16rD0 16rF2 16r20 16r03 \
        16r3B 16r05 16r65 16rD0 16rF2 16r20 16r03 16r3C 16r05 16r66 \
        16rD0 16rF2 16r20 16r03 16r3D 16r05 16r67 16rD0 16rF2 16r20 \
        16r03 16r3E 16r05 16r68 16rD0 16rF2 16r20 16r03 16r3F 16r05 \
        16r69 16rD0 16rF2 16r20 16r03 16r40 16r05 16r6A 16rD0 16rF2 \
        16r20 16r03 16r41 16r05 16r6B 16rD0 16rF2 16r20 16r03 16r42 \
        16r05 16r6C 16rD0 16rF2 16r20 16r03 16r43 16r05 16r71 16rD0 \
        16rF2 16r20 16r03 16r44 16r51 16rD0 16rF2 16r20 16r03 16r45 \
        16r52 16rD0 16rF2 16r20 16r03 16r46 16r53 16rD0 16rF2 16r20 \
        16r03 16r47 16r03 16r48 16rD0 16rF2 16r20 16r03 16r49 16r51 \
        16rD0 16rF2 16r20 16r03 16r4A 16r52 16rD0 16rF2 16r20 16r03 \
        16r4B 16r54 16rD0 16rF2 16r20 16r03 16r4C 16r58 16rD0 16rF2 \
        16r20 16r03 16r4D 16r05 16r10 16rD0 16rF2 16r20 16r03 16r4E \
        16r03 16r4F 16rD0 16rF2 16r20 16r03 16r50 16r05 16r40 16rD0 \
        16rF2 16r20 16r03 16r51 16r03 16r52 16rD0 16rF2 16r20 16r03 \
        16r53 16r03 16r54 16rD0 16rF2 16r20 16r03 16r55 16r03 16r56 \
        16rD0 16rF2 16r20 16r03 16r57 16r03 16r58 16rD0 16rF2 16r20 \
        16r03 16r59 16r50 16rD0 16rF2 16r20 16r03 16r5A 16r51 16rD0 \
        16rF2 16r20 16r03 16r5B 16r52 16rD0 16rF2 16r20 16r03 16r5C \
        16r53 16rD0 16rF2 16r20 16r03 16r5D 16r54 16rD0 16rF2 16r20 \
        16r03 16r5E 16r55 16rD0 16rF2 16r20 16r03 16r5F 16r56 16rD0 \
        16rF2 16r20 16r03 16r60 16r57 16rD0 16rF2 16r20 16r03 16r61 \
        16r58 16rD0 16rF2 16rF5] \
    #( #StartupMsgID 16r11001 #LoginToolID 16r11002 #LogoutToolID 16r11003 \
        #ShutdownMsgID 16r11004 #ActivateToolID 16r11005 #DeactivateToolID \
        16r11006 #ActiveToolID 16r11007 #InactiveToolID 16r11008 #ToolStatusID \
        16r11009 #ToolCmdID 16r1100A #ToolCmdReplyID 16r1100B #ShutdownToolID \
        16r1100C #AGA_Path 16r80000001 #AGA_XRefList 16r80000002 #AGA_Activate \
        16r80000003 #AGA_Context 16r80000004 #AGA_HelpGroup 16r80000005 \
        #AGA_Reserved1 16r80000006 #AGA_Reserved2 16r80000007 #AGA_Reserved3 \
        16r80000008 #AGA_ARexxPort 16r80000009 #AGA_ARexxPortName 16r8000000A \
        #AGA_Secure 16r8000000B #HTF_LOAD_INDEX #HTF_LOAD_ALL #HTF_CACHE_NODE \
        #HTF_CACHE_DB #HTF_UNIQUE 16r8000 #HTF_NOACTIVATE 16r10000 #HTFC_SYSGADS \
        16r80000000 #HTH_OPEN #HTH_CLOSE #HTERR_NOT_ENOUGH_MEMORY #HTERR_CANT_OPEN_DATABASE \
        #HTERR_CANT_FIND_NODE #HTERR_CANT_OPEN_NODE #HTERR_CANT_OPEN_WINDOW \
        #HTERR_INVALID_COMMAND #HTERR_CANT_COMPLETE #HTERR_PORT_CLOSED \
        #HTERR_CANT_CREATE_PORT #HTERR_KEYWORD_NOT_FOUND #HM_FINDNODE \
        #HM_OPENNODE #HM_CLOSENODE #HM_EXPUNGE 10 #HTNF_KEEP #HTNF_RESERVED1 \
        #HTNF_RESERVED2 #HTNF_ASCII #HTNF_RESERVED3 #HTNF_CLEAN 32 #HTNF_DONE \
        #HTNA_Screen 16r80000001 #HTNA_Pens 16r80000002 #HTNA_Rectangle \
        16r80000003 #HTNA_HelpGroup 16r80000005 #XR_GENERIC #XR_FUNCTION \
        #XR_COMMAND #XR_INCLUDE #XR_MACRO #XR_STRUCT #XR_FIELD #XR_TYPEDEF \
        #XR_DEFINE  )) >

<primitive 112 pTempVar 3  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 4  " privateNew " \
  #( #[ 16r20 16r90 16r00 16r71 16r21 16rF3 16rF5] \
    #( #new  )) >

<primitive 112 pTempVar 5  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #AGuideTags \
  <primitive 97 #AGuideTags #Dictionary #AmigaTalk:System/AmigaGuide.st \
   #(  #uniqueInstance ) \
   #( #privateSetup #privateInitializeDictionary #new #privateNew  \
       #isSingleton  ) \
  pTempVar 2 4 > #isSingleton >

pTempVar <- <primitive 110 30 >
<primitive 112 pTempVar 1  " removeMemHandler: " \
  #( #[ 16r54 16r05 16r59 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " addMemHandler: " \
  #( #[ 16r54 16r05 16r58 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " rawDoFormat:to:renderFunction:data: " \
  #( #[ 16r54 16r05 16r57 16r21 16r22 16r23 16r24 16rFA 16r06 16rD1 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " stackSwap: " \
  #( #[ 16r54 16r05 16r56 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " coldReboot " \
  #( #[ 16r54 16r05 16r55 16rFA 16r02 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " cacheControl:with: " \
  #( #[ 16r54 16r05 16r4F 16r21 16r22 16rFA 16r04 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " cacheClearE:length:caches: " \
  #( #[ 16r54 16r05 16r4E 16r21 16r22 16r23 16rFA 16r05 16rD1 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 8  " cacheClearU " \
  #( #[ 16r54 16r05 16r4D 16rFA 16r02 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " addMemList:attrs:priority:base:named: " \
  #( #[ 16r54 16r05 16r4C 16r21 16r22 16r23 16r24 16r25 16rFA 16r07 16rD1 \
        16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " sumKickData " \
  #( #[ 16r54 16r05 16r4B 16rFA 16r02 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " getConditionCodes " \
  #( #[ 16r54 16r05 16r3D 16rFA 16r02 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " openResource: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 60  )) >

<primitive 112 pTempVar 13  " removeResource: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 59  )) >

<primitive 112 pTempVar 14  " addResource: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 58  )) >

<primitive 112 pTempVar 15  " abortIO: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 57  )) >

<primitive 112 pTempVar 16  " waitIO: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 56  )) >

<primitive 112 pTempVar 17  " checkIO: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 55  )) >

<primitive 112 pTempVar 18  " sendIO: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 54  )) >

<primitive 112 pTempVar 19  " doIO: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #( 53  )) >

<primitive 112 pTempVar 20  " removeDevice: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 52  )) >

<primitive 112 pTempVar 21  " addDevice: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 51  )) >

<primitive 112 pTempVar 22  " deleteIORequest: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 50  )) >

<primitive 112 pTempVar 23  " createIORequest:size: " \
  #( #[ 16r54 16r30 16r21 16r22 16rFA 16r04 16rD1 16rF3 16rF5] \
    #( 49  )) >

<primitive 112 pTempVar 24  " callDebug: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 32  )) >

<primitive 112 pTempVar 25  " alertDisplay: " \
  #( #[ 16r54 16r30 16r21 16rFA 16r03 16rD1 16rF2 16rF5] \
    #( 31  )) >

<primitive 112 pTempVar 26  " initResident:segments: " \
  #( #[ 16r54 16r30 16r21 16r22 16rFA 16r04 16rD1 16rF3 16rF5] \
    #( 30  )) >

<primitive 112 pTempVar 27  " findResidentNamed: " \
  #( #[ 16r54 16r05 16r1D 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 28  " makeFunctionsIn:with:displacement: " \
  #( #[ 16r54 16r05 16r1C 16r21 16r22 16r23 16rFA 16r05 16rD1 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 29  " initStruct:with:size: " \
  #( #[ 16r54 16r05 16r1A 16r21 16r22 16r23 16rFA 16r05 16rD1 16rF2 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 30  " initCode:version: " \
  #( #[ 16r54 16r05 16r19 16r21 16r22 16rFA 16r04 16rD1 16rF2 16rF5] \
    #(  )) >

<primitive 98 #Executive \
  <primitive 97 #Executive #Object #AmigaTalk:System/Exec.st \
   #(  ) \
   #( #removeMemHandler: #addMemHandler:  \
       #rawDoFormat:to:renderFunction:data: #stackSwap: #coldReboot #cacheControl:with:  \
       #cacheClearE:length:caches: #cacheClearU #addMemList:attrs:priority:base:named: #sumKickData  \
       #getConditionCodes #openResource: #removeResource: #addResource: #abortIO: #waitIO:  \
       #checkIO: #sendIO: #doIO: #removeDevice: #addDevice: #deleteIORequest:  \
       #createIORequest:size: #callDebug: #alertDisplay: #initResident:segments: #findResidentNamed:  \
       #makeFunctionsIn:with:displacement: #initStruct:with:size: #initCode:version:  ) \
  pTempVar 6 8 > #ordinary >

pTempVar <- <primitive 110 14 >
<primitive 112 pTempVar 1  " avlKeyCompare:with: " \
  #( #[ 16r54 16r05 16r66 16r21 16r22 16rFA 16r04 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " avlNodeCompare:with: " \
  #( #[ 16r54 16r05 16r65 16r21 16r22 16rFA 16r04 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " getDefaultKeyCompareFunction " \
  #( #[ 16r54 16r05 16r68 16rFA 16r02 16rD1 16rF1 16r61 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " getDefaultCompareFunction " \
  #( #[ 16r54 16r05 16r67 16rFA 16r02 16rD1 16rF1 16r60 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " findLastAVLNode: " \
  #( #[ 16r54 16r05 16r64 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " findFirstAVLNode: " \
  #( #[ 16r54 16r05 16r63 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " findNextAVLNode:in:function: " \
  #( #[ 16r54 16r05 16r62 16r22 16r21 16r23 16rFA 16r05 16rD1 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 8  " findNextAVLNode: " \
  #( #[ 16r54 16r05 16r61 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " findPrevAVLNode:in:function: " \
  #( #[ 16r54 16r05 16r60 16r22 16r21 16r23 16rFA 16r05 16rD1 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 10  " findPrevAVLNode: " \
  #( #[ 16r54 16r05 16r5F 16r21 16rFA 16r03 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " findAVLNode:in:function: " \
  #( #[ 16r54 16r05 16r5E 16r22 16r21 16r23 16rFA 16r05 16rD1 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 12  " removeAVLNode:from:function: " \
  #( #[ 16r54 16r05 16r5D 16r22 16r21 16r23 16rFA 16r05 16rD1 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 13  " removeAVLNode:from: " \
  #( #[ 16r54 16r05 16r5C 16r22 16r21 16rFA 16r04 16rD1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " addAVLNode:to:function: " \
  #( #[ 16r54 16r05 16r5B 16r22 16r21 16r23 16rFA 16r05 16rD1 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 98 #AVLTree \
  <primitive 97 #AVLTree #Object #AmigaTalk:System/Exec.st \
   #(  #compareFuncObj #compareKeyFuncObj ) \
   #( #avlKeyCompare:with: #avlNodeCompare:with:  \
       #getDefaultKeyCompareFunction #getDefaultCompareFunction #findLastAVLNode: #findFirstAVLNode:  \
       #findNextAVLNode:in:function: #findNextAVLNode: #findPrevAVLNode:in:function: #findPrevAVLNode:  \
       #findAVLNode:in:function: #removeAVLNode:from:function: #removeAVLNode:from:  \
       #addAVLNode:to:function:  ) \
  pTempVar 4 6 > #ordinary >

pTempVar <- <primitive 110 24 >
<primitive 112 pTempVar 1  " audioKey " \
  #( #[ 16r05 16r16 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " dispose " \
  #( #[ 16r50 16r10 16r11 16rFA 16r03 16rDC 16rF2 16r20 16r80 16r00 16rF2 \
        16r55 16r10 16rFA 16r02 16rDC 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #( #disposeData  )) >

<primitive 112 pTempVar 3  " disposeData " \
  #( #[ 16r52 16r12 16rFA 16r02 16rDC 16rF2 16r55 16r50 16r12 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " freeChannel " \
  #( #[ 16r05 16r14 16r10 16r11 16r13 16rFA 16r04 16rDC 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " write:size: " \
  #( #[ 16r05 16r13 16r10 16r21 16r22 16rFA 16r04 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " read:size: " \
  #( #[ 16r05 16r12 16r10 16r21 16r22 16rFA 16r04 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " lock " \
  #( #[ 16r57 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " finish " \
  #( #[ 16r58 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " update " \
  #( #[ 16r05 16r19 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " clear " \
  #( #[ 16r05 16r18 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " flush " \
  #( #[ 16r59 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " changePriority: " \
  #( #[ 16r56 16r10 16r21 16rFA 16r03 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " reset " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 14  " stop " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 15  " start " \
  #( #[ 16r30 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 16  " playAt:for: " \
  #( #[ 16r30 16r10 16r21 16r22 16r13 16rFA 16r05 16rDC 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 17  " setData: " \
  #( #[ 16r05 16r1A 16r10 16r21 16rFA 16r03 16rDC 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " read " \
  #( #[ 16r05 16r11 16r10 16r13 16rFA 16r03 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " waitCycle " \
  #( #[ 16r05 16r10 16r10 16r13 16rFA 16r03 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " period: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rDC 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 21  " volume: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rDC 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 22  " myChannel " \
  #( #[ 16r05 16r1B 16r10 16rFA 16r02 16rDC 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " openChannel:priority: " \
  #( #[ 16r05 16r15 16r10 16r22 16r21 16rFA 16r04 16rDC 16r73 16r20 16r80 \
        16r00 16r63 16r23 16rF3 16rF5] \
    #( #myChannel  )) >

<primitive 112 pTempVar 24  " initialize:channels:flags:priority: " \
  #( #[ 16r51 16rFA 16r01 16rDC 16r60 16r53 16r10 16r21 16r23 16r24 16r22 \
        16rFA 16r06 16rDC 16r61 16r20 16r22 16r24 16r82 16r00 16rF6 \
        16r03 16r20 16r31 16rBD 16rF2 16rF5] \
    #( #openChannel:priority: 'Could NOT open Audio channel(s)!'  )) >

<primitive 98 #Audio \
  <primitive 97 #Audio #Device #AmigaTalk:System/Audio.st \
   #(  #private1 #private2 #private3 #aChannel ) \
   #( #audioKey #dispose #disposeData #freeChannel #write:size: #read:size:  \
       #lock #finish #update #clear #flush #changePriority: #reset #stop #start  \
       #playAt:for: #setData: #read #waitCycle #period: #volume: #myChannel  \
       #openChannel:priority: #initialize:channels:flags:priority:  ) \
  pTempVar 5 7 > #ordinary >

pTempVar <- <primitive 110 23 >
<primitive 112 pTempVar 1  " repeatKey " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r200  )) >

<primitive 112 pTempVar 2  " numericPad " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r100  )) >

<primitive 112 pTempVar 3  " middleMouseButton " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r1000  )) >

<primitive 112 pTempVar 4  " rightMouseButton " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r2000  )) >

<primitive 112 pTempVar 5  " leftMouseButton " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r4000  )) >

<primitive 112 pTempVar 6  " rightAmiga " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r80  )) >

<primitive 112 pTempVar 7  " leftAmiga " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r40  )) >

<primitive 112 pTempVar 8  " rightAlt " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r20  )) >

<primitive 112 pTempVar 9  " leftAlt " \
  #( #[ 16r30 16rF3 16rF5] \
    #( 16r10  )) >

<primitive 112 pTempVar 10  " control " \
  #( #[ 16r58 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " capsLock " \
  #( #[ 16r54 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " rightShift " \
  #( #[ 16r52 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " leftShift " \
  #( #[ 16r51 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " keyAlternated " \
  #( #[ 16r11 16r20 16r80 16r00 16r20 16r80 16r01 16rC0 16rFA 16r02 16r17 \
        16r71 16r21 16r50 16rCA 16rF3 16rF5] \
    #( #leftAlt #rightAlt  )) >

<primitive 112 pTempVar 15  " keyControlled " \
  #( #[ 16r11 16r20 16r80 16r00 16rFA 16r02 16r17 16r71 16r21 16r50 16rCA \
        16rF3 16rF5] \
    #( #control  )) >

<primitive 112 pTempVar 16  " keyShifted " \
  #( #[ 16r11 16r20 16r80 16r00 16r20 16r80 16r01 16rC0 16r20 16r80 16r02 \
        16rC0 16rFA 16r02 16r17 16r71 16r21 16r50 16rCA 16rF3 16rF5 \
       ] \
    #( #leftShift #rightShift #capsLock  )) >

<primitive 112 pTempVar 17  " keyQualifiers " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " keyCode " \
  #( #[ 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " getVanillaKey " \
  #( #[ 16r51 16r52 16r20 16rFA 16r03 16rDE 16rF1 16r60 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " translateKey: " \
  #( #[ 16r20 16r80 16r00 16rF7 16r0A 16r51 16r51 16r21 16r5B 16rFA 16r04 \
        16rDE 16rF3 16rF8 16r09 16rF2 16r51 16r51 16r21 16r5C 16rFA \
        16r04 16rDE 16rF3 16rF2 16rF5] \
    #( #keyShifted  )) >

<primitive 112 pTempVar 21  " getRawKey " \
  #( #[ 16r51 16r50 16r20 16rFA 16r03 16rDE 16rF1 16r60 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " registerTo: " \
  #( #[ 16r21 16r62 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " initialize " \
  #( #[ 16r50 16r60 16r50 16r61 16rF5] \
    #(  )) >

<primitive 98 #Key \
  <primitive 97 #Key #Device #AmigaTalk:System/Keyboard.st \
   #(  #keyCode #keyQualifier #aWindow ) \
   #( #repeatKey #numericPad #middleMouseButton #rightMouseButton  \
       #leftMouseButton #rightAmiga #leftAmiga #rightAlt #leftAlt #control #capsLock  \
       #rightShift #leftShift #keyAlternated #keyControlled #keyShifted #keyQualifiers  \
       #keyCode #getVanillaKey #translateKey: #getRawKey #registerTo: #initialize  ) \
  pTempVar 2 7 > #ordinary >

pTempVar <- <primitive 110 61 >
<primitive 112 pTempVar 1  " csi " \
  #( #[ 16r30 16rFA 16r01 16r60 16rF3 16rF5] \
    #( 16r9B  )) >

<primitive 112 pTempVar 2  " putString: " \
  #( #[ 16r50 16r55 16r10 16r21 16rFA 16r04 16rDE 16rF2 16r20 16r80 16r00 \
        16rF2 16rF5] \
    #( #crlf  )) >

<primitive 112 pTempVar 3  " putStringNoReturn: " \
  #( #[ 16r50 16r55 16r10 16r21 16rFA 16r04 16rDE 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " putChar: " \
  #( #[ 16r50 16r54 16r10 16r21 16rFA 16r04 16rDE 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " getString " \
  #( #[ 16r50 16r53 16r10 16rFA 16r03 16rDE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " getChar " \
  #( #[ 16r50 16r52 16r10 16rFA 16r03 16rDE 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " clearToBottom " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #esc '0J' #putString:  )) >

<primitive 112 pTempVar 8  " clear " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #esc '2J' #putString:  )) >

<primitive 112 pTempVar 9  " reset " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #esc 'c' #putString:  )) >

<primitive 112 pTempVar 10  " esc " \
  #( #[ 16r30 16rFA 16r01 16r60 16rF3 16rF5] \
    #( 16r1B  )) >

<primitive 112 pTempVar 11  " reset: " \
  #( #[ 16r20 16r80 16r00 16rF2 16rF5] \
    #( #reset  )) >

<primitive 112 pTempVar 12  " forwardTabs: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'I' #putString:  )) >

<primitive 112 pTempVar 13  " tab " \
  #( #[ 16r20 16r59 16r80 16r00 16r81 16r01 16rF2 16rF5] \
    #( #asCharacter #putChar:  )) >

<primitive 112 pTempVar 14  " backTab " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '1Z' #putString:  )) >

<primitive 112 pTempVar 15  " setTab " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '0W' #putString:  )) >

<primitive 112 pTempVar 16  " clearTab " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '2W' #putString:  )) >

<primitive 112 pTempVar 17  " clearTabs " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '5W' #putString:  )) >

<primitive 112 pTempVar 18  " setTopOffset: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'y' #putString:  )) >

<primitive 112 pTempVar 19  " setLeftOffset: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'x' #putString:  )) >

<primitive 112 pTempVar 20  " setLineLength: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'u' #putString:  )) >

<primitive 112 pTempVar 21  " setPageLength: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 't' #putString:  )) >

<primitive 112 pTempVar 22  " autoWrapOn " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '?7h' #putString:  )) >

<primitive 112 pTempVar 23  " autoWrapOff " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '?7l' #putString:  )) >

<primitive 112 pTempVar 24  " disableScroll " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '>1l' #putString:  )) >

<primitive 112 pTempVar 25  " enableScroll " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '>1h' #putString:  )) >

<primitive 112 pTempVar 26  " backgroundColor: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r31 16rC0 16r0A 16r11 16r0B 16r12 \
        16r32 16r0B 16r12 16r21 16r33 16rC0 16r0A 16r11 16r0B 16r12 \
        16r34 16r0B 16r12 16r81 16r05 16rF2 16rF5] \
    #( #csi 40 ';>' 30 'm' #putString:  )) >

<primitive 112 pTempVar 27  " textColor: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r31 16rC0 16r0A 16r11 16r0B 16r12 \
        16r32 16r0B 16r12 16r81 16r03 16rF2 16rF5] \
    #( #csi 30 'm' #putString:  )) >

<primitive 112 pTempVar 28  " cursorVisible " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi ' p' #putString:  )) >

<primitive 112 pTempVar 29  " cursorInvisible " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '0 p' #putString:  )) >

<primitive 112 pTempVar 30  " visibleText " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '28m' #putString:  )) >

<primitive 112 pTempVar 31  " invisibleText " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '8m' #putString:  )) >

<primitive 112 pTempVar 32  " invertedCharsOff " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '27m' #putString:  )) >

<primitive 112 pTempVar 33  " invertedChars " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '7m' #putString:  )) >

<primitive 112 pTempVar 34  " underlineCharsOff " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '24m' #putString:  )) >

<primitive 112 pTempVar 35  " underlineChars " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '4m' #putString:  )) >

<primitive 112 pTempVar 36  " italicCharsOff " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '23m' #putString:  )) >

<primitive 112 pTempVar 37  " italicChars " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '3m' #putString:  )) >

<primitive 112 pTempVar 38  " boldCharsOff " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '22m' #putString:  )) >

<primitive 112 pTempVar 39  " boldChars " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '1m' #putString:  )) >

<primitive 112 pTempVar 40  " normalChars " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '0m' #putString:  )) >

<primitive 112 pTempVar 41  " deleteCharacters: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'P' #putString:  )) >

<primitive 112 pTempVar 42  " deleteCurrentChar " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '0P' #putString:  )) >

<primitive 112 pTempVar 43  " deleteCurrentLine " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi 'M' #putString:  )) >

<primitive 112 pTempVar 44  " insertSpaces: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi '@' #putString:  )) >

<primitive 112 pTempVar 45  " insertLineBelowCurrent " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi 'L' #putString:  )) >

<primitive 112 pTempVar 46  " moveCursorLeft: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'D' #putString:  )) >

<primitive 112 pTempVar 47  " moveCursorRight: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'C' #putString:  )) >

<primitive 112 pTempVar 48  " moveCursorDown: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'B' #putString:  )) >

<primitive 112 pTempVar 49  " moveCursorUp: " \
  #( #[ 16r20 16r20 16r80 16r00 16r21 16r0A 16r11 16r0B 16r12 16r31 16r0B \
        16r12 16r81 16r02 16rF2 16rF5] \
    #( #csi 'A' #putString:  )) >

<primitive 112 pTempVar 50  " prevLineStart " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi '1F' #putString:  )) >

<primitive 112 pTempVar 51  " nextLineStart " \
  #( #[ 16r20 16r30 16r80 16r01 16r81 16r02 16rF2 16rF5] \
    #( 16r85 #asCharacter #putChar:  )) >

<primitive 112 pTempVar 52  " moveCursorTo: " \
  #( #[ 16r21 16r0A 16r31 16r73 16r21 16r0A 16r32 16r74 16r20 16r80 16r00 \
        16r24 16r0A 16r11 16r0B 16r12 16r31 16r0B 16r12 16r23 16r0A \
        16r11 16r0B 16r12 16r32 16r0B 16r12 16r72 16r20 16r22 16r81 \
        16r03 16rF2 16rF5] \
    #( #csi ';' 'H' #putString:  )) >

<primitive 112 pTempVar 53  " cursorToHome " \
  #( #[ 16r20 16r20 16r80 16r00 16r31 16r0B 16r12 16r81 16r02 16rF2 16rF5 \
       ] \
    #( #csi 'H' #putString:  )) >

<primitive 112 pTempVar 54  " crlf " \
  #( #[ 16r20 16r80 16r00 16rF2 16r20 16r80 16r01 16rF2 16rF5] \
    #( #carriageReturn #lineFeed  )) >

<primitive 112 pTempVar 55  " bell " \
  #( #[ 16r20 16r57 16r80 16r00 16r81 16r01 16rF2 16rF5] \
    #( #asCharacter #putChar:  )) >

<primitive 112 pTempVar 56  " carriageReturn " \
  #( #[ 16r20 16r30 16r80 16r01 16r81 16r02 16rF2 16rF5] \
    #( 13 #asCharacter #putChar:  )) >

<primitive 112 pTempVar 57  " lineFeed " \
  #( #[ 16r20 16r30 16r80 16r01 16r81 16r02 16rF2 16rF5] \
    #( 10 #asCharacter #putChar:  )) >

<primitive 112 pTempVar 58  " formFeed " \
  #( #[ 16r20 16r30 16r80 16r01 16r81 16r02 16rF2 16rF5] \
    #( 12 #asCharacter #putChar:  )) >

<primitive 112 pTempVar 59  " backSpace " \
  #( #[ 16r20 16r58 16r80 16r00 16r81 16r01 16rF2 16rF5] \
    #( #asCharacter #putChar:  )) >

<primitive 112 pTempVar 60  " initialize:for: " \
  #( #[ 16r50 16r51 16r22 16r21 16rFA 16r04 16rDE 16r60 16r22 16r61 16r20 \
        16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 61  " dispose " \
  #( #[ 16r50 16r50 16r10 16rFA 16r03 16rDE 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 98 #Console \
  <primitive 97 #Console #Device #AmigaTalk:System/Console.st \
   #(  #private #myWindow ) \
   #( #csi #putString: #putStringNoReturn: #putChar: #getString #getChar  \
       #clearToBottom #clear #reset #esc #reset: #forwardTabs: #tab #backTab #setTab  \
       #clearTab #clearTabs #setTopOffset: #setLeftOffset: #setLineLength:  \
       #setPageLength: #autoWrapOn #autoWrapOff #disableScroll #enableScroll  \
       #backgroundColor: #textColor: #cursorVisible #cursorInvisible #visibleText  \
       #invisibleText #invertedCharsOff #invertedChars #underlineCharsOff #underlineChars  \
       #italicCharsOff #italicChars #boldCharsOff #boldChars #normalChars #deleteCharacters:  \
       #deleteCurrentChar #deleteCurrentLine #insertSpaces: #insertLineBelowCurrent  \
       #moveCursorLeft: #moveCursorRight: #moveCursorDown: #moveCursorUp: #prevLineStart  \
       #nextLineStart #moveCursorTo: #cursorToHome #crlf #bell #carriageReturn #lineFeed  \
       #formFeed #backSpace #initialize:for: #dispose  ) \
  pTempVar 5 6 > #ordinary >

pTempVar <- <primitive 110 25 >
<primitive 112 pTempVar 1  " translateSCSIErrorNumber: " \
  #( #[ 16r05 16r16 16r21 16rFA 16r02 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " writeSCSICommand: " \
  #( #[ 16r05 16r15 16r10 16r11 16r21 16rFA 16r04 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " readSCSICommand " \
  #( #[ 16r05 16r14 16r10 16r11 16rFA 16r03 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " formatSCSIDevice:at: " \
  #( #[ 16r05 16r13 16r10 16r11 16r21 16r22 16rFA 16r05 16rE2 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 5  " setSCSISenseDataField: " \
  #( #[ 16r05 16r17 16r10 16r21 16rFA 16r03 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " getSenseDataInto: " \
  #( #[ 16r05 16r12 16r10 16r21 16rFA 16r03 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " setSCSIStatusField: " \
  #( #[ 16r05 16r11 16r10 16r21 16rFA 16r03 16rE2 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " setSCSIFlagsField: " \
  #( #[ 16r05 16r10 16r10 16r21 16rFA 16r03 16rE2 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " scsiStatus " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE2 16rF3 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 10  " actualSense " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE2 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 11  " actualCommandUsed " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE2 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 12  " setSCSICommandField: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rE2 16rF2 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 13  " actualDataUsedSize " \
  #( #[ 16r30 16r10 16rFA 16r02 16rE2 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 14  " setSCSIDataField: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rE2 16rF2 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 15  " sendSCSIDirectCommand " \
  #( #[ 16r59 16r10 16r11 16rFA 16r03 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 16  " seekTo: " \
  #( #[ 16r58 16r11 16r21 16rFA 16r03 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 17  " diskChanged " \
  #( #[ 16r57 16r11 16rFA 16r02 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " protectionStatus " \
  #( #[ 16r56 16r11 16rFA 16r02 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " start " \
  #( #[ 16r55 16r11 16rFA 16r02 16rE2 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " stop " \
  #( #[ 16r54 16r11 16rFA 16r02 16rE2 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " write: " \
  #( #[ 16r53 16r10 16r11 16r21 16rFA 16r04 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " readInto: " \
  #( #[ 16r52 16r10 16r11 16r21 16rFA 16r04 16rE2 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " open:unit: " \
  #( #[ 16r51 16r20 16r21 16r22 16rFA 16r04 16rE2 16r73 16r23 16r5B 16rC9 \
        16rF7 16r03 16r22 16rF1 16r63 16rF2 16r23 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " setUnit:lun:id: " \
  #( #[ 16r21 16r05 16r64 16rC2 16r22 16r30 16rC2 16rC0 16r23 16rC0 16rF1 \
        16r63 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 25  " close " \
  #( #[ 16r50 16r10 16r11 16r12 16rFA 16r04 16rE2 16rF2 16r55 16r50 16r10 \
        16rFA 16r03 16rFA 16rF2 16r55 16r50 16r11 16rFA 16r03 16rFA \
        16rF2 16r55 16r50 16r12 16rFA 16r03 16rFA 16rF2 16r5D 16r63 \
        16rF5] \
    #(  )) >

<primitive 98 #SCSIDevice \
  <primitive 97 #SCSIDevice #Device #AmigaTalk:System/SCSI.st \
   #(  #private1 #private2 #private3 #unitNumber ) \
   #( #translateSCSIErrorNumber: #writeSCSICommand: #readSCSICommand  \
       #formatSCSIDevice:at: #setSCSISenseDataField: #getSenseDataInto: #setSCSIStatusField:  \
       #setSCSIFlagsField: #scsiStatus #actualSense #actualCommandUsed #setSCSICommandField:  \
       #actualDataUsedSize #setSCSIDataField: #sendSCSIDirectCommand #seekTo: #diskChanged  \
       #protectionStatus #start #stop #write: #readInto: #open:unit: #setUnit:lun:id: #close  ) \
  pTempVar 4 6 > #ordinary >

pTempVar <- <primitive 110 38 >
<primitive 112 pTempVar 1  " open:unit: " \
  #( #[ 16r50 16r51 16r20 16r21 16r22 16rFA 16r05 16rDA 16r73 16r23 16r5B \
        16rC9 16rF7 16r03 16r22 16rF1 16r63 16rF2 16r23 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 2  " close " \
  #( #[ 16r50 16r50 16r20 16rFA 16r03 16rDA 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r55 16r50 16r11 16rFA 16r03 16rFA 16rF2 \
        16r55 16r50 16r12 16rFA 16r03 16rFA 16rF2 16r5D 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 3  " playLSN:startingAt: " \
  #( #[ 16r50 16r30 16r11 16r21 16r22 16rFA 16r05 16rDA 16rF3 16rF5] \
    #( 30  )) >

<primitive 112 pTempVar 4  " playMSF:startingAt: " \
  #( #[ 16r50 16r05 16r1D 16r11 16r21 16r22 16rFA 16r05 16rDA 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 5  " playTracks:startingAt: " \
  #( #[ 16r50 16r05 16r1C 16r11 16r21 16r22 16rFA 16r05 16rDA 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 6  " resumePlay " \
  #( #[ 16r50 16r59 16r11 16r5C 16rFA 16r04 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " pausePlay " \
  #( #[ 16r50 16r59 16r11 16r5B 16rFA 16r04 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " encloseDisk " \
  #( #[ 16r50 16r30 16r11 16r5C 16rFA 16r04 16rDA 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 9  " eject " \
  #( #[ 16r50 16r30 16r11 16r5B 16rFA 16r04 16rDA 16rF3 16rF5] \
    #( 13  )) >

<primitive 112 pTempVar 10  " motorOff " \
  #( #[ 16r50 16r30 16r11 16r5C 16rFA 16r04 16rDA 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 11  " writeProtected " \
  #( #[ 16r50 16r05 16r13 16r11 16rFA 16r03 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 12  " validDisk " \
  #( #[ 16r50 16r05 16r12 16r11 16rFA 16r03 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 13  " changeCount " \
  #( #[ 16r50 16r05 16r11 16r11 16rFA 16r03 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 14  " removeFrameInterrupt: " \
  #( #[ 16r50 16r30 16r11 16r21 16rFA 16r04 16rDA 16rF2 16rF5] \
    #( 38  )) >

<primitive 112 pTempVar 15  " addFrameInterrupt: " \
  #( #[ 16r50 16r30 16r10 16r11 16r21 16rFA 16r05 16rDA 16rF3 16rF5] \
    #( 37  )) >

<primitive 112 pTempVar 16  " removeChangeInterrupt: " \
  #( #[ 16r50 16r30 16r11 16r21 16rFA 16r04 16rDA 16rF2 16rF5] \
    #( 36  )) >

<primitive 112 pTempVar 17  " addChangeInterrupt: " \
  #( #[ 16r50 16r30 16r10 16r11 16r21 16rFA 16r05 16rDA 16rF3 16rF5] \
    #( 35  )) >

<primitive 112 pTempVar 18  " attenuateBy:for: " \
  #( #[ 16r50 16r30 16r11 16r22 16r21 16rFA 16r05 16rDA 16rF3 16rF5] \
    #( 34  )) >

<primitive 112 pTempVar 19  " qCodeLSN " \
  #( #[ 16r50 16r30 16r10 16r11 16rFA 16r04 16rDA 16rF3 16rF5] \
    #( 33  )) >

<primitive 112 pTempVar 20  " qCodeMSF " \
  #( #[ 16r50 16r30 16r10 16r11 16rFA 16r04 16rDA 16rF3 16rF5] \
    #( 32  )) >

<primitive 112 pTempVar 21  " search: " \
  #( #[ 16r50 16r30 16r11 16r21 16rFA 16r04 16rDA 16rF3 16rF5] \
    #( 31  )) >

<primitive 112 pTempVar 22  " readXL:startingAt: " \
  #( #[ 16r50 16r05 16r1B 16r10 16r11 16r21 16r22 16rFA 16r06 16rDA 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " contentsLSN:startingAt: " \
  #( #[ 16r50 16r05 16r1A 16r10 16r11 16r21 16r22 16rFA 16r06 16rDA 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " contentsMSF:startingAt: " \
  #( #[ 16r50 16r05 16r19 16r10 16r11 16r21 16r22 16rFA 16r06 16rDA 16rF3 \
        16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " configure: " \
  #( #[ 16r50 16r05 16r18 16r11 16r21 16rFA 16r04 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 26  " cdInfo " \
  #( #[ 16r50 16r05 16r17 16r10 16r11 16rFA 16r04 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " seekTo: " \
  #( #[ 16r50 16r30 16r11 16r21 16rFA 16r04 16rDA 16rF2 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 28  " motorOn " \
  #( #[ 16r50 16r30 16r11 16r5B 16rFA 16r04 16rDA 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 29  " getGeometry: " \
  #( #[ 16r50 16r05 16r16 16r11 16r21 16rFA 16r04 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 30  " readInto:start: " \
  #( #[ 16r50 16r54 16r11 16r21 16r22 16rFA 16r05 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 31  " translateCDErrorNumber: " \
  #( #[ 16r50 16r52 16r21 16rFA 16r03 16rDA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 32  " status " \
  #( #[ 16r50 16r30 16r10 16rFA 16r03 16rDA 16rF3 16rF5] \
    #( 47  )) >

<primitive 112 pTempVar 33  " audioPrecision " \
  #( #[ 16r50 16r30 16r10 16rFA 16r03 16rDA 16rF3 16rF5] \
    #( 46  )) >

<primitive 112 pTempVar 34  " maxSpeed " \
  #( #[ 16r50 16r30 16r10 16rFA 16r03 16rDA 16rF3 16rF5] \
    #( 45  )) >

<primitive 112 pTempVar 35  " sectorSize " \
  #( #[ 16r50 16r30 16r10 16rFA 16r03 16rDA 16rF3 16rF5] \
    #( 44  )) >

<primitive 112 pTempVar 36  " readXLSpeed " \
  #( #[ 16r50 16r30 16r10 16rFA 16r03 16rDA 16rF3 16rF5] \
    #( 43  )) >

<primitive 112 pTempVar 37  " readSpeed " \
  #( #[ 16r50 16r30 16r10 16rFA 16r03 16rDA 16rF3 16rF5] \
    #( 42  )) >

<primitive 112 pTempVar 38  " playSpeed " \
  #( #[ 16r50 16r30 16r10 16rFA 16r03 16rDA 16rF3 16rF5] \
    #( 41  )) >

<primitive 98 #CD \
  <primitive 97 #CD #Device #AmigaTalk:System/CDDevice.st \
   #(  #private1 #private2 #private3 #unitNumber ) \
   #( #open:unit: #close #playLSN:startingAt: #playMSF:startingAt:  \
       #playTracks:startingAt: #resumePlay #pausePlay #encloseDisk #eject #motorOff #writeProtected  \
       #validDisk #changeCount #removeFrameInterrupt: #addFrameInterrupt:  \
       #removeChangeInterrupt: #addChangeInterrupt: #attenuateBy:for: #qCodeLSN #qCodeMSF #search:  \
       #readXL:startingAt: #contentsLSN:startingAt: #contentsMSF:startingAt: #configure: #cdInfo  \
       #seekTo: #motorOn #getGeometry: #readInto:start: #translateCDErrorNumber:  \
       #status #audioPrecision #maxSpeed #sectorSize #readXLSpeed #readSpeed  \
       #playSpeed  ) \
  pTempVar 4 7 > #ordinary >

pTempVar <- <primitive 110 11 >
<primitive 112 pTempVar 1  " driveFlags " \
  #( #[ 16r05 16r23 16r52 16rB0 16r71 16r50 16r53 16r10 16r21 16r05 16r1D \
        16rFA 16r05 16rD1 16rF2 16r21 16r51 16rB1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " driveType " \
  #( #[ 16r05 16r23 16r52 16rB0 16r71 16r50 16r53 16r10 16r21 16r05 16r1C \
        16rFA 16r05 16rD1 16rF2 16r21 16r51 16rB1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " bufferMemoryType " \
  #( #[ 16r05 16r23 16r54 16rB0 16r71 16r50 16r53 16r10 16r21 16r05 16r18 \
        16rFA 16r05 16rD1 16rF2 16r21 16r51 16rB1 16r05 16r18 16rC4 \
        16r72 16r22 16r21 16r52 16rB1 16r05 16r10 16rC4 16rC0 16r72 \
        16r22 16r21 16r53 16rB1 16r58 16rC4 16rC0 16r72 16r22 16r21 \
        16r54 16rB1 16rC0 16r72 16r22 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " sectorsPerTrack " \
  #( #[ 16r05 16r23 16r54 16rB0 16r71 16r50 16r53 16r10 16r21 16r05 16r14 \
        16rFA 16r05 16rD1 16rF2 16r21 16r51 16rB1 16r05 16r18 16rC4 \
        16r72 16r22 16r21 16r52 16rB1 16r05 16r10 16rC4 16rC0 16r72 \
        16r22 16r21 16r53 16rB1 16r58 16rC4 16rC0 16r72 16r22 16r21 \
        16r54 16rB1 16rC0 16r72 16r22 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " numberSurfaces " \
  #( #[ 16r05 16r23 16r54 16rB0 16r71 16r50 16r53 16r10 16r21 16r05 16r10 \
        16rFA 16r05 16rD1 16rF2 16r21 16r51 16rB1 16r05 16r18 16rC4 \
        16r72 16r22 16r21 16r52 16rB1 16r05 16r10 16rC4 16rC0 16r72 \
        16r22 16r21 16r53 16rB1 16r58 16rC4 16rC0 16r72 16r22 16r21 \
        16r54 16rB1 16rC0 16r72 16r22 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " sectorsPerCylinder " \
  #( #[ 16r05 16r23 16r54 16rB0 16r71 16r50 16r53 16r10 16r21 16r30 16rFA \
        16r05 16rD1 16rF2 16r21 16r51 16rB1 16r05 16r18 16rC4 16r72 \
        16r22 16r21 16r52 16rB1 16r05 16r10 16rC4 16rC0 16r72 16r22 \
        16r21 16r53 16rB1 16r58 16rC4 16rC0 16r72 16r22 16r21 16r54 \
        16rB1 16rC0 16r72 16r22 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 7  " numCylinders " \
  #( #[ 16r05 16r23 16r54 16rB0 16r71 16r50 16r53 16r10 16r21 16r58 16rFA \
        16r05 16rD1 16rF2 16r21 16r51 16rB1 16r05 16r18 16rC4 16r72 \
        16r22 16r21 16r52 16rB1 16r05 16r10 16rC4 16rC0 16r72 16r22 \
        16r21 16r53 16rB1 16r58 16rC4 16rC0 16r72 16r22 16r21 16r54 \
        16rB1 16rC0 16r72 16r22 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " totalSectors " \
  #( #[ 16r05 16r23 16r54 16rB0 16r71 16r50 16r53 16r10 16r21 16r54 16rFA \
        16r05 16rD1 16rF2 16r21 16r51 16rB1 16r05 16r18 16rC4 16r72 \
        16r22 16r21 16r52 16rB1 16r05 16r10 16rC4 16rC0 16r72 16r22 \
        16r21 16r53 16rB1 16r58 16rC4 16rC0 16r72 16r22 16r21 16r54 \
        16rB1 16rC0 16r72 16r22 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " sectorSize " \
  #( #[ 16r05 16r23 16r54 16rB0 16r71 16r50 16r53 16r10 16r21 16r50 16rFA \
        16r05 16rD1 16rF2 16r21 16r51 16rB1 16r05 16r18 16rC4 16r72 \
        16r22 16r21 16r52 16rB1 16r05 16r10 16rC4 16rC0 16r72 16r22 \
        16r21 16r53 16rB1 16r58 16rC4 16rC0 16r72 16r22 16r21 16r54 \
        16rB1 16rC0 16r72 16r22 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " dispose " \
  #( #[ 16r50 16r30 16r10 16rFA 16r03 16rDA 16rF2 16r55 16r50 16r10 16rFA \
        16r03 16rFA 16rF2 16r5D 16rF3 16rF5] \
    #( 40  )) >

<primitive 112 pTempVar 11  " newGeometryObject " \
  #( #[ 16r50 16r30 16rFA 16r02 16rDA 16rF1 16r60 16rF3 16rF5] \
    #( 39  )) >

<primitive 98 #DriveGeometry \
  <primitive 97 #DriveGeometry #ByteArray #AmigaTalk:System/CDDevice.st \
   #(  #private ) \
   #( #driveFlags #driveType #bufferMemoryType #sectorsPerTrack  \
       #numberSurfaces #sectorsPerCylinder #numCylinders #totalSectors #sectorSize #dispose  \
       #newGeometryObject  ) \
  pTempVar 3 6 > #ordinary >

pTempVar <- <primitive 110 6 >
<primitive 112 pTempVar 1  " privateInitializeDictionary " \
  #( #[ 16r20 16r30 16r51 16rD0 16rF2 16r20 16r31 16r52 16rD0 16rF2 16r20 \
        16r32 16r53 16rD0 16rF2 16r20 16r33 16r54 16rD0 16rF2 16r20 \
        16r34 16r55 16rD0 16rF2 16r20 16r35 16r56 16rD0 16rF2 16r20 \
        16r36 16r50 16rD0 16rF2 16r20 16r37 16r51 16rD0 16rF2 16r20 \
        16r38 16r52 16rD0 16rF2 16r20 16r39 16r51 16rD0 16rF2 16r20 \
        16r3A 16r52 16rD0 16rF2 16r20 16r3B 16r54 16rD0 16rF2 16r20 \
        16r3C 16r58 16rD0 16rF2 16r20 16r3D 16r05 16r10 16rD0 16rF2 \
        16r20 16r3E 16r3F 16rD0 16rF2 16r20 16r03 16r10 16r05 16r40 \
        16rD0 16rF2 16r20 16r03 16r11 16r05 16r80 16rD0 16rF2 16r20 \
        16r03 16r12 16r03 16r13 16rD0 16rF2 16r20 16r03 16r14 16r03 \
        16r15 16rD0 16rF2 16r20 16r03 16r16 16r03 16r17 16rD0 16rF2 \
        16r20 16r03 16r18 16r03 16r19 16rD0 16rF2 16r20 16r03 16r1A \
        16r03 16r1B 16rD0 16rF2 16r20 16r03 16r1C 16r03 16r1D 16rD0 \
        16rF2 16r20 16r03 16r1E 16r03 16r1F 16rD0 16rF2 16r20 16r03 \
        16r20 16r03 16r21 16rD0 16rF2 16r20 16r03 16r22 16r03 16r23 \
        16rD0 16rF2 16r20 16r03 16r24 16r03 16r25 16rD0 16rF2 16r20 \
        16r03 16r26 16r03 16r27 16rD0 16rF2 16r20 16r03 16r28 16r03 \
        16r29 16rD0 16rF2 16r20 16r03 16r2A 16r03 16r2B 16rD0 16rF2 \
        16r20 16r03 16r2C 16r03 16r2D 16rD0 16rF2 16r20 16r03 16r2E \
        16r03 16r2F 16rD0 16rF2 16rF5] \
    #( #TAGCD_PLAYSPEED #TAGCD_READSPEED #TAGCD_READXLSPEED #TAGCD_SECTORSIZE \
        #TAGCD_XLECC #TAGCD_EJECTRESET #CDMODE_NORMAL #CDMODE_FFWD #CDMODE_FREV \
        #CDSTSF_CLOSED #CDSTSF_DISK #CDSTSF_SPIN #CDSTSF_TOC #CDSTSF_CDROM \
        #CDSTSF_PLAYING 32 #CDSTSF_PAUSED #CDSTSF_SEARCH #CDSTSF_DIRECTION \
        256 #CTLADR_CTLMASK 16rF0 #CTL_CTLMASK 16rD0 #CTL_2AUD 16r00 #CTL_2AUDEMPH \
        16r10 #CTL_4AUD 16r80 #CTL_4AUDEMPH 16r90 #CTL_DATA 16r40 #CTL_COPYMASK \
        16r20 #CTL_COPY 16r20 #CTLADR_ADRMASK 16r0F #ADR_POSITION 16r01 \
        #ADR_UPC 16r02 #ADR_ISRC 16r03 #ADR_HYBRID 16r05  )) >

<primitive 112 pTempVar 2  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r07 16r20 16r80 16r00 16r60 16r20 16r80 16r01 \
        16rF2 16r20 16rF3 16rF5] \
    #( #privateNew #privateInitializeDictionary  )) >

<primitive 112 pTempVar 3  " getTag: " \
  #( #[ 16r20 16r21 16rB1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 5  " privateNew " \
  #( #[ 16r20 16r90 16r00 16r71 16r21 16rF3 16rF5] \
    #( #new  )) >

<primitive 112 pTempVar 6  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #CDTags \
  <primitive 97 #CDTags #Dictionary #AmigaTalk:System/CDDevice.st \
   #(  #uniqueInstance ) \
   #( #privateInitializeDictionary #privateSetup #getTag: #new #privateNew  \
       #isSingleton  ) \
  pTempVar 2 4 > #isSingleton >

pTempVar <- <primitive 110 11 >
<primitive 112 pTempVar 1  " new " \
  #( #[ 16r20 16r90 16r00 16rF2 16r20 16r31 16rB0 16rF3 16rF5] \
    #( #new 'Default_AmigaTalk_MPort'  )) >

<primitive 112 pTempVar 2  " new: " \
  #( #[ 16r56 16r21 16rFA 16r02 16rBF 16r60 16r21 16r61 16r20 16rF3 16rF5 \
       ] \
    #(  )) >

<primitive 112 pTempVar 3  " getMsgPort " \
  #( #[ 16r58 16r10 16rFA 16r02 16rBF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " getNamedSystemPort: " \
  #( #[ 16r55 16r21 16rFA 16r02 16rBF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " checkForPort " \
  #( #[ 16r54 16r10 16rFA 16r02 16rBF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " sendMessageOutsideTo:msg: " \
  #( #[ 16r57 16r10 16r21 16r22 16rFA 16r04 16rBF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 7  " selectMessagePort " \
  #( #[ 16r50 16r58 16rFA 16r02 16rFA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 8  " sendMessage:msg: " \
  #( #[ 16r53 16r10 16r21 16r22 16rFA 16r04 16rBF 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 9  " getMessage " \
  #( #[ 16r52 16r10 16rFA 16r02 16rBF 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " addPort:priority: " \
  #( #[ 16r51 16r10 16r21 16r22 16rFA 16r04 16rBF 16r5D 16rB6 16rF7 16r0C \
        16r20 16r30 16r11 16r0B 16r12 16r31 16r0B 16r12 16rBD 16rF2 \
        16r5C 16rF3 16rF2 16r5B 16rF3 16rF5] \
    #( 'MsgPort ' ' NOT added to System!'  )) >

<primitive 112 pTempVar 11  " killPort " \
  #( #[ 16r50 16r10 16rFA 16r02 16rBF 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 98 #MsgPort \
  <primitive 97 #MsgPort #Object #AmigaTalk:System/MsgPort.st \
   #(  #private #portName ) \
   #( #new #new: #getMsgPort #getNamedSystemPort: #checkForPort  \
       #sendMessageOutsideTo:msg: #selectMessagePort #sendMessage:msg: #getMessage #addPort:priority:  \
       #killPort  ) \
  pTempVar 3 5 > #ordinary >

pTempVar <- <primitive 110 5 >
<primitive 112 pTempVar 1  " privateSetup " \
  #( #[ 16r10 16rA1 16rF7 16r74 16r20 16r80 16r00 16r60 16r20 16r31 16r32 \
        16rD0 16rF2 16r20 16r33 16r34 16rD0 16rF2 16r20 16r35 16r36 \
        16rD0 16rF2 16r20 16r37 16r38 16rD0 16rF2 16r20 16r39 16r3A \
        16rD0 16rF2 16r20 16r3B 16r3C 16rD0 16rF2 16r20 16r3D 16r3E \
        16rD0 16rF2 16r20 16r3F 16r03 16r10 16rD0 16rF2 16r20 16r03 \
        16r11 16r03 16r12 16rD0 16rF2 16r20 16r03 16r13 16r03 16r14 \
        16rD0 16rF2 16r20 16r03 16r15 16r03 16r16 16rD0 16rF2 16r20 \
        16r03 16r17 16r03 16r18 16rD0 16rF2 16r20 16r03 16r19 16r03 \
        16r1A 16rD0 16rF2 16r20 16r03 16r1B 16r03 16r1C 16rD0 16rF2 \
        16r20 16r03 16r1D 16r03 16r1E 16rD0 16rF2 16r20 16r03 16r1F \
        16r03 16r20 16rD0 16rF2 16r20 16r03 16r21 16r03 16r22 16rD0 \
        16rF2 16r20 16r03 16r23 16r03 16r24 16rD0 16rF2 16r5D 16rF2 \
        16r20 16rF3 16rF5] \
    #( #privateNew #RXCOMM 16r01000000 #RXFUNC 16r02000000 #RXCLOSE 16r03000000 \
        #RXQUERY 16r04000000 #RXADDFH 16r07000000 #RXADDLIB 16r08000000 \
        #RXREMLIB 16r09000000 #RXADDCON 16r0A000000 #RXREMCON 16r0B000000 \
        #RXTCOPN 16r0C000000 #RXTCCLS 16r0D000000 #RXFF_NOIO 16r10000 #RXFF_RESULT \
        16r20000 #RXFF_STRING 16r40000 #RXFF_TOKEN 16r80000 #RXFF_NONRET \
        16r100000 #RXCODEMASK 16rFF000000 #RXARGMASK 16r0000000F  )) >

<primitive 112 pTempVar 2  " arexxTag: " \
  #( #[ 16r20 16r21 16rB1 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " new " \
  #( #[ 16r20 16r80 16r00 16rF3 16rF5] \
    #( #privateSetup  )) >

<primitive 112 pTempVar 4  " privateNew " \
  #( #[ 16r20 16r90 16r00 16r71 16r21 16rF3 16rF5] \
    #( #new  )) >

<primitive 112 pTempVar 5  " isSingleton " \
  #( #[ 16r5B 16rF3 16rF5] \
    #(  )) >

<primitive 98 #ARexxTags \
  <primitive 97 #ARexxTags #Dictionary #AmigaTalk:System/ARexx.st \
   #(  #uniqueInstance ) \
   #( #privateSetup #arexxTag: #new #privateNew #isSingleton  ) \
  pTempVar 2 6 > #isSingleton >

pTempVar <- <primitive 110 5 >
<primitive 112 pTempVar 1  " value " \
  #( #[ 16r11 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " length " \
  #( #[ 16r55 16r10 16rFA 16r02 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " dispose " \
  #( #[ 16r54 16r10 16rFA 16r02 16rD3 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " new: " \
  #( #[ 16r21 16rA3 16r72 16r21 16r61 16r53 16r21 16r22 16rFA 16r03 16rD3 \
        16r60 16r20 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " new " \
  #( #[ 16r20 16r30 16r91 16r01 16rF2 16r5D 16rF3 16rF5] \
    #( 'Use "new: aString" to instantiate ARexxArg!' #error:  )) >

<primitive 98 #ARexxArg \
  <primitive 97 #ARexxArg #Object #AmigaTalk:System/ARexx.st \
   #(  #private #myValue ) \
   #( #value #length #dispose #new: #new  ) \
  pTempVar 3 4 > #ordinary >

pTempVar <- <primitive 110 27 >
<primitive 112 pTempVar 1  " close " \
  #( #[ 16r50 16r10 16rFA 16r02 16rD3 16rF2 16r55 16r50 16r10 16rFA 16r03 \
        16rFA 16rF2 16r5D 16r61 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 2  " portNameIs " \
  #( #[ 16r05 16r16 16r10 16rFA 16r02 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 3  " setRexxVar:with: " \
  #( #[ 16r05 16r1C 16r10 16r21 16r22 16rFA 16r04 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 4  " getRexxVar:into: " \
  #( #[ 16r05 16r1B 16r10 16r21 16r22 16rFA 16r04 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 5  " checkRexxMsg " \
  #( #[ 16r05 16r1A 16r10 16rFA 16r02 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 6  " getArgument: " \
  #( #[ 16r21 16r51 16rCC 16rFC 16r04 16r21 16r05 16r10 16rC8 16rF7 16r09 \
        16r05 16r13 16r10 16r21 16r51 16rC1 16rFA 16r03 16rD3 16rF2 \
        16r21 16r51 16rC8 16rF7 16r07 16r05 16r13 16r10 16r50 16rFA \
        16r03 16rD3 16rF2 16r21 16r05 16r10 16rCC 16rF7 16r02 16r30 \
        16rA8 16rF2 16rF5] \
    #( 'argNumber value out of range for getArgument:'  )) >

<primitive 112 pTempVar 7  " setArgument:to: " \
  #( #[ 16r20 16r21 16r11 16r22 16r83 16r00 16rF2 16rF5] \
    #( #setArgument:for:to:  )) >

<primitive 112 pTempVar 8  " setArgument:for:to: " \
  #( #[ 16r21 16r51 16rCC 16rFC 16r04 16r21 16r05 16r10 16rC8 16rF7 16r0A \
        16r05 16r12 16r22 16r21 16r51 16rC1 16r23 16rFA 16r04 16rD3 \
        16rF2 16r21 16r51 16rC8 16rF7 16r08 16r05 16r12 16r22 16r50 \
        16r23 16rFA 16r04 16rD3 16rF2 16r21 16r05 16r10 16rCC 16rF7 \
        16r02 16r30 16rA8 16rF2 16rF5] \
    #( 'argNumber value out of range for setArgument:to:'  )) >

<primitive 112 pTempVar 9  " getSecondaryResult " \
  #( #[ 16r05 16r11 16r10 16rFA 16r02 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 10  " getPrimaryResult " \
  #( #[ 16r05 16r10 16r10 16rFA 16r02 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 11  " setRMAction: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rD3 16rF2 16rF5] \
    #( 15  )) >

<primitive 112 pTempVar 12  " getRexxMsg " \
  #( #[ 16r30 16r10 16rFA 16r02 16rD3 16rF3 16rF5] \
    #( 14  )) >

<primitive 112 pTempVar 13  " arrayToArgs: " \
  #( #[ 16r21 16rA3 16r05 16r10 16rCC 16rF7 16r05 16r30 16rA8 16rF2 16r5D \
        16rF3 16rF2 16r31 16r10 16r21 16rFA 16r03 16rD3 16rF2 16rF5 \
       ] \
    #( 'inputArray too large for ARexxPort method!' 13  )) >

<primitive 112 pTempVar 14  " sendRexxCmd: " \
  #( #[ 16r30 16r10 16r21 16rFA 16r03 16rD3 16rF3 16rF5] \
    #( 12  )) >

<primitive 112 pTempVar 15  " isRexxMsg: " \
  #( #[ 16r30 16r21 16rFA 16r02 16rD3 16rF3 16rF5] \
    #( 11  )) >

<primitive 112 pTempVar 16  " fillRexxMsg:count:mask: " \
  #( #[ 16r30 16r21 16r22 16r23 16rFA 16r04 16rD3 16rF3 16rF5] \
    #( 10  )) >

<primitive 112 pTempVar 17  " clearRexxMsg:count: " \
  #( #[ 16r59 16r21 16r22 16rFA 16r03 16rD3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 18  " disposeRexxMsg: " \
  #( #[ 16r58 16r21 16rFA 16r02 16rD3 16rF2 16r55 16r50 16r21 16rFA 16r03 \
        16rFA 16rF2 16r5D 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 19  " sendOutMessage:to: " \
  #( #[ 16r05 16r18 16r10 16r22 16r21 16rFA 16r04 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 20  " createRexxMsg:extension:port: " \
  #( #[ 16r57 16r21 16r22 16r23 16rFA 16r04 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 21  " selectARexxPort " \
  #( #[ 16r50 16r58 16rFA 16r02 16rFA 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 22  " findARexxPort: " \
  #( #[ 16r05 16r17 16r12 16rFA 16r02 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 23  " fileExtension " \
  #( #[ 16r05 16r15 16r10 16rFA 16r02 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 24  " fileExtension: " \
  #( #[ 16r05 16r14 16r10 16r21 16rFA 16r03 16rD3 16rF2 16rF5] \
    #(  )) >

<primitive 112 pTempVar 25  " defaultExtension " \
  #( #[ 16r56 16rFA 16r01 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 26  " errorIs: " \
  #( #[ 16r52 16r21 16rFA 16r02 16rD3 16rF3 16rF5] \
    #(  )) >

<primitive 112 pTempVar 27  " open: " \
  #( #[ 16r21 16r62 16r51 16r21 16rFA 16r02 16rD3 16r60 16r05 16r19 16r10 \
        16rFA 16r02 16rD3 16r61 16r10 16rF3 16rF5] \
    #(  )) >

<primitive 98 #ARexxPort \
  <primitive 97 #ARexxPort #Object #AmigaTalk:System/ARexx.st \
   #(  #private #myRexxMsg #portName ) \
   #( #close #portNameIs #setRexxVar:with: #getRexxVar:into: #checkRexxMsg  \
       #getArgument: #setArgument:to: #setArgument:for:to: #getSecondaryResult  \
       #getPrimaryResult #setRMAction: #getRexxMsg #arrayToArgs: #sendRexxCmd: #isRexxMsg:  \
       #fillRexxMsg:count:mask: #clearRexxMsg:count: #disposeRexxMsg: #sendOutMessage:to:  \
       #createRexxMsg:extension:port: #selectARexxPort #findARexxPort: #fileExtension #fileExtension:  \
       #defaultExtension #errorIs: #open:  ) \
  pTempVar 4 6 > #ordinary >

