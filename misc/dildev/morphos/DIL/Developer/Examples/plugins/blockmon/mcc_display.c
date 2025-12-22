/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include "include.h"

//------------------------------------------------------------------------------

#define FACTOR 		500l

#define AI_VECTORS 	0x7fffl

#define COL_BG			MAKE_ID(0, 250, 250, 250)
#define COL_DISK		MAKE_ID(0, 220, 220, 220)
#define COL_R			MAKE_ID(0, 250, 150, 150)
#define COL_G			MAKE_ID(0, 150, 250, 150)
#define COL_B			MAKE_ID(0, 150, 150, 250)

#define OUTRAD 		(FACTOR / 2 * data->dd_Scale)
#define INRAD 			(OUTRAD / 4)

//------------------------------------------------------------------------------

//static struct Library *TimerBase = NULL;

//------------------------------------------------------------------------------

static void UpdateTitle(struct MCC_Display_Data *data);
static void UpdateSize(struct MCC_Display_Data *data);

static ULONG GetFraction(ULONG val);

static void DrawCyls(Control *control, struct RastPort *rp, LONG cx, LONG cy, ULONG radius);
static void DrawTracks(struct RastPort *rp, LONG cx, LONG cy, ULONG inrad, ULONG outrad, ULONG parts);
static void DrawBlock(struct RastPort *rp, LONG cx, LONG cy, ULONG radius1, ULONG radius2, ULONG part, ULONG parts, ULONG maxparts);

static void DrawBackground(struct MCC_Display_Data *data);
static void DrawEntry(struct MCC_Display_Data *data, Entry *entry);
static void DrawAll(struct MCC_Display_Data *data, ULONG flags);

//------------------------------------------------------------------------------

