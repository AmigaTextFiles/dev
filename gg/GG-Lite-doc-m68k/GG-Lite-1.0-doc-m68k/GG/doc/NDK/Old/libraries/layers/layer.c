/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

#include <exec/types.h>
#include <graphics/gfxbase.h>
#include <graphics/layers.h>
#include <proto/all.h>
#include <stdlib.h>
#include <string.h>

VOID clean_exit(LONG retc);
VOID cleanUp(VOID);
VOID myOrCols(struct Region *region);
VOID pMessage(UBYTE *string);
VOID myLabelRegion( struct Region *region, struct Layer *layer,
					LONG color, UBYTE *string);
VOID myLabelAllRegions(LONG color);
VOID myLabelLayer( struct Layer *layer, LONG color, UBYTE *string);
VOID myResetRegions(VOID);

#define L_DELAY 100
#define S_DELAY 50

#define DUMMY 0L

#define CLR_RED 1
#define CLR_GRN 2
#define CLR_BLU 3

#define SCREEN_D 2
#define SCREEN_W 320
#define SCREEN_H 200

/* the starting size of example layers, offsets are used for placement */
#define W_H 50
#define W_T 5
#define W_B (W_T+W_H)-1
#define W_W 80
#define W_L (SCREEN_W/2) - (W_W/2)
#define W_R (W_L+W_W)-1

/* size of the superbitmap */
#define SUPER_H SCREEN_H
#define SUPER_W SCREEN_W

/* starting size of the message layer */
#define M_H 10
#define M_T SCREEN_H-M_H
#define M_B (M_T+M_H)-1
#define M_W SCREEN_W
#define M_L 0
#define M_R (M_L+M_W)-1

/* This example shows how to use the layers.library.
** This code may be freely utilized to develop programs for the Amiga.
*/
struct GfxBase *GfxBase;
struct Library *LayersBase;

/* global for FreeMem() */
struct View *oldview = NULL;    /* save old view so can go back to sys */
struct View theView;
struct ViewPort theViewPort;
/* pointer to colormap struct, dynamic alloc */
struct ColorMap *theColorMap = NULL;
struct BitMap theBitMap, theSuperBitMap;
struct Layer *theLayers[3] =  { NULL, NULL, NULL, };
struct Layer *msgLayer = NULL;
LONG theLayerFlags[3] = { LAYERSUPER, LAYERSMART, LAYERSIMPLE };
struct Layer_Info *theLayerInfo = NULL;

USHORT colortable[] = { 0x000, 0xf00, 0x0f0, 0x00f };
struct Region *ColRegion = NULL;
struct Region *RowRegion = NULL;
struct Region *theRegions[3] = { NULL, NULL, NULL };

