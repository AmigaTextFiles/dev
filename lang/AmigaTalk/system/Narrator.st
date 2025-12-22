" ----------------------------------------------------------------------"
" Narrator Class is derived from abstract Device Class.                 "

"  WARNING:  You should know what you're doing to the Amiga OS before   "
"            messing with this Class, or any other System Class!        " 

" This class is a Singleton Class, meaning there can be only one 
  narrator per AmigaTalk program (what would more than one narrator
  talking at the same time sound like, anyway?)
"
" ----------------------------------------------------------------------"

Class Narrator :Device ! uniqueInstance !
[
  isSingleton

      ^ true
|
  close

      <primitive 230 0 self>.
      
      <primitive 250 5 0 self>.
      
      ^ nil
|
  privateOpen

      "Use new method instead."

      ^ <primitive 230 1>
|
  setVolume: newSpeakingVolume

      "Range:  0 to 64 (max)"

      ^ <primitive 230 2 newSpeakingVolume>
| 
  setSex: newSpeakerSex

      "Female = 0, & Male = 1"

      ^ <primitive 230 3 newSpeakerSex>
| 
  setPitch: newSpeakingPitch

      "Range:  65 to 320Hz"
      ^ <primitive 230 4 newSpeakingPitch>
|
  setMode: newModeString

      "valid string settings are: robotic, natural & manual"
      ^ <primitive 230 5 newModeString>
|
  setRate: newSpeakingRate

      "Range: 40 to 400 words/minute"
      ^ <primitive 230 6 newSpeakingRate>
|
  setFormant1: percentDeviation 

      "Range: -100 to 100 in steps of 5, Default = 0"
      ^ <primitive 230 7 1 percentDeviation>
|
  setFormant2: percentDeviation 

      "Range: -100 to 100 in steps of 5, Default = 0"
      ^ <primitive 230 7 2 percentDeviation>
|
  setFormant3: percentDeviation 

      "Range: -100 to 100 in steps of 5, Default = 0"
      ^ <primitive 230 7 3 percentDeviation>
| 
  setFormant1Amplitude: newAmplitude

      "RANGE: 31 to -32 dB."
      ^ <primitive 230 8 1 newAmplitude>
| 
  setFormant2Amplitude: newAmplitude

      "RANGE: 31 to -32 dB."
      ^ <primitive 230 8 2 newAmplitude>
| 
  setFormant3Amplitude: newAmplitude

      "RANGE: 31 to -32 dB."
      ^ <primitive 230 8 3 newAmplitude>
|
  setEnthusiasm: aFloat

      "From 1/32 to 32/32 only (32/32 = default)"
      ^ <primitive 230 9 aFloat>
|
  setPriority: newSpeakingPriority

      "Range: -128 to 127, Default = 100"
      ^ <primitive 230 10 newSpeakingPriority>
| 
  setPitchModulation: voiceQuiver

      "Range: 0 to 255"
      ^ <primitive 230 11 voiceQuiver>
| 
  setArticulation: newPercentArticulation

      "Set amount of slurring of words.  Range:  0 to 255% (max)"
      ^ <primitive 230 12 newPercentArticulation>
| 
  setPhoneme: phonemeString

      "Used with setCentralizeValue: to change the accent of Narrator."

      "Valid strings are:"
      
      "IY  long  e as in beet,   eat.
       IH  short i as in bit,    in.
       EH  short e as in bet,    end.
       AE  short a as in bat,    ad.
       AA  short o as in bottle, on.
       AH  short u as in but,    up.
       AO  short a as in ball,   awl.
       OW  long  o as in boat,   own.     (diphthong)
       UH  short u as in book,   soot.
       ER  short i as in bird,   early.
       UW  long  u as in brew,   boolean. (diphthong)"

      "No checking is performed on your string, so get it right!" 

      ^ <primitive 230 13 phonemeString>
| 
  setCentralizeValue: newCentralizePercent

      "Used with setPhoneme: to change the accent of Narrator."
      "Range: 0 to 100%"
      ^ <primitive 230 14 newCentralizePercent>
| 
  setFlags: newFlags 

      "NDF_NEWIORB = 1, NDF_WORDSYNC = 2, NDF_SYLSYNC = 4"
      ^ <primitive 230 15 newFlags>
| 
  setVoicingAmplitude: newAVBias  

      "RANGE: 31 to -32 dB."
      ^ <primitive 230 16 newAVBias>
| 
  setFricationAmplitude: newAFBias 

      "RANGE: 31 to -32 dB."
      ^ <primitive 230 17 newAFBias>
| 
  speak: normalString

      ^ <primitive 230 18 normalString>
| 
  speakPhonetics: phoneticString
      ^ <primitive 230 19 phoneticString>
| 
  translateText: aString

      "Returns a Phonetic string representation of aString"
      ^ <primitive 230 20 aString>
|
  new: aValue

      'Cannot use new: method on Narrator class!' print.
      ^ nil
|
  privateSetup ! check !

      (uniqueInstance isNil)
         ifTrue: [ check <- (self privateOpen).

                   (check = 0)
                      ifTrue:  [ uniqueInstance <- 'MyNarrator'.
                                 ^ self
                               ]
                      ifFalse: [ 'Problem opening Narrator:' print.
                                 <primitive 230 21 check> print.
                                 ^ uniqueInstance <- nil
                               ] 
                 ]
|
  new 

      ^ (self privateSetup)
]
