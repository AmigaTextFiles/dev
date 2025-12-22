/***************************************/
/* Example of using MapFunctions  v1.0 */
/* Written by Kelly Samel              */
/* Email- samel@telusplanet.net        */    
/***************************************/
#include <stdio.h>
#include <stdlib.h>
#include <intuition/intuition.h>
#include <graphics/gfx.h>
#include <mapmaster/mapfunctions.h> /* Include file for MapFunctions */
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

int mapdata[241]; /* mapdata[] must be defined Global and must */
                  /* be large enough to hold your maps         */
                  /* horizblocks*vertblocks+1                  */

/***************************************************************************/
/*         ------------------ Start Of Main ---------------                */
/***************************************************************************/
main()
{
struct BitMap mybitmap; /* BitMap to hold your blocks */
char blocksfile[]="dungeonblocks.iff"; /* name of iff file containing
                                          your blocks */
char mapfile[]="dungeonblocks.map"; /* name of mapmaster map file */

/* Structure for the screen */
struct Screen *screen1;

/* Open the Screen */
screen1=OpenScreenTags (NULL,SA_DisplayID,LORES_KEY,
SA_Depth,4,SA_Title,(ULONG)"our screen",TAG_DONE);

/* -Instructions on using these functions- */
/* First load the map                      */
/* Then get the blocks                     */
/* Then get the color palette -Optional-   */
/* and finally paste the map to the screen */
/* Free the memory GetBlocks took          */

LoadMap(mapfile,20,12);
GetBlocks(blocksfile,&mybitmap,4,320,200);
GetBlocksPalette(blocksfile,screen1); 
PasteBlocks(20,12,16,16,1,0,0,&mybitmap,&screen1->BitMap);
FreeBlocks(&mybitmap,4);

Delay(5*60); /* wait for awhile */

/* Close everything we opened */
CloseScreen(screen1);
}
/***************************************************************************/
/*         ------------------ End Of Main ---------------                  */
/***************************************************************************/
