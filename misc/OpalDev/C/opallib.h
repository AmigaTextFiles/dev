
/* opal.library C header file
 */


#ifndef	OPALLIB_H
#define	OPALLIB_H

#ifndef	EXEC_TYPES_H
#include "exec/types.h"
#endif

#ifndef LIBRARIES_DOS_H
#include "libraries/dos.h"
#endif

#define MAXCOPROINS	290	/* Number of CoPro instructions		*/

	/* Screen flags */

#define HIRES24		0x1L	/* High resolution screen.		*/
#define ILACE24		0x2L	/* Interlaced screen.			*/
#define OVERSCAN24	0x4L	/* Overscan screen.			*/
#define NTSC24		0x8L	/* NTSC Screen - Not user definable	*/
#define CLOSEABLE24	0x10L	/* Screen is closeable.			*/
#define PLANES8		0x20L	/* Screen has 8 bitplanes.		*/
#define PLANES15	0x40L	/* Screen has 15 bitplanes.		*/
#define CONTROLONLY24	0x2000L	/* Used for updating control bits only	*/
#define PALMAP24	0x4000L	/* Screen is in palette mapped mode	*/
#define INCHIP24	0x8000L	/* In chip ram - Not user definable	*/

#define FLAGSMASK24  (CONTROLONLY24|PALMAP24|CLOSEABLE24|PLANES8|PLANES15|\
				OVERSCAN24|ILACE24|HIRES24)

	/* LoadIFF24 Flags */

#define FORCE24		1  /* Force conversion of palette mapped to 24 bit */ 
#define KEEPRES24	2  /* Keep the current screen resolution	*/
#define LOADMASK24	4  /* Load mask plane if it exists		*/
#define VIRTUALSCREEN24	8  /* Load complete image into fast ram		*/


	/* SaveIFF24 Flags */

#define OVFASTFORMAT	1	/* Save as opalvision fast format	*/
#define NOTHUMBNAIL	4	/* Inhibit thumbnail chunk		*/
#define SAVEMASK24	8	/* Save MaskPlane with image		*/

	/* Config Flags */

#define OVCF_OPALVISION	0x1	/* Display board is an OpalVision	*/
#define OVCF_COLORBURST	0x2	/* Display board is a ColorBurst	*/

	/* Coprocessor bits. */

#define VIDMODE0	0x01	/* Video control bit 1 (S0)		*/
#define VIDMODE1	0x02	/* Video control bit 1 (S1)		*/
#define DISPLAYBANK2	0x04	/* Select display bank 2		*/
#define HIRESDISP	0x08	/* Enable hi-res display		*/
#define DUALDISPLAY	0x10	/* Select dual display mode (active low)*/
#define OVPRI		0x20	/* Set OpalVision priority		*/
#define PRISTENCIL	0x40	/* Enable priority stencil		*/
#define ADDLOAD		0x80	/* Address load bit. Active low		*/


#define ADDLOAD_B	7
#define PRISTENCIL_B	6
#define OVPRI_B		5
#define DUALDISPLAY_B	4
#define HIRESDISP_B	3
#define DISPLAYBANK2_B	2
#define VIDMODE1_B	1
#define VIDMODE0_B	0


	/* Control line bits */

#define VALID0		0x00001
#define VALID1		0x00002
#define VALID2		0x00004
#define VALID3		0x00008
#define WREN		0x00010
#define COL_COPRO	0x00020
#define AUTO		0x00040
#define DUALPLAYFIELD	0x00080
#define FIELD		0x00100
#define AUTOFIELD	0x00200
#define DISPLAYLATCH	0x00400
#define FRAMEGRAB	0x00800
#define RWR1		0x01000
#define RWR2		0x02000
#define GWR1		0x04000
#define GWR2		0x08000
#define BWR1		0x10000
#define BWR2		0x20000
#define VLSIPROG	0x40000
#define FREEZEFRAME	0x80000

