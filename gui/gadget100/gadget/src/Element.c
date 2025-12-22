/*
**	Element.c:	Strukturen für Gadgets: Image, Border, Text
**	23.09.92 - 03.10.92
*/

#include "Element.pro"
#include "Utility.pro"

#ifdef LIBRARY
#include "GadgetPrivateLibrary.h"
#include "Gadget_lib.h"
#endif

extern struct TextAttr TextAttr, BoldTextAttr;

/*
**	Funktionen für NewIntuiText
**	06.09.92 - 23.09.92
*/

static struct NewIntuiText
{
	struct IntuiText itext;
	struct IntuiText under;
	BYTE score[2];
};

struct IntuiText *gadAllocNewIntuiText(BYTE *text, SHORT x, SHORT y, SHORT frontpen, SHORT *shortcut)
{
	struct NewIntuiText *nit = NULL;
	BYTE *buffer = NULL;
	BYTE *u = text? strchr(text, UNDERSCORE) : NULL;

	if((nit = ALLOCMEM(sizeof(struct NewIntuiText))) &&
	(!text || (buffer = ALLOCMEM(NEWSTRLEN(text) + 1))))
	{
      nit->itext.FrontPen = frontpen;
		nit->itext.BackPen = 0;
		nit->itext.DrawMode = JAM1;
		nit->itext.LeftEdge = x;
		nit->itext.TopEdge = y;
		nit->itext.ITextFont = (shortcut && *shortcut == RETURN && !u)?
                           	&BoldTextAttr : &TextAttr;
		nit->itext.IText = (UBYTE *)buffer;
		nit->itext.NextText = u? &nit->under : NULL;
      if(u)
		{
	      nit->under.FrontPen = frontpen;
			nit->under.BackPen = 0;
			nit->under.DrawMode = JAM1;
			nit->under.LeftEdge = x + (u-text)*8;
			nit->under.TopEdge = y+1;
			nit->under.ITextFont = &TextAttr;
			nit->under.IText = (UBYTE *)nit->score;
			nit->under.NextText = NULL;
			nit->score[0] = '_';
			nit->score[1] = 0;
		}
		if(text && u)
		{
			strncpy(buffer, text, u-text);
			strcpy(buffer + (u-text), u+1);
			if(shortcut)
				*shortcut = *(u+1);
		}
		else if(text)
			strcpy(buffer, text);
		return(&nit->itext);
	}
	if(buffer)
		FREEMEM(buffer, NEWSTRLEN(text) + 1);
	if(nit)
		FREEMEM(nit, sizeof(struct NewIntuiText));
	return(NULL);
}

void gadFreeNewIntuiText(struct IntuiText *itext)
{
	if(itext)
   {
		if(itext->IText)
			FREEMEM(itext->IText, strlen((BYTE *)itext->IText)+1L);
		FREEMEM(itext, sizeof(struct NewIntuiText));
	}
}

/*
**	Funktionen zu IntuiText:
**	11.09.92 - 23.09.92
*/

struct IntuiText *gadAllocIntuiText(SHORT fp, SHORT bp, SHORT dm, SHORT x, SHORT y, struct TextAttr *ta, BYTE *text, struct IntuiText *ni)
{
	struct IntuiText *it;

	if(it = ALLOCMEM(sizeof(struct IntuiText)))
	{
		it->FrontPen = (fp<0)? 1 : fp;
		it->BackPen = (bp<0)? 0 : bp;
		it->DrawMode = dm;
		it->LeftEdge = x;
		it->TopEdge = y;
		it->ITextFont = ta;
		it->IText = (UBYTE *)text;
		it->NextText = ni;
	}
	return(it);
}

void gadFreeIntuiText(struct IntuiText *it)
{
	if(it)
		FREEMEM(it, sizeof(struct IntuiText));
}

/*
**	Funktionen zu Border:
**	23.09.92 - 23.09.92
*/

