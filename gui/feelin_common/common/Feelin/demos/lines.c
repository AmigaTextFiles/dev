/*
   
   Lines Demo © 2000-2006 by Olivier LAVIALE <gofromiel@gofromiel.com>

*/

///Header

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/feelin.h>

#include <libraries/feelin.h>
#include <feelin/xmlapplication.h>

struct FeelinBase                  *FeelinBase;

#ifdef __amigaos4__

struct FeelinIFace                 *IFeelin;

#else

#define GfxBase                     FeelinBase->Graphics

#endif

enum    {

		FV_ATTRIBUTE_CYCLE,
		FV_ATTRIBUTE_TRAIL,
		FV_ATTRIBUTE_MICRO

		};

enum    {

		FV_METHOD_UPDATE

		};


struct LocalObjectData
{
	F_MEMBER_AREA_PUBLIC;

	uint32                          micros;
	APTR                            signal_handler;

	int16                           x[2],y[2];
	int16                           xd[2],yd[2];
	APTR                            ox[2],oy[2];
	uint32                          j;
	uint32                          Pen;        // FV_Pen_Xxx
	uint8                           Cycle;
	uint8                           CycleDone;
	int8                            CycleWay;
	uint8                           Line;       // Line to draw (or beeing drawn)
	int8                            k;
	uint8                           Trail;
	APTR                            TrailData;
};

long rand(void);

#define MyLine                                  IFEELIN F_NewObj(cc->Name,TAG_DONE)

//+

///ModifyTrail
APTR ModifyTrail(FClass *Class, FObject Obj, uint8 Trail)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	LOD->Trail = 0;

	if (LOD->TrailData)
	{
		LOD->ox[0] = 0; LOD->ox[1] = 0; // Reset coordinates
		LOD->oy[0] = 0; LOD->oy[1] = 0; // Reset coordinates

		IFEELIN F_Dispose(LOD->TrailData);
	}
		
	LOD->TrailData = IFEELIN F_New(sizeof (int16) * 4 * Trail);
	
	if (LOD->TrailData)
	{
	   LOD->ox[0] = LOD->TrailData;
	   LOD->ox[1] = (APTR)((uint32)(LOD->ox[0]) + sizeof (int16) * Trail);
	   LOD->oy[0] = (APTR)((uint32)(LOD->ox[1]) + sizeof (int16) * Trail);
	   LOD->oy[1] = (APTR)((uint32)(LOD->oy[0]) + sizeof (int16) * Trail);
	}

	LOD->Trail = Trail;

	return LOD->TrailData;
}
//+
///add_signal_handler
APTR add_signal_handler(FClass *Class, FObject Obj)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (_area_render)
	{
		if (LOD->signal_handler)
		{
			IFEELIN F_Do(_area_app, FM_Application_DeleteSignalHandler, LOD->signal_handler);
		}

		LOD->signal_handler = (APTR) IFEELIN F_Do
		(
			_area_app, FM_Application_CreateSignalHandler,

			FA_SignalHandler_Target,    Obj,
			FA_SignalHandler_Method,    F_METHOD_ID(UPDATE),
			FA_SignalHandler_Micros,    LOD->micros,

			TAG_DONE
		);
	}

	return LOD->signal_handler;
}
//+

