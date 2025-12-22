/* $VER: preferences.h 38.2 (16.9.1992) */
OPT NATIVE
MODULE 'target/exec/types', 'target/devices/timer'
{MODULE 'intuition/preferences'}

/* ======================================================================== */
/* === Preferences ======================================================== */
/* ======================================================================== */

/* these are the definitions for the printer configurations */
NATIVE {FILENAME_SIZE}	CONST FILENAME_SIZE	= 30	/* Filename size */
NATIVE {DEVNAME_SIZE}	CONST DEVNAME_SIZE	= 16	/* Device-name size */

NATIVE {POINTERSIZE} CONST POINTERSIZE = (1 + 16 + 1) * 2	/* Size of Pointer data buffer */

NATIVE {TOPAZ_EIGHTY} CONST TOPAZ_EIGHTY = 8
NATIVE {TOPAZ_SIXTY} CONST TOPAZ_SIXTY = 9

NATIVE {preferences} OBJECT preferences
    /* the default font height */
    {fontheight}	fontheight	:BYTE			/* height for system default font  */

    /* constant describing what's hooked up to the port */
    {printerport}	printerport	:UBYTE			/* printer port connection	   */

    /* the baud rate of the port */
    {baudrate}	baudrate	:UINT			/* baud rate for the serial port   */

    /* various timing rates */
    {keyrptspeed}	keyrptspeed	:timeval		/* repeat speed for keyboard	   */
    {keyrptdelay}	keyrptdelay	:timeval		/* Delay before keys repeat	   */
    {doubleclick}	doubleclick	:timeval		/* Interval allowed between clicks */

    /* Intuition Pointer data */
    {pointermatrix}	pointermatrix[POINTERSIZE]	:ARRAY OF UINT	/* Definition of pointer sprite    */
    {xoffset}	xoffset	:BYTE			/* X-Offset for active 'bit'	   */
    {yoffset}	yoffset	:BYTE			/* Y-Offset for active 'bit'	   */
    {color17}	color17	:UINT			/***********************************/
    {color18}	color18	:UINT			/* Colours for sprite pointer	   */
    {color19}	color19	:UINT			/***********************************/
    {pointerticks}	pointerticks	:UINT			/* Sensitivity of the pointer	   */

    /* Workbench Screen colors */
    {color0}	color0	:UINT			/***********************************/
    {color1}	color1	:UINT			/*  Standard default colours	   */
    {color2}	color2	:UINT			/*   Used in the Workbench	   */
    {color3}	color3	:UINT			/***********************************/

    /* positioning data for the Intuition View */
    {viewxoffset}	viewxoffset	:BYTE			/* Offset for top lefthand corner  */
    {viewyoffset}	viewyoffset	:BYTE			/* X and Y dimensions		   */
    {viewinitx}	viewinitx	:INT
	{viewinity}	viewinity	:INT		/* View initial offset values	   */

    {enablecli}	enablecli	:INT			/* CLI availability switch */

    /* printer configurations */
    {printertype}	printertype	:UINT			/* printer type		   */
    {printerfilename}	printerfilename[FILENAME_SIZE]	:ARRAY OF UBYTE/* file for printer	   */

    /* print format and quality configurations */
    {printpitch}	printpitch	:UINT			/* print pitch			   */
    {printquality}	printquality	:UINT			/* print quality		   */
    {printspacing}	printspacing	:UINT			/* number of lines per inch	   */
    {printleftmargin}	printleftmargin	:UINT		/* left margin in characters	   */
    {printrightmargin}	printrightmargin	:UINT		/* right margin in characters	   */
    {printimage}	printimage	:UINT			/* positive or negative		   */
    {printaspect}	printaspect	:UINT			/* horizontal or vertical	   */
    {printshade}	printshade	:UINT			/* b&w, half-tone, or color	   */
    {printthreshold}	printthreshold	:INT		/* darkness ctrl for b/w dumps	   */

    /* print paper descriptors */
    {papersize}	papersize	:UINT			/* paper size			   */
    {paperlength}	paperlength	:UINT			/* paper length in number of lines */
    {papertype}	papertype	:UINT			/* continuous or single sheet	   */

    /* Serial device settings: These are six nibble-fields in three bytes */
    {serrwbits}	serrwbits	:UBYTE	 /* upper nibble = (8-number of read bits)	*/
			 /* lower nibble = (8-number of write bits)	*/
    {serstopbuf}	serstopbuf	:UBYTE  /* upper nibble = (number of stop bits - 1)	*/
			 /* lower nibble = (table value for BufSize)	*/
    {serparshk}	serparshk	:UBYTE	 /* upper nibble = (value for Parity setting)	*/
			 /* lower nibble = (value for Handshake mode)	*/
    {lacewb}	lacewb	:UBYTE	 /* if workbench is to be interlaced		*/

    {pad}	pad[12 ]	:ARRAY OF UBYTE
    {prtdevname}	prtdevname[DEVNAME_SIZE]	:ARRAY OF UBYTE	/* device used by printer.device
					 * (omit the ".device")
					 */
    {defaultprtunit}	defaultprtunit	:UBYTE	/* default unit opened by printer.device */
    {defaultserunit}	defaultserunit	:UBYTE	/* default serial unit */

    {rowsizechange}	rowsizechange	:BYTE	/* affect NormalDisplayRows/Columns	*/
    {columnsizechange}	columnsizechange	:BYTE

    {printflags}	printflags	:UINT	/* user preference flags */
    {printmaxwidth}	printmaxwidth	:UINT	/* max width of printed picture in 10ths/in */
    {printmaxheight}	printmaxheight	:UINT	/* max height of printed picture in 10ths/in */
    {printdensity}	printdensity	:UBYTE	/* print density */
    {printxoffset}	printxoffset	:UBYTE	/* offset of printed picture in 10ths/inch */

    {wb_width}	wb_width	:UINT		/* override default workbench width  */
    {wb_height}	wb_height	:UINT		/* override default workbench height */
    {wb_depth}	wb_depth	:UBYTE		/* override default workbench depth  */

    {ext_size}	ext_size	:UBYTE		/* extension information -- do not touch! */
			    /* extension size in blocks of 64 bytes */
