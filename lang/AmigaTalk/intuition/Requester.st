"--------------------------------------------------------------------"
" Requester Class implements control of Amiga Requesters, except for "
" displaying them, which is done inside the Window class.            "
" There are simpler Requester methods in class AmigaTalk & Window,   "
" but they do NOT have as much flexibility as this Class.            "
"--------------------------------------------------------------------"

Class Requester :Glyph ! private !
[
   "reqValuesArray has the following fields:
       LeftEdge, TopEdge, Width, Height, RelLeft, RelTop,
       ReqGadget, ReqBorder, ReqText, Flags BackFill, ImageBMap,
       ReqImage, ReqLayer:
   "
   initialize: reqValuesArray

      <primitive 185 3 0  (reqValuesArray at: 1)  private>.
      <primitive 185 3 1  (reqValuesArray at: 2)  private>.
      <primitive 185 3 2  (reqValuesArray at: 3)  private>.
      <primitive 185 3 3  (reqValuesArray at: 4)  private>.
      <primitive 185 3 4  (reqValuesArray at: 5)  private>.
      <primitive 185 3 5  (reqValuesArray at: 6)  private>.
      <primitive 185 3 9  (reqValuesArray at: 7)  private>.
      <primitive 185 3 10 (reqValuesArray at: 8)  private>.
      <primitive 185 3 8  (reqValuesArray at: 9)  private>.
      <primitive 185 3 6  (reqValuesArray at: 10) private>.
      <primitive 185 3 7  (reqValuesArray at: 11) private>.
      <primitive 185 3 11 (reqValuesArray at: 12) private>.
      <primitive 185 3 12 (reqValuesArray at: 13) private>.
      <primitive 185 3 13 (reqValuesArray at: 14) private>.

      ^ self
|
   getStartPoint

      ^ <primitive 185 2 0 private> @ <primitive 185 2 1 private>
|
   setStartPoint: newPoint

      <primitive 185 3 0 (newPoint x) private>.
      <primitive 185 3 1 (newPoint y) private>
|
   getReqSize

      ^ <primitive 185 2 2 private> @ <primitive 185 2 3 private>
|
   setReqSize: sizePoint

      <primitive 185 3 2 (sizePoint x) private>.
      <primitive 185 3 3 (sizePoint y) private>
|
   getRelativePoint

      ^ <primitive 185 2 4 private> @ <primitive 185 2 5 private>
|
   setRelativePoint: newRelPoint

      <primitive 185 3 4 (newRelPoint x) private>.
      <primitive 185 3 5 (newRelPoint y) private>
|
   getFlags

      ^ <primitive 185 2 6 private>
|
   setFlags: newFlags

      <primitive 185 3 6 newFlags private>
|
   getBackFill

      ^ <primitive 185 2 7 private>
|
   setBackFill: newBackFill

      <primitive 185 3 7 newBackFill private>
|
   getReqText

      ^ <primitive 185 2 8 private>
|
   setReqText: newReqText

      <primitive 185 3 8 newReqText private>
|
   getReqBorder

      ^ <primitive 185 2 10 private>
|
   setReqBorder: newReqBorder

      <primitive 185 3 10 newReqBorder private>
|
   getReqGadget

      ^ <primitive 185 2 9 private>
|
   setReqGadget: newReqGadget

      <primitive 185 3 9 newReqGadget private>
|
   getReqBitMap

      ^ <primitive 185 2 11 private>
|
   getReqImage

      ^ <primitive 185 2 12 private>
|
   getReqLayer

      ^ <primitive 185 2 13 private>
|
   setReqBitMap: newBitMapObject

      <primitive 185 3 11 newBitMapObject private>
|
   setReqImage: newImageObject

      <primitive 185 3 12 newImageObject private>
|
   setReqLayer: newLayerObject

      <primitive 185 3 13 newLayerObject private>
|
   dispose

      <primitive 185 0 private>.

      ^ nil
|
   new

      private <- <primitive 185 1>.

      ^ self
]