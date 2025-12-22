/*
**
** Include file for the Warp3D API
** $VER: Warp3D.h 1.0 (20.05.98)
**
**
** This file is part of the Warp3D Project.
** Warp3D is copyrighted
** (C) 1998 Sam Jordan, Hans-Jörg Frieden, Thomas Frieden
** All rights reserved
**
** See the documentation for conditions.
**
** Converted to PowerD by Martin Kuchinka with help of h2m converter (7.7.2001)
*/
MODULE	'exec/lists'
MODULE	'exec/nodes'
MODULE	'exec/libraries'
MODULE	'utility/tagitem'
MODULE	'graphics/gfx'
MODULE	'graphics/displayinfo'

TDEF	W3D_Bool:WORD
TDEF	W3D_Float:FLOAT
TDEF	W3D_Double:DOUBLE

CONST	W3D_TRUE=1
CONST	W3D_FALSE=0

OBJECT W3D_Color
	r:W3D_Float,
	g:W3D_Float,
	b:W3D_Float,
	a:W3D_Float     /* RGBA values in range [0..1] */

OBJECT W3D_ColorRGB
	r:W3D_Float,
	g:W3D_Float,
	b:W3D_Float     /* RGB values in range [0..1] */

OBJECT W3D_Vertex
	x:W3D_Float,
	y:W3D_Float,          /* window coordinates */
	z:W3D_Double,         /* z koordinate. Double precision for 32bit
				   zbuffers */
	w:W3D_Float,          /* w koordinate. */
	u:W3D_Float,
	v:W3D_Float,
	tex3d:W3D_Float,      /* u/v koordinates, and an additional for 3d
				   textures */
	color:W3D_Color,      /* vertex color */
	spec:W3D_ColorRGB,    /* specular lighting color */
	l:W3D_Float           /* Lambda value for Mipmapping. Private right 
				   now */

OBJECT W3D_Texture
	link:Node,                  /* linkage, used by Warp3D itself */
	resident:W3D_Bool,          /* TRUE, if texture is on card */
	mipmap:W3D_Bool,            /* TRUE, if mipmaps are supported */
	dirty:W3D_Bool,             /* TRUE, if texture image was changed */
	matchfmt:W3D_Bool,          /* TRUE, if srcfmt = destfmt */
	reserved1:W3D_Bool,
	reserved2:W3D_Bool,
	mipmapmask:ULONG,           /* which mipmaps have to be generated */
	texsource:VOID,      /* texture source image */
	mipmaps[16]:VOID,    /* mipmap images */
	texfmtsrc:LONG,             /* texture format (from W3D_ATO_FORMAT) */
	palette:PTR TO ULONG,       /* texture palette for chunky textures */
	texdata:VOID,        /* texture data converted */
	texdest:VOID,        /* texture location on card */
	texdestsize:LONG,           /* size of VRAM allocation */
	texwidth:LONG,              /* texture width in pixels */
	texwidthexp:LONG,           /* texture width exponent */
	texheight:LONG,             /* texture width in pixels */
	texheightexp:LONG,          /* texture width exponent */
	bytesperpix:LONG,           /* bytes per pixel */
	bytesperrow:LONG,           /* bytes per row */
	driver:VOID          /* insert driver specific data here */

OBJECT W3D_Point
	v1:W3D_Vertex,             /* vertex */
	tex:PTR TO W3D_Texture,    /* texture */
	pointsize:W3D_Float        /* point diameter */

OBJECT W3D_Line
	v1:W3D_Vertex,
	v2:W3D_Vertex,             /* vertices for line drawing */
	tex:PTR TO W3D_Texture,    /* texture */
	linewidth:W3D_Float,       /* line width */
	st_enable:W3D_Bool,        /* stippling enable */
	st_pattern:UWORD,          /* stippling pattern */
	st_factor:LONG             /* stippling factor */

OBJECT W3D_Lines
	vertexcount:LONG,          /* Number of vertices */
	v:PTR TO W3D_Vertex,       /* An array of at least two vertices */
	tex:PTR TO W3D_Texture,    /* texture */
	linewidth:W3D_Float,       /* line width */
	st_enable:W3D_Bool,        /* stippling enable */
	st_pattern:UWORD,          /* stippling pattern */
	st_factor:LONG             /* stippling factor */

OBJECT W3D_Triangle
	v1:W3D_Vertex,
	v2:W3D_Vertex,
	v3:W3D_Vertex,              /* three vertices for triangle drawing */
	tex:PTR TO W3D_Texture,     /* texture */
	st_pattern:PTR TO UBYTE     /* stippling pattern */

OBJECT W3D_TriangleV
	v1:PTR TO W3D_Vertex,
	v2:PTR TO W3D_Vertex,
	v3:PTR TO W3D_Vertex,       /* Three vertex POINTERS */
	tex:PTR TO W3D_Texture,     /* see above */
	st_pattern:PTR TO UBYTE     /* See above */

OBJECT W3D_Triangles
	vertexcount:LONG,           /* number of vertices */
	v:PTR TO W3D_Vertex,        /* an array of at least 3 vertices */
	tex:PTR TO W3D_Texture,     /* texture */
	st_pattern:PTR TO UBYTE     /* stippling pattern */

