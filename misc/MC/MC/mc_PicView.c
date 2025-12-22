/******************************************************************************
**									     **
** MultiColor-Demo-PicView						     **
**									     **
**---------------------------------------------------------------------------**
** V2.0 vom 02.10.95							     **
******************************************************************************/

#include "sc:source/mc/multicolor.h"

/* Protos */

void OpenAll(void);
void CloseAll(void);
void PicView(char *name,WORD ro,WORD go,WORD bo);
void Usage(void);

/* defines */

extern struct ExecBase		*SysBase;
struct IntuitionBase		*IntuitionBase=0l;
struct GfxBase				*GfxBase=0l;
struct Screen				*scr=0l;
struct Window				*win=0l;
MCHandle					*mch=0l;

struct TagItem scrtags[]={
	SA_Left,		0,
	SA_Top, 		0,
	SA_Width,		0,
	SA_Height,		0,
	SA_Depth,		0,
	SA_Colors,		0l,
	SA_Type,		CUSTOMSCREEN,
	SA_DisplayID,	PAL_MONITOR_ID,
	TAG_DONE
};

struct TagItem wintags[]={
	WA_Left,		0,
	WA_Top, 		0,
	WA_Width,		0,
	WA_Height,		0,
	WA_IDCMP,		IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY,
	WA_Flags,		WFLG_SMART_REFRESH|WFLG_RMBTRAP|WFLG_BORDERLESS|WFLG_ACTIVATE,
	WA_CustomScreen,0l,
	TAG_DONE
};

/* Funktions */

