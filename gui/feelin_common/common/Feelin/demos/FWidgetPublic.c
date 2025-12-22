/*
	WidgetPublicData

	2000-2006 © Olivier LAVIALE <gofromiel@gofromiel.com>

*/

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/feelin.h>

#include <libraries/feelin.h>

struct FeelinBase *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace                 *IFeelin;
#endif

struct LocalObjectData
{
	F_MEMBER_WIDGET_PUBLIC;
};

///mNew
F_METHOD(uint32,mNew)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	F_SAVE_WIDGET_PUBLIC;

	return F_SUPERDO();
}
//+
/// mDraw
F_METHOD(uint32,mDraw)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	IFEELIN F_Log
	(
		FV_LOG_USER,

		"widget is: %s, %s, %s, %s",

		_widget_is_selected ? "selected" : "not selected",
		_widget_is_pressed ? "pressed" : "not pressed",
		_widget_is_active ? "active" : "not active",
		_widget_is_disabled ? "disabled" : "not disabled"
	);

	return F_SUPERDO();
}
//+

/// Main
int main(void)
{
	STATIC F_METHODS_ARRAY =
	{
		F_METHODS_OVERRIDE_STATIC(mNew, FM_New),
		F_METHODS_OVERRIDE_STATIC(mDraw, FM_Area_Draw),

		F_ARRAY_END
	};
	
	STATIC F_TAGS_ARRAY =
	{
		F_TAGS_ADD_SUPER(Text),
		F_TAGS_ADD_LOD,
		F_TAGS_ADD_METHODS,
		
		F_ARRAY_END
	};

	if (F_FEELIN_OPEN)
	{
		FClass *cc = IFEELIN F_CreateClassA(NULL,F_TAGS_PTR);

		if (cc != NULL)
		{
			FObject app, win, play_1, play_2, disable_1, disable_2;

			app = AppObject,
				Child, win = WindowObject,
					FA_Window_Title, "FWidgetPublic",
					FA_Window_Open, TRUE,

					Child, VGroup,
						Child, play_1 = IFEELIN F_NewObj(cc->Name,
							
							FA_Element_Class,       "button",
							FA_Widget_SetMax,       FV_Widget_SetHeight,
							#ifdef F_NEW_WIDGET_MODE
							FA_Widget_Mode,         FV_Widget_Mode_Button,
							#else
							FA_Widget_Mode,         FV_Widget_Mode_Release,
							#endif
							FA_Text_Contents,       "let's play !",
							FA_Text_PreParse,       "<align=center>",

						End,
						
						Child, play_2 = IFEELIN F_NewObj(cc->Name,

							FA_Element_Class,       "button",
							FA_Widget_SetMax,       FV_Widget_SetHeight,
							#ifdef F_NEW_WIDGET_MODE
							FA_Widget_Mode,         FV_Widget_Mode_Button,
							#else
							FA_Widget_Mode,         FV_Widget_Mode_Release,
							#endif
							FA_Text_Contents,       "let's play !",
							FA_Text_PreParse,       "<align=center>",

						End,

						Child, RowGroup(2), FA_Element_Class, "box",

							Child, HLabel("enabled first:"),
							Child, disable_1 = Checkbox(TRUE),
							Child, HLabel("enabled second:"),
							Child, disable_2 = Checkbox(TRUE),

						End,
					End,
				End,
			End;

			if (app != NULL)
			{
				IFEELIN F_Do(win,FM_Notify, FA_Window_CloseRequest,TRUE, app,FM_Application_Shutdown,0);
				IFEELIN F_Do(disable_1, FM_Notify, FA_Widget_Selected, FV_Notify_Always, play_1, FM_Set, 2, FA_Widget_Disabled, FV_Notify_Toggle);
				IFEELIN F_Do(disable_2, FM_Notify, FA_Widget_Selected, FV_Notify_Always, play_2, FM_Set, 2, FA_Widget_Disabled, FV_Notify_Toggle);

				IFEELIN F_Do(app,FM_Application_Run);
				IFEELIN F_DisposeObj(app);
			}

			IFEELIN F_DeleteClass(cc);
		}
		else
		{
			IDOS_ Printf("Could not create custom class.\n");
		}
		
		F_FEELIN_CLOSE;
	}
	else
	{
		IDOS_ Printf("Failed to open feelin.library\n");
	}
	
	return 0;
}
//+
