/*
 *	File:					CustomGadgets.c
 *	Description:	
 *
 *	(C) 1994, Ketil Hunn.
 *
 */

#ifndef	EG_POPUPGADGET_C
#define	EG_POPUPGADGET_C

#define	EG_POPUPHEIGHT	9

#define	MRW	8

#define EG_PopUpGadgetWidth	17


__chip static const UWORD EG_GetDirImageData[]={
	0x03c0,	/* ......****...... */
	0x0420,	/* .....*....*..... */
	0xf810,	/* *****......*.... */
	0xfc10,	/* ******.....*.... */
	0xc3f0,	/* **....******.... */
	0xc010,	/* **.........*.... */
	0xc010,	/* **.........*.... */
	0xc010,	/* **.........*.... */
	0xc010,	/* **.........*.... */
	0xfff0,	/* ************.... */
};

__chip static const UWORD EG_PopUpImageData[] = {
	0x1c00,	/* ...***.......... */
	0x1c00,	/* ...***.......... */
	0x1c00,	/* ...***.......... */
	0x7f00,	/* .*******........ */
	0x3e00,	/* ..*****......... */
	0x1c00,	/* ...***.......... */
	0x0800,	/* ....*........... */
	0x0000,	/* ................ */
	0x7f00,	/* .*******........ */
};

struct egGadget
{
	struct Gadget *gadget;
	struct BitMap ImageBitMap;
	struct BitMap BitMap;

	struct Image Image1;
	struct Image Image2;
};

__asm void egCalcGadgetImage(register __a0 struct egGadget	*gad,
														register __a1 struct DrawInfo		*dri,
														register __a2 struct NewGadget	*ng,
														register __d0 WORD							imageheight)
{
	struct RastPort	rp;
	static ULONG gadgetdatasize;
	ULONG gaddepth=dri->dri_Depth;
	UBYTE *chipdata;

	/* Calculate byte count for chip data (Image data are UWORDs!) */
	gadgetdatasize=(EG_PopUpGadgetWidth+15)/16*2*2*ng.ng_Height*gaddepth;

	/* Allocate memory for image */
	if(chipdata=AllocVec(gadgetdatasize, MEMF_PUBLIC|MEMF_CLEAR|MEMF_CHIP))
	{
		ULONG planemask=(1L<<gaddepth)-1;
		ULONG yoff=(ng.ng_Height-EG_POPUPHEIGHT)/2;

		/* Init Image structure */
		popup->Image1.LeftEdge		=0;
		popup->Image1.TopEdge			=0;
		popup->Image1.Width				=EG_PopUpGadgetWidth;
		popup->Image1.Height			=ng.ng_Height;
		popup->Image1.Depth				=gaddepth;
		popup->Image1.PlanePick		=planemask;
		popup->Image1.PlaneOnOff	=0;
		popup->Image1.NextImage		=NULL;
		popup->Image2							=popup->Image1;
		popup->Image1.ImageData		=(UWORD *)chipdata;
		popup->Image2.ImageData		=(UWORD *)(chipdata+gadgetdatasize/2);

		/* Init graphics structures */
		InitBitMap(&popup->BitMap, gaddepth, EG_PopUpGadgetWidth, ng.ng_Height);
		InitRastPort(&rp);
		rp.BitMap=&popup->BitMap;

		/* Set plane pointers */
		{
			int i;
			ULONG off=gadgetdatasize/gaddepth/2;
			UBYTE *pl=(UBYTE *)popup->Image1.ImageData;

			for(i=0; i<gaddepth; i++, pl+=off)
				popup->BitMap.Planes[i]=pl;
		}

		/* Draw button image (deselected state) */
		SetRast(&rp, dri->dri_Pens[BACKGROUNDPEN]);
		DrawBevelBox(&rp,
									0, 0, EG_PopUpGadgetWidth, ng.ng_Height,
									GT_VisualInfo, ng->ng_VisualInfo,
									TAG_DONE);
		BltBitMap(&popup->ImageBitMap,
							0, 0, &popup->BitMap, 4 , yoff, imageheight, EG_POPUPHEIGHT, ANBC, planemask, NULL);
		BltBitMap(&popup->ImageBitMap,
							0, 0, &popup->BitMap, 4, yoff, imageheight, EG_POPUPHEIGHT, ABC|ABNC|ANBC,
							dri->dri_Pens[TEXTPEN],NULL);

		/* Set plane pointers */
		{
			int i;
			ULONG off=gadgetdatasize/gaddepth/2;
			UBYTE *pl=(UBYTE *)popup->Image2.ImageData;

			for(i=0; i<gaddepth; i++, pl+=off)
				popup->BitMap.Planes[i]=pl;
		}

		/* Draw button image (selected state) */
		SetRast(&rp, dri->dri_Pens[FILLPEN]);
		DrawBevelBox(&rp, 0, 0, EG_PopUpGadgetWidth, ng.ng_Height,
									GT_VisualInfo,	ng->ng_VisualInfo,
									GTBB_Recessed,	FALSE,
									TAG_DONE);
		BltBitMap(&popup->ImageBitMap, 0,0, &popup->BitMap, 4, yoff, imageheight, EG_POPUPHEIGHT, ANBC, planemask,NULL);
		BltBitMap(&popup->ImageBitMap, 0,0, &popup->BitMap, 4, yoff, imageheight, EG_POPUPHEIGHT, ABC|ABNC|ANBC,
														dri->dri_Pens[FILLTEXTPEN],NULL);
	}
}

