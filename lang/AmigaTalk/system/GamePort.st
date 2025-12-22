" ---------------------------------------------------------------------"
" GamePort Class is an abstract Class that allows the user of AmigaTalk"
" to utilize the GamePort Device that the Amiga PC uses to detect      "
" input events, such as mouse movement or button clicks or joystick    "
" movement. "
" ---------------------------------------------------------------------"
"  WARNING:  You should know what you're doing to the Amiga OS before  "
"            messing with this Class, or any other System Class!       "
" ---------------------------------------------------------------------"

Class GamePort :Device
[
  openGamePort: whichUnit
    ^ super subclassResponsibility: 'openGamePort:'
|
  getControllerType: portObject
    "The integer returned by this method is one of the following: "

     "  GPCT_ALLOCATED    -1"
     "  GPCT_NOCONTROLLER  0"
     "  GPCT_MOUSE         1" 
     "  GPCT_RELJOYSTICK   2"
     "  GPCT_ABSJOYSTICK   3"
    ^ <primitive 223 7 portObject>
|
  new: dummy
    ^ super doesNotUnderstand: 'new:' 
]

" -------------------------------------------------------------------- "
" Mouse Class allows the User to setup & use a Mouse.                  "
" -------------------------------------------------------------------- "

Class Mouse :GamePort ! private !
[
  getControllerType
    ^ (super getControllerType: private)
|
  openMousePort: whichUnit ! chk !
    private <- <primitive 223 1 whichUnit>.

    chk <- <primitive 223 7 private>.

    (chk == 0)    " Port NOT being used?? "
       ifTrue:  [ <primitive 223 8 private 1>.  "GPCT_MOUSE <- 1"
                  ^ self
                ]
       ifFalse: [ self error: 'Mouse port ',whichUnit,' already in use!'. 
                  ^ nil
                ]
|   
  closeMousePort
    <primitive 223 0 private>
|
  clearMousePortBuffer
    <primitive 223 6 private>
|
  getButtonCode
    ^ <primitive 223 10 private>
|
  getQualifiers
    ^ <primitive 223 11 private>
|
  getXPos
    ^ <primitive 223 12 private>
|
  getYPos
    ^ <primitive 223 13 private>
|
  getIEAddress
    ^ <primitive 223 14 private>
|
  getTimeStamp
    ^ <primitive 223 15 private>
|   
  getTriggerKeys
    ^ <primitive 223 16 private>
|
  getTriggerTime
    ^ <primitive 223 17 private>
|         
  getTriggerXDelta
    ^ <primitive 223 18 private>
|
  getTriggerYDelta
    ^ <primitive 223 19 private>
|
  setKeyTransition: transType

    "GPTF_UPKEYS = 2, GPTF_DOWNKEYS = 1 or GPTF_DOWNKEYS + GPTF_UPKEYS:"

    (transType >= 1 & transType <= 3)
      ifTrue:  [ <primitive 223 2 private transType> ]
      ifFalse: [ 'transType parameter out of range (1 to 3 only)!' print ]
|
  setTimeTransition: timeOutValue
    (timeOutValue < 0)
      ifTrue: [ 'timeOutValue out of range (S/B >= 0).' print.
                ^ nil 
              ].
    <primitive 223 3 private timeOutValue>
|
  setXDeltaTransition: xvalue
    <primitive 223 4 private xvalue>
|
  setYDeltaTransition: yvalue
    <primitive 223 5 private yvalue>
|
  waitForButton:    kvalue ! ret !
    ret <- self getButtonCode.
    [ret = kvalue] whileFalse: [ret <- self getButtonCode]
|
  waitForQualifier: qvalue ! ret !
    ret <- self getQualifiers.
    [ret = qvalue] whileFalse: [ret <- self getQualifiers]
|
  waitForXPos: xvalue ! ret !
    ret <- self getXPos.
    [ret = xvalue] whileFalse: [ret <- self getXPos]
|
  waitForYPos: yvalue ! ret !
    ret <- self getYPos.
    [ret = yvalue] whileFalse: [ret <- self getYPos]
|
  new: whichUnit
    ^ (self openMousePort: whichUnit)
]

" -------------------------------------------------------------------- "
" AbsJoyStick Class allows the User to setup & use an Absolute-type    "
" JoyStick."
" -------------------------------------------------------------------- "

