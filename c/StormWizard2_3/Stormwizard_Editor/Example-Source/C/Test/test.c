#include	<stdio.h>

#include	<clib/alib_protos.h>

#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/graphics_lib.h>
#include	<pragma/utility_lib.h>
#include	<pragma/wizard_lib.h>

#include	<libraries/wizard.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>

#include	"test.h"

#include	"//wizard/wizardhooks.h"

APTR	surface;
struct Screen	*screen;
struct NewWindow *newwin;
struct Window	*window;
struct WizardWindowHandle *winhandle;
struct Gadget *gads[WINDOW_MAIN_GADGETS];

extern APTR WizardSurface;
extern ULONG HookEntry();



ULONG HookRoutine(struct Hook *hook,Object *obj,Msg msg)
{
	struct RastPort *RPort;
	struct WizardSliderRender *rendermsg;

	switch (msg->MethodID)
	{
		case WSLIDERM_RENDER:
			{
				rendermsg=(struct WizardSliderRender *)msg;

				RPort=rendermsg->wpsl_RastPort;

// RastPort ist in jeder Hinsicht undefiniert !!!

				SetAPen(RPort,0);
				SetDrMd(RPort,JAM1);

				RectFill(RPort,rendermsg->wpsl_Bounds.Left,
								rendermsg->wpsl_Bounds.Top,
								rendermsg->wpsl_Bounds.Left+rendermsg->wpsl_Bounds.Width-1,
								rendermsg->wpsl_Bounds.Top+rendermsg->wpsl_Bounds.Height-1);


				SetAPen(RPort,1);
				RectFill(RPort,

								rendermsg->wpsl_Bounds.Left+
									rendermsg->wpsl_KnobBounds.Left,

								rendermsg->wpsl_Bounds.Top+
									rendermsg->wpsl_KnobBounds.Top,

								rendermsg->wpsl_Bounds.Left+
									rendermsg->wpsl_KnobBounds.Left+rendermsg->wpsl_KnobBounds.Width-1,

								rendermsg->wpsl_Bounds.Top+
									rendermsg->wpsl_KnobBounds.Top+rendermsg->wpsl_KnobBounds.Height-1
							);


			}
			break;
	}

	return(0);
}


struct Hook MyHook=
{
	NULL,NULL,
	&HookEntry,
	(ULONG(*)())&HookRoutine,
	NULL
};


main()
{
	BOOL Flag;

	struct IntuiMessage *msg;


	// Erstmal die Oberflächenbeschreibung bereitstellen !
	if ((surface=WZ_OpenSurface("test.wizard",0,TAG_DONE)))
	{

		// Natürlich brauchen wir auch einen Screen oder ?
		if ((screen=LockPubScreen(0L)))
		{

			// Jetzt holen wir uns ein WindowHandle, mit dem unsere Object
			// durch die wizard.library verwaltet werden.
			if ((winhandle=WZ_AllocWindowHandle(screen,0L,surface,TAG_DONE)))
			{

				// Da ein WindowHandle nur Sinn macht, wenn auch die Objecte
				// darin vorkommen, legen wir diese Objecte jetzt an.
				if ((newwin=WZ_CreateWindowObj(winhandle,WINDOW_MAIN,WWH_GadgetArray,gads,
																							WWH_GadgetArraySize,sizeof(gads),
																							TAG_DONE)))
				{

					SetGadgetAttrs(gads[1],0,0,WSLIDERA_Hook,&MyHook,TAG_DONE);

					// Nachdem das glatt ging, versuchen wir unser
					// Fenster zu öffnen. Dabei werden alle Object installiert.
					if ((window=WZ_OpenWindow(winhandle,newwin,WA_AutoAdjust,TRUE,
																			TAG_DONE)))
					{
						Flag=TRUE;	// Flag für Beenden der nachfolgenden Schleife

						do
						{
							// Da wir keine Rechenzeit vergeuden wollen, werden wir
							// das Program schlafen legen, bis eine Message
							// eintifft. Für Profis gilt, das auch Wait() verwendet
							// werden kann.
							WaitPort(window->UserPort);

							if ((msg=(struct IntuiMessage *)GetMsg(window->UserPort)))
							{
								// Ha, da ist doch tatsächlich eine Message ange-
								// kommen. Na dann gucken wir mal ob Sie auch vom
								// richtigen Type ist.

								switch(msg->Class)
								{
									case IDCMP_CLOSEWINDOW:
										{
											Flag=FALSE;
										}
										break;
								}

								// Da wir keine Speicherleichen dulden wollen und
								// das Messagesystem nicht durcheinanden bringen
								// wollen, teilen wir den Betriebssystem mit, das
								// die Message von uns nicht mehr benötigt wird.
								ReplyMsg((struct Message *)msg);
							}
						}
						while (Flag);

						// Fenster schließen
						WZ_CloseWindow(winhandle);
					}
				}

				// In jedem Fall muß ein mit WZ_AllocWindowHandle() angelegter
				// WindowHandle auch wieder freigegeben werden. Übrigens
				// kann das Fenster hierbei noch offen sein. Probieren Sie es!
				WZ_FreeWindowHandle(winhandle);
			}

			// PublicScreen-BenutzerZähler wieder um eins verringern
			UnlockPubScreen(0L,screen);
		}

		// Da wir keine Objekte von dieser Surface mehr besitzen und wir diese
		// auch nicht mehr anlegen. Geben Sie wir damit frei. Übrigens noch
		// nicht freigegebene WindowHandles werden hierbei von der
		// wizard.libarry entfernt (Fenster auch geschlossen).
		WZ_CloseSurface(surface);
	}
}