ENDOBJECT


/* Workbench Interlace (use one bit) */
NATIVE {LACEWB}			CONST LACEWB			= $1
NATIVE {LW_RESERVED}	CONST LW_RESERVED	= 1		/* internal use only */

/* Enable_CLI	*/
NATIVE {SCREEN_DRAG}	CONST SCREEN_DRAG	= $4000
NATIVE {MOUSE_ACCEL}	CONST MOUSE_ACCEL	= $8000

/* PrinterPort */
NATIVE {PARALLEL_PRINTER} CONST PARALLEL_PRINTER = $00
NATIVE {SERIAL_PRINTER}	CONST SERIAL_PRINTER	= $01

/* BaudRate */
NATIVE {BAUD_110}	CONST BAUD_110	= $00
NATIVE {BAUD_300}	CONST BAUD_300	= $01
NATIVE {BAUD_1200}	CONST BAUD_1200	= $02
NATIVE {BAUD_2400}	CONST BAUD_2400	= $03
NATIVE {BAUD_4800}	CONST BAUD_4800	= $04
NATIVE {BAUD_9600}	CONST BAUD_9600	= $05
NATIVE {BAUD_19200}	CONST BAUD_19200	= $06
NATIVE {BAUD_MIDI}	CONST BAUD_MIDI	= $07

/* PaperType */
NATIVE {FANFOLD}	CONST FANFOLD	= $00
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

/* PaperSize (all paper sizes have a zero in the lowest nybble) */
NATIVE {US_LETTER}	CONST US_LETTER	= $00
NATIVE {US_LEGAL}	CONST US_LEGAL	= $10
NATIVE {N_TRACTOR}	CONST N_TRACTOR	= $20
NATIVE {W_TRACTOR}	CONST W_TRACTOR	= $30
NATIVE {CUSTOM}		CONST CUSTOM		= $40

/* New PaperSizes for V36: */
NATIVE {EURO_A0}	CONST EURO_A0	= $50		/* European size A0: 841 x 1189 */
NATIVE {EURO_A1}	CONST EURO_A1	= $60		/* European size A1: 594 x 841 */
NATIVE {EURO_A2}	CONST EURO_A2	= $70		/* European size A2: 420 x 594 */
NATIVE {EURO_A3}	CONST EURO_A3	= $80		/* European size A3: 297 x 420 */
NATIVE {EURO_A4}	CONST EURO_A4	= $90		/* European size A4: 210 x 297 */
NATIVE {EURO_A5}	CONST EURO_A5	= $A0		/* European size A5: 148 x 210 */
NATIVE {EURO_A6}	CONST EURO_A6	= $B0		/* European size A6: 105 x 148 */
NATIVE {EURO_A7}	CONST EURO_A7	= $C0		/* European size A7: 74 x 105 */
NATIVE {EURO_A8}	CONST EURO_A8	= $D0		/* European size A8: 52 x 74 */


/* PrinterType */
NATIVE {CUSTOM_NAME}		CONST CUSTOM_NAME		= $00
NATIVE {ALPHA_P_101}		CONST ALPHA_P_101		= $01
NATIVE {BROTHER_15XL}		CONST BROTHER_15XL		= $02
NATIVE {CBM_MPS1000}		CONST CBM_MPS1000		= $03
NATIVE {DIAB_630}		CONST DIAB_630		= $04
NATIVE {DIAB_ADV_D25}		CONST DIAB_ADV_D25		= $05
NATIVE {DIAB_C_150}		CONST DIAB_C_150		= $06
NATIVE {EPSON}			CONST EPSON			= $07
NATIVE {EPSON_JX_80}		CONST EPSON_JX_80		= $08
NATIVE {OKIMATE_20}		CONST OKIMATE_20		= $09
NATIVE {QUME_LP_20}		CONST QUME_LP_20		= $0A
/* new printer entries, 3 October 1985 */
NATIVE {HP_LASERJET}		CONST HP_LASERJET		= $0B
NATIVE {HP_LASERJET_PLUS}	CONST HP_LASERJET_PLUS	= $0C

