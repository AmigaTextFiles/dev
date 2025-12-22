
#include <graphics.h>
#include <stdio.h>
#include <stdlib.h>

main()
{
struct window mine;     /* Window structure */
struct pixels pix;      /* Pixel plotting structure */
struct draw dia;        /* Relative drawing structure */
        int     i;

        mine->graph=1;
        mine->width=255;
        mine->number='4';

/* Open map with width 256 on window #4 */
        window(mine);

/* Clear the graphics window */
        clg();

/* Draw a series of concentric circles in the centre of the screen 
 * these go off the screen but don't generate an error - very cool!
 */
        pix->x0=128;
        pix->y0=32;
        pix->y1=1;      /* skip factor */
        for (i=50 ; i!=0; i--)
        {
                pix->x1=i;      /* radius */
                circle(pix);
                if (i < 25 ) i--;
        }

	pix->x0=0;
	pix->y0=0;
	pix->x1=255;
	pix->y1=63;
	draw(pix);

/* Draw a diamond - weak, but it demonstrates relative drawing! */
        pix->x0=200;
        pix->y0=32;
        plot(pix);

        dia->x=10;
        dia->y=10;
        drawr(dia);
        dia->x=10;
        dia->y=-10;
        drawr(dia);
        dia->x=-10;
        dia->y=-10;
        drawr(dia);
        dia->x=-10;
        dia->y=10;
        drawr(dia);

/* Draw boxes inside one another */

        pix->x0=1;     /* X */
        pix->y0=1;     /* Y */

        for (i=64 ; i != 0 ; i--)
        {
                pix->x1=i;      /* Width */
                pix->y1=i;      /* Depth */
                drawb(pix);     /* Draw box */
                i--;
        }

/* Close the graphics window */
        closegfx(mine);
}

