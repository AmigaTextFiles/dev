/*****************************************************************************
* 6502D Version 0.1                                                          *
* Bart Trzynadlowski, 1999                                                   *
*                                                                            *
* Feel free to do whatever you wish with this source code provided that you  *
* understand it is provided "as is" and that the author will not be held     *
* responsible for anything that happens because of this software.            *
*                                                                            *
* 6502d.c: Main code for the 6502 disassembler.                              *
*****************************************************************************/

/* the source code is hideous, live with it =) */

#include <stdio.h>
#include <stdlib.h>
#include "6502d.h"

#define USAGE_TEXT "Usage: 6502d -f infile [-s start] [-h] [-v]\nTry \"6502d -h\" for help\n"
#define VERSION_TEXT "6502d version 0.1\n"
#define HELP_TEXT "6502d -- Free 6502 Disassembler by Bart Trzynadlowski\n" \
                  "\n" \
                  "Usage: 6502d -f infile [-s start] [-h] [-v]\n" \
                  "All arguments in brackets, [], are optional. Case sensitivity applies.\n" \
                  "\n" \
                  "Argument Descriptions:\n" \
                  "\t-f infile:\tSpecifies the input binary file.\n" \
                  "\t-s start:\tStarting point of disassembly (in base 16).\n" \
                  "\t-h:\tPrints this help text. All other arguments ignored, except -v.\n" \
                  "\t-v:\tPrints version. All other arguments ignored.\n" \
                  "\n" \
                  "Feel free to do whatever you wish with this software as long as you understand\n" \
                  "it is provided \"as is\" and the author will not be held liable for anything that\n" \
                  "happens in relation with it.\n"
#define ERROR_ARGUMENT_MSG "6502d: error, missing or invalid argument(s)\n"

int main(int argc, char *argv[])
{       
        int i;
        int *p=&i;      /* pointer to i */
        int if_index;   /* index into argv[] pointing to infile name */
        FILE *infile;
        unsigned long start=0;
        long filesize;
        unsigned char opcode;

        /* read arguments. if argc==1 then only the path was recorded */
        if (argc==1)
        {
                printf(USAGE_TEXT);
                return 0;
        }

        /* check for -r */
        if (singlearg(argc, argv, "-v"))
        {
                printf(VERSION_TEXT);
                return 0;
        }
        /* check for -h */
        if (singlearg(argc, argv, "-h"))
        {
                printf(HELP_TEXT);
                return 0;
        }
        /* get -f argument */
        if_index=findarg(argc, argv, "-f");
        if (if_index==0)        /* no -f on command line? */
        {
                printf(ERROR_ARGUMENT_MSG);
                return 1;
        }
        /* get -s argument if it exists */
        if (findarg(argc, argv, "-s")!=0)
                start=strtoul(argv[findarg(argc, argv, "-s")], NULL, 16);
        /* open the files */
        if ((infile=fopen(argv[if_index], "rb"))==NULL)
        {
                printf("6502d: error, could not open \"%s\"\n", argv[if_index]);
                return 1;
        }

        /* get length of file, seek 0 bytes from end */
        fseek(infile, 0, SEEK_END);
        filesize=ftell(infile);
        fseek(infile, start, SEEK_SET);

        /* main loop */
        for (i=start;i!=filesize;i++)
        {
                
                opcode=fgetc(infile);
                /* if last byte then just do a db $XX */
                if (i>=filesize-1-2)
                        printf("%08X:\t%02X\t.DB $%02X\n", i, opcode, opcode);
                else
                        disasm(opcode, p, infile);
        }

        return 0;
}


