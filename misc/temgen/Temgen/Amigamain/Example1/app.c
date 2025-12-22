/*
   shows the use of the message functions
   call this from Workbench and Shell to see the difference
*/

#include "app.h"
#include "amigamain.h"

#include <proto/dos.h>

#include <stdio.h>

void APP_run(void)
{
    messagef("Default output\n");

    config.message_output = FALSE;
    config.message_request = TRUE;
    messagef("Output only to EasyRequest\n");

    config.message_output = TRUE;
    config.message_request = FALSE;
    messagef("Output only to Output()\n");

    config.message_output = TRUE;
    config.message_request = TRUE;
    messagef("Output to EasyRequest and Output()\n");

    messagef("Output with parameters\n%s\n%ld\n", "a string", 42);

    printf("Output with printf\n");
    Printf("Output with Printf\n");

    show_request( "Title", "The answer is %ld\n", "OK|CANCEL", 42);
}

void APP_clean(void)
{
    puts("APP_clean");
}

