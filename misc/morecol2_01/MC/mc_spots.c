/******************************************************************************
**                                                                           **
** MultiColor-Demo-Spots                                                     **
**                                                                           **
**---------------------------------------------------------------------------**
** V2.0 vom 02.10.95                                                         **
******************************************************************************/

#include "sc:source/mc/multicolor.h"

/* Protos */

void OpenAll(void);
void CloseAll(void);
void Spots(void);
void ReadSpots(char *name);
void DrawSpot(UBYTE i);
double Intensity(double dist);
UBYTE GetSign(UWORD x,UWORD y,UBYTE typ);
void SetSign(UWORD x,UWORD y,UBYTE typ,double color);
void Usage(void);

/* Global */

struct
{
	UWORD	x,y;
	MCPoint	color;
	UWORD	radiusx,radiusy;
} SpotList[50];

UBYTE spotanz;

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

void Spots(void)
{
	struct IntuiMessage *imsg;
	ULONG iclass;
	USHORT icode;
	register UBYTE i=0,quit=0;
	register UWORD x,y;
	register LONG xp,yp;
	double intens,dist,pi2=1.570796327;
	MCPoint	akt;

	for(y=0;y<mch->yres;y++)
	{
		for(x=0;x<mch->xres;x++)
		{
			akt.r=akt.g=akt.b=0.0;
			for(i=0;i<spotanz;i++)
			{
				yp=y-SpotList[i].y;
				xp=x-SpotList[i].x;
				dist=sqrt((double)(xp*xp+yp*yp));
				if(dist<(SpotList[i].radiusx/5)) intens=1.0;
				else if(dist>(SpotList[i].radiusx*2.5)) intens=0.0;
				else
				{
					dist-=(SpotList[i].radiusx/5);
					dist=dist*pi2/((SpotList[i].radiusx*2.5));
					intens=(1.0-sin(dist));intens=intens*intens;
				}
				akt.r+=(intens*SpotList[i].color.r);
				akt.g+=(intens*SpotList[i].color.g);
				akt.b+=(intens*SpotList[i].color.b);
			}
			akt.r=fabs(akt.r);if(akt.r>1.0) akt.r=1.0;
			akt.g=fabs(akt.g);if(akt.g>1.0) akt.g=1.0;
			akt.b=fabs(akt.b);if(akt.b>1.0) akt.b=1.0;
			MC_PutPixel(mch,x,y,akt);
		}
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

void ReadSpots(char *name)
{
	FILE *in;
	register UBYTE i,j;
	char spotline[80],mbuf[10];

	spotanz=0;
	if(in=fopen(name,"rb"))
	{
		while(!feof(in))
		{
			j=0;
	        fgets(spotline,79,in);
			for(i=0;i<3;i++) mbuf[i]=spotline[j+i];
			mbuf[i]=0;j+=4;SpotList[spotanz].x=atoi(mbuf);
			for(i=0;i<3;i++) mbuf[i]=spotline[j+i];
			mbuf[i]=0;j+=4;SpotList[spotanz].y=atoi(mbuf);
			for(i=0;i<7;i++) mbuf[i]=spotline[j+i];
			mbuf[i]=0;j+=8;SpotList[spotanz].color.r=atof(mbuf);
			for(i=0;i<7;i++) mbuf[i]=spotline[j+i];
			mbuf[i]=0;j+=8;SpotList[spotanz].color.g=atof(mbuf);
			for(i=0;i<7;i++) mbuf[i]=spotline[j+i];
			mbuf[i]=0;j+=8;SpotList[spotanz].color.b=atof(mbuf);
			for(i=0;i<3;i++) mbuf[i]=spotline[j+i];
			mbuf[i]=0;j+=4;SpotList[spotanz].radiusx=atoi(mbuf);
			for(i=0;i<3;i++) mbuf[i]=spotline[j+i];
			mbuf[i]=0;j+=4;SpotList[spotanz].radiusy=atoi(mbuf);
			spotanz++;
		}
		fclose(in);
	}
}

double Intensity(double dist)
{
	return(0.75+(0.25*cos(dist)*(2.0-cos(dist))));
}


void Usage(void)
{
	printf("Usage \n");
	printf("\tmc_spots typ res name\n");
	printf("\tres\typ | 0=ECS | 1=AGA,GFX-Card\n");
	printf("\t--------+-------+---------------\n");
	printf("\t e (ehb)| 64    | -             \n");
	printf("\t l (low)| 32    | 256           \n");
	printf("\t h (hi )| 16    | 256           \n");
	printf("\t s (shi)| --    | 256           \n");
	printf("\t--------+-------+---------------\n");
	printf("\n\tname  spotliste\n");
}

void main(int argc,char *argv[])
{
	UBYTE dep,typ,fail=0;
	char res;

	if(argc==4)
	{
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
				ReadSpots(argv[3]);
				Spots();
			}
		}
		else Usage();
	}
	else Usage();
	CloseAll();
}
