#ifndef AMIGAMAIN_H
#define AMIGAMAIN_H

#include <exec/types.h>
#include <intuition/intuition.h>

#include <stdarg.h>

struct Config
{
    /* true if libraries have successful been opened */
    BOOL all_libraries_open;

    /* true if application was started from Workbench */
    BOOL start_from_wb;

    /* reference window for EasyRequest */
    struct Window *reqwin;

    BOOL message_request;
    BOOL message_output;
};

extern struct Config config;

LONG show_request( char *title, char *text, char *button, ... );
LONG show_request_args( char *title, char *text, char *button, va_list ap );
void vmessagef(char *format, va_list ap);
void messagef(char *format, ... );
char *strcpy_malloc(const char *s );

#endif
