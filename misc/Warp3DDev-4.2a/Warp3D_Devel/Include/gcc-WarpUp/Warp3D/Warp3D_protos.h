#ifndef WARP3D_GCCLIB_PROTOS_H
#define WARP3D_GCCLIB_PROTOS_H



#ifdef __PPC__
#include <utility/tagitem.h>
#include <stdarg.h>

extern struct Library *Warp3DPPCBase;

#include <powerpc/warpup_macros.h>

/************************** Context functions ***********************************/
#define W3D_CreateContext(v1,v2)    PPCLP2  (Warp3DPPCBase,-30,W3D_Context *,   ULONG *,3,v1,struct TagItem *,4,v2)
static inline W3D_Context  *W3D_CreateContextTags(ULONG *error, Tag tag1, ...)
{
	static struct TagItem _tags[20];
	int i = 0;
	va_list marker;

	if (tag1 == TAG_DONE)
	{
		_tags[0].ti_Tag = TAG_DONE;
		return W3D_CreateContext(error, _tags);
	}

	_tags[i].ti_Tag = tag1;

	va_start (marker, tag1);
	do
	{
		_tags[i].ti_Data = va_arg(marker, ULONG);
		i++;
		_tags[i].ti_Tag = va_arg(marker, ULONG);
	}
	while (_tags[i].ti_Tag != TAG_DONE);

	va_end(marker);
	return W3D_CreateContext(error, _tags);
}


#define W3D_DestroyContext(v1)      PPCLP1NR(Warp3DPPCBase,-36,         W3D_Context *,3,v1)
#define W3D_GetState(v1,v2)     PPCLP2  (Warp3DPPCBase,-42,ULONG,       W3D_Context *,3,v1,ULONG,4,v2)
#define W3D_SetState(v1,v2,v3)      PPCLP3  (Warp3DPPCBase,-48,ULONG,       W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3)
#define W3D_Hint(v1,v2,v3)      PPCLP3  (Warp3DPPCBase,-294,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3)

/************************** Hardware/Driver functions ***************************/
#define W3D_CheckDriver()       PPCLP0  (Warp3DPPCBase,-54,ULONG        )
#define W3D_LockHardware(v1)        PPCLP1  (Warp3DPPCBase,-60,ULONG,       W3D_Context *,3,v1)
#define W3D_UnLockHardware(v1)      PPCLP1NR(Warp3DPPCBase,-66,         W3D_Context *,3,v1)
#define W3D_WaitIdle(v1)        PPCLP1NR(Warp3DPPCBase,-72,         W3D_Context *,3,v1)
#define W3D_CheckIdle(v1)       PPCLP1  (Warp3DPPCBase,-78,ULONG,       W3D_Context *,3,v1)
#define W3D_Query(v1,v2,v3)     PPCLP3  (Warp3DPPCBase,-84,ULONG,       W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3)
#define W3D_GetTexFmtInfo(v1,v2,v3) PPCLP3  (Warp3DPPCBase,-90,ULONG,       W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3)
#define W3D_GetDriverState(v1)      PPCLP1  (Warp3DPPCBase,-306,ULONG,      W3D_Context *,3,v1)
#define W3D_GetDestFmt()        PPCLP0  (Warp3DPPCBase,-384,ULONG       )
#define W3D_GetDrivers()        PPCLP0  (Warp3DPPCBase,-402,W3D_Driver **   )
#define W3D_QueryDriver(v1,v2,v3)   PPCLP3  (Warp3DPPCBase,-408,ULONG,      W3D_Driver *,3,v1,ULONG,4,v2,ULONG,5,v3)
#define W3D_GetDriverTexFmtInfo(v1,v2,v3) PPCLP3(Warp3DPPCBase,-414,ULONG,      W3D_Driver *,3,v1,ULONG,4,v2,ULONG,5,v3)
#define W3D_RequestMode(v1)     PPCLP1  (Warp3DPPCBase,-420,ULONG,      struct TagItem *,3,v1)
static inline ULONG W3D_RequestModeTags(Tag tag1, ...)
{
	static struct TagItem _tags[20];
	int i = 0;
	va_list marker;

	if (tag1 == TAG_DONE)
	{
		_tags[0].ti_Tag = TAG_DONE;
		return W3D_RequestMode(_tags);
	}

	_tags[i].ti_Tag = tag1;

	va_start (marker, tag1);
	do
	{
		_tags[i].ti_Data = va_arg(marker, ULONG);
		i++;
		_tags[i].ti_Tag = va_arg(marker, ULONG);
	}
	while (_tags[i].ti_Tag != TAG_DONE);

	va_end(marker);
	return W3D_RequestMode(_tags);
}

