#include <exec/types.h>
#include <exec/memory.h>
#include <exec/execbase.h>
#include <intuition/intuition.h>
#include <time.h>

/*************/
/* CONSTANTS */
/*************/

#define MAXMODE 2

/***********/
/* GLOBALS */
/***********/

char WindowTitle[80] = "MemBar";

struct NewWindow nw =
    {
	0, 0, 320, 10,
	0, 1,
	MOUSEBUTTONS | CLOSEWINDOW,
	WINDOWCLOSE | WINDOWDRAG | WINDOWDEPTH | SMART_REFRESH | NOCAREREFRESH | RMBTRAP,
	NULL,
	NULL,
	WindowTitle,
	NULL,
	NULL,
	0, 0, 0, 0,
	WBENCHSCREEN
    };

/**************/
/* PROTOTYPES */
/**************/

ULONG MaxMem(__D0 ULONG);

/********************/
/* main()           */
/********************/

void main()
    {
	struct Window *win;
	struct RastPort *rp;

	SHORT delay = 20;
	SHORT mode = 0;
	BOOL bool = TRUE;

	win = (struct Window *)OpenWindow(&nw);
	if ( !win )
	    {
		puts("MemBar : Can't open window.");
		exit(0);
	    }

	rp = win->RPort;

	while ( bool )
	    {
		struct IntuiMessage *msg;

		Delay(delay);

		while ( msg = (struct IntuiMessage *)GetMsg(win->UserPort) )
		    {
			ULONG class = msg->Class;
			USHORT code = msg->Code;

			ReplyMsg(msg);

			switch ( class )
			    {
				case CLOSEWINDOW :
				    bool = FALSE;
				    break;
				case MOUSEBUTTONS :
				    if ( code == MENUUP )
					{
					    mode++;

					    if ( mode >= MAXMODE )
						mode = 0;
					}
				    break;
			    }
		    }

		switch ( mode )
		    {
			case 0 :
			    {
				/***************/
				/* show membar */
				/***************/

				ULONG max;
				LONG x;

				SetAPen(rp, 2);
				Move(rp, 32, 1); Draw(rp, 30, 8);
				Move(rp, 31, 1); Draw(rp, 31, 8);
				Move(rp, 264, 1); Draw(rp, 264, 8);
				Move(rp, 263, 1); Draw(rp, 263, 8);
				Move(rp, 32, 1); Draw(rp, 262, 1);
				Move(rp, 32, 4); Draw(rp, 262, 4);
				Move(rp, 32, 5); Draw(rp, 262, 5);
				Move(rp, 32, 8); Draw(rp, 262, 8);

				max = MaxMem(MEMF_CHIP);

				x = 231 * (max - AvailMem(MEMF_CHIP)) / max + 32;

				SetAPen(rp, 3);
				Move(rp, 32, 2); Draw(rp, x, 2);
				Move(rp, 32, 3); Draw(rp, x, 3);

				x++;

				SetAPen(rp, 2);
				Move(rp, 263, 2); Draw(rp, x, 2);
				Move(rp, 263, 3); Draw(rp, x, 3);

				max = MaxMem(MEMF_FAST);
				x = 231 * (max - AvailMem(MEMF_FAST)) / max + 32;

				SetAPen(rp, 3);
				Move(rp, 32, 6); Draw(rp, x, 6);
				Move(rp, 32, 7); Draw(rp, x, 7);

				x++;

				SetAPen(rp, 6);
				Move(rp, 263, 6); Draw(rp, x, 6);
				Move(rp, 263, 7); Draw(rp, x, 7);

				delay = 20;
			    }
			    break;
			case 1 :
			    {
				/*************/
				/* show time */
				/*************/

				time_t t = time(NULL);
				struct tm *tp = localtime(&t);

				if ( (tp->tm_sec == 0) || (delay != 30) )
				    {
					strftime(WindowTitle, 80, "%a, %d. %b %Y  %H:%M", tp);
					SetWindowTitles(win, WindowTitle, NULL);
				    }

				delay = 30;
			    }
			    break;
		    }
	    }

	CloseWindow(win);
	exit(0);
    }

/********************/
/* MaxMem()         */
/********************/

ULONG MaxMem(__D0 ULONG MemType)
    {
	ULONG BlockSize = 0;
	struct MemHeader *MemHeader;
	extern struct ExecBase *SysBase;

	Forbid();

	for ( MemHeader = (struct MemHeader *)SysBase->MemList.lh_Head ; MemHeader->mh_Node.ln_Succ ; MemHeader = (struct MemHeader *)MemHeader->mh_Node.ln_Succ )
	    if ( MemHeader->mh_Attributes & MemType)
		BlockSize += (ULONG)MemHeader->mh_Upper - (ULONG)MemHeader->mh_Lower;

	Permit();

	return(BlockSize);
    }

