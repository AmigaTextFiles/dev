/*
**     $VER: rtgsublibs.h 1.009 (15 Jan 1998)
*/

MODULE	'utility/tagitem'
			'exec/nodes'

// The TagItem ID's (ti_Tag values) for OpenRtgScreen()
// Information like width, height, screenmode to use, depth and overscan
// information is located in the ScreenReq structure which must be passed
// to OpenRtgScreen().  The RtgScreenModeReq() function creates these
// ScreenReq structures for you.
#define rtg_Dummy  TAG_USER
#define rtg_Buffers  (rtg_Dummy + $01)
// [1] You can use this tag to specify the number
// of screen buffers for your screen.  Setting this
// to 2 or 3 will allow you to do Double or Triple
// buffering.  Valid values are 1, 2 or 3.

#define rtg_Interleaved  (rtg_Dummy + $02)
// [FALSE] Specifying TRUE will cause bitmaps to
// be allocated interleaved.  OpenRtgScreen will
// fail if bitplanes cannot be allocated that way
// unlike Intuition/OpenScreenTagList().

#define rtg_Draggable  (rtg_Dummy + $03)
// [TRUE] Specifying FALSE will make the screen
// non-draggable.  Do not use without good reason!

#define rtg_Exclusive  (rtg_Dummy + $04)
// [FALSE] Allows screens which won't share the
// display with other screens.  Use sparingly!
// #define rtg_ChunkySupport (rtg_Dummy + 0x05)
//
// [0] This LONG is used to indicate which
// Chunky modes this application supports.  A
// set bit means the mode is supported:
// ;    ;
// ;    ;    | Pixels  | Pixel|Color| Pixel
// ;    ; Bit|represent| size |space| layout
// ;    ;------------------------------------------------------------------
// ;    ;  0  TrueColor  LONG   RGB   %00000000 rrrrrrrr gggggggg bbbbbbbb  ARGB32
// ;    ;  1  TrueColor 3 BYTE  RGB   %rrrrrrrr gggggggg bbbbbbbb           RGB24
// ;    ;  2  TrueColor  WORD   RGB   %rrrrrggg gggbbbbb                    RGB16
// ;    ;  3  TrueColor  WORD   RGB   %0rrrrrgg gggbbbbb                    RGB15
// ;    ;  4  TrueColor  LONG   BGR   %00000000 bbbbbbbb gggggggg rrrrrrrr  ABGR32
// ;    ;  5  TrueColor 3 BYTE  BGR   %bbbbbbbb gggggggg rrrrrrrr           BGR24
// ;    ;  6  TrueColor  WORD   BGR   %bbbbbggg gggrrrrr                    BGR16
// ;    ;  7  TrueColor  WORD   BGR   %0bbbbbgg gggrrrrr                    BGR15
// ;    ;  8  TrueColor  LONG   RGB   %rrrrrrrr gggggggg bbbbbbbb 00000000  RGBA32
// ;    ;  9  ColorMap   BYTE   -     -                                     LUT8
// ;    ; 10  Graffiti   BYTE   -     - (Graffiti style chunky, very special)
// ;    ; 11  TrueColor  WORD   RGB   %gggbbbbb 0rrrrrgg                    RGB15PC
// ;    ; 12  TrueColor  WORD   BGR   %gggrrrrr 0bbbbbgg                    BGR15PC
// ;    ; 13  TrueColor  WORD   RGB   %gggbbbbb rrrrrggg                    RGB16PC
// ;    ; 14  TrueColor  WORD   BGR   %gggrrrrr bbbbbggg                    BGR16PC
// ;    ; 15  TrueColor  LONG   BGR   %bbbbbbbb gggggggg rrrrrrrr 00000000  BGRA32
//;
//    ; This table is by no means complete.  There are probably more modes
//    ; available on common Amiga graphic cards, but I have no information
//    ; on them yet.  If you know about such modes please contact me.
//
//    ; Setting this LONG to zero means your application doesn't support
//    ; any Chunky orientated display modes.
//
//    #define rtg_PlanarSupport (rtg_Dummy + 0x06)
//                            ;[0] This LONG is used to indicate which
//                            ;Planar modes this application supports.  A
//                            ;set bit means the mode is supported:
//    ; Bit 0: Indicates it supports 1 bitplane non-interleaved
//    ; Bit 1: Indicates it supports 2 bitplanes non-interleaved
//    ; (...)
//    ; Bit 7: Indicates it supports 8 bitplanes non-interleaved
//
//    ; Bit 16: Indicates it supports 1 bitplane interleaved
//    ; Bit 17: Indicates it supports 2 bitplanes interleaved
//    ; (...)
//    ; Bit 23: Indicates it supports 8 bitplanes interleaved
//
//    ; Bit 15: Indicates it supports EHB mode (6 bitplanes) non-interleaved
//    ; Bit 31: Indicates it supports EHB mode (6 bitplanes) interleaved
//
//    ; Note that all planar modes are color-mapped.  Bits 8-14 and 24-30
//    ; are unused for now, but could be used later to support planar modes
//    ; with even higher number of bitplanes.
//
//    ; Setting this LONG to zero means your application doesn't support
//    ; any Planar orientated display modes.

