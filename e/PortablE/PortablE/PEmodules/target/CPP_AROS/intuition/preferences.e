/* $Id: preferences.h 20855 2004-02-10 09:34:48Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/devices/timer'
{#include <intuition/preferences.h>}
NATIVE {INTUITION_PREFERENCES_H} CONST

/* Printer configurations */
NATIVE {FILENAME_SIZE}	CONST FILENAME_SIZE	= 30
NATIVE {DEVNAME_SIZE}	CONST DEVNAME_SIZE	= 16

/* Size of Pointer data buffer */
NATIVE {POINTERSIZE} CONST POINTERSIZE = ((1+16+1)*2)


/* Default font sizes */
/* (Height of default font topaz in 60/80 column mode */
NATIVE {TOPAZ_EIGHTY} CONST TOPAZ_EIGHTY = 8
NATIVE {TOPAZ_SIXTY} CONST TOPAZ_SIXTY = 9

/* NOTE: From V36 on fields of struct Preferences are ignored by SetPrefs().
 * Generally elements are added or replaced as new hard- and software arise.
 * Some fields can only be set by initial SetPrefs() using
 * DEVS:system-configuration. Some data must be truncated so applications
 * calling GetPrefs() modifying parts of the struct References and calling
 * SetPrefs() do not kill data.
 * See GetPrefs() and SetPrefs() for further information.
 */

NATIVE {Preferences} OBJECT preferences
    {FontHeight}	fontheight	:BYTE
    {PrinterPort}	printerport	:UBYTE	/* Printer port connection */
    {BaudRate}	baudrate	:UINT	/* Baud rate for the serial port */

    /* Timing rates */
    {KeyRptSpeed}	keyrptspeed	:timeval /* Repeat speed for keyboard */
    {KeyRptDelay}	keyrptdelay	:timeval /* Delay before keys repeat */
    {DoubleClick}	doubleclick	:timeval /* Interval allowed between clicks */

    /* Intuition Mouse-Pointer data */
    {PointerMatrix}	pointermatrix[POINTERSIZE]	:ARRAY OF UINT	/* Definition of pointer sprite */
    {XOffset}	xoffset	:BYTE			/* X-Offset for hot spot        */
    {YOffset}	yoffset	:BYTE			/* Y-Offset for hot spot        */
    {color17}	color17	:UINT			/* Colors for pointer sprite    */
    {color18}	color18	:UINT			/*   "     "     "      "       */
    {color19}	color19	:UINT			/*   "     "     "      "       */
    {PointerTicks}	pointerticks	:UINT			/* Sensitivity of the pointer   */

    /* Standard 4 Workbench-Screen colors */
    {color0}	color0	:UINT
    {color1}	color1	:UINT
    {color2}	color2	:UINT
    {color3}	color3	:UINT

    /* Positioning data for the Intuition View */
    {ViewXOffset}	viewxoffset	:BYTE /* Offset for top-left corner */
    {ViewYOffset}	viewyoffset	:BYTE
    {ViewInitX}	viewinitx	:INT   /* Initial offset values of View */
    {ViewInitY}	viewinity	:INT

    {EnableCLI}	enablecli	:INT /* CLI availability switch */

    /* Printer configurations */
    {PrinterType}	printertype	:UINT			  /* printer type */
    {PrinterFilename}	printerfilename[FILENAME_SIZE]	:ARRAY OF UBYTE /* file for printer */

    /* Print format and quality configurations */
    {PrintPitch}	printpitch	:UINT	    /* Print pitch		      */
    {PrintQuality}	printquality	:UINT	    /* Print quality		      */
    {PrintSpacing}	printspacing	:UINT	    /* Number of lines per inch	      */
    {PrintLeftMargin}	printleftmargin	:UINT  /* Left margin in characters      */
    {PrintRightMargin}	printrightmargin	:UINT /* Right margin in characters     */
    {PrintImage}	printimage	:UINT	    /* Positive or negative	      */
    {PrintAspect}	printaspect	:UINT	    /* Horizontal or vertical	      */
    {PrintShade}	printshade	:UINT	    /* B&W, half-tone, or color	      */
    {PrintThreshold}	printthreshold	:INT   /* Darkness control for b/w dumps */

    /* Print-paper description */
    {PaperSize}	papersize	:UINT	/* Paper size			   */
    {PaperLength}	paperlength	:UINT	/* Paper length in number of lines */
    {PaperType}	papertype	:UINT	/* Continuous or single sheet	   */

    /* Serial device settings:
     * six nibble-fields in three bytes
     */
    {SerRWBits}	serrwbits	:UBYTE	/* Upper nibble = (8-number of read bits)    */
			/* Lower nibble = (8-number of write bits)   */
    {SerStopBuf}	serstopbuf	:UBYTE	/* Upper nibble = (number of stop bits - 1)  */
			/* Lower nibble = (table value for BufSize)  */
    {SerParShk}	serparshk	:UBYTE	/* Upper nibble = (value for Parity setting) */
			/* Lower nibble = (value for Handshake mode) */
    {LaceWB}	lacewb	:UBYTE	/* If workbench is to be interlaced	     */

    {Pad}	pad[12]	:ARRAY OF UBYTE
    {PrtDevName}	prtdevname[DEVNAME_SIZE]	:ARRAY OF UBYTE /* Device used by printer.device
				     * (leave out the ".device")
				     */
    {DefaultPrtUnit}	defaultprtunit	:UBYTE /* Default unit opened by printer.device */
    {DefaultSerUnit}	defaultserunit	:UBYTE /* Default serial unit */

    {RowSizeChange}	rowsizechange	:BYTE    /* Affect NormalDisplayRows/Columns */
    {ColumnSizeChange}	columnsizechange	:BYTE

    {PrintFlags}	printflags	:UINT	  /* User preference flags */
    {PrintMaxWidth}	printmaxwidth	:UINT  /* Max width  of printed picture in 0.1 inch */
    {PrintMaxHeight}	printmaxheight	:UINT /* Max height of printed picture in 0.1 inch */
    {PrintDensity}	printdensity	:UBYTE   /* Print density */
    {PrintXOffset}	printxoffset	:UBYTE   /* Offset of printed picture in 0.1 inch */

    {wb_Width}	wb_width	:UINT  /* Override default Workbench width  */
    {wb_Height}	wb_height	:UINT /* Override default Workbench height */
    {wb_Depth}	wb_depth	:UBYTE  /* Override default Workbench depth  */

    {ext_size}	ext_size	:UBYTE /* Internal value 'extension information'
		     * = extension size in blocks of 64 bytes
		     * DO NOT TOUCH !!!
		     */
