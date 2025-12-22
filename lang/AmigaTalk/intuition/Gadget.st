"-----------------------------------------------------------------------"
" Gadget Class is an Abstract class for Intuition Gadgets.              "
"-----------------------------------------------------------------------"

Class Gadget :Glyph ! intuition !
[
   getGadgetObject   " After all, this is an ABSTRACT CLASS!! "

      super subclassResponsibility: 'getGadgetObject'.

      ^ nil
|
   isDisabled: thisGadget ! mask !

      (intuition isNil)
         ifTrue: [ intuition <- Intuition new ].
         
      mask <- (intuition systemTag: #GFLG_DISABLED).

      (mask and: [<primitive 183 2 4 thisGadget>])
         ifTrue: [ ^ true ].

      ^ false
|
   isSelected: thisGadget ! mask !

      (intuition isNil)
         ifTrue: [ intuition <- Intuition new ].
         
      mask <- (intuition systemTag: #GFLG_SELECTED).

      (mask and: [<primitive 183 2 4 thisGadget>])
         ifTrue: [ ^ true ].

      ^ false
|
   "only needed because of GZZGADGET & REQGADGET type flags."
   gadgetTypeIs: thisGadget

      ^ <primitive 183 2 6 thisGadget>
|
   dispose: thisGadget

      <primitive 183 0 thisGadget>.
      
      <primitive 250 5 0 thisGadget>.
      
      ^ nil
|
   setStartPoint: thisGadget to: newPoint ! x y !  "newPoint  is leftEdge @ topEdge"

      x <- newPoint x.
      y <- newPoint y.

      <primitive 183 3 0 x thisGadget>.
      <primitive 183 3 1 y thisGadget>.
|
   setGadgetSize: thisGadget to: sizePoint ! w h ! "sizePoint is width @ height"

      w <- sizePoint x.
      h <- sizePoint y.

      <primitive 183 3 2 w thisGadget>.
      <primitive 183 3 3 h thisGadget>
|
   getStartPoint: thisGadget ! leftEdge topEdge !

      leftEdge <- <primitive 183 2 0 thisGadget>.
      topEdge  <- <primitive 183 2 1 thisGadget>.

      ^ leftEdge @ topEdge
|
   getGadgetSize: thisGadget ! width height !

      width  <- <primitive 183 2 2 thisGadget>.
      height <- <primitive 183 2 3 thisGadget>.

      ^ width @ height
|
   getGadgetUserData: thisGadget

      ^ <primitive 183 2 19 thisGadget>
|
   setGadgetUserData: thisGadget to: newData

      <primitive 183 3 12 newData thisGadget>
]

"-----------------------------------------------------------------------"
" BoolGadget Class implements messages specific only to boolean gadgets."
"-----------------------------------------------------------------------"

Class BoolGadget :Gadget ! private userData !
[
   dispose

      super dispose: private.

      ^ nil
|
   isDisabled

      ^ (super isDisabled: private)
|
   isSelected

      ^ (super isSelected: private)
|
   gadgetTypeIs

      ^ (super gadgetTypeIs: private)
|
   "only needed because of GZZGADGET & REQGADGET type flags."
   setGadgetType: newGadgetType

      <primitive 183 3 6 newGadgetType private>
|
   getGadgetObject

      ^ private
|
   setStartPoint: newPoint "newPoint  is leftEdge @ topEdge"

      super setStartPoint: private to: newPoint.

      ^ newPoint
|   
   setGadgetSizeTo: sizePoint

      super setGadgetSize: private to: sizePoint.
      
      ^ sizePoint
|
   getStartPoint

      ^ (super getStartPoint: private)
|
   getGadgetSize

      ^ (super getGadgetSize: private)
|
   getFlags

      ^ <primitive 183 2 4 private>
|
   setFlags: newFlags

      <primitive 183 3 4 newFlags private>
|
   getActivation

      ^ <primitive 183 2 5 private>
|
   setActivation: newActivation

      <primitive 183 3 5 newActivation private>
|
   getGadgetID

      ^ <primitive 183 2 7 private>
|
   setGadgetID: newGadgetID

      <primitive 183 3 7 newGadgetID private>
|
   getNextGadget

      ^ <primitive 183 2 8 private>
|
   setNextGadget: newNextGadgetObject

      <primitive 183 3 8 newNextGadgetObject private>
|
   getITextString

      ^ <primitive 183 2 9 private>
|
   getGadgetText            " which is an IntuiText Object "

      ^ <primitive 183 2 18 private>
|
   setGadgetText: newIntuiTextObject

      <primitive 183 3 9 newIntuiTextObject private>
|
   getRenderObject

      ^ <primitive 183 2 10 private>
|
   setRender: newRenderObject " Either an Image, Border or IntuiText! "

      <primitive 183 3 10 newRenderObject private>.
|
   getSelectObject

      ^ <primitive 183 2 11 private>
|
   setSelect: newSelectObject " Either an Image, Border or IntuiText! "

      <primitive 183 3 11 newSelectObject private>
|
   getUserData ! rval !

      rval <- super getGadgetUserData: self.

      ^ (rval at: 2)
|
   getGadgetValue ! rval !

      rval <- super getGadgetUserData: self.

      ^ (rval at: 1)
|
   setUserMethod: methodSymbol

      userData at: 2 put: methodSymbol
|
   new

      private  <- <primitive 183 1>.

      userData <- Array new: 3.
      
      self setGadgetType: 1.

      super setGadgetUserData: self to: userData.
      
      ^ self
]

"---------------------------------------------------------------------"
" StrGadget Class implements messages specific only to string gadgets."
"---------------------------------------------------------------------"

Class StrGadget :Gadget ! private userData !
[
   dispose
      super dispose: private.

      ^ nil
|
   isDisabled
      ^ (super isDisabled: private)
|
   isSelected
      ^ (super isSelected: private)
|
   gadgetTypeIs
      ^ (super gadgetTypeIs: private)
|
   setStartPoint: newPoint "newPoint  is leftEdge @ topEdge"
      super setStartPoint: private to: newPoint.

      ^ newPoint
|   
   setGadgetSizeTo: sizePoint
      super setGadgetSize: private to: sizePoint.
      
      ^ sizePoint
|
   getStartPoint
      ^ (super getStartPoint: private)
|
   getGadgetSize
      ^ (super getGadgetSize: private)
|
   setBufferSize: newSize
      <primitive 183 5 newSize private>
|
   getBufferSize
      ^ <primitive 183 2 12 private>
|
   getFlags
      ^ <primitive 183 2 4 private>
|
   setFlags: newFlags
      <primitive 183 3 4 newFlags private>
|
   getActivation
      ^ <primitive 183 2 5 private>
|
   setActivation: newActivation
      <primitive 183 3 5 newActivation private>
|
   setGadgetType: newGadgetType
      <primitive 183 3 6 newGadgetType private>.
|
   getGadgetID
      ^ <primitive 183 2 7 private>
|
   setGadgetID: newGadgetID
      <primitive 183 3 7 newGadgetID private>
|
   getNextGadget
      ^ <primitive 183 2 8 private>
|
   setNextGadget: newNextGadgetObject
      <primitive 183 3 8 newNextGadgetObject private>
|
   getITextString
      ^ <primitive 183 2 9 private>
|
   getGadgetText
      ^ <primitive 183 2 18 private>
|
   setGadgetText: newIntuiTextObject
      <primitive 183 3 9 newIntuiTextObject private>
|
   getRender
      ^ <primitive 183 2 10 private>
|
   setRender: newRenderObject " Either an Image or IntuiText! "
      <primitive 183 3 10 newRenderObject private>
|
   getSelect
      ^ <primitive 183 2 11 private>
|
   setSelect: newSelectObject " Either an Image or IntuiText! "
      <primitive 183 3 11 newSelectObject private>
|
   getGadgetObject
      ^ private
|
   getUserData ! rval !
      rval <- super getGadgetUserData: self.

      ^ (rval at: 2)
|
   getGadgetValue ! rval !
      rval <- super getGadgetUserData: self.

      ^ (rval at: 1)
|
   setUserMethod: methodSymbol
      userData at: 2 put: methodSymbol
|
   new
      private  <- <primitive 183 1>.
      userData <- Array new: 3.
       
      self setGadgetType: 4.
      
      super setGadgetUserData: self to: userData.
      
      ^ self
]

"------------------------------------------------------"
" PropGadget Class implements messages specific only to"
" proportional gadgets.                                "
"------------------------------------------------------"

Class PropGadget :Gadget ! private userData !
[
   dispose
      super dispose: private.

      ^ nil
|
   isDisabled
      ^ (super isDisabled: private)
|
   isSelected
      ^ (super isSelected: private)
|
   gadgetTypeIs
      ^ (super gadgetTypeIs: private)
|
   "only needed because of GZZGADGET & REQGADGET type flags."
   setGadgetType: newGadgetType
      <primitive 183 3 6 newGadgetType private>
|
   getGadgetObject
      ^ private
|
   setStartPoint: newPoint "newPoint  is leftEdge @ topEdge"
      super setStartPoint: private to: newPoint.

      ^ newPoint
|   
   setGadgetSizeTo: sizePoint
      super setGadgetSize: private to: sizePoint.
      
      ^ sizePoint
|
   getStartPoint
      ^ (super getStartPoint: private)
|
   getGadgetSize
      ^ (super getGadgetSize: private)
|
   modifyProps: newFlags hPot: hp vPot: vp hBody: hb
                vBody: vb window: windowObject

      <primitive 183 4 newFlags hp vp hb vb windowObject private>.
|
   setProps: newFlags hPot: hp vPot: vp hBody: hb vBody: vb

      <primitive 183 6 newFlags hp vp hb vb private>
|
   getFlags
      ^ <primitive 183 2 4 private>
|
   setFlags: newFlags
      <primitive 183 3 4 newFlags private>
|
   getActivation
      ^ <primitive 183 2 5 private>
|
   setActivation: newActivation
      <primitive 183 3 5 newActivation private>
|
   getGadgetID
      ^ <primitive 183 2 7 private>
|
   setGadgetID: newGadgetID
      <primitive 183 3 7 newGadgetID private>
|
   getNextGadget
      ^ <primitive 183 2 8 private>
|
   setNextGadget: newNextGadgetObject
      <primitive 183 3 8 newNextGadgetObject private>
|
   getITextString
      ^ <primitive 183 2 9 private>
|
   getGadgetText
      ^ <primitive 183 2 18 private>
|
   setGadgetText: newIntuiTextObject
      <primitive 183 3 9 newIntuiTextObject private>
|
   getRender
      ^ <primitive 183 2 10 private>
|
   setRender: newRenderObject " Either an Image or IntuiText! "
      <primitive 183 3 10 newRenderObject private>
|
   getSelect
      ^ <primitive 183 2 11 private>
|
   setSelect: newSelectObject " Either an Image or IntuiText! "
      <primitive 183 3 11 newSelectObject private>
|
   getPropFlags
      ^ <primitive 183 2 13 private>
|
   getHPot
      ^ <primitive 183 2 14 private>
|
   getVPot
      ^ <primitive 183 2 15 private>
|
   getHBody
      ^ <primitive 183 2 16 private>
|
   getVBody
      ^ <primitive 183 2 17 private>
|
   getUserData ! rval !
      rval <- super getGadgetUserData: self.

      ^ (rval at: 2)
|
   getGadgetValue ! rval !
      rval <- super getGadgetUserData: self.

      ^ (rval at: 1)
|
   setUserMethod: methodSymbol
      userData at: 2 put: methodSymbol
|
   new
      private  <- <primitive 183 1>.
      userData <- Array new: 3.
      
      self setGadgetType: 3.

      super setGadgetUserData: self to: userData.
      
      ^ self
]
