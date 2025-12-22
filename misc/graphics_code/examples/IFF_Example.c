// A Little example program to load in and display an iff file.
// this requires the iff.library supplied to be installed in
// your libs: drawer.
// Don't know what happens if it isn't.

    #include <proto/graphics.h>     // Need this for the graphics_base.h file

// My include files
// Change according to their location

    #include <custom/graphics_base.h>
    #include <custom/graphics.h>

    #include <hardware/cia.h>       // Don't really need this

// The C Palette data

    #include "palette.c"

__far extern struct CIA ciaa, ciab;

VOID main()
{

// A Screen store structure

    struct Screen_Store *screen = NULL;

// init the graphics functions

    Graphics_Init();

// Open the screen

    screen=Open_Screen(320,256,8,NULL,&myData);

// Load the IFF

    Load_IFF(screen,"levellingthelaw");

// Wait for a mouse press

    while ((ciaa.ciapra & (1 << CIAB_GAMEPORT0))!=0)
        ;

// fade out

    Fade_To_Black(screen,&myData);

// Close the screen

    Close_Screen(screen);

// Close the graphics

    Graphics_Close();

}