ENDOBJECT


/* Workbench Interlace (uses one bit) */
NATIVE {LACEWB}		CONST LACEWB		= $1
NATIVE {LW_RESERVED}	CONST LW_RESERVED	= 1	/* internal use only */

NATIVE {SCREEN_DRAG}	CONST SCREEN_DRAG	= $4000
NATIVE {MOUSE_ACCEL}	CONST MOUSE_ACCEL	= $8000

/* PrinterPort */
NATIVE {PARALLEL_PRINTER} CONST PARALLEL_PRINTER = $00
NATIVE {SERIAL_PRINTER}	 CONST SERIAL_PRINTER	 = $01

/* BaudRates */
NATIVE {BAUD_110}	CONST BAUD_110	= $00
NATIVE {BAUD_300}	CONST BAUD_300	= $01
NATIVE {BAUD_1200}	CONST BAUD_1200	= $02
NATIVE {BAUD_2400}	CONST BAUD_2400	= $03
NATIVE {BAUD_4800}	CONST BAUD_4800	= $04
NATIVE {BAUD_9600}	CONST BAUD_9600	= $05
NATIVE {BAUD_19200}	CONST BAUD_19200	= $06
NATIVE {BAUD_MIDI}	CONST BAUD_MIDI	= $07

/* PaperType */
NATIVE {FANFOLD}		CONST FANFOLD		= $00
NATIVE {SINGLE}		CONST SINGLE		= $80

/* PrintPitch */
NATIVE {PICA}		CONST PICA		= $000
NATIVE {ELITE}		CONST ELITE		= $400
NATIVE {FINE}		CONST FINE		= $800