static ULONG mNew(struct IClass *cl, Object *obj, struct opSet *msg)
{
	struct MCC_Display_Data *data;

	if (!(obj = (Object *)DoSuperMethodA(cl, obj, msg)))
		return 0;

	data = INST_DATA(cl, obj); memclr(data, sizeof(struct MCC_Display_Data));
	
	data->dd_VectorsMax = AI_VECTORS;
	if ((data->dd_Vectors = AllocVec(data->dd_VectorsMax * 5, MEMF_PUBLIC))) {
		struct MUI_MinMaxDefCur *mmdc = &data->dd_MinMaxDefCur;

		data->obj_self = obj;

		mmdc->MinWidth  = FACTOR;
		mmdc->MinHeight = FACTOR;
		mmdc->MaxWidth	 = MUI_MAXMAX;
		mmdc->MaxHeight = MUI_MAXMAX;
		mmdc->DefWidth	 = FACTOR;
		mmdc->DefHeight = FACTOR;
		mmdc->CurWidth  = mmdc->MinWidth;
		mmdc->CurHeight = mmdc->MinHeight;
		
		data->dd_Scale = 1ul;
		setf(data->dd_Flags, DDF_FIRST);

		data->dd_Control = (Control *)GetTagData(MUIA_Display_Control, 0ul, msg->ops_AttrList);

		/*if ((data->dd_EHPort = CreateMsgPort()))
		{
			if ((data->dd_EHReq = CreateIORequest(data->dd_EHPort, sizeof(struct timerequest))))
			{
				if (!OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest *)data->dd_EHReq, 0))
				{
					TimerBase = (struct Library *)data->dd_EHReq->tr_node.io_Device;
					return ((ULONG)obj);
				}
				DeleteIORequest(data->dd_EHReq);
			}
			DeleteMsgPort(data->dd_EHPort);
		}*/
		
      set(obj, MUIA_FillArea, FALSE);
		return ((ULONG)obj);
	}
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mDispose(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);
	
	/*if (data->dd_EHReq) {
		if (data->dd_EHReq->tr_node.io_Device) {
			CloseDevice((struct IORequest *)data->dd_EHReq);
		}
		DeleteIORequest(data->dd_EHReq);
	}
	if (data->dd_EHPort)
		DeleteMsgPort(data->dd_EHPort);
   */

	if (data->dd_Vectors)
		FreeVec(data->dd_Vectors);

   return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mSet(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);
   struct TagItem *tags, *tag;

	for ((tags = ((struct opSet *)msg)->ops_AttrList); (tag = NextTagItem(&tags));)
	{
		switch (tag->ti_Tag)
		{
			case MUIA_Parent:
				data->obj_parent = (Object *)tag->ti_Data;
				break;
			case MUIA_Display_MainData: {
				struct DosEnvec *de;
				
            data->dd_MainData = (struct MCC_Main_Data *)tag->ti_Data;
				data->dd_Params = data->dd_MainData->md_ApplicationData->ad_Params;
				
            de = &data->dd_Params->p_DosEnvec;

				if (de->de_LowCyl != de->de_HighCyl)
					data->dd_Cylinders = de->de_HighCyl - de->de_LowCyl + 1;
				else
					data->dd_Cylinders = 100ul;

				if (de->de_SectorPerBlock == 1 && de->de_BlocksPerTrack > 1)
					data->dd_Tracks = de->de_BlocksPerTrack;
				else if (de->de_SectorPerBlock > 1 && de->de_BlocksPerTrack == 1)
					data->dd_Tracks = de->de_SectorPerBlock;
				else
					data->dd_Tracks = 1ul;

				data->dd_CylinderFract = GetFraction(data->dd_Cylinders);
				data->dd_TrackFract = GetFraction(data->dd_Tracks);
            break;
			}
			/*case MUIA_Display_Sleep: {
				if (tag->ti_Data)
					DoMethod(_win(obj), MUIM_Window_RemEventHandler, &data->dd_EHNode);
				else
					DoMethod(_win(obj), MUIM_Window_AddEventHandler, &data->dd_EHNode);
				break;
			}*/
		}
	}

	return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mSetup(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);

	if (!DoSuperMethodA(cl, obj, msg))
		return FALSE;

	data->dd_EHNode.ehn_Object	= obj;
	data->dd_EHNode.ehn_Class	= cl;
	data->dd_EHNode.ehn_Events = IDCMP_RAWKEY;
	DoMethod(_win(obj), MUIM_Window_AddEventHandler, &data->dd_EHNode);

	/*data->dd_IHNode.ihn_Object  = obj;
	data->dd_IHNode.ihn_Millis  = 1000;
	data->dd_IHNode.ihn_Method  = MUIM_Display_Trigger;
	data->dd_IHNode.ihn_Flags   = MUIIHNF_TIMER;
	DoMethod(_app(obj), MUIM_Application_AddInputHandler, &data->dd_IHNode);

	data->dd_EHReq->tr_node.io_Command = TR_ADDREQUEST;
	data->dd_EHReq->tr_time.tv_secs    = 1;
	data->dd_EHReq->tr_time.tv_micro   = 0;
	SendIO((struct IORequest *)data->dd_EHReq);
   */
	return TRUE;
}

static ULONG mCleanup(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);

	DoMethod(_win(obj), MUIM_Window_RemEventHandler, &data->dd_EHNode);
	/*DoMethod(_app(obj), MUIM_Application_RemInputHandler, &data->dd_IHNode);

   if (!CheckIO((struct IORequest *)data->dd_EHReq))
		AbortIO((struct IORequest *)data->dd_EHReq);
   WaitIO((struct IORequest *)data->dd_EHReq);
	*/
   return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mShow(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);
	struct RastPort *rp = _rp(obj);

	if (!rp->TmpRas) {
		data->dd_RasterWidth = (LONG)max(rp->Layer->Width, _width(obj));
		data->dd_RasterHeight = (LONG)max(rp->Layer->Height, _height(obj));

		//kprintf("mShow() tmpras  w %ld, h %ld\n", data->dd_RasterWidth, data->dd_RasterHeight);

		if (!(data->dd_Raster = AllocRaster(data->dd_RasterWidth, data->dd_RasterHeight)))
			return FALSE;

		rp->TmpRas = InitTmpRas(&data->dd_TmpRas, data->dd_Raster, RASSIZE(data->dd_RasterWidth, data->dd_RasterHeight));
	}
	if (!rp->AreaInfo) {
		InitArea(&data->dd_AreaInfo, data->dd_Vectors, data->dd_VectorsMax);
		rp->AreaInfo = &data->dd_AreaInfo;
   }

	clrf(data->dd_Flags, DDF_ICONIFIED);
   return TRUE;
}

