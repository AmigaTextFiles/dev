;
; ** $VER: gels.h 39.0 (21.8.91)
; ** Includes Release 40.15
; **
; ** include file for AMIGA GELS (Graphics Elements)
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

;  VSprite flags
;  user-set VSprite flags:
#SUSERFLAGS  = $00FF    ;  mask of all user-settable VSprite-flags
#VSPRITE     = $0001    ;  set if VSprite, clear if Bob
#SAVEBACK    = $0002    ;  set if background is to be saved/restored
#OVERLAY     = $0004    ;  set to mask image of Bob onto background
#MUSTDRAW    = $0008    ;  set if VSprite absolutely must be drawn
;  system-set VSprite flags:
#BACKSAVED   = $0100    ;  this Bob's background has been saved
#BOBUPDATE   = $0200    ;  temporary flag, useless to outside world
#GELGONE     = $0400    ;  set if gel is completely clipped (offscreen)
#VSOVERFLOW  = $0800    ;  VSprite overflow (if MUSTDRAW set we draw!)

;  Bob flags
;  these are the user flag bits
#BUSERFLAGS  = $00FF    ;  mask of all user-settable Bob-flags
#SAVEBOB     = $0001    ;  set to not erase Bob
#BOBISCOMP   = $0002    ;  set to identify Bob as AnimComp
;  these are the system flag bits
#BWAITING    = $0100    ;  set while Bob is waiting on 'after'
#BDRAWN     = $0200    ;  set when Bob is drawn this DrawG pass
#BOBSAWAY    = $0400    ;  set to initiate removal of Bob
#BOBNIX     = $0800    ;  set when Bob is completely removed
#SAVEPRESERVE = $1000   ;  for back-restore during double-buffer
#OUTSTEP     = $2000    ;  for double-clearing if double-buffer

;  defines for the animation procedures
#ANFRACSIZE  = 6
#ANIMHALF    = $0020
#RINGTRIGGER = $0001


;  UserStuff definitions
;  *  the user can define these to be a single variable or a sub-structure
;  *  if undefined by the user, the system turns these into innocuous variables
;  *  see the manual for a thorough definition of the UserStuff definitions
;  *
;


; ********************** GEL STRUCTURES **********************************

Structure VSprite

;  --------------------- SYSTEM VARIABLES -------------------------------
;  GEL linked list forward/backward pointers sorted by y,x value
    *NextVSprite.VSprite
    *PrevVSprite.VSprite

;  GEL draw list constructed in the order the Bobs are actually drawn, then
;  *  list is copied to clear list
;  *  must be here in VSprite for system boundary detection
;
    *DrawPath.VSprite     ;  pointer of overlay drawing
    *ClearPath.VSprite    ;  pointer for overlay clearing

;  the VSprite positions are defined in (y,x) order to make sorting
;  *  sorting easier, since (y,x) as a long integer
;
    OldY.w
    OldX.w       ;  previous position

;  --------------------- COMMON VARIABLES ---------------------------------
    Flags.w       ;  VSprite flags


;  --------------------- USER VARIABLES -----------------------------------
;  the VSprite positions are defined in (y,x) order to make sorting
;  *  sorting easier, since (y,x) as a long integer
;
    Y.w
    X.w        ;  screen position

    Height.w
    Width.w       ;  number of words per row of image data
    Depth.w       ;  number of planes of data

    MeMask.w       ;  which types can collide with this VSprite
    HitMask.w       ;  which types this VSprite can collide with

    *ImageData.w       ;  pointer to VSprite image

;  borderLine is the one-dimensional logical OR of all
;  *  the VSprite bits, used for fast collision detection of edge
;
    *BorderLine.w       ;  logical OR of all VSprite bits
    *CollMask.w       ;  similar to above except this is a matrix

;  pointer to this VSprite's color definitions (not used by Bobs)
    *SprColors.w

    *VSBob.Bob       ;  points home if this VSprite is part of
;        a Bob