#define VALID0_B	0
#define VALID1_B	1
#define VALID2_B	2
#define VALID3_B	3
#define WREN_B		4
#define COL_COPRO_B	5
#define AUTO_B		6
#define DUALPLAYFIELD_B	7
#define FIELD_B		8
#define AUTOFIELD_B	9
#define DISPLAYLATCH_B	10
#define FRAMEGRAB_B	11
#define RWR1_B		12
#define RWR2_B		13
#define GWR1_B		14
#define GWR2_B		15
#define BWR1_B		16
#define BWR2_B		17
#define VLSIPROG_B	18
#define FREEZEFRAME_B	19

#define NUMCONTROLBITS	20
#define VALIDCODE	5



	/* Some useful macros */

	/* Set pen value */

#define SetPen24(S,R,G,B) {(S)->Pen_R=R; (S)->Pen_G=G; (S)->Pen_B=B;}
#define SetPen15(S,R,G,B) {(S)->Pen_R=(((R)<<2)|(((G)&0x18)>>3));\
				(S)->Pen_G=((B)|((G)<<5));}
#define SetPen8P(S,Col)	  {(S)->Pen_R=Col;}
#define SetPen8(S,R,G,B)  {(S)->Pen_R=(((B)&3)|(((G)&7)<<2)|(((R)&7)<<5));}

	/* Playfield & Priority stencil pens */

#define SetPFPen(S,State) {(S)->Pen_R=State;}
#define SetPRPen(S,State) {(S)->Pen_R=State;}

	/* return current pen value */

#define GetPen24(S,R,G,B) {R=(S)->Pen_R;G=(S)->Pen_G; B=(S)->Pen_B;}
#define GetPen15(S,R,G,B) {R=(S)->Pen_R>>2;\
			  G=((((S)->Pen_R&3)<<3)|(((S)->Pen_G&0xE0)>>5));\
			  B=(S)->Pen_G&0x1F;}
#define GetPen8P(S,Col)	  {Col=(S)->Pen_R;}
#define GetPen8(S,R,G,B)  {R=((S)->Pen_R&0xE0)>>5; G=((S)->Pen_R&0x1C)>>2;\
			  B=(S)->Pen_R&3;}

	/* Get return value from ReadPixel24() */

#define GetCol24(S,R,G,B) {R=(S)->Red;G=(S)->Green; B=(S)->Blue;}
#define GetCol15(S,R,G,B) {R=(S)->Red>>2;\
			  G=((((S)->Red&3)<<3)|(((S)->Green&0xE0)>>5));\
			  B=(S)->Green&0x1F;}
#define GetCol8P(S,Col)	  {Col=(S)->Red;}
#define GetCol8(S,R,G,B)  {R=((S)->Red&0xE0)>>5; G=((S)->Red&0x1C)>>2;\
			  B=(S)->Red&3;}

#define LoadImage24 LoadIFF24

#define DrawCircle24(S,Cx,Cy,r) DrawEllipse24(S,Cx,Cy,r,r);


struct OpalScreen
	{ SHORT		Width;
	  SHORT		Height;
	  SHORT		Depth;
	  SHORT		ClipX1,ClipY1;
	  SHORT		ClipX2,ClipY2;
	  SHORT		BytesPerLine;
	  UWORD 	Flags;
	  SHORT		RelX;
	  SHORT		RelY;
	  struct MsgPort *UserPort;
	  SHORT		MaxFrames;
	  SHORT		VStart;
	  SHORT		CoProOffset;
	  SHORT		LastWait;
	  UWORD		LastCoProIns;
	  UBYTE		*BitPlanes[24];
	  UBYTE		*MaskPlane;
	  ULONG		AddressReg;
	  UBYTE		UpdateDelay;
	  UBYTE		PalLoadAddress;
	  UBYTE		PixelReadMask;
	  UBYTE		CommandReg;
	  UBYTE		Palette[3*256];
	  UBYTE		Pen_R;
	  UBYTE		Pen_G;
	  UBYTE		Pen_B;
	  UBYTE		Red;
	  UBYTE		Green;
	  UBYTE		Blue;
	  UBYTE		CoProData[MAXCOPROINS];
	  SHORT		Modulo;
	  UBYTE		Reserved[38];
#ifdef OPAL_PRIVATE
	  ULONG		CopList_Cycle[12];
	  UBYTE		Update_Cycles;
	  UBYTE		Pad;
#endif
	};


	/* Error return codes */

