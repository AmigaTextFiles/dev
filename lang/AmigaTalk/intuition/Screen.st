"---------------------------------------------------------- "
" Screen Class implements control of Amiga Screens          "
" screenModeID = 32-bit display mode ID value               "
" --------------------------------------------------------- "
" NOTE:  The order & number of the Class instance variables "
"        matters to the underlying AmigaTalk code, DO NOT   "
"        CHANGE THEM!                                       "
"---------------------------------------------------------- "

Class Screen :Glyph ! private savedTitle screenModeID !
[
   pullScreenUp: numLines    

      "numLines <= 0"
      <primitive 180 5 numLines private>
|     
   pushScreenDown: numLines  

      "numLines >= 0"
      <primitive 180 6 numLines private>
|     
   redrawScreen

      <primitive 180 7 private>
|     
   reOpenScreen

      private <- <primitive 180 8 savedTitle>
|
   displayBeep

      <primitive 180 4 'DisplayBeep' private>
|
   screenToBack

      <primitive 180 4 'ScreenToBack' private>
|
   screenToFront

      <primitive 180 4 'ScreenToFront' private>
|
   turnOffTitle

      <primitive 180 4 'TurnOffTitle' private>
|
   showTitle

      <primitive 180 4 'ShowTitle' private>
|
   setTitle: newTitle

      <primitive 180 3 8 newTitle>.

      savedTitle <- newTitle
|
   setFont: newFontObject

      <primitive 180 3 7 newFontObject>
|
   setBitMap: newBitMapObject

      <primitive 180 3 12 newBitMapObject>
|
   getOrigin

      ^ <primitive 180 2 0 private> @ <primitive 180 2 1 private>
|
   getScreenSize

      ^ <primitive 180 2 2 private> @ <primitive 180 2 3 private>
|
   getScreenPens

      ^ <primitive 180 2 4 private> @ <primitive 180 2 5 private>
|
   getFlags

      ^ <primitive 180 2 6 private>
|
   getType

      ^ <primitive 180 2 11 private>
|
   getViewMode

      ^ <primitive 180 2 10 private>
|
   getTitle

      ^ savedTitle <- <primitive 180 2 8 private>
|
   getDepth

      ^ <primitive 180 2 9 private>
|
   getFontName

      ^ <primitive 180 2 7 private>
|
   getFontObject      

      ^ <primitive 180 2 13 private>
|    
   getBitMap

      ^ <primitive 180 2 12 private> "Returns an Integer (BitMap address)"
|
   getBarHeightSize

      ^ <primitive 180 2 14 private>
|         
   getBarVBorderSize

      ^ <primitive 180 2 15 private>
|         
   getBarHBorderSize

      ^ <primitive 180 2 16 private>
|         
   getMenuVBorderSize

      ^ <primitive 180 2 17 private>
|         
   getMenuHBorderSize

      ^ <primitive 180 2 18 private>
|         
   getWBorTopSize

      ^ <primitive 180 2 19 private>
|         
   getWBorLeftSize

      ^ <primitive 180 2 20 private>
|         
   getWBorRightSize

      ^ <primitive 180 2 21 private>
|         
   getWBorBottomSize

      ^ <primitive 180 2 22 private>
|
   getUserData

      ^ <primitive 180 2 23 private>
|
   getVisualInfo: tagArray                 " tagArray can be nil "

      ^ <primitive 180 13 tagArray private>
|
   disposeVisualInfo: viObj

      <primitive 180 14 viObj>.
      
      <primitive 250 5 0 viObj>.
      
      ^ nil
|
   setScreenPens: pensPoint ! fp bp !

      fp <- pensPoint x.
      bp <- pensPoint y.

      <primitive 180 3 4 fp>.
      <primitive 180 3 5 bp>
|
   close
      <primitive 180 0 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   thisScreen

      " Necessary for passing a screen to a tag list (scr thisScreen): "
      ^ private
|
   setScreenModeID: newScreenModeID

      screenModeID <- newScreenModeID
|
   getScreenModeID

      ^ <primitive 180 2 10 private>
|
   open: screenTitle

      private    <- <primitive 180 1 screenModeID screenTitle>.

      savedTitle <- screenTitle
|
   new: newScreenModeID

      (savedTitle isNil)
         ifTrue: [ savedTitle <- 'Default ScreenTitle' ].

      private      <- <primitive 180 1 newScreenModeID savedTitle>.

      screenModeID <- newScreenModeID.

      ^ self
|
   openScreen: screenMode title: screenTitle

      savedTitle <- screenTitle.

      self          new: screenMode.

      ^ self
|
   openScreenWithTags: tagArray

      private <- <primitive 180 9 tagArray>.

      self getTitle. " This assumes you included an SA_Title tag! "
      
      ^ self
|
   lockPublicScreen: screenName                       " screenName can be nil "

      ^ private <- <primitive 180 11 screenName>
|
   unlockPublicScreen: screenObject named: screenName " screenName can be nil "

      <primitive 180 12 screenName screenObject>
|
   getScreenErrorString: errorNumber

      ^ <primitive 180 10 errorNumber>
|
   selectAndOpenScreen ! aTitle userMode !

      "Show the ScreenMode ASL requester & open selection"

      amigatalk setIOMessage: 'What is the Title of the Screen?'. 
      amigatalk setIOTitle:   'Enter a Screen Title:'.

      aTitle <- amigatalk getString.
      
      amigatalk setIOTitle:   'Available Screen Modes:'.
      amigatalk setIOMessage: aTitle.

      userMode <- amigatalk getScreenModeID.

      ^ (self openScreen: userMode title: aTitle)
]
