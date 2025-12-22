;
; **  $VER: imageclass.h 38.5 (26.3.92)
; **  Includes Release 40.15
; **
; **  Definitions for the image classes
; **
; **  (C) Copyright 1989-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "utility/tagitem.pb"

;
;  * NOTE:  <intuition/iobsolete.h> is included at the END of this file!
;

#CUSTOMIMAGEDEPTH = (-1)
;  if image.Depth is this, it's a new Image class object

;  some convenient macros and casts
;#GADGET_BOX( = g ) ( (*) &((struct Gadget *)(g))\LeftEdge ).IBox
;#IM_BOX( = im ) ( (*) &((struct Image *)(im))\LeftEdge ).IBox
;#IM_FGPEN( = im ) ( (im)\PlanePick )
;#IM_BGPEN( = im ) ( (im)\PlaneOnOff )

; ****************************************************
#IA_Dummy  = (#TAG_USER + $20000)
#IA_Left   = (#IA_Dummy + $01)
#IA_Top   = (#IA_Dummy + $02)
#IA_Width  = (#IA_Dummy + $03)
#IA_Height  = (#IA_Dummy + $04)
#IA_FGPen  = (#IA_Dummy + $05)
      ;  IA_FGPen also means "PlanePick"
#IA_BGPen  = (#IA_Dummy + $06)
      ;  IA_BGPen also means "PlaneOnOff"
#IA_Data   = (#IA_Dummy + $07)
      ;  bitplanes, for classic image,
;        * other image classes may use it for other things
;
#IA_LineWidth  = (#IA_Dummy + $08)
#IA_Pens   = (#IA_Dummy + $0E)
      ;  pointer to UWORD pens[],
;        * ala DrawInfo.Pens, MUST be
;        * terminated by ~0.  Some classes can
;        * choose to have this, or SYSIA_DrawInfo,
;        * or both.
;
#IA_Resolution  = (#IA_Dummy + $0F)
      ;  packed uwords for x/y resolution into a longword
;        * ala DrawInfo.Resolution
;

; *** see class documentation to learn which ****
; *** classes recognize these   ****
#IA_APattern  = (#IA_Dummy + $10)
#IA_APatSize  = (#IA_Dummy + $11)
#IA_Mode   = (#IA_Dummy + $12)
#IA_Font   = (#IA_Dummy + $13)
#IA_Outline  = (#IA_Dummy + $14)
#IA_Recessed  = (#IA_Dummy + $15)
#IA_DoubleEmboss  = (#IA_Dummy + $16)
#IA_EdgesOnly  = (#IA_Dummy + $17)

; *** "sysiclass" attributes   ****
#SYSIA_Size  = (#IA_Dummy + $0B)
      ;  #define's below
#SYSIA_Depth  = (#IA_Dummy + $0C)
      ;  this is unused by Intuition.  SYSIA_DrawInfo
;        * is used instead for V36
;
#SYSIA_Which  = (#IA_Dummy + $0D)
      ;  see #define's below
#SYSIA_DrawInfo  = (#IA_Dummy + $18)
      ;  pass to sysiclass, please

; **** obsolete: don't use these, use IA_Pens ****
#SYSIA_Pens  = #IA_Pens
#IA_ShadowPen  = (#IA_Dummy + $09)
#IA_HighlightPen  = (#IA_Dummy + $0A)

;  New for V39:
#SYSIA_ReferenceFont = (#IA_Dummy + $19)
      ;  Font to use as reference for scaling
;        * certain sysiclass images
;
#IA_SupportsDisable = (#IA_Dummy + $1a)
      ;  By default, Intuition ghosts gadgets itself,
;        * instead of relying on IDS_DISABLED or
;        * IDS_SELECTEDDISABLED.  An imageclass that
;        * supports these states should return this attribute
;        * as TRUE.  You cannot set or clear this attribute,
;        * however.
;

#IA_FrameType  = (#IA_Dummy + $1b)
      ;  Starting with V39, FrameIClass recognizes
;        * several standard types of frame.  Use one
;        * of the FRAME_ specifiers below. Defaults
;        * to FRAME_DEFAULT.
;

; * next attribute: (IA_Dummy + 0x1c) *
; ***********************************************

;  data values for SYSIA_Size
#SYSISIZE_MEDRES = (0)
#SYSISIZE_LOWRES = (1)
#SYSISIZE_HIRES = (2)