static ULONG mHide(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);
	struct RastPort *rp = _rp(obj);

	//kprintf("mHide() tmpras  w %ld, h %ld\n", data->dd_RasterWidth, data->dd_RasterHeight);

	if (rp->TmpRas && data->dd_Raster) {
		FreeRaster(data->dd_Raster, data->dd_RasterWidth, data->dd_RasterHeight);
		rp->TmpRas = NULL;
      data->dd_Raster = NULL;
	}
	if (rp->AreaInfo)
		rp->AreaInfo = NULL;
	
	setf(data->dd_Flags, DDF_ICONIFIED);
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mAskMinMax(struct IClass *cl, Object *obj, struct MUIP_AskMinMax *msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);
	struct MUI_MinMaxDefCur *mmdc = &data->dd_MinMaxDefCur;
	struct MUI_MinMax *mm;
	ULONG rc;

	rc = DoSuperMethodA(cl, obj, msg);
	mm = msg->MinMaxInfo;

	mm->MinWidth  += mmdc->MinWidth;
	mm->MinHeight += mmdc->MinHeight;
	mm->MaxWidth  += mmdc->MaxWidth;
	mm->MaxHeight += mmdc->MaxHeight;
	mm->DefWidth  += mmdc->DefWidth;
	mm->DefHeight += mmdc->DefHeight;

	return rc;
}

//------------------------------------------------------------------------------

static ULONG mDraw(struct IClass *cl, Object *obj, struct MUIP_Draw *msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);

	DoSuperMethodA(cl, obj, (Msg)msg);

	if (issetf(data->dd_Flags, DDF_ICONIFIED))
		return 0;
	
   if (data->dd_Params) {
		if (issetf(data->dd_Flags, DDF_FIRST)) {
			DrawAll(data, MADF_DRAWOBJECT);
			clrf(data->dd_Flags, DDF_FIRST);
		} else
			DrawAll(data, msg->flags);
	} else
		DrawBackground(data);
		
	UpdateTitle(data);
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mHandleEvent(struct IClass *cl, Object *obj, struct MUIP_HandleEvent *msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);

	if (msg->imsg) {
		ULONG iclass = msg->imsg->Class;
		UWORD code = msg->imsg->Code;

		//data->dd_MousePos[0] = (LONG)msg->imsg->MouseX;
		//data->dd_MousePos[1] = (LONG)msg->imsg->MouseY;

		switch (iclass)
      {
			case IDCMP_RAWKEY:
			{
				switch (code) {
					case RAWKEY_ESCAPE:
						DoMethod(_app(obj), MUIM_Application_PushMethod, _app(obj), 1, MUIM_Application_Project_Iconify);
						break;
					case RAWKEY_KP_PLUS:
					{
						ULONG newscale = (ULONG)min(data->dd_Scale + 1, MUI_MAXMAX / FACTOR);

						if (data->dd_Scale != newscale) {
							data->dd_Scale = newscale;
                     data->dd_MinMaxDefCur.CurWidth  = (WORD)(FACTOR * data->dd_Scale);
							data->dd_MinMaxDefCur.CurHeight = (WORD)(FACTOR * data->dd_Scale);
							UpdateSize(data);
						}
                  break;
					}
					case RAWKEY_KP_MINUS:
					{
						ULONG newscale = (ULONG)max(data->dd_Scale - 1, 1);

						if (data->dd_Scale != newscale) {
							data->dd_Scale = newscale;
							data->dd_MinMaxDefCur.CurWidth  = (WORD)(FACTOR * data->dd_Scale);
							data->dd_MinMaxDefCur.CurHeight = (WORD)(FACTOR * data->dd_Scale);
							UpdateSize(data);
						}
						break;
					}
				}
				break;
			}
			
         /*just for later usage, maybe :) */
			
         /*case IDCMP_MOUSEMOVE:
			{
				if (_isinobject(data->dd_MousePos[0], data->dd_MousePos[1])) {
					data->dd_MousePos[0] -= _mleft(obj);
					data->dd_MousePos[1] -= _mtop(obj);

					//kprintf("x %3ld, y %3ld\n",data->dd_MousePos[0], data->dd_MousePos[1]);
				}
				break;
         }
			case IDCMP_MOUSEBUTTONS:
			{
				if (_isinobject(data->dd_MousePos[X], data->dd_MousePos[Y])) {
					data->dd_MousePos[X] -= _mleft(obj);
					data->dd_MousePos[Y] -= _mtop(obj);

					switch (msg->imsg->Code) {
						case SELECTDOWN:
							break;
						case SELECTUP:
							break;
						case MENUDOWN:
							break;
						default:
                     break;
					}
				}
				break;
			}*/
		}
	}

	return (DoSuperMethodA(cl, obj, (Msg)msg));
}