#define W3D_TestMode(v1)        PPCLP1  (Warp3DPPCBase,-438,W3D_Driver *,   ULONG,3,v1)

/************************** Texture functions ***********************************/
#define W3D_AllocTexObj(v1,v2,v3)   PPCLP3  (Warp3DPPCBase,-96,W3D_Texture *,   W3D_Context *,3,v1,ULONG *,4,v2,struct TagItem *,5,v3)
static inline W3D_Texture *W3D_AllocTexObjTags(W3D_Context *context, ULONG *error, Tag tag1, ...)
{
	static struct TagItem _tags[20];
	int i = 0;
	va_list marker;

	if (tag1 == TAG_DONE)
	{
		_tags[0].ti_Tag = TAG_DONE;
		return W3D_AllocTexObj(context, error, _tags);
	}

	_tags[i].ti_Tag = tag1;

	va_start (marker, tag1);
	do
	{
		_tags[i].ti_Data = va_arg(marker, ULONG);
		i++;
		_tags[i].ti_Tag = va_arg(marker, ULONG);
	}
	while (_tags[i].ti_Tag != TAG_DONE);

	va_end(marker);
	return W3D_AllocTexObj(context, error, _tags);
}

#define W3D_FreeTexObj(v1,v2)       PPCLP2NR(Warp3DPPCBase,-102,            W3D_Context *,3,v1,W3D_Texture *,4,v2)
#define W3D_ReleaseTexture(v1,v2)   PPCLP2NR(Warp3DPPCBase,-108,            W3D_Context *,3,v1,W3D_Texture *,4,v2)
#define W3D_FlushTextures(v1,v2)    PPCLP1NR(Warp3DPPCBase,-114,            W3D_Context *,3,v1)
#define W3D_SetFilter(v1,v2,v3,v4)  PPCLP4  (Warp3DPPCBase,-120,ULONG,      W3D_Context *,3,v1,W3D_Texture *,4,v2,ULONG,5,v3,ULONG,6,v4)
#define W3D_SetTexEnv(v1,v2,v3,v4)  PPCLP4  (Warp3DPPCBase,-126,ULONG,      W3D_Context *,3,v1,W3D_Texture *,4,v2,ULONG,5,v3,W3D_Color *,6,v4)
#define W3D_SetWrapMode(v1,v2,v3,v4,v5) PPCLP5  (Warp3DPPCBase,-132,ULONG,      W3D_Context *,3,v1,W3D_Texture *,4,v2,ULONG,5,v3,ULONG,6,v4,W3D_Color *,7,v5)
#define W3D_UpdateTexImage(v1,v2,v3,v4,v5)      PPCLP5(Warp3DPPCBase,-138,ULONG,      W3D_Context *,3,v1,W3D_Texture *,4,v2,void *,5,v3,ULONG,6,v4,ULONG *,7,v5)
#define W3D_UpdateTexSubImage(v1,v2,v3,v4,v5,v6,v7) PPCLP7  (Warp3DPPCBase,-372,ULONG,      W3D_Context *,3,v1,W3D_Texture *,4,v2,void *,5,v3,ULONG,6,v4,ULONG *,7,v5,W3D_Scissor *,8,v6,ULONG,9,v7)
#define W3D_UploadTexture(v1,v2)    PPCLP2  (Warp3DPPCBase,-144,ULONG,      W3D_Context *,3,v1,W3D_Texture *,4,v2)
#define W3D_FreeAllTexObj(v1)       PPCLP1  (Warp3DPPCBase,-378,ULONG,      W3D_Context *,3,v1)
#define W3D_SetChromaTestBounds(v1,v2,v3,v4,v5) PPCLP5(Warp3DPPCBase,-444,ULONG,       W3D_Context *,3,v1,W3D_Texture *,4,v2,ULONG,5,v3,ULONG,6,v4,ULONG,7,v5)

