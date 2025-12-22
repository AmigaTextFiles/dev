/* Demo for joystick library (link version) */
/* for Lettuce C */
/* written by Olli */

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <joystick.h>

struct NewWindow nw={
    20,20,240,45,
    3,2,
    CLOSEWINDOW,
    RMBTRAP|WINDOWDRAG|WINDOWDEPTH|WINDOWCLOSE,
    0,0,"JoyLib DEMO",0,0,
    0,0,0,0,
    WBENCHSCREEN};

struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct RastPort *rp;

#define print(x,y,s) Move(rp,x,y);Text(rp,s,4)

void printjoy(int num)
{
    int v=(num)?joy1():joy0();
    int x=(num)?125:5;

    print(x,30,(v&JOY_LEFT)?"LEFT":"    ");
    print(x+70,30,(v&JOY_RIGHT)?"RIGT":"    ");
    print(x+35,20,(v&JOY_UP)?" UP ":"    ");
    print(x+35,40,(v&JOY_DOWN)?"DOWN":"    ");
    print(x+35,30,(v&JOY_FIRE)?"FIRE":"    ");
}

int _main(void)
{
    struct Window *w;

    IntuitionBase=OldOpenLibrary("intuition.library");
    GfxBase=OldOpenLibrary("graphics.library");
    if(!(w=OpenWindow(&nw))) goto xit;
    rp=w->RPort;
    SetAPen(rp,3);
    SetBPen(rp,0);
    SetDrMd(rp,JAM2);
    while(!GetMsg(w->UserPort)) {
	printjoy(0);
	printjoy(1);
	WaitTOF();
    }
    CloseWindow(w);
xit:
    return(0);
}

