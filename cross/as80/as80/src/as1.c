/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as1.c - Version 1.31 - 09/03/2004
 */

#include        "as.h"

static char     alpha[] =
"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.$";
static char     digit[] = "0123456789";
static char     hex[] = "abcdefABCDEF";
static int      lflag = 0;

int symbol()
        {
        register int    c;
        register char   *p;

        if (peeksym >= 0)       {
                c = peeksym;
                peeksym = -1;
                return (c);
        }

        if (eof)
                return (EOF);

        if (peekc)
                c = peekc, peekc = 0;
        else
                c = getchar();

        if (lflag)      {
                lno++;
                lflag = 0;
        }

        if (c == EOF)   {
                eof++;
                return (EOF);
        }

        while (c == ' ' || c == '\t')
                c = getchar();

        if (c == '\n')  {
                lflag++;
                return (c);
        }

        if (c == '$')   {
                c = getchar();
                if (index(c, alpha))    {
                        p = symname;
                        *p++ = '$';
                        while (index(c, alpha) || index(c, digit))      {
                                *p++ = c;
                                c = getchar();
                        }

                        *p = 0;
                        peekc = c;
                        return (NAME);
                }

                if (index(c, digit))    {
                        peekc = c;
                        c = dbase;
                        dbase = 10;
                        getnum();
                        dbase = c;
                        return (TEMP);
                }

                error("Illegal symbol");
        }

        if (index(c, alpha))    {
                p = symname;
                while (index(c, alpha) || index(c, digit))      {
                        *p++ = c;
                        c = getchar();
                }

                *p = 0;
                peekc = c;
                return (NAME);
        }

        if (index(c, digit))    {
                peekc = c;
                return (getnum());
        }

        /*
        if (c == '\'')
                return (getcc());
        */

        return (c);
}

int getnum()
        {
        register int    v;
        register int    base;
        register int    c;

        base = dbase;
        v = 0;
        c = peekc;

        if (c == '0')   {
                base = 8;

                if ((c = getchar()) == 'x' || c == 'X') {
                        base = 16;
                        c = getchar();
                }
        }

loop:
        while (index(c, digit)) {
                if (base == 8)
                        v = (v << 3) + c - '0';
                else if (base == 10)
                        v = (((v << 2) + v) << 1) + c - '0';
                else if (base == 16)
                        v = (v << 4) + c - '0';

                c = getchar();
        }

        if (base == 16 && index(c, hex))        {
                v <<= 4;
                v += 10 + ((c >= 'a' && c <= 'f') ? c - 'a' : c - 'A');
                c = getchar();
                goto loop;
        }

        cval = v;
        vtype = EXPR;
        peekc = c;
        return (NUM);
}

int getcc()
        {
        error("Getcc called - not implemented");
        cval = 0;
        vtype = EXPR;
        return (NUM);
}

int index(register char   c, register char *s)
        {
        register int    i;

        for (i = 0; *s; i++)
                if (*s++ == c)
                        return (i + 1);

        return (0);
}
