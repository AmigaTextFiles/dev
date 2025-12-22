/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as5.c - Version 1.31 - 09/03/2004
 */

#include        "as.h"

extern optab    *rfind();

int expr()
        {
        register int    s;
        register int    i, j;
        register int    op;
        register int    type;
        char            *inv = "Invalid expression";

        if ((s = symbol()) == NAME)
                i = getvalue(symname);
        else if (s == NUM)
                i = cval;
        else if (s == '-' || s == '+')  {
                if (symbol() != NUM)
                        error(inv);

                if (s == '-')
                        i = (-cval);
                else
                        i = cval;
        }
        else
                error(inv);

        type = vtype;

        for (;;)        {
                if (!(op = getop()))
                        break;

                if (type == GUNDEF)
                        error("Global in expression");

                if ((s = symbol()) == NAME)
                        j = getvalue(symname);
                else if (s == NUM)
                        j = cval;
                else
                        error(inv);

                if (vtype == GUNDEF)
                        error("Global in expression");

                if (ltype(type) && ltype(vtype))
                        error(inv);

                if (ltype(type) || ltype(vtype))
                        type = LLABEL;
                else
                        type = EXPR;

                switch (op)     {

                case '+':
                        i += j;
                        break;

                case '-':
                        i -= j;
                        break;

                default:
                        error("Unimplemented operator");
                }
        }

        vtype = type;
        return (i);
}

int getop()
        {
        register int    s;

        if ((s = symbol()) == '+' || s == '-')
                return (s);

        peeksym = s;
        return (0);
}

int ltype(register int type)
        {

        return (type == LLABEL || type == GLABEL);
}

void comma()
        {

        if (symbol() != ',')
                error("Comma expected");
}

int getsreg()
        {
        register optab  *r;
        register int    s;
        char            *offerr;

        offerr = "Illegal offset";

        if ((s = symbol()) != NAME && s != NUM && s != '-' && s != '+')
                goto err;

        if (s == NAME)  {
                if ((r = rfind(symname)) == NULL)
                        goto err;

                if (r -> o_value < 0)
                        goto err;

                return (r -> o_value);
        }

        peeksym = s;
        offset = expr();

        if (vtype != EXPR)
                error(offerr);

        if (symbol() != '(')
                error(offerr);

        if (symbol() != NAME)
                goto err;

        if ((r = rfind(symname)) == NULL)
                goto err;

        if (r -> o_value != 0xdd && r -> o_value != 0xfd)
                goto err;

        if (symbol() != ')')
                error(offerr);

        indxflg = r -> o_value;
        return (6);     /* hl pair */

err:
        error("Register expected");
        return (0);
}

int getdreg()
        {
        register optab  *r;

        if (symbol() != NAME)
                goto err;

        if ((r = rfind(symname)) == NULL)
                goto err;

        if (r -> o_type < 0)
                goto err;

        if (r -> o_type == 0xdd || r -> o_type == 0xfd) {
                indxflg = r -> o_type;
                return (4);     /* hl pair */
        }

        return (r -> o_type);

err:
        error("Register expected");
        return (0);
}

optab   *
rfind(register char *s)
        {
        register optab  *p;

        for (p = regist; p -> o_name; p++)
                if (lowcmp(p -> o_name, s) == 0)
                        break;

        if (!p -> o_name)
                return (NULL);

        return (p);
}


lowcmp(register char   *s1, register char *s2)
        {
        register int    c1, c2;

        for (;;)        {
                c1 = *s1++;
                c2 = *s2++;

                if (!c1 || !c2)
                        break;

                if (c1 >= 'A' && c1 <= 'Z')
                        c1 += 'a' - 'A';

                if (c2 >= 'A' && c2 <= 'Z')
                        c2 += 'a' - 'A';

                if (c1 != c2)
                        break;
        }

        return (c1 - c2);
}
