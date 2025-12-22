      IFND            EGS_EGS_I
EGS_EGS_I       SET     1
*\
*
*  $
*  $ FILE     : egs.i
*  $ VERSION  : 1
*  $ REVISION : 36
*  $ DATE     : 31-Jan-93 14:44
*  $
*  $ Author   : mvk
*  $
*
*
* (c) Copyright 1990/93 VIONA Development
*     All Rights Reserved
*
*\
	IFND    EXEC_TYPES_I
	INCLUDE "exec/types.i"
	ENDC
	IFND    EXEC_PORTS_I
	INCLUDE "exec/ports.i"
	ENDC

*
*  This library is the basic interface to high resolution graphics cards.
*  The hardware is almost completely encapsulated by this module. It is
*  not allowed to access hardware registers directly.
*
*  The library is designed for full multitasking support. Thus several
*  programs can use the graphics card simultaneously.  Screens can be
*  switched like Intuition screens by pressing the left Amiga key and "S".
*
*  Moreover, a separate mouse pointer is supported.  The Amiga mouse and
*  EGS mouse can be exchanged by pressing the left Amiga key and "A".
*  If the mouse pointer is on the EGS screen, all key codes are redirected
*  to the screen, too.
*
*  EGS screens have a message system on their own so that applications with
*  input processing can lack any window without losing multitasking
*  capabilities.
*

*
*  EMemNode, EMemPtr
*
*  Graphics memory on the card is allocated by the procedure AllocEMem.
*  The memory segments are held in EMemNode list structures.  As graphics
*  cards use almost only big consecutive segments, the EGS libraries possess
*  memory management that can move memory in its address location.  To
*  inhibit memory running away while being used, the EMemNode must be locked
*  by incrementing "lock", e.g. when loading "dest" into any address register.
*  "lock" must be decremented after memory access.  The address of the
*  allocated graphics memory is located in the "dest" field.
*  Only the fields "dest" and "lock" are public, all other fields are
*  strictly private.  Example:
*
*  EMemNode mem;
*  ...
*  mem.lock++;               now mem.dest may be used
*  mem.dest = $AA;
*  ...(further memory accesses)...
*  mem.lock--;               now mem.dest may not be used any longer
*

* To access the "lock" component, you would have to use
*   "mynode.lock.false.lock", which is simply disgusting !
*
* struct E_EMemNode {
*                        APTR Dest;
*                        union {
*                               struct {
*                                       BYTE Lock;
*                                       UBYTE Display;
*                                       } false;
*                               struct {
*                                       UWORD Moveable;
*                                       } true;
*                               } Lock;
*
*                       UWORD Pad_1;
*                       LONG Size;
*                       APTR Next, Prev;
*                  };
*
*   But as "moveable" is private to the EGS library, I just ignore the
*   memory variation.  If you want to test for moveable then test both
*   "lock" and "display".
*
 STRUCTURE  E_EMemNode,0
	APTR    emn_Dest
	BYTE    emn_Lock
	UBYTE   emn_Display
	UWORD   emn_Pad_1
	LONG    emn_Size
	APTR    emn_Next
	APTR    emn_Prev
	LABEL   emn_SIZEOF

*
*  EViewPtr
*
*  Opaque access to a view mode which contains only internal data that is
*  not exported for reasons of compatibility.
*

*
*  CLUEntry, CLU, CLUPtr
*
*  The colour lookup table.  The range of a colour component red, green or
*  blue is 0 to 255, which means all 8 bits are used.  The number of necessary
*  table entries depends on the selected screen depth.  If the CLUT is too
*  short, the missing colours are selected by random.  If no CLUT is
*  specified, a standard CLUT is generated.
*
 STRUCTURE  E_CLUEntry,0
	UBYTE   ece_Red
	UBYTE   ece_Green
	UBYTE   ece_Blue
	UBYTE   ece_Dummy
	LABEL   ece_SIZEOF

