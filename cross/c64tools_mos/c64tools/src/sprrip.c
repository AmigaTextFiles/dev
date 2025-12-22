#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

unsigned char buffer[16384];

int main(int argc, char **argv)
{
        FILE *srch;
	FILE *desth;
	int bank, c, color = 8;

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

        srch = fopen(argv[1], "rb");
        if (!srch)
        {
                printf("Error opening source!\n");
                return 1;
        }

        desth = fopen(argv[3], "wb");
        if (!desth)
        {
                fclose(srch);
                printf("Error opening source!\n");
                return 1;
        }

        fseek(srch, bank * 16384, SEEK_SET);
        fread(buffer, 16384, 1, srch);
        for (c = 0; c < 255; c++)
        {
                buffer[c*64+63] = color;
        }
        fwrite(buffer, 16384, 1, desth);
        fclose(srch);
        fclose(desth);
        return 0;
}
