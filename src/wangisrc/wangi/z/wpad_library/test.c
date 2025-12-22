#include <exec/types.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/wpad.h>
#include <pragmas/wpad_pragmas.h>
#include <libraries/wpad.h>
#include <utility/hooks.h>
#include <proto/commodities.h>

extern struct Library *WPadBase = NULL;
extern struct Library *CxBase = NULL;

struct NewBroker nb = 
{
	NB_VERSION,
	"wpad.library example",
	"example",
	"example",
	0,0,0,0,0
};

struct Hook hook;

#define rEG(x) register __ ## x

ULONG __saveds __asm hookfunc( rEG(a0) struct Hook *hook,
                               rEG(a2) struct WPOPHookMsg *hmsg,
                               rEG(a1) struct PadItem *node )
{
	if( hmsg->hm_MethodID == WPOP_HOOK_EXEC )
		Printf("HOOK => \"%s\"\n", node->pi_Name);
	return( WPOP_HOOKRETURN_OK );
}

void main( void )
{
	hook.h_Entry = hookfunc;
	hook.h_SubEntry = NULL;
	hook.h_Data = NULL;
	
	if( (WPadBase = OpenLibrary("wpad.library", 0)) &&
	    (CxBase = OpenLibrary("commodities.library", 0)) )
	{
		struct MsgPort *port;
		if( port = CreateMsgPort() )
		{
			CxObj *broker;
			if( broker = CxBroker(&nb, NULL) )
			{
				struct PadItem node1 =
				{
					{
						NULL,
						NULL,
						0,
						0,
						"Node 1"
					},
					NULL,
					"control alt 4",
					NULL,
					NULL,
					NULL
				};
				struct PadItem node2 =
				{
					{
						NULL,
						NULL,
						0,
						0,
						"Node 2"
					},
					NULL,
					"control alt 2",
					NULL,
					NULL,
					NULL
				};
				struct List list;
				struct Pad *pad1;
				struct TextAttr font = 
				{
					"topaz.font",
					8,
					0,
					FPB_ROMFONT
				};
				
				ActivateCxObj(broker, 1L);
				
				NewList(&list);
				
				AddHead(&list, (struct Node *)&node1);
				AddHead(&list, (struct Node *)&node2);

			
			
		
				if( (pad1 = WP_OpenPad(WPOP_Items, &list,
		 		                       WPOP_Font, &font,
				                       WPOP_Broker, broker,
				                       WPOP_HotKey, "control alt 3",
				                       WPOP_ProcName, "WangiPad_TEST_Pad",
				                       WPOP_StackSize, 2000,
				                       WPOP_Priority, -1,
				                       WPOP_Hook, &hook,
				                       TAG_END)) )
				{
					Printf("Pads opened!\n");
					Wait(SIGBREAKF_CTRL_C);

					WP_ClosePadA(pad1, NULL);
					Printf("Pad 1 closed!\n");
				} else
					Printf("Can't open pads!\n");
				DeleteCxObjAll(broker);
			}
			DeleteMsgPort(port);
		}
		CloseLibrary(CxBase);
		CloseLibrary(WPadBase);
		Printf("Library closed!\n");
	}
}