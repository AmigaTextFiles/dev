/******************************************************************************
**									     **
** MultiColor-Include							     **
**									     **
**---------------------------------------------------------------------------**
** V2.0 vom 01.10.95							     **
******************************************************************************/

/* Prototypes für Libraryfunctions */

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>

/* Includes */

#include <exec/types.h>
#include <exec/exec.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <graphics/gfx.h>
#include <graphics/gfxmacros.h>
#include <graphics/display.h>
#include <graphics/displayinfo.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

/* die entsprechenden Matheroutinen includen */

#ifdef _M68881
    #include <m68881.h>
#endif

/* Definitionen */

typedef struct
{
    ULONG   Red,Green,Blue;
} Triplet_32;

typedef struct
{
    WORD	    NumColors;
    WORD	    FirstColor;
    Triplet_32	    Triplet[256];
    WORD	    Terminator;
} Palette_32;

typedef struct
{
    WORD r,g,b;
} MCPoint;

void MC_PrintPoint (MCPoint * point)
{
    printf ("Point [%5d:%5d:%5d]\n"
	, point->r
	, point->g
	, point->b
	);
}

typedef struct
{
    struct RastPort   rp[256];	    /* One Rastport for each pen	*/
    struct ViewPort * vp;	    /* The associated ViewPort		*/
    UBYTE	      ix_r[86],     /* Pen for RED fraction of color	*/
		      ix_g[86],     /* Pen for GREEN fraction of color	*/
		      ix_b[86];     /* Pen for BLUE fraction of color	*/
    UBYTE	      ix_back[256]; /* Pen to Color reversal		*/
    UWORD	      xres,	    /* Resolution in X (This is NOT
					screen->Width !!!)		*/
		      yres;	    /* Resolution in Y			*/
    Palette_32	      palette;	    /* The palette for the screen	*/
    MCPoint	      error;	    /* This contains the mismatch for
					the last few colors.		*/
    UBYTE	      cfact;	    /* Factor for Color->Pen		*/
    UWORD	    * ymod;	    /* [0..yres] Gives y%3		*/
} MCHandle;

/* Functions ************************************************************************************************/