OBJECT W3D_TrianglesV
	vertexcount:LONG,              /* number of vertices */
	v:PTR TO PTR TO W3D_Vertex,    /* Pointer to an array of pointers ! */
	tex:PTR TO W3D_Texture,        /* Texture */
	st_pattern:PTR TO UBYTE        /* Stippling pattern */

OBJECT W3D_Fog
	start:W3D_Float,       /* start of fogging zone */
	end:W3D_Float,         /* end of fogging area */
	density:W3D_Float,     /* fog density for exp. fogging */
	color:W3D_ColorRGB     /* fog color */

OBJECT W3D_Scissor
	left:LONG,      /* left offset of clipping area */
	top:LONG,       /* top offset of clipping area */
	width:LONG,     /* width of clipping area */
	height:LONG     /* height of clipping area */

OBJECT W3D_QHead
	type:WORD,      /* Type of this entry */
	length:WORD,    /* Length of the entry, including this struct */
	state:ULONG     /* State longword */

OBJECT W3D_Queue
	data:PTR TO UBYTE,       /* Pointer to data area */
	size:ULONG,              /* Size of the data block */
	current:PTR TO UBYTE     /* Current insertion position */

#define QEMPTY(x) ( x.data = x.current )

/* The maximum number of texture mapping units (TMU) supported by Warp3D right now */
#define W3D_MAX_TMU          16     	/* be prepared that this might grow */

/* The context structure is private, and should not be accessed in any
   way by Warp3D applications, with the following exceptions:

   The following fields are READ-ONLY:
   format, bprow, width, height, depth, drawmem

 */
OBJECT W3D_Context
	driver:VOID,                            /* insert driver specific data here */
	gfxdriver:VOID,                         /* usable by the GFXdriver */
	drivertype:LONG,                               /* driver type (3DHW / CPU) */
	regbase:VOID,                           /* register base */
	vmembase:VOID,                          /* video memory base */
	zbuffer:VOID,                           /* Pointer to the Z buffer */
	stencilbuffer:VOID,                     /* Pointer to the stencil buffer */
	state:ULONG,                                   /* hardware state (see below) */
	drawregion:PTR TO BitMap,                      /* destination bitmap */
	supportedfmt:ULONG,                            /* bitmask with all supported dest fmt */
	format:ULONG,                                  /* bitmap format (see below) */
	yoffset:LONG,                                  /* Y-Offset (for ScrollVPort-Multibuf.) */
	bprow:LONG,                                    /* bytes per row */
	width:LONG,                                    /* bitmap width */
	height:LONG,                                   /* bitmap height */
	depth:LONG,                                    /* bitmap depth */
	chunky:W3D_Bool,                               /* TRUE, if palettized screen mode */
	destalpha:W3D_Bool,                            /* TRUE, if dest alpha channel available */
	zbufferalloc:W3D_Bool,                         /* TRUE, is Z buffer is allocated */
	stbufferalloc:W3D_Bool,                        /* TRUE, is stencil buffer is allocated */
	HWlocked:W3D_Bool,                             /* TRUE, if 3D HW was locked */
	w3dbitmap:W3D_Bool,                            /* TRUE, if drawregion points to a W3D_Bitmap */
	zbufferlost:W3D_Bool,                          /* TRUE, if zbuffer not reallocatable */
	reserved3:W3D_Bool,
	restex:MinList,                                /* A list of all resident textures, used for LRU implementation */
	tex:MinList,                                   /* A list of all textures which are not on card */
	maxtexwidth:LONG,                              /* -HJF- replaced these for possible */
	maxtexheight:LONG,                             /* support of non-square textures */
	maxtexwidthp:LONG,                             /* -HJF- For hardware that has different */
	maxtexheightp:LONG,                            /* constaints in perspective mode */
	scissor:W3D_Scissor,                           /* scissor region */
	fog:W3D_Fog,                                   /* fogging parameters */
	envsupmask:ULONG,                              /* Mask of supported envmodes */
	queue:PTR TO W3D_Queue,                        /* queue to buffer drawings */
	drawmem:VOID,                           /* base address for drawing operations */
	globaltexenvmode:ULONG,                        /* Global texture environment mode */
	globaltexenvcolor[4]:W3D_Float,                /* global texture env color */
	DriverBase:PTR TO Library,                     /* Library base of the active driver */
	EnableMask:ULONG,                              /* Mask for enable-able states */
	DisableMask:ULONG,                             /* Mask for disable-able states */
	CurrentChip:ULONG,                             /* Chip constant */
	DriverVersion:ULONG,                           /* Internal driver version */
	VertexPointer:VOID,                     /* Pointer to the vertex buffer array */
	VPStride:LONG,                                 /* Stride of vertex array */
	VPMode:ULONG,                                  /* Vertex buffer format */
	VPFlags:ULONG,                                 /* not yet used */
	TexCoordPointer[W3D_MAX_TMU]:VOID,      /* Pointer to each TMU's texture coordinate array */
	TPStride[W3D_MAX_TMU]:LONG,                    /* Stride of TexCoordPointers */
	CurrentTex[W3D_MAX_TMU]:PTR TO W3D_Texture,    /* Pointer to each TMU's texture object */
	TPVOffs[W3D_MAX_TMU]:LONG,                     /* Offset to V coordinate */
	TPWOffs[W3D_MAX_TMU]:LONG,                     /* Offset to W coordinate */
	TPFlags[W3D_MAX_TMU]:LONG,                     /* Flags */
	ColorPointer:VOID,                      /* Pointer to the color array */
	CPStride:LONG,                                 /* Color pointer stride */
	CPMode:ULONG,                                  /* Mode and color format */
	CPFlags:ULONG,                                 /* not yet used */
	FrontFaceOrder:ULONG                           /* Winding order of front facing triangles */