#define OL_ERR_OUTOFMEM		1
#define OL_ERR_OPENFILE		2
#define OL_ERR_NOTIFF		3
#define OL_ERR_FORMATUNKNOWN	3
#define OL_ERR_NOTILBM		4
#define OL_ERR_FILEREAD		5
#define OL_ERR_FILEWRITE	6
#define OL_ERR_BADIFF		7
#define OL_ERR_CANTCLOSE	8
#define OL_ERR_OPENSCREEN	9
#define OL_ERR_NOTHUMBNAIL	10
#define OL_ERR_BADJPEG		11
#define OL_ERR_UNSUPPORTED	12
#define OL_ERR_CTRLC		13
#define OL_ERR_MAXERR		40



struct OpalScreen *OpenScreen24 (long ScreenModes);
BOOL CloseScreen24 (void);
long WritePixel24 (struct OpalScreen *Scrn, long x, long y);
long ReadPixel24 (struct OpalScreen *Scrn, long x, long y);
void ClearScreen24 (struct OpalScreen *Scrn);
void ILBMtoOV (struct OpalScreen *Scrn, UBYTE *ILBMData, long SourceWidth,
		 long Lines, long TopLine, long Planes);
void UpdateDelay24 (long Frames);
void Refresh24 (void);
BOOL SetDisplayBottom24 (long Bottom);
void ClearDisplayBottom24 (void);
void SetSprite24 (USHORT *Sprite, long SpriteNum);
void AmigaPriority (void);
void OVPriority (void);
void DualDisplay24 (void);
void SingleDisplay24 (void);
void AppendCopper24 (UWORD *CopperArray[]);
void RectFill24
	(struct OpalScreen *Scrn, long x1, long y1, long x2, long y2);
void UpdateCoPro24 (void);
void SetControlBit24 (long List, long Bit, long State);
void PaletteMap24 (long Map);
void UpdatePalette24 (void);
void Scroll24 (long Dx, long Dy);
long LoadIFF24 (struct OpalScreen *Scrn, char *FileName, long Flags);
void SetScreen24 (struct OpalScreen *Scrn);
long SaveIFF24 (struct OpalScreen *Scrn, char *FileName,
		 long (* ChunkFunc)(), long Flags);
struct OpalScreen *CreateScreen24 (long ScreenModes, long Width, long Height);
void FreeScreen24 (struct OpalScreen *Scrn);
void UpdateRegs24 (void);
void SetLoadAddress24 (void);
void RGBtoOV (struct OpalScreen *Scrn, UBYTE *RGBData[3],
				 long x, long y, long w, long h);
struct OpalScreen *ActiveScreen24 (void);
void FadeIn24 (long Time);
void FadeOut24 (long Time);
void ClearQuick24 (void);
long WriteThumbnail24 (struct OpalScreen *Scrn, BPTR File);
void SetRGB24 (long Entry, long R, long G, long B);
void DrawLine24 (struct OpalScreen *Scrn, long X1, long Y1, long X2, long y2);
void StopUpdate24 (void);
long WritePFPixel24 (struct OpalScreen *Scrn, long x, long y);
long WritePRPixel24 (struct OpalScreen *Scrn, long x, long y);
long OVtoRGB (struct OpalScreen *Scrn, UBYTE *RGBData[],
				 long x, long y, long w, long h);
void OVtoILBM (struct OpalScreen *Scrn, UBYTE *ILBMData, long DestWidth,
			long Lines, long TopLine);
void UpdateAll24 (void);
void UpdatePFStencil24 (void);
void EnablePRStencil24 (void);
void DisablePRStencil24 (void);
void ClearPRStencil24 (struct OpalScreen *Scrn);
void SetPRStencil24 (struct OpalScreen *Scrn);
void DisplayFrame24 (long Frame);
void WriteFrame24 (long Frame);
void BitPlanetoOV (struct OpalScreen *Scrn, UBYTE *SrcPlanes[],
		long BytesPerLine, long Lines, long TopLine, long SrcDepth);
