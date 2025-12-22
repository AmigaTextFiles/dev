#ifndef INTUITION_SCREENS_H
#include <intuition/screens.h>
#endif

#include <proto/graphics.h>

#include "Global.h"

/****** gamesupport.library/GS_AllocateColors ****************************
*
*   NAME
*	GS_AllocateColors -- allocate colors in a screen.
*
*   SYNOPSIS
*	Success = GS_AllocateColors(Screen, Colors, Distinct)
*	  d0                          a0       a1       d0
*
*	ULONG GS_AllocateColors(struct Screen *,struct GS_ColorDef *,ULONG);
*
*   FUNCTION
*	Allocate the shared pens required for your program. You pass in
*	a table of RGB values, and you get a table of pens to use.
*	GS_AllocateColors() attempts to optimize the color search; so the
*	result is different from that of a normal for-loop.
*	We must call GS_FreeColors() when we're done with the pens.
*
*   INPUTS
*	Screen     - the screen we want to open on
*	Colors     - the Red, Green and Blue fields must be set by you; they
*	             will remain unchanged.
*	Distinct   - how many distinct colors to get at most. Pass 0 for
*	             no limit.
*
*   RESULT
*	Success - TRUE if everything went okay. Colors->DistinctColors
*	          will be filled in for you.
*	          If FALSE, you can check IoErr(): it returns 0 if we were
*	          unable to allocate some or all pens.
*
*    NOTE
*	The algorithm has been taken from Xmris 4.02.
*
*   SEE ALSO
*	graphics.library/ObtainBestPen(), GameSupport.h, GS_FreeColors()
*
*************************************************************************/

/* AFAIK, X uses 16 bit per gun */
#define RGB2X(r, g, b) (((LONG)(b) - (LONG)(r)) * (56756 / 2) / 65536)
#define RGB2Y(r, g, b) (((LONG)(g) - ((LONG)(r) + (LONG)(b)) / 2) / 2)
#define RGB2H(r, g, b) (((LONG)(g) * 4 + (LONG)(r) * 3 + (LONG)(b)) / 8)

SAVEDS_ASM_D0A0A1(ULONG,LibGS_AllocateColors,ULONG,Distinct,struct Screen *,Screen,struct GS_ColorDef *,Colors)