/* PrintQuality */
NATIVE {DRAFT}		CONST DRAFT		= $000
NATIVE {LETTER}		CONST LETTER		= $100

/* PrintSpacing */
NATIVE {SIX_LPI}		CONST SIX_LPI		= $000
NATIVE {EIGHT_LPI}	CONST EIGHT_LPI	= $200

/* Print Image */
NATIVE {IMAGE_POSITIVE}	CONST IMAGE_POSITIVE	= $00
NATIVE {IMAGE_NEGATIVE}	CONST IMAGE_NEGATIVE	= $01

/* PrintAspect */
NATIVE {ASPECT_HORIZ}	CONST ASPECT_HORIZ	= $00
NATIVE {ASPECT_VERT}	CONST ASPECT_VERT	= $01

/* PrintShade */
NATIVE {SHADE_BW}	CONST SHADE_BW	= $00
NATIVE {SHADE_GREYSCALE}	CONST SHADE_GREYSCALE	= $01
NATIVE {SHADE_COLOR}	CONST SHADE_COLOR	= $02

/* PaperSize (All paper sizes must have a zero in the lowest nibble) */
NATIVE {US_LETTER}	CONST US_LETTER	= $00
NATIVE {US_LEGAL}	CONST US_LEGAL	= $10
NATIVE {N_TRACTOR}	CONST N_TRACTOR	= $20
NATIVE {W_TRACTOR}	CONST W_TRACTOR	= $30
NATIVE {CUSTOM}		CONST CUSTOM		= $40

/* European sizes */
NATIVE {EURO_A0}		CONST EURO_A0		= $50	/* A0: 841 x 1189 */
NATIVE {EURO_A1}		CONST EURO_A1		= $60	/* A1: 594 x 841  */
NATIVE {EURO_A2}		CONST EURO_A2		= $70	/* A2: 420 x 594  */
NATIVE {EURO_A3}		CONST EURO_A3		= $80	/* A3: 297 x 420  */
NATIVE {EURO_A4}		CONST EURO_A4		= $90	/* A4: 210 x 297  */
NATIVE {EURO_A5}		CONST EURO_A5		= $A0	/* A5: 148 x 210  */
NATIVE {EURO_A6}		CONST EURO_A6		= $B0	/* A6: 105 x 148  */
NATIVE {EURO_A7}		CONST EURO_A7		= $C0	/* A7: 74 x 105   */
NATIVE {EURO_A8}		CONST EURO_A8		= $D0	/* A8: 52 x 74    */

/* PrinterType */
NATIVE {CUSTOM_NAME}	CONST CUSTOM_NAME	= $00
NATIVE {ALPHA_P_101}	CONST ALPHA_P_101	= $01
NATIVE {BROTHER_15XL}	CONST BROTHER_15XL	= $02
NATIVE {CBM_MPS1000}	CONST CBM_MPS1000	= $03
NATIVE {DIAB_630}	CONST DIAB_630	= $04
NATIVE {DIAB_ADV_D25}	CONST DIAB_ADV_D25	= $05
NATIVE {DIAB_C_150}	CONST DIAB_C_150	= $06
NATIVE {EPSON}		CONST EPSON		= $07
NATIVE {EPSON_JX_80}	CONST EPSON_JX_80	= $08
NATIVE {OKIMATE_20}	CONST OKIMATE_20	= $09
NATIVE {QUME_LP_20}	CONST QUME_LP_20	= $0A
NATIVE {HP_LASERJET}	 CONST HP_LASERJET	 = $0B
NATIVE {HP_LASERJET_PLUS} CONST HP_LASERJET_PLUS = $0C

/* Serial Input Buffer Sizes */
NATIVE {SBUF_512}	CONST SBUF_512	= $00
NATIVE {SBUF_1024}	CONST SBUF_1024	= $01
NATIVE {SBUF_2048}	CONST SBUF_2048	= $02
NATIVE {SBUF_4096}	CONST SBUF_4096	= $03
NATIVE {SBUF_8000}	CONST SBUF_8000	= $04
NATIVE {SBUF_16000}	CONST SBUF_16000	= $05

/* Serial Bit Masks */
NATIVE {SREAD_BITS}	CONST SREAD_BITS	= $F0 /* SerRWBits */
NATIVE {SWRITE_BITS}	CONST SWRITE_BITS	= $0F

