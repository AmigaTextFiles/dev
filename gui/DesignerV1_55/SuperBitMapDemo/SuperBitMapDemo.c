/* Compile me to get full executable. */

#include <stdio.h>
#include "superbitmapdemowin.c"

BOOL inbox(void)
{
return ( 
		(SBWin->MouseX-SBWin->BorderLeft > 7  ) &&  
		(SBWin->MouseX-SBWin->BorderLeft < 275) &&  
		(SBWin->MouseY-SBWin->BorderTop  > 38 ) &&  
		(SBWin->MouseY-SBWin->BorderTop  < 145)
		);
}

UWORD   oldx;
UWORD   oldy;
UWORD   newx;
UWORD   newy;

int main(void)
{
int done=0;
ULONG class;
UWORD code;
struct Gadget *pgsel;
struct IntuiMessage *imsg;
struct Border myborder = {0,0,1,0,JAM1,2,(WORD *)&oldx,NULL};
BOOL drawing = FALSE;

oldx = 65535;
oldy = 65535;
if (OpenLibs()==0)
	{
	if (OpenWindowSBWin( (UBYTE *)"DesignerDemoPubScreen" )==0)
		{
		while(done==0)
			{
			Wait(1L << SBWin->UserPort->mp_SigBit);
			imsg=GT_GetIMsg(SBWin->UserPort);
			while (imsg != NULL )
				{
				class=imsg->Class;
				code=imsg->Code;
				pgsel=(struct Gadget *)imsg->IAddress; /* Only reference if it is a gadget message */
				GT_ReplyIMsg(imsg);
				if (class==IDCMP_CLOSEWINDOW)
					done=1;
				if (class==IDCMP_REFRESHWINDOW)
					{
					GT_BeginRefresh(SBWin);
					GT_EndRefresh(SBWin, TRUE);
					}
				if (class == IDCMP_GADGETUP)
					{
					if (pgsel->GadgetID == ColourGadget)
						{
						myborder.FrontPen = code;
						}
					}
				if (class == IDCMP_MOUSEBUTTONS)
					{
					if (code== SELECTUP)
						{
						drawing = FALSE;
						}
					else
						{
						if ( inbox() )
							{
							drawing = TRUE;
							oldx = SBWin->MouseX-SBWin->BorderLeft;
							oldy = SBWin->MouseY-SBWin->BorderTop;
							}
						}
					}
				if (class == IDCMP_MOUSEMOVE )
					{
					if (drawing==TRUE)
						{
						if ( inbox() )
							{
							newx = SBWin->MouseX-SBWin->BorderLeft;
							newy = SBWin->MouseY-SBWin->BorderTop;
							if ( oldx != 65535 )
								{
								DrawBorder(SBWin->RPort,(struct Border *)&myborder,0,0);
								}
							oldx = newx;
							oldy = newy;
							}
						else
							{
							oldx = 65535;
							oldy = 65535;
							}
						}
					}
				imsg=GT_GetIMsg(SBWin->UserPort);
				}
			}
		
		CloseWindowSBWin();
		}
	else
		printf("Cannot open window.\n");
	CloseLibs();
	}
else
	printf("Cannot open libraries.\n");
}
