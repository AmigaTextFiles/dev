/******************************************************************************
**                                                                           **
** MultiColor-Demo-Plasma                                                    **
**                                                                           **
**---------------------------------------------------------------------------**
** V2.0 vom 01.10.95                                                         **
******************************************************************************/

#include "sc:source/mc/multicolor.h"

/* Protos */

void OpenAll(void);
void CloseAll(void);
void Plasma(double frac);
void Usage(void);
/* defines */

extern struct ExecBase 		*SysBase;
struct IntuitionBase		*IntuitionBase=0l;
struct GfxBase	 			*GfxBase=0l;
struct Screen				*scr=0l;
struct Window				*win=0l;
MCHandle					*mch=0l;

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

void Plasma(double frac)
{
	struct IntuiMessage *imsg;
	ULONG iclass;
	USHORT icode;
	register UBYTE quit=0;
	MCPoint akt,c1,c3,c5,c7,c9;
	UWORD f[300][4],dimx,dimy;
	WORD ptr=0;
	double rndf,dimf=frac/(double)(mch->xres*mch->yres);
	UWORD x1,x2,x3,y1,y2,y3;

	srand48(time(NULL));			/* init the random-number-generator */
	f[0][0]=0;f[0][1]=0;f[0][2]=mch->xres-1;f[0][3]=mch->yres-1;

	akt.r=drand48();akt.g=drand48();akt.b=drand48();
	MC_PutPixel(mch,0,0,akt);
	akt.r=drand48();akt.g=drand48();akt.b=drand48();
	MC_PutPixel(mch,mch->xres-1,0,akt);
	akt.r=drand48();akt.g=drand48();akt.b=drand48();
	MC_PutPixel(mch,mch->xres-1,mch->yres-1,akt);
	akt.r=drand48();akt.g=drand48();akt.b=drand48();
	MC_PutPixel(mch,0,mch->xres-1,akt);
	while(ptr>-1)
	{
		dimx=f[ptr][2]-f[ptr][0];
		dimy=f[ptr][3]-f[ptr][1];
		if(dimx>1 || dimy>1)
		{
			rndf=(dimx*dimy)*dimf;
			x1=f[ptr][0];x3=f[ptr][2];x2=x1+((x3-x1)>>1);
			y1=f[ptr][1];y3=f[ptr][3];y2=y1+((y3-y1)>>1);
			c1=MC_GetPixel(mch,x1,y1);c3=MC_GetPixel(mch,x3,y1);c9=MC_GetPixel(mch,x3,y3);c7=MC_GetPixel(mch,x1,y3);

			c5.r=(c1.r+c3.r+c7.r+c9.r)/4.0+(rndf*(0.5-drand48()));
			if(c5.r>1.0) c5.r=1.0;
			if(c5.r<0.0) c5.r=0.0;
			c5.g=(c1.g+c3.g+c7.g+c9.g)/4.0+(rndf*(0.5-drand48()));
			if(c5.g>1.0) c5.g=1.0;
			if(c5.g<0.0) c5.g=0.0;
			c5.b=(c1.b+c3.b+c7.b+c9.b)/4.0+(rndf*(0.5-drand48()));
			if(c5.b>1.0) c5.b=1.0;
			if(c5.b<0.0) c5.b=0.0;
			MC_PutPixel(mch,x2,y2,c5);
			akt=MC_GetPixel(mch,x2,y1);
			if(akt.r==0.0 && akt.g==0.0 && akt.b==0.0)
			{
				akt.r=(c1.r+c3.r+c5.r)/3.0;
				akt.g=(c1.g+c3.g+c5.g)/3.0;
				akt.b=(c1.b+c3.b+c5.b)/3.0;
				MC_PutPixel(mch,x2,y1,akt); 
			}
			akt=MC_GetPixel(mch,x1,y2);
			if(akt.r==0.0 && akt.g==0.0 && akt.b==0.0)
			{
				akt.r=(c1.r+c7.r+c5.r)/3.0;
				akt.g=(c1.g+c7.g+c5.g)/3.0;
				akt.b=(c1.b+c7.b+c5.b)/3.0;
				MC_PutPixel(mch,x1,y2,akt); 
			}
			akt=MC_GetPixel(mch,x3,y2);
			if(akt.r==0.0 && akt.g==0.0 && akt.b==0.0)
			{
				akt.r=(c3.r+c9.r+c5.r)/3.0;
				akt.g=(c3.g+c9.g+c5.g)/3.0;
				akt.b=(c3.b+c9.b+c5.b)/3.0;
				MC_PutPixel(mch,x3,y2,akt); 
			}
			akt=MC_GetPixel(mch,x2,y3);
			if(akt.r==0.0 && akt.g==0.0 && akt.b==0.0)
			{
				akt.r=(c7.r+c9.r+c5.r)/3.0;
				akt.g=(c7.g+c9.g+c5.g)/3.0;
				akt.b=(c7.b+c9.b+c5.b)/3.0;
				MC_PutPixel(mch,x2,y3,akt); 
			}
			f[ptr][2]=x2;f[ptr][3]=y2;ptr++;
			f[ptr][0]=x2;f[ptr][1]=y1;f[ptr][2]=x3;f[ptr][3]=y2;ptr++;
			f[ptr][0]=x2;f[ptr][1]=y2;f[ptr][2]=x3;f[ptr][3]=y3;ptr++;
			f[ptr][0]=x1;f[ptr][1]=y2;f[ptr][2]=x2;f[ptr][3]=y3;
			if(ptr>250)
			{
				printf("stack overflow\n");
				ptr=-1;
			}
		}
		else ptr--;
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
	printf("\tmc_plasma typ res chaos\n");
	printf("\tres\typ | 0=ECS | 1=AGA,GFX-Card\n");
	printf("\t--------+-------+---------------\n");
	printf("\t e (ehb)| 64    | -             \n");
	printf("\t l (low)| 32    | 256           \n");
	printf("\t h (hi )| 16    | 256           \n");
	printf("\t s (shi)| --    | 256           \n");
	printf("\t--------+-------+---------------\n");
	printf("\n\tchaos smothness\n");
}

void main(int argc,char *argv[])
{
	UBYTE dep,typ,fail=0;
	char res;
	double frac=20.0;

	if(argc>=3)
	{
		if(argc==4) frac=atof(argv[3]);
		typ=atoi(argv[1])&1;
		res=argv[2][0];

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
				Plasma(frac);
				MC_Free(mch);
			}
		}
		else Usage();
	}
	else Usage();
	CloseAll();
}
