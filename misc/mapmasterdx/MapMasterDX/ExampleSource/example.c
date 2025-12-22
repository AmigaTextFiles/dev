// MapMasterDX map example v0.1 - January 13 2007
// This is a simple demonstration of how to load a mapfile
// and some blocks and paste the results into a window's rastport

/// Includes
/* ANSI C */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* System */
#include <dos/dos.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>

/* Prototypes */
#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/icon.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/utility.h>
#include <proto/asl.h>
#include <proto/muimaster.h>

// Cybergraphx includes
#include <cybergraphx/cybergraphics.h>  /* v41 uses cybergraphx/ dir */
#include <clib/cybergraphics_protos.h>

///

// First setup a structure to hold all data related to the map
struct MapInfo
{
	int *mapdata;
	int mapwidth;
	int mapheight;
	int blockwidth;
	int blockheight;
	int blockgap;
};

struct MapInfo mapinfo; // Holds info about our mapdata
struct Window *window;  // window to display output
struct BitMap *blocks_bm;      // Points to Datatype loaded bitmap
Object *dtobject;  // Used when loading via Picture Datatype

// Prototypes

// Map handling functions
int *LoadMap(char *filename, struct MapInfo *mapinfo);
int SaveMap(int *mapdata,char *path, struct MapInfo *mapinfo);
void FreeMap(int *mapdata);

void PasteBlocksRP(struct MapInfo *project,
				   int xoffset,int yoffset,   // offset into mapdata in blocks
				   int xdoffset,int ydoffset, // offset into rastport in pixels
				   struct BitMap *source,
				   struct RastPort *dest,
                   int *mapdata);

// Datatype picture loading
struct BitMap *LoadDTPicture(char *filename,Object **dtobject);
void FreeDTPicture(Object *dtobject);

// Window handling
int WindowOpen(struct Window **window,int width, int height,
			   int xpos,int ypos);


// Main
int main(void)
{
	// Some variables for the IDCMP input loop
    int done;
	struct IntuiMessage *msg;
	ULONG iclass;
	int code;

	// offsets for moving through the mapdata
	int xoffset=1;
	int yoffset=1;

	// First load in some map data
	mapinfo.mapdata = LoadMap("test.map",&mapinfo);

	// Open a window
	WindowOpen(&window,320, 240, 100,100);

	// Load in the block image via datatypes
	blocks_bm = LoadDTPicture("testblocks.iff24",&dtobject);

	// Draw the map into the window
	PasteBlocksRP(&mapinfo,
				  1,1,
				  window->BorderLeft,window->BorderTop,
				  blocks_bm,window->RPort,
				  &mapinfo.mapdata[0]);

	// Take keyboard input to allow arrow keys to move around the map
	done = FALSE;

	while(done == FALSE)
	{
		Wait (1 << window->UserPort->mp_SigBit);
		while((!done) && (msg = (struct IntuiMessage *) GetMsg(window->UserPort)))
		{
			iclass = msg->Class; // Get the Class
			code  = msg->Code; // Get the Code

			ReplyMsg((struct Message *) msg); // reply to message

			// Check what type of message we received
			switch (iclass)
  			{
				case IDCMP_RAWKEY:
					if(code == 204) // up
					{
						if (yoffset-1 > 0)
						{
							yoffset--;
						}
					}
					if(code == 205) // down
					{
						if (yoffset+1 < mapinfo.mapheight)
						{
							yoffset++;
						}
					}
					if(code == 207) // left
					{
						if (xoffset-1 > 0)
						{
							xoffset--;
						}
					}
					if(code == 206) // right
					{
						if (xoffset+1 < mapinfo.mapwidth)
						{
							xoffset++;
						}
					}

					if(code==69) // Esc key
					{
						done=TRUE;
					}

				  // Draw the map into the window since a key was pressed
				  // which may have changed the offsets
				  PasteBlocksRP(&mapinfo,
				  xoffset,yoffset,
				  window->BorderLeft,window->BorderTop,
				  blocks_bm,window->RPort,
				  &mapinfo.mapdata[0]);

				break;
			}
		}
	}


	// Close the window
	CloseWindow(window);

	// Free the blocks image
	// (this frees the dtobject and bitmap data)
	FreeDTPicture(dtobject);
  
	// Free the mapdata before exiting
	FreeMap(mapinfo.mapdata);

	return(NULL);
}

