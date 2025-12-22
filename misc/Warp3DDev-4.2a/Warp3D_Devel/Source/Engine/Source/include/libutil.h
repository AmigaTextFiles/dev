#ifndef __LIBUTIL_H
#define __LIBUTIL_H

#include "lex.h"
#include "queue.h"

void    TIMER_init          (void);
float   TIMER_GetSeconds    (void);
void    TIMER_StartInterval (void);
float   TIMER_StopInterval  (void);
void    TIMER_StartElapsed  (void);
float   TIMER_GetElapsed    (void);

#endif
