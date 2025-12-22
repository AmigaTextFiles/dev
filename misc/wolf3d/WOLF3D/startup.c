#include "startup.h"
#include <exec/memory.h>

extern byte walls[8][65][2];

void main() /* MAIN - handles initialization, starting the game, and cleaning up. */
{
    word result;
    
    result = StartUp();
    
    if(result == SUCCESS)
    	WOLF3D();
    else
    	ERROR_ALERT(result);
    
    CleanUp();
}

word StartUp( void )
{
    register word index, x, y, count;
    long result;
    FILE *fp, *fopen();
    
    IntuitionBase = OpenLibrary("intuition.library",37L);
    if(IntuitionBase == NULL) return(1);
    
    GfxBase = OpenLibrary("graphics.library",37L);
    if(GfxBase == NULL) return(2);

    MyBMP = (struct BitMap *) AllocMem((long)sizeof(struct BitMap), MEMF_CLEAR);
    if(! MyBMP) return(10);
    
    InitBitMap(MyBMP, ViewDepth, 320L, 200L);
    
    MyBMP->Planes[0] = (PLANEPTR)AllocRaster(320, (200*4));
    if(! MyBMP->Planes[0]) return(11);

    for(index = 1; index < ViewDepth; index++)
        MyBMP->Planes[index] = MyBMP->Planes[index-1] + 8000L; // 8000 bytes per plane

    MySCR = OpenScreenTags(	NULL,
    				SA_Depth, ViewDepth,
				SA_Width, 320L,
				SA_Height, 200L,
				SA_ShowTitle, FALSE,
				SA_Title, (char *) "WOLF 3D",
				SA_SysFont, NULL,
				SA_Type, CUSTOMSCREEN,
				SA_BitMap, MyBMP,
				SA_Quiet, TRUE,
				SA_DClip, &MyRect,
				TAG_DONE);
    if(MySCR == NULL) return(3);
    
    
	
    MyWIN = OpenWindowTags(	NULL,
    				WA_IDCMP, IDCMP_RAWKEY|IDCMP_VANILLAKEY,
    				WA_CustomScreen, MySCR,
				WA_NoCareRefresh, TRUE,
				WA_Activate, TRUE,
				WA_Borderless, TRUE,
				WA_Backdrop, TRUE,
				WA_RMBTrap, TRUE,
				WA_SimpleRefresh, TRUE,
				TAG_DONE);
    if(MyWIN == NULL) return(4);


    RASTPORT = MyWIN->RPort;
    
    JoyStick1 = AllocateJoystick();
    if(JoyStick1 == NULL) return(5);

   
    /* CHANGE SCREEN COLOURS */
    for(index = 0; index < 8; index++)
	SetRGB4(&MyWIN->WScreen->ViewPort, index, (index<<1),index<<1,index<<1);


/* allocate sound channels, load samples */

    /* ALLOCATE MEMORY BUFFERS */
    /* FETCH BITMAP IMAGES */
    /* 1. WALLS */

/* ---------------------------------------- */
/* Fetch Bitmap images. (walls)             */
/* ---------------------------------------- */
    for(index = 0; index < NbrWallBMPs; index++)
    {
	Wall[index] = (unsigned char *)malloc(64*64);
	if(! Wall[index]) return(9);
    };

    fp = fopen("walls.bmp","r");
    
    if(fp)
    {
	for(index = 0; index < NbrWallBMPs; index++)
	{
	    for(y = 0; y < 64; y++)
	    	for(x = 0; x < 64; x++)
		{
		    result = fgetc(fp);
		    *(Wall[index]+x*64+y) = (byte) result;
		    if(result == -1)
		    {
			fclose(fp);
			return(7);
		    };
		};
	};
	
	fclose(fp);
    }
    else
	return(6);


    fBUFFER = (unsigned char *)malloc(fBUFFER_SIZE);
    if(! fBUFFER) return (8);

    /* ---------------------------------------------
       Initialize the wall array to contain
       coordinates for all the columns of the walls.
       --------------------------------------------- */

    /* north/west wall/door */

    count = 0;
    for(index = 32; index >= -32; index--)
    {
	walls[W][count][0] = -32;
	walls[W][count][1] = index;
	walls[DRW][count][0] = 0;
	walls[DRW][count][1] = index;

	walls[N][count][0] = index;
	walls[N][count][1] = 32;
	walls[DRN][count][0] = index;
	walls[DRN][count][1] = 0;
	count++;
    };
    
    /* east/south wall/door */

    count = 0;
    for(index = -32; index <= 32; index++)
    {
	walls[E][count][0] = 32;
	walls[E][count][1] = index;
	walls[DRE][count][0] = 0;
	walls[DRE][count][1] = index;

	walls[S][count][0] = index;
	walls[S][count][1] = -32;
	walls[DRS][count][0] = index;
	walls[DRS][count][1] = 0;

	count++;
    };


    return(SUCCESS);    
}


void CleanUp( void )
{
    register long index;

    for(index = 0; index < NbrWallBMPs; index++)
	if(Wall[index]) free(Wall[index]);
	
    if(fBUFFER) free(fBUFFER);
    if(JoyStick1) DeallocateJoystick();
    if(MyWIN) CloseWindow( MyWIN );
    if(MySCR) CloseScreen( MySCR );
    if(MyBMP->Planes[0]) FreeRaster(MyBMP->Planes[0], 320L, 200L*4);
    if(MyBMP) FreeMem(MyBMP, (long)sizeof(struct BitMap));
    if(GfxBase) CloseLibrary( GfxBase );
    if(IntuitionBase) CloseLibrary( IntuitionBase );

}


void ERROR_ALERT( word result )
{
    fprintf(stderr,"WOLF3D ERROR: %s\n",ErrorMesg[ result ]);
}



