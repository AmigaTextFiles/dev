"---------------------------------------------------"
" Menu Class implements control of Amiga Menus      "
" except for actually displaying it, which is in the"
" Window class.                                     "
"---------------------------------------------------"

Class Menu :Glyph
! 
   private nextMenu leftEdge topEdge width height flags menuName firstItem
!
[
   getMenu

      ^ private
|
   getStartPoint

      leftEdge <- <primitive 182 2 0 0 private>.
      topEdge  <- <primitive 182 2 1 0 private>.

      ^ leftEdge @ topEdge
|
   getMenuSize

      width  <- <primitive 182 2 2 0 private>.
      height <- <primitive 182 2 3 0 private>.

      ^ width @ height
|
   setStartPoint: newPoint ! x y !

      x <- newPoint x.
      y <- newPoint y.

      <primitive 182 3 0 x 0 private>.      
      <primitive 182 3 1 y 0 private>.

      leftEdge <- x.
      topEdge  <- y
|
   setMenuSize: sizePoint ! w h !

      w <- sizePoint x.
      h <- sizePoint y.

      <primitive 182 3 2 w 0 private>.
      <primitive 182 3 3 h 0 private>.

      width  <- w.
      height <- h
|
   dispose
      
      <primitive 182 0 0 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   getFlags

      ^ flags <- <primitive 182 2 4 0 private>
|
   setFlags: newFlags

      <primitive 182 3 4 newFlags 0 private>.

      flags <- newFlags
|
   getNextMenu

      ^ nextMenu <- <primitive 182 2 8 0 private>
|
   setNextMenu: newNextMenu

      <primitive 182 3 8 newNextMenu 0 private>.

      nextMenu <- newNextMenu
|
   getFirstItem

      ^ firstItem <- <primitive 182 2 9 0 private>
|
   setFirstItem: newFirstItem

      <primitive 182 3 9 newFirstItem 0 private>.

      firstItem <- newFirstItem
|
   getMenuName

      ^ menuName <- <primitive 182 2 13 0 private>
|
   setMenuName: newMenuName

      <primitive 182 3 13 newMenuName 0 private>.

      menuName <- newMenuName
|
   new: newMenuName

      private  <- <primitive 182 1 0 newMenuName>.

      menuName <- newMenuName.

      ^ self
]

Class MenuItem :Menu
! 
   private    nextItem      leftEdge topEdge    width    height 
   flags      mutualExclude itemFill selectFill command  subItem 
   nextSelect itemName
!
[
   getMenuItem

      ^ private
|
   dispose

      <primitive 182 0 1 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   getStartPoint

      leftEdge <- <primitive 182 2 0 1 private>.
      topEdge  <- <primitive 182 2 1 1 private>.

      ^ leftEdge @ topEdge
|
   getItemSize

      width  <- <primitive 182 2 2 1 private>.
      height <- <primitive 182 2 3 1 private>.

      ^ width @ height
|
   setStartPoint: newPoint ! x y !

      x <- newPoint x.
      y <- newPoint y.

      <primitive 182 3 0 x 1 private>.
      <primitive 182 3 1 y 1 private>.

      leftEdge <- x.
      topEdge  <- y
|
   setItemSize: sizePoint ! w h !

      w <- sizePoint x.
      h <- sizePoint y.

      <primitive 182 3 2 w 1 private>.
      <primitive 182 3 3 h 1 private>.

      width  <- w.
      height <- h
|
   getFlags

      ^ flags <- <primitive 182 2 4 1 private>
|
   setFlags: newFlags

      <primitive 182 3 4 newFlags 1 private>.

      flags <- newFlags
|
   getMutualExclude

      ^ mutualExclude <- <primitive 182 2 5 1 private>
|
   setMutualExclude: newMutualExclude

      <primitive 182 3 5 newMutualExclude 1 private>.

      mutualExclude <- newMutualExclude
|
   getCommand

      ^ command <- <primitive 182 2 6 1 private>
|
   setCommand: newCommand

      <primitive 182 3 6 newCommand 1 private>.

      command <- newCommand
|
   getNextItem

      ^ nextItem <- <primitive 182 2 7 1 private>
|
   setNextItem: newNextItem

      <primitive 182 3 7 newNextItem 1 private>.

      nextItem <- newNextItem
|
   getItemFill

      ^ itemFill <- <primitive 182 2 10 1 private>
|
   setItemFill: newItemFill

      <primitive 182 3 10 newItemFill 1 private>.

      itemFill <- newItemFill
|
   getSelectFill
      ^ selectFill <- <primitive 182 2 11 1 private>
|
   setSelectFill: newSelectFill

      <primitive 182 3 11 newSelectFill 1 private>.

      selectFill <- newSelectFill
|
   getSubItem

      ^ subItem <- <primitive 182 2 12 1 private>
|
   setSubItem: newSubItem

      <primitive 182 3 12 newSubItem 1 private>.

      subItem <- newSubItem
|
   new: newItemName

      private  <- <primitive 182 1 1 newItemName>.

      itemName <- newItemName.

      ^ self
]

Class SubItem :MenuItem
! 
   private       nextItem leftEdge   topEdge width      height      flags 
   mutualExclude itemFill selectFill command nextSelect subItemName
!
[
   getSubItem

      ^ private
|
   dispose

      <primitive 182 0 2 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   getStartPoint

      leftEdge <- <primitive 182 2 0 2 private>.
      topEdge  <- <primitive 182 2 1 2 private>.

      ^ leftEdge @ topEdge
|
   getSubSize

      width  <- <primitive 182 2 2 2 private>.
      height <- <primitive 182 2 3 2 private>.

      ^ width @ height
|
   setStartPoint: newPoint ! x y !

      x <- newPoint x.
      y <- newPoint y.

      <primitive 182 3 0 x 2 private>.
      <primitive 182 3 1 y 2 private>.

      leftEdge <- x.
      topEdge  <- y
|
   setSubSize: sizePoint ! w h ! 

      w <- sizePoint x.
      h <- sizePoint y.

      <primitive 182 3 2 w 2 private>.
      <primitive 182 3 3 h 2 private>.

      width  <- w.
      height <- h
|
   getFlags

      ^ flags <- <primitive 182 2 4 2 private>
|
   setFlags: newFlags

      <primitive 182 3 4 newFlags 2 private>.

      flags <- newFlags
|
   getMutualExclude

      ^ mutualExclude <- <primitive 182 2 5 2 private>
|
   setMutualExclude: newMutualExclude

      <primitive 182 3 5 newMutualExclude 2 private>.

      mutualExclude <- newMutualExclude
|
   getCommand

      ^ command <- <primitive 182 2 6 2 private>
|
   setCommand: newCommand

      <primitive 182 3 6 newCommand 2 private>.

      command <- newCommand
|
   getNextItem

      ^ nextItem <- <primitive 182 2 7 2 private>
|
   setNextItem: newNextItem

      <primitive 182 3 7 newNextItem 2 private>.

      nextItem <- newNextItem
|
   getItemFill

      ^ itemFill <- <primitive 182 2 10 2 private>
|
   setItemFill: newItemFill

      <primitive 182 3 10 newItemFill 2 private>.

      itemFill <- newItemFill
|
   getSelectFill

      ^ selectFill <- <primitive 182 2 11 2 private>
|
   setSelectFill: newSelectFill

      <primitive 182 3 11 newSelectFill 2 private>.

      selectFill <- newSelectFill
|
   new: newSubItemName

      private     <- <primitive 182 1 2 newSubItemName>.

      subItemName <- newSubItemName.

      ^ self
]