*
*  EBitMapPtr, EBitMap
*
*  Basic structure for management of graphics memory.
*
*  As different graphic boards exist which have different memory organisations
*  the egs libraries offer several different bitmap types.
*
*  These are the fields that have the same meaning in any bitmap:
*
*   .Width       : Pixel Width.
*   .Height      : Pixel Height.
*   .BytesPerRow : Number of bytes per row.
*   .Depth       : Number of bits for one pixel; though in 24 bit mode (real)
*                  the number 24 is contained herein, always 32 bits (one
*                  long word) are used.
*
*   .Type        : type of bitmap.
*
*  The different types are:
*
*   E_PIXELMAP      : The memory format is chunky which means that the bits that
*                     build up one pixel lay in adjacent memory locations.
*                     E.g. 2 bits : aabbccdd eeffgghh iijjkkll ...
*                     The organisation in 24 bit is RGBx. This is the native egs
*                     bitmap type. You can allways get an map of these type in
*                     24 bits. The functions in egsblit are allways able to work
*                     with this bitmap and convert from and to other 24 bit
*                     formats, or to other bit depths.
*                     The real location in memory is
*
*                             ..->Typekey.PixelMap.Planes.Dest
*
*                     The memory has to be locked before it is accessed or the
*                     pointer to it, as the libraries are able to move parts
*                     of the graphicsmemory to gain longer fragments.
*                     To lock increment the lock field, to unlock decrement it
*                     again. This lock does not guarantee exclusive access, it
*                     only guarantees, that the bitmap ist not moved.
*
*   E_PIXLACEMAP    : Some graphicsboards have in interlaced an splitted memory
*                     which means that the odd and the even field of the display
*                     reside in different memory locations. The format is the
*                     same as E_pixelMap, with one exception. The even lines
*                     are in one block and the odd lines are in one block. The
*                     starting location of the odd field is
*
*                       ..->Typekey.PixelMap.Planes.Dest+
*                        ..->Typekey.PixelMap.IntDisp
*
*   E_BITPLANEMAP   : The bits that build each pixel are spread over several
*                     bitplanes.
*
*   E_USERMAP       : Nothing is known about the structure of the frame store.
*
*   E_PIXELMAP_xRGB : Same as E_PIXELMAP, exept that the format in 24 bit is
*                     xRGB and not RGBx.
*
*  Your programms should be able to handle at least the E_PIXELMAP format. If
*  it can't handle the format it is given, use the routines of the
*  egsblit.library.
*  If you need a bitmap for double buffering you should use the bitmap from
*  your screen as friend bitmap and the flag E_EB_DISPLAYABLE.
*
*

*
*
*  Enumeration type for access to union fields
*
*
E_PIXELMAP              EQU     0
E_PIXLACEMAP            EQU     1
E_BITPLANEMAP           EQU     2
E_USERMAP               EQU     3
E_PIXELMAP_xRGB         EQU     4
E_EB_DISPLAYABLE        EQU     1
E_EB_BLITABLE           EQU     2
E_EB_SWAPABLE           EQU     4
E_EB_NOTSWAPABLE        EQU     8
E_EB_CLEARMAP           EQU     16

 STRUCTURE  E_EBitMap,0
	WORD    ebm_Width
	WORD    ebm_Height
	WORD    ebm_BytesPerRow
	BYTE    ebm_Depth
	UBYTE   ebm_Type

* Enumeration type descriptor for access to union fields

	APTR    ebm_Dest
	WORD    ebm_Lock
	WORD    ebm_Pad1

	STRUCT  ebm_BitPlanes,24*4  ; because Ptr size is 4 Bytes
				    ; in C BitPlanes[24]
	LABEL   ebm_SIZEOF

*
*               union {
*
*                       struct {
*                               struct   E_EMemNode Planes;
*                                ULONG             IntDisp;
*                              } PixelMap;
*
*                       struct {
*                               APTR   BitPlanes [24];
*                              } BitPlaneMap;
*
*                       struct {
*                               APTR   Action;
*                               } UserMap;
*
*                       } Typekey;
*                 };
*

