/*
   shows the use of locale feature
   the german catalog has reversed order of arguments
*/

#define CATCOMP_NUMBERS

#include "app_strings.h"

#include "app.h"
#include "amigamain.h"

#include <stdio.h>

extern STRPTR GetString(struct LocaleInfo *li, LONG stringNum);

void APP_run(void)
{
    messagef_loc(MSG_SWAP_DEMO, "'STRING'", 77777);

    show_request( "Title",
        GetString(&li, MSG_SWAP_DEMO),
        GetString(&li, MSG_OK),
        "'STRING'", 42);
}

void APP_clean(void)
{
    messagef("\nAPP_clean\n");
}

