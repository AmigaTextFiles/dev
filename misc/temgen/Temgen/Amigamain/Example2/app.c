/*
   shows the use of the tooltype/readarg feature
   call this from Workbench and Shell to see the difference
   Example Shell call: app pubscreen=test jingle nr 3
*/

#include "app.h"
#include "amigamain.h"

#include <stdio.h>

void APP_run(void)
{
    config.message_output = TRUE;
    config.message_request = FALSE;
    messagef("Pubscreen %s\n", config.pubscreen);
    messagef("Jingle %ld\n", config.jingle);
    messagef("Number %ld\n", config.nr);

    messagef("\nSee what happens if you use %%d instead of %%ld\n");
    messagef("Jingle %d\n", config.jingle);
    messagef("Number %d\n", config.nr);
}

void APP_clean(void)
{
    messagef("\nAPP_clean\n");
}

