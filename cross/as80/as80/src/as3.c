/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as3.c - Version 1.31 - 09/03/2004
 */

#include        "as.h"

void local(register int    n)

        {

        switch (n)      {

        case 0:         /* .ascii */
                asciz(0);
                return;

        case 1:         /* .asciz */
                asciz(1);
                return;

        case 2:         /* .blkb */
                n = expr();

                if (vtype != EXPR)
                        error("Illegal .blkb");

                outzero(n);
                return;

        case 3:         /* .blkw */
                n = expr();
                if (vtype != EXPR)
                        error("Illegal .blkw");

                outzero(n << 1);
                return;

        case 4:         /* .byte */
                byte();
                return;

        case 5:         /* .data */
                outseg(DATA);
                return;

        case 7:         /* .end */
                eof++;
                return;

        case 9:         /* .even */
                if (loc & 01)
                        outabs(0);

                return;

        case 11:        /* .globl */
                global();
                return;

        case 13:        /* .macro */
                defmacro();
                return;

        case 14:        /* .text */
                outseg(TEXT);
                return;

        case 15:        /* .word */
                word();
                return;

        default:
                error("Illegal local action");
                return;
        }
}

void asciz(int z)
        {
        register int    c;
        register int    fin;

        fin = symbol();

        if (fin == '\n' || fin == ';' || fin == NAME || fin == NUM)
                error("Illegal string");

        while ((c = getchar()) != fin)
                outabs(c);

        if (z)
                outabs(0);
}

void byte()
        {
        register int    s;

        for (;;)        {
                s = expr();

                if (vtype != EXPR)
                        error("Illegal .byte");

                outabs(s);

                if ((s = symbol()) == '\n' || s == ';') {
                        peeksym = s;
                        return;
                }

                if (s != ',')
                        perror("Comma expected");
        }
}

void word()
        {
        register int    s;

        for (;;)        {
                s = expr();
                outword(s, vtype);

                if ((s = symbol()) == '\n' || s == ';') {
                        peeksym = s;
                        return;
                }

                if (s != ',')
                        error("Comma expected");
        }
}

void global()
        {
        register int    s;

        for (;;)        {
                if ((s = symbol()) != NAME)
                        error("Label expected");

                deflabel(symname, GUNDEF);

                if ((s = symbol()) == '\n' || s == ';') {
                        peeksym = s;
                        return;
                }

                if (s != ',')
                        error("Comma expected");
        }
}
