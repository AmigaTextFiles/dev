#ifndef GFX_H
#define GFX_H


/* Define some basic structures needed by the routines */

/* Structure to use when opening a window - as per usual, if graph <> 0
 * then open graphics window number with width (pixels) width 
 */

struct window {
        char    number;
        char    x;
        char    y;
        char    width;
        char    depth;
        char    type;
        char    graph;
} ;

/* Structure for most of the graphics routines usually x0 and y0 are
 * the main coordinates and x1,y1 are width/depth, spare is used for
 * number of pixels scrolled in l(r)scroll
 *
 * For circles centred at (x0,y0) with radius x1, y1 gives a skip factor -
 * 1 gives a solid perimeter circle, and 2 spaces them a little more etc
 * NEVER SET TO ZERO!!!
 */


struct pixels {
        char    x0;
        char    y0;
        char    x1;
        char    y1;
        char    spare;
};

/* Structure for relative drawing */

struct draw {
        signed int     x;
        signed int     y;
};





/* Our kludgy prototypes */

/* HDRPRTYPE is a rather kludgey way to indicate to the compiler that these
 * functions are to be found in the library and not in other modules
 */

#pragma proto HDRPRTYPE

extern window(struct window *);
extern plot(struct pixels *);
extern unplot(struct pixels *);
extern draw(struct pixels *);
extern undraw(struct pixels *);
extern drawr(struct draw *);
extern undrawr(struct draw *);
extern drawb(struct pixels *);
extern undrawb(struct pixels *);
extern circle(struct pixels *);
extern uncircle(struct pixels *);
extern lscroll(struct pixels *);
extern rscroll(struct pixels *);        /* no scroll_right yet */
extern clg(void);
extern clga(struct pixels *);
extern closegfx(struct window *);

#pragma unproto HDRPRTYPE 






#endif