{
  struct ColorData
    {
      LONG Coord[2];			/* position in colorspace */
      ULONG Distance;			/* distance to nearest allocated color */
      ULONG PrivatePen;			/* Color number inside PrivateColorMap */
    };

  struct ColorData *ColorData;
  ULONG ColorCount;

  ColorCount=Colors->ColorCount;
  Colors->DistinctColors=0;
  if ((ColorData=GS_MemoryAlloc(ColorCount*sizeof(*ColorData))))
    {
      struct ColorMap *PrivateColorMap;

      if (!Distinct)
	{
	  Distinct=~0;
	}
      PrivateColorMap=NULL;
      if (Distinct>=ColorCount || (PrivateColorMap=GetColorMap(Distinct)))
	{
	  struct ColorMap *ColorMap;		/* the ColorMap to operate on */
	  ULONG LastAllocated;			/* the most recently allocated color */
	  struct TagItem TagList[2];

	  TagList[0].ti_Tag=OBP_Precision;
	  TagList[0].ti_Data=PRECISION_EXACT;
	  TagList[1].ti_Tag=TAG_DONE;

	  ColorMap=Screen->ViewPort.ColorMap;

	  /* init stuff */
	  {
	    ULONG i;

	    for (i=0; i<ColorCount; i++)
	      {
		Colors->Colors[i].Pen=-1L;

		ColorData[i].Coord[0] = RGB2X(Colors->Colors[i].Red>>16, Colors->Colors[i].Green>>16, Colors->Colors[i].Blue>>16);
		ColorData[i].Coord[1] = RGB2Y(Colors->Colors[i].Red>>16, Colors->Colors[i].Green>>16, Colors->Colors[i].Blue>>16);
		ColorData[i].Coord[2] = RGB2H(Colors->Colors[i].Red>>16, Colors->Colors[i].Green>>16, Colors->Colors[i].Blue>>16);
		ColorData[i].Distance=~0;
		ColorData[i].PrivatePen=~0;
	      }
	  }

	  /* find & allocate "black" */
	  {
	    ULONG Black;
	    ULONG i;

	    Black=0;
	    for (i=0; i<ColorCount; i++)
	      {
		if (ColorData[i].Coord[2]<ColorData[Black].Coord[2])
		  {
		    Black=i;
		  }
	      }
	    Colors->Colors[Black].Pen=ObtainBestPenA(ColorMap,
						     Colors->Colors[Black].Red,
						     Colors->Colors[Black].Green,
						     Colors->Colors[Black].Blue,
						     TagList);
	    Colors->DistinctColors=(Colors->Colors[Black].Pen!=-1L);
	    Distinct--;
	    LastAllocated=Black;
	  }

	  /* allocate colors in optimum order */
	  {
	    ULONG i;

	    for (i=1; Colors->DistinctColors>0 && i<ColorCount; i++)	/* we've already allocated one color */
	      {
		ULONG FarthestColor;

		/* adjust distances */
		/* find farthest color */
		{
		  ULONG j;
		  ULONG FarthestDistance;

		  FarthestDistance=0;
		  for (j=0; j<ColorCount; j++)
		    {
		      if (Colors->Colors[j].Pen==-1L)
			{
			  ULONG Distance;
			  int k;

			  Distance=0;
			  for (k=3; k--;)
			    {
			      ULONG Delta;

			      if (ColorData[LastAllocated].Coord[k]<ColorData[j].Coord[k])
				{
				  Delta=ColorData[j].Coord[k]-ColorData[LastAllocated].Coord[k];
				}
			      else
				{
				  Delta=ColorData[LastAllocated].Coord[k]-ColorData[j].Coord[k];
				}
			      Distance+=(Delta*Delta)/4;
			    }
			  if (Distance<ColorData[j].Distance)
			    {
			      ColorData[j].Distance=Distance;
			    }
			  if (ColorData[j].Distance>=FarthestDistance)
			    {
			      FarthestDistance=ColorData[j].Distance;
			      FarthestColor=j;
			    }
			}
		    }
		}

		/* allocate farthest color */
		if (Distinct)
		  {
		    Colors->Colors[FarthestColor].Pen=ObtainBestPenA(ColorMap,
								     Colors->Colors[FarthestColor].Red,
								     Colors->Colors[FarthestColor].Green,
								     Colors->Colors[FarthestColor].Blue,
								     TagList);
		  }
		else
		  {
		    ULONG Color;
		    ULONG j;

		    assert(PrivateColorMap);
		    Color=FindColor(PrivateColorMap,
				    Colors->Colors[FarthestColor].Red,
				    Colors->Colors[FarthestColor].Green,
				    Colors->Colors[FarthestColor].Blue,
				    -1);
		    for (j=0; ColorData[j].PrivatePen!=Color; j++)
		      ;
		    assert(Colors->Colors[j].Pen!=-1);
		    Colors->Colors[FarthestColor].Pen=ObtainPen(ColorMap,Colors->Colors[j].Pen,0,0,0,PEN_NO_SETCOLOR);
		  }
		if (Colors->Colors[FarthestColor].Pen==-1L)
		  {
		    Colors->DistinctColors=0;
		  }
		else if (Distinct)
		  {
		    LONG j;
		    int ReallyDistinct;

		    ReallyDistinct=TRUE;
		    for (j=0; ReallyDistinct && j<ColorCount; j++)
		      {
			if (j!=FarthestColor && Colors->Colors[j].Pen==Colors->Colors[FarthestColor].Pen)
			  {
			    ReallyDistinct=FALSE;
			  }
		      }
		    if (ReallyDistinct)
		      {
			Colors->DistinctColors++;
			Distinct--;
			if (PrivateColorMap)
			  {
			    struct
			      {
				ULONG Red, Green, Blue;
			      } Color;

			    GetRGB32(ColorMap,Colors->Colors[FarthestColor].Pen,1,&Color.Red);
			    SetRGB32CM(PrivateColorMap,Distinct,Color.Red,Color.Green,Color.Blue);
			    ColorData[FarthestColor].PrivatePen=Distinct;
			  }
		      }
		  }
		LastAllocated=FarthestColor;
	      }
	  }
	  FreeColorMap(PrivateColorMap);
	}
      /* clean up */
      GS_MemoryFree(ColorData);
      if (Colors->DistinctColors==0)
	{
	  GS_FreeColors(Screen,Colors);
	}
    }
  return Colors->DistinctColors;
}

/****** gamesupport.library/GS_FreeColors ********************************
*
*   NAME
*	GS_FreeColors -- free pens after we've used them.
*
*   SYNOPSIS
*	GS_FreeColors(Screen, Colors)
*	                a0      a1
*
*	void GS_FreeColors(struct Screen *, struct GS_ColorDef *);
*
*   FUNCTION
*	Free the pens allocated by GS_AllocateColors(). Make sure there's
*	no visible graphics with those pens still on the screen; the
*	usual thing is to close the window, then call GS_FreeColors(),
*	then unlock the screen.
*	You can call GS_FreeColors() as often as you want. You must not
*	call GS_FreeColors() on an array that had no GS_AllocateColors()
*	called on it.
*
*   INPUTS
*	Screen     - the screen. Must be the same screen as used for
*	             GS_AllocateColors(), of course.
*	Colors     - the structure filled in by GS_AllocateColors()
*
*   SEE ALSO
*	GS_AllocateColors(), graphics.library/ReleasePen()
*
*************************************************************************/

SAVEDS_ASM_A0A1(void,LibGS_FreeColors,struct Screen *,Screen,struct GS_ColorDef *,Colors)

{
  struct ColorMap *ColorMap;
  ULONG ColorCount;
  struct GS_Color *Color;

  ColorCount=Colors->ColorCount;
  ColorMap=Screen->ViewPort.ColorMap;
  Color=Colors->Colors;
  while (ColorCount)
    {
      ReleasePen(ColorMap,Color->Pen);
      Color->Pen=-1L;
      Color++;
      ColorCount--;
    }
}