MCHandle *MC_Init(struct Screen *scr,struct Window *win,UBYTE dep)
{
    register UWORD i,cnum;
    MCHandle *mch=0l;
    UBYTE cd[17];

    if(mch=AllocMem(sizeof(MCHandle),MEMF_ANY|MEMF_CLEAR))
    {
	mch->xres=scr->Width*2/3;
	mch->yres=scr->Height>>1;

	if (!(mch->ymod = AllocMem(sizeof(UWORD)*mch->yres,MEMF_ANY)) )
	{
	    FreeMem (mch,sizeof(MCHandle));
	    return NULL;
	}

	for (i=cnum=0; i<mch->yres; i++)
	{
	    mch->ymod[i] = cnum ++;

	    if (cnum==3)
		cnum=0;
	}

	mch->vp=&scr->ViewPort;
	for(i=0;i<(1L<<dep);i++)
	{
	    mch->rp[i]=*win->RPort;
	    SetAPen(&(mch->rp[i]),i);
	}

	mch->palette.Triplet[0].Red  =0l;
	mch->palette.Triplet[0].Green=0l;
	mch->palette.Triplet[0].Blue =0l;

	switch(dep)
	{
	case 4: 		/* r,g,b  6 Abstufungen =>    216 Farben */
	    cd[1]=48;cd[2]=96;cd[3]=144;cd[4]=192;cd[5]=240;
	    cnum=1;
	    mch->ix_b[0]=mch->ix_g[0]=mch->ix_r[0]=0;
	    for(i=1;i<6;i++) { mch->ix_b[i]=cnum;cnum++; }
	    for(i=1;i<6;i++) { mch->ix_g[i]=cnum;cnum++; }
	    for(i=1;i<6;i++) { mch->ix_r[i]=cnum;cnum++; }

	    cnum=1;
	    mch->ix_back[0]=0;
	    for(i=1;i<6;i++) { mch->ix_back[cnum]=i;cnum++; }
	    for(i=1;i<6;i++) { mch->ix_back[cnum]=i;cnum++; }
	    for(i=1;i<6;i++) { mch->ix_back[cnum]=i;cnum++; }

	    cnum=1;
	    for(i=1;i<6;i++)
	    {
		mch->palette.Triplet[cnum].Red	=0l;
		mch->palette.Triplet[cnum].Green=0l;
		mch->palette.Triplet[cnum].Blue =(ULONG)(0x01010101*cd[i]);
		cnum++;
	    }
	    for(i=1;i<6;i++)
	    {
		mch->palette.Triplet[cnum].Red	=0l;
		mch->palette.Triplet[cnum].Green=(ULONG)(0x01010101*cd[i]);
		mch->palette.Triplet[cnum].Blue =0l;
		cnum++;
	    }
	    for(i=1;i<6;i++)
	    {
		mch->palette.Triplet[cnum].Red	=(ULONG)(0x01010101*cd[i]);
		mch->palette.Triplet[cnum].Green=0l;
		mch->palette.Triplet[cnum].Blue =0l;
		cnum++;
	    }
	    mch->palette.NumColors=16;
	    mch->cfact=5;
	    break;

	case 5: 		/* r,g,b 11 Abstufungen =>   1331 Farben */
	    cd[1]=32;cd[2]=48;cd[3]=80;cd[4]=96;cd[5]=128;cd[6]=144;
	    cd[7]=176;cd[8]=192;cd[9]=224;cd[10]=240;
	    cnum=1;
	    mch->ix_b[0]=mch->ix_g[0]=mch->ix_r[0]=0;
	    for(i=1;i<11;i++) { mch->ix_b[i]=cnum;cnum++; }
	    for(i=1;i<11;i++) { mch->ix_g[i]=cnum;cnum++; }
	    for(i=1;i<11;i++) { mch->ix_r[i]=cnum;cnum++; }

	    cnum=1;
	    mch->ix_back[0]=0;
	    for(i=1;i<11;i++) { mch->ix_back[cnum]=i;cnum++; }
	    for(i=1;i<11;i++) { mch->ix_back[cnum]=i;cnum++; }
	    for(i=1;i<11;i++) { mch->ix_back[cnum]=i;cnum++; }

	    cnum=1;
	    for(i=1;i<11;i++)
	    {
		mch->palette.Triplet[cnum].Red	=0l;
		mch->palette.Triplet[cnum].Green=0l;
		mch->palette.Triplet[cnum].Blue =(ULONG)(0x01010101*(i<<4));
		cnum++;
	    }
	    for(i=1;i<11;i++)
	    {
		mch->palette.Triplet[cnum].Red	=0l;
		mch->palette.Triplet[cnum].Green=(ULONG)(0x01010101*(i<<4));
		mch->palette.Triplet[cnum].Blue =0l;
		cnum++;
	    }
	    for(i=1;i<11;i++)
	    {
		mch->palette.Triplet[cnum].Red	=(ULONG)(0x01010101*(i<<4));
		mch->palette.Triplet[cnum].Green=0l;
		mch->palette.Triplet[cnum].Blue =0l;
		cnum++;
	    }
	    mch->palette.Triplet[cnum].Red  =0xFFFFFFFF;
	    mch->palette.Triplet[cnum].Green=0xFFFFFFFF;
	    mch->palette.Triplet[cnum].Blue =0xFFFFFFFF;
	    mch->palette.NumColors=32;
	    mch->cfact=10;
	    break;

	case 6: 		/* r,g,b 16 Abstufungen =>   4096 Farben */
	    cd[1]=32;cd[2]=48;cd[3]=128;cd[4]=144;cd[5]=160;cd[6]=176;
	    cd[7]=192;cd[8]=208;cd[9]=224;cd[10]=240;
	    mch->ix_b[0]=mch->ix_g[0]=mch->ix_r[0]=0;
	    mch->ix_b[ 1]=33;mch->ix_g[ 1]=43;mch->ix_r[ 1]=53;
	    mch->ix_b[ 2]= 1;mch->ix_g[ 2]=11;mch->ix_r[ 2]=21;
	    mch->ix_b[ 3]= 2;mch->ix_g[ 3]=12;mch->ix_r[ 3]=22;
	    mch->ix_b[ 4]=36;mch->ix_g[ 4]=46;mch->ix_r[ 4]=56;
	    mch->ix_b[ 5]=38;mch->ix_g[ 5]=48;mch->ix_r[ 5]=58;
	    mch->ix_b[ 6]=40;mch->ix_g[ 6]=50;mch->ix_r[ 6]=60;
	    mch->ix_b[ 7]=42;mch->ix_g[ 7]=52;mch->ix_r[ 7]=62;
	    mch->ix_b[ 8]= 3;mch->ix_g[ 8]=13;mch->ix_r[ 8]=23;
	    mch->ix_b[ 9]= 4;mch->ix_g[ 9]=14;mch->ix_r[ 9]=24;
	    mch->ix_b[10]= 5;mch->ix_g[10]=15;mch->ix_r[10]=25;
	    mch->ix_b[11]= 6;mch->ix_g[11]=16;mch->ix_r[11]=26;
	    mch->ix_b[12]= 7;mch->ix_g[12]=17;mch->ix_r[12]=27;
	    mch->ix_b[13]= 8;mch->ix_g[13]=18;mch->ix_r[13]=28;
	    mch->ix_b[14]= 9;mch->ix_g[14]=19;mch->ix_r[14]=29;
	    mch->ix_b[15]=10;mch->ix_g[15]=20;mch->ix_r[15]=30;

	    cnum=1;
	    mch->ix_back[ 0]= 0;
	    mch->ix_back[33]=mch->ix_back[43]=mch->ix_back[53]= 1;
	    mch->ix_back[ 1]=mch->ix_back[11]=mch->ix_back[21]= 2;
	    mch->ix_back[ 2]=mch->ix_back[12]=mch->ix_back[22]= 3;
	    mch->ix_back[36]=mch->ix_back[46]=mch->ix_back[56]= 4;
	    mch->ix_back[38]=mch->ix_back[48]=mch->ix_back[58]= 5;
	    mch->ix_back[40]=mch->ix_back[50]=mch->ix_back[60]= 6;
	    mch->ix_back[42]=mch->ix_back[52]=mch->ix_back[62]= 7;
	    mch->ix_back[ 3]=mch->ix_back[13]=mch->ix_back[23]= 8;
	    mch->ix_back[ 4]=mch->ix_back[14]=mch->ix_back[24]= 9;
	    mch->ix_back[ 5]=mch->ix_back[15]=mch->ix_back[25]=10;
	    mch->ix_back[ 6]=mch->ix_back[16]=mch->ix_back[26]=11;
	    mch->ix_back[ 7]=mch->ix_back[17]=mch->ix_back[27]=12;
	    mch->ix_back[ 8]=mch->ix_back[18]=mch->ix_back[28]=13;
	    mch->ix_back[ 9]=mch->ix_back[19]=mch->ix_back[29]=14;
	    mch->ix_back[10]=mch->ix_back[20]=mch->ix_back[30]=15;

	    cnum=1;
	    for(i=1;i<11;i++)
	    {
		mch->palette.Triplet[cnum].Red	=0l;
		mch->palette.Triplet[cnum].Green=0l;
		mch->palette.Triplet[cnum].Blue =(ULONG)(0x01010101*cd[i]);
		cnum++;
	    }
	    for(i=1;i<11;i++)
	    {
		mch->palette.Triplet[cnum].Red	=0l;
		mch->palette.Triplet[cnum].Green=(ULONG)(0x01010101*cd[i]);
		mch->palette.Triplet[cnum].Blue =0l;
		cnum++;
	    }
	    for(i=1;i<11;i++)
	    {
		mch->palette.Triplet[cnum].Red	=(ULONG)(0x01010101*cd[i]);
		mch->palette.Triplet[cnum].Green=0l;
		mch->palette.Triplet[cnum].Blue =0l;
		cnum++;
	    }
	    mch->palette.Triplet[cnum].Red  =0xFFFFFFFF;
	    mch->palette.Triplet[cnum].Green=0xFFFFFFFF;
	    mch->palette.Triplet[cnum].Blue =0xFFFFFFFF;
	    mch->palette.NumColors=32;
	    mch->cfact=15;
	    break;

	case 8: 		/* r,g,b 85 Abstufungen => 614125 Farben */
	    cnum=1;
	    mch->ix_b[0]=0;
	    for(i=1;i<85;i++) { mch->ix_b[i]=cnum;cnum++; }
	    mch->ix_g[0]=0;
	    for(i=1;i<85;i++) { mch->ix_g[i]=cnum;cnum++; }
	    mch->ix_r[0]=0;
	    for(i=1;i<85;i++) { mch->ix_r[i]=cnum;cnum++; }

	    cnum=1;
	    mch->ix_back[0]=0;
	    for(i=1;i<85;i++) { mch->ix_back[cnum]=i;cnum++; }
	    for(i=1;i<85;i++) { mch->ix_back[cnum]=i;cnum++; }
	    for(i=1;i<85;i++) { mch->ix_back[cnum]=i;cnum++; }

	    cnum=1;
	    for(i=1;i<85;i++)
	    {
		mch->palette.Triplet[cnum].Red	=0l;
		mch->palette.Triplet[cnum].Green=0l;
		mch->palette.Triplet[cnum].Blue =(ULONG)(0x01010101*(i*3));
		cnum++;
	    }
	    for(i=1;i<85;i++)
	    {
		mch->palette.Triplet[cnum].Red	=0l;
		mch->palette.Triplet[cnum].Green=(ULONG)(0x01010101*(i*3));
		mch->palette.Triplet[cnum].Blue =0l;
		cnum++;
	    }
	    for(i=1;i<85;i++)
	    {
		mch->palette.Triplet[cnum].Red	=(ULONG)(0x01010101*(i*3));
		mch->palette.Triplet[cnum].Green=0l;
		mch->palette.Triplet[cnum].Blue =0l;
		cnum++;
	    }
	    mch->palette.Triplet[cnum].Red  =0xFFFFFFFF;
	    mch->palette.Triplet[cnum].Green=0xFFFFFFFF;
	    mch->palette.Triplet[cnum].Blue =0xFFFFFFFF;
	    mch->palette.NumColors=256;
	    mch->cfact=84;
	    break;
	} /* switch */

	mch->palette.FirstColor=0;
	mch->palette.Terminator=0;
	LoadRGB32(mch->vp,(ULONG *)&(mch->palette));

	mch->error.r=mch->error.g=mch->error.b=0;
    }
    return(mch);
}