void OpenAll(void)
{
//	if(!(IntuitionBase=OpenLibrary("intuition.library",37))) CloseAll();
	if(!(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library",39))) CloseAll();
	if(!(GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",37))) CloseAll();

	if(!(scr=OpenScreenTagList(0l,scrtags))) CloseAll();
	wintags[6].ti_Data=(ULONG)scr;

	if(!(win=OpenWindowTagList(0l,wintags))) CloseAll();
}

void CloseAll(void)
{
	if(win)                 CloseWindow(win);
	if(scr)                 CloseScreen(scr);
	if(GfxBase)             CloseLibrary((struct Library *)GfxBase);
	if(IntuitionBase)       CloseLibrary((struct Library *)IntuitionBase);
	exit(0);
}

void PicView(char *name,WORD ro,WORD go,WORD bo)
{
	struct IntuiMessage *imsg;
	ULONG iclass;
	USHORT icode;
	UBYTE quit=0,color;
	MCPoint akt;
	FILE *in_r,*in_g,*in_b;
	register int x,y;
	char name_r[200],name_g[200],name_b[200];

	sprintf(name_r,"%s.r",name);
	sprintf(name_g,"%s.g",name);
	sprintf(name_b,"%s.b",name);

	if(in_r=fopen(name_r,"rb"))
	{
	    if(in_g=fopen(name_g,"rb"))
	    {
		if(in_b=fopen(name_b,"rb"))
		{
		    for(y=0;y<mch->yres && !quit;y++)
		    {
			for(x=0;x<mch->xres;x++)
			{
			    color=fgetc(in_r);
			    akt.r=ro+color;
			    if (akt.r < 0)
				akt.r=0;
			    else if (akt.r>255)
				akt.r=255;
			    color=fgetc(in_g);
			    akt.g=ro+color;
			    if (akt.g < 0)
				akt.g=0;
			    else if (akt.g>255)
				akt.g=255;
			    color=fgetc(in_b);
			    akt.b=bo+color;
			    if (akt.b < 0)
				akt.b=0;
			    else if (akt.b>255)
				akt.b=255;
			    MC_PutPixel(mch,x,y,&akt);

			    if(imsg=(struct IntuiMessage *)GetMsg(win->UserPort))
			    {
				ReplyMsg((struct Message *)imsg);
				quit=1;
				break;
			    }
			}
		    }
		    fclose(in_b);
		}
		fclose(in_g);
	    }
	    fclose(in_r);
	}
	while(!quit)
	{
		WaitPort(win->UserPort);
		while(imsg=(struct IntuiMessage *)GetMsg(win->UserPort))
		{
			iclass	=imsg->Class;
			icode	=imsg->Code;
			ReplyMsg((struct Message *)imsg);
			switch(iclass)
			{
				case IDCMP_RAWKEY:
					switch(icode)
					{
						case 0x45:		/* ESC */
						case 0x40:		/* Space */
							quit=1;break;
					}
					break;
			}
		}
	}
}

void Usage(void)
{
	printf("Usage \n");
	printf("\tmc_picview typ res name\n");
	printf("\tres\\typ | 0=ECS | 1=AGA,GFX-Card\n");
	printf("\t--------+-------+---------------\n");
	printf("\t e (ehb)| 64    | -             \n");
	printf("\t l (low)| 32    | 256           \n");
	printf("\t h (hi )| 16    | 256           \n");
	printf("\t s (shi)| --    | 256           \n");
	printf("\t--------+-------+---------------\n");
	printf("\n\tname  raw-picturefile\n");
}

void main(int argc,char *argv[])
{
	UBYTE dep,typ,fail=0;
	char res;
	WORD ro=0,go=0,bo=0;

	if(argc>=4)
	{
		typ=atoi(argv[1])&1;
		res=argv[2][0];
		if(argc>=5) ro=atof(argv[4])*255;
		if(argc>=6) ro=atof(argv[5])*255;
		if(argc>=7) ro=atof(argv[6])*255;

		switch(typ)
		{
			case 0: 	/* ECS */
				switch(res)
				{
					case 'E':
					case 'e':
						scrtags[4].ti_Data=dep=6;
						wintags[2].ti_Data=scrtags[2].ti_Data=354;		/* 236 */
						wintags[3].ti_Data=scrtags[3].ti_Data=552;		/* 276 */
						scrtags[7].ti_Data|=EXTRAHALFBRITELACE_KEY;
						break;
					case 'L':
					case 'l':
						scrtags[4].ti_Data=dep=5;
						wintags[2].ti_Data=scrtags[2].ti_Data=354;		/* 236 */
						wintags[3].ti_Data=scrtags[3].ti_Data=552;		/* 276 */
						scrtags[7].ti_Data|=LORESLACE_KEY;
						break;
					case 'H':
					case 'h':
						scrtags[4].ti_Data=dep=4;
						wintags[2].ti_Data=scrtags[2].ti_Data=708;		/* 472 */
						wintags[3].ti_Data=scrtags[3].ti_Data=552;		/* 276 */
						scrtags[7].ti_Data|=HIRESLACE_KEY;
						break;
					case 'S':
					case 's':
						fail=1;
						break;
				}
				break;
			case 1: 	/* AGA,GFX-Card */
				switch(res)
				{
					case 'E':
					case 'e':
						fail=1;
						break;
					case 'L':
					case 'l':
						scrtags[4].ti_Data=dep=8;
						wintags[2].ti_Data=scrtags[2].ti_Data=354;		/* 236 */
						wintags[3].ti_Data=scrtags[3].ti_Data=552;		/* 276 */
						scrtags[7].ti_Data|=LORESLACE_KEY;
						break;
					case 'H':
					case 'h':
						scrtags[4].ti_Data=dep=8;
						wintags[2].ti_Data=scrtags[2].ti_Data=708;		/* 472 */
						wintags[3].ti_Data=scrtags[3].ti_Data=552;		/* 276 */
						scrtags[7].ti_Data|=HIRESLACE_KEY;
						break;
					case 'S':
					case 's':
						scrtags[4].ti_Data=dep=8;
						wintags[2].ti_Data=scrtags[2].ti_Data=1416;		/* 944 */
						wintags[3].ti_Data=scrtags[3].ti_Data=552;		/* 276 */
						scrtags[7].ti_Data|=SUPERLACE_KEY;
						break;
				}
				break;
		}

		if(!fail)
		{
			OpenAll();
			if(mch=MC_Init(scr,win,dep))
			{
				PicView(argv[3],ro,go,bo);
				MC_Free(mch);
			}
		}
		else Usage();
	}
	else Usage();
	CloseAll();
}
