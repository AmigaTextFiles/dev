/*
** This program needs at least V39 include files !
*/

#include "demo.h"

#include "gadgets/colorwheel.h"
#include "intuition/icclass.h"
#include "intuition/gadgetclass.h"


/*
** Gauge object macro to display colorwheels
** hue and saturation values.
*/

#define InfoGauge GaugeObject,\
	GaugeFrame    , \
	MUIA_Background  , MUII_BACKGROUND,\
	MUIA_Gauge_Max   , 16384,\
	MUIA_Gauge_Divide, 262144,\
	MUIA_Gauge_Horiz , TRUE,\
	End


int main(int argc,char *argv[])
{
	struct Library *ColorWheelBase;
	APTR App,Window,Wheel,Hue,Sat;
	LONG signal;

	init();

	if (!(ColorWheelBase = OpenLibrary("gadgets/colorwheel.gadget",0)))
		fail(NULL,"colorwheel boopsi gadget not available\n");

	App = ApplicationObject,
		MUIA_Application_Title      , "BoopsiDoor",
		MUIA_Application_Version    , "$VER: BoopsiDoor 7.35 (10.02.94)",
		MUIA_Application_Copyright  , "©1992/93, Stefan Stuntz",
		MUIA_Application_Author     , "Stefan Stuntz",
		MUIA_Application_Description, "Show a boopsi colorwheel with MUI.",
		MUIA_Application_Base       , "BOOPSIDOOR",

		SubWindow, Window = WindowObject,
			MUIA_Window_Title, "BoopsiDoor",
			MUIA_Window_ID   , MAKE_ID('B','O','O','P'),

			WindowContents, VGroup,

				Child, ColGroup(2),
					Child, Label("Hue:"       ), Child, Hue = InfoGauge,
					Child, Label("Saturation:"), Child, Sat = InfoGauge,
					Child, RectangleObject,MUIA_Weight,0,End, Child, ScaleObject, End,
					End,

				Child, Wheel = BoopsiObject,  /* MUI and Boopsi tags mixed */

					GroupFrame,

					MUIA_Boopsi_ClassID  , "colorwheel.gadget",

					MUIA_Boopsi_MinWidth , 30, /* boopsi objects don't know */
					MUIA_Boopsi_MinHeight, 30, /* their sizes, so we help   */

					MUIA_Boopsi_Remember , WHEEL_Saturation, /* keep important values */
					MUIA_Boopsi_Remember , WHEEL_Hue,        /* during window resize  */

					MUIA_Boopsi_TagScreen, WHEEL_Screen, /* this magic fills in */
					WHEEL_Screen         , NULL,         /* the screen pointer  */

					GA_Left     , 0,
					GA_Top      , 0, /* MUI will automatically     */
					GA_Width    , 0, /* fill in the correct values */
					GA_Height   , 0,

					ICA_TARGET  , ICTARGET_IDCMP, /* needed for notification */

					WHEEL_Saturation, 0, /* start in the center */

					End,
				End,
			End,
		End;

	if (!App)
	{
		if (ColorWheelBase) CloseLibrary(ColorWheelBase);
		fail(App,"Failed to create Application.");
	}


/*
** you can react on every boopsi notification
** event as on any other MUI attribute.
*/

	DoMethod(Wheel,MUIM_Notify,WHEEL_Hue       ,MUIV_EveryTime,Hue,4,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue);
	DoMethod(Wheel,MUIM_Notify,WHEEL_Saturation,MUIV_EveryTime,Sat,4,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue);


/*
** Simplest possible MUI main loop.
*/

	DoMethod(Window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,App,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
	set(Window,MUIA_Window_Open,TRUE);

	while (DoMethod(App,MUIM_Application_Input,&signal) != MUIV_Application_ReturnID_Quit)
		if (signal)
			Wait(signal);

	set(Window,MUIA_Window_Open,FALSE);


/*
** shut down.
*/

	if (ColorWheelBase) CloseLibrary(ColorWheelBase);
	fail(App,NULL);
}
