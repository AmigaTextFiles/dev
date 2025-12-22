/******************************************************************************
**                                                                           **
** MultiColor-Demo-Fract                                                     **
**                                                                           **
**---------------------------------------------------------------------------**
** V2.0 vom 01.10.95                                                         **
******************************************************************************/

// good spots
// 
// -1.460652  -1.454792  -0.002050  +0.002050  300 1
// -1.279381  -1.267661  -0.059969  -0.051769  300 1
// +0.308857  +0.319540  -0.032816  -0.025317  300 1
// +0.3121861 +0.3128537 -0.0313250 -0.0308563 400 0

#include "sc:source/mc/multicolor.h"

/* Protos */

void OpenAll(void);
void CloseAll(void);
void CRange(MCPoint *ctab,UWORD six,MCPoint sc,UWORD eix,MCPoint ec);
void Palette(MCPoint *ctab);
void Fract(double x1,double x2,double y1,double y2,UWORD it,UWORD cs,MCPoint *ctab);
void Usage(void);

/* defines */

extern struct ExecBase 		*SysBase;
struct IntuitionBase		*IntuitionBase=0l;
struct GfxBase	 			*GfxBase=0l;
struct Screen				*scr=0l;
struct Window				*win=0l;
MCHandle					*mch=0l;

#define maxc 256
MCPoint						ctab[maxc+1];


struct TagItem scrtags[]={
	SA_Left,		0,
	SA_Top,			0,
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
	WA_Top,			0,
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
	if(!(IntuitionBase=OpenLibrary("intuition.library",39))) CloseAll();
	if(!(GfxBase=OpenLibrary("graphics.library",37))) CloseAll();

	if(!(scr=OpenScreenTagList(0l,scrtags))) CloseAll();
	wintags[6].ti_Data=scr;

	if(!(win=OpenWindowTagList(0l,wintags))) CloseAll();
}

void CloseAll(void)
{
	if(win)				CloseWindow(win);
	if(scr)				CloseScreen(scr);
	if(GfxBase)			CloseLibrary(GfxBase);
	if(IntuitionBase)	CloseLibrary(IntuitionBase);
	exit(0);
}

void CRange(MCPoint *ctab,UWORD six,MCPoint sc,UWORD eix,MCPoint ec)
{
	register UWORD i;
	UWORD anz=eix-six;
	double rd,gd,bd;

	rd=(ec.r-sc.r)/(double)anz;
	gd=(ec.g-sc.g)/(double)anz;
	bd=(ec.b-sc.b)/(double)anz;
	for(i=0;i<anz;i++)
	{
		sc.r+=rd;
		sc.g+=gd;
		sc.b+=bd;
		ctab[six+i]=sc;
	}
}

void Palette(MCPoint *ctab)
{
	MCPoint p1,p2;

	p1.r=0.0;p1.g=0.0;p1.b=0.0;
	p2.r=1.0;p2.g=0.0;p2.b=0.0;CRange(ctab,  0,p1, 32,p2);
	p1.r=1.0;p1.g=1.0;p1.b=0.0;CRange(ctab, 32,p2, 64,p1);
	p2.r=0.0;p2.g=1.0;p2.b=0.0;CRange(ctab, 64,p1, 96,p2);
	p1.r=0.0;p1.g=1.0;p1.b=1.0;CRange(ctab, 96,p2,128,p1);
	p2.r=0.0;p2.g=0.0;p2.b=1.0;CRange(ctab,128,p1,160,p2);
	p1.r=1.0;p1.g=0.0;p1.b=1.0;CRange(ctab,160,p2,192,p1);
	p2.r=1.0;p2.g=0.0;p2.b=0.0;CRange(ctab,192,p1,224,p2);
	p1.r=0.0;p1.g=0.0;p1.b=0.0;CRange(ctab,224,p2,256,p1);
}

void Fract(double x1,double x2,double y1,double y2,UWORD it,UWORD cs,MCPoint *ctab)
{
	struct IntuiMessage *imsg;
	ULONG iclass;
	USHORT icode;
	register UBYTE quit=0;
	register UWORD i,j,n,h;
	MCPoint akt;
	double x,y,xd,yd,a,b,c,d;

	xd=(x2-x1)/mch->xres;
	yd=(y2-y1)/mch->yres;
	y=y1;
	for(j=0;j<mch->yres;j++)
	{
		x=x1;
		for(i=0;i<mch->xres;i++)
		{
			c=(a=x)*a;d=(b=y)*b;h=0;
			for(n=1;n<it;n++)
			{
				b=2.0*a*b+y;
				c=(a=c-d+x)*a;
				d=b*b;
				if(c+d>4.0) { h=n;n=it; }
			}
			akt=ctab[(h<<cs)%maxc];
			MC_PutPixel(mch,i,j,akt);
			x+=xd;
		}
		y+=yd;
	}


	while(!quit)
	{
		WaitPort(win->UserPort);
		while(imsg=GetMsg(win->UserPort))
		{
			iclass	=imsg->Class;
			icode	=imsg->Code;
			ReplyMsg(imsg);
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
	printf("\tmc_bleed typ res\n");
	printf("\tres\typ | 0=ECS | 1=AGA,GFX-Card\n");
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
	double x1=-2.0,x2=1.0,y1=-1.35,y2=1.35;
	UWORD it=80,cs=2;

	if(argc>=3)
	{
		typ=atoi(argv[1])&1;
		res=argv[2][0];
		if(argc>=4) x1=atof(argv[3]);
		if(argc>=5) x2=atof(argv[4]);
		if(argc>=6) y1=atof(argv[5]);
		if(argc>=7) y2=atof(argv[6]);
		if(argc>=8) it=atoi(argv[7]);
		if(argc>=9) cs=atoi(argv[8]);

		switch(typ)
		{
			case 0:		/* ECS */
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
			case 1:		/* AGA,GFX-Card */
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
				Palette(ctab);
				Fract(x1,x2,y1,y2,it,cs,ctab);
				MC_Free(mch);
			}
		}
		else Usage();
	}
	else Usage();
	CloseAll();
}
