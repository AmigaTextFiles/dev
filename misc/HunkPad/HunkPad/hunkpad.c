/* HunkPad version 2
 *
 * Copyright 1986 j w hamilton
 * Permission to copy is granted
 *
 * :ts=8 bk=0 ma=1
 */

#include <stdio.h>

#define HUNK_UNIT       0x3E7L
#define HUNK_NAME       0x3E8L
#define HUNK_CODE       0x3E9L
#define HUNK_DATA       0x3EAL
#define HUNK_BSS        0x3EBL
#define HUNK_RELOC32    0x3ECL
#define HUNK_RELOC16    0x3EDL
#define HUNK_RELOC8     0x3EEL
#define HUNK_EXT        0x3EFL
#define HUNK_SYMBOL     0x3F0L
#define HUNK_DEBUG      0x3F1L
#define HUNK_END        0x3F2L
#define HUNK_HEADER     0x3F3L
#define HUNK_OVERLAY    0x3F5L
#define HUNK_BREAK      0x3F6L

static char *Usage = {
"\
HunkPad version 2, 11 aug 1986  j w hamilton\n\
\n\
Usage: hunkpad <file>...\n\
"
};

main (argc, argv)
        char **argv;
{
        int file;

        if (argc < 2)
                printf(Usage);
        else {
                while (*++argv) {
                        if ((file = open(*argv, 2)) < 0)
                                printf("can't open %s\n", *argv);
                        else {
                                hunkpad(file, *argv);
                                close(file);
                        }
                }
        }
}

static
hunkpad (f, n)
        int f;
        char *n;
{
        long size, pos, mod, mark, count, val;

        /* check the first longword for legal executable prefixes
         * this test should be fancier;  i think only HUNK_UNIT and
         * HUNK_HEADER are valid, but just in case...
         */
        read(f, &val, sizeof (long));
        if (val < HUNK_UNIT || HUNK_BREAK < val)
                printf("%s: not an executable file (beg=0x%lx)\n", n, val);
        else {
                /* get the file size
                 */
                lseek(f, 0L, 2);
                size = lseek(f, 0L, 1);
                /* executables are always multiples of 4
                 */
                if (size & 0x3L)
                        printf("%s: not an executable file (size=%ld corrupted?)\n", n, size);
                else {
                        mod = size & 0x7FL;
                        if (mod) {
                                /* not padded
                                 * make sure it's an executable
                                 */
                                lseek(f, -4L, 2);
                                read(f, &val, sizeof (long));
                                if (val != HUNK_END)
                                        printf("%s: not an executable file (end=0x%lx)\n", n, val);
                                else {
                                        /* add HUNK_ENDs
                                         */
                                        count = (128 - mod) / sizeof(long);
                                        printf("%s: adding %ld HUNK_ENDs\n", n, count);
                                        while (count--)
                                                write(f, &val, sizeof (long));
                                }
                        } else {
                                /* possibly padded
                                 */
                                mark = -1L;
                                pos = size - 128;
                                lseek(f, -128L, 2);
                                while (pos < size) {
                                        read(f, &val, sizeof (long));
                                        if (val == HUNK_END)
                                                mark = pos;
                                        pos += sizeof(long);
                                }
                                if (mark == -1L)
                                        printf("%s: not an executable file (no HUNK_END in last block)\n", n);
                                else {
                                        pos = mark + sizeof (long);
                                        count = (size - pos) / sizeof(long);
                                        if (count == 0)
                                                printf("%s: OK already\n", n);
                                        else {
                                                printf("%s: writing %ld HUNK_ENDs\n", n, count);
                                                lseek(f, (long) (pos - size), 2);
                                                val = HUNK_END;
                                                while (count--)
                                                        write(f, &val, sizeof (long));
                                        }
                                }
                        }
                }
        }
}

