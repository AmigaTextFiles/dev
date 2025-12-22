/* 
** $Id: Guigfx_data.h 1.1 2000/03/30 22:33:12 msbethke Exp msbethke $
*/

/* Instance data for Guigfx.mcc */
struct Data {
	Object *this;								// pointer to self
	struct IClass *myclass;					// class pointer
	APTR Picture, PicBackup;				// guigfx picture object and its backup
	APTR PSM, DrawHandle;					// guigfx PenShareMap/Drawhandle
	ULONG PicW, PicH;							// picture's current width/height
	ULONG OrigW, OrigH;						// original dimensions as loaded
	ULONG CorrW, CorrH;						// picture's aspect-corrected dimensions
	ULONG PosX, PosY;							// x and y position in drawing rectangle

	LONG Precision;							// remap recision (see graphics/view.h: OBP_PRECISION)
	LONG DitherMode;							// dither mode (see libraries/guigfx.h: GGFX_DitherMode)
	LONG DitherThresh;						// dither threshold (guigfx: GGFX_DitherThreshold)
	ULONG Quality;								// quality as defined in NewImage_mcc.h

	struct Rectangle ShowRect;				// Rectangle inside image to display

	LONG TransColor;							// transparent color in 0x00rrggbb format
	struct BitMap *PicBM;					// picture's bitmap
	PLANEPTR BltMask;							// optional transparency mask
	BOOL DisposePicture;						// dispose picture in OM_DISPOSE?
	BOOL Transparency;						//	render with transparent background?
	WORD ScaleMode;							// whether/how to allow scaling
	BOOL AutoDither;							// automatic dithering y/n
};