/// mNew
F_METHOD(FObject,mNew)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	F_SAVE_AREA_PUBLIC;

	LOD->Cycle = 1;
	LOD->Trail = 8;
	LOD->micros = 10000;

	if (IFEELIN F_SuperDo(Class,Obj,Method,

		FA_Element_Class, "gauge",
		FA_Element_Style, "background: dark;",

		FA_Widget_Chainable, FALSE,

		TAG_MORE, Msg))
	{
		if (!LOD->TrailData)
		{
			ModifyTrail(Class,Obj,LOD->Trail);
		}

		if (LOD->TrailData)
		{
			return Obj;
		}
	}
	return NULL;
}
//+
///mDispose
F_METHOD(void,mDispose)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (LOD->TrailData != NULL)
	{
		IFEELIN F_Dispose(LOD->TrailData);

		LOD->TrailData = NULL;
	}

	F_SUPERDO();
}
//+
///mSet
F_METHOD(void,mSet)
{
	struct LocalObjectData *LOD  = F_LOD(Class,Obj);
	struct TagItem *Tags = Msg,item;

	while (IFEELIN F_DynamicNTI(&Tags,&item,Class))
	switch (item.ti_Tag)
	{
		case FV_ATTRIBUTE_CYCLE:
		{
			LOD->Cycle = item.ti_Data;
			LOD->Pen = LOD->Cycle ? FV_Pen_Shine : FV_Pen_Highlight;
		}
		break;

		case FV_ATTRIBUTE_TRAIL:
		{
			if (_area_is_drawable)
			{
				IFEELIN F_Set(_area_render,FA_Render_Forbid,TRUE);

				ModifyTrail(Class,Obj,item.ti_Data);

				IFEELIN F_Set(_area_render,FA_Render_Forbid,FALSE);

				IFEELIN F_Draw(Obj,FF_Draw_Object);
			}
			else
			{
				ModifyTrail(Class,Obj,item.ti_Data);
			}
		}
		break;

		case FV_ATTRIBUTE_MICRO:
		{
			LOD->micros = item.ti_Data;

			add_signal_handler(Class,Obj);
		}
		break;
	}

	F_SUPERDO();
}
//+
/// mShow
F_METHOD(int32,mShow)
{

/* It's better to add signal handlers in the  FM_Area_Show  method  because  the
object  may  be hidden at any time and even if it won't be able to be drawn
it's a waste of time (CPU time) to leave it active. */

	if (F_SUPERDO())
	{
		add_signal_handler(Class,Obj);

		return TRUE;
	}
	return FALSE;
}
//+
/// mHide
F_METHOD(uint32,mHide)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (LOD->signal_handler)
	{
		IFEELIN F_Do(_area_app, FM_Application_DeleteSignalHandler, LOD->signal_handler);

		LOD->signal_handler = NULL;
	}

	return F_SUPERDO();
}
//+
/// mAskMinMax

/* AskMinMax method will be called before the window is opened  and  before
layout  takes place. We need to tell Feelin the minimum and maximum size of
our object. Note that we indeed need to *add* these values,  not  just  set
them ! */

F_METHOD(uint32,mAskMinMax)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	_area_minw += 30;
	_area_minh += 30;

	/* Now call our superclass. FC_Area will handle everything, taking  care
	of FA_FixedXxx, FA_MinXxx and FA_MaxXxx. */

	return F_SUPERDO();
}
//+
/// mDraw

/* Draw method is called whenever Feelin feels (obviously  ;-))  we  should
render our object. This usually happens after layout is finished. Note: You
may only render within the rectangle _area_cx, _area_cy, _area_cx2, _area_cy2. */

