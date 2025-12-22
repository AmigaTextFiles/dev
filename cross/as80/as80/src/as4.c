/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as4.c - Version 1.31 - 10/03/2004
 */

#include        "as.h"

sym     symtab[MAXLAB];         /* symbol table */
temp    tmptab[MAXTEMP];        /* temporaries */
temp    *tp;                    /* pointer to temporaries */

char    symstr[8*MAXLAB];       /* label storage */

char    *symp = symstr;         /* pointer to label storage */

int     globno = 0;             /* global label number */

sym     *
hash(register char   *s)
        {
        register unsigned       h;

        for (h = 0; *s; h = (h << 1) + *s++)
                ;

        h %= MAXLAB;

        return (&symtab[h]);
}

void deflabel(register char *s, register int type)
        {
        register sym    *p;
        extern sym      *hash();

        if (strcmp(s, ".") == 0)        {
                error("Illegal label");
                return;
        }

        if (pass != 1)
                return;

        p = hash(s);

        while (p -> s_name)     {
                if (strcmp(s, p ->s_name) == 0)
                        if (type == GUNDEF && p -> s_flag == LLABEL)    {
                  /* p -> s_flag == GLABEL;*/ p -> s_flag = GLABEL;
                                p -> s_glob = globno++;
                                return;
                        }
                        else if (p -> s_flag != UNDEF && p -> s_flag != GUNDEF)
                                error("Label already defined");
                        else
                                break;

                if (++p >= symtab + MAXLAB)
                        p = symtab;
        }

        if (!p -> s_name)       {
                p -> s_name = symp;
                while (*symp++ = *s++)
                        ;
        }

        if (p -> s_flag == UNDEF)       {
                p -> s_flag = type;

                if (type == GUNDEF)     {
                        p -> s_value = 0;
                        p -> s_glob = globno++;
                        return;
                }
        }
        else if (p -> s_flag == GUNDEF)
                p -> s_flag = GLABEL;
        else
                error("Illegal label definition - cannot happen");

        p -> s_seg = seg;
        p -> s_value = loc;
        p -> s_temp = tp;
        p -> s_ntmp = 0;

        tmpsym = p;
}

void defexpr(register char   *s)
        {
        register sym    *p;
        extern sym      *hash();

        if (strcmp(s, ".") == 0)        {
                loc = expr();
                outorg(loc);
                return;
        }

        p = hash(s);

        while (p -> s_name)     {
                if (strcmp(s, p -> s_name) == 0)
                        if (p -> s_flag == UNDEF || p -> s_flag == EXPR)
                                break;
                        else
                                error("Expression already defined");

                if (++p >= symtab + MAXLAB)
                        p = symtab;
        }

        if (!p -> s_name)       {
                p -> s_name = symp;
                while (*symp++ = *s++)
                        ;
        }

        p -> s_flag = EXPR;
        p -> s_value = expr();
        p -> s_temp = 0;
        p -> s_ntmp = 0;
}

int getvalue(register char   *s)
        {
        register sym    *p;
        extern sym      *hash();

        if (strcmp(s, ".") == 0)
                return (loc);

        p = hash(s);

        while (p -> s_name)     {
                if (strcmp(s, p -> s_name) == 0)
                        if (p -> s_flag != UNDEF)       {
                                vtype = p -> s_flag;
                                vseg = p -> s_seg;

                                if (vtype == GUNDEF)    {
                                        if (pass == 1)
                                                vtype = EXPR;

                                        return (p -> s_glob);
                                }
                                else
                                        return (p -> s_value);
                        }
                        else
                                break;

                if (++p >= symtab + MAXLAB)
                        p = symtab;
        }

        if (!p -> s_name)       {
                p -> s_name = symp;
                while (*symp++ = *s++)
                        ;
        }

        vtype = p -> s_flag = UNDEF;
        vseg = TEXT;

        if (pass == 1)
                vtype = EXPR;

        return (0);
}

void header()
        {
        register sym    *p;

        for (p = symtab; p - symtab < MAXLAB; p++)
                if (p -> s_name)        {
                        if (p -> s_flag == UNDEF)       {
                                p -> s_flag = GUNDEF;
                                p -> s_value = 0;
                                p -> s_glob = globno++;
                        }

                        if (p -> s_flag == GLABEL || p -> s_flag == GUNDEF)
                                printf(":S%-8.8s%02x%02x%04x%04x\n", p ->
s_name, p -> s_flag, p -> s_seg, p -> s_value, p -> s_glob);
                }
}

void tmplabel()
        {
}

void tmpexpr()
        {
}