Class AbsJoyStick :GamePort ! private !
[
  getControllerType
    ^ (super getControllerType: private)
|
  openGamePort: whichUnit ! chk !
    private <- <primitive 223 1 whichUnit>.

    chk <- <primitive 223 7 private>.

    (chk == 0)
       ifTrue:  [ <primitive 223 8 private 3>. "GPCT_ABSJOYSTICK <- 3"
                  ^ self
                ]
       ifFalse: [ self error: 'Game port ',whichUnit,' already in use!'. 
                  ^ nil
                ]
|   
  closeGamePort
    <primitive 223 0 private>
|
  clearGamePortBuffer
    <primitive 223 6 private>
|
  getButtonCode
    ^ <primitive 223 10 private>
|
  getQualifiers
    ^ <primitive 223 11 private>
|
  getXPos
    ^ <primitive 223 12 private>
|
  getYPos
    ^ <primitive 223 13 private>
|
  getIEAddress
    ^ <primitive 223 14 private>
|
  getTimeStamp
    ^ <primitive 223 15 private>
|   
  getTriggerKeys
    ^ <primitive 223 16 private>
|
  getTriggerTime
    ^ <primitive 223 17 private>
|         
  getTriggerXDelta
    ^ <primitive 223 18 private>
|
  getTriggerYDelta
    ^ <primitive 223 19 private>
|
  setKeyTransition: transType

    "GPTF_UPKEYS = 2, GPTF_DOWNKEYS = 1 or GPTF_DOWNKEYS + GPTF_UPKEYS:"

    (transType >= 1 & transType <= 3)
      ifTrue:  [ <primitive 223 2 private transType> ]
      ifFalse: [ 'transType parameter out of range (1 to 3 only)!' print ]
|
  setTimeTransition: timeOutValue
    (timeOutValue < 0)
      ifTrue: [ 'timeOutValue out of range (S/B >= 0).' print.
                ^ nil 
              ].
    <primitive 223 3 private timeOutValue>
|
  setXDeltaTransition: xvalue
    <primitive 223 4 private xvalue>
|
  setYDeltaTransition: yvalue
    <primitive 223 5 private yvalue>
|
  waitForButton:    kvalue ! ret !
    ret <- self getButtonCode.
    [ret = kvalue] whileFalse: [ret <- self getButtonCode]
|
  waitForQualifier: qvalue ! ret !
    ret <- self getQualifiers.
    [ret = qvalue] whileFalse: [ret <- self getQualifiers]
|
  waitForXPos: xvalue ! ret !
    ret <- self getXPos.
    [ret = xvalue] whileFalse: [ret <- self getXPos]
|
  waitForYPos: yvalue ! ret !
    ret <- self getYPos.
    [ret = yvalue] whileFalse: [ret <- self getYPos]
|
  new: whichUnit
    ^ (self openGamePort: whichUnit)
]

" -------------------------------------------------------------------- "
" RelJoyStick Class allows the User to setup & use a Relative-type     "
" JoyStick."
" -------------------------------------------------------------------- "

Class RelJoyStick :GamePort ! private !
[
  getControllerType
    ^ (super getControllerType: private)
|
  openGamePort: whichUnit ! chk !
    private <- <primitive 223 1 whichUnit>.

    chk <- <primitive 223 7 private>.

    (chk == 0)
       ifTrue:  [ <primitive 223 8 private 2>. "GPCT_RELJOYSTICK <- 2"
                  ^ self
                ]
       ifFalse: [ self error: 'Game port ',whichUnit,' already in use!'. 
                  ^ nil
                ]
|   
  closeGamePort
    <primitive 223 0 private>
|
  clearGamePortBuffer
    <primitive 223 6 private>
|
  getButtonCode
    ^ <primitive 223 10 private>
|
  getQualifiers
    ^ <primitive 223 11 private>
|
  getXPos
    ^ <primitive 223 12 private>
|
  getYPos
    ^ <primitive 223 13 private>
|
  getIEAddress
    ^ <primitive 223 14 private>
|
  getTimeStamp
    ^ <primitive 223 15 private>
|   
  getTriggerKeys
    ^ <primitive 223 16 private>
|
  getTriggerTime
    ^ <primitive 223 17 private>
|         
  getTriggerXDelta
    ^ <primitive 223 18 private>
|
  getTriggerYDelta
    ^ <primitive 223 19 private>
|
  setKeyTransition: transType

    "GPTF_UPKEYS = 2, GPTF_DOWNKEYS = 1 or GPTF_DOWNKEYS + GPTF_UPKEYS:"

    (transType >= 1 & transType <= 3)
      ifTrue:  [ <primitive 223 2 private transType> ]
      ifFalse: [ 'transType parameter out of range (1 to 3 only)!' print ]
|
  setTimeTransition: timeOutValue
    (timeOutValue < 0)
      ifTrue: [ 'timeOutValue out of range (S/B >= 0).' print.
                ^ nil 
              ].
    <primitive 223 3 private timeOutValue>
|
  setXDeltaTransition: xvalue
    <primitive 223 4 private xvalue>
|
  setYDeltaTransition: yvalue
    <primitive 223 5 private yvalue>
|
  waitForButton:    kvalue ! ret !
    ret <- self getButtonCode.
    [ret = kvalue] whileFalse: [ret <- self getButtonCode]
|
  waitForQualifier: qvalue ! ret !
    ret <- self getQualifiers.
    [ret = qvalue] whileFalse: [ret <- self getQualifiers]
|
  waitForXPos: xvalue ! ret !
    ret <- self getXPos.
    [ret = xvalue] whileFalse: [ret <- self getXPos]
|
  waitForYPos: yvalue ! ret !
    ret <- self getYPos.
    [ret = yvalue] whileFalse: [ret <- self getYPos]
|
  new: whichUnit
    ^ (self openGamePort: whichUnit)
]