#define ARGB32  1
#define RGB24   2
#define RGB16   4
#define RGB15   8
#define ABGR32  16
#define BGR24   32
#define BGR16   64
#define BGR15   128
#define RGBA32  256
#define LUT8    512
#define GRAFFITI  1024
#define RGB15PC   2048
#define BGR15PC   4096
#define RGB16PC   8192
#define BGR16PC   16384
#define BGRA32    32768
#define Planar1   1
#define Planar2   2
#define Planar3   4
#define Planar4   8
#define Planar5   16
#define Planar6   32
#define Planar7   64
#define Planar8   128
#define Planar1I  1<<16
#define Planar2I  1<<17
#define Planar3I  1<<18
#define Planar4I  1<<19
#define Planar5I  1<<20
#define Planar6I  1<<21
#define Planar7I  1<<22
#define Planar8I  1<<23
#define PlanarEHB  1<<15
#define PlanarEHBI  1<<31
#define rtg_ZBuffer  (rtg_Dummy + $07)
// Allocate a Z-Buffer. Only works with sublibraries that implement the rtgmaster 3D Extensions.

#define rtg_Use3D  (rtg_Dummy + $08)
// Use the 3D Chips. (You can only do conventional Double/Triple-Buffering, if you do NOT use
// them. If you use them, the Extra Buffers are used by the 3D Chips)

#define rtg_Workbench  (rtg_Dummy + $09)
// Open a Window on the Workbench, instead of a Screen. This Tag takes the Colorformat
// to use with CopyRtgBlit() as Parameter
// End of OpenRtgScreenTagList() enumeration ***
// This structure is private and for the internal use of RtgMaster.library
// and its sub-libraries ONLY.  This structure will change in the future.

#define rtg_MouseMove  (rtg_Dummy+ $0A)
// RtgGetMsg also returns IDCMP_MOUSEMOVE messages

#define rtg_DeltaMove  (rtg_Dummy+ $0B)
// RtgGetMsg also returns IDCMP_MOUSEMOVE messages, and it returns Delta-Values,
// not absolute values.

#define rtg_PubScreenName  (rtg_Dummy+ $0C)
// Open a Window on a Public Screen with the provided Public Screen Name.
// Note: This does not work with all Sublibraries. Some simply ignore this
// (For example EGS...)

OBJECT RtgDimensionInfo
	Width:ULONG,
	Height:ULONG

