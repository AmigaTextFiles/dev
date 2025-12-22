/* global information and includes shared by all modules. */

/* ---------------------------  I N C L U D E S  -------------------------- */

#include <intuition/intuition.h>
#include <graphics/gfx.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
//#include <clib/dos_protos.h>

#include <time.h>

/* -----------------------------  G L O B A L  ---------------------------- */

extern struct Window *MyWIN;
extern struct RastPort *RASTPORT;
extern unsigned char *fBUFFER;


/* ----------------------------  D E F I N E S  --------------------------- */

#define word short
#define byte char

#define ScreenLeft 0
#define ScreenRight 319
#define ScreenTop 0
#define ScreenBottom 199

#define ViewLeft 0
#define ViewRight 255
#define ViewTop 0
#define ViewBottom 127

#define ViewCenterX ((ViewRight+ViewLeft)/2)
#define ViewCenterY ((ViewTop+ViewBottom)/2)

#define ViewDepth 4
#define NbrWallBMPs 2
#define fBUFFER_SIZE 32768

typedef struct PLAYER
{
    long X;	/* X and Z are used to maintain some fixed point precision */
    long Z;
    word Xcopy; /* Xcopy and Zcopy are used in normal calculations */
    word Zcopy;
    word speed;
    word attitude;
};