void MC_Free(MCHandle *mch)
{
    if(mch)
	FreeMem(mch,sizeof(MCHandle));
}

/***********************************************************************************************************/

#ifndef MC_PATTERN
#   define MC_PATTERN 2
#endif

/* Offsets for the pixels. Every position is mapped to three distinct
    points. */
static UWORD MC_Coords[3][2][6] =
{
    /* Pattern 1 (original) */
#if MC_PATTERN==1
    /*	GB R
	R GB

	RG B
	B RG

	BR G
	G BR */
{ /* y==0 */
    { /* x==0 */
	/*R:*/ 0,1, /*G:*/ 0,0, /*B*/ 1,0,
    },
    { /* x==1 */
	/*R:*/ 1,0, /*G:*/ 0,1, /*B*/ 1,1,
    }
},
{ /* y==1 */
    { /* x==0 */
	/*R:*/ 0,0, /*G:*/ 1,0, /*B*/ 0,1,
    },
    { /* x==1 */
	/*R:*/ 0,1, /*G:*/ 1,1, /*B*/ 1,0,
    }
},
{ /* y==2 */
    { /* x==0 */
	/*R:*/ 1,0, /*G:*/ 0,1, /*B*/ 0,0,
    },
    { /* x==1 */
	/*R:*/ 1,1, /*G:*/ 1,0, /*B*/ 0,1,
    }
}
#elif MC_PATTERN==2
    /*	RG B
	B RG

	GB R
	R GB

	BR G
	G BR */
{ /* y==0 */
    { /* x==0 */
	/*R:*/ 0,0, /*G:*/ 1,0, /*B*/ 0,1,
    },
    { /* x==1 */
	/*R:*/ 0,1, /*G:*/ 1,1, /*B*/ 1,0,
    }
},
{ /* y==1 */
    { /* x==0 */
	/*R:*/ 0,1, /*G:*/ 0,0, /*B*/ 1,0,
    },
    { /* x==1 */
	/*R:*/ 1,0, /*G:*/ 0,1, /*B*/ 1,1,
    }
},
{ /* y==2 */
    { /* x==0 */
	/*R:*/ 1,0, /*G:*/ 0,1, /*B*/ 0,0,
    },
    { /* x==1 */
	/*R:*/ 1,1, /*G:*/ 1,0, /*B*/ 0,1,
    }
}
#elif MC_PATTERN==3
    /*	GB G
	R RB

	GB G
	R RB

	GB G
	R RB */
{ /* y==0 */
    { /* x==0 */
	/*R:*/ 0,1, /*G:*/ 0,0, /*B*/ 1,0,
    },
    { /* x==1 */
	/*R:*/ 0,1, /*G:*/ 1,0, /*B*/ 1,1,
    }
},
{ /* y==1 */
    { /* x==0 */
	/*R:*/ 0,1, /*G:*/ 0,0, /*B*/ 1,0,
    },
    { /* x==1 */
	/*R:*/ 0,1, /*G:*/ 1,0, /*B*/ 1,1,
    }
},
{ /* y==2 */
    { /* x==0 */
	/*R:*/ 0,1, /*G:*/ 0,0, /*B*/ 1,0,
    },
    { /* x==1 */
	/*R:*/ 0,1, /*G:*/ 1,0, /*B*/ 1,1,
    }
}
#endif
};