;  planePick flag:  set bit selects a plane from image, clear bit selects
;  *  use of shadow mask for that plane
;  * OnOff flag: if using shadow mask to fill plane, this bit (corresponding
;  *  to bit in planePick) describes whether to fill with 0's or 1's
;  * There are two uses for these flags:
;  * - if this is the VSprite of a Bob, these flags describe how the Bob
;  *   is to be drawn into memory
;  * - if this is a simple VSprite and the user intends on setting the
;  *   MUSTDRAW flag of the VSprite, these flags must be set too to describe
;  *   which color registers the user wants for the image
;
    PlanePick.b
    PlaneOnOff.b

    VUserExt.w      ;  user definable:  see note above
EndStructure

Structure Bob
;  blitter-objects

;  --------------------- SYSTEM VARIABLES ---------------------------------

;  --------------------- COMMON VARIABLES ---------------------------------
    Flags.w ;  general purpose flags (see definitions below)

;  --------------------- USER VARIABLES -----------------------------------
    *SaveBuffer.w ;  pointer to the buffer for background save

;  used by Bobs for "cookie-cutting" and multi-plane masking
    *ImageShadow.w

;  pointer to BOBs for sequenced drawing of Bobs
;  *  for correct overlaying of multiple component animations
;
    *Before.Bob ;  draw this Bob before Bob pointed to by before
    *After.Bob ;  draw this Bob after Bob pointed to by after

    *BobVSprite.VSprite   ;  this Bob's VSprite definition

    *BobComp.AnimComp     ;  pointer to this Bob's AnimComp def

    *DBuffer.DBufPacket     ;  pointer to this Bob's dBuf packet

    BUserExt.w     ;  Bob user extension
EndStructure

Structure AnimComp

;  --------------------- SYSTEM VARIABLES ---------------------------------

;  --------------------- COMMON VARIABLES ---------------------------------
    Flags.w      ;  AnimComp flags for system & user

;  timer defines how long to keep this component active:
;  *  if set non-zero, timer decrements to zero then switches to nextSeq
;  *  if set to zero, AnimComp never switches
;
    Timer.w

;  --------------------- USER VARIABLES -----------------------------------
;  initial value for timer when the AnimComp is activated by the system
    TimeSet.w

;  pointer to next and previous components of animation object
    *NextComp.AnimComp
    *PrevComp.AnimComp

;  pointer to component component definition of next image in sequence
    *NextSeq.AnimComp
    *PrevSeq.AnimComp

    *AnimCRoutine.l ;  address of special animation procedure

    YTrans.w     ;  initial y translation (if this is a component)
    XTrans.w     ;  initial x translation (if this is a component)

    *HeadOb.AnimOb

    *AnimBob.Bob
EndStructure

Structure AnimOb

;  --------------------- SYSTEM VARIABLES ---------------------------------
    *NextOb.AnimOb
    *PrevOb.AnimOb

;  number of calls to Animate this AnimOb has endured
    Clock.l

    AnOldY.w
    AnOldX.w     ;  old y,x coordinates

;  --------------------- COMMON VARIABLES ---------------------------------
    AnY.w
    AnX.w      ;  y,x coordinates of the AnimOb

;  --------------------- USER VARIABLES -----------------------------------
    YVel.w
    XVel.w      ;  velocities of this object
    YAccel.w
    XAccel.w     ;  accelerations of this object

    RingYTrans.w
    RingXTrans.w    ;  ring translation values

    *AnimORoutine.l     ;  address of special animation
;            procedure

    *HeadComp.AnimComp     ;  pointer to first component

    AUserExt.w     ;  AnimOb user extension
EndStructure

;  dBufPacket defines the values needed to be saved across buffer to buffer
;  *  when in double-buffer mode
;
Structure DBufPacket

    BufY.w
    BufX.w      ;  save the other buffers screen coordinates
    *BufPath.VSprite     ;  carry the draw path over the gap

;  these pointers must be filled in by the user
;  pointer to other buffer's background save buffer
    *BufBuffer.w
EndStructure



;  ************************************************************************

;  these are GEL functions that are currently simple enough to exist as a
;  *  definition.  It should not be assumed that this will always be the case
;
;#InitAnimate(animKey) = *(animKey) = NULL}
;#RemBob(b) = (b)\Flags |= #BOBSAWAY}


;  ************************************************************************

#B2NORM     = 0
#B2_SWAP     = 1
#B2BOBBER    = 2

;  ************************************************************************

;  a structure to contain the 16 collision procedure addresses
Structure collTable
    *collPtrs.l[16]
EndStructure

