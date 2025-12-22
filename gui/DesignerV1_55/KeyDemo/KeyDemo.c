/* Simple demo using a Designer created file */
/* Only run from CLI */

#include "keydemowin.c"

ULONG MyTags[]=
	{
	0,0,
	TAG_DONE
	};

int main(void)
{
int done=0;
ULONG class;
UWORD code;
struct Gadget *pgsel;
struct IntuiMessage *imsg;
int GadNumber;
int CycleGadPos=0;
int SliderPos=0;
int ScrollerPos=0;
int PalettePos=0;
if (OpenLibs()==0)
	{
	if (OpenWindowMainWindow()==0)
		{
		printf("Key Demo Begins...\n");
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
				GadNumber = 99;
				switch (class)
					{
					case IDCMP_CLOSEWINDOW :
						done=1;
						break;
					case IDCMP_GADGETDOWN :
						GadNumber = pgsel->GadgetID;
						break;
					case IDCMP_GADGETUP :
						GadNumber = pgsel->GadgetID;
						break;
					case IDCMP_VANILLAKEY :
						
						/* For these gadgets case matters  */
						
						switch (code)
							{
							case 'p' :
								PalettePos += 1;
								if (PalettePos>(1L << MainWindowDepth)-1)
								  PalettePos=0;
								printf("Palette = %ld\n",PalettePos);
								MyTags[0] = GTPA_Color;
								MyTags[1] = PalettePos;
								GT_SetGadgetAttrsA(MainWindowGadgets[PaletteGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case 'P' :
								PalettePos -= 1;
								if (PalettePos<0)
								  PalettePos = (1L << MainWindowDepth)-1;
								printf("Palette = %ld\n",PalettePos);
								MyTags[0] = GTPA_Color;
								MyTags[1] = PalettePos;
								GT_SetGadgetAttrsA(MainWindowGadgets[PaletteGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case 'y' :
								CycleGadPos += 1;
								if (CycleGadPos>3)
								  CycleGadPos=0;
								printf("Cycle = %ld\n",CycleGadPos);
								MyTags[0] = GTCY_Active;
								MyTags[1] = CycleGadPos;
								GT_SetGadgetAttrsA(MainWindowGadgets[CycleGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case 'Y' :
								CycleGadPos -= 1;
								if (CycleGadPos<0)
								  CycleGadPos=3;
								printf("Cycle = %ld\n",CycleGadPos);
								MyTags[0] = GTCY_Active;
								MyTags[1] = CycleGadPos;
								GT_SetGadgetAttrsA(MainWindowGadgets[CycleGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case 'r' :
								if (ScrollerPos<8)
								  ScrollerPos += 1;
								printf("Scroller =  %ld\n",ScrollerPos);
								MyTags[0] = GTSC_Top;
								MyTags[1] = ScrollerPos;
								GT_SetGadgetAttrsA(MainWindowGadgets[ScrollerGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case 'R' :
								if (ScrollerPos>0)
								  ScrollerPos -= 1;
								printf("Scroller =  %ld\n",ScrollerPos);
								MyTags[0] = GTSC_Top;
								MyTags[1] = ScrollerPos;
								GT_SetGadgetAttrsA(MainWindowGadgets[ScrollerGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case 'l' :
								if (SliderPos<15)
								  SliderPos += 1;
								printf("Slider = %ld\n",SliderPos);
								MyTags[0] = GTSL_Level;
								MyTags[1] = SliderPos;
								GT_SetGadgetAttrsA(MainWindowGadgets[SliderGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case 'L' :
								if (SliderPos>0)
								  SliderPos -= 1;
								printf("Slider = %ld\n",SliderPos);
								MyTags[0] = GTSL_Level;
								MyTags[1] = SliderPos;
								GT_SetGadgetAttrsA(MainWindowGadgets[SliderGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							}
						
						/* Downcase key code */
						
						if ( (64<code) && (code<91) )
							code +=32;
						
						/* For these gadgets case does not matter */
						
						switch (code)
							{
							case 's' :
								printf("Activating String Gadget\n");
								ActivateGadget(MainWindowGadgets[StringGadget], MainWindow, NULL);
								break;
							case 'i' :
								printf("Activating Integer Gadget\n");
								ActivateGadget(MainWindowGadgets[IntegerGadget], MainWindow, NULL);
								break;
							case 'q' :
								GadNumber = QuitButton;
								break;
							case 'b' :
								GadNumber = ButtonGadget;
								break;
							case '0' :
								printf("MX = 0\n");
								MyTags[0] = GTMX_Active;
								MyTags[1] = 0;
								GT_SetGadgetAttrsA(MainWindowGadgets[MXGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case '1' :
								printf("MX = 1\n");
								MyTags[0] = GTMX_Active;
								MyTags[1] = 1;
								GT_SetGadgetAttrsA(MainWindowGadgets[MXGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case '2' :
								printf("MX = 2\n");
								MyTags[0] = GTMX_Active;
								MyTags[1] = 2;
								GT_SetGadgetAttrsA(MainWindowGadgets[MXGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case '3' :
								printf("MX = 3\n");
								MyTags[0] = GTMX_Active;
								MyTags[1] = 3;
								GT_SetGadgetAttrsA(MainWindowGadgets[MXGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							case 'c' :
								printf("CheckBox Toggled\n");
								MyTags[0] = GTCB_Checked;
							    if ((MainWindowGadgets[CheckBoxGadget]->Flags & GFLG_SELECTED)==0)
							    	{
							    	MyTags[1] = TRUE;
							    	}
							    else
							    	{
							    	MyTags[1] = FALSE;
							    	};
								GT_SetGadgetAttrsA(MainWindowGadgets[CheckBoxGadget], MainWindow, NULL, (struct TagItem *)MyTags);
								break;
							}
						break;
					};
				switch (GadNumber)
					{
					case CheckBoxGadget :
						printf("CheckBox Toggled\n");
						break;
					case PaletteGadget :
						PalettePos = code;
						printf("Palette = %ld\n",code);
						break;
					case ButtonGadget :
						printf("Button Pressed\n");
						break;
					case IntegerGadget :
						printf("Integer Gadget = %ld\n",((struct StringInfo *)MainWindowGadgets[IntegerGadget]->SpecialInfo)->LongInt);
						break;
					case StringGadget :
						printf("String Gadget = %s\n",((struct StringInfo *)MainWindowGadgets[StringGadget]->SpecialInfo)->Buffer);
						break;
					case QuitButton :
						done = 1;
						break;
					case MXGadget :
						printf("MX = %ld\n",code);
						break;
					case CycleGadget :
						CycleGadPos = code;
						printf("Cycle = %ld\n",code);
						break;
					case SliderGadget :
						SliderPos = code;
						printf("Slider = %ld\n",code);
						break;
					case ScrollerGadget :
						ScrollerPos = code;
						printf("Scroller = %ld\n",code);
						break;
					};
				imsg=GT_GetIMsg(MainWindow->UserPort);
				}
			}
		printf("Bye...\n");
		CloseWindowMainWindow();
		}
	else
		printf("Cannot open window.\n");
	}
else
	printf("Cannot open libraries.\n");
}