F_METHODM(void,mDraw,FS_Area_Draw)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	struct RastPort *rp = _area_rp;

	int16 *ox;
	int16 *oy;
	
	uint32 i;

	/* let our superclass draw itself first, Area class would e.g. draw  the
	frame and clear the whole region. What it does exactly depends on flags.
	*/

	if (FF_Draw_Object & Msg->Flags)
	{
		F_SUPERDO();
		
		/* Reset values */

		for (i = 0 ; i < 2 ; i++)
		{
			LOD-> x[i] = _area_cx + (rand() % _area_cw); if (LOD->x[i] < _area_cx) LOD->x[i] = _area_cx; else if (LOD->x[i] > _area_cx2) LOD->x[i] = _area_cx2;
			LOD-> y[i] = _area_cy + (rand() % _area_ch); if (LOD->y[i] < _area_cy) LOD->y[i] = _area_cy; else if (LOD->y[i] > _area_cy2) LOD->y[i] = _area_cy2;
			LOD->xd[i] = rand() % 10 + 1;
			LOD->yd[i] = rand() % 10 + 1;
		}

		LOD->Pen        = (LOD->Cycle) ? FV_Pen_Shine : FV_Pen_Highlight;
		LOD->j          = 0;
		LOD->CycleWay   = 1;
		LOD->CycleDone  = 0;
		LOD->Line       = 0;
	}

	if (!LOD->TrailData) return;

	if (LOD->j >= LOD->Trail - 1)
	{
		i = (LOD->Line >= LOD->Trail - 1) ? 0 : LOD->Line + 1;

		_FPen(FV_Pen_Dark);
		ox = LOD->ox[0]; oy = LOD->oy[0]; _Move(ox[i],oy[i]);
		ox = LOD->ox[1]; oy = LOD->oy[1]; _Draw(ox[i],oy[i]);
	}

	_FPen(LOD->Pen);
	_Move(LOD->x[0],LOD->y[0]);
	_Draw(LOD->x[1],LOD->y[1]);


	if (LOD->Cycle && ++LOD->CycleDone >= LOD->Cycle)
	{
		LOD->CycleDone = 0;

		if (LOD->CycleWay > 0)
		{
			if (LOD->Pen + 1 >= FV_Pen_Dark) LOD->CycleWay = -1;
		}
		else
		{
			if (LOD->Pen - 1 <= FV_Pen_Shine) LOD->CycleWay = 1;
		}

		LOD->Pen += LOD->CycleWay;
	}

	for (i = 0 ; i < 2 ; i++)
	{
		ox = LOD->ox[i]; ox[LOD->Line] = LOD->x[i];
		oy = LOD->oy[i]; oy[LOD->Line] = LOD->y[i];

		LOD->x[i] += LOD->xd[i];
		LOD->y[i] += LOD->yd[i];

		if (LOD->x[i] < _area_cx)
		{
			LOD->xd[i] = -LOD->xd[i]; LOD->x[i] = _area_cx;
		}
		else if (LOD->x[i] > _area_cx2)
		{
			LOD->xd[i] = -LOD->xd[i]; LOD->x[i] = _area_cx2;
		}

		if (LOD->y[i] < _area_cy)
		{
			LOD->yd[i] = -LOD->yd[i]; LOD->y[i] = _area_cy;
		}
		else if (LOD->y[i] > _area_cy2)
		{
			LOD->yd[i] = -LOD->yd[i]; LOD->y[i] = _area_cy2;
		}

		/* Twisting coordinates */

		if (((rand() >> 5) & 127) < 2)
		{
			if (LOD->xd[i] < 1) LOD->k = TRUE;
			LOD->xd[i] = (rand() >> 5) & 7;
			if (LOD->k) LOD->xd[i] = -LOD->xd[i];
			LOD->k = FALSE;
		}

		if (((rand() >> 5) & 255) < 50)
		{
			 if (LOD->yd[i] < 1) LOD->k = TRUE;
			 LOD->yd[i] = (rand() >> 5) & 7;
			 if (LOD->k) LOD->yd[i] = -LOD->yd[i];
			 LOD->k = FALSE;
		}
	}

	if (++LOD->Line >= LOD->Trail) LOD->Line = 0;
	LOD->j++;
}
//+
///mUpdate
F_METHOD(int32,mUpdate)
{
	IFEELIN F_Draw(Obj, FF_Draw_Update);
   
	return TRUE; // If we return FALSE the timer event won't be requested again
}
//+

/*** attributes and methods defined by the class ***********************************************/

STATIC F_ATTRIBUTES_ARRAY =
{
	F_ATTRIBUTES_ADD("Cycle", FV_TYPE_INTEGER),
	F_ATTRIBUTES_ADD("Trail", FV_TYPE_INTEGER),
	F_ATTRIBUTES_ADD("Micro", FV_TYPE_INTEGER),

	F_ARRAY_END
};

STATIC F_METHODS_ARRAY =
{
	F_METHODS_ADD(mUpdate, "Update"),

	F_METHODS_OVERRIDE_STATIC(mNew,       FM_New),
	F_METHODS_OVERRIDE_STATIC(mDispose,   FM_Dispose),
	F_METHODS_OVERRIDE_STATIC(mSet,       FM_Set),

	F_METHODS_OVERRIDE_STATIC(mShow,      FM_Area_Show),
	F_METHODS_OVERRIDE_STATIC(mHide,      FM_Area_Hide),
	F_METHODS_OVERRIDE_STATIC(mAskMinMax, FM_Area_AskMinMax),
	F_METHODS_OVERRIDE_STATIC(mDraw,      FM_Area_Draw),

	F_ARRAY_END
};

