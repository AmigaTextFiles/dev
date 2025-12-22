#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include "amigamain.h"
#include "app.h"

struct Config config;
char *vers="\0$VER: MyApp 0.1 (26.6.2004)";
static BPTR oldout, newout;

struct IntuitionBase *IntuitionBase = NULL;

#define MSG_OK            "OK"
#define MSG_REQTITLE      "Message"
#define MSG_ERR_LIB       "Couldn't open %s V%ld\n"
#define MSG_ERR_SHELL     "Application can't be started from Shell\n"
#define MSG_ERR_WB        "Application can't be started from Workbench\n"
#define MSG_ERR_RAM       "Couldn't allocate RAM in function %s\n"
#define MSG_ERR_TOOLTYPES "Couldn't read tooltypes\n"
#define MSG_ERR_READARGS  "Couldn't read command line arguments\n"
#define MSG_ERR_OPEN      "Couldn't open stream %s\n"

static void cleanexit( void );
static struct Library *save_open_library( UBYTE *libName, ULONG version);

int
main(int argc, char *argv[] )
{
    atexit( cleanexit );
    config.message_request = 1;
    config.message_output = 1;
    if ( argc == 0 )
    {
        /* started from Workbench */
        config.start_from_wb = TRUE;
        if ( ! freopen( "con:10/50/300/100/stdin/AUTO"  , "r", stdin  ))
        {
            messagef( MSG_ERR_OPEN, "'stdin'" );
            exit( EXIT_FAILURE );
        }
        if ( ! freopen( "con:10/150/300/100/stdout/AUTO", "w", stdout ))
        {
            messagef( MSG_ERR_OPEN, "'stdout'" );
            exit( EXIT_FAILURE );
        }

        newout = Open("con:10/250/300/100/AmigaDos/AUTO", MODE_OLDFILE);
        if ( ! newout )
        {
            messagef( MSG_ERR_OPEN, "'AmigaDos'" );
            exit( EXIT_FAILURE );
        }
        oldout = SelectOutput(newout );
    }
    IntuitionBase = (struct IntuitionBase *)
        save_open_library("intuition.library", 40);
    config.all_libraries_open = TRUE;
    if ( config.start_from_wb )
    {
    }
    else
    {
    }
    APP_run();
    return EXIT_SUCCESS;
}

/*
  open EasyRequest
*/
LONG
show_request( char *title, char *text, char *button, ... )
{
    va_list ap;
    va_start(ap, button );
    return show_request_args(title, text, button, ap);
    va_end(ap );
}

/*
  open EasyRequest (va_list)
*/
LONG
show_request_args( char *title, char *text, char *button, va_list ap )
{
    struct EasyStruct es = {sizeof (struct EasyStruct), 0, 0, 0, 0};
    es.es_Title = title;
    es.es_TextFormat = text;
    es.es_GadgetFormat = button;
    return EasyRequestArgs(config.reqwin, &es, 0, ap);
}

/*
  formated output to Output() and/or Workbench
  parameters like vprintf
*/
void
vmessagef( char *format, va_list ap )
{
    if ( ! format) return;
    if ( config.message_output )
    {
        VPrintf(format, ap);
        Flush( Output() );
    }
    if ( config.message_request && IntuitionBase )
    {
        show_request_args( MSG_REQTITLE, format, MSG_OK, ap);
    }
}

/*
  messagef (like printf)
*/
void
messagef( char *format, ... )
{
    va_list ap;
    va_start(ap, format);
    vmessagef(format, ap);
    va_end(ap);
}

/*
  copies string s to new allocated RAM
*/
char *
strcpy_malloc(const char *s )
{
    char *dest;
    if ( ! s)
        return NULL;
    dest = malloc( strlen( s ) + 1);
    if ( ! dest )
    {
        messagef( MSG_ERR_RAM , "strcpy_malloc");
        exit( EXIT_FAILURE );
    }
    strcpy(dest, s);
    return dest;
}

/*
  OpenLibrary with check of return value
*/
static struct Library *
save_open_library(UBYTE *libName, ULONG version)
{
    struct Library *lib;
    lib = OpenLibrary(libName, version);
    if ( ! lib )
    {
        messagef( MSG_ERR_LIB ,libName, version );
        exit( EXIT_FAILURE);
    }
    return lib;
}


/*
  cleanup function for atexit
*/
static void
cleanexit( void )
{
    APP_clean();
    if ( config.start_from_wb )
        Delay( 200 );
    if ( config.all_libraries_open )
    {
        if ( newout )
        {
            SelectOutput(oldout );
            Close(newout );
        }
    }
    CloseLibrary((struct Library *) IntuitionBase );
}
