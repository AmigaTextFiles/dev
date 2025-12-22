#include <stdio.h>
#include <stdlib.h>

FILE *fd=NULL;

int main(int argc, char **argv) {
    int i=0;

    fd=fopen("ram:Padding.txt","w");

    for (i=0;i<4597684;i++) {
	fprintf(fd,".");
    };

    fclose(fd);
}
