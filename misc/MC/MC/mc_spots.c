/******************************************************************************
**									     **
** MultiColor-Demo-Spots						     **
**									     **
**---------------------------------------------------------------------------**
** V2.0 vom 02.10.95							     **
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
    UWORD   x,y;
    MCPoint color;
    UWORD   radiusx,radiusy;
} SpotList[50];

UBYTE spotanz;

int IntensTable[100];

/* defines */

extern struct ExecBase		*SysBase;
struct IntuitionBase		*IntuitionBase=0l;
struct GfxBase			*GfxBase=0l;
struct Screen			*scr=0l;
struct Window			*win=0l;
MCHandle			*mch=0l;

struct TagItem scrtags[]={
	SA_Left,		0,
	SA_Top, 		0,
	SA_Width,		0,
	SA_Height,		0,
	SA_Depth,		0,
	SA_Colors,		0l,
	SA_Type,		CUSTOMSCREEN,
	SA_DisplayID,		PAL_MONITOR_ID,
	TAG_DONE
};

struct TagItem wintags[]={
	WA_Left,		0,
	WA_Top, 		0,
	WA_Width,		0,
	WA_Height,		0,
	WA_IDCMP,		IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY,
	WA_Flags,		WFLG_SMART_REFRESH|WFLG_RMBTRAP|
				WFLG_BORDERLESS|WFLG_ACTIVATE,
	WA_CustomScreen,0l,
	TAG_DONE
};

/* Funktions */

void OpenAll(void)
{
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

LONG IntSqrt (LONG num)
{
    LONG left, right, mid;

    left = 0; right = num;

    while (right-left > 1)
    {
	mid=(left+right+1)>>1;

	if (mid*mid > num)
	    right = mid;
	else
	    left = mid;
    }

    if (left!=right)
    {
	int tmp;

	mid=left*left;
	tmp=right*right;

	if (num-mid < tmp-num)
	    mid=left;
	else
	    mid=right;
    }
    else
	mid=left;

    return mid;
}

void Spots(void)
{
    struct IntuiMessage *imsg;
    ULONG iclass;
    USHORT icode;
    register UBYTE i=0,quit=0;
    register UWORD x,y;
    register LONG xp,yp;
    int intens,idist;
    MCPoint akt;

    for (i=0; i<=90; i++)
    {
	IntensTable[i] = 256.0 * cos((PID2/90.0)*(double)i);
    }

    for ( ; i<=100; i++)
    {
	IntensTable[i] = 0;
    }

    for(y=0;y<mch->yres&&!quit;y++)
    {
	for(x=0;x<mch->xres&&!quit;x++)
	{
	    akt.r=akt.g=akt.b=0;
	    for(i=0;i<spotanz;i++)
	    {
		yp=y-SpotList[i].y;
		xp=x-SpotList[i].x;

		if (xp < 0)
		    xp = -xp;
		if (yp < 0)
		    yp = -yp;

		if (xp > SpotList[i].radiusx || yp > SpotList[i].radiusx)
		    continue;

		idist=IntSqrt (xp*xp+yp*yp);

		if (idist>=SpotList[i].radiusx)
		    continue;

		intens=IntensTable[idist*100/SpotList[i].radiusx];

		akt.r+=intens*SpotList[i].color.r >> 8;
		akt.g+=intens*SpotList[i].color.g >> 8;
		akt.b+=intens*SpotList[i].color.b >> 8;

		if (akt.r < 0) akt.r = 0; else if (akt.r > 255) akt.r = 255;
		if (akt.g < 0) akt.g = 0; else if (akt.g > 255) akt.g = 255;
		if (akt.b < 0) akt.b = 0; else if (akt.b > 255) akt.b = 255;
	    }

	    if(imsg=(struct IntuiMessage *)GetMsg(win->UserPort))
	    {
		ReplyMsg((struct Message *)imsg);
		quit=1;
		break;
	    }
	    MC_PutPixel(mch,x,y,&akt);
	}
    }

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
    char spotline[256];
    int x,y,rx,ry;
    double r,g,b;

    spotanz=0;
    if(in=fopen(name,"rb"))
    {
	while(!feof(in))
	{
	    fgets(spotline,79,in);

	    sscanf (spotline,"%i %i %lg %lg %lg %i %i",
		&x,&y,&r,&g,&b,&rx,&ry);

	    SpotList[spotanz].x=x;
	    SpotList[spotanz].y=y;
	    SpotList[spotanz].color.r=r*255;
	    SpotList[spotanz].color.g=g*255;
	    SpotList[spotanz].color.b=b*255;
	    SpotList[spotanz].radiusx=rx;
	    SpotList[spotanz].radiusy=ry;

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
    printf("\tres\\typ | 0=ECS | 1=AGA,GFX-Card\n");
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
		ReadSpots(argv[3]);
		Spots();
	    }
	}
	else Usage();
    }
    else Usage();
    CloseAll();
}
