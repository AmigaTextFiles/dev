/* Compile me to get full executable. */

#include "multipledemoc.c"

int done=0;
ULONG count;
UWORD Code;
struct Gadget *Gad;
struct IntuiMessage *imsg;
struct MsgPort *MyMsgPort;
struct WindowNode *WinNode;
struct WindowNode *WinNode2;
struct List WindowList;

int OpenNewWin(void)
{
struct WindowNode * WN;
WN=AllocMem(sizeof(struct WindowNode),MEMF_CLEAR);
if (WN !=NULL)
	{
	OpenWindowWinNodeWin( MyMsgPort, WN );
	if (WN->Win==NULL)
		{
		FreeMem(WN,sizeof(struct WindowNode));
		}
	else
		{
		AddTail(&WindowList,(struct Node *)WN);
		WN->Win->UserData=(void *)WN;
		count=0;
		WinNode2=(struct WindowNode *)WindowList.lh_Head;
		while (WinNode2->ln_Succ != NULL)
			{
			count++;
			GT_SetGadgetAttrs(WinNode2->WinGadgets[2],WinNode2->Win, NULL, GTNM_Number, count, TAG_DONE);
			WinNode2=WinNode2->ln_Succ;
			}
		return(0);
		}
	}
return(1);
}

int CloseOneWin( struct WindowNode * WN)
{
	Remove((struct Node *)WN);
	CloseWindowWinNodeWin(WN);
	FreeMem(WN,sizeof(struct WindowNode));
	count=0;
	WinNode2=(struct WindowNode *)WindowList.lh_Head;
	while (WinNode2->ln_Succ != NULL)
		{
		count++;
		GT_SetGadgetAttrs(WinNode2->WinGadgets[2],WinNode2->Win, NULL, GTNM_Number, count, TAG_DONE);
		WinNode2=WinNode2->ln_Succ;
		}
}

void ProcessMenuIDCMPCommonMenu( UWORD MenuNumber)
{
UWORD MenuNum;
UWORD ItemNumber;
struct MenuItem *item;
while ((MenuNumber != MENUNULL))
	{
	item = ItemAddress( CommonMenu, MenuNumber);
	MenuNum = MENUNUM(MenuNumber);
	ItemNumber = ITEMNUM(MenuNumber);
	switch ( MenuNum )
		{
		case CommonMenu_Options :
			switch ( ItemNumber )
				{
				case CommonMenu_Options_Item0 :
					WinNode=(struct WindowNode *)WindowList.lh_Head;
					while (WinNode->ln_Succ->ln_Succ != NULL)
						{
						CloseOneWin(WinNode);
						WinNode=(struct WindowNode *)WindowList.lh_Head;
						}
					break;
				case CommonMenu_Options_Item2 :
					WinNode=(struct WindowNode *)WindowList.lh_Head;
					while (WinNode->ln_Succ != NULL)
						{
						CloseOneWin(WinNode);
						WinNode=(struct WindowNode *)WindowList.lh_Head;
						}
					break;
				}
			break;
		}
	MenuNumber = item->NextSelect;
	}
}

int main(void)
{
ULONG class;
if (OpenLibs()==0)
	{
	NewList(&WindowList);
	if ((MyMsgPort=CreateMsgPort())!=0)
		{
		if (OpenNewWin()==0)
			while(done==0)
				{
				Wait(1L << MyMsgPort->mp_SigBit);
				imsg=GT_GetIMsg(MyMsgPort);
				while (imsg != NULL )
					{
					class=imsg->Class;
					Code=imsg->Code;
					Gad=(struct Gadget *)imsg->IAddress;
					WinNode = (struct WindowNode *)imsg->IDCMPWindow->UserData;
					GT_ReplyIMsg(imsg);
					switch ( class )
						{
						case IDCMP_GADGETUP :
							switch ( Gad->GadgetID ) 
								{
								case CommonWin_Gad0 :
									OpenNewWin();
									break;
								case CommonWin_Gad1 :
									OpenNewWin();
									OpenNewWin();
									OpenNewWin();
									OpenNewWin();
									OpenNewWin();
									break;
								}
							break;
						case IDCMP_CLOSEWINDOW :
							CloseOneWin(WinNode);
							if (WindowList.lh_Head->ln_Succ==NULL)
							  done=1;
							break;
						case IDCMP_MENUPICK :
							ProcessMenuIDCMPCommonMenu( Code );
							if (WindowList.lh_Head->ln_Succ==NULL)
							  done=1;
							break;
						}
					imsg=GT_GetIMsg(MyMsgPort);
					}
				}
		else
			printf("Cannot open window.\n");
		if (CommonMenu != NULL)
		  FreeMenus(CommonMenu);
		DeleteMsgPort(MyMsgPort);
		}
	else
		printf("Cannot make message Port.\n");
	CloseLibs();
	}
else
	printf("Cannot open libraries.\n");
}
