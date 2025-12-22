#include <libraries/dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <io.h>
#include <fcntl.h>
#include <sys/stat.h>

unsigned char buffer[16384];

int main(int argc, char **argv)
{
        int srch, desth, bank, c, color = 8;
        if (argc < 4)
        {
                printf("Usage: sprrip <ramdump file> <banknumber> <destination file> [spritecolor]\n");
                return 1;
        }

        sscanf(argv[2], "%d", &bank);
        bank = 3 - bank;
        bank &= 3;

        if (argc > 4)
        {
          sscanf(argv[4], "%d", &color);
        }

        srch = Open(argv[1], MODE_OLDFILE);
        if (srch == -1)
        {
                printf("Error opening source!\n");
                return 1;
        }

        desth = Open(argv[3], MODE_NEWFILE);
        if (desth == -1)
        {
                Close(srch);
                printf("Error opening source!\n");
                return 1;
        }

        Seek(srch, bank * 16384, SEEK_SET);
        Read(srch, buffer, 16384);
        for (c = 0; c < 255; c++)
        {
                buffer[c*64+63] = color;
        }
        Write(desth, buffer, 16384);
        Close(srch);
        Close(desth);
        return 0;
}