void SetCoPro24 (long Line, long Instruction);
void RegWait24 (void);
void DualPlayField24 (void);
void SinglePlayField24 (void);
void ClearPFStencil24 (struct OpalScreen *Scrn);
void SetPFStencil24 (struct OpalScreen *Scrn);
long ReadPRPixel24 (struct OpalScreen *Scrn, long x, long y);
long ReadPFPixel24 (struct OpalScreen *Scrn, long x, long y);
void OVtoBitPlane (struct OpalScreen *Scrn, UBYTE *DestPlanes[],
		long DestWidth, long Lines, long TopLine);
void FreezeFrame24 (BOOL Freeze);
struct OpalScreen *LowMemUpdate24 (struct OpalScreen *Scrn,long Frame);
long DisplayThumbnail24 (struct OpalScreen *Scrn, char *FileName, long x,long y);
long Config24 (void);
void AutoSync24 (BOOL Sync);
void DrawEllipse24 (struct OpalScreen *Scrn, long Cx, long Cy, long a, long b);
void LatchDisplay24 (BOOL Latch);
void SetHires24 (long TopLine, long Lines);
void SetLores24 (long TopLine, long Lines);
BOOL DownLoadFrame24 (struct OpalScreen *OScrn,long x,long y,long w,long h);
long SaveJPEG24 (struct OpalScreen *OScrn, char *FileName, long Flags, long Quality);
struct OpalScreen *LowMem2Update24 (struct OpalScreen *Scrn,long Frame);
struct OpalScreen *LowMemRGB24 (long ScreenModes,long WriteFrame,long Width,long Height, long Modulo, UBYTE *RGBPlanes[3]);

