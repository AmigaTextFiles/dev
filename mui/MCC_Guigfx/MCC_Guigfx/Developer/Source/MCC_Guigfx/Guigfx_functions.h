/*
** $Id: Guigfx_functions.h 1.2 2000/03/30 23:02:43 msbethke Exp msbethke $
*/

BOOL InitGuiGfxStuff(struct Data*);
void FreeGuiGfxStuff(struct Data*);
void SetPicSize(struct Data*, ULONG, ULONG);
void CalculateScalingFactors(struct Data*);
BOOL RenderBitmaps(struct Data*,Object*);
BOOL GetNewHandle(struct Data*,Object*);
void DisposeBitmaps(struct Data*);
void DisposeBitmapsAndHandle(struct Data*);
void SetQuality(struct Data*, ULONG);
BOOL SetNewBitmap(struct MUIP_Guigfx_BitMapInfo*, struct Data*);
BOOL SetNewImage(struct MUIP_Guigfx_ImageInfo*, struct Data*);
BOOL SetNewFileName(STRPTR, struct Data*);
void ObjectSizeChange(struct Data*);