NATIVE {SSTOP_BITS}	CONST SSTOP_BITS	= $F0 /* SerStopBuf */
NATIVE {SBUFSIZE_BITS}	CONST SBUFSIZE_BITS	= $0F

NATIVE {SPARITY_BITS}	CONST SPARITY_BITS	= $F0 /* SerParShk */
NATIVE {SHSHAKE_BITS}	CONST SHSHAKE_BITS	= $0F

/* Serial Parity
 * (upper nibble, after being shifted by macro SPARNUM() )
 */
NATIVE {SPARITY_NONE}	CONST SPARITY_NONE	= 0
NATIVE {SPARITY_EVEN}	CONST SPARITY_EVEN	= 1
NATIVE {SPARITY_ODD}	CONST SPARITY_ODD	= 2
NATIVE {SPARITY_MARK}	CONST SPARITY_MARK	= 3
NATIVE {SPARITY_SPACE}	CONST SPARITY_SPACE	= 4

/* Serial Handshake Mode
 * (lower nibble, after masking using macro SHANKNUM() )
 */
NATIVE {SHSHAKE_XON}	CONST SHSHAKE_XON	= 0
NATIVE {SHSHAKE_RTS}	CONST SHSHAKE_RTS	= 1
NATIVE {SHSHAKE_NONE}	CONST SHSHAKE_NONE	= 2


/* New defines for PrintFlags */

NATIVE {CORRECT_RED}	    CONST CORRECT_RED	    = $0001 /* Color correct red shades */
NATIVE {CORRECT_GREEN}	    CONST CORRECT_GREEN	    = $0002 /* Color correct green shades */
NATIVE {CORRECT_BLUE}	    CONST CORRECT_BLUE	    = $0004 /* Color correct blue shades */

NATIVE {CENTER_IMAGE}	    CONST CENTER_IMAGE	    = $0008 /* Center image on paper */

NATIVE {IGNORE_DIMENSIONS}   CONST IGNORE_DIMENSIONS   = $0000 /* Ignore max width/height settings */
NATIVE {BOUNDED_DIMENSIONS}  CONST BOUNDED_DIMENSIONS  = $0010 /* Use max width/height as boundaries */
NATIVE {ABSOLUTE_DIMENSIONS} CONST ABSOLUTE_DIMENSIONS = $0020 /* Use max width/height as absolutes */
NATIVE {PIXEL_DIMENSIONS}    CONST PIXEL_DIMENSIONS    = $0040 /* Use max width/height as printer pixels */
NATIVE {MULTIPLY_DIMENSIONS} CONST MULTIPLY_DIMENSIONS = $0080 /* Use max width/height as multipliers */

NATIVE {INTEGER_SCALING}     CONST INTEGER_SCALING     = $0100 /* Force integer scaling */

NATIVE {ORDERED_DITHERING}   CONST ORDERED_DITHERING   = $0000 /* Ordered dithering */
NATIVE {HALFTONE_DITHERING}  CONST HALFTONE_DITHERING  = $0200 /* Halftone dithering */
NATIVE {FLOYD_DITHERING}     CONST FLOYD_DITHERING     = $0400 /* Floyd-Steinberg dithering */

NATIVE {ANTI_ALIAS}	    CONST ANTI_ALIAS	    = $0800 /* Anti-alias image */
NATIVE {GREY_SCALE2}	    CONST GREY_SCALE2	    = $1000 /* For use with HI-Res monitor */

/* masks used for checking bits */
NATIVE {CORRECT_RGB_MASK}    CONST CORRECT_RGB_MASK    = (CORRECT_RED OR CORRECT_GREEN OR CORRECT_BLUE)
NATIVE {DIMENSIONS_MASK}	    CONST DIMENSIONS_MASK	    = (BOUNDED_DIMENSIONS OR ABSOLUTE_DIMENSIONS OR PIXEL_DIMENSIONS OR MULTIPLY_DIMENSIONS)
NATIVE {DITHERING_MASK}	    CONST DITHERING_MASK	    = (HALFTONE_DITHERING OR FLOYD_DITHERING)
