/* Compile me to get full executable. */

#include <stdio.h>
#include "pubscreendemop1win.c"


int main(void)
{
int done=0;
ULONG class;
UWORD code;
struct Gadget *pgsel;
struct IntuiMessage *imsg;
struct Screen *Scr=NULL;
if (OpenLibs()==0)
	{
	Scr = OpenMyPubScrScreen();
	PubScreenStatus(Scr,0);
	if (Scr != NULL)
		{
		if (OpenWindowScrWin(Scr)==0)
			{
			while(done==0)
				{
				Wait(1L << ScrWin->UserPort->mp_SigBit);
				imsg=GT_GetIMsg(ScrWin->UserPort);
				while (imsg != NULL )
					{
					class=imsg->Class;
					code=imsg->Code;
					pgsel=(struct Gadget *)imsg->IAddress; /* Only reference if it is a gadget message */
					GT_ReplyIMsg(imsg);
					if (class==IDCMP_CLOSEWINDOW)
						{
						CloseWindowScrWin();
						if (CloseScreen(Scr))
						 	{
							Scr=NULL;
							done=1;
							}
						else
							{
							OpenWindowScrWin(Scr);
							if (ScrWin==NULL)
								{
								done=1;
								printf("Could not reopen window.\n");
								}
							}
						}
					if (class==IDCMP_REFRESHWINDOW)
						{
						GT_BeginRefresh(ScrWin);
						GT_EndRefresh(ScrWin, TRUE);
						}
					if (class==IDCMP_GADGETUP)
						{
						if (pgsel->GadgetID == State)
							{
							if (code==0)
								PubScreenStatus(Scr,0);
							else
								PubScreenStatus(Scr,0);
							}
						}
					imsg = NULL;
					if (ScrWin != NULL)
						imsg=GT_GetIMsg(ScrWin->UserPort);
					}
				}
			
			if (ScrWin != NULL)
				CloseWindowScrWin();
			}
		else
			printf("Cannot open window.\n");
		if (Scr != NULL)
			CloseScreen(Scr);
		}
	else
		printf("Cannot Open Screen.\n");
	CloseLibs();
	}
else
	printf("Cannot open libraries.\n");
}
