/* Simple demo using a Designer created file */
/* Only run from CLI */

#include "toggledemowin.c"

ULONG MyTags[] =
{
	GTTX_Text,0,
	TAG_DONE
};

int main(void)
{
int done=0;
ULONG class;
UWORD code;
struct Gadget *pgsel;
struct IntuiMessage *imsg;
UWORD GadNumber;
if (OpenLibs()==0)
	{
	if (MakeImages()==0)
		{
		if (OpenWindowMainWindow()==0)
			{
			while (done==0)
				{
				Wait(1L << MainWindow->UserPort->mp_SigBit);
				imsg=GT_GetIMsg(MainWindow->UserPort);
				while (imsg != NULL )
					{
					class=imsg->Class;
					code=imsg->Code;
					pgsel=(struct Gadget *)imsg->IAddress; /* Only reference if it is a gadget message */
					GT_ReplyIMsg(imsg);
					GadNumber=99;
					switch (class)
						{
						case IDCMP_CLOSEWINDOW :
							done=1;
							break;
						case IDCMP_GADGETDOWN :
							GadNumber=pgsel->GadgetID;
							break;
						case IDCMP_VANILLAKEY :
							switch (code)
								{
								case 'F' :
									GadNumber = FirstGadget;
									break;
								case 'S' :
									GadNumber = SecondGadget;
									break;
								case 'T' :
									GadNumber = ThirdGadget;
									break;
								}
							break;
						}
					switch (GadNumber)
						{
						case FirstGadget :
							/* Remove gadgets from window */
							RemoveGList(MainWindow,MainWindowGList,~0);
							/* Change Gadget Flags */
							MainWindowGadgets[FirstGadget ]->Flags |=  GFLG_SELECTED;
						 	MainWindowGadgets[SecondGadget]->Flags &= ~GFLG_SELECTED;
							MainWindowGadgets[ThirdGadget ]->Flags &= ~GFLG_SELECTED;
							/* Put Gadgets Back in window */
							AddGList(MainWindow,MainWindowGList,50,~0,NULL);
							/* Refresh Gadgets */
							RefreshGList(MainWindowGList,MainWindow,NULL,~0);
							MyTags[1] = (ULONG)"First Option";
							GT_SetGadgetAttrsA(MainWindowGadgets[DisplayGadget],MainWindow, NULL, (struct TagItem *)MyTags);
							break;
						case SecondGadget :
							RemoveGList(MainWindow,MainWindowGList,~0);
							MainWindowGadgets[FirstGadget ]->Flags &= ~GFLG_SELECTED;
						 	MainWindowGadgets[SecondGadget]->Flags |=  GFLG_SELECTED;
							MainWindowGadgets[ThirdGadget ]->Flags &= ~GFLG_SELECTED;
							AddGList(MainWindow,MainWindowGList,0,~0,NULL);
							RefreshGList(MainWindowGList,MainWindow,NULL,~0);
							MyTags[1] = (ULONG)"Second Option";
							GT_SetGadgetAttrsA(MainWindowGadgets[DisplayGadget],MainWindow, NULL, (struct TagItem *)MyTags);
							break;
						case ThirdGadget :
							RemoveGList(MainWindow,MainWindowGList,~0);
							MainWindowGadgets[FirstGadget ]->Flags &= ~GFLG_SELECTED;
						 	MainWindowGadgets[SecondGadget]->Flags &= ~GFLG_SELECTED;
							MainWindowGadgets[ThirdGadget ]->Flags |=  GFLG_SELECTED;
							AddGList(MainWindow,MainWindowGList,50,~0,NULL);
							RefreshGList(MainWindowGList,MainWindow,NULL,~0);
							MyTags[1] = (ULONG)"Third Option";
							GT_SetGadgetAttrsA(MainWindowGadgets[DisplayGadget],MainWindow, NULL, (struct TagItem *)MyTags);
							break;
						}
					imsg=GT_GetIMsg(MainWindow->UserPort);
					}
				}
			CloseWindowMainWindow();
			}
		else
			printf("Cannot open window.\n");
		FreeImages();
		}
	else
		printf("Cannot make images.\n");
	}
else
	printf("Cannot open libraries.\n");
}