OBJECT W3D_Bitmap
	bprow:LONG,          /* Bytes per row */
	width:LONG,          /* Width */
	height:LONG,         /* Height */
	format:ULONG,        /* Destination color format */
	dest:VOID     /* Pointer to destination */

OBJECT W3D_Driver              /* W3D_ScreenMode structure */
	ChipID:ULONG,         /* One of W3D_CHIP_??? below */
	formats:ULONG,        /* Bitmask of supported formats */
	name:PTR TO UBYTE,    /* Name of the chip/driver */
	swdriver:W3D_Bool     /* W3D_TRUE -> CPU-Driver */

OBJECT W3D_ScreenMode                              /* Tags for W3D_CreateContext */
	ModeID:ULONG,                         /* ModeID for OpenScreen */
	Width:ULONG,
	Height:ULONG,                         /* Width and Height for visible screen */
	Depth:ULONG,                          /* Pixel Depth */
	DisplayName[DISPLAYNAMELEN]:UBYTE,    /* readable name of this display mode 
					 */
	Driver:PTR TO W3D_Driver,             /* Matching driver for this mode */
	Next:VOID                      /* Next W3D_ScreenMode in list */

#define W3D_CC_TAGS              (TAG_USER+$200000)
#define W3D_CC_BITMAP            (W3D_CC_TAGS+0)        	/* destination bitmap */
#define W3D_CC_YOFFSET           (W3D_CC_TAGS+1)        	/* y-Offset */
#define W3D_CC_DRIVERTYPE        (W3D_CC_TAGS+2)        	/* see below */
#define W3D_CC_W3DBM             (W3D_CC_TAGS+3)        	/* Use W3D_Bitmap instead of struct BitMap */
#define W3D_CC_INDIRECT          (W3D_CC_TAGS+4)        	/* Indirect drawing */
#define W3D_CC_GLOBALTEXENV      (W3D_CC_TAGS+5)        	/* SetTexEnv is global */
#define W3D_CC_DOUBLEHEIGHT      (W3D_CC_TAGS+6)        	/* Drawing area has double height */
#define W3D_CC_FAST              (W3D_CC_TAGS+7)        	/* Allow Warp3D to modify passed Triangle/Lines/Points */
#define W3D_CC_MODEID            (W3D_CC_TAGS+8)        	/* Specify modeID to use */

/* driver types. These are used as flags for W3D_CreateContext and as bitmask
   for W3D_CheckDriver. It is also used by W3DHW_GetDriverInfo and in the
   element 'drivertype' in the context structure */
#define W3D_DRIVER_UNAVAILABLE   (1<<0) 	/* driver unavailable */
#define W3D_DRIVER_BEST          (1<<1) 	/* use best mode */
#define W3D_DRIVER_3DHW          (1<<2) 	/* use 3D-HW */
#define W3D_DRIVER_CPU           (1<<3) 	/* use CPU */

/*  Chip constants returned e.g. by W3D_GetDrivers. These can be
   used to identify the chip that is active/available.
   You may not, however, make any assumtions about the capabilities
   of the driver based on this constant, since some features might be
   emulated.
   Strictly for informational/internal uses.
 */
CONST	W3D_CHIP_UNKNOWN=1,
		W3D_CHIP_VIRGE=2,
		W3D_CHIP_PERMEDIA2=3,
		W3D_CHIP_VOODOO1=4

/* Tags for W3D_AllocTexObj */
#define W3D_ATO_TAGS             (TAG_USER+$201000)
#define W3D_ATO_IMAGE            (W3D_ATO_TAGS+0)       	/* texture image */
#define W3D_ATO_FORMAT           (W3D_ATO_TAGS+1)       	/* source format */
#define W3D_ATO_WIDTH            (W3D_ATO_TAGS+2)       	/* border width */
#define W3D_ATO_HEIGHT           (W3D_ATO_TAGS+3)       	/* border height */
#define W3D_ATO_MIPMAP           (W3D_ATO_TAGS+4)       	/* mipmap mask */
#define W3D_ATO_PALETTE          (W3D_ATO_TAGS+5)       	/* texture palette */
#define W3D_ATO_MIPMAPPTRS       (W3D_ATO_TAGS+6)       	/* array of user-supplied mipmaps */

