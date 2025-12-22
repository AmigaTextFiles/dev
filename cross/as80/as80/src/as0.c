/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as0.c - Version 1.31 - 09/03/2004
 */

#include        "as.h"

static char version[]="$VER: as80 v1.31";

main(register int argc, register char **argv)
        {

        pass1(argc, argv);

        if (errcnt)     {
                fprintf(stderr, "\nErrors in pass 1\n");
                exit(1);
        }

        pass2(argc, argv);
}

void pass1(register int argc, register char **argv)
        {

        pass++;
        tloc = dloc = loc = 0;
        outseg(TEXT);

        while (++argv, --argc > 0)      {
                if (argv[0][0] == '-')
                        switch (argv[0][1])     {

                        case 'o':
                                ++argv;
                                --argc;
                                continue;

                        default:
                                fprintf(stderr, "Unknown option -%c\n",
argv[0][1]);
                                exit(1);
                        }

                file = argv[0];
                dofile();
        }
}

void pass2(register int argc, register char   **argv)
        {
        register int    i;

        file = NULL;

        for (i = 0; i < argc; i++)
                if (argv[i][0] == '-' && argv[i][1] == 'o')     {
                        file = argv[i + 1];
                        break;
                }

        if (!file)
                file = "z.out";

        if (freopen(file, "w", stdout) == NULL) {
                fprintf(stderr, "Cannot create %s\n", file);
                exit(1);
        }

        header();
        pass1(argc, argv);
        dumpabs();
        printf("\n");
}

void dofile()
        {

        if (freopen(file, "r", stdin) == NULL)  {
                fprintf(stderr, "Cannot open %s\n", file);
                exit(1);
        }

        lno = 1;
        eof = 0;

        setjmp(errstart);

        while (!eof)
                parse();
}

void error(char *s)
        {
void a,b,c,d,e,f;
        errcnt++;

        fprintf(stderr, "%s:%d:", file, lno);
        fprintf(stderr, s, a, b, c, d, e, f);
        fprintf(stderr, "\n");

        skipln(0);
        longjmp(errstart,0);
}

char    outtxt[256];
int     outind = 0;

void outabs(register int    v)
        {
        register int    n;

        loc++;

        if (n = (v >> 8) & 0377)
                loc++;

        if (pass == 1)
                return;

        if (outind == 256)
                dumpabs();

        if (n)
                outtxt[outind++] = n;

        if (outind == 256)
                dumpabs();

        outtxt[outind++] = v;
}

void dumpabs()
        {
        register int    i;

        if (pass == 1 || !outind)
                return;

        outn(ABSOLUTE);
        outn(outind & 0377);    /* count */

        for (i = 0; i < outind; i++)
                outn(outtxt[i]);

        outind = 0;
}

void outword(v, type)
        {

        loc += 2;

        if (pass == 1)
                return;

        if (type == EXPR)       {
                outabs(v & 0377);
                outabs((v >> 8) & 0377);
                return;
        }

        dumpabs();

        if (type == LLABEL || type == GLABEL)   {
                if (vseg == TEXT)
                        outn(RELTEXT);
                else
                        outn(RELDATA);
        }
        else
                outn(GLOBAL);

        outn(v & 0377);
        outn((v >> 8) & 0377);
}

void outzero(register int v)
        {

        loc += v;

        if (pass == 1)
                return;

        dumpabs();
        outn(ZERO);             /* zero data */
        outn(v & 0377);
        outn((v >> 8) & 0377);
}

int     ocount = 0;

void outn(register int v)
        {

        if (ocount == 36)
                segset();

        ocount++;
        printf("%02x", v);
}

void outseg(register int type)
        {

        if (type == seg)
                return;

        dumpabs();

        if (type == TEXT)       {
                dloc = loc;
                loc = tloc;
        }
        else    {
                tloc = loc;
                loc = dloc;
        }

        seg = type;
        segset();
}

void outorg(register int n)
        {

        if (pass == 1)
                return;

        dumpabs();
        outn(ORIGIN);
        outn(n & 0377);
        outn((n >> 8) & 0377);
}

void segset()
        {

        if (pass == 1)
                return;

        ocount = 0;
        printf("\n:%c", seg == TEXT ? 'T' : 'D');
}

void skipln(register int s)
        {

        while (!eof && s != '\n')
                s = symbol();
}

void eoln(register int sym)
        {

        if (!sym)
                sym = symbol();

        if (sym != '\n' && sym != ';')
                error("No operand expected");

        skipln(sym);
}