// This structure is private and for the internal use of RtgMaster.library
// and its sub-libraries ONLY.  This structure will change in the future.
OBJECT ScreenMode
	ScrNode:MinNode,                      // ln_Succ and ln_Pred from ListNode structure
	Name:PTR TO UBYTE,
	Description:PTR TO UBYTE,             // Description of the graphics board this mode
	GraphicsBoard:ULONG,                  // The graphics board this mode requires
	ModeID:ULONG,                         // ModeID (depends on sm_GraphicsBoard)
	Reserved[8]:BYTE,                     // 8 bytes reserved space for use of the sub-library
	MinWidth:ULONG,                       // minimum width in pixels
	MaxWidth:ULONG,                       // maximum width in pixels
	MinHeight:ULONG,                      // Minimum height in pixels
	MaxHeight:ULONG,                      // Maximum height in pixels
	Default:RtgDimensionInfo,             // Standard width and height of this ScreenMode
	TextOverscan:RtgDimensionInfo,        // Settable via preferences
	StandardOverscan:RtgDimensionInfo,    // Settable via preferences
	MaxOverscan:RtgDimensionInfo,         // Maximum width and height (without the
	ChunkySupport:ULONG,                  // This LONG is used to indicate which Chunky
	PlanarSupport:ULONG,                  // This LONG is used to indicate which Planar
	PixelAspect:ULONG,                    // For a PAL 320x256 screen you have to write
	VertScan:ULONG,                       // Vertical scan rate of this screenmode
	HorScan:ULONG,                        // Horizontal scan rate of this screenmode
	PixelClock:ULONG,                     // Pixelclock rate (in Hz)
	VertBlank:ULONG,                      // Vertical blank rate of this screenmode
	Buffers:ULONG,                        // The number of buffers this ScreenMode can
	BitsRed:UWORD,                        // The number of bits per gun for Red
	BitsGreen:UWORD,                      // The number of bits per gun for Green
	BitsBlue:UWORD                        // The number of bits per gun for Blue

// The TagItem ID's (ti_Tag values) for GetRtgScreenData()
// These tags are used to return data to the user about the RtgScreen
// structure in a future compatible way.
#define grd_Dummy  TAG_USER
#define grd_Width  (grd_Dummy + $01)
// Gets you the Width in pixels of the screen

#define grd_Height  (grd_Dummy + $02)
// Gets you the Height in pixels of the screen

#define grd_PixelLayout  (grd_Dummy + $03)
// Gets you the pixellayout of the screen, see
// defines below.  This also tells you whether
// the screen is Chunky or Planar

#define grd_ColorSpace  (grd_Dummy + $04)
// Gets you the colorspace of the screen, see
// defines below

#define grd_Depth  (grd_Dummy + $05)
// The number of colors LOG 2.  For Planar modes
// this also tells you the number of bitplanes.
// Don't rely on this number except to get the
// number of colors for Chunky modes.

#define grd_PlaneSize  (grd_Dummy + $06)
// Tells you the number of bytes to skip to get
// to the next (bit)plane.  You can use this to
// find the start addresses of the other (bit)planes
// in Planar and in (BytePlane) Chunky modes

#define grd_BytesPerRow  (grd_Dummy + $07)
// The number of bytes taken up by a row.  This
// refers to one (bit/byte)plane only for modes
// working with planes.

#define grd_MouseX  (grd_Dummy + $08)
// Finds out the Mouse X position

#define grd_MouseY  (grd_Dummy + $09)
// Finds out the Mouse Y position
// The TagItem ID's (ti_Tag values) for GetGfxCardData()
// These tags are used to return data to the user about the graphics card
// which the RtgScreen uses.

#define grd_BusSystem  (grd_Dummy + $0A)
#define grd_3DChipset  (grd_Dummy + $0B)

// For usage with the rtgmaster 3D Extensions, will be ignored from sublibraries
// that do not support the 3D Extensions.
#define grd_Z3  1	// Zorro III Bus
#define grd_Z2  2	// Zorro II Bus
#define grd_Custom  3	// Custom Chipset
#define grd_RGBPort  4	// Board connected to RGB Port
#define grd_GVP  5	// GVP "special" Bus of GVP Turbo Board (EGS110 GFX Board)
#define grd_DDirect  6	// DraCo Direct Bus

