" --------------------------------------------------------------------- "
" GUI Class allows the User to make GUI's using the GadTools function-  "
" ality of Intuition.  This Class is a lot simpler than Gadget Classes, "
" Menu Classes & the Window Class.                                      "
" --------------------------------------------------------------------- "
" WARNING "
" This class is not finished! "
""
" HISTORY "
"     19-May-2000 - Created the first draft of the Class.               "
" --------------------------------------------------------------------- "

Class GUI :Glyph  ! private numGadgets parentScreen gadArray !
[
   refreshGadgets

      <primitive 181 4 'RefreshGadgets' private>
|
   handleIntuition

      ^ <primitive 181 16 private>
|
   addMenuStrip: menuObject

      <primitive 181 5 'AddMenuStrip' menuObject private>
|
   removeMenuStrip

      <primitive 181 4 'RemoveMenuStrip' private>
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
   at: aNumber

      ( (aNumber < 1) or: [aNumber > <primitive 4 gadArray>] )
         ifTrue: [ self error: 'index error'. ^nil ].

      ^ <primitive 111 gadArray aNumber>
|
   at: aNumber put: aGadget

      ((aNumber < 1) or: [aNumber > <primitive 4 gadArray>])
         ifTrue: [ self error: 'index error'. ^nil ].

      <primitive 112 gadArray aNumber aGadget>.

      ^ aGadget
|
   sizeGadgetArray

      ^ <primitive 4 gadArray>
|
   newGadgetTagArray: gNum tags: tagArray ! tagsize !

      tagsize <- tagArray size.

      <primitive 183 xx (gNum - 1) tagsize tagArray>
|
   newGadgetArray: howMany

      numGadgets <- howMany.

      ^ gadArray <- <primitive 114 howMany>
|
   setGadgetID: newGadgetID for: gadgetObject

      <primitive 183 3 0 7 newGadgetID gadgetObject>
|
   getMenuFlagsFor: menuObject

      ^ <primitive 182 2 4 menuObject>
|
   setMenuFlags: newFlags for: menuObject

      menuObject setMenuFlags: newFlags
|
   printIText: iTextObject at: aPoint

      <primitive 181 14 iTextObject (aPoint x) (aPoint y) private>
|
   setGUIOrigin: newPoint ! x y !

      x <- newPoint x.
      y <- newPoint y.

      <primitive 181 3 0 x private>.
      <primitive 181 3 1 y private>
|
   setGUISize: sizePoint ! w h !

      w <- sizePoint x.
      h <- sizePoint y.

      <primitive 181 3 2 w private>.
      <primitive 181 3 3 h private>
|
   setFlags: newFlags

      <primitive 181 3 6 newFlags private>
|
   setIDCMPFlags: newIDCMP

      <primitive 181 3 7 newIDCMP private>
|
   new
  
      self error: 'GUI Class only responds to "new:"'.
  
      ^ nil
|
   new: guiTitle

      private <- <primitive 181 17 guiTitle>.

      ^ self
|
   closeGUI

      <primitive 181 0 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   openOnScreen: screenObject

      <primitive 181 1 screenObject private>.

      parentScreen <- screenObject
]
