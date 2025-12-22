/* Header for millibar.library */
/* Stefan Popp 06/2001         */
/* Version 0.10                */

#ifndef MILLIBAR_H
#define MILLIBAR_H

#include <clib/graphics_protos.h>
#include <stdlib.h>


typedef struct mbcpar {

    RastPort *rp;
    char     *code;
    int      codetype;
    int      xpos;
    int      ypos;
    int      xscale;
    int      yscale;
    int      drawmode;
    

} MBC_PAR;

#define CODABAR 1

#endif