void MC_PutPixel(MCHandle *mch,UWORD x,UWORD y,MCPoint *pt)
{
    UWORD rx,ry;
    UBYTE r,g,b;
    UWORD t,*cptr;
    struct RastPort * rp = mch->rp;

    rx=x+(x>>1);
    ry=y<<1;

    t=pt->r*mch->cfact+mch->error.r; mch->error.r=(BYTE)t&0xFF; r=t>>8;
    t=pt->g*mch->cfact+mch->error.g; mch->error.g=(BYTE)t&0xFF; g=t>>8;
    t=pt->b*mch->cfact+mch->error.b; mch->error.b=(BYTE)t&0xFF; b=t>>8;

    r = mch->ix_r[r];
    g = mch->ix_g[g];
    b = mch->ix_b[b];

    cptr = MC_Coords[mch->ymod[y]][x&1];

    WritePixel (&rp[r],rx+cptr[0],ry+cptr[1]);
    WritePixel (&rp[g],rx+cptr[2],ry+cptr[3]);
    WritePixel (&rp[b],rx+cptr[4],ry+cptr[5]);
}

void MC_GetPixel(MCHandle *mch,UWORD x,UWORD y,MCPoint *akt)
{
    UWORD rx,ry,*cptr;
    UBYTE r,g,b;
    struct RastPort * rp = &mch->rp[0];

    r = g = b = 0;
    rx = x + (x >> 1);
    ry = y << 1;

    cptr = MC_Coords[mch->ymod[y]][x&1];

    r=ReadPixel (rp,rx+cptr[0],ry+cptr[1]);
    g=ReadPixel (rp,rx+cptr[2],ry+cptr[3]);
    b=ReadPixel (rp,rx+cptr[4],ry+cptr[5]);

    akt->r=(mch->ix_back[r]<<8)/mch->cfact;
    akt->g=(mch->ix_back[g]<<8)/mch->cfact;
    akt->b=(mch->ix_back[b]<<8)/mch->cfact;
}