/************************** Drawing functions ***********************************/
#define W3D_DrawLine(v1,v2)     PPCLP2  (Warp3DPPCBase,-150,ULONG,      W3D_Context *,3,v1,W3D_Line *,4,v2)
#define W3D_DrawPoint(v1,v2)        PPCLP2  (Warp3DPPCBase,-156,ULONG,      W3D_Context *,3,v1,W3D_Point *,4,v2)
#define W3D_DrawTriangle(v1,v2)     PPCLP2  (Warp3DPPCBase,-162,ULONG,      W3D_Context *,3,v1,W3D_Triangle *,4,v2)
#define W3D_DrawTriFan(v1,v2)       PPCLP2  (Warp3DPPCBase,-168,ULONG,      W3D_Context *,3,v1,W3D_Triangles *,4,v2)
#define W3D_DrawTriStrip(v1,v2)     PPCLP2  (Warp3DPPCBase,-174,ULONG,      W3D_Context *,3,v1,W3D_Triangles *,4,v2)
#define W3D_Flush(v1)           PPCLP1  (Warp3DPPCBase,-312,ULONG,      W3D_Context *,3,v1)
#define W3D_DrawLineStrip(v1,v2)    PPCLP2  (Warp3DPPCBase,-390,ULONG,      W3D_Context *,3,v1,W3D_Lines *,4,v2)
#define W3D_DrawLineLoop(v1,v2)     PPCLP2  (Warp3DPPCBase,-396,ULONG,      W3D_Context *,3,v1,W3D_Lines *,4,v2)
#define W3D_ClearDrawRegion(v1, v2) PPCLP2  (Warp3DPPCBase,-450,ULONG,      W3D_Context *,3,v1,ULONG,4,v2)

/************************** Effect functions ************************************/
#define W3D_SetAlphaMode(v1,v2,v3)  PPCLP3  (Warp3DPPCBase,-180,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,W3D_Float *,5,v3)
#define W3D_SetBlendMode(v1,v2,v3)  PPCLP3  (Warp3DPPCBase,-186,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3)
#define W3D_SetDrawRegion(v1,v2,v3,v4)  PPCLP4  (Warp3DPPCBase,-192,ULONG,      W3D_Context *,3,v1,struct BitMap *,4,v2,int,5,v3,W3D_Scissor *,6,v4)
#define W3D_SetDrawRegionWBM(v1,v2,v3)  PPCLP3  (Warp3DPPCBase,-300,ULONG,      W3D_Context *,3,v1,W3D_Bitmap *,4,v2,W3D_Scissor *,5,v3)
#define W3D_SetFogParams(v1,v2,v3)  PPCLP3  (Warp3DPPCBase,-198,ULONG,      W3D_Context *,3,v1,W3D_Fog *,4,v2,ULONG,5,v3)
#define W3D_SetLogicOp(v1,v2)       PPCLP2  (Warp3DPPCBase,-288,ULONG,      W3D_Context *,3,v1,ULONG,4,v2)
#define W3D_SetColorMask(v1,v2,v3,v4,v5)    PPCLP5  (Warp3DPPCBase,-204,ULONG,      W3D_Context *,3,v1,W3D_Bool,4,v2,W3D_Bool,5,v3,W3D_Bool,6,v4,W3D_Bool,7,v5)
#define W3D_SetPenMask(v1,v2)       PPCLP2  (Warp3DPPCBase,-318,ULONG,      W3D_Context *,3,v1,ULONG,4,v2)
#define W3D_SetCurrentColor(v1,v2)  PPCLP2  (Warp3DPPCBase,-360,ULONG,      W3D_Context *,3,v1,W3D_Color *,4,v2)
#define W3D_SetCurrentPen(v1,v2)    PPCLP2  (Warp3DPPCBase,-366,ULONG,      W3D_Context *,3,v1,ULONG,4,v2)
#define W3D_SetScissor(v1,v2)       PPCLP2NR(Warp3DPPCBase,-426,            W3D_Context *,3,v1,W3D_Scissor *,4,v2)
#define W3D_FlushFrame(v1)      PPCLP1NR(Warp3DPPCBase,-432,            W3D_Context *,3,v1)

