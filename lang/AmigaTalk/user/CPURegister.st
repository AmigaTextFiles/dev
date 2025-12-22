" ---------------------------------------------------------------- "
" Register.st - Implementation of an Abstract CPU register         "
"               object.                                            "
" ================================================================ "
" numBits       = size (in bits) of the Register                   "  
" contents      = the value in the Register                        "
" window        = the GUI Window that the Register is displayed in "
" numberBase    = Binary, Octal or Hexadecimal number base         "
" intuiText     = IntuiText Object for the contents                "
" labelIText    = Logical name of the Register (ex: 'PC')          "
" containerBBox = Frame around the Register contents               " 
" viObj         = visualInfo Object from the GUI Screen            "
" ---------------------------------------------------------------- "

Class Register :Integer
! numBits       contents window         numberBase intuiText 
  containerBBox viObj    defaultBoxType labelIText
!
[
   new: regSize ! intuition !
   
     intuition <- Intuition new.
     numBits   <- regSize.
     contents  <- 0.
     
     defaultBoxType <- (intuition systemTag: #GTBB_Recessed).
     
     ^ self
|
   initializeLabel: labelText at: startPoint

     labelIText <- IText new: labelText.

     labelIText setITextOrigin: startPoint.
|
   initializeIText: theText at: startPoint
   
     intuiText <- IText new: theText.

     intuiText setITextOrigin: startPoint.
|
   attachTo: thisWindow ! scr !

     " window & screen already have to be open for this method: "

     window <- thisWindow.

     scr    <- window screen.

     viObj  <- scr getVisualInfo.
|
   containerType: newBoxType 
   
     " range: 0 to 3 "
   
     defaultBoxType <- newBoxType
|
   basis: newBasis
   
     numberBase <- newBasis
|     
   display: newValue at: startPoint
   
     self xxxErase: contents.
     self value: newValue.
     
     intuiText setITextOrigin: startPoint.
          
     self xxxDrawContainer: defaultBoxType for: intuiText.
     self xxxDrawContents:  contents.
     self xxxDrawLabel:     labelIText.
|
   setupDisplayPens: fgBgPens

     " fgBgPens is a Point Object: "   

     intuiText setPens: fgBgPens
|
   value: newContents
   
     contents <- newContents
|
   value
   
     ^ contents
|
   xxxDrawContents: newContents
   
     intuiText setText: newContents
     
     window printIText: intuiText at: (intuiText getITextOrigin).
|
   xxxDrawLabel: labelContents
   
     labelIText setText: labelContents
     
     window printIText: labelIText at: (labelIText getITextOrigin).
|
   xxxErase: oldContents ! pens !
   
     pens <- intuiText getPens.
     
     intuiText setPens: (pens y) @ (pens x). " reverse the Pens "

     " Now draw over the displayed text: "     

     window printIText: intuiText at: (intuiText getITextOrigin).
|
   xxxContainerSize

     " textSize returns a Point Object: "
        
     ^ intuiText textSize. 
|
   xxxDrawContainer: boxType for: itext ! x y w h scr sizePt startPt !
   
     containerBBox <- BevelBox new.
     
     startPt       <- itext getITextOrigin.
     sizePt        <- self xxxContainerSize.
     
     x <- startPt x.
     y <- startPt y.
     
     (x > 2)
        ifTrue:  [ x <- x - 2. w <- (sizePt x) + 2. ]
        ifFalse: [ w <- (sizePt x) + 4 ].

     (y > 2)
        ifTrue:  [ y <- y - 2. h <- (sizePt y) + 2. ]
        ifFalse: [ h <- (sizePt y) + 4 ].
        
     containerBBox setupBoxX: x y: y width: w height: h flags: boxType.

     containerBBox drawBoxOn: window with: viObj.
]

" ---------------------------------------------------------------- "
" ByteRegister.st - Implementation of an 8-bit CPU register        "
"                   object.  Most of the methods are defined in    "
" the parent class Register.                                       "
" ================================================================ "
" myBasis = Binary, Octal or Hexadecimal number base               "
" ---------------------------------------------------------------- "

Class ByteRegister :Register ! myBasis !
[
   new: newValueString
   
     super new:   8.
     super value: newValueString.
     super basis: 2.
     
     myBasis <- 2.
     
     ^ self
|
   changeBasis: newBasis
   
     super basis: newBasis.
     
     myBasis <- newBasis.
|
   setContentsTo: newValue
   
     (newValue isKindOf: Integer)
       ifTrue: [ (myBasis = 2) 
                   ifTrue:  [ ^ super value: (newValue asBareBinary) ].
                  
                 (myBasis = 8)
                   ifTrue:  [ ^ super value: (newValue asBareOctal) ].  
                 
                 (myBasis = 16)  
                   ifTrue:  [ ^ super value: (newValue asBareHex) ]
                   ifFalse: [ ^ super value: 'nil' ]            
               ].

     (newValue isKindOf: String)
       ifTrue:  [ ^ super value: newValue ]
       ifFalse: [ ^ super value: 'nil' ]
|
   displayIn: thisWindow
   
     super attachTo: thisWindow.
]

" ---------------------------------------------------------------- "
" WordRegister.st - Implementation of an 16-bit CPU register       "
"                   object.  Most of the methods are defined in    "
" the parent class Register.                                       "
" ================================================================ "
" myBasis = Binary, Octal or Hexadecimal number base               "
" ---------------------------------------------------------------- "

Class WordRegister :Register ! myBasis !
[
   new: newValueString
   
     super new:   16.
     super value: newValueString.
     super basis: 2.
     
     myBasis <- 2.
     
     ^ self
|
   changeBasis: newBasis
   
     super basis: newBasis.
     
     myBasis <- newBasis.
|
   setContentsTo: newValue
   
     (newValue isKindOf: Integer)
       ifTrue: [ (myBasis = 2) 
                   ifTrue:  [ ^ super value: (newValue asBareBinary) ].
                  
                 (myBasis = 8)
                   ifTrue:  [ ^ super value: (newValue asBareOctal) ].  
                 
                 (myBasis = 16)  
                   ifTrue:  [ ^ super value: (newValue asBareHex) ]
                   ifFalse: [ ^ super value: 'nil' ]            
               ].

     (newValue isKindOf: String)
       ifTrue:  [ ^ super value: newValue ]
       ifFalse: [ ^ super value: 'nil' ]
|
   displayIn: thisWindow
   
     super attachTo: thisWindow.
]

" ---------------------------------------------------------------- "
" LongWordRegister.st - Implementation of an 32-bit CPU register   "
"                   object.  Most of the methods are defined in    "
" the parent class Register.                                       "
" ================================================================ "
" myBasis = Binary, Octal or Hexadecimal number base               "
" ---------------------------------------------------------------- "

Class LongWordRegister :Register ! myBasis !
[
   new: newValueString
   
     super new:   32.
     super value: newValueString.
     super basis: 16.
     
     myBasis <- 16.
     
     ^ self
|
   changeBasis: newBasis
   
     super basis: newBasis.
     
     myBasis <- newBasis.
|
   setContentsTo: newValue
   
     (newValue isKindOf: Integer)
       ifTrue: [ (myBasis = 2) 
                   ifTrue:  [ ^ super value: (newValue asBareBinary) ].
                  
                 (myBasis = 8)
                   ifTrue:  [ ^ super value: (newValue asBareOctal) ].  
                 
                 (myBasis = 16)  
                   ifTrue:  [ ^ super value: (newValue asBareHex) ]
                   ifFalse: [ ^ super value: 'nil' ]            
               ].

     (newValue isKindOf: String)
       ifTrue:  [ ^ super value: newValue ]
       ifFalse: [ ^ super value: 'nil' ]
|
   displayIn: thisWindow
   
     super attachTo: thisWindow.
]

