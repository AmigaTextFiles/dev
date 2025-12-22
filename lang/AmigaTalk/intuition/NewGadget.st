" --------------------------------------------------------------------- 
* This class is necessary for setting up the environment for a bunch of
* NewGadgets, since a GUI usually has more than one Gadget in it. 
* --------------------------------------------------------------------- 
" 
Class GadgetSystem :Array 
! private0 private1 library viObj textAttr !
[
   new: forUserGUI
      
      (library isNil)
         ifTrue: [ library <- <primitive 190 1 'gadtools.library' 39> ].

      textAttr   <- forUserGUI textAttributes.
      viObj      <- forUserGUI visualInfo.
         
      private0 <- <primitive 239 0 1>.          "Allocate GList "
      private1 <- <primitive 239 0 2 private0>. "CreateContext()"
      
      ^ self
|
   gadgetList
      
      ^ private0
|
   dispose   
      <primitive 239 0 0 private0>. "FreeGadgets(); FreeVec()"

      private1 <- nil.
      
      private0 <- nil.

      (library notNil)
         ifTrue: [ <primitive 190 0 library>. 
                   library <- nil ].
      ^ nil
|
   gadgetContext

      ^ private1
|
   visualInfo
      
      " Used by subclasses "
      ^ viObj
|
   textAttributes
      
      " Used by subclasses "
      ^ textAttr
|
   addGadgetToList: newGadgetObj at: gadgetObj type: gType tags: tagArray
      ! rval !
      
      " tagArray can be nil here.
      * Equivalent to CreateGadgetA() from gadtools.library: 
      "
      
      rval <- <primitive 239 0 4 gadgetObj newGadgetObj gType tagArray>.

      (rval isNil)
        ifTrue: [ super error: 'Ran out of memory for GadTools Gadgets!'.

                  ^ nil ]. 
      
      self grow: rval.
      
      ^ rval
]