/* Possible modes for SetFrontFace */
#define W3D_CW                   0                      	/* Front face is clockwise */
#define W3D_CCW                  1                      	/* Front face is counter clockwise */

/* possible values for W3D_ATO_FORMAT  and W3D_GetTexFmtInfo */
/* a = alpha, r = red, g = green, b = blue, l = luminance, i = intensity */
#define W3D_CHUNKY               1      	/* palettized */
#define W3D_A1R5G5B5             2      	/* a rrrrr ggggg bbbbb */
#define W3D_R5G6B5               3      	/* rrrrr gggggg bbbbb */
#define W3D_R8G8B8               4      	/* rrrrrrrr gggggggg bbbbbbbb */
#define W3D_A4R4G4B4             5      	/* aaaa rrrr gggg bbbb */
#define W3D_A8R8G8B8             6      	/* aaaaaaaa rrrrrrrr gggggggg bbbbbbbb */
#define W3D_A8                   7      	/* aaaaaaaa */
#define W3D_L8                   8      	/* llllllll */
#define W3D_L8A8                 9      	/* llllllll aaaaaaaa */
#define W3D_I8                  10      	/* iiiiiiii */
#define W3D_R8G8B8A8            11      	/* rrrrrrrr gggggggg bbbbbbbb aaaaaaaa */

/* return values of W3D_GetTexFmtInfo (bitmask) */
#define W3D_TEXFMT_SUPPORTED     (1<<0) 	/* format is supported, although it may be converted */
#define W3D_TEXFMT_FAST          (1<<16) 	/* format directly supported by 3D HW */
#define W3D_TEXFMT_CLUTFAST      (1<<17) 	/* format is directly supported on LUT8 screens */
#define W3D_TEXFMT_ARGBFAST      (1<<18) 	/* format is directly supported on 16/24 bit screens */
#define W3D_TEXFMT_UNSUPPORTED   (1<<1) 	/* this format is unsupported, and can't be simulated */

/* bitmap format flags used by CPU drivers */
#define W3D_FMT_CLUT             (1<<0) 	/* chunky */
#define W3D_FMT_R5G5B5           (1<<1) 	/* 0 rrrrr ggggg bbbbb */
#define W3D_FMT_B5G5R5           (1<<2) 	/* 0 bbbbb ggggg rrrrr */
#define W3D_FMT_R5G5B5PC         (1<<3) 	/* ggg bbbbb 0 rrrrr gg */
#define W3D_FMT_B5G5R5PC         (1<<4) 	/* ggg rrrrr 0 bbbbb gg */
#define W3D_FMT_R5G6B5           (1<<5) 	/* rrrrr gggggg bbbbb */
#define W3D_FMT_B5G6R5           (1<<6) 	/* bbbbb gggggg rrrrr */
#define W3D_FMT_R5G6B5PC         (1<<7) 	/* ggg bbbbb rrrrr ggg */
#define W3D_FMT_B5G6R5PC         (1<<8) 	/* ggg rrrrr bbbbb ggg */
#define W3D_FMT_R8G8B8           (1<<9) 	/* rrrrrrrr gggggggg bbbbbbbb */
#define W3D_FMT_B8G8R8           (1<<10)        	/* bbbbbbbb gggggggg rrrrrrrr */
#define W3D_FMT_A8R8G8B8         (1<<11)        	/* aaaaaaaa rrrrrrrr gggggggg bbbbbbbb */
#define W3D_FMT_A8B8G8R8         (1<<12)        	/* aaaaaaaa bbbbbbbb gggggggg rrrrrrrr */
#define W3D_FMT_R8G8B8A8         (1<<13)        	/* rrrrrrrr gggggggg bbbbbbbb aaaaaaaa */
#define W3D_FMT_B8G8R8A8         (1<<14)        	/* bbbbbbbb gggggggg rrrrrrrr aaaaaaaa */

/* possible mode values for W3D_SetState/W3D_GetState and for 'state' in the
   context structure */