STATIC F_TAGS_ARRAY =
{
	F_TAGS_ADD_SUPER(Widget),
	F_TAGS_ADD_LOD,
	F_TAGS_ADD_METHODS,
	F_TAGS_ADD_ATTRIBUTES,
	
	F_ARRAY_END
};

/*** main ******************************************************************/

STATIC F_ENTITIES_ARRAY =
{
	F_ENTITIES_ADD("window-title", "Feelin : Lines"),
	F_ENTITIES_ADD_EMPTY("class:line"),
 
	F_ARRAY_END
};

enum    {
	
		FV_ENTITY_WINDOW_TITLE,
		FV_ENTITY_CLASS_LINE,
		FV_ENTITY_TEXT

		};

///Main
int main()
{
	if (F_FEELIN_OPEN)
	{
		/* Create the new custom class with a call to F_CreateClassA().  This
		function  returns  a  struct  FeelinClass. You must use cc->Name to
		create instance of your custom class. This Name is unique and made by
		F_CreateClassA(). */

		FClass *cc = IFEELIN F_CreateClassA(NULL,F_TAGS_PTR);
		
		if (cc)
		{
			FObject app;
			
			F_ENTITIES_SET(FV_ENTITY_CLASS_LINE, cc->Name);
			
			app = XMLApplicationObject,
				
				"Source",        "lines.xml",
				"SourceType",    FV_Document_SourceType_File,
				"Entities",     F_ENTITIES_PTR,

				End;
							 
			if (app)
			{

				FObject win, grp, ccl, trl, spd;

				#ifdef F_NEW_GETELEMENTBYID
				
				bool32 ok = TRUE;
				
				struct element_item
				{
					STRPTR Id;
					FObject *ObjectPtr;
				};

				struct element_item ar[] =
				{
					{ "win", &win },
					{ "grp", &grp },
					{ "ccl", &ccl },
					{ "trl", &trl },
					{ "spd", &spd },

					F_ARRAY_END
				};

				struct element_item *item;

				for ( item = ar ; item->Id ; item++)
				{
					FObject rc = (FObject) IFEELIN F_Do(app, FM_GetElementById, item->Id);

					if (!rc)
					{
						IFEELIN F_Log(0, "Object '%s' is missing", item->Id);

						ok = FALSE;

						continue;
					}

					*item->ObjectPtr = rc;
				}
				
				#else

				IFEELIN F_Do
				(
					app, (uint32) "GetObjects",

					"win", &win,
					"grp", &grp,
					"ccl", &ccl,
					"trl", &trl,
					"spd", &spd,

					NULL
				);

				#endif

				#ifdef F_NEW_GETELEMENTBYID
				if (ok)
				#endif
				{

				/* create notifications */
	 
				IFEELIN F_Do(win,FM_Notify,FA_Window_CloseRequest,TRUE,FV_Notify_Application,FM_Application_Shutdown,0);
				IFEELIN F_Do(ccl,FM_Notify,"Value",FV_Notify_Always,grp,FM_Set,4,cc->Attributes[FV_ATTRIBUTE_CYCLE].ID,FV_Notify_Value,FA_Group_Forward,TRUE);
				IFEELIN F_Do(trl,FM_Notify,"Value",FV_Notify_Always,grp,FM_Set,4,cc->Attributes[FV_ATTRIBUTE_TRAIL].ID,FV_Notify_Value,FA_Group_Forward,TRUE);
				IFEELIN F_Do(spd,FM_Notify,"Value",FV_Notify_Always,grp,FM_Set,4,cc->Attributes[FV_ATTRIBUTE_MICRO].ID,FV_Notify_Value,FA_Group_Forward,TRUE);
				
				/* launch the application */
	 
				IFEELIN F_Do(app, (uint32) "Run");
				}

				IFEELIN F_DisposeObj(app);
			}

			IFEELIN F_DeleteClass(cc);
		}
		else
		{
			IDOS_ Printf("Unable to create custom class.\n");
		}
		F_FEELIN_CLOSE;
	}
	else
	{
		IDOS_ Printf("Unable to open feelin.library v%ld.\n",FV_FEELIN_VERSION);
	}
	return 0;
}
//+
