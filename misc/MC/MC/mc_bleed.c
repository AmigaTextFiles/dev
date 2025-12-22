/******************************************************************************
**									     **
** MultiColor-Demo-Bleed						     **
**									     **
**---------------------------------------------------------------------------**
** V2.0 vom 01.10.95							     **
******************************************************************************/

#include "sc:source/mc/multicolor.h"

/* Protos */

void OpenAll(void);
void CloseAll(void);
void Bleed(UWORD eg1,UWORD eg2,UWORD eg3,UWORD eg4);
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

void Bleed(UWORD eg1,UWORD eg2,UWORD eg3,UWORD eg4)
{
	struct IntuiMessage *imsg;
	ULONG iclass;
	USHORT icode;
	register UBYTE quit=0;
	register UWORD x,y;
	MCPoint edge[4],akt,t1,t2;
	MCPoint v1d,/*v1s,*/v2d,/*v2s,*/h1d/*,h1s*/;
//	FILE *filer=0l,*fileg=0l,*fileb=0l;
//	UBYTE color;

	edge[0].r=(eg1&0xF00)>>4;
	edge[0].g=(eg1&0x0F0);
	edge[0].b=(eg1&0x00F)<<4;
	edge[1].r=(eg2&0xF00)>>4;
	edge[1].g=(eg2&0x0F0);
	edge[1].b=(eg2&0x00F)<<4;
	edge[2].r=(eg3&0xF00)>>4;
	edge[2].g=(eg3&0x0F0);
	edge[2].b=(eg3&0x00F)<<4;
	edge[3].r=(eg4&0xF00)>>4;
	edge[3].g=(eg4&0x0F0);
	edge[3].b=(eg4&0x00F)<<4;

	v1d.r=edge[3].r-edge[0].r;//v1s.r=v1d.r/(double)mch->yres;
	v1d.g=edge[3].g-edge[0].g;//v1s.g=v1d.g/(double)mch->yres;
	v1d.b=edge[3].b-edge[0].b;//v1s.b=v1d.b/(double)mch->yres;
	v2d.r=edge[2].r-edge[1].r;//v2s.r=v2d.r/(double)mch->yres;
	v2d.g=edge[2].g-edge[1].g;//v2s.g=v2d.g/(double)mch->yres;
	v2d.b=edge[2].b-edge[1].b;//v2s.b=v2d.b/(double)mch->yres;

//	filer=fopen("xh3:test.r","wb");
//	fileg=fopen("xh3:test.g","wb");
//	fileb=fopen("xh3:test.b","wb");

//	if(filer && fileg && fileb)
//	{
	    for(y=0;y<mch->yres;y++)
	    {
		t1.r=edge[0].r+v1d.r*y/mch->yres;
		t1.g=edge[0].g+v1d.g*y/mch->yres;
		t1.b=edge[0].b+v1d.b*y/mch->yres;
		t2.r=edge[1].r+v2d.r*y/mch->yres;
		t2.g=edge[1].g+v2d.g*y/mch->yres;
		t2.b=edge[1].b+v2d.b*y/mch->yres;
		h1d.r=t2.r-t1.r;//h1s.r=h1d.r/(double)mch->xres;
		h1d.g=t2.g-t1.g;//h1s.g=h1d.g/(double)mch->xres;
		h1d.b=t2.b-t1.b;//h1s.b=h1d.b/(double)mch->xres;
		for(x=0;x<mch->xres;x++)
		{
		    akt.r=t1.r+h1d.r*x/mch->xres;
		    akt.g=t1.g+h1d.g*x/mch->xres;
		    akt.b=t1.b+h1d.b*x/mch->xres;
//		    color=(UBYTE)(255.0*akt.r);fwrite(&color,1,1,filer);
//		    color=(UBYTE)(255.0*akt.g);fwrite(&color,1,1,fileg);
//		    color=(UBYTE)(255.0*akt.b);fwrite(&color,1,1,fileb);
		    MC_PutPixel(mch,x,y,&akt);
		    if (imsg=(struct IntuiMessage *)GetMsg(win->UserPort))
		    {
			ReplyMsg((struct Message *)imsg);
			quit=1;
			break;
		    }
		}
		if (quit)
		    break;
	    }
//	    fclose(fileb);
//	    fclose(fileg);
//	    fclose(filer);
//	}
    while(!quit)
    {
	WaitPort(win->UserPort);
	while(imsg=(struct IntuiMessage *)GetMsg(win->UserPort))
	{
	    iclass  =imsg->Class;
	    icode   =imsg->Code;
	    ReplyMsg((struct Message *)imsg);
	    switch(iclass)
	    {
	    case IDCMP_RAWKEY:
		switch(icode)
		{
		    case 0x45:		    /* ESC */
		    case 0x40:		    /* Space */
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
	printf("\tmc_bleed typ res\n");
	printf("\tres\\typ | 0=ECS | 1=AGA,GFX-Card\n");
	printf("\t--------+-------+---------------\n");
	printf("\t e (ehb)| 64    | -             \n");
	printf("\t l (low)| 32    | 256           \n");
	printf("\t h (hi )| 16    | 256           \n");
	printf("\t s (shi)| --    | 256           \n");
	printf("\t--------+-------+---------------\n");
}

void main(int argc,char *argv[])
{
    UBYTE dep,typ,fail=0;
    char res;
    UWORD eg1=0xF00,eg2=0x0F0,eg3=0x00F,eg4=0xFFF;

    if(argc>=3)
    {
	typ=atoi(argv[1])&1;
	res=argv[2][0];
	if(argc>=4) eg1=strtol(argv[3],NULL,0);
	if(argc>=5) eg2=strtol(argv[4],NULL,0);
	if(argc>=6) eg3=strtol(argv[5],NULL,0);
	if(argc>=7) eg4=strtol(argv[6],NULL,0);

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
		wintags[2].ti_Data=scrtags[2].ti_Data=354; /* 236 */
		wintags[3].ti_Data=scrtags[3].ti_Data=552; /* 276 */
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
		Bleed(eg1,eg2,eg3,eg4);
		MC_Free(mch);
	    }
	}
	else Usage();
    }
    else Usage();
    CloseAll();
}
