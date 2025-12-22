/* Short C Example for the Z88 Dev Kit
 * Insultingly simple just takes first 5
 * lines of text file and displays them on
 * screen.
 *
 * Displays usage of:
 * fopen, fgets, putn, puts, putchar
 */


#include <stdio.h>
#include <stdlib.h>



main()
{
        FILE *fp;
        char line[160];
        int     i;

/* Do yourself a favour and change the filename to something else! */
        fp=fopen("transfer.tex","r");
        putn(fp);
        if ((fp == NULL))
        {
                puts("\l\nCan't open file, sorry\l\n");
                exit(0);
        }
        for (i=0; i!=5; i++)
        {
                fgets(line,80,fp);
                puts(line);
                putchar('\l');
                putchar('\n');
        }
        fclose(fp);
}