//------------------------------------------------------------------------------

static ULONG mTrigger(struct IClass *cl, Object *obj, Msg msg)
{
   MUI_Redraw(obj, MADF_DRAWOBJECT);
   return 0;
}

//------------------------------------------------------------------------------

#define RWB_MIN 		0.1f
#define RWB_MAX 		2.0f
#define RWB_STEP 		0.1f

static ULONG mUpdate(struct IClass *cl, Object *obj, struct MUIP_Display_Update *msg)
{
	struct MCC_Display_Data *data = INST_DATA(cl, obj);
	Control *control = data->dd_Control;
	Entry *entry = NULL;
	DILPlugin *p;
	BOOL found = FALSE;

   data->dd_Plugin = p = msg->Plugin;

	DoSuperMethodA(cl, obj, (Msg)msg);

	ForeachNode(&control->c_List, entry) {
		if (entry->e_BlockOffset == p->p_Block && entry->e_BlockCount == p->p_Blocks) {
			found = TRUE; break;
		}
	}
	
   if (found) {
		if (issetf(p->p_Flags, DILF_READ)) {
			entry->e_RAC++;
			entry->e_LA = 1;
		} else if (issetf(p->p_Flags, DILF_WRITE)) {
			entry->e_WAC++;
			entry->e_LA = 2;
		}
		control->c_AccessCountMax = max(control->c_AccessCountMax, max(entry->e_RAC, entry->e_WAC));
   } else {
		if (control->c_ListEntries + 1 > control->c_Settings.s_CacheMaxLength) {
			if ((entry = (Entry *)GetHead(&control->c_List))) {
            _Remove(&entry->e_Node);
            FreeVP(control, entry);
				control->c_ListEntries--;
			}
      }
		if ((entry = AllocVP(control, sizeof(Entry)))) {
			entry->e_BlockOffset = p->p_Block;
			entry->e_BlockCount = p->p_Blocks;
			if (issetf(p->p_Flags, DILF_READ)) {
				entry->e_RAC = 1ul;
				entry->e_LA = 1;
			} else if (issetf(p->p_Flags, DILF_WRITE)) {
				entry->e_WAC = 1ul;
				entry->e_LA = 2;
			}
         _AddTail(&control->c_List, &entry->e_Node);
			control->c_ListEntries++;
			
			setf(control->c_Flags, CF_NEEDSAVE);
		}
	}
	
   if (isclrf(data->dd_Flags, DDF_ICONIFIED)) {
		MUI_Redraw(obj, MADF_DRAWUPDATE);
      UpdateSize(data);
   }
   return 0;
}

//------------------------------------------------------------------------------

