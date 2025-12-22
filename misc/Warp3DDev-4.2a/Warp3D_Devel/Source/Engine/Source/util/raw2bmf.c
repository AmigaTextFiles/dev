#include <stdio.h>

void main(int argc, char **argv)
{
	FILE *f,*g;
	int h,w;
	int p;
	int i,j;
	int a,b;

	if (argc != 5) {
		printf("Usage: %s width height infile outfile\n", argv[0]);
		exit(0L);
	}

	f = fopen(argv[3],"rb");
	if (!f) goto panic;
	g = fopen(argv[4],"wb");
	if (!g) goto panic;
	h=atoi(argv[2]);
	w=atoi(argv[1]);

	fputc(w,g);
	fputc(h,g);

	p = ((w+8)/8);
	p *= h;    // Bytes per glyph (output)
	printf("%d bytes per glyph\n",p);

	for (i=0; i<46; i++) {
		for (j=0; j<p; j++) {
			// Read two bytes from input
			a=fgetc(f);
			b=fgetc(f);
			fputc(a,g);
		}
	}

panic:
	fclose(f);
	fclose(g);
}