#define W3D_AUTOTEXMANAGEMENT    (1<<1) 	/* automatic texture management */
#define W3D_SYNCHRON             (1<<2) 	/* wait, until HW is idle */
#define W3D_INDIRECT             (1<<3) 	/* drawing is queued until flushed */
#define W3D_GLOBALTEXENV         (1<<4) 	/* SetTexEnv is global */
#define W3D_DOUBLEHEIGHT         (1<<5) 	/* Drawing area is double height */
#define W3D_FAST                 (1<<6) 	/* Allow Warp3D to modify passed Triangles/Points/Lines */
#define W3D_AUTOCLIP             (1<<7) 	/* clip to screen region */
#define W3D_TEXMAPPING           (1<<8) 	/* texmapping state */
#define W3D_PERSPECTIVE          (1<<9) 	/* perspective correction state */
#define W3D_GOURAUD              (1<<10)  /* gouraud/flat shading */
#define W3D_ZBUFFER              (1<<11)  /* Z-Buffer state */
#define W3D_ZBUFFERUPDATE        (1<<12)  /* Z-Buffer update state */
#define W3D_BLENDING             (1<<13)  /* Alpha blending state */
#define W3D_FOGGING              (1<<14)  /* Fogging state */
#define W3D_ANTI_POINT           (1<<15)  /* Point antialiasing state */
#define W3D_ANTI_LINE            (1<<16)  /* Line antialiasing state */
#define W3D_ANTI_POLYGON         (1<<17)  /* Polygon antialiasing state */
#define W3D_ANTI_FULLSCREEN      (1<<18)  /* Fullscreen antialiasing state */
#define W3D_DITHERING            (1<<19)  /* dithering state */
#define W3D_LOGICOP              (1<<20)  /* logic operations */
#define W3D_STENCILBUFFER        (1<<21)  /* stencil buffer/stencil test */
#define W3D_ALPHATEST            (1<<22)  /* alpha test */
#define W3D_SPECULAR             (1<<23)  /* Specular lighting */
#define W3D_TEXMAPPING3D         (1<<24)  /* 3d textures */
#define W3D_SCISSOR              (1<<25)  /* Scissor test enable */
#define W3D_CHROMATEST           (1<<26)  /* Chroma test enable */
#define W3D_CULLFACE             (1<<27)  /* Backface culling enable */

/* action/result values for W3D_SetState/W3D_GetState */
#define W3D_ENABLE               1      	/* enable mode */
#define W3D_ENABLED              1      	/* mode is enabled */
#define W3D_DISABLE              2      	/* disable mode */
#define W3D_DISABLED             2      	/* mode is disabled */

/* mode parameters for W3D_Query */
#define W3D_Q_DRAW_POINT         1      	/* point drawing */
#define W3D_Q_DRAW_LINE          2      	/* line drawing */
#define W3D_Q_DRAW_TRIANGLE      3      	/* triangle drawing */
#define W3D_Q_DRAW_POINT_X       4      	/* points with size != 1 supported */
#define W3D_Q_DRAW_LINE_X        5      	/* lines with width != 1 supported */
#define W3D_Q_DRAW_LINE_ST       6      	/* line stippling supported */
#define W3D_Q_DRAW_POLY_ST       7      	/* polygon stippling supported */
#define W3D_Q_DRAW_POINT_FX      8      	/* point drawing supports special fx */
#define W3D_Q_DRAW_LINE_FX       9      	/* line drawing supports speical fx */

/* Note: more of these below */
#define W3D_Q_TEXMAPPING         11     	/* texmapping in general */
#define W3D_Q_MIPMAPPING         12     	/* mipmapping */
#define W3D_Q_BILINEARFILTER     13     	/* bilinear filter */
#define W3D_Q_MMFILTER           14     	/* mipmap filter */
#define W3D_Q_LINEAR_REPEAT      15     	/* W3D_REPEAT for linear texmapping */
#define W3D_Q_LINEAR_CLAMP       16     	/* W3D_CLAMP for linear texmapping */
#define W3D_Q_PERSPECTIVE        17     	/* perspective correction */
#define W3D_Q_PERSP_REPEAT       18     	/* W3D_REPEAT for persp. texmapping */
#define W3D_Q_PERSP_CLAMP        19     	/* W3D_CLAMP for persp. texmapping */
#define W3D_Q_ENV_REPLACE        20     	/* texenv REPLACE */
#define W3D_Q_ENV_DECAL          21     	/* texenv DECAL */
#define W3D_Q_ENV_MODULATE       22     	/* texenv MODULATE */
#define W3D_Q_ENV_BLEND          23     	/* texenv BLEND */
#define W3D_Q_WRAP_ASYM          24     	/* texture wrapping asymetric in s and t direction */
#define W3D_Q_SPECULAR           25     	/* Specular hiliting */
#define W3D_Q_BLEND_DECAL_FOG    26     	/* driver supports alpha blending and decal with fog */
#define W3D_Q_TEXMAPPING3D       27     	/* driver supports 3-dimensional (volumetric) textures */
#define W3D_Q_CHROMATEST         28     	/* driver supports chroma test */
#define W3D_Q_FLATSHADING        31     	/* flat shading */
#define W3D_Q_GOURAUDSHADING     32     	/* gouraud shading */
#define W3D_Q_ZBUFFER            41     	/* Z buffer in general */
#define W3D_Q_ZBUFFERUPDATE      42     	/* Z buffer update */
#define W3D_Q_ZCOMPAREMODES      43     	/* Z buffer compare modes */
#define W3D_Q_ALPHATEST          51     	/* alpha test in general */
#define W3D_Q_ALPHATESTMODES     52     	/* alpha test modes */
#define W3D_Q_BLENDING           61     	/* alpha blending */
#define W3D_Q_SRCFACTORS         62     	/* source factors */
#define W3D_Q_DESTFACTORS        63     	/* destination factors */
#define W3D_Q_ONE_ONE            64     	/* W3D_ONE / W3D_ONE supported */
#define W3D_Q_FOGGING            71     	/* fogging in general */
#define W3D_Q_LINEAR             72     	/* linear fogging */
#define W3D_Q_EXPONENTIAL        73     	/* exponential fogging */
#define W3D_Q_S_EXPONENTIAL      74     	/* square exponential fogging */
#define W3D_Q_INTERPOLATED       75     	/* interpolated fog */
#define W3D_Q_ANTIALIASING       81     	/* antialiasing in general */
#define W3D_Q_ANTI_POINT         82     	/* point antialiasing */
#define W3D_Q_ANTI_LINE          83     	/* line antialiasing */
#define W3D_Q_ANTI_POLYGON       84     	/* polygon antialiasing */
#define W3D_Q_ANTI_FULLSCREEN    85     	/* full screen antialiasing */
#define W3D_Q_DITHERING          91     	/* dithering */
#define W3D_Q_PALETTECONV        92     	/* driver can use per-texture palettes on 8bit screens */
#define W3D_Q_SCISSOR            101    	/* scissor test */
#define W3D_Q_MAXTEXWIDTH        111    	/* max. texture border width */
#define W3D_Q_MAXTEXHEIGHT       112    	/* max. texture border height */
#define W3D_Q_MAXTEXWIDTH_P      113    	/* max. texture border width */
#define W3D_Q_MAXTEXHEIGHT_P     114    	/* max. texture border height */
#define W3D_Q_RECTTEXTURES       115    	/* rectangular texture supported */
#define W3D_Q_LOGICOP            121    	/* logical operation */
#define W3D_Q_MASKING            131    	/* color/index masking */
#define W3D_Q_STENCILBUFFER      141    	/* stencil buffer in general */
#define W3D_Q_STENCIL_MASK       142    	/* mask value */
#define W3D_Q_STENCIL_FUNC       143    	/* stencil functions */
#define W3D_Q_STENCIL_SFAIL      144    	/* stencil operation SFAIL */
#define W3D_Q_STENCIL_DPFAIL     145    	/* stencil operation DPFAIL */
#define W3D_Q_STENCIL_DPPASS     146    	/* stencil operation DPPASS */
#define W3D_Q_STENCIL_WRMASK     147    	/* stencil buffer supports write masking */
#define W3D_Q_DRAW_POINT_TEX     160    	/* point drawing supports textures */
#define W3D_Q_DRAW_LINE_TEX      161    	/* line drawing supports textures */
#define W3D_Q_CULLFACE           162    	/* driver supports backface culling */