__asm __saveds struct Gadget *mrCreateGadgetA(register __d0 ULONG								kind,
																							register __a1 struct Gadget				*previous,
																							register __a2 struct NewGadget		*ng, 
																							register __a3 APTR								mrgadget,
																							register __a4 struct DrawInfo			*dri,
																							register __a0 struct TagItem			*taglist)
{
	struct Gadget	*gad;
	
	gad=CreateGadget(GENERIC_KIND, previous, ng, 
										TAG_MORE,	taglist,
										TAG_END);
		
	switch(kind)
	{
		case POPUP_KIND:		
			{
				struct PopUpGadget	*popup=(struct PopUpGadget *)mrgadget;

				popup->type											=kind;
				ng->ng_Width										=EG_PopUpGadgetWidth;
				popup->ImageBitMap.BytesPerRow	=2;
				popup->ImageBitMap.Rows					=EG_POPUPHEIGHT;
				popup->ImageBitMap.Flags				=0;
				popup->ImageBitMap.Depth				=8;
				popup->ImageBitMap.pad					=0;
				popup->ImageBitMap.Planes[0]		=
				popup->ImageBitMap.Planes[1]		=
				popup->ImageBitMap.Planes[2]		=
				popup->ImageBitMap.Planes[3]		=
				popup->ImageBitMap.Planes[4]		=
				popup->ImageBitMap.Planes[5]		=
				popup->ImageBitMap.Planes[6]		=
				popup->ImageBitMap.Planes[7]		=(PLANEPTR) EG_PopUpImageData;

				mrCalcPopUpImage(popup, dri, ng, (ULONG)ng->ng_Height);

				gad->Flags				=GFLG_GADGHIMAGE|GFLG_GADGIMAGE;
				gad->Activation		=GACT_RELVERIFY;
				gad->GadgetType		|=GTYP_BOOLGADGET;
				gad->GadgetRender	=&popup->Image1;
				gad->SelectRender	=&popup->Image2;
			}
			break;
	}
	return gad;
}

struct Gadget *mrCreateGadget(	ULONG								kind,
																struct Gadget				*previous,
																struct NewGadget		*ng, 
																APTR								mrgadget,
																struct DrawInfo			*dri,
																Tag									tag1, ...)
{
	return mrCreateGadgetA(kind, previous, ng, mrgadget, dri, (struct TagItem *)&tag1);
}

__asm __saveds void mrFreeGadget(register __a0 APTR *mrgadget)
{
#ifdef MYDEBUG_H
	DebugOut("EG_FreePopUpGadget");
#endif

	if(mrgadget)
	{
		struct PopUpGadget	*popup=(struct PopUpGadget *)mrgadget;

		switch(popup->type)
		{
			case POPUP_KIND:
				FreeVec(popup->Image1.ImageData);
				break;
		}
	}
}

#endif