VOID main(int argc, char **argv)
{
struct RasInfo theRasInfo;
short iii,jjj;
UWORD *colorpalette;
struct Rectangle rect;  /* some rectangle structures */

if ((GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",0)) == NULL)
	exit(RETURN_WARN);

if((LayersBase = OpenLibrary("layers.library",0)) == NULL)
	clean_exit(RETURN_WARN);

/* example steals screen from Intuition,
** this is just an example.  In real life, open your own.
*/
oldview = GfxBase->ActiView;    /* save current view, go back later */

/* get a LayerInfo structure */
if((theLayerInfo = NewLayerInfo()) == NULL)
	clean_exit(RETURN_WARN);

InitView(&theView);
theView.ViewPort = &theViewPort;
InitVPort(&theViewPort);

theViewPort.DWidth  = SCREEN_W;
theViewPort.DHeight = SCREEN_H;
theViewPort.RasInfo = &theRasInfo;

InitBitMap(&theBitMap,SCREEN_D,SCREEN_W,SCREEN_H);

theRasInfo.BitMap   = &theBitMap;
theRasInfo.RxOffset = 0;
theRasInfo.RyOffset = 0;
theRasInfo.Next     = NULL;

theColorMap = GetColorMap(4);

colorpalette = (UWORD *)theColorMap->ColorTable;
for(iii=0; iii<4; iii++)
	*colorpalette++ = colortable[iii];
theViewPort.ColorMap = theColorMap;    /* link it with the viewport */

for(iii=0; iii<SCREEN_D; iii++)
	{
	if((theBitMap.Planes[iii] =
				(PLANEPTR)AllocRaster(SCREEN_W,SCREEN_H)) == NULL)
		clean_exit(RETURN_WARN);
	BltClear(theBitMap.Planes[iii], RASSIZE(SCREEN_W, SCREEN_H), 1);
	}

MakeVPort( &theView, &theViewPort ); /* construct copper (prelim) list */
MrgCop( &theView );       /* merge copper lists in the view structure. */
LoadView(&theView);

if ((msgLayer = CreateUpfrontLayer( theLayerInfo, &theBitMap,
                     M_L, M_T, M_R, M_B, LAYERSMART, NULL)) == NULL)
	clean_exit(RETURN_WARN);
pMessage("Setting up Layers");

/* Layers stuff starts here ********************************************/
InitBitMap(&theSuperBitMap,SCREEN_D,SUPER_W,SUPER_H);
for(iii=0; iii<SCREEN_D; iii++)
	{
	if((theSuperBitMap.Planes[iii] =
	                  (PLANEPTR)AllocRaster(SUPER_W,SUPER_H)) == NULL)
		clean_exit(RETURN_WARN);
	BltClear(theSuperBitMap.Planes[iii], RASSIZE(SUPER_W, SUPER_H), 1);
	}

for(iii=0; iii<3; iii++)
	{
	pMessage("Create BehindLayer");
	if (iii == 0)
		{
		if((theLayers[iii] = CreateBehindLayer( theLayerInfo, &theBitMap,
		            W_L+(iii*30), W_T+(iii*30), W_R+(iii*30), W_B+(iii*30),
				    theLayerFlags[iii], &theSuperBitMap)) == NULL)
			clean_exit(RETURN_WARN);
		}
	else
		{
		if((theLayers[iii] = CreateBehindLayer( theLayerInfo, &theBitMap,
		            W_L+(iii*30), W_T+(iii*30), W_R+(iii*30), W_B+(iii*30),
				    theLayerFlags[iii], NULL)) == NULL)
			clean_exit(RETURN_WARN);
		}

	pMessage("RectFill the RastPort");
	SetAPen(theLayers[iii]->rp,iii+1);
	SetDrMd(theLayers[iii]->rp,JAM1);
	if (iii == 0) RectFill(theLayers[iii]->rp,0,0,SUPER_W-1,SUPER_H-1);
	if (iii == 1) RectFill(theLayers[iii]->rp,0,0,W_W-1,W_H-1);
	if (iii == 2) RectFill(theLayers[iii]->rp,0,0,W_W-1,W_H-1);
	SetAPen(theLayers[iii]->rp,0);
	Move(theLayers[iii]->rp,5,7);
	}

pMessage("Label all Layers");
Text(theLayers[0]->rp,"Super",5);
Text(theLayers[1]->rp,"Smart",5);
Text(theLayers[2]->rp,"Simple",6);

pMessage("MoveLayer 1 InFrontOf 0");
if (!MoveLayerInFrontOf( theLayers[1], theLayers[0]))
	clean_exit(RETURN_WARN);

pMessage("MoveLayer 2 InFrontOf 1");
if (!MoveLayerInFrontOf( theLayers[2], theLayers[1]))
	clean_exit(RETURN_WARN);
myLabelLayer(theLayers[2], CLR_BLU, "Simple");

pMessage("Incrementally MoveLayers...");
for(iii=0; iii<30; iii++)
	{
	if (!MoveLayer(DUMMY, theLayers[1], -1, 0))
		clean_exit(RETURN_WARN);
	if (!MoveLayer(DUMMY, theLayers[2], -2, 0))
		clean_exit(RETURN_WARN);
	myLabelLayer(theLayers[2], CLR_BLU, "Simple");
	}

pMessage("make Layer 0 the UpfrontLayer");
if (!UpfrontLayer(DUMMY, theLayers[0]))
	clean_exit(RETURN_WARN);

pMessage("make Layer 2 the BehindLayer");
if (!BehindLayer(DUMMY, theLayers[2]))
	clean_exit(RETURN_WARN);

pMessage("Incrementally MoveLayers again...");
for(iii=0; iii<30; iii++)
	{
	if (!MoveLayer(DUMMY, theLayers[1], 0, 1))
		clean_exit(RETURN_WARN);
	if (!MoveLayer(DUMMY, theLayers[2], 0, 2))
		clean_exit(RETURN_WARN);
	myLabelLayer(theLayers[2], CLR_BLU, "Simple");
	}

pMessage("Big MoveLayer");
for(iii=0; iii<3; iii++)
	{
	if (!MoveLayer(DUMMY, theLayers[iii], -theLayers[iii]->bounds.MinX, 0))
		clean_exit(RETURN_WARN);
	}

pMessage("Incrementally increase size");
for(iii=0; iii<5; iii++)
	{
	for(jjj=0; jjj<3; jjj++)
		{
		if (!SizeLayer(DUMMY, theLayers[jjj], 1, 1))
			clean_exit(RETURN_WARN);
		}
	myLabelLayer(theLayers[1], CLR_GRN, "Smart");
	myLabelLayer(theLayers[2], CLR_BLU, "Simple");
	}

pMessage("Big SizeLayer");
for(iii=0; iii<3; iii++)
	{
	if (!SizeLayer(DUMMY,theLayers[iii],SCREEN_W-(theLayers[iii]->bounds.MaxX)-1,0))
		clean_exit(RETURN_WARN);
	}
myLabelLayer(theLayers[1], CLR_GRN, "Smart");
myLabelLayer(theLayers[2], CLR_BLU, "Simple");

pMessage("ScrollLayer down");
for(iii=0; iii<30; iii++)
	{
	for(jjj=0; jjj<3; jjj++)
		{
		ScrollLayer(DUMMY, theLayers[jjj], 0, -1);
		}
	myLabelLayer(theLayers[1], CLR_GRN, "Smart");
	myLabelLayer(theLayers[2], CLR_BLU, "Simple");
	}
pMessage("ScrollLayer up");
for(iii=0; iii<30; iii++)
	{
	for(jjj=0; jjj<3; jjj++)
		{
		ScrollLayer(DUMMY, theLayers[jjj], 0, 1);
		}
	myLabelLayer(theLayers[1], CLR_GRN, "Smart");
	myLabelLayer(theLayers[2], CLR_BLU, "Simple");
	}

/* Regions stuff starts here *******************************************/
pMessage("Create Regions");
if ((RowRegion = NewRegion()) == NULL)
	clean_exit(RETURN_WARN);
if ((ColRegion = NewRegion()) == NULL)
	clean_exit(RETURN_WARN);
for(iii=0; iii<3; iii++)
	if ((theRegions[iii] = NewRegion()) == NULL) /* for each layer */
		clean_exit(RETURN_WARN);

pMessage("Build two tmp regions");
myOrCols(ColRegion);	/* made into subroutine, used often */
for (iii=1; iii<6; iii++)
	{
	rect.MinX = 50;
	rect.MaxX = 315;
	rect.MinY = (iii*10)-5;
	rect.MaxY = (iii*10);
	if (!OrRectRegion(RowRegion, &rect))
		clean_exit(RETURN_WARN);
	}

rect.MinX = 5;
rect.MaxX = 315;
rect.MinY = 25;
rect.MaxY = 30;

myResetRegions();
pMessage("OrRectRegion one row...");
for (iii=0; iii<3; iii++)
	if (!OrRectRegion(theRegions[iii], &rect))
		clean_exit(RETURN_WARN);

pMessage("OrRectRegion result (blue)");
myLabelAllRegions(CLR_BLU);
Delay(L_DELAY);

myResetRegions();
pMessage("XorRectRegion one row...");
for (iii=0; iii<3; iii++)
	if (!XorRectRegion(theRegions[iii], &rect))
		clean_exit(RETURN_WARN);

pMessage("XorRectRegion result (blue)");
myLabelAllRegions(CLR_BLU);
Delay(L_DELAY);

myResetRegions();
pMessage("AndRectRegion one row...");
for (iii=0; iii<3; iii++)
	AndRectRegion(theRegions[iii], &rect);

pMessage("AndRectRegion result (blue)");
myLabelAllRegions(CLR_BLU);
Delay(L_DELAY);

myResetRegions();
pMessage("ClearRectRegion one row...");
for (iii=0; iii<3; iii++)
	if (!ClearRectRegion(theRegions[iii], &rect))
		clean_exit(RETURN_WARN);

pMessage("ClearRectRegion result (blue)");
myLabelAllRegions(CLR_BLU);
Delay(L_DELAY);

myResetRegions();
pMessage("OrRegionRegion Rows...");
for (iii=0; iii<3; iii++)
	if (!OrRegionRegion(RowRegion, theRegions[iii]))
		clean_exit(RETURN_WARN);

pMessage("OrRegionRegion result (blue)");
myLabelAllRegions(CLR_BLU);
Delay(L_DELAY);

myResetRegions();
pMessage("XorRegionRegion Rows...");
for (iii=0; iii<3; iii++)
	if (!XorRegionRegion(RowRegion, theRegions[iii]))
		clean_exit(RETURN_WARN);

pMessage("XorRegionRegion result (blue)");
myLabelAllRegions(CLR_BLU);
Delay(L_DELAY);

myResetRegions();
pMessage("AndRegionRegion Rows...");
for (iii=0; iii<3; iii++)
	if (!AndRegionRegion(RowRegion, theRegions[iii]))
		clean_exit(RETURN_WARN);

pMessage("AndRegionRegion result (blue)");
myLabelAllRegions(CLR_BLU);
Delay(L_DELAY);

cleanUp();
}    /* end of main() */

VOID clean_exit(LONG retc)
{
cleanUp();
exit(retc);
}

VOID cleanUp(VOID)
{
short iii;

if (oldview)
	LoadView(oldview);              /* put back the old view  */

if (msgLayer != NULL)
	if (!DeleteLayer(DUMMY, msgLayer))
		exit(RETURN_FAIL);

if (ColRegion != NULL)
	DisposeRegion(ColRegion);
if (RowRegion != NULL)
	DisposeRegion(RowRegion);
for(iii=0; iii<3; iii++)
	{
	if (theRegions[iii] != NULL)
		DisposeRegion(theRegions[iii]);
	if (theLayers[iii] != NULL)
		if (!DeleteLayer(DUMMY,theLayers[iii]))
			exit(RETURN_FAIL);
	}

/* !!! free superbitmap */
for (iii=0; iii<SCREEN_D; iii++)
	{    /* free the drawing area */
	if (theSuperBitMap.Planes[iii] != NULL)
		FreeRaster(theSuperBitMap.Planes[iii], SUPER_W, SUPER_H);
	}

if (theLayerInfo != NULL)
	DisposeLayerInfo(theLayerInfo);
if (theColorMap != NULL)
	FreeColorMap(theColorMap);       /* free the color map */
for (iii=0; iii<SCREEN_D; iii++)
	{    /* free the drawing area */
	if (theBitMap.Planes[iii] != NULL)
		FreeRaster(theBitMap.Planes[iii], SCREEN_W, SCREEN_H);
	}

/* free dynamically created structures */
FreeVPortCopLists(&theViewPort);
FreeCprList(theView.LOFCprList);

if (LayersBase != NULL)
	CloseLibrary(LayersBase);
if (GfxBase != NULL)
	CloseLibrary((struct Library *)GfxBase);
}

VOID myOrCols(struct Region *region)
{
short iii;
struct Rectangle rect;
for (iii=5; iii<10; iii++)
	{
	rect.MinX = (iii*10);
	rect.MaxX = (iii*10)+5;
	rect.MinY = 5;
	rect.MaxY = 50;
	if (!OrRectRegion(region, &rect))
		clean_exit(RETURN_WARN);
	}
}

VOID pMessage(UBYTE *string)
{
Delay(S_DELAY);
myLabelLayer(msgLayer, CLR_GRN, string);
}

VOID myLabelRegion( struct Region *region, struct Layer *layer,
					LONG color, UBYTE *string)
{
struct Region *old_region;

/* blow away the damage list. */
if (BeginUpdate(layer))
	EndUpdate(layer, TRUE);

/* install a user clip region.
** draw into the layer
** then put back the old clip region
*/
old_region = InstallClipRegion(layer,region);
myLabelLayer(layer, color, string);
region = InstallClipRegion(layer,old_region);
}

VOID myLabelAllRegions(LONG color)
{
myLabelRegion(theRegions[0], theLayers[0], color, "Super");
myLabelRegion(theRegions[1], theLayers[1], color, "Smart");
myLabelRegion(theRegions[2], theLayers[2], color, "Simple");
}

VOID myLabelLayer( struct Layer *layer, LONG color, UBYTE *string)
{
SetAPen(layer->rp, color);
SetDrMd(layer->rp,JAM1);
RectFill(layer->rp, 0, 0, layer->bounds.MaxX - layer->bounds.MinX,
		 layer->bounds.MaxY - layer->bounds.MinY);
SetAPen(layer->rp,0);
Move(layer->rp,5,7);
Text(layer->rp, string, strlen(string));
}

VOID myResetRegions(VOID)
{
short iii;

pMessage("Clear all Regions");
myLabelLayer(theLayers[0], CLR_RED, "Super");
myLabelLayer(theLayers[1], CLR_RED, "Smart");
myLabelLayer(theLayers[2], CLR_RED, "Simple");
for (iii=0; iii<3; iii++)
	ClearRegion(theRegions[iii]);

/* put the col region into each layer */
pMessage("OrRegionRect Columns...");
for (iii=0; iii<3; iii++)
	myOrCols(theRegions[iii]);

pMessage("ORed in Column Rects - in green");
myLabelAllRegions(CLR_GRN);
}