/* results of W3D_Query (if a result-set is expected) */
#define W3D_FULLY_SUPPORTED      3      	/* completely supported */
#define W3D_PARTIALLY_SUPPORTED  4      	/* partially supported */
#define W3D_NOT_SUPPORTED        5      	/* not supported */

/* blending modes used for alpha blending (the comment shows for
   which function [source or destination] the mode can be used) */
#define W3D_ZERO                 1      	/* source + dest */
#define W3D_ONE                  2      	/* source + dest */
#define W3D_SRC_COLOR            3      	/* dest only */
#define W3D_DST_COLOR            4      	/* source only */
#define W3D_ONE_MINUS_SRC_COLOR  5      	/* dest only */
#define W3D_ONE_MINUS_DST_COLOR  6      	/* source only */
#define W3D_SRC_ALPHA            7      	/* source + dest */
#define W3D_ONE_MINUS_SRC_ALPHA  8      	/* source + dest */
#define W3D_DST_ALPHA            9      	/* source + dest */
#define W3D_ONE_MINUS_DST_ALPHA  10     	/* source + dest */
#define W3D_SRC_ALPHA_SATURATE   11     	/* source only */
#define W3D_CONSTANT_COLOR					12
#define W3D_ONE_MINUS_CONSTANT_COLOR	13
#define W3D_CONSTANT_ALPHA					14
#define W3D_ONE_MINUS_CONSTANT_ALPHA	15

#define W3D_NEAREST              1      	/* no mipmapping, no filtering */
#define W3D_LINEAR               2      	/* no mipmapping, bilinear filtering */
#define W3D_NEAREST_MIP_NEAREST  3      	/* mipmapping, no filtering */
#define W3D_NEAREST_MIP_LINEAR   4      	/* mipmapping, bilinear filtering */
#define W3D_LINEAR_MIP_NEAREST   5      	/* filtered mipmapping, no filtering */
#define W3D_LINEAR_MIP_LINEAR    6      	/* mipmapping, trilinear filtering */

/* fog modes */
#define W3D_FOG_LINEAR           1      	/* linear fogging */
#define W3D_FOG_EXP              2      	/* exponential fogging */
#define W3D_FOG_EXP_2            3      	/* square exponential fogging */
#define W3D_FOG_INTERPOLATED     4      	/* interpolated fogging */

/* texture environment parameters */
#define W3D_REPLACE              1      	/* unlit texturing */
#define W3D_DECAL                2      	/* RGB: same as W3D_REPLACE RGBA: use alpha to blend texture with primitive (lit-texturing) */
#define W3D_MODULATE             3      	/* lit-texturing by modulation */
#define W3D_BLEND                4      	/* blend with environment color */

/* texture wrapping parameters */
#define W3D_REPEAT               1      	/* texture is repeated */
#define W3D_CLAMP                2      	/* texture is clamped */

