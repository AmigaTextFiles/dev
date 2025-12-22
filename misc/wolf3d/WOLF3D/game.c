#include "game.h"
#include "JoyStick.h"
#include "sort.h"
#include "sine.h"

/* -------------------------------------------------------------------- */
extern byte walls[8][65][2];

word INPUTMETHOD, FIN;

struct BLOCKTYPE Level_One[ NbrBlocks+1 ] =
{
	{ 1,1,2,1, NORTH,NULL},
	{ 0,0,3,1, NORTH,NULL},
	{ 0,0,4,1, NORTH,NULL},
	{ 1,1,5,2, WEST,NULL},
	{ 0,0,5,3, WEST,NULL},
	{ 0,0,4,4, WEST|SOUTH|NORTH,NULL},
	{ 1,1,5,5, WEST,NULL},
	{ 0,0,5,6, WEST,NULL},
	{ 0,0,5,7, WEST,NULL},
	{ 1,1,4,8, SOUTH,NULL},
	{ 0,0,3,7, WEST|EAST|SOUTH,NULL},
	{ 0,0,2,8, SOUTH,NULL},
	{ 1,1,1,7, EAST,NULL},
	{ 0,0,1,6, EAST,NULL},
	{ 0,0,1,5, EAST,NULL},
	{ 0,1,2,4, EAST|SOUTH|NORTH,NULL},
	{ 0,0,1,3, EAST,NULL},
	{ 0,0,1,2, EAST,NULL},
	{ 1,1,3,4, DOOR|NORTH|SOUTH,NULL},
};

struct DOORTYPE myDoor;
struct PLAYER player1 = { 0,0,0,0,0,0 };
struct xBUFFTYPE xBUFFER[ViewRight+1];
word zBUFFER[NbrBlocks + NbrObjects][2];



/* ------------------  I N T E R N A L   R O U T I N E S  ----------------- */

void WOLF3D( void );

/* ------------------------------------------------------------------------ */

void WOLF3D(void)
{
    register word index;
    
    word count;    
    unsigned long frame = 0,start,seconds;
    unsigned int clock[2];
  
    
    /* ------------------------------------------------------------------ */
    /* PRE-GAME INITIALIZATION                                            */
    /* ------------------------------------------------------------------ */

    COSINE = &SINE[90*2];

    INPUTMETHOD = JOYSTICK;
    FIN = 0;
        
    timer(clock);
    start = clock[0];

    /* Initialize level one's blocks to the proper coordinates (i*64) */
        
    for(index = 0; index < NbrBlocks; index++)
    {
	Level_One[index].x *= 64;
	Level_One[index].z *= 64;
    };

/* ---------------------------------------- */
    
    /* Setup the playing display. Ie: its initial graphics */
    
    SetAPen(RASTPORT,13);
    RectFill(RASTPORT,0,0,ScreenRight,ScreenBottom);


    player1.X = (long)(128) << FFPBitSize; /* Set the player start coords at 2,2 */
    player1.Z = (long)(128) << FFPBitSize;
    player1.Xcopy = (word)(player1.X >> FFPBitSize);
    player1.Zcopy = (word)(player1.Z >> FFPBitSize);
    
//  CreateDoorList();
//  CreateNpcList();

    /*-------------------------
    Object[0].ShipDefn = &Cube;
    Object[0].center[0] = 192;
    Object[0].center[1] = 0;
    Object[0].center[2] = 64;
    Object[0].attitude = 0;
    -------------------------*/
    
    
    /* ---------------------------------------------------------------- */
    /* MAIN GAME LOOP							*/
    /* ---------------------------------------------------------------- */

    while(! FIN  )
    {
	/* ------------------------------------------------------------ */
	/* TRANSFORM WORLD BLOCKS AND OBJECTS				*/
	/* ------------------------------------------------------------ */
	
	TransformBlocks( &player1 );
// 	TransformObjects( &player1 );

	
	/* ------------------------------------------------------------ */
	/* CREATE AND SORT THE ZDEPTHBUFFER				*/
	/* ------------------------------------------------------------ */

	count = CreateZbuffer();
	SORTWORLD(zBUFFER, count);


	/* ------------------------------------------------------------ */
	/* CREATE THE XIMAGEBUFFER					*/
	/* ------------------------------------------------------------ */

	CreateXbuffer(count);


	/* ------------------------------------------------------------ */
	/* RENDER THE WORLD AND OBJECTS INTO THE FRAMEBUFFER		*/
	/* ------------------------------------------------------------ */

	AsmClearFrame((long *)fBUFFER,151587081L,134744072L);
	AsmRenderWorld((long)xBUFFER,(long)fBUFFER);
//	AsmRenderObjects();


	/* ------------------------------------------------------------ */
	/* COPY THE FRAMEBUFFER TO VIDEO MEMORY				*/
	/* ------------------------------------------------------------ */

	AsmChunky2Planar((long)fBUFFER,(long)RASTPORT->BitMap->Planes[0]);


        /* ------------------------------------------------------------ */
        /* FETCH AND EVALUATE PLAYER INPUT				*/
        /* ------------------------------------------------------------ */

	FetchEvaluateInput( &player1 );
	UpdatePlayerPosition( &player1 );
	// in updateposition also handle collision events
	// collision with: blocks & objects

//	UpdateDoorList();
//	UpdateNpcList();	/* NonPlayerCharacters - bad guys */

	if(frame++ == 1000) FIN = 27;
    };

    timer(clock);
    seconds = clock[0] - start;
    if(! seconds) seconds = 1;

//  DestroyDoorList();
//  DestroyNpcList();
    
    printf("Frames: %d & Seconds: %d\n",frame,seconds);
    printf("Est Frames per second:  %d\n",frame/seconds);
}

/* -------------------------------------------------------------------------- 
	if(code == ' ')
	{
	    myDoor.status = 1;
	};

	myDoor.length = myDoor.length + myDoor.XDIR * myDoor.status;
	if( (myDoor.length == 64) && (myDoor.status != 0))
	{
	    myDoor.status = 0;
	    myDoor.XDIR *= -1;
	}
	else
	if( (myDoor.length == 0) && (myDoor.status != 0))
	{
	    myDoor.status = 0;
	    myDoor.XDIR *= -1;
	};
	
	Level_One[18].x = myDoor.oldX + myDoor.length;

*/