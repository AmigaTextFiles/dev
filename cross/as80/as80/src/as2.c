/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as2.c - Version 1.3 - 85/10/03 18:19:04
 */

#include        "as.h"

void parse()
        {
        register int    s;
        register optab  *p;
        char            save[40];

loop:
        indxflg = offset = 0;

        if ((s = symbol()) == '\n')
                return;

        if (s == EOF)
                return;

        if (s == ';')   {
                skipln(0);
                return;
        }

        if (s != NAME && s != NUM && s != TEMP)
                error("Invalid line");

        if (s == NUM)   {
                peeksym = s;
                word();
                return;
        }

        if (s == TEMP)  {
                if ((s = symbol()) == '=')      {
                        tmpexpr();
                        return;
                }
                else if (s == ':')      {
                        tmplabel();
                        goto loop;
                }

                peeksym = s;
                word();
                return;
        }

        strcpy(save, symname);

        if ((s = symbol()) == '=')      {
                defexpr(save);
                return;
        }
        else if (s == ':')      {
                deflabel(save, LLABEL);
                goto loop;
        }

        for (p = opcode; p -> o_name; p++)
                if (lowcmp(p -> o_name, save) == 0)
                        break;

        if (!p -> o_name && !macro(save))
                error("Illegal opcode");

        if (!p -> o_name)       {
                domacro(save);
                return;
        }

        if (p -> o_type == SINGLE)      {
                outabs(p -> o_value);
                eoln(s);
                return;
        }

        peeksym = s;

        switch (p -> o_type)    {

        case LOCAL:
                local(p -> o_value);
                break;

        case ACCUM:
                accum(p -> o_value);
                break;

        case DOUBLE:
                wordop(p -> o_value);
                break;

        case BYTE:
                bytop(p -> o_value);
                break;

        case RELOC:
                reloc(p -> o_value);
                break;

        case SPECIAL:
                special(p -> o_value);
                break;

        case RELAT:
                relat(p -> o_value);
                break;

        case BIT:
                bitop(p -> o_value);
                break;

        default:
                error("No match in optab - can't happen");
        }

        eoln(0);
}

void accum(register int n)
        {
        register int    r;

        r = getsreg();

        if (indxflg)
                outabs(indxflg);

        outabs(n + r);

        if (indxflg)
                outabs(offset);
}

void wordop(register int n)
        {
        register int    r;

        r = getdreg();

        if (indxflg)
                outabs(indxflg);

        outabs(n + (r << 3));
}

void bytop(register int n)
        {

        outabs(n);
        n = expr();

        if (vtype != EXPR)
                error("Illegal operand");

        outabs(n);
}

void reloc(register int n)
        {

        outabs(n);
        n = expr();
        outword(n, vtype);
}

void bitop(register int n)
        {
        register int    v;
        register int    r;

        v = expr();

        if (vtype != EXPR)
                error("Illegal bit expression");

        if (v < 0 || v > 7)
                error("Illegal bit number");

        comma();

        r = getsreg();

        if (indxflg)
                outabs(indxflg);

        outabs(n + (v << 3) + r);

        if (indxflg)
                outabs(offset);
}

void relat(register int n)
        {
        register int    v;

        v = expr();

        if (vtype == GUNDEF)
                error("Illegal relative branch");

        outabs(n);
        v = v - loc;

        if (pass != 1 && (v < -127 || v > 127))
                error("Relative branch overflow");

        outabs(v & 0377);
}

void special(register int n)
        {
        register int    v;

        switch (n)      {

        default:
                error("Special op not found - can't happen");
                return;

        case 0x01:      /* lxi */
                v = getdreg();
                comma();
                outabs(n + (v << 3));
                v = expr();
                outword(v, vtype);
                return;

        case 0x04:      /* inr */
        case 0x05:      /* dcr */
                v = getsreg();
                outabs(n + (v << 3));
                return;

        case 0x06:      /* mvi */
                v = getsreg();
                comma();
                outabs(n + (v << 3));
                v = expr();

                if (vtype != EXPR)
                        error("Illegal operand");

                outabs(v);
                return;

        case 0x40:      /* mov */
                v = getsreg();
                n += (v << 3);
                comma();
                v = getsreg();

                outabs(n + v);
                return;

        case 0xc7:      /* rst */
                v = expr();

                if (v == GUNDEF)
                        error("Illegal operand");

                if (v >= 0 && v <= 7)
                        outabs(n + (v << 3));
                else if (v >= 0 && v <= 0x38 && v % 8 == 0)
                        outabs(n + v);
                else
                        error("Illegal address");

                return;

        case 0xed40:    /* inp */
        case 0xed41:    /* outp */
                v = getsreg();

                if (v == 6)     /* memory reference */
                        error("Illegal register");

                outabs(n + (v << 3));
                return;
        }
}