/* alpha test compare modes */
#define W3D_A_NEVER              1      	/* discard incoming pixel */
#define W3D_A_LESS               2      	/* draw, if value < refvalue */
#define W3D_A_GEQUAL             3      	/* draw, if value >= refvalue */
#define W3D_A_LEQUAL             4      	/* draw, if value <= refvalue */
#define W3D_A_GREATER            5      	/* draw, if value > refvalue */
#define W3D_A_NOTEQUAL           6      	/* draw, if value != refvalue */
#define W3D_A_EQUAL              7      	/* draw, if value == refvalue */
#define W3D_A_ALWAYS             8      	/* always draw */

/* Z buffer compare modes */
#define W3D_Z_NEVER              1      	/* discard incoming pixel */
#define W3D_Z_LESS               2      	/* draw, if value < Z(Z_Buffer) */
#define W3D_Z_GEQUAL             3      	/* draw, if value >= Z(Z_Buffer) */
#define W3D_Z_LEQUAL             4      	/* draw, if value <= Z(Z_Buffer) */
#define W3D_Z_GREATER            5      	/* draw, if value > Z(Z_Buffer) */
#define W3D_Z_NOTEQUAL           6      	/* draw, if value != Z(Z_Buffer) */
#define W3D_Z_EQUAL              7      	/* draw, if value == Z(Z_Buffer) */
#define W3D_Z_ALWAYS             8      	/* always draw */

/* logical operation modes */
#define W3D_LO_CLEAR             1      	/* dest = 0 */
#define W3D_LO_AND               2      	/* dest = source & dest */
#define W3D_LO_AND_REVERSE       3      	/* dest = source & !dest */
#define W3D_LO_COPY              4      	/* dest = source */
#define W3D_LO_AND_INVERTED      5      	/* dest = !source & dest */
#define W3D_LO_NOOP              6      	/* dest = dest */
#define W3D_LO_XOR               7      	/* dest = source ^ dest */
#define W3D_LO_OR                8      	/* dest = source | dest */
#define W3D_LO_NOR               9      	/* dest = !(source | dest) */
#define W3D_LO_EQUIV             10     	/* dest = !(source ^ dest) */
#define W3D_LO_INVERT            11     	/* dest = !dest */
#define W3D_LO_OR_REVERSE        12     	/* dest = source | !dest */
#define W3D_LO_COPY_INVERTED     13     	/* dest = !source */
#define W3D_LO_OR_INVERTED       14     	/* dest = !source | dest */
#define W3D_LO_NAND              15     	/* dest = !(source & dest) */
#define W3D_LO_SET               16     	/* dest = 1 */

/* stencil test functions */
#define W3D_ST_NEVER             1      	/* don't draw pixel */
#define W3D_ST_ALWAYS            2      	/* draw always */
#define W3D_ST_LESS              3      	/* draw, if refvalue < ST */
#define W3D_ST_LEQUAL            4      	/* draw, if refvalue <= ST */
#define W3D_ST_EQUAL             5      	/* draw, if refvalue == ST */
#define W3D_ST_GEQUAL            6      	/* draw, if refvalue >= ST */
#define W3D_ST_GREATER           7      	/* draw, if refvalue > ST */
#define W3D_ST_NOTEQUAL          8      	/* draw, if refvalue != ST */

/* stencil test operations */
#define W3D_ST_KEEP              1      	/* keep stencil buffer value */
#define W3D_ST_ZERO              2      	/* clear stencil buffer value */
#define W3D_ST_REPLACE           3      	/* replace by reference value */
#define W3D_ST_INCR              4      	/* increment */
#define W3D_ST_DECR              5      	/* decrement */
#define W3D_ST_INVERT            6      	/* invert bitwise */

/* chroma test modes */
#define W3D_CHROMATEST_NONE       1     	/* No chroma test */
#define W3D_CHROMATEST_INCLUSIVE  2     	/* texels in the range pass the test */
#define W3D_CHROMATEST_EXCLUSIVE  3     	/* texels in the range are rejected */

