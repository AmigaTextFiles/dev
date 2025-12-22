#include <libraries/feelin.h>

#include <proto/exec.h>
#include <proto/feelin.h>

struct FeelinBase *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace *IFeelin;
#endif

/// Header
struct LocalObjectData
{
   FAreaPublic                     *AreaPublic;

   uint32                           micros;
   APTR                             sh;

   uint32                            index;
};

/* Some strings to display */

static const char *Cheuveux[] =
{
   "Tes cheuveux contiennent tout un rêve.",
   "Plein de voilures et de matures.",
   "Ils contiennent de grandes mers",
   "dont les moussons me portent",
   "vers le charmant climat.",
   "Où l'espace est plus bleue",
   "et plus profond.",
   "Où l'atmosphère est parfumée par les fruits,",
   "par les feuilles",
   "et par la peau humaine.",
   "Dans l'océan de ta chevelure",
   "j'entrevois un phare",
   "fourmillant de chants mélancoliques,",
   "d'hommes vigoureux de toute nation",
   "et de navrires de toutes formes.",
   "Découpant leur architecture",
   "fine et compliquée",
   "sur un ciel immense",
   "ou se prélasse l'éternelle chaleur.",
   "Laisse-moi respirer longtemps",
   "l'odeur de tes cheveux",
   "et y plonger tout mon visage.",
   "Comme un homme althéré",
   "dans l'eau d'une source",
   "et les agiter avec ma main,",
   "comme un mouchoir odorant,",
   "pour secouer les souvenirs dans l'air.",
   "Dans les caresses de ta cheuveulure,",
   "je retrouve les langueurs des longues heures",
   "passées sur un divan",
   "dans la chambre d'un beau navire.",
   "Bbercé par les roulis imperceptibles du port,",
   "entre les pots de fleurs",
   "et les gargoulettes rafraichissantes.",
   "Dans l'ardent foyer de ta cheuveulure,",
   "je respire l'odeur du tabac,",
   "mélée à l'opimum et au sucre.",
   "Dans la nuit de ta chevelure",
   "je vois resplendir",
   "l'infini de l'azur tropical.",
   "Sur les rivages duvetés de ta chevelure",
   "je m'ennivre des odeurs combinées",
   "du gondron, du musk et de l'huile de coco.",
   "Laisse moi mordre longtemps",
   "tes tresses lourdes et noires.",
   "Quand je mordille tes cheuveux",
   "élastiques et rebelles,",
   "il me semble que je mange des souvenirs.",
   NULL
};

//+

enum  {

	  FV_METHOD_TRIGGER

	  };

enum  {

	  FV_ATTRIBUTE_DELAY

	  };

///mNew
F_METHOD(uint32,mNew)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	F_SAVE_AREA_PUBLIC;

	LOD->micros = 500000;
	LOD->index = 0;

	return F_SUPERDO();
}
//+
///mSet
F_METHOD(uint32,mSet)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	struct TagItem *Tags = Msg,item;

	while (IFEELIN F_DynamicNTI(&Tags,&item,Class))
	switch (item.ti_Tag)
	{
		case FV_ATTRIBUTE_DELAY:
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
					FA_SignalHandler_Method,    F_METHOD_ID(TRIGGER),
					FA_SignalHandler_Micros,    LOD->micros,

					TAG_DONE);
			}
		}
		break;
	}

	return F_SUPERDO();
}
//+
///mSetup
F_METHOD(uint32,mSetup)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (F_SUPERDO())
	{
		LOD->sh = (APTR) IFEELIN F_Do
		(
			_area_app, FM_Application_CreateSignalHandler,

			FA_SignalHandler_Target,    Obj,
			FA_SignalHandler_Method,    F_METHOD_ID(TRIGGER),
			FA_SignalHandler_Micros,    LOD->micros,

			TAG_DONE
		);

	   return TRUE;
	}
	return FALSE;
}
//+
///mCleanup
F_METHOD(uint32,mCleanup)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (LOD->sh)
	{
		IFEELIN F_Do(_area_app, FM_Application_DeleteSignalHandler, LOD->sh);

		LOD->sh = NULL;
	}

	return F_SUPERDO();
}
//+
///mTrigger
F_METHOD(uint32,mTrigger)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	IFEELIN F_Set(Obj,FA_Text_Contents,(uint32)(Cheuveux[LOD->index]));

	if (!Cheuveux[++LOD->index])
	{
		LOD->index = 0;
	}

	return TRUE;
}
//+