// defines for grd_PixelLayout
#define grd_PLANAR      0	// Non interleaved planar layout [X bitplanes/pixel]
#define grd_PLANATI     1	// Interleaved planar layout     [X bitplanes/pixel]
#define grd_CHUNKY      2	// 8-bit Chunky layout           [BYTE/pixel]
#define grd_HICOL15     3	// 15-bit Chunky layout          [WORD/pixel]
#define grd_HICOL16     4	// 16-bit Chunky layout          [WORD/pixel]
#define grd_TRUECOL24   5	// 24-bit Chunky layout          [3 BYTES/pixel]
#define grd_TRUECOL24P  6	// 24-bit Chunky layout          [3 BYTEPLANES/pixel]
#define grd_TRUECOL32   7	// 24-bit Chunky layout          [LONG/pixel]
#define grd_GRAFFITI    8	// 8-bit Graffiti-type Chunky layout (very special...)
#define grd_TRUECOL32B  9

// defines for grd_ColorSpace
#define grd_Palette  0	// Mode uses a Color Look-Up Table (CLUT)
#define grd_RGB      1	// Standard RGB color space
#define grd_BGR      2	// high-endian RGB color space, BGR
#define grd_RGBPC    3	// RGB with lowbyte and highbyte swapped
#define grd_BGRPC    4	// BGR with lowbyte and highbyte swapped

// End of GetRtgScreenData() enumeration ***
// Information about the RtgScreenModeReq tags:
//
// Each tag specified for the RtgScreenModeReq() function limits in some
// way the number of ScreenModes available to the user.  Sometimes this
// means a screenmode is completely ommited, and sometimes this means
// certain screenmodes can only be used if the user selects them to
// be wide enough.  So for example, a ScreenMode which supports screens
// of 300 to 400 pixels in width, could be filtered out completely by
// setting smr_MinWidth to 401.  But if the smr_MinWidth is set to for
// example 320 then the user is allowed to select a width of 320-400
// pixels (for this ScreenMode, and if the smr_MaxWidth allows this).
// If smr_MinWidth is 200 pixels then the ScreenMode is the limiting
// factor which means the user can't select ScreenModes smaller than
// 300 pixels.
//
// The PlanarSupport and ChunkySupport tags determine which ScreenModes
// are available to the user depending on their layout and number of
// colors.
// This structure is private and for the internal use of RtgMaster.library
// and its sub-libraries ONLY.  This structure will change in the future.
OBJECT ScreenReq
	ScreenMode:PTR TO ScreenMode,    // Ptr to ScreenMode structure
	Width:ULONG,                     // Must be within Tag specified limits
	Height:ULONG,                    // The width and height which the user selected
	Depth:UWORD,                     // Number of colors log2 which the user selected
	Overscan:UWORD,                  // 0 = No Overscan.  See defines below.
	Flags:UBYTE                      // For the meaning of the bits see below

OBJECT ScreenReqList
	SRNode:MinNode,
	req:PTR TO ScreenReq

// Bits set in ScreenMode.Flags
#define sq_EHB           (1 << 0)  	// EHB selected (sq_Depth = 6)
#define sq_CHUNKYMODE    (1 << 1)  	// Chunky Mode selected
#define sq_DEFAULTX      (1 << 2)  	// Default Width selected
#define sq_DEFAULTY      (1 << 3)  	// Default Height selected

// defines for Overscan
#define sq_NOOVERSCAN        0
#define sq_TEXTOVERSCAN      1	// User settable, should be entirely visible
#define sq_STANDARDOVERSCAN  2	// Standard overscan (just past edges)
#define sq_MAXOVERSCAN       3	// Maximum overscan (as much as possible)

// This structure is private and for the internal use of RtgMaster.library
// and its sub-libraries ONLY.  This structure will change in the future.
OBJECT RtgScreen
	LibBase:ULONG,
	LibVersion:UWORD,
	Pad1:UWORD,
	GraphicsBoard:ULONG,
	Reserved[20]:BYTE,
	MouseX:ULONG,
	MouseY:ULONG,
	c2pcode:PTR,
	c2pdata:PTR,
	c2pcurr:ULONG,
	c2pname[30]:BYTE