" ---------------------------------------------------------------------
* This class contains common methods for all the different types of
* NewGadgets in this file.
* ---------------------------------------------------------------------
"
Class CommonGadget :Glyph 
! nGadStruct structArray myAspect myGadget gType windowObj intuition !
[
   glyphType
   
      ^ gType 
|
   isDisplayed

      ^ (windowObj notNil) " For now "
|
   window
   
      ^ windowObj
|
   registerTo: aWindowObject

      (aWindowObject isNil)
         ifTrue: [ 'NewGadget Object given a nil Window object!' print.

                   ^ nil                 ].

      ^ windowObj <- aWindowObject
|
   dispose

      <primitive 239 0 7 nGadStruct>.

      <primitive 250 5 0 nGadStruct>.
      
      ^ nil
|
   gadgetTypeFor: typeSymbol
   
      (intuition isNil)
         ifTrue: [intuition <- Intuition new].
         
      ^ gType <- intuition systemTag: typeSymbol
|
   defaultOrientationFor: typeSymbol
   
      " This method only pertains to Scrollers & Sliders: "

      (intuition isNil)
         ifTrue: [intuition <- Intuition new].
         
      (typeSymbol = #SCROLLER_KIND)
         ifTrue:  [ ^ intuition systemTag: #LORIENT_HORIZ ].
         
      (typeSymbol = #SLIDER_KIND)   
         ifTrue:  [ ^ intuition systemTag: #LORIENT_HORIZ ]
         ifFalse: [ ^ intuition systemTag: #LORIENT_NONE  ].
|
   test: gadgetName ! ans !

      amigatalk setIOTitle:   'Test NewGadget Action:'.
      
      ans <- amigatalk getUserResponse: ('You pressed: ', gadgetName, 
                                         ' Do you want to continue?').
      (ans = 0)
         ifTrue:  [ ^ true  ]
         ifFalse: [ ^ false ] " Terminate UserGUI/controlLoop "
|
   gadgetType
   
      ^ gType
|
   gadget 
   
      ^ myGadget
|
   gadgetName

      (gType = (self gadgetTypeFor: #GENERIC_KIND))
        ifFalse: [ ^ (structArray at: 5) ]
        ifTrue:  [ ^ (structArray at: 7) ]
|
   value: newAspect

      " Set the Displayed Gadget to newAspect: "
      <primitive 239 0 14 myGadget windowObj newAspect>.
      
      ^ myAspect <- newAspect
|
   value

      ^ myAspect
|
   setup: srcArray
   
      ^ self xxxSetupStruct: structArray with: srcArray 
|
   addToGList: gadgetList at: gadgetObject with: tagArray
   
      myGadget <- gadgetList addGadgetToList: nGadStruct 
                                          at: gadgetObject 
                                        type: (structArray at: 11) 
                                        tags: tagArray.
                                        
      ^ myGadget
|
   setValue  " make instance variable reflect the Gadget contents. "

                    " Obtain the Displayed Gadget value: "      
      ^ self value: <primitive 239 0 13 myGadget windowObj gType>.
|
   initializeControl 
   
      ^ true
|
   newGadget: gadgetType

      ^ self xxxSetup: gadgetType.
|
   initializeValue: newAspect
   
      ^ myAspect <- newAspect 
|
   xxxMakeGadgetWith: structureArray
   
      ^ nGadStruct <- <primitive 239 0 3 structureArray (structureArray size)>
|
   xxxCopy: srcArray to: destArray
      
      (1 to: (srcArray size)) 
         do: [ :ele | destArray at: ele
                               put: (srcArray at: ele) ].
      ^ destArray
|
   xxxSetupStruct: destArray with: srcArray

      " Copy user array to internal storage: "

      self xxxCopy: srcArray to: destArray.
             
      ^ self xxxMakeGadgetWith: destArray.
|
   xxxSetup: gadgetType

      gType       <- gadgetType.
      
      myAspect    <- nil.

      myGadget    <- nil.

      windowObj   <- nil.
      
      nGadStruct  <- nil.
            
      structArray <- Array new: 12.

      structArray at: 11 put: gadgetType.
            
      ^ self
]

" ---------------------------------------------------------------------
* These classes are meant for use with UserGUI & its subclasses.
* They do NOT allow for remote updating via the underlying model.  
* The corresponding Auto??Gadget classes do.

* In general, all NewGadget classes should have the following notes
* adhered to:
*
* structArray is an Array Object with the following elements in the     
* given order:
*   ele[1]  <- ng_LeftEdge,   ele[2]  <- ng_TopEdge,
*   ele[3]  <- ng_Width,      ele[4]  <- ng_Height,
*   ele[5]  <- ng_GadgetText, ele[6]  <- ng_TextAttr,
*   ele[7]  <- ng_GadgetID,   ele[8]  <- ng_Flags,
*   ele[9]  <- ng_VisualInfo, ele[10] <- ng_UserData
*
*   ele[11] <- NewGadget Type Tag
*   ele[12] <- HotKey or nil.
*
*   ele[10] (UserData) can be any AmigaTalk object 
*   but I recommend that you use a #methodSymbol.
*
*   ele[7] (GadgetID) should be a 16-Bit Integer value.
* ---------------------------------------------------------------------
"

" ---------------------------------------------------------------------
* This Class is a simple Image Button that displays a getFile glyph.
* Use it to indicate to the User that a fileName string Gadget can be
* filled from an ASL File Requester called by this GetFileGadget.
*
* structArray is an Array Object with the following elements blanked
* out:
*   ele[5]  <- nil,           
*   ele[6]  <- nil,
*   ele[12] <- nil.
* --------------------------------------------------------------------- 
" 
Class GetFileGadget :CommonGadget ! private myType gClass gImage !
[
   dispose
      
      super dispose.
      
      <primitive 239 0 18 gImage>.
      <primitive 239 0 17 gClass>.
      
      gClass <- nil.
      gImage <- nil.
      
      ^ nil
|
   setup: thisArray

      " Remove un-necessary fields: "
      thisArray at: 5  put: nil.
      thisArray at: 6  put: nil.
      thisArray at: 12 put: nil.

      private <- super xxxMakeGadgetWith: thisArray.
      
      gClass  <- <primitive 239 0 15>.

      gImage  <- <primitive 239 0 16 gClass (thisArray at: 9)>.

       ^ private
|
   addToGList: gadgetList at: gadgetObject with: tagArray ! chk gfGadget !
   
      gfGadget <- gadgetList addGadgetToList: private 
                                          at: gadgetObject 
                                        type: myType
                                        tags: tagArray.
                                        
      chk <- <primitive 239 0 19 gfGadget gImage>.
      
      (chk isNil)
          ifTrue: [ 'Bad parameter for GetFileGadget setup: method!' print.
                     ^ nil ].
         
      ^ gfGadget
|
   new: newAction

      myType <- (super gadgetTypeFor: #GENERIC_KIND).

      super newGadget: myType.

      super initializeValue: newAction.

      ^ self
|
   buttonPressed

      ^ self value " Subclasses should override this "
|
   testGetFileGadget ! fileName !

      amigatalk newIO: 'Select a file Name...' 
                title: 'Testing GetFileGadget Class:'.
      
      fileName <- amigatalk getFileName.
      
      ('   You selected: "', fileName,
       '" in testing GetFileGadget Class.') print.
      
      ^ true
]

" ---------------------------------------------------------------------
* This Class is meant for giving User control over actions that can be
* taken from the UserGUI, such as '_OKAY', or '_CANCEL' operations.
*
* Example usage:
* newGadget    <- ButtonGadget new
* newStruct    <- #( 10 40 100 20 'My _Gadget'
*                    textAttrObj gadgetID 
*                    myFlags vi userData 
*                    nil $G )
* 
* newGadgetObj <- newGadget setup: newStruct
* --------------------------------------------------------------------- 
" 
Class ButtonGadget :CommonGadget
[
   new: newAction

      super newGadget: (super gadgetTypeFor: #BUTTON_KIND).

      super initializeValue: newAction.

      ^ self
|
   buttonPressed

      ^ self value " Subclasses should override this "
|
   testButtonGadget

      ^ super test: (super gadgetName).
]

" ---------------------------------------------------------------------
* This Class is meant for giving User a way to choose to set/clear an
* option.
* --------------------------------------------------------------------- 
" 
Class CheckBoxGadget :CommonGadget
[
   new: newAction

      super newGadget: (super gadgetTypeFor: #CHECKBOX_KIND).
      
      super initializeValue: newAction.

      ^ self
|
   buttonPressed

      ^ self value " Subclasses should override this "
|
   testCheckBoxGadget

      ^ super test: (self gadgetName)
]

" ---------------------------------------------------------------------
* IntegerGadget class allows the User to enter an Integer value into
* a UserGUI & its subclasses.
* --------------------------------------------------------------------- 
" 
Class IntegerGadget :CommonGadget ! myInteger !
[
   new: newInteger

      super newGadget: (super gadgetTypeFor: #INTEGER_KIND).

      super initializeValue: newInteger.

      myInteger <- newInteger.
       
      ^ self
|
   value: newInteger

      ^ myInteger <- super value: newInteger
|
   value

      ^ myInteger <- super setValue
|
   testIntegerGadget

      self value.
            
      ('   User entered: "', myInteger asString, '"') print.

      ^ true
]

" ---------------------------------------------------------------------
* This Class is meant for giving the User a way to choose from a List
* of indeterminate length any String/Item displayed.
* --------------------------------------------------------------------- 
" 
Class ListViewGadget :CommonGadget 
! listSize listStruct lvmStruct  listArray !
[
   dispose
      
      <primitive 239 0 24 listStruct lvmStruct >.
      
      super dispose.
      
      <primitive 250 5 0 listStruct>.
      <primitive 250 5 0 lvmStruct >. " All bridges burned!! "

      ^ nil
|
   xxxMakePrivateStrings: theseStrings

      lvmStruct  <- <primitive 239 0 22 theseStrings>.      

      ^ listStruct <- <primitive 239 0 23 lvmStruct>.
|
   new: theseStrings ! defaultStrings !

      listArray <- theseStrings.

      super newGadget: (super gadgetTypeFor: #LISTVIEW_KIND).

      " ListView Gadgets require an exec List structure, not an array
      * of Strings, so convert the listArray to listStruct: 
      "
      ((theseStrings size) > 0)
         ifTrue:  [ listSize <- (theseStrings size).
                    
                    self xxxMakePrivateStrings: theseStrings. ]

         ifFalse: [ listSize       <- 3.
                    defaultStrings <- #( '        ' '        ' '        ' ).
                    listArray      <- defaultStrings.
                    
                    self xxxMakePrivateStrings: defaultStrings. ].
      ^ self
|
   value ! index !
   
      index <- super value.
      
      ^ (listArray at: index)
|
   choicesTag     " Script files need this! "

      ^ listStruct 
|
   initializeControl

      " Take care of things that can only be taken care of once the 
      * GUI Window is open:
      " 
      ('initializeControl ListView Gadget...') print.   

      <primitive 239 0 25 listStruct (super gadget) (super window) nil>.
      
      ^ true
|
   listContents
   
      ^ listArray
|
   selectionMade

      ^ self value " Subclasses should override this "
|
   setValue ! index gad type window ! 

      gad    <- super gadget.
      type   <- super gadgetType.
      window <- super window.
            
      " make instance variable reflect the Gadget contents. "
      
      index <- <primitive 239 0 13 gad window type>.

      ^ super value: index.
|
   testListViewGadget ! listChoiceString !

      self setValue. " Update so value method is correct first. "
      
      listChoiceString <- (self value).

      ('   You selected list item ', listChoiceString ) print.

      ^ true
]

" ---------------------------------------------------------------------
* This Class is meant for giving the User a way to choose from a List
* of Mutually exclusive choices.
* --------------------------------------------------------------------- 
" 
Class MXGadget :CommonGadget ! listSize private2 choiceArray !
[
   dispose

      <primitive 239 0 21 private2 (super gadgetType)>.
      
      super dispose.
      
      <primitive 250 5 0 private2>.
      
      ^ nil
|
   xxxMakePrivStrings: theseStrings ! maxSize !

      maxSize <- 1.
      
      " Find the longest String length for maxSize: "

      (1 to: (theseStrings size))
         do: [ :i | (((theseStrings at: i) size) > maxSize)
                     ifTrue: [ maxSize <- ((theseStrings at: i) size) ] ].

      ^ <primitive 239 0 20 (super gadgetType) maxSize theseStrings>.
|
   new: theseStrings

      choiceArray <- theseStrings.

      super newGadget: (super gadgetTypeFor: #MX_KIND).
      
      (theseStrings size > 0)
         ifTrue:  [ listSize <- theseStrings size.
                    private2 <- self xxxMakePrivStrings: theseStrings. ]

         ifFalse: [ listSize <- 3.
                    private2 <- self xxxMakePrivStrings: #( '            ' 
                                                            '            ' 
                                                            '            ' 
                                                          ). ].
      ^ self
|
   choicesTag    " Script files need this! "
   
      ^ private2
|
   choices
   
      ^ choiceArray
|
   selectionMade

      ^ self value " Subclasses should override this "
|
   value ! index !

      index <- super value.
      
      ^ (choiceArray at: index)
|
   setValue  ! index gad type window ! 
      
      gad    <- super gadget.
      type   <- super gadgetType.
      window <- super window.
            
      " make instance variable reflect the Gadget contents. "
      
      index <- <primitive 239 0 13 gad window type>.

      ^ super value: index.
|
   testMXGadget ! mxChoiceString !

      self setValue. " Update so value method is correct first. "
      
      mxChoiceString <- (self value).

      ('   You selected mx item ', mxChoiceString ) print.

      ^ true
]

" ---------------------------------------------------------------------
* NumberGadget class allows the User to view an Integer value in
* a UserGUI & its subclasses.
* --------------------------------------------------------------------- 
" 
Class NumberGadget :CommonGadget ! myNumber !
[
   new: newNumber

      super newGadget: (super gadgetTypeFor: #NUMBER_KIND).

      super initializeValue: newNumber.

      myNumber <- newNumber.
       
      ^ self
|
   value: newNumber

      ^ myNumber <- super value: newNumber
|
   value

      ^ myNumber <- super setValue.
|
   testNumberGadget

      ('   User sees: "', (super value) asString, '"') print.

      ^ true
]

" ---------------------------------------------------------------------
* This Class is meant for giving the User a way to choose from a List
* of choices.
* --------------------------------------------------------------------- 
" 
Class CycleGadget :CommonGadget ! listSize private2 choiceArray !
[
   dispose

      <primitive 239 0 21 private2 (super gadgetType)>.
      
      super dispose.
      
      <primitive 250 5 0 private2>.
      
      ^ nil
|
   xxxMakePrivStrings: theseStrings ! maxSize !

      maxSize <- 1.
      
      " Find the longest String length for maxSize: "

      (1 to: (theseStrings size))
         do: [ :i | (((theseStrings at: i) size) > maxSize)
                     ifTrue: [ maxSize <- ((theseStrings at: i) size) ] ].

      ^ <primitive 239 0 20 (super gadgetType) maxSize theseStrings>.
|
   new: theseStrings

      choiceArray <- theseStrings.
      
      super newGadget: (super gadgetTypeFor: #CYCLE_KIND).
      
      (theseStrings size > 0)
         ifTrue:  [ listSize <- theseStrings size.
                    private2 <- self xxxMakePrivStrings: theseStrings. ]

         ifFalse: [ listSize <- 3.
                    private2 <- self xxxMakePrivStrings: #( '            ' 
                                                            '            ' 
                                                            '            ' 
                                                          ). ].
      ^ self
|
   choicesTag    " Script files need this! "
      
      ^ private2
|
   choices
   
      ^ choiceArray
|
   selectionMade

      ^ self value " Subclasses should override this "
|
   value ! index !

      index <- super value.
      
      ^ (choiceArray at: index)
|
   setValue  ! index gad type window ! 
      
      gad    <- super gadget.
      type   <- super gadgetType.
      window <- super window.
            
      " make instance variable reflect the Gadget contents. "
      
      index <- <primitive 239 0 13 gad window type>.

      ^ super value: index.
|
   testCycleGadget ! cycleChoiceString !

      self setValue. " Update so value method is correct first. "
      
      cycleChoiceString <- (self value).

      ('   You selected item ', cycleChoiceString ) print.

      ^ true
]

" ---------------------------------------------------------------------
* This Class is meant for giving the User a way to choose from an
* array of colored boxes.  The colors cannot be changed by this
* class.
* --------------------------------------------------------------------- 
" 
Class PaletteGadget :CommonGadget ! numColors !
[
   new: numberOfChoices

      super newGadget: (super gadgetTypeFor: #PALETTE_KIND).
      
      (numberOfChoices > 1)
         ifTrue:  [ numColors <- numberOfChoices ].

      ^ self
|
   selectionMade

      ^ super value " Subclasses should override this "
|
   testPaletteGadget ! colorIndex !

      super setValue. " Update so value method is correct first. "
      
      colorIndex <- (super value).

      ('   You selected color number ', colorIndex asString ) print.

      ^ true
]

" ---------------------------------------------------------------------
* ScrollerGadget class allows the User to move either horizontally or
* vertically with a control.
* --------------------------------------------------------------------- 
" 
Class ScrollerGadget :CommonGadget ! myMin myMax myOrientation !
[
   new: newOrientation

      myOrientation <- newOrientation.

      super newGadget: (super gadgetTypeFor: #SCROLLER_KIND).

      ^ self
|
   setMin: newMin max: newMax
   
      myMin <- newMin.
      myMax <- newMax.
|
   orientation: newOrientation " 0 = NONE, 1 = HORIZ, 2 = VERT "
   
      ^ myOrientation <- newOrientation
|
   orientation
   
      ^ myOrientation
|
   value: newPosition

      (newPosition > myMax)
         ifTrue: [ newPosition <- myMax ].
         
      (newPosition < myMin)
         ifTrue: [ newPosition <- myMin ].
         
      " Update the Gadget contents: "

      ^ super value: newPosition.
|
   value

      ^ super setValue.
|
   testScrollerGadget

      ('   User is at: "', (self value) asString, '"') print.

      ^ true
]

" ---------------------------------------------------------------------
* SliderGadget class allows the User to move either horizontally or
* vertically with a control & set a level.
* --------------------------------------------------------------------- 
" 
Class SliderGadget :CommonGadget ! myMax myMin myOrientation !
[
   new: newOrientation

      myOrientation <- newOrientation.

      super newGadget: (super gadgetTypeFor: #SLIDER_KIND).

      ^ self
|
   setMin: newMin max: newMax
   
      myMin <- newMin.
      myMax <- newMax.
|
   initializeControl ! win !
   
      win <- super window.

      self value: myMin.
            
      win refreshYourself
|
   value: newPosition

      (newPosition > myMax)
         ifTrue: [ newPosition <- myMax ].
         
      (newPosition < myMin)
         ifTrue: [ newPosition <- myMin ].
         
      " Update the Gadget contents: "

      ^ super value: newPosition
|
   value

      ^ super setValue.
|
   testSliderGadget

      ('   User is at: "', (self value) asString, '"') print.

      ^ true
]

" ---------------------------------------------------------------------
* StringGadget class allows the User to enter a String value into
* a UserGUI & its subclasses.
* ---------------------------------------------------------------------
" 
Class StringGadget :CommonGadget  ! myString !
[
   new: newString

      myString <- newString.
 
      super newGadget: (super gadgetTypeFor: #STRING_KIND).

      super initializeValue: newString.
      
      ^ self
|
   value: newString

      ^ myString <- super value: newString
|
   value

      ^ myString <- super setValue.
|
   testStringGadget

      self setValue.
            
      ('   User entered: "', myString, '"') print.

      ^ true
]

" ---------------------------------------------------------------------
* TextGadget class allows the User to view a String in
* a UserGUI & its subclasses.
* --------------------------------------------------------------------- 
" 
Class TextGadget :CommonGadget ! myText !
[
   new: newText

      myText <- newText.
 
      super newGadget: (super gadgetTypeFor: #TEXT_KIND).

      super initializeValue: newText.

      ^ self
|
   value: newText

      ^ myText <- super value: newText
|
   value

      ^ myText <- super setValue
|
   testTextGadget

      ('   User sees: "', self value, '"') print.

      ^ true
]
