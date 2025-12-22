/* COMPARE.C */

#include <stdio.h>

/* Define EOF if not truly ANSI */
#ifndef EOF
#define EOF (-1)
#endif

int main(int argc, char **argv)
{
        FILE *file1; FILE *file2;
        unsigned int bufin1, bufin2, bpos=0, fpos=0, i;
        unsigned char buffer[16];
        
        if(argc!=3) {
                fprintf(stderr,"usage: compare <file1> <file2>\n\n");
                printf("compare was called with the wrong number of arguments.\n");
                return(1);
        }

        file1=fopen(argv[1],"rb");
        file2=fopen(argv[2],"rb");

        while(!feof(file1)) {
                bufin1=getc(file1);
                bufin2=getc(file2);

                if(bufin1==EOF && bufin2==EOF) {
                        fprintf(stderr,"compare succeded, A6 was made correctly.\n");
                        return(0);
                }

                if(bufin1==bufin2) {
                        buffer[bpos]=bufin1;
                        bpos=(bpos+1) & 0x0f;
                        fpos++;
                } else {
                        printf("compare failed, A6 not correctly made.\n\n");

                        fpos-=0x10;
                        
                        printf("left: `%s'\nright: `%s'\n\n",argv[1],argv[2]);

                        i=0;

                        while(i<0x10) {
                                if(fpos>-1)
                                        printf("    %5x %4x %4x\n",fpos,buffer[bpos],buffer[bpos]);
                                bpos=(bpos+1) & 0x0f;
                                i++;
                                fpos++;
                        }

                        printf("--> %5x %4x %4x <--\n",fpos++,bufin1,bufin2);

                        bpos=0;

                        while(!feof(file1) && !feof(file2) && bpos<0x10) {
                                bufin1=getc(file1);
                                bufin2=getc(file2);

                                printf("    %5x %4x %4x\n",fpos,bufin1,bufin2);

                                fpos++;
                                bpos++;
                        }

                        return(0);
                }
        }
	return(0);
}
