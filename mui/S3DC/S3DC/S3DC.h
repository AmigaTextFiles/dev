/* S3DC ( Simple 3D Cube )
   v1.0
*/


#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>

#include <libraries/mui.h>


/* Custom class constants */
#define DEFAULT_WIDTH 100
#define DEFAULT_HEIGHT 100

#define MAX_WIDTH 700
#define MAX_HEIGHT 700

#define MIN_WIDTH 75
#define MIN_HEIGHT 75

struct S3DC_Data
{
  float phi, theta;
  int BlackPen,WhitePen;
};


struct S3DC_COORD
{
  int x;
  int y;
};

typedef struct S3DC_COORD S3DC_Coord;


ULONG S3DC_AskMinMax(struct IClass *cl,Object *obj,struct MUIP_AskMinMax *msg);
ULONG S3DC_Draw(struct IClass *cl,Object *obj,struct MUIP_Draw *msg);
ULONG S3DC_Setup(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg);
ULONG S3DC_Cleanup(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg);
ULONG S3DC_HandleInput(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg);
ULONG S3DC_Dispatcher(struct IClass *cl __asm("a0"),Object *obj __asm("a2"),Msg msg __asm("a1"));