MCC_DISPATCHER(dpDisplay)
{
	if (msg) switch (msg->MethodID) {
		case OM_NEW 					: return (mNew(cl, obj, (APTR)msg));
		case OM_DISPOSE 				: return (mDispose(cl, obj, (APTR)msg));
		case OM_SET 					: return (mSet(cl, obj, (APTR)msg));
		case MUIM_Setup 				: return (mSetup(cl, obj, (APTR)msg));
		case MUIM_Cleanup 			: return (mCleanup(cl, obj, (APTR)msg));
		case MUIM_Show 				: return (mShow(cl, obj, (APTR)msg));
		case MUIM_Hide 				: return (mHide(cl, obj, (APTR)msg));
		case MUIM_AskMinMax 			: return (mAskMinMax(cl, obj, (APTR)msg));
		case MUIM_Draw 				: return (mDraw(cl, obj, (APTR)msg));
		case MUIM_HandleEvent 	   : return (mHandleEvent(cl, obj, (APTR)msg));
		case MUIM_Display_Trigger  : return (mTrigger(cl, obj, (APTR)msg));
		case MUIM_Display_Update	: return (mUpdate(cl, obj, (APTR)msg));
	}
	return (DoSuperMethodA(cl, obj, msg));
}
MCC_DISPATCHER_END

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

static void UpdateTitle(struct MCC_Display_Data *data)
{
	Control *control = data->dd_Control;

   if (data->dd_Params) {
		struct DosEnvec *de = &data->dd_Params->p_DosEnvec;
		UQUAD bytes = (UQUAD)(de->de_SizeBlock << 2) * (UQUAD)GetNumBlocks(de);

		SetTitle(data->obj_self, "DIL "NAME_LONG
			" · device %s, cyls %lu, heads %lu, tracks %lu, size %s · memusage %lu bytes, listlength %lu/%lu, scale %lu",
			data->dd_Params->p_DosNameString,
			GetNumCyls(de),
			de->de_Surfaces,
			de->de_BlocksPerTrack,
			Size2String(bytes),
			control->c_PoolUsage,
			control->c_ListEntries,
			control->c_Settings.s_CacheMaxLength,
			data->dd_Scale
		);
	} else {
		SetTitle(data->obj_self, "DIL "NAME_LONG
			" · memusage %lu bytes, listlength %lu/%lu, scale %lu",
			control->c_PoolUsage,
			control->c_ListEntries,
			control->c_Settings.s_CacheMaxLength,
			data->dd_Scale
		);
	}
}

static void UpdateSize(struct MCC_Display_Data *data)
{
	if (data->dd_MainData) {
		struct MUI_MinMaxDefCur *mmdc = &data->dd_MinMaxDefCur;

      if (mmdc->MinWidth != mmdc->CurWidth || mmdc->MinHeight != mmdc->CurHeight) {
			mmdc->MinWidth = mmdc->CurWidth;
			mmdc->MinHeight = mmdc->CurHeight;

         //calls MUIM_Draw method!
			if (DoMethod(data->dd_MainData->obj_group_display, MUIM_Group_InitChange))
				DoMethod(data->dd_MainData->obj_group_display, MUIM_Group_ExitChange);
		}
	}
}

//------------------------------------------------------------------------------

static ULONG GetFraction(ULONG val)
{
	ULONG fract;
                          if (val <=       100) fract = 1;
	else if (val >      100 && val <=      1000) fract = 10;
	else if (val >     1000 && val <=     10000) fract = 100;
	else if (val >    10000 && val <=    100000) fract = 1000;
	else if (val >   100000 && val <=   1000000) fract = 10000;
	else if (val >  1000000 && val <=  10000000) fract = 100000;
	else if (val > 10000000 && val <= 100000000) fract = 1000000;
	else fract = 10000000;

	return fract;
}

//------------------------------------------------------------------------------

static void DrawCyls(Control *control, struct RastPort *rp, LONG cx, LONG cy, ULONG radius)
{
	register DOUBLE r = (DOUBLE)radius;
	register LONG i, x, y;

	x = cx + (LONG)(control->c_SinTable[0] * r);
	y = cy + (LONG)(control->c_CosTable[0] * r);
	Move(rp, x, y);

	for (i = 1l; i <= DEG_360; i++) {
		x = cx + (LONG)(control->c_SinTable[i] * r);
		y = cy + (LONG)(control->c_CosTable[i] * r);
      Draw(rp, x, y);
	}
}

