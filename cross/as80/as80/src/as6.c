/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as6.c - Version 1.31 - 09/03/2004
 */

#include        "as.h"

int macro(char *s)
        {

        return (0);
}

void domacro(char *s)
{char *buf="Domacro called : %s-------------------------------------";
sprintf(buf,"Domacro called : %s", s);
        error(buf);
}

void defmacro()
        {

        skipln(0);
}