#ifdef	AZTEC_C
#pragma amicall(OpalBase,0x1e,OpenScreen24(D0))
#pragma amicall(OpalBase,0x24,CloseScreen24())
#pragma amicall(OpalBase,0x2a,WritePixel24(A0,D0,D1))
#pragma amicall(OpalBase,0x30,ReadPixel24(A0,D0,D1))
#pragma amicall(OpalBase,0x36,ClearScreen24(A0))
#pragma amicall(OpalBase,0x3c,ILBMtoOV(A0,A1,D0,D1,D2,D3))
#pragma amicall(OpalBase,0x42,UpdateDelay24(D0))
#pragma amicall(OpalBase,0x48,Refresh24())
#pragma amicall(OpalBase,0x4e,SetDisplayBottom24(D0))
#pragma amicall(OpalBase,0x54,ClearDisplayBottom24())
#pragma amicall(OpalBase,0x5a,SetSprite24(A0,D0))
#pragma amicall(OpalBase,0x60,AmigaPriority())
#pragma amicall(OpalBase,0x66,OVPriority())
#pragma amicall(OpalBase,0x6c,DualDisplay24())
#pragma amicall(OpalBase,0x72,SingleDisplay24())
#pragma amicall(OpalBase,0x78,AppendCopper24(A0))
#pragma amicall(OpalBase,0x7e,RectFill24(A0,D0,D1,D2,D3))
#pragma amicall(OpalBase,0x84,UpdateCoPro24())
#pragma amicall(OpalBase,0x8A,SetControlBit24(D0,D1,D2))
#pragma amicall(OpalBase,0x90,PaletteMap24(D0))
#pragma amicall(OpalBase,0x96,UpdatePalette24())
#pragma amicall(OpalBase,0x9c,Scroll24(D0,D1))
#pragma amicall(OpalBase,0xa2,LoadIFF24(A0,A1,D0))
#pragma amicall(OpalBase,0xa8,SetScreen24(A0))
#pragma amicall(OpalBase,0xae,SaveIFF24(A0,A1,A2,D0))
#pragma amicall(OpalBase,0xb4,CreateScreen24(D0,D1,D2))
#pragma amicall(OpalBase,0xba,FreeScreen24(A0))
#pragma amicall(OpalBase,0xc0,UpdateRegs24())
#pragma amicall(OpalBase,0xc6,SetLoadAddress24())
#pragma amicall(OpalBase,0xcc,RGBtoOV(A0,A1,D0,D1,D2,D3))
#pragma amicall(OpalBase,0xd2,ActiveScreen24())
#pragma amicall(OpalBase,0xd8,FadeIn24(D0))
#pragma amicall(OpalBase,0xde,FadeOut24(D0))
#pragma amicall(OpalBase,0xe4,ClearQuick24())
#pragma amicall(OpalBase,0xea,WriteThumbnail24(A0,A1))
#pragma amicall(OpalBase,0xf0,SetRGB24(D0,D1,D2,D3))
#pragma amicall(OpalBase,0xf6,DrawLine24(A0,D0,D1,D2,D3))
#pragma amicall(OpalBase,0xfc,StopUpdate24())
#pragma amicall(OpalBase,0x102,WritePFPixel24(A0,D0,D1))
#pragma amicall(OpalBase,0x108,WritePRPixel24(A0,D0,D1))
#pragma amicall(OpalBase,0x10e,OVtoRGB(A0,A1,D0,D1,D2,D3))
#pragma amicall(OpalBase,0x114,OVtoILBM(A0,A1,D0,D1,D2))
#pragma amicall(OpalBase,0x11a,UpdateAll24())
#pragma amicall(OpalBase,0x120,UpdatePFStencil24())
#pragma amicall(OpalBase,0x126,EnablePRStencil24())
#pragma amicall(OpalBase,0x12c,DisablePRStencil24())
#pragma amicall(OpalBase,0x132,ClearPRStencil24(A0))
#pragma amicall(OpalBase,0x138,SetPRStencil24(A0))
#pragma amicall(OpalBase,0x13e,DisplayFrame24(D0))
#pragma amicall(OpalBase,0x144,WriteFrame24(D0))
#pragma amicall(OpalBase,0x14a,BitPlanetoOV(A0,A1,D0,D1,D2,D3))
#pragma amicall(OpalBase,0x150,SetCoPro24(D0,D1))
#pragma amicall(OpalBase,0x156,RegWait24())
#pragma amicall(OpalBase,0x15c,DualPlayField24())
#pragma amicall(OpalBase,0x162,SinglePlayField24())
#pragma amicall(OpalBase,0x168,ClearPFStencil24(A0))
#pragma amicall(OpalBase,0x16e,SetPFStencil24(A0))
#pragma amicall(OpalBase,0x174,ReadPRPixel24(A0,D0,D1))
#pragma amicall(OpalBase,0x17a,ReadPFPixel24(A0,D0,D1))
#pragma amicall(OpalBase,0x180,OVtoBitPlane(A0,A1,D0,D1,D2))
#pragma amicall(OpalBase,0x186,FreezeFrame24(D0))
#pragma amicall(OpalBase,0x18c,LowMemUpdate24(A0,D0))
#pragma amicall(OpalBase,0x192,DisplayThumbnail24(A0,A1,D0,D1))
#pragma amicall(OpalBase,0x198,Config24())
#pragma amicall(OpalBase,0x19e,AutoSync24(D0))
#pragma amicall(OpalBase,0x1a4,DrawEllipse24(A0,D0,D1,D2,D3))
#pragma amicall(OpalBase,0x1aa,LatchDisplay24(D0))
#pragma amicall(OpalBase,0x1b0,SetHires24(D0,D1))
#pragma amicall(OpalBase,0x1b6,SetLores24(D0,D1))
#pragma amicall(OpalBase,0x1bc,DownLoadFrame24(A0,D0,D1,D2,D3))
#pragma amicall(OpalBase,0x1c2,SaveJPEG24(A0,A1,D0,D1))
#pragma amicall(OpalBase,0x1c8,LowMem2Update24(A0,D0))
#pragma amicall(OpalBase,0x1ce,LowMemRGB24(D0,D1,D2,D3,D4,A0))
#else
#pragma libcall OpalBase OpenScreen24 1e 1
#pragma libcall OpalBase CloseScreen24 24 0
#pragma libcall OpalBase WritePixel24 2a 10803
#pragma libcall OpalBase ReadPixel24 30 10803
#pragma libcall OpalBase ClearScreen24 36 801
#pragma libcall OpalBase ILBMtoOV 3c 32109806
#pragma libcall OpalBase UpdateDelay24 42 1
#pragma libcall OpalBase Refresh24 48 0
#pragma libcall OpalBase SetDisplayBottom24 4e 1
#pragma libcall OpalBase ClearDisplayBottom24 54 0
#pragma libcall OpalBase SetSprite24 5a 802
#pragma libcall OpalBase AmigaPriority 60 0
#pragma libcall OpalBase OVPriority 66 0
#pragma libcall OpalBase DualDisplay24 6c 0
#pragma libcall OpalBase SingleDisplay24 72 0
#pragma libcall OpalBase AppendCopper24 78 801
#pragma libcall OpalBase RectFill24 7e 3210805
#pragma libcall OpalBase UpdateCoPro24 84 0
#pragma libcall OpalBase SetControlBit24 8a 21003
#pragma libcall OpalBase PaletteMap24 90 1
#pragma libcall OpalBase UpdatePalette24 96 0
#pragma libcall OpalBase Scroll24 9c 1002
#pragma libcall OpalBase LoadIFF24 a2 9803
#pragma libcall OpalBase SetScreen24 a8 801
#pragma libcall OpalBase SaveIFF24 ae a9804
#pragma libcall OpalBase CreateScreen24 b4 21003
#pragma libcall OpalBase FreeScreen24 ba 801
#pragma libcall OpalBase UpdateRegs24 c0 0
#pragma libcall OpalBase SetLoadAddress24 c6 0
#pragma libcall OpalBase RGBtoOV cc 32109806
#pragma libcall OpalBase ActiveScreen24 d2 0
#pragma libcall OpalBase FadeIn24 d8 1
#pragma libcall OpalBase FadeOut24 de 1
#pragma libcall OpalBase ClearQuick24 e4 0
#pragma libcall OpalBase WriteThumbnail24 ea 9802
#pragma libcall OpalBase SetRGB24 f0 321004
#pragma libcall OpalBase DrawLine24 f6 3210805
#pragma libcall OpalBase StopUpdate24 fc 0
#pragma libcall OpalBase WritePFPixel24 102 10803
#pragma libcall OpalBase WritePRPixel24 108 10803
#pragma libcall OpalBase OVtoRGB 10e 32109806
#pragma libcall OpalBase OVtoILBM 114 2109805
#pragma libcall OpalBase UpdateAll24 11a 0
#pragma libcall OpalBase UpdatePFStencil24 120 0
#pragma libcall OpalBase EnablePRStencil24 126 0
#pragma libcall OpalBase DisablePRStencil24 12c 0
#pragma libcall OpalBase ClearPRStencil24 132 801
#pragma libcall OpalBase SetPRStencil24 138 801
#pragma libcall OpalBase DisplayFrame24 13e 1
#pragma libcall OpalBase WriteFrame24 144 1
#pragma libcall OpalBase BitPlanetoOV 14a 32109806
#pragma libcall OpalBase SetCoPro24 150 1002
#pragma libcall OpalBase RegWait24 156 0
#pragma libcall OpalBase DualPlayField24 15c 0
#pragma libcall OpalBase SinglePlayField24 162 0
#pragma libcall OpalBase ClearPFStencil24 168 801
#pragma libcall OpalBase SetPFStencil24 16e 801
#pragma libcall OpalBase ReadPRPixel24 174 10803
#pragma libcall OpalBase ReadPFPixel24 17a 10803
#pragma libcall OpalBase OVtoBitPlane 180 2109805
#pragma libcall OpalBase FreezeFrame24 186 1
#pragma libcall OpalBase LowMemUpdate24 18c 802
#pragma libcall OpalBase DisplayThumbnail24 192 109804
#pragma libcall OpalBase Config24 198 0
#pragma libcall OpalBase AutoSync24 19e 1
#pragma libcall OpalBase DrawEllipse24 1a4 3210805
#pragma libcall OpalBase LatchDisplay24 1aa 1
#pragma libcall OpalBase SetHires24 1b0 1002
#pragma libcall OpalBase SetLores24 1b6 1002
#pragma libcall OpalBase DownLoadFrame24 1bc 3210805
#pragma libcall OpalBase SaveJPEG24 1c2 109804
#pragma libcall OpalBase LowMem2Update24 1c8 802
#pragma libcall OpalBase LowMemRGB24  1ce 84321006

#endif

#endif