/* error/status values */
#define W3D_SUCCESS               0     	/* success */
#define W3D_BUSY                 -1     	/* graphics hardware is busy */
#define W3D_ILLEGALINPUT         -2     	/* failure, illegal input */
#define W3D_NOMEMORY             -3     	/* no memory available */
#define W3D_NODRIVER             -4     	/* no hardware driver available */
#define W3D_NOTEXTURE            -5     	/* texture is missing */
#define W3D_TEXNOTRESIDENT       -6     	/* texture not resident */
#define W3D_NOMIPMAPS            -7     	/* mipmaps are not supported by this texture object */
#define W3D_NOGFXMEM             -8     	/* no graphics memory available */
#define W3D_NOTVISIBLE           -9     	/* drawing area not visible/ bitmap swapped out */
#define W3D_UNSUPPORTEDFILTER    -10    	/* unsupported filter */
#define W3D_UNSUPPORTEDTEXENV    -11    	/* unsupported filter */
#define W3D_UNSUPPORTEDWRAPMODE  -12    	/* unsupported wrap mode */
#define W3D_UNSUPPORTEDZCMP      -13    	/* unsupported Z compare mode */
#define W3D_UNSUPPORTEDATEST     -14    	/* unsupported alpha test */
#define W3D_UNSUPPORTEDBLEND     -15    	/* unsupported blending function */
#define W3D_UNSUPPORTEDFOG       -16    	/* unsupported fog mode */
#define W3D_UNSUPPORTEDSTATE     -17    	/* can't enable/disable state */
#define W3D_UNSUPPORTEDFMT       -18    	/* unsupported bitmap format */
#define W3D_UNSUPPORTEDTEXSIZE   -19    	/* unsupported texture border size */
#define W3D_UNSUPPORTEDLOGICOP   -20    	/* unsupported logical operation */
#define W3D_UNSUPPORTEDSTTEST    -21    	/* unsupported stencil test */
#define W3D_ILLEGALBITMAP        -22    	/* illegal bitmap */
#define W3D_NOZBUFFER            -23    	/* Z buffer is missing/unavailable */
#define W3D_NOPALETTE            -24    	/* Palette missing for chunky textures */
#define W3D_MASKNOTSUPPORTED     -25    	/* color/index masking not supported */
#define W3D_NOSTENCILBUFFER      -26    	/* Stencil buffer is missing/unavailable */
#define W3D_QUEUEFAILED          -27    	/* The request can not be queued */
#define W3D_UNSUPPORTEDTEXFMT    -28    	/* Texformat unsupported */
#define W3D_WARNING              -29    	/* Parital success */
#define W3D_UNSUPPORTED            -30  	/* Requested feature is unsupported */

/* Hints */
#define W3D_H_TEXMAPPING         1      	/* Quality of general texture mapping */
#define W3D_H_MIPMAPPING         2      	/* Quality of mipmapping */
#define W3D_H_BILINEARFILTER     3      	/* Quality of bilinear filtering */
#define W3D_H_MMFILTER           4      	/* Quality of depth filter */
#define W3D_H_PERSPECTIVE        5      	/* Quality of perspective correction */
#define W3D_H_BLENDING           6      	/* Quality of alpha blending */
#define W3D_H_FOGGING            7      	/* Quality of fogging */
#define W3D_H_ANTIALIASING       8      	/* Quality of antialiasing */
#define W3D_H_DITHERING          9      	/* Quality of dithering */
#define W3D_H_ZBUFFER           10      	/* Quality of zbuffering */
#define W3D_H_POINTDRAW         11			/* Quality parameters */

#define W3D_H_FAST               1      	/* Low quality, fast rendering */
#define W3D_H_AVERAGE            2      	/* Medium quality and speed */
#define W3D_H_NICE               3      	/* Best quality, low speed */

/* ScreenMode Requester TagItems */
#define W3D_SMR_TAGS         (TAG_USER+$202000)
#define W3D_SMR_DRIVER       (W3D_SMR_TAGS+0)   	/* Driver to filter */
#define W3D_SMR_DESTFMT      (W3D_SMR_TAGS+1)   	/* Dest Format to filter */
#define W3D_SMR_TYPE         (W3D_SMR_TAGS+2)   	/* Type to filter */
#define W3D_SMR_SIZEFILTER   (W3D_SMR_TAGS+3)   	/* Also filter size */
#define W3D_SMR_MODEMASK     (W3D_SMR_TAGS+4)   	/* AND-Mask for modes */

/* BestModeID tag items */
#define W3D_BMI_TAGS         (TAG_USER+$203000)
#define W3D_BMI_DRIVER       (W3D_BMI_TAGS+0)
#define W3D_BMI_WIDTH        (W3D_BMI_TAGS+1)
#define W3D_BMI_HEIGHT       (W3D_BMI_TAGS+2)
#define W3D_BMI_DEPTH        (W3D_BMI_TAGS+3)

/* Vertex Buffer defines */
CONST	W3D_VERTEX_F_F_F=0,
		W3D_VERTEX_F_F_D=1,
		W3D_VERTEX_D_D_D=2

#define W3D_COLOR_FLOAT      ($01<<30)
#define W3D_COLOR_UBYTE      ($02<<30)

CONST	W3D_CMODE_RGB=1,
		W3D_CMODE_BGR=2,
		W3D_CMODE_RGBA=4,
		W3D_CMODE_ARGB=8,
		W3D_CMODE_BGRA=16

CONST	W3D_PRIMITIVE_TRIANGLES=0,
		W3D_PRIMITIVE_TRIFAN=1,
		W3D_PRIMITIVE_TRISTRIP=2,
		W3D_PRIMITIVE_POINTS=3,
		W3D_PRIMITIVE_LINES=4,
		W3D_PRIMITIVE_LINELOOP=5,
		W3D_PRIMITIVE_LINESTRIP=6

CONST	W3D_INDEX_UBYTE=0,
		W3D_INDEX_UWORD=1,
		W3D_INDEX_ULONG=2

#define W3D_TEXCOORD_NORMALIZED          (1<<0)     	/* Texture coordinates are normalized */