struct Border gadDummyBorder=
{
   0, 0, 0, 0, JAM1, 0, NULL, NULL,
};

void gadInitBorder(struct Border *bo1, struct Border *bo2, USHORT x, USHORT y, USHORT width, USHORT height, USHORT recessed)
{
   WORD *data1 = bo1->XY, *data2 = bo2->XY;

   bo1->LeftEdge = x;
	bo1->TopEdge  = y;
   bo1->FrontPen = recessed? 1 : 2;
	bo1->BackPen = 0;
	bo1->DrawMode = JAM1;
	bo1->Count = 5;
	bo1->NextBorder = bo2;
   data1[0] = 0;	data1[1] = 0;
	data1[2] = 0;	data1[3] = height-1;
	data1[4] = 1; 	data1[5] = height-2;
	data1[6] = 1; 	data1[7] = 0;
	data1[8] = width-1;	data1[9] = 0;

   bo2->LeftEdge = x;
	bo2->TopEdge  = y;
   bo2->FrontPen = recessed? 2 : 1;
	bo2->BackPen = 0;
	bo2->DrawMode = JAM1;
	bo2->Count = 5;
	bo2->NextBorder = NULL;
	data2[0] = width-1;	data2[1] = height-1;
	data2[2] = width-1;	data2[3] = 0;
	data2[4] = width-2;	data2[5] = 1;
	data2[6] = width-2;	data2[7] = height-1;
	data2[8] = 1;	data2[9] = height-1;
}

/*
**	Funktionen für Images:
**	23.09.92 - 23.09.92
*/

struct Image *gadAllocImage(SHORT x, SHORT y, SHORT w, SHORT h, SHORT depth, USHORT pick, USHORT onoff, struct Image *next)
{
	struct Image *image = NULL;
	LONG bytesperrow = ((w+15)>>4)<<1;
	LONG size = bytesperrow * h * depth;
	USHORT *ptr = NULL;

	if((image = ALLOCMEM(sizeof(struct Image))) &&
	(!size || (ptr = ALLOCCHIPMEM(bytesperrow * h * depth))))
	{
		image->LeftEdge = x;
		image->TopEdge = y;
		image->Width = w;
		image->Height = h;
		image->Depth = depth;
		image->ImageData = ptr;
		image->PlanePick = pick;
		image->PlaneOnOff = onoff;
		image->NextImage = next;

		return(image);
   }
	if(ptr)
		FREECHIPMEM(ptr, bytesperrow * h * depth);
	if(image)
		FREEMEM(image, sizeof(struct Image));
	return(NULL);
}

void gadFreeImage(struct Image *image)
{
	if(image)
   {
      LONG bytesperrow = ((image->Width+15)>>4)<<1;

		if(image->ImageData)
			FREECHIPMEM(image->ImageData, bytesperrow * image->Height * image->Depth);
      FREEMEM(image, sizeof(struct Image));
	}
}

void setpoint(UWORD *p, WORD x, WORD val);
#pragma regcall(setpoint(a0, d0, d1))

#asm

	public _setpoint:

_setpoint:  						;a0 = p, d0 = x, d1 = set/clear
	move.l	d2,-(sp)
	move.w	d0,d2
	asr.w		#3,d2
	add.w		d2,a0
	asl.w		#3,d2
	sub.w    d0,d2
	add.w		#7,d2
	tst.w		d1
	beq.s		setpoint.clr
setpoint.set:
	bset.b	d2,(a0)
	bra.s		setpoint.end
setpoint.clr:
	bclr.b	d2,(a0)
setpoint.end
	move.l	(sp)+,d2
	rts
#endasm