* Access example:
*
*    E_EBitMapPtr Ptr;
*    APTR Plane, Otherplane;
*
*    if (Ptr->Type == E_BITPLANEMAP)
*      {
*      Plane = Ptr->Typekey.BitPlaneMap.BitPlanes[someindex];
*      }
*    if (Ptr-Type == E_PIXELMAP)
*      {
*      Otherplane = Ptr->Typekey.PixelMap.Planes.Dest;
*      }
*
*

*
*  SoftMousePtr, SoftMouse, HardMousePtr, HardMouse
*
*  Data block for the mouse pointer. Three colours can be used. The bits of
*  a pixel are consecutive as usually, the combination %00 represents a
*  transparent pixel.
*
*  The maximum size of a software mouse pointer is 32 by 32 pixels.  A hard-
*  ware mouse pointer can have up to 64 by 64 pixels but that would exceed
*  the processor capabilities during emulation.
*
*
*  EMouse, EMousePtr
*
*  Definition structure for a mouse pointer.  Each screen can have only one
*  mouse pointer at any moment.  When switching screens, the pointer is
*  changed adequately.  A screen's mouse pointer can be altered by a function
*  at any time.
*
*  For graphics cards without a hardware pointer a pointer is emulated by
*  software.  Specified HardMouse structures are used only if a hardware
*  pointer was implemented, too.  If .soft = NIL then the HardMouse structure
*  is converted into a SoftMouse structure automatically.
*
*   .Color1       : Colour for %01
*   .Color2       : Colour for %10
*   .Color3       : Colour for %11.
*                   These colours are supported only for 4 bit mode and higher.
*   .XSpot,
*   .YSpot        : Displacement of the mouse pointer's click pixel.
*   .Width,
*   .Height       : Width and Height of the SoftMouse.
*   .Soft         : Pointer to SoftMouse structure, should always be initia-
*                   lized for reasons of compatibility.
*   .Hard         : Pointer to HardMouse structure; if you always want to use
*                   the small mouse pointer this field should be NIL.
*
*  Example: The standard mouse pointer.
*
*    StdMouse= EMouse:(Color1=$00000001,Color2=$FF0000FF,Color3=$80000080,
*                      XSpot=1,YSpot=1,Width=25,Height=31,
*                      Soft=SoftMouse:(
*   (%01010101000000000000000000000000,%00000000000000000000000000000000),
*   (%01111111010101010000000000000000,%00000000000000000000000000000000),
*   (%01111010111111110101010100000000,%00000000000000000000000000000000),
*   (%01111111101010101111111101010101,%00000000000000000000000000000000),
*   (%00011111111110101010101011110100,%00000000000000000000000000000000),
*   (%00011111111111111110101011010000,%00000000000000000000000000000000),
*   (%00011111111111111111111101000000,%00000000000000000000000000000000),
*   (%00011111111111111111110100000000,%00000000000000000000000000000000),
*   (%00010111111111111111101101000000,%00000000000000000000000000000000),
*   (%00000111111111111111111011010100,%00000000000000000000000000000000),
*   (%00000111111111111111111110111101,%00000000000000000000000000000000),
*   (%00000111111111011111111111101111,%01000000000000000000000000000000),
*   (%00000101111101010111111111111011,%11010100000000000000000000000000),
*   (%00000001110101010101111111111110,%10111101000000000000000000000000),
*   (%00000001010101010101111111111111,%11101011010000000000000000000000),
*   (%00000001010101010101011111111111,%11111010110101000000000000000000),
*   (%00000001010101010101010111111111,%11111111101111010000000000000000),
*   (%00000001010101010101010101111111,%11111111111101000000000000000000),
*   (%00000001010101010101010101111111,%11111111010100000000000000000000),
*   (%00000000010101010001010101011111,%11111101000000000000000000000000),
*   (%00000000010101000000010101010111,%11110101010000000000000000000000),
*   (%00000000010100000000010101010101,%11110101010100000000000000000000),
*   (%00000000010000000000000101010101,%11010101010101010000000000000000),
*   (%00000000000000000000000001010101,%01010101010101010100000000000000),
*   (%00000000000000000000000000010101,%01010101010101010000000000000000),
*   (%00000000000000000000000000010101,%01010101010101000000000000000000),
*   (%00000000000000000000000000000101,%01010101010000000000000000000000),
*   (%00000000000000000000000000000001,%01010101000000000000000000000000),
*   (%00000000000000000000000000000000,%01010101000000000000000000000000),
*   (%00000000000000000000000000000000,%01010100000000000000000000000000),
*   (%00000000000000000000000000000000,%00010000000000000000000000000000),
*   (%00000000000000000000000000000000,%00000000000000000000000000000000))'PTR);
*
 STRUCTURE  E_EMouse,0
	LONG    emo_Color1
	LONG    emo_Color2
	LONG    emo_Color3
	WORD    emo_XSpot
	WORD    emo_YSpot
	WORD    emo_Width
	WORD    emo_Height
	APTR    emo_Soft
	APTR    emo_Hard
	LABEL   emo_SIZEOF

*
*  EScrFlags, EScrFlagSet, EScreen, EScreenPtr, NewEScreen...
*
*  EScreens are structures with capabilities as follows:
*   - Management of resolution mode (EViewPtr)
*   - Management of graphics memory (EBitMap)
*   - Message system for user input
*  Please note that an EScreen is different from the EGSIntui screens, i.e.
*  NO window can be opened on any EScreen; for that purpose an EGSIntui screen
*  must be created.
*
*  EScrFlags
*     SCREENBEHIND : The new screen is opened behind all other screens.
*     OWNBITMAP    : The screen has a user defined BitMap.
*     LACESCREEN   : The screen is to be opened as interlaced to decrease
*                    video line frequency in spite of knowing the flicker
*                    (currently without meaning).
*
*  NewEScreen
*   .Mode          : Name of the selected video mode ending with a null byte.
*   .Depth         : Required bit depth (1, 2, 4, 6, 8, 12, 16 or 24).
*                    Allowed pixel depths depend on the underlying hardware,
*                    and may vary for different screen modes. The suggested
*                    way to retrieve data for supported modes and depths is
*                    by the use of 'E_GetHardInfo'.
*   .Colors        : An own CLUT if required; if NIL the standard CLUT is used.
*   .Map           : Possibly a user BitMap which has to be allocated
*                    previously.
*   .Flags         : Flags for the new screen (only "SCREENBEHIND").
*   .Mouse         : Possibly a user mouse pointer.
*   .EdcmpFlags    : Messages to be sent.
*   .Port          : Possibly an application message port; must be removed
*                    before closing the screen (or crash).
*

* Corresponding EScrFlagSet has 32 bits !
E_SCREENBEHIND          EQU     1
E_OWN_BITMAP            EQU     2
E_LACESCREEN            EQU     4

 STRUCTURE  E_NewEScreen,0
	APTR    ens_Mode
	UWORD   ens_Depth
	UWORD   ens_Pad_1
	APTR    ens_Colors
	APTR    ens_Map
	ULONG   ens_Flags
	APTR    ens_Mouse
	ULONG   ens_EdcmpFlags
	APTR    ens_Port
	LABEL   ens_SIZEOF

*
*  EScreen
*   .Prev,
*   .Next          : Internal chaining.
*   .View          : !!!! PRIVATE !!!!
*   .Map           : Pointer to the screen's BitMap structure.
*   .Colors        : !!!! PRIVATE !!!!
*   .Mouse         : EMouse structure (READ ONLY !!!!).
*   .MouseOn       : !!!! PRIVATE !!!!
*   .EdcmpFlags    : Message flags (READ ONLY !!!).
*   .Port          : Screen's message port.
*   .BackLink      : Link field for users, e.g. used by EGSIntui.
*   .MouseX,
*   .MouseY        : Always the current mouse position on the screen.
*
 STRUCTURE  E_EScreen,0
	APTR    esc_Prev
	APTR    esc_Next
	APTR    esc_View
	APTR    esc_Map
	APTR    esc_Colors
	APTR    esc_Mouse
	ULONG   esc_Flags
	UBYTE   esc_MouseOn
	UBYTE   esc_Pad_1
	UBYTE   esc_Pad_2
	UBYTE   esc_Pad_3
	ULONG   esc_EdcmpFlags
	APTR    esc_Port
	APTR    esc_BackLink
	WORD    esc_MouseX
	WORD    esc_MouseY
	LABEL   esc_SIZEOF

*
*  EDCMPFlags, EDCMPFlagSet, EGSMsgPtr, EGSMessage
*
*  Structures for the message system working on the EScreen level.  Thus
*  mouse and character input can be gained without opening a window.
*
*  EDCMPFlags:
*    eMOUSEBUTTONS  : Mouse buttons were pressed
*    eMOUSEMOVE     : Mouse was moved
*    eRAWKEY        : Key code from the keyboard
*    eINTUITICK     : Timer is calling
*    eDISKINSERTED  : Disk was inserted
*    eDISKREMOVED   : Disk was removed
*    eNEWPREFS      : Preferences have been changed
*
*   .Class          : Type of the message
*   .Code           : Message code (refer to  "InputEvents")
*   .Qualifier      : Message code (refer to  "InputEvents")
*   .IAddress       : (For E_eRAWKEY: Pointer to deadkey array )
*   .MouseX,
*   .MouseY         : Mouse position
*   .Second,
*   .Micros         : Event time
*   .EdcmpScreen    : Screen sending the message
*

* Corresponding EDCMPFlagSet has 32 bits !
E_eMOUSEBUTTONS         EQU     1
E_eMOUSEMOVE            EQU     2
E_eRAWKEY               EQU     4
E_eTIMETICK             EQU     8
E_eDISKINSERTED         EQU     16
E_eDISKREMOVED          EQU     32
E_eNEWPREFS             EQU     64

 STRUCTURE  E_EGSMessage,0
	STRUCT  ems_Msg,MN_SIZE
				; has long word size
	ULONG   ems_Class
	UWORD   ems_Code
	UWORD   ems_Qualifier
	APTR    ems_IAddress
	WORD    ems_MouseX
	WORD    ems_MouseY
	ULONG   ems_Seconds
	ULONG   ems_Micros
	APTR    ems_EdcmpScreen
	LABEL   ems_SIZEOF

*
*  ScreenMode, ScreenModePtr
*
*  Information on supported screen modes and depths. The list including
*  these modes is found by 'GetHardInfo'.
*
*   .ln_Name : The name of the mode, for use in 'E_OpenScreen' ...
*   .Horiz     : The horizontal resolution
*   .Vert      : The vertical resolution
*   .Depths    : The supported pixel depths in this mode. Each depth is
*                represented in one bit. E.g. (1<<24) & mode->depths for
*                24 bit.
*
 STRUCTURE  E_ScreenMode,0
	STRUCT  esm_Node,LN_SIZE
	UWORD   esm_Pad
	UWORD   esm_Horiz
	UWORD   esm_Vert
	ULONG   esm_Depths
	LABEL   esm_SIZEOF

*
*  To realize the highest possible compatibility between different graphics
*  cards, the library must offer a function giving information about the
*  current card plugged in.  Among these information items are the resolutions
*  that the card implements.
*  That task is carried out by the HardInfo structure and the procedure
*  "GetHardInfo".
*

* Corresponding HardInfoFlagSet has 32 bits !

E_HARD_BLITTER                  EQU     1
E_HARD_BOOTROM                  EQU     2
E_HARD_VBLANK                   EQU     4
E_HARD_REALMODE                 EQU     8
E_HARD_GAMMACORRECT             EQU     16
E_HARD_PLANES                   EQU     32

 STRUCTURE  E_HardInfo,0
	APTR    ehi_Product
	APTR    ehi_Manufact
	APTR    ehi_Name
	WORD    ehi_Version
	WORD    ehi_MaxFreq
	ULONG   ehi_Flags
	APTR    ehi_Modes
	WORD    ehi_ActPixClock
	WORD    ehi_frameTime
	APTR    ehi_MemBase
	LONG    ehi_MemSize
	APTR    ehi_LibDate
	LABEL   ehi_SIZEOF

	ENDC  ; EGS_EGS_H
