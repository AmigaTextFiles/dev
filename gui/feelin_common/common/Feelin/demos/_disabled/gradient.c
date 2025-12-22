/*

   Rotating gradient with XML Application
 
*/

#include <libraries/feelin.h>

#include <proto/exec.h>
#include <proto/feelin.h>

struct  FeelinBase    *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace    *IFeelin;
#endif


struct LocalObjectData
{
   FAreaPublic                     *AreaPublic;

   uint32                           micros;
   APTR                             sh;

   uint32                           angle;
   STRPTR                           sspec;
   STRPTR                           espec;
   
   FObject                          image;
};

enum  {

	  FV_ATTRIBUTE_ANGLE,
	  FV_ATTRIBUTE_SSPEC,
	  FV_ATTRIBUTE_ESPEC,
	  FV_ATTRIBUTE_MICRO

	  };

enum  {

	  FV_METHOD_UPDATE

	  };

#define SPEC_FORMAT                             "%ld° %s %s"

///mNew
F_METHOD(uint32,mNew)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	
	F_SAVE_AREA_PUBLIC;

	LOD->micros = 500000;
	
	return IFEELIN F_SuperDo(Class,Obj,Method,

		Child, LOD->image = PreviewImageObject,
			FA_Widget_Draggable,     FALSE,
			FA_Widget_Dropable,      FALSE,
			//FA_ContextHelp,   NULL,
		End,
		
		F_ATTRIBUTE_ID(ANGLE),   0,
		F_ATTRIBUTE_ID(SSPEC),   "black",
		F_ATTRIBUTE_ID(ESPEC),   "white",

	TAG_MORE,Msg);
}
//+
///mDispose
F_METHOD(void, mDispose)
{
	struct LocalObjectData *LOD = F_LOD(Class, Obj);
 
	IFEELIN F_Dispose(LOD->sspec); LOD->sspec = NULL;
	IFEELIN F_Dispose(LOD->espec); LOD->espec = NULL;
	
	F_SUPERDO();
}
//+
///mSet
F_METHOD(void,mSet)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	struct TagItem *Tags = Msg,item;

	bool32 update = FALSE;
	
	while (IFEELIN F_DynamicNTI(&Tags,&item,Class))
	switch (item.ti_Tag)
	{
		case FV_ATTRIBUTE_ANGLE:
		{
			update = TRUE;
			
			LOD->angle = item.ti_Data;
		}
		break;
		
		case FV_ATTRIBUTE_SSPEC:
		{
			update = TRUE;
			
			IFEELIN F_Dispose(LOD->sspec);
			LOD->sspec = IFEELIN F_StrNew(NULL, "%s", item.ti_Data);
		}
		break;
		
		case FV_ATTRIBUTE_ESPEC:
		{
			update = TRUE;
			
			IFEELIN F_Dispose(LOD->espec);
			LOD->espec = IFEELIN F_StrNew(NULL, "%s", item.ti_Data);
		}
		break;
		
		case FV_ATTRIBUTE_MICRO:
		{
			LOD->micros = item.ti_Data;

			if (_area_render)
			{
				if (LOD->sh)
				{
					IFEELIN F_Do(_area_app, FM_Application_DeleteSignalHandler, LOD->sh);
				}

				LOD->sh = (APTR) IFEELIN F_Do(_area_app, FM_Application_CreateSignalHandler,

					FA_SignalHandler_Target,    Obj,
					FA_SignalHandler_Method,    F_METHOD_ID(UPDATE),
					FA_SignalHandler_Micros,    LOD->micros,

					TAG_DONE);
			}
		}
		break;
	}

	F_SUPERDO();
	
	if (update)
	{
		IFEELIN F_Do(LOD->image,FM_SetAs,FV_SetAs_String,"FA_Preview_Spec",SPEC_FORMAT,LOD->angle,LOD->sspec,LOD->espec);
	}
}
//+
/// mShow
F_METHOD(bool32,mShow)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	/* It's better to add signal handlers in the FM_Area_Show method because the
	object  may  be  hidden  at any time and even if it won't be able to be
	drawn it's a waste of time (CPU time) to leave it active. */

	if (F_SUPERDO())
	{
		LOD->sh = (APTR) IFEELIN F_Do(_area_app, FM_Application_CreateSignalHandler,

			 FA_SignalHandler_Target,    Obj,
			 FA_SignalHandler_Method,    F_METHOD_ID(UPDATE),
			 FA_SignalHandler_Micros,    LOD->micros,

			 TAG_DONE);

		return TRUE;
	}
	return FALSE;
}
//+
/// mHide
F_METHOD(void,mHide)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (LOD->sh)
	{
		IFEELIN F_Do(_area_app, FM_Application_DeleteSignalHandler, LOD->sh);

		LOD->sh = NULL;
	}

	F_SUPERDO();
}
//+
///mUpdate
F_METHOD(uint32,mUpdate)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (LOD->angle == 359)
	{
		LOD->angle = 0;
	}
	else
	{
		LOD->angle++;
	}
  
	IFEELIN F_Do(LOD->image,FM_SetAs,FV_SetAs_String,"FA_Preview_Spec",SPEC_FORMAT,LOD->angle,LOD->sspec,LOD->espec);
	
	return TRUE;
}
//+

STATIC F_METHODS_ARRAY =
{
	F_METHODS_ADD(mUpdate, "Update"),

	F_METHODS_OVERRIDE_STATIC(mNew,      FM_New),
	F_METHODS_OVERRIDE_STATIC(mDispose,  FM_Dispose),
	F_METHODS_OVERRIDE_STATIC(mSet,      FM_Set),
	F_METHODS_OVERRIDE_STATIC(mShow,     FM_Area_Show),
	F_METHODS_OVERRIDE_STATIC(mHide,     FM_Area_Hide),

	F_ARRAY_END
};

STATIC F_ATTRIBUTES_ARRAY =
{
	F_ATTRIBUTES_ADD("Angle", FV_TYPE_INTEGER),
	F_ATTRIBUTES_ADD("SSpec", FV_TYPE_STRING),
	F_ATTRIBUTES_ADD("ESpec", FV_TYPE_STRING),
	F_ATTRIBUTES_ADD("Micro", FV_TYPE_INTEGER),

	F_ARRAY_END
};

STATIC F_TAGS_ARRAY =
{
	F_TAGS_ADD_SUPER(Group),
	F_TAGS_ADD_LOD,
	F_TAGS_ADD_ATTRIBUTES,
	F_TAGS_ADD_METHODS,

	F_ARRAY_END
};

/// Main
int main()
{
	if (F_FEELIN_OPEN)
	{

		FClass *cc = IFEELIN F_CreateClassA(NULL, F_TAGS_PTR);
		
		if (cc)
		{
			FObject app;
			
			STATIC F_ENTITIES_ARRAY =
			{
				F_ENTITIES_ADD_EMPTY("class:gradient"),
				
				F_ARRAY_END
			};
			
			F_ENTITIES_SET(0, cc->Name);
 
			app = XMLApplicationObject,

			   "Source", "gradient.xml",
			   "SourceType", FV_Document_SourceType_File,
			   "Entities", F_ENTITIES_PTR,
			   
				End;
			
			if (app)
			{
				IFEELIN F_Do(app, (uint32) "Run");
				IFEELIN F_DisposeObj(app);
			}

			IFEELIN F_DeleteClass(cc);
		}
		
		F_FEELIN_CLOSE;
	}
	return 0;
}
//+