void gadMakeButtonImage(struct Image *image, ULONG highlight)
{
	SHORT width=image->Width, height=image->Height,
			wperrow=(width+15)>>4, bperrow=wperrow<<1,
			set=highlight? 0 : ~0, clr=~set, j;
	register UWORD *p = image->ImageData;

	if(height>1 && wperrow)
	{
		memset(p, clr, bperrow);
      setpoint(p, width-1, set); p+=wperrow;
			for(j=1; j<height-1; j++, p+=wperrow)
			{
				memset(p, clr, bperrow);
				setpoint(p, width-2, set);
				setpoint(p, width-1, set);
			}
         memset(p, set, bperrow);
			setpoint(p, 0, clr);	p+=wperrow;
         memset(p, set, bperrow);
			setpoint(p, width-1, clr); p+=wperrow;
			for(j=1; j<height-1; j++, p+=wperrow)
			{
				memset(p, clr, bperrow);
				setpoint(p, 0, set);
				setpoint(p, 1, set);
			}
			memset(p, clr, bperrow);
         setpoint(p, 0, set); p+=wperrow;
	}
}

static ULONG cyctop[]=
{
	0x01fc0000,
	0x03060000,
	0x03060000,
	0x031f8000,
	0x030f0000,
	0x03060000,
};
static ULONG cycmid=	0x03000000;
static ULONG cycbottom[]=
{
	0x03060000,
	0x01fc0000,
	0x00000000,
};

void gadMakeCycleImage(struct Image *image, ULONG highlight)
{
	SHORT width=image->Width, height=image->Height,
			wperrow=(width+15)>>4, bperrow=wperrow<<1,
			set=highlight? 0 : ~0, clr=~set,
         toph=sizeof(cyctop)/sizeof(ULONG),
			both=sizeof(cycbottom)/sizeof(ULONG), i;
	register UWORD *p1, *p2;

	gadMakeButtonImage(image, highlight);
	if(wperrow >= 2)
	{
		p1 = image->ImageData + 2*wperrow; p2 = p1+height*wperrow;
		for(i=2; i<height-2; i++, p1+=wperrow, p2+=wperrow)
		{
			setpoint(p1, 20, set);
			setpoint(p2, 21, set);
		}
   	if(height> 2+toph+both+2)
		{
			p1 = image->ImageData + 2*wperrow, p2 = p1+height*wperrow;
         for(i=0; i<toph; i++, p1+=wperrow, p2+=wperrow)
			{
				*(ULONG *)p1 |= cyctop[i];
				*(ULONG *)p2 &= ~(cyctop[i]);
			}
			for(i=2+toph; i<height-2-both; i++, p1+=wperrow, p2+=wperrow)
			{
				*(ULONG *)p1 |= cycmid;
				*(ULONG *)p2 &= ~(cycmid);
			}
         for(i=0; i<both; i++, p1+=wperrow, p2+=wperrow)
			{
				*(ULONG *)p1 |= cycbottom[i];
				*(ULONG *)p2 &= ~(cycbottom[i]);
			}
		}
	}
}

void gadMakeRecessedImage(struct Image *image, ULONG border)
{
	SHORT width=image->Width, height=image->Height,
			wperrow=(width+15)>>4, bperrow=wperrow<<1,
			set=border? ~0 : 0, clr=0, j;
	register UWORD *p = image->ImageData;

	if(height>1 && wperrow)
	{
      memset(p, set, bperrow);
		setpoint(p, width-1, clr); p+=wperrow;
		for(j=1; j<height-1; j++, p+=wperrow)
		{
			memset(p, clr, bperrow);
			setpoint(p, 0, set);
			setpoint(p, 1, set);
		}
		memset(p, clr, bperrow);
      setpoint(p, 0, set); p+=wperrow;
		memset(p, clr, bperrow);
      setpoint(p, width-1, set); p+=wperrow;
		for(j=1; j<height-1; j++, p+=wperrow)
		{
			memset(p, clr, bperrow);
			setpoint(p, width-2, set);
			setpoint(p, width-1, set);
		}
      memset(p, set, bperrow);
		setpoint(p, 0, clr);	p+=wperrow;
	}
}