/************************** ZBuffer functions ***********************************/
#define W3D_AllocZBuffer(v1)        PPCLP1  (Warp3DPPCBase,-216,ULONG,      W3D_Context *,3,v1)
#define W3D_FreeZBuffer(v1)     PPCLP1  (Warp3DPPCBase,-222,ULONG,      W3D_Context *,3,v1)
#define W3D_ClearZBuffer(v1,v2)     PPCLP2  (Warp3DPPCBase,-228,ULONG,      W3D_Context *,3,v1,W3D_Double *,4,v2)
#define W3D_ReadZPixel(v1,v2,v3,v4) PPCLP4  (Warp3DPPCBase,-234,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,W3D_Double *,6,v4)
#define W3D_ReadZSpan(v1,v2,v3,v4,v5)   PPCLP5  (Warp3DPPCBase,-240,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG,6,v4,W3D_Double *,7,v5)
#define W3D_SetZCompareMode(v1,v2)  PPCLP2  (Warp3DPPCBase,-246,ULONG,      W3D_Context *,3,v1,ULONG,4,v2)
#define W3D_WriteZPixel(v1,v2,v3,v4)    PPCLP4  (Warp3DPPCBase,-348,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,W3D_Double *,6,v4)
#define W3D_WriteZSpan(v1,v2,v3,v4,v5,v6)   PPCLP6  (Warp3DPPCBase,-354,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG,6,v4,W3D_Double *,7,v5,UBYTE *,8,v6)

/************************** StencilBuffer functions *****************************/
#define W3D_AllocStencilBuffer(v1)  PPCLP1  (Warp3DPPCBase,-252,ULONG,      W3D_Context *,3,v1)
#define W3D_ClearStencilBuffer(v1,v2)   PPCLP2  (Warp3DPPCBase,-258,ULONG,      W3D_Context *,3,v1,ULONG *,4,v2)
#define W3D_FillStencilBuffer(v1,v2,v3,v4,v5,v6,v7) PPCLP2  (Warp3DPPCBase,-264,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG,6,v4,ULONG,7,v5,ULONG,8,v6,void *,9,v7)
#define W3D_FreeStencilBuffer(v1)   PPCLP1  (Warp3DPPCBase,-270,ULONG,      W3D_Context *,3,v1)
#define W3D_ReadStencilPixel(v1,v2,v3,v4)   PPCLP4  (Warp3DPPCBase,-276,ULONG,  W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG *,6,v4)
#define W3D_ReadStencilSpan(v1,v2,v3,v4,v5) PPCLP5  (Warp3DPPCBase,-282,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG,6,v4,ULONG *,7,v5)
#define W3D_SetStencilFunc(v1,v2,v3,v4) PPCLP4  (Warp3DPPCBase,-210,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG,6,v4)
#define W3D_SetStencilOp(v1,v2,v3,v4)   PPCLP4  (Warp3DPPCBase,-324,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG,6,v4)
#define W3D_SetWriteMask(v1,v2)     PPCLP2  (Warp3DPPCBase,-330,ULONG,      W3D_Context *,3,v1,ULONG,4,v2)
#define W3D_WriteStencilPixel(v1,v2,v3,v4)  PPCLP4  (Warp3DPPCBase,-336,ULONG,  W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG,6,v4)
#define W3D_WriteStencilSpan(v1,v2,v3,v4,v5,v6) PPCLP6  (Warp3DPPCBase,-342,ULONG,      W3D_Context *,3,v1,ULONG,4,v2,ULONG,5,v3,ULONG,6,v4,ULONG *,7,v5,UBYTE *,8,v6)