static void DrawTracks(struct RastPort *rp, LONG cx, LONG cy, ULONG inrad, ULONG outrad, ULONG parts)
{
	register DOUBLE degrees = (DOUBLE)DEG_360;
	register DOUBLE r1 = (DOUBLE)inrad;
	register DOUBLE r2 = (DOUBLE)outrad;
	register DOUBLE i, hdg, step, rad;
	register LONG x, y;
	
	while	((DOUBLE)parts >= degrees)
		degrees *= 2.0;

	hdg = degrees / 2.0f;
	step = degrees / (DOUBLE)parts;

	for (i = hdg; i >= -hdg; i -= step) {
		rad = i * PI / hdg;
		
      x = cx + (LONG)(sin(rad) * r1);
		y = cy + (LONG)(cos(rad) * r1);
		Move(rp, x, y);
		
      x = cx + (LONG)(sin(rad) * r2);
		y = cy + (LONG)(cos(rad) * r2);
      Draw(rp, x, y);
	}
}

static void DrawBlock(struct RastPort *rp, LONG cx, LONG cy, ULONG radius1, ULONG radius2, ULONG part, ULONG parts, ULONG maxparts)
{
	register DOUBLE degrees = (DOUBLE)DEG_360;
	register DOUBLE r1 = (DOUBLE)radius1;
	register DOUBLE r2 = (DOUBLE)radius2;
	register DOUBLE hdg, step, i, u, v, w, rad;
	register LONG x, y;

	while	((DOUBLE)maxparts >= degrees)
		degrees *= 2.0;

	hdg = degrees / 2.0f;
	step = degrees / (DOUBLE)maxparts;

	u = hdg - step * (DOUBLE)(part - 1);
	v = step * (DOUBLE)parts;
	w = v / 10.0; //the more, the finer
	
	rad = u * PI / hdg;
	x = cx + (LONG)(sin(rad) * r1);
	y = cy + (LONG)(cos(rad) * r1);
	AreaMove(rp, x, y);

	for (i = u-w; i >= u-v+w; i -= w) {
		rad = i * PI / hdg;
		x = cx + (LONG)(sin(rad) * r1);
		y = cy + (LONG)(cos(rad) * r1);
		AreaDraw(rp, x, y);
	}
	
	rad = (u-v) * PI / hdg;
	x = cx + (LONG)(sin(rad) * r1);
	y = cy + (LONG)(cos(rad) * r1);
   AreaDraw(rp, x, y);

	rad = (u-v) * PI / hdg;
	x = cx + (LONG)(sin(rad) * r2);
	y = cy + (LONG)(cos(rad) * r2);
   AreaDraw(rp, x, y);

	for (i = u-v+w; i <= u-w; i += w) {
		rad = i * PI / hdg;
		x = cx + (LONG)(sin(rad) * r2);
		y = cy + (LONG)(cos(rad) * r2);
		AreaDraw(rp, x, y);
	}

	rad = u * PI / hdg;
	x = cx + (LONG)(sin(rad) * r2);
	y = cy + (LONG)(cos(rad) * r2);
   AreaDraw(rp, x, y);

	AreaEnd(rp);
}

//------------------------------------------------------------------------------

static void DrawBackground(struct MCC_Display_Data *data)
{
	Object *obj = data->obj_self;
	
	SetRPAttrs(_rp(obj),
		RPTAG_DrMd, JAM1,
		RPTAG_PenMode, FALSE,
		RPTAG_FgColor, COL_BG,
		RPTAG_BgColor, 0ul,
	TAG_DONE);
	
	//DoMethod(obj, MUIM_DrawBackground, l, t, r-l, b-t, 0l, 0l, 0l); //mui method

   RectFill(_rp(obj), (LONG)_mleft(obj), (LONG)_mtop(obj), (LONG)_mright(obj), (LONG)_mbottom(obj));
}

//------------------------------------------------------------------------------

