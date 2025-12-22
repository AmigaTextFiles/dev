/***************************************/
/*  Block Routines for C Language V1.0 */
/*  Written by Kelly Samel             */
/*  Email- samel@telusplanet.net       */
/***************************************/
#include <stdio.h>
#include <stdlib.h>
#include <intuition/intuition.h>
#include <graphics/gfx.h>
#include <mapmaster/iff.h> /* Include file for iff.library */
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

/* must be defined in your source code */
extern mapdata[];

/******************************/
/*  ProtoTypes for Functions  */
/******************************/
void LoadMap(char filename[],int horizblocks,int vertblocks);
void GetBlocks(char blocksfile[],struct BitMap *tempbitmap,int depth,int bmwidth,int bmheight);
void GetBlocksPalette(char blocksfile[],struct Screen *screen);
void FreeBlocks(struct BitMap *tempbitmap,int depth);
void PasteBlocks(int horizblocks,int vertblocks,int blockwidth,int blockheight,int blockgap,int xoffset,int yoffset,struct BitMap *source,struct BitMap *dest);

/************************************************/
/* Loads the map data into your mapdata[] Array */
/************************************************/
void LoadMap(char filename[],int horizblocks,int vertblocks)
{
/* Setup required variables */
FILE *mapfile;
char tempstring[11];
int n=1;

/* Open the mapfile for reading */
mapfile=fopen(filename,"r");

/* Loop to read the mapdata */
while (n<horizblocks*vertblocks+1)
{
fgets(tempstring,10,mapfile);
mapdata[n]=atoi(tempstring);
n++;}

/* Close the mapfile */
fclose(mapfile);
}

/***********************************************************************/
/* GetBlocks loads IFF picture data into a bitmap to be used as blocks */
/***********************************************************************/
void GetBlocks(char blocksfile[],struct BitMap *tempbitmap,int depth,int bmwidth,int bmheight)
{
/* Setup and initialize required variables */
struct Library *IFFBase;
IFFL_HANDLE iff; BOOL success;
int DEPTH;
DEPTH=depth; depth=0;

/* Initialize and allocate memory for the BitMap */
/* that will hold your blocks */
InitBitMap(tempbitmap,DEPTH,bmwidth,bmheight);
for(depth=0; depth<DEPTH; depth++)
    {tempbitmap->Planes[depth] = AllocRaster(bmwidth,bmheight);}

/* Open iff.library v23 */
IFFBase=OpenLibrary("iff.library",23);

/* Load the Picture into memory using iff.library V23 */
iff=IFFL_OpenIFF(blocksfile,IFFL_MODE_READ);
success=IFFL_DecodePic(iff,tempbitmap);

/* Close what we opened */
IFFL_CloseIFF(iff);
CloseLibrary(IFFBase);
}

/*************************************************************/
/*   Gets color Palette from blocks and loads it into screen */
/*************************************************************/
void GetBlocksPalette(char blocksfile[],struct Screen *screen)
{
/* Setup and initialize required variables */
struct Library *IFFBase;
IFFL_HANDLE iff; 
UWORD colors[256]; int numcol;

IFFBase=OpenLibrary("iff.library",23);

/* Load the Picture and get colors from it */
iff=IFFL_OpenIFF(blocksfile,IFFL_MODE_READ);
numcol=IFFL_GetColorTab(iff,colors);

/* Load the colors into screen */
LoadRGB4(&screen->ViewPort,colors,numcol);

/* Close what we opened */
IFFL_CloseIFF(iff);
CloseLibrary(IFFBase);
}

/****************************************/
/* Frees memory allocated by GetBlocks  */
/****************************************/
void FreeBlocks(struct BitMap *tempbitmap,int depth)
{
int DEPTH;
DEPTH=depth; depth=0;
/* Free memory allocated for BitMap that holds your blocks */
for(depth=0; depth<DEPTH; depth++)
    {FreeRaster(tempbitmap->Planes[depth],tempbitmap->BytesPerRow*8,tempbitmap->Rows);}
}

/********************************************************************************/
/* Pastes the blocks from source BitMap to a Destination BitMap using mapdata[] */
/********************************************************************************/
void PasteBlocks(int horizblocks,int vertblocks,int blockwidth,int blockheight,int blockgap,int xoffset,int yoffset,struct BitMap *source,struct BitMap *dest)
{
/* Setup and initialize Required Variables */
int x; int y; int x2; int y2;
int n; int n2; int counter; int done;
int totalwidth; int totalheight;
x=0; y=0; counter=1; done=0;
x2=0; y2=0;
n=1; n2=2;
totalwidth=(source->BytesPerRow*8)/(blockwidth+blockgap)-1;
totalheight=source->Rows/(blockheight+blockgap);

/* Loop to paste blocks to screen */
while(n<horizblocks*vertblocks+1)
{
/* loop to decide the coordinates to get the pasting block from */
while(counter<mapdata[n])
{
if(x==totalwidth){x=0; y++; counter++;}
if(counter==mapdata[n]){done=1;}
if(x<totalwidth && done==0){x++; counter++;}
}
/* Paste the current block using supplied parameters */
BltBitMap(source,x*(blockwidth+blockgap)+blockgap,y*(blockheight+blockgap)+blockgap,dest,x2+xoffset,y2+yoffset,blockwidth,blockheight,0xC0,0xff,NULL);

/* Reset the variables */
counter=1; x=0; y=0; done=0;

/* Keep it pasting in the right place */
x2=x2+blockwidth;
if (n==horizblocks){y2=y2+blockheight; x2=0;}
if (n==horizblocks*n2){y2=y2+blockheight; x2=0; n2++;}

n++;}

}