/*************************** V3 Vector functions **********************************/
#define W3D_DrawTriangleV(v1, v2)   PPCLP2 (Warp3DPPCBase,-456,ULONG,   W3D_Context *,3,v1,W3D_TriangleV *,4,v2)
#define W3D_DrawTriFanV(v1, v2)     PPCLP2 (Warp3DPPCBase,-462,ULONG,   W3D_Context *,3,v1,W3D_TrianglesV *,4,v2)
#define W3D_DrawTriStripV(v1, v2)   PPCLP2 (Warp3DPPCBase,-468,ULONG,   W3D_Context *,3,v1,W3D_TrianglesV *,4,v2)

/*************************** V3 Screenmode functions ******************************/
#define W3D_GetScreenmodeList()     PPCLP0  (Warp3DPPCBase,-474,W3D_ScreenMode * )
#define W3D_FreeScreenmodeList(v1)  PPCLP1NR(Warp3DPPCBase,-480,        W3D_ScreenMode *,3,v1)
#define W3D_BestModeID(v1)          PPCLP1  (Warp3DPPCBase,-486,ULONG,  struct TagItem *,3,v1)
static inline ULONG W3D_BestModeIDTags(Tag tag1, ...)
{
	static struct TagItem _tags[20];
	int i = 0;
	va_list marker;

	if (tag1 == TAG_DONE)
	{
		_tags[0].ti_Tag = TAG_DONE;
		return W3D_BestModeID(_tags);
	}

	_tags[i].ti_Tag = tag1;

	va_start (marker, tag1);
	do
	{
		_tags[i].ti_Data = va_arg(marker, ULONG);
		i++;
		_tags[i].ti_Tag = va_arg(marker, ULONG);
	}
	while (_tags[i].ti_Tag != TAG_DONE);

	va_end(marker);
	return W3D_BestModeID(_tags);
}

/*************************** V4 vertex array functions ******************************/
#define W3D_VertexPointer(context,pointer,stride,mode,flags) PPCLP5(Warp3DPPCBase, -492, ULONG, W3D_Context *, 3, context, void *, 4, pointer, int, 5, stride, ULONG, 6, mode, ULONG, 7, flags)
#define W3D_TexCoordPointer(context,pointer,stride,unit,off_v,off_w,flags) PPCLP7(Warp3DPPCBase, -498, ULONG, W3D_Context *, 3, context, void *, 4, pointer, int, 5, stride, int, 6, unit, int, 7, off_v, int, 8, off_w, ULONG, 9, flags)
#define W3D_ColorPointer(context,pointer,stride,format,mode,flags) PPCLP6(Warp3DPPCBase, -504, ULONG, W3D_Context *, 3, context, void *, 4, pointer, int, 5, stride, ULONG, 6, format, ULONG, 7, mode, ULONG, 8, flags)
#define W3D_BindTexture(context,tmu,texture) PPCLP3(Warp3DPPCBase, -510, ULONG, W3D_Context *, 3, context, ULONG, 4, tmu, W3D_Texture *, 5, texture)
#define W3D_DrawArray(context,primitive,base,count) PPCLP4(Warp3DPPCBase, -516, ULONG, W3D_Context *, 3, context, ULONG, 4, primitive, ULONG, 5, base, ULONG, 6, count)
#define W3D_DrawElements(context,primitive,type,count,indices) PPCLP5(Warp3DPPCBase, -522, ULONG, W3D_Context *, 3, context, ULONG, 4, primitive, ULONG, 5, type, ULONG, 6, count, void *, 7, indices)
#define W3D_SetFrontFace(context, direction) PPCLP2NR(Warp3DPPCBase, -528, W3D_Context *, 3, context, ULONG, 4, direction)

#endif /* __PPC__ */

#endif /* POWERPC_GCCLIB_PROTOS_H */