/* Serial Input Buffer Sizes */
NATIVE {SBUF_512}	CONST SBUF_512	= $00
NATIVE {SBUF_1024}	CONST SBUF_1024	= $01
NATIVE {SBUF_2048}	CONST SBUF_2048	= $02
NATIVE {SBUF_4096}	CONST SBUF_4096	= $03
NATIVE {SBUF_8000}	CONST SBUF_8000	= $04
NATIVE {SBUF_16000}	CONST SBUF_16000	= $05

/* Serial Bit Masks */
NATIVE {SREAD_BITS}	CONST SREAD_BITS	= $F0 /* for SerRWBits	*/
NATIVE {SWRITE_BITS}	CONST SWRITE_BITS	= $0F

NATIVE {SSTOP_BITS}	CONST SSTOP_BITS	= $F0 /* for SerStopBuf	*/
NATIVE {SBUFSIZE_BITS}	CONST SBUFSIZE_BITS	= $0F

NATIVE {SPARITY_BITS}	CONST SPARITY_BITS	= $F0 /* for SerParShk	*/
NATIVE {SHSHAKE_BITS}	CONST SHSHAKE_BITS	= $0F

NATIVE {SPARITY_NONE}	 CONST SPARITY_NONE	 = 0
NATIVE {SPARITY_EVEN}	 CONST SPARITY_EVEN	 = 1
NATIVE {SPARITY_ODD}	 CONST SPARITY_ODD	 = 2
/* New parity definitions for V36: */
NATIVE {SPARITY_MARK}	 CONST SPARITY_MARK	 = 3
NATIVE {SPARITY_SPACE}	 CONST SPARITY_SPACE	 = 4

NATIVE {SHSHAKE_XON}	 CONST SHSHAKE_XON	 = 0
NATIVE {SHSHAKE_RTS}	 CONST SHSHAKE_RTS	 = 1
NATIVE {SHSHAKE_NONE}	 CONST SHSHAKE_NONE	 = 2

/* new defines for PrintFlags */

NATIVE {CORRECT_RED}	    CONST CORRECT_RED	    = $0001  /* color correct red shades */
NATIVE {CORRECT_GREEN}	    CONST CORRECT_GREEN	    = $0002  /* color correct green shades */
NATIVE {CORRECT_BLUE}	    CONST CORRECT_BLUE	    = $0004  /* color correct blue shades */

NATIVE {CENTER_IMAGE}	    CONST CENTER_IMAGE	    = $0008  /* center image on paper */

NATIVE {IGNORE_DIMENSIONS}   CONST IGNORE_DIMENSIONS   = $0000 /* ignore max width/height settings */
NATIVE {BOUNDED_DIMENSIONS}  CONST BOUNDED_DIMENSIONS  = $0010  /* use max width/height as boundaries */
NATIVE {ABSOLUTE_DIMENSIONS} CONST ABSOLUTE_DIMENSIONS = $0020  /* use max width/height as absolutes */
NATIVE {PIXEL_DIMENSIONS}    CONST PIXEL_DIMENSIONS    = $0040  /* use max width/height as prt pixels */
NATIVE {MULTIPLY_DIMENSIONS} CONST MULTIPLY_DIMENSIONS = $0080 /* use max width/height as multipliers */

NATIVE {INTEGER_SCALING}     CONST INTEGER_SCALING     = $0100  /* force integer scaling */

NATIVE {ORDERED_DITHERING}   CONST ORDERED_DITHERING   = $0000 /* ordered dithering */
NATIVE {HALFTONE_DITHERING}  CONST HALFTONE_DITHERING  = $0200  /* halftone dithering */
NATIVE {FLOYD_DITHERING}     CONST FLOYD_DITHERING     = $0400 /* Floyd-Steinberg dithering */

NATIVE {ANTI_ALIAS}	    CONST ANTI_ALIAS	    = $0800 /* anti-alias image */
NATIVE {GREY_SCALE2}	    CONST GREY_SCALE2	    = $1000 /* for use with hi-res monitor */

/* masks used for checking bits */

NATIVE {CORRECT_RGB_MASK}    CONST CORRECT_RGB_MASK    = (CORRECT_RED OR CORRECT_GREEN OR CORRECT_BLUE)
NATIVE {DIMENSIONS_MASK}     CONST DIMENSIONS_MASK     = (BOUNDED_DIMENSIONS OR ABSOLUTE_DIMENSIONS OR PIXEL_DIMENSIONS OR MULTIPLY_DIMENSIONS)
NATIVE {DITHERING_MASK}	    CONST DITHERING_MASK	    = (HALFTONE_DITHERING OR FLOYD_DITHERING)
