/* Compile me to get full executable. */

#include <stdio.h>
#include <workbench/startup.h>
#include "showicondemowin.c"

int main(void)
{
int done=0;
ULONG class;
UWORD code;
ULONG appid=1;
struct Gadget *pgsel;
struct IntuiMessage *imsg;
struct AppMessage *appmsg;
struct MsgPort *appport;
UBYTE  Buffer[250];

if (OpenLibs()==0)
	{
	if (appport=CreateMsgPort())
		{
		if (OpenWindowWin0(appport,appid)==0)
			{
			while(done==0)
				{
				
				Wait( (1L << Win0->UserPort->mp_SigBit) | (1L << appport->mp_SigBit) );
				
				imsg=GT_GetIMsg(Win0->UserPort);
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
						GT_BeginRefresh(Win0);
						GT_EndRefresh(Win0, TRUE);
						}
					imsg=GT_GetIMsg(Win0->UserPort);
					}
				
				/* Process appwindow messages */
				
				while (appmsg=(struct AppMessage *)GetMsg(appport))
		            {
		            
		            printf("File = %s\n",appmsg->am_ArgList->wa_Name);
		            
		            NameFromLock( appmsg->am_ArgList->wa_Lock , Buffer , 250);
		            
		            printf("Dir  = %s\n", Buffer);
		            
		            ReplyMsg( (struct Message *) appmsg);
		            }
				
				}
			
			CloseWindowWin0();
			}
		else
			printf("Cannot open window.\n");
	
		/* Clear message port before closing */
		
		while (appmsg=(struct AppMessage *)GetMsg(appport))
		    ReplyMsg( (struct Message *) appmsg);
		
		DeleteMsgPort(appport);
		}
	else
		printf("Cannot create msg port.\n");
	CloseLibs();
	}
else
	printf("Cannot open libraries.\n");
}