// Loads the map data into your mapdata Pointer and allocates memory
int *LoadMap(char *filename, struct MapInfo *mapinfo)
{
 // Setup required variables
 FILE *mapfile;
 char tempstring[11];
 int index=1; // start at index 1 instead of 0 for easier handling
 int horizblocks=0;
 int vertblocks=0;
 int *mapdata;

 // Open the mapfile for reading
 mapfile=fopen(filename,"r");

 // Get in the Width and Height of map
 fgets(tempstring,10,mapfile);
 horizblocks = atoi(tempstring);
 mapinfo->mapwidth = atoi(tempstring);

 fgets(tempstring,10,mapfile);
 vertblocks = atoi(tempstring);
 mapinfo->mapheight = atoi(tempstring);

 // Allocate exact amount of Memory needed
 mapdata = (int *) malloc (((horizblocks*vertblocks)+1) * sizeof(int));

 // skip to the part of the map file we need to access
 fgets(tempstring,10,mapfile); // skip blockwidth
 mapinfo->blockwidth = atoi(tempstring);

 fgets(tempstring,10,mapfile); // skip blockheight
 mapinfo->blockheight = atoi(tempstring);

 fgets(tempstring,10,mapfile); // skip blockgap
 mapinfo->blockgap = atoi(tempstring);


 // Loop to read the mapdata
 while (index<(horizblocks*vertblocks)+1)
 {
	fgets(tempstring,10,mapfile);
	mapdata[index] = atoi(tempstring);
    index++;
 }

 // Close the mapfile
 fclose(mapfile);

 // return the new mapdata
 return(mapdata);
}

// Frees the memory and data allocated by LoadMap
void FreeMap(int *mapdata)
{
 // free the memory so that you can load a new map into mapdata
 free((int *) mapdata);
}

//   Saves out the Map to disk
int SaveMap(int *mapdata,char *path, struct MapInfo *mapinfo)
{
 FILE *mapfile;
 char string[7];
 int linefeed=10;
 int index=1; // start at index 1 instead of 0 for easier handling

 // If file is writable save it out
 if((mapfile=fopen(path,"w")) != NULL)
 {

	// save the information
	stci_d(string,mapinfo->mapwidth);
	fputs(string,mapfile);
	fputc(linefeed,mapfile);

	stci_d(string,mapinfo->mapheight);
	fputs(string,mapfile);
	fputc(linefeed,mapfile);

	stci_d(string,mapinfo->blockwidth);
	fputs(string,mapfile);
	fputc(linefeed,mapfile);

	stci_d(string,mapinfo->blockheight);
	fputs(string,mapfile);
	fputc(linefeed,mapfile);

	stci_d(string,mapinfo->blockgap);
	fputs(string,mapfile);
	fputc(linefeed,mapfile);

	// Loop to save the map to disk
	while (index<(mapinfo->mapwidth*mapinfo->mapheight)+1)
	{
		stci_d(string,mapdata[index]);
		fputs(string,mapfile);
		fputc(linefeed,mapfile);
		index++;
	}


	fclose(mapfile); // close the file
	return(1);
 }

 return(0);
}


// Paste blocks from source bitmap into a destination rastport
// Take into account clipping and offsets etc.
void PasteBlocksRP(struct MapInfo *project,
                   int xoffset,int yoffset,
                   int xdoffset,int ydoffset,
                   struct BitMap *source,struct RastPort *dest,int *mapdata)
{
	// Setup and initialize Required Variables

	// Variables related to pasting routine
    int x; int y; int x2; int y2;
    int n; int n2; int counter; int done;

	// Variables related to the Map and Blocks
    int horizblocks; int vertblocks;
    int blockwidth; int blockheight; int blockgap;
    int totalwidth; int totalheight;
	int blocksize;

    // amount to add to xoffset each time through
    // the loop
    int xadd=0;

    // Retrieve the variables used for pasting
    horizblocks = project->mapwidth;
    vertblocks  = project->mapheight;
    blockwidth  = project->blockwidth;
    blockheight = project->blockheight;
    blockgap = project->blockgap;


	// Initialize to suitable starting values
	x=0; y=0; counter=1; done=0;
    x2=0; y2=0;
	n=1; n2=2;

    // Total width and height in blocks of the block bitmap
	totalwidth  = (GetBitMapAttr(source,BMA_WIDTH))/(blockwidth+blockgap)-1;
    totalheight = (GetBitMapAttr(source,BMA_HEIGHT))/(blockheight+blockgap);

	// Calculate total number of available blocks before pasting
	blocksize = totalwidth * totalheight;

    // Number of blocks to actually paste
	horizblocks = (window->Width - window->BorderRight-1) - window->BorderLeft;
    horizblocks = (horizblocks / blockwidth);

    // Ensure we don't go beyond the map size
    if ((horizblocks + xoffset) > project->mapwidth)
    {
		horizblocks = project->mapwidth - xoffset;
        xadd = xoffset;
    }
    else if ((horizblocks+xoffset) <= project->mapwidth)
    {
	xadd = (project->mapwidth - horizblocks);
        // xadd = horizblocks + xoffset;
    }

    // Y direction
	vertblocks = (window->Height - window->BorderBottom-1) - window->BorderTop;
    vertblocks = (vertblocks / blockheight);

    // Ensure we don't go beyond the map size
    if ((vertblocks + yoffset) > project->mapheight)
    {
		vertblocks = project->mapheight - yoffset;
    }
    else if ((vertblocks+yoffset) <= project->mapheight)
    {

    }

    // move the xoffset far enough to account for
    // the vertical offset
    xoffset = xoffset + (yoffset*project->mapwidth);

	//printf("mw:%d mh:%d bw:%d bh:%d bg:%d\n",
	//		 horizblocks,vertblocks,blockwidth,blockheight,blockgap);

