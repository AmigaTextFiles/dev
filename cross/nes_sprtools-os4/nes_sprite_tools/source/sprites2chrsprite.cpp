/*
NES Sprite Tools.
Public domain source code.
by Joey Echeverria
*/

#include <stdio.h>
#include <stdlib.h>
#include "BMPImage.h"

int main(int argc, char **argv)
{
	int i, nbmps;
	BMPImage **bmps;
	BMPImage obmp;
	
	if(argc < 3) {
		fprintf(stderr,
		        " Usage: %s <input1.bmp> [input2.bmp [...]] <output.bmp>\n",
		        argv[0]);
		return 10;
	}
	
	nbmps = argc - 2;
	bmps = (BMPImage **)calloc(sizeof(BMPImage *), nbmps);
	
	for(i = 0; i < nbmps; i++) {
		bmps[i] = new BMPImage(argv[i+1]);
		if(!bmps[i]->IsValid()) {
			fprintf(stderr, "  Could not load image '%s'\n", argv[i+1]);
			return 20;
		}
		if(bmps[i]->GetHeight() != 8) {
			fprintf(stderr, "  Image size must be Nx8. Image '%s' is %ix%i.\n",
			        argv[i+1], bmps[i]->GetWidth(), bmps[i]->GetHeight());
			return 30;
		}
	}
	
	// 128x128 pixels, 16x16 tiles
	obmp.Resize(128, 128);
	
	int tilenum = 0;
	int ntiles;
	int xtile, x, y;
	for(i = 0; i < nbmps; i++) {
		ntiles = bmps[i]->GetWidth() / 8;
		for(xtile = 0; xtile < ntiles; xtile++) {
			for(x = 0; x < 8; x++) {
				for(y = 0; y < 8; y++) {
					Color c = bmps[i]->GetColor(xtile*8 + x, y);
					obmp.SetColor((tilenum%16)*8 + x,(tilenum/16)*8 + y, c);
				}
			}
			tilenum++;
			if(tilenum >= 16*16) {
				fprintf(stderr, "  Too many tiles: %i > %i\n", tilenum, 16*16-1);
				return 40;
			}
		}
	}
	
	if(!obmp.Write(argv[argc-1])) {
		fprintf(stderr, "Could not write file '%s'\n", argv[argc-1]);
		return 50;
	}
	else {
		printf("Wrote '%s' (%ix%i)\n", argv[argc-1], obmp.GetWidth(),
		       obmp.GetHeight());
	}
	
	return 0;
}