/*** Attibutes and Methods *********************************************************************/

STATIC F_ATTRIBUTES_ARRAY =
{
	F_ATTRIBUTES_ADD("Delay", FV_TYPE_INTEGER),

	F_ARRAY_END
};

STATIC F_METHODS_ARRAY =
{
   F_METHODS_ADD(mTrigger, "Trigger"),

   F_METHODS_OVERRIDE_STATIC(mNew,       FM_New),
   F_METHODS_OVERRIDE_STATIC(mSet,       FM_Set),
   F_METHODS_OVERRIDE_STATIC(mSetup,     FM_Element_Setup),
   F_METHODS_OVERRIDE_STATIC(mCleanup,   FM_Element_Cleanup),

   F_ARRAY_END
};

STATIC F_TAGS_ARRAY =
{
	F_TAGS_ADD_SUPER(Text),
	F_TAGS_ADD_LOD,
	F_TAGS_ADD_ATTRIBUTES,
	F_TAGS_ADD_METHODS,

	F_ARRAY_END
};

/*** main **************************************************************************************/

int main()
{
	FObject app,win,spd,my;

	if (F_FEELIN_OPEN)
	{
		FClass *cc = IFEELIN F_CreateClassA(NULL, F_TAGS_PTR);
			  
		if (cc)
		{
			app = ApplicationObject,
				FA_Application_Title,       "demo_SignalHandler",
				FA_Application_Version,     "$VER: demo_SignalHandler 1.0 (2004.05.19)",
				FA_Application_Copyright,   "©2004, Olivier LAVIALE <gofromiel@gofromiel.com>",
				FA_Application_Author,      "Olivier LAVIALE",
				FA_Application_Description, "Demonstrate the use of custom classes.",
				FA_Application_Base,        "DEMO_SHA1",

				Child, win = WindowObject,
					FA_Element_Id, "win",
					FA_Element_Persist, "width height",

					FA_Window_Title, "SignalHandler Class",
					FA_Window_Open, TRUE,
					
					Child, VGroup,
						Child, TextObject,

							FA_Element_Class, "textinfo",

							FA_Widget_SetMax, FV_Widget_SetHeight,
							FA_Widget_Chainable, FALSE,

							FA_Text_Contents, "<align=center>Demonstration of a class that reacts on<br>events (here: timer signals) automatically.",
						End,

						Child, my = IFEELIN F_NewObj(cc->Name,

							FA_Element_Class, "textinfo",

							FA_Area_Font, "big",
							FA_Widget_SetMin, FV_Widget_SetHeight,
							FA_Widget_SetMax, FV_Widget_SetNone,
							FA_Widget_Chainable, FALSE,

							FA_Text_PreParse, "<align=center>",
							FA_Text_VCenter, TRUE,
						End,

						Child, spd = IFEELIN F_MakeObj(FV_MakeObj_Slider, TRUE,5000,1000000,50000,
							FA_Element_Id, "speed",
							FA_Element_Persist, "value",
							FA_Widget_SetMax,     FV_Widget_SetHeight,
							//FA_ContextHelp,     "Adjust the number of micro seconds\nto wait between each string.",
						   "FA_Numeric_Step",   10000,
						   "FA_Numeric_Format", "Micros : %ld",
						End,
					End,
				End,
			End;

			if (app)
			{
				IFEELIN F_Do(win,FM_Notify,FA_Window_CloseRequest,TRUE,app,FM_Application_Shutdown,0);
				IFEELIN F_Do(spd,FM_Notify,"FA_Numeric_Value",FV_Notify_Always,my,FM_Set,2,"Delay",FV_Notify_Value);

				IFEELIN F_Do(app,FM_Application_Run);
				IFEELIN F_DisposeObj(app);
			}
			IFEELIN F_DeleteClass(cc);
		}
		
		F_FEELIN_CLOSE;
	}
	return 0;
}