	// Loop to paste blocks to screen
    while(n < horizblocks * vertblocks + 1)
    {
	// loop to decide the coordinates to get the pasting block from
	while(counter < mapdata[n+xoffset])
	{
	    if(x==totalwidth)
            {
            	x=0;
                y++;
                counter++;
            }

            if(counter == mapdata[n+xoffset])
            {
            	done=1;
            }

            if(x<totalwidth && done==0)
            {
            	x++;
            	counter++;
            }
	}

	// Paste the current block using supplied parameters
	if(mapdata[n+xoffset] <=  blocksize)
	{
		BltBitMapRastPort(source,x*(blockwidth+blockgap)+blockgap,y*(blockheight+blockgap)+blockgap,dest,x2+xdoffset,y2+ydoffset,blockwidth,blockheight,0xC0);
	}
	else
	{
		// Just fill block with solid color since it's out of range
		RectFill(dest,
				 x2+xdoffset, y2+ydoffset,
				 x2+xdoffset+blockwidth,
				 y2+ydoffset+blockheight);
	}

	// Reset the variables
	counter=1; x=0; y=0; done=0;

	// Keep it pasting in the right place
	x2 = x2 + blockwidth;

        if (n==horizblocks)
        {
			// Handle clearing the Border of window if it's larger than our blocks
			if ((x2+xdoffset) < (window->Width - window->BorderRight-1) )
			{
				RectFill( dest, x2+xdoffset, y2+ydoffset, (window->Width - window->BorderRight-1) ,
						  								  y2+ydoffset+blockheight);
			}


            y2=y2+blockheight;
            x2=0;

            xoffset = xoffset + xadd; // increase offset by width of entire mapdata
        }

        if (n==horizblocks * n2)
        {
			// Handle clearing the Border of window if it's larger than our blocks
			if ((x2+xdoffset) < (window->Width - window->BorderRight-1) )
			{
				RectFill( dest, x2+xdoffset, y2+ydoffset, (window->Width - window->BorderRight-1) ,
						  y2+ydoffset+blockheight);
			}

            y2=y2+blockheight;
            x2=0;
            n2++;

            xoffset = xoffset + xadd; // increase offset by width of entire mapdata
        }

	n++;
   }

	// Handle clearing the bottom Border of window if it's larger than our blocks
	if ((y2+ydoffset) < (window->Height-window->BorderBottom))
	{
		RectFill( dest, window->BorderLeft, y2+ydoffset,
				  (window->Width - window->BorderRight-1),
				  (window->Height - window->BorderBottom-1));

	}
}

// Datatypes picture loading function
struct BitMap *LoadDTPicture(char *filename,Object **dtobject)
{
	struct BitMap *bitmap;
    struct dtTrigger dtt;

	*dtobject = (Object *) NewDTObject(filename,
		DTA_SourceType, DTST_FILE,
		DTA_GroupID, GID_PICTURE,
		PDTA_FreeSourceBitMap,TRUE,
		PDTA_Remap,TRUE,
		PDTA_DestMode,PMODE_V43,
		TAG_DONE);

       // Check to see if the pictue load was succesful
	   if (*dtobject == NULL)
       {
            return(NULL);
       }


	DoMethod(*dtobject, DTM_PROCLAYOUT, NULL, 1 );
	GetDTAttrs(*dtobject, PDTA_DestBitMap, &bitmap, TAG_DONE );

	// return the allocated data
	return(bitmap);
}

void FreeDTPicture(Object *dtobject)
{
    // Only free the bitmap if it is allocated
	if (dtobject != NULL)
    {
        // Free the Picture and set pointer to NULL
		DisposeDTObject(dtobject);
		dtobject = NULL;
    }
}

// Open a basic window
int WindowOpen(struct Window **window,int width, int height,
			   int xpos,int ypos)
{
	struct Screen *pubscreen; // For opening on ambient

	// Get a lock on the default public screen (generally ambient)
	pubscreen = LockPubScreen(NULL);

	if((*window=OpenWindowTags(NULL,WA_Left,xpos,WA_Top,ypos,
								WA_Width,width,    WA_Height,height,
								WA_Title, "MapTest",
								WA_DetailPen,1,  WA_BlockPen,2,
								WA_MinWidth,width, WA_MinHeight,height,
								WA_MaxWidth,width, WA_MaxHeight,height,
								WA_SizeGadget,FALSE, WA_DragBar,TRUE,
								WA_Borderless,FALSE, WA_RMBTrap,FALSE,
								WA_DepthGadget,TRUE, WA_CloseGadget,TRUE,
								WA_Backdrop,FALSE,
								WA_Activate,TRUE,
								WA_PubScreen, pubscreen,
								WA_IDCMP,IDCMP_MOUSEBUTTONS
								| IDCMP_RAWKEY | IDCMP_CLOSEWINDOW,
								TAG_END)) == NULL)
	{
		// unlock the pubscreen again
		UnlockPubScreen(NULL, pubscreen);

		return(FALSE);
	}
	else
	{
		// unlock the pubscreen again
		UnlockPubScreen(NULL, pubscreen);

		return(TRUE);
	}

	return(FALSE);
}