static void DrawDisk(struct MCC_Display_Data *data)
{
	Control *control = data->dd_Control;
	Object *obj = data->obj_self;
	LONG cx = _mcenterx(obj);
	LONG cy = _mcentery(obj);
	register ULONG outrad = OUTRAD;
	register ULONG inrad = INRAD;
	register DOUBLE i, step;

	SetRPAttrs(_rp(obj),
		RPTAG_FgColor, COL_DISK,
	TAG_DONE);

	//more resolution if scaled
	//data->dd_TrackFract = (ULONG)((DOUBLE)data->dd_TrackFract / (DOUBLE)data->dd_Scale);
	//data->dd_CylinderFract = (ULONG)((DOUBLE)data->dd_CylinderFract / (DOUBLE)data->dd_Scale);

	step = (DOUBLE)(outrad - inrad) / ((DOUBLE)data->dd_Cylinders / (DOUBLE)data->dd_CylinderFract);

	for (i = (DOUBLE)inrad; i <= (DOUBLE)outrad; i += step)
		DrawCyls(control, _rp(obj), cx, cy, (ULONG)i);
	DrawCyls(control, _rp(obj), cx, cy, outrad);
	
   DrawTracks(_rp(obj), cx, cy, inrad, outrad, (ULONG)((DOUBLE)data->dd_Tracks / data->dd_TrackFract));
}

//------------------------------------------------------------------------------

static void DrawEntry(struct MCC_Display_Data *data, Entry *entry)
{
	Object *obj = data->obj_self;
	struct DosEnvec *de = &data->dd_Params->p_DosEnvec;
   LONG cx = _mcenterx(obj);
	LONG cy = _mcentery(obj);
	ULONG outrad = OUTRAD;
	ULONG inrad = INRAD;
	ULONG i, color, lc, lb;
	DOUBLE step;

	if (entry->e_LA == 1) {
		//UBYTE c = (UBYTE)(255.0f / (DOUBLE)control->c_AccessCountMax * (DOUBLE)entry->e_RAC);
		color = COL_B; //MAKE_ID(0, 0, 0, c);
	} else {
		//UBYTE c = (UBYTE)(255.0f / (DOUBLE)control->c_AccessCountMax * (DOUBLE)entry->e_WAC);
		color = COL_R; //MAKE_ID(0, c, 0, 0);
	}

   SetRPAttrs(_rp(obj),
		RPTAG_PenMode, FALSE,
		RPTAG_FgColor, color,
		RPTAG_BgColor, 0ul,
	TAG_DONE);

	step = (DOUBLE)(outrad - inrad) / (DOUBLE)data->dd_Cylinders;
	lc = GetCyl(de, entry->e_BlockOffset);
	i = lb = entry->e_BlockOffset;

	while (i < entry->e_BlockOffset + entry->e_BlockCount)
	{
		ULONG cylinder, track;
		ULONG r1 = inrad, r2 = inrad;

      while (GetCyl(de, i) == lc && i < entry->e_BlockOffset + entry->e_BlockCount)
			i++;

		cylinder = GetCyl(de, lb) - de->de_LowCyl;
		track	= GetTrack(de, lb);

      if (cylinder) {
			r1 += (ULONG)(step * (DOUBLE)cylinder);
			r2 += (ULONG)(step * (DOUBLE)(cylinder+1));
		} else
			r2 += (ULONG)step;

		DrawBlock(_rp(obj), cx, cy, r1, r2, track, i-lb, data->dd_Tracks);
		
      lc++; lb = i;
	}
}

//------------------------------------------------------------------------------

static void DrawAll(struct MCC_Display_Data *data, ULONG flags)
{
	Control *control = data->dd_Control;
	
   if (flags & MADF_DRAWOBJECT) {
		Entry *entry;
		
      DrawBackground(data);
		DrawDisk(data);

      ForeachNode(&control->c_List, entry)
			DrawEntry(data, entry);
	}
	else if (flags & MADF_DRAWUPDATE) {
		Entry *entry;
		
		if ((entry = (Entry *)GetTail(&control->c_List)))
			DrawEntry(data, entry);
	}
}

//------------------------------------------------------------------------------







