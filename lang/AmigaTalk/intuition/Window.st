"------------------------------------------------------------------- "
" Window Class implements control of Amiga Windows.                  "
""
"  WARNING: AmigaTalk depends on the order & number of the instance  "
"           variables being as show here, DO NOT CHANGE THEM!        "
"------------------------------------------------------------------- "

Class Window :Glyph ! private savedTitle parent !
[
   windowObject

     ^ private
|
   screen
     
     ^ parent
|
   refreshYourself

     <primitive 239 3 2 private>.

       self refreshGadgets.
       self refreshWindowFrame.

     <primitive 239 3 3 private 1 >.
|     
   setPointer: spriteObject size: sizePt offset: offPt ! w h x y !

      " This method is obsolete, use setWindowPointer: tagArray instead "
      w <- sizePt x.
      h <- sizePt y.

      x <- offPt  x.
      y <- offPt  y.

      <primitive 181 8 spriteObject h w x y private> "h w???"
|
   setWindowPointer: tagArray

      "	WA_Pointer (APTR) - The pointer you wish to associate with
	    your window.  If NULL, you are requesting the Preferences
	    default pointer.  Custom pointers should be allocated
	    by performing a NewObject() on 'pointerclass'.
	    (See <intuition/pointerclass.h>).  Defaults to NULL.

	WA_BusyPointer (BOOL) - Set to TRUE to request the Preferences
	    busy-pointer.  If FALSE, your pointer will be as requested
	    by WA_Pointer.  Defaults to FALSE.

	WA_PointerDelay (BOOL) - Set to TRUE to defer changing your
	    pointer for a brief instant.  This is typically used
	    along with setting the busy pointer, especially when
	    the application knows it may be busy for a very short
	    while.  If the application clears the pointer or sets
	    another pointer before the delay expires, the pending
	    pointer change is cancelled.  This reduces short
	    flashes of the busy pointer.
      "
      <primitive 181 20 private tagArray>
|
   addGadget: gadgetObject

      <primitive 181 9 gadgetObject private>
|
   setFirstGadget: newGadgetObject

      <primitive 181 3 12 newGadgetObject>
|
   refreshGadgets

      <primitive 181 4 'RefreshGadgets' private>
|
   refreshWindowFrame

      <primitive 181 4 'RefreshWindowFrame' private>
|
   removeGadget: gadgetObject

      <primitive 181 10 gadgetObject private>
|
   reportMouse: boolvalue

      (boolvalue == true)
         ifTrue: [<primitive 181 11 1 private>]
        ifFalse: [<primitive 181 11 0 private>]
|
   getMouseCoords

      ^ <primitive 181 2 8 private> @ <primitive 181 2 9 private>
|
   printIText: iTextObject at: aPoint

      <primitive 181 14 iTextObject (aPoint x) (aPoint y) private>
|
   handleIntuition

      ^ <primitive 181 16 private>
|
   windowToBack

      <primitive 181 4 'WindowToBack' private>
|
   windowToFront

      <primitive 181 4 'WindowToFront' private>
|
   showRequester: requesterObject

      <primitive 181 5 'ShowRequester' requesterObject private>
|
   addMenuStrip: menuObject

      <primitive 181 5 'AddMenuStrip' menuObject private>
|
   removeMenuStrip

      <primitive 181 4 'RemoveMenuStrip' private>
|
   moveWindow: deltaPt

      <primitive 181 6 'MoveWindow' (deltaPt x) (deltaPt y) private>
|
   infoReq: msg title: t

      <primitive 181 13 msg t 'OKAY'>
|
   yesNoReq: msg title: t

      ^ <primitive 181 13 msg t 'YES|NO'>
|
   getUserChoice: msg title: t choices: bstr

      ^ <primitive 181 13 msg t bstr>
|
   changeWindowSize: deltaPt

      <primitive 181 6 'SetWindowSize' (deltaPt x) (deltaPt y) private>
|
   getOrigin

      ^ <primitive 181 2 0 private> @ <primitive 181 2 1 private>
|
   getWindowSize

      ^ <primitive 181 2 2 private> @ <primitive 181 2 3 private>
|
   getWindowPens

      ^ <primitive 181 2 4 private> @ <primitive 181 2 5 private>
|
   getFlags

      ^ <primitive 181 2 6 private>
|
   getIDCMPFlags

      ^ <primitive 181 2 7 private>
|
   beginRefresh

      <primitive 181 4 'BeginRefresh' private>
|
   endRefresh

      <primitive 181 4 'EndRefresh' private>
|     
   remakeDisplay

      <primitive 181 4 'RemakeDisplay' private>
|     
   rethinkDisplay

      <primitive 181 4 'RethinkDisplay' private>
|
   setWindowOrigin: newPoint

      <primitive 181 3 0 (newPoint x)>.
      <primitive 181 3 1 (newPoint y)>
|
   setWindowSize: sizePoint

      <primitive 181 3 2 (sizePoint x)>.
      <primitive 181 3 3 (sizePoint y)>
|
   setWindowPens: newPensPoint

      <primitive 181 3 4 (newPensPoint x)>. "FrontPen"
      <primitive 181 3 5 (newPensPoint y)>  "BackPen"
|
   setFlags: newFlags

      <primitive 181 3 6 newFlags>
|
   setIDCMPFlags: newIDCMP

      <primitive 181 3 7 newIDCMP>
|
   setMinSize: newMinPoint ! minw minh !

      minw <- newMinPoint x.
      minh <- newMinPoint y.

      <primitive 181 3 8 minw>.
      <primitive 181 3 9 minh>
|
   setMaxSize: newMaxPoint ! maxw maxh !

      maxw <- newMaxPoint x.
      maxh <- newMaxPoint y.

      <primitive 181 3 10 maxw>.
      <primitive 181 3 11 maxh>
|
   getReqCount

      ^ <primitive 181 2 11 private>
|
   getPointerSize

      ^ <primitive 181 2 12 private> @ <primitive 181 2 13 private>
|
   setCheckMark: newCheckMarkImageObject

      <primitive 181 3 13 newCheckMarkImageObject>
|
   getWindowOffset

      ^ <primitive 181 2 14 private> @ <primitive 181 2 15 private>
|
   setBitMap: newBitMapObject

      <primitive 181 3 14 newBitMapObject>
|
   getBorderLeft

      ^ <primitive 181 2 18 private>
|
   getBorderTop

      ^ <primitive 181 2 19 private>
|
   getBorderRight

      ^ <primitive 181 2 20 private>
|
   getBorderBottom

      ^ <primitive 181 2 21 private>
|
   getCheckMarkImage

      ^ <primitive 181 2 22 private>  " Returns an Image Object "
|
   getUserData

      ^ <primitive 181 2 23 private>
|
   getTitle

      ^ <primitive 181 2 10 private>
|      
   changeTitle: newTitle

      <primitive 181 12 newTitle private>. "Window has to be still open!"

      savedTitle <- newTitle
|
   setWindowTitle: newWindowTitle

      savedTitle <- newWindowTitle
|
   getScreenTitle

      ^ savedTitle <- <primitive 181 2 16 private>
|
   new: newWindowTitle

      self setWindowTitle: newWindowTitle.

      ^ self
|
   openOnScreen: screenObject

      private <- <primitive 181 1 screenObject savedTitle>.
      parent  <- screenObject.
      
      ^ private
|
   openWindowWithTags: tagArray

      private <- <primitive 181 17 tagArray>.
      parent  <- <primitive 181 18 private>.
      
      ^ private
|
   reOpen

      ^ private <- <primitive 181 1 parent savedTitle>
|
   close

      <primitive 181 0 private>.

      <primitive 250 5 0 private>.
      
      ^ nil
|
   getWindowSignal

      " The window HAS TO BE OPEN BEFORE you use this! "
      ^ <primitive 181 2 17 private>
]