;
;  * SYSIA_Which tag data values:
;  * Specifies which system gadget you want an image for.
;  * Some numbers correspond to internal Intuition #defines
;
#DEPTHIMAGE = ($00) ;  Window depth gadget image
#ZOOMIMAGE = ($01) ;  Window zoom gadget image
#SIZEIMAGE = ($02) ;  Window sizing gadget image
#CLOSEIMAGE = ($03) ;  Window close gadget image
#SDEPTHIMAGE = ($05) ;  Screen depth gadget image
#LEFTIMAGE = ($0A) ;  Left-arrow gadget image
#UPIMAGE  = ($0B) ;  Up-arrow gadget image
#RIGHTIMAGE = ($0C) ;  Right-arrow gadget image
#DOWNIMAGE = ($0D) ;  Down-arrow gadget image
#CHECKIMAGE = ($0E) ;  GadTools checkbox image
#MXIMAGE  = ($0F) ;  GadTools mutual exclude "button" image
;  New for V39:
#MENUCHECK = ($10) ;  Menu checkmark image
#AMIGAKEY = ($11) ;  Menu Amiga-key image

;  Data values for IA_FrameType (recognized by FrameIClass)
;  *
;  * FRAME_DEFAULT:  The standard V37-type frame, which has
;  * thin edges.
;  * FRAME_BUTTON:  Standard button gadget frames, having thicker
;  * sides and nicely edged corners.
;  * FRAME_RIDGE:  A ridge such as used by standard string gadgets.
;  * You can recess the ridge to get a groove image.
;  * FRAME_ICONDROPBOX: A broad ridge which is the standard imagery
;  * for areas in AppWindows where icons may be dropped.
;

#FRAME_DEFAULT  = 0
#FRAME_BUTTON  = 1
#FRAME_RIDGE  = 2
#FRAME_ICONDROPBOX = 3


; image message id's */
#IM_DRAW = $202  ; draw yourself, with "state"    */
#IM_HITTEST = $203  ; Return TRUE If click hits image  */
#IM_ERASE = $204  ; erase yourself     */
#IM_MOVE  = $205  ; draw new AND erase old, smoothly */

#IM_DRAWFRAME = $206  ; draw with specified dimensions */
#IM_FRAMEBOX  = $207  ; get recommended frame around some box*/
#IM_HITFRAME  = $208  ; hittest with dimensions    */
#IM_ERASEFRAME = $209 ; hittest with dimensions    */

; image draw states OR styles, For IM_DRAW */
; Note that they have no bitwise meanings (unfortunately) */
#IDS_NORMAL   = (0)
#IDS_SELECTED  = (1)  ; For selected gadgets     */
#IDS_DISABLED  = (2)  ; For disabled gadgets     */
#IDS_BUSY  =  (3)  ; For future functionality */
#IDS_INDETERMINATE = (4)  ; For future functionality */
#IDS_INACTIVENORMAL= (5)  ; normal, in inactive window border */
#IDS_INACTIVESELECTED = (6)  ; selected, in inactive border */
#IDS_INACTIVEDISABLED = (7)  ; disabled, in inactive border */
#IDS_SELECTEDDISABLED = (8)  ; disabled AND selected    */

; oops, please forgive spelling error by jimm */
#IDS_INDETERMINANT = #IDS_INDETERMINATE

; IM_FRAMEBOX  */
Structure impFrameBox
    MethodID.l;
    *imp_ContentsBox.IBox; ; input: relative box of contents */
    *imp_FrameBox.IBox;    ; output: rel. box of encl frame  */
    *imp_DrInfo.DrawInfo;  ; NB: May be NULL */
    imp_FrameFlags.l;
EndStructure

#FRAMEF_SPECIFY = (1  <<  0)  ; Make do with the dimensions of FrameBox

; IM_DRAW, IM_DRAWFRAME  */
Structure impDraw
    MethodID.l
    *imp_RPort.RastPort
    X.w
    Y.w
    imp_State.l
    *imp_DrInfo.DrawInfo;  ; NB: May be NULL */
    ; these parameters only valid For IM_DRAWFRAME */
    Width.w
    Height.w
EndStructure

; IM_ERASE, IM_ERASEFRAME  */
; NOTE: This is a subset of impDraw  */
Structure impErase
    MethodID.l
    *imp_RPort.RastPort
    X.w
    Y.w
    ; these parameters only valid For IM_ERASEFRAME */
    Width.w
    Height.w
EndStructure

; IM_HITTEST, IM_HITFRAME  */
Structure impHitTest
    MethodID.l
    X.w
    Y.w
    ; these parameters only valid For IM_HITFRAME */
    Width.w
    Height.w
EndStructure
